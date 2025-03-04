#define V2 00010
#define V3 00011

#define A2 010000
#define A3 110000
#define A#2 001111
#define A4 101111
#define B2 001110
#define B3 101110
#define B4 001101
#define B5 101101
#define C3 001100
#define C4 101100
#define F#4 001011
#define C5 101011
#define D#3 001010
#define D#4 101010
#define D3 001001
#define D4 101001
#define E2 001000
#define E3 101000
#define E4 000111
#define E5 100111
#define F3 000110
#define F4 100110
#define G3 000101
#define G4 100101
#define kk 000100
#define ss 100100

#define xx 010010

# As Binary
#           C   N1    D1 C   N2    D2     
#   b110101 000101 00011 000110 00010 0

# N1 is played before N2.

.00 +0
#   Delay   N1 D1 N2 D2 0
.   b000000 xx V3 xx V2 0

.   b000000 xx V3 E2 V2 0
.   b000000 xx V2 E2 V2 0

.   b010000 E3 V3 E3 V2 0

.   b000000 xx V3 E2 V2 0
.   b000000 xx V2 E2 V2 0

.   b100000 D3 V3 D3 V2 0

.   b000000 xx V3 E2 V2 0
.   b000000 xx V2 E2 V2 0

.   b000000 C3 V3 C3 V2 0

.   b000000 xx V3 E2 V2 0
.   b000000 xx V2 E2 V2 0

.   b000000 A#2 V3 A#2 V2 0

.   b000000 xx V3 E2 V2 0
.   b000000 xx V2 E2 V2 0

.   b000000 E2 V3 B2 V2 0
.   b000000 xx V3 C3 V2 0


.   b000000 xx V3 E2 V2 0
.   b000000 xx V2 E2 V2 0

.   b000000 E3 V3 E3 V2 0

.   b000000 xx V3 E2 V2 0
.   b000000 xx V2 E2 V2 0

.   b000000 D3 V3 D3 V2 0

.   b000000 xx V3 E2 V2 0
.   b000000 xx V2 E2 V2 0

.   b000000 C3 V3 C3 V2 0

.   b000000 xx V3 E2 V2 0
.   b000000 xx V2 E2 V2 0

.   b000000 E2 V3 A#2 V2 0