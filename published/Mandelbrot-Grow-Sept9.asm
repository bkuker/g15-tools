# BBL - Bill's Bendix Loader
# Prepared by: Bill Kuker
# Date: 2-24-2025
#
#
# As the first block on a tape (after the number track) this
# Program reads the specified number of blocks into the first
# N lines of the drum in reverse order. The final block is
# copied into line 0, and then execution is transferred to
# Line 0 Instruction zero.
#
# It might waste a few inches of tape, but lets be real I'll
# never get to run it on the real thing.
# 
# (BBL Rhymes with nibble)
#
# Usage:
# Include this file, store number of tracks to load at :ct
# ct = 4 will load 4 tracks into lines 3,2,1,0 and then jump
# to 00:00
#
# #include "bbl.asm"
# ct:                      Count
# .     +4                 Number of blocks to load
#


# Copy loaded program from 19 -> 0 and begin execution at 0:03
#
.00 . u.01.02.0.19.00   Line 19 to Line 0 - Test not set
.01 . u.02.02.0.19.00   Line 19 to Line 0 - Test set
.02 .  .03.03.0.21.31   GOTO 0:3

# After each block is copied it goes to 0.
# The following code replazes the original instruction at zero with a
# jump to lp: at instruction iterate the loop.
#
# When the count reaches zero, this program will have been replaced
# by final block loaded from tape. I feel vaguely clever.

                        Replace instruction a 0.0 with jump to lp:
.03 .  .22.04.1.00.28   nz -> ARc
.04 .  .00.05.1.28.00   AR -> 00


lp:                     Loop
                        Clear Line 19
.05 .  .06.06.0.29.28   0 -> AR
.06 . u.07.07.0.28.19   AR -> Line 19

                        Load a block, copy it to Line nr in :ct
.07 .  .09.08.0.15.31   Read next tape block
.08 .  .08.08.0.28.31   Wait for IOReady

                        Calculate Checksum
.09 .  .10.10.0.29.28   0 -> AR
.10 . u.11.11.1.19.29   Sum line 19 to AR
.11 .  .13.12.0.28.27   If AR == 0
.12 .  .00.14.0.00.00   goto ok
                        else
.13 .  .00.20.0.00.00   got bc

ok:                     OK Checksum
                        Decrement count
.14 .  .24.15.1.00.28   ct -> ARc
.15 .  .23.16.3.00.29   AR--
.16 .  .24.17.1.28.00   AR -> ct

                        Execute copy instruction
.17 .  .18.19.1.00.29   Add copy intruction to ct in AR
.18 . u.22.00.0.19.00   Copy Instruction: Line 19 to Line 0
                        Added to AR, which has target line
.19 .  .21.21.0.31.31   NCAR
                        Copy instruction jumps to 0:0

bc:                     BAD Checksum
.20 .  .21.21.0.17.31   DING
.21 .  .23.14.0.16.31   Halt

#Data

nz:                     New Instruction for location Zero 
.22 .  .05.05.0.20.31   GOTO 0.lp



on:                     One - Constant
.23   +0000001          
ct:                     Count
.24   +0000003          

<BLOCK>
rs:                     Return Setup
.00 .  .01.02.1.02.28   Copy return command to A
.01 .  .40.40.2.20.31   Return Command
.02 .  .02.03.0.28.21   command for normal return
.03 .  .03.04.0.28.21   command for overflow return

                        Skip the above code after the
                        first call to this fractal code
.04 .  .05.06.0.02.28   Skip command to AR
.05 .  .01.07.0.00.00   
.06 .  .00.07.0.28.02   AR -> 2:0

                        Clear count
.07 .  .08.09.0.02.28   1 -> AR
.08   +0000001          
.09 .  .10.11.0.28.23   AR -> ct

                        Initialize Z
                        Load 23:0,1 (Ci,Cr) -> 20:0,1 (Zi,Zr)
.11 .  .12.13.0.23.20   Ci -> Zi
.13 .  .17.18.0.23.20   Cr -> Zr


lp:

#43-55
#                        Put Z into line 22 as complex mult params
#                        Copy 20:0,1 (Zi,Zr) to...
.18 .  .21.22.0.20.28   Zr -> AR
.22 .  .23.24.0.28.22   AR -> P1r
.24 .  .25.26.0.28.22   AR -> P2r

.26 .  .28.29.0.20.28   Zi -> AR
.29 .  .30.31.0.28.22   AR -> P1i
.31 .  .32.35.0.28.22   AR -> P2i

.35 .  .40.40.1.20.31   "goto" 01.40 (complex multcily)

                        Add position to Z^2
rt:
                        Zr = Zr + Cr
.40 .  .41.42.1.23.28   Cr -> AR
.42 .  .45.46.1.20.29   AR += 20.01 (ResultR / Zr)
.46 .  .49.50.1.28.20   AR -> 20.01

                        Zi = Zi + Ci
