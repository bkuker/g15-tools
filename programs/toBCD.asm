<INCLUDE src="lib/bbl.asm">
ct:                      Count
.     +3                 Number of tracks to load


<BLOCK>                  Line 3 format
.00   0
.01   0
.02   0                  Another decimal place?
.03   C000044            Format code: period, 6 digits, Linefeed, end


<BLOCK>                  Line 2 BCD Code
<INCLUDE src="lib/bcd.fraction.asm">


<BLOCK>                  Line 1, Unused


<BLOCK>                  Line 0, BCD Test program

# Binary to decimal IO Routine "test"
# Prepared by: Bill Kuker
# Date: 2-25-2025

.00 .  .vA.  .1.00.28    Load vA -> AR

                         Print value A to typewriter
.   .  .L2.  .0.08.31    Output AR to typewriter
.   .  .L0.L0.0.28.31    Wait here for IOReady

.   .  .vA.  .0.00.25    Load vA -> ID.1
.   .  .L1.L2.1.00.28    Load next instruction to AR, skip it
.   .  .ac.ac.0.20.31    GOTO 0:pr (return instruction)
.   .  .61.61.2.20.31    GOTO 2:61
ac:
                         Print value A to typewriter
.   .  .L2.  .0.08.31    Output AR to typewriter
.   .  .L0.L0.0.28.31    Wait here for IOReady
.   .  .L2.L0.0.16.31    HALT

vA:
.21   +506ww00           This has a surprise decimal value