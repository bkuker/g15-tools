# This program tests the assembler's instruction encoding
# for single precision math using operands at time L+1

#Expected output:
#     2u     45_
# (nice)

#LL S P.TT.NN.C.SS.DD BP  Comment

# Copy loaded program from 19 -> 0 and begin execution at 0:04
.00 . u.01.02.0.19.00     Line 19 to Line 0 - Test not set
.01 . u.02.02.0.19.00     Line 19 to Line 0 - Test set
.02 .  .04.04.0.21.31     Execute Line 0:4


# SLOW coded
# Each operand is stored much later on the drum
# So each command will be Deferred until that
# time
.04 .  .45.05.1.00.28     0:45  -> AR
.05 .  .47.06.2.00.29     0:47 +-> AR
.06 .  .49.07.1.28.00     AR -> 0:49

# Type result
.07 .  .49.08.1.00.28     0:49 -> AR
.08 .  .10.10.0.08.31     Output AR to typewriter
.10 .  .10.10.0.28.31     While !IOReady

.11 .  .00.14.0.00.00     NOP goto 14

# MAC coded 0:19 = 34 + 8
# Each operand is stored immediately following the
# relevent instruction. Assembler should emit immediate
# block commands of length 1, and will still operate
# properly
.14 .  .15.16.1.00.28     0:15  -> AR
.15 18                    34
.16 .  .17.18.2.00.29     0:17 +-> AR
.17 2d                    45
.18 .  .19.20.1.28.00     AR -> 0:19
.19 0                     Sum of 44 + 24

# Type result
.20 .  .19.21.1.00.28     0:19 -> AR
.21 .  .23.23.0.08.31     Output AR to typewriter
.23 .  .23.23.0.28.31     While !IOReady
.24 .  .00.99.0.00.00     NOP goto 99

# The operands for the SLOW version
.45 22
.47 8
.49 0



.99 .  .u1.99.0.16.31     HALT