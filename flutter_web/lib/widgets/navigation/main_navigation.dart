import 'package:flutter/material.dart';
import '../../pages/home_page.dart';
import '../../pages/player_roster_page.dart';
import '../../pages/team_formation_page.dart';
import '../../pages/battle_day_page.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const PlayerRosterPage(),
    const TeamFormationPage(),
    const BattleDayPage(),
  ];

  final List<BottomNavigationBarItem> _navItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.people),
      label: 'Players',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.groups),
      label: 'Selection',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.sports),
      label: 'Matches',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isDesktop = screenWidth > 800;
    final isLandscape = screenWidth > screenHeight;
    
    // For mobile landscape (width < 800 but in landscape), use drawer instead of bottom nav
    final showBottomNav = !isDesktop && !isLandscape;
    final showAppBar = isDesktop || isLandscape;

    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: showBottomNav ? BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromARGB(255, 247, 183, 7),
        selectedItemColor: const Color.fromARGB(255, 220, 20, 20),
        unselectedItemColor: Colors.white,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: _navItems,
      ) : null,
      drawer: !isDesktop ? Drawer(
        child: _buildDrawerContent(),
      ) : null,
      appBar: showAppBar ? AppBar(
        backgroundColor: const Color.fromARGB(255, 247, 183, 7),
        elevation: 0,
        title: Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              screenWidth > 1200 ? 'DE Badminton - Kannada Rajyotsava Cup 2025' : 'DE Badminton Cup 2025',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        actions: isDesktop ? [
          _buildDesktopNavButton('Home', 0, Icons.home),
          _buildDesktopNavButton('Players', 1, Icons.people),
          _buildDesktopNavButton('Selection', 2, Icons.groups),
          _buildDesktopNavButton('Matches', 3, Icons.sports),
          const SizedBox(width: 20),
        ] : null,
      ) : null,
    );
  }

  Widget _buildDesktopNavButton(String label, int index, IconData icon) {
    final isSelected = _currentIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextButton.icon(
        onPressed: () {
          setState(() {
            _currentIndex = index;
          });
        },
        icon: Icon(
          icon,
          color: isSelected ? const Color.fromARGB(255, 220, 20, 20) : Colors.white,
        ),
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color.fromARGB(255, 220, 20, 20) : Colors.white,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        style: TextButton.styleFrom(
          backgroundColor: isSelected ? Colors.white.withOpacity(0.2) : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerContent() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 247, 183, 7),
            Color.fromARGB(255, 220, 20, 20),
          ],
        ),
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DE Badminton',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Kannada Rajyotsava Cup',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '2025',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem('Home', 0, Icons.home),
          _buildDrawerItem('Player Roster', 1, Icons.people),
          _buildDrawerItem('Team Formation', 2, Icons.groups),
          _buildDrawerItem('Battle Day', 3, Icons.sports),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(String title, int index, IconData icon) {
    final isSelected = _currentIndex == index;
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? const Color.fromARGB(255, 220, 20, 20) : Colors.white,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? const Color.fromARGB(255, 220, 20, 20) : Colors.white,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: Colors.white.withOpacity(0.2),
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
        Navigator.pop(context);
      },
    );
  }
}