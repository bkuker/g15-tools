<script setup lang="ts">
import Tape from './components/Tape.vue';
import Worksheet from './components/Worksheet.vue';
import { onMounted, onUnmounted } from 'vue';
import { inputAssembly } from "./components/Program";

onMounted(() => {
  document.body.addEventListener('drop', handleDrop);
  document.body.addEventListener('dragover', (event) => event.preventDefault()); // Prevent default to allow dropping
});

onUnmounted(() => {
  document.body.removeEventListener('drop', handleDrop);
});

function handleDrop(e: DragEvent){
  e.preventDefault();
  const file = e.dataTransfer?.files[0];
  if (!file) return;

  const reader = new FileReader();
  reader.onload = () => {
    if ( reader.result ){
      inputAssembly.value = reader.result.toString();
    }
  };
  reader.readAsText(file);
}
</script>

<template>
  <div id="app">
    <Worksheet id="worksheet"/>
    <Tape id="tape"></Tape>
    <div id="notes">
      <ul>
        <li>Drag an .asm file onto page to load.</li>
        <li>Shift-click a row to enter a constant value</li>
        <li>No error checking!</li>
        <li>Command line and text editor is easier!</li>
        <li><a target="_blank" href="http://www.bitsavers.org/pdf/bendix/g-15/G15D_Programmers_Ref_Man.pdf">→ Programmer's Reference</a></li>
        <li><a target="_blank" href="https://bitsavers.org/pdf/bendix/g-15/60121600_G15_Theory_Of_Operation_Nov64.pdf">→ Theory of Operation</a></li>
        <li><a target="_blank" href="https://www.phkimpel.us/Bendix-G15/webUI/G15.html">→ Paul's Emulator </a></li>
      </ul>
    </div>
  </div>
</template>

<style scoped>
#app {
  position: absolute;
  left: 50%;
  transform: translate(-50%, 0);
}

#tape {
  position: absolute;
  left: 10in;
  top: 1in;
}

div {
  filter: drop-shadow(2px 2px 3px #666);
}

#notes {
  background-image: url('./assets/notepaper.png');
  font-family: "Shadows Into Light", serif;
  background-size: cover;
  width: 2.6in;
  height: 2in;
  transform: rotate(10deg);
  position: absolute;
  top: 10in;
  left: 9.3in;
  font-size: 9pt;
}

#notes li {
  list-style-type: none;
  padding-top: 4px;
}

#notes a {
  text-decoration: none;
  color: inherit;
}
</style>
