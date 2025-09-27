import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/google_sheets_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

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

class TeamTableCard extends StatefulWidget {
  const TeamTableCard({super.key});

  @override
  State<TeamTableCard> createState() => _TeamTableCardState();
}

class _TeamTableCardState extends State<TeamTableCard> {
  List<Map<String, dynamic>> teamData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTeamData();
  }

  Future<void> _loadTeamData() async {
    try {
      final googleSheetsService = GoogleSheetsService();
      final teams = await googleSheetsService.getTeams();
      
      setState(() {
        teamData = teams;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading team data: $e');
      setState(() {
        isLoading = false;
        // Fallback to hardcoded data
        teamData = [
          {
            'team_id': 'Chalukya',
            'team_name': 'ಚಾಲುಕ್ಯ - Chalukya',
            'captain_id': 'Harish Nayak',
          },
          {
            'team_id': 'Hoysala', 
            'team_name': 'ಹೊಯ್ಸಳ - Hoysala',
            'captain_id': 'Prashanth H',
          },
          {
            'team_id': 'Rashtrakuta',
            'team_name': 'ರಾಷ್ಟ್ರಕೂಟ - Rashtrakuta', 
            'captain_id': 'Harisha K',
          },
        ];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;
    final isTablet = screenWidth > 600;

    if (isLoading) {
      return Container(
        margin: EdgeInsets.symmetric(
          horizontal: isDesktop ? 40 : (isTablet ? 20 : 16),
          vertical: 8,
        ),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            height: 200,
            child: const Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 220, 20, 20),
              ),
            ),
          ),
        ),
      );
    }

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
        0: FlexColumnWidth(3),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(2),
        3: FlexColumnWidth(2),
        4: FlexColumnWidth(1),
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
            _buildTableHeader('Owner Flat'),
            _buildTableHeader('Captain'),
            _buildTableHeader('Export'),
          ],
        ),
        // Data Rows
        for (int i = 0; i < teamData.length; i++)
          TableRow(
            decoration: BoxDecoration(
              color: i.isEven ? Colors.white : Colors.grey[50],
            ),
            children: [
              _buildTableCell(teamData[i]['team_name']?.toString() ?? 'Unknown Team', isTeamName: true),
              _buildTableCell(teamData[i]['owner']?.toString() ?? 'TBA', isTeamName: false),
              _buildTableCell(teamData[i]['owner_flat']?.toString() ?? 'TBA', isTeamName: false),
              _buildTableCell('${teamData[i]['captain_id']?.toString() ?? 'TBA'} (Flat: ${teamData[i]['captain_flat']?.toString() ?? 'TBA'})', isTeamName: false),
              _buildExportCell(teamData[i]),
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

  Widget _buildTeamCard(Map<String, dynamic> team) {
    // Explicit null safety for all team data access
    final teamName = team['team_name']?.toString() ?? 'Unknown Team';
    final captainName = team['captain_id']?.toString() ?? 'Unknown Captain';
    
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
          // Team Name and Export Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildTeamNameWithKannada(teamName),
              ),
              IconButton(
                onPressed: () => _exportTeamToPDF(team),
                icon: const Icon(Icons.picture_as_pdf),
                tooltip: 'Export Team Details to PDF',
                color: const Color.fromARGB(255, 220, 20, 20),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // Owner Info
          _buildPersonInfo('Owner', team['owner']?.toString() ?? 'TBA', team['owner_flat']?.toString() ?? 'TBA'),
          const SizedBox(height: 8),
          
          // Captain Info  
          _buildPersonInfo('Captain', captainName, team['captain_flat']?.toString() ?? 'TBA'),
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
      child: isTeamName ? _buildTeamNameWithKannada(text) : Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
  
  Widget _buildTeamNameWithKannada(String teamName) {
    // Extract English and Kannada parts if available
    String englishName = teamName;
    String kannadaName = '';
    
    // If team name contains both scripts, try to separate them
    // This is a simple approach - you can enhance based on your data format
    if (_containsKannadaScript(teamName)) {
      // For now, display the original text in both fonts
      kannadaName = teamName;
    }
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (kannadaName.isNotEmpty) ...[
          Text(
            kannadaName,
            style: GoogleFonts.notoSansKannada(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 220, 20, 20),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
        ],
        Text(
          englishName,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 220, 20, 20),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
  
  bool _containsKannadaScript(String text) {
    // Check if text contains Kannada Unicode range (U+0C80–U+0CFF)
    return text.runes.any((rune) => rune >= 0x0C80 && rune <= 0x0CFF);
  }



  /// Builds export button cell for desktop table
  Widget _buildExportCell(Map<String, dynamic> team) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Center(
        child: IconButton(
          onPressed: () => _exportTeamToPDF(team),
          icon: const Icon(Icons.picture_as_pdf),
          tooltip: 'Export Team Details to PDF',
          color: const Color.fromARGB(255, 220, 20, 20),
        ),
      ),
    );
  }

  /// Exports comprehensive team details to PDF
  Future<void> _exportTeamToPDF(Map<String, dynamic> team) async {
    try {
      final teamId = team['team_id']?.toString() ?? '';
      final teamName = team['team_name']?.toString() ?? 'Unknown Team';
      final captainName = team['captain_id']?.toString() ?? 'Unknown Captain';
      final ownerName = team['owner']?.toString() ?? 'TBA';

      if (teamId.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid team data for export'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            color: Color.fromARGB(255, 220, 20, 20),
          ),
        ),
      );

      // Get complete team data
      final teamDetails = await _getCompleteTeamData(teamId);
      
      // Hide loading indicator
      Navigator.of(context).pop();

      final menPlayers = teamDetails['menPlayers'] ?? <Map<String, dynamic>>[];
      final womenPlayers = teamDetails['womenPlayers'] ?? <Map<String, dynamic>>[];
      final kidsPlayers = teamDetails['kidsPlayers'] ?? <Map<String, dynamic>>[];
      
      if (menPlayers.isEmpty && womenPlayers.isEmpty && kidsPlayers.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No players found for this team'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Generate PDF with separate pages for each category
      final pdf = pw.Document();
      
      // Add Men Team Page
      if (menPlayers.isNotEmpty) {
        pdf.addPage(
          _buildTeamPage(
            teamName: teamName,
            ownerName: ownerName,
            captainName: captainName,
            categoryTitle: 'Men Team',
            players: menPlayers,
            tableData: _buildMenTableData(menPlayers),
            headerColor: PdfColors.blue700,
            columnWidths: {
              0: const pw.FlexColumnWidth(3),
              1: const pw.FlexColumnWidth(2),
              2: const pw.FlexColumnWidth(2),
              3: const pw.FlexColumnWidth(2),
              4: const pw.FlexColumnWidth(2),
            },
          ),
        );
      }
      
      // Add Women Team Page
      if (womenPlayers.isNotEmpty) {
        pdf.addPage(
          _buildTeamPage(
            teamName: teamName,
            ownerName: ownerName,
            captainName: captainName,
            categoryTitle: 'Women Team',
            players: womenPlayers,
            tableData: _buildWomenKidsTableData(womenPlayers),
            headerColor: PdfColors.pink700,
            columnWidths: {
              0: const pw.FlexColumnWidth(4),
              1: const pw.FlexColumnWidth(3),
              2: const pw.FlexColumnWidth(2),
            },
          ),
        );
      }
      
      // Add Kids Team Page
      if (kidsPlayers.isNotEmpty) {
        pdf.addPage(
          _buildTeamPage(
            teamName: teamName,
            ownerName: ownerName,
            captainName: captainName,
            categoryTitle: 'Kids Team',
            players: kidsPlayers,
            tableData: _buildWomenKidsTableData(kidsPlayers),
            headerColor: PdfColors.orange700,
            columnWidths: {
              0: const pw.FlexColumnWidth(4),
              1: const pw.FlexColumnWidth(3),
              2: const pw.FlexColumnWidth(2),
            },
          ),
        );
      }

      // Save/Print PDF
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
        name: '${teamName.replaceAll(' ', '_')}_Complete_Details.pdf',
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PDF generated for $teamName'),
          backgroundColor: Colors.green,
        ),
      );

    } catch (e) {
      // Hide loading if still showing
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      
      print('Error exporting team PDF: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error generating PDF: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Gets complete team data organized by category with proper sorting
  Future<Map<String, List<Map<String, dynamic>>>> _getCompleteTeamData(String teamId) async {
    final googleSheetsService = GoogleSheetsService();
    
    try {
      // Get all players and auction history
      final allPlayers = await googleSheetsService.getPlayers();
      final auctionHistory = await googleSheetsService.getAuctionHistory();
      
      // Filter players by team
      final teamPlayers = allPlayers.where((player) {
        final playerTeamId = player['team_id']?.toString() ?? '';
        final playerStatus = (player['status'] ?? '').toString().trim();
        return playerTeamId == teamId && 
               playerStatus.isNotEmpty && 
               playerStatus.toLowerCase() != 'null';
      }).toList();

      // Merge auction data with player data
      final enrichedPlayers = teamPlayers.map((player) {
        final playerName = player['name']?.toString() ?? '';
        final playerId = player['player_id']?.toString() ?? '';
        
        // Find winning bid for this player
        final winningBid = auctionHistory.firstWhere(
          (bid) => (
            (bid['player_id']?.toString() ?? '') == playerName || 
            (bid['player_id']?.toString() ?? '') == playerId
          ) && 
          (bid['is_winning_bid'] == true || bid['is_winning_bid'] == 'true'),
          orElse: () => <String, dynamic>{},
        );
        
        final enrichedPlayer = Map<String, dynamic>.from(player);
        if (winningBid.isNotEmpty) {
          enrichedPlayer['bid_amount'] = winningBid['bid_amount'] ?? 0;
        } else {
          enrichedPlayer['bid_amount'] = player['base_price'] ?? 0;
        }
        
        return enrichedPlayer;
      }).toList();

      // Categorize and sort players
      final menPlayers = <Map<String, dynamic>>[];
      final womenPlayers = <Map<String, dynamic>>[];
      final kidsPlayers = <Map<String, dynamic>>[];

      for (final player in enrichedPlayers) {
        final category = (player['category'] ?? '').toString().toLowerCase();
        
        if (category == 'men' || category == 'male' || category == 'man') {
          menPlayers.add(player);
        } else if (category == 'women' || category == 'female' || category == 'woman') {
          womenPlayers.add(player);
        } else if (category == 'kids' || category == 'children' || category == 'child') {
          kidsPlayers.add(player);
        }
      }

      // Sort men by proficiency then by name, with bid amount priority
      _sortMenPlayers(menPlayers);
      
      // Sort women and kids by proficiency then by name
      _sortWomenKidsPlayers(womenPlayers);
      _sortWomenKidsPlayers(kidsPlayers);

      return {
        'menPlayers': menPlayers,
        'womenPlayers': womenPlayers,
        'kidsPlayers': kidsPlayers,
      };
    } catch (e) {
      print('Error getting complete team data: $e');
      return {
        'menPlayers': <Map<String, dynamic>>[],
        'womenPlayers': <Map<String, dynamic>>[],
        'kidsPlayers': <Map<String, dynamic>>[],
      };
    }
  }

  /// Sorts men players by proficiency order, then by name
  void _sortMenPlayers(List<Map<String, dynamic>> players) {
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
      
      final orderA = proficiencyOrder[proficiencyA] ?? 5;
      final orderB = proficiencyOrder[proficiencyB] ?? 5;
      
      if (orderA != orderB) {
        return orderA.compareTo(orderB);
      }
      
      return nameA.compareTo(nameB);
    });
  }

  /// Sorts women/kids players by proficiency order, then by name
  void _sortWomenKidsPlayers(List<Map<String, dynamic>> players) {
    const proficiencyOrder = {
      'intermediate': 1,
      'beginner': 2,
    };
    
    players.sort((a, b) {
      final proficiencyA = (a['proficiency'] ?? '').toString().toLowerCase().trim();
      final proficiencyB = (b['proficiency'] ?? '').toString().toLowerCase().trim();
      final nameA = (a['name'] ?? '').toString().toLowerCase();
      final nameB = (b['name'] ?? '').toString().toLowerCase();
      
      final orderA = proficiencyOrder[proficiencyA] ?? 3;
      final orderB = proficiencyOrder[proficiencyB] ?? 3;
      
      if (orderA != orderB) {
        return orderA.compareTo(orderB);
      }
      
      return nameA.compareTo(nameB);
    });
  }

  /// Builds table data for men players (with base and selling price)
  List<List<String>> _buildMenTableData(List<Map<String, dynamic>> players) {
    List<List<String>> tableData = [
      ['Player Name', 'Mobile Number', 'Proficiency', 'Base Price', 'Selling Price'],
    ];
    
    for (final player in players) {
      final name = (player['name'] ?? 'Unknown').toString();
      final phone = (player['phone'] ?? 'N/A').toString();
      final proficiency = (player['proficiency'] ?? 'N/A').toString();
      final basePrice = (player['base_price'] ?? 0).toString();
      final bidAmount = (player['bid_amount'] ?? player['base_price'] ?? 0).toString();
      
      tableData.add([
        name,
        phone,
        proficiency,
        '$basePrice Pnts',
        '$bidAmount Pnts',
      ]);
    }
    
    return tableData;
  }

  /// Builds table data for women/kids players (without pricing)
  List<List<String>> _buildWomenKidsTableData(List<Map<String, dynamic>> players) {
    List<List<String>> tableData = [
      ['Player Name', 'Mobile Number', 'Proficiency'],
    ];
    
    for (final player in players) {
      final name = (player['name'] ?? 'Unknown').toString();
      final phone = (player['phone'] ?? 'N/A').toString();
      final proficiency = (player['proficiency'] ?? 'N/A').toString();
      
      tableData.add([
        name,
        phone,
        proficiency,
      ]);
    }
    
    return tableData;
  }
  
  /// Builds a single team category page for PDF
  pw.Page _buildTeamPage({
    required String teamName,
    required String ownerName, 
    required String captainName,
    required String categoryTitle,
    required List<Map<String, dynamic>> players,
    required List<List<String>> tableData,
    required PdfColor headerColor,
    required Map<int, pw.TableColumnWidth> columnWidths,
  }) {
    return pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(40),
      build: (pw.Context context) {
        return [
          // Team Header
          pw.Header(
            level: 0,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  teamName,
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.red700,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  'Owner: $ownerName',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  'Captain: $captainName',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 30),
          
          // Category Title
          pw.Text(
            categoryTitle,
            style: pw.TextStyle(
              fontSize: 20,
              fontWeight: pw.FontWeight.bold,
              color: headerColor,
            ),
          ),
          pw.SizedBox(height: 15),
          
          // Players Table
          pw.TableHelper.fromTextArray(
            context: context,
            data: tableData,
            headerStyle: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.white,
            ),
            headerDecoration: pw.BoxDecoration(
              color: headerColor,
            ),
            cellStyle: const pw.TextStyle(fontSize: 12),
            cellHeight: 30,
            columnWidths: columnWidths,
          ),
          
          // Footer
          pw.Spacer(),
          pw.Text(
            'Generated on ${DateTime.now().toString().split('.')[0]}',
            style: pw.TextStyle(
              fontSize: 10,
              color: PdfColors.grey600,
            ),
          ),
        ];
      },
    );
  }
}
