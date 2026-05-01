#!/bin/bash
# ONE GAY UNICORN — Termux Launch Script

# Get the absolute path of the script directory
BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "🚀 Launching OGUF components on Termux..."

# Start Orchestrator (if not already running)
if ! curl -s http://localhost:8080/health > /dev/null 2>&1; then
    cd "$BASE_DIR/src"
    python3 -u orchestrator.py > "$BASE_DIR/orchestrator.log" 2>&1 &
    echo "✅ Orchestrator started"
else
    echo "✅ Orchestrator already running"
fi

# Start Termux Bridge
if [ -f "$BASE_DIR/src/termux-bridge/termux_bridge.py" ]; then
    cd "$BASE_DIR/src/termux-bridge"
    python3 -u termux_bridge.py > "$BASE_DIR/termux_bridge.log" 2>&1 &
    echo "✅ Termux Bridge started"
else
    echo "⚠️ Termux Bridge not found at $BASE_DIR/src/termux-bridge/termux_bridge.py"
fi

# Start Entanglement Twins
if [ -f "$BASE_DIR/src/entanglement-twins/entanglement_twins.py" ]; then
    cd "$BASE_DIR/src/entanglement-twins"
    python3 -u entanglement_twins.py > "$BASE_DIR/entanglement_twins.log" 2>&1 &
    echo "✅ Entanglement Twins started"
else
    echo "⚠️ Entanglement Twins not found at $BASE_DIR/src/entanglement-twins/entanglement_twins.py"
fi

echo ""
echo "📊 Status:"
sleep 3
curl -s http://localhost:8080/health | python3 -u -m json.tool || echo "Failed to connect to Orchestrator"
echo ""
echo "🦄 OGUF Full Stack — Active"
