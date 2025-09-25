import 'package:http/http.dart' as http;

class GoogleSheetsService {
  // Your Google Sheets ID
  static const String spreadsheetId = '1gVCjlH1lVb-OzLESEwZPUCbyKdQeuN0hKsyvmTV7-TU';
  
  // Base URL for Google Sheets CSV export
  static const String _baseUrl = 'https://docs.google.com/spreadsheets/d/$spreadsheetId/export?format=csv&gid=';
  
  // Sheet GIDs - these need to match your actual Google Sheets tab GIDs
  // You can find the GID in the URL when you view each sheet tab
  static const Map<String, String> _sheetGids = {
    'Players': '0',           // First sheet (Players)
    'Teams': '1291526164',    // Teams sheet
    'Auction_History': '1603832257',   // Auction_History sheet  
    'Matches': '424738768',           // Matches sheet
    'Live_Updates': '467423031',      // Live_Updates sheet
    'Tournament_Stats': '1466958466',  // Tournament_Stats sheet
    'Tournament_Config': '780447557', // Tournament_Config sheet
  };

  // Debug method to test Google Sheets connection
  Future<void> testConnection() async {
    print('=== Testing Google Sheets Connection ===');
    print('Spreadsheet ID: $spreadsheetId');
    print('Base URL: $_baseUrl');
    
    for (String sheetName in _sheetGids.keys) {
      final gid = _sheetGids[sheetName];
      final url = '$_baseUrl$gid';
      print('---');
      print('Testing $sheetName sheet:');
      print('  GID: $gid');
      print('  URL: $url');
      
      try {
        final response = await http.get(Uri.parse(url));
        print('  Status: ${response.statusCode}');
        
        if (response.statusCode == 200) {
          if (response.body.contains('Sign in') || response.body.contains('authentication')) {
            print('  ERROR: Authentication required - sheet is not public!');
          } else {
            final lines = response.body.split('\n');
            final nonEmptyLines = lines.where((line) => line.trim().isNotEmpty).toList();
            print('  SUCCESS: ${nonEmptyLines.length} rows of data');
            if (nonEmptyLines.isNotEmpty) {
              print('  Header: ${nonEmptyLines[0]}');
            }
            if (nonEmptyLines.length > 1) {
              print('  First data row: ${nonEmptyLines[1]}');
            }
            
            // Special handling for Teams sheet
            if (sheetName == 'Teams') {
              print('  === TEAMS SHEET ANALYSIS ===');
              if (nonEmptyLines.length <= 1) {
                print('  WARNING: Teams sheet has no data rows (only header or empty)');
              } else {
                print('  Teams sheet has ${nonEmptyLines.length - 1} data rows');
                // Show first few data rows
                for (int i = 1; i < nonEmptyLines.length && i <= 3; i++) {
                  print('  Data row ${i}: ${nonEmptyLines[i]}');
                }
              }
            }
          }
        } else {
          print('  ERROR: HTTP ${response.statusCode}');
          print('  Response body: ${response.body.substring(0, response.body.length > 200 ? 200 : response.body.length)}...');
        }
      } catch (e) {
        print('  EXCEPTION: $e');
      }
    }
    print('=== End Connection Test ===');
  }

