.49 .  .56.59.0.00.28    AR = Track 0 Load
.59 .  .61.48.0.28.00    0:61 = AR
.48 .  .60.62.4.00.26    PN:0 = 0:60, PN:1 = 0:61

#Song Loop
.62 .  .63.64.1.26.28    Load Music Data Load instruction from PN:1 to AR
.64 .  .66.66.0.31.31    NC from AR
#AR        68
.68 .  .70.72.4.28.21    Copy Music data from AR to 21:2 & 3 (DP = Two copies)
.72 .  .75.76.0.31.28    AND Music data in 21.3 with 20.3 To extract Note number
.76 .  .77.78.0.28.27    If AR == 0 GOTO 78 else GOTO 79

.79 .  .80.81.0.28.29    AR = AR * 2? AKA Shift left
.81 .  .82.84.0.00.29    AR += 0:82
.84 .  .86.86.0.31.31    NC from AR
#AR                      Play Note X (Copy note to line 19)
.10 .  .90.91.2.31.28    Note Data & -000000z Extract 4 bits length

.91 .  .92.93.0.28.27    IF AR == 0 GOTO 93
.94 . w.95.67.3.00.29    AR--
.67 .  .67.66.0.00.00    GOTO 66 (1 rotation delay)
.66 .  .66.91.0.00.00    GOTO 91


.93 .  .94.97.0.21.28    Load music data from 21:2 to AR
.97 . u.u0.u0.4.00.30    Adjust PN with values in 0:98, 0:99

#Stacatto / Legatto code
# If AR is neagative copy 0s to track 19 for one revolution
# Otherwise NOP
.u0 .  .u2.u2.0.22.31    TEST AR-SIGN
.u2 . u.u3.u4.0.00.00    AR Positive? Skip to 104
.u3 . u.u4.u4.0.29.19    AR Negative? Zero out track 19 TR (20.IR):0 > 19:104 #108

.u4 .  .u6.18.0.26.27    IF PN == 0 GOTO 18 else GOTO 19

.19 .  .20.62.0.00.00    NOP GOTO 62


.78 .  .82.83.0.31.28    
.83 .  .85.85.0.22.31    
.85 . u.86.10.0.29.19



.18 .  .49.52.0.16.31    
.52 .  .46.69.0.00.28    
.69 .  .71.63.0.15.31    
.63 .  .63.63.0.28.31    






#DATA

#Base of dynamic instructions to load music data from track 1,2 or 3
.56 10088078     d   0  68 0  1 28       56: d TR 1:0 > AR, nL=1, N=68*
.57 100880v8     d   0  68 0  2 28       57: d TR 2:0 > AR, nL=1, N=68*
.58 100880z8     d   0  68 0  3 28       58: d TR 3:0 > AR, nL=1, N=68*

.60 0x800000     i 108   0 0  0  0       60: i TR 0:61 > 0:61 #47, nL=0, N=0*
.61 10088078     d   0  68 0  1 28       61: d TR 1:0 > AR, nL=1, N=68*

#Base of dynamic note set instruction
.82 0uy140y6     i  87  10 0  3 19       82: i TR 3:83 > 19:83 #4, nL=87, N=10*

.95 1                                    Constant 1