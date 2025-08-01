# ☿ Mercury Remote Controller

A powerful, Docker-based remote access solution that allows you to connect to your Mac from any device using Apache Guacamole over VNC protocol. Access your Mac remotely through a modern web browser with full desktop control.

## 🌟 What is Mercury Remote Controller?

Mercury Remote Controller is a complete remote access solution that combines:
- **Apache Guacamole** - Web-based remote desktop gateway
- **PostgreSQL** - Reliable database backend
- **Docker** - Easy deployment and management
- **VNC Protocol** - Secure remote desktop connection

Perfect for:
- 🏠 **Remote Work** - Access your Mac from anywhere
- 🎓 **Education** - Remote teaching and learning
- 💼 **Business** - IT support and remote administration
- 🎮 **Gaming** - Remote gaming setup
- 🔧 **Development** - Remote development environment

## 🚀 Features

- **Cross-platform remote access**: Connect from Windows to Mac
- **Web-based interface**: Access through any modern web browser
- **VNC protocol support**: Secure remote desktop connection
- **Docker-based deployment**: Easy setup and management
- **Network discovery**: Automatic detection of devices on the same network

## 📋 Prerequisites

### System Requirements

#### Minimum Requirements:
- **CPU:** 2 cores
- **RAM:** 4GB
- **Storage:** 10GB free space
- **Network:** Stable internet connection

#### Supported Operating Systems:
- **macOS** 10.15 (Catalina) or later
- **Windows** 10/11
- **Linux** (Ubuntu 20.04+, CentOS 8+, etc.)

### Required Software

