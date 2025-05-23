import { ASM, type Numbers as N } from "./AsmTypes";
import * as convert from "./conversionUtils";
import assert from "assert";

export function parseAsmProgram(sourceCode: ASM.Line[]): ASM.Line[] {
    //Identify line types, seperate into text fields
    let parsedLines: (ASM.ParsedConstantText | ASM.ParsedInstructionText | ASM.Comment | ASM.ParsedLabel)[] = [];

    for (const line of sourceCode) {
        parsedLines.push(parseInstructionText(line));
    }

    //CALCULATE LOCATIONS
    //
    //Any literal is parsed from G15 two digit Decimal
    //Any blank ("  ") is taken to be consecutive (+1) from the previous
    //line's location.
    //TODO Consider +N notation, where "+1" and "  " are the same, but you can do +2 etc?
    let used = new Set<number>();
    let lastLoc = NaN;
    for (const p of parsedLines) {
        if (ASM.isParsedConstantText(p) || ASM.isParsedInstructionText(p)) {
            if (p.l.startsWith("L")) {
                let n = parseInt(p.l.substring(1));
                lastLoc = p.lResolved = (lastLoc + n);// % 107;
            } else if ( p.l.startsWith("%") ){
                lastLoc = p.lResolved = parseInt(resolveMod(p.l, lastLoc));
            } else if (p.l.trim() == "" || p.l == "od" || p.l == "ev") {
                let l = lastLoc;
                while(true){
                    l++;
                    l = l;// % 107;
                    if ( !used.has(l) )
                        break;
                }
                lastLoc = p.lResolved = l;
            } else {
                lastLoc = p.lResolved = convert.g15DecToInt(p.l as N.g15Dec);
            }

            //Is it already used?
            if ( used.has(p.lResolved) ){
                throw `Location ${p.lResolved} Duplicated at ${p.sourceFile}:${p.sourceLineNumber}`;
            }
            used.add(p.lResolved);

            //Post check even and Odd
            if (p.l == "ev" && p.lResolved % 2 != 0) {
                throw new Error(`Location must even, but is ${p.lResolved} at ${p.sourceFile}:${p.sourceLineNumber}`);
            } else if (p.l == "od" && p.lResolved % 2 != 1) {
                throw new Error(`Location must odd, but is ${p.lResolved} at ${p.sourceFile}:${p.sourceLineNumber}`);
            }

            if ( p.lResolved > 107 ){
                console.error(`Hit end of drum at at ${p.sourceFile}:${p.sourceLineNumber}`);
            }
        }
    }

    //Find Labels
    //
    //Any label refers to the next instruction or constant
    //in the source.
    let labels: Map<string, number> = new Map();
    let lastLabel: ASM.ParsedLabel | undefined;
    for (const p of parsedLines) {
        if (ASM.isParsedLabel(p)) {
            if (lastLabel != undefined) {
                throw "Two labels in a row at " + p.sourceLineNumber;
            }
            lastLabel = p;
        }
        if (lastLabel != undefined && (ASM.isParsedConstantText(p) || ASM.isParsedInstructionText(p))) {
            if (p.lResolved == undefined) {
                throw "Location unresolved for " + p.sourceLineNumber;
            }
            labels.set(lastLabel.label, p.lResolved);
            lastLabel = undefined;
        }
    }

    //Set nextLoc
    let previous: ASM.ParsedConstantText | ASM.ParsedInstructionText | undefined;
    for (const p of parsedLines) {
        if (ASM.isParsedConstantText(p) || ASM.isParsedInstructionText(p)) {
            if (previous != undefined) {
                previous.nextLoc = p.lResolved;
            }
            previous = p;
        }
    }

    let program: ASM.Line[] = []; //The commands and comments in PROGRAM order, not location order
    let lastLine;
    for (const parsed of parsedLines) {
        let line: ASM.Line = parseAsmLine(parsed, labels);
        program.push(line);
        if (ASM.isLoc(line)) {
            lastLine = line.l;
        }
    }
    return program;
}




