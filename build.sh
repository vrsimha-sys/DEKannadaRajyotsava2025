#!/bin/bash

# Flutter Web Build Script for Render Deployment
# This script builds the Flutter web application for production

set -e  # Exit on any error

echo "🚀 Starting Flutter Web Build for Render Deployment..."

# CRITICAL: Navigate to project directory FIRST before anything else
echo "🏠 CRITICAL: Navigating to project directory..."

# Force navigation to Render project directory
PROJECT_DIR="/opt/render/project/src"
echo "🔍 Checking for Render project directory: $PROJECT_DIR"

if [ -d "$PROJECT_DIR" ]; then
    echo "✅ Found Render project directory, navigating..."
    cd "$PROJECT_DIR"
    echo "✅ Changed to Render project directory: $(pwd)"
elif [ -n "$GITHUB_WORKSPACE" ] && [ -d "$GITHUB_WORKSPACE" ]; then
    echo "✅ Using GitHub workspace directory"
    cd "$GITHUB_WORKSPACE"
    echo "✅ Changed to GitHub workspace: $(pwd)"
else
    echo "⚠️ No standard project directory found, checking alternatives..."
    
    # Try to find project directory by looking for package.json or flutter_web
    for possible_dir in "/opt/render/project" "/app" "$HOME" "$PWD"; do
        if [ -d "$possible_dir" ] && [ -f "$possible_dir/package.json" -o -d "$possible_dir/flutter_web" ]; then
            echo "✅ Found project files in: $possible_dir"
            cd "$possible_dir"
            break
        fi
    done
    
    echo "📍 Current working directory: $(pwd)"
fi

echo "📋 AFTER NAVIGATION - Current directory contents:"
ls -la

# Debug environment information
echo "🔍 Environment Debug Info:"
echo "PWD: $PWD"
echo "HOME: $HOME"
echo "RENDER: $RENDER"
echo "RENDER_GIT_REPO_SLUG: $RENDER_GIT_REPO_SLUG"
echo "GITHUB_WORKSPACE: $GITHUB_WORKSPACE"

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
    
    # CRITICAL: Return to project directory after Flutter installation
    echo "🏠 Returning to project directory after Flutter installation..."
    cd /opt/render/project/src
    echo "📍 Back in project directory: $(pwd)"
fi

echo "🌐 Configuring Flutter for web..."
flutter config --enable-web

echo "📂 Navigating to flutter_web subdirectory..."
echo "Current directory: $(pwd)"

# Navigate to flutter_web directory (should be in project root now)
if [ -d "flutter_web" ]; then
    echo "✅ Found flutter_web directory"
    cd flutter_web
    echo "📋 Inside flutter_web directory:"
    ls -la
else
    echo "❌ flutter_web directory not found in project root!"
    echo "Contents of current directory:"
    ls -la
    echo "Searching for flutter_web in subdirectories..."
    find . -type d -name "flutter_web" 2>/dev/null || echo "No flutter_web directory found anywhere"
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