  // Helper method to test different GIDs for Teams sheet
  Future<void> testTeamsGIDs() async {
    print('=== Testing Different GIDs for Teams Sheet ===');
    
    // Common GID patterns to try
    List<String> possibleGIDs = [
      '1733072859', // Current GID
      '0',          // First sheet
      '1',          // Second sheet  
      '2',          // Third sheet
      '3',          // Fourth sheet
      '4',          // Fifth sheet
      '5',          // Sixth sheet
      '1733072858', // One less
      '1733072860', // One more
    ];
    
    for (String testGID in possibleGIDs) {
      final url = '$_baseUrl$testGID';
      print('---');
      print('Testing GID: $testGID');
      print('URL: $url');
      
      try {
        final response = await http.get(Uri.parse(url));
        print('Status: ${response.statusCode}');
        
        if (response.statusCode == 200) {
          if (response.body.contains('Sign in') || response.body.contains('authentication')) {
            print('ERROR: Authentication required');
          } else {
            final lines = response.body.split('\n');
            final nonEmptyLines = lines.where((line) => line.trim().isNotEmpty).toList();
            print('SUCCESS: ${nonEmptyLines.length} rows');
            
            if (nonEmptyLines.isNotEmpty) {
              final header = nonEmptyLines[0].toLowerCase();
              print('Header: ${nonEmptyLines[0]}');
              
              // Check if this looks like a Teams sheet
              if (header.contains('team') || header.contains('captain') || header.contains('budget')) {
                print('🎯 POTENTIAL TEAMS SHEET FOUND!');
                if (nonEmptyLines.length > 1) {
                  print('Sample data: ${nonEmptyLines[1]}');
                }
              }
            }
          }
        } else {
          print('ERROR: HTTP ${response.statusCode}');
        }
      } catch (e) {
        print('EXCEPTION: $e');
      }
    }
    print('=== End GID Test ===');
  }
  Future<List<List<String>>> readSheetData(String sheetName) async {
    try {
      final gid = _sheetGids[sheetName];
      if (gid == null) {
        print('Unknown sheet name: $sheetName');
        return [];
      }
      
      final url = '$_baseUrl$gid';
      print('Fetching data from: $url'); // Debug log
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        // Check if we got a login page instead of CSV data
        if (response.body.contains('Sign in') || response.body.contains('authentication')) {
          print('ERROR: Google Sheets requires authentication - sheet is not public!');
          print('Please make your Google Sheets public by:');
          print('1. Click Share button');
          print('2. Change to "Anyone with the link" → "Viewer"');
          return [];
        }
        
        // Parse CSV data
        final csvData = response.body;
        final List<List<String>> rows = [];
        
        final lines = csvData.split('\n');
        for (final line in lines) {
          if (line.trim().isEmpty) continue;
          
          // Improved CSV parsing to handle commas within quoted fields
          final row = _parseCsvLine(line);
          rows.add(row);
        }
        
        print('Fetched ${rows.length} rows from $sheetName sheet'); // Debug log
        return rows;
      } else {
        print('Failed to fetch sheet data: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error reading sheet data: $e');
      return [];
    }
  }

