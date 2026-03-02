#!/bin/bash
# High-Performance "Ermin" Launcher (LLM + Media Generation)

# 1. Start LLM Server (Llama.cpp)
./llama-server \
  -hf bartowski/Qwen2.5-Coder-32B-Instruct-GGUF:Q4_K_M \
  --ngl 99 \
  --ctx-size 16384 \
  --ubatch-size 1024 \
  --threads 16 \
  --parallel 2 \
  --port 11434 \
  --host 0.0.0.0 \
  --fa &

# 2. Start Media Generation Server (SD.cpp)
# We use the pruned-emaonly 1.5 model for efficiency.
./sd-server \
  -m sd-v1-5.safetensors \
  --port 7860 \
  --host 0.0.0.0 &

echo "Ermin AI Engine started."
echo "LLM: http://localhost:11434"
echo "Media: http://localhost:7860"

wait
