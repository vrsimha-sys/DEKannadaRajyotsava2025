import 'package:flutter/material.dart';

class PhotoService {
  /// Converts photo URL for web-compatible format
  /// 
  /// For web platforms, Google Drive has CORS restrictions that prevent
  /// direct image loading. This method checks platform compatibility
  /// and only returns URLs for non-Google Drive sources or mobile apps.
  /// 
  /// Returns: Direct image URL or null if not web-compatible
  static String? convertGoogleDriveUrl(String? url) {
    if (url == null || url.isEmpty) {
      return null;
    }

    // Clean the URL
    final cleanUrl = url.trim();
    
    // For web platform, skip Google Drive URLs due to CORS restrictions
    // Google Drive blocks cross-origin requests from web browsers
    if (_isWebPlatform() && 
        (cleanUrl.contains('drive.google.com') || 
         cleanUrl.contains('docs.google.com'))) {
      print('Skipping Google Drive URL for web platform due to CORS: $cleanUrl');
      return null; // This will trigger fallback to initials
    }

    // Check if it's already a direct image URL (non-Google Drive)
    if (cleanUrl.contains('lh3.googleusercontent.com') ||
        cleanUrl.contains('images.') ||
        cleanUrl.toLowerCase().contains('.jpg') || 
        cleanUrl.toLowerCase().contains('.jpeg') || 
        cleanUrl.toLowerCase().contains('.png') || 
        cleanUrl.toLowerCase().contains('.gif') ||
        cleanUrl.toLowerCase().contains('.webp')) {
      return cleanUrl;
    }

    // For mobile apps, we could potentially handle Google Drive URLs
    // but for now, return null to use fallback initials
    return null;
  }

  /// Checks if running on web platform
  static bool _isWebPlatform() {
    // In Flutter Web, this will be true
    try {
      return identical(0, 0.0) == false; // This is a web detection trick
    } catch (e) {
      return false;
    }
  }

  /// Generates a unique color based on player name for consistent avatar colors
  static Color generatePlayerColor(String playerName) {
    // Create a hash from the player name for consistent color generation
    int hash = playerName.hashCode;
    
    // Generate HSL values for pleasant colors
    double hue = ((hash % 360).abs()).toDouble();
    double saturation = 0.6 + ((hash >> 8) % 20) / 100.0; // 0.6 to 0.8
    double lightness = 0.4 + ((hash >> 16) % 20) / 100.0; // 0.4 to 0.6
    
    return HSLColor.fromAHSL(1.0, hue, saturation, lightness).toColor();
  }

  /// Builds a player avatar widget with photo support
  /// For web platform: Always uses styled initials due to Google Drive CORS restrictions
  /// For mobile: Attempts to load photo, falls back to initials on failure
  static Widget buildPlayerAvatar({
    required Map<String, dynamic> player,
    required String proficiency,
    required Color proficiencyColor,
    double size = 60,
    double fontSize = 18,
  }) {
    final playerName = player['name'] ?? 'Unknown';
    // For web platform, skip trying to load Google Drive photos due to CORS
    final photoUrl = _isWebPlatform() ? null : convertGoogleDriveUrl(player['photo_url']);

    // Extract initials for fallback
    final initials = _extractInitials(playerName);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: proficiencyColor,
          width: 2,
        ),
      ),
      child: ClipOval(
        child: photoUrl != null && photoUrl.isNotEmpty
            ? Image.network(
                photoUrl,
                width: size,
                height: size,
                fit: BoxFit.cover,
                headers: {
                  'Accept': 'image/*',
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  // Show loading spinner while image loads
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          proficiencyColor,
                          proficiencyColor.withOpacity(0.7),
                        ],
                      ),
                    ),
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                        strokeWidth: 2,
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  // Fallback to initials if image fails to load (including CORS errors)
                  print('Failed to load image for ${player['name'] ?? 'Unknown'}: $error');
                  return _buildInitialsAvatar(initials, proficiencyColor, fontSize);
                },
              )
            : _buildInitialsAvatar(initials, proficiencyColor, fontSize),
      ),
    );
  }

  /// Builds the fallback initials avatar with enhanced styling
  static Widget _buildInitialsAvatar(String initials, Color proficiencyColor, double fontSize) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            proficiencyColor,
            proficiencyColor.withOpacity(0.8),
            proficiencyColor.withOpacity(0.6),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: proficiencyColor.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.3),
                offset: const Offset(1, 1),
                blurRadius: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Extracts initials from a player name
  static String _extractInitials(String playerName) {
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

    return initials;
  }

  /// Creates a beautiful initials avatar with consistent color generation
  static Widget buildInitialsAvatar(String playerName, {double radius = 20.0}) {
    final initials = _extractInitials(playerName);
    final color = generatePlayerColor(playerName);
    
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color,
            color.withOpacity(0.8),
            color.withOpacity(0.6),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            color: Colors.white,
            fontSize: radius * 0.7, // Scale font size to radius
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.3),
                offset: const Offset(1, 1),
                blurRadius: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Simple avatar builder for cases where we just need a CircleAvatar
  /// For web platform: Always uses initials due to Google Drive CORS restrictions
  static Widget buildSimpleAvatar({
    required String playerName,
    String? photoUrl,
    required Color backgroundColor,
    double radius = 20,
  }) {
    // For web platform, skip trying to load Google Drive photos due to CORS
    final directUrl = _isWebPlatform() ? null : convertGoogleDriveUrl(photoUrl);
    final initials = _extractInitials(playerName);

    if (directUrl != null && directUrl.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor,
        backgroundImage: NetworkImage(directUrl),
        onBackgroundImageError: (error, stackTrace) {
          print('Failed to load avatar for $playerName: $error');
          // CORS errors will automatically fall back to initials below
        },
        child: Image.network(
          directUrl,
          errorBuilder: (context, error, stackTrace) {
            // If network image fails (including CORS), show initials
            return Text(
              initials,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );
    }

    // Fallback to styled initials avatar
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            backgroundColor,
            backgroundColor.withOpacity(0.8),
            backgroundColor.withOpacity(0.6),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            color: Colors.white,
            fontSize: radius * 0.6, // Scale font size to radius
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.3),
                offset: const Offset(1, 1),
                blurRadius: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}