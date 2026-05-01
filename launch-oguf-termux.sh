#!/bin/bash
# ONE GAY UNICORN — Ultra-Robust Termux Launch Script

# Get the absolute path of the script directory
BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "🚀 Initializing OGUF components on Termux..."

# Dependency Check
echo "📦 Checking dependencies..."
# In Termux, we might need to use 'pip' or 'pip3'
PIP_CMD="pip"
if ! command -v pip &> /dev/null; then
    PIP_CMD="pip3"
fi

for pkg in flask flask-cors; do
    if ! python3 -c "import ${pkg//-/_}" &> /dev/null; then
        echo "Installing $pkg..."
        $PIP_CMD install $pkg
    fi
done

# Kill existing processes to avoid port conflicts
echo "🧹 Cleaning up old processes..."
pkill -f "orchestrator.py"
pkill -f "termux_bridge.py"
pkill -f "entanglement_twins.py"
sleep 1

# Start Orchestrator
echo "📡 Starting Orchestrator..."
cd "$BASE_DIR/src"
python3 -u orchestrator.py > "$BASE_DIR/orchestrator.log" 2>&1 &
ORCH_PID=$!

# Wait for orchestrator to initialize
echo "⏳ Waiting for orchestrator to initialize..."
MAX_RETRIES=15
COUNT=0
READY=false
while [ $COUNT -lt $MAX_RETRIES ]; do
    if curl -s http://localhost:8080/health > /dev/null 2>&1; then
        echo "✅ Orchestrator is ready!"
        READY=true
        break
    fi
    # Check if the process is still alive
    if ! kill -0 $ORCH_PID 2>/dev/null; then
        echo "❌ Orchestrator process died. Check orchestrator.log"
        cat "$BASE_DIR/orchestrator.log"
        exit 1
    fi
    echo -n "."
    COUNT=$((COUNT + 1))
    sleep 2
done
echo ""

if [ "$READY" = false ]; then
    echo "⚠️ Orchestrator timed out. Check orchestrator.log"
    cat "$BASE_DIR/orchestrator.log"
    exit 1
fi

# Start Termux Bridge
if [ -f "$BASE_DIR/src/termux-bridge/termux_bridge.py" ]; then
    cd "$BASE_DIR/src/termux-bridge"
    python3 -u termux_bridge.py > "$BASE_DIR/termux_bridge.log" 2>&1 &
    echo "✅ Termux Bridge started"
else
    echo "⚠️ Termux Bridge not found"
fi

# Start Entanglement Twins
if [ -f "$BASE_DIR/src/entanglement-twins/entanglement_twins.py" ]; then
    cd "$BASE_DIR/src/entanglement-twins"
    python3 -u entanglement_twins.py > "$BASE_DIR/entanglement_twins.log" 2>&1 &
    echo "✅ Entanglement Twins started"
else
    echo "⚠️ Entanglement Twins not found"
fi

echo ""
echo "📊 Final Status Check:"
curl -s http://localhost:8080/health | python3 -m json.tool || echo "Failed to connect to Orchestrator"
echo ""
echo "🦄 OGUF Full Stack — Active"
