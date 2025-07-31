# ☿ Mercury Remote Controller - Detailed Setup Guide

## Overview

Mercury Remote Controller is a comprehensive remote access solution that enables secure VNC connections from Windows to Mac using Apache Guacamole. This guide provides detailed setup instructions and advanced configuration options.

## Architecture

The system consists of several components:

- **Apache Guacamole**: Web-based remote desktop gateway
- **Guacamole Daemon (guacd)**: Protocol translation service
- **PostgreSQL**: Database for user management and connection settings
- **Nginx**: Reverse proxy with SSL support
- **Network Discovery**: Automated device detection

## Prerequisites

### System Requirements

**Mac (Target):**
- macOS 10.14 or later
- Admin privileges
- Network connectivity
- Screen Sharing capability

**Windows (Client):**
- Windows 10 or later
- Docker Desktop 4.0+
- 4GB RAM minimum
- Network connectivity

### Network Requirements

- Both devices on same local network
- Port 5900 (VNC) accessible on Mac
- Ports 80, 443, 8080 available on Windows
- Firewall configured appropriately

## Installation Steps

### 1. Mac Configuration

#### Automatic Setup (Recommended)

```bash
# Navigate to project directory
cd "Desktop/Mercury Remote Controller"

# Run setup script
./scripts/setup-mac.sh
```

#### Manual Setup

1. **Enable Screen Sharing:**
   ```bash
   sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart \
       -activate -configure -access -on \
       -clientopts -setvnclegacy -vnclegacy yes \
       -clientopts -setvncpw -vncpw "your_password" \
       -restart -agent -privs -all
   ```

2. **Configure Firewall:**
   ```bash
   sudo /usr/libexec/ApplicationFirewall/socketfilterfw --add /System/Library/CoreServices/RemoteManagement/ARDAgent.app
   sudo /usr/libexec/ApplicationFirewall/socketfilterfw --unblock /System/Library/CoreServices/RemoteManagement/ARDAgent.app
   ```

3. **System Preferences Method:**
   - System Preferences > Sharing
   - Check "Screen Sharing"
   - Click "Computer Settings"
   - Check "VNC viewers may control screen"
   - Set VNC password

### 2. Windows Configuration

#### Automatic Setup (Recommended)

```cmd
# Navigate to project directory
cd "Mercury Remote Controller"

# Run setup script
scripts\setup-windows.bat
```

#### Manual Setup

1. **Install Docker Desktop:**
   - Download from https://www.docker.com/products/docker-desktop
   - Install and start Docker Desktop

2. **Start Services:**
   ```cmd
   docker-compose up -d
   ```

3. **Verify Services:**
   ```cmd
   docker-compose ps
   ```

### 3. Connection Setup

1. **Access Guacamole:**
   - Open browser: `http://localhost:8080/guacamole`
   - Login: `guacadmin` / `guacadmin`

2. **Add VNC Connection:**
   - Settings > Connections > New Connection
   - Protocol: VNC
   - Hostname: [Mac IP Address]
   - Port: 5900
   - Password: [Your VNC password]

3. **Test Connection:**
   - Click on the connection
   - Verify remote desktop access

## Advanced Configuration

### SSL/HTTPS Setup

1. **Generate SSL Certificate:**
   ```bash
   # Self-signed certificate (for testing)
   openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
       -keyout nginx/ssl/mercury.key \
       -out nginx/ssl/mercury.crt
   ```

2. **Update Nginx Configuration:**
   - Edit `nginx/nginx.conf`
   - Update SSL certificate paths
   - Restart services: `docker-compose restart nginx`

### Custom Branding

1. **Modify Guacamole Interface:**
   - Edit `guacamole/extensions/` files
   - Customize logos and styling
   - Update title and branding

2. **Custom CSS:**
   ```css
   /* Add to guacamole/extensions/custom.css */
   .guac-header {
       background: linear-gradient(45deg, #1a1a1a, #333);
   }
   ```

### User Management

1. **Create New Users:**
   - Login as guacadmin
   - Settings > Users > New User
   - Set permissions appropriately

2. **User Groups:**
   - Create groups for different access levels
   - Assign connections to groups
   - Manage permissions centrally

### Connection Groups

1. **Organize Connections:**
   - Create connection groups
   - Categorize by department/location
   - Set group-level permissions

2. **Sharing Profiles:**
   - Create sharing profiles for collaboration
   - Set time limits and restrictions
   - Monitor shared sessions

## Security Configuration

### Password Policies

1. **Strong Passwords:**
   - Minimum 12 characters
   - Mix of letters, numbers, symbols
   - Regular password rotation

2. **VNC Security:**
   - Use strong VNC passwords
   - Enable encryption if available
   - Restrict access to specific IPs

### Network Security

