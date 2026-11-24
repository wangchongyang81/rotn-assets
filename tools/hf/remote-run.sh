#!/usr/bin/env bash
set -euo pipefail
R=/workspace/rotn-assets; T=/workspace/models/judge; L=/workspace/serve-run.log
V=$R/tools/judge/serve-fp16.sh
nvidia-smi --query-gpu=name,memory.total,driver_version --format=csv,noheader
test -s /workspace/.hf_token || { echo no_token; exit 1; }; test -s "$V" || { echo no_serve_file; exit 1; }
for f in served-model-name dtype max-model-len gpu-memory-utilization host port structured-outputs-config; do
  grep -q -- "--$f" "$V" || { echo "MISSING $f"; exit 1; }
done
python3 -c 'import vllm' 2>/dev/null || python3 -m pip install -q -U --break-system-packages vllm==0.34.0
test -s $T/config.json || bash $R/tools/hf/pull.sh judge
: > $L; pkill -f '[v]llm serve' || true
for i in $(seq 20); do pgrep -f '[v]llm serve' >/dev/null || break; sleep 2; done
cd $R; MODEL=$T setsid nohup bash $V > $L 2>&1 < /dev/null &
sleep 6
pgrep -f '[v]llm serve' >/dev/null || { echo launch_failed; tail -15 $L; exit 1; }
for i in $(seq 30); do
  curl -s --max-time 4 http://127.0.0.1:8000/v1/models | grep -q judge && { echo "up $i"; break; }
  echo "tick $i"; sleep 15
done
curl -s --max-time 4 http://127.0.0.1:8000/v1/models | grep -q judge || { echo not_up; tail -15 $L; exit 1; }
curl -s --max-time 4 http://127.0.0.1:8001/v1/models | grep -q judge && echo proxy_ok || echo proxy_bad
echo judge_ready
