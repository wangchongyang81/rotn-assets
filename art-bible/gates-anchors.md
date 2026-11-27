# Anchor gates — realm-backed sheet (2026-11-27)

Retired: frame mean, dark%, bbox fill. All three measured the white studio
backdrop on the old locks and collapse on realm ground (frame mean 8.3-73.6,
dark% 71-98, fill 99.7-99.8 flat).

Fields, interior of the stick bbox, no corridor:
- p90 luminance  floor 135   (locks 164-199, realms 139-240)
- bright% >120   floor 11.0  (locks 25.2-69.2, realms 11.3-33.4)
- interior edge  floor 3.5   (locks 5.0-9.6, realms 3.7-7.6)
- interior sd    floor 45    (locks 43.7-59.7, realms 52.3-79.0)

sd is a pass check, not a target: separation, not exposure. p90 and bright% are
exposure. Edge is line quality.

Gauri cleared after the pose rebuild: p90 210, bright 18.3, edge 5.7. v8 night
is the canary, not an exception. jvala and kalyani edge 3.7 sit on the floor.

v8 carries a trailing [env.v8.key] appended after env so it lands last. Inert on
frame mean (33.1 -> 32.6), holds p90 139 and bright 11.3 above floor. CFG 5.5
buys +2.4 mean, not worth a sheet split.
