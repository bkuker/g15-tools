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

#define .. 010010

#define Th 000000
#define Sx 000001
#define Et 000010
#define Qu 000100
#define QS 000101
#define Ha 001000

# As Binary
#           C   N1    D1 C   N2    D2     
#   b110101 000101 000011 000110 00010 0

# N1 is played 30ms before N2.
# V2 is played 30ms before V3

#           .. V3  yy V2   Should play at the same time
#           yy V2  .. V3   60ms delay
# write amplifier of line 2 and the read amplifier of line 3, 

#85ms between lines
# delays
#   0   85ms 
#   1   142ms
#   2   203ms

#       About 60ms per delay

#30ms internote delay on one line
.00 +0

#BLOCK A1
.   b Sx kk  V3 E2  V2 0
.   b Sx ..  V2 E2  V2 0

.   b Sx E3  V3 ..  V2 0
.   b Sx ..  V3 E2  V2 0
.   b Sx ..  V2 E2  V2 0
.   b Sx D3  V3 ..  V2 0
.   b Sx ..  V3 E2  V2 0
.   b Sx ..  V2 E2  V2 0
.   b Sx C3  V3 ..  V2 0
.   b Sx ..  V3 E2  V2 0
.   b Sx ..  V2 E2  V2 0
.   b Sx A#2 V3 ..  V2 0

.   b Sx kk  V3 E2  V2 0
.   b Sx ..  V2 E2  V2 0
.   b Sx B2  V3 ..  V2 0
.   b Sx C3  V3 ..  V2 0

.   b Sx ..  V3 E2  V2 0
.   b Sx ..  V2 E2  V2 0
.   b Sx E3  V3 ..  V2 0
.   b Sx ..  V3 E2  V2 0
.   b Sx ..  V2 E2  V2 0
.   b Sx D3  V3 ..  V2 0
.   b Sx ..  V3 E2  V2 0
.   b Sx ..  V2 E2  V2 0

#Skip to Arp one after 3
#Block A2
.   b Sx C3  V3 ..  V2 0
.   b Sx ..  V3 E2  V2 0
.   b Sx ..  V2 E2  V2 0
.   b Ha A#2 V3 E2  V2 0
.   b Sx ..  V2 ..  V2 0

#back to zero
#BLOCK A1
.   b Sx kk  V3 E2  V2 0
.   b Sx ..  V2 E2  V2 0

.   b Sx E3  V3 ..  V2 0
.   b Sx ..  V3 E2  V2 0
.   b Sx ..  V2 E2  V2 0
.   b Sx D3  V3 ..  V2 0
.   b Sx ..  V3 E2  V2 0
.   b Sx ..  V2 E2  V2 0
.   b Sx C3  V3 ..  V2 0
.   b Sx ..  V3 E2  V2 0
.   b Sx ..  V2 E2  V2 0
.   b Sx A#2 V3 ..  V2 0
.   b Sx ..  V3 E2  V2 0
.   b Sx ..  V2 E2  V2 0
.   b Sx B2  V3 ..  V2 0
.   b Sx C3  V3 ..  V2 0

.   b Sx ..  V3 E2  V2 0
.   b Sx ..  V2 E2  V2 0
.   b Sx E3  V3 ..  V2 0
.   b Sx ..  V3 E2  V2 0
.   b Sx ..  V2 E2  V2 0
.   b Sx D3  V3 ..  V2 0
.   b Sx ..  V3 E2  V2 0
.   b Sx ..  V2 E2  V2 0

#Skip to Arp one after 3

#Arpeggio One
.   b Th D#4 V2 C4 V3 0
.   b Th E4  V2 B3 V3 0
.   b Th F#4 V2 A4 V3 0
.   b Th G4  V2 D#4 V3 0
.   b Th B3  V2 F#4 V3 0
.   b Th G4  V2 A4 V3 0
.   b Th B4  V2 A4 V3 0
.   b Th G4  V2 F#4 V3 0

#BLOCK A + Drum
#0
.   b Sx kk  V3 E2  V2 0
.   b Sx ..  V2 E2  V2 0
.   b Sx E3  V3 ss  V2 0
.   b Sx ..  V3 E2  V2 0
#1
.   b Sx kk  V2 E2  V2 0
.   b Sx D3  V3 kk  V2 0
.   b Sx ss  V3 E2  V2 0
.   b Sx ..  V2 E2  V2 0
#2
.   b Sx C3  V3 kk  V2 0
.   b Sx ..  V3 E2  V2 0
.   b Sx ss  V2 E2  V2 0
.   b Sx A#2 V3 ..  V2 0
#3
.   b Sx kk  V3 E2  V2 0
.   b Sx ..  V2 E2  V2 0
.   b Sx B2  V3 kk  V2 0
.   b Sx C3  V3 ..  V2 0

#0
.   b Sx kk  V3 E2  V2 0
.   b Sx ..  V2 E2  V2 0
.   b Sx E3  V3 ss  V2 0
.   b Sx ..  V3 E2  V2 0
#1
.   b Sx kk  V2 E2  V2 0
.   b Sx D3  V3 ..  V2 0
.   b Sx ss  V3 E2  V2 0
.   b Sx ..  V2 E2  V2 0

#2
.   b Sx C3  V3 kk  V2 0
.   b Sx ..  V3 E2  V2 0
.   b Sx ss  V2 E2  V2 0
#3 & 4
.   b Ha A#2 V3 E2  V2 0


.   b Th ..  V3 ..  V2 0
