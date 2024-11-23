FROM node:slim

# Set the working directory
WORKDIR /usr/src/app

# Copy package.json and package-lock.json for dependency installation
COPY package*.json ./

# Update and install necessary dependencies for Electron
RUN apt-get update && apt-get install -y \
    libgtkextra-dev \
    libgconf2-dev \
    libnss3 \
    libasound2 \
    libxtst-dev \
    libxss1 \
    libx11-xcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxi6 \
    libxrandr2 \
    libxrender1 \
    libxslt1-dev \
    libasound2-dev \
    && apt-get clean

# Install npm dependencies
RUN npm install --save-dev electron --legacy-peer-deps

# Install project dependencies
COPY . . 
RUN npm install

# Make the start script executable
RUN chmod +x /usr/src/app/start.sh

# Set the command to run your application
CMD ["/usr/src/app/start.sh"]
