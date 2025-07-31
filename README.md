# ☿ Mercury Remote Controller

A remote access solution that allows you to connect to your Mac from a Windows computer using Apache Guacamole over VNC protocol.

## 🚀 Features

- **Cross-platform remote access**: Connect from Windows to Mac
- **Web-based interface**: Access through any modern web browser
- **VNC protocol support**: Secure remote desktop connection
- **Docker-based deployment**: Easy setup and management
- **Network discovery**: Automatic detection of devices on the same network

## 📋 Prerequisites

### On Mac (Target Machine)
- macOS with Screen Sharing enabled
- VNC server running
- Network access between devices

### On Windows (Client Machine)
- Docker Desktop installed
- Modern web browser (Chrome, Firefox, Edge, Safari)
- Network access to Mac

## 🛠️ Quick Setup

### 1. Mac Configuration (One-time setup)

```bash
# Enable Screen Sharing
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate -configure -access -on -clientopts -setvnclegacy -vnclegacy yes -clientopts -setvncpw -vncpw your_password_here -restart -agent -privs -all

# Or enable through System Preferences:
# System Preferences > Sharing > Screen Sharing (check the box)
```

### 2. Windows Setup (Docker)

```bash
# Clone or download this project
# Navigate to the project directory
cd "Mercury Remote Controller"

# Start the services
docker-compose up -d
```

### 3. Access the Interface

1. Open your web browser
2. Navigate to: `http://localhost:8080/guacamole`
3. Default credentials:
   - Username: `guacadmin`
   - Password: `guacadmin`

## 🔧 Configuration

### Network Discovery

The system automatically detects Mac devices on the same network. To manually configure:

1. Find your Mac's IP address:
   ```bash
   # On Mac terminal
   ifconfig | grep "inet " | grep -v 127.0.0.1
   ```

2. Add connection in Guacamole:
   - Protocol: VNC
   - Hostname: [Mac IP Address]
   - Port: 5900
   - Password: [Your VNC password]

### Security Settings

- Change default Guacamole credentials
- Use strong VNC passwords
- Configure firewall rules appropriately
- Consider VPN for external access

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

### Common Issues

1. **Connection Refused**
   - Verify Screen Sharing is enabled on Mac
   - Check firewall settings
   - Ensure VNC port (5900) is accessible

2. **Authentication Failed**
   - Verify VNC password is correct
   - Check Guacamole credentials
   - Ensure Mac user account has proper permissions

3. **Network Issues**
   - Verify both devices are on the same network
   - Check network discovery script output
   - Test basic connectivity with ping

### Logs

```bash
# View Docker logs
docker-compose logs guacamole
docker-compose logs guacd
docker-compose logs postgres

# View Mac VNC logs
sudo log show --predicate 'process == "VNC"' --last 1h
```

## 🔒 Security Considerations

- Change default passwords immediately
- Use HTTPS in production environments
- Implement proper firewall rules
- Regular security updates
- Monitor access logs

## 📞 Support

For issues and questions:
1. Check the troubleshooting section
2. Review Docker and Guacamole logs
3. Verify network connectivity
4. Ensure all prerequisites are met

## 📄 License

This project is provided as-is for educational and personal use.

---

**☿ Mercury Remote Controller** - Secure cross-platform remote access solution 