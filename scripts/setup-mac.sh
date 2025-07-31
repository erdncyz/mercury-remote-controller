#!/bin/bash

# ☿ Mercury Remote Controller - Mac Setup Script
# This script configures macOS for remote access via VNC

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if running as root
check_root() {
    if [[ $EUID -eq 0 ]]; then
        print_error "This script should not be run as root"
        exit 1
    fi
}

# Function to get user confirmation
confirm() {
    read -p "$1 (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        return 0
    else
        return 1
    fi
}

# Function to get Mac IP address
get_mac_ip() {
    local ip=$(ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}' | head -1)
    echo "$ip"
}

# Function to enable Screen Sharing
enable_screen_sharing() {
    print_status "Enabling Screen Sharing..."
    
    # Enable Screen Sharing via command line
    sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart \
        -activate -configure -access -on \
        -clientopts -setvnclegacy -vnclegacy yes \
        -clientopts -setvncpw -vncpw "$VNC_PASSWORD" \
        -restart -agent -privs -all
    
    if [ $? -eq 0 ]; then
        print_success "Screen Sharing enabled successfully"
    else
        print_error "Failed to enable Screen Sharing"
        return 1
    fi
}

# Function to configure firewall
configure_firewall() {
    print_status "Configuring firewall for VNC access..."
    
    # Add VNC port to firewall
    sudo /usr/libexec/ApplicationFirewall/socketfilterfw --add /System/Library/CoreServices/RemoteManagement/ARDAgent.app
    sudo /usr/libexec/ApplicationFirewall/socketfilterfw --unblock /System/Library/CoreServices/RemoteManagement/ARDAgent.app
    
    print_success "Firewall configured for VNC"
}

# Function to create VNC password file
create_vnc_password() {
    print_status "Creating VNC password file..."
    
    # Create .vnc directory if it doesn't exist
    mkdir -p ~/.vnc
    
    # Create password file
    echo "$VNC_PASSWORD" | vncpasswd -f > ~/.vnc/passwd
    chmod 600 ~/.vnc/passwd
    
    print_success "VNC password file created"
}

# Function to display connection information
show_connection_info() {
    local mac_ip=$(get_mac_ip)
    
    echo
    echo "=========================================="
    echo "☿ Mercury Remote Controller - Mac Setup Complete"
    echo "=========================================="
    echo
    echo "Connection Information:"
    echo "  Mac IP Address: $mac_ip"
    echo "  VNC Port: 5900"
    echo "  VNC Password: $VNC_PASSWORD"
    echo
    echo "To connect from Windows:"
    echo "  1. Start Docker containers: docker-compose up -d"
    echo "  2. Open browser: http://localhost:8080/guacamole"
    echo "  3. Login with: guacadmin / guacadmin"
    echo "  4. Add VNC connection:"
    echo "     - Protocol: VNC"
    echo "     - Hostname: $mac_ip"
    echo "     - Port: 5900"
    echo "     - Password: $VNC_PASSWORD"
    echo
    echo "Manual Screen Sharing Setup (if needed):"
    echo "  System Preferences > Sharing > Screen Sharing"
    echo "  Check 'Screen Sharing' and 'VNC viewers may control screen'"
    echo
    echo "=========================================="
}

# Function to test VNC connection
test_vnc_connection() {
    local mac_ip=$(get_mac_ip)
    
    print_status "Testing VNC connection..."
    
    # Check if port 5900 is listening
    if nc -z localhost 5900 2>/dev/null; then
        print_success "VNC server is running on port 5900"
    else
        print_warning "VNC server may not be running. Please check Screen Sharing settings."
    fi
    
    # Test network connectivity
    if ping -c 1 "$mac_ip" >/dev/null 2>&1; then
        print_success "Network connectivity confirmed"
    else
        print_warning "Network connectivity test failed"
    fi
}

# Main script execution
main() {
    echo "☿ Mercury Remote Controller - Mac Setup"
    echo "========================================"
    echo
    
    # Check if not running as root
    check_root
    
    # Get VNC password
    echo "Please set a VNC password for remote access:"
    read -s -p "VNC Password: " VNC_PASSWORD
    echo
    read -s -p "Confirm VNC Password: " VNC_PASSWORD_CONFIRM
    echo
    
    if [ "$VNC_PASSWORD" != "$VNC_PASSWORD_CONFIRM" ]; then
        print_error "Passwords do not match"
        exit 1
    fi
    
    if [ -z "$VNC_PASSWORD" ]; then
        print_error "VNC password cannot be empty"
        exit 1
    fi
    
    # Confirm setup
    if ! confirm "Proceed with Mac setup for Mercury Remote Controller?"; then
        print_status "Setup cancelled"
        exit 0
    fi
    
    # Execute setup steps
    enable_screen_sharing
    configure_firewall
    create_vnc_password
    test_vnc_connection
    show_connection_info
    
    print_success "Mac setup completed successfully!"
    echo
    print_status "You can now connect from Windows using Apache Guacamole"
}

# Run main function
main "$@" 