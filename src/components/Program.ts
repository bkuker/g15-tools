import { ref, computed, watchEffect } from 'vue'
import { ASM, type Numbers as N } from "../../assembler/AsmTypes";
import { parseAsmProgram } from "../../assembler/instructionUtils";
import * as tape from "../../assembler/tapeUtils";
import numberTrack from '../../assembler/numberTrack';
import { formatCommand } from "../../assembler/instructionUtils.ts";

const MIN_LEN = 40;

export const inputAssembly = ref<string>("\n".repeat(MIN_LEN));

const inputAssemblyParsed = computed<ASM.Line[]>(()=>{
    return parseAsmProgram( inputAssembly.value );
});

export const sourceCodeText = ref<any[]>([]);
watchEffect(()=>{
    let pt = [];
    for (let line of inputAssemblyParsed.value) {
        let text = {}
        if (ASM.isInstruction(line)) {
            text = {
                s: ".",
                l: line.l,
                p: line.p.trim(),
                t: line.t,
                n: line.n,
                c: line.c,
                src: line.src,
                dst: line.dst,
                bp: line.bp?"-":"",
                comment: line.comment
            }
        } else if (ASM.isConstant(line)) {
            text = {
                l: line.l,
                comment: line.comment,
                value: line.valueText
            }
        } else {
            text = {
                comment: line.rawText
            }
        }
        pt.push(text);
    }
    while (pt.length <= MIN_LEN ){
        pt.push({comment: ""});
    }
    sourceCodeText.value = pt;
});

export const outputAssembly = computed<string>(()=>{
    let asm = "";
    for ( let line of sourceCodeText.value ){
        if ( !line.p ){
            line.p = " ";
        }
        if ( line.value ){
            asm += `.${line.l.padStart(2,"0")} ${line.value}\n`;
        } else if ( line.hasOwnProperty("c") ){
            line.s = ".";
            asm += formatCommand( line ) + "\n";
        } else {
            asm += line.comment + "\n";
        }
    }
    return asm;
});

const outputAssemblyParsed = computed<ASM.Line[]>(()=>{
    return parseAsmProgram( outputAssembly.value );
});


const outputWords = computed<N.word[]>(()=>{
    //Get Filter the LOC lines and put them in order
    let line: ASM.Loc[] = [];
    for (let cmd of outputAssemblyParsed.value.filter((o: any): o is ASM.Loc => typeof o.l === 'number')) {
        line[cmd.l] = cmd;
    }

    //For each location output the word or a zero
    let lineWords: N.word[] = [];
    for (let l = 0; l < 108; l++) {
        if (line[l]) {
            lineWords[l] = line[l].word;
        } else {
            lineWords[l] = 0 as N.word;
        }
    }
    return lineWords;
});

export const outputBlockPti = computed<string>(()=>{
    return tape.lineToTape(outputWords.value);
});

export const outputBootablePti = computed<string>(()=>{
    return numberTrack + "\n\n" + outputBlockPti.value;
});