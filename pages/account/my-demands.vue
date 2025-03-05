<template>
  <div class="max-w-5xl mx-auto px-4 py-12">
    <!-- En-tête -->
    <div class="flex items-center justify-between mb-8">
      <div>
        <h1 class="text-2xl font-bold text-gray-900">Mes demandes</h1>
        <p class="text-gray-600 mt-1">Gérez vos demandes de services</p>
      </div>
      <NuxtLink 
        to="/account" 
        class="text-sm text-gray-600 hover:text-gray-900 flex items-center gap-1"
      >
        <ArrowLeft class="w-4 h-4" />
        <span>Retour au profil</span>
      </NuxtLink>
    </div>
    
    <!-- Filtres et actions -->
    <div class="bg-white rounded-2xl shadow-sm border border-gray-200 p-6 mb-8">
      <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <!-- Filtres -->
        <div class="flex items-center gap-3">
          <button 
            @click="activeFilter = 'all'"
            class="px-4 py-2 rounded-xl text-sm font-medium transition-colors"
            :class="activeFilter === 'all' ? 'bg-primary-50 text-primary-700' : 'text-gray-700 hover:bg-gray-50'"
          >
            Toutes ({{ demands.length }})
          </button>
          <button 
            @click="activeFilter = 'active'"
            class="px-4 py-2 rounded-xl text-sm font-medium transition-colors"
            :class="activeFilter === 'active' ? 'bg-primary-50 text-primary-700' : 'text-gray-700 hover:bg-gray-50'"
          >
            Actives ({{ activeDemandsCount }})
          </button>
          <button 
            @click="activeFilter = 'completed'"
            class="px-4 py-2 rounded-xl text-sm font-medium transition-colors"
            :class="activeFilter === 'completed' ? 'bg-primary-50 text-primary-700' : 'text-gray-700 hover:bg-gray-50'"
          >
            Terminées ({{ completedDemandsCount }})
          </button>
        </div>
        
        <!-- Nouvelle demande -->
        <NuxtLink 
          to="/requests/new"
          class="flex items-center justify-center gap-2 px-4 py-2.5 bg-primary-600 text-white rounded-xl hover:bg-primary-700 transition-colors"
        >
          <Plus class="w-4 h-4" />
          <span class="text-sm font-medium">Nouvelle demande</span>
        </NuxtLink>
      </div>
    </div>
    
    <!-- Liste des demandes -->
    <div v-if="filteredDemands.length > 0" class="space-y-6">
      <div 
        v-for="demand in filteredDemands" 
        :key="demand.id"
        class="bg-white rounded-2xl shadow-sm border border-gray-200 overflow-hidden"
      >
        <!-- En-tête de la demande -->
        <div class="p-6 border-b border-gray-100">
          <div class="flex flex-col md:flex-row md:items-start justify-between gap-4">
            <!-- Informations principales -->
            <div class="flex-1">
              <div class="flex items-center gap-3">
                <div class="w-10 h-10 rounded-full bg-primary-50 flex items-center justify-center text-xl">
                  {{ getServiceIcon(demand.service) }}
                </div>
                <div>
                  <h2 class="text-lg font-medium text-gray-900">{{ demand.title }}</h2>
                  <div class="flex items-center gap-4 mt-1">
                    <span class="text-sm text-gray-500 flex items-center gap-1">
                      <Calendar class="w-4 h-4" />
                      {{ formatDate(demand.date) }}
                    </span>
                    <span class="text-sm text-gray-500 flex items-center gap-1">
                      <MapPin class="w-4 h-4" />
                      {{ demand.location }}
                    </span>
                  </div>
                </div>
              </div>
              
              <p class="mt-3 text-gray-700">{{ demand.description }}</p>
            </div>
            
            <!-- Statut et actions -->
            <div class="flex flex-col items-end gap-4">
              <span class="px-3 py-1 text-sm font-medium rounded-full"
                :class="getStatusClass(demand.status)"
              >
                {{ getStatusLabel(demand.status) }}
              </span>
              
              <div class="flex gap-2">
                <button 
                  v-if="demand.status !== 'completed'"
                  @click="showDeleteConfirmation(demand.id)"
                  class="p-2 text-gray-500 hover:text-red-600 hover:bg-red-50 rounded-full transition-colors"
                  title="Supprimer"
                >
                  <Trash2 class="w-5 h-5" />
                </button>
                <NuxtLink 
                  :to="`/requests/${demand.id}`"
                  class="p-2 text-gray-500 hover:text-primary-600 hover:bg-primary-50 rounded-full transition-colors"
                  title="Voir les détails"
                >
                  <Eye class="w-5 h-5" />
                </NuxtLink>
                <button 
                  v-if="demand.status === 'active'"
                  @click="toggleProposals(demand.id)"
                  class="p-2 text-gray-500 hover:text-primary-600 hover:bg-primary-50 rounded-full transition-colors"
                  :class="{ 'bg-primary-50 text-primary-600': expandedDemand === demand.id }"
                  title="Voir les propositions"
                >
                  <ChevronDown v-if="expandedDemand !== demand.id" class="w-5 h-5" />
                  <ChevronUp v-else class="w-5 h-5" />
                </button>
              </div>
            </div>
          </div>
        </div>
        
        <!-- Section des propositions (expandable) -->
        <div v-if="expandedDemand === demand.id" class="bg-gray-50 p-6">
          <h3 class="text-base font-medium text-gray-900 mb-4">
            {{ demand.proposals.length > 0 ? 'Propositions reçues' : 'Aucune proposition reçue' }}
          </h3>
          
          <div v-if="demand.proposals.length > 0" class="space-y-4">
            <div 
              v-for="proposal in demand.proposals" 
              :key="proposal.id"
              class="bg-white rounded-xl border border-gray-200 p-4 hover:border-primary-200 transition-colors"
            >
              <!-- En-tête de la proposition -->
              <div class="flex items-start justify-between">
                <div class="flex items-center gap-3">
                  <div class="w-12 h-12 rounded-full overflow-hidden">
                    <img 
                      :src="proposal.expert.avatar" 
                      :alt="proposal.expert.name"
                      class="w-full h-full object-cover"
                    />
                  </div>
                  <div>
                    <h4 class="font-medium text-gray-900">{{ proposal.expert.name }}</h4>
                    <div class="flex items-center gap-1 mt-0.5">
                      <Star class="w-4 h-4 text-yellow-400 fill-current" />
                      <span class="text-sm text-gray-600">4.8 (24 avis)</span>
                    </div>
                  </div>
                </div>
                <div class="text-right">
                  <div class="font-medium text-gray-900">{{ formatPrice(proposal.price) }}</div>
                  <div class="text-sm text-gray-500">Prix proposé</div>
                </div>
              </div>
              
              <!-- Message de l'expert -->
              <div class="mt-3 p-3 bg-gray-50 rounded-lg text-gray-700 text-sm">
                {{ proposal.message }}
              </div>
              
              <!-- Actions -->
              <div class="mt-4 flex justify-between items-center">
                <button 
                  class="text-primary-600 hover:text-primary-700 text-sm font-medium flex items-center gap-1"
                  @click="viewExpertProfile(proposal.expert.id)"
                >
                  <User class="w-4 h-4" />
                  <span>Voir le profil</span>
                </button>
                
                <div class="flex gap-2">
                  <button 
                    class="px-3 py-1.5 border border-gray-200 rounded-lg text-gray-700 hover:bg-gray-50 text-sm font-medium"
                    @click="contactExpert(proposal.expert.id)"
                  >
                    <span>Contacter</span>
                  </button>
                  <button 
                    class="px-3 py-1.5 bg-primary-600 text-white rounded-lg hover:bg-primary-700 text-sm font-medium"
                    @click="acceptProposal(proposal.id)"
                  >
                    <span>Accepter</span>
                  </button>
                </div>
              </div>
            </div>
          </div>
          
          <!-- État vide pour les propositions -->
          <div v-else class="text-center py-6">
            <div class="w-16 h-16 mx-auto rounded-full bg-gray-100 flex items-center justify-center">
              <Users class="w-8 h-8 text-gray-400" />
            </div>
            <p class="mt-4 text-gray-600">Aucune proposition pour le moment</p>
            <p class="mt-2 text-sm text-gray-500">Les experts intéressés vous enverront leurs propositions ici</p>
          </div>
        </div>
      </div>
    </div>
    
    <!-- État vide -->
    <div v-else class="bg-white rounded-2xl shadow-sm border border-gray-200 p-12 text-center">
      <div class="w-20 h-20 mx-auto rounded-full bg-gray-100 flex items-center justify-center">
        <ClipboardList class="w-10 h-10 text-gray-400" />
      </div>
      <h3 class="mt-6 text-lg font-medium text-gray-900">Aucune demande trouvée</h3>
      <p class="mt-2 text-gray-600">
        Vous n'avez pas encore publié de demande de service
      </p>
      <div class="mt-6">
        <NuxtLink 
          to="/requests/new"
          class="inline-flex items-center justify-center gap-2 px-4 py-2.5 bg-primary-600 text-white rounded-xl hover:bg-primary-700 transition-colors"
        >
          <Plus class="w-4 h-4" />
          <span class="text-sm font-medium">Publier une demande</span>
        </NuxtLink>
      </div>
    </div>
    
    <!-- Modal de confirmation de suppression -->
    <Dialog :open="showDeleteModal" @close="showDeleteModal = false" class="relative z-50">
      <div class="fixed inset-0 bg-black/30" aria-hidden="true" />
      
      <div class="fixed inset-0 flex items-center justify-center p-4">
        <DialogPanel class="w-full max-w-md bg-white rounded-2xl p-6">
          <DialogTitle class="text-xl font-bold text-gray-900">
            Supprimer cette demande ?
          </DialogTitle>
          
          <p class="mt-4 text-gray-600">
            Êtes-vous sûr de vouloir supprimer cette demande ? Cette action est irréversible.
          </p>
          
          <div class="mt-6 flex gap-3">
            <button
              @click="showDeleteModal = false"
              class="flex-1 px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50"
            >
              Annuler
            </button>
            <button
              @click="deleteDemand"
              class="flex-1 px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700"
            >
              Supprimer
            </button>
          </div>
        </DialogPanel>
      </div>
    </Dialog>
    
    <!-- Modal de confirmation d'acceptation -->
    <Dialog :open="showAcceptModal" @close="showAcceptModal = false" class="relative z-50">
      <div class="fixed inset-0 bg-black/30" aria-hidden="true" />
      
      <div class="fixed inset-0 flex items-center justify-center p-4">
        <DialogPanel class="w-full max-w-md bg-white rounded-2xl p-6">
          <DialogTitle class="text-xl font-bold text-gray-900">
            Accepter cette proposition
          </DialogTitle>
          
          <p class="mt-4 text-gray-600">
            En acceptant cette proposition, vous allez créer un contrat avec cet expert. Les autres propositions seront automatiquement refusées.
          </p>
          
          <div class="mt-6 flex gap-3">
            <button
              @click="showAcceptModal = false"
              class="flex-1 px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50"
            >
              Annuler
            </button>
            <button
              @click="confirmAcceptProposal"
              class="flex-1 px-4 py-2 bg-primary-600 text-white rounded-lg hover:bg-primary-700"
            >
              Confirmer
            </button>
          </div>
        </DialogPanel>
      </div>
    </Dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { Dialog, DialogPanel, DialogTitle } from '@headlessui/vue'
