#!/bin/bash
# ═══════════════════════════════════════════════════════════════
# Check connected Android devices
# ═══════════════════════════════════════════════════════════════

echo "🔍 Checking for connected Android devices..."
echo ""

# Check if adb is available
if ! command -v adb &> /dev/null; then
    echo "❌ ADB not found. Please install Android SDK Platform Tools."
    exit 1
fi

# List devices
DEVICES=$(adb devices | grep -v "List" | grep "device$" | wc -l | tr -d ' ')

if [ "$DEVICES" -eq 0 ]; then
    echo "❌ No devices connected."
    echo ""
    echo "📋 Checklist:"
    echo "  1. Connect device via USB cable"
    echo "  2. Enable Developer Options on device"
    echo "  3. Enable USB Debugging"
    echo "  4. Accept USB debugging prompt on device"
    echo ""
    echo "Then run: adb devices"
    exit 1
fi

echo "✅ Found $DEVICES device(s)"
echo ""
adb devices -l
echo ""

# Show device info
echo "📱 Device Information:"
echo "  Model: $(adb shell getprop ro.product.model)"
echo "  Android: $(adb shell getprop ro.build.version.release)"
echo "  SDK: $(adb shell getprop ro.build.version.sdk)"
echo ""

# Check if backend is reachable
echo "🌐 Checking network connectivity to backend..."
IP="192.168.0.49"
PORT="8080"

if adb shell "ping -c 1 $IP" &> /dev/null; then
    echo "✅ Device can reach backend at $IP"
else
    echo "⚠️  Device cannot reach backend at $IP"
    echo "   Make sure device and computer are on same Wi-Fi network"
fi

echo ""
echo "✅ Device is ready for development!"
