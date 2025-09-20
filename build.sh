#!/bin/bash

# Flutter Web Build Script for Render Deployment
# This script builds the Flutter web application for production

echo "🚀 Starting Flutter Web Build for Render Deployment..."

# Set environment variables
export PATH="$PATH:/opt/flutter/bin"
export PUB_CACHE="/tmp/.pub-cache"

# Create necessary directories
mkdir -p /tmp/.pub-cache

echo "📦 Flutter version check..."
flutter --version || {
  echo "❌ Flutter not found. Installing Flutter..."
  
  # Download and install Flutter
  cd /tmp
  curl -L https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.13.9-stable.tar.xz -o flutter.tar.xz
  tar xf flutter.tar.xz
  export PATH="/tmp/flutter/bin:$PATH"
  
  echo "✅ Flutter installed successfully"
  flutter --version
}

echo "🔧 Configuring Flutter for web..."
flutter config --enable-web

echo "📂 Navigating to Flutter project directory..."
cd flutter_web

echo "📥 Getting Flutter dependencies..."
flutter pub get

echo "🏗️ Building Flutter web application..."
flutter build web --release --web-renderer html

echo "📋 Build output directory contents:"
ls -la build/web/

echo "✅ Flutter web build completed successfully!"
echo "🌐 Ready for deployment to Render"