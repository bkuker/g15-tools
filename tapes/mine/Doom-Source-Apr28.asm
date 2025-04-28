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
# <INCLUDE src="bbl.asm">
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
.24   +0000012          Load 18 blocks

#Line 19 is used for loading

#Line 18 is used as silence!

<BLOCK>
.00   +6x4968u          
.01   +09wy5y4          
.02   -40uz662          
.03   -72u9456          
.04   -9621ywx          
.05   -xz6z5z3          
.06   +y4280vx          
.07   +323213u          
.08   +58z1842          
.09   -zx17356          
.10   +uw5706u          
.11   -x94vu9w          
.12   -4zwwx44          
.13   +5u57411          
.14   -zz02192          
.15   -w33762v          
.16   -903z930          
.17   +64uz933          
.18   +49178zu          
.19   -7u0u6wx          
.20   -06153v1          
.21   +04y6012          
.22   +2x41215          
.23   -x86115x          
.24   +247z02w          
.25   -yz2u0v5          
.26   +w370391          
.27   +5zz1w0u          
.28   -0464wy1          
.29   +zv49966          
.30   +w72601v          
.31   +x1z33u4          
.32   +00u4755          
.33   -36x59xu          
.34   +u598yu2          
.35   +6807255          
.36   -v8wyx8y          
.37   -0yxzz6x          
.38   -u996uz2          
.39   -8v726y4          
.40   +4z84z51          
.41   +x3u0000          
.42   +0000000          
.43   +0000000          
.44   +0000000          
.45   +0000000          
.46   +0000000          
.47   +0000000          
.48   +0000000          
.49   +0000000          
.50   +0000000          
.51   +0000000          
.52   +0000000          
.53   +0000000          
.54   +0000000          
.55   +0000000          
.56   +0000000          
.57   +0000000          
.58   +0000000          
.59   +0000000          
.60   +0000000          
.61   +0000000          
.62   +0000000          
.63   +0000000          
.64   +0000000          
.65   +0000000          
.66   +0000000          
.67   +0000000          
.68   +0000000          
.69   +0000000          
.70   +0000000          
.71   +0000000          
.72   +0000000          
.73   +0000000          
.74   +0000000          
.75   +0000000          
.76   +0000000          
.77   +0000000          
.78   +0000000          
.79   +0000000          
.80   +0000000          
.81   +0000000          
.82   -000003u          
.83   -yw14x26          
.84   -ywu8360          
.85   -w826u46          
.86   -3u6yzxv          
.87   -8310u41          
.88   -7z82x43          
.89   -xv6789v          
.90   +1581114          
.91   -v6w0z0u          
.92   -703z431          
.93   +7zyzxvw          
.94   +4y84v3z          
.95   -02v1v74          
.96   -02uxv12          
.97   -7v1x0v8          
.98   +078uw23          
.99   +27w2zx9          
.u0   +7176u3x          
.u1   -w3z06x5          
.u2   +u2xwvuv          
.u3   -1521uz1          
.u4   +735uz5y          
.u5   +z6vzu95          
.u6   +wwu7w46          

<BLOCK>

#A2 / A3
.01   +zzzzzzz          
.02   +zzzzzzz          
.03   +zzzzzzz          
.04   +zzzzzzz          
.05   +zzzzzzz          
.06   +zzzzzzz          
.07   +zzzzzzz          
.08   -zzzzzzz          
.09   -zzzzzzz          
.10   -zzzzzzz          
.11   -zzzzzzz          
.12   -zzzzzzz          
.13   -zzzzzzz          
.14   -zzzzzzz          
.15   -zzzzz00          
.16   -0000001          
.17   -0000001          
.18   -0000001          
.19   -0000001          
.20   -0000001          
.21   -0000001          
.22   -0000001          
.23   -0000001          
.24   +0000000          
.25   +0000000          
.26   +0000000          
.27   +0000000          
.28   +0000000          
.29   +0000000          
.30   +0000000          
.31   +003zzzz          
.32   +zzzzzzz          
.33   +zzzzzzz          
.34   +zzzzzzz          
.35   +zzzzzzz          
.36   +zzzzzzz          
.37   +zzzzzzz          
.38   +zzzzzzz          
.39   -zzzzzzz          
.40   -zzzzzzz          
.41   -zzzzzzz          
.42   -zzzzzzz          
.43   -zzzzzzz          
.44   -zzzzzzz          
.45   -zzzzzzz          
.46   -zzzzzzz          
.47   -8000000          
.48   -0000001          
.49   -0000001          
.50   -0000001          
.51   -0000001          
.52   -0000001          
.53   -0000001          
.54   -0000001          
.55   +0000000          
.56   +0000000          
.57   +0000000          
.58   +0000000          
.59   +0000000          
.60   +0000000          
.61   +0000000          
.62   +00000zz          
.63   +zzzzzzz          
.64   +zzzzzzz          
.65   +zzzzzzz          
.66   +zzzzzzz          
.67   +zzzzzzz          
.68   +zzzzzzz          
.69   +zzzzzzz          
.70   +zzzzzzz          
.71   -zzzzzzz          
.72   -zzzzzzz          
.73   -zzzzzzz          
.74   -zzzzzzz          
.75   -zzzzzzz          
.76   -zzzzzzz          
.77   -zzzzzzz          
.78   -zzy0000          
.79   -0000001          
.80   -0000001          
.81   -0000001          
.82   -0000001          
.83   -0000001          
.84   -0000001          
.85   -0000001          
.86   +0000000          
.87   +0000000          
.88   +0000000          
.89   +0000000          
.90   +0000000          
.91   +0000000          
.92   +0000000          
.93   +0000000          
.94   +7zzzzzz          
.95   +zzzzzzz          
.96   +zzzzzzz          
.97   +zzzzzzz          
.98   +zzzzzzz          
.99   +zzzzzzz          
.u0   +zzzzzzz          
.u1   +zzzzzzz          
.u2   -zzzzzzz          
.u3   -zzzzzzz          
.u4   -zzzzzzz          
.u5   -zzzzzzz          
.u6   -zzzzzzz          
.u7   -zzzzzzz          


<BLOCK>

