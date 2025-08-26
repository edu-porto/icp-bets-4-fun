@echo off
echo 🚀 Starting ICP Bets - SIMPLE MODE
echo.

REM Check if Node.js is installed
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Node.js not found. Please install Node.js first: https://nodejs.org/
    pause
    exit /b 1
)

REM Check if dfx is installed
dfx --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ DFX not found. Installing now...
    echo.
    echo 📦 Installing DFX...
    echo Please run this command in a new terminal:
    echo sh -ci "$(curl -fsSL https://internetcomputer.org/install.sh)"
    echo.
    echo 🔄 After installation, restart your terminal and run this script again.
    pause
    exit /b 1
)

echo ✅ All dependencies found!
echo.
echo 🚀 Starting the app...

REM Install frontend dependencies
cd src\frontend
echo 📦 Installing frontend dependencies...
npm install

REM Build frontend
echo 🔨 Building frontend...
npm run build

REM Go back to root
cd ..\..

REM Start local Internet Computer
echo 🌐 Starting local Internet Computer...
dfx start --background

REM Wait a moment
timeout /t 5 /nobreak >nul

REM Deploy canisters
echo 📦 Deploying canisters...
dfx deploy

REM Deploy frontend
echo 🚀 Deploying frontend...
dfx deploy frontend

echo.
echo 🎉 APP IS READY!
echo.
echo 🌐 Open your browser and go to:
echo    http://localhost:8000
echo.
echo 🎥 Record your video now!
echo.
echo 🛑 To stop the app, press Ctrl+C
echo.

REM Keep running
pause 