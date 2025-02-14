import * as util from "../assembler/assemblerUtils.js";


let locationsUsed = [];

let locTable = document.getElementById("locations");
for (let r = 0; r < 108 / 4; r++) {
    let tr = document.createElement("tr");
    locTable.appendChild(tr);
    for (let i = 0; i < 4; i++) {
        let l = r * 4 + i;
        let td = document.createElement("td");
        locationsUsed[l] = td;
        tr.appendChild(td);

        td.innerText = util.intToG15Dec(l);
    }

}

let codeTable = document.getElementById("code");
for (let line = 0; line < 40; line++) {
    let tr = document.createElement("tr");
    codeTable.appendChild(tr);

    let l = codeTable.appendChild(document.createElement("td")).appendChild(document.createElement("input"));
    let p = codeTable.appendChild(document.createElement("td")).appendChild(document.createElement("input"));
    let t = codeTable.appendChild(document.createElement("td")).appendChild(document.createElement("input"));
    let n = codeTable.appendChild(document.createElement("td")).appendChild(document.createElement("input"));
    let c = codeTable.appendChild(document.createElement("td")).appendChild(document.createElement("input"));
    let s = codeTable.appendChild(document.createElement("td")).appendChild(document.createElement("input"));
    let d = codeTable.appendChild(document.createElement("td")).appendChild(document.createElement("input"));
    let bp = codeTable.appendChild(document.createElement("td")).appendChild(document.createElement("input"));

    let comment = codeTable.appendChild(document.createElement("td")).appendChild(document.createElement("input"));
    comment.classList.add("comment");

    for ( let i of [l,t,n,s,d]){
        i.size = 2;
        i.maxLength = 2;
        i.style.width = "3em";
    }

    for ( let i of [p,c,bp]){
        i.size = 1;
        i.maxLength = 1;
        i.style.width = "2em";
    }

}