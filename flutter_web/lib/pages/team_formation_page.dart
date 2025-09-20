import 'package:flutter/material.dart';
import '../services/google_sheets_service.dart';

class TeamFormationPage extends StatefulWidget {
  const TeamFormationPage({super.key});

  @override
  State<TeamFormationPage> createState() => _TeamFormationPageState();
}

class _TeamFormationPageState extends State<TeamFormationPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    // Initialize animation controller for empty state
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _refreshData() {
    // Refresh team formation data
    setState(() {
      // This will trigger a rebuild of the widget
    });
    
    // Show a snackbar to confirm refresh
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Team formation data refreshed'),
        duration: Duration(seconds: 2),
        backgroundColor: Color.fromARGB(255, 220, 20, 20),
      ),
    );
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
                      'Team Formation',
                      style: TextStyle(
                        fontSize: isDesktop ? 32 : 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Player Auction & Team Building',
                      style: TextStyle(
                        fontSize: isDesktop ? 16 : 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Sunday, 28 September, 2025',
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
              future: _getTeams(),
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
                  // Show only "Auction Day Awaits" widget when no data
                  return Center(
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.gavel,
                              size: 80,
                              color: const Color.fromARGB(255, 220, 20, 20).withOpacity(0.6),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              '⚡ Auction Day Awaits! ⚡',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 220, 20, 20),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Teams will be formed during the auction.\nCome back on auction day to see the action!',
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
                                    Icons.event,
                                    color: const Color.fromARGB(255, 220, 20, 20),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Get ready for the bidding wars!',
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
                        tabs: const [
                          Tab(icon: Icon(Icons.queue), text: 'Queue'),
                          Tab(icon: Icon(Icons.groups), text: 'Teams'),
                          Tab(icon: Icon(Icons.analytics), text: 'Stats'),
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
                          _buildAuctionTab(),
                          _buildTeamsTab(),
                          _buildStatsTab(),
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
        future: _getTeams(),
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

  Widget _buildAuctionTab() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Current Player Being Auctioned
          Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [Colors.white, Color(0xFFF5F5F5)],
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'Current Player',
                    style: TextStyle(
                      fontSize: isDesktop ? 20 : 16,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 220, 20, 20),
                    ),
                  ),
                  const SizedBox(height: 16),
                  CircleAvatar(
                    radius: isDesktop ? 50 : 40,
                    backgroundColor: const Color.fromARGB(255, 247, 183, 7),
                    child: Text(
                      'RK',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: isDesktop ? 24 : 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Rajesh Kumar',
                    style: TextStyle(
                      fontSize: isDesktop ? 24 : 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Age: 28 | Experience: 5 years',
                    style: TextStyle(
                      fontSize: isDesktop ? 16 : 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildBidInfo('Base Price', '₹5,000'),
                      _buildBidInfo('Current Bid', '₹12,000'),
                      _buildBidInfo('Next Bid', '₹13,000'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => _placeBid(1000),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: const Text('+₹1K', style: TextStyle(color: Colors.white)),
                      ),
                      ElevatedButton(
                        onPressed: () => _placeBid(2000),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        child: const Text('+₹2K', style: TextStyle(color: Colors.white)),
                      ),
                      ElevatedButton(
                        onPressed: () => _placeBid(5000),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                        ),
                        child: const Text('+₹5K', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Auction Queue
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Auction Queue',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _getAuctionQueue().length,
                        itemBuilder: (context, index) {
                          final player = _getAuctionQueue()[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: const Color.fromARGB(255, 247, 183, 7),
                              child: Text(
                                player['name'].split(' ').map((e) => e[0]).take(2).join(),
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                            title: Text(player['name']),
                            subtitle: Text('Base Price: ₹${player['basePrice']}'),
                            trailing: Text('${index + 1}'),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBidInfo(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 220, 20, 20),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildTeamsTab() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;
    final isTablet = screenWidth > 450 && screenWidth <= 800;
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Formed Teams',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 220, 20, 20),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _getTeams(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color.fromARGB(255, 220, 20, 20),
                    ),
                  );
                }
                
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error loading teams: ${snapshot.error}',
                      style: TextStyle(color: Colors.red[600]),
                    ),
                  );
                }
                
                final teams = snapshot.data ?? [];
                
                if (teams.isEmpty) {
                  return _buildEmptyTeamsMessage();
                }
                
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isDesktop ? 3 : (isTablet ? 2 : 1),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: isDesktop ? 1.4 : (isTablet ? 1.2 : 1.8),
                  ),
                  itemCount: teams.length,
                  itemBuilder: (context, index) {
                    return _buildTeamCard(teams[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyTeamsMessage() {
    return Center(
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.gavel,
                    size: 80,
                    color: const Color.fromARGB(255, 220, 20, 20).withOpacity(0.6),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    '⚡ Auction Day Awaits! ⚡',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 220, 20, 20),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Teams will be formed during the auction.\nCome back on auction day to see the action!',
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
                          Icons.event,
                          color: const Color.fromARGB(255, 220, 20, 20),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Get ready for the bidding wars!',
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
          );
        },
      ),
    );
  }

  Widget _buildTeamCard(Map<String, dynamic> team) {
    // Map Google Sheets data to UI expectations
    final teamName = team['team_name'] ?? 'Unknown Team';
    final playerCount = team['player_count'] ?? 0;
    final spentBudget = team['spent_budget'] ?? 0;
    
    // Generate a color based on team name
    final colors = [
      const Color.fromARGB(255, 220, 20, 20),
      const Color.fromARGB(255, 247, 183, 7),
      Colors.blue,
      Colors.green,
      Colors.purple,
      Colors.orange,
      Colors.teal,
      Colors.pink,
    ];
    final teamColor = colors[teamName.hashCode.abs() % colors.length];
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: teamColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.sports, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        teamName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '₹${spentBudget.toString()} spent',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Players: $playerCount',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: playerCount / 8,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(teamColor),
            ),
            const SizedBox(height: 8),
            Text(
              'Budget: ₹${(team['remaining_budget'] ?? 0).toString()} left',
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

  Widget _buildStatsTab() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;
    final isTablet = screenWidth > 450 && screenWidth <= 800;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Auction Statistics',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 220, 20, 20),
            ),
          ),
          const SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: isDesktop ? 3 : (isTablet ? 2 : 2),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: isDesktop ? 1.8 : (isTablet ? 1.5 : 1.2),
            children: [
              _buildStatCard('Total Players', '45', Icons.people),
              _buildStatCard('Players Sold', '28', Icons.check_circle),
              _buildStatCard('Avg. Price', '₹8,500', Icons.attach_money),
              _buildStatCard('Teams Formed', '4', Icons.groups),
              _buildStatCard('Highest Bid', '₹25,000', Icons.trending_up),
              _buildStatCard('Total Revenue', '₹2,38,000', Icons.account_balance),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: const Color.fromARGB(255, 220, 20, 20),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 220, 20, 20),
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _placeBid(int amount) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Bid placed: +₹$amount'),
        backgroundColor: Colors.green,
      ),
    );
  }

  List<Map<String, dynamic>> _getAuctionQueue() {
    return [
      {'name': 'Priya Sharma', 'basePrice': '4,000'},
      {'name': 'Suresh Rao', 'basePrice': '6,000'},
      {'name': 'Anita Rao', 'basePrice': '3,500'},
      {'name': 'Vikram Singh', 'basePrice': '5,500'},
    ];
  }

  Future<List<Map<String, dynamic>>> _getTeams() async {
    final googleSheetsService = GoogleSheetsService();
    try {
      final teams = await googleSheetsService.getTeams();
      return teams;
    } catch (e) {
      print('Error fetching teams: $e');
      return []; // Return empty list to show "Auction Day Awaits" message
    }
  }
}