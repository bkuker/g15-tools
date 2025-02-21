#Print the Fibonacci numbers

.00 . u.01.01.0.19.00     Line 19 to Line 0 - Test not set
.01 .  .03.02.0.21.31     Jump to 0:2

                          Set up formatting
.02 .  .03.lp.1.0.03      0:3 -> 3:3 Copy format code to line 3, goto 4
.03 0000044               Format code, no sign no decimal, line feed.

#Should Blank N go to L+1, or next SLOC?
#Probably next sloc!

#lp:
                          Print value A to typewriter
.04 .  .30.  .1.00.28     0.30 -> ARc   AR = A
.   .  .L2.  .0.08.31     Output AR to typewriter
.   .  .L0.L0.0.28.31     Wait here for IOReady

                          C = A + B...
.   .  .30.  .1.00.28     0.30 -> ARc   AR = A
.   .  .31.  .2.00.29     0.31 -> AR+   AR += B
.   .  .32.  .1.28.00     AR -> 00.32   C = A + B
.   .  .31.  .1.00.28     AR = B
.   .  .30.  .1.28.00     A = AR
.   .  .32.  .1.00.28     AR = C
.   .  .31.lp.1.28.00     B = AR, GOTO 4

.30 1                     A
.31 1                     B
.32 0                     C

