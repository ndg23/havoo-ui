<template>
  <div class="max-w-5xl mx-auto px-4 pt-5 pb-16">
    <h1 class="text-2xl font-bold mb-6">Mes propositions</h1>
    
    <!-- Filtres -->
    <div class="mb-6 flex flex-wrap gap-3">
      <button 
        v-for="status in ['all', 'pending', 'accepted', 'rejected']" 
        :key="status"
        @click="currentFilter = status"
        class="px-3 py-1.5 rounded-lg text-sm font-medium transition-colors"
        :class="currentFilter === status 
          ? 'bg-primary-100 dark:bg-primary-900/30 text-primary-600 dark:text-primary-400' 
          : 'bg-gray-100 dark:bg-gray-800 text-gray-700 dark:text-gray-300 hover:bg-gray-200 dark:hover:bg-gray-700'"
      >
        {{ getStatusText(status) }}
      </button>
    </div>
    
    <!-- Liste des propositions -->
    <div v-if="filteredProposals.length" class="space-y-4">
      <div 
        v-for="proposal in filteredProposals" 
        :key="proposal.id"
        class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 overflow-hidden shadow-sm hover:shadow-md transition-shadow"
      >
        <div class="border-b border-gray-200 dark:border-gray-700 px-6 py-4">
          <div class="flex justify-between items-start">
            <div>
              <h3 class="font-medium text-gray-900 dark:text-white">{{ proposal.request_title }}</h3>
              <p class="text-sm text-gray-500 dark:text-gray-400 mt-1">
                Proposé à {{ proposal.client_name }} · {{ formatDate(proposal.created_at) }}
              </p>
            </div>
            <span 
              class="px-2.5 py-1 rounded-full text-xs font-medium"
              :class="getStatusBadgeClasses(proposal.status)"
            >
              {{ getStatusText(proposal.status) }}
            </span>
          </div>
        </div>
        
        <div class="px-6 py-4">
          <div class="grid grid-cols-1 sm:grid-cols-3 gap-4 mb-4">
            <div>
              <p class="text-xs text-gray-500 dark:text-gray-400">Montant proposé</p>
              <p class="font-medium text-gray-900 dark:text-white">{{ formatCurrency(proposal.price) }}</p>
            </div>
            <div>
              <p class="text-xs text-gray-500 dark:text-gray-400">Délai de livraison</p>
              <p class="font-medium text-gray-900 dark:text-white">{{ proposal.delivery_time }} jours</p>
            </div>
            <div>
              <p class="text-xs text-gray-500 dark:text-gray-400">Date de proposition</p>
              <p class="font-medium text-gray-900 dark:text-white">{{ formatDate(proposal.created_at) }}</p>
            </div>
          </div>
          
          <div class="mb-4">
            <p class="text-xs text-gray-500 dark:text-gray-400 mb-1">Votre message</p>
            <p class="text-sm text-gray-700 dark:text-gray-300">{{ proposal.description }}</p>
          </div>
          
          <div class="flex justify-between items-center">
            <NuxtLink 
              :to="`/requests/${proposal.request_id}`"
              class="text-sm text-primary-600 hover:text-primary-500 dark:text-primary-400 font-medium"
            >
              Voir la demande
            </NuxtLink>
            
            <div class="flex gap-2">
              <button 
                v-if="proposal.status === 'pending'" 
                @click="editProposal(proposal.id)"
                class="px-3 py-1.5 text-sm font-medium rounded-lg bg-gray-100 hover:bg-gray-200 dark:bg-gray-700 dark:hover:bg-gray-600 text-gray-700 dark:text-gray-300"
              >
                Modifier
              </button>
              
              <button 
                v-if="proposal.status === 'accepted'" 
                class="px-3 py-1.5 text-sm font-medium rounded-lg bg-green-100 hover:bg-green-200 dark:bg-green-800/30 dark:hover:bg-green-800/40 text-green-700 dark:text-green-400"
              >
                Contacter le client
              </button>
              
              <button 
                v-if="proposal.status === 'rejected'" 
                @click="deleteProposal(proposal.id)"
                class="px-3 py-1.5 text-sm font-medium rounded-lg bg-gray-100 hover:bg-gray-200 dark:bg-gray-700 dark:hover:bg-gray-600 text-gray-700 dark:text-gray-300"
              >
                Supprimer
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
    
    <!-- État vide -->
    <div 
      v-else
      class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 p-8 text-center"
    >
      <FileText class="h-12 w-12 text-gray-300 dark:text-gray-600 mx-auto mb-3" />
      <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-1">Aucune proposition trouvée</h3>
      <p class="text-gray-500 dark:text-gray-400 mb-4">
        {{ 
          currentFilter === 'all' 
            ? 'Vous n\'avez pas encore soumis de propositions aux clients.' 
            : `Vous n'avez pas de propositions ${getStatusText(currentFilter).toLowerCase()}.` 
        }}
      </p>
      <NuxtLink 
        to="/requests" 
        class="inline-flex items-center px-4 py-2 bg-primary-600 hover:bg-primary-700 text-white rounded-lg font-medium"
      >
        Parcourir les demandes
      </NuxtLink>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { FileText } from 'lucide-vue-next'
