# BBL - Bill's Bendix Loader
# Prepared by: Bill Kuker
# Date: 2-25-2025
#
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
# Usage:
# Include this file, store number of tracks to load at :ct
#
# <INCLUDE src="bbl.asm">
# ct:                      Count
# .     +3                 Number of tracks to load
#


# Copy loaded program from 19 -> 0 and begin execution at 0:03
#
.00 . u.01.02.0.19.00    Line 19 to Line 0 - Test not set
.01 . u.02.02.0.19.00    Line 19 to Line 0 - Test set
.02 .  .03.03.0.21.31    GOTO 0:3

# After each block is copied it goes to 0.
# The following code replazes the original instruction at zero with a
# jump to lp: at instruction iterate the loop.
#
# When the count reaches zero, this program will have been replaced
# by final block loaded from tape. I feel vaguely clever.

                         Replace instruction a 0.0 with jump to lp:
.   .  .nz.  .1.00.28    nz -> ARc
.   .  .00.  .1.28.00    AR -> 00


lp:                      Loop
                         Load a block, copy it to Line nr in :ct
.   .  .L2.  .0.15.31    Read next tape block
.   .  .L0.L0.0.28.31    Wait for IOReady
                         Load ct, decrement, store to ct
.   .  .ct.  .1.00.28    ct -> ARc
.   .  .on.  .3.00.29    AR--
.   .  .ct.  .1.28.00    AR -> ct
.   .  .cp.  .1.00.29    Add copy intruction to ct in AR
.   .  .L2.L2.0.31.31    NCAR

#Data

nz:                      New Instruction for location Zero 
.   .  .lp.lp.0.20.31    GOTO 0.lp

cp:                      Copy
.   . u.L1.00.0.19.01    Copy Instruction: Line 19 to Line 1
                         Added to AR, which has target line -1

on:                      One - Constant
.     +1