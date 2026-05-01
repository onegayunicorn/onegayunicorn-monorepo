#!/bin/bash
# ONE GAY UNICORN — Full Setup Script
set -e

echo "🚀 Setting up OGUF on Manus Sandbox (Simulating Moto G35)..."

# Install dependencies
sudo pip3 install flask flask-cors requests pyyaml prometheus-client

# Make bridge script executable
chmod +x /home/ubuntu/moto-g35-orchestrator-robot/scripts/termux-bridge.sh

# Initialize bridge
/home/ubuntu/moto-g35-orchestrator-robot/scripts/termux-bridge.sh init

echo "✅ Setup complete"
echo "Next: Start orchestrator and bridge"
