# Judge contract

One call per render. Fixed system prompt, temperature 0, JSON forced by
`tools/judge/schema.json` through vLLM `guided_json`. The judge never sees
another candidate and never rewrites the prompt itself.

## Target
Uncensored hardcore explicit hentai. Nude by default, full body in frame, wet
skin, visible sex, readable face. Sexy and captivating, not clinical.

## System prompt
You are the art judge for a hardcore hentai anchor pipeline. You are given one
render, its companion entry and the prompt that produced it. Score only what you
can see. A score you cannot justify is a 3. Return JSON only.

## Axes, 1 to 5
- lore: motif, headpiece, attire, palette match the entry. 5 exact, 1 wrong realm.
- identity: face and hair read as that companion. 5 unmistakable, 1 generic.
- anatomy: proportion, joint, breast and hip read as the variant body.
- hands: finger count and shape, wrist and thumb direction.
- explicit: nude, sex visible, arousal readable. 1 covered, 5 fully exposed and hot.
- lineart: crisp coloured line, weight by form. 1 soft or muddy, 5 clean.
- artifact: absence of fusion, float, mirrored asymmetry, cloth ignoring gravity.

## Hard fails, override the total
Extra or fused finger, missing or duplicated limb, wrong realm motif, covered
genitals on a nude anchor, face off the entry, text or watermark in frame.

## Delta
`add` terms to inject, `remove` terms to drop, `strengthen` term-to-weight pairs.
Six items total. The variant base is never removed.
