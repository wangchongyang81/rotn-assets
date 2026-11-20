# rotn-pilot layout

Private. Holds trained LoRAs and recovery config only. Never the checkpoint,
never a secret.

| path | holds |
|---|---|
| lora/<name>/ | .safetensors plus its training config |
| logs/<name>/ | sample grids, loss notes |
| env/ | python freeze, image pin, pod recipe |
| recovery/ | restore notes for a dead volume |

Every LoRA folder carries the anchor sheet commit it trained against.
