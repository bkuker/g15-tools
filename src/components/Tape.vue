<script setup>
import {outputBlockPti as pti} from "./Program";

</script>

<template>
    <div id="tape">
        <img src="../assets/tape-torn-top.png"/>
        <div id="data">
            {{pti}}
        </div>
        <img src="../assets/tape-torn.png"/>
    </div>
</template>

<style scoped>
#tape {
    width: 2in;
}
#data {
    background-color: #B7D0E2;
    white-space: pre;
    font-family: "Special Elite", monospace;
    font-weight: 400;
    font-style: normal;
    font-size: 10px;
    line-height: 24px;
    color: #444;
    width: 2in;
    padding: 25px 5px 5px 5px;
}
#tape img {
    width: 2in;
    display: block;
}
</style>