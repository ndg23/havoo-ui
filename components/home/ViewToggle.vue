<template>
    <div class="flex items-center gap-2 bg-gray-100 p-1 rounded-lg">
      <button
        @click="$emit('update:modelValue', 'grid')"
        :class="[
          'p-2 rounded-md transition-colors',
          modelValue === 'grid' 
            ? 'bg-white text-blue-600 -shadow-sm' 
            : 'text-gray-600 hover:text-gray-900'
        ]"
      >
        <Squares2X2Icon class="w-5 h-5" />
      </button>
      <button
        @click="$emit('update:modelValue', 'list')"
        :class="[
          'p-2 rounded-md transition-colors',
          modelValue === 'list' 
            ? 'bg-white text-blue-600 -shadow-sm' 
            : 'text-gray-600 hover:text-gray-900'
        ]"
      >
        <ListBulletIcon class="w-5 h-5" />
      </button>
    </div>
  </template>
  
  <script setup lang="ts">
  import { 
    Squares2X2Icon,
    ListBulletIcon
  } from '@heroicons/vue/24/outline'
  
  defineProps<{
    modelValue: 'grid' | 'list'
  }>()
  
  defineEmits<{
    'update:modelValue': ['grid' | 'list']
  }>()
  </script>