#!/usr/bin/env bash
set -euo pipefail
R=/workspace/rotn-assets; T=/workspace/models/judge; L=/workspace/serve-run.log
KEY=$HOME/.ssh/id_ed25519; ID=${1:-$(bash tools/hf/judge-id.sh)}
read -r IP SPORT <<<"$(runpodctl pod get "$ID" | python3 -c "import json,sys;s=json.load(sys.stdin)['ssh'];print(s['ip'],s['port'])")"
S="ssh -o StrictHostKeyChecking=no -o ConnectTimeout=8 -i $KEY -p $SPORT root@$IP"
echo "setup-judge $ID $IP:$SPORT"
$S 'nvidia-smi --query-gpu=name,memory.total,driver_version --format=csv,noheader'
$S 'test -s /workspace/.hf_token' || { echo no_token; exit 1; }
$S "mkdir -p $T $R/tools/hf $R/tools/judge"
set +o pipefail; tar -czf - tools | $S "tar -xzf - --no-same-owner -C $R"; set -o pipefail
$S "chmod +x $R/tools/hf/*.sh $R/tools/judge/*.sh"
$S "python3 -c 'import vllm' 2>/dev/null || python3 -m pip install -q -U --break-system-packages vllm==0.34.0"
$S 'vllm --version | tail -1'
bash tools/hf/verify-judge.sh "$ID" || { echo flag_mismatch; exit 1; }
$S "test -s $T/config.json" || $S "cd $R && bash tools/hf/pull.sh judge"
$S 'pkill -f "[v]llm serve"; for i in $(seq 20); do pgrep -f "[v]llm serve" >/dev/null || break; sleep 2; done'
$S ": > $L"
$S "cd $R && MODEL=$T setsid nohup bash tools/judge/serve-fp16.sh > $L 2>&1 < /dev/null &"
$S "sleep 6; pgrep -f '[v]llm serve' >/dev/null || { echo launch_failed; tail -15 $L; exit 1; }"
for i in $(seq 30); do
  $S "curl -s --max-time 4 http://127.0.0.1:8000/v1/models | grep -q judge" && { echo "up $i"; break; }
  sleep 15
done
$S 'curl -s --max-time 4 http://127.0.0.1:8000/v1/models | grep -q judge' || { echo not_up; $S "tail -15 $L"; exit 1; }
$S 'curl -s --max-time 60 http://127.0.0.1:8000/v1/chat/completions -H "content-type: application/json" -d "{\"model\":\"judge\",\"max_tokens\":16,\"messages\":[{\"role\":\"user\",\"content\":\"reply with the single word ok\"}]}"' | head -c 240; echo
echo "judge_ready $ID"
