<template>
  <div class="relative">
    <textarea
      :id="id"
      :value="modelValue"
      :required="required"
      :rows="rows"
      class="
        block w-full px-4 py-3
        text-gray-900 bg-white
        border border-gray-200 rounded-lg
        appearance-none
        focus:outline-none focus:ring-2 focus:ring-orange-500/20 focus:border-orange-500
        peer
        resize-none
      "
      placeholder=" "
      @input="$emit('update:modelValue', ($event.target as HTMLTextAreaElement).value)"
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
  modelValue: string
  label: string
  rows?: number
  required?: boolean
}>()

defineEmits<{
  (e: 'update:modelValue', value: string): void
}>()
</script> 