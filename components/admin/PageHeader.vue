<template>
  <div class="mb-10">
    <!-- Bannière colorée avec animation subtile -->
    <div class="relative overflow-hidden rounded-t-xl mb-6">
      <div class="h-1.5 w-full bg-gradient-to-r from-primary-600 via-blue-500 to-indigo-600 animate-gradient-x"></div>
    </div>
    
    <!-- Header principal avec titre et actions -->
    <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-5 mb-8">
      <div class="animate-fade-in">
        <h1 class="text-[28px] font-bold text-gray-900 tracking-tight">{{ title }}</h1>
        <p v-if="subtitle" class="mt-1 text-[15px] text-gray-500 max-w-2xl">{{ subtitle }}</p>
      </div>
      
      <div class="flex items-center gap-3 animate-fade-in-delayed">
        <slot name="actions"></slot>
      </div>
    </div>
    
    <!-- Cartes de statistiques avec animation staggered -->
    <div v-if="$slots.stats" class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 mb-8 stats-grid">
      <slot name="stats"></slot>
    </div>
    
    <!-- Section supplémentaire pour les filtres/recherche -->
    <div v-if="$slots.filters" 
      class="bg-white rounded-xl border border-gray-200 p-6 shadow-sm hover:shadow-md transition-all duration-300 animate-fade-up">
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

<style scoped>
.animate-gradient-x {
  background-size: 200% 200%;
  animation: gradient-x 8s ease infinite;
}

@keyframes gradient-x {
  0% { background-position: 0% 50% }
  50% { background-position: 100% 50% }
  100% { background-position: 0% 50% }
}

.animate-fade-in {
  animation: fade-in 0.6s ease-out;
}

.animate-fade-in-delayed {
  animation: fade-in 0.6s ease-out 0.2s both;
}

.animate-fade-up {
  animation: fade-up 0.5s ease-out 0.3s both;
}

@keyframes fade-in {
  from { opacity: 0; }
  to { opacity: 1; }
}

@keyframes fade-up {
  from { 
    opacity: 0;
    transform: translateY(10px);
  }
  to { 
    opacity: 1;
    transform: translateY(0);
  }
}

.stats-grid > * {
  opacity: 0;
  animation: fade-up 0.4s ease-out forwards;
}

.stats-grid > *:nth-child(1) { animation-delay: 0.1s; }
.stats-grid > *:nth-child(2) { animation-delay: 0.2s; }
.stats-grid > *:nth-child(3) { animation-delay: 0.3s; }
.stats-grid > *:nth-child(4) { animation-delay: 0.4s; }
</style> 