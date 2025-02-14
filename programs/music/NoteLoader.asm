#i/d T   N C  S  D DP BP  L  Interpretation

#LL S P.TT.NN.C.SS.DD BP  Comment


#Move execution to line zero
.00 . u.01.02.0.19.00   Copy Line 19 to 0
.02 .  .04.04.0.21.31   Goto 0:4

#Some kind of checksum! 
.04 .  .u7.05.3.19.28   Load 19:107 > AR (AR = -30984)
.05 . u.06.06.1.19.29   Sum line 19 to AR
.06 .  .07.08.0.28.27   If AR == 0 GOTO 7 ELSE GOTO 8


#Loop, load next 15 tape blocks into lines 4-18 
# for ( TRACKS_TO_LOAD = -16; TRACKS_TO_LOAD != 0; TRACKS_TO_LOAD++ ) {
.08 .  .22.23.1.00.28   AR = TRACKS_TO_LOAD (-16 to start)
.23 .  .95.25.1.00.29   AR += ONE
.25 .  .26.27.0.28.27   If AR == 0 GOTO 27 else GOTO 28

#Executed 15 times
.28 .  .30.30.0.15.31   Read Tape to Line 19
.30 .  .22.32.1.28.00   TRACKS_TO_LOAD = AR (Save for later)
.32 .  .33.34.0.00.29   AR += COPY_INSTRUCTION
.34 .  .34.34.0.28.31   Wait for IOReady
.35 .  .37.37.0.31.31   Next Command from AR
#AR        8            Copy Line 19 to Track Number + 4
#}




#Executed once
.27 .  .36.u6.4.00.25   d DP-TR 0:36 > ID:0, nL=38, N=106*

#i   1  39 0 25  0      106: i TR ID:1 > 0:107 #2, nL=1, N=39*
#i  44   0 0  0 20       39: i TR 0:40 > 20:0 #4, nL=44, N=0*

#Stopped Here
#i  44  44 0 28 31       44: i TEST I/O READY:45 #107, nL=44, N=44


#TRACKS_TO_LOAD:
.22	-16		Number of tracks to load, decrements each time through loop.
#ONE:
.95	1		The constant 1
#COPY_INSTRUCTION:
.33	04w104y6  	TR 19:34 > 19:34 #4, nL=38, N=8* Copy instruction, modified then executed from AR

#No idea yet, used at end of program
#0000z210  0007908      30984  0.000115424 i   0   7 2  8  8      107: i TVA 8:108 > 8:108 #0, nL=0, N=7*
##01010736  080839v    8422299  0.031375509 i   8   8 0 28 27        6: i TR AR > TEST:7 #1, nL=8, N=8*
#0045833y  022w19z    2277791  0.008485433 i   2  44 0 12 31       36: i TYPE IN:37 #73, nL=2, N=44*
#000000zy  000007z        127  0.000000473 i   0   0 0  3 31       40: i FAST PUNCH 19:41 #67, nL=0, N=0*
##00000000  0000000          0  0.000000000 i   0   0 0  0  0       21: i TR 0:22 > 0:22 #86, nL=0, N=0*

