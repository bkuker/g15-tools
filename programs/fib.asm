# Copy loaded program from 19 -> 0 and begin execution at 0:04
.00 . u.01.02.0.19.00     Line 19 to Line 0 - Test not set
.01 . u.02.02.0.19.00     Line 19 to Line 0 - Test set
.02 .  .04.42.0.21.31     Execute Line 0 GOTO 0:42 to set formatting

# Variables
.30 1                     A
.31 1                     B
.32 0                     C

# Print value A to typewriter
.04 .  .30.05.1.00.28     0.30 -> ARc   AR = A
.05 .  .07.07.0.08.31     Output AR to typewriter
.07 .  .07.07.0.28.31     While !IOReady GOTO 7

# C = A + B
.08 .  .30.09.1.00.28     0.30 -> ARc   AR = A
.09 .  .31.10.2.00.29     0.31 -> AR+   AR += B
.10 .  .32.11.1.28.00     AR -> 00.32   C = A + B

# A = B
.11 .  .31.12.1.00.28     AR = B
.12 .  .30.13.1.28.00     A = AR

# B = C
# GOTO :04
.13 .  .32.14.1.00.28     AR = C
.14 .  .31.04.1.28.00     B = AR, GOTO 4

#Formatting
# Default formatting is 03:03 = -8w00000 03:02 = 1000000, but
# These format codes will do no leading zero one value per line
.40 0000000              F2 Format code for 03:02
.41 0000044              F3 Format code for 03:03

# 3:02 = 1000000
.42 .  .40.43.1.00.28     AR = F2
.43 .  .02.44.1.28.03     03:02 = AR

# 03:03 = -8w00000
.44 .  .41.45.1.00.28     AR = F3
.45 .  .03.04.1.28.03     03:02 = AR, GOTO 4