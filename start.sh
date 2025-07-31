#!/bin/bash

# ☿ Mercury Remote Controller - Main Startup Script
# This script starts all services and performs network discovery

set -e

# Load environment variables
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

# Default values if .env is not loaded
GUACAMOLE_PORT=${GUACAMOLE_PORT:-8080}
GUACAMOLE_ADMIN_USER=${GUACAMOLE_ADMIN_USER:-guacadmin}
GUACAMOLE_ADMIN_PASSWORD=${GUACAMOLE_ADMIN_PASSWORD:-guacadmin}

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

# Function to check if Docker is running
check_docker() {
    if ! docker info >/dev/null 2>&1; then
        print_error "Docker is not running. Please start Docker Desktop first."
        exit 1
    fi
    print_success "Docker is running"
}

# Function to start Docker services
start_services() {
    print_status "Starting Mercury Remote Controller services..."
    
    # Stop any existing containers
    docker-compose down >/dev/null 2>&1 || true
    
    # Start services
    docker-compose up -d
    
    # Wait for services to be ready
    print_status "Waiting for services to start..."
    sleep 10
    
    # Check service status
    print_status "Checking service status..."
    docker-compose ps
}

# Function to perform network discovery
discover_network() {
    print_status "Performing network discovery..."
    ./scripts/network-discovery.sh
}

# Function to get device IP address
get_device_ip() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        ipconfig getifaddr en0 2>/dev/null || ipconfig getifaddr en1 2>/dev/null || echo "localhost"
    else
        hostname -I | awk '{print $1}' 2>/dev/null || echo "localhost"
    fi
}

# Function to display connection information
show_connection_info() {
    local device_ip=$(get_device_ip)
    
    echo
    echo "=========================================="
    echo "☿ Mercury Remote Controller - Ready!"
    echo "=========================================="
    echo
    echo "Services are now running:"
    echo "  • Apache Guacamole: http://localhost:$GUACAMOLE_PORT/guacamole"
    echo "  • Apache Guacamole (Network): http://$device_ip:$GUACAMOLE_PORT/guacamole"
    echo
    echo "Default login credentials:"
    echo "  Username: $GUACAMOLE_ADMIN_USER"
    echo "  Password: $GUACAMOLE_ADMIN_PASSWORD"
    echo
    echo "🌐 Access URLs:"
echo "  Local Access:"
echo "    • http://localhost:$GUACAMOLE_PORT/guacamole"
echo "    • http://127.0.0.1:$GUACAMOLE_PORT/guacamole"
echo
echo "  Network Access (for other devices):"
echo "    • http://$device_ip:$GUACAMOLE_PORT/guacamole"
echo
echo "📱 Mobile/Tablet Access:"
echo "    • http://$device_ip:$GUACAMOLE_PORT/guacamole"
    echo
    echo "To connect to your Mac:"
echo "  1. Open your web browser"
echo "  2. Go to: http://$device_ip:$GUACAMOLE_PORT/guacamole"
echo "  3. Login with the credentials above"
    echo "  4. Add a new VNC connection:"
    echo "     - Protocol: VNC"
    echo "     - Hostname: $device_ip"
    echo "     - Port: 5900"
    echo "     - Password: [Your VNC password]"
    echo
    echo "Useful commands:"
    echo "  • View logs: docker-compose logs"
    echo "  • Stop services: docker-compose down"
    echo "  • Restart services: docker-compose restart"
    echo "  • Network discovery: ./scripts/network-discovery.sh"
    echo "  • Access info: ./scripts/get-access-info.sh"
    echo
    echo "💡 Tips:"
echo "  • Other devices must be on the same network"
echo "  • Make sure firewall allows port $GUACAMOLE_PORT"
echo "  • For external access, configure port forwarding"
    echo
    echo "=========================================="
}

# Function to handle cleanup on exit
cleanup() {
    print_status "Shutting down services..."
    docker-compose down >/dev/null 2>&1 || true
}

# Main script execution
main() {
    echo "☿ Mercury Remote Controller - Starting Services"
    echo "==============================================="
    echo
    
    # Set up cleanup trap
    trap cleanup EXIT
    
    # Check prerequisites
    check_docker
    
    # Start services
    start_services
    
    # Perform network discovery
    discover_network
    
    # Show connection information
    show_connection_info
    
    print_success "Mercury Remote Controller is ready!"
    echo
    print_status "Press Ctrl+C to stop all services"
    
    # Keep the script running
    while true; do
        sleep 1
    done
}

# Run main function
main "$@" 