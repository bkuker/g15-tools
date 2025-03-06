# Copy loaded program from 19 -> 0 and begin execution at 0:03
#
.00 . u.01.02.0.19.00   Line 19 to Line 0 - Test not set
.01 . u.02.02.0.19.00   Line 19 to Line 0 - Test set
.02 .  .03.03.0.21.31   GOTO 0:3

.03 .  .i1.  .0.00.22   Copy Note load to 22:0
.   .  .de.  .0.00.20   Copy duration extractor to 20:1
.   .  .ne.nn.4.00.20   Copy note extractors to 20:2,3

.
nn:
.07 .  .L1.  .0.22.28   Copy Note load instruction to AR
.09 .  .L1.11.0.00.29   Increment note load instruction
.10 +100000             1 shifted to T position

.11 .  .L1.  .0.28.22   Copy incremented load instruction back to 22:0
.13 .  .L2.L2.0.31.31   NCAR
ml:
.14 .  .L1.  .0.28.27   Check AR (node data) Zero
.16 .  .L2.00.0.16.31     if AR == 0 HALT


.17 . u.L5.  .0.28.21   4 copies of AR to 21:0-4
.22 . u.L5.  .0.31.21   Extract parts of notes

                        ID:1 Delay, ID:3 First note, ID:2 Second note

                        Shift first note (ID:3) bits down
.27 .  .31.  .0.21.25   Load 21:3 to ID TODO MAC

.35 .  .22.  .1.26.31   Shift ID1 right 11 bits
.58 .  .59.  .1.25.21   Copy ID:1 back to 21:3

                        Play First Note (ID:3)
.60 .  .L1.L2.0.00.28 - Copy note load instr to AR
.61 . u.a1.a1.0.00.00   Note Load Instruction
.62 .  .63.  .0.21.29   Add 21:03 to AR TODO MAC
.64 .  .L2.L2.0.31.31   NCAR
a1:                     After Note 1

                        Play Second Note (ID:2)
.65 .  .L1.L2.0.00.28   Copy note load instr to AR
.66 . u.a2.a2.0.00.00   Note Load Instruction
.67 .  .70.  .0.21.29   Add 21:02 to AR TODO MAC
.71 .  .L2.L2.0.31.31   NCAR

a2:                     Process Delay
.72 .  .73.  .0.21.28   Copy delay from ID:1 to AR
dy:
.74 .  .L1.  .0.28.27   Check AR Zero
.76 .  .00.nn.0.00.00       if AR == 0 goto nn
.   .  .L1.dy.3.00.29   Decrement delay, goto dy
.   +00200000           1 shifted to Delay position


.88                     //Align these constants
de:
.%1 b11111100000000000000000000000
ne:
.%2 b00000000000000000111111111110
.%3 b00000011111111111000000000000
i1:
.%0 .  .00.ml.0.01.28   Music Data Load Instruction
