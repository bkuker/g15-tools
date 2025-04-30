<INCLUDE src="../lib/bbl.asm">
ct:                     Count
.     +4                Load 4 tape blocks into 3,2,1,0

<BLOCK>                 Line 3 AR Format
.02 b0 001 000 000 000 000 000 000 000 000 0
.03 b100 011 000 000 000 000 000 000 000 01

<BLOCK>                 Line 2 Line 19 Format
.02 b0 001 000 000 000 000 000 000 000 000 0
.03 b100 011 000 000 000 000 000 000 000 01

<BLOCK>                 Line 1, Unused

<BLOCK>                 Line 0 - Program

                        Clear Line 19
.00 .  .01.02.0.00.28 - 0 -> AR
.01 0
.02 . u.03.04.0.28.19   AR -> Line 19

                        Copy a value to 19.u7
.04 .  .05.06.0.00.28   Copy next value to AR
.05 +1234567
.06 .  .u7.07.0.28.19   Copy AR to 19.u7

.07 .  .09.10.0.09.31   Type Line 19

.10 .  .12.10.0.16.31   HALT