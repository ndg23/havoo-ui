<template>
  <div class="space-y-2">
    <label class="block text-sm font-medium text-gray-700">Photos</label>
    <div class="mt-1 flex justify-center px-6 pt-5 pb-6 border-2 border-gray-300 border-dashed rounded-lg">
      <div class="space-y-1 text-center">
        <svg class="mx-auto h-12 w-12 text-gray-400" stroke="currentColor" fill="none" viewBox="0 0 48 48">
          <path d="M28 8H12a4 4 0 00-4 4v20m32-12v8m0 0v8a4 4 0 01-4 4H12a4 4 0 01-4-4v-4m32-4l-3.172-3.172a4 4 0 00-5.656 0L28 28M8 32l9.172-9.172a4 4 0 015.656 0L28 28m0 0l4-4m4-4h.01" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
        </svg>
        <div class="flex text-sm text-gray-600">
          <label class="relative cursor-pointer rounded-md font-medium text-orange-600 hover:text-orange-500 focus-within:outline-none focus-within:ring-2 focus-within:ring-offset-2 focus-within:ring-orange-500">
            <span>Télécharger des fichiers</span>
            <input 
              type="file" 
              class="sr-only" 
              multiple 
              accept="image/*"
              @change="handleFileChange"
            >
          </label>
          <p class="pl-1">ou glisser-déposer</p>
        </div>
        <p class="text-xs text-gray-500">PNG, JPG jusqu'à 10MB</p>
      </div>
    </div>
    <p v-if="error" class="mt-1 text-sm text-red-500">{{ error }}</p>
  </div>
</template>

<script setup lang="ts">
const emit = defineEmits<{
  (e: 'update:modelValue', value: File[]): void
}>()

defineProps<{
  modelValue: File[]
  error?: string
}>()

const handleFileChange = (event: Event) => {
  const files = (event.target as HTMLInputElement).files
  if (files) {
    emit('update:modelValue', Array.from(files))
  }
}
</script> 