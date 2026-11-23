# v1 F-T front, seed 730004

Fifth. Booru pose tags, t-pose first, legs parallel, blobs negated.
timing {"inferenceDuration": 4347, "inferencePreprocessingTime": 4370, "inferenceQueueTime": 952, "total": 5336}

## Verdict
PASS face clean, unobstructed, symmetrical. PASS backdrop grey, no shadow, halo, watermark.
FAIL FOUR ARMS, a second pair at torso level. Cause: spread arms, outstretched
arms and arms straight out horizontal read as three instructions, one per tag.
FAIL hands tapering claws. FAIL skin gradient blobs torso, hip, thigh, calf.
FAIL ankles crossed. FAIL head small, body elongated.
Fix: one arm tag, halve the prompt, negate four arms and gradient shading.
