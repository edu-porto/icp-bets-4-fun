#!/bin/bash

echo "🚀 Starting ICP Bets in WSL..."
echo ""

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js not found. Installing Node.js..."
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    sudo apt-get install -y nodejs
    echo "✅ Node.js installed!"
fi

# Check if dfx is installed
if ! command -v dfx &> /dev/null; then
    echo "❌ DFX not found. Installing DFX..."
    sh -ci "$(curl -fsSL https://internetcomputer.org/install.sh)"
    echo "export PATH=\"\$HOME/bin:\$PATH\"" >> ~/.bashrc
    export PATH="$HOME/bin:$PATH"
    echo "✅ DFX installed!"
fi

echo "✅ All dependencies found!"
echo ""
echo "🚀 Starting the app..."

# Install frontend dependencies
cd src/frontend
echo "📦 Installing frontend dependencies..."
npm install

# Build frontend
echo "🔨 Building frontend..."
npm run build

# Go back to root
cd ../..

# Start local Internet Computer
echo "🌐 Starting local Internet Computer..."
dfx start --background

# Wait a moment
sleep 5

# Deploy canisters
echo "📦 Deploying canisters..."
dfx deploy

# Deploy frontend
echo "🚀 Deploying frontend..."
dfx deploy frontend

echo ""
echo "🎉 APP IS READY!"
echo ""
echo "🌐 Open your browser and go to:"
echo "   http://localhost:8000"
echo ""
echo "🎥 Record your video now!"
echo ""
echo "🛑 To stop the app, press Ctrl+C"
echo ""

# Keep running
tail -f /dev/null 