# Copy loaded program from 19 -> 0 and begin execution at 0:03
.00 . u.01.02.0.19.00   Line 19 to Line 0 - Test not set
.01 . u.02.02.0.19.00   Line 19 to Line 0 - Test set
.02 .  .04.03.0.21.31   Transfer control to 0:03

##### SET UP FORMAT
#Minus, Period, 0-7 and TAB
                        SPDDDDDDD[CR]E
.od .  .L1.L3.5.00.26   Copy next two words to PN
.   b 0 001 000 000 000 000 000 000 000 000 0 
.   b 100 011 000 000 000 000 000 000 000 01
.   .  .02.  .5.26.03   Copy PN to line 3:02,03

lp:

##### PRINT DIRECT FROM AR
.   .  .vv.  .0.00.28   Load vv to AR
.   .  .L2.L2.0.08.31   Output AR to typewriter
.L2 .  .L0.L0.0.28.31   Wait for IOReady

##### PRINT WITH COPY TO / FROM 23:0
.   .  .vv.  .0.00.28   Load vv to AR
.   .  .00.  .0.28.23   AR -> 23:0
.   .  .00.  .0.23.28   23:0 -> AR
.   .  .L2.L2.0.08.31   Output AR to typewriter
.L2 .  .L0.L0.0.28.31   Wait for IOReady

##### PRINT WITH COPY TO / FROM 23:0 AND TYPE-IN
.   .  .vv.  .0.00.28   Load next value to AR
.   .  .00.  .0.28.23   AR -> 23:0
.   .  .L2.  .0.12.31   Enable Type In
.   .  .L0.L0.0.28.31   Wait for IOReady

##### At least three cycles after Input...
.   .  .L2.  .0.00.00
.   .  .L2.  .0.00.00
.   .  .L2.  .0.00.00
.   .  .L2.  .0.00.00

##### COPY TYPED IN VALUE TO VV AND LOOP
.   .  .vv.lp.0.23.00   23:0 -> vv

vv:
.%0 -0123456