.00 . u.01.02.0.19.00   Line 19 to Line 0 - Test not set
.01 . u.02.02.0.19.00   Line 19 to Line 0 - Test set
.02 .  .03.03.0.21.31   GOTO 0:3

.03 .  .04.07.4.00.26   Put a small value into PN
.04 0000002
.05 0000000

.07 .  .08.11.7.00.30   Subtract Zero from PN
.08 0000000
.09 0000000

.11 .  .12.14.5.26.21   Copy to 21

.14 .  .L2.00.0.16.31   Halt