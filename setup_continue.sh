#!/bin/bash
# Natalie's High-Performance LLM Setup Script (2026)

# 1. Download llama-server binary (Bleeding edge for 2026)
echo "--- Downloading llama-server engine ---"
curl -L -o llama-server https://github.com/ggerganov/llama.cpp/releases/latest/download/llama-server-linux-x64
chmod +x llama-server

# 2. Download the Model (Qwen-2.5-Coder-32B Q4_K_M)
# This model is the sweet spot for your 128GB RAM / VRAM combo.
echo "--- Downloading Qwen-2.5-Coder-32B (~20GB) ---"
curl -L -o coder-model.gguf https://huggingface.co/bartowski/Qwen2.5-Coder-32B-Instruct-GGUF/resolve/main/Qwen2.5-Coder-32B-Instruct-Q4_K_M.gguf?download=true

# 3. Create the Launch Script
echo "--- Creating high-speed launcher ---"
cat << 'LAUNCH' > start.sh
#!/bin/bash
./llama-server \
  -m coder-model.gguf \
  --ngl 99 \
  --ctx-size 16384 \
  --threads $(nproc) \
  --parallel 2 \
  --cont-batching \
  --port 11434 \
  --host 0.0.0.0 \
  --fa
LAUNCH
chmod +x start.sh

echo "--- Setup Complete! ---"
echo "Run './start.sh' to begin. Your model and engine are in $(pwd)"
