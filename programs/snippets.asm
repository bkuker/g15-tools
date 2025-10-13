# Copy loaded program from 19 -> 0 and begin execution at 0:04
.00 . u.01.02.0.19.00   Line 19 to Line 0 - Test not set
.01 . u.02.02.0.19.00   Line 19 to Line 0 - Test set
.02 .  .04.04.0.21.31   Transfer control to 0:04

#Load a 4 word format code

                        Load a format code
.%3 . u.L5.L5.5.00.20   Copy next four words to Line 20
.   b 000 000 000 000 000 000 000 000 000 00
.   b  00 000 000 000 000 000 000 000 000 000
.   b   0 001 000 000 000 000 000 000 000 000 0 
.   b 100 011 000 000 000 000 000 000 000 01
.   .  .00.  .5.20.03   DP Copy 20:00,01 to line 3:00,01
.   .  .02.  .5.20.03   DP Copy 20:02,03 to line 3:02,03

#Load a 2 word format code

                        Load a format code
.   .  .L1.L3.5.00.26   Copy next two words to PN
.   b 0 001 000 000 000 000 000 000 000 000 0 
.   b 100 011 000 000 000 000 000 000 000 01
.   .  .02.  .5.26.03   Copy PN to line 3:02,03