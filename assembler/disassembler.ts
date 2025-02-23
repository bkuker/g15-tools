import fs from "fs";
import assert from "assert";
import * as convert from "./conversionUtils";
import { commandToInstructionWord, formatCommand } from "./instructionUtils";
import disassembleWord from "./PaulDecoder.js";
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
    .option('--nostatic', 'Do not perform static analysis.')
    .option('-e, --entrypoints <entry points>', 'Comma separated list of entry points for static analysis')
    .argument('<pti tape file>');
commandLine.parse();

const fileName = commandLine.args[0];

const data = fs.readFileSync(fileName, 'utf-8'); // Read file synchronously
const lines = data.split(/\r?\n/); // Split into lines

let block = tape.tapeToWords(data);

//Pad block to length
while (block.length < 108) {
    block.push(0 as N.word);
}

function parseWordToRaw(word) {

    let value = word >> 1;
    let sign = word & 1;
    let signCode = (sign ? "-" : " ");
    let signedValue = (sign ? -value : value);

    // Decode the instruction
    let dp = word & 0x01;             // single/double mode
    let d = (word >> 1) & 0x1F;      // destination line
    let s = (word >> 6) & 0x1F;      // source line
    let c = (word >> 11) & 0x03;     // characteristic code
    let n = (word >> 13) & 0x7F;     // next command location
    let bp = (word >> 20) & 0x01;     // breakpoint flag
    let t = (word >> 21) & 0x7F;     // operand timing number
    let p = (word >> 28) & 0x01;     // prefix (immediate/deferred execution) bit

    let raw = {
        p, t, n, c, s, d, bp, dp, word
    }

    return raw;
}

function rawToString(raw) {
    return ("id").at(raw.p) +
        raw.t.toString().padStart(4, " ") +
        raw.n.toString().padStart(4, " ") +
        (raw.dp * 4 + raw.c).toString().padStart(2, " ") +
        raw.s.toString().padStart(3, " ") +
        raw.d.toString().padStart(3, " ") +
        (raw.dp ? "1" : "").padStart(2, " ") +
        (raw.bp ? "b" : "").padStart(3, " ");
}

function rawToCommand(raw) {
    //U - Immediate
    //W - Deferred
    let cmd: ASM.Instruction = {
        l: 0,
        s: ".",
        p: raw.p == 1 ? "w" : "u",  //TODO Blank if it would not change result
        t: raw.t,                   //TODO Delete 1 or 2 maybe
        n: raw.n,
        c: raw.c + (raw.dp << 2),
        src: raw.s,
        dst: raw.d,
        bp: raw.bp == 1,
        comment: "",
        word: raw.word
    }

    assert(raw.word == commandToInstructionWord(cmd));

    return cmd;
}

function normalizeCmd(cmd) {
    /**
     * Undo the Deferred to Immediate translation done when
     * T = L1. The reversal is ambiguous, but for now I assume
     * if it can be done it should be done
     */

    //The original command's word
    const inWord = commandToInstructionWord(cmd);

    //If any of the following transformations result in the
    //same word as the original command they are returned.

    //Future work could include some better guesses as to when

    //If removeing the prefix has no effect, remove the
    //prefix
    let cpy = { ...cmd, p: " " };
    if (commandToInstructionWord(cpy) == inWord) {
        return cpy;
    }

    //Remove prefix and adjust T...
    if (cmd.p == "u" && (cmd.t == cmd.l + 1 || cmd.t == cmd.l + 2)) {

        //No prefix might mean immediate if T was originally
        //L+1 and 1 was added
        cpy = { ...cmd, p: " ", t: cmd.t - 1 };
        if (commandToInstructionWord(cpy) == inWord) {
            return cpy;
        }

        //Same as above, but EVEN DP version
        if (cmd.c >= 4) {
            cpy = { ...cmd, p: " ", t: cmd.t - 2 };
            if (commandToInstructionWord(cpy) == inWord) {
                return cpy;
            }
        }

    }

    return cmd;
}

let program: ASM.Instruction[] = [];
for (let l = 0; l < block.length; l++) {
    let loc = l.toString().padStart(2, "0");
    if (l >= 100) {
        loc = "u" + (l - 100);
    }
    let word = block[l];

    let raw = parseWordToRaw(word);

    let cmd = rawToCommand(raw);
    cmd.l = l;
    cmd = normalizeCmd(cmd);
    cmd.comment = disassembleWord(l, raw.word).butt;

    program[l] = cmd;
}

let done: number[] = [];

//Perform static analysis if enabled
if (!commandLine.opts().nostatic) {

    //Initialize TODO with list of entrypoints from command
    //line, or with just a zero.
    let todo = commandLine.opts().entrypoints || "0";
    todo = todo.split(",").map(e => +e);

    while (todo.length) {
        //console.log(todo);
        //console.log(done);

        let cur = todo.shift();
        done.push(cur);
        let cmd = program[cur];

        if (cmd.src == 31 && cmd.dst == 31 && cmd.c == 0) {
            continue;
        }

        //TODO All of them!
        if (cur == 100)
            console.log(formatCommand(cmd));
        let test = false;
        // console.log(cmd.src);
        if (cmd.dst == 27) {
            test = true;
        } else if (cmd.src == 28 && cmd.dst == 31 && cmd.c <= 3) {
            test = true;
        } else if (cmd.src == 22 && cmd.dst == 31 && cmd.c == 0) {
            test = true;
        } else if (cmd.comment && cmd.comment.indexOf("TEST") != -1) {
            test = true;
        }
        //console.log(test);


        if (test) {
            if (done.indexOf(cmd.n + 1) == -1) {
                // console.log(cur, cmd.n + 1);
                todo.unshift(cmd.n + 1);
            }
        }

        if (done.indexOf(cmd.n) == -1) {
            //console.log(cur, cmd.n);
            todo.unshift(cmd.n);
        }
    }
}

//TODO --nostatic makes EVERYTHING print like a constant :(
let out = "#" + fileName + "\n\n";
out += "#LL S P TT NN C SS DD B  Comment\n"
let last: ASM.Instruction | null = null;
for (let l of done) {
    if (last && last.n != l)
        out += "\n";
    let cmd = program[l];
    out = out + formatCommand(cmd) + "\n";
    if (cmd.src == 31 && cmd.dst == 31 && cmd.c == 0) {
        out = out + "#AR";
    }
    last = cmd;
}

if (!commandLine.opts().nostatic) {
    //TODO don't include if none
    out += "\n\n#Not Reached from Entry Points\n";
    out += "#                        Comment:             Assembly:\n"
    out += "#LL   ±Hex               Raw       Decimal     LL S P TT NN C SS DD B  Interpretation\n"
}

for (let cmd of program) {
    if (done.indexOf(cmd.l) == -1 && cmd.word != 0) {
        let constant = `.${convert.intToG15Dec(cmd.l)}   ${convert.g15SignedHex(cmd.word).padEnd(19, " ")}`;
        let comment = convert.g15Hex(cmd.word) + "  " + convert.wordToDec(cmd.word).toString().padStart(9);
        if (cmd.comment?.indexOf("Invalid") == -1) {
            comment += "  " + formatCommand(cmd);
        }
        out += constant + comment + "\n";
    }
}


console.log(out);