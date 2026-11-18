# Why the t-pose will not hold

9 seeds. Horizontal once, at 006. Prompt saturated, synonyms and weights exhausted.

Cause: 832 px width. A full body with arms at shoulder height needs ~1000 px of
span, so the model angles the arms down to fit the frame. Tag strength cannot
beat the frame edge.

Levers left in Venice, in order:
1 wider canvas for the pose anchor, 1024 square, arms fit
2 cfg 7, stronger adherence, supports 1
3 accept a drooping a-pose and record it as the anchor compromise
4 Civitai, where a ControlNet skeleton sets the pose outright

Venice has no ControlNet, so if 1 and 2 fail the answer is 3 or 4.
