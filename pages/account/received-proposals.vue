<template>
  <div class="max-w-5xl mx-auto px-4 pt-5 pb-16">
    <h1 class="text-2xl font-bold mb-6">Propositions reçues</h1>
    
    <!-- Filtres simples -->
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
        <div class="px-6 py-4 border-b border-gray-200 dark:border-gray-700">
          <div class="flex justify-between items-start">
            <div>
              <h3 class="font-medium text-gray-900 dark:text-white">
                {{ proposal.mission_title }}
              </h3>
              <p class="text-sm text-gray-500 dark:text-gray-400 mt-1 flex items-center">
                <UserCircle class="h-4 w-4 mr-1" /> {{ proposal.expert_name }}
                <span class="mx-2">•</span>
                {{ formatDate(proposal.created_at) }}
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
          <!-- Informations essentielles -->
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
              <p class="text-xs text-gray-500 dark:text-gray-400">Reçue le</p>
              <p class="font-medium text-gray-900 dark:text-white">{{ formatDate(proposal.created_at) }}</p>
            </div>
          </div>
          
          <!-- Message de l'expert -->
          <div class="mb-4">
            <p class="text-xs text-gray-500 dark:text-gray-400 mb-1">Message de l'expert</p>
            <p class="text-sm text-gray-700 dark:text-gray-300">{{ proposal.description }}</p>
          </div>
          
          <!-- Actions -->
          <div class="flex justify-between items-center">
            <NuxtLink 
              :to="`/experts/${proposal.expert_id}`"
              class="text-sm text-primary-600 hover:text-primary-500 dark:text-primary-400 font-medium"
            >
              Voir le profil
            </NuxtLink>
            
            <div class="flex gap-2">
              <!-- Actions uniquement pour les propositions en attente -->
              <template v-if="proposal.status === 'pending'">
                <button 
                  @click="acceptProposal(proposal.id)"
                  class="px-3 py-1.5 text-sm font-medium rounded-lg bg-green-100 hover:bg-green-200 dark:bg-green-900/20 dark:hover:bg-green-900/30 text-green-700 dark:text-green-400"
                >
                  Accepter
                </button>
                
                <button 
                  @click="rejectProposal(proposal.id)"
                  class="px-3 py-1.5 text-sm font-medium rounded-lg bg-gray-100 hover:bg-gray-200 dark:bg-gray-700 dark:hover:bg-gray-600 text-gray-700 dark:text-gray-300"
                >
                  Refuser
                </button>
              </template>
              
              <!-- Actions pour les propositions acceptées -->
              <button 
                v-if="proposal.status === 'accepted'"
                @click="contactExpert(proposal.expert_id)"
                class="px-3 py-1.5 text-sm font-medium rounded-lg bg-primary-100 hover:bg-primary-200 dark:bg-primary-900/20 dark:hover:bg-primary-900/30 text-primary-700 dark:text-primary-400"
              >
                Contacter l'expert
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
      <Inbox class="h-12 w-12 text-gray-300 dark:text-gray-600 mx-auto mb-3" />
      <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-1">Aucune proposition</h3>
      <p class="text-gray-500 dark:text-gray-400 mb-4">
        {{ 
          currentFilter === 'all' 
            ? 'Vous n\'avez pas encore reçu de propositions d\'experts.' 
            : `Vous n'avez pas de propositions ${getStatusText(currentFilter).toLowerCase()}.` 
        }}
      </p>
      <NuxtLink 
        to="/requests/new" 
        class="inline-flex items-center px-4 py-2 bg-primary-600 hover:bg-primary-700 text-white rounded-lg font-medium"
      >
        Créer une demande
      </NuxtLink>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { Inbox, UserCircle } from 'lucide-vue-next'
import { useRouter } from 'vue-router'

const router = useRouter()

// Filtrage
const currentFilter = ref('all')

// Données fictives des propositions reçues
const proposals = ref([
  {
    id: 1,
    mission_id: 101,
    mission_title: "Création d'un logo pour ma startup",
    expert_id: 201,
    expert_name: "Olivier Dubois",
    price: 450,
    delivery_time: 7,
    description: "Je peux vous créer un logo moderne et professionnel en 7 jours, avec 3 concepts initiaux et 2 rounds de révisions. Vous recevrez tous les formats nécessaires (AI, EPS, PNG, JPG) ainsi que le guide d'utilisation.",
    status: "pending",
    created_at: "2023-09-18T08:45:00Z"
  },
  {
    id: 2,
    mission_id: 101,
    mission_title: "Création d'un logo pour ma startup",
    expert_id: 202,
    expert_name: "Marie Toure",
    price: 380,
    delivery_time: 5,
    description: "Spécialiste en design minimaliste, je vous propose une identité visuelle épurée et mémorable. Le forfait inclut le logo en plusieurs formats, une carte de visite et un favicon.",
    status: "pending",
    created_at: "2023-09-17T15:30:00Z"
  },
  {
    id: 3,
    mission_id: 102,
    mission_title: "Développement d'une application mobile",
    expert_id: 203,
    expert_name: "Thomas Konaté",
    price: 3800,
    delivery_time: 45,
    description: "Je développerai votre application mobile native pour iOS et Android avec Flutter, incluant toutes les fonctionnalités demandées, un backend sécurisé et un panel d'administration.",
    status: "accepted",
    created_at: "2023-09-10T11:20:00Z"
  },
  {
    id: 4,
    mission_id: 103,
    mission_title: "Traduction de mon site web en anglais",
    expert_id: 204,
    expert_name: "Sophie Diarra",
    price: 250,
    delivery_time: 3,
    description: "Traductrice professionnelle anglais-français avec 8 ans d'expérience, je vous propose une traduction précise et naturelle de votre site web, optimisée pour le référencement.",
    status: "rejected",
    created_at: "2023-09-05T14:15:00Z"
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
const acceptProposal = (id) => {
  if (confirm('Êtes-vous sûr de vouloir accepter cette proposition ?')) {
    // Dans un environnement réel, vous appelleriez votre API
    // pour mettre à jour le statut et créer un contrat
    
    const proposalIndex = proposals.value.findIndex(p => p.id === id)
    if (proposalIndex !== -1) {
      // Mettre à jour la proposition sélectionnée
      proposals.value[proposalIndex].status = 'accepted'
      
      // Mettre à jour les autres propositions pour la même demande
      const missionId = proposals.value[proposalIndex].mission_id
      proposals.value.forEach((p, index) => {
        if (p.id !== id && p.mission_id === missionId && p.status === 'pending') {
          proposals.value[index].status = 'rejected'
        }
      })
    }
    
    // Afficher une confirmation
    alert('Proposition acceptée. Un contrat a été créé.')
  }
}

const rejectProposal = (id) => {
  if (confirm('Êtes-vous sûr de vouloir refuser cette proposition ?')) {
    // Dans un environnement réel, vous appelleriez votre API
    const proposalIndex = proposals.value.findIndex(p => p.id === id)
    if (proposalIndex !== -1) {
      proposals.value[proposalIndex].status = 'rejected'
    }
  }
}

const contactExpert = (expertId) => {
  router.push(`/messages/expert/${expertId}`)
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