FROM node:22

# Install dependencies needed for Electron
RUN apt-get update && apt-get install \
    git libx11-xcb1 libxcb-dri3-0 libxtst6 libnss3 libatk-bridge2.0-0 libgtk-3-0 libxss1 libasound2 \
    -yq --no-install-suggests --no-install-recommends \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN useradd -d /programmable-matter programmable-matter
WORKDIR /programmable-matter
COPY . .

# Configure npm cache location
RUN npm config set cache /tmp/npm-cache

# Install dependencies as root
USER root
RUN npm cache clean --force
RUN npm install --legacy-peer-deps --loglevel verbose

# Electron-specific permissions
RUN chown root /programmable-matter/node_modules/electron/dist/chrome-sandbox
RUN chmod 4755 /programmable-matter/node_modules/electron/dist/chrome-sandbox

# Switch to the non-root user
USER programmable-matter

# Start the application
CMD npm run start
