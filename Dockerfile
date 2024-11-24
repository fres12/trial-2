FROM node:22

# Install dependencies needed for Electron
RUN apt-get update && apt-get install \
    git libx11-xcb1 libxcb-dri3-0 libxtst6 libnss3 libatk-bridge2.0-0 libgtk-3-0 libxss1 libasound2 libdrm2 libgbm1 \
    -yq --no-install-suggests --no-install-recommends \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY package*.json ./
RUN  npm install --production
COPY . .
RUN npm run build
    
EXPOSE 3000
CMD npm run start