  // PLAYERS MANAGEMENT
  Future<List<Map<String, dynamic>>> getPlayers({String? category}) async {
    print('=== getPlayers() called ===');
    try {
      final data = await readSheetData('Players');
      print('Raw data received: ${data.length} rows');
      
      if (data.isEmpty) {
        print('ERROR: No data returned from Google Sheets - sheet might be empty or inaccessible');
        print('Falling back to dummy data');
        return _getDummyPlayers(category: category);
      }
      
      if (data.length <= 1) {
        print('ERROR: Only header row found, no actual player data');
        print('Falling back to dummy data');
        return _getDummyPlayers(category: category);
      }
      
      print('SUCCESS: Found ${data.length - 1} player records in Google Sheets');
      
      // Debug: Print header row to see column structure
      if (data.isNotEmpty) {
        print('Header row: ${data[0]}');
        print('Header columns count: ${data[0].length}');
        for (int i = 0; i < data[0].length; i++) {
          print('Column $i: ${data[0][i]}');
        }
      }
      
      // Skip header row (index 0)
      final rows = data.skip(1).toList();
      
      List<Map<String, dynamic>> players = rows.map((row) {
        // Find photo_url column dynamically or use default position
        String photoUrl = '';
        if (data.isNotEmpty) {
          final headers = data[0];
          int photoUrlIndex = -1;
          
          // Look for photo_url column by name
          for (int i = 0; i < headers.length; i++) {
            final header = headers[i].toLowerCase().trim();
            if (header.contains('photo') && (header.contains('url') || header.contains('id'))) {
              photoUrlIndex = i;
              break;
            }
          }
          
          // If found by name, use that column; otherwise try default position 14
          if (photoUrlIndex != -1 && row.length > photoUrlIndex) {
            photoUrl = row[photoUrlIndex];
          } else if (row.length > 14) {
            photoUrl = row[14];
          }
        }
        
        return <String, dynamic>{
          'player_id': (row.isNotEmpty ? row[0] : '').toString().trim(),
          'name': (row.length > 1 ? row[1] : '').toString().trim(),
          'email': (row.length > 2 ? row[2] : '').toString().trim(),
          'phone': (row.length > 3 ? row[3] : '').toString().trim(),
          'flat_number': (row.length > 4 ? row[4] : '').toString().trim(),
          'category': (row.length > 5 ? row[5] : '').toString().trim(),
          'proficiency': (row.length > 6 ? row[6] : '').toString().trim(),
          'emergency_contact': (row.length > 7 ? row[7] : '').toString().trim(),
          'emergency_phone': (row.length > 8 ? row[8] : '').toString().trim(),
          'registration_date': (row.length > 9 ? row[9] : '').toString().trim(),
          'base_price': row.length > 10 ? (int.tryParse(row[10].toString()) ?? 0) : 0,
          'status': (row.length > 11 ? row[11] : '').toString().trim(),
          'team_id': (row.length > 12 ? row[12] : '').toString().trim(),
          'created_at': (row.length > 13 ? row[13] : '').toString().trim(),
          'photo_url': photoUrl.toString().trim(), // Dynamic photo_url mapping
        };
      }).toList();
      
      // Debug logging for Harish Nayak specifically
      for (var player in players) {
        if (player['name'].toString().toLowerCase().contains('harish')) {
          print('=== GOOGLE SHEETS DEBUG: Harish Data ===');
          print('Full player data: $player');
          print('Photo URL from sheet: ${player['photo_url']}');
          print('Row length: ${rows.firstWhere((row) => row.length > 1 && row[1].toLowerCase().contains('harish'), orElse: () => []).length}');
          break;
        }
      }
      
      if (category != null) {
        players = players.where((player) => 
          player['category'].toString().toLowerCase() == category.toLowerCase()
        ).toList();
      }
      
      print('Returning ${players.length} players from Google Sheets');
      return players;
    } catch (e) {
      print('Error fetching players: $e');
      return _getDummyPlayers(category: category);
    }
  }

