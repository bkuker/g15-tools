<script setup>

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
        <th width="20">BP</th>
        <th style="letter-spacing: .7em;">NOTES</th>
      </tr>
    </thead>
    <tbody>
      <tr v-for="n in 26" :key="n-1">
        <td><input type="text" class="long" maxlength="2"></td>
        <td><input type="text" class="short" maxlength="1"></td>
        <td><input type="text" class="long" maxlength="2"></td>
        <td><input type="text" class="long" maxlength="2"></td>
        <td><input type="text" class="short" maxlength="1"></td>
        <td><input type="text" class="long" maxlength="2"></td>
        <td><input type="text" class="long" maxlength="2"></td>
        <td><input type="text" class="short" maxlength="1"></td>
        <td><input type="text" class="comment"></td>
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
}

#code th{
  height: .375in;
}

#code th.tht {
  font-size: 9pt;
  line-height: 7pt;
}

input {
  margin: 0;
  padding: 0;
  border: none;
  text-align: right;
}

input:focus {
  border: none;
  outline: none;
}

input.comment {
  text-align: left;
  padding-left: 10px;
}

input.long {
  width: 3em;
  padding-right: 12px;
}

input.short {
  width: 2em;
  padding-right: 9px;
}
</style>
