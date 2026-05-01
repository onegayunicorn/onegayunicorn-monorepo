#!/bin/bash
# OGUF Launch Script

echo "🦄 Starting OGUF Stack..."

# Start orchestrator in background
python3 /home/ubuntu/onegayunicorn-monorepo/src/orchestrator.py > /home/ubuntu/orchestrator.log 2>&1 &
ORCH_PID=$!
echo $ORCH_PID > /home/ubuntu/orchestrator.pid

echo "✅ Orchestrator started with PID $ORCH_PID"

# Wait for it to be ready
sleep 2

# Verify
if curl -s http://localhost:8080/health > /dev/null; then
    echo "🟢 Orchestrator is healthy!"
    curl -s http://localhost:8080/health | jq .
else
    echo "🔴 Orchestrator failed to start. Check /home/ubuntu/orchestrator.log"
fi

# Run bridge status
/home/ubuntu/moto-g35-orchestrator-robot/scripts/termux-bridge.sh status
