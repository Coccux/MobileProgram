#!/bin/bash
# ═══════════════════════════════════════════════════════════════
# Fix file permissions for build scripts
# Run this if you get "Permission denied" errors
# ═══════════════════════════════════════════════════════════════

echo "🔧 Fixing file permissions..."

# Make gradlew executable
if [ -f "gradlew" ]; then
    chmod +x gradlew
    echo "✅ gradlew is now executable"
else
    echo "❌ gradlew not found"
fi

# Make all scripts executable
if [ -d "scripts" ]; then
    chmod +x scripts/*.sh 2>/dev/null
    echo "✅ All shell scripts in scripts/ are now executable"
fi

echo ""
echo "✅ Done! You can now run:"
echo "   make dev-run"
echo "   ./scripts/install-dev.sh"
echo "   ./scripts/check-device.sh"
