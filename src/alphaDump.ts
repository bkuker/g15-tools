import fs from "fs";
import assert from "assert";
import * as convert from "./conversionUtils";
import { commandToInstructionWord, formatCommand } from "./instructionUtils";
import disassembleWord from "./PaulDecoder";
import * as tape from "./tapeUtils";
import { ASM, Numbers as N } from "./AsmTypes";
import { Command } from 'commander';
import * as alpha from './alphaUtils';
import { glob, globSync, globStream, globStreamSync, Glob } from 'glob'

//If running from "npm run" change back
//to the directory the user ran the program from
if (process.env.INIT_CWD) {
    process.chdir(process.env.INIT_CWD);
}

//Command line stuff
const commandLine = new Command();
commandLine
    .argument('<pti tape file>');
commandLine.parse();

const fileNames = globSync(commandLine.args[0]);

for (let fileName of fileNames) {
    console.error(fileName);
    const data = fs.readFileSync(fileName, 'utf-8'); // Read file synchronously


    for (let block of splitPtiBlocks(data)) {
        let words = tape.tapeToWords(block);
        let bits = words.reverse().map(w => w.toString(2).padStart(29, "0"));
        let allBits = bits.join("");

        //allBits = allBits.split('').reverse().join('');

        for (let i = 0; i < 8; i++) {
            let bytes = allBits.match(/.{1,8}/g);
            let numbers = bytes?.map(b => parseInt(b, 2));
            let chars = numbers?.map(alpha.numericToChar);
            let s = chars?.map(c => c !== undefined ? c : '\n').join("");
            s = s?.replace(/\n+/g, '\n');

            let lines = s?.split(/\r?\n/); // Split into lines
            //lines = lines?.filter(l => l.length > 8);
            lines = lines?.filter(s => /[A-Za-z0-9]{8,}/.test(s));

            if (lines && lines?.length){
                console.log(i, lines);
            }

            allBits = allBits.substring(1);
        }
        //console.log(words.map(wordToAlpha));
    }
}

function wordToAlpha(w: N.word) {
    let bs = w.toString(2).padStart(29, "0");
    let bytes = bs.match(/.{1,8}/g);

    return bytes;
}

function splitPtiBlocks(tape: string): string[] {
    /**
     * This function takes a PTI string containing multiple blocks
     * and returns an array of individual PTI blocks
     */

    let lines = tape.split(/\r?\n/); // Split into lines

    //Remove comments
    lines = lines.filter(t => !t.startsWith("#"));

    //Remove blank lines
    lines = lines.filter(t => t.trim().length > 0);

    //Normalize reload
    lines = lines.map(t => t.replace("R", "/"))

    const blocks = [""];

    for (let l of lines) {
        blocks[blocks.length - 1] += l + "\n";
        if (l.endsWith("S")) {
            blocks.push("");
        }
    }

    //Return non-empty blocks
    return blocks.filter(t => t.trim().length > 0);
}