  // TEAMS MANAGEMENT
  Future<List<Map<String, dynamic>>> getTeams() async {
    try {
      print('GoogleSheetsService: Starting getTeams()');
      final data = await readSheetData('Teams');
      print('GoogleSheetsService: Raw data length: ${data.length}');
      
      if (data.isEmpty || data.length <= 1) {
        print('GoogleSheetsService: No team data found - data.length = ${data.length}');
        if (data.isNotEmpty) {
          print('GoogleSheetsService: Header row: ${data[0]}');
        }
        return []; // Return empty list to show "Auction Day Awaits" message
      }
      
      // Log the first few rows for debugging
      print('GoogleSheetsService: First 3 rows of raw data:');
      for (int i = 0; i < data.length && i < 3; i++) {
        print('GoogleSheetsService: Row $i: ${data[i]}');
      }
      
      // Skip header row (index 0)
      final rows = data.skip(1).toList();
      print('GoogleSheetsService: Processing ${rows.length} data rows');
      
      List<Map<String, dynamic>> teams = rows.map((row) => <String, dynamic>{
        // Basic team information
        'team_id': (row.isNotEmpty ? row[0] : '').toString().trim(),
        'team_name': (row.length > 1 ? row[1] : '').toString().trim(),
        'captain_id': (row.length > 2 ? row[2] : '').toString().trim(),
        'total_budget': row.length > 3 ? (int.tryParse(row[3].toString()) ?? 0) : 0,
        'spent_budget': row.length > 4 ? (int.tryParse(row[4].toString()) ?? 0) : 0,
        'remaining_budget': row.length > 5 ? (int.tryParse(row[5].toString()) ?? 0) : 0,
        'player_count': row.length > 6 ? (int.tryParse(row[6].toString()) ?? 0) : 0,
        'wins': row.length > 7 ? (int.tryParse(row[7].toString()) ?? 0) : 0,
        'losses': row.length > 8 ? (int.tryParse(row[8].toString()) ?? 0) : 0,
        'points': row.length > 9 ? (int.tryParse(row[9].toString()) ?? 0) : 0,
        'status': (row.length > 10 ? row[10] : '').toString().trim(),
        'created_at': (row.length > 11 ? row[11] : '').toString().trim(),
        
        // Advanced players (columns 12-15)
        'required_number_of_adv': row.length > 12 ? (int.tryParse(row[12].toString()) ?? 0) : 0,
        'number_of_adv_bought': row.length > 13 ? (int.tryParse(row[13].toString()) ?? 0) : 0,
        'base_price_per_adv': row.length > 14 ? (double.tryParse(row[14].toString()) ?? 0.0) : 0.0,
        'total_base_price_adv': row.length > 15 ? (double.tryParse(row[15].toString()) ?? 0.0) : 0.0,
        
        // Intermediate+ players (columns 16-19)
        'required_number_of_int_plus': row.length > 16 ? (int.tryParse(row[16].toString()) ?? 0) : 0,
        'number_of_int_plus_bought': row.length > 17 ? (int.tryParse(row[17].toString()) ?? 0) : 0,
        'base_price_per_int_plus': row.length > 18 ? (double.tryParse(row[18].toString()) ?? 0.0) : 0.0,
        'total_base_price_int_plus': row.length > 19 ? (double.tryParse(row[19].toString()) ?? 0.0) : 0.0,
        
        // Intermediate players (columns 20-23)
        'required_number_of_int': row.length > 20 ? (int.tryParse(row[20].toString()) ?? 0) : 0,
        'number_of_int_bought': row.length > 21 ? (int.tryParse(row[21].toString()) ?? 0) : 0,
        'base_price_per_int': row.length > 22 ? (double.tryParse(row[22].toString()) ?? 0.0) : 0.0,
        'total_base_price_int': row.length > 23 ? (double.tryParse(row[23].toString()) ?? 0.0) : 0.0,
        
        // Beginner players (columns 24-27)
        'required_number_of_beg': row.length > 24 ? (int.tryParse(row[24].toString()) ?? 0) : 0,
        'number_of_beg_bought': row.length > 25 ? (int.tryParse(row[25].toString()) ?? 0) : 0,
        'base_price_per_beg': row.length > 26 ? (double.tryParse(row[26].toString()) ?? 0.0) : 0.0,
        'total_base_price_beg': row.length > 27 ? (double.tryParse(row[27].toString()) ?? 0.0) : 0.0,
        
        // Total base pool (column 28)
        'total_base_pool': row.length > 28 ? (double.tryParse(row[28].toString()) ?? 0.0) : 0.0,
      }).toList();
      
      // Filter out empty teams (where team_id is empty)
      teams = teams.where((team) => team['team_id'].toString().trim().isNotEmpty).toList();
      
      print('GoogleSheetsService: Final teams count after filtering: ${teams.length}');
      for (int i = 0; i < teams.length && i < 3; i++) {
        print('GoogleSheetsService: Team ${i + 1}: ${teams[i]}');
      }
      
      return teams;
    } catch (e) {
      print('GoogleSheetsService: Error fetching teams: $e');
      print('GoogleSheetsService: Stack trace: ${StackTrace.current}');
      return []; // Return empty list to show "Auction Day Awaits" message
    }
  }

