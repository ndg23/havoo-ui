<template>
  <div 
    class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 overflow-hidden shadow-sm hover:shadow-md transition-shadow"
    :class="{ 'border-primary-200 dark:border-primary-700': isHighlighted }"
  >
    <div class="p-5">
      <!-- En-tête avec le titre et le statut -->
      <div class="flex justify-between items-start mb-3">
        <h3 class="font-medium text-gray-900 dark:text-white">{{ request.title }}</h3>
        <span 
          class="px-2 py-0.5 text-xs font-medium rounded-full"
          :class="getStatusClasses(request.status)"
        >
          {{ getStatusText(request.status) }}
        </span>
      </div>
      
      <!-- Description courte -->
      <p class="text-sm text-gray-600 dark:text-gray-300 mb-4 line-clamp-2">
        {{ request.description }}
      </p>
      
      <!-- Informations clés -->
      <div class="grid grid-cols-2 gap-3 mb-4 text-sm">
        <div>
          <p class="text-xs text-gray-500 dark:text-gray-400">Budget</p>
          <p class="font-medium text-gray-900 dark:text-white">
            {{ request.budget ? formatCurrency(request.budget) : 'Non spécifié' }}
          </p>
        </div>
        <div>
          <p class="text-xs text-gray-500 dark:text-gray-400">Délai</p>
          <p class="font-medium text-gray-900 dark:text-white">
            {{ request.deadline ? formatDate(request.deadline) : 'Flexible' }}
          </p>
        </div>
      </div>
      
      <!-- Compteur de propositions (pour les clients) -->
      <div v-if="isClient && request.proposals_count > 0" class="mb-4 flex items-center">
        <span class="px-2 py-0.5 bg-primary-100 dark:bg-primary-900/20 text-primary-700 dark:text-primary-400 text-xs font-medium rounded-full flex items-center">
          <MessageSquare class="h-3 w-3 mr-1" />
          {{ request.proposals_count }} proposition{{ request.proposals_count > 1 ? 's' : '' }}
        </span>
      </div>
      
      <!-- Actions -->
      <div class="flex justify-between items-center mt-2">
        <NuxtLink 
          :to="isClient ? `/account/requests/${request.id}` : `/requests/${request.id}`"
          class="text-sm text-primary-600 hover:text-primary-500 dark:text-primary-400 font-medium"
        >
          Voir les détails
        </NuxtLink>
        
        <div>
          <!-- Action principale selon le rôle et statut -->
          <template v-if="isClient">
            <NuxtLink 
              v-if="request.proposals_count > 0"
              :to="`/account/received-proposals?request=${request.id}`"
              class="px-3 py-1.5 text-xs font-medium rounded-lg bg-primary-100 hover:bg-primary-200 dark:bg-primary-900/20 dark:hover:bg-primary-900/30 text-primary-700 dark:text-primary-400"
            >
              Voir les propositions
            </NuxtLink>
            <span 
              v-else
              class="text-xs text-gray-500 dark:text-gray-400"
            >
              Aucune proposition
            </span>
          </template>
          
          <template v-else>
            <NuxtLink 
              v-if="request.status === 'open'"
              :to="`/requests/${request.id}/propose`"
              class="px-3 py-1.5 text-xs font-medium rounded-lg bg-primary-100 hover:bg-primary-200 dark:bg-primary-900/20 dark:hover:bg-primary-900/30 text-primary-700 dark:text-primary-400"
            >
              Proposer mes services
            </NuxtLink>
            <span 
              v-else
              class="text-xs text-gray-500 dark:text-gray-400"
            >
              Demande fermée
            </span>
          </template>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { MessageSquare } from 'lucide-vue-next'

// Définition des props
const props = defineProps({
  request: {
    type: Object,
    required: true
  },
  isClient: {
    type: Boolean,
    default: false
  },
  isHighlighted: {
    type: Boolean,
    default: false
  }
})

// Formatage et helpers
const formatCurrency = (amount) => {
  return new Intl.NumberFormat('fr-FR', { style: 'currency', currency: 'EUR' }).format(amount)
}

const formatDate = (dateString) => {
  const date = new Date(dateString)
  return new Intl.DateTimeFormat('fr-FR', { 
    day: 'numeric', 
    month: 'long'
  }).format(date)
}

const getStatusText = (status) => {
  const statusMap = {
    'open': 'Ouvert',
    'assigned': 'Attribué',
    'completed': 'Terminé',
    'cancelled': 'Annulé'
  }
  return statusMap[status] || status
}

const getStatusClasses = (status) => {
  const classMap = {
    'open': 'bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-400',
    'assigned': 'bg-blue-100 text-blue-800 dark:bg-blue-900/30 dark:text-blue-400',
    'completed': 'bg-gray-100 text-gray-800 dark:bg-gray-700 dark:text-gray-300',
    'cancelled': 'bg-red-100 text-red-800 dark:bg-red-900/30 dark:text-red-400'
  }
  return classMap[status] || ''
}
</script> 