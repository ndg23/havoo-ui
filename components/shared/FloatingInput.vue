<template>
  <div class="relative">
    <input
      :id="id"
      :value="modelValue"
      @input="$emit('update:modelValue', ($event.target as HTMLInputElement).value)"
      :type="type"
      class="block px-4 py-3 w-full text-gray-900 bg-white border border-gray-200 rounded-lg appearance-none focus:border-0 focus:border-orange-500 peer"
      placeholder=" "
      :required="required"
    />
    <label
      :for="id"
      class="absolute text-sm text-gray-500 transition-all duration-200 transform left-4 top-1/2 -translate-y-1/2 cursor-text peer-focus:text-xs peer-focus:top-2.5 peer-focus:text-orange-500 peer-[:not(:placeholder-shown)]:text-xs peer-[:not(:placeholder-shown)]:top-2.5"
    >
      {{ label }}
      <span v-if="required" class="text-red-500 ml-1">*</span>
    </label>
  </div>
</template>

<script setup lang="ts">
defineProps<{
  id: string
  label: string
  modelValue: string | number
  type?: string
  required?: boolean
}>()

defineEmits<{
  (e: 'update:modelValue', value: string): void
}>()
</script> 