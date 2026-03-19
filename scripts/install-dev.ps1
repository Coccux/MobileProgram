# ═══════════════════════════════════════════════════════════════
# Quick install script for dev build (PowerShell)
# ═══════════════════════════════════════════════════════════════

$ErrorActionPreference = "Stop"

Write-Host "🏗️  Building dev-debug APK..." -ForegroundColor Green
.\gradlew.bat assembleDevDebug

Write-Host "📱 Installing on device..." -ForegroundColor Green
.\gradlew.bat installDevDebug

Write-Host "🚀 Launching app..." -ForegroundColor Green
adb shell am start -n com.example.Russify.dev.debug/com.example.Russify.MainActivity

Write-Host "✅ Done! App is running." -ForegroundColor Green
Write-Host "📋 To view logs: adb logcat | Select-String 'russify'" -ForegroundColor Yellow
