<INCLUDE src="lib/bbl.asm">
ct:                      Count
.     +3                 Number of tracks to load


<BLOCK>                  Line 3 format
#.03   0000220            Format code: 6 digits, LF, END.
#.03   0000044            Format code: 7 digits, LF, END.
#.03   0001100            Format code: 5 digits, LF, END.
.03   0008800            Format code: 4 digits, LF, END.


<BLOCK>                  Line 2, BCD Routine
<INCLUDE src="lib/bcd.fraction.asm">

<BLOCK>                  Line 1, Unused

<BLOCK>                  Line 0

#Print the Fibonacci numbers
# Prepared by: Bill Kuker
# Date: 2-24-2025
#

lp:                      
                         Swap A <- B <- C
.00 .  .vB.  .1.00.28 -  AR = B
.   .  .vA.  .1.28.00    A = AR
.   .  .vC.  .1.00.28    AR = C
.   .  .vB.  .1.28.00    B = AR

.   .  .00.  .0.00.00    NOP to align next instruction

                         Convert vA to decimal
.   .  .vA.  .0.00.25    vA -> ID.1 (BCD Routine parameter)
.   .  .L1.L2.1.00.28    Load next instruction to AR, skip it
.   .  .ac.ac.0.20.31    GOTO 0:ac (return instruction)
.   .  .61.61.2.20.31    GOTO 2:61

ac:                      After Conversion
.   .  .L2.  .0.08.31    Output AR to typewriter
.   .  .L0.L0.0.28.31    Wait here for IOReady

                         C = A + B...
.   .  .vA.  .1.00.28    vA -> ARc   AR = A
.   .  .vB.  .2.00.29    vB -> AR+   AR += B
.   .  .vC.  .1.28.00    AR -> vC    C = A + B

.   .  .L2.  .0.22.31    Check AR sign..
.   .  .lp.lp.0.20.31      if positive GOTO lp
.   .  .L2.L0.0.16.31      if negative HALT

#Variables
vA:
.   0
vB:
.   +00068DB
vC:
.   +00068DC


