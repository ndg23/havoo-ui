<template>
  <div class="space-y-2">
    <label class="block text-sm font-medium text-gray-700">{{ label }}</label>
    <select
      :value="modelValue"
      @input="$emit('update:modelValue', ($event.target as HTMLSelectElement).value)"
      class="block w-full rounded-lg border-gray-200 -shadow-sm focus:border-orange-500 focus:ring-orange-500"
    >
      <option value="">Sélectionnez une option</option>
      <option v-for="option in options" :key="option.id" :value="option.id">
        {{ option.label }}
      </option>
    </select>
    <p v-if="error" class="mt-1 text-sm text-red-500">{{ error }}</p>
  </div>
</template>

<script setup lang="ts">
interface Option {
  id: string
  label: string
}

defineProps<{
  modelValue: string
  label: string
  options: Option[]
  error?: string
}>()

defineEmits<{
  (e: 'update:modelValue', value: string): void
}>()
</script> 