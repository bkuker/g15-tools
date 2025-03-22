<INCLUDE src="../lib/bbl.asm">
ct:                     Count
.   d2

<BLOCK>                 Block 1

<INCLUDE src="../lib/complex.mult.div.asm">

<BLOCK>                 Block 0
#define ILOW d-0.01
#define IHIGH d0.01
#define ISTEP d0.0005

#define RLOW d-0.02
#define RHIGH d0.005
#define RSTEP d0.0002

                        Reset Imaginary Position
.00 .  .L1.L2.1.00.28   Imaginary Start -> AR
.   ILOW                Imaginary Start Position
.   .  .ci.  .1.28.00   AR -> Imaginary Position

nl:                     Loop start for a new line

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

                        ci = ci + ISTEP
.   .  .ci.  .1.00.28   Imaginary Position -> AR
.   .  .L1.L2.1.00.29   AR += Step
.   ISTEP               Imaginary Step
.   .  .ci.  .1.28.00   AR -> Imaginary Position

                        if ci > IHIGH then HALT
.   .  .ci.  .1.00.28   Imaginary Position -> AR
.   .  .L1.L2.3.00.29   Subtract end point
.   IHIGH               Imaginary End Position
.   .  .L2.  .1.22.31   Test AR sign
.   .  .L2.00.0.16.31   if AR >= 0 HALT
                        else continue on

                        Reset Real Position
.   .  .L1.L2.1.00.28   Real Start -> AR
.   RLOW                Real Start Position
.   .  .cr.  .1.28.00   AR -> Real Position

nc:                     Next Character loop start
                        
                        cr = cr + RSTEP
.   .  .cr.  .1.00.28   Real Position -> AR
.   .  .L1.L2.1.00.29   AR += Step
.   RSTEP               Real Step   TODO .00035
.   .  .cr.  .1.28.00   AR -> Real Position

########## BEGIN FRACTAL CODE

                        Clear count
.   .  .L1.L2.0.00.28   0 -> AR
.   0
.   .  .ct.  .0.28.00   AR -> ct

                        Initialize z
.   .  .cr.  .0.00.28   Real Position -> AR
.   .  .zr.  .0.28.00   AR -> zr
.   .  .ci.  .0.00.28   Imaginary Position -> AR
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
.   .  .40.40.1.20.31   "goto" 01.40 (complex multcily)

                        Add position to Z^2
rt:
                        zr = rr + cr
.   .  .cr.  .1.00.28   Real Position -> AR
.   .  .01.  .1.20.29   AR += 20.01 (Result real)
.   .  .zr.  .1.28.00   AR -> zr

                        zi = ri + ci
.   .  .ci.  .1.00.28   Imaginary Position -> AR
.   .  .00.  .1.20.29   AR += 20.00 (Result imaginary)
.   .  .zi.  .1.28.00   AR -> zi

                        if |zr| > 2 goto ot
.   .  .zr.  .2.00.28   |zr| -> AR
.   .  .L1.L2.3.00.29   Subtract two
.   d0.02               Two shifted
.   .  .L2.  .1.22.31   Test AR sign
.   .  .L1.ot.0.00.00   if AR >= 0 goto ot
                        else continue on

                        if |zi| > 2 goto ot
.   .  .zi.  .2.00.28   |zi| -> AR
.   .  .L1.L2.3.00.29   Subtract two
.   d0.02               Two shifted
.   .  .L2.  .1.22.31   Test AR sign
.   .  .L1.ot.0.00.00   if AR >= 0 goto ot
                        else continue on

                        ct = ct + 1
.   .  .ct.  .1.00.28   ct -> AR
.   .  .L1.L2.1.00.29   AR += 1
.   +1
.   .  .ct.  .1.28.00   AR -> ct

                        if ct > limit goto in
.   .  .L1.L2.3.00.29   Subtract limit
.   +10                 Limit 10
.   .  .L2.  .1.22.31 - Test AR sign
.   .  .L1.in.0.00.00   if AR >= 0 goto in
.   .  .L1.lp.0.00.00   else loop


in:                     Point is IN
.   .  .L1.tp.0.00.28   Eights -> AR; GOTO tp
.   +8888888

ot:                     Point is OUT
.   .  .L1.tp.0.00.28   Zero -> AR; GOTO tp
.   +0 


###############END FRACTAL CODE

tp:                     Print out value in AR
.   .  .L2.  .0.08.31   Output AR to typewriter
.   .  .L0.L0.0.28.31   Wait for IOReady

                        If cr > RHIGH
                            goto nl - Next Line
                        else
                            goto nc - Next Character
.   .  .cr.  .1.00.28   Real Position -> AR
.   .  .L1.L2.3.00.29   Subtract end point
.   RHIGH               Real End Position
.   .  .L2.  .1.22.31   Test AR sign
.   .  .L1.nl.0.00.00   if AR >= 0 goto nl
.   .  .L1.nc.0.00.00   else goto nc


                        C - The complex coordinate on the screen
cr:
.   0                   
ci:
.   0
                        
zr:                     Z - The complex iterated point
.   0
zi:
.   0

ct:                     Count - the iteration counter
.   0