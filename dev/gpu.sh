#!/usr/bin/env bash
GPU_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$GPU_SCRIPT_DIR/.." && pwd)"

if lspci | grep -i "NVIDIA" > /dev/null; then
    echo "Detected NVIDIA GPU — running ai/cuda.sh"
    bash "$REPO_ROOT/ai/cuda.sh"
elif lspci | grep -i "AMD/ATI" > /dev/null; then
    echo "Detected AMD GPU — running ai/rocm.sh"
    bash "$REPO_ROOT/ai/rocm.sh"
else
    echo "No NVIDIA or AMD discrete GPU detected — skipping CUDA/ROCm setup"
fi