  // MATCHES MANAGEMENT
  Future<List<Map<String, dynamic>>> getMatches({String? status}) async {
    try {
      final data = await readSheetData('Matches');
      if (data.isEmpty || data.length <= 1) {
        print('No match data found in Google Sheets, using dummy data');
        return _getDummyMatches(status: status);
      }
      
      // Skip header row (index 0)
      final rows = data.skip(1).toList();
      
      List<Map<String, dynamic>> matches = rows.map((row) => <String, dynamic>{
        'match_id': (row.isNotEmpty ? row[0] : '').toString().trim(),
        'match_type': (row.length > 1 ? row[1] : '').toString().trim(),
        'team1_id': (row.length > 2 ? row[2] : '').toString().trim(),
        'team2_id': (row.length > 3 ? row[3] : '').toString().trim(),
        'scheduled_date': (row.length > 4 ? row[4] : '').toString().trim(),
        'scheduled_time': (row.length > 5 ? row[5] : '').toString().trim(),
        'venue': (row.length > 6 ? row[6] : '').toString().trim(),
        'status': (row.length > 7 ? row[7] : '').toString().trim(),
        'team1_score': row.length > 8 ? (int.tryParse(row[8].toString()) ?? 0) : 0,
        'team2_score': row.length > 9 ? (int.tryParse(row[9].toString()) ?? 0) : 0,
        'winner_team_id': (row.length > 10 ? row[10] : '').toString().trim(),
        'match_duration': (row.length > 11 ? row[11] : '').toString().trim(),
        'referee': (row.length > 12 ? row[12] : '').toString().trim(),
        'round_number': row.length > 13 ? (int.tryParse(row[13].toString()) ?? 0) : 0,
        'group_name': (row.length > 14 ? row[14] : '').toString().trim(),
        'notes': (row.length > 15 ? row[15] : '').toString().trim(),
        'created_at': (row.length > 16 ? row[16] : '').toString().trim(),
      }).toList();
      
      if (status != null) {
        matches = matches.where((match) => 
          match['status'].toString().toLowerCase() == status.toLowerCase()
        ).toList();
      }
      
      print('Returning ${matches.length} matches from Google Sheets');
      return matches;
    } catch (e) {
      print('Error fetching matches: $e');
      return _getDummyMatches(status: status);
    }
  }

  // TOURNAMENT CONFIG
  Future<Map<String, dynamic>> getTournamentConfig() async {
    try {
      final data = await readSheetData('Tournament_Config');
      if (data.isEmpty || data.length <= 1) {
        print('No config data found in Google Sheets, using dummy data');
        return _getDummyTournamentConfig();
      }
      
      Map<String, dynamic> config = {};
      
      // Skip header row and parse config
      final rows = data.skip(1).toList();
      for (final row in rows) {
        if (row.length >= 2) {
          config[row[0]] = row[1];
        }
      }
      
      print('Returning config from Google Sheets: ${config.keys.length} entries');
      return config;
    } catch (e) {
      print('Error fetching tournament config: $e');
      return _getDummyTournamentConfig();
    }
  }

