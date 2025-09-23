import 'package:flutter/material.dart';
import '../services/google_sheets_service.dart';
import '../widgets/proficiency_player_view.dart';

class PlayerRosterPage extends StatefulWidget {
  const PlayerRosterPage({super.key});

  @override
  State<PlayerRosterPage> createState() => _PlayerRosterPageState();
}

class _PlayerRosterPageState extends State<PlayerRosterPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GoogleSheetsService _googleSheetsService = GoogleSheetsService();
  
  // Future variables to enable refresh functionality
  late Future<List<Map<String, dynamic>>> _menPlayersFuture;
  late Future<List<Map<String, dynamic>>> _womenPlayersFuture;
  late Future<List<Map<String, dynamic>>> _kidsPlayersFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Initialize futures
    _initializeFutures();
    // Test Google Sheets connection
    _testGoogleSheetsConnection();
  }

  void _initializeFutures() {
    _menPlayersFuture = _getMenPlayers();
    _womenPlayersFuture = _getWomenPlayers();
    _kidsPlayersFuture = _getKidsPlayers();
  }

  void _refreshAllData() {
    setState(() {
      // Create new Future instances to force refresh
      _initializeFutures();
    });
  }

  void _testGoogleSheetsConnection() async {
    print('=== Testing Google Sheets from Player Roster Page ===');
    await _googleSheetsService.testConnection();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // Header Section
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(isDesktop ? 40 : 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(255, 247, 183, 7),
                  Color.fromARGB(255, 220, 20, 20),
                ],
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isDesktop) ...[
                      Image.asset(
                        'assets/images/badminton_logo_left.png',
                        height: 80,
                        errorBuilder: (context, error, stackTrace) =>
                            const SizedBox.shrink(),
                      ),
                      const SizedBox(width: 20),
                    ],
                    Expanded(
                      child: Column(
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'Player Roster',
                              style: TextStyle(
                                fontSize: isDesktop ? 36 : 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 8),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'Registered Participants',
                              style: TextStyle(
                                fontSize: isDesktop ? 18 : 16,
                                color: Colors.white.withOpacity(0.9),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Refresh button positioned under "Registered Participants"
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: IconButton(
                              onPressed: _refreshAllData,
                              icon: const Icon(
                                Icons.refresh,
                                color: Colors.white,
                                size: 24,
                              ),
                              tooltip: 'Refresh Player Data',
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isDesktop) ...[
                      const SizedBox(width: 20),
                      Image.asset(
                        'assets/images/badminton_logo_right.png',
                        height: 80,
                        errorBuilder: (context, error, stackTrace) =>
                            const SizedBox.shrink(),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // Tab Bar
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(child: FittedBox(fit: BoxFit.scaleDown, child: Text('Men'))),
                Tab(child: FittedBox(fit: BoxFit.scaleDown, child: Text('Women'))),
                Tab(child: FittedBox(fit: BoxFit.scaleDown, child: Text('Kids'))),
              ],
              labelColor: const Color.fromARGB(255, 220, 20, 20),
              unselectedLabelColor: Colors.grey,
              indicatorColor: const Color.fromARGB(255, 220, 20, 20),
              labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              unselectedLabelStyle: const TextStyle(fontSize: 14),
            ),
          ),

          // Tabs Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: _menPlayersFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error loading men players: ${snapshot.error}'),
                      );
                    } else {
                      final players = snapshot.data ?? [];
                      return ProficiencyPlayerView(
                        players: players,
                        category: 'Men',
                      );
                    }
                  },
                ),
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: _womenPlayersFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error loading women players: ${snapshot.error}'),
                      );
                    } else {
                      final players = snapshot.data ?? [];
                      return ProficiencyPlayerView(
                        players: players,
                        category: 'Women',
                      );
                    }
                  },
                ),
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: _kidsPlayersFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error loading kids players: ${snapshot.error}'),
                      );
                    } else {
                      final players = snapshot.data ?? [];
                      return ProficiencyPlayerView(
                        players: players,
                        category: 'Kids',
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Google Sheets data methods - replace hardcoded data with real data
  Future<List<Map<String, dynamic>>> _getMenPlayers() async {
    try {
      final players = await _googleSheetsService.getPlayers();
      final menPlayers = players.where((player) => 
        player['category']?.toString().toLowerCase() == 'men' ||
        player['category']?.toString().toLowerCase() == 'male'
      ).toList();
      
      // Enrich player data with selling price and team name
      return await _enrichPlayerData(menPlayers);
    } catch (e) {
      print('Error loading men players: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> _getWomenPlayers() async {
    try {
      final players = await _googleSheetsService.getPlayers();
      final womenPlayers = players.where((player) => 
        player['category']?.toString().toLowerCase() == 'women' ||
        player['category']?.toString().toLowerCase() == 'female'
      ).toList();
      
      // Enrich player data with selling price and team name
      return await _enrichPlayerData(womenPlayers);
    } catch (e) {
      print('Error loading women players: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> _getKidsPlayers() async {
    try {
      final players = await _googleSheetsService.getPlayers();
      final kidsPlayers = players.where((player) => 
        player['category']?.toString().toLowerCase() == 'kids' ||
        player['category']?.toString().toLowerCase() == 'children'
      ).toList();
      
      // Enrich player data with selling price and team name
      return await _enrichPlayerData(kidsPlayers);
    } catch (e) {
      print('Error loading kids players: $e');
      return [];
    }
  }

  // Helper method to enrich player data with selling price and team name
  Future<List<Map<String, dynamic>>> _enrichPlayerData(List<Map<String, dynamic>> players) async {
    try {
      // Get auction history and teams data
      final auctionHistory = await _googleSheetsService.getAuctionHistory();
      final teams = await _googleSheetsService.getTeams();
      
      // Create maps for quick lookup
      final Map<String, int> playerSellingPrices = {};
      final Map<String, String> teamNames = {};
      
      // Build selling price map from auction history (winning bids only)
      for (var bid in auctionHistory) {
        if (bid['is_winning_bid'] == true) {
          final playerId = bid['player_id']?.toString() ?? '';
          final bidAmount = bid['bid_amount'] ?? 0;
          if (playerId.isNotEmpty) {
            playerSellingPrices[playerId] = bidAmount;
          }
        }
      }
      
      // Build team names map
      for (var team in teams) {
        final teamId = team['team_id']?.toString() ?? '';
        final teamName = team['team_name']?.toString() ?? '';
        if (teamId.isNotEmpty) {
          teamNames[teamId] = teamName;
        }
      }
      
      // Enrich each player with selling price and team name
      return players.map((player) {
        final playerId = player['player_id']?.toString() ?? '';
        final teamId = player['team_id']?.toString() ?? '';
        
        return {
          ...player,
          'selling_price': playerSellingPrices[playerId],
          'team_name': teamNames[teamId],
        };
      }).toList();
      
    } catch (e) {
      print('Error enriching player data: $e');
      // Return original players if enrichment fails
      return players;
    }
  }
}