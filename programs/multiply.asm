#I always thought something was fundamentally wrong with the universe

.00 . u.01.01.0.19.00     Line 19 to Line 0 - Test not set
.01 .  .03.  .0.21.31     Jump to 0:2 TODO Empty N breaks things

#This code must be here because it copies to 3:3 for formatting
                          Set up formatting
.02 .  .03.11.0.00.03     0:3 -> 3:3 Copy format code to line 3, goto 4
.03 0000044               Format code, no sign no decimal, line feed.

.11 .  .L3.  .0.23.31     Clear stuff
.12 .  .51.  .0.00.25     Load .51 as multiplicand -> ID.1
.13 .  .53.  .0.00.24     Load .53 as multiplier   -> MQ.1
.15 .  .56.  .0.24.31     Multiply                 -> ID.1 * MQ.1 -> PN.0,1

                          Shift result 1 bit right for... reasons?
.16 .  .00.  .4.26.25     PN -> ID
.17 .  .02.  .1.26.31     Shift ID 1 bit right
.18 .  .18.  .1.25.28     ID.0 -> ARc
.19 .  .19.  .1.28.25     ARc -> ID.1

                          Print result
.   .  .L2.  .0.08.31     Output AR to typewriter
.   .  .L0.L0.0.28.31     Wait here for IOReady
.   .  .L2.L0.0.16.31     HALT
.51   d6                   six
.53   d7                   seven