#!/usr/bin/env python3
"""
Setup script for The Immigrants Event Management Backend
"""

import os
import sys
import subprocess
import platform

def run_command(command, description):
    """Run a command and handle errors"""
    print(f"Running: {description}")
    try:
        result = subprocess.run(command, shell=True, check=True, capture_output=True, text=True)
        print(f"✅ {description} completed successfully")
        return True
    except subprocess.CalledProcessError as e:
        print(f"❌ {description} failed: {e}")
        print(f"Error output: {e.stderr}")
        return False

def check_python_version():
    """Check if Python version is sufficient"""
    print("Checking Python version...")
    if sys.version_info < (3, 8):
        print("❌ Python 3.8 or higher is required")
        return False
    print(f"✅ Python {sys.version_info.major}.{sys.version_info.minor}.{sys.version_info.micro} detected")
    return True

def create_virtual_environment():
    """Create a virtual environment"""
    venv_path = os.path.join(os.path.dirname(__file__), 'venv')
    
    if os.path.exists(venv_path):
        print("✅ Virtual environment already exists")
        return True
    
    print("Creating virtual environment...")
    return run_command(f"python -m venv {venv_path}", "Creating virtual environment")

def install_requirements():
    """Install required packages"""
    venv_path = os.path.join(os.path.dirname(__file__), 'venv')
    
    if platform.system() == "Windows":
        pip_path = os.path.join(venv_path, 'Scripts', 'pip.exe')
    else:
        pip_path = os.path.join(venv_path, 'bin', 'pip')
    
    requirements_path = os.path.join(os.path.dirname(__file__), 'requirements.txt')
    
    return run_command(f"{pip_path} install -r {requirements_path}", "Installing requirements")

def create_run_script():
    """Create a run script for the application"""
    script_dir = os.path.dirname(__file__)
    venv_path = os.path.join(script_dir, 'venv')
    
    if platform.system() == "Windows":
        # Windows batch script
        python_path = os.path.join(venv_path, 'Scripts', 'python.exe')
        script_content = f"""@echo off
echo Starting The Immigrants Event Management Backend...
"{python_path}" "{os.path.join(script_dir, 'event_manager.py')}"
pause
"""
        script_path = os.path.join(script_dir, 'run_event_manager.bat')
    else:
        # Unix shell script
        python_path = os.path.join(venv_path, 'bin', 'python')
        script_content = f"""#!/bin/bash
echo "Starting The Immigrants Event Management Backend..."
"{python_path}" "{os.path.join(script_dir, 'event_manager.py')}"
"""
        script_path = os.path.join(script_dir, 'run_event_manager.sh')
    
    try:
        with open(script_path, 'w') as f:
            f.write(script_content)
        
        if platform.system() != "Windows":
            os.chmod(script_path, 0o755)
        
        print(f"✅ Created run script: {script_path}")
        return True
    except Exception as e:
        print(f"❌ Failed to create run script: {e}")
        return False

def create_firebase_config_template():
    """Create a Firebase configuration template"""
    script_dir = os.path.dirname(__file__)
    config_path = os.path.join(script_dir, 'firebase_config_template.json')
    
    config_template = {
        "type": "service_account",
        "project_id": "your-project-id",
        "private_key_id": "your-private-key-id",
        "private_key": "-----BEGIN PRIVATE KEY-----\nYOUR_PRIVATE_KEY_HERE\n-----END PRIVATE KEY-----\n",
        "client_email": "your-client-email@your-project-id.iam.gserviceaccount.com",
        "client_id": "your-client-id",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
        "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/your-client-email%40your-project-id.iam.gserviceaccount.com"
    }
    
    try:
        import json
        with open(config_path, 'w') as f:
            json.dump(config_template, f, indent=2)
        
        print(f"✅ Created Firebase config template: {config_path}")
        print("⚠️  Please update this file with your actual Firebase credentials")
        return True
    except Exception as e:
        print(f"❌ Failed to create Firebase config template: {e}")
        return False

def main():
    """Main setup function"""
    print("🎮 The Immigrants Event Management Backend Setup")
    print("=" * 50)
    
    # Check Python version
    if not check_python_version():
        return False
    
    # Create virtual environment
    if not create_virtual_environment():
        return False
    
    # Install requirements
    if not install_requirements():
        return False
    
    # Create run script
    if not create_run_script():
        return False
    
    # Create Firebase config template
    if not create_firebase_config_template():
        return False
    
    print("\n" + "=" * 50)
    print("✅ Setup completed successfully!")
    print("\nNext steps:")
    print("1. Update firebase_config_template.json with your Firebase credentials")
    print("2. Rename it to firebase_config.json")
    if platform.system() == "Windows":
        print("3. Run the backend with: run_event_manager.bat")
    else:
        print("3. Run the backend with: ./run_event_manager.sh")
    print("\nFor Firebase credentials, visit:")
    print("https://console.firebase.google.com/project/your-project/settings/serviceaccounts/adminsdk")
    
    return True

if __name__ == "__main__":
    if main():
        sys.exit(0)
    else:
        sys.exit(1)