#A#2 / A4
.01   +zzzzzzz          
.02   +zzzzzzz          
.03   +zzzzzzz          
.04   -zzzzzzz          
.05   -zzzzzzz          
.06   -zzzzzzz          
.07   -zzzzzzz          
.08   +zzzzzzz          
.09   +zzzzzzz          
.10   +zzzzzzz          
.11   +zzzzzzz          
.12   -zzzzzzz          
.13   -zzzzzzz          
.14   -zzzzzy0          
.15   +0000000          
.16   -0000001          
.17   -0000001          
.18   -0000001          
.19   -0000001          
.20   +0000000          
.21   +0000000          
.22   +0000000          
.23   +0000000          
.24   -0000001          
.25   -0000001          
.26   -0000001          
.27   +0000000          
.28   +0000000          
.29   +00007zz          
.30   -zzzzzzz          
.31   +zzzzzzz          
.32   +zzzzzzz          
.33   +zzzzzzz          
.34   +zzzzzzz          
.35   -zzzzzzz          
.36   -zzzzzzz          
.37   -zzzzzzz          
.38   -zzzzzzz          
.39   +zzzzzzz          
.40   +zzzzzzz          
.41   +zzzzzzz          
.42   +zzzzzzz          
.43   -zzzzzzz          
.44   +zzy0000          
.45   +0000000          
.46   +0000000          
.47   -0000001          
.48   -0000001          
.49   -0000001          
.50   -0000001          
.51   +0000000          
.52   +0000000          
.53   +0000000          
.54   +0000000          
.55   -0000001          
.56   -0000001          
.57   -0000001          
.58   -0000001          
.59   -07zzzzz          
.60   -zzzzzzz          
.61   -zzzzzzz          
.62   -zzzzzzz          
.63   +zzzzzzz          
.64   +zzzzzzz          
.65   +zzzzzzz          
.66   +zzzzzzz          
.67   -zzzzzzz          
.68   -zzzzzzz          
.69   -zzzzzzz          
.70   +zzzzzzz          
.71   +zzzzzzz          
.72   +zzzzzzz          
.73   +zzzzzzz          
.74   +0000000          
.75   +0000000          
.76   +0000000          
.77   +0000000          
.78   -0000001          
.79   -0000001          
.80   -0000001          
.81   -0000001          
.82   +0000000          
.83   +0000000          
.84   +0000000          
.85   +0000000          
.86   -0000001          
.87   -0000001          
.88   -000003z          
.89   +zzzzzzz          
.90   -zzzzzzz          
.91   -zzzzzzz          
.92   -zzzzzzz          
.93   -zzzzzzz          
.94   +zzzzzzz          
.95   +zzzzzzz          
.96   +zzzzzzz          
.97   +zzzzzzz          
.98   -zzzzzzz          
.99   -zzzzzzz          
.u0   -zzzzzzz          
.u1   -zzzzzzz          
.u2   +zzzzzzz          
.u3   +zzzz000          
.u4   -0000001          
.u5   -0000001          
.u6   +0000000          
.u7   +0000000          


<BLOCK>

#B2 / B3
.01   +zzzzzzz          
.02   +zzzzzzz          
.03   +zzzzzzz          
.04   +zzzzzzz          
.05   +zzzzzzz          
.06   +zzzzzzz          
.07   -zzzzzzz          
.08   -zzzzzzz          
.09   -zzzzzzz          
.10   -zzzzzzz          
.11   -zzzzzzz          
.12   -zzzzzzz          
.13   -zzzzzzz          
.14   -0000001          
.15   -0000001          
.16   -0000001          
.17   -0000001          
.18   -0000001          
.19   -0000001          
.20   -0000001          
.21   +0000000          
.22   +0000000          
.23   +0000000          
.24   +0000000          
.25   +0000000          
.26   +0000000          
.27   +0000001          
.28   +zzzzzzz          
.29   +zzzzzzz          
.30   +zzzzzzz          
.31   +zzzzzzz          
.32   +zzzzzzz          
.33   +zzzzzzz          
.34   +zzzzzzz          
.35   -zzzzzzz          
.36   -zzzzzzz          
.37   -zzzzzzz          
.38   -zzzzzzz          
.39   -zzzzzzz          
.40   -zzzzzzz          
.41   -zzzzzzw          
.42   -0000001          
.43   -0000001          
.44   -0000001          
.45   -0000001          
.46   -0000001          
.47   -0000001          
.48   -0000001          
.49   +0000000          
.50   +0000000          
.51   +0000000          
.52   +0000000          
.53   +0000000          
.54   +0000000          
.55   +0000007          
.56   +zzzzzzz          
.57   +zzzzzzz          
.58   +zzzzzzz          
.59   +zzzzzzz          
.60   +zzzzzzz          
.61   +zzzzzzz          
.62   +zzzzzzz          
.63   -zzzzzzz          
.64   -zzzzzzz          
.65   -zzzzzzz          
.66   -zzzzzzz          
.67   -zzzzzzz          
.68   -zzzzzzz          
.69   -zzzzzz0          
.70   -0000001          
.71   -0000001          
.72   -0000001          
.73   -0000001          
.74   -0000001          
.75   -0000001          
.76   -0000001          
.77   +0000000          
.78   +0000000          
.79   +0000000          
.80   +0000000          
.81   +0000000          
.82   +0000000          
.83   +000001z          
.84   +zzzzzzz          
.85   +zzzzzzz          
.86   +zzzzzzz          
.87   +zzzzzzz          
.88   +zzzzzzz          
.89   +zzzzzzz          
.90   +zzzzzzz          
.91   -zzzzzzz          
.92   -zzzzzzz          
.93   -zzzzzzz          
.94   -zzzzzzz          
.95   -zzzzzzz          
.96   -zzzzzzz          
.97   -zzzzzw0          
.98   -0000001          
.99   -0000001          
.u0   -0000001          
.u1   -0000001          
.u2   -0000001          
.u3   -0000001          
.u4   -0000001          
.u5   +0000000          
.u6   +0000000          
.u7   +0000000          


<BLOCK>

