# Sustituye por la versión que estes utilizando
FROM node:18-alpine

WORKDIR /usr/src/app

# Definir la variable de entorno para optimizaciones de producción
ENV NODE_ENV=production
ENV SERVER_PORT=3047

# Copia los archivos de empaquetado e instala ÚNICAMENTE dependencias de producción
COPY package*.json ./
RUN npm ci --only=production

# Copia el resto del código fuente del proyecto
COPY . .

# Expone el puerto a utilizar, sumale tu número de lista.
EXPOSE 3047

# Comando para iniciar la API en producción
CMD ["npm", "start"]