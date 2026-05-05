#!/usr/bin/env bash
set -e

echo "⚠️ Reseteando la base de datos (borrando volúmenes)..."
/usr/local/bin/docker-compose down -v

echo "🚀 Reiniciando el stack..."
./reload.sh

echo "✅ Base de datos reseteada y stack reiniciado."
