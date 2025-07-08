# Copy loaded program from 19 -> 0 and begin execution at 0:03
.00 . u.01.02.0.19.00   Line 19 to Line 0 - Test not set
.01 . u.02.02.0.19.00   Line 19 to Line 0 - Test set
.02 .  .04.03.0.21.31   Transfer control to 0:03

lp:

##### SET UP FORMAT
#Minus, Period, 0-7 and TAB
                        SPDDDDDDD[CR]E
.03 .  .04.06.5.00.26   Copy next two words to PN
.04   +1000000          
.05   -8w00000          
.06 .  .02.07.5.26.03   Copy PN to line 3:02,03

##### PRINT DIRECT FROM AR
.07 .  .08.09.0.00.28   Load next value to AR
.08   -0123456          
.09 .  .11.11.0.08.31   Output AR to typewriter
.11 .  .11.11.0.28.31   Wait for IOReady

##### PRINT WITH COPY TO / FROM 23:0
.12 .  .13.14.0.00.28   Load next value to AR
.13   -0123456          
.14 .  .16.15.0.28.23   AR -> 23:0
.15 .  .16.16.0.23.28   23:0 -> AR
.16 .  .18.18.0.08.31   Output AR to typewriter
.18 .  .18.18.0.28.31   Wait for IOReady

##### PRINT WITH COPY TO / FROM 23:0 AND TYPE-IN
.19 .  .20.21.0.00.28   Load next value to AR
.20   -0123456          
.21 .  .24.22.0.28.23   AR -> 23:0
.22 .  .24.23.0.12.31   Enable Type In
.23 .  .23.23.0.28.31   Wait for IOReady
.24 .  .28.25.0.23.28   23:0 -> AR
.25 .  .27.27.0.08.31   Output AR to typewriter
.27 .  .27.27.0.28.31   Wait for IOReady

.28 .  .29.03.0.00.00   GOTO lp
