
export namespace Numbers {
    //Represents full 29-bit word, Sign is LSB
    export type word = number & { __brand: 'word' };
    
    //A word in G15 Hex, Sign is LSB
    export type g15Hex = string & { __brand: 'g15Hex' };

    //G15 Hex String representation of value with leading "-" if negative
    export type signedG15Hex = string & { __brand: 'signedG15Hex' };

    //Insane format in Decimal where 107 becomes u7 and 122 is w2 etc
    export type g15Dec = string & { __brand: 'g15Dec' };

    //A normal hex value
    export type normalHex = string & { __brand: 'normalHex' };
}

export namespace ASM {
    //Every line from an ASM file
    //Including blank, comment, whatever
    export interface Line {
        sourceLineNumber?: number,
        rawText?: string
    }

    //Any line with a Location and Comment
    export interface Loc extends Line {
        l: number,
        word: Numbers.word,
        comment?: string
    }

    //A line with a Location, Constant and comment
    export interface Constant extends Loc {
        value: number
    }

    export type prefixType = " " | "u" | "w";
    export type sType = "." | "s";

    //A full on instruction in PPR format
    export interface Instruction extends Loc {
        s: sType,
        p: prefixType,
        t: number,
        n: number,
        c: number,
        src: number,
        dst: number,
        bp: boolean
    }
}