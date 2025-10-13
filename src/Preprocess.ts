import fs from "fs";
import path from "path";
import { ASM } from "./AsmTypes";

export function blockChop(lines: ASM.Line[]): ASM.Line[][] {
    let blocks: ASM.Line[][] = [[]];
    for (let line of lines) {
        if (line.rawText.startsWith("<BLOCK")) {
            blocks.push([]);
        } else {
            blocks[blocks.length - 1].push(line);
        }
    }
    return blocks.map(resolveDefines);
}

export function resolveDefines(block : ASM.Line[]) : ASM.Line[] {
    let defines : Map<string, string> = new Map();
    for ( let line of block ){
        if ( line.rawText.startsWith("#define ") ){
            let d = line.rawText.substring(8); //Remove #define
            let dd = d.split(" ", 2);
            defines.set(dd[0], dd[1]);
        }
    }
    for ( let line of block ){
        if ( line.rawText.startsWith("#define ") ){
            //empty
        } else {
            defines.forEach((v,k) => line.rawText = line.rawText.replaceAll(k,v));
        }
    }
    return block;
}

/**
 * Processes INCLUDES
 * @param fileName 
 * @returns An array of ILines
 */
export function preprocess(sourceFile: string, sourceFileRaw: string | undefined = undefined): ASM.Line[] {
    let sourceLineNumber = 0;
    let ret: ASM.Line[] = [];
    const data = fs.readFileSync(sourceFile, 'utf-8');

    for (let rawText of data.split(/\r?\n/)) {
        sourceLineNumber++;
        const match = rawText.match(/^#include\s+"(.*?)"/);
        if (match) {
            const includeFileRaw = match[1];
            const includeFileName = path.resolve(path.dirname(sourceFile), includeFileRaw);
            ret = ret.concat(preprocess(includeFileName, includeFileRaw));
        } else {
            ret.push({
                sourceFile: sourceFileRaw || sourceFile,
                sourceLineNumber,
                rawText
            });
        }
    }

    return ret;
}