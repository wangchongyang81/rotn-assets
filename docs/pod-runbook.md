# Pod runbook - mandatory
1. On EVERY new pod, restore the last successful clone before anything else:
   ls /workspace/images/ ; tar xzf /workspace/images/comfy-app-LATEST.tar.gz -C /workspace
   Only clone from git if no image exists.
2. Before closing ANY run: tar the working app dir to the volume.
   tar czf /workspace/images/comfy-app-$(date +%F-%H%M).tar.gz -C /workspace comfy-app
   Then ln -sf the newest to comfy-app-LATEST.tar.gz. Never close without it.
3. Never pkill -f with a pattern that appears in the pkill command line. Use [b]rackets.

## Pod kc45pk4bayvjfh 2026-11-21
host 213.173.102.196 port 33616. /opt/ComfyUI, torch 2.11.0+cu128, http 200.
extra_model_paths.yaml -> /workspace/comfy. Snapshot comfy-app-2026-11-21-0209.tar.gz.
Restore: tar xzf /workspace/images/comfy-app-LATEST.tar.gz -C /opt

## HF mirror
Text: tools/mirror_hf.sh text -> wangchongyang81/rotn-pilot (private, manifests/ and docs/)
Binaries: tools/mirror_hf.sh models|snapshots -> hf://buckets/wangchongyang81/rotn-bin
Bucket address form is the full hf://buckets/ URI. -R lists recursively.
CI: .github/workflows/mirror-hf.yml runs text mode on manifest/doc push, secret HF_TOKEN.
HF_TOKEN is an OAuth token, expires 2026-12-19. Re-set from `hf auth token` before then.

## CI mirror PROVEN 2026-11-21
Workflow mirror-hf run 44901526888 completed success in 16s on push.
Secret HF_TOKEN set, trigger on art/manifests/** and docs/** paths.
Text mode is automatic and verified.

## OPEN: binaries never mirrored
models (9.0G) and snapshots have no bucket copy yet. Needs a pod with
volume 39dhm3ia6u mounted, then:
  bash tools/mirror_hf.sh models
  bash tools/mirror_hf.sh snapshots
Verify with: hf buckets ls -R hf://buckets/wangchongyang81/rotn-bin

## Binaries MIRRORED 2026-11-21
models 9607489074 B and 3 snapshots verified in hf://buckets/wangchongyang81/rotn-bin
via buckets sync --plan then --apply. cp takes no --recursive; sync is the verb.
Caveat: LATEST.tar.gz is a symlink and syncs as a full copy, so it goes stale.
Restore ignores it - always pick the newest dated tar.

## Restore from bucket (READ PATH PROVEN 2026-11-21)
Fresh pod with volume mounted:
  hf auth login --token "$(cat /root/.hf_tok)"
  hf buckets sync hf://buckets/wangchongyang81/rotn-bin/models /workspace/comfy/models --include '*.safetensors'
  hf buckets sync hf://buckets/wangchongyang81/rotn-bin/snapshots /workspace/images --include '*.tar.gz'
  tar xzf /workspace/images/<newest dated tar> -C /opt
Checksum round-trip verified on 0213 against the bucket copy.

## Models read path PROVEN 2026-11-21
Dry-run of the models restore planned 2 downloads at 7105349958 and 2502139104.
Snapshot read path proven by sha256 round-trip on 0213 (ca4d1ae4...215cb6 both sides).
Region: non-Team is always US. Local->bucket and bucket->local are fine from any
region pod; bucket->bucket copies only within a region.
Mirror pod ee7jaehd9b38to deleted. Volume 39dhm3ia6u persists.

## close_session.sh
Usage: ./tools/close_session.sh <pod-id>
Gates: validate_manifests, parity, text mirror, then pod lookup. Text mirrors
before the lookup, so a bad ID still pushes text and then exits 1 without CLOSED.
NEVER deletes the pod. UNTESTED end to end against a live pod as of 2026-11-21.
First run next session is the test.

## HF_TOKEN is now a CLASSIC write token 2026-11-21
Replaces the OAuth token that expired 2026-12-19. Classic write tokens do not
expire. Created as rotn-ci on https://huggingface.co/settings/tokens.
OAuth value parked as HF_TOKEN_OAUTH for rollback.
Proof: workflow run 44904034246 success immediately after the swap.
Token creation is web-only - /api/tokens is dead for OAuth, HfApi has no method.
tools/set_hf_token.sh sets, tests and auto-rolls-back.
The token appeared in a chat log; revoke on the settings page if that matters.
