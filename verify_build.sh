#!/bin/bash

# Simple Build Verification Script
# This script tests if the build command works locally

echo "🔍 Build Verification Script"
echo "=============================="

echo "📂 Current directory:"
pwd
ls -la

echo ""
echo "🔍 Checking for build.sh:"
if [ -f "build.sh" ]; then
    echo "✅ build.sh found"
    ls -la build.sh
else
    echo "❌ build.sh not found"
    exit 1
fi

echo ""
echo "🔍 Checking flutter_web directory:"
if [ -d "flutter_web" ]; then
    echo "✅ flutter_web directory found"
    cd flutter_web
    echo "📋 Contents of flutter_web:"
    ls -la
    
    echo ""
    echo "🔍 Checking pubspec.yaml:"
    if [ -f "pubspec.yaml" ]; then
        echo "✅ pubspec.yaml found"
        echo "📋 pubspec.yaml content:"
        cat pubspec.yaml
    else
        echo "❌ pubspec.yaml not found"
        exit 1
    fi
    
    cd ..
else
    echo "❌ flutter_web directory not found"
    exit 1
fi

echo ""
echo "🚀 Ready to run build script"
echo "Run: chmod +x build.sh && ./build.sh"