#!/bin/bash

# GetTor Deployment Script
# This script sets up and deploys GetTor services

set -e

echo "=== GetTor Deployment Script ==="
echo "Setting up GetTor distribution system..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Python is installed
if ! command -v python &> /dev/null; then
    print_error "Python is not installed. Please install Python 2.7 or 3.x"
    exit 1
fi

print_status "Python found: $(python --version 2>&1)"

# Check if pip is installed
if ! command -v pip &> /dev/null; then
    print_error "pip is not installed. Please install pip"
    exit 1
fi

print_status "pip found: $(pip --version)"

# Install dependencies
print_status "Installing dependencies..."
pip install -r requirements.txt

# Create necessary directories
print_status "Creating directory structure..."
mkdir -p log
mkdir -p lang
mkdir -p upload
mkdir -p providers

# Update configuration files with absolute paths
GETTOR_PATH=$(pwd)
print_status "Setting up configuration files with path: $GETTOR_PATH"

# Update core.cfg
sed -i "s|/path/to/gettor|$GETTOR_PATH|g" core.cfg
sed -i "s|/path/to/|$GETTOR_PATH/|g" core.cfg

# Update smtp.cfg
sed -i "s|/path/to/gettor|$GETTOR_PATH|g" smtp.cfg
sed -i "s|/path/to/|$GETTOR_PATH/|g" smtp.cfg

# Update xmpp.cfg
sed -i "s|/path/to/gettor|$GETTOR_PATH|g" xmpp.cfg
sed -i "s|/path/to/|$GETTOR_PATH/|g" xmpp.cfg

# Update twitter.cfg
sed -i "s|/path/to/gettor|$GETTOR_PATH|g" twitter.cfg
sed -i "s|/path/to/|$GETTOR_PATH/|g" twitter.cfg

# Update http.cfg
sed -i "s|/path/to/gettor|$GETTOR_PATH|g" http.cfg
sed -i "s|/path/to/|$GETTOR_PATH/|g" http.cfg

# Update blacklist.cfg
sed -i "s|/path/to/gettor|$GETTOR_PATH|g" blacklist.cfg
sed -i "s|/path/to/|$GETTOR_PATH/|g" blacklist.cfg

# Initialize databases
print_status "Initializing databases..."
if [ -f "scripts/create_db.py" ]; then
    python scripts/create_db.py
else
    print_warning "Database creation script not found. You may need to create databases manually."
fi

# Set permissions
print_status "Setting permissions..."
chmod +x run_gettor.py
chmod +x deploy.sh

# Check configuration
print_status "Checking configuration..."
print_warning "Please review and update the following configuration files with your actual credentials:"
echo "  - twitter.cfg (Twitter API credentials)"
echo "  - xmpp.cfg (XMPP account credentials)"
echo "  - upload/dropbox.cfg (Dropbox access token)"
echo "  - upload/drive.cfg (Google Drive credentials)"
echo "  - upload/github.cfg (GitHub access token)"

echo
print_status "GetTor setup complete!"
echo
echo "To start GetTor services:"
echo "  python run_gettor.py all      # Start all services"
echo "  python run_gettor.py smtp     # Start SMTP service only"
echo "  python run_gettor.py xmpp     # Start XMPP service only"
echo "  python run_gettor.py twitter  # Start Twitter service only"
echo "  python run_gettor.py http     # Start HTTP service only"
echo
echo "For detailed installation instructions, see INSTALL.md"
echo "For usage instructions, see README.md"
echo
print_status "Deployment script completed successfully!"