#!/bin/bash
# ONE GAY UNICORN — Robust Termux Launch Script

# Get the absolute path of the script directory
BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "🚀 Initializing OGUF components on Termux..."

# Dependency Check
echo "📦 Checking dependencies..."
if ! python3 -c "import flask" &> /dev/null; then
    echo "Installing Flask..."
    pip install flask
fi
if ! python3 -c "import flask_cors" &> /dev/null; then
    echo "Installing Flask-CORS..."
    pip install flask-cors
fi

# Start Orchestrator (if not already running)
if ! curl -s http://localhost:8080/health > /dev/null 2>&1; then
    cd "$BASE_DIR/src"
    python3 -u orchestrator.py > "$BASE_DIR/orchestrator.log" 2>&1 &
    echo "✅ Orchestrator started"
else
    echo "✅ Orchestrator already running"
fi

# Wait for orchestrator to initialize
echo "⏳ Waiting for orchestrator to initialize..."
MAX_RETRIES=10
COUNT=0
while [ $COUNT -lt $MAX_RETRIES ]; do
    if curl -s http://localhost:8080/health > /dev/null 2>&1; then
        echo "✅ Orchestrator is ready!"
        break
    fi
    echo -n "."
    COUNT=$((COUNT + 1))
    sleep 2
done
echo ""

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
curl -s http://localhost:8080/health | python3 -m json.tool || echo "Failed to connect to Orchestrator"
echo ""
echo "🦄 OGUF Full Stack — Active"
