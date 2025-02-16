<script setup lang="ts">
import { outputAssembly,  outputBootablePti} from "./Program";

function downloadString(text:string, fileName:string) {
    var blob = new Blob([text], { type: 'text/plain' });
    var a = document.createElement('a');
    a.download = fileName;
    a.href = URL.createObjectURL(blob);
    a.dataset.downloadurl = ['text/plain', a.download, a.href].join(':');
    a.style.display = "none";
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    setTimeout(function() { URL.revokeObjectURL(a.href); }, 1500);
}

function downloadASM(){
    downloadString(outputAssembly.value, "file.asm");
}

function downloadPTI(){
    downloadString(outputBootablePti.value, "file.pti");
}
</script>

<template>
    <div>
    <button @click="downloadASM">💾 .asm</button>
    <br>
    <button @click="downloadPTI">💾 .pti</button>
    </div>
</template>

<style scoped>
button {
    width: 70px;
    text-align: left;
}
</style>