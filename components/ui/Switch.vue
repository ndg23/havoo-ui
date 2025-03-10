<template>
  <button 
    type="button"
    :class="[
      'relative inline-flex h-6 w-11 items-center rounded-full transition-colors focus:outline-none',
      modelValue 
        ? 'bg-primary-600 dark:bg-primary-500' 
        : 'bg-gray-300 dark:bg-gray-600'
    ]"
    @click="toggle"
  >
    <span 
      class="inline-block h-4 w-4 transform rounded-full bg-white transition"
      :class="modelValue ? 'translate-x-6' : 'translate-x-1'"
    ></span>
  </button>
</template>

<script setup>
import { defineProps, defineEmits } from 'vue'

const props = defineProps({
  modelValue: {
    type: Boolean,
    default: false
  }
})

const emit = defineEmits(['update:modelValue', 'change'])

const toggle = () => {
  emit('update:modelValue', !props.modelValue)
  emit('change', !props.modelValue)
}
</script>