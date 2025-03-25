<template>
  <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 overflow-hidden shadow-sm transition-all duration-200">
    <!-- En-tête avec titre et statut -->
    <div class="p-4 border-b border-gray-100 dark:border-gray-700">
      <div class="flex justify-between items-start">
        <div class="flex">
          <!-- Avatar de l'autre partie -->
          <div class="flex-shrink-0 mr-3">
            <div v-if="otherPartyAvatar" class="h-10 w-10 rounded-full overflow-hidden">
              <img :src="otherPartyAvatar" :alt="otherPartyName" class="h-full w-full object-cover" />
            </div>
            <div v-else class="h-10 w-10 rounded-full bg-primary-100 dark:bg-primary-900/30 flex items-center justify-center text-primary-600 dark:text-primary-400 font-medium">
              {{ getInitials(otherPartyName) }}
            </div>
          </div>
          
          <!-- Titre et nom -->
          <div>
            <p class="text-sm font-medium text-gray-500 dark:text-gray-400">
              <span>{{ isClient ? 'Expert' : 'Client' }}:</span>
              <span class="text-gray-900 dark:text-white ml-1">{{ otherPartyName }}</span>
            </p>
            <h3 class="text-base font-bold text-gray-900 dark:text-white line-clamp-1">
              {{ contract.job_title }}
            </h3>
          </div>
        </div>
        
        <!-- Badge de statut -->
        <span 
          class="px-2.5 py-0.5 rounded-full text-xs font-medium"
          :class="getStatusClass(contract.status)"
        >
          {{ getStatusLabel(contract.status) }}
        </span>
      </div>
    </div>
    
    <!-- Informations principales -->
    <div class="p-4">
      <!-- Grille d'informations -->
      <div class="grid grid-cols-2 gap-4">
        <!-- Prix -->
        <div class="bg-gray-50 dark:bg-gray-800/80 p-3 rounded-lg">
          <p class="text-xs font-medium text-gray-500 dark:text-gray-400 mb-1">Montant</p>
          <p class="font-bold text-gray-900 dark:text-white">{{ formatPrice(contract.agreed_price) }}</p>
        </div>
        
        <!-- Période -->
        <div class="bg-gray-50 dark:bg-gray-800/80 p-3 rounded-lg">
          <p class="text-xs font-medium text-gray-500 dark:text-gray-400 mb-1">Échéance</p>
          <p class="font-medium text-gray-900 dark:text-white text-sm">
            {{ formatDate(contract.end_date) }}
          </p>
        </div>
      </div>
      
      <!-- Statut des évaluations avec style Twitter -->
      <div class="mt-4">
        <div class="flex items-center">
          <span 
            class="w-2 h-2 rounded-full mr-2"
            :class="getRatingStatusColor(contract.rating_status)"
          ></span>
          <p class="text-sm font-medium" :class="getRatingStatusClass(contract.rating_status)">
            {{ contract.rating_status }}
          </p>
        </div>
      </div>
      
      <!-- Actions -->
      <div class="mt-4 flex flex-wrap justify-between items-center gap-2">
        <NuxtLink 
          :to="`/account/contracts/${contract.contract_id}`"
          class="text-sm font-medium text-primary-600 dark:text-primary-400 hover:text-primary-700 dark:hover:text-primary-300 flex items-center group"
        >
          <span>Voir les détails</span>
          <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 ml-1 transform transition-transform group-hover:translate-x-0.5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
          </svg>
        </NuxtLink>
        
        <div class="flex flex-wrap gap-2">
          <!-- Bouton pour laisser une évaluation -->
          <NuxtLink 
            v-if="contract.status === 'completed' && showRatingButton"
            :to="`/account/contracts/${contract.contract_id}/rate`"
            class="inline-flex items-center px-3 py-1.5 border border-transparent rounded-full text-xs font-medium text-white bg-primary-600 hover:bg-primary-700 shadow-sm transition-colors"
          >
            <Star class="h-3.5 w-3.5 mr-1.5" />
            <span>Évaluer</span>
          </NuxtLink>
          
          <!-- Bouton pour marquer comme terminé -->
          <button 
            v-if="contract.status === 'active' && isClient"
            @click="$emit('complete', contract.contract_id)"
            class="inline-flex items-center px-3 py-1.5 border border-transparent rounded-full text-xs font-medium text-white bg-green-600 hover:bg-green-700 shadow-sm transition-colors"
          >
            <Check class="h-3.5 w-3.5 mr-1.5" />
            <span>Terminer</span>
          </button>
          
          <!-- Bouton pour contacter -->
          <button 
            @click="$emit('contact', otherPartyId)"
            class="inline-flex items-center px-3 py-1.5 border border-gray-200 dark:border-gray-700 rounded-full text-xs font-medium text-gray-700 dark:text-gray-300 bg-white dark:bg-gray-800 hover:bg-gray-50 dark:hover:bg-gray-700 shadow-sm transition-colors"
          >
            <MessageSquare class="h-3.5 w-3.5 mr-1.5" />
            <span>Contacter</span>
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue';
import { Star, Check, MessageSquare } from 'lucide-vue-next';