#B4 / B5
.01   +zzzzzzz          
.02   -zzzzzzz          
.03   -zzzw000          
.04   -0000001          
.05   +0000000          
.06   +0000000          
.07   +zzzzzzz          
.08   +zzzzzzz          
.09   -zzzzzzz          
.10   -zzz8000          
.11   -0000001          
.12   +0000000          
.13   +0000001          
.14   +zzzzzzz          
.15   +zzzzzzz          
.16   -zzzzzzz          
.17   -zzz0000          
.18   -0000001          
.19   +0000000          
.20   +0000003          
.21   +zzzzzzz          
.22   +zzzzzzz          
.23   -zzzzzzz          
.24   -zzy0000          
.25   -0000001          
.26   +0000000          
.27   +0000007          
.28   +zzzzzzz          
.29   +zzzzzzz          
.30   -zzzzzzz          
.31   -zzw0000          
.32   -0000001          
.33   +0000000          
.34   +000000z          
.35   +zzzzzzz          
.36   +zzzzzzz          
.37   -zzzzzzz          
.38   -zz80000          
.39   -0000001          
.40   +0000000          
.41   +000001z          
.42   +zzzzzzz          
.43   +zzzzzzz          
.44   -zzzzzzz          
.45   -zz00000          
.46   -0000001          
.47   +0000000          
.48   +000003z          
.49   +zzzzzzz          
.50   +zzzzzzz          
.51   -zzzzzzz          
.52   -zy00000          
.53   -0000001          
.54   +0000000          
.55   +000007z          
.56   +zzzzzzz          
.57   +zzzzzzz          
.58   -zzzzzzz          
.59   -zw00000          
.60   -0000001          
.61   +0000000          
.62   +00000zz          
.63   +zzzzzzz          
.64   -zzzzzzz          
.65   -zzzzzzz          
.66   -z800000          
.67   -0000001          
.68   +0000000          
.69   +00001zz          
.70   +zzzzzzz          
.71   -zzzzzzz          
.72   -zzzzzzz          
.73   -z000000          
.74   -0000001          
.75   +0000000          
.76   +00003zz          
.77   +zzzzzzz          
.78   -zzzzzzz          
.79   -zzzzzzz          
.80   -y000000          
.81   -0000001          
.82   +0000000          
.83   +00007zz          
.84   +zzzzzzz          
.85   -zzzzzzz          
.86   -zzzzzzz          
.87   -w000000          
.88   -0000001          
.89   +0000000          
.90   +0000zzz          
.91   +zzzzzzz          
.92   -zzzzzzz          
.93   -zzzzzzz          
.94   -8000000          
.95   -0000001          
.96   +0000000          
.97   +0001zzz          
.98   +zzzzzzz          
.99   -zzzzzzz          
.u0   -zzzzzzz          
.u1   -0000001          
.u2   -0000001          
.u3   +0000000          
.u4   +0003zzz          
.u5   +zzzzzzz          
.u6   -zzzzzzz          
.u7   -zzzzzzz          


<BLOCK>

#C3 / C4
.01   +zzzzzzz          
.02   +zzzzzzz          
.03   +zzzzzzz          
.04   +zzzzzzz          
.05   +zzzzzzz          
.06   +zzzzzzz          
.07   -zzzzzzz          
.08   -zzzzzzz          
.09   -zzzzzzz          
.10   -zzzzzzz          
.11   -zzzzzzz          
.12   -zzzzzzz          
.13   -z800000          
.14   -0000001          
.15   -0000001          
.16   -0000001          
.17   -0000001          
.18   -0000001          
.19   -0000001          
.20   +0000000          
.21   +0000000          
.22   +0000000          
.23   +0000000          
.24   +0000000          
.25   +0000000          
.26   +003zzzz          
.27   +zzzzzzz          
.28   +zzzzzzz          
.29   +zzzzzzz          
.30   +zzzzzzz          
.31   +zzzzzzz          
.32   +zzzzzzz          
.33   -zzzzzzz          
.34   -zzzzzzz          
.35   -zzzzzzz          
.36   -zzzzzzz          
.37   -zzzzzzz          
.38   -zzzzzzz          
.39   -zzzy000          
.40   -0000001          
.41   -0000001          
.42   -0000001          
.43   -0000001          
.44   -0000001          
.45   -0000001          
.46   +0000000          
.47   +0000000          
.48   +0000000          
.49   +0000000          
.50   +0000000          
.51   +0000000          
.52   +00000zz          
.53   +zzzzzzz          
.54   +zzzzzzz          
.55   +zzzzzzz          
.56   +zzzzzzz          
.57   +zzzzzzz          
.58   +zzzzzzz          
.59   -zzzzzzz          
.60   -zzzzzzz          
.61   -zzzzzzz          
.62   -zzzzzzz          
.63   -zzzzzzz          
.64   -zzzzzzz          
.65   -zzzzzz8          
.66   -0000001          
.67   -0000001          
.68   -0000001          
.69   -0000001          
.70   -0000001          
.71   -0000001          
.72   +0000000          
.73   +0000000          
.74   +0000000          
.75   +0000000          
.76   +0000000          
.77   +0000000          
.78   +0000000          
.79   +7zzzzzz          
.80   +zzzzzzz          
.81   +zzzzzzz          
.82   +zzzzzzz          
.83   +zzzzzzz          
.84   +zzzzzzz          
.85   +zzzzzzz          
.86   -zzzzzzz          
.87   -zzzzzzz          
.88   -zzzzzzz          
.89   -zzzzzzz          
.90   -zzzzzzz          
.91   -zzzzzzz          
.92   -zw00000          
.93   -0000001          
.94   -0000001          
.95   -0000001          
.96   -0000001          
.97   -0000001          
.98   -0000001          
.99   +0000000          
.u0   +0000000          
.u1   +0000000          
.u2   +0000000          
.u3   +0000000          
.u4   +0000000          
.u5   +001zzzz          
.u6   +zzzzzzz          
.u7   +zzzzzzz          


<BLOCK>

