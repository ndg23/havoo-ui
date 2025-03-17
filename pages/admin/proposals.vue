<template>
  <div class="space-y-6 max-w-7xl mx-auto">
    <!-- En-tête avec style Twitter -->
    <div class="px-4 py-6">
      <h1 class="text-2xl font-bold text-gray-900 dark:text-white">Propositions</h1>
      <p class="text-gray-600 dark:text-gray-400 mt-1">Gérez et suivez les propositions des experts aux clients</p>
    </div>
    
    <!-- Statistiques rapides -->
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
      <div 
        v-for="stat in stats" 
        :key="stat.label"
        class="bg-white dark:bg-gray-800 p-6 rounded-xl border border-gray-100 dark:border-gray-700"
      >
        <div class="flex items-center justify-between">
          <div>
            <p class="text-sm text-gray-500 dark:text-gray-400">{{ stat.label }}</p>
            <p class="text-2xl font-bold text-gray-900 dark:text-white mt-1">{{ stat.value }}</p>
          </div>
          <div class="h-12 w-12 rounded-full bg-primary-50 dark:bg-primary-900/20 flex items-center justify-center">
            <component :is="stat.icon" class="h-6 w-6 text-primary-600 dark:text-primary-400" />
          </div>
        </div>
      </div>
    </div>
    
    <!-- Filtres et actions -->
    <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-100 dark:border-gray-700 p-5">
      <div class="flex flex-wrap gap-4 items-center justify-between">
        <div class="flex flex-wrap gap-3">
          <!-- Recherche -->
          <div class="relative">
            <Search class="absolute left-3 top-2.5 h-5 w-5 text-gray-400" />
            <input 
              v-model="search"
              type="text"
              placeholder="Rechercher..."
              class="pl-10 pr-4 py-2 border border-gray-200 dark:border-gray-600 rounded-full focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white w-60"
            />
          </div>
          
          <!-- Filtre de statut -->
          <select 
            v-model="statusFilter"
            class="px-4 py-2 border border-gray-200 dark:border-gray-600 rounded-full focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white appearance-none"
          >
            <option value="all">Tous les statuts</option>
            <option value="pending">En attente</option>
            <option value="accepted">Acceptées</option>
            <option value="declined">Refusées</option>
            <option value="completed">Terminées</option>
          </select>
          
          <!-- Filtre de date -->
          <select 
            v-model="dateFilter"
            class="px-4 py-2 border border-gray-200 dark:border-gray-600 rounded-full focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white appearance-none"
          >
            <option value="all">Toutes les dates</option>
            <option value="today">Aujourd'hui</option>
            <option value="week">Cette semaine</option>
            <option value="month">Ce mois</option>
          </select>
        </div>
        
        <!-- Actions -->
        <div class="flex items-center gap-2">
          <button 
            @click="exportData"
            class="flex items-center p-2.5 text-gray-700 dark:text-gray-300 bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-600 rounded-full hover:bg-gray-50 dark:hover:bg-gray-700"
            title="Exporter"
          >
            <Download class="h-5 w-5" />
          </button>
          <button 
            @click="refreshData"
            class="flex items-center p-2.5 text-gray-700 dark:text-gray-300 bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-600 rounded-full hover:bg-gray-50 dark:hover:bg-gray-700"
            title="Rafraîchir"
          >
            <RefreshCw class="h-5 w-5" />
          </button>
        </div>
      </div>
    </div>
    
    <!-- Liste des propositions -->
    <div v-if="isLoading" class="flex justify-center p-12">
      <div class="inline-block h-8 w-8 animate-spin rounded-full border-4 border-solid border-primary-500 border-r-transparent"></div>
    </div>
    
    <div v-else-if="filteredProposals.length === 0" class="bg-white dark:bg-gray-800 rounded-xl p-8 text-center border border-gray-100 dark:border-gray-700">
      <div class="inline-flex items-center justify-center h-16 w-16 rounded-full bg-gray-100 dark:bg-gray-700 mb-4">
        <InboxIcon class="h-8 w-8 text-gray-500 dark:text-gray-400" />
      </div>
      <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-2">Aucune proposition trouvée</h3>
      <p class="text-gray-600 dark:text-gray-400 mb-4">
        Essayez de modifier vos filtres ou d'effectuer une nouvelle recherche.
      </p>
      <button 
        @click="resetFilters"
        class="px-4 py-2 bg-primary-600 hover:bg-primary-700 text-white text-sm font-medium rounded-full shadow-sm"
      >
        Réinitialiser les filtres
      </button>
    </div>
    
    <div v-else class="bg-white dark:bg-gray-800 rounded-xl border border-gray-100 dark:border-gray-700 overflow-hidden">
      <div class="divide-y divide-gray-100 dark:divide-gray-700">
        <div 
          v-for="proposal in filteredProposals" 
          :key="proposal.id"
          class="p-6 hover:bg-gray-50 dark:hover:bg-gray-900/30 transition-colors"
        >
          <div class="flex flex-col lg:flex-row lg:items-center gap-4 relative">
            <!-- Expert info -->
            <div class="flex items-center gap-3 flex-1">
              <div class="h-12 w-12 rounded-full bg-gray-100 dark:bg-gray-700 overflow-hidden">
                <img 
                  v-if="proposal.expert?.avatar" 
                  :src="proposal.expert.avatar" 
                  alt="Expert" 
                  class="h-full w-full object-cover"
                />
                <User v-else class="h-full w-full p-2.5 text-gray-400" />
              </div>
              <div>
                <h3 class="text-base font-bold text-gray-900 dark:text-white">{{ proposal.expert?.name || 'Expert inconnu' }}</h3>
                <p class="text-sm text-gray-600 dark:text-gray-400">{{ proposal.expert?.specialty || 'Spécialité non spécifiée' }}</p>
              </div>
            </div>
            
            <!-- Demande -->
            <div class="flex-1">
              <div class="space-y-1">
                <h4 class="text-sm font-medium text-gray-700 dark:text-gray-300">Demande</h4>
                <p class="text-sm font-medium text-gray-900 dark:text-white">{{ proposal.request?.title || 'Demande non trouvée' }}</p>
              </div>
              <div class="flex items-center gap-4 mt-2 text-sm">
                <div class="flex items-center text-gray-600 dark:text-gray-400">
                  <Calendar class="h-4 w-4 mr-1.5" />
                  {{ formatDate(proposal.created_at) }}
                </div>
                <div class="flex items-center text-gray-600 dark:text-gray-400">
                  <DollarSign class="h-4 w-4 mr-1.5" />
                  {{ proposal.price }}FCFA
                </div>
              </div>
            </div>
            
            <!-- Statut et actions -->
            <div class="flex flex-col items-end gap-3">
              <div 
                class="px-3 py-1 rounded-full text-xs font-medium"
                :class="getStatusClass(proposal.status)"
              >
                {{ getStatusLabel(proposal.status) }}
              </div>
              
              <div class="flex items-center gap-2">
                <button 
                  @click="showProposalDetails(proposal)"
                  class="p-1.5 text-gray-500 hover:text-primary-600 dark:text-gray-400 dark:hover:text-primary-400"
                  title="Voir les détails"
                >
                  <Eye class="h-4 w-4" />
                </button>
                <button 
                  @click="showProposalMessage(proposal)"
                  class="p-1.5 text-gray-500 hover:text-primary-600 dark:text-gray-400 dark:hover:text-primary-400"
                  title="Voir le message"
                >
                  <MessageSquare class="h-4 w-4" />
                </button>
                <button 
                  v-if="proposal.status === 'pending'"
                  @click="manageProposal(proposal, 'approve')"
                  class="p-1.5 text-gray-500 hover:text-green-600 dark:text-gray-400 dark:hover:text-green-400"
                  title="Approuver"
                >
                  <CheckIcon class="h-4 w-4" />
                </button>
                <button 
                  v-if="proposal.status === 'pending'"
                  @click="manageProposal(proposal, 'reject')"
                  class="p-1.5 text-gray-500 hover:text-red-600 dark:text-gray-400 dark:hover:text-red-400"
                  title="Rejeter"
                >
                  <X class="h-4 w-4" />
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    
    <!-- Pagination -->
    <div v-if="proposals.length > 0" class="flex justify-center mt-6">
      <div class="flex items-center space-x-2">
        <button 
          :disabled="currentPage === 1"
          @click="currentPage--"
          class="p-2 rounded-full border border-gray-200 dark:border-gray-600 disabled:opacity-50 disabled:cursor-not-allowed text-gray-500 dark:text-gray-400 hover:bg-gray-50 dark:hover:bg-gray-700"
        >
          <ChevronLeft class="h-5 w-5" />
        </button>
        
        <div class="flex items-center space-x-1">
          <button 
            v-for="page in paginationArray"
            :key="page"
            @click="page !== '...' ? currentPage = page : null"
            :disabled="page === '...'"
            class="flex items-center justify-center h-8 w-8 rounded-full text-sm font-medium"
            :class="currentPage === page 
              ? 'bg-primary-600 text-white' 
              : 'text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700'"
          >
            {{ page }}
          </button>
        </div>
        
        <button 
          :disabled="currentPage === totalPages"
          @click="currentPage++"
          class="p-2 rounded-full border border-gray-200 dark:border-gray-600 disabled:opacity-50 disabled:cursor-not-allowed text-gray-500 dark:text-gray-400 hover:bg-gray-50 dark:hover:bg-gray-700"
        >
          <ChevronRight class="h-5 w-5" />
        </button>
      </div>
    </div>
    
    <!-- Modal de détails -->
    <AdminModal
      v-if="showModal"
      :show="showModal"
      :title="modalTitle"
      @close="showModal = false"
    >
      <template #icon>
        <MessageSquare v-if="modalType === 'message'" class="h-5 w-5 mr-2 text-primary-600 dark:text-primary-400" />
        <InfoIcon v-else class="h-5 w-5 mr-2 text-primary-600 dark:text-primary-400" />
      </template>
      
      <div v-if="modalType === 'details'" class="p-6 space-y-6">
        <!-- Détails de la proposition -->
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <!-- Info expert -->
          <div class="space-y-4">
            <h3 class="text-lg font-medium text-gray-900 dark:text-white">Expert</h3>
            <div class="flex items-center gap-3">
              <div class="h-14 w-14 rounded-full bg-gray-100 dark:bg-gray-700 overflow-hidden">
                <img 
                  v-if="selectedProposal?.expert?.avatar" 
                  :src="selectedProposal.expert.avatar" 
                  alt="Expert" 
                  class="h-full w-full object-cover"
                />
                <User v-else class="h-full w-full p-3 text-gray-400" />
              </div>
              <div>
                <h4 class="text-base font-bold text-gray-900 dark:text-white">{{ selectedProposal?.expert?.name || 'Expert inconnu' }}</h4>
                <p class="text-sm text-gray-600 dark:text-gray-400">{{ selectedProposal?.expert?.specialty || 'Spécialité non spécifiée' }}</p>
              </div>
            </div>
            
            <div class="flex items-center gap-3 mt-2">
              <div class="flex items-center text-gray-600 dark:text-gray-400">
                <Star class="h-4 w-4 mr-1.5 text-yellow-500" />
                {{ selectedProposal?.expert?.rating || '4.8' }} ({{ selectedProposal?.expert?.reviews || '24' }} avis)
              </div>
              <div class="flex items-center text-gray-600 dark:text-gray-400">
                <Briefcase class="h-4 w-4 mr-1.5" />
                {{ selectedProposal?.expert?.experience || '5' }} ans
              </div>
            </div>
          </div>
          
          <!-- Info demande -->
          <div class="space-y-4">
            <h3 class="text-lg font-medium text-gray-900 dark:text-white">Demande</h3>
            <p class="text-base font-medium text-gray-900 dark:text-white">{{ selectedProposal?.request?.title || 'Demande non trouvée' }}</p>
            <div class="flex items-center gap-3">
              <div class="flex items-center text-gray-600 dark:text-gray-400">
                <User class="h-4 w-4 mr-1.5" />
                {{ selectedProposal?.request?.client_name || 'Client inconnu' }}
              </div>
              <div class="flex items-center text-gray-600 dark:text-gray-400">
                <Calendar class="h-4 w-4 mr-1.5" />
                {{ formatDate(selectedProposal?.request?.deadline) || 'Non spécifiée' }}
              </div>
            </div>
          </div>
        </div>
        
        <!-- Prix et statut -->
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6 border-t border-b border-gray-200 dark:border-gray-700 py-6">
          <div>
            <h3 class="text-sm font-medium text-gray-500 dark:text-gray-400 mb-1">Prix proposé</h3>
            <p class="text-2xl font-bold text-gray-900 dark:text-white">{{ selectedProposal?.price || 0 }}FCFA</p>
          </div>
          <div>
            <h3 class="text-sm font-medium text-gray-500 dark:text-gray-400 mb-1">Statut</h3>
            <div class="flex items-center">
              <div 
                class="px-3 py-1 rounded-full text-sm font-medium"
                :class="getStatusClass(selectedProposal?.status)"
              >
                {{ getStatusLabel(selectedProposal?.status) }}
              </div>
            </div>
          </div>
        </div>
        
        <!-- Message de la proposition -->
        <div>
          <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-3">Message</h3>
          <div class="bg-gray-50 dark:bg-gray-800 p-4 rounded-lg">
            <p class="text-gray-700 dark:text-gray-300 whitespace-pre-line">{{ selectedProposal?.message || 'Aucun message disponible' }}</p>
          </div>
        </div>
        
        <!-- Historique -->
        <div v-if="selectedProposal?.history && selectedProposal.history.length > 0">
          <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-3">Historique</h3>
          <ul class="space-y-3">
            <li 
              v-for="(event, index) in selectedProposal.history" 
              :key="index"
              class="flex items-start space-x-3"
            >
              <div class="flex-shrink-0 h-5 w-5 rounded-full bg-primary-100 dark:bg-primary-900/30 flex items-center justify-center">
                <component :is="getEventIcon(event.type)" class="h-3 w-3 text-primary-600 dark:text-primary-400" />
              </div>
              <div>
                <p class="text-sm text-gray-700 dark:text-gray-300">{{ event.description }}</p>
                <p class="text-xs text-gray-500 dark:text-gray-400">{{ formatDate(event.date) }}</p>
              </div>
            </li>
          </ul>
        </div>
      </div>
      
      <div v-if="modalType === 'message'" class="p-6">
        <div class="bg-gray-50 dark:bg-gray-800 p-6 rounded-lg">
          <p class="text-gray-700 dark:text-gray-300 whitespace-pre-line">{{ selectedProposal?.message || 'Aucun message disponible' }}</p>
        </div>
      </div>
      
      <!-- Footer avec actions -->
      <template #footer>
        <div class="flex justify-end space-x-3">
          <button 
            @click="showModal = false"
            class="px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-md text-gray-700 dark:text-gray-300 bg-white dark:bg-gray-800 hover:bg-gray-50 dark:hover:bg-gray-700"
          >
            Fermer
          </button>
          
          <div v-if="selectedProposal?.status === 'pending' && modalType === 'details'">
            <button 
              @click="manageProposal(selectedProposal, 'approve')"
              class="px-4 py-2 bg-green-600 hover:bg-green-700 text-white rounded-md mr-2"
            >
              Approuver
            </button>
            <button 
              @click="manageProposal(selectedProposal, 'reject')"
              class="px-4 py-2 bg-red-600 hover:bg-red-700 text-white rounded-md"
            >
              Rejeter
            </button>
          </div>
        </div>
      </template>
    </AdminModal>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { 
  Search, 
  Filter, 
  Calendar, 
  DollarSign, 
  MessageSquare, 
  User, 
  Eye, 
  X, 
  Check as CheckIcon, 
  Inbox as InboxIcon,
  ChevronLeft,
  ChevronRight,
  RefreshCw,
  Download,
  Info as InfoIcon,
  Star,
  Briefcase,
  Clock, 
  CheckCircle,
  AlertTriangle,
  PenTool
} from 'lucide-vue-next'
import AdminModal from '~/components/admin/AdminModal.vue'

