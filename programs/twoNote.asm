#include "lib/bbl.asm"
ct:                     Count
.     +4                Load 4 tape blocks into 3,2,1,0

<BLOCK>                 Line 3

<BLOCK>                 Line 2

<BLOCK>                 Line 1
.00 +002861f
.01 +fffffff
.02 -fffffff
.03 -fffffff
.04 +fffffff
.05 +fffffff
.06 -fffffff
.07 +fff0000
.08 -0000001
.09 -0000001
.10 +0000000
.11 +0000000
.12 -0000001
.13 -0000001
.14 +0000000
.15 +0003eff
.16 +fffffff
.17 +fffffff
.18 -fffffff
.19 -fffffff
.20 +fffffff
.21 +fffffff
.22 +fc00000
.23 +0000000
.24 -0000001
.25 -0000001
.26 +0000000
.27 +0000000
.28 -0000001
.29 -0000001
.30 -261ffff
.31 -fffffff
.32 +fffffff
.33 -fffffff
.34 -fffffff
.35 -fffffff
.36 +fffffff
.37 +0000000
.38 +0000000
.39 +0000000
.40 -0000001
.41 +0000000
.42 +0000000
.43 +0000000
.44 -0000105
.45 -cf7ffff
.46 -fffffff
.47 +fffffff
.48 +fffffff
.49 -fffffff
.50 -fffffff
.51 +fffffe0
.52 -0000001
.53 +0000000
.54 +0000000
.55 -0000001
.56 -0000001
.57 +0000000
.58 +0000000
.59 -000407d
.60 +fffffff
.61 -fffffff
.62 -fffffff
.63 +fffffff
.64 +fffffff
.65 -fffffff
.66 -ffff800
.67 -0000001
.68 -0000001
.69 +0000000
.70 +0000000
.71 -0000001
.72 -0000001
.73 +0000000
.74 +000aff7
.75 +fffffff
.76 +fffffff
.77 -fffffff
.78 -fffffff
.79 +fffffff
.80 +fffffff
.81 +ffe0000
.82 +0000000
.83 -0000001
.84 -0000001
.85 +0000000
.86 +0000000
.87 -0000001
.88 +0000000
.89 -47647ff
.90 -fffffff
.91 +fffffff
.92 -fffffff
.93 -fffffff
.94 -fffffff
.95 +fffffff
.96 +f800000
.97 +0000000
.98 +0000000
.99 -0000001
.u0 +0000000
.u1 +0000000
.u2 -0000001
.u3 -000000a
.u4 -0997fff
.u5 -fffffff
.u6 +fffffff
.u7 +fffffff



<BLOCK>                 Line 0

.00 . u.  .  .0.01.02   Copy line 1 -> 2
.   . u.  .  .1.01.03   Copy line 1 -> 3 ABS
.   .  .L2.L0.0.16.31   HALT
