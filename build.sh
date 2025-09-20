#!/bin/bash

# Flutter Web Build Script for Render Deployment
# This script builds the Flutter web application for production

set -e  # Exit on any error

echo "🚀 Starting Flutter Web Build for Render Deployment..."

# Debug environment information
echo "🔍 Environment Debug Info:"
echo "PWD: $PWD"
echo "HOME: $HOME"
echo "RENDER: $RENDER"
echo "RENDER_GIT_REPO_SLUG: $RENDER_GIT_REPO_SLUG"
echo "GITHUB_WORKSPACE: $GITHUB_WORKSPACE"

# Navigate to project directory first
echo "🏠 Navigating to project directory..."
if [ -n "$RENDER_GIT_REPO_SLUG" ]; then
    # In Render environment, navigate to the project directory
    PROJECT_DIR="/opt/render/project/src"
    if [ -d "$PROJECT_DIR" ]; then
        cd "$PROJECT_DIR"
        echo "✅ Changed to Render project directory: $PROJECT_DIR"
    else
        echo "❌ Render project directory not found: $PROJECT_DIR"
        echo "Available directories in /opt/render/project/:"
        ls -la /opt/render/project/ 2>/dev/null || echo "Directory not accessible"
        exit 1
    fi
elif [ -n "$GITHUB_WORKSPACE" ]; then
    cd "$GITHUB_WORKSPACE"
    echo "✅ Changed to GitHub workspace: $GITHUB_WORKSPACE"
else
    echo "⚠️ Using current directory: $PWD"
fi

echo "📋 Current directory contents:"
ls -la

# Set environment variables
export PATH="$PATH:/opt/flutter/bin:/tmp/flutter/bin"
export PUB_CACHE="${PUB_CACHE:-/tmp/.pub-cache}"
export FLUTTER_ROOT="/tmp/flutter"

# Create necessary directories
mkdir -p "${PUB_CACHE}"
mkdir -p /tmp

echo "📦 Checking for existing Flutter installation..."
if flutter --version 2>/dev/null; then
    echo "✅ Flutter already installed"
    flutter --version
else
    echo "❌ Flutter not found. Installing Flutter..."
    
    # Download and install Flutter (updated to latest stable)
    cd /tmp
    echo "📥 Downloading Flutter SDK..."
    curl -L https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.3-stable.tar.xz -o flutter.tar.xz
    
    echo "📦 Extracting Flutter SDK..."
    tar xf flutter.tar.xz
    
    # Add Flutter to PATH
    export PATH="/tmp/flutter/bin:$PATH"
    
    echo "✅ Flutter installed successfully"
    flutter --version
    
    echo "🔧 Running Flutter doctor..."
    flutter doctor -v
fi

echo "🌐 Configuring Flutter for web..."
flutter config --enable-web

echo "📂 Looking for Flutter project directory..."
echo "Current directory: $(pwd)"
echo "Directory contents:"
ls -la

# Navigate to flutter_web directory
if [ -d "flutter_web" ]; then
    echo "✅ Found flutter_web directory"
    cd flutter_web
    echo "📋 Inside flutter_web directory:"
    ls -la
elif [ -d "./flutter_web" ]; then
    echo "✅ Found ./flutter_web directory"
    cd ./flutter_web
    echo "📋 Inside flutter_web directory:"
    ls -la
else
    echo "❌ flutter_web directory not found!"
    echo "Searching for flutter_web in subdirectories..."
    find . -type d -name "flutter_web" 2>/dev/null || echo "No flutter_web directory found"
    exit 1
fi

echo "📋 Flutter project directory contents:"
ls -la

echo "📥 Getting Flutter dependencies..."
flutter pub get

echo "📋 Dependencies installed. Checking pubspec.yaml:"
cat pubspec.yaml

echo "🏗️ Building Flutter web application..."
flutter build web --release --web-renderer html --verbose

echo "📋 Build completed. Checking output directory:"
ls -la build/
ls -la build/web/

echo "✅ Flutter web build completed successfully!"
echo "🌐 Built files are in: flutter_web/build/web"
echo "📁 Ready for deployment to Render"