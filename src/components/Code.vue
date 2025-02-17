<script setup lang="ts">
import { sourceCodeText } from "./Program";

function toggleConstant( line : any, e: Event ){
  e.preventDefault();
  if ( line.hasOwnProperty("value") ){
    delete line.value;
  } else {
    line.value = "";
  }
}

function focus(e: FocusEvent ){
  (e.target as HTMLInputElement).select();
}
</script>

<template>
  <table id="code">
    <thead>
      <tr>
        <th width="40">L</th>
        <th width="20">P</th>
        <th width="40" class="tht">T<br>or<br>L<sub>k</sub></th>
        <th width="40">N</th>
        <th width="20">C</th>
        <th width="40">S</th>
        <th width="40">D</th>
        <th width="20" class="bp">BP</th>
        <th class="notes">NOTES</th>
      </tr>
    </thead>
    <tbody>
      <tr v-for="line in sourceCodeText" @focusin="focus" @click.shift="e=>toggleConstant(line,e)">
        <td><input v-model="line.l" type="text" class="long" maxlength="2"></td>
        <template v-if="line.value !== undefined">
          <td colspan="7"><input v-model="line.value" type="text" class="constant"></td>
        </template>
        <template v-else>
          <td><input v-model="line.p" type="text" class="short" maxlength="1"></td>
          <td><input v-model="line.t" type="text" class="long" maxlength="2"></td>
          <td><input v-model="line.n" type="text" class="long" maxlength="2"></td>
          <td><input v-model="line.c" type="text" class="short" maxlength="1"></td>
          <td><input v-model="line.src" type="text" class="long" maxlength="2"></td>
          <td><input v-model="line.dst" type="text" class="long" maxlength="2"></td>
          <td><input v-model="line.bp" type="text" class="short" maxlength="1"></td>
        </template>
        <td><input v-model="line.comment" type="text" class="comment"></td>
      </tr>
    </tbody>
  </table>

</template>

<style scoped>


#code {
  border-collapse: collapse;
}

#code,
#code th,
#code td {
  border: 1px solid black;
  padding: 0;
}

#code th{
  height: .375in;
}

#code th.tht {
  font-size: 9pt;
  line-height: 7pt;
}

#code th.bp {
  transform: scale(.7, 1);
}

#code th.notes {
  transform: scale(.7, 1);
  letter-spacing: 1em;
}

input {
  display: block;
  margin: 0;
  padding: 0;
  border: none;
  text-align: right;
  height: 19px;
  width: 100%;
}

input:focus {
  border: none;
  outline: none;
}

input.comment, input.constant {
  text-align: left;
  padding-left: 5px;
  width: 100%
}

input.long {
  padding-right: 13px;
}

input.short {
  padding-right: 6px;
}
</style>
