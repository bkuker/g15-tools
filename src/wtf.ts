
import * as convert from "./conversionUtils";
import { formatCommand, parseAsmProgram } from "./instructionUtils";
import * as tape from "./tapeUtils";
import { ASM, Numbers as N } from "./AsmTypes";
import { Command } from 'commander';

const commandLine = new Command();
commandLine
    .argument('<value>');
commandLine.parse();

const input = commandLine.args[0];

console.log("=== Interpreted as Raw Hex ===");
dump(convert.g15HexToDec(input as N.g15Hex) as N.word);

console.log("=== Interpreted as ± Hex ===");
let w = convert.g15HexToDec(input as N.g15Hex);
w = w * 2;
if ( w < 0 ){
    w = Math.abs(w) + 1;
}
dump(w as N.word);

console.log("=== Interpreted as Decimal ===");
dump(parseInt(input) as N.word);


function dump(word : N.word) {
    console.log("As Raw Hex:\t", convert.g15Hex(word));
    console.log("As ± Hex:\t", convert.g15SignedHex(word));
    console.log("As Decimal: \t", word);
    console.log("As ± Decimal:\t", convert.wordToDec(word));
    console.log("As Binary:\t", word.toString(2).padStart(29,"0"));
    //console.log("As Instruction:\t", TODO)
    console.log("As Fractional Decimal:", convert.wordToFractionalDec(word));
    console.log();
}