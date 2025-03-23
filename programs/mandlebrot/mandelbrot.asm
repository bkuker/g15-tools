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
.   ILOW                
.   .  .00.rs.1.28.23   AR -> Ci


rs:                     Return Setup
.   .  .L3.nl.4.00.21   DP Copy return commands to line 20
.                       Alignment
.                       Alignment
.%2 .  .rt.rt.0.20.31   command for normal return
.   .  .rt.rt.0.20.31   command for overflow return

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
.   .  .00.  .1.23.28   Ci -> AR
.   .  .L1.L2.1.00.29   AR += Step
.   ISTEP               Imaginary Step
.   .  .00.  .1.28.23   AR -> Ci

                        if ci > IHIGH then HALT
.   .  .00.  .1.23.28   Ci -> AR
.   .  .L1.L2.3.00.29   Subtract end point
.   IHIGH               
.   .  .L2.  .1.22.31   Test AR sign
.   .  .L2.00.0.16.31   if AR >= 0 HALT
                        else continue on

                        Reset Real Position
.   .  .L1.L2.1.00.28   Real Start -> AR
.   RLOW                
.   .  .01.  .1.28.23   AR -> Cr

nc:                     Next Character loop start
                        
                        Cr = Cr + RSTEP
.   .  .%1.%2.1.23.28   Cr -> AR
.%2 .  .L1.L2.1.00.29   AR += Step
.   RSTEP               
.   .  .%1.%2.1.28.23   AR -> Cr


############################
###### SKIP FRACTAL CODE
#.   .  .L1.in.0.00.00   


########## BEGIN FRACTAL CODE

                        Clear count
.%2 .  .L1.L2.0.00.28   0 -> AR
.   0
.   .  .02.  .0.28.23   AR -> ct

                        Initialize Z
                        Load 23:0,1 (Ci,Cr) -> 20:0,1 (Zi,Zr)
.   .  .00.  .0.23.20   Ci -> Zi
.   .  .01.  .0.23.20   Cr -> Zr


lp:
                        Put Z into line 22 as complex mult params
                        Copy 20:0,1 (Zi,Zr) to...
.   .  .00.  .0.20.28   Zi -> AR
.   .  .00.  .0.28.22   AR -> P2i
.   .  .02.  .0.28.22   AR -> P1i

.   .  .01.  .0.20.28   Zr -> AR
.   .  .01.  .0.28.22   AR -> P2r
.   .  .03.  .0.28.22   AR -> P1r


.   .  .40.40.1.20.31   "goto" 01.40 (complex multcily)

                        Add position to Z^2
rt:
                        Zr = Zr + Cr
.   .  .01.  .1.23.28   Cr -> AR
.   .  .01.  .1.20.29   AR += 20.01 (ResultR / Zr)
.   .  .01.  .1.28.20   AR -> 20.01

                        Zi = Zi + Ci
.   .  .00.  .1.23.28   Ci -> AR
.   .  .00.  .1.20.29   AR += 20.00 (ResultI / Zi)
.   .  .00.  .1.28.20   AR -> 20.00

                        if |Zr| > 2 goto ot
.   .  .00.  .2.20.28   |Zr| -> AR
.   .  .L1.L2.3.00.29   Subtract two
.   d0.02               Two shifted
.   .  .L2.  .1.22.31   Test AR sign
.   .  .L1.ot.0.00.00   if AR >= 0 goto ot
                        else continue on

                        if |Zi| > 2 goto ot
.   .  .01.  .2.20.28   |Zi| -> AR
.   .  .L1.L2.3.00.29   Subtract two
.   d0.02               Two shifted
.   .  .L2.  .1.22.31   Test AR sign
.   .  .L1.ot.0.00.00   if AR >= 0 goto ot
                        else continue on

                        ct = ct + 1
.   .  .02.  .1.23.28   ct -> AR
.   .  .L1.L2.1.00.29   AR += 1
.   +1
.   .  .02.  .1.28.23   AR -> ct

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

                        If Cr > RHIGH
                            goto nl - Next Line
                        else
                            goto nc - Next Character
.   .  .01.  .1.23.28   Cr -> AR
.   .  .L1.L2.3.00.29   Subtract end point
.   RHIGH               
.   .  .L2.  .1.22.31   Test AR sign
.   .  .L1.nl.0.00.00   if AR >= 0 goto nl
.   .  .L1.nc.0.00.00   else goto nc
