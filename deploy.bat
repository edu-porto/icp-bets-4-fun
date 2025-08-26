@echo off
echo 🚀 Deploying ICP Bets Platform...

REM Check if dfx is installed
where dfx >nul 2>nul
if %errorlevel% neq 0 (
    echo ❌ DFX not found. Please install DFX first:
    echo    sh -ci "$(curl -fsSL https://internetcomputer.org/install.sh)"
    pause
    exit /b 1
)

REM Check if Node.js is installed
where node >nul 2>nul
if %errorlevel% neq 0 (
    echo ❌ Node.js not found. Please install Node.js first.
    pause
    exit /b 1
)

REM Check if npm is installed
where npm >nul 2>nul
if %errorlevel% neq 0 (
    echo ❌ npm not found. Please install npm first.
    pause
    exit /b 1
)

echo ✅ Prerequisites check passed

REM Stop any running dfx processes
echo 🛑 Stopping any running DFX processes...
dfx stop 2>nul

REM Start local Internet Computer
echo 🌐 Starting local Internet Computer...
dfx start --background --clean

REM Wait for IC to be ready
echo ⏳ Waiting for Internet Computer to be ready...
timeout /t 10 /nobreak >nul

REM Deploy canisters
echo 📦 Deploying canisters...
dfx deploy

REM Install frontend dependencies
echo 📦 Installing frontend dependencies...
cd src\frontend
npm install

REM Build frontend
echo 🔨 Building frontend...
npm run build

REM Go back to root
cd ..\..

REM Deploy frontend
echo 🚀 Deploying frontend...
dfx deploy frontend

echo.
echo 🎉 Deployment complete!
echo.
echo 🌐 Open the application:
echo    dfx canister open frontend
echo.
echo 🔧 Useful commands:
echo    dfx canister status auth      # Check auth canister status
echo    dfx canister status game      # Check game canister status
echo    dfx canister status treasury  # Check treasury canister status
echo    dfx canister status frontend  # Check frontend canister status
echo.
echo 📚 View logs:
echo    dfx logs auth
echo    dfx logs game
echo    dfx logs treasury
echo.
echo 🛑 Stop the platform:
echo    dfx stop
echo.
pause 