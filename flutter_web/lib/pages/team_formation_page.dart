import 'package:flutter/material.dart';
import '../services/google_sheets_service.dart';
import '../services/photo_service.dart';

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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isDesktop = screenWidth > 800;
    final isLandscape = screenWidth > screenHeight;
    final isMobileLandscape = isLandscape && screenWidth <= 800;

    print('TeamFormationPage: Build method called, isDesktop: $isDesktop, isLandscape: $isLandscape');

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // Header Section - Reduced padding for mobile landscape
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(isMobileLandscape ? 10 : (isDesktop ? 40 : 20)),
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
                // Header content
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Team Formation',
                      style: TextStyle(
                        fontSize: isMobileLandscape ? 18 : (isDesktop ? 32 : 24),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: isMobileLandscape ? 4 : 8),
                    Text(
                      'Player Selection & Team Building',
                      style: TextStyle(
                        fontSize: isMobileLandscape ? 12 : (isDesktop ? 16 : 14),
                        color: Colors.white.withOpacity(0.9),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: isMobileLandscape ? 2 : 4),
                    Text(
                      'Friday, 26 September, 2025 @ 9:00 PM',
                      style: TextStyle(
                        fontSize: isMobileLandscape ? 10 : (isDesktop ? 14 : 12),
                        color: Colors.white.withOpacity(0.8),
                        fontWeight: FontWeight.w300,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                SizedBox(height: isMobileLandscape ? 8 : 12),
                // Refresh button positioned below header text and centered
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: IconButton(
                    onPressed: () {
                      print('TeamFormationPage: Refresh button pressed');
                      setState(() {
                        // This will trigger a rebuild and re-fetch the data
                      });
                    },
                    icon: const Icon(
                      Icons.refresh,
                      color: Colors.white,
                      size: 24,
                    ),
                    tooltip: 'Refresh Teams Data',
                  ),
                ),
              ],
            ),
          ),
          
          // Content Area - Conditional based on data availability
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _getTeams(),
              builder: (context, snapshot) {
                print('TeamFormationPage: FutureBuilder state: ${snapshot.connectionState}');
                print('TeamFormationPage: Has data: ${snapshot.hasData}');
                print('TeamFormationPage: Has error: ${snapshot.hasError}');
                if (snapshot.hasError) {
                  print('TeamFormationPage: Error: ${snapshot.error}');
                }
                
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color.fromARGB(255, 220, 20, 20),
                    ),
                  );
                }
                
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading data',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${snapshot.error}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              // Retry
                            });
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }
                
                // Check if there is data available with explicit null checking
                final teamsData = snapshot.data;
                bool hasData = snapshot.hasData && 
                               teamsData != null && 
                               teamsData.isNotEmpty;
                print('TeamFormationPage: hasData: $hasData, dataType: ${teamsData.runtimeType}');
                
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
                            const SizedBox(height: 16),
                            // Debug button to test Google Sheets connection
                            ElevatedButton.icon(
                              onPressed: () async {
                                final googleSheetsService = GoogleSheetsService();
                                print('=== MANUAL DEBUG TEST ===');
                                await googleSheetsService.testConnection();
                                
                                // Test different GIDs for Teams sheet
                                print('=== TESTING DIFFERENT GIDS ===');
                                await googleSheetsService.testTeamsGIDs();
                                
                                // Test Teams specifically
                                print('=== TESTING TEAMS FETCH ===');
                                try {
                                  final teams = await googleSheetsService.getTeams();
                                  print('Manual test: Fetched ${teams.length} teams');
                                  for (var team in teams) {
                                    print('Manual test team: $team');
                                  }
                                  
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Debug: Found ${teams.length} teams. Check console for details.'),
                                      backgroundColor: teams.isEmpty ? Colors.red : Colors.green,
                                      duration: Duration(seconds: 5),
                                    ),
                                  );
                                } catch (e) {
                                  print('Manual test error: $e');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Debug Error: $e'),
                                      backgroundColor: Colors.red,
                                      duration: Duration(seconds: 5),
                                    ),
                                  );
                                }
                              },
                              icon: Icon(Icons.bug_report),
                              label: Text('Debug: Test Sheets Connection'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
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
    );
  }

  Widget _buildAuctionTab() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    
    return DefaultTabController(
      length: 3,
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 8.0 : 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tab Bar for Men, Women, and Kids categories
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey[600],
                indicator: BoxDecoration(
                  color: const Color.fromARGB(255, 220, 20, 20),
                  borderRadius: BorderRadius.circular(8),
                ),
                isScrollable: true,
                tabAlignment: TabAlignment.center,
                tabs: [
                  Tab(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Men', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          Text('Auction', style: TextStyle(fontSize: 10)),
                        ],
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Women', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          Text('Draft', style: TextStyle(fontSize: 10)),
                        ],
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Kids', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          Text('Draft', style: TextStyle(fontSize: 10)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Tab Bar View for content
            Expanded(
              child: TabBarView(
                children: [
                  _buildMenAuctionSection(),
                  _buildWomenDraftSection(),
                  _buildKidsDraftSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamsTab() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    
    return DefaultTabController(
      length: 3,
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 8.0 : 16.0),
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
            
            // Tab Bar for Men, Women, and Kids categories
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey[600],
                indicator: BoxDecoration(
                  color: const Color.fromARGB(255, 220, 20, 20),
                  borderRadius: BorderRadius.circular(8),
                ),
                isScrollable: true,
                tabAlignment: TabAlignment.center,
                tabs: [
                  Tab(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Men Teams', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Tab(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Women Teams', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Tab(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Kids Teams', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Tab Bar View for content
            Expanded(
              child: TabBarView(
                children: [
                  _buildCategoryTeamsSection('Men'),
                  _buildCategoryTeamsSection('Women'),
                  _buildCategoryTeamsSection('Kids'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTeamsSection(String category) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;
    final isTablet = screenWidth > 450 && screenWidth <= 800;
    
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _getCategoryTeams(category),
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
              'Error loading $category teams: ${snapshot.error}',
              style: TextStyle(color: Colors.red[600]),
            ),
          );
        }
        
        final teams = snapshot.data ?? [];
        
        if (teams.isEmpty) {
          return _buildEmptyTeamsMessage(category);
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
            return _buildTeamCard(teams[index], category);
          },
        );
      },
    );
  }

  Widget _buildEmptyTeamsMessage([String? category]) {
    final categoryText = category != null ? ' for $category' : '';
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
                    'No teams formed$categoryText yet.\nCome back on auction day to see the action!',
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

  Widget _buildTeamCard(Map<String, dynamic> team, [String? category]) {
    // Map Google Sheets data to UI expectations with explicit type casting
    final teamName = (team['team_name'] ?? 'Unknown Team').toString();
    final teamId = (team['team_id'] ?? '').toString();
    
    // Use category-specific data if available, otherwise fall back to total data with type safety
    final playerCount = category != null 
        ? (int.tryParse((team['category_player_count'] ?? 0).toString()) ?? 0)
        : (int.tryParse((team['player_count'] ?? 0).toString()) ?? 0);
    final spentBudget = category != null
        ? (int.tryParse((team['category_spent_budget'] ?? 0).toString()) ?? 0)
        : (int.tryParse((team['spent_budget'] ?? 0).toString()) ?? 0);
    
    // Proficiency counts with explicit type casting
    final advancedCount = int.tryParse((team['advanced_count'] ?? 0).toString()) ?? 0;
    final intermediatePlusCount = int.tryParse((team['intermediate_plus_count'] ?? 0).toString()) ?? 0;
    final intermediateCount = int.tryParse((team['intermediate_count'] ?? 0).toString()) ?? 0;
    final beginnerCount = int.tryParse((team['beginner_count'] ?? 0).toString()) ?? 0;
    
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
    
    return GestureDetector(
      onTap: () => _showTeamPlayersDialog(teamId, teamName, category),
      child: Card(
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
                        if (category?.toLowerCase() == 'men')
                          Text(
                            category != null 
                                ? '$category: ${spentBudget.toString()} Pnts spent'
                                : '${spentBudget.toString()} Pnts spent',
                            style: TextStyle(
                              color: const Color.fromARGB(255, 40, 1, 85),
                              fontSize: 12,
                            ),
                          )
                        else
                          Text(
                            category != null 
                                ? '$category Players'
                                : 'Players',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                category != null
                    ? category.toLowerCase() == 'men'
                        ? '$category Players: $playerCount/10'
                        : category.toLowerCase() == 'women'
                            ? '$category Players: $playerCount/6'
                            : '$category Players: $playerCount/4'  // Kids
                    : 'Players: $playerCount',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              // Proficiency breakdown
              if (playerCount > 0) ...[
                Row(
                  children: _buildProficiencyChips(category, advancedCount, intermediatePlusCount, intermediateCount, beginnerCount),
                ),
                const SizedBox(height: 8),
              ],
              LinearProgressIndicator(
                value: category?.toLowerCase() == 'men' 
                    ? playerCount / 10  // Men teams: max 10 players
                    : category?.toLowerCase() == 'women'
                        ? playerCount / 6  // Women teams: max 6 players
                        : playerCount / 4,  // Kids teams: max 4 players
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(teamColor),
              ),
              const SizedBox(height: 8),
              if (category?.toLowerCase() == 'men') ...[
                Text(
                  'Base Pool: ${(team['total_base_pool'] ?? 0).toString()} Pnts',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 245, 70, 1),
                    fontSize: 12,
                  ),
                ),
                Text(
                  'Bidding Pool: ${(team['remaining_budget'] ?? 0).toString()} Pnts left',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 3, 70, 255),
                    fontSize: 12,
                  ),
                ),
                Text(
                  'Total Budget: ${((team['spent_budget'] ?? 0) + (team['remaining_budget'] ?? 0) + (team['total_base_pool'] ?? 0)).toString()} Pnts',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 2, 122, 8),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildProficiencyChips(String? category, int advancedCount, int intermediatePlusCount, int intermediateCount, int beginnerCount) {
    List<Widget> chips = [];
    
    if (category?.toLowerCase() == 'men') {
      // Men have 4 proficiency levels
      if (advancedCount > 0) {
        chips.add(_buildProficiencyChip('Adv', advancedCount, Colors.red));
        chips.add(const SizedBox(width: 8));
      }
      if (intermediatePlusCount > 0) {
        chips.add(_buildProficiencyChip('Int+', intermediatePlusCount, Colors.orange));
        chips.add(const SizedBox(width: 8));
      }
      if (intermediateCount > 0) {
        chips.add(_buildProficiencyChip('Int', intermediateCount, Colors.blue));
        chips.add(const SizedBox(width: 8));
      }
      if (beginnerCount > 0) {
        chips.add(_buildProficiencyChip('Beg', beginnerCount, Colors.green));
      }
    } else {
      // Women and Kids have 2 proficiency levels
      if (intermediateCount > 0) {
        chips.add(_buildProficiencyChip('Int', intermediateCount, Colors.orange));
        chips.add(const SizedBox(width: 8));
      }
      if (beginnerCount > 0) {
        chips.add(_buildProficiencyChip('Beg', beginnerCount, Colors.green));
      }
    }
    
    // Remove trailing SizedBox if it exists
    if (chips.isNotEmpty && chips.last is SizedBox) {
      chips.removeLast();
    }
    
    return chips;
  }

  Widget _buildProficiencyChip(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        '$label: $count',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  void _showTeamPlayersDialog(String teamId, String teamName, String? category) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.8,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            teamName,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 220, 20, 20),
                            ),
                          ),
                          if (category != null)
                            Text(
                              '$category Players',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: _getTeamPlayers(teamId, category),
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
                            'Error loading players: ${snapshot.error}',
                            style: TextStyle(color: Colors.red[600]),
                          ),
                        );
                      }
                      
                      final players = snapshot.data ?? [];
                      
                      if (players.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.people_outline,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                category != null 
                                    ? 'No $category players in this team yet'
                                    : 'No players in this team yet',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      
                      return ListView.builder(
                        itemCount: players.length,
                        itemBuilder: (context, index) {
                          final player = players[index];
                          return _buildPlayerListTile(player, category);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlayerListTile(Map<String, dynamic> player, String? category) {
    // Explicit type casting for player data to prevent type errors in production
    final playerName = (player['name'] ?? 'Unknown Player').toString();
    final playerCategory = (player['category'] ?? '').toString();
    final proficiency = (player['proficiency'] ?? 'Not specified').toString();
    final bidAmount = (player['bid_amount'] ?? player['base_price'] ?? 0).toString();
    final status = (player['status'] ?? '').toString();
    
    // Generate color based on category
    Color categoryColor;
    switch (playerCategory.toLowerCase()) {
      case 'male':
      case 'men':
      case 'man':
        categoryColor = Colors.blue;
        break;
      case 'female':
      case 'women':
      case 'woman':
        categoryColor = Colors.pink;
        break;
      case 'kids':
      case 'children':
      case 'child':
        categoryColor = Colors.orange;
        break;
      default:
        categoryColor = Colors.grey;
    }
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: PhotoService.buildSimpleAvatar(
          playerName: playerName,
          photoUrl: player['photo_url'],
          backgroundColor: categoryColor,
          radius: 20,
        ),
        title: Text(
          playerName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Category: $playerCategory'),
            Text('Proficiency: $proficiency'),
            if (status.isNotEmpty) Text('Status: $status'),
          ],
        ),
        trailing: category?.toLowerCase() == 'men' 
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$bidAmount Pnts',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 220, 20, 20),
                    ),
                  ),
                  Text(
                    'Sold',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    playerCategory.toLowerCase() == 'women' || playerCategory.toLowerCase() == 'female' || playerCategory.toLowerCase() == 'woman'
                        ? 'Drafted' 
                        : 'Drafted',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _getTeamPlayers(String teamId, String? category) async {
    final googleSheetsService = GoogleSheetsService();
    try {
      print('TeamFormationPage: Getting players for team $teamId, category: $category');
      
      // Get all players and auction history
      final allPlayers = await googleSheetsService.getPlayers();
      final auctionHistory = await googleSheetsService.getAuctionHistory();
      
      // Filter players by team_id and category
      final teamPlayers = allPlayers.where((player) {
        final playerTeamId = player['team_id']?.toString() ?? '';
        final playerStatus = (player['status'] ?? '').toString().trim();
        
        // Player must belong to this team and have a status (sold/drafted)
        if (playerTeamId != teamId || playerStatus.isEmpty || playerStatus.toLowerCase() == 'null') {
          return false;
        }
        
        // If category is specified, filter by category
        if (category != null) {
          final playerCategory = (player['category'] ?? '').toString().toLowerCase();
          final targetCategory = category.toLowerCase();
          return playerCategory == targetCategory || 
                 (targetCategory == 'men' && (playerCategory == 'male' || playerCategory == 'man')) ||
                 (targetCategory == 'women' && (playerCategory == 'female' || playerCategory == 'woman')) ||
                 (targetCategory == 'kids' && (playerCategory == 'children' || playerCategory == 'child'));
        }
        
        return true;
      }).toList();
      
      // Merge auction history data with player data
      final enrichedPlayers = teamPlayers.map((player) {
        final playerName = player['name']?.toString() ?? '';
        final playerId = player['player_id']?.toString() ?? '';
        
        // Find the winning bid for this player from auction history
        final winningBid = auctionHistory.firstWhere(
          (bid) => (
            (bid['player_id']?.toString() ?? '') == playerName || 
            (bid['player_id']?.toString() ?? '') == playerId
          ) && 
          (bid['is_winning_bid'] == true || bid['is_winning_bid'] == 'true'),
          orElse: () => <String, dynamic>{},
        );
        
        // Create enriched player data
        final enrichedPlayer = Map<String, dynamic>.from(player);
        if (winningBid.isNotEmpty) {
          enrichedPlayer['bid_amount'] = winningBid['bid_amount'] ?? 0;
        } else {
          enrichedPlayer['bid_amount'] = player['base_price'] ?? 0; // Fallback to base_price
        }
        
        return enrichedPlayer;
      }).toList();
      
      print('TeamFormationPage: Found ${enrichedPlayers.length} players for team $teamId');
      return enrichedPlayers;
    } catch (e) {
      print('TeamFormationPage: Error getting team players: $e');
      return [];
    }
  }

  Widget _buildStatsTab() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    
    return DefaultTabController(
      length: 3,
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 8.0 : 16.0),
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
            const SizedBox(height: 16),
            
            // Tab Bar for Men, Women, and Kids categories
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey[600],
                indicator: BoxDecoration(
                  color: const Color.fromARGB(255, 220, 20, 20),
                  borderRadius: BorderRadius.circular(8),
                ),
                isScrollable: true,
                tabAlignment: TabAlignment.center,
                tabs: [
                  Tab(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Men Stats', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Tab(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Women Stats', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Tab(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Kids Stats', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Tab Bar View for content
            Expanded(
              child: TabBarView(
                children: [
                  _buildCategoryStatsSection('Men'),
                  _buildCategoryStatsSection('Women'),
                  _buildCategoryStatsSection('Kids'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryStatsSection(String category) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;
    final isTablet = screenWidth > 450 && screenWidth <= 800;
    
    return FutureBuilder<Map<String, dynamic>>(
      future: _getCategoryAuctionStats(category),
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
              'Error loading $category statistics: ${snapshot.error}',
              style: TextStyle(color: Colors.red[600]),
            ),
          );
        }
        
        final stats = snapshot.data ?? {};
        
        if (stats.isEmpty || (stats['total_players'] ?? 0) == 0) {
          return _buildEmptyStatsMessage(category);
        }
        
        final totalPlayers = stats['total_players'] ?? 0;
        final playersSold = stats['players_sold'] ?? 0;
        final teamsWithPlayers = stats['teams_with_players'] ?? 0;
        
        // Create different stat cards based on category
        List<Widget> statCards = [
          _buildStatCard('Total Players', totalPlayers.toString(), Icons.people, category),
          _buildStatCard(
            category.toLowerCase() == 'men' ? 'Players Sold' : 'Players Drafted', 
            playersSold.toString(), 
            Icons.check_circle, 
            category
          ),
          _buildStatCard('Teams w/ Players', teamsWithPlayers.toString(), Icons.groups, category),
        ];
        
        // Add different stats for Men category
        if (category.toLowerCase() == 'men') {
          statCards.addAll([
            _buildClickableHighestBidCard(category),
          ]);
        }
        
        return SingleChildScrollView(
          child: GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: isDesktop ? 3 : (isTablet ? 2 : 2),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: isDesktop ? 1.8 : (isTablet ? 1.5 : 1.2),
            children: statCards,
          ),
        );
      },
    );
  }

  Widget _buildEmptyStatsMessage(String category) {
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
                    Icons.bar_chart,
                    size: 80,
                    color: const Color.fromARGB(255, 220, 20, 20).withOpacity(0.6),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '📊 No $category Stats Yet',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 220, 20, 20),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No $category players have been auctioned yet.\nStats will appear once the auction begins!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildClickableHighestBidCard(String? category) {
    return GestureDetector(
      onTap: () => _showTopPlayersPerTeam(category),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(255, 220, 20, 20).withOpacity(0.1),
                Colors.white,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.trending_up,
                  size: 32,
                  color: const Color.fromARGB(255, 220, 20, 20),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap to View',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 220, 20, 20),
                  ),
                ),
                Text(
                  'Top Players\nper Team',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, [String? category]) {
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

  Widget _buildMenAuctionSection() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    
    return Card(
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 8 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Auction Queue - Men Category',
              style: TextStyle(
                fontSize: isMobile ? 16 : 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 220, 20, 20),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Players available - Men',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _getAuctionQueue(),
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
                        'Error loading auction queue: ${snapshot.error}',
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  
                  final auctionQueue = snapshot.data ?? [];
                  
                  if (auctionQueue.isEmpty) {
                    return Center(
                      child: Text(
                        'All Men category players have been sold!',
                        style: TextStyle(
                          fontSize: isMobile ? 14 : 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }
                  
                  return ListView.builder(
                    itemCount: auctionQueue.length,
                    itemBuilder: (context, index) {
                      final player = auctionQueue[index];
                      return ListTile(
                        leading: PhotoService.buildSimpleAvatar(
                          playerName: player['name'] ?? 'Unknown',
                          photoUrl: player['photo_url'],
                          backgroundColor: const Color.fromARGB(255, 247, 183, 7),
                          radius: 20,
                        ),
                        title: Text(
                          player['name'],
                          style: TextStyle(fontSize: isMobile ? 14 : 16),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Proficiency: ${player['proficiency'] ?? 'Not specified'}',
                              style: TextStyle(fontSize: isMobile ? 10 : 12, color: Colors.grey[600]),
                            ),
                            Text(
                              'Base Price: ${player['basePrice']} Pnts',
                              style: TextStyle(fontSize: isMobile ? 10 : 12, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                        trailing: Text(
                          '${index + 1}',
                          style: TextStyle(fontSize: isMobile ? 12 : 14),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWomenDraftSection() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    
    return Card(
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 12 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Draft Queue - Women Category',
              style: TextStyle(
                fontSize: isMobile ? 16 : 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 220, 20, 20),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Players available - Women',
              style: TextStyle(
                fontSize: isMobile ? 10 : 12,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _getDraftQueue(),
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
                        'Error loading draft queue: ${snapshot.error}',
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  
                  final draftQueue = snapshot.data ?? [];
                  
                  if (draftQueue.isEmpty) {
                    return Center(
                      child: Text(
                        'All Women category players have been drafted!',
                        style: TextStyle(
                          fontSize: isMobile ? 14 : 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }
                  
                  return ListView.builder(
                    itemCount: draftQueue.length,
                    itemBuilder: (context, index) {
                      final player = draftQueue[index];
                      return ListTile(
                        leading: PhotoService.buildSimpleAvatar(
                          playerName: player['name'] ?? 'Unknown',
                          photoUrl: player['photo_url'],
                          backgroundColor: const Color.fromARGB(255, 247, 183, 7),
                          radius: 20,
                        ),
                        title: Text(
                          player['name'],
                          style: TextStyle(fontSize: isMobile ? 14 : 16),
                        ),
                        subtitle: Text(
                          'Proficiency: ${player['proficiency'] ?? 'Not specified'}',
                          style: TextStyle(fontSize: isMobile ? 10 : 12, color: Colors.grey[600]),
                        ),
                        trailing: Text(
                          '${index + 1}',
                          style: TextStyle(fontSize: isMobile ? 12 : 14),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKidsDraftSection() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    
    return Card(
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 12 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Draft Queue - Kids Category',
              style: TextStyle(
                fontSize: isMobile ? 16 : 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 220, 20, 20),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Players available - Kids',
              style: TextStyle(
                fontSize: isMobile ? 10 : 12,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _getKidsDraftQueue(),
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
                        'Error loading kids draft queue: ${snapshot.error}',
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  
                  final kidsDraftQueue = snapshot.data ?? [];
                  
                  if (kidsDraftQueue.isEmpty) {
                    return Center(
                      child: Text(
                        'All Kids category players have been drafted!',
                        style: TextStyle(
                          fontSize: isMobile ? 14 : 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }
                  
                  return ListView.builder(
                    itemCount: kidsDraftQueue.length,
                    itemBuilder: (context, index) {
                      final player = kidsDraftQueue[index];
                      return ListTile(
                        leading: PhotoService.buildSimpleAvatar(
                          playerName: player['name'] ?? 'Unknown',
                          photoUrl: player['photo_url'],
                          backgroundColor: const Color.fromARGB(255, 247, 183, 7),
                          radius: 20,
                        ),
                        title: Text(
                          player['name'],
                          style: TextStyle(fontSize: isMobile ? 14 : 16),
                        ),
                        subtitle: Text(
                          'Proficiency: ${player['proficiency'] ?? 'Not specified'}',
                          style: TextStyle(fontSize: isMobile ? 10 : 12, color: Colors.grey[600]),
                        ),
                        trailing: Text(
                          '${index + 1}',
                          style: TextStyle(fontSize: isMobile ? 12 : 14),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to sort players by proficiency order and then by name
  List<Map<String, dynamic>> _sortPlayersByProficiencyAndName(List<Map<String, dynamic>> players) {
    // Define proficiency order for Men: Advanced, Intermediate+, Intermediate, Beginner
    // For Women/Kids: only Intermediate, Beginner are used
    const proficiencyOrder = {
      'advanced': 1,
      'intermediate+': 2,
      'intermediate': 3,
      'beginner': 4,
    };
    
    players.sort((a, b) {
      final proficiencyA = (a['proficiency'] ?? '').toString().toLowerCase().trim();
      final proficiencyB = (b['proficiency'] ?? '').toString().toLowerCase().trim();
      final nameA = (a['name'] ?? '').toString().toLowerCase();
      final nameB = (b['name'] ?? '').toString().toLowerCase();
      
      // Get proficiency order values (default to 5 for unknown proficiency)
      final orderA = proficiencyOrder[proficiencyA] ?? 5;
      final orderB = proficiencyOrder[proficiencyB] ?? 5;
      
      // First sort by proficiency order
      if (orderA != orderB) {
        return orderA.compareTo(orderB);
      }
      
      // Then sort by name within the same proficiency
      return nameA.compareTo(nameB);
    });
    
    return players;
  }

  Future<List<Map<String, dynamic>>> _getAuctionQueue() async {
    final googleSheetsService = GoogleSheetsService();
    try {
      print('TeamFormationPage: Getting auction queue (Men category players with null/blank status)...');
      final allPlayers = await googleSheetsService.getPlayers();
      print('TeamFormationPage: Found ${allPlayers.length} total players');
      
      // Filter for Men category with null or blank status
      final menAvailablePlayers = allPlayers.where((player) {
        final category = (player['category'] ?? '').toString().toLowerCase();
        final status = (player['status'] ?? '').toString().trim();
        final isMenCategory = category == 'men' || category == 'male' || category == 'man';
        final isAvailable = status.isEmpty || status.toLowerCase() == 'null';
        return isMenCategory && isAvailable;
      }).toList();
      
      print('TeamFormationPage: Filtered to ${menAvailablePlayers.length} available Men category players');
      
      // Transform player data to match auction queue format
      final transformedPlayers = menAvailablePlayers.map((player) => {
        'name': player['name'] ?? 'Unknown Player',
        'basePrice': player['base_price']?.toString() ?? '0',
        'player_id': player['player_id'] ?? '',
        'category': player['category'] ?? '',
        'proficiency': player['proficiency'] ?? '',
        'status': player['status'] ?? '',
      }).toList();
      
      // Sort by proficiency order and then by name
      return _sortPlayersByProficiencyAndName(transformedPlayers);
    } catch (e) {
      print('TeamFormationPage: Error getting auction queue: $e');
      // Fallback to sample Men players if there's an error
      return [
        {'name': 'Suresh Rao', 'basePrice': '6,000', 'category': 'Men'},
        {'name': 'Vikram Singh', 'basePrice': '5,500', 'category': 'Men'},
        {'name': 'Rajesh Kumar', 'basePrice': '7,000', 'category': 'Men'},
        {'name': 'Amit Sharma', 'basePrice': '4,500', 'category': 'Men'},
      ];
    }
  }

  Future<List<Map<String, dynamic>>> _getDraftQueue() async {
    final googleSheetsService = GoogleSheetsService();
    try {
      print('TeamFormationPage: Getting draft queue (Women category players with null/blank status)...');
      final allPlayers = await googleSheetsService.getPlayers();
      print('TeamFormationPage: Found ${allPlayers.length} total players');
      
      // Filter for Women category with null or blank status
      final womenAvailablePlayers = allPlayers.where((player) {
        final category = (player['category'] ?? '').toString().toLowerCase();
        final status = (player['status'] ?? '').toString().trim();
        final isWomenCategory = category == 'women' || category == 'female' || category == 'woman';
        final isAvailable = status.isEmpty || status.toLowerCase() == 'null';
        return isWomenCategory && isAvailable;
      }).toList();
      
      print('TeamFormationPage: Filtered to ${womenAvailablePlayers.length} available Women category players');
      
      // Transform player data to match draft queue format
      final transformedPlayers = womenAvailablePlayers.map((player) => {
        'name': player['name'] ?? 'Unknown Player',
        'basePrice': player['base_price']?.toString() ?? '0',
        'player_id': player['player_id'] ?? '',
        'category': player['category'] ?? '',
        'proficiency': player['proficiency'] ?? '',
        'status': player['status'] ?? '',
      }).toList();
      
      // Sort by proficiency order and then by name
      return _sortPlayersByProficiencyAndName(transformedPlayers);
    } catch (e) {
      print('TeamFormationPage: Error getting draft queue: $e');
      // Fallback to sample Women players if there's an error
      return [
        {'name': 'Priya Sharma', 'basePrice': '5,000', 'category': 'Women'},
        {'name': 'Anita Desai', 'basePrice': '4,500', 'category': 'Women'},
        {'name': 'Kavya Nair', 'basePrice': '6,000', 'category': 'Women'},
        {'name': 'Meera Reddy', 'basePrice': '5,500', 'category': 'Women'},
      ];
    }
  }

  Future<List<Map<String, dynamic>>> _getKidsDraftQueue() async {
    final googleSheetsService = GoogleSheetsService();
    try {
      print('TeamFormationPage: Getting kids draft queue (Kids category players with null/blank status)...');
      final allPlayers = await googleSheetsService.getPlayers();
      print('TeamFormationPage: Found ${allPlayers.length} total players');
      
      // Filter for Kids category with null or blank status
      final kidsAvailablePlayers = allPlayers.where((player) {
        final category = (player['category'] ?? '').toString().toLowerCase();
        final status = (player['status'] ?? '').toString().trim();
        final isKidsCategory = category == 'kids' || category == 'kid' || category == 'children' || category == 'child';
        final isAvailable = status.isEmpty || status.toLowerCase() == 'null';
        return isKidsCategory && isAvailable;
      }).toList();
      
      print('TeamFormationPage: Filtered to ${kidsAvailablePlayers.length} available Kids category players');
      
      // Transform player data to match draft queue format
      final transformedPlayers = kidsAvailablePlayers.map((player) => {
        'name': player['name'] ?? 'Unknown Player',
        'basePrice': player['base_price']?.toString() ?? '0',
        'player_id': player['player_id'] ?? '',
        'category': player['category'] ?? '',
        'proficiency': player['proficiency'] ?? '',
        'status': player['status'] ?? '',
      }).toList();
      
      // Sort by proficiency order and then by name
      return _sortPlayersByProficiencyAndName(transformedPlayers);
    } catch (e) {
      print('TeamFormationPage: Error getting kids draft queue: $e');
      // Fallback to sample Kids players if there's an error
      return [
        {'name': 'Arjun Kumar', 'basePrice': '2,000', 'category': 'Kids'},
        {'name': 'Sneha Rao', 'basePrice': '1,500', 'category': 'Kids'},
        {'name': 'Ravi Sharma', 'basePrice': '2,500', 'category': 'Kids'},
        {'name': 'Ananya Singh', 'basePrice': '1,800', 'category': 'Kids'},
      ];
    }
  }

  Future<Map<String, dynamic>> _getCategoryAuctionStats(String category) async {
    final googleSheetsService = GoogleSheetsService();
    try {
      print('TeamFormationPage: Getting $category auction statistics...');
      
      // Get all players and filter by category
      final allPlayers = await googleSheetsService.getPlayers();
      final categoryPlayers = allPlayers.where((player) {
        final playerCategory = (player['category'] ?? '').toString().toLowerCase();
        final targetCategory = category.toLowerCase();
        return playerCategory == targetCategory || 
               (targetCategory == 'men' && (playerCategory == 'male' || playerCategory == 'man')) ||
               (targetCategory == 'women' && (playerCategory == 'female' || playerCategory == 'woman')) ||
               (targetCategory == 'kids' && (playerCategory == 'children' || playerCategory == 'child'));
      }).toList();
      
      if (categoryPlayers.isEmpty) {
        return {
          'total_players': 0,
          'players_sold': 0,
          'avg_price': 0,
          'teams_with_players': 0,
          'highest_bid': 0,
          'total_revenue': 0,
        };
      }
      
      // Calculate statistics for this category
      final totalPlayers = categoryPlayers.length;
      final soldPlayers = categoryPlayers.where((player) {
        final status = (player['status'] ?? '').toString().trim();
        return status.isNotEmpty && status.toLowerCase() != 'null';
      }).toList();
      
      final playersSold = soldPlayers.length;
      
      // Calculate prices from sold players
      final prices = soldPlayers.map((player) {
        return int.tryParse(player['base_price']?.toString() ?? '0') ?? 0;
      }).where((price) => price > 0).toList();
      
      final totalRevenue = prices.fold(0, (sum, price) => sum + price);
      final avgPrice = prices.isEmpty ? 0 : (totalRevenue / prices.length).round();
      final highestBid = prices.isEmpty ? 0 : prices.reduce((a, b) => a > b ? a : b);
      
      // Count teams that have players from this category
      final teamsWithPlayers = soldPlayers
          .map((player) => player['team_id']?.toString() ?? '')
          .where((teamId) => teamId.isNotEmpty)
          .toSet()
          .length;
      
      final stats = {
        'total_players': totalPlayers,
        'players_sold': playersSold,
        'avg_price': avgPrice,
        'teams_with_players': teamsWithPlayers,
        'highest_bid': highestBid,
        'total_revenue': totalRevenue,
      };
      
      print('TeamFormationPage: $category auction stats: $stats');
      return stats;
    } catch (e) {
      print('TeamFormationPage: Error getting $category auction stats: $e');
      return {
        'total_players': 0,
        'players_sold': 0,
        'avg_price': 0,
        'teams_with_players': 0,
        'highest_bid': 0,
        'total_revenue': 0,
      };
    }
  }

  Future<List<Map<String, dynamic>>> _getTeams() async {
    final googleSheetsService = GoogleSheetsService();
    try {
      print('TeamFormationPage: Starting to fetch teams...');
      final teams = await googleSheetsService.getTeams();
      print('TeamFormationPage: Fetched ${teams.length} teams');
      
      // Add detailed logging for debugging
      if (teams.isEmpty) {
        print('TeamFormationPage: No teams found - will show Auction Day Awaits');
      } else {
        print('TeamFormationPage: Teams data available - ${teams.length} teams found');
        for (int i = 0; i < teams.length && i < 3; i++) {
          print('TeamFormationPage: Team ${i + 1}: ${teams[i]}');
        }
      }
      
      return teams;
    } catch (e) {
      print('TeamFormationPage: Error fetching teams: $e');
      print('TeamFormationPage: Stack trace: ${StackTrace.current}');
      return []; // Return empty list to show "Auction Day Awaits" message
    }
  }

  Future<List<Map<String, dynamic>>> _getCategoryTeams(String category) async {
    final googleSheetsService = GoogleSheetsService();
    try {
      print('TeamFormationPage: Getting $category teams...');
      
      // Get all teams and players with explicit null safety
      final allTeams = await googleSheetsService.getTeams();
      final allPlayers = await googleSheetsService.getPlayers();
      
      // Validate data is not empty
      if (allTeams.isEmpty || allPlayers.isEmpty) {
        print('TeamFormationPage: Empty data received from GoogleSheetsService');
        return [];
      }
      
      // Filter players by category with explicit type casting
      final categoryPlayers = allPlayers.where((player) {
        final playerCategory = (player['category'] ?? '').toString().toLowerCase().trim();
        final targetCategory = category.toLowerCase().trim();
        return playerCategory == targetCategory || 
               (targetCategory == 'men' && (playerCategory == 'male' || playerCategory == 'man')) ||
               (targetCategory == 'women' && (playerCategory == 'female' || playerCategory == 'woman')) ||
               (targetCategory == 'kids' && (playerCategory == 'children' || playerCategory == 'child'));
      }).toList();
      
      // Calculate category-specific player counts for each team with type safety
      final teamsWithCategoryData = allTeams.map((team) {
        final teamId = (team['team_id'] ?? '').toString().trim();
        
        // Get players in this team for this category with explicit type checking
        final teamCategoryPlayers = categoryPlayers.where((player) {
          final playerTeamId = (player['team_id'] ?? '').toString().trim();
          final playerStatus = (player['status'] ?? '').toString().trim();
          return playerTeamId == teamId && playerStatus.isNotEmpty && playerStatus.toLowerCase() != 'null';
        }).toList();
        
        final categoryPlayersInTeam = teamCategoryPlayers.length;
        
        // Calculate proficiency counts based on category
        int advancedCount = 0;
        int intermediatePlusCount = 0;
        int intermediateCount = 0;
        int beginnerCount = 0;
        
        for (final player in teamCategoryPlayers) {
          final proficiency = (player['proficiency'] ?? '').toString().toLowerCase().trim();
          
          if (category.toLowerCase() == 'men') {
            // Men have 4 proficiency levels: Advanced, Intermediate+, Intermediate, Beginner
            if (proficiency == 'advanced' || proficiency == 'adv') {
              advancedCount++;
            } else if (proficiency == 'intermediate+' || proficiency == 'int+') {
              intermediatePlusCount++;
            } else if (proficiency == 'intermediate' || proficiency == 'int') {
              intermediateCount++;
            } else if (proficiency == 'beginner' || proficiency == 'beg') {
              beginnerCount++;
            }
          } else {
            // Women and Kids have 2 proficiency levels: Intermediate, Beginner
            if (proficiency == 'intermediate' || proficiency == 'int') {
              intermediateCount++;
            } else if (proficiency == 'beginner' || proficiency == 'beg') {
              beginnerCount++;
            }
          }
        }
        
        // Use spent budget from teams sheet instead of calculating from player prices with type safety
        final categorySpentBudget = category.toLowerCase() == 'men' 
            ? (int.tryParse((team['spent_budget'] ?? 0).toString()) ?? 0)  // Use actual spent_budget from teams sheet for Men
            : 0;  // Women and Kids don't have budget tracking
        
        return <String, dynamic>{
          ...team,
          'category_player_count': categoryPlayersInTeam,
          'category_spent_budget': categorySpentBudget,
          'advanced_count': advancedCount,
          'intermediate_plus_count': intermediatePlusCount,
          'intermediate_count': intermediateCount,
          'beginner_count': beginnerCount,
        };
      }).where((team) => (team['category_player_count'] ?? 0) > 0).toList(); // Only show teams with players in this category
      
      print('TeamFormationPage: Found ${teamsWithCategoryData.length} teams with $category players');
      return teamsWithCategoryData;
    } catch (e) {
      print('TeamFormationPage: Error fetching $category teams: $e');
      return [];
    }
  }

  Future<void> _showTopPlayersPerTeam(String? category) async {
    final googleSheetsService = GoogleSheetsService();
    
    try {
      // Get all teams and players
      final allTeams = await googleSheetsService.getTeams();
      final allPlayers = await googleSheetsService.getPlayers();
      
      // Filter players by category (Men only)
      final categoryPlayers = allPlayers.where((player) {
        final playerCategory = (player['category'] ?? '').toString().toLowerCase();
        final targetCategory = 'men';
        return playerCategory == targetCategory || 
               playerCategory == 'male' || 
               playerCategory == 'man';
      }).toList();
      
      // Build team data with top 2 players
      List<Map<String, dynamic>> teamData = [];
      
      for (final team in allTeams) {
        final teamId = team['team_id']?.toString() ?? '';
        final teamName = team['team_name']?.toString() ?? 'Unknown Team';
        
        // Get players in this team for this category
        final teamCategoryPlayers = categoryPlayers.where((player) {
          final playerTeamId = player['team_id']?.toString() ?? '';
          final playerStatus = (player['status'] ?? '').toString().trim();
          return playerTeamId == teamId && playerStatus.isNotEmpty && playerStatus.toLowerCase() != 'null';
        }).toList();
        
        if (teamCategoryPlayers.isNotEmpty) {
          // Sort players by base price (descending) to get top players
          teamCategoryPlayers.sort((a, b) {
            final priceA = int.tryParse(a['base_price']?.toString() ?? '0') ?? 0;
            final priceB = int.tryParse(b['base_price']?.toString() ?? '0') ?? 0;
            return priceB.compareTo(priceA);
          });
          
          // Get top 2 players
          final topPlayers = teamCategoryPlayers.take(2).toList();
          
          teamData.add({
            'team_name': teamName,
            'top_players': topPlayers,
          });
        }
      }
      
      // Sort teams by team name
      teamData.sort((a, b) => a['team_name'].compareTo(b['team_name']));
      
      // Show dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          final screenWidth = MediaQuery.of(context).size.width;
          final screenHeight = MediaQuery.of(context).size.height;
          final isMobile = screenWidth < 600;
          
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Container(
              width: isMobile ? screenWidth * 0.95 : screenWidth * 0.7,
              height: isMobile ? screenHeight * 0.85 : screenHeight * 0.75,
              constraints: BoxConstraints(
                maxWidth: 600,
                maxHeight: 700,
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Top 2 Players per Team - Men',
                          style: TextStyle(
                            fontSize: isMobile ? 16 : 20,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 220, 20, 20),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: teamData.length,
                      itemBuilder: (context, index) {
                        final team = teamData[index];
                        final teamName = team['team_name'];
                        final topPlayers = team['top_players'] as List<Map<String, dynamic>>;
                        
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  teamName,
                                  style: TextStyle(
                                    fontSize: isMobile ? 14 : 16,
                                    fontWeight: FontWeight.bold,
                                    color: const Color.fromARGB(255, 220, 20, 20),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                ...topPlayers.asMap().entries.map((entry) {
                                  final playerIndex = entry.key;
                                  final player = entry.value;
                                  final playerName = player['name'] ?? 'Unknown';
                                  final basePrice = player['base_price']?.toString() ?? '0';
                                  final proficiency = player['proficiency']?.toString() ?? '';
                                  
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 24,
                                          height: 24,
                                          decoration: BoxDecoration(
                                            color: playerIndex == 0 
                                                ? Colors.amber 
                                                : Colors.grey[400],
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${playerIndex + 1}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                playerName,
                                                style: TextStyle(
                                                  fontSize: isMobile ? 12 : 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                '$basePrice Pnts • $proficiency',
                                                style: TextStyle(
                                                  fontSize: isMobile ? 10 : 12,
                                                  color: Colors.grey[600],
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      print('Error showing top players per team: $e');
      // Show error dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to load team data. Please try again.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}