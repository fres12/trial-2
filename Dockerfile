FROM node:22

# Install dependencies for Electron and Xvfb
RUN apt-get update && apt-get install -y \
    xvfb \
    git libx11-xcb1 libxcb-dri3-0 libxtst6 libnss3 libatk-bridge2.0-0 libgtk-3-0 libxss1 libasound2 libdrm2 libgbm1 \
    -yq --no-install-suggests --no-install-recommends \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Add a non-root user
RUN useradd -m -d /custom-app custom-app
WORKDIR /custom-app

# Copy the rest of the application
COPY . .

# Install npm dependencies
RUN npm install

# Debug to ensure other files are copied
RUN ls -la

# Fix permissions for Electron chrome-sandbox binary AFTER npm install
USER root
RUN chown root:root /custom-app/node_modules/electron/dist/chrome-sandbox && \
    chmod 4755 /custom-app/node_modules/electron/dist/chrome-sandbox

# Optionally enable unprivileged user namespaces (workaround #3)
RUN echo "kernel.unprivileged_userns_clone=1" > /etc/sysctl.d/99-userns.conf && \
    sysctl -p /etc/sysctl.d/99-userns.conf || true

# Set npm cache location
RUN npm config set cache /tmp/npm-cache

# Set npm global directory to avoid permission issues
ENV NPM_CONFIG_PREFIX=/home/node/.npm-global
ENV PATH=$PATH:/home/node/.npm-global/bin

# Set ownership of the working directory and node_modules
RUN mkdir -p /custom-app/node_modules && chown -R custom-app:custom-app /custom-app

# Switch back to the non-root user
USER custom-app

# Expose port for the application
EXPOSE 3000

# Start the application with --no-sandbox and Xvfb
CMD ["xvfb-run", "--auto-servernum", "--server-args='-screen 0 1024x768x24'", "npm", "run", "start", "--", "--no-sandbox"]