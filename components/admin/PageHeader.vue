<template>
  <div class="mb-8">
    <!-- Bannière colorée au-dessus de la section -->
    <div class="h-1.5 w-full bg-gradient-to-r from-primary-600 to-indigo-500 rounded-t-lg mb-6"></div>
    
    <!-- Header principal avec titre et actions -->
    <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4 mb-6">
      <div>
        <h1 class="text-2xl font-bold text-gray-900">{{ title }}</h1>
        <p v-if="subtitle" class="mt-1 text-sm text-gray-500">{{ subtitle }}</p>
      </div>
      
      <slot name="actions"></slot>
    </div>
    
    <!-- Cartes de statistiques -->
    <div v-if="$slots.stats" class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 mb-6">
      <slot name="stats"></slot>
    </div>
    
    <!-- Section supplémentaire pour les filtres/recherche -->
    <div v-if="$slots.filters" class="bg-white rounded-xl border border-gray-200 p-5 shadow-sm">
      <slot name="filters"></slot>
    </div>
  </div>
</template>

<script setup>
defineProps({
  title: {
    type: String,
    required: true
  },
  subtitle: {
    type: String,
    default: ''
  }
})
</script> 