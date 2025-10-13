#include "../lib/bbl.asm"
ct:                     Count
.   d6                  Load 6


<BLOCK>                 5
#include "B2_B3.asm"

<BLOCK>                 4
#include "F3_F4.asm"

<BLOCK>                 Line 3 Empty (Playback)

<BLOCK>                 Line 2 Empty (Playback)

<BLOCK>                 Line 1 Empty (Unused)

<BLOCK>                 Line 0, startup

                        Zero out first word of line 19
.00 .  .L1.L2.3.19.28   0 -> AR
.   .  .00.  .0.28.19   AR->19:0
.   .  .L2.  .0.15.31   Begin to read next tape block
.   .  .00.00.6.21.31   Execute from 19:0

<BLOCK>                 Fun song data
.00 . u.01.00.0.01.03
.   0
.   0
.   0

.   . u.01.00.0.05.03
.   0
.   0
.   0

.   . u.01.00.0.04.03
.   0
.   0
.   0

.   . u.01.00.0.05.03
.   0
.   0
.   0


.   . u.01.00.0.04.03
.   0
.   0
.   0

.   . u.01.00.0.05.03
.   0
.   0
.   0


.   . u.01.00.0.04.03
.   0
.   0
.   0

.   . u.01.00.0.05.03
.   0
.   0
.   0


.   . u.01.00.0.04.03
.   0
.   0
.   0

.   . u.01.00.0.05.03
.   0
.   0
.   0


.   . u.01.00.0.04.03
.   0
.   0
.   0

.   . u.01.00.0.05.03
.   0
.   0
.   0