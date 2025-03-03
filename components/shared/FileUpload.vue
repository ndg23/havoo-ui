<template>
  <div class="space-y-2">
    <label :for="id" class="text-sm font-medium text-gray-700 flex items-center gap-2">
      {{ label }}
      <span v-if="required" class="text-red-500">*</span>
    </label>
    
    <div 
      class="relative border border-dashed border-gray-200 rounded-xl p-4 hover:border-orange-500/50 transition-colors cursor-pointer"
      @click="$refs.input.click()"
      @dragover.prevent
      @drop.prevent="handleDrop"
    >
      <input
        ref="input"
        :id="id"
        type="file"
        class="hidden"
        :accept="accept"
        :required="required"
        @change="handleChange"
      >
      
      <div v-if="!modelValue" class="flex flex-col items-center justify-center py-4">
        <ArrowUpTrayIcon class="w-8 h-8 text-gray-400 mb-2" />
        <p class="text-sm text-gray-500">
          Glissez votre fichier ici ou cliquez pour sélectionner
        </p>
        <p class="text-xs text-gray-400 mt-1">
          {{ accept }} - Max 5MB
        </p>
      </div>
      
      <div v-else class="flex items-center justify-between">
        <div class="flex items-center gap-3">
          <DocumentIcon class="w-8 h-8 text-gray-400" />
          <div>
            <p class="text-sm font-medium text-gray-900">{{ modelValue.name }}</p>
            <p class="text-xs text-gray-500">{{ formatSize(modelValue.size) }}</p>
          </div>
        </div>
        <button 
          type="button"
          class="p-1 hover:bg-gray-100 rounded-lg"
          @click.stop="$emit('update:modelValue', null)"
        >
          <XMarkIcon class="w-5 h-5 text-gray-400" />
        </button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ArrowUpTrayIcon, DocumentIcon, XMarkIcon } from '@heroicons/vue/24/outline'
import { ref } from 'vue'

const input = ref<HTMLInputElement | null>(null)

defineProps<{
  id: string
  label: string
  modelValue: File | null
  accept?: string
  required?: boolean
}>()

const emit = defineEmits<{
  (e: 'update:modelValue', file: File | null): void
}>()

const handleChange = (event: Event) => {
  const input = event.target as HTMLInputElement
  if (input.files?.length) {
    emit('update:modelValue', input.files[0])
  }
}

const handleDrop = (event: DragEvent) => {
  if (event.dataTransfer?.files.length) {
    emit('update:modelValue', event.dataTransfer.files[0])
  }
}

const formatSize = (bytes: number) => {
  if (bytes < 1024) return bytes + ' B'
  if (bytes < 1024 * 1024) return (bytes / 1024).toFixed(1) + ' KB'
  return (bytes / (1024 * 1024)).toFixed(1) + ' MB'
}
</script> 