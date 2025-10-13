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
#define kk 010001 
#define ss 000100

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
# Block 1-B
#2 & 3
.   b Sx ..  V3 C3  V2 0
.   b Sx ..  V3 E2  V2 0
.   b Sx ..  V2 E2  V2 0
.   b Ha A#2 V3 E2  V2 0
.   b Sx ..  V2 ..  V2 0

# Block 1-A
#0
.   b Sx kk  V3 E2  V2 0
.   b Sx ..  V2 E2  V2 0
.   b Sx E3  V3 ..  V2 0
.   b Sx ..  V3 E2  V2 0
#1
.   b Sx ..  V2 E2  V2 0
.   b Sx D3  V3 ..  V2 0
.   b Sx ..  V3 E2  V2 0
.   b Sx ..  V2 E2  V2 0
#2
.   b Sx C3  V3 ..  V2 0
.   b Sx ..  V3 E2  V2 0
.   b Sx ..  V2 E2  V2 0
.   b Sx A#2 V3 ..  V2 0
#3
.   b Sx ..  V3 E2  V2 0
.   b Sx ..  V2 E2  V2 0
.   b Sx B2  V3 E2  V2 0
.   b Sx C3  V3 ..  V2 0
#0
.   b Sx kk  V3 E2  V2 0
.   b Sx ..  V2 E2  V2 0
.   b Sx E3  V3 ..  V2 0
.   b Sx ..  V3 E2  V2 0
#1
.   b Sx ..  V2 E2  V2 0
.   b Sx D3  V3 ..  V2 0
.   b Sx ..  V3 E2  V2 0
.   b Sx ..  V2 E2  V2 0
.   0

# "F4", "E4", "D#4", "F4", "A4", "G4", "F4", "D4", "F4", "G4", "A4", "B4", "A4", "G4", "F4", "D4"]
# Arpeggio One
.   b Th F4  V2 E4 V2 0
.   b Th D#4 V2 F4 V2 0
.   b Th A4  V2 G4 V2 0
.   b Th F4  V2 D4 V2 0
.   b Th F4  V2 G4 V2 0
.   b Th A4  V2 B4 V2 0
.   b Th A4  V2 G4 V2 0
.   b Sx F4  V2 D4 V2 0
.   0


# Block 2-B
#2
.   b Sx C3  V3 kk  V2 0
.   b Sx ..  V3 E2  V2 0
.   b Sx ss  V2 E2  V2 0
#3 & 4
.   b Ha A#2 V3 E2  V2 0

# Block 2-A
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
.   b Sx D3  V3 kk  V2 0
.   b Sx ss  V3 E2  V2 0
.   b Sx ..  V2 E2  V2 0
.   0


# Block 3-A
#0
.   b Sx kk  V3 A2  V2 0
.   b Sx ..  V2 A2  V2 0
.   b Sx A3  V3 ss  V2 0
.   b Sx ..  V3 A2  V2 0
#1
.   b Sx kk  V2 A2  V2 0
.   b Sx G3  V3 kk  V2 0
.   b Sx ss  V3 A2  V2 0
.   b Sx ..  V2 A2  V2 0
#2
.   b Sx F3  V3 kk  V2 0
.   b Sx ..  V3 A2  V2 0
.   b Sx ss  V2 A2  V2 0
.   b Sx D#3 V3 ..  V2 0
#3
.   b Sx kk  V3 A2  V2 0
.   b Sx ..  V2 A2  V2 0
.   b Sx E3  V3 kk  V2 0
.   b Sx F3  V3 ..  V2 0

#0
.   b Sx kk  V3 A2  V2 0
.   b Sx ..  V2 A2  V2 0
.   b Sx A3  V3 ss  V2 0
.   b Sx ..  V3 A2  V2 0
#1
.   b Sx kk  V2 A2  V2 0
.   b Sx G3  V3 kk  V2 0
.   b Sx ss  V3 A2  V2 0
.   b Sx ..  V2 A2  V2 0

# Block 3-B
#2
.   b Sx F3  V3 kk  V2 0
.   b Sx ..  V3 A2  V2 0
.   b Sx ss  V2 A2  V2 0
#3 & 4
.   b Ha D#3 V3 A2  V2 0
.   0


# Arpeggio 2
.   b Th B4  V2 G4 V3 0
.   b Th E4  V2 G4 V2 0
.   b Th B4  V2 G4 V2 0
.   b Th B4  V2 C5 V2 0
.   b Th B4  V2 G4 V2 0
.   b Th B4  V2 G4 V2 0
.   b Th B4  V2 C5 V2 0
.   b Sx E5  V2 B5 V2 0
.   0
