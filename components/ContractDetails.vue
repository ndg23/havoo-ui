<template>
  <div class="bg-white dark:bg-gray-800 rounded-lg shadow p-6">
    <!-- En-tête du contrat -->
    <div class="mb-6">
      <h3 class="text-lg font-medium text-gray-900 dark:text-white">{{ contract.title }}</h3>
      <p class="text-sm text-gray-500 dark:text-gray-400">{{ formatDate(contract.created_at) }}</p>
    </div>
    
    <!-- Détails du contrat -->
    <div class="space-y-4">
      <div>
        <p class="text-sm font-medium text-gray-500 dark:text-gray-400">Statut</p>
        <div class="mt-1">
          <span 
            class="px-2.5 py-0.5 rounded-full text-xs font-medium"
            :class="getStatusClasses(contract.status)"
          >
            {{ getStatusText(contract.status) }}
          </span>
        </div>
      </div>
      
      <div>
        <p class="text-sm font-medium text-gray-500 dark:text-gray-400">Montant total</p>
        <p class="mt-1 text-sm text-gray-900 dark:text-white">{{ formatCurrency(contract.amount) }}</p>
      </div>
      
      <div>
        <p class="text-sm font-medium text-gray-500 dark:text-gray-400">Description</p>
        <p class="mt-1 text-sm text-gray-900 dark:text-white">{{ contract.description }}</p>
      </div>
      
      <div>
        <p class="text-sm font-medium text-gray-500 dark:text-gray-400">Dates</p>
        <p class="mt-1 text-sm text-gray-900 dark:text-white">
          {{ formatDate(contract.start_date) }} - {{ contract.end_date ? formatDate(contract.end_date) : 'En cours' }}
        </p>
      </div>
      
      <!-- Section des livrables (remplace la section des milestones) -->
      <div>
        <p class="text-sm font-medium text-gray-500 dark:text-gray-400">Livrables attendus</p>
        <p class="mt-1 text-sm text-gray-900 dark:text-white">{{ contract.deliverable_description || 'Aucune description spécifiée' }}</p>
        
        <div v-if="contract.deliverable_files && contract.deliverable_files.length > 0" class="mt-2">
          <p class="text-sm font-medium text-gray-500 dark:text-gray-400">Fichiers livrés</p>
          <ul class="mt-1 space-y-1">
            <li v-for="file in contract.deliverable_files" :key="file" class="text-sm">
              <a :href="file" class="text-primary-600 hover:text-primary-500 dark:text-primary-400" target="_blank">
                {{ getFileName(file) }}
              </a>
            </li>
          </ul>
        </div>
      </div>
    </div>
    
    <!-- Boutons d'action -->
    <div class="mt-6 flex flex-wrap gap-3">
      <button 
        v-if="contract.status === 'active'" 
        class="px-4 py-2 bg-primary-600 hover:bg-primary-700 text-white rounded-lg text-sm font-medium"
      >
        Marquer comme terminé
      </button>
      
      <button 
        v-if="['draft', 'active'].includes(contract.status)" 
        class="px-4 py-2 bg-gray-100 hover:bg-gray-200 dark:bg-gray-700 dark:hover:bg-gray-600 text-gray-800 dark:text-gray-200 rounded-lg text-sm font-medium"
      >
        {{ contract.status === 'draft' ? 'Éditer le contrat' : 'Contacter le client' }}
      </button>
    </div>
  </div>
</template>

<script setup>
// Le reste du code...
</script> 