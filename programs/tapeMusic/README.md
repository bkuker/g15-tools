This was a silly experiment for music playback.

The idea would be to load notes into the lines 4-18 (and if you are tricky 0 and 1 as well).

The program then begins a load from tape to line 19, and then jumps to 19:0.

The tape contains nothing but block copy instructions from the note lines to the output lines, each of which also has N = 0...

So the machine is constantly executing 19:0, which is also constantly being written to by the tape reader.

Because the two hardwares are not perfectly synchronized playback would be imperfect, but if longer notes repeat the same copy over and over again missing one instruction only costs a 30th of a second.

I don't like this because it's a neat hack it is not an interesting program, and I am a programmer.

It works on Paul's emulator, don't know if it would work in the real thing