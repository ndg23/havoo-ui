<template>
  <div class="relative">
    <select
      :id="id"
      :value="modelValue"
      @input="$emit('update:modelValue', ($event.target as HTMLSelectElement).value)"
      class="block w-full px-4 py-3 text-gray-900 bg-white border border-gray-200 rounded-lg appearance-none focus:outline-none focus:ring-2 focus:ring-orange-500/20 focus:border-orange-500 peer"
      :required="required"
    >
      <option value="" disabled selected></option>
      <option 
        v-for="option in options" 
        :key="option.value"
        :value="option.value"
      >
        {{ option.label }}
      </option>
    </select>
    <label
      :for="id"
      class="absolute text-sm text-gray-500 transition-all duration-200 transform left-4 top-1/2 -translate-y-1/2 cursor-text peer-focus:text-xs peer-focus:top-2.5 peer-focus:text-orange-500 peer-[&:not(:placeholder-shown)]:text-xs peer-[&:not(:placeholder-shown)]:top-2.5"
    >
      {{ label }}
      <span v-if="required" class="text-red-500 ml-1">*</span>
    </label>
    
    <!-- Icône de flèche personnalisée -->
    <div class="absolute inset-y-0 right-0 flex items-center px-2 pointer-events-none">
      <ChevronDownIcon class="w-5 h-5 text-gray-400" />
    </div>
  </div>
</template>

<script setup lang="ts">
import { ChevronDownIcon } from '@heroicons/vue/24/outline'

interface Option {
  value: string
  label: string
}

defineProps<{
  id: string
  label: string
  modelValue: string
  options: Option[]
  required?: boolean
}>()

defineEmits<{
  (e: 'update:modelValue', value: string): void
}>()
</script> 