.50 .  .52.53.1.23.28   Ci -> AR
.53 .  .56.57.1.20.29   AR += 20.00 (ResultI / Zi)
.57 .  .60.61.1.28.20   AR -> 20.00

                        if |Zi| > 2 goto ot
.61 .  .64.65.2.20.28   |Zi| -> AR
.65 .  .66.67.3.02.29   Subtract two
.66   +051yv85          Two shifted
.67 .  .69.70.1.22.31   Test AR sign
.70 .  .71.96.0.00.00   if AR >= 0 goto ot
                        else continue on

                        if |Zr| > 2 goto ot
.71 .  .73.74.2.20.28   |Zr| -> AR
.74 .  .75.76.3.02.29   Subtract two
.75   +051yv85          Two shifted
.76 .  .78.79.1.22.31   Test AR sign
.79 .  .80.96.0.00.00   if AR >= 0 goto ot
                        else continue on

                        ct = ct + 1
.80 .  .82.83.1.23.28   ct -> AR
.83 .  .84.85.1.02.29   AR += 1
.84   +0000001          
.85 .  .86.87.1.28.23   AR -> ct

                        if ct > limit goto in
.87 .  .88.89.3.02.29   Subtract limit
.88   +0000011           Limit 12
.89 .  .91.92.1.22.31   Test AR sign
.92 .  .93.94.0.00.00   if AR >= 0 goto in
.93 .  .94.18.0.00.00   else loop


in:                     Point is IN
.94 .  .95.17.0.02.28   Eights -> AR; GOTO tp
.95   +0000000          

ot:                     Point is OUT
.96 .  .98.99.6.23.25 - Ct -> ID1
.99 .  .10.14.1.26.31   Shift R 4
.14 .  .16.17.0.25.28   ID0 -> AR

tp:
.17 .  .19.18.0.20.31   RETURN

<BLOCK>

# Bendix subroutine - Complex Multiplication
# Prepared by: D. Stein, S. H. Lewis #1205
# Date: 3-13-1957
# Line: 01
# Multiplication
#   Calculates:
#       (x + yi) = (a + bi) * (c + di)
#   Entry:  40
#   Exit:   38
#   Input:
#      10^-2d -> 22.00
#      10^-2c -> 22.01
#      10^-2b -> 22.02
#      10^-2a -> 22.03
#      Return Command
#           Normal 21.02
#           Overflow 21.03
#   Output:
#      10^-2y -> 20.00
#      10^-2x -> 20.01
#
# https://rbk.delosent.com/allq/Q5531.pdf Page 53
# Dave Green archive: David-Green-Files\kimpel\1205A.G15
# Corrections to the bendix publications are noted in
# comments, these were in the David Green Files
#
# Multiplication seems to work
# Division untested.
#
# Transcribed: Bill Kuker 3/13/2025
#
# 
.40 .  .42.44.6.22.25   ID(1):=22.02  =(10^-2)b
.44 . u.46.47.0.22.24   MQ(1):=22.01  =(10^-2)c
.47 .  .56.u4.0.24.31   PN = (10^-4)bc
.u4 .  .u6.02.4.26.20   20.02.03:=PN(0.1)
.02 .  .04.06.6.22.25   ID(1):=22.00  =(10^-2)d
.06 . u.08.09.0.22.24   MQ(1):=22.03  =(10^-2)a
.09 .  .56.66.0.24.31   PN = (10^-4)ad
.66 .  .68.70.4.26.21   21.00.01:=PN(0.1)
.70 .  .72.76.5.21.26   PN(0.1):=21.00.01
.76 .  .78.80.5.20.30   PN:=PN+20.02.03  =(10^-4)(ad+bc)
.80 .  .82.84.5.26.20   20.02.03:=PN(0.1)
.84 .  .86.88.4.20.25   ID(0.1):=20.02.03
.88 . u.90.91.0.01.24   MQ(1):=01.89  =10^2(2^-7)
.89   +w800000              10^2(2^-7)
.91 .  .10.01.0.24.31   PN:=(10^-2)(2^-7)(ad+bc)

# Typo?
# From Scan:
#01 .  .16.18.?.??.??   2^?? *? |PN| -> PN0,1+
# From David Green:
.01 . u.16.18.6.26.30   PN:=(10^-2)(ad+bc)


.18 . u.21.22.2.26.20   20.00:=PN(1)  =(10^-2)y
.22 .  .24.26.0.23.31   clear (even)
.26 . u.28.28.0.22.25   ID(1):=22.03  =(10^-2)a
.28 . u.30.31.0.22.24   MQ(1):=22.01  =(10^-2)c
.31 .  .56.92.0.24.31   =(10^-4)ac
.92 .  .94.96.4.26.20   20.02.03:=PN(0.1)
.96 .  .98.u0.6.22.25   ID(1):=22.02  =(10^-2)b
.u0 .  .u4.05.6.22.24   MQ(1):=22.00  =(10^-2)d
.05 .  .56.62.0.24.31   =(10^-4)bd

