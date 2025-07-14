# Copy loaded program from 19 -> 0 and begin execution at 0:03
.00 . u.01.02.0.19.00   Line 19 to Line 0 - Test not set
.01 . u.02.02.0.19.00   Line 19 to Line 0 - Test set
.02 .  .04.03.0.21.31   Transfer control to 0:03

##### SET UP FORMAT
#Minus, Period, 0-7 and TAB
                        SPDDDDDDD[CR]E
.03 .  .04.06.5.00.26   Copy next two words to PN
.04   +1000000          
.05   -8w00000          
.06 .  .02.07.5.26.03   Copy PN to line 3:02,03

lp:

##### PRINT DIRECT FROM AR
.07 .  .28.08.0.00.28   Load vv to AR
.08 .  .10.10.0.08.31   Output AR to typewriter
.10 .  .10.10.0.28.31   Wait for IOReady

##### PRINT WITH COPY TO / FROM 23:0
.11 .  .28.12.0.00.28   Load vv to AR
.12 .  .00.13.0.28.23   AR -> 23:0
.13 .  .00.14.0.23.28   23:0 -> AR
.14 .  .16.16.0.08.31   Output AR to typewriter
.16 .  .16.16.0.28.31   Wait for IOReady

##### PRINT WITH COPY TO / FROM 23:0 AND TYPE-IN
.17 .  .28.18.0.00.28   Load next value to AR
.18 .  .00.19.0.28.23   AR -> 23:0
.19 .  .21.20.0.12.31   Enable Type In
.20 .  .20.20.0.28.31   Wait for IOReady

##### At least three cycles after Input...
.21 .  .23.22.0.00.00   
.22 .  .24.23.0.00.00   
.23 .  .25.24.0.00.00   
.24 .  .26.25.0.00.00   

##### COPY TYPED IN VALUE TO VV AND LOOP
.25 .  .28.07.0.23.00   23:0 -> vv

vv:
.28   -0123456          
