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
import * as util from "./assemblerUtils";
import * as tape from "./tapeUtils";
import { ASM, Numbers as N } from "./AsmTypes";
import { Command } from 'commander';

//If running from "npm run" change back
//to the directory the user ran the program from
if (process.env.INIT_CWD) {
    process.chdir(process.env.INIT_CWD);
}

//Command line stuff
const commandLine = new Command();
commandLine
    .option('--words', 'Output words, not pti')
    .option('--bootable', 'Output a number track before the program block')
    .argument('<string>');
commandLine.parse();

const fileName: string = commandLine.args[0];
const data: string = fs.readFileSync(fileName, 'utf-8'); // Read file synchronously
const lines: string[] = data.split(/\r?\n/); // Split into lines

function parseLine(rawText: string): ASM.Line {

    //TODO Create ASMLines
    if (rawText.trim().startsWith("#") || rawText.trim().length == 0) {
        return {
            sourceLineNumber: 0,
            rawText
        };
    }

    //Each line follows the pattern:
    //  LL S P.TT.NN.C.SS.DD BP
    //Taken from the programming problem worksheet
    //and various published source listings.

    //Extract the Location and s columns
    let l = util.g15DecToInt(rawText.substring(1, 3) as N.g15Dec);
    let s = rawText.substring(4, 5) as ASM.sType;

    if (s == "." || s == "s") {
        //If s is "." or "s" this is an instruction

        //Extract the rest
        let p = rawText.substring(6, 7) as ASM.prefixType;
        let t = rawText.substring(8, 10) as N.g15Dec;
        let n = rawText.substring(11, 13) as N.g15Dec;
        let c = rawText.substring(14, 15);
        let src = rawText.substring(16, 18);
        let dst = rawText.substring(19, 21);
        let bp = rawText.substring(22, 23);
        let comment = rawText.substring(24).trim();

        //Place into an object
        let cmd: ASM.Instruction = {
            rawText,
            l,
            s,
            p,
            t: util.g15DecToInt(t),
            n: util.g15DecToInt(n),
            c: +c,
            src: +src,
            dst: +dst,
            bp: bp.trim().length > 0,
            comment,
            word: 0 as N.word
        }

        //This is the command's actual binary value as an integer
        cmd.word = util.commandToInstructionWord(cmd);

        return cmd;
    } else {
        //TODO: Support double precision constants?

        //There was not a "." or "s" in the s column...
        //This is a constant in +/- hex form
        let val: N.signedG15Hex = rawText.substring(4, 20).trim() as N.signedG15Hex;

        //Separate sign bit from absolute value hex
        let neg = false;
        let abs: N.g15Hex;
        if (val.startsWith("-")) {
            abs = val.substring(1) as N.g15Hex;
            neg = true;
        } else {
            abs = val as string as N.g15Hex;
        }

        //convert the abs to an integer
        let valNum = util.g15HexToDec(abs);

        //Convert that integer and sign into the
        //raw g15 word
        let word = Math.abs(valNum) << 1;
        if (neg) {
            word = word | 0x01;
        }

        //Extract the comment
        let comment = rawText.substring(24).trim();

        //Place into an object
        let data: ASM.Constant = {
            rawText,
            l: l,
            word: word as N.word,
            value: valNum * (neg ? -1 : 1),
            comment
        }
        return data;
    }

}

let program: ASM.Line[] = []; //The commands and comments in PROGRM order, not location order
let sourceLineNumber = 0;
for (const rawText of lines) {
    let line: ASM.Line = parseLine(rawText);
    line.sourceLineNumber = sourceLineNumber++;
    program.push(line);
}

//Order the program by location (Constants and Instructions only)
let line: ASM.Loc[] = [];
for (let cmd of program.filter((o: any): o is ASM.Loc => typeof o.l === 'number')) {
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

if (commandLine.opts().words) {
    //Dump words
    for (let l = 0; l < 108; l++) {
        if (lineWords[l] != 0) {
            console.log(l.toString().padStart(3, " "), util.g15Hex(lineWords[l]));
        }
    }
} else {
    //Output PTI Paper tape image
    let pti = "";
    if (commandLine.opts().bootable) {
        pti += numberTrack() + "\n\n";
    }
    pti += "# " + fileName + "\n" + tape.lineToTape(lineWords);
    console.log(pti);
}

function numberTrack(): string {
    let nt = `# Number Track
-1414794z5v58003u9u8001x2x2000/
y86800073v380039998001wuwu000/
y46400071v180038988001w2w2000/
y0600006zuz80037978001vuvu000/
xw5w0006xux80036968001v2v2000/
x8580006vuv80035958001uuuu000/
x45400069u980034948001u2u2000/
x05000067u7800339380019u9u000/
ww4w00065u5800329280019292000/
w84800063u3800319180018u8u000/
w44400061u1800309080018282000/
w0400005z9z8002z8z80017u7u000/
vw3w0005x9x8002y8y80017272000/
v8380005v9v8002x8x80016u6u000/
v43400059998002w8w80016262000/
v03000057978002v8v80015u5u000/
uw2w00055958002u8u80015252000/
u8280005393800298980014u4u000/
u4240005191800288880014242000/
u0200004z8z800278780013u3u000/
9w1w0004x8x800268680013232000/
98180004v8v800258580012u2u000/
94140004989800248480012222000/
90100004787800238380011u1u000/
8w0w0004585800228280011212000/
88080004383800218180010u0u000/
84040004181800208080010202000S`

    return nt;
}