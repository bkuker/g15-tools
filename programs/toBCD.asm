.00 . u.01.01.0.19.02     Line 19 to Line 2 - Test not set
.01 .  .03.02.2.21.31     Jump to 2:2

#This code must be here because it copies to 3:3 for formatting
                          Set up formatting
.02 .  .03.04.1.02.03     0:3 -> 3:3 Copy format code to line 3, goto 4
.03 C000044               Format code: period, 6 digits, Linefeed, end

                          Print value A to typewriter
.04 .  .vA.  .1.02.28     0.30 -> ARc   AR = A
pr:
.   .  .L2.  .0.08.31     Output AR to typewriter
.   .  .L0.L0.0.28.31     Wait here for IOReady

.   .  .vA.64.0.02.25     Load vA -> ID.1

.   .  .L2.L0.0.16.31     HALT

vA:
.99 0x2x3xzy              Decimal value 0.411772724

# Input-Output Routine - Binary to decimal
# #1101
# Prepared by Ed Williams
# Page 7 of 9
# Date 1-25-57
# Line 02
#   Input:
#       x in Id.1
#       Return command in AR
#   Output:
#       x as decimal in AR
#
# https://rbk.delosent.com/allq/Q7621.pdf Page 15
# Transcribed: Bill Kuker 2/22/2025
#
.61 .  .63.64.0.28.02    Return Link
.64 .  .65.75.0.25.28    X->AR
.75 .  .76.84.0.02.29    x1 = x + roundoff
.84 .  .90.90.0.23.31    clear
.90 .  .91.92.0.28.25    x1->ID.1
.92 .  .93.95.0.02.24    [v6xv680]->MQ.1
.95 .  .06.u2.0.24.31    d1
.u2 .  .u5.u5.3.23.31    
.u5 .  .06.10.0.24.31    d2
.10 .  .13.13.3.23.31    
.13 .  .06.20.0.24.31    d3
.20 .  .23.23.3.23.31    
.23 .  .06.30.0.24.31    d4
.30 .  .33.33.3.23.31    
.33 .  .06.40.0.24.31    d5
.40 .  .43.43.3.23.31    
.43 .  .06.50.0.24.31    d6
.50 .  .53.53.3.23.31    
.53 .  .06.60.0.24.31    d7
#.60 .  .61.63.0.26.28    |x| +-> AR
.60 .  .61.pr.0.26.28    |x| +-> AR
#.63                      Exit...?

#Data Check format, signed or un?
.76   +000000x            "Roundoff"?
.93   +v6xv680
.u7   9u3wy94            

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
.52   +zzzzzzz