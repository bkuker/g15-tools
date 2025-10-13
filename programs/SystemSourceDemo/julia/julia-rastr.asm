#define ILOW d-0.0110
#define IHIGH d0.0110
#define ISTEP d0.001

#define RLOW d-0.018
#define RHIGH d0.018
#define RSTEP d0.0005

#define INITIAL_CR d-0.014
#define INITIAL_CI d0.000

#define STEP_CR d0.0007
#define STEP_CI d0.0003

#External Labels from julia-fractal.asm
#define CR 41
#define CI 52
#define RT 40

.00 .  .01.su.0.00.00   GOTO SetUp

.03 0                   Room for formatting codes

#1. Setup return commands
su:                     Set Up
.   .  .L1.L2.0.03.28   Copy return command to A
.   .  .RT.RT.4.20.31   Return Command
.   .  .02.  .0.28.21   command for normal return
.   .  .03.  .0.28.21   command for overflow return



#2. Reset CI and CR to initial values new run
rt:                     ReseT
.   .  .L1.L2.1.03.28   Initial Cr -> AR
.   INITIAL_CR
.   .  .CR.  .1.28.04   AR -> Cr

.   .  .L1.L2.1.03.28   Initial Ci -> AR
.   INITIAL_CI
.   .  .CI.dr.1.28.04   AR -> Ci



#4. Draw the new image
dr:
                        Print a CR and a period
.   .  .L1.L2.1.03.28   AR = Format Newline
.   b010 011 001 000 000 000 000 000 000 00
.   .  .03.  .1.28.03   03:03 = AR
.   .  .L2.  .0.08.31   Output AR to typewriter
.%3 .  .L0.L0.0.28.31   Wait for IOReady

                        Reset Imaginary Position
.%0 .  .L1.L2.1.03.28   Imaginary Start -> AR
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
.   .  .%0.  .1.23.28   Ci -> AR
.L3 .  .L1.L2.1.03.29   AR += Step
is:
.od ISTEP               Imaginary Step
.   .  .%0.  .1.28.23   AR -> Ci

                        if ci > IHIGH then HALT
.L5 .  .%0.  .1.23.28   Ci -> AR
.L4 .  .L1.L2.3.03.29   Subtract end point
.   IHIGH               
.   .  .L2.  .0.22.31   Test AR sign
.L3 .  .L2.dn.0.00.00   if AR >= 0 GOTO Done

                        Reset Real Position
.   .  .L1.L2.1.03.28   Real Start -> AR
.   RLOW                
.   .  .%1.  .1.28.23   AR -> Cr

nc:                     Next Character loop start
                        
                        Cr = Cr + RSTEP
.L5 .  .%1.  .1.23.28   Cr -> AR
.%2 .  .L1.L2.1.03.29   AR += Step
rs:
.od RSTEP               
.   .  .%1.  .1.28.23   AR -> Cr


###CALL FRACTAL CODE
.%2 . w.tp.00.4.21.31   GOSUB 2.0 Line 2 instruction zero

tp:                     TyPe out value in AR
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


#3. Set up for a new image
dn:                     DoNe with Image
# add a little to CI
.   .  .CI.  .1.04.28   Ci -> AR
.   .  .L1.L2.1.03.29   AR +=
.   STEP_CI
.   .  .CI.  .1.28.04   AR -> Ci

# Add a little to CR
.   .  .CR.  .1.04.28   Cr -> AR
.   .  .L1.L2.1.03.29   AR +=
.   STEP_CR
.   .  .CR.  .1.28.04   AR -> Cr

#If CR is big, reset
.   .  .L1.L2.1.03.29   AR -= following value
.   d-0.003
.   .  .L2.  .0.22.31   Test AR sign
.   .  .L2.rt.0.16.31 - if AR >= 0 HALT goto reset
.   .  .L1.dr.0.00.00   GOTO DRaw