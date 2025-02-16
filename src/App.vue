<script setup lang="ts">
import Tape from './components/Tape.vue'
import Worksheet from './components/Worksheet.vue'
</script>

<template>
  <Worksheet id="worksheet"/>
  <Tape id="tape"></Tape>
</template>

<style scoped>
#tape {
  position: absolute;
  left: 10in;
  top: 1in;
}
div {
  filter: drop-shadow(5px 5px 5px #666);
}

</style>
