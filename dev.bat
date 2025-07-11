@echo off
setlocal enabledelayedexpansion

REM Development script for The Immigrants Flutter game

echo 🎮 The Immigrants - Flutter Game Development
echo ===========================================

REM Check if Flutter is installed
flutter --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Flutter is not installed. Please install Flutter first.
    echo    Visit: https://flutter.dev/docs/get-started/install
    exit /b 1
)

for /f "tokens=*" %%i in ('flutter --version 2^>nul ^| findstr /r "^Flutter"') do set "flutter_version=%%i"
echo ✅ Flutter detected: !flutter_version!

REM Main command handling
if "%1"=="" goto :show_help
if /i "%1"=="setup" goto :setup
if /i "%1"=="web" goto :web
if /i "%1"=="android" goto :android
if /i "%1"=="ios" goto :ios
if /i "%1"=="build" goto :build
if /i "%1"=="test" goto :test
if /i "%1"=="clean" goto :clean
if /i "%1"=="help" goto :show_help
if /i "%1"=="--help" goto :show_help
if /i "%1"=="-h" goto :show_help

echo ❌ Unknown command: %1
goto :show_help

:setup
echo 📦 Installing dependencies...
flutter pub get
if errorlevel 1 (
    echo ❌ Failed to install dependencies
    exit /b 1
)
echo ✅ Setup complete!
goto :end

:web
echo 🌐 Running on web...
flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080
goto :end

:android
echo 📱 Running on Android...
flutter run
goto :end

:ios
echo 📱 Running on iOS...
echo ⚠️  iOS development is not supported on Windows
echo    Use a Mac or try web/Android instead
goto :end

:build
echo 🏗️ Building for web production...
flutter build web --base-href /krugou.github.io/
if errorlevel 1 (
    echo ❌ Build failed
    exit /b 1
)
echo ✅ Build complete! Files are in build\web\
goto :end

:test
echo 🧪 Running tests...
flutter test
goto :end

:clean
echo 🧹 Cleaning build files...
flutter clean
flutter pub get
if errorlevel 1 (
    echo ❌ Clean operation failed
    exit /b 1
)
echo ✅ Clean complete!
goto :end

:show_help
echo Usage: dev.bat [COMMAND]
echo.
echo Commands:
echo   setup     - Get dependencies and setup project
echo   web       - Run on web browser
echo   android   - Run on Android device/emulator
echo   ios       - Run on iOS simulator (not supported on Windows)
echo   build     - Build for web production
echo   test      - Run tests
echo   clean     - Clean build files
echo   help      - Show this help message
echo.
goto :end

:end
