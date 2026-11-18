# Decision: prompt-in endpoint, no deployment

Abandoned: local ComfyUI (OOM), fal Model APIs (hosted IDs only), CLI deploys,
weight uploads (200 MB cap, checkpoint 34 shards, 690 MB disk).

Chosen shape: paste our prompts into a host endpoint, take the image back.

## Costs, accepted
1. Checkpoint identity is the host's. Locks gain host_model naming the exact
   endpoint. A host that hides its model fails the lock.
2. No ControlNet. T and P become text poses. Skeleton files stay for later.
3. Seed only where the host honours it.

## Still binding
Art bible style, six QC criteria, 832x1216 no stretch, licence record.

## Filter, all required
Explicit anime, safety off, exact model named, seed accepted, 832x1216 accepted.

## Ranking
1 civitai generator: native noobai/illustrious/pony, unhedged explicit, api
2 novita: fast cheap, hidden lora stack
3 fal hosted anime: verify checker off per endpoint
4 replicate: version pin, cold start
