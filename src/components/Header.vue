<script setup lang="ts">
import Downloads from './Downloads.vue'
</script>

<template>
    <div id="header">
      <img src="../assets/logo.png" id="logo">
      <div id="address">Los Angeles 45, California</div>
      <div id="name">
        <div>G-15D<br>PROGRAM PROBLEM:</div><input type="text" size="55"/>
      </div>
      <div id="author">Prepared by<input type="text" size="15"/></div>
      <!--<div>
        Page <input type="text"/> of <input type="text"/>
        Date: <input type="text"/>
        Line <input type="text"/>
      </div>-->
      <Downloads id="downloads"/>
    </div>
</template>

<style scoped>
#header {
  border: 1px solid black;
  letter-spacing: .15em;
}

#downloads { 
  position: absolute;
  top: 5px;
  right: 5px;
}

#logo {
  width: 2.5in;
  position: absolute;
  left: .4in;
  top: -50%;
  z-index: 100;
}

#header {
  width: 100%;
  position: relative;
  font-size: 10px;
  height: 2cm;
}

#address {
  position: absolute;
  top: 0;
  left: 3.1in;
}


#author {
  position: absolute;
  top: .35in;
  left: 2.9in;
}

#name {
  position: absolute;
  top: .43in;
  left: 5px;
}

#name>div {
  text-align: center;
  display: inline-block;
}

#header input {
  border: none;
  border-bottom: 1px solid black;
}

input {
  font-family: cursive;
  color: blue;
}

input:focus {
  outline: none;
}
</style>
