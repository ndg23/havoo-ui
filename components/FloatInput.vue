<template>
  <div class="relative">
    <input
      :id="id"
      :type="type"
      :value="modelValue"
      @input="$emit('update:model-value', ($event.target as HTMLInputElement).value)"
      :placeholder="placeholder"
      class="peer w-full px-4 py-3 rounded-xl border border-gray-200 focus:border-primary-500 focus:ring-primary-500 transition-all"
      :class="[
        customClass,
        { 'pl-10': icon }
      ]"
    />
    
    <label
      :for="id"
      class="absolute left-4 top-3 text-gray-500 transition-all duration-200 pointer-events-none peer-focus:-top-2.5 peer-focus:left-3 peer-focus:text-xs peer-focus:text-primary-600 peer-focus:bg-white peer-focus:px-1"
      :class="{ 
        '-top-2.5 left-3 text-xs bg-white px-1': isFloating,
        'text-primary-600': isFloating && !error,
        'text-red-500': error,
        'left-10': icon
      }"
    >
      {{ label }}
    </label>
    
    <!-- Icône (si fournie) -->
    <div v-if="icon" class="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400">
      <component :is="icon" class="w-5 h-5" />
    </div>
    
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
    type: [String, Number],
    default: ''
  },
  type: {
    type: String,
    default: 'text'
  },
  placeholder: {
    type: String,
    default: ''
  },
  icon: {
    type: [Object, Function],
    default: null
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