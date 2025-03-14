<template>
  <div>
    <h1 class="text-2xl font-bold mb-6">Mes contrats</h1>
    
    <!-- Filtres simplifiés -->
    <div class="mb-6 flex gap-4">
      <button 
        v-for="status in ['all', 'active', 'completed', 'draft']" 
        :key="status"
        @click="currentFilter = status"
        class="px-3 py-1.5 rounded-lg text-sm font-medium"
        :class="currentFilter === status 
          ? 'bg-primary-100 dark:bg-primary-900/30 text-primary-600 dark:text-primary-400' 
          : 'bg-gray-100 dark:bg-gray-800 text-gray-700 dark:text-gray-300 hover:bg-gray-200 dark:hover:bg-gray-700'"
      >
        {{ getStatusText(status) }}
      </button>
    </div>
    
    <!-- Liste des contrats -->
    <div class="space-y-4">
      <div 
        v-for="contract in filteredContracts" 
        :key="contract.id"
        class="bg-white dark:bg-gray-800 rounded-lg shadow p-4 hover:shadow-md transition-shadow"
      >
        <div class="flex justify-between items-start">
          <div>
            <h3 class="font-medium text-gray-900 dark:text-white">{{ contract.title }}</h3>
            <p class="text-sm text-gray-500 dark:text-gray-400">{{ formatDate(contract.created_at) }}</p>
          </div>
          <span 
            class="px-2.5 py-0.5 rounded-full text-xs font-medium"
            :class="getStatusClasses(contract.status)"
          >
            {{ getStatusText(contract.status) }}
          </span>
        </div>
        
        <div class="mt-3 flex justify-between items-center">
          <p class="text-sm font-medium text-gray-900 dark:text-white">{{ formatCurrency(contract.amount) }}</p>
          <NuxtLink 
            :to="`/contracts/${contract.id}`"
            class="text-primary-600 hover:text-primary-500 text-sm font-medium"
          >
            Voir les détails
          </NuxtLink>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
// Le reste du code...
</script> 