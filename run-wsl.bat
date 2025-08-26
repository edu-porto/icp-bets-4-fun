@echo off
echo 🐧 Starting ICP Bets in WSL (Windows Subsystem for Linux)
echo.

REM Check if WSL is available
wsl --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ WSL not found. Please enable WSL first:
    echo    wsl --install
    pause
    exit /b 1
)

echo ✅ WSL found! Opening WSL terminal...
echo.
echo 🚀 The project will start in WSL. Follow these steps:
echo.
echo 1. When WSL opens, the project will start automatically
echo 2. Wait for "APP IS READY!" message
echo 3. Open your browser to: http://localhost:8000
echo 4. Record your video!
echo.
echo 🛑 To stop: Press Ctrl+C in the WSL terminal
echo.

REM Open WSL and run the project
wsl bash -c "cd /mnt/c/Users/Inteli/Documents/GitHub/icp-bets-4-fun && ./start-project.sh"

pause 