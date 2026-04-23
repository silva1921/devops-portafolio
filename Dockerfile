# Stage 1: Build
FROM node:22.12.0-alpine AS builder

WORKDIR /app

# Copiar archivos de dependencias
COPY package*.json ./

# Instalar dependencias
RUN npm ci

# Copiar código fuente
COPY . .

# Construir la aplicación
RUN npm run build

# Stage 2: Runtime
FROM node:22.12.0-alpine

WORKDIR /app

# Instalar solo dependencias de producción
COPY package*.json ./
RUN npm ci --omit=dev

# Copiar build desde la etapa anterior
COPY --from=builder /app/dist ./dist

# Exposer puerto
EXPOSE 3000

# Variables de entorno
ENV HOST=0.0.0.0
ENV PORT=3000

# Comando por defecto
CMD ["npm", "run", "preview"]
