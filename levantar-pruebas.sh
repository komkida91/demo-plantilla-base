#!/bin/bash
# Script simple para levantar entorno de pruebas local
# Uso: bash levantar-pruebas.sh [puerto]

PORT="${1:-8080}"
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "🧪 Levantando servidor de pruebas..."
echo "📁 Directorio: $REPO_DIR"
echo "🔗 Puerto: $PORT"
echo ""

cd "$REPO_DIR"

# Detener servidor anterior si existe
PID_FILE="/tmp/servidor-local-$(basename "$REPO_DIR").pid"
if [ -f "$PID_FILE" ]; then
    OLD_PID=$(cat "$PID_FILE" 2>/dev/null || echo "")
    if kill -0 "$OLD_PID" 2>/dev/null; then
        echo "⚠️  Deteniendo servidor anterior (PID: $OLD_PID)..."
        kill "$OLD_PID" 2>/dev/null || true
        sleep 1
    fi
    rm -f "$PID_FILE"
fi

# Levantar servidor
if command -v python3 &> /dev/null; then
    nohup python3 -m http.server "$PORT" --bind 0.0.0.0 > /tmp/servidor-$(basename "$REPO_DIR").log 2>&1 &
    SERVER_PID=$!
elif command -v python &> /dev/null; then
    nohup python -m SimpleHTTPServer "$PORT" > /tmp/servidor-$(basename "$REPO_DIR").log 2>&1 &
    SERVER_PID=$!
else
    echo "❌ Python no encontrado"
    exit 1
fi

# Guardar PID
echo "$SERVER_PID" > "$PID_FILE"

# Esperar a que inicie
sleep 3

# Verificar
if kill -0 "$SERVER_PID" 2>/dev/null; then
    echo "✅ Servidor levantado correctamente"
    echo ""
    echo "📋 Información:"
    echo "   🔗 URL: http://localhost:$PORT"
    echo "   📝 PID: $SERVER_PID"
    echo ""
    echo "🛑 Para detener:"
    echo "   kill $SERVER_PID"
    echo "   o"
    echo "   bash detener-pruebas.sh"
    echo ""
else
    echo "❌ Error al levantar servidor"
    rm -f "$PID_FILE"
    exit 1
fi
