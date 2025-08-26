@echo off
echo 🐳 Starting ICP Bets Minimal Development Environment...

REM Check if Docker is running
docker info >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker is not running. Please start Docker Desktop first.
    pause
    exit /b 1
)

echo ✅ Docker is running
echo 🚀 Starting minimal development environment...

REM Start the minimal development container
docker-compose -f docker-compose.minimal.yml up --build

echo.
echo 🎉 Minimal development environment stopped.
pause 