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
