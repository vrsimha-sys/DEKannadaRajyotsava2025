import 'package:flutter/material.dart';

class PhotoService {
  /// Converts Google Drive sharing URL to CORS-friendly thumbnail URL
  /// 
  /// Handles various Google Drive URL formats and converts to thumbnail API
  /// which doesn't have CORS restrictions for web applications.
  /// 
  /// Returns: https://drive.google.com/thumbnail?id={FILE_ID}&sz=w200-h200
  static String? convertGoogleDriveUrl(String? url) {
    if (url == null || url.isEmpty) {
      return null;
    }

    // Clean the URL
    final cleanUrl = url.trim();
    
    // Check if it's already a thumbnail or uc link
    if (cleanUrl.contains('drive.google.com/thumbnail') || 
        cleanUrl.contains('lh3.googleusercontent.com')) {
      return cleanUrl;
    }

    // Extract file ID from various Google Drive URL formats
    String? fileId;

    // Format: https://drive.google.com/file/d/{FILE_ID}/view?usp=sharing
    final fileViewRegex = RegExp(r'drive\.google\.com/file/d/([a-zA-Z0-9_-]+)');
    final fileViewMatch = fileViewRegex.firstMatch(cleanUrl);
    if (fileViewMatch != null) {
      fileId = fileViewMatch.group(1);
    }

    // Format: https://drive.google.com/open?id={FILE_ID}
    if (fileId == null) {
      final openRegex = RegExp(r'drive\.google\.com/open\?id=([a-zA-Z0-9_-]+)');
      final openMatch = openRegex.firstMatch(cleanUrl);
      if (openMatch != null) {
        fileId = openMatch.group(1);
      }
    }

    // Format: Direct ID extraction from various patterns
    if (fileId == null) {
      final idRegex = RegExp(r'[&?]id=([a-zA-Z0-9_-]+)');
      final idMatch = idRegex.firstMatch(cleanUrl);
      if (idMatch != null) {
        fileId = idMatch.group(1);
      }
    }

    // If we found a file ID, return the CORS-friendly thumbnail URL
    if (fileId != null && fileId.isNotEmpty) {
      // Use thumbnail API which doesn't have CORS restrictions
      return 'https://drive.google.com/thumbnail?id=$fileId&sz=w200-h200';
    }

    // If it looks like it might be a direct image URL, return as-is
    if (cleanUrl.toLowerCase().contains('.jpg') || 
        cleanUrl.toLowerCase().contains('.jpeg') || 
        cleanUrl.toLowerCase().contains('.png') || 
        cleanUrl.toLowerCase().contains('.gif') ||
        cleanUrl.toLowerCase().contains('.webp')) {
      return cleanUrl;
    }

    return null;
  }

  /// Builds a player avatar widget with photo support
  /// Falls back to initials if photo fails to load
  static Widget buildPlayerAvatar({
    required Map<String, dynamic> player,
    required String proficiency,
    required Color proficiencyColor,
    double size = 60,
    double fontSize = 18,
  }) {
    final playerName = player['name'] ?? 'Unknown';
    final photoUrl = convertGoogleDriveUrl(player['photo_url']);

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

  /// Builds the fallback initials avatar
  static Widget _buildInitialsAvatar(String initials, Color proficiencyColor, double fontSize) {
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
        child: Text(
          initials,
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
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

  /// Simple avatar builder for cases where we just need a CircleAvatar
  static Widget buildSimpleAvatar({
    required String playerName,
    String? photoUrl,
    required Color backgroundColor,
    double radius = 20,
  }) {
    final directUrl = convertGoogleDriveUrl(photoUrl);
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

    // Fallback to initials
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor,
      child: Text(
        initials,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}