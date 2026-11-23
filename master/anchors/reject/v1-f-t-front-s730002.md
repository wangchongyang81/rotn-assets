# v1 F-T front, seed 730002

Third attempt. s730001 fixed clothing and face but arms still dropped and
feet were cropped, so pose and framing tags were strengthened and
arms down, a-pose, cropped legs, cut off feet negated.
timing {"inferenceDuration": 2662, "inferencePreprocessingTime": 2684, "inferenceQueueTime": 2148, "total": 4850}

## Verdict

PASS pose: arms level and extended, legs together, front view, feet in frame,
bare face and body, no shadow, no watermark.
FAIL hands: both sit in front of the face and hide it, fingers fused to stubs.
FAIL face: obscured by hands, cannot judge eyes or symmetry.
FAIL backdrop: unrequested gold halo above the head.
Cause: palms forward drew the hands inward. Fix at prompt level, seed kept moving.
