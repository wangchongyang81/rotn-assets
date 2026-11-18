# rotn-assets

Art repo for rotn. Public, clones anonymously, venice lane owns it entirely.

## Contents
- `art-bible/` — binding art direction. Read `art-bible/README.md` first.
  Nine files, 00 through 08, each governs the one before it less than 00 does.
- `archive/` — retired art, dated. Never deleted, never edited.
  `archive/2026-11-18/` is the pre-rebuild set: 66 CGs at 3:2 and 136 files,
  all delivery-size, no masters.
- `deploy/` — one-off payloads, not build input.

## Masters
Masters live under `master/` when they exist. None do yet. Every archived file
is delivery-size, so nothing can be re-derived — replacement is regeneration
against the bible, not a resize.

## This repo is not the live art
The game serves `public/assets` in `rotn-src`. Files here reach it by
`scripts/install-cg.sh <source> <target-name>` or a lane-owned copy, never by
the build.

## Rules
- Name to `art-bible/05-naming.md` or it does not land.
- Pass `art-bible/06-qc.md` before a file is offered to `rotn-src`.
- Replacements archive the old file in the same commit.
- No spaces, no capitals, no `-final`.