#F#4 / C5
.01   +zzzzzzz          
.02   +zzzzzzz          
.03   -zzzzzzz          
.04   -zzzzy00          
.05   +0000000          
.06   +0000000          
.07   -0000001          
.08   -0000001          
.09   +007zzzz          
.10   -zzzzzzz          
.11   -zzzzzzz          
.12   -zzzzzzz          
.13   +zzzzzzz          
.14   -0000001          
.15   -0000001          
.16   -0000001          
.17   +0000000          
.18   +00003zz          
.19   -zzzzzzz          
.20   +zzzzzzz          
.21   +zzzzzzz          
.22   +zzzzzzz          
.23   +zz00000          
.24   +0000000          
.25   +0000000          
.26   -0000001          
.27   -0000001          
.28   +zzzzzzz          
.29   +zzzzzzz          
.30   -zzzzzzz          
.31   -zzzzzzz          
.32   -zzzz800          
.33   -0000001          
.34   -0000001          
.35   -0000001          
.36   +0000000          
.37   -01zzzzz          
.38   -zzzzzzz          
.39   -zzzzzzz          
.40   +zzzzzzz          
.41   +zzzzzzw          
.42   -0000001          
.43   +0000000          
.44   +0000000          
.45   +0000000          
.46   +0000zzz          
.47   +zzzzzzz          
.48   +zzzzzzz          
.49   -zzzzzzz          
.50   -zzzzzzz          
.51   +zw00000          
.52   +0000000          
.53   -0000001          
.54   -0000001          
.55   -0000007          
.56   -zzzzzzz          
.57   -zzzzzzz          
.58   -zzzzzzz          
.59   +zzzzzzz          
.60   +zzzy000          
.61   -0000001          
.62   -0000001          
.63   +0000000          
.64   +0000000          
.65   -07zzzzz          
.66   +zzzzzzz          
.67   +zzzzzzz          
.68   +zzzzzzz          
.69   -zzzzzz0          
.70   +0000000          
.71   +0000000          
.72   -0000001          
.73   -0000001          
.74   -0003zzz          
.75   +zzzzzzz          
.76   -zzzzzzz          
.77   -zzzzzzz          
.78   -zzzzzzz          
.79   -z000000          
.80   -0000001          
.81   -0000001          
.82   +0000000          
.83   +000001z          
.84   -zzzzzzz          
.85   -zzzzzzz          
.86   +zzzzzzz          
.87   +zzzzzzz          
.88   -zzz8000          
.89   +0000000          
.90   +0000000          
.91   +0000000          
.92   -0000001          
.93   +1zzzzzz          
.94   +zzzzzzz          
.95   +zzzzzzz          
.96   -zzzzzzz          
.97   -zzzzzw0          
.98   +0000000          
.99   -0000001          
.u0   -0000001          
.u1   -0000001          
.u2   -000zzzz          
.u3   -zzzzzzz          
.u4   -zzzzzzz          
.u5   +zzzzzzz          
.u6   +zzzzzzz          
.u7   -w000000          


<BLOCK>

#D#3 / D#4
.01   +zzzzzzz          
.02   +zzzzzzz          
.03   +zzzzzzz          
.04   +zzzzzzz          
.05   +zzzzzzz          
.06   -zzzzzzz          
.07   -zzzzzzz          
.08   -zzzzzzz          
.09   -zzzzzzz          
.10   -zzzzzzz          
.11   -y000000          
.12   -0000001          
.13   -0000001          
.14   -0000001          
.15   -0000001          
.16   -0000001          
.17   +0000000          
.18   +0000000          
.19   +0000000          
.20   +0000000          
.21   +0000000          
.22   +07zzzzz          
.23   +zzzzzzz          
.24   +zzzzzzz          
.25   +zzzzzzz          
.26   +zzzzzzz          
.27   +zzzzzzz          
.28   -zzzzzzz          
.29   -zzzzzzz          
.30   -zzzzzzz          
.31   -zzzzzzz          
.32   -zzzzzzz          
.33   -zz00000          
.34   -0000001          
.35   -0000001          
.36   -0000001          
.37   -0000001          
.38   -0000001          
.39   +0000000          
.40   +0000000          
.41   +0000000          
.42   +0000000          
.43   +0000000          
.44   +003zzzz          
.45   +zzzzzzz          
.46   +zzzzzzz          
.47   +zzzzzzz          
.48   +zzzzzzz          
.49   +zzzzzzz          
.50   -zzzzzzz          
.51   -zzzzzzz          
.52   -zzzzzzz          
.53   -zzzzzzz          
.54   -zzzzzzz          
.55   -zzz8000          
.56   -0000001          
.57   -0000001          
.58   -0000001          
.59   -0000001          
.60   -0000001          
.61   +0000000          
.62   +0000000          
.63   +0000000          
.64   +0000000          
.65   +0000000          
.66   +0001zzz          
.67   +zzzzzzz          
.68   +zzzzzzz          
.69   +zzzzzzz          
.70   +zzzzzzz          
.71   +zzzzzzz          
.72   -zzzzzzz          
.73   -zzzzzzz          
.74   -zzzzzzz          
.75   -zzzzzzz          
.76   -zzzzzzz          
.77   -zzzzw00          
.78   -0000001          
.79   -0000001          
.80   -0000001          
.81   -0000001          
.82   -0000001          
.83   +0000000          
.84   +0000000          
.85   +0000000          
.86   +0000000          
.87   +0000000          
.88   +00000zz          
.89   +zzzzzzz          
.90   +zzzzzzz          
.91   +zzzzzzz          
.92   +zzzzzzz          
.93   +zzzzzzz          
.94   -zzzzzzz          
.95   -zzzzzzz          
.96   -zzzzzzz          
.97   -zzzzzzz          
.98   -zzzzzzz          
.99   -zzzzzy0          
.u0   -0000001          
.u1   -0000001          
.u2   -0000001          
.u3   -0000001          
.u4   -0000001          
.u5   +0000000          
.u6   +0000000          
.u7   +0000000          


<BLOCK>

#D3 / D4
.01   +zzzzzzz          
.02   +zzzzzzz          
.03   +zzzzzzz          
.04   +zzzzzzz          
.05   +zzzzzzz          
.06   -zzzzzzz          
.07   -zzzzzzz          
.08   -zzzzzzz          
.09   -zzzzzzz          
.10   -zzzzzzz          
.11   -zzzzzw0          
.12   -0000001          
.13   -0000001          
.14   -0000001          
.15   -0000001          
.16   -0000001          
.17   -0000001          
.18   +0000000          
.19   +0000000          
.20   +0000000          
.21   +0000000          
.22   +0000000          
.23   +0003zzz          
.24   +zzzzzzz          
.25   +zzzzzzz          
.26   +zzzzzzz          
.27   +zzzzzzz          
.28   +zzzzzzz          
.29   -zzzzzzz          
.30   -zzzzzzz          
.31   -zzzzzzz          
.32   -zzzzzzz          
.33   -zzzzzzz          
.34   -zzzzzzz          
.35   -zy00000          
.36   -0000001          
.37   -0000001          
.38   -0000001          
.39   -0000001          
.40   -0000001          
.41   +0000000          
.42   +0000000          
.43   +0000000          
.44   +0000000          
.45   +0000000          
.46   +0000000          
.47   +zzzzzzz          
.48   +zzzzzzz          
.49   +zzzzzzz          
.50   +zzzzzzz          
.51   +zzzzzzz          
.52   +zzzzzzz          
.53   -zzzzzzz          
.54   -zzzzzzz          
.55   -zzzzzzz          
.56   -zzzzzzz          
.57   -zzzzzzz          
.58   -zzzzz80          
.59   -0000001          
.60   -0000001          
.61   -0000001          
.62   -0000001          
.63   -0000001          
.64   -0000001          
.65   +0000000          
.66   +0000000          
.67   +0000000          
.68   +0000000          
.69   +0000000          
.70   +0007zzz          
.71   +zzzzzzz          
.72   +zzzzzzz          
.73   +zzzzzzz          
.74   +zzzzzzz          
.75   +zzzzzzz          
.76   -zzzzzzz          
.77   -zzzzzzz          
.78   -zzzzzzz          
.79   -zzzzzzz          
.80   -zzzzzzz          
.81   -zzzzzzz          
.82   -zw00000          
.83   -0000001          
.84   -0000001          
.85   -0000001          
.86   -0000001          
.87   -0000001          
.88   +0000000          
.89   +0000000          
.90   +0000000          
.91   +0000000          
.92   +0000000          
.93   +0000001          
.94   +zzzzzzz          
.95   +zzzzzzz          
.96   +zzzzzzz          
.97   +zzzzzzz          
.98   +zzzzzzz          
.99   +zzzzzzz          
.u0   -zzzzzzz          
.u1   -zzzzzzz          
.u2   -zzzzzzz          
.u3   -zzzzzzz          
.u4   -zzzzzzz          
.u5   -zzzzz00          
.u6   -0000001          
.u7   -0000001          


