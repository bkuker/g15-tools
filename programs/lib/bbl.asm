# BBL - Bill's Bendix Loader
# Prepared by: Bill Kuker
# Date: 2-24-2025
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
#
# Usage:
# Include this file, store number of tracks to load at :ct
# ct = 4 will load 4 tracks into lines 3,2,1,0 and then jump
# to 00:00
#
# #include "bbl.asm"
# ct:                      Count
# .     +4                 Number of blocks to load
#


# Copy loaded program from 19 -> 0 and begin execution at 0:03
#
.00 . u.01.02.0.19.00   Line 19 to Line 0 - Test not set
.01 . u.02.02.0.19.00   Line 19 to Line 0 - Test set
.02 .  .03.03.0.21.31   GOTO 0:3

# After each block is copied it goes to 0.
# The following code replazes the original instruction at zero with a
# jump to lp: at instruction iterate the loop.
#
# When the count reaches zero, this program will have been replaced
# by final block loaded from tape. I feel vaguely clever.

                        Replace instruction a 0.0 with jump to lp:
.   .  .nz.  .1.00.28   nz -> ARc
.   .  .00.  .1.28.00   AR -> 00


lp:                     Loop
                        Clear Line 19
.   .  .  .  .0.29.28   0 -> AR
.   . u.L1.  .0.28.19   AR -> Line 19

                        Load a block, copy it to Line nr in :ct
.   .  .L2.  .0.15.31   Read next tape block
.   .  .L0.L0.0.28.31   Wait for IOReady

                        Calculate Checksum
.   .  .  .  .0.29.28   0 -> AR
.   . u.L1.  .1.19.29   Sum line 19 to AR
.   .  .L2.  .0.28.27   If AR == 0
.   .  .00.ok.0.00.00       goto ok
                        else
.   .  .00.bc.0.00.00       got bc

ok:                     OK Checksum
                        Decrement count
.   .  .ct.  .1.00.28   ct -> ARc
.   .  .on.  .3.00.29   AR--
.   .  .ct.  .1.28.00   AR -> ct

                        Execute copy instruction
.   .  .L1.L2.1.00.29   Add copy intruction to ct in AR
.   . u.L4.00.0.19.00   Copy Instruction: Line 19 to Line 0
                        Added to AR, which has target line
.   .  .L2.L2.0.31.31   NCAR
                        Copy instruction jumps to 0:0

bc:                     BAD Checksum
.   .  .  .  .0.17.31   DING
.   .  .L2.ok.0.16.31   Halt

#Data

nz:                     New Instruction for location Zero 
.   .  .lp.lp.0.20.31   GOTO 0.lp



on:                     One - Constant
.   +1