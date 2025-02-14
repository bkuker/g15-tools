
function wordToDec(w){
    let sign = w & 1;   //Extract sign bit
    let val = w >> 1;   //Extract absolute value
    if ( sign )
        val *= -1;      //Apply sign
    return val;
}

function g15SignedHex(w){
    let sign = w & 1;   //Extract sign bit
    let val = w >> 1;   //Extract absolute value
    let hex = g15Hex(val);
    return (sign?"-":"") + hex;
}

function g15Hex(v) {
    /**
     * Converts the value "v" to a hexidecimal string using the G-15
     */
    const hexRex = /[abcdefABCDEF]/g;   // standard hex characters
    return v.toString(16).replace(hexRex, (c) => {
        switch (c) {
            case "a": case "A":
                return "u";
            case "b": case "B":
                return "v";
            case "c": case "C":
                return "w";
            case "d": case "D":
                return "x";
            case "e": case "E":
                return "y";
            case "f": case "F":
                return "z";
            default:
                return "?";
        }
    }).padStart(8, "0");
}

function g15HexToDec(v) {
    /**
     * Convert a string in bendix hex to an integer
     */
    v = v.toLowerCase();
    v = v.replaceAll("u", "a");
    v = v.replaceAll("v", "b");
    v = v.replaceAll("w", "c");
    v = v.replaceAll("x", "d");
    v = v.replaceAll("y", "e");
    v = v.replaceAll("z", "f");
    console.log(v);
    return parseInt(v, 16);
}

function g15HexToNormalHex(v) {
    /**
     * Convert a string in bendix hex
     * to normal human hex
     */
    v = v.toLowerCase();
    v = v.replaceAll("u", "a");
    v = v.replaceAll("v", "b");
    v = v.replaceAll("w", "c");
    v = v.replaceAll("x", "d");
    v = v.replaceAll("y", "e");
    v = v.replaceAll("z", "f");
    return v;
}


function formatCommand(c) {
    /**
     * Returns a formatted version of a command object in the same format
     * as the input.
     */
    return `.${intToG15Dec(c.l)} ${c.s} ${c.p}.${intToG15Dec(c.t)}.${intToG15Dec(c.n)}.${c.c}.${intToG15Dec(c.src)}.${intToG15Dec(c.dst)} ${c.bp ? "-" : " "}  ${c.comment}`;
}

function g15DecToInt(v) {
    /**
     * Converts a G15 decimal number to an integer.
     * Numbers less than 100 are just normal, but
     * numbers greater than 100 have a u in the tens
     * place and so on. 107 = u7.
     */
    console.assert(v < 108); //Why would there be bigger numbers?

    v = v.replace("u", "10");
    v = v.replace("v", "11");
    v = v.replace("w", "12");
    v = v.replace("x", "13");
    v = v.replace("y", "14");
    v = v.replace("z", "15");
    return +v;
}

function intToG15Dec(v){
    /**
     * Convert an integer to 2 digit G15 decimal
     */
    let ret = v.toString().padStart(2, "0");
    if (v >= 100 && v < 110 ) {
        ret = "u" + (v - 100);
    }  else  if (v >= 110 && v < 120 ) {
        ret = "v" + (v - 110);
    } else  if (v >= 120 && v < 130 ) {
        ret = "w" + (v - 120);
    } else  if (v >= 130 && v < 140 ) {
        ret = "x" + (v - 130);
    } else  if (v >= 140 && v < 150 ) {
        ret = "y" + (v - 140);
    } else  if (v >= 150 && v < 160 ) {
        ret = "z" + (v - 150);
    }
    console.assert(ret.length == 2);
    return ret;
}

function commandToInstructionWord(c) {
    /**
     * Converts a command object into an instruction word.
     * Returns an integer, not g15 hex
     * 
     * TODO Review https://rbk.delosent.com/allq/Q9896.pdf p29
     * T needs modified for block commands maybe?
     */
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
    let id;
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

            if ( c.c < 4 ){
                tPrime = c.t + 1;
            } else {
                if ( c.t % 2 == 0 ){
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

    return o;
}


export {
    g15Hex, g15HexToNormalHex, formatCommand, commandToInstructionWord, wordToDec, g15HexToDec, intToG15Dec, g15SignedHex
}