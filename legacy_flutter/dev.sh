#!/bin/bash

# Development script for The Immigrants Flutter game

echo "🎮 The Immigrants - Flutter Game Development"
echo "==========================================="

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed. Please install Flutter first."
    echo "   Visit: https://flutter.dev/docs/get-started/install"
    exit 1
fi

echo "✅ Flutter detected: $(flutter --version | head -1)"

# Function to show help
show_help() {
    echo "Usage: ./dev.sh [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  setup     - Get dependencies and setup project"
    echo "  web       - Run on web browser"
    echo "  android   - Run on Android device/emulator"
    echo "  ios       - Run on iOS simulator"
    echo "  build     - Build for web production"
    echo "  test      - Run tests"
    echo "  clean     - Clean build files"
    echo "  help      - Show this help message"
    echo ""
}

# Main command handling
case "$1" in
    setup)
        echo "📦 Installing dependencies..."
        flutter pub get
        echo "✅ Setup complete!"
        ;;
    web)
        echo "🌐 Running on web..."
        flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080
        ;;
    android)
        echo "📱 Running on Android..."
        flutter run
        ;;
    ios)
        echo "📱 Running on iOS..."
        flutter run -d ios
        ;;
    build)
        echo "🏗️  Building for web production..."
        flutter build web --base-href /krugou.github.io/
        echo "✅ Build complete! Files are in build/web/"
        ;;
    test)
        echo "🧪 Running tests..."
        flutter test
        ;;
    clean)
        echo "🧹 Cleaning build files..."
        flutter clean
        flutter pub get
        echo "✅ Clean complete!"
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo "❌ Unknown command: $1"
        show_help
        exit 1
        ;;
esac