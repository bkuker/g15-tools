#LL S P.TT.NN.C.SS.DD BP  Comment

# Copy loaded program from 19 -> 0 and begin execution at 0:04
.00 . u.01.02.0.19.00     Line 19 to Line 0 - Test not set
.01 . u.02.02.0.19.00     Line 19 to Line 0 - Test set
.02 .  .05.05.0.21.31     Execute Line 0 GOTO 5


.04 .  .06.04.0.16.31     HALT

#COLS = ROWS
.05 .  .44.06.1.00.28     AR = ROWS
.06 .  .45.07.1.28.00     COLS = AR

.07 . w.08.52.0.21.31     GOSUB 52 Print an 8

# COLS = COLS - 1
.08 .  .45.09.1.00.28     AR = COLS
.09 .  .40.10.3.00.29     AR--
.10 .  .45.11.1.28.00     COLS = AR

.11 .  .45.12.0.00.27     COLS == 0 ? GOTO 12 else 13
.12 . w.19.54.0.21.31     GOSUB 54 Print an 8\N, GOTO 19

.13 .  .00.07.0.00.00     NOP GOTO 07

# ROWS = ROWS - 1
.19 .  .44.20.1.00.28     AR = ROWS
.20 .  .40.21.3.00.29     AR--
.21 .  .44.22.1.28.00     ROWS = AR
.22 .  .44.04.0.00.27     ROWS == 0 ? GOTO 04 else 05
 

#DATA
.40 1                     one
.41 0400000               F3 Format code, 1 digit, end
.42 4400000               F3 Format code, 0 digit, CR end
.43 8888888               eights!
.44 5                     ROWS
.45 0                     COLS

#Subroutine Print 8
.52 .  .41.53.1.00.28     AR = Format Code
.53 .  .03.56.1.28.03     03:03 = AR Format code to track 3

#Subroutine Print 8 CR
.54 .  .42.55.1.00.28     AR = Format Code
.55 .  .03.56.1.28.03     03:03 = AR Format code to track 3

#Load AR full of eights
.56 .  .43.58.1.00.28     AR = 0:43
# Print value A to typewriter
.58 .  .60.60.0.08.31     Output AR to typewriter
.60 .  .60.60.0.28.31     While !IOReady GOTO 10
.61 .  .62.61.0.20.31     RETURN

.99 .  .u1.99.0.16.31     HALT