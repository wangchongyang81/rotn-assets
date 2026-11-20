# Network volume

| field | value |
|---|---|
| id | 39dhm3ia6u |
| name | rotn-vol |
| size | 150 GB |
| datacenter | EU-RO-1 |
| created | 2026-11-20 |

EU-RO-1 is the only datacenter with 4090 stock, so the volume lives there.
A pod must be created in the same datacenter or the mount fails.

Holds: NoobAI checkpoint 7.1 GB, xinsir ControlNet 2.5 GB, LoRAs, outputs,
ComfyUI models tree. Never delete; recreate only from checkpoint/RECORD.md.

Mount path in pod: /workspace.
