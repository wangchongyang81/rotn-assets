# Production queue
Order simplest first. Recipe and acceptance: SET.md. seed 7, then 8, 9 on
reject - never reuse a rejected seed.
0  anchor-t re-render realm 01   proves the recipe before skeletons
1  p1 arms relaxed at sides
2  p2 hands on hips
3  p7 hands clasped in front
4  p8 one hand on hip, one arm down
5  p4 arms crossed under chest
6  p3 one arm raised, wave
7  p5 combat guard, fists up
Renderer: tools/runpod/remote-ppose-gen.sh <pose> <seed> <out>  CN 0.9
Upload:   tools/runpod/push-ppose.sh <host> <port> <pose>...  files+prompts together
negatives carry the proven ppose6 tail (shade, body, fit, censor) on every file.
pose.neg.ppose adds anti-a-pose on ppose only - p3 keeps its raised arm.
Wiring verified 2026-11-21: push and render use the same three names in the
same dir, guard exits on any missing file. UNPROVEN: that LoadImage reads
/workspace/comfy/input - nothing has ever landed there. First pod step is one
p2 upload and a check that the file appears in the node's dropdown.
Skeletons and prompts ready. Pod down. Nothing runs until up-connect.sh maps SSH.
Stop at 0 if edge_mean < 18 or bg_clean false. Skeletons built on a soft
recipe are soft and the whole set gets thrown away.

CLOSED 2026-11-21: push reads noobai/brown-on. noobai key carries absurdres, anime
style, flat colour, flat shading, cel shading from the accepted ppose6 recipe.
