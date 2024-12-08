FROM node:22

WORKDIR /app
COPY package*.json ./

# Instal semua dependensi, termasuk devDependencies untuk proses build
RUN npm install --legacy-peer-deps

COPY . . 
# Bangun proyek menggunakan devDependencies
RUN npm run build

# Hapus devDependencies untuk image final
RUN npm prune --production

EXPOSE 3000

# Jalankan aplikasi
CMD ["npm", "run", "start"]