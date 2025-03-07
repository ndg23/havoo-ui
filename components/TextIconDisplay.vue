<template>
  <span class="text-2xl block" v-bind="$attrs">{{ icon }}</span>
</template>

<script setup>
defineProps({
  icon: {
    type: String,
    required: true
  }
})
</script> 