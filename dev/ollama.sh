#!/bin/bash

# 1. Configuration Variables
# We use /usr/share/ollama for system-wide model storage (SELinux friendly)
DATA_DIR="/usr/share/ollama"
CURRENT_USER=$(whoami)

# 2. Install via official script
# This is superior to DNF for high-end NVIDIA cards as it pulls verified CUDA runners
echo "📦 Downloading and installing official Ollama binary..."
curl -fsSL https://ollama.com/install.sh | sh

# 3. Setup Dedicated Data Directory
# We move models out of /home to prevent SELinux 'Permission Denied' loops
echo "📂 Configuring storage at $DATA_DIR..."
sudo mkdir -p $DATA_DIR/.ollama/models
sudo chown -R $CURRENT_USER:$CURRENT_USER $DATA_DIR
sudo chmod -R 775 $DATA_DIR

# 4. Create the Systemd Service
echo "⚙️ Creating systemd service..."
sudo tee /etc/systemd/system/ollama.service > /dev/null <<EOF
[Unit]
Description=Ollama Service
After=network-online.target
Wants=network-online.target

[Service]
ExecStart=/usr/local/bin/ollama serve
User=$CURRENT_USER
Group=$CURRENT_USER
Restart=always
RestartSec=3

# Environment variables
Environment="HOME=$DATA_DIR"
Environment="OLLAMA_MODELS=$DATA_DIR/.ollama/models"

# Force use of NVIDIA GPU (ignores integrated AMD graphics)
Environment="CUDA_VISIBLE_DEVICES=0"

# Allow service to write to its data directory
ReadWritePaths=$DATA_DIR

[Install]
WantedBy=multi-user.target
EOF

# 5. Apply Fedora Security Overrides
# Tells SELinux to allow the service to talk to the internet and access its files
echo "🔓 Applying Fedora SELinux overrides..."
sudo setsebool -P httpd_can_network_connect 1 2>/dev/null
sudo restorecon -v /usr/local/bin/ollama 2>/dev/null
sudo restorecon -Rv $DATA_DIR 2>/dev/null

# 6. Enable and Start
echo "🚀 Launching Ollama..."
sudo systemctl daemon-reload
sudo systemctl enable ollama
sudo systemctl restart ollama

echo "---"
echo "✅ INSTALL COMPLETE!"
echo "Model storage: $DATA_DIR/.ollama/models"
echo "---"
sleep 2
sudo systemctl status ollama --no-pager

echo 'export PATH=$PATH:/usr/local/bin' >> ~/.bashrc
source ~/.bashrc