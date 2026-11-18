# Host comparison

Hard filter. A host passes only on all five; fail one and it is out.
1. Checkpoint pulled by HF repo id, or exact model id published.
2. Seed accepted as a parameter.
3. Negative prompt accepted as a parameter.
4. ControlNet openpose accepted.
5. Safety checker switchable off.

## Candidates
| host | hf id | seed | neg | cn | safety off | cost/img | verdict |
|---|---|---|---|---|---|---|---|
| fal | | ? | ? | ? | ? | ~0.005 | FAIL model apis: hosted IDs only, no noobai. Serverless needs access approval, cold start pulls 6.6GiB |
| venice | wai-Illustrious | PASS | PASS | FAIL | PASS | ~0.01 | best substitution: Illustrious is NoobAI's parent family, uncensored switch, no signup. 1 anime of 51 |
| novita | | ? | ? | ? | ? | ~0.002 | |
| wavespeed | | ? | ? | ? | ? | ~0.005 | upload path fails: 200 MB cap, 34 shards, no temp disk. Hosted endpoints unaffected |
| replicate | | | | | | ~0.01 | version pin, cold start |
| runpod template | | | | | | per minute | pod to manage |
| modal | | | | | | per second | most setup |

## Rule
Unknown is a fail. Record the exact endpoint slug and model id, not the
marketing name. Never trust a claim that is not in the endpoint schema.
