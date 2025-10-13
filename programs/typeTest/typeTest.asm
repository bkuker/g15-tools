# Copy loaded program from 19 -> 0 and begin execution at 0:03
.00 . u.01.02.0.19.00   Line 19 to Line 0 - Test not set
.01 . u.02.02.0.19.00   Line 19 to Line 0 - Test set
.02 .  .04.03.0.21.31   Transfer control to 0:03

pt:

#Minus, Period, 0-7 and TAB
                        SPDDDDDDDTE
.od .  .L1.L3.5.00.26   Copy next two words to PN
.   b 0 001 000 000 000 000 000 000 000 000 0 
.   b 100 011 000 000 000 000 000 000 000 11
.   .  .02.  .5.26.03   Copy PN to line 3:02,03

.   .  .L1.L2.0.00.28
vv:
.   -0123456
.   .  .L2.L2.0.08.31   Output AR to typewriter
.L2 .  .L0.L0.0.28.31   Wait for IOReady

.   .  .  .  .0.00.00   Timing

#Minus, Period, 7-x, NO TAB, positive .yz01234
#Question: Is a space printed as the second sign?
                        SPDDDDDDDE
.od .  .L1.L3.5.00.26   Copy next two words to PN
.   b 1 000 000 000 000 000 000 000 000 000 0 
.   b 100 011 000 000 000 000 000 000 000 00
.   .  .02.  .5.26.03   Copy PN to line 3:02,03

.   .  .L1.L2.0.00.28
.   -789uvwx
.   .  .L2.L2.0.08.31   Output AR to typewriter
.L2 .  .L0.L0.0.28.31   Wait for IOReady

.   .  .L1.L2.0.00.28
.   +yz01234
.   .  .L2.L2.0.08.31   Output AR to typewriter
.L2 .  .L0.L0.0.28.31   Wait for IOReady


#7 digits with sign and leading zeros
#Question: Are the leading zeros spaces or nothing?
                        SDDDDDDDCrE
.od .  .L1.L3.5.00.26   Copy next two words to PN
.   b 0 000 000 000 000 000 000 000 000 000 0 
.   b 100 000 000 000 000 000 000 000 001 00
.   .  .02.  .5.26.03   Copy PN to line 3:02,03

.   .  .L1.L2.0.00.28
.   +0000056
.   .  .L2.L2.0.08.31   Output AR to typewriter
.L2 .  .L0.L0.0.28.31   Wait for IOReady

.   .  .L1.L2.0.00.28
.   -0000078
.   .  .L2.L2.0.08.31   Output AR to typewriter
.L2 .  .L0.L0.0.28.31   Wait for IOReady


#7 digits with leading zeros, no sign or Period
#Question: Are the leading zeros spaces or nothing?
                        DDDDDDDCrE
.od .  .L1.L3.5.00.26   Copy next two words to PN
.   b 0 000 000 000 000 000 000 000 000 000 0 
.   b 000 000 000 000 000 000 000 010 001 00
.   .  .02.  .5.26.03   Copy PN to line 3:02,03

.   .  .L1.L2.0.00.28
.   +0000yyz
.   .  .L2.L2.0.08.31   Output AR to typewriter
.L2 .  .L0.L0.0.28.31   Wait for IOReady


#Load the default first value printed 23:0
.   .  .L1.L2.0.00.28   Load to AR
.   -0123456
.   .  .00.  .0.28.23   AR -> 23:0

#Allow the user to replace it.
.   .  .L2.  .0.12.31   Enable Type In
.   .  .L0.L0.0.28.31   Wait for IOReady

##### At least three cycles after Input...
.   .  .L2.  .0.00.00
.   .  .L2.  .0.00.00
.   .  .L2.  .0.00.00
.   .  .L2.  .0.00.00


#Print a CR
                        Load a format code
.od .  .L1.L3.5.00.26   Copy next two words to PN
.   b 0 000 000 000 000 000 000 000 000 000 0 
.   b 010 001 000 000 000 000 000 000 000 00
.   .  .02.  .5.26.03   Copy PN to line 3:02,03

.   .  .L2.L2.0.08.31   Output AR to typewriter
.L2 .  .L0.L0.0.28.31   Wait for IOReady

#Replace first value with value from 23:0 and loop
.   .  .00.  .0.23.28   23:0 -> AR
.   .  .vv.pt.0.28.00   AR -> 0:vv