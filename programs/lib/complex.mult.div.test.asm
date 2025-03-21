<INCLUDE src="bbl.asm">
ct:                     Count
.   d4                  Load 2 blocks

<BLOCK>                 Line 3 format
.03 b111 000 011 000 000 000 000 010 001 00

<BLOCK>                 Line 2, BCD Routine

<INCLUDE src="bcd.fraction.asm">

<BLOCK>                 Block 1

<INCLUDE src="complex.mult.div.asm">

<BLOCK>                 Block 0

# Complex Multiplication and Division. Subroutine #1205.
#   by D. Stein & S. H Lewis. 13 March 1957
#
# drg calling code (program start: 00.00)
#
# test multiplication (a+bi)(c+di)
# (1.6+2.5i)(2.5+0.9i)=(1.75+7.69i)
# results in 20.00. 20.01
#
.00 . u.05.05.0.00.22      22.01-.00:=00.01-.04
.01 d0.025               c=2.5*(10^-2)
.02 d0.025               b=2.5*(10^-2)
.03 d0.016               a=1.6*(10^-2)
.04 d0.009               d=0.9*(10^-2)
.05 .  .07.07.0.29.31      overflow set?  (to clear overflow)
.07 .  .10.12.4.00.21    no:  21.02.03:=00.10.11  (return addresses)
.08 .  .10.12.4.00.21    yes: 21.02.03:=00.10.11  (return addresses)
.10 .  .14.14.0.20.31      command for normal return
.11 .  .13.13.0.20.31      command for overflow return
.12 .  .40.40.1.20.31      "goto" 01.40 (complex multiply)

.13 .  .86.84.0.16.31   Overflow Return. HALT

                        Normal return
                        Print X
.14 .  .01.  .0.20.25   X -> ID.1 (BCD Routeine Parameter)
.   .  .L1.L2.1.00.28   Load BCD Return instruction to AR, skip it
.   .  .ax.ax.0.20.31   GOTO 0:ay (return instruction)
.   .  .61.61.2.20.31   GOTO 2:61 (BCD Routine)
ax:
.   .  .L2.  .0.08.31   Output AR to typewriter
.   .  .L0.L0.0.28.31   Wait here for IOReady
                        Print Y
.   .  .00.  .0.20.28 - Y -> AR
.   .  .01.  .0.28.25   AR -> ID.1 (BCD Routine Parmaeter)
.   .  .L1.L2.1.00.28   Load BCD Return instruction to AR, skip it
.   .  .ay.ay.0.20.31   GOTO 0:ax (return instruction)
.   .  .61.61.2.20.31   GOTO 2:61 (BCD Routine)
ay:
.   .  .L2.  .0.08.31   Output AR to typewriter
.   .  .L0.L0.0.28.31   Wait here for IOReady


.   .  .L2.L0.0.16.31   HALT