#!/bin/bash
if lspci | grep -i "NVIDIA" > /dev/null; then
    echo "Detected NVIDIA GPU — running ai/cuda.sh"
    sh ../ai/cuda.sh
elif lspci | grep -i "AMD/ATI" > /dev/null; then
    echo "Detected AMD GPU — running ai/rocm.sh"
    sh ../ai/rocm.sh
else
    echo "No NVIDIA or AMD discrete GPU detected — skipping CUDA/ROCm setup"
fi