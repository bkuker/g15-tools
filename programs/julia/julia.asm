#include "../lib/bbl.asm"
ct:                     Count
.   d3

<BLOCK>                 Block 2 Fractal Code
#include "julia-fractal.asm"

<BLOCK>                 Block 1
#include "../lib/complex.mult.div.asm"

<BLOCK>                 Block Raster Code
#include "julia-rastr.asm"