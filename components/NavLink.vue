<template>
  <NuxtLink 
    :to="to" 
    :class="[
      active 
        ? 'text-primary-600 dark:text-primary-400 font-medium'
        : 'text-gray-700 dark:text-gray-300 hover:text-primary-600 dark:hover:text-primary-400',
      'inline-flex items-center px-1 pt-1 text-sm transition-colors border-b-2',
      active 
        ? 'border-primary-500 dark:border-primary-400' 
        : 'border-transparent'
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