# Gunakan Node.js versi LTS terbaru
FROM node:22

# Install dependencies yang diperlukan untuk Electron
RUN apt-get update && apt-get install -yq --no-install-recommends \
    git libx11-xcb1 libxcb-dri3-0 libxtst6 libnss3 libatk-bridge2.0-0 libgtk-3-0 \
    libxss1 libasound2 libdrm2 libgbm1 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Tambahkan user non-root
RUN useradd -m -d /custom-app custom-app

# Atur direktori kerja
WORKDIR /custom-app

# Salin file package.json dan package-lock.json terlebih dahulu
COPY package*.json ./

# Install dependencies sebagai user root
RUN npm install --no-optional && \
    npm cache clean --force

# Salin semua file dari direktori proyek ke dalam container
COPY . .

# Set hak akses direktori
RUN chown -R custom-app:custom-app /custom-app

# Jalankan aplikasi dengan user non-root
USER custom-app

# Port default yang digunakan aplikasi
EXPOSE 3000

# Jalankan aplikasi
CMD ["npm", "run", "start"]
