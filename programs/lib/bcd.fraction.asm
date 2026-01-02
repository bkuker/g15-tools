# Input-Output Routine - Binary to decimal
# Prepared by: Ed Williams #1101
# Page: 7 of 9
# Date: 1-25-1957
# Line: 02
#   Entry:  61
#   Exit:   63
#   Input:
#      x in Id.1
#      Return command in AR
#   Output:
#      x as decimal in AR
#
# https://rbk.delosent.com/allq/Q7621.pdf Page 15
# http://www.bitsavers.org/pdf/bendix/g-15/G15D_Subroutines.pdf
# Transcribed: Bill Kuker 2/22/2025
#
.61 .  .63.64.0.28.02   Return Link
.64 .  .65.75.0.25.28   X->AR
.75 .  .76.84.0.02.29   x1 = x + roundoff
.84 .  .90.90.0.23.31   clear
.90 .  .91.92.0.28.25   x1->ID.1
.92 .  .93.95.0.02.24   [v6xv680]->MQ.1
.95 .  .06.u2.0.24.31   d1
.u2 .  .u5.u5.3.23.31    
.u5 .  .06.10.0.24.31   d2
.10 .  .13.13.3.23.31    
.13 .  .06.20.0.24.31   d3
.20 .  .23.23.3.23.31    
.23 .  .06.30.0.24.31   d4
.30 .  .33.33.3.23.31    
.33 .  .06.40.0.24.31   d5
.40 .  .43.43.3.23.31    
.43 .  .06.50.0.24.31   d6
.50 .  .53.53.3.23.31    
.53 .  .06.60.0.24.31   d7
.60 .  .61.63.0.26.28   |x| +-> AR
.63    0                Exit

#Data Check format, signed or un?
.76   +000000x          Roundoff
.93   +v6xv680
#.u7   9u3wy94            

.u3   +0zzzzzz
.u4   +zzzzzzz
.11   +00zzzzz
.12   +zzzzzzz
.21   +000zzzz
.22   +zzzzzzz
.31   +0000zzz
.32   +zzzzzzz
.41   +00000zz
.42   +zzzzzzz
.51   +000000z
.52

# Input-Output Routine - Decimal to binary
# Prepared by: Ed Williams #1101
# Page: 8 of 9
# Date: 1-25-1957
# Line: 02
#   Entry:  46
#   Exit:   47
#   Input:
#       x (decimal) in ID1 (7 digits & sign)
#       Return command in AR
#   Output:
#       ± |x| ± (binary fraction) in MQ0
#       ± |x| ± (binary integer) in AR

.46 .  .47.54.0.28.02   Link return
.54 .  .58.59.0.02.26   Clear PN0
.59 .  .61.62.0.25.24   Xd -> MQ1
.62 .  .67.69.1.02.25   10^6 -(1)->ID1
.69 .  .08.78.0.24.31   d1
.78 .  .79.81.1.02.25   d1
.81 .  .08.91.0.24.31
.91 .  .97.99.1.02.25   d3
.99 .  .08.26.0.24.31
.26 .  .27.29.1.02.25   d4
.29 .  .08.38.0.24.31
.38 .  .39.71.1.02.25   d5
.71 .  .08.80.0.24.31
.80 .  .83.85.1.02.25   d6
.85 .  .08.94.0.24.31
.94 .  .u1.07.1.02.25   d7
.07 .  .08.28.0.24.31
.28 .  .29.68.0.26.28   Xint -> AR
.68 .  .73.77.1.02.25   10^7 -> ID1
.77 .  .57.82.5.25.31   Xf -> MQ0
.47    0                Exit
.82 .  .83.86.1.28.25   Xint -(1)-> ID1
.86 .  .88.89.1.24.28   Xf -> AR
.89 .  .96.98.3.02.29   Xf - 2^-28
.98 .  .u0.66.1.28.24   Xf1 -> MQ0
.66 .  .67.47.1.25.28   Xin -> AR

# Assuming these are all signed format - @bkuker
.67    +0z42400
.79    +0186u00
.97    +0027100
.27    +0003y80
.39    +0000640
.83    +00000u0
.u1    +0000010
.73    +0989680
.58    +0000000
.96    +0000001