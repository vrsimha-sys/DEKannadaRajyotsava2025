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
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16), // Increased padding since we have more space
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Player Avatar with photo support
            _buildPlayerAvatar(player, proficiency),
            const SizedBox(height: 16), // Increased spacing

            // Player Name
            Flexible(
              child: Text(
                player['name'] ?? 'Unknown',
                style: const TextStyle(
                  fontSize: 16, // Increased font size
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 220, 20, 20),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 12), // Increased spacing

            // Flat Number
            Text(
              'Flat: ${player['flat_number'] ?? 'N/A'}',
              style: TextStyle(
                fontSize: 16, // Increased font size for better readability
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
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
    // Enhanced null safety and validation
    final photoUrlRaw = player['photo_url']?.toString();
    final photoUrl = photoUrlRaw?.trim();
    final playerName = player['name'] ?? 'Unknown';
    
    // Debug logging for Harish Nayak specifically
    if (playerName.toLowerCase().contains('harish')) {
      print('=== DEBUG: Harish Nayak Photo Data ===');
      print('Player name: $playerName');
      print('Raw photo_url: $photoUrlRaw');
      print('Trimmed photo_url: $photoUrl');
      print('Player data keys: ${player.keys.toList()}');
      print('===================================');
    }
    
    final hasValidPhoto = photoUrl != null && 
                         photoUrl.isNotEmpty && 
                         photoUrl != 'null' && 
                         photoUrl != 'N/A' &&
                         photoUrl.startsWith('http');

    if (playerName.toLowerCase().contains('harish')) {
      print('Harish hasValidPhoto: $hasValidPhoto');
    }

    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: hasValidPhoto ? null : LinearGradient(
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
      child: ClipOval(
        child: hasValidPhoto
            ? Image.network(
                _convertToDirectImageUrl(photoUrl),
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return _buildPlaceholderAvatar(proficiency, isLoading: true);
                },
                errorBuilder: (context, error, stackTrace) {
                  print('Error loading image for $playerName: $error');
                  if (playerName.toLowerCase().contains('harish')) {
                    print('Harish image URL that failed: ${_convertToDirectImageUrl(photoUrl)}');
                  }
                  return _buildPlaceholderAvatar(proficiency);
                },
              )
            : _buildPlaceholderAvatar(proficiency),
      ),
    );
  }

  Widget _buildPlaceholderAvatar(String proficiency, {bool isLoading = false}) {
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
      ),
      child: isLoading 
          ? const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : const Icon(
              Icons.person,
              color: Colors.white,
              size: 30,
            ),
    );
  }

  String _convertToDirectImageUrl(String originalUrl) {
    try {
      // Additional validation
      if (originalUrl.isEmpty || !originalUrl.startsWith('http')) {
        return originalUrl;
      }
      
      // Test with Harish's specific URL
      if (originalUrl.contains('1LaJCkLQWaJkHDYrzBAUNFLDGT3vvht1M')) {
        print('Converting Harish URL: $originalUrl');
      }
      
      // Convert Google Drive sharing URL to direct image URL
      if (originalUrl.contains('drive.google.com/file/d/')) {
        final parts = originalUrl.split('/d/');
        if (parts.length > 1) {
          final fileId = parts[1].split('/')[0];
          if (fileId.isNotEmpty) {
            final directUrl = 'https://drive.google.com/uc?export=view&id=$fileId';
            if (originalUrl.contains('1LaJCkLQWaJkHDYrzBAUNFLDGT3vvht1M')) {
              print('Harish converted URL: $directUrl');
            }
            return directUrl;
          }
        }
      }
      // Convert Google Drive sharing URLs with different formats
      else if (originalUrl.contains('drive.google.com') && originalUrl.contains('id=')) {
        try {
          final uri = Uri.parse(originalUrl);
          final fileId = uri.queryParameters['id'];
          if (fileId != null && fileId.isNotEmpty) {
            return 'https://drive.google.com/uc?export=view&id=$fileId';
          }
        } catch (e) {
          print('Error parsing Google Drive URL: $e');
        }
      }
      
      // Return original URL if it's already in the correct format or from another source
      return originalUrl;
    } catch (e) {
      print('Error converting image URL: $e');
      return originalUrl;
    }
  }
}