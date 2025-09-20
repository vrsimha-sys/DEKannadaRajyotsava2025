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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Test Google Sheets connection
    _testGoogleSheetsConnection();
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
                  future: _getMenPlayers(),
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
                  future: _getWomenPlayers(),
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
                  future: _getKidsPlayers(),
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
      return players.where((player) => 
        player['category']?.toString().toLowerCase() == 'men' ||
        player['category']?.toString().toLowerCase() == 'male'
      ).toList();
    } catch (e) {
      print('Error loading men players: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> _getWomenPlayers() async {
    try {
      final players = await _googleSheetsService.getPlayers();
      return players.where((player) => 
        player['category']?.toString().toLowerCase() == 'women' ||
        player['category']?.toString().toLowerCase() == 'female'
      ).toList();
    } catch (e) {
      print('Error loading women players: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> _getKidsPlayers() async {
    try {
      final players = await _googleSheetsService.getPlayers();
      return players.where((player) => 
        player['category']?.toString().toLowerCase() == 'kids' ||
        player['category']?.toString().toLowerCase() == 'children'
      ).toList();
    } catch (e) {
      print('Error loading kids players: $e');
      return [];
    }
  }
}