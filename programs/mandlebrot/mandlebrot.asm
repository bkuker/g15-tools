<INCLUDE src="../lib/bbl.asm">
ct:                     Count
.   d2

<BLOCK>                 Block 1

<INCLUDE src="../lib/complex.mult.div.asm">

<BLOCK>                 Block 0

                        Reset Imaginary Position
.00 .  .L1.L2.1.00.28   Imaginary Start -> AR
.   d-0.02              Imaginary Start Position
.   .  .ip.  .1.28.00   AR -> Imaginary Position

nl:
#TODO Halt when ip too high
                        Print a newline
.   .  .L1.L2.1.00.28   AR = Format Newline
.   +4400000            F3 Format code, 0 digit, CR end
.   .  .03.  .1.28.03   03:03 = AR
.   .  .L2.  .0.08.31   Output AR to typewriter
.   .  .L0.L0.0.28.31   Wait for IOReady

                        Set up single digit format code
.   .  .L1.L2.1.00.28   AR = Format Digit
.   +0400000            Format code, 1 digit, end
.   .  .03.  .1.28.03   03:03 = AR

                        Increment Imaginary Position by one step
.   .  .ip.  .1.00.28   Imaginary Position -> AR
.   .  .L1.L2.1.00.29   AR += Step
.   d0.001              Imaginary Step TODO .001
.   .  .ip.  .1.28.00   AR -> Imaginary Position

.   .  .ip.  .1.00.28   Imaginary Position -> AR
.   .  .L1.L2.3.00.29   Subtract end point
.   d0.02               Imaginary End Position
.   .  .L2.  .1.22.31   Test AR sign
.   .  .L2.00.0.16.31   if AR >= 0 HALT
                        else continue on

                        Reset Real Position
.   .  .L1.L2.1.00.28   Real Start -> AR
.   d-0.02              Real Start Position
.   .  .rp.  .1.28.00   AR -> Real Position

nc:
                        Increment Real Position by one step
.   .  .rp.  .1.00.28   Real Position -> AR
.   .  .L1.L2.1.00.29   AR += Step
.   d0.00035            Real Step   TODO .00035
.   .  .rp.  .1.28.00   AR -> Real Position

#TODO Something Useful

                        //Clear count
.   .  .L1.L2.0.00.28   0 -> AR
.   0
.   .  .ct.  .0.28.00   AR -> ct

                        Initialize z
.   .  .rp.  .0.00.28   Real Position -> AR
.   .  .zr.  .0.28.00   AR -> zr
.   .  .ip.  .0.00.28   Imaginary Position -> AR
.   .  .zi.  .0.28.00   AR -> zi

lp:
                        Put Z into line 22 as complex mult param
.   .  .zr.  .0.00.28   zr -> AR
.   .  .03.  .0.28.22   zr -> 22.03 (a)
.   .  .01.  .0.28.22   zr -> 22.01 (c)
.   .  .zi.  .0.00.28   zi -> AR
.   .  .02.  .0.28.22   zi -> 22.02 (b)
.   .  .00.  .0.28.22   zi -> 22.00 (d)

.   .  .00.  .0.00.00   Alignment

                        Square Z
.   .  .L1.sq.4.00.21   DP Copy return commands to line 20
.%2 .  .rt.rt.0.20.31   command for normal return
.   .  .rt.rt.0.20.31   command for overflow return
sq:
.   .  .40.40.1.20.31   "goto" 01.40 (complex multiply)

                        Add position to Z^2
rt:
                        zr = rr + rp
.   .  .rp.  .1.00.28   Real Position -> AR
.   .  .01.  .1.20.29   AR += 20.01 (Result real)
.   .  .zr.  .1.28.00   AR -> zr

                        zi = ri + ip
.   .  .ip.  .1.00.28   Imaginary Position -> AR
.   .  .00.  .1.20.29   AR += 20.00 (Result imaginary)
.   .  .zi.  .1.28.00   ar -> zi

                        if |zr| > 2 goto ot
.   .  .zr.  .2.00.28   |zr| -> AR
.   .  .L1.L2.3.00.29   Subtract two
.   d0.02               Two shifted
.   .  .L2.  .1.22.31   Test AR sign
.   .  .L1.o1.0.00.00   if AR >= 0 goto ot
                        else continue on

                        if |zi| > 2 goto ot
.   .  .zi.  .2.00.28   |zi| -> AR
.   .  .L1.L2.3.00.29   Subtract two
.   d0.02               Two shifted
.   .  .L2.  .1.22.31   Test AR sign
.   .  .L1.o2.0.00.00   if AR >= 0 goto ot
                        else continue on

                        ct = ct + 1
.   .  .ct.  .1.00.28   Load ct to AR
.   .  .L1.L2.1.00.29   Increment AR
.   +1
.   .  .ct.  .1.28.00   Save ar to ct

                        if ct > limit goto in
.   .  .L1.L2.3.00.29   Subtract limit
.   +10                  Limit 10
.   .  .L2.  .1.22.31 - Test AR sign
.   .  .L1.in.0.00.00   if AR >= 0 goto in
.   .  .L1.lp.0.00.00   else loop


in:
.   .  .L1.tp.0.00.28
.   +8888888

o1:
.   .  .L1.tp.0.00.28
.   +0 

o2:
.   .  .L1.tp.0.00.28
.   +0 

o3:
.   .  .L1.tp.0.00.28
.   +0 

tp:

.   .  .L2.  .0.08.31   Output AR to typewriter
.   .  .L0.L0.0.28.31   Wait for IOReady

.   .  .rp.  .1.00.28   Real Position -> AR
.   .  .L1.L2.3.00.29   Subtract end point
.   d0.02               Real End Position
.   .  .L2.  .1.22.31   Test AR sign
.   .  .L1.nl.0.00.00   if AR >= 0 goto nl
.   .  .L1.nc.0.00.00   else goto nc


rp:
.   0                   Real position
ip:
.   0                   Imaginary position
zr:
.   0
zi:
.   0
ct:
.   0