// Récupération des props du composant
const props = defineProps({
  contract: {
    type: Object,
    required: true
  },
  isClient: {
    type: Boolean,
    default: false
  },
  currentUserId: {
    type: String,
    required: true
  }
});

// Émetteur d'événements pour les actions
const emit = defineEmits(['complete', 'contact']);

// Computed properties pour l'autre partie
const otherPartyName = computed(() => {
  return props.isClient ? props.contract.worker_name : props.contract.client_name;
});

const otherPartyId = computed(() => {
  return props.isClient ? props.contract.worker_id : props.contract.client_id;
});

const otherPartyAvatar = computed(() => {
  // Note: Vous devrez adapter cette partie selon la façon dont vous stockez les avatars
  return null; // À remplacer par la logique appropriée
});

// Déterminer si on doit afficher le bouton d'évaluation
const showRatingButton = computed(() => {
  if (props.contract.status !== 'completed') return false;
  
  // Vérifier si l'utilisateur a déjà laissé une évaluation
  if (props.isClient) {
    return !props.contract.client_has_rated;
  } else {
    return !props.contract.expert_has_rated;
  }
});

// Méthodes pour formater et afficher les données
const formatPrice = (price) => {
  if (!price) return 'Prix non défini';
  return new Intl.NumberFormat('fr-FR', {
    style: 'currency',
    currency: 'XOF',
    maximumFractionDigits: 0
  }).format(price);
};

const formatDate = (dateString) => {
  if (!dateString) return '';
  const date = new Date(dateString);
  return new Intl.DateTimeFormat('fr-FR', {
    day: 'numeric',
    month: 'short',
    year: 'numeric'
  }).format(date);
};

const getInitials = (name) => {
  if (!name) return '??';
  return name
    .split(' ')
    .map(part => part.charAt(0))
    .join('')
    .toUpperCase();
};

const getStatusClass = (status) => {
  const classes = {
    'pending': 'bg-yellow-100 dark:bg-yellow-900/30 text-yellow-800 dark:text-yellow-200',
    'active': 'bg-blue-100 dark:bg-blue-900/30 text-blue-800 dark:text-blue-200',
    'completed': 'bg-green-100 dark:bg-green-900/30 text-green-800 dark:text-green-200',
    'cancelled': 'bg-red-100 dark:bg-red-900/30 text-red-800 dark:text-red-200'
  };
  return classes[status] || 'bg-gray-100 dark:bg-gray-700 text-gray-800 dark:text-gray-200';
};

const getStatusLabel = (status) => {
  const labels = {
    'pending': 'En attente',
    'active': 'En cours',
    'completed': 'Terminé',
    'cancelled': 'Annulé'
  };
  return labels[status] || 'Inconnu';
};

const getRatingStatusClass = (status) => {
  if (status.includes('Notations complétées')) {
    return 'text-green-600 dark:text-green-400';
  } else if (status.includes('En attente')) {
    return 'text-yellow-600 dark:text-yellow-400';
  }
  return 'text-gray-600 dark:text-gray-400';
};

const getRatingStatusColor = (status) => {
  if (status.includes('Notations complétées')) {
    return 'bg-green-500';
  } else if (status.includes('En attente')) {
    return 'bg-yellow-500';
  }
  return 'bg-gray-400';
};
</script> 