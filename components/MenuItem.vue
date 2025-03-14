<template>
  <NuxtLink 
    :to="to" 
    class="flex items-center px-4 py-2 text-sm text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700 rounded-md"
  >
    <slot></slot>
  </NuxtLink>
</template>

<script setup>
defineProps({
  to: {
    type: String,
    required: true
  }
})
</script> 