import { useRouter } from 'vue-router'

const router = useRouter()

// Filtrage
const currentFilter = ref('all')

// Données fictives des propositions
const proposals = ref([
  {
    id: 1,
    request_id: 101,
    request_title: "Développement d'un site e-commerce",
    client_name: "Sophie Koné",
    price: 2800,
    delivery_time: 30,
    description: "Je peux développer votre site e-commerce complet avec WordPress et WooCommerce, incluant une personnalisation complète du thème, la configuration des méthodes de paiement et la formation à l'utilisation du dashboard admin.",
    status: "pending",
    created_at: "2023-09-15T10:30:00Z"
  },
  {
    id: 2,
    request_id: 102,
    request_title: "Conception de logo pour une entreprise locale",
    client_name: "Ibrahim Diallo",
    price: 350,
    delivery_time: 7,
    description: "Je vous propose 3 concepts initiaux, avec 2 cycles de révision et la livraison des fichiers dans tous les formats demandés (AI, EPS, PNG, JPG, PDF).",
    status: "accepted",
    created_at: "2023-09-10T14:20:00Z"
  },
  {
    id: 3,
    request_id: 103,
    request_title: "Rédaction d'articles SEO pour site de nutrition",
    client_name: "Aminata Touré",
    price: 450,
    delivery_time: 14,
    description: "Je peux rédiger 5 articles optimisés SEO de 1500 mots chacun, avec recherche approfondie des mots-clés et intégration des tendances actuelles en nutrition.",
    status: "rejected",
    created_at: "2023-09-05T09:15:00Z"
  },
  {
    id: 4,
    request_id: 104,
    request_title: "Développement d'application mobile de recettes",
    client_name: "Moussa Camara",
    price: 3500,
    delivery_time: 45,
    description: "Je propose de développer l'application complète sous React Native, avec fonctionnalités de recherche, favoris, et suggestions personnalisées. Livraison pour iOS et Android.",
    status: "pending",
    created_at: "2023-09-12T16:45:00Z"
  }
])

// Propositions filtrées
const filteredProposals = computed(() => {
  if (currentFilter.value === 'all') {
    return proposals.value
  }
  return proposals.value.filter(proposal => proposal.status === currentFilter.value)
})

// Formatage et helpers
const formatCurrency = (amount) => {
  return new Intl.NumberFormat('fr-FR', { style: 'currency', currency: 'EUR' }).format(amount)
}

const formatDate = (dateString) => {
  const date = new Date(dateString)
  return new Intl.DateTimeFormat('fr-FR', { 
    day: 'numeric', 
    month: 'long', 
    year: 'numeric' 
  }).format(date)
}

const getStatusText = (status) => {
  const statusMap = {
    'all': 'Toutes',
    'pending': 'En attente',
    'accepted': 'Acceptées',
    'rejected': 'Refusées'
  }
  return statusMap[status] || status
}

const getStatusBadgeClasses = (status) => {
  const classMap = {
    'pending': 'bg-yellow-100 text-yellow-800 dark:bg-yellow-900/30 dark:text-yellow-400',
    'accepted': 'bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-400',
    'rejected': 'bg-red-100 text-red-800 dark:bg-red-900/30 dark:text-red-400'
  }
  return classMap[status] || ''
}

// Actions
const editProposal = (id) => {
  // Rediriger vers la page d'édition ou ouvrir une modal
  console.log(`Éditer la proposition ${id}`)
}

const deleteProposal = (id) => {
  if (confirm('Êtes-vous sûr de vouloir supprimer cette proposition ?')) {
    // Ici vous appelleriez votre API pour supprimer
    console.log(`Suppression de la proposition ${id}`)
    proposals.value = proposals.value.filter(p => p.id !== id)
  }
}

// Définition de la structure de page
definePageMeta({
  layout: 'default'
})
</script>

<style scoped>
/* Animation pour l'apparition des propositions */
.rounded-xl {
  animation: fadeIn 0.3s ease-out;
  animation-fill-mode: both;
}

/* Animation séquentielle pour les éléments */
.space-y-4 > div:nth-child(1) { animation-delay: 0.05s; }
.space-y-4 > div:nth-child(2) { animation-delay: 0.1s; }
.space-y-4 > div:nth-child(3) { animation-delay: 0.15s; }
.space-y-4 > div:nth-child(4) { animation-delay: 0.2s; }

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(8px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
</style> 