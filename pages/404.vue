<template>
  <div class="min-h-screen flex items-center justify-center bg-gray-50 dark:bg-gray-900 px-4">
    <div class="text-center max-w-md">
      <!-- Illustration -->
      <div class="mb-8 flex justify-center">
        <div class="w-24 h-24 rounded-full bg-primary-100 dark:bg-primary-900/30 flex items-center justify-center">
          <Map class="h-12 w-12 text-primary-600 dark:text-primary-400" />
        </div>
      </div>
      
      <!-- Message -->
      <h1 class="text-4xl font-bold text-gray-900 dark:text-white mb-3">404</h1>
      <h2 class="text-xl font-semibold text-gray-800 dark:text-gray-100 mb-3">Page introuvable</h2>
      <p class="text-gray-600 dark:text-gray-400 mb-6">
        La page que vous recherchez n'existe pas ou a été déplacée.
      </p>
      
      <!-- Actions -->
      <div class="flex flex-col sm:flex-row gap-3 justify-center">
        <NuxtLink 
          to="/" 
          class="px-5 py-2.5 bg-primary-600 hover:bg-primary-700 text-white font-medium rounded-full text-sm transition-colors"
        >
          Retour à l'accueil
        </NuxtLink>
        
        <button 
          @click="$router.back()" 
          class="px-5 py-2.5 bg-white dark:bg-gray-800 text-gray-700 dark:text-gray-300 border border-gray-300 dark:border-gray-700 font-medium rounded-full text-sm hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors"
        >
          Page précédente
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { Map } from 'lucide-vue-next'

// Définir un titre de page
useHead({
  title: 'Page introuvable | Havoo Services'
})
</script> 