//Break a instruction into it's textual components.
//All values are strings, and some may be mnemonics etc!
function parseInstructionText(lineData: ASM.Line): ASM.ParsedConstantText | ASM.ParsedInstructionText | ASM.ParsedLabel | ASM.Comment {
    let line = lineData.rawText;

    if (/^[A-Z][A-Z0-9]:/i.test(line)) {
        return {
            rawText: line,
            sourceLineNumber: lineData.sourceLineNumber,
            sourceFile: lineData.sourceFile,
            label: line.substring(0, 2)
        }
    }

    let s = line.substring(4, 5) as ASM.sType;
    if (
        line.trim().startsWith("#")
        || line.trim().length == 0
        || line.startsWith(" ".repeat(24))) {
        return {
            comment: line,
            rawText: line,
            sourceLineNumber: lineData.sourceLineNumber,
            sourceFile: lineData.sourceFile
        };
    } else if (s == "." || s == "s") {
        //An Instruction
        return {
            l: line.substring(1, 3),
            s: line.substring(4, 5),
            p: line.substring(6, 7),
            t: line.substring(8, 10),
            n: line.substring(11, 13),
            c: line.substring(14, 15),
            src: line.substring(16, 18),
            dst: line.substring(19, 21),
            bp: line.substring(22, 23),
            comment: line.substring(24),
            rawText: line,
            sourceLineNumber: lineData.sourceLineNumber,
            sourceFile: lineData.sourceFile
        }
    } else if (line.startsWith(".")) {
        //A Constant
        let value = line.substring(4, 20);
        if (value.startsWith("b")) {
            return {
                l: line.substring(1, 3),
                value: line.substring(4),
                comment: "",
                rawText: line,
                sourceLineNumber: lineData.sourceLineNumber,
                sourceFile: lineData.sourceFile,
            }
        } else {
            return {
                l: line.substring(1, 3),
                value: value,
                comment: line.substring(24),
                rawText: line,
                sourceLineNumber: lineData.sourceLineNumber,
                sourceFile: lineData.sourceFile,
            }
        }
    } else {
        throw `Error parsing line ${lineData.sourceFile}:${lineData.sourceLineNumber} ${line}`;
    }
}

function resolveG15DecToInt(v: string, loc: number, nextSlocLoc: number, labels: Map<string, number>): number {
    if (labels.has(v)) {
        v = (labels.get(v) as number).toString();
    }

    //Blank means next SLOC location, useful for T or N
    if (v == "  ") {
        return nextSlocLoc;
    }

    //L1 = Loc plus 1, like in docs
    if (v.startsWith("L")) {
        return (loc + parseInt(v.replace("L", ""))) % 107;
    }

    //Just a number
    return convert.g15DecToInt(v as N.g15Dec) % 107;
}

function resolveMod(v: string, l: number): string {
    if (!v.startsWith("%")) {
        return v;
    }
    let m: number = parseInt(v.substring(1));
    let ret = l;
    assert(m >= 0 && m < 4, "Invalid mod value");
    do {
        ret = ret + 1;
    } while (ret % 4 != m);
    return ret.toString();
}

/**
 * Parse a raw line of assembly input into an ASM.Line object
 */
