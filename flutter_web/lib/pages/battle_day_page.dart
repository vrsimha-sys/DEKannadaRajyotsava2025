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

  // Pagination variables for fixtures (desktop mode)
  final Map<String, int> _currentPage = {'Men': 0, 'Women': 0, 'Kids': 0};
  static const int _itemsPerPage = 10;

  @override
  void initState() {
    super.initState();
    _mainTabController = TabController(length: 2, vsync: this); // Fixtures and Standings
    _fixturesTabController = TabController(length: 3, vsync: this); // Men, Women, Kids
    _standingsTabController = TabController(length: 3, vsync: this); // Men, Women, Kids
    
    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _scaleAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeAnimationController, curve: Curves.easeIn),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleAnimationController, curve: Curves.elasticOut),
    );
    
    _fadeAnimationController.forward();
    _scaleAnimationController.forward();
  }

  // Refresh data method
  void _refreshData() {
    setState(() {
      // This will trigger a rebuild of FutureBuilder widgets
    });
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
      body: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                children: [
                  // Header Section
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 16,
                      bottom: 24,
                      left: 24,
                      right: 24,
                    ),
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
                        
                        if (snapshot.hasError) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  size: 64,
                                  color: Colors.red,
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Unable to load tournament data',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Error: ${snapshot.error}',
                                  style: const TextStyle(color: Colors.grey),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: _refreshData,
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          );
                        }
                        
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.event_busy,
                                  size: 64,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'No matches scheduled',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Check back later for tournament updates',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: _refreshData,
                                  child: const Text('Refresh'),
                                ),
                              ],
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
            ),
          );
        },
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

  // Build Fixtures Section with category tabs
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

  // Build Standings Section with category tabs
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
        print('FixturesTable ($category): snapshot.data length = ${snapshot.data?.length}');
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
                    final isDesktop = constraints.maxWidth >= 600;
                    
                    // For desktop, implement pagination
                    if (isDesktop) {
                      return _buildPaginatedFixtures(category, fixtures, constraints);
                    }
                    
                    // For mobile, keep the original scrollable layout
                    return SizedBox(
                      height: 400,
                      child: Scrollbar(
                        thumbVisibility: true,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: constraints.maxWidth,
                              ),
                              child: DataTable(
                                columnSpacing: isSmallScreen ? 8 : 16,
                                headingRowColor: MaterialStateProperty.all(
                                  const Color.fromARGB(255, 220, 20, 20).withOpacity(0.1),
                                ),
                                columns: [
                                  DataColumn(
                                    label: Text(
                                      'Time',
                                      style: TextStyle(
                                        fontSize: isSmallScreen ? 12 : 14,
                                        fontWeight: FontWeight.bold,
                                        color: const Color.fromARGB(255, 220, 20, 20),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Court',
                                      style: TextStyle(
                                        fontSize: isSmallScreen ? 12 : 14,
                                        fontWeight: FontWeight.bold,
                                        color: const Color.fromARGB(255, 220, 20, 20),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: SizedBox(
                                      width: isSmallScreen ? 80 : 120,
                                      child: Text(
                                        'Pair 1',
                                        style: TextStyle(
                                          fontSize: isSmallScreen ? 12 : 14,
                                          fontWeight: FontWeight.bold,
                                          color: const Color.fromARGB(255, 220, 20, 20),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const DataColumn(label: Text('vs')),
                                  DataColumn(
                                    label: SizedBox(
                                      width: isSmallScreen ? 80 : 120,
                                      child: Text(
                                        'Pair 2',
                                        style: TextStyle(
                                          fontSize: isSmallScreen ? 12 : 14,
                                          fontWeight: FontWeight.bold,
                                          color: const Color.fromARGB(255, 220, 20, 20),
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Skill',
                                      style: TextStyle(
                                        fontSize: isSmallScreen ? 12 : 14,
                                        fontWeight: FontWeight.bold,
                                        color: const Color.fromARGB(255, 220, 20, 20),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Team 1',
                                      style: TextStyle(
                                        fontSize: isSmallScreen ? 12 : 14,
                                        fontWeight: FontWeight.bold,
                                        color: const Color.fromARGB(255, 220, 20, 20),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Team 2',
                                      style: TextStyle(
                                        fontSize: isSmallScreen ? 12 : 14,
                                        fontWeight: FontWeight.bold,
                                        color: const Color.fromARGB(255, 220, 20, 20),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Status',
                                      style: TextStyle(
                                        fontSize: isSmallScreen ? 12 : 14,
                                        fontWeight: FontWeight.bold,
                                        color: const Color.fromARGB(255, 220, 20, 20),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Score',
                                      style: TextStyle(
                                        fontSize: isSmallScreen ? 12 : 14,
                                        fontWeight: FontWeight.bold,
                                        color: const Color.fromARGB(255, 220, 20, 20),
                                      ),
                                    ),
                                  ),
                                ],
                                rows: fixtures.map<DataRow>((fixture) => DataRow(
                                  cells: [
                                    DataCell(Text(
                                      fixture['Time'] ?? '',
                                      style: TextStyle(fontSize: isSmallScreen ? 11 : 13),
                                    )),
                                    DataCell(Text(
                                      fixture['Court'] ?? '',
                                      style: TextStyle(fontSize: isSmallScreen ? 11 : 13),
                                    )),
                                    DataCell(
                                      SizedBox(
                                        width: isSmallScreen ? 80 : 120,
                                        child: _buildPairDisplay(fixture['Pair 1'] ?? '', isSmallScreen),
                                      ),
                                    ),
                                    DataCell(
                                      Icon(
                                        Icons.sports_tennis,
                                        size: isSmallScreen ? 12 : 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    DataCell(
                                      SizedBox(
                                        width: isSmallScreen ? 80 : 120,
                                        child: _buildPairDisplay(fixture['Pair 2'] ?? '', isSmallScreen),
                                      ),
                                    ),
                                    DataCell(Text(
                                      fixture['Skill'] ?? '',
                                      style: TextStyle(fontSize: isSmallScreen ? 11 : 13),
                                    )),
                                    DataCell(Text(
                                      fixture['Team 1'] ?? '',
                                      style: TextStyle(fontSize: isSmallScreen ? 11 : 13),
                                    )),
                                    DataCell(Text(
                                      fixture['Team 2'] ?? '',
                                      style: TextStyle(fontSize: isSmallScreen ? 11 : 13),
                                    )),
                                    DataCell(
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: _getStatusColor(fixture['Status'] ?? ''),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          fixture['Status']?.isNotEmpty == true ? fixture['Status'] : 'Scheduled',
                                          style: TextStyle(
                                            fontSize: isSmallScreen ? 10 : 12,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(Text(
                                      _getScoreDisplay(fixture),
                                      style: TextStyle(
                                        fontSize: isSmallScreen ? 11 : 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                                  ],
                                )).toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }

  // Helper method to display pair names vertically
  Widget _buildPairDisplay(String pairText, bool isSmallScreen) {
    if (pairText.isEmpty) return const Text('');
    
    // Split by ' & ' and display vertically
    final names = pairText.split(' & ');
    if (names.length == 2) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            names[0].trim(),
            style: TextStyle(
              fontSize: isSmallScreen ? 10 : 12,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          Text(
            names[1].trim(),
            style: TextStyle(
              fontSize: isSmallScreen ? 10 : 12,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      );
    } else {
      return Text(
        pairText,
        style: TextStyle(
          fontSize: isSmallScreen ? 10 : 12,
          fontWeight: FontWeight.w500,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      );
    }
  }

  // Helper method to get status color
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'in progress':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  // Helper method to get score display
  String _getScoreDisplay(Map<String, dynamic> fixture) {
    final team1Score = fixture['Team1_Score']?.toString() ?? '0';
    final team2Score = fixture['Team2_Score']?.toString() ?? '0';
    
    if (team1Score == '0' && team2Score == '0') {
      return '-';
    }
    
    return '$team1Score-$team2Score';
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
                    return SizedBox(
                      height: isSmallScreen ? 400 : 500, // Fixed height for vertical scrolling
                      child: Scrollbar(
                        thumbVisibility: true, // Make scrollbar always visible on desktop
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          physics: const AlwaysScrollableScrollPhysics(), // Ensure scrolling works on desktop
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: constraints.maxWidth,
                              ),
                              child: DataTable(
                                columnSpacing: isSmallScreen ? 12 : 20,
                                headingRowColor: MaterialStateProperty.all(
                                  const Color.fromARGB(255, 220, 20, 20).withOpacity(0.1),
                                ),
                                columns: [
                                  DataColumn(
                                    label: Text(
                                      'Rank',
                                      style: TextStyle(
                                        fontSize: isSmallScreen ? 12 : 14,
                                        fontWeight: FontWeight.bold,
                                        color: const Color.fromARGB(255, 220, 20, 20),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Team',
                                      style: TextStyle(
                                        fontSize: isSmallScreen ? 12 : 14,
                                        fontWeight: FontWeight.bold,
                                        color: const Color.fromARGB(255, 220, 20, 20),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'P',
                                      style: TextStyle(
                                        fontSize: isSmallScreen ? 12 : 14,
                                        fontWeight: FontWeight.bold,
                                        color: const Color.fromARGB(255, 220, 20, 20),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'W',
                                      style: TextStyle(
                                        fontSize: isSmallScreen ? 12 : 14,
                                        fontWeight: FontWeight.bold,
                                        color: const Color.fromARGB(255, 220, 20, 20),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'L',
                                      style: TextStyle(
                                        fontSize: isSmallScreen ? 12 : 14,
                                        fontWeight: FontWeight.bold,
                                        color: const Color.fromARGB(255, 220, 20, 20),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Pts',
                                      style: TextStyle(
                                        fontSize: isSmallScreen ? 12 : 14,
                                        fontWeight: FontWeight.bold,
                                        color: const Color.fromARGB(255, 220, 20, 20),
                                      ),
                                    ),
                                  ),
                                ],
                                rows: standings.asMap().entries.map<DataRow>((entry) {
                                  final index = entry.key;
                                  final standing = entry.value;
                                  final isTopThree = index < 3;
                                  
                                  return DataRow(
                                    color: isTopThree 
                                        ? MaterialStateProperty.all(Colors.amber.withOpacity(0.1))
                                        : null,
                                    cells: [
                                      DataCell(
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            if (isTopThree) 
                                              Icon(
                                                index == 0 ? Icons.emoji_events : Icons.star,
                                                color: index == 0 ? const Color(0xFFFFD700) : Colors.amber,
                                                size: isSmallScreen ? 16 : 20,
                                              ),
                                            const SizedBox(width: 4),
                                            Text(
                                              '${index + 1}',
                                              style: TextStyle(
                                                fontSize: isSmallScreen ? 12 : 14,
                                                fontWeight: isTopThree ? FontWeight.bold : FontWeight.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      DataCell(Text(
                                        standing['team'] ?? '',
                                        style: TextStyle(
                                          fontSize: isSmallScreen ? 12 : 14,
                                          fontWeight: isTopThree ? FontWeight.bold : FontWeight.normal,
                                        ),
                                      )),
                                      DataCell(Text(
                                        '${standing['played'] ?? 0}',
                                        style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                                      )),
                                      DataCell(Text(
                                        '${standing['won'] ?? 0}',
                                        style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                                      )),
                                      DataCell(Text(
                                        '${standing['lost'] ?? 0}',
                                        style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                                      )),
                                      DataCell(Text(
                                        '${standing['points'] ?? 0}',
                                        style: TextStyle(
                                          fontSize: isSmallScreen ? 12 : 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }

  // Calculate standings from match results  
  List<Map<String, dynamic>> _calculateStandings(List<Map<String, dynamic>> matches) {
    final Map<String, Map<String, dynamic>> teamStats = {};
    
    print('=== Calculating standings for ${matches.length} matches ===');
    for (final match in matches) {
      print('Match: ${match['Team 1']} vs ${match['Team 2']} - Category: ${match['Category']} - Status: ${match['Status']}');
    }
    
    // Step 1: Initialize all teams from Team 1 and Team 2 columns
    for (final match in matches) {
      final team1 = match['Team 1']?.toString();
      final team2 = match['Team 2']?.toString();
      
      if (team1?.isNotEmpty == true) {
        teamStats[team1!] ??= {'team': team1, 'played': 0, 'won': 0, 'lost': 0, 'points': 0};
      }
      if (team2?.isNotEmpty == true) {
        teamStats[team2!] ??= {'team': team2, 'played': 0, 'won': 0, 'lost': 0, 'points': 0};
      }
    }
    
    // Step 2: Calculate played count from completed matches
    for (final match in matches) {
      final team1 = match['Team 1']?.toString();
      final team2 = match['Team 2']?.toString();
      final status = match['Status']?.toString().toLowerCase();
      
      if (team1?.isNotEmpty != true || team2?.isNotEmpty != true) continue;
      if (status != 'completed') continue;
      
      // Update played count for both teams
      teamStats[team1!]!['played']++;
      teamStats[team2!]!['played']++;
    }
    
    // Step 3: Calculate wins by counting appearances in Winner_Team_ID column
    for (final match in matches) {
      final status = match['Status']?.toString().toLowerCase();
      final winningTeam = match['Winner_Team_ID']?.toString();
      
      if (status != 'completed') continue;
      if (winningTeam?.isNotEmpty != true) continue;
      
      // Count win for the team that appears in winning_team_id
      if (teamStats.containsKey(winningTeam!)) {
        teamStats[winningTeam]!['won']++;
      }
    }
    
    // Step 4: Calculate lost = played - won and points = 1 * won for all teams
    for (final teamId in teamStats.keys) {
      final played = teamStats[teamId]!['played'] as int;
      final won = teamStats[teamId]!['won'] as int;
      teamStats[teamId]!['lost'] = played - won;
      teamStats[teamId]!['points'] = 1 * won; // Points = 1 * Won
      print('Team $teamId: P=$played W=$won L=${played - won} Pts=${1 * won}');
    }
    
    // Convert to list and sort by points (descending), then by wins
    final standings = teamStats.values.toList();
    standings.sort((a, b) {
      final pointsCompare = (b['points'] ?? 0).compareTo(a['points'] ?? 0);
      if (pointsCompare == 0) {
        return (b['won'] ?? 0).compareTo(a['won'] ?? 0);
      }
      return pointsCompare;
    });
    
    print('=== Final standings (${standings.length} teams) ===');
    for (int i = 0; i < standings.length; i++) {
      final team = standings[i];
      print('${i + 1}. ${team['team']}: ${team['points']} pts (${team['won']}W-${team['lost']}L-${team['played']}P)');
    }
    
    return standings;
  }

  // Build paginated fixtures for desktop
  Widget _buildPaginatedFixtures(String category, List<Map<String, dynamic>> fixtures, BoxConstraints constraints) {
    final currentPage = _currentPage[category] ?? 0;
    final totalPages = (fixtures.length / _itemsPerPage).ceil();
    
    // Calculate the fixtures for current page
    final startIndex = currentPage * _itemsPerPage;
    final endIndex = (startIndex + _itemsPerPage).clamp(0, fixtures.length);
    final paginatedFixtures = fixtures.sublist(startIndex, endIndex);
    
    return Column(
      children: [
        // Page indicator
        if (totalPages > 1)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Page ${currentPage + 1} of $totalPages (${fixtures.length} matches)',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: currentPage > 0
                          ? () => setState(() => _currentPage[category] = currentPage - 1)
                          : null,
                      icon: const Icon(Icons.chevron_left),
                      tooltip: 'Previous Page',
                    ),
                    IconButton(
                      onPressed: currentPage < totalPages - 1
                          ? () => setState(() => _currentPage[category] = currentPage + 1)
                          : null,
                      icon: const Icon(Icons.chevron_right),
                      tooltip: 'Next Page',
                    ),
                  ],
                ),
              ],
            ),
          ),
        
        // Fixtures table
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: constraints.maxWidth,
              ),
              child: DataTable(
                columnSpacing: 16,
                headingRowColor: MaterialStateProperty.all(
                  const Color.fromARGB(255, 220, 20, 20).withOpacity(0.1),
                ),
                columns: const [
                  DataColumn(
                    label: Text(
                      'Time',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 220, 20, 20),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Court',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 220, 20, 20),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: SizedBox(
                      width: 120,
                      child: Text(
                        'Pair 1',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 220, 20, 20),
                        ),
                      ),
                    ),
                  ),
                  DataColumn(label: Text('vs')),
                  DataColumn(
                    label: SizedBox(
                      width: 120,
                      child: Text(
                        'Pair 2',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 220, 20, 20),
                        ),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Skill',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 220, 20, 20),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Team 1',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 220, 20, 20),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Team 2',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 220, 20, 20),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Status',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 220, 20, 20),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Score',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 220, 20, 20),
                      ),
                    ),
                  ),
                ],
                rows: paginatedFixtures.map<DataRow>((fixture) => DataRow(
                  cells: [
                    DataCell(Text(
                      fixture['Time'] ?? '',
                      style: const TextStyle(fontSize: 13),
                    )),
                    DataCell(Text(
                      fixture['Court'] ?? '',
                      style: const TextStyle(fontSize: 13),
                    )),
                    DataCell(
                      SizedBox(
                        width: 120,
                        child: _buildPairDisplay(fixture['Pair 1'] ?? '', false),
                      ),
                    ),
                    DataCell(
                      Icon(
                        Icons.sports_tennis,
                        size: 16,
                        color: Colors.grey,
                      ),
                    ),
                    DataCell(
                      SizedBox(
                        width: 120,
                        child: _buildPairDisplay(fixture['Pair 2'] ?? '', false),
                      ),
                    ),
                    DataCell(Text(
                      fixture['Skill'] ?? '',
                      style: const TextStyle(fontSize: 13),
                    )),
                    DataCell(Text(
                      fixture['Team 1'] ?? '',
                      style: const TextStyle(fontSize: 13),
                    )),
                    DataCell(Text(
                      fixture['Team 2'] ?? '',
                      style: const TextStyle(fontSize: 13),
                    )),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getStatusColor(fixture['Status'] ?? ''),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          fixture['Status']?.isNotEmpty == true ? fixture['Status'] : 'Scheduled',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    DataCell(Text(
                      _getScoreDisplay(fixture),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                  ],
                )).toList(),
              ),
            ),
          ),
        ),
        
        // Bottom pagination controls (optional, for easier access)
        if (totalPages > 1)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(totalPages.clamp(0, 5), (index) {
                // Show max 5 page buttons
                int pageIndex;
                if (totalPages <= 5) {
                  pageIndex = index;
                } else {
                  // Smart pagination: show pages around current page
                  if (currentPage < 3) {
                    pageIndex = index;
                  } else if (currentPage > totalPages - 3) {
                    pageIndex = totalPages - 5 + index;
                  } else {
                    pageIndex = currentPage - 2 + index;
                  }
                }
                
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: TextButton(
                    onPressed: () => setState(() => _currentPage[category] = pageIndex),
                    style: TextButton.styleFrom(
                      backgroundColor: pageIndex == currentPage 
                          ? const Color.fromARGB(255, 220, 20, 20) 
                          : Colors.grey.shade200,
                      foregroundColor: pageIndex == currentPage 
                          ? Colors.white 
                          : Colors.black87,
                      minimumSize: const Size(40, 36),
                    ),
                    child: Text('${pageIndex + 1}'),
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }
}