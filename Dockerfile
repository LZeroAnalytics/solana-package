FROM ghcr.io/beeman/solana-test-validator:latest

# Switch to root user to install packages
USER root

RUN apt-get update && apt-get install -y \
    build-essential \
    clang \
    pkg-config libssl-dev libudev-dev \
    curl && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Rust and spl-token CLI for USDC operations
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y \
    && . ~/.cargo/env \
    && cargo install spl-token-cli

ENV PATH="/root/.cargo/bin:${PATH}"

# Create app directory
WORKDIR /app

# Copy API package files
COPY api/package*.json ./
RUN npm install

# Copy API source code
COPY api/ ./

# Build the TypeScript API
RUN npm run build

# Create entrypoint script that handles both API and validator
COPY <<EOF /entrypoint.sh
#!/bin/bash
set -e

echo "Starting API in background..."
cd /app && npm start &
API_PID=\$!
echo "API started with PID: \$API_PID"

# Wait for API to initialize
sleep 5

echo "Starting validator with command: \$@"
exec "\$@"
EOF

RUN chmod +x /entrypoint.sh

# Expose ports
# 3000 - API port
# 8899 - Solana RPC port  
# 8900 - Solana WebSocket port
EXPOSE 3000 8899 8900

# Set environment variables
ENV PORT=3000
ENV RPC_URL=http://localhost:8899
ENV LOG_LEVEL=info

# Use entrypoint script
ENTRYPOINT ["/entrypoint.sh"]
