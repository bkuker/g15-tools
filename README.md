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

The `--resolved` option will output the program as ASM with all mnemonics resolved.

### Constants
Numerical values may be specified at a given location in several formats...
```
.01   zzzzzzz            Raw 29 bit word. Sign is LSB
.02   +56789uv1          Signed 28 bit hex value
.03   d420               Decimal integer value

#⚠️ Not done yet:
.04   d.3141562          Decimal fractional value
                         Binary value perhaps?
.05   b000 000 000 000 000 000 000 000 000 00
```

### Labels

The term SLOC (Source line of code) refers to code in source file order, NOT the order on the drum / tape. Comments & blank lines are ignored.

You may place **two character** labels in your code. They will be resolved to the next SLOC's LL value. In the following example the `ht` label may be used in place of the value 42 in your program.

```
ht:
.42 .  .44.42.0.16.31    HALT
```

### Mnemonics

Most of these mnemonics help you write simple linear code without worrying about LL and NN too much.
They also make it easier to write "relocatable" code: Code that will work without editing if you change it's location.

* Location:
    * Auto Increment: Leave LL blank for LL = (Previous SLOC).LL + 1
    * **TODO**: May add things like `+2`
    * **TODO**: May add `e!` and `o!` to mean "emit error if not even / odd"
        * Helpful with certain instructions
    * **TODO**: May add `n!` where n in 0-3 to mean "emit error if not divisible by n"
        * Helpful with short lines / 2 word registers

* Time & Next:
    * Next SLOC: Leave TT or NN blank to get (Next SLOC).LL
    * Lk: For k = 0-9, resolves to LL + k.
        * L0 gives you this line's LL value, L1 adds 1, etc
    * Label: You may use a label in place of TT or NN.

* Source & Dest:
    * **TODO** May add mnemonics like Ac, A+, ID, etc?

```
# This code is defined to start at 03, but if you were to
# change that, the remaining code needn't be edited.

                         Load AR format code to line 3
.03 .  .L2.  .0.15.31    Read next tape block
.   .  .L0.L0.0.28.31    Wait for IOReady
.   . u.  .  .0.19.03    Copy line 19 to Line 3

# This halt command can be pasted anywhere.
.   .  .L2.L0.0.16.31    HALT
```


### Example

```
C:\Users\bkuker\g15-tools\programs>npm run asm -- fib.asm

# fib.asm
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
## Bendix G-15 Programming Workdsheet UI

This project also contains a vue/vite project implementing a UI similar to the programming form that was used to write down code for the G15.

It's for fun, and for super casual hacking, but use the command line versions if you want to get anything done!

It should be available [here](https://www.billkuker.com/g15-tools/).

## Tracer
This is a work in progress :)

