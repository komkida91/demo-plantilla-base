#!/bin/bash
# Script simple para detener servidor de pruebas

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
PID_FILE="/tmp/servidor-local-$(basename "$REPO_DIR").pid"

if [ -f "$PID_FILE" ]; then
    PID=$(cat "$PID_FILE" 2>/dev/null || echo "")
    if kill -0 "$PID" 2>/dev/null; then
        echo "🛑 Deteniendo servidor (PID: $PID)..."
        kill "$PID" 2>/dev/null || true
        sleep 1
        echo "✅ Servidor detenido"
    else
        echo "⚠️  Servidor no está corriendo"
    fi
    rm -f "$PID_FILE"
else
    echo "⚠️  No se encontró archivo PID"
    echo "   El servidor puede no estar corriendo"
fi
