# 05 — Naming, sizes, directories

Grammar for every asset id. The registry indexes by these.

## Pattern
`<class>-<subject>-<variant>.<ext>` — lowercase, hyphen-separated, ASCII only.
Existing files already follow it (`cg-12-dark.webp`, `npc-4-nude.webp`).
New assets extend it; no asset is renamed without a registry migration.

## Classes
`npc` character portrait, `bust` dialogue bust, `expr` expression,
`cg` story illustration, `env` environment plate, `prop` realm key prop,
`ui` interface art, `fx` effect sheet,
`player` the player's own body, one per class,
`mob` realm enemy, its own body, never shared across realms.

## Subject
Realm number zero-padded to two for `cg`, `env` and `prop`. Character number
for `npc`, `bust`, `player` and `expr`. `mob` takes realm number then a
two-digit mob index, so `mob-07-02` never reads as `cg-07`.

## Variants
`holy`, `dark`, `nude`, `expr-<name>`, `size-<width>`, `layer-<fg|mg|bg>`.
Order fixed: variant before size, size last.

## Sizes
Masters are never in the app bundle.
| class | master | delivery |
| cg | 3840 wide | 1280 1920 2560 3840 |
| npc, bust, player | 2048 | 512 1024 |
| mob | 1024 | 512 |
| expr | 1024 | 512 |
| env | 2048 | 1024 2048 |
| prop | 1024 | 512 |
| ui | 2x target | 1x 2x |

## Directories
`public/assets/cg`, `portraits`, `mobs`, `busts`, `expr`, `env`, `props`,
`ui`, `fx`.
Masters live in `rotn-assets` under the same tree, `master/` prefix.

## Formats
AVIF then WebP. PNG only for art that needs alpha under 8 colours.

## Forbidden
Spaces, capitals, dots before the extension, version suffixes like `-v2`,
`final`, `copy`, or a bare number with no class.

## Registry fields
`id`, `class`, `subject`, `variant`, `w`, `h`, `ext`, `master`, `realm`,
`character`, `locked`, `added`. One row per delivered file.
