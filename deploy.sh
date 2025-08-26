#!/bin/bash

echo "🚀 Deploying ICP Bets Platform..."

# Check if dfx is installed
if ! command -v dfx &> /dev/null; then
    echo "❌ DFX not found. Please install DFX first:"
    echo "   sh -ci \"\$(curl -fsSL https://internetcomputer.org/install.sh)\""
    exit 1
fi

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js not found. Please install Node.js first."
    exit 1
fi

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    echo "❌ npm not found. Please install npm first."
    exit 1
fi

echo "✅ Prerequisites check passed"

# Stop any running dfx processes
echo "🛑 Stopping any running DFX processes..."
dfx stop 2>/dev/null || true

# Start local Internet Computer
echo "🌐 Starting local Internet Computer..."
dfx start --background --clean

# Wait for IC to be ready
echo "⏳ Waiting for Internet Computer to be ready..."
sleep 10

# Deploy canisters
echo "📦 Deploying canisters..."
dfx deploy

# Install frontend dependencies
echo "📦 Installing frontend dependencies..."
cd src/frontend
npm install

# Build frontend
echo "🔨 Building frontend..."
npm run build

# Go back to root
cd ../..

# Deploy frontend
echo "🚀 Deploying frontend..."
dfx deploy frontend

echo ""
echo "🎉 Deployment complete!"
echo ""
echo "🌐 Open the application:"
echo "   dfx canister open frontend"
echo ""
echo "🔧 Useful commands:"
echo "   dfx canister status auth      # Check auth canister status"
echo "   dfx canister status game      # Check game canister status"
echo "   dfx canister status treasury  # Check treasury canister status"
echo "   dfx canister status frontend  # Check frontend canister status"
echo ""
echo "📚 View logs:"
echo "   dfx logs auth"
echo "   dfx logs game"
echo "   dfx logs treasury"
echo ""
echo "🛑 Stop the platform:"
echo "   dfx stop" 