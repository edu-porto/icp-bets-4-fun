@echo off
echo 🐳 Starting ICP Bets Development Environment...

REM Check if Docker is running
docker info >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker is not running. Please start Docker Desktop first.
    pause
    exit /b 1
)

echo ✅ Docker is running
echo 🚀 Starting development environment...

REM Start the development container
docker-compose -f docker-compose.dev.yml up --build

echo.
echo 🎉 Development environment stopped.
pause 