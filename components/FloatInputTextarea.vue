<template>
  <div class="relative">
    <textarea
      :id="id"
      :value="modelValue"
      @input="$emit('update:model-value', ($event.target as HTMLTextAreaElement).value)"
      :placeholder="placeholder"
      :rows="rows"
      class="peer w-full px-4 py-3 rounded-xl border border-gray-200 focus:border-primary-500 focus:ring-primary-500 transition-all"
      :class="customClass"
    ></textarea>
    
    <label
      :for="id"
      class="absolute left-4 top-3 text-gray-500 transition-all duration-200 pointer-events-none peer-focus:-top-2.5 peer-focus:left-3 peer-focus:text-xs peer-focus:text-primary-600 peer-focus:bg-white peer-focus:px-1"
      :class="{ 
        '-top-2.5 left-3 text-xs bg-white px-1': isFloating,
        'text-primary-600': isFloating && !error,
        'text-red-500': error
      }"
    >
      {{ label }}
    </label>
    
    <!-- Message d'erreur -->
    <p v-if="error" class="mt-1 text-xs text-red-500">
      {{ error }}
    </p>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'

const props = defineProps({
  id: {
    type: String,
    required: true
  },
  label: {
    type: String,
    required: true
  },
  modelValue: {
    type: String,
    default: ''
  },
  placeholder: {
    type: String,
    default: ''
  },
  rows: {
    type: Number,
    default: 4
  },
  error: {
    type: String,
    default: ''
  },
  customClass: {
    type: String,
    default: ''
  }
})

defineEmits(['update:model-value'])

// Déterminer si l'étiquette doit flotter
const isFloating = computed(() => {
  return props.modelValue !== '' && props.modelValue !== null && props.modelValue !== undefined
})
</script> 