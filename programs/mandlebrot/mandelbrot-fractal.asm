rs:                     Return Setup
                        Set up the return instructions for the complex
                        multiplication routine.
.00 .  .L1.L2.1.02.28   Copy return command to A
.   .  .rt.rt.2.20.31   Return Command
.   .  .02.  .0.28.21   command for normal return
.   .  .03.  .0.28.21   command for overflow return

                        Skip the above code after the
                        first call to this fractal code
.   .  .L1.L2.0.02.28   Skip command to AR
.   .  .01.07.0.00.00   
.   .  .00.  .0.28.02   AR -> 2:0

                        Reset the iteration count
                        ct = 1
.07 .  .L1.L2.0.02.28   1 -> AR
.   d1
.   .  .%2.  .0.28.23   AR -> ct

                        Initialize Z
                        Load 23:0,1 (Ci,Cr) -> 20:0,1 (Zi,Zr)
.L2 .  .%0.  .0.23.20   Ci -> Zi
.%1 .  .%1.  .0.23.20   Cr -> Zr


lp:

                        Put Z into line 22 as complex mult params
                        Copy 20:0,1 (Zi,Zr) to...
.L5 .  .%1.  .0.20.28   Zr -> AR
.%2 .  .%3.  .0.28.22   AR -> P1r
.%0 .  .%1.  .0.28.22   AR -> P2r

.%2 .  .%0.  .0.20.28   Zi -> AR
.%1 .  .%2.  .0.28.22   AR -> P1i
.L2 .  .%0.  .0.28.22   AR -> P2i

                        Call complex multiplication routine
.35 .  .40.40.1.20.31   GOTO 1:40

                        Add position to Z^2
rt:
                        Zr = Zr + Cr
.40 .  .%1.  .1.23.28   Cr -> AR
.%2 .  .%1.  .1.20.29   AR += 20.01 (ResultR / Zr)
.%2 .  .%1.  .1.28.20   AR -> 20.01

                        Zi = Zi + Ci
.%2 .  .%0.  .1.23.28   Ci -> AR
.%1 .  .%0.  .1.20.29   AR += 20.00 (ResultI / Zi)
.%1 .  .%0.  .1.28.20   AR -> 20.00

                        Determine if the point is OUT. Uses a
                        square (rather than a circle) for speed.
                        if |Zi| > 2 goto ot
.%1 .  .%0.  .2.20.28   |Zi| -> AR
.%1 .  .L1.L2.3.02.29   Subtract two
.   d0.02               Two shifted
.   .  .L2.  .0.22.31   Test AR sign
.L3 .  .L1.ot.0.00.00   if AR >= 0 goto ot
                        else continue on

                        if |Zr| > 2 goto ot
.   .  .%1.  .2.20.28   |Zr| -> AR
.%2 .  .L1.L2.3.02.29   Subtract two
.   d0.02               Two shifted
.   .  .L2.  .0.22.31   Test AR sign
.L3 .  .L1.ot.0.00.00   if AR >= 0 goto ot
                        else continue on

                        Increment the count
                        ct = ct + 1
.   .  .%2.  .1.23.28   ct -> AR
.%3 .  .L1.L2.1.02.29   AR += 1
.   d1
.   .  .%2.  .1.28.23   AR -> ct

                        If the count exceeds the limit, the
                        point is IN, otherwise loop again
.%3 .  .L1.L2.3.02.29   Subtract limit
.   d17                 Limit 16
.   .  .L2.  .0.22.31   Test AR sign
.L3 .  .L1.in.0.00.00   if AR >= 0 goto in
.   .  .L1.lp.0.00.00   else loop


in:                     Point is IN
.   .  .L1.tp.0.02.28   Zero AR, GOTO tp
.   d0

ot:                     Point is OUT
                        Copy the lowest nibble of the count into
                        the highest nibble of AR.
.   .  .%2.  .6.23.25   Ct -> ID1
.%3 .  .10.  .1.26.31   Shift R 4
.14 .  .%0.tp.0.25.28   ID0 -> AR

tp:
.17 .  .L2.L1.0.20.31   RETURN