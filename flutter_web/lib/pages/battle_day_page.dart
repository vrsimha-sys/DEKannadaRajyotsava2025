import 'package:flutter/material.dart';
import '../services/google_sheets_service.dart';

class BattleDayPage extends StatefulWidget {
  const BattleDayPage({super.key});

  @override
  State<BattleDayPage> createState() => _BattleDayPageState();
}

class _BattleDayPageState extends State<BattleDayPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _fadeAnimationController;
  late AnimationController _scaleAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  final GoogleSheetsService _googleSheetsService = GoogleSheetsService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    
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
    _tabController.dispose();
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
                      'Tournament Matches & Live Updates',
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
                    // Tab Bar
                    Container(
                      color: Colors.white,
                      child: TabBar(
                        controller: _tabController,
                        isScrollable: true,
                        tabs: const [
                          Tab(icon: Icon(Icons.schedule), text: 'Fixtures'),
                          Tab(icon: Icon(Icons.live_tv), text: 'Live'),
                          Tab(icon: Icon(Icons.leaderboard), text: 'Standings'),
                          Tab(icon: Icon(Icons.bar_chart), text: 'Results'),
                        ],
                        labelColor: const Color.fromARGB(255, 220, 20, 20),
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: const Color.fromARGB(255, 220, 20, 20),
                      ),
                    ),
                    
                    // Tab Content
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildFixturesTab(),
                          _buildLiveTab(),
                          _buildStandingsTab(),
                          _buildResultsTab(),
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

  Widget _buildFixturesTab() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _googleSheetsService.getMatches(status: 'Scheduled'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color.fromARGB(255, 220, 20, 20),
            ),
          );
        }
        
        final fixtures = snapshot.data ?? [];
        
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Match Fixtures',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 220, 20, 20),
                    ),
                  ),
                  DropdownButton<String>(
                    value: 'All Rounds',
                    items: const [
                      DropdownMenuItem(value: 'All Rounds', child: Text('All Rounds')),
                      DropdownMenuItem(value: 'Quarter Finals', child: Text('Quarter Finals')),
                      DropdownMenuItem(value: 'Semi Finals', child: Text('Semi Finals')),
                      DropdownMenuItem(value: 'Finals', child: Text('Finals')),
                    ],
                    onChanged: (value) {},
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: fixtures.isEmpty
                    ? const Center(
                        child: Text(
                          'No fixtures scheduled yet',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: fixtures.length,
                        itemBuilder: (context, index) {
                          return _buildFixtureCard(fixtures[index]);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFixtureCard(Map<String, dynamic> fixture) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(fixture['status'] ?? 'Unknown'),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    fixture['status'] ?? 'Unknown',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  '${fixture['match_type'] ?? 'Match'} • ${fixture['venue'] ?? 'TBD'}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        fixture['team1_id'] ?? 'Team 1',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (fixture['team1_score'] != null && fixture['team1_score'] > 0)
                        Text(
                          '${fixture['team1_score']}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 220, 20, 20),
                          ),
                        ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'VS',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        fixture['team2_id'] ?? 'Team 2',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (fixture['team2_score'] != null && fixture['team2_score'] > 0)
                        Text(
                          '${fixture['team2_score']}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 220, 20, 20),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.schedule, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      '${fixture['scheduled_date'] ?? 'TBD'} ${fixture['scheduled_time'] ?? ''}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                if (fixture['referee'] != null && fixture['referee'].toString().isNotEmpty)
                  Text(
                    'Ref: ${fixture['referee']}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveTab() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _googleSheetsService.getMatches(status: 'Live'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color.fromARGB(255, 220, 20, 20),
            ),
          );
        }
        
        final liveMatches = snapshot.data ?? [];
        
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Live Matches',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 220, 20, 20),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: liveMatches.isEmpty
                    ? const Center(
                        child: Text(
                          'No live matches at the moment',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: liveMatches.length,
                        itemBuilder: (context, index) {
                          return _buildLiveMatchCard(liveMatches[index]);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLiveMatchCard(Map<String, dynamic> match) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.live_tv, color: Colors.white, size: 12),
                      SizedBox(width: 4),
                      Text(
                        'LIVE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  '${match['venue'] ?? 'Court'} • ${match['match_duration'] ?? '0:00'}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        match['team1_id'] ?? 'Team 1',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        '${match['team1_score'] ?? 0}',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 220, 20, 20),
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'VS',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        match['team2_id'] ?? 'Team 2',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        '${match['team2_score'] ?? 0}',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 220, 20, 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStandingsTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tournament Standings',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 220, 20, 20),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Center(
              child: Text(
                'Standings will be available once matches begin',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsTab() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _googleSheetsService.getMatches(status: 'Completed'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color.fromARGB(255, 220, 20, 20),
            ),
          );
        }
        
        final results = snapshot.data ?? [];
        
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Match Results',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 220, 20, 20),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: results.isEmpty
                    ? const Center(
                        child: Text(
                          'No completed matches yet',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: results.length,
                        itemBuilder: (context, index) {
                          return _buildResultCard(results[index]);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildResultCard(Map<String, dynamic> result) {
    final isTeam1Winner = result['winner_team_id'] == result['team1_id'];
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'COMPLETED',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  '${result['match_type'] ?? 'Match'}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isTeam1Winner ? Colors.green.withOpacity(0.1) : null,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              result['team1_id'] ?? 'Team 1',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: isTeam1Winner ? Colors.green : Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            if (isTeam1Winner)
                              const Icon(Icons.emoji_events, color: Colors.green, size: 16),
                          ],
                        ),
                        Text(
                          '${result['team1_score'] ?? 0}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: isTeam1Winner ? Colors.green : const Color.fromARGB(255, 220, 20, 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'VS',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: !isTeam1Winner ? Colors.green.withOpacity(0.1) : null,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              result['team2_id'] ?? 'Team 2',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: !isTeam1Winner ? Colors.green : Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            if (!isTeam1Winner)
                              const Icon(Icons.emoji_events, color: Colors.green, size: 16),
                          ],
                        ),
                        Text(
                          '${result['team2_score'] ?? 0}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: !isTeam1Winner ? Colors.green : const Color.fromARGB(255, 220, 20, 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '${result['scheduled_date'] ?? 'Date TBD'}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'live':
        return Colors.red;
      case 'completed':
        return Colors.green;
      case 'scheduled':
        return Colors.blue;
      case 'upcoming':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  void _refreshData() {
    setState(() {
      // This will trigger a rebuild and refetch data from Google Sheets
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data refreshed!'),
        backgroundColor: Colors.green,
      ),
    );
  }
}