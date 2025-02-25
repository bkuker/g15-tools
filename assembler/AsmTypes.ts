
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

    //Guard functions
    export function isLoc( o : Line ): o is Loc {
        return typeof (o as Loc).l == "number";
    }

    export function isConstant( o : Line ): o is Constant {
        return typeof (o as Constant).valueText == "string";
    }

    export function isInstruction( o : Line ): o is Instruction {
        return typeof (o as Instruction).c == "number";
    }

    export function isParsedConstantText( o : Line ): o is ParsedConstantText {
        return typeof (o as ParsedConstantText).value == "string";
    }

    export function isParsedInstructionText( o : Line ): o is ParsedInstructionText {
        return typeof (o as ParsedInstructionText).c == "string";
    }

    export function isParsedLabel( o : Line ): o is ParsedLabel {
        return typeof (o as ParsedLabel).label == "string";
    }


    

    //Every line from an ASM file
    //Including blank, comment, whatever
    export interface Line {
        sourceFile: string,
        sourceLineNumber: number,
        rawText: string,
    }

    export interface ParsedLabel extends Line {
        label: string
    }

    export interface ParsedInstructionText extends Line {
        l: string,
        s: string,
        p: string,
        t: string,
        n: string,
        c: string,
        src: string,
        dst: string,
        bp: string,
        comment?: string,

        lResolved: number | undefined,
        nextLoc: number | undefined,
    }

    export interface ParsedConstantText extends Line {
        l: string,
        value: string
        comment?: string,

        lResolved: number | undefined,
        nextLoc: number | undefined,
    }

    export interface Comment extends Line {
        comment: string //May be empty string
    }



    //Any line with a Location and Comment
    export interface Loc extends Line {
        l: number,
        word: Numbers.word,
        comment?: string
    }

    //A line with a Location, Constant and comment
    export interface Constant extends Loc {
        //value: number,
        valueText: string
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