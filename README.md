# DE Karnataka Rajyotsava Badminton Tournament

A Flutter web application for managing badminton tournaments with direct Google Sheets integration.

## 🎯 Project Overview

This project creates a web platform for managing badminton tournaments including player registration, team formation, match scheduling, and live updates. The application features:

- **Flutter Web Frontend**: Responsive web interface optimized for tournament management
- **Google Sheets Integration**: Direct CSV-based integration with Google Sheets for data management
- **Real-time Updates**: Live data synchronization from Google Sheets
- **Tournament Management**: Complete tournament lifecycle management

## 🏗️ Project Structure

```
DEKannadaRajyotsava/
├── flutter_web/          # Flutter web application
│   ├── lib/
│   │   ├── main.dart      # Application entry point
│   │   ├── pages/         # UI pages
│   │   │   ├── home_page.dart
│   │   │   ├── player_roster_page.dart
│   │   │   ├── team_formation_page.dart
│   │   │   └── battle_day_page.dart
│   │   ├── services/      # Business logic
│   │   │   └── google_sheets_service.dart
│   │   └── widgets/       # Reusable components
│   │       └── navigation/
│   ├── web/               # Web configuration
│   ├── assets/images/     # Tournament images and logos
│   └── pubspec.yaml       # Dependencies
├── shared/                # Documentation
│   ├── complete_setup_guide.md
│   └── google_sheets_setup.md
├── docs/                  # Project documentation
│   ├── deployment.md
│   └── flutter_setup.md
├── run_flutter.bat        # Quick start script
└── README.md
```
```

## 🚀 Quick Start

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Google Cloud Console account
- Git

### 1. Clone the Repository

```bash
git clone <repository-url>
cd DEKannadaRajyotsava
```

### 2. Set Up Flutter Web

```bash
cd flutter_web

# Get dependencies
flutter pub get

# Run the web application
flutter run -d chrome --web-port 8080
```

### 3. Set Up Flask API

```bash
cd flask_api

# Create virtual environment
python -m venv venv

# Activate virtual environment
# Windows:
venv\Scripts\activate
# macOS/Linux:
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Set up environment variables
copy .env.example .env
# Edit .env with your Google Sheets configuration

# Run the Flask application
python app.py
```

### 4. Configure Google Sheets

Follow the detailed instructions in `shared/google_sheets_setup.md` to:
1. Create a Google Sheets document
2. Set up the required sheets structure
3. Create a Google Service Account
4. Configure authentication

## 🌟 Features

### Frontend (Flutter Web)
- **Responsive Design**: Works on desktop, tablet, and mobile
- **Kannada Language Support**: Native Kannada fonts and text
- **Modern UI**: Material Design with Karnataka's cultural colors
- **Interactive Elements**: Animations and smooth transitions
- **Event Management**: Browse and register for events
- **Cultural Programs**: Showcase traditional performances

### Backend (Flask API)
- **RESTful API**: Standard HTTP methods for data operations
- **Google Sheets Integration**: Direct database operations
- **CORS Support**: Cross-origin requests enabled
- **Error Handling**: Comprehensive error responses
- **Logging**: Detailed logging for debugging

### Database (Google Sheets)
- **Events Management**: Store and manage event information
- **Registration System**: Track event registrations
- **Cultural Programs**: Manage performance schedules
- **Easy Administration**: Non-technical users can manage data

## 📱 API Endpoints

### Events
- `GET /api/events` - Get all events
- `POST /api/events` - Create new event
- `PUT /api/events/<id>` - Update event
- `DELETE /api/events/<id>` - Delete event

### Registrations
- `GET /api/registrations` - Get all registrations
- `POST /api/registrations` - Create new registration

### Cultural Programs
- `GET /api/cultural-programs` - Get all cultural programs

## 🎨 Design Principles

### Color Scheme
- **Primary**: Orange (#FF9933) - Represents the Karnataka flag
- **Secondary**: Green (#128807) - Karnataka flag green
- **Accent**: White (#FFFFFF) - Purity and peace

### Typography
- **Primary Font**: Noto Sans Kannada - For Kannada text
- **Secondary Font**: Google Fonts - For English text

### Cultural Elements
- Karnataka map illustrations
- Traditional patterns and motifs
- Cultural symbols and icons

## 🛠️ Development

### Flutter Development

```bash
cd flutter_web

# Run in development mode
flutter run -d chrome --web-port 8080

# Build for production
flutter build web --release

# Analyze code
flutter analyze

# Run tests
flutter test
```

### Flask Development

```bash
cd flask_api

# Run in development mode
export FLASK_ENV=development
python app.py

# Run with auto-reload
flask run --debug

# Install new dependencies
pip install <package-name>
pip freeze > requirements.txt
```

## 📦 Deployment

### Frontend Deployment
- Build the Flutter web app: `flutter build web`
- Deploy the `build/web` directory to any static hosting service
- Popular options: Firebase Hosting, Netlify, Vercel

### Backend Deployment
- Deploy to cloud platforms like Heroku, Google Cloud Run, or AWS
- Set environment variables for production
- Use gunicorn for production WSGI server

### Environment Variables

Create a `.env` file in the `flask_api` directory:

```env
FLASK_APP=app.py
FLASK_ENV=production
GOOGLE_SPREADSHEET_ID=your_spreadsheet_id
GOOGLE_SERVICE_ACCOUNT_JSON=your_service_account_json
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature-name`
3. Commit your changes: `git commit -am 'Add feature'`
4. Push to the branch: `git push origin feature-name`
5. Submit a pull request

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Government of Karnataka for cultural heritage information
- Flutter and Google teams for excellent development tools
- Open source community for various packages and libraries

## 📞 Support

For support and questions:
- Create an issue in the repository
- Contact the development team
- Check the documentation in the `docs/` directory

---

**Made with ❤️ for Karnataka's Cultural Heritage**