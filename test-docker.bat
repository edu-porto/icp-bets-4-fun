@echo off
echo 🧪 Testing Docker Setup for ICP Bets...

REM Check if Docker is running
docker info >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker is not running. Please start Docker Desktop first.
    pause
    exit /b 1
)

echo ✅ Docker is running

REM Test building the development image
echo 🔨 Testing Docker build...
docker-compose -f docker-compose.dev.yml build --no-cache

if %errorlevel% neq 0 (
    echo ❌ Docker build failed. Check the error messages above.
    pause
    exit /b 1
)

echo ✅ Docker build successful!

REM Test running the container briefly
echo 🚀 Testing container startup...
docker-compose -f docker-compose.dev.yml up -d

REM Wait a moment
timeout /t 5 /nobreak >nul

REM Check if container is running
docker ps | findstr icp-bets-dev >nul
if %errorlevel% neq 0 (
    echo ❌ Container failed to start. Check logs with: docker-compose -f docker-compose.dev.yml logs
    docker-compose -f docker-compose.dev.yml down
    pause
    exit /b 1
)

echo ✅ Container started successfully!

REM Stop the test container
echo 🛑 Stopping test container...
docker-compose -f docker-compose.dev.yml down

echo.
echo 🎉 Docker setup test completed successfully!
echo.
echo 🚀 You can now run the full development environment with:
echo    run-dev.bat
echo.
pause 