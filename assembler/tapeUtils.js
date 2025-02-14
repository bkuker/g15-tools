import * as util from "./assemblerUtils.js";

function lineToTape(lineWords) {
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
    let chunks = bin.match(/.{1,116}/g);
    let ptiBlock = "";
    const SYM = "0123456789uvwxyz";
    for (let i = 0; i < chunks.length; i++) {
        let out = "";
        let nibbles = chunks[i].match(/.{1,4}/g);
        for (let nibble of nibbles) {
            let v = parseInt(nibble, 2);
            out += SYM[v];
        }
        ptiBlock = ptiBlock + out;
        //Apply the appropriate line ending
        ptiBlock = ptiBlock + (i == chunks.length - 1 ? "S" : "/\n");
    }
    return ptiBlock;

}

function tapeToWords( tapeBlock ){
    /**
     * This function takes a tape block as a string and returns
     * an array of words.
     */
    const lines = tapeBlock.split(/\r?\n/); // Split into lines
    
    let block = [];
    for (const rawText of lines) {
        if (rawText.trim().startsWith("#")) {
            continue;   //Ignore Comment
        } if (rawText.trim().length == 0) {
            continue;   //Ignore blank space
        }
    
        //TODO just assuming it is one single block in normal format
        //so just ignore any end or stops.
        let line = rawText.trim().replace("/", "").replace("S", "").replace("-", "");
    
        //Change line to normal hex
        line = util.g15HexToNormalHex(line);
    
        //Build line as a stiing of 1 and 0
        //This is inefficient but simple and mirrors what happens
        //in the machine
        let bin = "";
        for (let hd of line) {
            bin += parseInt(hd, 16).toString(2).padStart(4, "0");
        }
        console.assert(bin.length == 116);
    
        //Each 116 bits of tape is four 29-bit words
        let bWords = bin.match(/.{1,29}/g);
        console.assert(bWords.length == 4);
    
        let words = bWords.map(b => parseInt(b, 2));
    
        block = words.reverse().concat(block);
    }
    return block;
}

export { lineToTape, tapeToWords }