const supabase = useSupabaseClient()

// État
const proposals = ref([])
const isLoading = ref(true)
const search = ref('')
const statusFilter = ref('all')
const dateFilter = ref('all')
const currentPage = ref(1)
const perPage = ref(10)
const showModal = ref(false)
const selectedProposal = ref(null)
const modalType = ref('details') // 'details' ou 'message'
const modalTitle = ref('')

// Pagination
const totalPages = computed(() => Math.ceil(filteredProposals.value.length / perPage.value))

const paginationArray = computed(() => {
  const result = []
  
  if (totalPages.value <= 7) {
    for (let i = 1; i <= totalPages.value; i++) {
      result.push(i)
    }
    return result
  }
  
  // Version avec ellipsis
  if (currentPage.value <= 3) {
    // Début
    for (let i = 1; i <= 5; i++) {
      result.push(i)
    }
    result.push('...')
    result.push(totalPages.value)
  } else if (currentPage.value >= totalPages.value - 2) {
    // Fin
    result.push(1)
    result.push('...')
    for (let i = totalPages.value - 4; i <= totalPages.value; i++) {
      result.push(i)
    }
  } else {
    // Milieu
    result.push(1)
    result.push('...')
    for (let i = currentPage.value - 1; i <= currentPage.value + 1; i++) {
      result.push(i)
    }
    result.push('...')
    result.push(totalPages.value)
  }
  
  return result
})

