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
