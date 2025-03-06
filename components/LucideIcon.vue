<template>
  <span class="lucide-icon-wrapper">
    <component :is="icon" v-bind="$attrs" />
  </span>
</template>

<script setup>
defineProps({
  icon: {
    type: Object,
    required: true
  }
})
</script> 