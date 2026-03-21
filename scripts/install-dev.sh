#!/bin/bash
# ═══════════════════════════════════════════════════════════════
# Quick install script for dev build
# ═══════════════════════════════════════════════════════════════

set -e

echo "🏗️  Building dev-debug APK..."
./gradlew assembleDevDebug

echo "📱 Installing on device..."
./gradlew installDevDebug

echo "🚀 Launching app..."
adb shell am start -n com.example.Russify.dev.debug/com.example.Russify.MainActivity

echo "✅ Done! App is running."
echo "📋 To view logs: make logs-dev"
