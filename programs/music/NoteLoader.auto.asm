
#Move execution to line zero
.00 . u.01.02.0.19.00    Copy Line 19 to 0
.02 .  .04.04.0.21.31    Goto 0:4

#Some kind of checksum! 
.04 .  .u7.05.3.19.28    Load 19:107 > AR (AR = -30984)  
.05 . u.06.06.1.19.29    Sum line 19 to AR
.06 .  .07.08.0.28.27    If AR == 0 GOTO 8 ELSE GOTO 9
.09 .  .11.09.0.16.31    HALT

#Loop, load next 15 tape blocks into lines 4-18 
.08 .  .22.23.1.00.28    AR = TRACKS_TO_LOAD (-16 to start)
.23 .  .95.25.1.00.29    AR += ONE
.25 .  .26.27.0.28.27    If AR == 0 GOTO 27 else GOTO 28

.28 .  .30.30.0.15.31    Read Tape to Line 19
.30 .  .22.32.1.28.00    TRACKS_TO_LOAD = AR (Save for later)
.32 .  .33.34.0.00.29    AR += COPY_INSTRUCTION
.34 .  .34.34.0.28.31    Wait for IOReady
.35 .  .37.37.0.31.31    Next Command from AR
#AR        08            Copy Line 19 to Track Number + 4, GOTO 8

#Loop done, not sure what this does yet
.27 .  .36.u6.4.00.25    d DP-TR 0:36 > ID:0, nL=38, N=106*
.u6 . u.01.39.0.25.00    TR ID:1 > 0:107 #2, nL=1, N=39*
.39 . u.44.00.0.00.20    TR 0:40 > 20:0 #4, nL=44, N=0*

 
#DATA

#TRACKS_TO_LOAD:
.22	-16		Number of tracks to load, decrements each time through loop.
#ONE:
.95	1		The constant 1
#COPY_INSTRUCTION:
.33	04w104y6  	TR 19:34 > 19:34 #4, nL=38, N=8* Copy instruction, modified then executed from AR