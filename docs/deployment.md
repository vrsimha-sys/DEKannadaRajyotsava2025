# Deployment Guide

## Local Development

### Prerequisites
- Flutter SDK 3.0+
- Python 3.8+
- Docker and Docker Compose (optional)
- Google Cloud account

### Quick Start
```bash
# 1. Set up Flutter web
cd flutter_web
flutter pub get
flutter run -d chrome --web-port 8080

# 2. Set up Flask API (in new terminal)
cd flask_api
python -m venv venv
venv\Scripts\activate  # Windows
source venv/bin/activate  # macOS/Linux
pip install -r requirements.txt
copy .env.example .env  # Configure your Google Sheets settings
python app.py
```

## Docker Deployment

### Build and Run
```bash
# Build Flutter web for production
cd flutter_web
flutter build web --release

# Run with Docker Compose
cd ..
docker-compose up --build
```

### Environment Setup
```bash
# Copy environment template
copy .env.example .env

# Edit .env with your Google Sheets configuration
# Set GOOGLE_SPREADSHEET_ID and GOOGLE_SERVICE_ACCOUNT_JSON
```

## Cloud Deployment Options

### 1. Firebase Hosting + Google Cloud Run

#### Flutter Web (Firebase Hosting)
```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login and initialize
firebase login
firebase init hosting

# Build and deploy
cd flutter_web
flutter build web --release
firebase deploy --only hosting
```

#### Flask API (Cloud Run)
```bash
# Build and deploy to Cloud Run
cd flask_api
gcloud run deploy kannada-rajyotsava-api \
  --source . \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated
```

### 2. Netlify + Heroku

#### Flutter Web (Netlify)
```bash
# Build the web app
cd flutter_web
flutter build web --release

# Deploy build/web folder to Netlify via:
# - Drag and drop to netlify.com
# - Connect GitHub repository
# - Use Netlify CLI
```

#### Flask API (Heroku)
```bash
# Create Heroku app
cd flask_api
heroku create kannada-rajyotsava-api

# Set environment variables
heroku config:set GOOGLE_SPREADSHEET_ID=your_id
heroku config:set GOOGLE_SERVICE_ACCOUNT_JSON='{"type":"service_account",...}'

# Deploy
git push heroku main
```

### 3. Vercel + Railway

#### Flutter Web (Vercel)
```bash
# Install Vercel CLI
npm install -g vercel

# Deploy
cd flutter_web
flutter build web --release
vercel --prod
```

#### Flask API (Railway)
```bash
# Connect GitHub repository to Railway
# Set environment variables in Railway dashboard
# Deploy automatically on git push
```

## Production Configuration

### Security
- Use HTTPS for all communications
- Secure Google Service Account keys
- Implement rate limiting
- Add authentication if needed
- Validate all inputs

### Performance
- Enable gzip compression
- Use CDN for static assets
- Optimize images
- Implement caching strategies
- Monitor API response times

### Monitoring
- Set up logging
- Monitor API endpoints
- Track error rates
- Set up alerts for downtime

## Environment Variables

### Flutter Web
No environment variables needed for basic deployment.

### Flask API
Required:
- `GOOGLE_SPREADSHEET_ID`: Your Google Sheets document ID
- `GOOGLE_SERVICE_ACCOUNT_JSON`: Service account credentials

Optional:
- `PORT`: API port (default: 5000)
- `FLASK_ENV`: Environment (development/production)
- `CORS_ORIGINS`: Allowed origins for CORS

## Troubleshooting

### Common Issues
1. **Flutter build errors**: Run `flutter clean` and `flutter pub get`
2. **API connection errors**: Check CORS configuration and endpoints
3. **Google Sheets errors**: Verify service account permissions
4. **Docker issues**: Ensure Docker is running and images are built

### Debugging
- Check browser console for frontend errors
- Review API logs for backend issues
- Use `flutter doctor` to verify Flutter setup
- Test API endpoints independently