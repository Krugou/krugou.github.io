#!/usr/bin/env python3
"""
Upload Events to Firebase Script
=====================================

This script uploads event data from JSON files to Firebase Firestore.
It reads the territory_events.json and milestone_events.json files from the assets/events/
directory and uploads them to Firebase with the correct structure.

Usage:
    python upload_events_to_firebase.py [--config CONFIG_FILE] [--dry-run]

Arguments:
    --config    Path to Firebase credentials JSON file (default: firebase_config.json)
    --dry-run   Preview what would be uploaded without actually uploading
    --force     Overwrite existing data in Firebase
    --verbose   Enable verbose logging

Requirements:
    - Firebase Admin SDK credentials file
    - JSON event files in ../assets/events/
    - Internet connection to Firebase
"""

import os
import sys
import json
import argparse
import logging
from typing import Dict, List, Any, Optional
from pathlib import Path

try:
    import firebase_admin
    from firebase_admin import credentials, firestore
    from google.cloud.firestore_v1.base_query import FieldFilter
except ImportError as e:
    print("❌ Firebase Admin SDK not installed. Run: pip install firebase-admin")
    print(f"Error: {e}")
    sys.exit(1)


class FirebaseEventsUploader:
    """Handles uploading event data to Firebase Firestore"""

    def __init__(self, config_file: str, dry_run: bool = False, verbose: bool = False):
        self.config_file = config_file
        self.dry_run = dry_run
        self.verbose = verbose
        self.db = None

        # Setup logging
        log_level = logging.DEBUG if verbose else logging.INFO
        logging.basicConfig(
            level=log_level,
            format='%(asctime)s - %(levelname)s - %(message)s',
            datefmt='%Y-%m-%d %H:%M:%S'
        )
        self.logger = logging.getLogger(__name__)

        # Initialize Firebase
        self._initialize_firebase()

    def _initialize_firebase(self):
        """Initialize Firebase Admin SDK"""
        try:
            if not os.path.exists(self.config_file):
                raise FileNotFoundError(f"Firebase config file not found: {self.config_file}")

            self.logger.info(f"Initializing Firebase with config: {self.config_file}")

            # Initialize Firebase Admin SDK
            cred = credentials.Certificate(self.config_file)

            # Check if Firebase app is already initialized
            try:
                firebase_admin.get_app()
                self.logger.info("Firebase already initialized")
            except ValueError:
                firebase_admin.initialize_app(cred)
                self.logger.info("Firebase initialized successfully")

            # Get Firestore client
            self.db = firestore.client()
            self.logger.info("Firestore client created successfully")

        except Exception as e:
            self.logger.error(f"Failed to initialize Firebase: {e}")
            sys.exit(1)

    def load_json_file(self, file_path: str) -> Dict[str, Any]:
        """Load and parse JSON file"""
        try:
            self.logger.debug(f"Loading JSON file: {file_path}")

            if not os.path.exists(file_path):
                raise FileNotFoundError(f"JSON file not found: {file_path}")

            with open(file_path, 'r', encoding='utf-8') as f:
                data = json.load(f)

            self.logger.info(f"Successfully loaded {file_path}")
            return data

        except json.JSONDecodeError as e:
            self.logger.error(f"Invalid JSON in {file_path}: {e}")
            raise
        except Exception as e:
            self.logger.error(f"Error loading {file_path}: {e}")
            raise

    def validate_event_data(self, events: List[Dict[str, Any]], event_type: str) -> bool:
        """Validate event data structure"""
        self.logger.debug(f"Validating {event_type} events")

        required_fields = ['id', 'title', 'description', 'type', 'populationChange', 'probability', 'category']
        milestone_required_fields = required_fields + ['threshold']

        for i, event in enumerate(events):
            # Check required fields
            fields_to_check = milestone_required_fields if event_type == 'milestone' else required_fields

            for field in fields_to_check:
                if field not in event:
                    self.logger.error(f"Missing required field '{field}' in {event_type} event {i}: {event.get('id', 'unknown')}")
                    return False

            # Validate data types
            if not isinstance(event.get('populationChange'), (int, float)):
                self.logger.error(f"Invalid populationChange type in event {event.get('id')}")
                return False

            if not isinstance(event.get('probability'), (int, float)) or not (0 <= event.get('probability') <= 1):
                self.logger.error(f"Invalid probability in event {event.get('id')} (must be 0-1)")
                return False

        self.logger.info(f"✅ {event_type} events validation passed ({len(events)} events)")
        return True

    def upload_territory_events(self, territory_events: Dict[str, List[Dict[str, Any]]], force: bool = False) -> bool:
        """Upload territory events to Firebase"""
        try:
            self.logger.info("Uploading territory events...")

            # Validate all territory events
            total_events = 0
            for territory, events in territory_events.items():
                if not self.validate_event_data(events, 'territory'):
                    return False
                total_events += len(events)

            if self.dry_run:
                self.logger.info(f"[DRY RUN] Would upload {total_events} territory events across {len(territory_events)} territories")
                for territory, events in territory_events.items():
                    self.logger.info(f"  - {territory}: {len(events)} events")
                return True

            # Check if document already exists
            doc_ref = self.db.collection('events').document('territory_events')
            doc = doc_ref.get()

            if doc.exists and not force:
                self.logger.warning("Territory events already exist in Firebase. Use --force to overwrite.")
                user_input = input("Do you want to overwrite existing data? (y/N): ")
                if user_input.lower() != 'y':
                    self.logger.info("Upload cancelled by user")
                    return False

            # Upload to Firebase
            doc_ref.set(territory_events)
            self.logger.info(f"✅ Successfully uploaded {total_events} territory events to Firebase")

            return True

        except Exception as e:
            self.logger.error(f"Error uploading territory events: {e}")
            return False

    def upload_milestone_events(self, milestone_events: List[Dict[str, Any]], force: bool = False) -> bool:
        """Upload milestone events to Firebase"""
        try:
            self.logger.info("Uploading milestone events...")

            # Validate milestone events
            if not self.validate_event_data(milestone_events, 'milestone'):
                return False

            if self.dry_run:
                self.logger.info(f"[DRY RUN] Would upload {len(milestone_events)} milestone events")
                for event in milestone_events:
                    self.logger.info(f"  - {event.get('id')}: {event.get('title')}")
                return True

            # Check if document already exists
            doc_ref = self.db.collection('events').document('milestone_events')
            doc = doc_ref.get()

            if doc.exists and not force:
                self.logger.warning("Milestone events already exist in Firebase. Use --force to overwrite.")
                user_input = input("Do you want to overwrite existing data? (y/N): ")
                if user_input.lower() != 'y':
                    self.logger.info("Upload cancelled by user")
                    return False

            # Upload to Firebase with proper structure
            milestone_data = {
                'milestones': milestone_events
            }

            doc_ref.set(milestone_data)
            self.logger.info(f"✅ Successfully uploaded {len(milestone_events)} milestone events to Firebase")

            return True

        except Exception as e:
            self.logger.error(f"Error uploading milestone events: {e}")
            return False

    def verify_upload(self) -> bool:
        """Verify that events were uploaded correctly"""
        try:
            self.logger.info("Verifying uploaded events...")

            # Check territory events
            territory_doc = self.db.collection('events').document('territory_events').get()
            if not territory_doc.exists:
                self.logger.error("Territory events document not found in Firebase")
                return False

            territory_data = territory_doc.to_dict()
            territory_count = sum(len(events) for events in territory_data.values())
            self.logger.info(f"✅ Found {territory_count} territory events across {len(territory_data)} territories")

            # Check milestone events
            milestone_doc = self.db.collection('events').document('milestone_events').get()
            if not milestone_doc.exists:
                self.logger.error("Milestone events document not found in Firebase")
                return False

            milestone_data = milestone_doc.to_dict()
            milestone_count = len(milestone_data.get('milestones', []))
            self.logger.info(f"✅ Found {milestone_count} milestone events")

            self.logger.info("🎉 Event verification completed successfully!")
            return True

        except Exception as e:
            self.logger.error(f"Error verifying upload: {e}")
            return False

    def list_existing_events(self) -> bool:
        """List existing events in Firebase"""
        try:
            self.logger.info("Listing existing events in Firebase...")

            # List territory events
            territory_doc = self.db.collection('events').document('territory_events').get()
            if territory_doc.exists:
                territory_data = territory_doc.to_dict()
                self.logger.info(f"Territory Events ({len(territory_data)} territories):")
                for territory, events in territory_data.items():
                    self.logger.info(f"  - {territory}: {len(events)} events")
            else:
                self.logger.info("No territory events found in Firebase")

            # List milestone events
            milestone_doc = self.db.collection('events').document('milestone_events').get()
            if milestone_doc.exists:
                milestone_data = milestone_doc.to_dict()
                milestones = milestone_data.get('milestones', [])
                self.logger.info(f"Milestone Events ({len(milestones)} events):")
                for milestone in milestones:
                    self.logger.info(f"  - {milestone.get('id')}: {milestone.get('title')}")
            else:
                self.logger.info("No milestone events found in Firebase")

            return True

        except Exception as e:
            self.logger.error(f"Error listing events: {e}")
            return False


