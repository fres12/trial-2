FROM node:18

LABEL RUN="podman run -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix$DISPLAY -v $(pwd)/src:/app/src --rm -it electron-wrapper bash"

RUN apt-get update && apt-get install \
    git libx11-xcb1 libxcb-dri3-0 libxtst6 libnss3 libatk-bridge2.0-0 libgtk-3-0 libxss1 libasound2 \
    -yq --no-install-suggests --no-install-recommends \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY package*.json ./

# Pastikan direktori /app dibuat dan dimiliki oleh pengguna node
RUN mkdir -p /app && chown -R node:node /app

USER node
RUN npm install
RUN npx electron-rebuild

# Kembalikan ke root untuk sandbox Electron
USER root
RUN chown root /app/node_modules/electron/dist/chrome-sandbox
RUN chmod 4755 /app/node_modules/electron/dist/chrome-sandbox

USER node
CMD bash
