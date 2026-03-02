#!/bin/bash
# Natalie's High-Performance LLM Setup Script (2026)

# 1. Download llama-server binary (Bleeding edge for 2026)
echo "--- Downloading llama-server engine ---"
curl -L -o llama-server https://github.com/ggerganov/llama.cpp/releases/latest/download/llama-server-linux-x64
chmod +x llama-server

# 2. Download the Models
# This model is the sweet spot for your 128GB RAM / VRAM combo.
echo "--- Downloading Qwen-2.5-Coder-32B (~20GB) ---"
curl -L -o coder-model.gguf https://huggingface.co/bartowski/Qwen2.5-Coder-32B-Instruct-GGUF/resolve/main/Qwen2.5-Coder-32B-Instruct-Q4_K_M.gguf?download=true

# 2.5 Download Stable Diffusion for local media generation
echo "--- Downloading Stable Diffusion engine & model ---"
curl -L -o sd-server https://github.com/leejet/stable-diffusion.cpp/releases/latest/download/sd-server-linux-x64
chmod +x sd-server
curl -L -o sd-v1-5.safetensors https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/v1-5-pruned-emaonly.safetensors?download=true

# 3. Create the Launch Script
echo "--- Creating high-speed launcher ---"
cat << 'LAUNCH' > start.sh
#!/bin/bash
# 1. Start LLM Server (Llama.cpp)
./llama-server \
  -m coder-model.gguf \
  --ngl 99 \
  --ctx-size 16384 \
  --threads $(nproc) \
  --parallel 2 \
  --cont-batching \
  --port 11434 \
  --host 0.0.0.0 \
  --fa &

# 2. Start Media Generation Server (SD.cpp)
./sd-server \
  -m sd-v1-5.safetensors \
  --port 7860 \
  --host 0.0.0.0 &

wait
LAUNCH
chmod +x start.sh

echo "--- Setup Complete! ---"
echo "Run './start.sh' to begin. Your model and engine are in $(pwd)"
