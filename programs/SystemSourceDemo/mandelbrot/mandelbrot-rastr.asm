#define ILOW d-0.0110
#define IHIGH d0.0110
#define ISTEP d0.0040

#define RLOW d-0.021
#define RHIGH d0.0052
#define RSTEP d0.0016


#1. Setup return commands
su:                     Set Up
#define RT 40
.00 .  .L1.L2.0.00.28   Copy return command to A
.   .  .RT.RT.2.20.31   Return Command
.   .  .02.  .0.28.21   command for normal return
.   .  .03.  .0.28.21   command for overflow return
.   .  .01.sz.0.00.00   GOTO sz

st:                     Start
                        Reset Imaginary Position
.08 .  .L1.L2.1.00.28   Imaginary Start -> AR
.   ILOW                
.   .  .00.  .1.28.23   AR -> Ci

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
is:
.od ISTEP               Imaginary Step
.   .  .00.  .1.28.23   AR -> Ci

                        if ci > IHIGH then HALT
.   .  .00.  .1.23.28   Ci -> AR
.   .  .L1.L2.3.00.29   Subtract end point
.   IHIGH               
.   .  .L2.  .0.22.31   Test AR sign
.   .  .L2.st.0.00.00 - if AR >= 0 GOTO START
                        else continue on

                        Reset Real Position
.   .  .L1.L2.1.00.28   Real Start -> AR
.   RLOW                
.   .  .01.  .1.28.23   AR -> Cr

nc:                     Next Character loop start
                        
                        Cr = Cr + RSTEP
.   .  .%1.  .1.23.28   Cr -> AR
.%2 .  .L1.L2.1.00.29   AR += Step
rs:
.od RSTEP               
.   .  .%1.  .1.28.23   AR -> Cr


###CALL FRACTAL CODE
.%2 . w.tp.00.2.21.31   GOSUB 2.0 Line 2 instruction zero

#.%2 .  .L1.L2.0.00.28   AR = ones
#.   +1111111            F3 Format code, 0 digit, CR end

tp:                     Print out value in AR
.   .  .L2.  .0.08.31   Output AR to typewriter
.L3 .  .L0.L0.0.28.31   Wait for IOReady

                        If Cr > RHIGH
                            goto nl - Next Line
                        else
                            goto nc - Next Character
.   .  .%1.  .1.23.28   Cr -> AR
.%2 .  .L1.L2.3.00.29   Subtract end point
.   RHIGH               
.   .  .L2.  .0.22.31   Test AR sign
.L3 .  .L1.nl.0.00.00   if AR >= 0 goto nl
.L1 .  .L1.nc.0.00.00   else goto nc

sz:
.   .  .ze.  .0.00.28   AR = 0
.   .  .00.  .0.28.23   AR -> 23:0
.   .  .L2.  .0.12.31   Enable Type in
.L2 .  .L0.L0.0.28.31   Wait for IOReady
.   .  .00.  .0.23.28   23:0 -> AR Load typed value into AR
.   .  .  .  .0.28.27   Ar == 0?
.   .  .  .sm.0.00.00   Goto Small
.   .  .un.  .3.00.29   AR--
.   .  .  .  .0.28.27   Ar == 0?
.   .  .  .md.0.00.00   Goto Medium
.   .  .un.  .3.00.29   AR--
.   .  .  .  .0.28.27   Ar == 0?
.   .  .  .lg.0.00.00   Goto Large
.   .  .un.  .3.00.29   AR--
.   .  .  .  .0.28.27   Ar == 0?
.   .  .  .hg.0.00.00   Goto Huge

.   .  .  .sm.0.00.00   Default Small

un:
.   d1
ze:
.   d0
sm:                     SMALL
.   .  .L1.L2.0.00.28   Load to AR
.   d0.0040
.   .  .is.  .0.28.00   Save to is
.   .  .L1.L2.0.00.28   Load to AR
.   d0.0016
.   .  .rs.st.0.28.00   Save to rs

md:                     MEDIUM
.   .  .L1.L2.0.00.28   Load to AR
.   d0.0020
.   .  .is.  .0.28.00   Save to is
.   .  .L1.L2.0.00.28   Load to AR
.   d0.0008
.   .  .rs.st.0.28.00   Save to rs

lg:                     LARGE
.   .  .L1.L2.0.00.28   Load to AR
.   d0.0010
.   .  .is.  .0.28.00   Save to is
.   .  .L1.L2.0.00.28   Load to AR
.   d0.0004
.   .  .rs.st.0.28.00   Save to rs

hg:                     HUGE
.   .  .L1.L2.0.00.28   Load to AR
.   d0.0005
.   .  .is.  .0.28.00   Save to is
.   .  .L1.L2.0.00.28   Load to AR
.   d0.0002
.   .  .rs.st.0.28.00   Save to rs