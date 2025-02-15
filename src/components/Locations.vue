<script setup>
  import * as util from "/assembler/assemblerUtils.js";

</script>

<template>
  <div id="locations">
    <div v-for="n in 107" :key="n-1">
      {{ util.intToG15Dec(n - 1).replace(/^0/,"") }}
    </div>
  </div>
</template>

<style scoped>
#locations {
  border: 1px solid black;
}

#locations {
  display: grid;
  grid-template-columns: auto auto auto auto;
}

#locations > div {
  text-align: center;
  padding-top: 5px;
  padding-bottom: 5px;
  transform: scale(.6,1);
}
</style>
