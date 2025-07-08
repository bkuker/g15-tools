# Copy loaded program from 19 -> 0 and begin execution at 0:03
.00 . u.01.02.0.19.00   Line 19 to Line 0 - Test not set
.01 . u.02.02.0.19.00   Line 19 to Line 0 - Test set
.02 .  .04.03.0.21.31   Transfer control to 0:03

lp:

##### SET UP FORMAT
#Minus, Period, 0-7 and TAB
                        SPDDDDDDD[CR]E
.od .  .L1.L3.5.00.26   Copy next two words to PN
.   b 0 001 000 000 000 000 000 000 000 000 0 
.   b 100 011 000 000 000 000 000 000 000 01
.   .  .02.  .5.26.03   Copy PN to line 3:02,03

##### PRINT DIRECT FROM AR
.   .  .L1.L2.0.00.28   Load next value to AR
.   -0123456
.   .  .L2.L2.0.08.31   Output AR to typewriter
.L2 .  .L0.L0.0.28.31   Wait for IOReady

##### PRINT WITH COPY TO / FROM 23:0
.   .  .L1.L2.0.00.28   Load next value to AR
.   -0123456
.   .  .%0.  .0.28.23   AR -> 23:0
.   .  .%0.  .0.23.28   23:0 -> AR
.   .  .L2.L2.0.08.31   Output AR to typewriter
.L2 .  .L0.L0.0.28.31   Wait for IOReady

##### PRINT WITH COPY TO / FROM 23:0 AND TYPE-IN
.   .  .L1.L2.0.00.28   Load next value to AR
.   -0123456
.   .  .%0.  .0.28.23   AR -> 23:0
.   .  .L2.  .0.12.31   Enable Type In
.   .  .L0.L0.0.28.31   Wait for IOReady
.   .  .%0.  .0.23.28   23:0 -> AR
.   .  .L2.L2.0.08.31   Output AR to typewriter
.L2 .  .L0.L0.0.28.31   Wait for IOReady

.   .  .L1.lp.0.00.00   GOTO lp