import { 
  ArrowLeft, Calendar, MapPin, Eye, MessageSquare, 
  Trash2, Plus, ClipboardList, ChevronDown, ChevronUp,
  User, Users, Star
} from 'lucide-vue-next'

// État des filtres
const activeFilter = ref('all') // 'all', 'active', 'completed'

// État d'expansion des demandes
const expandedDemand = ref<number | null>(null)

// État des modals
const showDeleteModal = ref(false)
const showAcceptModal = ref(false)
const demandToDelete = ref<number | null>(null)
const proposalToAccept = ref<number | null>(null)

// Données simulées (à remplacer par une API)
const demands = ref([
  {
    id: 1,
    title: 'Ménage hebdomadaire',
    service: 'menage',
    description: 'Recherche personne pour ménage hebdomadaire dans un appartement de 3 pièces.',
    date: '2024-02-20',
    location: 'Cotonou, Bénin',
    status: 'active',
    proposals: [
      {
        id: 1,
        expert: {
          id: 1,
          name: 'Aminata Diallo',
          avatar: 'https://randomuser.me/api/portraits/women/65.jpg'
        },
        price: 15000,
        message: 'Je suis disponible pour ce service. J\'ai 3 ans d\'expérience dans le ménage professionnel et je peux commencer dès la semaine prochaine.'
      },
      {
        id: 2,
        expert: {
          id: 2,
          name: 'Kofi Mensah',
          avatar: 'https://randomuser.me/api/portraits/men/42.jpg'
        },
        price: 18000,
        message: 'J\'ai 5 ans d\'expérience dans le ménage professionnel. Je propose un service complet incluant le nettoyage des vitres et le repassage.'
      }
    ]
  },
  {
    id: 2,
    title: 'Réparation plomberie',
    service: 'bricolage',
    description: 'Besoin d\'un plombier pour réparer un robinet qui fuit dans la salle de bain.',
    date: '2024-02-15',
    location: 'Cotonou, Bénin',
    status: 'completed',
    proposals: [
      {
        id: 3,
        expert: {
          id: 3,
          name: 'Ibrahim Touré',
          avatar: 'https://randomuser.me/api/portraits/men/32.jpg'
        },
        price: 8500,
        message: 'Je peux intervenir rapidement. J\'ai tous les outils nécessaires pour ce type de réparation.'
      }
    ]
  },
  {
    id: 3,
    title: 'Tonte de pelouse',
    service: 'jardinage',
    description: 'Recherche jardinier pour tondre une pelouse de 200m².',
    date: '2024-02-25',
    location: 'Cotonou, Bénin',
    status: 'active',
    proposals: []
  }
])

