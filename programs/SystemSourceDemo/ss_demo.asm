#include "../lib/bbl.asm"
ct:                     Count
.   d6

<BLOCK>                 Block 5 Guessing Game
#include "guessingGame.asm"

<BLOCK>                 Block 4 Julia fractal Code
#include "julia/julia-fractal.asm"

<BLOCK>                 Block 3 Julia Main code
#include "julia/julia-rastr.asm"

<BLOCK>                 Block 2 Mandelbrot Fractal Code
#include "mandelbrot/mandelbrot-fractal.asm"

<BLOCK>                 Block 1 Bendix Complex Routine
#include "../lib/complex.mult.div.asm"

<BLOCK>                 Block 0 Mandelbrot Raster Code
#include "mandelbrot/mandelbrot-rastr.asm"