# Flutter Web Setup Guide

## Prerequisites
- Flutter SDK 3.0.0 or higher
- Chrome browser (for development)
- Code editor (VS Code recommended)

## Installation Steps

### 1. Install Flutter SDK
```bash
# Download Flutter SDK from https://flutter.dev/docs/get-started/install
# Extract and add to your PATH

# Verify installation
flutter doctor
```

### 2. Enable Web Support
```bash
# Enable web support
flutter config --enable-web

# Verify web devices are available
flutter devices
```

### 3. Project Setup
```bash
cd flutter_web

# Get all dependencies
flutter pub get

# Clean previous builds
flutter clean
```

### 4. Development Server
```bash
# Run development server
flutter run -d chrome --web-port 8080

# Or specify a different port
flutter run -d chrome --web-port 3000
```

## Key Dependencies

### UI and Design
- `responsive_framework`: Responsive design across devices
- `google_fonts`: Custom typography with Noto Sans Kannada
- `animated_text_kit`: Text animations for better UX

### State Management  
- `provider`: Simple state management
- `bloc/flutter_bloc`: Advanced state management option

### API and HTTP
- `http`: HTTP requests to Flask API
- `dio`: Advanced HTTP client with interceptors

### Google Services
- `googleapis`: Google Sheets API integration
- `google_sign_in`: Authentication (optional)

### Utilities
- `intl`: Internationalization and date formatting
- `shared_preferences`: Local storage
- `url_launcher`: Open external links

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── pages/                    # Screen widgets
│   └── home_page.dart
├── services/                 # API and external services
│   ├── api_service.dart
│   └── google_sheets_service.dart
└── widgets/                  # Reusable UI components
    ├── navbar.dart
    ├── hero_section.dart
    ├── events_section.dart
    └── footer.dart
```

## Configuration

### Assets
Update `pubspec.yaml` to include your assets:
```yaml
flutter:
  assets:
    - assets/images/
    - assets/icons/
    - assets/data/
```

### Fonts
Add Kannada fonts for proper text rendering:
```yaml
fonts:
  - family: Kannada
    fonts:
      - asset: assets/fonts/NotoSansKannada-Regular.ttf
      - asset: assets/fonts/NotoSansKannada-Bold.ttf
        weight: 700
```

## Building for Production

### Development Build
```bash
flutter build web --debug
```

### Production Build  
```bash
# Build optimized version
flutter build web --release

# Build with specific base href
flutter build web --base-href /kannada-rajyotsava/

# Output will be in build/web/
```

## Common Issues and Solutions

### 1. CORS Issues
If you encounter CORS errors when connecting to the Flask API:
- Ensure Flask-CORS is properly configured
- Check that the API URL is correct
- Use a proxy during development if needed

### 2. Font Loading Issues
- Ensure font files are in the correct directory
- Check `pubspec.yaml` font configuration
- Restart the development server after font changes

### 3. Asset Loading Issues
- Verify asset paths in `pubspec.yaml`
- Run `flutter clean` and `flutter pub get`
- Check browser console for 404 errors

## Testing

### Run Tests
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widget_test.dart

# Run tests with coverage
flutter test --coverage
```

### Integration Testing
```bash
# Run integration tests
flutter drive --target=test_driver/app.dart
```

## Development Tips

### Hot Reload
- Use `r` in terminal to hot reload
- Use `R` to hot restart
- Changes to `main.dart` require hot restart

### Debugging
- Use browser developer tools
- Add `print()` statements for debugging
- Use Flutter Inspector in VS Code

### Performance
- Use `const` constructors where possible
- Optimize image sizes
- Minimize widget rebuilds

## VS Code Extensions

Recommended extensions for Flutter development:
- Flutter
- Dart
- Flutter Tree
- Bracket Pair Colorizer
- Material Icon Theme

## Useful Commands

```bash
# Check for updates
flutter upgrade

# Analyze code quality
flutter analyze

# Format code
flutter format .

# Clean build cache
flutter clean

# Get package dependencies
flutter pub get

# Upgrade packages
flutter pub upgrade

# Check outdated packages
flutter pub outdated
```