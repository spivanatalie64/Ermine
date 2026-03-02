#!/bin/bash
# High-Performance "Ermine" Launcher
./llama-server \
  -hf bartowski/Qwen2.5-Coder-32B-Instruct-GGUF:Q4_K_M \
  --ngl 99 \
  --ctx-size 16384 \
  --ubatch-size 1024 \
  --threads 16 \
  --parallel 2 \
  --port 11434 \
  --host 0.0.0.0 \
  --fa