// Statistiques
const stats = ref([
  { label: 'Total propositions', value: 0, icon: MessageSquare },
  { label: 'En attente', value: 0, icon: Clock },
  { label: 'Acceptées', value: 0, icon: CheckCircle },
  { label: 'Refusées', value: 0, icon: X }
])

// Propositions filtrées
const filteredProposals = computed(() => {
  let filtered = [...proposals.value]
  
  // Recherche
  if (search.value) {
    const searchLower = search.value.toLowerCase()
    filtered = filtered.filter(proposal => 
      proposal.expert?.name?.toLowerCase().includes(searchLower) ||
      proposal.request?.title?.toLowerCase().includes(searchLower) ||
      proposal.message?.toLowerCase().includes(searchLower)
    )
  }
  
  // Filtre par statut
  if (statusFilter.value !== 'all') {
    filtered = filtered.filter(proposal => proposal.status === statusFilter.value)
  }
  
  // Filtre par date
  if (dateFilter.value !== 'all') {
    const now = new Date()
    const today = new Date(now.getFullYear(), now.getMonth(), now.getDate())
    const weekStart = new Date(today)
    weekStart.setDate(today.getDate() - today.getDay())
    const monthStart = new Date(now.getFullYear(), now.getMonth(), 1)
    
    filtered = filtered.filter(proposal => {
      const createdAt = new Date(proposal.created_at)
      
      if (dateFilter.value === 'today') {
        return createdAt >= today
      } else if (dateFilter.value === 'week') {
        return createdAt >= weekStart
      } else if (dateFilter.value === 'month') {
        return createdAt >= monthStart
      }
      
      return true
    })
  }
  
  // Pagination
  const startIndex = (currentPage.value - 1) * perPage.value
  const endIndex = startIndex + perPage.value
  
  return filtered.slice(startIndex, endIndex)
})

