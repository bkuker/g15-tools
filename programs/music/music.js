import fs from "fs";

const fileName = 'software/tools/trace/laMars.dis.hex';
const data = fs.readFileSync(fileName, 'utf-8'); // Read file synchronously
const lines = data.split(/\r?\n/); // Split into lines

let out = "";
for (let rawText of lines) {
    rawText = rawText.trim();
    let val = parseInt(rawText, 16);
   out = out + val.toString(2).padStart(29, "0") + "\n";
}

console.log(out);
