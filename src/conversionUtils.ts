import {type Numbers as N } from "./AsmTypes";
import assert from "assert";

function validateWord( w : N.word ){
    assert( w >= 0, "Words can't be negative " + w);
    assert( w <= 0x1FFFFFFF, "Words limited to 29 bits");
}

export function wordToDec(w: N.word): number {
    validateWord(w);
    let sign = w & 1;   //Extract sign bit
    let val = w >> 1;   //Extract absolute value
    if (sign)
        val *= -1;      //Apply sign
    return val;
}

export function g15SignedHex(w: N.word): N.signedG15Hex {
    validateWord(w);
    let sign = w & 1;   //Extract sign bit
    let val = w >> 1;   //Extract absolute value
    let hex = g15Hex(val as N.word);
    assert(hex.startsWith("0"));
    hex = hex.substring(1) as N.g15Hex;
    return ((sign ? "-" : "+") + hex) as N.signedG15Hex;
}

export function wordToFractionalDec( w : N.word ): number {
    let sign = w & 1;   //Extract sign bit
    let val = w >> 1;   //Extract absolute value
    if ( sign )
        val = val * -1;
    val = val / (1<<28);
    return val;
    validateWord(w);
}

export function fractionalDecToWord( w: number ): N.word {
    if ( w <= -1 || w >= 1 ){
        throw "Fractional decimals must be in the range (-1, 1): " + w;
    }
    w = w * (1<<28);
    w = Math.round(w);
    w = w * 2;
    if ( w < 0 ){
        w = Math.abs(w);
        w = w | 1;
    }
    validateWord(w as N.word);
    return w as N.word;
}

/*
export function intToSignedG15Hex(v: number){
    let neg = v < 0;
    v = Math.abs(v);
    v = v << 1;
    if (neg) {
        v = v | 0x01;
    }
    return g15SignedHex(v as N.word);
}*/

export function g15Hex(v: N.word): N.g15Hex {
    validateWord(v);
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
    }).padStart(8, "0") as N.g15Hex;
}

export function g15HexToDec(val: N.g15Hex): number {
    /**
     * Convert a string in bendix hex to an integer
     */
    let v: string = val.toLowerCase();
    v = v.replaceAll("u", "a");
    v = v.replaceAll("v", "b");
    v = v.replaceAll("w", "c");
    v = v.replaceAll("x", "d");
    v = v.replaceAll("y", "e");
    v = v.replaceAll("z", "f");
    return parseInt(v, 16);
}

export function g15HexToNormalHex(val: N.g15Hex): N.normalHex {
    /**
     * Convert a string in bendix hex
     * to normal human hex
     */
    let v: string = val.toLowerCase();
    v = v.replaceAll("u", "a");
    v = v.replaceAll("v", "b");
    v = v.replaceAll("w", "c");
    v = v.replaceAll("x", "d");
    v = v.replaceAll("y", "e");
    v = v.replaceAll("z", "f");
    return v as N.normalHex;
}

export function g15DecToInt(val: N.g15Dec): number {
    /**
     * Converts a G15 decimal number to an integer.
     * Numbers less than 100 are just normal, but
     * numbers greater than 100 have a u in the tens
     * place and so on. 107 = u7.
     */
    let v: string = val;
    v = v.replace("u", "10");
    v = v.replace("v", "11");
    v = v.replace("w", "12");
    v = v.replace("x", "13");
    v = v.replace("y", "14");
    v = v.replace("z", "15");
    return +v;
}

export function intToG15Dec(v: number): N.g15Dec {
    /**
     * Convert an integer to 2 digit G15 decimal
     */
    let ret = v.toString().padStart(2, "0");
    if (v >= 100 && v < 110) {
        ret = "u" + (v - 100);
    } else if (v >= 110 && v < 120) {
        ret = "v" + (v - 110);
    } else if (v >= 120 && v < 130) {
        ret = "w" + (v - 120);
    } else if (v >= 130 && v < 140) {
        ret = "x" + (v - 130);
    } else if (v >= 140 && v < 150) {
        ret = "y" + (v - 140);
    } else if (v >= 150 && v < 160) {
        ret = "z" + (v - 150);
    }
    assert(ret.length == 2);
    return ret as N.g15Dec;
}