# Typo?
#From Scan:
#62 .  .66.68.0.2?.2?   10^-4bd * (PN0,1) -> 21.00,01
# From David Green:
.62 .  .64.68.4.26.21   21.00.01:=PN(0.1)

.68 .  .70.74.5.20.26   PN(0.1):=20.02.03
.74 .  .76.78.7.21.30   PN:=PN-21.00.01
.78 .  .80.82.5.26.21   21.00.01:=PN(0.1)
.82 .  .84.86.4.21.25   ID(0.1):=21.00.01
.86 .  .89.93.0.01.24   MQ(1):=01.89  =10^2(2^-7)
.93 .  .10.03.0.24.31   

# Typo?
#From Scan - Very clear
#.03 .  .18.20.6.26.30
#From David Green
.03 . u.18.20.6.26.30   

.20 . u.22.24.0.26.20   20.01:=PN(1)  =(10^-2)x
.24 .  .26.33.0.29.31   overflow?
.33 . u.35.36.0.21.28   no:  AR:=21.02
.34 . u.36.36.0.21.28   yes: AR:=21.03
.36 .  .38.38.0.31.31   execute AR (exit)

# Complex Division 
.35 .  .38.38.0.23.31   clear
.38 .  .40.41.2.22.28   AR:=21.00  =(10^-2)abs(d)
.41 . u.43.43.0.28.20   20.02:=AR
.43 .  .45.48.2.22.28   AR:=22.01  =(10^-2)abs(c)
.48 .  .50.51.3.20.29   AR:=AR-20.02  =abs(c)-abs(d)
.51 .  .53.54.0.22.31   is AR negative?
.54 .  .57.83.0.22.25   +ve: (c>=d) ID(1):=22.01  =(10^-2)c
.55 . u.61.63.2.22.22   -ve: (c<d)  22.01-00:=22.00-03
.63 . u.65.65.3.22.28   AR:=-22.00
.65 . u.67.69.3.22.30   PN(0):=22.02
.69 . u.71.72.1.28.22   22.02:=AR
.72 .  .76.77.1.26.22   22.00:=PN(0)
.77 .  .81.83.0.22.25   ID(1):=22.01
.83 .  .84.87.6.22.26   PN(1):=22.00 tva
.87 .  .56.39.5.25.31   divide
.39 . u.41.45.0.24.21   21.00:=MQ(0)
.45 .  .48.50.6.21.25   ID(1):=21.00 tva
.50 .  .52.61.6.22.24   MQ(1):=22.00 tva
.61 .  .56.10.0.24.31   multiply
.10 .  .12.16.4.26.20   20.00.01:=PN(0.1)
.16 .  .19.19.0.23.31   clear
.19 .  .21.23.0.22.25   ID(1):=22.01
.23 .  .02.29.0.26.31   shift 1 bit
.29 .  .32.37.4.25.20   20.02.03:=ID(0.1)
.37 . u.42.42.5.20.30   PN(0.1):=20.00.01+20.02.03
.42 .  .44.46.5.26.22   22.00.01:=PN(0.1)  =denominator
.46 .  .48.52.6.21.25   ID(1):=21.00 tva
.52 .  .54.57.6.22.24   MQ(1):=22.02 tva
.57 .  .56.07.0.24.31   multiply
.07 .  .10.11.4.26.20   20.00.01:=PN(0.1)
.11 .  .14.14.0.23.31   clear
.14 . u.16.17.0.22.25   ID(1):=22.03
.17 .  .02.21.0.26.31   shift
.21 . u.24.25.4.25.20   20.02.03:=ID(0.1)
.25 . u.30.32.5.20.30   PN(0.1):=20.02.03+20.00.01
.32 .  .34.49.5.26.20   20.02.03:=PN(0.1)
.49 .  .52.58.4.20.25   ID(0.1):=20.02.03
.58 .  .81.99.1.01.24   MQ(1):=01.88  =10^-2
.81   -zx70u3y          
.99 .  .58.53.0.24.31   multiply
.53 . u.56.56.4.26.20   20.02.03:=PN(0.1)
.56 .  .60.64.4.22.25   ID(0.1):=22.00.01  =denominator
.64 .  .66.15.4.20.26   PN(0.1):=20.02.03
.15 .  .58.90.5.25.31   divide
.90 .  .92.94.1.24.27   test for zero
.94 .  .96.98.6.24.20   yes: 20.01:=MQ(0) tva
.95 .  .99.36.0.21.28   no:  21.03:=AR  (command)
.98 .  .u0.00.6.21.25   ID(1):=21.00 tva
.00 .  .03.13.0.22.24   MQ(1):=22.03
.13 .  .56.79.0.24.31   multiply
.79 .  .82.85.4.26.20   20.02.03:=PN(0.1)
.85 .  .88.97.6.22.25   ID(1):=22.02 tva
.97 .  .02.u1.0.26.31   shift 6 bits
.u1 . u.u4.04.4.25.22   22.02.03:=ID(0.1)
.04 .  .06.08.5.22.26   PN(0.1):=22.02.03
.08 .  .10.12.7.20.30   PN(0.1):=PN-20.02.03
.12 .  .16.59.5.26.21   21.00.01:=PN(0.1)
.59 .  .60.73.4.21.25   ID(0.1):=21.00.01
.73 .  .81.u3.1.01.24   MQ(1):=01.81  =10^-2
.u3 .  .58.60.0.24.31   multiply
.60 .  .64.67.4.26.21   21.00.01:=PN(0.1)
.67 . u.70.71.4.22.25   ID(0.1):=22.00.01  =denominator
.71 . u.74.75.4.21.26   PN(0.1):=21.00.01  =no
.75 .  .58.27.5.25.31   divide
.27 . u.29.30.0.24.20   20.00:=MQ(0)  =(10^-2)y
.30 .  .32.33.1.24.27   MQ(1) zero?

