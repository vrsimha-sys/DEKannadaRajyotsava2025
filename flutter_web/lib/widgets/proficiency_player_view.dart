import 'package:flutter/material.dart';

class ProficiencyPlayerView extends StatefulWidget {
  final List<Map<String, dynamic>> players;
  final String category;

  const ProficiencyPlayerView({
    super.key,
    required this.players,
    required this.category,
  });

  @override
  State<ProficiencyPlayerView> createState() => _ProficiencyPlayerViewState();
}

class _ProficiencyPlayerViewState extends State<ProficiencyPlayerView>
    with SingleTickerProviderStateMixin {
  late TabController _proficiencyTabController;
  late List<String> availableProficiencyLevels;

  final List<String> allProficiencyLevels = [
    'Advanced',
    'Intermediate+',
    'Intermediate',
    'Beginner'
  ];

  @override
  void initState() {
    super.initState();
    // Sort players alphabetically
    widget.players.sort((a, b) {
      final nameA = (a['name'] ?? '').toString().toLowerCase();
      final nameB = (b['name'] ?? '').toString().toLowerCase();
      return nameA.compareTo(nameB);
    });
    
    // Get only proficiency levels that have players
    availableProficiencyLevels = _getAvailableProficiencyLevels();
    _proficiencyTabController = TabController(length: availableProficiencyLevels.length, vsync: this);
  }

  @override
  void dispose() {
    _proficiencyTabController.dispose();
    super.dispose();
  }

  List<String> _getAvailableProficiencyLevels() {
    return allProficiencyLevels.where((level) {
      return widget.players.any((player) {
        final playerProficiency = player['proficiency']?.toString() ?? '';
        return playerProficiency.toLowerCase() == level.toLowerCase();
      });
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // If no proficiency levels have players, show empty state
    if (availableProficiencyLevels.isEmpty) {
      return _buildNoProficiencyState();
    }

    return Column(
      children: [
        // Proficiency Level Tabs
        Container(
          color: Colors.grey[50],
          child: TabBar(
            controller: _proficiencyTabController,
            tabs: availableProficiencyLevels.map((level) => Tab(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(level),
              ),
            )).toList(),
            labelColor: const Color.fromARGB(255, 220, 20, 20),
            unselectedLabelColor: Colors.grey[600],
            indicatorColor: const Color.fromARGB(255, 220, 20, 20),
            indicatorWeight: 2,
            labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold), // Reduced font size
            unselectedLabelStyle: const TextStyle(fontSize: 10), // Reduced font size
            isScrollable: false, // Ensure tabs fit the screen
          ),
        ),

        // Proficiency Level Content
        Expanded(
          child: TabBarView(
            controller: _proficiencyTabController,
            children: availableProficiencyLevels.map((level) {
              final playersAtLevel = _getPlayersAtProficiencyLevel(level);
              return _buildProficiencyView(level, playersAtLevel);
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildNoProficiencyState() {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.people_outline,
                size: 80,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'No ${widget.category} players registered yet',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Player registrations will appear here when available',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getPlayersAtProficiencyLevel(String proficiency) {
    final players = widget.players.where((player) {
      final playerProficiency = player['proficiency']?.toString() ?? '';
      return playerProficiency.toLowerCase() == proficiency.toLowerCase();
    }).toList();
    
    // Sort players alphabetically by name
    players.sort((a, b) {
      final nameA = (a['name'] ?? '').toString().toLowerCase();
      final nameB = (b['name'] ?? '').toString().toLowerCase();
      return nameA.compareTo(nameB);
    });
    
    return players;
  }

  Widget _buildProficiencyView(String proficiency, List<Map<String, dynamic>> players) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;
    final crossAxisCount = isDesktop ? 4 : (screenWidth > 600 ? 3 : 2);

    return Padding(
      padding: const EdgeInsets.all(12.0), // Reduced padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with count and proficiency info
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12), // Reduced padding
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(255, 247, 183, 7).withOpacity(0.1),
                  const Color.fromARGB(255, 220, 20, 20).withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color.fromARGB(255, 220, 20, 20).withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _getProficiencyIcon(proficiency),
                  color: const Color.fromARGB(255, 220, 20, 20),
                  size: 18, // Reduced icon size
                ),
                const SizedBox(width: 8),
                Expanded( // Make text responsive
                  child: Text(
                    '${widget.category} - $proficiency (${players.length})',
                    style: const TextStyle(
                      fontSize: 16, // Reduced font size
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 220, 20, 20),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                if (players.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), // Reduced padding
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 220, 20, 20),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${players.length} Players',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10, // Reduced font size
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12), // Reduced spacing

          // Players Grid
          Expanded(
            child: players.isEmpty
                ? _buildEmptyProficiencyState(proficiency)
                : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.85, // Adjusted for cleaner cards
                    ),
                    itemCount: players.length,
                    itemBuilder: (context, index) {
                      return _buildPlayerCard(players[index], proficiency);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerCard(Map<String, dynamic> player, String proficiency) {
    final status = player['status']?.toString().trim() ?? '';
    final isStatusNotBlank = status.isNotEmpty && status.toLowerCase() != 'null';
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(12), // Reduced padding to give more space
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              _getProficiencyColor(proficiency).withOpacity(0.05),
            ],
          ),
          border: Border.all(
            color: _getProficiencyColor(proficiency).withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start, // Changed from center to start
          mainAxisSize: MainAxisSize.min, // Added to minimize space usage
          children: [
            // Player Avatar with photo support
            _buildPlayerAvatar(player, proficiency),
            const SizedBox(height: 12), // Reduced spacing

            // Player Name
            Text(
              player['name'] ?? 'Unknown',
              style: const TextStyle(
                fontSize: 14, // Reduced font size to fit more content
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 220, 20, 20),
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8), // Reduced spacing

            // Flat Number
            Text(
              'Flat: ${player['flat_number'] ?? 'N/A'}',
              style: TextStyle(
                fontSize: 13, // Reduced font size
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            
            // Additional information based on status and category
            if (isStatusNotBlank) ...[
              const SizedBox(height: 6), // Reduced spacing
              
              // Status
              Text(
                'Status: $status',
                style: TextStyle(
                  fontSize: 12, // Reduced font size
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              
              // For Men: Show Selling Price only when status is "Sold"
              if (widget.category.toLowerCase() == 'men' && status.toLowerCase() == 'sold') ...[
                const SizedBox(height: 3), // Reduced spacing
                Text(
                  'Price: ${player['selling_price'] ?? 'N/A'} Pnts', // Shortened label
                  style: TextStyle(
                    fontSize: 12, // Reduced font size
                    color: Colors.green[600],
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              
              // Team Name (for all categories when status is not blank)
              const SizedBox(height: 3), // Reduced spacing
              Text(
                'Team: ${player['team_name'] ?? 'N/A'}',
                style: TextStyle(
                  fontSize: 12, // Reduced font size
                  color: Colors.blue[600],
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyProficiencyState(String proficiency) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getProficiencyIcon(proficiency),
                size: 60, // Reduced size
                color: Colors.grey[400],
              ),
              const SizedBox(height: 12), // Reduced spacing
              Text(
                'No $proficiency players in ${widget.category}',
                style: TextStyle(
                  fontSize: 16, // Reduced font size
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6), // Reduced spacing
              Text(
                'Players with $proficiency skill level will appear here',
                style: TextStyle(
                  fontSize: 12, // Reduced font size
                  color: Colors.grey[500],
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getProficiencyColor(String proficiency) {
    switch (proficiency.toLowerCase()) {
      case 'advanced':
        return Colors.red[600]!;
      case 'intermediate+':
        return Colors.orange[600]!;
      case 'intermediate':
        return Colors.blue[600]!;
      case 'beginner':
        return Colors.green[600]!;
      default:
        return Colors.grey[600]!;
    }
  }

  IconData _getProficiencyIcon(String proficiency) {
    switch (proficiency.toLowerCase()) {
      case 'advanced':
        return Icons.star;
      case 'intermediate+':
        return Icons.trending_up;
      case 'intermediate':
        return Icons.sports_tennis;
      case 'beginner':
        return Icons.sports;
      default:
        return Icons.help_outline;
    }
  }

  Widget _buildPlayerAvatar(Map<String, dynamic> player, String proficiency) {
    final playerName = player['name'] ?? 'Unknown';
    
    // Extract initials from player name
    final nameParts = playerName.trim().split(' ');
    String initials = '';
    
    if (nameParts.isNotEmpty) {
      // Take first letter of first name
      if (nameParts[0].isNotEmpty) {
        initials += nameParts[0][0].toUpperCase();
      }
      
      // Take first letter of last name if available
      if (nameParts.length > 1 && nameParts[nameParts.length - 1].isNotEmpty) {
        initials += nameParts[nameParts.length - 1][0].toUpperCase();
      }
    }
    
    // Fallback to 'U' if no valid initials
    if (initials.isEmpty) {
      initials = 'U';
    }

    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            _getProficiencyColor(proficiency),
            _getProficiencyColor(proficiency).withOpacity(0.7),
          ],
        ),
        border: Border.all(
          color: _getProficiencyColor(proficiency),
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}