<template>
  <div id="locations">
    <div v-for="n in 107" :key="n-1" :class="{used: used[n-1]}">
      {{ convert.intToG15Dec(n - 1).replace(/^0/,"") }}
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'

import * as convert from "../../assembler/conversionUtils";
import { sourceCodeText } from "./Program";

const used = computed<boolean[]>(()=>{
  let u = [];
  for ( let l of sourceCodeText.value ){
    if (l.l){
      u[convert.g15DecToInt(l.l.toString())] = true;
    }
  }
  return u;
});

</script>

<style scoped>
#locations {
  border: 1px solid black;
}

#locations {
  display: grid;
  grid-template-columns: auto auto auto auto;
}

.used:before {
  content: "X";
  color: blue;
  font-family: cursive;
  position: absolute;
  left: 10px;
  top: 3px;
  font-size: 15pt;
  transform: scale(2,1);
}

#locations > div {
  text-align: center;
  padding-top: 5px;
  padding-bottom: 5px;
  transform: scale(.6,1);
}
</style>