// Computed
const filteredDemands = computed(() => {
  if (activeFilter.value === 'all') return demands.value
  if (activeFilter.value === 'active') return demands.value.filter(d => d.status === 'active')
  if (activeFilter.value === 'completed') return demands.value.filter(d => d.status === 'completed')
  return demands.value
})

const activeDemandsCount = computed(() => 
  demands.value.filter(d => d.status === 'active').length
)

const completedDemandsCount = computed(() => 
  demands.value.filter(d => d.status === 'completed').length
)

// Méthodes
const formatDate = (dateString: string) => {
  const options: Intl.DateTimeFormatOptions = { day: 'numeric', month: 'long', year: 'numeric' }
  return new Date(dateString).toLocaleDateString('fr-FR', options)
}

const formatPrice = (price: number) => {
  return new Intl.NumberFormat('fr-FR', { style: 'currency', currency: 'XOF' }).format(price)
}

const getStatusClass = (status: string) => {
  const classes = {
    'active': 'bg-green-100 text-green-800',
    'pending': 'bg-yellow-100 text-yellow-800',
    'completed': 'bg-gray-100 text-gray-800'
  }
  return classes[status as keyof typeof classes] || ''
}

const getStatusLabel = (status: string) => {
  const labels = {
    'active': 'Active',
    'pending': 'En attente',
    'completed': 'Terminée'
  }
  return labels[status as keyof typeof labels] || status
}

