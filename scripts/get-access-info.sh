#!/bin/bash

# Mercury Remote Controller - Access Information Script
# This script automatically detects the device's IP address and provides access information

# Load environment variables
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

# Default values if .env is not loaded
GUACAMOLE_PORT=${GUACAMOLE_PORT:-8080}
GUACAMOLE_ADMIN_USER=${GUACAMOLE_ADMIN_USER:-guacadmin}
GUACAMOLE_ADMIN_PASSWORD=${GUACAMOLE_ADMIN_PASSWORD:-guacadmin}

echo "☿ Mercury Remote Controller - Access Information"
echo "==============================================="

# Function to get the primary IP address
get_ip_address() {
    # Try different methods to get the IP address
    local ip_address=""
    
    # Method 1: macOS specific
    if [[ "$OSTYPE" == "darwin"* ]]; then
        ip_address=$(ipconfig getifaddr en0 2>/dev/null)
        if [[ -z "$ip_address" ]]; then
            ip_address=$(ipconfig getifaddr en1 2>/dev/null)
        fi
    fi
    
    # Method 2: Linux specific
    if [[ -z "$ip_address" ]]; then
        ip_address=$(hostname -I | awk '{print $1}' 2>/dev/null)
    fi
    
    # Method 3: Cross-platform fallback
    if [[ -z "$ip_address" ]]; then
        ip_address=$(ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}' | head -1 2>/dev/null)
    fi
    
    echo "$ip_address"
}

# Function to check if port is accessible
check_port() {
    local ip=$1
    local port=$2
    timeout 2 bash -c "</dev/tcp/$ip/$port" 2>/dev/null
    return $?
}

# Get IP address
IP_ADDRESS=$(get_ip_address)

if [[ -z "$IP_ADDRESS" ]]; then
    echo "[ERROR] Could not determine IP address"
    echo "[INFO] You can still access via localhost: http://localhost:8080/guacamole/"
    exit 1
fi

echo "[INFO] Device IP Address: $IP_ADDRESS"
echo "[INFO] Guacamole Port: $GUACAMOLE_PORT"
echo ""

# Check if services are running
echo "[INFO] Checking service status..."
if docker-compose ps | grep -q "mercury-guacamole.*Up"; then
    echo "[SUCCESS] Guacamole service is running"
    
    # Check port accessibility
    if check_port "$IP_ADDRESS" $GUACAMOLE_PORT; then
        echo "[SUCCESS] Port $GUACAMOLE_PORT is accessible"
    else
        echo "[WARNING] Port $GUACAMOLE_PORT might not be accessible from external devices"
    fi
    
    echo ""
    echo "🌐 Access Information:"
    echo "====================="
    echo "Local Access:"
echo "  • http://localhost:$GUACAMOLE_PORT/guacamole/"
echo "  • http://127.0.0.1:$GUACAMOLE_PORT/guacamole/"
echo ""
echo "Network Access:"
echo "  • http://$IP_ADDRESS:$GUACAMOLE_PORT/guacamole/"
echo ""
echo "📱 Mobile/Tablet Access:"
echo "  • http://$IP_ADDRESS:$GUACAMOLE_PORT/guacamole/"
echo ""
echo "🔐 Login Credentials:"
echo "  • Username: $GUACAMOLE_ADMIN_USER"
echo "  • Password: $GUACAMOLE_ADMIN_PASSWORD"
    echo ""
    echo "💡 Tips:"
echo "  • Make sure your firewall allows connections on port $GUACAMOLE_PORT"
echo "  • Other devices must be on the same network"
echo "  • For external access, configure port forwarding on your router"
    
else
    echo "[ERROR] Guacamole service is not running"
    echo "[INFO] Start the services with: ./start.sh"
fi

echo ""
echo "🔍 Network Information:"
echo "======================"
echo "Network Interface: $(ifconfig | grep -E "^[a-zA-Z]" | head -1 | awk '{print $1}' | sed 's/://')"
echo "Subnet: $(ipconfig getifaddr en0 2>/dev/null | sed 's/\.[0-9]*$/.0\/24/' 2>/dev/null || echo 'Unknown')"
echo "Gateway: $(netstat -nr | grep default | awk '{print $2}' | head -1 2>/dev/null || echo 'Unknown')" 