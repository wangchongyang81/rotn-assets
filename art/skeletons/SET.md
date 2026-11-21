# Skeleton set
Controlnet openpose sources. Shared across every realm and variant. Skeletons
carry no ethnicity, no costume, no lighting.

## Poses
skel-tpose.png      lock pose, arms horizontal, straight elbows
skel-ppose-p1.png   arms relaxed at sides
skel-ppose-p2.png   hands on hips
skel-ppose-p3.png   one arm raised, wave
skel-ppose-p4.png   arms crossed under chest
skel-ppose-p5.png   combat guard, fists up
skel-apose-wide.png  wide stance, left arm horizontal, right arm 45 deg down
skel-ppose-p7.png   hands clasped in front
skel-ppose-p8.png   one hand on hip, one arm down

## Recipe - fixes the r1t34 defects
cfg 5.5 (4.0 was soft), euler_ancestral, normal, 36 steps, 832x1216, seed 7
P add: sharp focus, crisp lineart, clean silhouette, (solid white background:1.6)
P change: dim lighting 1.8 -> 1.2, keep even flat light
N add: machinery, mecha, robot, industrial, scenery, props, background clutter,
blurry, soft focus, depth of field, bokeh, gradient background, no humans

## Notes
apose-wide is asymmetric on purpose - brace/landing base, not a T.

## Acceptance
edge_mean >= 18, bg_frac >= 0.55, bg_clean true, all joints in frame, no
cropping at wrists or ankles. Reject and re-seed otherwise.
