<script setup>
import Header from './Header.vue'
import Locations from './Locations.vue'
import Code from './Code.vue'
</script>

<template>
  <div class="worksheet">
    <Header class="header"/>
    <Locations class="locations"/>
    <Code class="code"/>
  </div>
</template>

<style scoped>
div.worksheet {
  border: 1px dashed black;
}

div.worksheet {
  width: 8.5in;
  height: 11in;
  padding: .5in;
}

div.worksheet {
  display: grid;
  grid-template-columns: 1.5in 1fr;
  grid-template-rows: 2cm 1fr;
  grid-column-gap: 1px; 
  grid-row-gap: 1px;
}

.header {
  grid-area: 1 / 1 / 2 / 3;
}

.location {
  grid-area: 2 / 1 / 3 / 2;
}

.code {
  grid-area: 2 / 2 / 3 / 3;
}
</style>
