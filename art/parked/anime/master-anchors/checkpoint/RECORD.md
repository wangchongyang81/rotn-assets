# Checkpoint record

File: ~/ComfyUI/models/checkpoints/NoobAI-XL-v1.1.safetensors
Source: huggingface.co/Laxhar/noobai-XL-1.1
  NoobAI-XL-v1.1.safetensors
Size: 7105349958
sha256: 6681e8e4b134c81f16533acedb0d406d7e5e366e1624b4105178c64d00b05d51
Licence: fair-ai-public-license-1.0-sd plus model terms
  See licence/RECORD.md for the read and the obligations.

## Settings
euler_a, karras, 24 steps, cfg 6, from the card's own range.

## Host
Codespace, 2 cores, no GPU, ~5 GB RAM, 709 MB free after download.
CPU only. Slow. The smoke test proves prompts and skeleton, not throughput.

## Civitai copy, same file
model 833294, version 1116447, air urn:air:sdxl:checkpoint:civitai:833294@1116447
size 6938818.318359375 KB = 7105349958 bytes, matches the HF file exactly
fp bf16, format SafeTensor, status Published, nsfwLevel 15 (PG..X)
paidAccess null, licensingFee null, uploadType Created

OBLIGATION, differs from HF: allowNoCredit false. Credit required for 833294.

## Unproven
Can the on-site generator run it? usageControl is Download but the field is
None on models known to generate, so it proves nothing. gen endpoint 404.
Settle in a browser: generator, model selector, search NoobAI-XL, look for 833294.