// Charger les propositions
const fetchProposals = async () => {
  isLoading.value = true
  
  try {
    // Fetch from Supabase
    const { data, error } = await supabase
      .from('proposals')
      .select(`
        *,
        expert:expert_id (
          id, 
          first_name, 
          last_name, 
          avatar_url, 
          profession,
          average_rating,
          years_experience
        ),
        request:request_id (
          id,
          title,
          client_name,
          deadline
        )
      `)
      .order('created_at', { ascending: false })
    
    if (error) throw error
    
    // Format data
    proposals.value = (data || []).map(item => {
      // Format expert name
      if (item.expert) {
        item.expert.name = `${item.expert.first_name || ''} ${item.expert.last_name || ''}`.trim()
        item.expert.specialty = item.expert.profession
        item.expert.rating = item.expert.average_rating
        item.expert.experience = item.expert.years_experience
      }
      
      return item
    })
    
    // Update stats
    updateStats()
    
  } catch (err) {
    console.error('Erreur lors du chargement des propositions:', err)
  } finally {
    isLoading.value = false
  }
}

// Mettre à jour les statistiques
const updateStats = () => {
  stats.value[0].value = proposals.value.length
  stats.value[1].value = proposals.value.filter(p => p.status === 'pending').length
  stats.value[2].value = proposals.value.filter(p => p.status === 'accepted').length
  stats.value[3].value = proposals.value.filter(p => p.status === 'declined').length
}

