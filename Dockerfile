FROM node:18

RUN apt-get -y install libgtkextra-dev libgconf2-dev libnss3 libasound2 libxtst-dev libxss1

WORKDIR /src
COPY package*.json ./
RUN npm install --save-dev electron
RUN npm install --legacy-peer-deps
COPY . .
RUN npm run build

EXPOSE 3000

CMD ["npm","run","dev"]