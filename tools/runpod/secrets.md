# Secrets

| secret | lives | never |
|---|---|---|
| runpod key | ~/.runpod/config.toml 600 | repo, image, prompt |
| HF token | hf auth (oauth, expires 2026-12-19) | repo |
| HF repo | private, `rotn-pilot` | public |

Pod env carries `HF_TOKEN` at create time only. Image bakes no secret.
Reissue runpod key if config is ever committed by accident.
Civitai token lives at /workspace/.civitai, mode 600, on the volume.
Never in git, never inline. dl.sh reads it.
Set it once per volume; it survives restarts.