<BLOCK>

#E2 / E3
.01   +zzzzzzz          
.02   +zzzzzzz          
.03   +zzzzzzz          
.04   +zzzzzzz          
.05   +zzzzzzz          
.06   +zzzzzzz          
.07   +zzzzzzz          
.08   +zzzzzzz          
.09   +zzzzzzz          
.10   +zzzzzzz          
.11   -zzzzzzz          
.12   -zzzzzzz          
.13   -zzzzzzz          
.14   -zzzzzzz          
.15   -zzzzzzz          
.16   -zzzzzzz          
.17   -zzzzzzz          
.18   -zzzzzzz          
.19   -zzzzzzz          
.20   -zzzzzzy          
.21   -0000001          
.22   -0000001          
.23   -0000001          
.24   -0000001          
.25   -0000001          
.26   -0000001          
.27   -0000001          
.28   -0000001          
.29   -0000001          
.30   -0000001          
.31   +0000000          
.32   +0000000          
.33   +0000000          
.34   +0000000          
.35   +0000000          
.36   +0000000          
.37   +0000000          
.38   +0000000          
.39   +0000000          
.40   +0000000          
.41   +000000z          
.42   +zzzzzzz          
.43   +zzzzzzz          
.44   +zzzzzzz          
.45   +zzzzzzz          
.46   +zzzzzzz          
.47   +zzzzzzz          
.48   +zzzzzzz          
.49   +zzzzzzz          
.50   +zzzzzzz          
.51   +zzzzzzz          
.52   -zzzzzzz          
.53   -zzzzzzz          
.54   -zzzzzzz          
.55   -zzzzzzz          
.56   -zzzzzzz          
.57   -zzzzzzz          
.58   -zzzzzzz          
.59   -zzzzzzz          
.60   -zzzzzzz          
.61   -zzzzzzz          
.62   -zzzzzw0          
.63   -0000001          
.64   -0000001          
.65   -0000001          
.66   -0000001          
.67   -0000001          
.68   -0000001          
.69   -0000001          
.70   -0000001          
.71   -0000001          
.72   -0000001          
.73   +0000000          
.74   +0000000          
.75   +0000000          
.76   +0000000          
.77   +0000000          
.78   +0000000          
.79   +0000000          
.80   +0000000          
.81   +0000000          
.82   +0000000          
.83   +00001zz          
.84   +zzzzzzz          
.85   +zzzzzzz          
.86   +zzzzzzz          
.87   +zzzzzzz          
.88   +zzzzzzz          
.89   +zzzzzzz          
.90   +zzzzzzz          
.91   +zzzzzzz          
.92   +zzzzzzz          
.93   +zzzzzzz          
.94   -zzzzzzz          
.95   -zzzzzzz          
.96   -zzzzzzz          
.97   -zzzzzzz          
.98   -zzzzzzz          
.99   -zzzzzzz          
.u0   -zzzzzzz          
.u1   -zzzzzzz          
.u2   -zzzzzzz          
.u3   -zzzzzzz          
.u4   -zzzz800          
.u5   -0000001          
.u6   -0000001          
.u7   -0000001          


<BLOCK>

#E4 / E5
.01   +zzzzzzz          
.02   +zzzzzzz          
.03   -zzzzzzz          
.04   -zzzzzzz          
.05   -zy00000          
.06   -0000001          
.07   -0000001          
.08   +0000000          
.09   +0000000          
.10   +0007zzz          
.11   +zzzzzzz          
.12   +zzzzzzz          
.13   -zzzzzzz          
.14   -zzzzzzz          
.15   -zzzzz00          
.16   -0000001          
.17   -0000001          
.18   +0000000          
.19   +0000000          
.20   +0000003          
.21   +zzzzzzz          
.22   +zzzzzzz          
.23   +zzzzzzz          
.24   -zzzzzzz          
.25   -zzzzzzz          
.26   -z000000          
.27   -0000001          
.28   -0000001          
.29   +0000000          
.30   +0000000          
.31   +003zzzz          
.32   +zzzzzzz          
.33   +zzzzzzz          
.34   -zzzzzzz          
.35   -zzzzzzz          
.36   -zzzz800          
.37   -0000001          
.38   -0000001          
.39   +0000000          
.40   +0000000          
.41   +000001z          
.42   +zzzzzzz          
.43   +zzzzzzz          
.44   +zzzzzzz          
.45   -zzzzzzz          
.46   -zzzzzzz          
.47   -8000000          
.48   -0000001          
.49   -0000001          
.50   +0000000          
.51   +0000000          
.52   +01zzzzz          
.53   +zzzzzzz          
.54   +zzzzzzz          
.55   -zzzzzzz          
.56   -zzzzzzz          
.57   -zzzw000          
.58   -0000001          
.59   -0000001          
.60   +0000000          
.61   +0000000          
.62   +00000zz          
.63   +zzzzzzz          
.64   +zzzzzzz          
.65   +zzzzzzz          
.66   -zzzzzzz          
.67   -zzzzzzy          
.68   -0000001          
.69   -0000001          
.70   -0000001          
.71   +0000000          
.72   +0000000          
.73   +0zzzzzz          
.74   +zzzzzzz          
.75   +zzzzzzz          
.76   -zzzzzzz          
.77   -zzzzzzz          
.78   -zzy0000          
.79   -0000001          
.80   -0000001          
.81   +0000000          
.82   +0000000          
.83   +00007zz          
.84   +zzzzzzz          
.85   +zzzzzzz          
.86   +zzzzzzz          
.87   -zzzzzzz          
.88   -zzzzzz0          
.89   -0000001          
.90   -0000001          
.91   -0000001          
.92   +0000000          
.93   +0000000          
.94   +7zzzzzz          
.95   +zzzzzzz          
.96   +zzzzzzz          
.97   -zzzzzzz          
.98   -zzzzzzz          
.99   -zz00000          
.u0   -0000001          
.u1   -0000001          
.u2   +0000000          
.u3   +0000000          
.u4   +0003zzz          
.u5   +zzzzzzz          
.u6   +zzzzzzz          
.u7   -zzzzzzz          


