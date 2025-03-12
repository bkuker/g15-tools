.00 . u.L5.85.0.00.20 - Copy next 3 values to 20:1,2,3,0
# Delay Extractor
.01 b11111100000000000000000000000
# Note Extractor
.02 b00000000000000000111111111110
.03 b00000011111111111000000000000
#Next Note Instruction
.04 .  .00.ml.0.01.28   Music Data Load Instruction

#Test Conductor Code
.85 .  .L1.L2.0.00.28   1A
.   .  .05.ml.0.01.28   
.   . w.  .09.0.21.31   

.   .  .L1.L2.0.00.28   1B 1A
.   .  .00.ml.0.01.28   
.   . w.  .09.0.21.31   

.   .  .L1.L2.0.00.28   1B 1A
.   .  .00.ml.0.01.28   
.   . w.  .09.0.21.31   

.   .  .L1.L2.0.00.28   ARP 1
.   .  .30.ml.0.01.28   
.   . w.  .09.0.21.31   

.   .  .L1.L2.0.00.28   2A
.   .  .44.ml.0.01.28   
.   . w.  .09.0.21.31   

.   .  .L1.L2.0.00.28   2B 2A
.   .  .39.ml.0.01.28   
.   . w.  .09.0.21.31   

.   .  .L1.L2.0.00.28   ARP 1 (replace with Arp2)
.   .  .30.ml.0.01.28   
.   . w.  .09.0.21.31   

.28 .  .L1.L2.0.00.28   3AB
.   .  .68.ml.0.01.28   
.   . w.  .09.0.21.31   

.   .  .  .L2.0.00.28   3AB
.   .  .68.ml.0.01.28   
.   . w.  .09.0.21.31   

.   .  .L2.00.0.16.31   HALT

# Arrive at 07 with the NN instruction in 20:0
# OR
# Arrive at 09 with the NN instruction in AR.

nn:
.07 .  .L1.  .0.20.28   Copy Note load instruction to AR
.09 .  .L1.11.0.00.29   Increment note load instruction
.10 +100000             1 shifted to T position

.11 .  .L1.  .0.28.20   Copy incremented load instruction back to 22:0
.13 .  .L2.L2.0.31.31   NCAR
ml:
.14 .  .L1.  .0.28.27   Check AR (node data) Zero
.16 .  .L2.L1.0.20.31      if AR == 0 RETURN
#.16 .  .L2.00.0.16.31     if AR == 0 HALT


.17 . u.L5.  .0.28.21   4 copies of AR to 21:0-4
.22 . u.L5.  .0.31.21   Extract parts of notes Line 21 = Line 21 & Line 20

                        21:1 Delay, 21:3 First note, 21:2 Second note
                        Each note is the C, Src and Dst to add to the
                        note load instruction.

                        Shift first note (ID:3) bits down
.27 .  .31.  .0.21.25   Load 21:3 to ID TODO MAC

.35 .  .22.  .1.26.31   Shift ID1 right 11 bits
.58 .  .59.  .1.25.21   Copy ID:1 back to 21:3

                        Play First Note (21:3)
.60 .  .L1.L2.0.00.28 - Copy note load instr to AR
.61 . u.a1.a1.0.00.00   Note Load Instruction
.62 .  .63.  .0.21.29   Add 21:03 to AR
.64 .  .L2.L2.0.31.31   NCAR
a1:                     After Note 1

                        Play Second Note (21:2)
.67 .  .L1.L2.0.00.28   Copy note load instr to AR
.68 . u.a2.a2.0.00.00   Note Load Instruction
.69 .  .70.  .0.21.29   Add 21:02 to AR
.71 .  .L2.L2.0.31.31   NCAR
a2:                     After Note 2

                        Process Delay
.74 .  .77.  .0.21.28   Copy delay from ID:1 to AR
dy:
.78 .  .L1.  .0.28.27   Check AR Zero
.80 .  .00.nn.0.00.00       if AR == 0 goto nn
.   .  .L1.dy.3.00.29   Decrement delay, goto dy
.   +00200000           1 shifted to Delay position