#!/bin/bash

# ☿ Mercury Remote Controller - Network Discovery Script
# This script discovers Mac devices on the local network

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

# Function to get local network information
get_network_info() {
    local interface=$(route -n get default | grep interface | awk '{print $2}')
    local local_ip=$(ifconfig $interface | grep "inet " | awk '{print $2}')
    local network=$(echo $local_ip | sed 's/\.[0-9]*$/.0\/24/')
    
    echo "$interface|$local_ip|$network"
}

# Function to scan network for Mac devices
scan_network() {
    local network=$1
    local interface=$2
    
    print_status "Scanning network: $network"
    print_status "Interface: $interface"
    
    # Use nmap if available, otherwise use ping sweep
    if command -v nmap &> /dev/null; then
        print_status "Using nmap for network scan..."
        nmap -sn $network | grep -E "Nmap scan report|MAC Address" | grep -B1 "MAC Address" | grep "Nmap scan report" | awk '{print $5}' | while read ip; do
            if [ ! -z "$ip" ]; then
                check_mac_device "$ip"
            fi
        done
    else
        print_status "Using ping sweep for network scan..."
        for i in {1..254}; do
            local ip=$(echo $network | sed 's/\/24//' | sed 's/\.0$//').$i
            ping -c 1 -W 1 $ip >/dev/null 2>&1 &
        done
        wait
        
        # Check each IP for Mac devices
        for i in {1..254}; do
            local ip=$(echo $network | sed 's/\/24//' | sed 's/\.0$//').$i
            check_mac_device "$ip"
        done
    fi
}

# Function to check if an IP belongs to a Mac device
check_mac_device() {
    local ip=$1
    
    # Try to get system information via SSH or other methods
    if nc -z -w1 $ip 22 2>/dev/null; then
        # Try SSH connection to get system info
        ssh -o ConnectTimeout=2 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null $ip "uname -s" 2>/dev/null | grep -i "darwin" >/dev/null
        if [ $? -eq 0 ]; then
            print_success "Found Mac device at: $ip"
            echo "$ip" >> /tmp/mercury_mac_devices.txt
        fi
    fi
    
    # Check for VNC port
    if nc -z -w1 $ip 5900 2>/dev/null; then
        print_success "Found VNC service at: $ip"
        echo "$ip" >> /tmp/mercury_vnc_devices.txt
    fi
}

# Function to display discovered devices
display_discovered_devices() {
    echo
    echo "=========================================="
    echo "☿ Mercury Remote Controller - Network Scan Results"
    echo "=========================================="
    echo
    
    if [ -f /tmp/mercury_mac_devices.txt ]; then
        echo "Mac devices found:"
        while read ip; do
            echo "  • $ip"
        done < /tmp/mercury_mac_devices.txt
        echo
    else
        print_warning "No Mac devices found via SSH"
    fi
    
    if [ -f /tmp/mercury_vnc_devices.txt ]; then
        echo "VNC services found:"
        while read ip; do
            echo "  • $ip:5900"
        done < /tmp/mercury_vnc_devices.txt
        echo
    else
        print_warning "No VNC services found"
    fi
    
    echo "Connection Instructions:"
    echo "  1. Open Guacamole: http://localhost:8080/guacamole"
    echo "  2. Login with: guacadmin / guacadmin"
    echo "  3. Add new VNC connection:"
    echo "     - Protocol: VNC"
    echo "     - Hostname: [IP from above]"
    echo "     - Port: 5900"
    echo "     - Password: [Your VNC password]"
    echo
    echo "=========================================="
}

# Function to clean up temporary files
cleanup() {
    rm -f /tmp/mercury_mac_devices.txt
    rm -f /tmp/mercury_vnc_devices.txt
}

# Main script execution
main() {
    echo "☿ Mercury Remote Controller - Network Discovery"
    echo "==============================================="
    echo
    
    # Clean up any existing temporary files
    cleanup
    
    # Get network information
    local network_info=$(get_network_info)
    local interface=$(echo $network_info | cut -d'|' -f1)
    local local_ip=$(echo $network_info | cut -d'|' -f2)
    local network=$(echo $network_info | cut -d'|' -f3)
    
    print_status "Local IP: $local_ip"
    print_status "Network: $network"
    
    # Scan the network
    scan_network "$network" "$interface"
    
    # Display results
    display_discovered_devices
    
    print_success "Network discovery completed!"
}

# Trap to clean up on exit
trap cleanup EXIT

# Run main function
main "$@" 