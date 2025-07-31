# ☿ Mercury Remote Controller - Quick Start Guide

## 🚀 Get Started in 5 Minutes

This guide will help you set up remote access from Windows to Mac using Apache Guacamole.

## 📋 Prerequisites

### On Mac (Target Machine)
- macOS with admin privileges
- Screen Sharing capability
- Network access

### On Windows (Client Machine)
- Docker Desktop installed
- Modern web browser
- Network access to Mac

## 🛠️ Step-by-Step Setup

### Step 1: Configure Mac (One-time setup)

1. **Open Terminal on your Mac**
2. **Navigate to the project directory:**
   ```bash
   cd "Desktop/Mercury Remote Controller"
   ```

3. **Run the Mac setup script:**
   ```bash
   ./scripts/setup-mac.sh
   ```

4. **Follow the prompts:**
   - Set a VNC password when prompted
   - Confirm the setup when asked
   - The script will automatically:
     - Enable Screen Sharing
     - Configure VNC settings
     - Set up firewall rules
     - Display your Mac's IP address

### Step 2: Set up Windows (One-time setup)

1. **Copy the project folder to your Windows machine**
2. **Open Command Prompt as Administrator**
3. **Navigate to the project directory:**
   ```cmd
   cd "Mercury Remote Controller"
   ```

4. **Run the Windows setup script:**
   ```cmd
   scripts\setup-windows.bat
   ```

5. **Wait for Docker to start the services**
   - This may take a few minutes on first run
   - You'll see status messages as services start

### Step 3: Connect to your Mac

1. **Open your web browser**
2. **Navigate to:** `http://localhost:8080/guacamole`
3. **Login with default credentials:**
   - Username: `guacadmin`
   - Password: `guacadmin`

4. **Add a new VNC connection:**
   - Click "Settings" (gear icon)
   - Click "Connections" tab
   - Click "New Connection"
   - Fill in the details:
     - **Name:** My Mac
     - **Protocol:** VNC
     - **Hostname:** [Your Mac's IP address]
     - **Port:** 5900
     - **Password:** [Your VNC password from Step 1]
   - Click "Save"

5. **Connect to your Mac:**
   - Click on your new connection
   - You should now see your Mac's desktop!

## 🔧 Troubleshooting

### Common Issues

**Connection Refused:**
- Verify Screen Sharing is enabled on Mac
- Check that VNC password is correct
- Ensure both devices are on the same network

**Can't Find Mac IP:**
- Run the network discovery script: `./scripts/network-discovery.sh`
- Or manually find IP: `ifconfig | grep "inet " | grep -v 127.0.0.1`

**Docker Issues:**
- Ensure Docker Desktop is running
- Try restarting Docker: `docker-compose down && docker-compose up -d`

**Login Problems:**
- Default credentials are: `guacadmin` / `guacadmin`
- Change these after first login for security

### Manual Screen Sharing Setup (if script fails)

1. **System Preferences > Sharing**
2. **Check "Screen Sharing"**
3. **Click "Computer Settings"**
4. **Check "VNC viewers may control screen"**
5. **Set a VNC password**

## 🔒 Security Recommendations

1. **Change default passwords immediately**
2. **Use strong VNC passwords**
3. **Consider using HTTPS (port 443)**
4. **Restrict network access if possible**
5. **Regular security updates**

## 📞 Support

If you encounter issues:

1. **Check the logs:**
   ```bash
   docker-compose logs
   ```

2. **Verify network connectivity:**
   ```bash
   ping [Mac IP Address]
   ```

3. **Test VNC directly:**
   ```bash
   nc -z [Mac IP] 5900
   ```

4. **Review the full README.md for detailed information**

## 🎯 Next Steps

- **Customize the interface** with your own branding
- **Set up multiple connections** for different Macs
- **Configure user management** for team access
- **Enable HTTPS** for secure external access
- **Set up automated backups** of connection settings

---

**☿ Mercury Remote Controller** - Secure cross-platform remote access solution 