#### 1. Docker Desktop
- **Download:** [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- **Version:** 4.0.0 or later
- **Installation:** Follow official Docker installation guide

**⚠️ Important for Apple Silicon (M1/M2) Macs:**
- The project uses x86_64 Docker images for compatibility
- Docker will automatically handle platform emulation
- First startup may take longer due to image conversion
- Performance is optimized for ARM64 native images

#### 2. Git (Optional but Recommended)
- **Download:** [Git](https://git-scm.com/downloads)
- **Version:** 2.30.0 or later

#### 3. Modern Web Browser
- **Chrome** 90+ / **Firefox** 88+ / **Safari** 14+ / **Edge** 90+

### Network Requirements
- Both devices must be on the same network (for local access)
- Port 8080 (or custom port) must be available
- Firewall should allow the selected port

## 🛠️ Installation Guide

### Step 1: Download the Project

#### Option A: Using Git (Recommended)
```bash
# Clone the repository
git clone https://github.com/erdncyz/mercury-remote-controller.git

# Navigate to the project directory
cd mercury-remote-controller
```

#### Option B: Manual Download
1. Go to [GitHub Repository](https://github.com/erdncyz/mercury-remote-controller)
2. Click the green "Code" button
3. Select "Download ZIP"
4. Extract the ZIP file
5. Open terminal/command prompt in the extracted folder

### Step 2: Verify Prerequisites

```bash
# Check if Docker is installed and running
docker --version
docker-compose --version

# Check if Docker Desktop is running
docker info
```

**If Docker is not running:**
- **macOS:** Open Docker Desktop application
- **Windows:** Start Docker Desktop from Start Menu
- **Linux:** Run `sudo systemctl start docker`

### Step 3: Configure the Project (Optional)

Edit the `.env` file to customize settings:

```bash
# Open .env file in your preferred editor
nano .env
# or
code .env
# or
notepad .env
```

**Available Configuration Options:**
```bash
# Port Configuration
GUACAMOLE_PORT=8080              # Change the web interface port
NGINX_PORT=80                    # Nginx port (if enabled)
NGINX_SSL_PORT=443               # SSL port (if enabled)

# Database Configuration
POSTGRES_DB=guacamole_db         # Database name
POSTGRES_USER=guacamole_user     # Database user
POSTGRES_PASSWORD=your_password  # Database password

# Guacamole Configuration
GUACAMOLE_ADMIN_USER=guacadmin   # Admin username
GUACAMOLE_ADMIN_PASSWORD=guacadmin # Admin password

# Security Configuration
ALLOW_EXTERNAL_ACCESS=false      # Set to true for external access
ENABLE_SSL=false                 # Set to true for HTTPS
```

### Step 4: Start the Services

#### Quick Start (Recommended)
```bash
# Start all services with one command
./start.sh
```

#### Manual Start
```bash
# Start services in background
docker-compose up -d

# Check service status
docker-compose ps

# View logs
docker-compose logs -f
```

### Step 5: Access the Interface

#### First Time Setup
1. **Open your web browser**
2. **Navigate to:** `http://localhost:8080/guacamole`
3. **Login with default credentials:**
   - Username: `guacadmin`
   - Password: `guacadmin`

#### Get Access Information
```bash
# Run the access info script to get all connection details
./scripts/get-access-info.sh
```

### Step 6: Configure Remote Access

#### Enable Screen Sharing on Mac (Target Machine)
```bash
# Method 1: Command Line (Recommended)
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart \
  -activate -configure -access -on \
  -clientopts -setvnclegacy -vnclegacy yes \
  -clientopts -setvncpw -vncpw your_vnc_password \
  -restart -agent -privs -all

# Method 2: System Preferences
# System Preferences > Sharing > Screen Sharing (check the box)
```

#### Add VNC Connection in Guacamole
1. **Login to Guacamole**
2. **Click "Settings" (gear icon)**
3. **Click "Connections" tab**
4. **Click "New Connection"**
5. **Fill in the details:**
   - **Name:** My Mac
   - **Protocol:** VNC
   - **Hostname:** [Your Mac's IP Address]
   - **Port:** 5900
   - **Password:** [Your VNC Password]
6. **Click "Save"**

### Step 7: Connect from Other Devices

#### Network Access
```bash
# Get your device's IP address
./scripts/get-access-info.sh

# Access from other devices on the same network:
# http://[YOUR_DEVICE_IP]:8080/guacamole
```

#### Mobile/Tablet Access
- Use the same network URL
- Works on any modern mobile browser
- Touch-friendly interface

## 🔧 Advanced Configuration

### Network Discovery

The system automatically detects devices on the same network. To manually configure:

```bash
# Find your Mac's IP address
ifconfig | grep "inet " | grep -v 127.0.0.1

# Or use the network discovery script
./scripts/network-discovery.sh
```

### Port Configuration

#### Change Default Port
```bash
# Edit .env file
nano .env

# Change the port
GUACAMOLE_PORT=9090

# Restart services
docker-compose down && docker-compose up -d
```

#### Multiple Ports
```bash
# For different services, you can configure:
GUACAMOLE_PORT=8080      # Web interface
NGINX_PORT=80            # HTTP (if enabled)
NGINX_SSL_PORT=443       # HTTPS (if enabled)
```

### Security Configuration

#### Change Default Passwords
```bash
# Edit .env file
nano .env

# Change admin credentials
GUACAMOLE_ADMIN_USER=admin
GUACAMOLE_ADMIN_PASSWORD=your_secure_password

# Change database password
POSTGRES_PASSWORD=your_database_password

# Restart services
docker-compose down && docker-compose up -d
```

#### Enable SSL/HTTPS
```bash
# Edit .env file
nano .env

# Enable SSL
ENABLE_SSL=true

# Configure SSL ports
NGINX_SSL_PORT=443
```

#### Firewall Configuration
```bash
# macOS - Allow incoming connections
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --add /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/MacOS/ARDAgent

# Linux - Open port
sudo ufw allow 8080

# Windows - Allow through Windows Firewall
netsh advfirewall firewall add rule name="Mercury Remote Controller" dir=in action=allow protocol=TCP localport=8080
```

### Performance Optimization

#### Resource Limits
```bash
# Edit docker-compose.yml to add resource limits
services:
  guacamole:
    deploy:
      resources:
        limits:
          memory: 2G
          cpus: '1.0'
```

#### Database Optimization
```bash
# PostgreSQL configuration in .env
POSTGRES_SHARED_BUFFERS=256MB
POSTGRES_EFFECTIVE_CACHE_SIZE=1GB
POSTGRES_WORK_MEM=4MB
```

## 📁 Project Structure

```
Mercury Remote Controller/
├── docker-compose.yml          # Docker services configuration
├── guacamole/                  # Guacamole configuration
│   ├── extensions/             # Custom extensions
│   └── lib/                    # Additional libraries
├── nginx/                      # Reverse proxy configuration
│   └── nginx.conf
├── scripts/                    # Setup and utility scripts
│   ├── setup-mac.sh           # Mac configuration script
│   ├── setup-windows.sh       # Windows setup script
│   └── network-discovery.sh   # Network device discovery
├── docs/                       # Documentation
└── README.md                   # This file
```

## 🔍 Troubleshooting

### Common Issues & Solutions

#### 1. Docker Issues

**Problem:** "Docker is not running"
```bash
# Solution: Start Docker Desktop
# macOS: Open Docker Desktop application
# Windows: Start Docker Desktop from Start Menu
# Linux: sudo systemctl start docker
```

**Problem:** "Platform mismatch" (Apple Silicon Macs)
```bash
# This warning is normal for M1/M2 Macs
# The project uses x86_64 images for compatibility
# Docker automatically handles platform emulation
# No action needed - services will work normally
```

**Problem:** "Slow startup on Apple Silicon"
```bash
# First startup takes longer due to image conversion
# Subsequent startups will be faster
# Consider using ARM64 native images for better performance
```

**Problem:** "Port already in use"
```bash
# Solution: Change port in .env file
nano .env
# Change GUACAMOLE_PORT=8080 to GUACAMOLE_PORT=9090
docker-compose down && docker-compose up -d
```

**Problem:** "Permission denied"
```bash
# Solution: Fix file permissions
chmod +x start.sh
chmod +x scripts/*.sh
```

#### 2. Connection Issues

**Problem:** "Connection refused"
```bash
# Check if services are running
docker-compose ps

# Check service logs
docker-compose logs guacamole
docker-compose logs postgres

# Verify port is accessible
curl -I http://localhost:8080/guacamole/
```

**Problem:** "Cannot connect to database"
```bash
# Restart database service
docker-compose restart postgres

# Check database logs
docker-compose logs postgres

# Reset database (WARNING: This will delete all data)
docker-compose down -v && docker-compose up -d
```

#### 3. Authentication Issues

**Problem:** "Invalid login credentials"
```bash
# Check .env file for correct credentials
cat .env | grep GUACAMOLE_ADMIN

# Reset to default credentials
echo "GUACAMOLE_ADMIN_USER=guacadmin" >> .env
echo "GUACAMOLE_ADMIN_PASSWORD=guacadmin" >> .env

# Restart services
docker-compose down && docker-compose up -d
```

**Problem:** "VNC authentication failed"
```bash
# Verify VNC is enabled on Mac
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate

# Check VNC password
# System Preferences > Sharing > Screen Sharing > Computer Settings
```

#### 4. Network Issues

**Problem:** "Cannot access from other devices"
```bash
# Check firewall settings
# macOS: System Preferences > Security & Privacy > Firewall
# Windows: Windows Defender Firewall
# Linux: sudo ufw status

# Verify IP address
./scripts/get-access-info.sh

# Test connectivity
ping [YOUR_DEVICE_IP]
```

**Problem:** "Slow connection"
```bash
# Check network speed
speedtest-cli

# Optimize VNC settings in Guacamole
# Settings > Connections > [Your Connection] > Parameters
# - Set color depth to 16
# - Enable compression
```

### Diagnostic Commands

#### Check Service Status
```bash
# View all running containers
docker-compose ps

# Check service health
docker-compose ps --format "table {{.Name}}\t{{.Status}}\t{{.Ports}}"
```

#### View Logs
```bash
# View all logs
docker-compose logs

# View specific service logs
docker-compose logs guacamole
docker-compose logs postgres
docker-compose logs guacd

# Follow logs in real-time
docker-compose logs -f guacamole
```

#### Network Diagnostics
```bash
# Check network connectivity
./scripts/get-access-info.sh

# Test port accessibility
telnet localhost 8080

# Check network interfaces
ifconfig
ip addr show
```

#### System Resources
```bash
# Check Docker resource usage
docker stats

# Check system resources
top
htop
free -h
df -h
```

### Reset & Recovery

#### Complete Reset
```bash
# Stop all services
docker-compose down

# Remove all data (WARNING: This will delete everything)
docker-compose down -v
docker system prune -a

# Start fresh
docker-compose up -d
```

#### Reset Database Only
```bash
# Stop services
docker-compose down

# Remove database volume
docker volume rm mercuryremotecontroller_postgres_data

# Restart services
docker-compose up -d
```

#### Reset Configuration
```bash
# Backup current .env
cp .env .env.backup

# Reset to defaults
cp .env.example .env

# Restart services
docker-compose down && docker-compose up -d
```

## 🔒 Security Considerations

- Change default passwords immediately
- Use HTTPS in production environments
- Implement proper firewall rules
- Regular security updates
- Monitor access logs

## 📚 Usage Examples

### Basic Usage

#### Start the Service
```bash
# Quick start
./start.sh

# Or manually
docker-compose up -d
```

#### Access from Different Devices
```bash
# Get access information
./scripts/get-access-info.sh

# Local access
http://localhost:8080/guacamole

# Network access
http://[YOUR_IP]:8080/guacamole

# Mobile access
http://[YOUR_IP]:8080/guacamole
```

### Advanced Usage

#### Multiple Connections
1. **Login to Guacamole**
2. **Add multiple VNC connections:**
   - Home Mac: `192.168.1.100:5900`
   - Office Mac: `192.168.1.101:5900`
   - Server: `192.168.1.102:5900`

#### Connection Groups
1. **Create connection groups:**
   - Home Devices
   - Office Devices
   - Servers
2. **Organize connections by purpose**

#### User Management
1. **Create additional users:**
   - Admin users (full access)
   - Regular users (limited access)
   - Guest users (read-only)

### Performance Tips

#### Optimize for Speed
```bash
# In Guacamole connection settings:
# - Color depth: 16-bit
# - Enable compression: Yes
# - Enable audio: No (unless needed)
# - Enable printing: No (unless needed)
```

#### Optimize for Quality
```bash
# In Guacamole connection settings:
# - Color depth: 24-bit
# - Enable compression: Yes
# - Update interval: 100ms
# - Enable audio: Yes
```

## 🔧 Maintenance

### Regular Maintenance

#### Update the Project
```bash
# Backup current setup
cp .env .env.backup
cp docker-compose.yml docker-compose.yml.backup

# Pull latest changes
git pull origin main

# Restart services
docker-compose down && docker-compose up -d
```

#### Backup Data
```bash
# Backup database
docker-compose exec postgres pg_dump -U guacamole_user guacamole_db > backup.sql

# Backup configuration
tar -czf mercury-backup-$(date +%Y%m%d).tar.gz .env docker-compose.yml init/
```

#### Clean Up
```bash
# Remove unused Docker resources
docker system prune -f

# Remove old logs
docker-compose logs --tail=100 > recent-logs.txt
```

### Monitoring

#### Health Check
```bash
# Check service health
docker-compose ps

# Monitor resource usage
docker stats

# Check logs for errors
docker-compose logs --tail=50 | grep -i error
```

#### Performance Monitoring
```bash
# Monitor network usage
iftop -i en0

# Monitor disk usage
df -h

# Monitor memory usage
free -h
```

## 🚀 Deployment Options

### Local Development
```bash
# Standard local setup
./start.sh
```

### Production Deployment
```bash
# 1. Set up SSL certificates
# 2. Configure firewall rules
# 3. Set strong passwords
# 4. Enable monitoring
# 5. Set up backups
```

### Cloud Deployment
```bash
# AWS EC2
# - Launch Ubuntu instance
# - Install Docker
# - Clone repository
# - Configure security groups
# - Set up domain and SSL

# Google Cloud
# - Launch Compute Engine instance
# - Install Docker
# - Clone repository
# - Configure firewall rules
# - Set up load balancer
```

## 📞 Support & Community

### Getting Help

#### Before Asking for Help
1. ✅ Check this README thoroughly
2. ✅ Review the troubleshooting section
3. ✅ Check Docker and Guacamole logs
4. ✅ Verify all prerequisites are met
5. ✅ Test with default configuration

#### Where to Get Help
- **GitHub Issues:** [Create an issue](https://github.com/erdncyz/mercury-remote-controller/issues)
- **Documentation:** Check the `docs/` folder
- **Community:** Join our discussions

#### When Reporting Issues
Please include:
- Operating system and version
- Docker version
- Complete error messages
- Steps to reproduce
- Logs from `docker-compose logs`

### Contributing

We welcome contributions! Here's how:

1. **Fork the repository**
2. **Create a feature branch**
3. **Make your changes**
4. **Test thoroughly**
5. **Submit a pull request**

### Roadmap

#### Planned Features
- [ ] SSL/HTTPS support
- [ ] Multi-factor authentication
- [ ] User management interface
- [ ] Connection monitoring
- [ ] Mobile app
- [ ] Cloud backup integration

#### Known Issues
- Platform compatibility warnings (non-critical)
- ARM64 emulation performance
- Large file transfer limitations

## 📄 License & Legal

### License
This project is provided as-is for educational and personal use.

### Disclaimer
- Use at your own risk
- Not intended for production use without proper security review
- Ensure compliance with local laws and regulations
- Respect privacy and security best practices

### Acknowledgments
- **Apache Guacamole** - Web-based remote desktop gateway
- **PostgreSQL** - Reliable database backend
- **Docker** - Containerization platform
- **VNC Protocol** - Remote desktop protocol

---

## 🎯 Quick Reference

### Essential Commands
```bash
# Start services
./start.sh

# Stop services
docker-compose down

# View logs
docker-compose logs -f

# Get access info
./scripts/get-access-info.sh

# Check status
docker-compose ps
```

### Default Credentials
- **Username:** `guacadmin`
- **Password:** `guacadmin`
- **Port:** `8080`
- **URL:** `http://localhost:8080/guacamole`

### Important Files
- `.env` - Configuration file
- `docker-compose.yml` - Service definitions
- `start.sh` - Startup script
- `scripts/get-access-info.sh` - Access information

---

**☿ Mercury Remote Controller** - Secure cross-platform remote access solution

*Built with ❤️ for the remote work community* 