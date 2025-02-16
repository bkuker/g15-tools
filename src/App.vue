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
  filter: drop-shadow(5px 5px 5px #666);
}

</style>
