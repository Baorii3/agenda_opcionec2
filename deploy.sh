#!/usr/bin/env bash
set -e

# Configuración
PROJECT_DIR="/root/agenda/agenda_ec2_barata"
API_DIR="/root/agenda/AGENDA_API"
KEY_FILE="$PROJECT_DIR/agenda-key.pem"

# 1. Obtener IP de Terraform automáticamente
echo "🔍 Buscando IP del servidor en Terraform..."
IP=$(cd "$PROJECT_DIR/terraform" && terraform output -raw public_ip | tr -d '\r')

if [ -z "$IP" ] || [ "$IP" == "exit" ]; then
    echo "❌ Error: No se pudo obtener la IP de Terraform. Asegúrate de haber hecho 'terraform apply'."
    exit 1
fi

echo "🚀 Desplegando en: http://$IP"

# 2. Sincronizar archivos con rsync (Mucho más eficiente)
echo "📦 Subiendo configuración..."
rsync -avP --delete -e "ssh -i $KEY_FILE -o StrictHostKeyChecking=no" \
    --exclude '/terraform' \
    --exclude '/.git' \
    "$PROJECT_DIR/" "ec2-user@$IP:/home/ec2-user/agenda_ec2_barata/"

echo "📦 Subiendo carpeta API..."
rsync -avP --delete -e "ssh -i $KEY_FILE -o StrictHostKeyChecking=no" \
    --exclude '/target' \
    --exclude '/.git' \
    --exclude '/.mvn' \
    "$API_DIR/" "ec2-user@$IP:/home/ec2-user/AGENDA_API/"

# 3. Lanzar reload en remoto
echo "🔥 Reiniciando aplicación en el servidor..."
ssh -i "$KEY_FILE" -o StrictHostKeyChecking=no ec2-user@"$IP" "cd agenda_ec2_barata && chmod +x reload.sh && ./reload.sh"

echo ""
echo "✅ ¡Listo! La agenda está desplegada en: http://$IP"
