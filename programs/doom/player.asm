# Copy loaded program from 19 -> 0 and begin execution at 0:03
#
.00 . u.01.02.0.19.00   Line 19 to Line 0 - Test not set
.01 . u.02.02.0.19.00   Line 19 to Line 0 - Test set
.02 .  .03.03.0.21.31   GOTO 0:3

.03 .  .i1.  .4.00.22   DP Copy Note load to 22:0, copy A to 22:1
.   .  .i2.  .0.00.22   SP Copy Note Copy B to 22:2
.   .  .de.  .0.00.20   Copy duration extractor to 20:1
.   .  .ne.nn.4.00.20   Copy note extractors to 20:2,3


nn:
.%3 .  .L1.  .0.22.28   Copy Note load instruction to AR
.   .  .L1.L3.0.00.29   Increment note load instruction
.   +100000             1 shifted to T position
.
.%3 .  .L1.  .0.28.22   Copy incremented load instruction back to 22:0
.   .  .L2.L2.0.31.31   NCAR
ml:
.   .  .L1.  .0.28.27   Check AR Zero
.   .  .L2.00.0.16.31     if negative HALT


.   . u.L5.  .0.28.21   4 copies of AR to 21:0-4
.   . u.L5.  .0.31.21   Extract parts of notes

                        ID:1 Delay, ID3 First note, ID2 Second note

.   .  .03.L2.0.21.25   Load 21:3 to ID TODO MAC
.
.od .  .22.  .1.26.31   Shift ID1 right 11 bits
.   .  .03.  .1.25.21   Copy ID:1 back to 21:3

.   .  .L1.L2.0.00.28 - Copy note load instr to AR
.   . u.a1.a1.0.00.00   Note Load Instruction
.   .  .03.  .0.21.29   Add 21:03 to AR TODO MAC
.   .  .L2.L2.0.31.31   NCAR
a1:                     After Note 1

.   .  .L1.L2.0.00.28   Copy note load instr to AR
.   . u.a2.a2.0.00.00   Note Load Instruction
.   .  .02.  .0.21.29   Add 21:02 to AR TODO MAC
.   .  .L2.L2.0.31.31   NCAR
a2:                     After note 2


.   .  .00.nn.0.00.00   goto nn

.88                     //Align these constants
de:
.%1 b1111110000000000000000000000
ne:
.%2 b0000000000000000111111111110
.%3 b0000011111111111000000000000
i1:
.%0 .  .00.ml.0.01.28   Music Data Load Instruction
.%1 . u.99.99.0.00.00   Note Copy Instruction A     TODO Choose N, T
i2:
.%2 . u.99.99.0.00.00   Note Copy Instruction B     TODO Choose N, T
