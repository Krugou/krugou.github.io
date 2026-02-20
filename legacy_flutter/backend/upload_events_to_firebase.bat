@echo off
REM Upload Events to Firebase - Windows Batch Script
REM This script runs the Python events uploader with the virtual environment

echo.
echo =====================================
echo  The Immigrants - Firebase Uploader
echo =====================================
echo.

REM Check if virtual environment exists
if not exist "%~dp0venv\Scripts\python.exe" (
    echo Error: Virtual environment not found!
    echo Please run setup.py first to create the virtual environment.
    echo.
    pause
    exit /b 1
)

REM Check if Firebase config exists
if not exist "%~dp0firebase_config.json" (
    echo Error: Firebase configuration not found!
    echo Please create firebase_config.json from firebase_config_template.json
    echo and update it with your Firebase credentials.
    echo.
    pause
    exit /b 1
)

REM Check for command line arguments
set DRY_RUN=
set FORCE=
set VERBOSE=
set LIST_EXISTING=
set VERIFY_ONLY=

:parse_args
if "%1"=="--dry-run" (
    set DRY_RUN=--dry-run
    shift
    goto parse_args
)
if "%1"=="--force" (
    set FORCE=--force
    shift
    goto parse_args
)
if "%1"=="--verbose" (
    set VERBOSE=--verbose
    shift
    goto parse_args
)
if "%1"=="--list-existing" (
    set LIST_EXISTING=--list-existing
    shift
    goto parse_args
)
if "%1"=="--verify-only" (
    set VERIFY_ONLY=--verify-only
    shift
    goto parse_args
)
if "%1"=="--help" (
    goto show_help
)
if "%1"=="-h" (
    goto show_help
)
if not "%1"=="" (
    echo Unknown argument: %1
    goto show_help
)

REM Run the uploader
echo Running Firebase events uploader...
echo.
"%~dp0venv\Scripts\python.exe" "%~dp0upload_events_to_firebase.py" %DRY_RUN% %FORCE% %VERBOSE% %LIST_EXISTING% %VERIFY_ONLY%

echo.
echo Upload process completed.
pause
exit /b %ERRORLEVEL%

:show_help
echo.
echo Usage: upload_events_to_firebase.bat [OPTIONS]
echo.
echo Options:
echo   --dry-run        Preview what would be uploaded without actually uploading
echo   --force          Overwrite existing data in Firebase without prompting
echo   --verbose        Enable verbose logging
echo   --list-existing  List existing events in Firebase and exit
echo   --verify-only    Only verify existing uploads without uploading new data
echo   --help, -h       Show this help message
echo.
echo Examples:
echo   upload_events_to_firebase.bat
echo   upload_events_to_firebase.bat --dry-run --verbose
echo   upload_events_to_firebase.bat --force
echo   upload_events_to_firebase.bat --list-existing
echo.
pause
exit /b 0