<BLOCK>
#define ILOW d-0.0110
#define IHIGH d0.0110
#define ISTEP d0.0040

#define RLOW d-0.021
#define RHIGH d0.0052
#define RSTEP d0.0016

                        Reset Imaginary Position
.00 .  .01.02.1.00.28   Imaginary Start -> AR
.01   -02x0y56              
.02 .  .00.03.1.28.23   AR -> Ci

nl:                     Loop start for a new line

                        Print a newline
.03 .  .04.05.1.00.28   AR = Format Newline
.04   +4400000          F3 Format code, 0 digit, CR end
.05 .  .03.06.1.28.03   03:03 = AR
.06 .  .08.07.0.08.31   Output AR to typewriter
.07 .  .07.07.0.28.31   Wait for IOReady

                        Set up single digit format code
.08 .  .09.10.1.00.28   AR = Format Digit
.09   +0400000          Format code, 1 digit, end
.10 .  .03.11.1.28.03   03:03 = AR

                        ci = ci + d0.0040
.11 .  .00.12.1.23.28   Ci -> AR
.12 .  .13.14.1.00.29   AR += Step
is:
.13   +010624y            Imaginary Step
.14 .  .00.15.1.28.23   AR -> Ci

                        if ci > d0.0110 then HALT
.15 .  .00.16.1.23.28   Ci -> AR
.16 .  .17.18.3.00.29   Subtract end point
.17   +02x0y56            
.18 .  .20.19.1.22.31   Test AR sign
.19 .  .21.48.0.16.31   if AR >= 0 HALT
                        else continue on

                        Reset Real Position
.20 .  .21.22.1.00.28   Real Start -> AR
.21   -0560419             
.22 .  .01.23.1.28.23   AR -> Cr

nc:                     Next Character loop start
                        
                        Cr = Cr + d0.0016
.23 .  .25.26.1.23.28   Cr -> AR
.26 .  .27.28.1.00.29   AR += Step
rs:
.27   +0068xv9            
.28 .  .29.30.1.28.23   AR -> Cr


###CALL FRACTAL CODE
.30 . w.31.00.2.21.31   GOSUB 2.0 Line 2 instruction zero

#.%2 .  .L1.L2.0.00.28   AR = ones
#.   +1111111            F3 Format code, 0 digit, CR end

tp:                     Print out value in AR
.31 .  .33.34.0.08.31   Output AR to typewriter
.34 .  .34.34.0.28.31   Wait for IOReady

                        If Cr > d0.0052
                            goto nl - Next Line
                        else
                            goto nc - Next Character
.35 .  .37.38.1.23.28   Cr -> AR
.38 .  .39.40.3.00.29   Subtract end point
.39   +0154w98            
.40 .  .42.43.1.22.31   Test AR sign
.43 .  .44.03.0.00.00   if AR >= 0 goto nl
.44 .  .45.23.0.00.00   else goto nc

bg:                     MAKE IT BIGGER  
.48 .  .13.49.0.00.25   is -> ID
.49 .  .02.50.1.26.31   Shift ID 1 bit right
.50 .  .13.52.0.25.00   ID -> is

.52 .  .27.53.0.00.25   is -> ir
.53 .  .02.54.1.26.31   Shift ID 1 bit right
.54 .  .27.00.0.25.00   ID -> ir
