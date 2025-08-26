# 🚀 SUPER SIMPLE SETUP - Just Run the App!

## 🎯 **What You Need:**
1. **WSL (Windows Subsystem for Linux)** - You already have this! ✅
2. **That's it!**

## 🚀 **How to Run (2 Steps):**

### **Step 1: Double-click this file**
```
run-wsl.bat
```

### **Step 2: Wait for it to finish**
- It will open WSL automatically
- Install Node.js and DFX if needed
- Start the local Internet Computer
- Deploy all canisters
- Show you "APP IS READY!"

### **Step 3: Open your browser**
Go to: **http://localhost:8000**

## 🎥 **Record Your Video:**
- The app will be running at `http://localhost:8000`
- You can sign in with Internet Identity
- Play the betting games (Rock Paper Scissors, Coin Flip)
- Show the treasury stats
- Everything works locally

## 🛑 **To Stop:**
- Press `Ctrl+C` in the WSL terminal
- Or just close the WSL terminal window

## ❌ **If Something Goes Wrong:**

### **"WSL not found"**
- Run this in PowerShell as Administrator: `wsl --install`
- Restart your computer
- Run `run-wsl.bat` again

### **Permission denied in WSL**
- The script will handle this automatically
- If you get permission errors, just run `run-wsl.bat` again

### **Port already in use**
- Close other applications that might be using port 8000
- Or restart your computer

## 🔧 **Manual WSL Commands (if you prefer):**
```bash
# Open WSL
wsl

# Navigate to project
cd /mnt/c/Users/Inteli/Documents/GitHub/icp-bets-4-fun

# Run the project
./start-project.sh
```

## 🌟 **Why WSL is Better:**
- **Linux commands work perfectly** (no Windows compatibility issues)
- **DFX runs natively** (it's designed for Linux)
- **All dependencies install smoothly** (no Windows path issues)
- **Same experience as Mac/Linux developers**

---

**That's it! Just run `run-wsl.bat` and record your video! 🎬**

**WSL handles everything - you get a Linux environment inside Windows! 🐧** 