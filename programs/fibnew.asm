#Print the Fibonacci numbers

.00 . u.01.  .0.19.00     Line 19 to Line 0 - Test not set
.01 .  .03.  .0.21.31     Jump to 0:2

#This code must be here because it copies to 3:3 for formatting
                          Set up formatting
.02 .  .03.lp.1.00.03     0:3 -> 3:3 Copy format code to line 3, goto 4
.03 0000044               Format code, no sign no decimal, line feed.

#This code is mainly relocatiable, so no L or N literals
lp:
                          Print value A to typewriter
.   .  .vA.  .1.00.28     0.30 -> ARc   AR = A
.   .  .L2.  .0.08.31     Output AR to typewriter
.   .  .L0.L0.0.28.31     Wait here for IOReady

                          C = A + B...
.   .  .vA.  .1.00.28     0.30 -> ARc   AR = A
.   .  .vB.  .2.00.29     0.31 -> AR+   AR += B
.   .  .vC.  .1.28.00     AR -> 00.32   C = A + B
.   .  .vB.  .1.00.28     AR = B
.   .  .vA.  .1.28.00     A = AR
.   .  .vC.  .1.00.28     AR = C
.   .  .vB.lp.1.28.00     B = AR, GOTO 4

#Using labels for variables feels dirty
#because there is no src / dst check logic
vA:
.   d1                     A
vB:
.   d1                     B
vC:
.   d0                     C