<BLOCK>

#F3 / F4
.01   +zzzzzzz          
.02   +zzzzzzz          
.03   +zzzzzzz          
.04   +zzzzzzz          
.05   -zzzzzzz          
.06   -zzzzzzz          
.07   -zzzzzzz          
.08   -zzzzzzz          
.09   -zzzzzzw          
.10   -0000001          
.11   -0000001          
.12   -0000001          
.13   -0000001          
.14   -0000001          
.15   +0000000          
.16   +0000000          
.17   +0000000          
.18   +0000000          
.19   +000003z          
.20   +zzzzzzz          
.21   +zzzzzzz          
.22   +zzzzzzz          
.23   +zzzzzzz          
.24   +zzzzzzz          
.25   -zzzzzzz          
.26   -zzzzzzz          
.27   -zzzzzzz          
.28   -zzzzzzz          
.29   -zzzzy00          
.30   -0000001          
.31   -0000001          
.32   -0000001          
.33   -0000001          
.34   -0000001          
.35   +0000000          
.36   +0000000          
.37   +0000000          
.38   +0000000          
.39   +0001zzz          
.40   +zzzzzzz          
.41   +zzzzzzz          
.42   +zzzzzzz          
.43   +zzzzzzz          
.44   -zzzzzzz          
.45   -zzzzzzz          
.46   -zzzzzzz          
.47   -zzzzzzz          
.48   -zzzzzzz          
.49   -zzz0000          
.50   -0000001          
.51   -0000001          
.52   -0000001          
.53   -0000001          
.54   +0000000          
.55   +0000000          
.56   +0000000          
.57   +0000000          
.58   +0000000          
.59   +00zzzzz          
.60   +zzzzzzz          
.61   +zzzzzzz          
.62   +zzzzzzz          
.63   +zzzzzzz          
.64   -zzzzzzz          
.65   -zzzzzzz          
.66   -zzzzzzz          
.67   -zzzzzzz          
.68   -zzzzzzz          
.69   -z800000          
.70   -0000001          
.71   -0000001          
.72   -0000001          
.73   -0000001          
.74   +0000000          
.75   +0000000          
.76   +0000000          
.77   +0000000          
.78   +0000000          
.79   +7zzzzzz          
.80   +zzzzzzz          
.81   +zzzzzzz          
.82   +zzzzzzz          
.83   +zzzzzzz          
.84   -zzzzzzz          
.85   -zzzzzzz          
.86   -zzzzzzz          
.87   -zzzzzzz          
.88   -zzzzzzy          
.89   -0000001          
.90   -0000001          
.91   -0000001          
.92   -0000001          
.93   -0000001          
.94   +0000000          
.95   +0000000          
.96   +0000000          
.97   +0000000          
.98   +000001z          
.99   +zzzzzzz          
.u0   +zzzzzzz          
.u1   +zzzzzzz          
.u2   +zzzzzzz          
.u3   +zzzzzzz          
.u4   -zzzzzzz          
.u5   -zzzzzzz          
.u6   -zzzzzzz          
.u7   -zzzzzzz          


<BLOCK>

#G3 / G4
.01   +zzzzzzz          
.02   +zzzzzzz          
.03   +zzzzzzz          
.04   -zzzzzzz          
.05   -zzzzzzz          
.06   -zzzzzzz          
.07   -zzzzzzz          
.08   -zzzzzy0          
.09   -0000001          
.10   -0000001          
.11   -0000001          
.12   -0000001          
.13   +0000000          
.14   +0000000          
.15   +0000000          
.16   +0000000          
.17   +00007zz          
.18   +zzzzzzz          
.19   +zzzzzzz          
.20   +zzzzzzz          
.21   +zzzzzzz          
.22   -zzzzzzz          
.23   -zzzzzzz          
.24   -zzzzzzz          
.25   -zzzzzzz          
.26   -zzy0000          
.27   -0000001          
.28   -0000001          
.29   -0000001          
.30   -0000001          
.31   +0000000          
.32   +0000000          
.33   +0000000          
.34   +0000000          
.35   +07zzzzz          
.36   +zzzzzzz          
.37   +zzzzzzz          
.38   +zzzzzzz          
.39   +zzzzzzz          
.40   -zzzzzzz          
.41   -zzzzzzz          
.42   -zzzzzzz          
.43   -zzzzzzz          
.44   -0000001          
.45   -0000001          
.46   -0000001          
.47   -0000001          
.48   +0000000          
.49   +0000000          
.50   +0000000          
.51   +0000000          
.52   +000003z          
.53   +zzzzzzz          
.54   +zzzzzzz          
.55   +zzzzzzz          
.56   +zzzzzzz          
.57   -zzzzzzz          
.58   -zzzzzzz          
.59   -zzzzzzz          
.60   -zzzzzzz          
.61   -zzzz000          
.62   -0000001          
.63   -0000001          
.64   -0000001          
.65   -0000001          
.66   +0000000          
.67   +0000000          
.68   +0000000          
.69   +0000000          
.70   +003zzzz          
.71   +zzzzzzz          
.72   +zzzzzzz          
.73   +zzzzzzz          
.74   +zzzzzzz          
.75   -zzzzzzz          
.76   -zzzzzzz          
.77   -zzzzzzz          
.78   -zzzzzzz          
.79   -z000000          
.80   -0000001          
.81   -0000001          
.82   -0000001          
.83   -0000001          
.84   +0000000          
.85   +0000000          
.86   +0000000          
.87   +0000001          
.88   +zzzzzzz          
.89   +zzzzzzz          
.90   +zzzzzzz          
.91   +zzzzzzz          
.92   -zzzzzzz          
.93   -zzzzzzz          
.94   -zzzzzzz          
.95   -zzzzzzz          
.96   -zzzzz80          
.97   -0000001          
.98   -0000001          
.99   -0000001          
.u0   -0000001          
.u1   +0000000          
.u2   +0000000          
.u3   +0000000          
.u4   +0000000          
.u5   +0001zzz          
.u6   +zzzzzzz          
.u7   +zzzzzzz          


