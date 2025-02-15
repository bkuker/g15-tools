# Bendix G-15 Software tools

Assembler, disassembler and assorted tools for the Bendix G15.

Assembler is too strong a word, it encodes programs written in the G15 decimal format (similar to the paper programming problem worksheet) into binary words and then outputs them as a [.pti file](https://github.com/retro-software/G15-software/).

You can run the programs on Paul Kimpel's [Bendix g15 Emulator](https://www.phkimpel.us/Bendix-G15/).


## Getting Started

These tools are written in TypeScript because I love you.

Also because huge inspiration and help came from Paul's web based emulator, and I envision these tools being used to add the ability to program his emulator via an integrated web based interface.

You will need to install npm to use them on the command line, and then `npm ci` to install the required libraries.

**⚠️ WARNING:** Windows users, powerShell seems do output redirection in UTF-16 or something terrible. Use `cmd.exe`.

## Assembler

The assembler converts a file of decimal instructions to 29-bit instruction words, and outputs them to STDOUT in .pti paper tape image format.

The `--words` option outputs the program words in G15 hex, not a .pti file.

The `--bootable` option will output the Number Track prior to the program code.

### Example

```
C:\Users\bkuker\g15-tools\programs>npm run asm -- fib.asm

# fib.asm
00000000000000000000000000000/
...⊘ OUTPUT SKIPPED ⊘...
00000000000000000000000000000/
00000004z823w0280390713w1uz00/
9z0w41w5005vw027w2u0753w12838/
070739z000000001w1w47x3w0u838/
0000000021515z8080898002044w0S
```

## Disassembler

The disassembler converts a .pti tape image file to an assembly program.

**⚠️ WARNING:** This only works on .pti files containing a single block of code, no number track.

By default it will perform a rudimentary static analysis, reordering code locations to match the order in which they are executed. It inserts a blank line after any line of code that does not simply jump to the next line. Continuous blocks of code are therefor output, making manual interpretation easier. You will likely still need to perform some rearraingement of these blocks to make source code organized and logical.

The `--nostatic` option disables this, code will be output in location order, from 0-u7.

The `--entrypoints` or `-e` option allows you to provide a comma seperated list of entry points for this analysis, default is `0`.

Output is to STDOUT, you might want to redirect the output to a file.



### Example:

```
C:\Users\bkuker\g15-tools\programs\music>npm run dasm -- m1.pti --entrypoints 0,49   

#m1.pti
.00 . u.01.02.0.19.00    i TR 19:1 > 0:1 #108
.02 .  .04.04.0.21.31    i MARK:3, CD=0 #1
.04 .  .u7.05.3.19.28    d SU 19:107 > AR
.05 . u.06.06.1.19.29    i AD 19:6 > AR+ #108

...⊘ OUTPUT TRUNCATED ⊘...
```

## Tracer
This is a work in progress :)

