# Resume — P closed 2026-11-20

Pod ckhmhcihw8q83v, 213.173.107.89:18747, volume 39dhm3ia6u.
Aux pinned to c2655d2.

T anchor-tv2 accepted: f0.18 810, corners 255.
P anchor-pv2 accepted: f0.18 (20,536) horizontal arm, corners 255,
right max pulled to 536 not 824. Known fault: hand hovers, forearm
separates from body at 50-58% (2 runs). Accepted, not chased.

Six P attempts after pv2 all lost the arm or the hip: qa (arm absent),
qb (no render), pz, qa3 (arm gone, 3 runs), qa4 (arm diagonal, 214/188).
Root cause of the arm failures: any change to the left arm coords or the
seed breaks the horizontal. pv2 is the only skeleton that holds both
the T's own left reach (41) and the hip bend in one image.

Sheet rebuild is next from tv2 and pv2.
