import { type ASM, type Numbers as N } from "./AsmTypes";
import * as convert from "./conversionUtils";

export function parseAsmProgram(sourceCode: string): ASM.Line[] {
    const lines: string[] = sourceCode.split(/\r?\n/); // Split into lines
    let program: ASM.Line[] = []; //The commands and comments in PROGRM order, not location order
    let sourceLineNumber = 0;
    for (const rawText of lines) {
        let line: ASM.Line = parseAsmLine(rawText);
        line.sourceLineNumber = sourceLineNumber++;
        program.push(line);
    }
    return program;
}

/**
 * Parse a raw line of assembly input into an ASM.Line object
 */
export function parseAsmLine(rawText: string): ASM.Line {

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
    let l = convert.g15DecToInt(rawText.substring(1, 3) as N.g15Dec);
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
            t: convert.g15DecToInt(t),
            n: convert.g15DecToInt(n),
            c: +c,
            src: +src,
            dst: +dst,
            bp: bp.trim().length > 0,
            comment,
            word: 0 as N.word
        }

        //This is the command's actual binary value as an integer
        cmd.word = commandToInstructionWord(cmd);

        return cmd;
    } else {
        //TODO: Support double precision constants?

        //There was not a "." or "s" in the s column...
        //This is a constant in +/- hex form
        const valueText: N.signedG15Hex = rawText.substring(4, 20).trim() as N.signedG15Hex;

        //Separate sign bit from absolute value hex
        let neg = false;
        let abs: N.g15Hex;
        if (valueText.startsWith("-")) {
            abs = valueText.substring(1) as N.g15Hex;
            neg = true;
        } else {
            abs = valueText as string as N.g15Hex;
        }

        //convert the abs to an integer
        let valNum = convert.g15HexToDec(abs);

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
            valueText: valueText,
            comment
        }
        return data;
    }

}

/**
 * Returns a formatted version of a command object in the same format
 * as the input.
 */
export function formatCommand(c: ASM.Instruction): string {
    return `.${convert.intToG15Dec(c.l)} ${c.s} ${c.p}.${convert.intToG15Dec(c.t)}.${convert.intToG15Dec(c.n)}.${c.c}.${convert.intToG15Dec(c.src)}.${convert.intToG15Dec(c.dst)} ${c.bp ? "-" : " "}  ${c.comment}`;
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