function parseAsmLine(parsed: ASM.ParsedConstantText | ASM.ParsedInstructionText | ASM.ParsedLabel | ASM.Comment, labels: Map<string, number>): ASM.Line {


    //Each line follows the pattern:
    //  LL S P.TT.NN.C.SS.DD BP
    //Taken from the programming problem worksheet
    //and various published source listings.

    //Extract the Location and s columns
    if (ASM.isParsedInstructionText(parsed)) {
        //Decode instruction

        //let l = convert.g15DecToInt(parsed.l as N.g15Dec);//g15DecToIntRelative(parsed.l, previousLine, labels);

        let cmd: ASM.Instruction = {
            rawText: parsed.rawText,
            l: parsed.lResolved as number,
            s: parsed.s as ASM.sType,
            p: parsed.p as ASM.prefixType,
            t: resolveG15DecToInt(resolveMod(parsed.t, parsed.lResolved as number), parsed.lResolved as number, parsed.nextLoc as number, labels),//convert.g15DecToInt(parsed.t as N.g15Dec),
            n: resolveG15DecToInt(resolveMod(parsed.n, parsed.lResolved as number), parsed.lResolved as number, parsed.nextLoc as number, labels),//convert.g15DecToInt(parsed.n as N.g15Dec),
            c: +parsed.c,
            src: +parsed.src,
            dst: +parsed.dst,
            bp: parsed.bp.trim().length > 0,
            comment: parsed.comment?.trim(),
            word: 0 as N.word,
            sourceLineNumber: parsed.sourceLineNumber,
            sourceFile: parsed.sourceFile
        }

        //This is the command's actual binary value as an integer
        cmd.word = commandToInstructionWord(cmd);

        return cmd;
    } else if (ASM.isParsedConstantText(parsed)) {
        //Decode constant

        //TODO: Support double precision constants?
        //TODO Consider Binary and fractional decimal literals

        const valueText = parsed.value.trim();
        let word: N.word | undefined;

        if (valueText.startsWith("d0.") || valueText.startsWith("d.") || valueText.startsWith("d-")) {
            //Parse as fractional decimal
            let v = parseFloat(valueText.substring(1));
            word = convert.fractionalDecToWord(v);
        } else if (valueText.startsWith("d")) {
            //Parse as integer decimal
            let v = parseInt(valueText.substring(1));
            v = v << 1;
            if (v < 0) {
                v = v | 0x01;
            }
            word = v as N.word;
        } else if (valueText.startsWith("+")) {
            //Parse as Positive +/- hex
            let abs = valueText.substring(1) as N.g15Hex;
            let valNum = convert.g15HexToDec(abs);
            word = (Math.abs(valNum) << 1) as N.word;
        } else if (valueText.startsWith("-")) {
            //Parse as Negative +/- hex
            let abs = valueText.substring(1) as N.g15Hex;
            let valNum = convert.g15HexToDec(abs);
            word = ((Math.abs(valNum) << 1) | 0x01) as N.word;
        } else if (valueText.startsWith("b")) {
            let bin = valueText.substring(1);
            bin = bin.replaceAll(" ", "");
            word = parseInt(bin, 2) as N.word;
        } else if (valueText == "") {
            word = 0 as N.word;
        } else {
            //Parse as raw 29bit word
            word = convert.g15HexToDec(valueText as N.g15Hex) as N.word;
        }

        //Place into an object
        let data: ASM.Constant = {
            rawText: parsed.rawText,
            l: parsed.lResolved as number,
            word: word as N.word,
            valueText: valueText,
            comment: parsed.comment,
            sourceLineNumber: parsed.sourceLineNumber,
            sourceFile: parsed.sourceFile
        }
        return data;
    } else {
        //Just return comment or label
        return parsed;
    }

}

/**
 * Returns a formatted version of a command object in the same format
 * as the input.
 */
export function formatCommand(c: ASM.Instruction): string {
    return `.${convert.intToG15Dec(c.l)} ${c.s} ${c.p}.${convert.intToG15Dec(c.t)}.${convert.intToG15Dec(c.n)}.${c.c}.${convert.intToG15Dec(c.src)}.${convert.intToG15Dec(c.dst)} ${c.bp ? "-" : " "} ${c.comment}`;
}

/**
 * Converts a command object into an instruction word.
 * Returns an integer, not g15 hex
 * 
 * See https://rbk.delosent.com/allq/Q9896.pdf p29
 */
export function commandToInstructionWord(c: ASM.Instruction): N.word {

    let o = 0;
    o = o | (c.dst << 1);
    o = o | (c.src << 6);

    //Disassembler shows C as
    //(dp*4 + c)

    o = o | ((c.c & 0b11) << 11);
    o = o | (c.c >> 2); //TODO CHECK SINGLE vs DOUBLE

    o = o | (c.n << 13);
    o = o | ((c.bp ? 1 : 0) << 20);

    //Is this deferred?
    // Prefix u: i/d = 0 immediate
    //        w: i/d = 1 deferred
    //    blank: i/d = 1 deferred
    //           UNLESS dest = 31 or t = l + 1
    let tPrime = c.t;
    const DEFERRED = 1;
    const IMMEDIATE = 0;
    let id = 0;
    if (c.p == "u") {
        id = IMMEDIATE;
    } else if (c.p == "w") {
        id = DEFERRED;
    } else if (c.p == " ") {
        if (c.dst == 31) {
            id = IMMEDIATE;
        } else if (c.t == c.l + 1) {
            //TODO T is wrong
            id = IMMEDIATE;

            if (c.c < 4) {
                tPrime = c.t + 1;
            } else {
                if (c.t % 2 == 0) {
                    tPrime = c.t + 2;
                } else {
                    tPrime = c.t + 1;
                }
            }

        } else {
            id = DEFERRED;
        }
    }

    o = o | (tPrime << 21);


    o = o | (id << 28);

    return o as N.word;
}