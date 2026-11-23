# v1 F-T front, seed ???, first Civitai accept

PASS pose. Arms dead horizontal, first fully level render in 11 attempts.
PASS style. Anime with linework, cel shading, no 3D mannequin.
PASS face. Eyes, nose, mouth visible, not faceless.
PASS hair. Short black hair, not bald.
PASS hands. Five fingers visible, not blobs.
FAIL background. Pure white, not dark grey.

Cause: model field was correct (NoobAI), prompt had style anchors.
Background is a generator setting, prompt cannot override it.

Verdict: ACCEPT with note on background.
