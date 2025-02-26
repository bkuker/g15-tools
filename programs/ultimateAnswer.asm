#LL S P.TT.NN.C.SS.DD BP  Comment
.00 . u.01.02.0.19.00   Line 19 to Line 0 - Test not set
.01 . u.02.02.0.19.00   Line 19 to Line 0 - Test set
.02 .  .04.04.0.21.31   Execute Line 0 at T4

.04 . w.20.05.1.00.28   0.20 -> ARc
.05 . w.20.06.2.00.29   0.22 -> AR+
.06 . w.20.07.2.00.29   0.22 -> AR+
.07 . w.20.08.2.00.29   0.22 -> AR+
.08 . w.20.09.2.00.29   0.22 -> AR+
.09 . w.20.10.2.00.29   0.22 -> AR+

.10 . w.23.11.1.28.00   AR -> 00.23

.11 .  .14.14.0.08.31   Type AR
.14 .  .16.14.0.16.31   HALT

.20 +7                  Constant 7
.21 0                   Answer here

