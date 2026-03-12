#!/bin/bash

# --- 1. Auto-Detection ---
# Locates ComfyUI/main.py within 3 levels of $HOME
COMFY_DIR=$(find "$HOME" -maxdepth 3 -name "main.py" | grep "ComfyUI/main.py" | head -n 1 | xargs dirname)

if [ -z "$COMFY_DIR" ]; then
    echo "❌ Error: Could not find ComfyUI directory in $HOME. Please ensure it is named 'ComfyUI'."
    exit 1
fi

SERVICE_NAME="comfyui.service"
VENV_DIR="$COMFY_DIR/venv"
PYTHON_BIN="$VENV_DIR/bin/python"
CURRENT_USER=$USER
CURRENT_GROUP=$(id -gn)

echo "📍 Target detected: $COMFY_DIR"
echo "👤 Running as user: $CURRENT_USER"

# --- 2. Fedora System Prep ---
echo "🛠️ Installing Fedora dependencies..."
sudo dnf install python3-venv python3-pip -y

# --- 3. Environment & Hardware Setup (RTX 50 Series) ---
if [ ! -d "$VENV_DIR" ]; then
    echo "📦 Creating Virtual Environment..."
    python3 -m venv "$VENV_DIR"
fi

echo "🐍 Upgrading Pip and Installing Torch (CUDA 12.8+)..."
"$PYTHON_BIN" -m pip install --upgrade pip
# Using cu124/cu128 as the base for RTX 50 series stability
"$PYTHON_BIN" -m pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu124
"$PYTHON_BIN" -m pip install -r "$COMFY_DIR/requirements.txt"

# --- 4. The Fedora "Service Sandbox" Fix ---
echo "⚙️ Generating Systemd Service with Read/Write overrides..."

sudo tee /etc/systemd/system/$SERVICE_NAME > /dev/null <<EOF
[Unit]
Description=ComfyUI AI Generation Tool
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=$CURRENT_USER
Group=$CURRENT_GROUP
WorkingDirectory=$COMFY_DIR
ExecStart=$PYTHON_BIN $COMFY_DIR/main.py --listen 127.0.0.1 --port 8188
Restart=always
RestartSec=10

# FEDORA SECURITY BYPASS:
# Allow service to 'see' home but keep it restricted
ProtectHome=read-only
ProtectSystem=full
NoNewPrivileges=no
PrivateTmp=true

# CRITICAL: Punch holes for ComfyUI to write its database and images
ReadWritePaths=$COMFY_DIR
ReadWritePaths=$COMFY_DIR/temp
ReadWritePaths=$COMFY_DIR/output
ReadWritePaths=$COMFY_DIR/user
ReadWritePaths=$COMFY_DIR/models

[Install]
WantedBy=multi-user.target
EOF

# --- 5. SELinux & Permission Hardening ---
echo "🔓 Applying SELinux executable contexts..."
# Fixes the 203/EXEC error by marking the venv as executable code
sudo chcon -t bin_t "$PYTHON_BIN" 2>/dev/null
sudo chcon -R -t bin_t "$VENV_DIR" 2>/dev/null

# Allow the service to bind to the network port
sudo setsebool -P httpd_can_network_connect 1 2>/dev/null
sudo setsebool -P nis_enabled 1 2>/dev/null

# Fix folder ownership just in case
sudo chown -R $CURRENT_USER:$CURRENT_GROUP "$COMFY_DIR"

# --- 6. Launch ---
echo "🚀 Reloading Systemd and Starting Service..."
sudo systemctl daemon-reload
sudo systemctl enable "$SERVICE_NAME"
sudo systemctl restart "$SERVICE_NAME"

# Open Firewall
sudo firewall-cmd --permanent --add-port=8188/tcp 2>/dev/null
sudo firewall-cmd --reload 2>/dev/null

echo "---"
echo "✅ Setup Complete for $CURRENT_USER!"
echo "📡 Access at: http://127.0.0.1:8188"
echo "📜 View logs with: sudo journalctl -u $SERVICE_NAME -f"