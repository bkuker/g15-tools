#define ILOW d-0.0110
#define IHIGH d0.0110
#define ISTEP d0.0010

#define RLOW d-0.021
#define RHIGH d0.021
#define RSTEP d0.0004

.00 .  .L1.rt.0.00.00   GOTO RESET

#Leave room for formatting codes

st:                     Start
                        Reset Imaginary Position
.04 .  .L1.L2.1.03.28   Imaginary Start -> AR
.   ILOW                
.   .  .00.  .1.28.23   AR -> Ci

nl:                     Loop start for a new line

                        Print a newline
.   .  .L1.L2.1.03.28   AR = Format Newline
.   +4400000            F3 Format code, 0 digit, CR end
.   .  .03.  .1.28.03   03:03 = AR
.   .  .L2.  .0.08.31   Output AR to typewriter
.   .  .L0.L0.0.28.31   Wait for IOReady

                        Set up single digit format code
.   .  .L1.L2.1.03.28   AR = Format Digit
.   +0400000            Format code, 1 digit, end
.   .  .03.  .1.28.03   03:03 = AR

                        ci = ci + ISTEP
.   .  .00.  .1.23.28   Ci -> AR
.   .  .L1.L2.1.03.29   AR += Step
is:
.od ISTEP               Imaginary Step
.   .  .00.  .1.28.23   AR -> Ci

                        if ci > IHIGH then HALT
.   .  .00.  .1.23.28   Ci -> AR
.   .  .L1.L2.3.03.29   Subtract end point
.   IHIGH               
.   .  .L2.  .0.22.31   Test AR sign
.   .  .L2.bg.0.00.00   if AR >= 0 HALT
                        else continue on

                        Reset Real Position
.   .  .L1.L2.1.03.28   Real Start -> AR
.   RLOW                
.   .  .01.  .1.28.23   AR -> Cr

nc:                     Next Character loop start
                        
                        Cr = Cr + RSTEP
.   .  .%1.  .1.23.28   Cr -> AR
.%2 .  .L1.L2.1.03.29   AR += Step
rs:
.od RSTEP               
.   .  .%1.  .1.28.23   AR -> Cr


###CALL FRACTAL CODE
.%2 . w.tp.00.4.21.31   GOSUB 2.0 Line 2 instruction zero

#.%2 .  .L1.L2.0.03.28   AR = ones
#.   +1111111            F3 Format code, 0 digit, CR end

tp:                     Print out value in AR
.   .  .L2.  .0.08.31   Output AR to typewriter
.L3 .  .L0.L0.0.28.31   Wait for IOReady

                        If Cr > RHIGH
                            goto nl - Next Line
                        else
                            goto nc - Next Character
.   .  .%1.  .1.23.28   Cr -> AR
.%2 .  .L1.L2.3.03.29   Subtract end point
.   RHIGH               
.   .  .L2.  .0.22.31   Test AR sign
.L3 .  .L1.nl.0.00.00   if AR >= 0 goto nl
.L1 .  .L1.nc.0.00.00   else goto nc


#define CR 41
#define CI 52
bg:                     

# add a little to CI
.   .  .CI.  .1.04.28   Ci -> AR
.   .  .L1.L2.1.03.29   AR +=
.   d0.0003
.   .  .CI.  .1.28.04   AR -> Ci

# Add a little to CR
.   .  .CR.  .1.04.28   Cr -> AR
.   .  .L1.L2.1.03.29   AR +=
.   d0.0007
.   .  .CR.  .1.28.04   AR -> Cr

#If CR is big, do a thing
.   .  .L1.L2.1.03.29   AR -= following value
.   d-0.003
.   .  .L2.  .0.22.31   Test AR sign
.   .  .L2.rt.0.16.31 - if AR >= 0 HALT goto reset
.   .  .00.st.0.00.00   Else goto Start

rt:                     RESET
.   .  .L1.L2.1.03.28   Initial Cr -> AR
.   d-0.014             Initial Cr
.   .  .CR.  .1.28.04   AR -> Cr

.   .  .L1.L2.1.03.28   Initial Ci -> AR
.   d0.000
.   .  .CI.st.1.28.04   AR -> Ci

