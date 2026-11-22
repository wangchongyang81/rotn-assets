# Wildcard taxonomy
Basis: Illustrious-xl model card, read 2026-11-21. NoobAI differs only where marked.
Sections are machine-concatenated later. Not prose.

## LAW 0 - the skeleton owns the pose
Openpose already draws every joint. Pose tags name the pose and stop. The card warns
that critical composition tags conflict and confuse the model. r1t34 spent nine tags
re-describing the skeleton and edge collapsed to 11.6.
Hard cap four pose tags. Never write five fingers, straight elbows, hands open.

## quality.pos
illus: masterpiece (quality), best quality, very aesthetic, absurdres
noobai: masterpiece, best quality, newest, absurdres
Two quality words maximum. Four stack into mush.

## pose.carrier - exactly one per render, nothing else
tpose      t-pose, arms out, standing, front view
ppose      standing, arms at sides, front view
apose-wide standing, arms out, wide stance, front view
p1         standing, arms at sides, front view
p2         standing, hands on hips, front view
p3         standing, one arm up, front view
p4         standing, arms crossed, front view
p5         standing, fists up, front view
p7         standing, hands clasped, front view
p8         standing, hand on hip, front view

## frame.pos - one only
full body / cowboy shot / upper body / portrait
close-up pairs with portrait and never with full body.

## body.pos - ladder, stop at the rung reached
0 clothed 1 topless 2 nude 3 completely nude 4 spread legs 5 act
4 and 5 require rung 3 present. Never 2 and 3 together.

## censor.neg - suppression is negative, never positive
bar censor, mosaic censoring, pixelated, censored, light censor
uncensored as a positive is weak. The negatives do the work.

## artifact.neg - lifted verbatim from the card
worst quality, bad quality, low quality, lowres, displeasing, very displeasing,
bad anatomy, bad hands, extra digits, fewer digits, scan artifacts, jpeg artifacts,
signature, twitter username, guro

## layout.neg - vital for a single-figure anchor
comic, multiple views, 2koma, 4koma, split screen, reference sheet, character sheet

## lighting.pos
(dim lighting:1.2) not 1.8. 1.8 flattens contrast and kills edges.
sharp focus, crisp lineart, clean silhouette
Never pair dim lighting with even flat light AND rim lighting.

## background.pos
(solid white background:1.6)
simple background licenses scenery and is why machinery appeared. Use it only
when the realm demands scenery. white background alone for anchors.

## background.neg
machinery, mecha, robot, industrial, scenery, props, background clutter,
gradient background, bokeh, depth of field, blurry, soft focus

## skin.pos - realm axis, one ladder only
brown skin 1.3 / dark skin 1.4 are the same axis. Pick one, never both.
tan skin 1.3 is the neighbouring rung and goes in the negative if not wanted.
orange skin is a hue error, always negative at 1.5.

## hair.pos - keep to two
long black hair
One length, one colour, one optional detail. Three hair tags smear the head.

## anatomy.pos - fixed, never varies by pose
1girl, solo, female adult mid-twenties, medium build, head to body ratio 1 to 7
solo is mandatory. No pair tags on a single-figure anchor.

## CONTRADICTIONS - never in the same string
full body + close-up
simple background + white background
brown skin + dark skin
topless + completely nude
dim lighting + rim lighting
standing + sitting
3 quality words
more than 4 pose tags
cowboy shot + full body
