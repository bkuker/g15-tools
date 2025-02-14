#LL S P.TT.NN.C.SS.DD BP  Comment

#Diaper tape 1 block 1, just some random instructions
#                         Hex from decompiler
.00 s u.01.02.0.19.00     002044w0  Line 19 to Line 0 - Test not set
.01 s u.02.02.0.19.00     004044w0 Line 19 to Line 0 - Test set
.02 .  .16.18.0.21.31     0202457y  Exit to Line 0, 18 ; T # of 16 for format use
.03 -8w00000              11800001 From diaper doc
.04 .  .05.05.1.31.31     00u0uzzy Number track to Line 18
.05 .  .07.07.3.00.28     00y0z838  Clear and subtract 17x86w from AR 
.06 147x86w               028zv0x8  from diaper doc
.07 . u.08.11.1.18.29     01016wvu Add all Line 18 
.08 .  .10.21.0.08.31     0142u23y Type AR 3; also from 35 above 

#.18 s  .00.48.1.19.31     00060wzy  Stop DA-1
#.48 .  .51.51.0.23.31     066665zy Clear
#.51 . u.52.04.1.26.18     06808yu4 Clear Line 18
#.04 .  .05.05.1.31.31     00u0uzzy Number track to Line 18
#.74 . w.70.30.0.21.31     18w3w57y  Mark 70 3; enter error subroutine at 30 above

#Programmers ref P25
#.00 .  .05.01.1.12.28     a = (12.05) + -> ARc
#.01 .  .20.02.3.07.29     b = (7.20) - -> AR+
#.02 .  .36.03.2.07.29     |c| = |(07.36)| -> AR+
#.03 .  .u0.04.1.28.06     x = (AR) + -> 06.u0