1. **Firewall Rules:**
   ```bash
   # Mac firewall
   sudo /usr/libexec/ApplicationFirewall/socketfilterfw --add /System/Library/CoreServices/RemoteManagement/ARDAgent.app
   
   # Windows firewall
   netsh advfirewall firewall add rule name="Mercury VNC" dir=in action=allow protocol=TCP localport=5900
   ```

2. **VPN Access:**
   - Set up VPN for external access
   - Configure routing appropriately
   - Monitor access logs

### Access Control

1. **Time-based Access:**
   - Set access windows for users
   - Configure timezone settings
   - Implement session timeouts

2. **IP Restrictions:**
   - Limit access to specific IP ranges
   - Use geolocation blocking
   - Monitor failed login attempts

## Monitoring and Logging

### Log Management

1. **Docker Logs:**
   ```bash
   # View all logs
   docker-compose logs
   
   # Follow specific service
   docker-compose logs -f guacamole
   
   # Export logs
   docker-compose logs > mercury_logs.txt
   ```

2. **System Logs:**
   ```bash
   # Mac VNC logs
   sudo log show --predicate 'process == "VNC"' --last 1h
   
   # Network logs
   sudo log show --predicate 'process == "networkd"' --last 1h
   ```

### Performance Monitoring

1. **Resource Usage:**
   ```bash
   # Docker stats
   docker stats
   
   # System resources
   top
   htop
   ```

2. **Connection Monitoring:**
   - Monitor active sessions
   - Track connection history
   - Analyze usage patterns

## Troubleshooting

### Common Issues

#### Connection Problems

**Issue:** "Connection refused"
- **Solution:** Verify Screen Sharing is enabled on Mac
- **Check:** `nc -z [Mac IP] 5900`

**Issue:** "Authentication failed"
- **Solution:** Check VNC password
- **Check:** Verify user permissions

**Issue:** "Network unreachable"
- **Solution:** Ensure both devices on same network
- **Check:** `ping [Mac IP]`

#### Docker Issues

**Issue:** "Port already in use"
- **Solution:** Stop conflicting services
- **Check:** `netstat -an | grep :8080`

**Issue:** "Container won't start"
- **Solution:** Check Docker logs
- **Check:** `docker-compose logs [service]`

**Issue:** "Database connection failed"
- **Solution:** Restart PostgreSQL container
- **Check:** `docker-compose restart postgres`

#### Performance Issues

**Issue:** "Slow connection"
- **Solution:** Reduce screen resolution
- **Check:** Network bandwidth

**Issue:** "High CPU usage"
- **Solution:** Limit concurrent connections
- **Check:** System resources

### Diagnostic Commands

```bash
# Network connectivity
ping [Mac IP]
nc -z [Mac IP] 5900
traceroute [Mac IP]

# Service status
docker-compose ps
docker-compose logs
docker stats

# System resources
top
df -h
free -h

# Network interfaces
ifconfig
ipconfig
```

## Backup and Recovery

### Data Backup

1. **Database Backup:**
   ```bash
   docker-compose exec postgres pg_dump -U guacamole_user guacamole_db > backup.sql
   ```

2. **Configuration Backup:**
   ```bash
   tar -czf mercury_backup_$(date +%Y%m%d).tar.gz \
       docker-compose.yml \
       guacamole/ \
       nginx/ \
       scripts/ \
       init/
   ```

### Recovery Procedures

1. **Database Recovery:**
   ```bash
   docker-compose exec postgres psql -U guacamole_user guacamole_db < backup.sql
   ```

2. **Service Recovery:**
   ```bash
   docker-compose down
   docker-compose up -d
   ```

## Maintenance

### Regular Tasks

1. **Weekly:**
   - Review access logs
   - Check system resources
   - Update passwords

2. **Monthly:**
   - Backup configurations
   - Update Docker images
   - Review security settings

3. **Quarterly:**
   - Security audit
   - Performance review
   - User access review

### Updates

1. **Docker Images:**
   ```bash
   docker-compose pull
   docker-compose up -d
   ```

2. **System Updates:**
   - Keep macOS updated
   - Update Windows regularly
   - Monitor security patches

## Support and Resources

### Documentation
- [Apache Guacamole Documentation](https://guacamole.apache.org/doc/gug/)
- [Docker Documentation](https://docs.docker.com/)
- [VNC Protocol Specification](https://tools.ietf.org/html/rfc6143)

### Community
- [Guacamole Mailing Lists](https://guacamole.apache.org/mailing-lists.html)
- [Docker Community](https://forums.docker.com/)
- [Stack Overflow](https://stackoverflow.com/)

### Professional Support
- Consider enterprise support for production deployments
- Implement monitoring and alerting
- Regular security assessments

---

**☿ Mercury Remote Controller** - Enterprise-grade remote access solution 