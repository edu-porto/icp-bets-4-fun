FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV DFX_VERSION=0.15.0
ENV NODE_VERSION=18

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    build-essential \
    ca-certificates \
    gnupg \
    lsb-release \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - \
    && apt-get install -y nodejs

# Install DFX
RUN sh -ci "$(curl -fsSL https://internetcomputer.org/install.sh)" \
    && echo 'export PATH="$PATH:$HOME/bin"' >> ~/.bashrc

# Install Rust (required for some DFX operations)
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y \
    && echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.bashrc

# Set working directory
WORKDIR /app

# Copy project files
COPY . .

# Install frontend dependencies
RUN cd src/frontend && npm install

# Build frontend
RUN cd src/frontend && npm run build

# Expose ports
EXPOSE 8000 3000 4943

# Create startup script
RUN echo '#!/bin/bash\n\
echo "🚀 Starting ICP Bets Platform..."\n\
echo "📦 Installing DFX dependencies..."\n\
dfx start --background --clean\n\
echo "⏳ Waiting for Internet Computer to be ready..."\n\
sleep 15\n\
echo "🔨 Deploying canisters..."\n\
dfx deploy\n\
echo "🚀 Deploying frontend..."\n\
dfx deploy frontend\n\
echo ""\n\
echo "🎉 Platform is ready!"\n\
echo "🌐 Frontend: http://localhost:3000"\n\
echo "🔗 Canister IDs:"\n\
dfx canister id auth\n\
dfx canister id game\n\
dfx canister id treasury\n\
dfx canister id frontend\n\
echo ""\n\
echo "📚 View logs: dfx logs [canister-name]"\n\
echo "🛑 Stop: dfx stop"\n\
echo ""\n\
echo "Keeping platform running... Press Ctrl+C to stop"\n\
tail -f /dev/null' > /start.sh && chmod +x /start.sh

# Set the startup script as entrypoint
ENTRYPOINT ["/start.sh"] 