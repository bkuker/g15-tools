import { ASM, type Numbers as N } from "./AsmTypes";
import * as convert from "./conversionUtils";
import { formatCommand } from "./instructionUtils";
import colors from "colors/safe";

interface Time {
    startDelay: number,
    executionTime: number,
    nextDelay: number,
    totalToNext: number
}

export default analyzeColor;

export function analyzeColor(program: ASM.Line[]): void {
    let times = computeTimes(program.filter(ASM.isInstruction));

    for (let l of program) {
        if (ASM.isInstruction(l)) {
            let t: Time = times.get(l.l) as Time;
            let str = formatCommand(l);
            str = str.trim().padEnd(60, " ") + t.totalToNext;
            if (t.totalToNext > 90) {
                str = colors.red(str);
            } else if ( t.totalToNext > 30 ){
                str = colors.yellow(str);
            } else if (t.totalToNext > 10) {
                str = colors.white(str);
                str = colors.bold(str);
            } else {
                str = colors.gray(str);
            }

            console.log(str);
        } else {
            console.log(colors.gray(l.rawText));
        }
    }


    for (let inst of program) {

    }
}

export function analyzeTable(p: ASM.Line[]): void {
    let program = p.filter(ASM.isInstruction);

    let times = computeTimes(program);

    console.log("\n\nLL\tWait\tExec\tDelay\tTotal");
    console.log("-------------------------------------");

    let lastSrc = "";

    for (let inst of program) {
        let t: Time = times.get(inst.l) as Time;

        let s1 = `${inst.l}:\t${t.startDelay.toString().padStart(4)}\t${t.executionTime.toString().padStart(4)}`;
        s1 = s1 + `\t${t.nextDelay.toString().padStart(5)}\t${t.totalToNext.toString().padStart(5)}`;

        let src = inst.sourceFile == lastSrc ? " ".repeat(lastSrc.length + 1) : inst.sourceFile + ":";
        let s2 = `\t${src} ${inst.sourceLineNumber}`;
        console.log(s1 + s2);

        lastSrc = inst.sourceFile;
    }

}

function computeTimes(program: ASM.Instruction[]): Map<number, Time> {
    let res = new Map<number, Time>();
    for (let inst of program) {
        let location = inst.l;
        let time = inst.t;
        let next = inst.n;

        let startDelay;
        if (inst.p == "u") {
            startDelay = 0;
        } else {
            startDelay = time - location;
            if (startDelay < 0)
                startDelay += 108;
        }

        let executionTime;
        if (inst.p == "u") {
            executionTime = time - location;
            if (executionTime < 0)
                executionTime += 108;
        } else {
            executionTime = 1;
        }

        let endTime = location + startDelay + executionTime;
        endTime = endTime % 108;
        if (endTime < 0)
            endTime += 108;

        let nextDelay = next - endTime;
        if (nextDelay < 0)
            nextDelay += 108;

        res.set(location, {
            startDelay,
            executionTime,
            nextDelay,
            totalToNext: startDelay + executionTime + nextDelay
        });
    }
    return res;
}