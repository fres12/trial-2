# Use a compatible Node.js version
FROM node:18-slim

# Install Electron dependencies
RUN apt-get update && apt-get install -y \
    git \
    libx11-xcb1 \
    libxcb-dri3-0 \
    libxtst6 \
    libnss3 \
    libatk-bridge2.0-0 \
    libgtk-3-0 \
    libxss1 \
    libasound2 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies as root to avoid permission issues
RUN npm install --legacy-peer-deps

# Copy application files
COPY . .

# Rebuild native modules for Electron
RUN npx electron-rebuild

# Set correct permissions for the app folder
RUN chown -R node:node /app

# Switch to a non-root user
USER node

# Electron needs special sandbox permissions (fix known issue)
RUN chmod 4755 /app/node_modules/electron/dist/chrome-sandbox

# Default command
CMD ["bash"]
