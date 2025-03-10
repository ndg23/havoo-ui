<template>
  <div class="flex items-center justify-between mb-6">
    <div>
      <h1 v-if="title" class="text-2xl font-bold text-gray-900 dark:text-white">{{ title }}</h1>
      <p v-if="subtitle" class="text-sm text-gray-600 dark:text-gray-400 mt-1">{{ subtitle }}</p>
    </div>
    <NuxtLink 
      to="/account" 
      class="inline-flex items-center px-4 py-2 text-sm font-medium text-gray-700 dark:text-gray-300 bg-white dark:bg-gray-800 rounded-lg border border-gray-300 dark:border-gray-600 hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors"
    >
      <ChevronLeft class="h-4 w-4 mr-1.5" />
      Retour au profil
    </NuxtLink>
  </div>
</template>

<script setup>
import { ChevronLeft } from 'lucide-vue-next'

defineProps({
  title: {
    type: String,
    default: ''
  },
  subtitle: {
    type: String,
    default: ''
  }
})
</script> 