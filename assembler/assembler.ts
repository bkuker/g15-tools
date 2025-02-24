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

import fs from "fs";
import * as convert from "./conversionUtils";
import { formatCommand, parseAsmProgram } from "./instructionUtils";
import * as tape from "./tapeUtils";
import { ASM, Numbers as N } from "./AsmTypes";
import { Command } from 'commander';
import numberTrack from './numberTrack';

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
    .option('--bootable', 'Output a number track before the program block')
    .argument('<assembly file name>');
commandLine.parse();

const fileName = commandLine.args[0];
const data = fs.readFileSync(fileName, 'utf-8'); // Read file synchronously

//Cut input into blocks
let blocks: string[] = [""];
for (let line of data.split(/\r?\n/)) {
    //TODO Also deal with line numbers
    const match = line.match( /<INCLUDE\s+src="(.*?)"/);
    if ( match ){
        const srcFile = match[1];
        let src = fs.readFileSync(srcFile, 'utf-8');
        if ( !src.endsWith("\n") ){
            src = src + "\n";
        }
        blocks[blocks.length - 1] += src;
    } else if (line.startsWith("<BLOCK")) {
            blocks.push("");
    } else {
        blocks[blocks.length - 1] += line + "\n";
    }
}

if (commandLine.opts().bootable) {
    console.log(numberTrack + "\n\n");
}

for (let b = 0; b < blocks.length; b++ ) {
    //TODO Deal with line number
    let program: ASM.Line[] = parseAsmProgram(blocks[b]);

    //Order the program by location (Constants and Instructions only)
    let line: ASM.Loc[] = [];
    for (let cmd of program.filter((o: any): o is ASM.Loc => typeof o.l === 'number')) {
        if ( line[cmd.l] != undefined ){
            console.error(`Location ${cmd.l} duplicated. Lines ${line[cmd.l].sourceLineNumber} & ${cmd.sourceLineNumber}`)
        }
        line[cmd.l] = cmd;
    }

    //Convert the program to an array of words at the appropriate locations
    let lineWords: N.word[] = [];
    for (let l = 0; l < 108; l++) {
        if (line[l]) {
            lineWords[l] = line[l].word;
        } else {
            lineWords[l] = 0 as N.word;
        }
    }

    //Output
    if (commandLine.opts().resolved) {
        if ( b != 0 ){
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
        if ( b != 0 ){
            console.log("<BLOCK>");
        }
        //Dump words
        for (let l = 0; l < 108; l++) {
            if (lineWords[l] != 0) {
                console.log(l.toString().padStart(3, " "), convert.g15Hex(lineWords[l]));
            }
        }
    } else {
        if ( b != 0 ){
            console.log("\n");
        }
        //Output PTI Paper tape image
        let pti = "";
        pti += "# " + fileName + "\n" + tape.lineToTape(lineWords);
        console.log(pti);
    }
}