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
    'Teams': '1733072859',    // Teams sheet
    'Auction_History': '2',   // Auction_History sheet  
    'Matches': '3',           // Matches sheet
    'Live_Updates': '4',      // Live_Updates sheet
    'Tournament_Stats': '5',  // Tournament_Stats sheet
    'Tournament_Config': '6', // Tournament_Config sheet
  };

  // Debug method to test Google Sheets connection
  Future<void> testConnection() async {
    print('=== Testing Google Sheets Connection ===');
    print('Spreadsheet ID: $spreadsheetId');
    
    for (String sheetName in _sheetGids.keys) {
      final gid = _sheetGids[sheetName];
      final url = '$_baseUrl$gid';
      print('Testing $sheetName sheet - URL: $url');
      
      try {
        final response = await http.get(Uri.parse(url));
        print('$sheetName - Status: ${response.statusCode}');
        if (response.statusCode == 200) {
          final lines = response.body.split('\n').where((line) => line.trim().isNotEmpty).toList();
          print('$sheetName - Data rows: ${lines.length}');
          if (lines.isNotEmpty) {
            print('$sheetName - Header row: ${lines[0]}');
            // Look for Harish Nayak in Players sheet
            if (sheetName == 'Players' && lines.length > 1) {
              for (int i = 1; i < lines.length; i++) {
                if (lines[i].toLowerCase().contains('harish')) {
                  print('Found Harish row: ${lines[i]}');
                  final columns = _parseCsvLine(lines[i]);
                  print('Harish columns count: ${columns.length}');
                  for (int j = 0; j < columns.length; j++) {
                    print('Column $j: ${columns[j]}');
                  }
                  break;
                }
              }
            }
          }
        } else {
          print('$sheetName - Error: ${response.statusCode} - ${response.body}');
        }
      } catch (e) {
        print('$sheetName - Exception: $e');
      }
      print('---');
    }
    print('=== End Test ===');
  }

  // Generic method to read sheet data as CSV
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
        
        return {
          'player_id': row.isNotEmpty ? row[0] : '',
          'name': row.length > 1 ? row[1] : '',
          'email': row.length > 2 ? row[2] : '',
          'phone': row.length > 3 ? row[3] : '',
          'flat_number': row.length > 4 ? row[4] : '',
          'category': row.length > 5 ? row[5] : '',
          'proficiency': row.length > 6 ? row[6] : '',
          'emergency_contact': row.length > 7 ? row[7] : '',
          'emergency_phone': row.length > 8 ? row[8] : '',
          'registration_date': row.length > 9 ? row[9] : '',
          'base_price': row.length > 10 ? int.tryParse(row[10]) ?? 0 : 0,
          'status': row.length > 11 ? row[11] : '',
          'team_id': row.length > 12 ? row[12] : '',
          'created_at': row.length > 13 ? row[13] : '',
          'photo_url': photoUrl, // Dynamic photo_url mapping
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
      final data = await readSheetData('Teams');
      if (data.isEmpty || data.length <= 1) {
        print('No team data found in Google Sheets, returning empty list');
        return []; // Return empty list to show "Auction Day Awaits" message
      }
      
      // Skip header row (index 0)
      final rows = data.skip(1).toList();
      
      List<Map<String, dynamic>> teams = rows.map((row) => {
        'team_id': row.isNotEmpty ? row[0] : '',
        'team_name': row.length > 1 ? row[1] : '',
        'captain_id': row.length > 2 ? row[2] : '',
        'total_budget': row.length > 3 ? int.tryParse(row[3]) ?? 0 : 0,
        'spent_budget': row.length > 4 ? int.tryParse(row[4]) ?? 0 : 0,
        'remaining_budget': row.length > 5 ? int.tryParse(row[5]) ?? 0 : 0,
        'player_count': row.length > 6 ? int.tryParse(row[6]) ?? 0 : 0,
        'wins': row.length > 7 ? int.tryParse(row[7]) ?? 0 : 0,
        'losses': row.length > 8 ? int.tryParse(row[8]) ?? 0 : 0,
        'points': row.length > 9 ? int.tryParse(row[9]) ?? 0 : 0,
        'status': row.length > 10 ? row[10] : '',
        'created_at': row.length > 11 ? row[11] : '',
      }).toList();
      
      print('Returning ${teams.length} teams from Google Sheets');
      return teams;
    } catch (e) {
      print('Error fetching teams: $e');
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
      
      List<Map<String, dynamic>> matches = rows.map((row) => {
        'match_id': row.isNotEmpty ? row[0] : '',
        'match_type': row.length > 1 ? row[1] : '',
        'team1_id': row.length > 2 ? row[2] : '',
        'team2_id': row.length > 3 ? row[3] : '',
        'scheduled_date': row.length > 4 ? row[4] : '',
        'scheduled_time': row.length > 5 ? row[5] : '',
        'venue': row.length > 6 ? row[6] : '',
        'status': row.length > 7 ? row[7] : '',
        'team1_score': row.length > 8 ? int.tryParse(row[8]) ?? 0 : 0,
        'team2_score': row.length > 9 ? int.tryParse(row[9]) ?? 0 : 0,
        'winner_team_id': row.length > 10 ? row[10] : '',
        'match_duration': row.length > 11 ? row[11] : '',
        'referee': row.length > 12 ? row[12] : '',
        'round_number': row.length > 13 ? int.tryParse(row[13]) ?? 0 : 0,
        'group_name': row.length > 14 ? row[14] : '',
        'notes': row.length > 15 ? row[15] : '',
        'created_at': row.length > 16 ? row[16] : '',
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