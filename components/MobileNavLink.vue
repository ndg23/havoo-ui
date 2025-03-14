<template>
  <NuxtLink 
    :to="to" 
    :class="[
      active 
        ? 'bg-primary-50 dark:bg-primary-900/30 text-primary-600 dark:text-primary-400' 
        : 'text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-800',
      'group flex items-center px-3 py-2 text-base font-medium rounded-lg'
    ]"
  >
    <slot></slot>
  </NuxtLink>
</template>

<script setup>
defineProps({
  to: {
    type: String,
    required: true
  },
  active: {
    type: Boolean,
    default: false
  }
})
</script> 