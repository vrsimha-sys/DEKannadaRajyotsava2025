import 'package:flutter/material.dart';
import '../services/google_sheets_service.dart';

class BattleDayPage extends StatefulWidget {
  const BattleDayPage({super.key});

  @override
  State<BattleDayPage> createState() => _BattleDayPageState();
}

class _BattleDayPageState extends State<BattleDayPage>
    with TickerProviderStateMixin {
  late TabController _mainTabController;
  late TabController _fixturesTabController;
  late TabController _standingsTabController;
  late AnimationController _fadeAnimationController;
  late AnimationController _scaleAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  final GoogleSheetsService _googleSheetsService = GoogleSheetsService();

  @override
  void initState() {
    super.initState();
    _mainTabController = TabController(length: 2, vsync: this); // Fixtures and Standings
    _fixturesTabController = TabController(length: 3, vsync: this); // Men, Women, Kids
    _standingsTabController = TabController(length: 3, vsync: this); // Men, Women, Kids
    
    // Initialize animations for "Battle yet to Start" widget
    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _scaleAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeAnimationController, curve: Curves.easeInOut),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleAnimationController, curve: Curves.elasticOut),
    );
    
    // Start animations
    _fadeAnimationController.forward();
    _scaleAnimationController.forward();
  }

  @override
  void dispose() {
    _mainTabController.dispose();
    _fixturesTabController.dispose();
    _standingsTabController.dispose();
    _fadeAnimationController.dispose();
    _scaleAnimationController.dispose();
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Battle Day',
                      style: TextStyle(
                        fontSize: isDesktop ? 32 : 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tournament Fixtures & Standings',
                      style: TextStyle(
                        fontSize: isDesktop ? 16 : 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Sunday, 09 Nov, 2025',
                      style: TextStyle(
                        fontSize: isDesktop ? 14 : 12,
                        color: Colors.white.withOpacity(0.8),
                        fontWeight: FontWeight.w300,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Content Area - Conditional based on data availability
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _googleSheetsService.getMatches(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color.fromARGB(255, 220, 20, 20),
                    ),
                  );
                }
                
                // Debug logging
                print('BattleDayPage: snapshot.hasData = ${snapshot.hasData}');
                print('BattleDayPage: snapshot.data = ${snapshot.data}');
                if (snapshot.hasError) {
                  print('BattleDayPage: snapshot.error = ${snapshot.error}');
                }
                
                // Check if there is data available
                bool hasData = snapshot.hasData && snapshot.data!.isNotEmpty;
                
                if (!hasData) {
                  // Show only "Battle yet to Start" widget when no data
                  return Center(
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.sports_tennis,
                              size: 80,
                              color: const Color.fromARGB(255, 220, 20, 20).withOpacity(0.6),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              '⚔️ Battle yet to Start! ⚔️',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 220, 20, 20),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Tournament battles are being prepared.\nCome back soon to witness the epic matches!',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 32),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color.fromARGB(255, 220, 20, 20).withOpacity(0.3),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.schedule,
                                    color: const Color.fromARGB(255, 220, 20, 20),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Prepare for the ultimate showdown!',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromARGB(255, 220, 20, 20),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                
                // Show tabs and content when data is available
                return Column(
                  children: [
                    // Main Tab Bar (Fixtures and Standings)
                    Container(
                      color: Colors.white,
                      child: TabBar(
                        controller: _mainTabController,
                        tabs: const [
                          Tab(icon: Icon(Icons.schedule), text: 'Fixtures'),
                          Tab(icon: Icon(Icons.leaderboard), text: 'Standings'),
                        ],
                        labelColor: const Color.fromARGB(255, 220, 20, 20),
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: const Color.fromARGB(255, 220, 20, 20),
                      ),
                    ),
                    
                    // Tab Content
                    Expanded(
                      child: TabBarView(
                        controller: _mainTabController,
                        children: [
                          _buildFixturesSection(),
                          _buildStandingsSection(),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FutureBuilder<List<Map<String, dynamic>>>(
        future: _googleSheetsService.getMatches(),
        builder: (context, snapshot) {
          // Only show refresh button when there is data
          bool hasData = snapshot.hasData && snapshot.data!.isNotEmpty;
          if (!hasData) {
            return const SizedBox.shrink(); // Hide the button when no data
          }
          
          return FloatingActionButton.extended(
            onPressed: _refreshData,
            backgroundColor: const Color.fromARGB(255, 220, 20, 20),
            icon: const Icon(Icons.refresh, color: Colors.white),
            label: const Text('Refresh', style: TextStyle(color: Colors.white)),
          );
        },
      ),
    );
  }

  void _refreshData() {
    setState(() {
      // This will trigger a rebuild and refresh the data
    });
  }

  // Build Fixtures Section with Category Tabs
  Widget _buildFixturesSection() {
    return Column(
      children: [
        // Category Tab Bar for Fixtures
        Container(
          color: Colors.grey[50],
          child: TabBar(
            controller: _fixturesTabController,
            tabs: const [
              Tab(text: 'Men'),
              Tab(text: 'Women'),
              Tab(text: 'Kids'),
            ],
            labelColor: const Color.fromARGB(255, 220, 20, 20),
            unselectedLabelColor: Colors.grey,
            indicatorColor: const Color.fromARGB(255, 220, 20, 20),
          ),
        ),
        
        // Category Tab Content for Fixtures
        Expanded(
          child: TabBarView(
            controller: _fixturesTabController,
            children: [
              _buildFixturesTable('Men'),
              _buildFixturesTable('Women'),
              _buildFixturesTable('Kids'),
            ],
          ),
        ),
      ],
    );
  }

  // Build Standings Section with Category Tabs  
  Widget _buildStandingsSection() {
    return Column(
      children: [
        // Category Tab Bar for Standings
        Container(
          color: Colors.grey[50],
          child: TabBar(
            controller: _standingsTabController,
            tabs: const [
              Tab(text: 'Men'),
              Tab(text: 'Women'), 
              Tab(text: 'Kids'),
            ],
            labelColor: const Color.fromARGB(255, 220, 20, 20),
            unselectedLabelColor: Colors.grey,
            indicatorColor: const Color.fromARGB(255, 220, 20, 20),
          ),
        ),
        
        // Category Tab Content for Standings
        Expanded(
          child: TabBarView(
            controller: _standingsTabController,
            children: [
              _buildStandingsTable('Men'),
              _buildStandingsTable('Women'),
              _buildStandingsTable('Kids'),
            ],
          ),
        ),
      ],
    );
  }

  // Build Fixtures Table for specific category
  Widget _buildFixturesTable(String category) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _googleSheetsService.getMatchesByCategory(category: category),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color.fromARGB(255, 220, 20, 20),
            ),
          );
        }
        
        // Debug logging
        print('FixturesTable ($category): snapshot.hasData = ${snapshot.hasData}');
        print('FixturesTable ($category): snapshot.data = ${snapshot.data}');
        if (snapshot.hasError) {
          print('FixturesTable ($category): snapshot.error = ${snapshot.error}');
        }
        
        final fixtures = snapshot.data ?? [];
        
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: fixtures.isEmpty
              ? Center(
                  child: Text(
                    'No $category fixtures scheduled yet',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                )
              : LayoutBuilder(
                  builder: (context, constraints) {
                    final isSmallScreen = constraints.maxWidth < 600;
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: isSmallScreen ? 1000 : constraints.maxWidth,
                        ),
                        child: DataTable(
                          headingRowColor: MaterialStateProperty.all(
                            const Color.fromARGB(255, 220, 20, 20).withOpacity(0.1),
                          ),
                          columnSpacing: isSmallScreen ? 12 : 24,
                          dataRowMinHeight: isSmallScreen ? 40 : 48,
                          dataRowMaxHeight: isSmallScreen ? 50 : 56,
                          columns: [
                            DataColumn(
                              label: SizedBox(
                                width: isSmallScreen ? 60 : 80,
                                child: const Text('Time', 
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: isSmallScreen ? 60 : 80,
                                child: const Text('Court', 
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: isSmallScreen ? 100 : 120,
                                child: const Text('Pair 1', 
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: isSmallScreen ? 100 : 120,
                                child: const Text('Pair 2', 
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: isSmallScreen ? 80 : 100,
                                child: const Text('Team 1', 
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: isSmallScreen ? 80 : 100,
                                child: const Text('Team 2', 
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: isSmallScreen ? 80 : 100,
                                child: const Text('Status', 
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: isSmallScreen ? 50 : 70,
                                child: const Text('T1 Score', 
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: isSmallScreen ? 50 : 70,
                                child: const Text('T2 Score', 
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: isSmallScreen ? 80 : 100,
                                child: const Text('Winner', 
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                ),
                              ),
                            ),
                          ],
                          rows: fixtures.map((fixture) {
                            return DataRow(
                              cells: [
                                DataCell(
                                  SizedBox(
                                    width: isSmallScreen ? 60 : 80,
                                    child: Text(
                                      fixture['scheduled_time'] ?? '',
                                      style: TextStyle(fontSize: isSmallScreen ? 10 : 12),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  SizedBox(
                                    width: isSmallScreen ? 60 : 80,
                                    child: Text(
                                      fixture['venue'] ?? '',
                                      style: TextStyle(fontSize: isSmallScreen ? 10 : 12),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  SizedBox(
                                    width: isSmallScreen ? 100 : 120,
                                    child: Text(
                                      fixture['pair1'] ?? '',
                                      style: TextStyle(fontSize: isSmallScreen ? 10 : 12),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  SizedBox(
                                    width: isSmallScreen ? 100 : 120,
                                    child: Text(
                                      fixture['pair2'] ?? '',
                                      style: TextStyle(fontSize: isSmallScreen ? 10 : 12),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  SizedBox(
                                    width: isSmallScreen ? 80 : 100,
                                    child: Text(
                                      fixture['team1_id'] ?? '',
                                      style: TextStyle(fontSize: isSmallScreen ? 10 : 12),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  SizedBox(
                                    width: isSmallScreen ? 80 : 100,
                                    child: Text(
                                      fixture['team2_id'] ?? '',
                                      style: TextStyle(fontSize: isSmallScreen ? 10 : 12),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  SizedBox(
                                    width: isSmallScreen ? 80 : 100,
                                    child: _buildStatusChip(fixture['status'] ?? ''),
                                  ),
                                ),
                                DataCell(
                                  SizedBox(
                                    width: isSmallScreen ? 50 : 70,
                                    child: Text(
                                      fixture['team1_score']?.toString() ?? '0',
                                      style: TextStyle(
                                        fontSize: isSmallScreen ? 10 : 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  SizedBox(
                                    width: isSmallScreen ? 50 : 70,
                                    child: Text(
                                      fixture['team2_score']?.toString() ?? '0',
                                      style: TextStyle(
                                        fontSize: isSmallScreen ? 10 : 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  SizedBox(
                                    width: isSmallScreen ? 80 : 100,
                                    child: Text(
                                      fixture['winner_team_id'] ?? '',
                                      style: TextStyle(
                                        fontSize: isSmallScreen ? 10 : 12,
                                        fontWeight: FontWeight.w600,
                                        color: fixture['winner_team_id']?.isNotEmpty == true 
                                          ? Colors.green[700] 
                                          : null,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }

  // Build Status Chip for fixtures table
  Widget _buildStatusChip(String status) {
    Color chipColor;
    String displayText = status;
    
    switch (status.toLowerCase()) {
      case 'scheduled':
        chipColor = Colors.blue;
        displayText = 'Scheduled';
        break;
      case 'live':
      case 'in progress':
        chipColor = Colors.green;
        displayText = 'Live';
        break;
      case 'completed':
        chipColor = Colors.grey;
        displayText = 'Done';
        break;
      default:
        chipColor = Colors.orange;
        displayText = status.isNotEmpty ? status : 'TBD';
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        displayText,
        style: const TextStyle(
          color: Colors.white, 
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  // Build Standings Table for specific category
  Widget _buildStandingsTable(String category) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _googleSheetsService.getMatchesByCategory(category: category),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color.fromARGB(255, 220, 20, 20),
            ),
          );
        }
        
        final matches = snapshot.data ?? [];
        final standings = _calculateStandings(matches);
        
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: standings.isEmpty
              ? Center(
                  child: Text(
                    'No $category standings available yet',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                )
              : LayoutBuilder(
                  builder: (context, constraints) {
                    final isSmallScreen = constraints.maxWidth < 600;
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: isSmallScreen ? 500 : constraints.maxWidth,
                        ),
                        child: DataTable(
                          headingRowColor: MaterialStateProperty.all(
                            const Color.fromARGB(255, 220, 20, 20).withOpacity(0.1),
                          ),
                          columnSpacing: isSmallScreen ? 20 : 56,
                          dataRowMinHeight: isSmallScreen ? 40 : 48,
                          dataRowMaxHeight: isSmallScreen ? 50 : 56,
                          columns: [
                            DataColumn(
                              label: SizedBox(
                                width: isSmallScreen ? 120 : 150,
                                child: const Text('Team', 
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: isSmallScreen ? 60 : 80,
                                child: const Text('Played', 
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: isSmallScreen ? 50 : 70,
                                child: const Text('Won', 
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: isSmallScreen ? 50 : 70,
                                child: const Text('Lost', 
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: isSmallScreen ? 60 : 80,
                                child: const Text('Points', 
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                          rows: standings.map((team) {
                            return DataRow(
                              cells: [
                                DataCell(
                                  SizedBox(
                                    width: isSmallScreen ? 120 : 150,
                                    child: Text(
                                      team['team'] ?? '',
                                      style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  SizedBox(
                                    width: isSmallScreen ? 60 : 80,
                                    child: Text(
                                      team['played']?.toString() ?? '0',
                                      style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  SizedBox(
                                    width: isSmallScreen ? 50 : 70,
                                    child: Text(
                                      team['won']?.toString() ?? '0',
                                      style: TextStyle(
                                        fontSize: isSmallScreen ? 12 : 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.green[700],
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  SizedBox(
                                    width: isSmallScreen ? 50 : 70,
                                    child: Text(
                                      team['lost']?.toString() ?? '0',
                                      style: TextStyle(
                                        fontSize: isSmallScreen ? 12 : 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.red[700],
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  SizedBox(
                                    width: isSmallScreen ? 60 : 80,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(255, 220, 20, 20).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        team['points']?.toString() ?? '0',
                                        style: TextStyle(
                                          fontSize: isSmallScreen ? 12 : 14,
                                          fontWeight: FontWeight.bold,
                                          color: const Color.fromARGB(255, 220, 20, 20),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }

  // Calculate standings from matches
  List<Map<String, dynamic>> _calculateStandings(List<Map<String, dynamic>> matches) {
    Map<String, Map<String, int>> teamStats = {};
    
    for (var match in matches) {
      String team1 = match['team1_id'] ?? '';
      String team2 = match['team2_id'] ?? '';
      String winner = match['winner_team_id'] ?? '';
      String status = match['status'] ?? '';
      
      if (team1.isEmpty || team2.isEmpty) continue;
      
      // Initialize teams if not exists
      teamStats[team1] ??= {'played': 0, 'won': 0, 'lost': 0, 'points': 0};
      teamStats[team2] ??= {'played': 0, 'won': 0, 'lost': 0, 'points': 0};
      
      // Only count completed matches
      if (status.toLowerCase() == 'completed') {
        teamStats[team1]!['played'] = (teamStats[team1]!['played'] ?? 0) + 1;
        teamStats[team2]!['played'] = (teamStats[team2]!['played'] ?? 0) + 1;
        
        if (winner == team1) {
          teamStats[team1]!['won'] = (teamStats[team1]!['won'] ?? 0) + 1;
          teamStats[team2]!['lost'] = (teamStats[team2]!['lost'] ?? 0) + 1;
        } else if (winner == team2) {
          teamStats[team2]!['won'] = (teamStats[team2]!['won'] ?? 0) + 1;
          teamStats[team1]!['lost'] = (teamStats[team1]!['lost'] ?? 0) + 1;
        }
      }
    }
    
    // Convert to list and calculate points
    List<Map<String, dynamic>> standings = [];
    teamStats.forEach((team, stats) {
      standings.add({
        'team': team,
        'played': stats['played'],
        'won': stats['won'],
        'lost': stats['lost'],
        'points': stats['won'], // 1 point per win as per requirements
      });
    });
    
    // Sort by points descending, then by wins descending
    standings.sort((a, b) {
      int pointsCompare = (b['points'] ?? 0).compareTo(a['points'] ?? 0);
      if (pointsCompare == 0) {
        return (b['won'] ?? 0).compareTo(a['won'] ?? 0);
      }
      return pointsCompare;
    });
    
    return standings;
  }
}