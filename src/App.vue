<script setup lang="ts">
import Tape from './components/Tape.vue'
import Worksheet from './components/Worksheet.vue'
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
