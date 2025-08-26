#!/bin/bash

echo "🐳 Starting ICP Bets Platform with Docker..."

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker first."
    exit 1
fi

# Check if Docker Compose is available
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose not found. Please install Docker Compose."
    exit 1
fi

echo "✅ Docker is running"
echo "🚀 Building and starting the platform..."

# Build and start the containers
docker-compose up --build

echo ""
echo "🎉 Platform stopped. To restart, run: docker-compose up" 