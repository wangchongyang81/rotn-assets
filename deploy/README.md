# rotn judge env

Proven judge config, frozen 2026-11-24. A fresh pod clones this folder and
runs: bash deploy/setup-judge.sh <pod-id>

- GPU A100-SXM4-80GB (81920 MiB), driver >= 580
- image runpod/pytorch:1.0.3-cu1281-torch291-ubuntu2404
- vllm 0.34.0 via --break-system-packages; pulls torch 2.14.0+cu130
- bind 8000, nginx public 8001, no --guided-decoding-backend
- weights live in this repo root; tools/hf/pull.sh judge fetches them
