#!/bin/bash
# Upload Events to Firebase - Shell Script
# This script runs the Python events uploader with the virtual environment

echo
echo "====================================="
echo " The Immigrants - Firebase Uploader"
echo "====================================="
echo

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check if virtual environment exists
if [ ! -f "$SCRIPT_DIR/venv/bin/python" ]; then
    echo "Error: Virtual environment not found!"
    echo "Please run setup.py first to create the virtual environment."
    echo
    exit 1
fi

# Check if Firebase config exists
if [ ! -f "$SCRIPT_DIR/firebase_config.json" ]; then
    echo "Error: Firebase configuration not found!"
    echo "Please create firebase_config.json from firebase_config_template.json"
    echo "and update it with your Firebase credentials."
    echo
    exit 1
fi

# Function to show help
show_help() {
    echo
    echo "Usage: ./upload_events_to_firebase.sh [OPTIONS]"
    echo
    echo "Options:"
    echo "  --dry-run        Preview what would be uploaded without actually uploading"
    echo "  --force          Overwrite existing data in Firebase without prompting"
    echo "  --verbose        Enable verbose logging"
    echo "  --list-existing  List existing events in Firebase and exit"
    echo "  --verify-only    Only verify existing uploads without uploading new data"
    echo "  --help, -h       Show this help message"
    echo
    echo "Examples:"
    echo "  ./upload_events_to_firebase.sh"
    echo "  ./upload_events_to_firebase.sh --dry-run --verbose"
    echo "  ./upload_events_to_firebase.sh --force"
    echo "  ./upload_events_to_firebase.sh --list-existing"
    echo
    exit 0
}

# Parse command line arguments
ARGS=""
for arg in "$@"; do
    case $arg in
        --dry-run)
            ARGS="$ARGS --dry-run"
            ;;
        --force)
            ARGS="$ARGS --force"
            ;;
        --verbose)
            ARGS="$ARGS --verbose"
            ;;
        --list-existing)
            ARGS="$ARGS --list-existing"
            ;;
        --verify-only)
            ARGS="$ARGS --verify-only"
            ;;
        --help|-h)
            show_help
            ;;
        *)
            echo "Unknown argument: $arg"
            show_help
            ;;
    esac
done

# Run the uploader
echo "Running Firebase events uploader..."
echo
"$SCRIPT_DIR/venv/bin/python" "$SCRIPT_DIR/upload_events_to_firebase.py" $ARGS

echo
echo "Upload process completed."
exit $?
