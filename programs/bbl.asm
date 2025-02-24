# BBL - Bill's Bendix Loader
#
# As the first block on a tape (after the number track) this
# Program reads the specified number of blocks into the first
# N lines of the drum in reverse order. The final block is
# copied into line 0, and then execution is transferred to
# Line 0 Instruction zero.
#
# It might waste a few inches of tape, but lets be real I'll
# never get to run it on the real thing.
# 
# (BBL Rhymes with nibble)


# Copy loaded program from 19 -> 0 and begin execution at 0:03
.00 . u.01.02.0.19.00    Line 19 to Line 0 - Test not set
.01 . u.02.02.0.19.00    Line 19 to Line 0 - Test set
.02 .  .03.03.0.21.31    Execute Line 0 GOTO 0:3

# After each block is copied it goes to 0.
# The following code replazes the original instruction at zero with a
# jump to lp: at instruction iterate the loop.
#
# When the count reaches zero, this program will have been replaced
# by final block loaded from tape. I feel vaguely clever.
.   .  .nz.  .1.00.28    nt -> ARc
.   .  .00.  .1.28.00    AR -> 00


lp:                      Loop
# Load a block, copy it to Line specified in :ct
.   .  .L2.  .0.15.31    Read next tape block
.   .  .L0.L0.0.28.31    Wait for IOReady
.   .  .ct.  .1.00.28    ct -> ARc
.   .  .on.  .3.00.29    AR--
.   .  .ct.  .1.28.00    AR -> ct
.   .  .cp.  .1.00.29    Add copy intruction to AR
.   .  .L2.L2.0.31.31    NCAR

nz:                      New Zero 
.   .  .lp.lp.0.20.31    GOTO lp instruction for location zero

cp:                      Copy   
.   . u.L1.00.0.19.01    Copy Instruction: Line 19 to Line 1
                         Added to AR, which has target line -1

ct:                      Count Tracks
.     +3                 Tracks to load

on:                      One.
.     +1

#TEST BLOCKS BELOW

BLOCK:
.00   +3

BLOCK:
.00   +2

BLOCK:
.00   +1

BLOCK:
.00 .  .L2.L0.0.16.31    HALT