  // DUMMY DATA METHODS FOR TESTING
  List<Map<String, dynamic>> _getDummyPlayers({String? category}) {
    List<Map<String, dynamic>> allPlayers = [
      {
        'player_id': 'P001',
        'name': 'Rajesh Kumar',
        'email': 'rajesh@email.com',
        'phone': '+91-9876543210',
        'flat_number': '4B',
        'category': 'Men',
        'proficiency': 'Advanced',
        'emergency_contact': 'Sunita Kumar',
        'emergency_phone': '+91-9876543211',
        'registration_date': '2025-09-15',
        'base_price': 5000,
        'status': 'Active',
        'team_id': 'T001',
        'created_at': '2025-09-15 10:30:00',
        'photo_url': '', // No photo for dummy data
      },
      {
        'player_id': 'P002',
        'name': 'Priya Sharma',
        'email': 'priya@email.com',
        'phone': '+91-9876543212',
        'flat_number': '7A',
        'category': 'Women',
        'proficiency': 'Intermediate+',
        'emergency_contact': 'Amit Sharma',
        'emergency_phone': '+91-9876543213',
        'registration_date': '2025-09-15',
        'base_price': 4000,
        'status': 'Active',
        'team_id': 'T002',
        'created_at': '2025-09-15 11:00:00',
        'photo_url': '', // No photo for dummy data
      },
      {
        'player_id': 'P003',
        'name': 'Arjun Patel',
        'email': 'arjun@email.com',
        'phone': '+91-9876543214',
        'flat_number': '2C',
        'category': 'Kids',
        'proficiency': 'Beginner',
        'emergency_contact': 'Kavita Patel',
        'emergency_phone': '+91-9876543215',
        'registration_date': '2025-09-16',
        'base_price': 2000,
        'status': 'Active',
        'team_id': '',
        'created_at': '2025-09-16 09:00:00',
        'photo_url': '', // No photo for dummy data
      },
      {
        'player_id': 'P004',
        'name': 'Deepika Rao',
        'email': 'deepika@email.com',
        'phone': '+91-9876543216',
        'flat_number': '5D',
        'category': 'Women',
        'proficiency': 'Intermediate',
        'emergency_contact': 'Suresh Rao',
        'emergency_phone': '+91-9876543217',
        'registration_date': '2025-09-16',
        'base_price': 5500,
        'status': 'Active',
        'team_id': 'T001',
        'created_at': '2025-09-16 14:30:00',
        'photo_url': '', // No photo for dummy data
      },
    ];

    if (category != null) {
      return allPlayers.where((player) => 
        player['category'].toString().toLowerCase() == category.toLowerCase()
      ).toList();
    }
    
    return allPlayers;
  }

  List<Map<String, dynamic>> _getDummyMatches({String? status}) {
    // Return empty list to show "Battle yet to Start" message
    // When real data is available in Google Sheets, this method won't be called
    print('Returning empty matches list - Battle yet to Start');
    return [];
  }

  // AUCTION HISTORY MANAGEMENT
  Future<List<Map<String, dynamic>>> getAuctionHistory() async {
    try {
      print('GoogleSheetsService: Starting getAuctionHistory()');
      final data = await readSheetData('Auction_History');
      print('GoogleSheetsService: Auction history raw data length: ${data.length}');
      
      if (data.isEmpty || data.length <= 1) {
        print('GoogleSheetsService: No auction history data found');
        return [];
      }
      
      // Skip header row (index 0)
      final rows = data.skip(1).toList();
      print('GoogleSheetsService: Processing ${rows.length} auction history rows');
      
      List<Map<String, dynamic>> auctionHistory = rows.map((row) => <String, dynamic>{
        'auction_id': (row.isNotEmpty ? row[0] : '').toString().trim(),
        'player_id': (row.length > 1 ? row[1] : '').toString().trim(),
        'team_id': (row.length > 2 ? row[2] : '').toString().trim(),
        'initial_bid_amount': row.length > 3 ? (int.tryParse(row[3].toString()) ?? 0) : 0, // New column
        'bid_amount': row.length > 4 ? (int.tryParse(row[4].toString()) ?? 0) : 0, // Shifted by 1
        'bid_type': (row.length > 5 ? row[5] : '').toString().trim(), // Shifted by 1
        'is_winning_bid': row.length > 6 ? (row[6].toString().toLowerCase() == 'true' || row[6].toString() == '1') : false, // Shifted by 1
        'auction_round': row.length > 7 ? (int.tryParse(row[7].toString()) ?? 1) : 1, // Shifted by 1
        'bid_timestamp': (row.length > 8 ? row[8] : '').toString().trim(), // Shifted by 1
        'auctioneer_notes': (row.length > 9 ? row[9] : '').toString().trim(), // Shifted by 1
      }).toList();
      
      // Filter out empty entries
      auctionHistory = auctionHistory.where((entry) => 
        entry['auction_id'].toString().trim().isNotEmpty
      ).toList();
      
      print('GoogleSheetsService: Final auction history count: ${auctionHistory.length}');
      return auctionHistory;
    } catch (e) {
      print('GoogleSheetsService: Error fetching auction history: $e');
      return [];
    }
  }