// Réinitialiser les filtres
const resetFilters = () => {
  search.value = ''
  statusFilter.value = 'all'
  dateFilter.value = 'all'
  currentPage.value = 1
}

// Rafraîchir les données
const refreshData = () => {
  fetchProposals()
}

// Exporter les données
const exportData = () => {
  // Implémenter l'export CSV/Excel ici
  alert('La fonctionnalité d\'export sera bientôt disponible')
}

// Gérer une proposition (approuver/rejeter)
const manageProposal = async (proposal, action) => {
  try {
    const newStatus = action === 'approve' ? 'accepted' : 'declined'
    
    // Mettre à jour dans Supabase
    const { error } = await supabase
      .from('proposals')
      .update({ 
        status: newStatus,
        updated_at: new Date()
      })
      .eq('id', proposal.id)
    
    if (error) throw error
    
    // Fermer le modal
    showModal.value = false
    
    // Rafraîchir les données
    await fetchProposals()
    
  } catch (err) {
    console.error('Erreur lors de la gestion de la proposition:', err)
    alert('Une erreur est survenue lors de la modification du statut')
  }
}

// Afficher les détails d'une proposition
const showProposalDetails = (proposal) => {
  selectedProposal.value = proposal
  modalType.value = 'details'
  modalTitle.value = 'Détails de la proposition'
  showModal.value = true
}

