//Assembler is too big a word for this.
//Its a .... Encoder.


/*
These are @UsagiElectric's notes from Discord

.13 s  .15.16.0.00.28    Number track checks; 111111 to AR
.16 .  .19.20.0.00.23    Format to Line 23, 3

.LL S P.TT.NN.C.SS.DD BP
     .LL  0 > Location of instruction on drum
      S   0 > ???
      P   1 > Prefix U or W, controls block command and normal command
     .TT  7 > T or LK:
            T  - Timing number, the address in the line where the operand is
            LK - Word position of the command plus K
     .NN  7 > Word location of the next instruction
     .C   3 > Characteristic, 
     .SS  5 > Source, the line where the operand is located
     .DD  5 > Destination, the line where the operand will be located
      BP  1 > Break Point, CPU pause on - here and switch in BP
*/

import path from "path";
import os from "os";
import * as convert from "./conversionUtils";
import { formatCommand, parseAsmProgram } from "./instructionUtils";
import * as tape from "./tapeUtils";
import { ASM, Numbers as N } from "./AsmTypes";
import { Command } from 'commander';
import numberTrack from './numberTrack.js';
import { preprocess, blockChop } from "./Preprocess";
import analyze from "./analyzer";
import { MinimalAdder } from "./MinimalAdder";

//If running from "npm run" change back
//to the directory the user ran the program from
if (process.env.INIT_CWD) {
    process.chdir(process.env.INIT_CWD);
}

//Command line stuff
const commandLine = new Command();
commandLine
    .option('--words', 'Output words, not pti')
    .option('--resolved', 'Output resolved code, not pti')
    .option('--ptr', "Output Paper Tape Reversed (PTR) binary")
    .option('--time', 'Analyze time')
    .option('--bootable', 'Output a number track before the program block')
    .argument('<assembly file name>');
commandLine.parse();

const fileName = commandLine.args[0];


let blocks: ASM.Line[][] = blockChop(preprocess(fileName));

let pti = "";

for (let b = 0; b < blocks.length; b++) {
    //TODO Deal with line number
    let program: ASM.Line[] = parseAsmProgram(blocks[b]);

    //Order the program by location (Constants and Instructions only)
    let line: ASM.Loc[] = [];
    for (let cmd of program.filter((o: any): o is ASM.Loc => typeof o.l === 'number')) {
        if (line[cmd.l] != undefined) {
            throw `Location ${cmd.l} duplicated. Lines ${line[cmd.l].sourceLineNumber} & ${cmd.sourceLineNumber}`;
        }
        line[cmd.l] = cmd;
    }

    let checksumLocation = -1;

    //Convert the program to an array of words at the appropriate locations
    //Also find the last unused location to store the checksum in.
    //(Not just using u7 can mean shorter tapes)
    let lineWords: N.word[] = [];
    for (let l = 0; l < 108; l++) {
        if (line[l]) {
            lineWords[l] = line[l].word;
        } else {
            lineWords[l] = 0 as N.word;
            if ( checksumLocation == -1 )
                checksumLocation = l;
        }
    }

    //Sum the words, and return that sum, negated
    //as a word.
    //
    //When inserted back into the line at a location
    //that was previously zero, the new sum of the 
    //entire line should be zero.
    function sum(lineWords : N.word[]): N.word {
        const adder = new MinimalAdder();

        adder.transferToAR(0, MinimalAdder.chAD); // initialize the checksum
        for (let word of lineWords) {
            adder.addToAR(word, MinimalAdder.chAD); //add
        }
        adder.transferToAR(adder.AR, MinimalAdder.chAD); //Decomplement
        let sum = adder.AR;

        if (sum != 0)
            sum = sum ^ 0x01;

        return sum as N.word;
    }

    let checksum = sum(lineWords);
    if (checksumLocation == -1 ){
        console.error(`Can't checksum block ${b}, no free space. ${convert.g15SignedHex(checksum)}`);
    } else {
        lineWords[checksumLocation] = checksum;
    }

    //Output
    if (commandLine.opts().time) {
        if (b != 0) {
            console.log("<BLOCK>");
        }
        analyze(program);
    } else if (commandLine.opts().resolved) {
        if (b != 0) {
            console.log("<BLOCK>");
        }
        //Output resolved code
        for (let l of program) {
            if (ASM.isInstruction(l)) {
                console.log(formatCommand(l));
            } else if (ASM.isConstant(l)) {
                console.log(`.${convert.intToG15Dec(l.l)}   ${convert.g15SignedHex(l.word).padEnd(18, " ")}${l.comment}`)
            } else {
                console.log(l.rawText);
            }
        }
    } else if (commandLine.opts().words) {
        if (b != 0) {
            console.log("<BLOCK>");
        }
        //Dump words
        for (let l = 0; l < 108; l++) {
            if (lineWords[l] != 0) {
                console.log(l.toString().padStart(3, " "), convert.g15Hex(lineWords[l]));
            }
        }
    } else {
        //Build PTI Paper tape image
        pti += "\n";
        pti += "# " + program[0].sourceFile + ":" + program[0].sourceLineNumber + "\n";
        pti += "# Block " + b + "\n";
        pti += tape.lineToTape(lineWords);
        pti += "\n";
    }
}

if ( pti ){
    let header = "";
    header += `# File:\t${path.resolve(fileName)}\n`;
    header += `# User:\t${os.userInfo().username}\n`;
    header += `# Host:\t${os.hostname()}\n`;
    header += `# Date:\t${new Date()}\n`;

    if (commandLine.opts().bootable) {
        pti = numberTrack + "\n\n" + pti;
    }

    pti = header + pti;
    
    if ( commandLine.opts().ptr ){
        process.stdout.write(new Uint8Array(tape.ptiToPtr(pti)));
    } else {
        console.log(pti);
    }
}