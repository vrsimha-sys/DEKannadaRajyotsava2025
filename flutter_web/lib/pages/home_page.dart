import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 247, 183, 7), // Karnataka flag yellow
                Color.fromARGB(255, 220, 20, 20), // Karnataka flag red
              ],
              stops: [0.0, 1.0],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 
                            MediaQuery.of(context).padding.top - 
                            MediaQuery.of(context).padding.bottom,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    child: Column(
                      children: [
                        BadmintonTitleWithLogos(),
                        const SizedBox(height: 20),
                        ResponsiveLogoImage(),
                        const SizedBox(height: 20),
                        TeamTableCard(),
                        const Spacer(),
                        FooterWidget(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ResponsiveTitle extends StatelessWidget {
  const ResponsiveTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;
    final isTablet = screenWidth > 450 && screenWidth <= 800;

    // Responsive font sizes - adjusted for better mobile display
    double kannadaFontSize = isDesktop ? 56 : (isTablet ? 38 : 22);
    double englishFontSize = isDesktop ? 48 : (isTablet ? 32 : 18);

    // Responsive padding - reduced for mobile
    EdgeInsets padding = EdgeInsets.symmetric(
      horizontal: isDesktop ? 40 : (isTablet ? 25 : 15),
      vertical: isDesktop ? 20 : (isTablet ? 15 : 8),
    );

    return Container(
      width: double.infinity,
      padding: padding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // DE Badminton - moved to top
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'DE Badminton',
              style: TextStyle(
                fontSize: englishFontSize,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                shadows: const [
                  Shadow(
                    offset: Offset(2, 2),
                    blurRadius: 4,
                    color: Colors.black54,
                  ),
                ],
                letterSpacing: screenWidth <= 450 ? 0.8 : 1.2,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
          ),
          
          SizedBox(height: isDesktop ? 16 : (isTablet ? 12 : 6)),
          
          // Main Kannada Title
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'ಕನ್ನಡ ರಾಜ್ಯೋತ್ಸವ ಕಪ್ - ೨೦೨೫',
              style: TextStyle(
                fontSize: kannadaFontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: const [
                  Shadow(
                    offset: Offset(3, 3),
                    blurRadius: 6,
                    color: Colors.black54,
                  ),
                ],
                letterSpacing: screenWidth <= 450 ? 1.0 : 1.5,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
          ),
          
          SizedBox(height: isDesktop ? 16 : (isTablet ? 12 : 6)),
          
          // English Title
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Kannada Rajyotsava Cup - 2025',
              style: TextStyle(
                fontSize: englishFontSize,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                shadows: const [
                  Shadow(
                    offset: Offset(2, 2),
                    blurRadius: 4,
                    color: Colors.black54,
                  ),
                ],
                letterSpacing: screenWidth <= 450 ? 0.8 : 1.2,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class BadmintonTitleWithLogos extends StatelessWidget {
  const BadmintonTitleWithLogos({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;
    final isTablet = screenWidth > 450 && screenWidth <= 800;
    final isMobile = screenWidth <= 450;

    // Responsive logo sizes - reduced desktop size
    double logoSize = isMobile ? 50 : (isTablet ? 80 : 70);
    
    // Responsive spacing - reduced to bring logos closer to title
    double logoSpacing = isMobile ? 8 : (isTablet ? 12 : 8);
    
    // Responsive font sizes - reduced desktop sizes
    double kannadaFontSize = isDesktop ? 42 : (isTablet ? 38 : 22);
    double englishFontSize = isDesktop ? 36 : (isTablet ? 32 : 18);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 40 : (isTablet ? 25 : 15),
        vertical: isDesktop ? 20 : (isTablet ? 15 : 8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left badminton logo - now visible on all screen sizes
          Image.asset(
            'assets/images/badminton_logo_left.png',
            width: logoSize,
            height: logoSize,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              print('Error loading left logo: $error');
              return Container(
                width: logoSize,
                height: logoSize,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.sports,
                        color: Colors.white,
                        size: logoSize * 0.4,
                      ),
                      Text(
                        'B',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: logoSize * 0.3,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          SizedBox(width: logoSpacing),
          
          // Center titles
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // DE Badminton
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'DE Badminton',
                    style: TextStyle(
                      fontSize: englishFontSize,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      shadows: const [
                        Shadow(
                          offset: Offset(2, 2),
                          blurRadius: 4,
                          color: Colors.black54,
                        ),
                      ],
                      letterSpacing: screenWidth <= 450 ? 0.8 : 1.2,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                  ),
                ),
                
                SizedBox(height: isDesktop ? 16 : (isTablet ? 12 : 6)),
                
                // Main Kannada Title
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'ಕನ್ನಡ ರಾಜ್ಯೋತ್ಸವ ಕಪ್ - ೨೦೨೫',
                    style: TextStyle(
                      fontSize: kannadaFontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: const [
                        Shadow(
                          offset: Offset(3, 3),
                          blurRadius: 6,
                          color: Colors.black54,
                        ),
                      ],
                      letterSpacing: screenWidth <= 450 ? 1.0 : 1.5,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                  ),
                ),
                
                SizedBox(height: isDesktop ? 16 : (isTablet ? 12 : 6)),
                
                // English Title
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Kannada Rajyotsava Cup - 2025',
                    style: TextStyle(
                      fontSize: englishFontSize,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      shadows: const [
                        Shadow(
                          offset: Offset(2, 2),
                          blurRadius: 4,
                          color: Colors.black54,
                        ),
                      ],
                      letterSpacing: screenWidth <= 450 ? 0.8 : 1.2,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
          
          // Right badminton logo - now visible on all screen sizes
          SizedBox(width: logoSpacing),
          Image.asset(
            'assets/images/badminton_logo_right.png',
            width: logoSize,
            height: logoSize,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              print('Error loading right logo: $error');
              return Container(
                width: logoSize,
                height: logoSize,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.sports,
                        color: Colors.white,
                        size: logoSize * 0.4,
                      ),
                      Text(
                        'B',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: logoSize * 0.3,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;
    final isTablet = screenWidth > 450 && screenWidth <= 800;

    // Calculate footer font size as 25% of main title size, increased 50% for mobile/tablet
    double kannadaFontSize = isDesktop ? 14 : (isTablet ? 20 : 20); // Mobile: 5.5*1.5=8.25, Tablet: 9.5*1.5=14.25
    double englishFontSize = isDesktop ? 12 : (isTablet ? 18 : 18); // Mobile: 4.5*1.5=6.75, Tablet: 8*1.5=12

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 40 : (isTablet ? 25 : 15),
        vertical: isDesktop ? 15 : (isTablet ? 10 : 5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Kannada text
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'ನೆನಪುಗಳನ್ನು ರಚಿಸಿ ಮತ್ತು ನಿಮ್ಮ ಚಿಂತೆಗಳನ್ನು ಉಡಾಯಿಸಿ!',
              style: TextStyle(
                fontSize: kannadaFontSize,
                fontWeight: FontWeight.w500,
                color: Colors.white.withOpacity(0.9),
                shadows: const [
                  Shadow(
                    offset: Offset(1, 1),
                    blurRadius: 2,
                    color: Colors.black45,
                  ),
                ],
                letterSpacing: screenWidth <= 450 ? 0.5 : 0.8,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
          ),
          
          SizedBox(height: isDesktop ? 8 : (isTablet ? 6 : 3)),
          
          // English text
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Create Memories & Smash Your Worries',
              style: TextStyle(
                fontSize: englishFontSize,
                fontWeight: FontWeight.w400,
                color: Colors.white.withOpacity(0.9),
                shadows: const [
                  Shadow(
                    offset: Offset(1, 1),
                    blurRadius: 2,
                    color: Colors.black45,
                  ),
                ],
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class ResponsiveLogoImage extends StatelessWidget {
  const ResponsiveLogoImage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isDesktop = screenWidth > 800;
    final isTablet = screenWidth > 450 && screenWidth <= 800;
    final isMobile = screenWidth <= 450;

    // Responsive image sizing based on screen dimensions
    double imageWidth;
    double imageHeight;
    
    if (isMobile) {
      // Mobile: 60% of screen width, max 200px width, max 150px height
      imageWidth = (screenWidth * 0.6).clamp(100, 200);
      imageHeight = (screenHeight * 0.15).clamp(75, 150);
    } else if (isTablet) {
      // Tablet: 50% of screen width, max 300px width, max 225px height
      imageWidth = (screenWidth * 0.5).clamp(150, 300);
      imageHeight = (screenHeight * 0.2).clamp(112, 225);
    } else {
      // Desktop: reduced size - 25% of screen width, max 250px width, max 180px height
      imageWidth = (screenWidth * 0.25).clamp(150, 250);
      imageHeight = (screenHeight * 0.15).clamp(100, 180);
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 40 : (isTablet ? 25 : 15),
      ),
      child: Center(
        child: Image.asset(
          'assets/images/DE_Badminton_Rajyotsava_Logo.jpg',
          width: imageWidth,
          height: imageHeight,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            print('Error loading main logo: $error');
            print('StackTrace: $stackTrace');
            return Container(
              width: imageWidth,
              height: imageHeight,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.white.withOpacity(0.8),
                      size: imageHeight * 0.2,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Logo not found\nDE_Badminton_Rajyotsava_Logo.jpg',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: imageHeight * 0.06,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class TeamTableCard extends StatelessWidget {
  const TeamTableCard({super.key});

  final List<Map<String, String>> teamData = const [
    {
      'teamName': 'ಚಾಲುಕ್ಯ - Chalukya',
      'ownerName': 'Sudheer Somayaji',
      'ownerFlat': '321',
      'marqueePlayerName': 'Shashank D',
      'marqueePlayerFlat': '606',
    },
    {
      'teamName': 'ಹೊಯ್ಸಳ - Hoysala',
      'ownerName': 'Abbur Madhusudhan',
      'ownerFlat': '007',
      'marqueePlayerName': 'Prashanth H',
      'marqueePlayerFlat': '315',
    },
    {
      'teamName': 'ರಾಷ್ಟ್ರಕೂಟ - Rashtrakuta',
      'ownerName': 'Somshekhar',
      'ownerFlat': '015',
      'marqueePlayerName': 'Harisha K',
      'marqueePlayerFlat': '301',
    },
    
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;
    final isTablet = screenWidth > 600;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isDesktop ? 40 : (isTablet ? 20 : 16),
        vertical: 8,
      ),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                Colors.grey[50]!,
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(isDesktop ? 16 : 12),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      const Color.fromARGB(255, 247, 183, 7).withOpacity(0.1),
                      const Color.fromARGB(255, 220, 20, 20).withOpacity(0.1),
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.groups,
                      color: const Color.fromARGB(255, 220, 20, 20),
                      size: isDesktop ? 24 : 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Teams at Battlefield',
                      style: TextStyle(
                        fontSize: isDesktop ? 20 : 18,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 220, 20, 20),
                      ),
                    ),
                  ],
                ),
              ),

              // Table Content
              Padding(
                padding: EdgeInsets.all(isDesktop ? 16 : 12),
                child: isDesktop
                    ? _buildDesktopTable()
                    : _buildMobileCards(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopTable() {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(3),
        2: FlexColumnWidth(3),
      },
      children: [
        // Header Row
        TableRow(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          children: [
            _buildTableHeader('Team Name'),
            _buildTableHeader('Owner'),
            _buildTableHeader('Captain'),
          ],
        ),
        // Data Rows
        for (int i = 0; i < teamData.length; i++)
          TableRow(
            decoration: BoxDecoration(
              color: i.isEven ? Colors.white : Colors.grey[50],
            ),
            children: [
              _buildTableCell(teamData[i]['teamName']!, isTeamName: true),
              _buildPersonCell(
                teamData[i]['ownerName']!,
                teamData[i]['ownerFlat']!,
              ),
              _buildPersonCell(
                teamData[i]['marqueePlayerName']!,
                teamData[i]['marqueePlayerFlat']!,
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildMobileCards() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: teamData.map((team) => _buildTeamCard(team)).toList(),
    );
  }

  Widget _buildTeamCard(Map<String, String> team) {
    // Explicit null safety for all team data access
    final teamName = team['teamName']?.toString() ?? 'Unknown Team';
    final ownerName = team['ownerName']?.toString() ?? 'Unknown Owner';
    final ownerFlat = team['ownerFlat']?.toString() ?? '---';
    final marqueePlayerName = team['marqueePlayerName']?.toString() ?? 'Unknown Player';
    final marqueePlayerFlat = team['marqueePlayerFlat']?.toString() ?? '---';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color.fromARGB(255, 220, 20, 20).withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Team Name
          Text(
            teamName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 220, 20, 20),
            ),
          ),
          const SizedBox(height: 8),
          
          // Owner Info
          _buildPersonInfo('Owner', ownerName, ownerFlat),
          const SizedBox(height: 6),
          
          // Marquee Player Info
          _buildPersonInfo('Captain', marqueePlayerName, marqueePlayerFlat),
        ],
      ),
    );
  }

  Widget _buildPersonInfo(String label, String name, String flat) {
    // Explicit null safety for parameters
    final safeLabel = label.toString();
    final safeName = name.toString();
    final safeFlat = flat.toString();
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            '$safeLabel:',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                safeName,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Text(
                'Flat: $safeFlat',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 220, 20, 20),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTableCell(String text, {bool isTeamName = false}) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: isTeamName ? FontWeight.bold : FontWeight.w500,
          color: isTeamName 
              ? const Color.fromARGB(255, 220, 20, 20)
              : Colors.black87,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildPersonCell(String name, String flat) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            'Flat: $flat',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