def find_events_directory() -> str:
    """Find the events directory relative to the script location"""
    script_dir = Path(__file__).parent
    events_dir = script_dir.parent / 'assets' / 'events'

    if not events_dir.exists():
        # Try alternative paths
        alternative_paths = [
            script_dir / 'events',
            script_dir / 'assets' / 'events',
            Path.cwd() / 'assets' / 'events',
        ]

        for path in alternative_paths:
            if path.exists():
                return str(path)

        raise FileNotFoundError(f"Events directory not found. Tried: {events_dir}")

    return str(events_dir)


def main():
    """Main function"""
    parser = argparse.ArgumentParser(
        description='Upload event data from JSON files to Firebase Firestore',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python upload_events_to_firebase.py
  python upload_events_to_firebase.py --config my_firebase_config.json
  python upload_events_to_firebase.py --dry-run --verbose
  python upload_events_to_firebase.py --force --verbose
  python upload_events_to_firebase.py --list-existing
        """
    )

    parser.add_argument(
        '--config',
        default='firebase_config.json',
        help='Path to Firebase credentials JSON file (default: firebase_config.json)'
    )

    parser.add_argument(
        '--dry-run',
        action='store_true',
        help='Preview what would be uploaded without actually uploading'
    )

    parser.add_argument(
        '--force',
        action='store_true',
        help='Overwrite existing data in Firebase without prompting'
    )

    parser.add_argument(
        '--verbose',
        action='store_true',
        help='Enable verbose logging'
    )

    parser.add_argument(
        '--list-existing',
        action='store_true',
        help='List existing events in Firebase and exit'
    )

    parser.add_argument(
        '--verify-only',
        action='store_true',
        help='Only verify existing uploads without uploading new data'
    )

    args = parser.parse_args()

    print("🎮 The Immigrants - Firebase Events Uploader")
    print("=" * 50)

    # Initialize uploader
    try:
        uploader = FirebaseEventsUploader(
            config_file=args.config,
            dry_run=args.dry_run,
            verbose=args.verbose
        )
    except Exception as e:
        print(f"❌ Failed to initialize uploader: {e}")
        return 1

    # Handle list-existing command
    if args.list_existing:
        return 0 if uploader.list_existing_events() else 1

    # Handle verify-only command
    if args.verify_only:
        return 0 if uploader.verify_upload() else 1

    try:
        # Find events directory
        events_dir = find_events_directory()
        print(f"📂 Events directory: {events_dir}")

        # Load event files
        territory_events_file = os.path.join(events_dir, 'territory_events.json')
        milestone_events_file = os.path.join(events_dir, 'milestone_events.json')

        territory_events = uploader.load_json_file(territory_events_file)
        milestone_events_data = uploader.load_json_file(milestone_events_file)
        milestone_events = milestone_events_data.get('milestones', [])

        # Upload events
        success = True

        if not uploader.upload_territory_events(territory_events, force=args.force):
            success = False

        if not uploader.upload_milestone_events(milestone_events, force=args.force):
            success = False

        # Verify upload if not dry run
        if success and not args.dry_run:
            if not uploader.verify_upload():
                success = False

        if success:
            if args.dry_run:
                print("\n🎉 Dry run completed successfully!")
                print("Run without --dry-run to actually upload the events.")
            else:
                print("\n🎉 Events uploaded to Firebase successfully!")
                print("Your Flutter app can now load events from Firebase.")
        else:
            print("\n❌ Upload failed. Check the logs above for details.")
            return 1

        return 0

    except FileNotFoundError as e:
        print(f"❌ File not found: {e}")
        print("Make sure the events JSON files exist in the assets/events/ directory")
        return 1
    except Exception as e:
        print(f"❌ Unexpected error: {e}")
        return 1


if __name__ == "__main__":
    sys.exit(main())
