#!/bin/bash

# --- 1. Auto-Detection & Hardware Check ---
COMFY_DIR=$(find "$HOME" -maxdepth 3 -name "main.py" | grep "ComfyUI/main.py" | head -n 1 | xargs dirname)

if [ -z "$COMFY_DIR" ]; then
    echo "❌ Error: Could not find ComfyUI directory in $HOME."
    exit 1
fi

# Detect GPU type
if lspci | grep -i "NVIDIA" > /dev/null; then
    GPU_TYPE="nvidia"
    echo "🔍 Hardware detected: NVIDIA GPU"
elif lspci | grep -i "AMD/ATI" > /dev/null; then
    GPU_TYPE="amd"
    echo "🔍 Hardware detected: AMD GPU (ROCm Path)"
else
    GPU_TYPE="cpu"
    echo "⚠️ No dedicated GPU detected. Falling back to CPU."
fi

SERVICE_NAME="comfyui.service"
VENV_DIR="$COMFY_DIR/venv"
PYTHON_BIN="$VENV_DIR/bin/python"
CURRENT_USER=$USER
CURRENT_GROUP=$(id -gn)

# --- 2. Fedora System Prep ---
echo "🛠️ Installing Fedora dependencies..."
sudo dnf install python3-venv python3-pip pciutils -y

# --- 3. Environment & Hardware Setup ---
if [ ! -d "$VENV_DIR" ]; then
    echo "📦 Creating Virtual Environment..."
    python3 -m venv "$VENV_DIR"
fi

"$PYTHON_BIN" -m pip install --upgrade pip

if [ "$GPU_TYPE" == "nvidia" ]; then
    echo "🐍 Installing Torch (CUDA 12.4+)..."
    "$PYTHON_BIN" -m pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu124
elif [ "$GPU_TYPE" == "amd" ]; then
    echo "🐍 Installing Torch (ROCm 6.2+)..."
    "$PYTHON_BIN" -m pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/rocm6.2
else
    echo "🐍 Installing Torch (CPU)..."
    "$PYTHON_BIN" -m pip install torch torchvision torchaudio
fi

"$PYTHON_BIN" -m pip install -r "$COMFY_DIR/requirements.txt"

# --- 4. The Fedora "Service Sandbox" Fix ---
echo "⚙️ Generating Systemd Service..."

# AMD Override: Many consumer cards (RX 6000/7000) need this to be recognized by ROCm
AMD_ENV=""
if [ "$GPU_TYPE" == "amd" ]; then
    # Forces RDNA3/RDNA2 cards to act as supported hardware if they aren't officially on the list
    AMD_ENV="Environment=HSA_OVERRIDE_GFX_VERSION=11.0.0" 
fi

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
$AMD_ENV
ExecStart=$PYTHON_BIN $COMFY_DIR/main.py --listen 127.0.0.1 --port 8188
Restart=always
RestartSec=10

ProtectHome=read-only
ProtectSystem=full
NoNewPrivileges=no
PrivateTmp=true

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
sudo chcon -t bin_t "$PYTHON_BIN" 2>/dev/null
sudo chcon -R -t bin_t "$VENV_DIR" 2>/dev/null
sudo setsebool -P httpd_can_network_connect 1 2>/dev/null
sudo setsebool -P nis_enabled 1 2>/dev/null
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
echo "✅ Setup Complete for $GPU_TYPE!"
echo "📡 Access at: http://127.0.0.1:8188"