// Afficher le message d'une proposition
const showProposalMessage = (proposal) => {
  selectedProposal.value = proposal
  modalType.value = 'message'
  modalTitle.value = 'Message de la proposition'
  showModal.value = true
}

// Formater une date
const formatDate = (dateString) => {
  if (!dateString) return 'Non spécifiée'
  
  const date = new Date(dateString)
  return new Intl.DateTimeFormat('fr-FR', {
    day: 'numeric',
    month: 'long',
    year: 'numeric'
  }).format(date)
}

// Obtenir la classe CSS pour le statut
const getStatusClass = (status) => {
  switch (status) {
    case 'pending':
      return 'bg-yellow-100 text-yellow-800 dark:bg-yellow-900/30 dark:text-yellow-400'
    case 'accepted':
      return 'bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-400'
    case 'declined':
      return 'bg-red-100 text-red-800 dark:bg-red-900/30 dark:text-red-400'
    case 'completed':
      return 'bg-blue-100 text-blue-800 dark:bg-blue-900/30 dark:text-blue-400'
    default:
      return 'bg-gray-100 text-gray-800 dark:bg-gray-700 dark:text-gray-400'
  }
}

// Obtenir le libellé du statut
const getStatusLabel = (status) => {
  switch (status) {
    case 'pending':
      return 'En attente'
    case 'accepted':
      return 'Acceptée'
    case 'declined':
      return 'Refusée'
    case 'completed':
      return 'Terminée'
    default:
      return status
  }
}

// Obtenir l'icône pour un événement d'historique
const getEventIcon = (type) => {
  switch (type) {
    case 'created':
      return PenTool
    case 'status_changed':
      return RefreshCw
    case 'accepted':
      return CheckCircle
    case 'declined':
      return X
    case 'completed':
      return CheckIcon
    case 'warning':
      return AlertTriangle
    default:
      return InfoIcon
  }
}

// Initialisation
onMounted(() => {
  fetchProposals()
})

definePageMeta({
  layout: 'admin'
})
</script> 