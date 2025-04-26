import * as util from "./conversionUtils.js";
import { type Numbers as N } from "./AsmTypes";
import assert from "assert";

function lineToTape(lineWords: N.word[], elideZeros = true): string {
    /**
     * This function takes a 108 long array of integers
     * and converts it to a string in the .pti format
     * described at:
     * 
     * https://github.com/retro-software/G15-software/ 
     */


    //Convert lineWords into a binary string
    let bin = "";
    for (let l = 0; l < 108; l++) {
        let b = ((lineWords[l] >>> 0).toString(2).padStart(29, "0"));
        bin = b + bin;
    }

    //Convert binary to tape
    let chunks = bin.match(/.{1,116}/g)!;
    let ptiBlock = "";
    const SYM = "0123456789uvwxyz";
    for (let i = 0; i < chunks.length; i++) {
        let lastChunk = i == chunks.length - 1;
        let out = "";
        let nibbles = chunks[i].match(/.{1,4}/g)!;
        for (let nibble of nibbles) {
            let v = parseInt(nibble, 2);
            out += SYM[v];
        }
        if (out == "00000000000000000000000000000" && elideZeros && !lastChunk) {
            continue;
        } else {
            elideZeros = false;
        }
        ptiBlock = ptiBlock + out;
        //Apply the appropriate line ending
        ptiBlock = ptiBlock + (lastChunk ? "S" : "/\n");
    }
    return ptiBlock;

}

function tapeToWords(tapeBlock: string): N.word[] {
    /**
     * This function takes a tape block as a string and returns
     * an array of words.
     */
    const lines = tapeBlock.split(/\r?\n/); // Split into lines

    let block: N.word[] = [];
    for (const rawText of lines) {
        if (rawText.trim().startsWith("#")) {
            continue;   //Ignore Comment
        } if (rawText.trim().length == 0) {
            continue;   //Ignore blank space
        }

        //TODO just assuming it is one single block in normal format
        //so just ignore any end or stops.
        let cleanedLine: N.g15Hex = rawText.trim().replace("/", "").replace("S", "").replace("-", "") as N.g15Hex;

        //Change line to normal hex
        let line: N.normalHex = util.g15HexToNormalHex(cleanedLine);

        //Build line as a stiing of 1 and 0
        //This is inefficient but simple and mirrors what happens
        //in the machine
        let bin = "";
        for (let hd of line) {
            bin += parseInt(hd, 16).toString(2).padStart(4, "0");
        }
        assert.equal(bin.length, 116, "Wrong number of bits in line");

        //Each 116 bits of tape is four 29-bit words
        let bWords = bin.match(/.{1,29}/g)!;

        assert(bWords.length == 4);

        let words = bWords.map(b => parseInt(b, 2)) as N.word[];

        block = words.reverse().concat(block);
    }
    return block;
}

function ptiToPtr(pti: string) {
    //A mapping of PTI Characters to their numeric value
    let ptiChars = {
        " ": 0,
        "-": 1,
        "C": 2, "D": 2,
        "T": 3,
        "S": 4,
        "/": 5, "R": 5,
        ".": 6, "P": 6,
        "W": 7,
        "i": 15,
        "0": 16, "1": 17, "2": 18, "3": 19, "4": 20,
        "5": 21, "6": 22, "7": 23, "8": 24, "9": 25,
        "u": 26, "v": 27, "w": 28, "x": 29, "y": 30, "z": 31
    };

    //This function converts the number to 5 bit binary,
    //reverses those bits, and then returns the resulting
    //number
    function reverse(n: number): number {
        let bin = n.toString(2);
        bin = bin.padStart(5, "0");
        assert(bin.length == 5);
        bin = bin.split("").reverse().join("");
        let v = parseInt(bin, 2);
        return v;
    }

    const out: number[] = [];

    //12" Leader
    for (let i = 0; i < 120; i++)
        out.push(0);

    for (let line of pti.split(/\r?\n/)) {
        line = line.trim();

        if (line.length == 0)
            continue; //Ignore empty lines

        if (line.startsWith("#"))
            continue; //Ignore comments
        
        for (let char of line) {
            let s = ptiChars[char];
            s = reverse(s);
            out.push(s);
            if (char == '/') {
                //One extra space after each reload
                out.push(0);
            }
            if (char == 'S') {
                //6" between blocks
                for (let i = 0; i < 60; i++)
                    out.push(0);
            }
        }
    }

    //12" Trailer
    for (let i = 0; i < 120; i++)
        out.push(0);

    return out;
}
export { lineToTape, tapeToWords, ptiToPtr }