<BLOCK>
.00   -68w1v0u          
.01   +u4zw901          
.02   -3vxwvuv          
.03   +x7v4605          
.04   +7009uw6          
.05   +v6vu498          
.06   +745wvyy          
.07   +u51020v          
.08   -w02z594          
.09   -020x5v6          
.10   -v8813uu          
.11   +u27xx49          
.12   +30v66z8          
.13   -1w6v4ux          
.14   +102x9v1          
.15   -1z854y1          
.16   +13wy1z6          
.17   -64w4028          
.18   +wv007xy          
.19   -9w0w7xw          
.20   -x2536w7          
.21   -u523x12          
.22   -9zx9vv5          
.23   +uu0811u          
.24   +54578z6          
.25   +3804v6x          
.26   -2862u5w          
.27   -zz85u46          
.28   +v62720v          
.29   +6vv7u70          
.30   -wy3z6y3          
.31   -87v4178          
.32   +1049z2z          
.33   -y195888          
.34   -4979y91          
.35   +x7069x7          
.36   +u78y801          
.37   +u38z437          
.38   +v4v67uw          
.39   -4zvz7vz          
.40   -u85zw9y          
.41   +6xuuwwy          
.42   -x29504v          
.43   +5v5x03w          
.44   +363zv6x          
.45   -u95x0yw          
.46   -678y341          
.47   -v9438vz          
.48   +y3w7x05          
.49   -9yvy79z          
.50   +63y0y90          
.51   -78xvv33          
.52   +zv335x8          
.53   +8u6vywu          
.54   -5682w71          
.55   -v1058x4          
.56   -1w4455y          
.57   -630u5v3          
.58   +72y7496          
.59   +6xw9zz2          
.60   +334z1uu          
.61   -47419y5          
.62   +6z36yyv          
.63   -z4v48x1          
.64   +170ux95          
.65   +2v6v0y5          
.66   +z19u843          
.67   +9749yvu          
.68   -74v755y          
.69   -61614x0          
.70   -018y877          
.71   -3y3uv45          
.72   +zy849y4          
.73   -x79yz97          
.74   -vx3278z          
.75   -9991229          
.76   +035v37u          
.77   -0y76373          
.78   -42y0u28          
.79   -x53wx08          
.80   +4uy77v7          
.81   +yz95v45          
.82   -37v2079          
.83   +6wz4uyz          
.84   +w4w1v44          
.85   +yy6z3yy          
.86   +z47v2w4          
.87   -7269156          
.88   -w32u60z          
.89   +9831vy1          
.90   +x6zy963          
.91   -2xw3y31          
.92   -67179y6          
.93   -7yuxuz4          
.94   -zz2572y          
.95   -6x8xxw4          
.96   -17w5vyy          
.97   -3xzv8w1          
.98   +z94y370          
.99   -0u29779          
.u0   +w627009          
.u1   +2y19934          
.u2   +u2414ww          
.u3   -3x467w2          
.u4   -z93zz67          
.u5   -5012726          
.u6   -72877xy          

<BLOCK>

<BLOCK>

<BLOCK>
#define V2 00010
#define V3 00011

#define A2 010000
#define A3 110000
#define A#2 001111
#define A4 101111
#define B2 001110
#define B3 101110
#define B4 001101
#define B5 101101
#define C3 001100
#define C4 101100
#define F#4 001011
#define C5 101011
#define D#3 001010
#define D#4 101010
#define D3 001001
#define D4 101001
#define E2 001000
#define E3 101000
#define E4 000111
#define E5 100111
#define F3 000110
#define F4 100110
#define G3 000101
#define G4 100101
#define kk 010001 
#define ss 000100

#define .. 010010

#define Th 000000
#define Sx 000001
#define Et 000010
#define Qu 000100
#define QS 000101
#define Ha 001000

# As Binary
#           C   N1    D1 C   N2    D2     
#   b110101 000101 000011 000110 00010 0

# N1 is played 30ms before N2.
# 00010 is played 30ms before 00011

#           010010 00011  yy 00010   Should play at the same time
#           yy 00010  010010 00011   60ms delay
# write amplifier of line 2 and the read amplifier of line 3, 

#85ms between lines
# delays
#   0   85ms 
#   1   142ms
#   2   203ms

#       About 60ms per delay

#30ms internote delay on one line
.00   +0000000          
# Block 1-B
#2 & 3
.01   +0521982          
.02   +0521902          
.03   +0521102          
.04   +20z1902          
.05   +0521242          

# Block 1-A
#0
.06   +0511902          
.07   +0521102          
.08   +0681u42          
.09   +0521902          
#1
.10   +0521102          
.11   +0491u42          
.12   +0521902          
.13   +0521102          
#2
.14   +04w1u42          
.15   +0521902          
.16   +0521102          
.17   +04z1u42          
#3
.18   +0521902          
.19   +0521102          
.20   +04y1902          
.21   +04w1u42          
#0
.22   +0511902          
.23   +0521102          
.24   +0681u42          
.25   +0521902          
#1
.26   +0521102          
.27   +0491u42          
.28   +0521902          
.29   +0521102          
.30   +0000000          

# "100110", "000111", "101010", "100110", "101111", "100101", "100110", "101001", "100110", "100101", "101111", "001101", "101111", "100101", "100110", "101001"]
# Arpeggio One
.31   +02610y2          
.32   +02u14w2          
.33   +02z14u2          
.34   +0261522          
.35   +02614u2          
.36   +02z11u2          
.37   +02z14u2          
.38   +0661522          
.39   +0000000          


# Block 2-B
#2
.40   +04w1u22          
.41   +0521902          
.42   +0441102          
#3 & 4
.43   +20z1902          

