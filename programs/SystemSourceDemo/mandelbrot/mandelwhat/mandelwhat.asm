#include "../lib/bbl.asm"
ct:                     Count
.   d4

<BLOCK>                 Block 3 AR Format
.02 b0 001 000 000 000 000 000 000 000 000 0
.03 b100 011 000 000 000 000 000 000 000 01

<BLOCK>                 Block 2 Fractal Code
#include "fractalwhat.asm"

<BLOCK>                 Block 1 Complex Multiplication
#include "../lib/complex.mult.div.asm"

<BLOCK>                 Block 0 test code
#define TEST_I d0.000
#define TEST_R d-0.005

                        Load imaginary part of test value
.00 .  .L1.L2.0.00.28   Imaginary Test -> AR
.   TEST_I                
.   .  .00.  .0.28.23   AR -> Ci
                        Load real part of test value
.   .  .L1.L2.0.00.28   Real Start -> AR
.   TEST_R                
.   .  .01.  .0.28.23   AR -> Cr

###CALL FRACTAL CODE
.   . w.tp.00.2.21.31   GOSUB 2.0 Line 2 instruction zero

tp:
.   .  .L2.  .0.08.31   Output AR to typewriter
.L3 .  .L0.L0.0.28.31   Wait for IOReady
.   .  .L2.00.0.16.31   HALT