#LL S P.TT.NN.C.SS.DD B Comment

# Copy loaded program from 19 -> 0 and begin execution at 0:04
.00 . u.01.01.0.19.00   Copy Line 19 to Line 0
.01 .  .02.02.0.21.31   Transfer control to 0:02
.02 .  .03.04.0.00.03   0:3 -> 3:3 Copy format code to line 3, goto 4
                        Format Code: D D CR END
.03 b 000 000 000 000 000 000 000 010 001 00

# This clears line 23, and then adds a special bit in the last word.
# That bit will be shifted away after 9 bits of input. That is two
# Characters and CR shifts in a 0 sign. This allows the code to Loop
# until the user presses DDCr, no need for s.

                        Clear 23:0 for type-in
.04 .  .  .  .0.29.28   0 -> AR
.   . u.L5.  .0.28.23   0 -> 23:0,1,2,3

                        Place bit in 23:3
.   .  .  .L2.0.00.29   Load to AR
.   b0000000100000000000000000000
.   .  .03.  .0.28.23   AR -> 23:3

.   .  .L2.  .0.12.31   Enable Type In

wt:                     Wait for 23:0 to equal zero
.   .  .03.  .0.23.27   Is 23:3 == 0?
.   .  .  .in.0.00.00       = 0, GOTO in 
.   .  .  .wt.0.00.00       != 0 GOTO wt


in:
.   .  .L2.  .0.00.31   SET IOReady
                        Load input into AR
.   .  .00.  .0.23.28   23:0 -> AR

.   .  .00.  .0.00.00   NOOP WAIT
.   .  .00.  .0.00.00   NOOP WAIT
.   .  .00.  .0.00.00   NOOP WAIT
.   .  .00.  .0.00.00   NOOP WAIT

.   .  .L2.  .0.08.31   Output AR to typewriter
.   .  .L0.L0.0.28.31   Wait for IOReady
.   .  .00.04.0.00.00   GOTO 04