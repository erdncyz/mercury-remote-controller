@echo off
REM ☿ Mercury Remote Controller - Windows Setup Script
REM This script sets up Docker and starts the Mercury Remote Controller services

setlocal enabledelayedexpansion

REM Colors for output (Windows 10+)
set "BLUE=[94m"
set "GREEN=[92m"
set "YELLOW=[93m"
set "RED=[91m"
set "NC=[0m"

REM Function to print colored output
:print_status
echo %BLUE%[INFO]%NC% %~1
goto :eof

:print_success
echo %GREEN%[SUCCESS]%NC% %~1
goto :eof

:print_warning
echo %YELLOW%[WARNING]%NC% %~1
goto :eof

:print_error
echo %RED%[ERROR]%NC% %~1
goto :eof

echo ☿ Mercury Remote Controller - Windows Setup
echo ============================================
echo.

REM Check if Docker is installed
call :print_status "Checking Docker installation..."
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    call :print_error "Docker is not installed or not running"
    echo.
    echo Please install Docker Desktop from: https://www.docker.com/products/docker-desktop
    echo After installation, make sure Docker Desktop is running and try again.
    echo.
    pause
    exit /b 1
)

call :print_success "Docker is installed and running"

REM Check if Docker Compose is available
call :print_status "Checking Docker Compose..."
docker-compose --version >nul 2>&1
if %errorlevel% neq 0 (
    call :print_error "Docker Compose is not available"
    echo.
    echo Please ensure Docker Compose is installed with Docker Desktop.
    echo.
    pause
    exit /b 1
)

call :print_success "Docker Compose is available"

REM Check if we're in the correct directory
if not exist "docker-compose.yml" (
    call :print_error "docker-compose.yml not found in current directory"
    echo.
    echo Please run this script from the Mercury Remote Controller project directory.
    echo.
    pause
    exit /b 1
)

call :print_success "Project files found"

REM Stop any existing containers
call :print_status "Stopping any existing containers..."
docker-compose down >nul 2>&1

REM Pull latest images
call :print_status "Pulling latest Docker images..."
docker-compose pull

REM Start the services
call :print_status "Starting Mercury Remote Controller services..."
docker-compose up -d

REM Wait for services to start
call :print_status "Waiting for services to start..."
timeout /t 10 /nobreak >nul

REM Check if services are running
call :print_status "Checking service status..."
docker-compose ps

echo.
echo ============================================
echo ☿ Mercury Remote Controller - Setup Complete
echo ============================================
echo.
echo Services are now running:
echo   - Apache Guacamole: http://localhost:8080/guacamole
echo   - Nginx (HTTPS): https://localhost
echo.
echo Default login credentials:
echo   Username: guacadmin
echo   Password: guacadmin
echo.
echo To connect to your Mac:
echo   1. Make sure Screen Sharing is enabled on your Mac
echo   2. Find your Mac's IP address
echo   3. Add a new VNC connection in Guacamole:
echo      - Protocol: VNC
echo      - Hostname: [Mac IP Address]
echo      - Port: 5900
echo      - Password: [Your VNC password]
echo.
echo Useful commands:
echo   - View logs: docker-compose logs
echo   - Stop services: docker-compose down
echo   - Restart services: docker-compose restart
echo.
echo ============================================
call :print_success "Mercury Remote Controller is ready!"
echo.
pause 