#!/usr/bin/env bash
set -e

ACTION=${1:-build}
SCHEME="Side Search"
BUNDLE_ID="dev.smartium.sidesearch"

# We use the build folder to find the app
BUILD_DIR=".build"

build_app() {
    echo "🔨 Building $SCHEME for Device..."
    # We fallback to standard output if xcpretty is not installed
    if command -v xcpretty &> /dev/null; then
        xcodebuild -scheme "$SCHEME" \
            -destination "generic/platform=iOS" \
            -derivedDataPath "$BUILD_DIR" \
            build | xcpretty
    else
        xcodebuild -scheme "$SCHEME" \
            -destination "generic/platform=iOS" \
            -derivedDataPath "$BUILD_DIR" \
            build
    fi
    echo "✅ Build complete."
}

run_app() {
    build_app
    
    # Find the app bundle
    APP_PATH=$(find "$BUILD_DIR/Build/Products/" -name "*.app" | head -n 1)
    
    if [ -z "$APP_PATH" ]; then
        echo "❌ Could not find .app in build directory."
        exit 1
    fi

    echo "📱 Installing $APP_PATH to physical device..."
    
    # Get the first connected physical device
    DEVICE_ID=$(xcrun devicectl list devices | grep "iPhone" | grep "connected" | awk '{print $NF}' | head -n 1)
    
    if [ -z "$DEVICE_ID" ]; then
        echo "⚠️ No connected physical device found. Please connect your iPhone."
        exit 1
    fi
    
    echo "📲 Deploying to device $DEVICE_ID..."
    xcrun devicectl device install app --device "$DEVICE_ID" "$APP_PATH"
    
    echo "🚀 Launching app on device..."
    xcrun devicectl device process launch --device "$DEVICE_ID" "$BUNDLE_ID"
    
    echo "🎉 Done!"
}

if [ "$ACTION" == "build" ]; then
    build_app
elif [ "$ACTION" == "run" ]; then
    run_app
else
    echo "Usage: ./scripts/dev.sh [build|run]"
fi
