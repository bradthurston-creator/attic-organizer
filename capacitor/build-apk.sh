#!/usr/bin/env bash
set -euo pipefail

# ==============================================
# Attic Organizer — One-Shot APK Build
# ==============================================
# Edit source in:  ../app/index.html  (webDir)
# Run this from:   capacitor/
# ==============================================

echo "=== 1. Copy web assets to Android project ==="
npx cap copy android

echo ""
echo "=== 2. Build APK ==="
export ANDROID_HOME=$HOME/android-sdk
export JAVA_HOME=$HOME/jdk21
export PATH=$JAVA_HOME/bin:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH
cd android
./gradlew assembleDebug
cd ..

echo ""
APK_PATH="android/app/build/outputs/apk/debug/app-debug.apk"
APK_SIZE=$(stat --format=%s "$APK_PATH")
echo "=== 3. APK built: $APK_PATH ($(( APK_SIZE / 1024 )) KB) ==="
sha256sum "$APK_PATH"

echo ""
echo "=== DONE ==="
echo "Install instructions for Brad:"
echo "1. Copy APK to your phone (ADB, USB, or cloud sync)"
echo "2. Open the APK file on your phone and accept install"
echo ""
echo "Or serve locally for phone download:"
echo "  cd ~/projects/attic-organizer/capacitor/android/app/build/outputs/apk/debug/"
echo "  python3 -m http.server 8765"
echo "  Then on phone: http://<your-ip>:8765/app-debug.apk"