<template>
  <span 
    class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium"
    :class="variantClasses"
  >
    <slot></slot>
  </span>
</template>

<script setup>
const props = defineProps({
  variant: {
    type: String,
    default: 'default',
    validator: (value) => ['default', 'primary', 'success', 'danger', 'warning', 'info'].includes(value)
  }
})

const variantClasses = computed(() => {
  switch (props.variant) {
    case 'primary':
      return 'bg-primary-50 text-primary-700 dark:bg-primary-900/30 dark:text-primary-300'
    case 'success':
      return 'bg-green-50 text-green-700 dark:bg-green-900/30 dark:text-green-300'
    case 'danger':
      return 'bg-red-50 text-red-700 dark:bg-red-900/30 dark:text-red-300'
    case 'warning':
      return 'bg-yellow-50 text-yellow-700 dark:bg-yellow-900/30 dark:text-yellow-300'
    case 'info':
      return 'bg-blue-50 text-blue-700 dark:bg-blue-900/30 dark:text-blue-300'
    default:
      return 'bg-gray-100 text-gray-700 dark:bg-gray-800 dark:text-gray-300'
  }
})
</script> 