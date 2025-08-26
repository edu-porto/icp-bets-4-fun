@echo off
echo 🐳 Starting ICP Bets Platform with Docker...

REM Check if Docker is running
docker info >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker is not running. Please start Docker Desktop first.
    pause
    exit /b 1
)

REM Check if Docker Compose is available
docker-compose --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker Compose not found. Please install Docker Compose.
    pause
    exit /b 1
)

echo ✅ Docker is running
echo 🚀 Building and starting the platform...

REM Build and start the containers
docker-compose up --build

echo.
echo 🎉 Platform stopped. To restart, run: docker-compose up
pause 