# Block 2-A
#0
.44   +0511902          
.45   +0521102          
.46   +0681882          
.47   +0521902          
#1
.48   +0511102          
.49   +0491u22          
.50   +0441902          
.51   +0521102          
#2
.52   +04w1u22          
.53   +0521902          
.54   +0441102          
.55   +04z1u42          
#3
.56   +0511902          
.57   +0521102          
.58   +04y1u22          
.59   +04w1u42          

#0
.60   +0511902          
.61   +0521102          
.62   +0681882          
.63   +0521902          
#1
.64   +0511102          
.65   +0491u22          
.66   +0441902          
.67   +0521102          
.68   +0000000          


# Block 3-A
#0
.69   +0511u02          
.70   +0521202          
.71   +0701882          
.72   +0521u02          
#1
.73   +0511202          
.74   +0451u22          
.75   +0441u02          
.76   +0521202          
#2
.77   +0461u22          
.78   +0521u02          
.79   +0441202          
.80   +04u1u42          
#3
.81   +0511u02          
.82   +0521202          
.83   +0681u22          
.84   +0461u42          

#0
.85   +0511u02          
.86   +0521202          
.87   +0701882          
.88   +0521u02          
#1
.89   +0511202          
.90   +0451u22          
.91   +0441u02          
.92   +0521202          

# Block 3-B
#2
.93   +0461u22          
.94   +0521u02          
.95   +0441202          
#3 & 4
.96   +20u1u02          
.97   +0000000          


# Arpeggio 2
.98   +00x14u3          
.99   +00714u2          
.u0   +00x14u2          
.u1   +00x1562          
.u2   +00x14u2          
.u3   +00x14u2          
.u4   +00x1562          
.u5   +06715u2          
.u6   +0000000          


<BLOCK>
.00 . u.05.85.0.00.20 - Copy next 3 values to 20:1,2,3,0
# Delay Extractor
.01   +zw00000          
# Note Extractor
.02   +00007zz          
.03   +03zz800          
#Next Note Instruction
.04 .  .00.14.0.01.28   Music Data Load Instruction

# Conductor Code
# Each 3 instruction block loads a new load
# instruction to AR and then calls the subroutine
# at 00:09 which plays music data using that loader
# until it encounters a zero, and then returns.

.85 .  .86.87.0.00.28   1A
.86 .  .05.14.0.01.28   
.87 . w.88.09.0.21.31   

.88 .  .89.90.0.00.28   1B 1A
.89 .  .00.14.0.01.28   
.90 . w.91.09.0.21.31   

.91 .  .92.93.0.00.28   1B 1A
.92 .  .00.14.0.01.28   
.93 . w.94.09.0.21.31   

.94 .  .95.96.0.00.28   ARP 1
.95 .  .30.14.0.01.28   
.96 . w.97.09.0.21.31   

.97 .  .98.99.0.00.28   2A
.98 .  .44.14.0.01.28   
.99 . w.u0.09.0.21.31   

.u0 .  .u1.u2.0.00.28   2B 2A
.u1 .  .39.14.0.01.28   
.u2 . w.u3.09.0.21.31   

.u3 .  .u4.u5.0.00.28   ARP 2
.u4 .  .97.14.0.01.28   
.u5 . w.28.09.0.21.31   

.28 .  .29.30.0.00.28   3AB
.29 .  .68.14.0.01.28   
.30 . w.31.09.0.21.31   

.31 .  .32.33.0.00.28   3AB
.32 .  .68.14.0.01.28   
.33 . w.36.09.0.21.31   

.36 .  .37.38.0.00.28   2A
.37 .  .44.14.0.01.28   
.38 . w.39.09.0.21.31   

.39 .  .40.41.0.00.28   2B 2A
.40 .  .39.14.0.01.28   
.41 . w.42.09.0.21.31   

.42 .  .43.44.0.00.28   Last little bit is stored on this line!
.43 .  .46.14.0.00.28   
.44 . w.45.09.0.21.31   

.45 .  .47.00.0.16.31   HALT

# This is the end of the song. No room on line 01.
en:
.46   +0000000          
.47   +04w1882          
.48   +0521902          
.49   +0641102          
.50   +20z1902          
.51   +0121243          Silence
.52   +0000000          End Song

# Arrive at 07 with the NN instruction in 20:0
# OR
# Arrive at 09 with the NN instruction in AR.

nn:
.07 .  .08.09.0.20.28   Copy Note load instruction to AR
.09 .  .10.11.0.00.29   Increment note load instruction
.10   +0100000          1 shifted to T position

.11 .  .12.13.0.28.20   Copy incremented load instruction back to 22:0
.13 .  .15.15.0.31.31   NCAR
ml:
.14 .  .15.16.0.28.27   Check AR (node data) Zero
.16 .  .18.17.0.20.31   if AR == 0 RETURN
#.16 .  .L2.00.0.16.31     if AR == 0 HALT


.17 . u.22.22.0.28.21   4 copies of AR to 21:0-4
.22 . u.27.27.0.31.21   Extract parts of notes Line 21 = Line 21 & Line 20

                        21:1 Delay, 21:3 First note, 21:2 Second note
                        Each note is the C, Src and Dst to add to the
                        note load instruction.

                        Shift first note (ID:3) bits down
.27 .  .31.35.0.21.25   Load 21:3 to ID TODO MAC

.35 .  .22.58.1.26.31   Shift ID1 right 11 bits
.58 .  .59.60.1.25.21   Copy ID:1 back to 21:3

                        Play First Note (21:3)
.60 .  .61.62.0.00.28 - Copy note load instr to AR
.61 . u.67.67.0.00.00   Note Load Instruction
.62 .  .63.64.0.21.29   Add 21:03 to AR
.64 .  .66.66.0.31.31   NCAR
a1:                     After Note 1

                        Play Second Note (21:2)
.67 .  .68.69.0.00.28   Copy note load instr to AR
.68 . u.74.74.0.00.00   Note Load Instruction
.69 .  .70.71.0.21.29   Add 21:02 to AR
.71 .  .73.73.0.31.31   NCAR
a2:                     After Note 2

                        Process Delay
.74 .  .77.78.0.21.28   Copy delay from ID:1 to AR
dy:
.78 .  .79.80.0.28.27   Check AR Zero
.80 .  .00.07.0.00.00   if AR == 0 goto nn
.81 .  .82.78.3.00.29   Decrement delay, goto dy
.82   +0200000          1 shifted to Delay position

