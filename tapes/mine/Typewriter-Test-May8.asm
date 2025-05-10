# Copy loaded program from 19 -> 0 and begin execution at 0:03
.00 . u.01.02.0.19.00   Line 19 to Line 0 - Test not set
.01 . u.02.02.0.19.00   Line 19 to Line 0 - Test set
.02 .  .04.03.0.21.31   Transfer control to 0:03

pt:

#Minus, Period, 0-7 and TAB
                        SPDDDDDDDTE
.03 .  .04.06.5.00.26   Copy next two words to PN
.04   +1000000          
.05   -8w00001          
.06 .  .02.07.5.26.03   Copy PN to line 3:02,03

.07 .  .08.09.0.00.28   
vv:
.08   -0123456          
.09 .  .11.11.0.08.31   Output AR to typewriter
.11 .  .11.11.0.28.31   Wait for IOReady

.12 .  .13.13.0.00.00   Timing

#Minus, Period, 7-x, NO TAB, positive .yz01234
#Question: Is a space printed as the second sign?
                        SPDDDDDDDE
.13 .  .14.16.5.00.26   Copy next two words to PN
.14   +8000000          
.15   +8w00000          
.16 .  .02.17.5.26.03   Copy PN to line 3:02,03

.17 .  .18.19.0.00.28   
.18   -789uvwx          
.19 .  .21.21.0.08.31   Output AR to typewriter
.21 .  .21.21.0.28.31   Wait for IOReady

.22 .  .23.24.0.00.28   
.23   +yz01234          
.24 .  .26.26.0.08.31   Output AR to typewriter
.26 .  .26.26.0.28.31   Wait for IOReady


#7 digits with sign and leading zeros
#Question: Are the leading zeros spaces or nothing?
                        SDDDDDDDCrE
.27 .  .28.30.5.00.26   Copy next two words to PN
.28   +0000000          
.29   +8000002          
.30 .  .02.31.5.26.03   Copy PN to line 3:02,03

.31 .  .32.33.0.00.28   
.32   +0000056          
.33 .  .35.35.0.08.31   Output AR to typewriter
.35 .  .35.35.0.28.31   Wait for IOReady

.36 .  .37.38.0.00.28   
.37   -0000078          
.38 .  .40.40.0.08.31   Output AR to typewriter
.40 .  .40.40.0.28.31   Wait for IOReady


#7 digits with leading zeros, no sign or Period
#Question: Are the leading zeros spaces or nothing?
                        DDDDDDDCrE
.41 .  .42.44.5.00.26   Copy next two words to PN
.42   +0000000          
.43   +0000022          
.44 .  .02.45.5.26.03   Copy PN to line 3:02,03

.45 .  .46.47.0.00.28   
.46   +0000yyz          
.47 .  .49.49.0.08.31   Output AR to typewriter
.49 .  .49.49.0.28.31   Wait for IOReady


#Load the default first value printed 23:0
.50 .  .51.52.0.00.28   Load to AR
.51   -0123456          
.52 .  .00.53.0.28.23   AR -> 23:0

#Allow the user to replace it.
.53 .  .55.54.0.12.31   Enable Type In
.54 .  .54.54.0.28.31   Wait for IOReady



#Print a CR
                        Load a format code
.55 .  .56.58.5.00.26   Copy next two words to PN
.56   +0000000          
.57   +4400000          
.58 .  .02.59.5.26.03   Copy PN to line 3:02,03

.59 .  .61.61.0.08.31   Output AR to typewriter
.61 .  .61.61.0.28.31   Wait for IOReady

#Replace first value with value from 23:0 and loop
.62 .  .00.63.0.23.28   23:0 -> AR
.63 .  .08.03.0.28.00   AR -> 0:vv
