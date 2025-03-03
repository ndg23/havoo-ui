<template>
  <button
    :class="[
      'px-6 py-3 rounded-xl font-medium transition-all duration-300',
      'transform active:scale-95',
      variants[variant],
      { 'opacity-50 cursor-not-allowed': disabled }
    ]"
    :disabled="disabled"
    @click="$emit('click')"
  >
    <slot />
  </button>
</template>

<script setup lang="ts">
interface Props {
  variant?: 'primary' | 'secondary' | 'white'
  disabled?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  variant: 'primary',
  disabled: false
})

const variants = {
  primary: 'bg-gradient-to-r from-blue-600 to-purple-600 text-white hover:shadow-lg hover:shadow-blue-500/25',
  secondary: 'bg-gray-100 text-gray-900 hover:bg-gray-200',
  white: 'bg-white text-gray-900 hover:bg-gray-50'
}
</script> 