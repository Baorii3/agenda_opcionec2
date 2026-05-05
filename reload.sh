#!/usr/bin/env bash
set -e

# Script de recarga para la versión barata (EC2)
# Este script construye las imágenes de Docker localmente en la EC2 y las levanta.

# 1. Verificar si existe el archivo .env con los secretos
if [ ! -f .env ]; then
    echo "⚠️ Error: No se encuentra el archivo .env"
    echo "Crea un archivo .env con las siguientes variables:"
    echo "GOOGLE_CLIENT_ID=..."
    echo "GOOGLE_CLIENT_SECRET=..."
    echo "AWS_COGNITO_USER_POOL_ID=..."
    echo "AWS_COGNITO_CLIENT_ID=..."
    exit 1
fi

# 2. Generar certificados si no existen
if [ ! -d certs ]; then
    echo "🔐 Generando certificados auto-firmados..."
    mkdir certs
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout certs/nginx.key -out certs/nginx.crt \
        -subj "/C=ES/ST=Barcelona/L=Barcelona/O=Agenda/OU=IT/CN=localhost"
fi

echo "🚀 Iniciando recarga de la Agenda (Versión Barata)..."

# 3. Levantar los contenedores
# Primero bajamos los contenedores antiguos y limpiamos caché para liberar RAM antes de compilar
echo "🧹 Liberando RAM para la compilación..."
/usr/local/bin/docker-compose down || true
docker builder prune -f || true

# Construimos la imagen de la API manualmente para evitar problemas con buildx
echo "🛠️ Construyendo imagen de la API..."
docker build -t agenda_ec2_barata-api ../AGENDA_API


echo "🚢 Levantando servicios..."
/usr/local/bin/docker-compose up -d

echo "✅ ¡Listo! La agenda está corriendo en http://localhost"
echo "Puedes ver los logs con: docker compose logs -f"