const getServiceIcon = (serviceId: string) => {
  const icons: Record<string, string> = {
    'menage': '🧹',
    'jardinage': '🌱',
    'bricolage': '🔨',
    'garde': '👶'
  }
  return icons[serviceId] || '📋'
}

const toggleProposals = (id: number) => {
  if (expandedDemand.value === id) {
    expandedDemand.value = null
  } else {
    expandedDemand.value = id
  }
}

const showDeleteConfirmation = (id: number) => {
  demandToDelete.value = id
  showDeleteModal.value = true
}

const deleteDemand = () => {
  if (demandToDelete.value) {
    // Supprimer la demande
    demands.value = demands.value.filter(d => d.id !== demandToDelete.value)
    
    // Fermer la modal
    showDeleteModal.value = false
    demandToDelete.value = null
  }
}

const viewExpertProfile = (expertId: number) => {
  // Rediriger vers le profil de l'expert
  navigateTo(`/experts/${expertId}`)
}

const contactExpert = (expertId: number) => {
  // Rediriger vers la messagerie
  navigateTo(`/messages?expert=${expertId}`)
}

const acceptProposal = (proposalId: number) => {
  proposalToAccept.value = proposalId
  showAcceptModal.value = true
}

const confirmAcceptProposal = () => {
  if (proposalToAccept.value) {
    // Trouver la demande correspondante
    const demand = demands.value.find(d => 
      d.proposals.some(p => p.id === proposalToAccept.value)
    )
    
    if (demand) {
      // Mettre à jour le statut de la demande
      demand.status = 'completed'
      
      // Simuler la création d'un contrat
      console.log(`Contrat créé pour la proposition ${proposalToAccept.value}`)
      
      // Fermer la modal
      showAcceptModal.value = false
      proposalToAccept.value = null
      
      // Fermer l'expansion
      expandedDemand.value = null
    }
  }
}
</script> 