  // Get players not yet sold (for auction queue)
  Future<List<Map<String, dynamic>>> getUnsoldPlayers() async {
    try {
      print('GoogleSheetsService: Getting unsold players...');
      
      // Get all players
      final allPlayers = await getPlayers();
      print('GoogleSheetsService: Total players: ${allPlayers.length}');
      
      // Get auction history to find sold players
      final auctionHistory = await getAuctionHistory();
      print('GoogleSheetsService: Auction history entries: ${auctionHistory.length}');
      
      // Get player IDs that have winning bids
      final soldPlayerIds = auctionHistory
          .where((entry) => entry['is_winning_bid'] == true)
          .map((entry) => entry['player_id'].toString())
          .toSet();
      
      print('GoogleSheetsService: Sold player IDs: $soldPlayerIds');
      
      // Filter out sold players
      final unsoldPlayers = allPlayers.where((player) => 
        !soldPlayerIds.contains(player['player_id'].toString())
      ).toList();
      
      print('GoogleSheetsService: Unsold players: ${unsoldPlayers.length}');
      return unsoldPlayers;
    } catch (e) {
      print('GoogleSheetsService: Error getting unsold players: $e');
      return [];
    }
  }

  // Calculate auction statistics
  Future<Map<String, dynamic>> getAuctionStats() async {
    try {
      print('GoogleSheetsService: Calculating auction stats...');
      
      final allPlayers = await getPlayers();
      final auctionHistory = await getAuctionHistory();
      final teams = await getTeams();
      
      // Calculate statistics
      final totalPlayers = allPlayers.length;
      final soldPlayers = auctionHistory
          .where((entry) => entry['is_winning_bid'] == true)
          .map((entry) => entry['player_id'])
          .toSet()
          .length;
      
      final winningBids = auctionHistory
          .where((entry) => entry['is_winning_bid'] == true)
          .map((entry) => entry['bid_amount'] as int)
          .toList();
      
      final totalRevenue = winningBids.fold<int>(0, (sum, amount) => sum + amount);
      final avgPrice = winningBids.isNotEmpty ? (totalRevenue / winningBids.length).round() : 0;
      final highestBid = winningBids.isNotEmpty ? winningBids.reduce((a, b) => a > b ? a : b) : 0;
      
      final stats = {
        'total_players': totalPlayers,
        'players_sold': soldPlayers,
        'avg_price': avgPrice,
        'teams_formed': teams.length,
        'highest_bid': highestBid,
        'total_revenue': totalRevenue,
      };
      
      print('GoogleSheetsService: Auction stats: $stats');
      return stats;
    } catch (e) {
      print('GoogleSheetsService: Error calculating auction stats: $e');
      return {
        'total_players': 0,
        'players_sold': 0,
        'avg_price': 0,
        'teams_formed': 0,
        'highest_bid': 0,
        'total_revenue': 0,
      };
    }
  }

  Map<String, dynamic> _getDummyTournamentConfig() {
    return {
      'tournament_name': 'DE Karnataka Rajyotsava Badminton Tournament',
      'tournament_date': '2025-11-01',
      'venue': 'DE Community Center',
      'max_teams': '8',
      'max_players_per_team': '8',
      'entry_fee': '1000',
      'registration_deadline': '2025-10-25',
      'contact_email': 'tournament@dekarnataka.com',
      'contact_phone': '+91-9876543200',
      'tournament_status': 'Registration Open',
    };
  }

  // Helper method to parse CSV line properly (handles commas within quotes)
  List<String> _parseCsvLine(String line) {
    List<String> result = [];
    bool inQuotes = false;
    String current = '';
    
    for (int i = 0; i < line.length; i++) {
      String char = line[i];
      
      if (char == '"') {
        inQuotes = !inQuotes;
      } else if (char == ',' && !inQuotes) {
        result.add(current.trim());
        current = '';
      } else {
        current += char;
      }
    }
    
    // Add the last field
    result.add(current.trim());
    
    return result;
  }
}