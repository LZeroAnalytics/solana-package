FROM ghcr.io/beeman/solana-test-validator:latest

# Switch to root user to install packages
USER root

# Install Node.js and npm
RUN apt-get update && apt-get install -y \
    curl \
    && curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Note: SPL Token CLI not available in this base image
# USDC funding will be disabled until proper SPL tools are available

# Create app directory
WORKDIR /app

# Copy API package files
COPY api/package*.json ./
RUN npm install

# Copy API source code
COPY api/ ./

# Build the TypeScript API
RUN npm run build

# Create startup script
RUN echo '#!/bin/bash\n\
# Start Solana test validator in background\n\
solana-test-validator \
  --ledger /tmp/solana-ledger \
  --rpc-port 8899 \
  --reset \
  --quiet &\n\
\n\
# Wait for validator to start\n\
sleep 10\n\
\n\
# Start the API\n\
cd /app && npm start\n\
' > /start.sh && chmod +x /start.sh

# Expose ports
# 3000 - API port
# 8899 - Solana RPC port  
# 8900 - Solana WebSocket port
EXPOSE 3000 8899 8900

# Set environment variables
ENV PORT=3000
ENV RPC_URL=http://localhost:8899
ENV LOG_LEVEL=info

# Start both services
CMD ["/start.sh"]
