## Scaling

Values are scaled by 10^-2. This was chosen by the author of
the complex multiplication routine. It costs some precision
but I am not planning to re-write that.

2.0 for example would be d0.02000

## Constants

RLOW, RSTEP and RHIGH determine the range of the output graphics on the real (left/right) axis. The Ixxx constants do the same on the imaginary (vertical) axis.

Take care in chosing these so that the width does not exeed your printer's platen.

## Line Usage

00: Mandelbrot Progran
01: Complex Multiplication (CM)
03: Print AR format code

20:
    0:          CM Imainary return value / Zi
    1:          CM Real return value / Zr
    2,3:        CM working registers
21:
    2,3:        CM return instructions
22:
    0,1,2,3:    CM input

23:
    0:          Ci imaginary part of C
    1:          Cr real part of C
    2:          ct Iteration Count

MP,PN,ID:       CM working registers

## Fractal code notes

Old

Clear count
Load C -> Z
Load Z -> 22.0,1,2,3
Call Complex Mult
    Z^2 in 20.1,0
Z = Z^2 + C
if |zr| > 2 goto ot
if |zi| > 2 goto ot
ct = ct + 1
if ct > limit goto in
else goto lp

New

Clear count
Load 23:0,1 (Ci,Cr) -> 20:0,1 (Zi,Zr)
lp:
Copy 20:0,1 (Zi,Zr) to
    22:0,1 (P2i,P2r)
    22:2,3 (P1i,P1r)
Call CM
    20:0,1 (Zi,Zr) = Z^2
Zi = Zi + Ci
Zr = Zr + Zr

if |zr| > 2 goto ot
if |zi| > 2 goto ot
ct = ct + 1
if ct > limit goto in
else goto lp

## Performance:
Old:
                Number of instructions executed:  2841720
                     Number of drum revolutions:  3811118
Move return copy out of loop:
                Number of instructions executed:  2673925
                     Number of drum revolutions:  3475527
Tiny optimization at beginning of nc: using % mnemonic:
                Number of instructions executed:  2673925
                     Number of drum revolutions:  3470574
2 line version
                Number of instructions executed:  2693595
                     Number of drum revolutions:  2933326

Starting Point:
                114,364,221 WT
Current:
                 30,625,248 WT
Remove extra return copies
    30,280,823