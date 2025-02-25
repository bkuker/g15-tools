import fs from "fs";
import path from "path";
import { ASM } from "./AsmTypes";
import { ssrRenderAttr } from "vue/server-renderer";


export function blockChop(lines: ASM.Line[]): ASM.Line[][] {
    let blocks: ASM.Line[][] = [[]];
    for (let line of lines) {
        if (line.rawText.startsWith("<BLOCK")) {
            blocks.push([]);
        } else {
            blocks[blocks.length - 1].push(line);
        }
    }
    return blocks;
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
        const match = rawText.match(/^<INCLUDE\s+src="(.*?)"/);
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