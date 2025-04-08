<INCLUDE src="../lib/bbl.asm">
ct:                     Count
.   d4                  Load 4 blocks

<BLOCK>                 Block 3 AR Format
.02 b0 001 000 000 000 000 000 000 000 000 0
.03 b100 011 000 000 000 000 000 000 000 01

<BLOCK>                 Line 2 Blank

<BLOCK>                 Block 1
<INCLUDE src="../lib/complex.mult.div.asm">

<BLOCK>                 Block 0

# Call complex multiplication to compute
# (-0.5 + 0i) squared.
# The result is different on two different emulators.

.00 . u.05.05.0.00.22      22.01-.00:=00.01-.04
.01 d-0.005               c=2.5*(10^-2)
.02 d0.000               b=2.5*(10^-2)
.03 d-0.005               a=1.6*(10^-2)
.04 d0.000               d=0.9*(10^-2)
.05 .  .07.07.0.29.31      overflow set?  (to clear overflow)
.07 .  .10.12.4.00.21    no:  21.02.03:=00.10.11  (return addresses)
.08 .  .10.12.4.00.21    yes: 21.02.03:=00.10.11  (return addresses)
.10 .  .14.14.0.20.31      command for normal return
.11 .  .13.13.0.20.31      command for overflow return
.12 .  .40.40.1.20.31      "goto" 01.40 (complex multiply)

.13 .  .14.14.0.17.31   Overflow return DING and continue

                        Normal return
                        Print Real Component
.   .  .%1.  .0.20.28   |Zr| -> AR
.   .  .L2.  .0.08.31   Output AR to typewriter
.L3 .  .L0.L0.0.28.31   Wait for IOReady

.   .  .L2.L0.0.16.31   HALT