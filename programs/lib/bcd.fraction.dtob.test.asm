# A simple decimal fraction addition routine.
# Worlds crappiest calculator!

#include "bbl.asm"

ct:
.   d4                  Load 4 blocks of code

<BLOCK>                 Line 3, format code
.03 b100 000 000 000 000 000 000 000 001 00

<BLOCK>                 Line 2, code under test
#include "bcd.fraction.asm"

<BLOCK>                 Line 1
                        Intentionally blank

<BLOCK>
                        Line 0, test code
.00 .  .00.  .0.00.00   NOP GOTO 1

                        Input and convert the first number
.   .  .ze.  .0.00.28   AR = 0
.   .  .00.  .0.28.23   AR -> 23:0
.   .  .L2.  .0.12.31   Enable Type in
.L2 .  .L0.L0.0.28.31   Wait for IOReady
.   .  .00.  .0.23.28   23:0 -> AR Load typed value into AR
.   .  .01.  .0.28.25   AR -> ID:1
.   .  .ri.cl.0.00.28   Load Return Instruction into ACC
ri:                     Return Instruction (data)
.   .  .ac.ac.0.20.31   GOTO 0:ac
cl:                     Call Conversion routine
.   .  .46.46.2.20.31   GOTO 2:46
ac:
                        Converted fractional value in MQ:0
.   .  .00.  .0.24.20   MQ:0 -> 20:0

                        Input and convert the second number
.   .  .ze.  .0.00.28   AR = 0
.   .  .00.  .0.28.23   AR -> 23:0
.   .  .L2.  .0.12.31   Enable Type in
.L2 .  .L0.L0.0.28.31   Wait for IOReady
.   .  .00.  .0.23.28   23:0 -> AR Load typed value into AR
.   .  .01.  .0.28.25   AR -> ID:1
.   .  .r2.c2.0.00.28   Load Return Instruction into ACC
r2:                     Return Instruction (data)
.   .  .a2.a2.0.20.31   GOTO 0:ac
c2:                     Call Conversion routine
.   .  .46.46.2.20.31   GOTO 2:46
a2:
                        Converted fractional value in MQ:0
                        MQ:0 -> 20:1
.   .  .00.  .0.24.28   MQ:0 -> ARc
.   .  .01.  .0.28.20   AR -> 20:1   

                        Add the two numbers in AR
.   .  .00.  .0.20.28   20:0 -> ARc
.   .  .01.  .0.20.29   20:1 -> AR+

                        Convert AR to Decimal
.   .  .01.  .0.28.25   AR -> ID:1
.   .  .r3.c3.0.00.28   Load Return Instruction into ACC
r3:                     Return Instruction (data)
.   .  .a3.a3.0.20.31   GOTO 0:ac
c3:                     Call D-to-B Conversion routine
.   .  .61.61.2.20.31   GOTO 2:46
a3:


                        Print out AR
.   .  .L2.  .0.08.31   Type AR
.   .  .L0.L0.0.28.31   Wait for IOReady
.   .  .L2.00.0.16.31   HALT


ze:
.   d0