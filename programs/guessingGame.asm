# Copy loaded program from 19 -> 0 and begin execution at 0:03
.00 . u.01.02.0.19.00   Line 19 to Line 0 - Test not set
.01 . u.02.02.0.19.00   Line 19 to Line 0 - Test set
.02 .  .04.04.0.21.31   Transfer control to 0:rn

.04 . u.L5.rn.0.00.20 - Copy next 4 values to 20:1,2,3,0
.   b00000000000000000000000011110
.   b00000000000000000000111100000
.   0
.   b00000000000000000000111111110

rn:
.   .  .L2.rl.0.12.31   Enable Type In

rf:                     "Random Fix"
                        Reload AR from 22:00 and keep going
.   .  .00.  .0.22.28   22:0 -> AR

rl:                     "Random Loop"
                        Continuously add a value that is co-prime
                        with 256 until user presses S
.   .  .  .L2.0.00.29   Add to AR
.   +85
.   .  .L0.L1.0.28.31   Test IOReady
.   .  .  .rl.0.00.00       Not ready? goto rl
                            Ready? Continue

# Once user has pressed S to start the above check will pass
# continuously, until it finds a number with no hex digits

                        Load AR into line 21, extract
                        first and second nibble, and first byte
.   . u.L5.  .0.28.21   4 copies of AR to 21:0-4
.   . u.L5.  .0.31.22   Extract to Line 22

                        If first nibble >= 10 (hex A) go to random fix
.   .  .01.  .0.22.28   22:1 -> AR
.   .  .  .L2.3.00.29   AR = AR - 9
.   +a
.   .  .L2.  .0.22.31   AR Negaive?
.   .  .  .rf.0.00.00   Not Negative, bigger than 9
                        Negative, continue

                        If second nibble is >= 10 go to random fix
.   .  .02.  .0.22.28   22:1 -> AR
.   .  .  .L2.3.00.29   AR = AR - 90
.   +a0
.   .  .L2.  .0.22.31   AR Negaive?
.   .  .  .rf.0.00.00   Not Negative, bigger than 9
                        Negative, continue

.   . w.  .d1.0.21.31   GOSUB d1

pp:                     PromPt
.   .  .L1.L2.0.00.28 - Load into AR
.   b 010 011 100 000 000 001 000 000 000 00
.   .  .03.  .0.28.03   Copy format code to 3:03
.   .  .L1.L2.0.00.28 - Load into AR
.   +0000000
.   .  .L2.  .0.08.31   Output AR to typewriter
.L3 .  .L0.L0.0.28.31   Wait for IOReady

.   .  .L1.L2.0.00.28 - Load into AR
.   b 100 000 000 011 011 011 010 001 000 00
.   .  .03.  .0.28.03   Copy format code to 3:03
.   .  .L1.L2.0.00.28 - Load into AR
.   -9999999
.   .  .L2.  .0.08.31   Output AR to typewriter
.L3 .  .L0.L0.0.28.31   Wait for IOReady

gg:                     "Get Guess"

# This clears line 23, and then adds a special bit in the last word.
# That bit will be shifted away after 9 bits of input. That is two
# Characters and CR shifts in a 0 sign. This allows the code to Loop
# until the user presses DDCr, no need for s.

                        Clear 23:0 for type-in
.   .  .  .  .0.29.28   0 -> AR
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
                        Load guess into AR
.   .  .00.  .0.23.28   23:0 -> AR

                        Subtract the secret
.   .  .00.  .3.22.29   AR = AR - 22:0

.   .  .  .  .0.28.27   Is AR == 0?
.   . w.rn.d3.0.21.31   GOSUB d3, back to rn

.   .  .L2.  .0.22.31   AR Negaive?
.   . w.gg.d2.0.21.31       Not Negaive, too big
.   . w.gg.d1.0.21.31       Negative

.   . w.  .d2.0.21.31   GOSUB d2


.   .  .L2.rn.0.16.31   Halt

d3:
.   .  .00.  .0.17.31   DING
.   .  .L2.  .0.00.00   NOP
.   .  .L2.  .0.00.00   NOP
.   .  .L2.  .0.00.00   NOP
.   .  .L2.  .0.00.00   NOP
.   .  .L2.  .0.00.00   NOP
.   .  .L2.  .0.00.00   NOP
.   .  .L2.  .0.00.00   NOP
.   .  .L2.  .0.00.00   NOP
.   .  .L2.  .0.00.00   NOP
.   .  .L2.  .0.00.00   NOP
.   .  .L2.  .0.00.00   NOP
.   .  .L2.  .0.00.00   NOP
d2:
.   .  .00.  .0.17.31   DING
.   .  .L2.  .0.00.00   NOP
.   .  .L2.  .0.00.00   NOP
.   .  .L2.  .0.00.00   NOP
.   .  .L2.  .0.00.00   NOP
.   .  .L2.  .0.00.00   NOP
.   .  .L2.  .0.00.00   NOP
.   .  .L2.  .0.00.00   NOP
.   .  .L2.  .0.00.00   NOP
.   .  .L2.  .0.00.00   NOP
.   .  .L2.  .0.00.00   NOP
.   .  .L2.  .0.00.00   NOP
.   .  .L2.  .0.00.00   NOP
d1:
.   .  .00.  .0.17.31   DING
.   .  .L1.L0.0.20.31   RETURN