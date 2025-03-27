<template>
  <div class="space-y-6 max-w-7xl mx-auto">
    <!-- En-tête avec style Twitter -->
    <div class="px-4 py-6">
      <h1 class="text-2xl font-bold text-gray-900 dark:text-white">Demandes de service</h1>
      <p class="text-gray-600 dark:text-gray-400 mt-1">Gérez les demandes de service et assignez des experts</p>
    </div>
    
    <!-- Notifications -->
    <div 
      v-if="notification.show" 
      class="mx-4 p-4 rounded-xl flex items-start gap-3"
      :class="[
        notification.type === 'success' ? 'bg-green-50 text-green-800 dark:bg-green-900/20 dark:text-green-400' : 
        notification.type === 'error' ? 'bg-red-50 text-red-800 dark:bg-red-900/20 dark:text-red-400' : 
        'bg-blue-50 text-blue-800 dark:bg-blue-900/20 dark:text-blue-400'
      ]"
    >
      <component 
        :is="notification.type === 'success' ? 'CheckCircle' : notification.type === 'error' ? 'AlertTriangle' : 'Info'" 
        class="h-5 w-5 mt-0.5 flex-shrink-0" 
      />
      <div>
        <h3 class="font-medium">{{ notification.title }}</h3>
        <p class="text-sm opacity-80 mt-0.5">{{ notification.message }}</p>
      </div>
      <button 
        @click="notification.show = false" 
        class="ml-auto p-1.5 rounded-full hover:bg-black/5 dark:hover:bg-white/5"
      >
        <X class="h-4 w-4" />
      </button>
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
          <div 
            class="h-12 w-12 rounded-full flex items-center justify-center"
            :class="stat.colorClass"
          >
            <component :is="stat.icon" class="h-6 w-6 text-white" />
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
              placeholder="Rechercher une demande..."
              class="pl-10 pr-4 py-2 border border-gray-200 dark:border-gray-600 rounded-full focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white w-60"
            />
          </div>
          
          <!-- Filtre de statut -->
          <select 
            v-model="statusFilter"
            class="px-4 py-2 border border-gray-200 dark:border-gray-600 rounded-full focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white appearance-none"
          >
            <option value="all">Tous les statuts</option>
            <option value="open">Nouvelles</option>
            <option value="assigned">Assignées</option>
            <option value="in_progress">En cours</option>
            <option value="completed">Terminées</option>
            <option value="cancelled">Annulées</option>
          </select>
          
          <!-- Filtre de catégorie -->
          <select 
            v-model="categoryFilter"
            class="px-4 py-2 border border-gray-200 dark:border-gray-600 rounded-full focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white appearance-none"
          >
            <option value="all">Toutes les catégories</option>
            <option v-for="category in professions" :key="category.id" :value="category.id">
              {{ category.name }}
            </option>
          </select>
        </div>
        
        <!-- Actions -->
        <div class="flex items-center gap-2">
          <button 
            @click="resetFilters"
            class="flex items-center p-2.5 text-gray-700 dark:text-gray-300 bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-600 rounded-full hover:bg-gray-50 dark:hover:bg-gray-700"
            title="Réinitialiser les filtres"
          >
            <RefreshCw class="h-5 w-5" />
          </button>
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
    
    <!-- Liste des demandes -->
    <div v-if="isLoading" class="flex justify-center p-12">
      <div class="inline-block h-8 w-8 animate-spin rounded-full border-4 border-solid border-primary-500 border-r-transparent"></div>
    </div>
    
    <div v-else-if="filteredRequests.length === 0" class="bg-white dark:bg-gray-800 rounded-xl p-8 text-center border border-gray-100 dark:border-gray-700">
      <div class="inline-flex items-center justify-center h-16 w-16 rounded-full bg-gray-100 dark:bg-gray-700 mb-4">
        <FileText class="h-8 w-8 text-gray-500 dark:text-gray-400" />
      </div>
      <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-2">Aucune demande trouvée</h3>
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
      <!-- En-tête du tableau -->
      <div class="grid grid-cols-6 gap-4 px-6 py-3 bg-gray-50 dark:bg-gray-800/80 border-b border-gray-100 dark:border-gray-700 text-sm font-medium text-gray-500 dark:text-gray-400">
        <div>Service</div>
        <div>Client</div>
        <div>Budget</div>
        <div>Date limite</div>
        <div>Statut</div>
        <div class="text-right">Actions</div>
      </div>
      
      <!-- Lignes du tableau -->
      <div class="divide-y divide-gray-100 dark:divide-gray-700">
        <div 
          v-for="mission in paginatedRequests" 
          :key="mission.id"
          class="grid grid-cols-6 gap-4 px-6 py-4 items-center hover:bg-gray-50 dark:hover:bg-gray-800/50 transition-colors"
        >
          <!-- Service -->
          <div class="flex items-center gap-3">
            <div 
              class="h-10 w-10 rounded-full flex items-center justify-center"
              :class="getCategoryColorClass(mission.profession_id)"
            >
              <component :is="getCategoryIcon(mission.profession_id)" class="h-5 w-5 text-white" />
            </div>
            <div>
              <p class="text-sm font-medium text-gray-900 dark:text-white line-clamp-1">{{ mission.title }}</p>
              <p class="text-xs text-gray-500 dark:text-gray-400">{{ getCategoryName(mission.profession_id) }}</p>
            </div>
          </div>
          
          <!-- Client -->
          <div>
            <p class="text-sm font-medium text-gray-900 dark:text-white">{{ mission.client_name }}</p>
            <div class="flex items-center text-xs text-gray-500 dark:text-gray-400">
              <MapPin class="h-3 w-3 mr-1" /> 
              {{ mission.location || 'Non spécifié' }}
            </div>
          </div>
          
          <!-- Budget -->
          <div>
            <span class="inline-flex items-center px-2.5 py-1 bg-primary-50 dark:bg-primary-900/20 text-primary-700 dark:text-primary-400 rounded-full text-xs font-bold">
              {{ mission.budget ? `${mission.budget}FCFA` : 'Non défini' }}
            </span>
          </div>
          
          <!-- Date limite -->
          <div class="text-sm text-gray-600 dark:text-gray-400">
            {{ formatDate(mission.deadline) }}
          </div>
          
          <!-- Statut -->
          <div>
            <span 
              class="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-medium"
              :class="getStatusClass(mission.status)"
            >
              <span class="w-1.5 h-1.5 rounded-full mr-1.5" :class="getStatusDotClass(mission.status)"></span>
              {{ formatStatus(mission.status) }}
            </span>
          </div>
          
          <!-- Actions -->
          <div class="flex justify-end gap-2">
            <button 
              @click="viewRequestDetails(mission)"
              class="p-1.5 text-gray-500 dark:text-gray-400 hover:text-gray-700 dark:hover:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700 rounded-full"
              title="Voir les détails"
            >
              <Eye class="h-5 w-5" />
            </button>
            <button 
              v-if="mission.status === 'open'"
              @click="openAssignModal(mission)"
              class="p-1.5 text-primary-600 dark:text-primary-400 hover:text-primary-700 dark:hover:text-primary-300 hover:bg-primary-50 dark:hover:bg-primary-900/20 rounded-full"
              title="Assigner un expert"
            >
              <UserPlus class="h-5 w-5" />
            </button>
            <button 
              v-if="['open', 'assigned'].includes(mission.status)"
              @click="cancelRequest(mission)"
              class="p-1.5 text-red-500 dark:text-red-400 hover:text-red-700 dark:hover:text-red-300 hover:bg-red-50 dark:hover:bg-red-900/20 rounded-full"
              title="Annuler"
            >
              <X class="h-5 w-5" />
            </button>
          </div>
        </div>
      </div>
      
      <!-- Pagination -->
      <div class="p-4 border-t border-gray-100 dark:border-gray-700 flex justify-between items-center">
        <p class="text-sm text-gray-500 dark:text-gray-400">
          Affichage de {{ (currentPage - 1) * itemsPerPage + 1 }} à {{ Math.min(currentPage * itemsPerPage, filteredRequests.length) }} sur {{ filteredRequests.length }} demandes
        </p>
        
        <div class="flex gap-1">
          <button 
            @click="currentPage = Math.max(1, currentPage - 1)"
            :disabled="currentPage === 1"
            class="p-2 rounded-full hover:bg-gray-100 dark:hover:bg-gray-700 text-gray-500 dark:text-gray-400 disabled:opacity-50"
          >
            <ChevronLeft class="h-5 w-5" />
          </button>
          
          <button 
            v-for="page in visiblePages" 
            :key="page"
            @click="typeof page === 'number' ? currentPage = page : null"
            :disabled="page === '...'"
            class="min-w-[40px] h-10 rounded-full flex items-center justify-center text-sm font-medium"
            :class="[
              page === '...' ? 'text-gray-400 cursor-default' : '',
              page === currentPage 
                ? 'bg-primary-50 text-primary-700 dark:bg-primary-900/20 dark:text-primary-400' 
                : 'text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700'
            ]"
          >
            {{ page }}
          </button>
          
          <button 
            @click="currentPage = Math.min(totalPages, currentPage + 1)"
            :disabled="currentPage === totalPages || totalPages === 0"
            class="p-2 rounded-full hover:bg-gray-100 dark:hover:bg-gray-700 text-gray-500 dark:text-gray-400 disabled:opacity-50"
          >
            <ChevronRight class="h-5 w-5" />
          </button>
        </div>
      </div>
    </div>
    
    <!-- Modal d'assignation d'expert -->
    <AdminModal
      :show="showAssignModal"
      title="Assigner un expert"
      @close="showAssignModal = false"
    >
      <template #icon>
        <UserCheck class="h-5 w-5 text-primary-600 mr-2" />
      </template>
      
      <div class="p-6">
        <div v-if="selectedRequest" class="mb-6">
          <h3 class="text-lg font-bold text-gray-900 dark:text-white mb-2">
            {{ selectedRequest.title }}
          </h3>
          <div class="flex items-center gap-2 text-sm text-gray-600 dark:text-gray-400 mb-4">
            <Tag class="h-4 w-4" />
            <span>{{ getCategoryName(selectedRequest.profession_id) }}</span>
            <span class="mx-2">•</span>
            <MapPin class="h-4 w-4" /> 
            <span>{{ selectedRequest.location || 'Non spécifié' }}</span>
            <span class="mx-2">•</span>
            <DollarSign class="h-4 w-4" />
            <span>{{ selectedRequest.budget ? `${selectedRequest.budget}FCFA` : 'Non défini' }}</span>
          </div>
          
          <div class="bg-gray-50 dark:bg-gray-800/50 rounded-lg p-4 text-sm text-gray-600 dark:text-gray-400 mb-6">
            <p>{{ selectedRequest.description }}</p>
          </div>
          
          <div class="space-y-4">
            <div>
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                Sélectionner un expert
              </label>
              <select 
                v-model="selectedExpertId"
                class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
              >
                <option value="">Choisir un expert</option>
                <option v-for="expert in availableExperts" :key="expert.id" :value="expert.id">
                  {{ expert.first_name }} {{ expert.last_name }} - {{ expert.skills.join(', ') }}
                </option>
              </select>
            </div>
            
            <div>
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                Notes pour l'expert (optionnel)
              </label>
              <textarea 
                v-model="assignmentNotes"
                rows="3"
                class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
                placeholder="Instructions spécifiques pour l'expert..."
              ></textarea>
            </div>
          </div>
        </div>
        
        <div class="flex justify-end gap-3 mt-6">
          <button 
            @click="showAssignModal = false"
            class="px-4 py-2 border border-gray-300 dark:border-gray-600 text-gray-700 dark:text-gray-300 rounded-lg hover:bg-gray-50 dark:hover:bg-gray-700"
          >
            Annuler
          </button>
          <button 
            @click="assignExpert"
            :disabled="!selectedExpertId || isAssigning"
            class="px-4 py-2 bg-primary-600 hover:bg-primary-700 text-white rounded-lg shadow-sm disabled:opacity-50 disabled:pointer-events-none"
          >
            <span v-if="isAssigning" class="flex items-center">
              <div class="h-4 w-4 border-2 border-white/60 border-t-white rounded-full animate-spin mr-2"></div>
              Assignation...
            </span>
            <span v-else>Assigner l'expert</span>
          </button>
        </div>
      </div>
    </AdminModal>
    
    <!-- Modal de détails de la demande -->
    <AdminModal
      :show="showDetailsModal"
      title="Détails de la demande"
      @close="showDetailsModal = false"
      size="lg"
    >
      <template #icon>
        <FileText class="h-5 w-5 text-primary-600 mr-2" />
      </template>
      
      <div class="p-6">
        <!-- Contenu du modal de détails -->
      </div>
    </AdminModal>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { useSupabaseClient } from '#imports'
import { 
  Search, FileText, Users as UsersIcon, Clock, Calendar, 
  DollarSign, Tag, MapPin, CheckCircle, X, 
  ChevronLeft, ChevronRight, Eye, UserPlus, UserCheck,
  AlertTriangle, Download, RefreshCw, LayoutGrid, Home,
  Paintbrush, Wrench, Briefcase, Scissors, Info
} from 'lucide-vue-next'

const supabase = useSupabaseClient()

// États
const missions = ref([])
const professions = ref([])
const experts = ref([])
const search = ref('')
const statusFilter = ref('all')
const categoryFilter = ref('all')
const currentPage = ref(1)
const itemsPerPage = ref(10)
const isLoading = ref(true)
const error = ref(null)

// Modals
const showAssignModal = ref(false)
const showDetailsModal = ref(false)
const selectedRequest = ref(null)
const selectedExpertId = ref('')
const assignmentNotes = ref('')
const isAssigning = ref(false)

// Notification
const notification = ref({
  show: false,
  type: '',
  title: '',
  message: ''
})

// Statistiques
const stats = ref([
  { 
    label: 'Total demandes', 
    value: '0', 
    icon: FileText, 
    colorClass: 'bg-blue-500 dark:bg-blue-600' 
  },
  { 
    label: 'Nouvelles', 
    value: '0', 
    icon: AlertTriangle, 
    colorClass: 'bg-amber-500 dark:bg-amber-600' 
  },
  { 
    label: 'En cours', 
    value: '0', 
    icon: Clock, 
    colorClass: 'bg-indigo-500 dark:bg-indigo-600' 
  },
  { 
    label: 'Terminées', 
    value: '0', 
    icon: CheckCircle, 
    colorClass: 'bg-green-500 dark:bg-green-600' 
  }
])

// Filtrer les demandes
const filteredRequests = computed(() => {
  let filtered = [...missions.value]
  
  // Filtre de recherche
  if (search.value) {
    const searchLower = search.value.toLowerCase()
    filtered = filtered.filter(mission => 
      mission.title?.toLowerCase().includes(searchLower) ||
      mission.description?.toLowerCase().includes(searchLower) ||
      mission.client_name?.toLowerCase().includes(searchLower)
    )
  }
  
  // Filtre de statut
  if (statusFilter.value !== 'all') {
    filtered = filtered.filter(mission => mission.status === statusFilter.value)
  }
  
  // Filtre de catégorie
  if (categoryFilter.value !== 'all') {
    filtered = filtered.filter(mission => 
      mission.profession_id === parseInt(categoryFilter.value)
    )
  }
  
  return filtered
})

// Pagination
const totalPages = computed(() => Math.ceil(filteredRequests.value.length / itemsPerPage.value))

const paginatedRequests = computed(() => {
  const start = (currentPage.value - 1) * itemsPerPage.value
  const end = start + itemsPerPage.value
  return filteredRequests.value.slice(start, end)
})

// Pages visibles pour la pagination
const visiblePages = computed(() => {
  const totalPageCount = totalPages.value
  if (totalPageCount <= 7) {
    return Array.from({ length: totalPageCount }, (_, i) => i + 1)
  }
  
  // Logique pour afficher un nombre limité de pages avec des ellipses
  if (currentPage.value <= 3) {
    return [1, 2, 3, 4, 5, '...', totalPageCount]
  } else if (currentPage.value >= totalPageCount - 2) {
    return [1, '...', totalPageCount - 4, totalPageCount - 3, totalPageCount - 2, totalPageCount - 1, totalPageCount]
  } else {
    return [1, '...', currentPage.value - 1, currentPage.value, currentPage.value + 1, '...', totalPageCount]
  }
})

// Experts disponibles pour l'assignation
const availableExperts = computed(() => {
  return experts.value.filter(expert => 
    expert.is_expert && expert.verification_status === 'approved'
  )
})

// Méthodes
const showNotification = (type, title, message = '') => {
  notification.value = {
    show: true,
    type,
    title,
    message
  }
  
  // Masquer la notification après 5 secondes
  setTimeout(() => {
    notification.value.show = false
  }, 5000)
}

// Mettre à jour les statistiques
const updateStats = () => {
  if (!missions.value.length) return
  
  // Total des demandes
  stats.value[0].value = missions.value.length.toString()
  
  // Nouvelles demandes
  stats.value[1].value = missions.value.filter(
    r => r.status === 'open'
  ).length.toString()
  
  // Demandes en cours
  stats.value[2].value = missions.value.filter(
    r => r.status === 'in_progress' || r.status === 'assigned'
  ).length.toString()
  
  // Demandes terminées
  stats.value[3].value = missions.value.filter(
    r => r.status === 'completed'
  ).length.toString()
}

// Charger les données
const fetchRequests = async () => {
  isLoading.value = true
  
  try {
    // Récupérer les catégories
    const { data: professionsData, error: professionsError } = await supabase
      .from('services_professions')
      .select('*')
    
    if (professionsError) throw professionsError
    professions.value = professionsData
    
    // Récupérer les demandes
    const { data: missionsData, error: missionsError } = await supabase
      .from('missions')
      .select('*')
      .order('created_at', { ascending: false })
    
    if (missionsError) throw missionsError
    missions.value = missionsData
    
    // Récupérer les experts
    const { data: expertsData, error: expertsError } = await supabase
      .from('profiles')
      .select('*')
      .eq('is_expert', true)
    
    if (expertsError) throw expertsError
    experts.value = expertsData
    
    // Mettre à jour les statistiques
    updateStats()
  } catch (err) {
    console.error('Erreur lors du chargement des données:', err)
    error.value = err.message
    showNotification('error', 'Erreur', 'Impossible de charger les données')
  } finally {
    isLoading.value = false
  }
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

// Formater le statut
const formatStatus = (status) => {
  switch (status) {
    case 'open': return 'Nouvelle'
    case 'assigned': return 'Assignée'
    case 'in_progress': return 'En cours'
    case 'completed': return 'Terminée'
    case 'cancelled': return 'Annulée'
    default: return status
  }
}

// Obtenir la classe CSS pour le statut
const getStatusClass = (status) => {
  switch (status) {
    case 'open':
      return 'bg-amber-100 text-amber-800 dark:bg-amber-900/30 dark:text-amber-400'
    case 'assigned':
      return 'bg-blue-100 text-blue-800 dark:bg-blue-900/30 dark:text-blue-400'
    case 'in_progress':
      return 'bg-indigo-100 text-indigo-800 dark:bg-indigo-900/30 dark:text-indigo-400'
    case 'completed':
      return 'bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-400'
    case 'cancelled':
      return 'bg-red-100 text-red-800 dark:bg-red-900/30 dark:text-red-400'
    default:
      return 'bg-gray-100 text-gray-800 dark:bg-gray-700 dark:text-gray-400'
  }
}

// Obtenir la classe pour le point de statut
const getStatusDotClass = (status) => {
  switch (status) {
    case 'open': return 'bg-amber-500'
    case 'assigned': return 'bg-blue-500'
    case 'in_progress': return 'bg-indigo-500'
    case 'completed': return 'bg-green-500'
    case 'cancelled': return 'bg-red-500'
    default: return 'bg-gray-500'
  }
}

// Obtenir le nom de la catégorie
const getCategoryName = (categoryId) => {
  const category = professions.value.find(c => c.id === categoryId)
  return category ? category.name : 'Service général'
}

// Obtenir l'icône de la catégorie
const getCategoryIcon = (categoryId) => {
  switch (categoryId) {
    case 1: return Home // Ménage
    case 2: return Paintbrush // Peinture
    case 3: return Wrench // Plomberie
    case 4: return Briefcase // Montage de meubles
    case 5: return Scissors // Jardinage
    default: return LayoutGrid
  }
}

// Obtenir la classe de couleur pour la catégorie
const getCategoryColorClass = (categoryId) => {
  switch (categoryId) {
    case 1: return 'bg-teal-500'
    case 2: return 'bg-purple-500'
    case 3: return 'bg-blue-500'
    case 4: return 'bg-amber-500'
    case 5: return 'bg-green-500'
    default: return 'bg-gray-500'
  }
}

// Voir les détails d'une demande
const viewRequestDetails = (mission) => {
  selectedRequest.value = mission
  showDetailsModal.value = true
}

// Ouvrir le modal d'assignation
const openAssignModal = (mission) => {
  selectedRequest.value = mission
  selectedExpertId.value = ''
  assignmentNotes.value = ''
  showAssignModal.value = true
}

// Assigner un expert
const assignExpert = async () => {
  if (!selectedExpertId.value || !selectedRequest.value) return
  
  isAssigning.value = true
  
  try {
    // Mettre à jour la demande avec l'expert assigné
    const { error: missionError } = await supabase
      .from('missions')
      .update({ 
        expert_id: selectedExpertId.value,
        admin_notes: assignmentNotes.value,
        status: 'assigned',
        updated_at: new Date()
      })
      .eq('id', selectedRequest.value.id)
    
    if (missionError) throw missionError
    
    // Rafraîchir les données
    await fetchRequests()
    
    showAssignModal.value = false
    showNotification('success', 'Expert assigné', 'L\'expert a été assigné à la demande avec succès')
  } catch (err) {
    console.error('Erreur lors de l\'assignation:', err)
    showNotification('error', 'Erreur', 'Impossible d\'assigner l\'expert à la demande')
  } finally {
    isAssigning.value = false
  }
}

// Annuler une demande
const cancelRequest = async (mission) => {
  if (!confirm(`Êtes-vous sûr de vouloir annuler la demande "${mission.title}" ?`)) return
  
  try {
    const { error } = await supabase
      .from('missions')
      .update({ 
        status: 'cancelled',
        updated_at: new Date()
      })
      .eq('id', mission.id)
    
    if (error) throw error
    
    // Rafraîchir les données
    await fetchRequests()
    showNotification('success', 'Demande annulée', 'La demande a été annulée avec succès')
  } catch (err) {
    console.error('Erreur lors de l\'annulation:', err)
    showNotification('error', 'Erreur', 'Impossible d\'annuler la demande')
  }
}

// Réinitialiser les filtres
const resetFilters = () => {
  search.value = ''
  statusFilter.value = 'all'
  categoryFilter.value = 'all'
  currentPage.value = 1
}

// Exporter les données
const exportData = () => {
  // Implémenter l'export CSV/Excel ici
  alert('La fonctionnalité d\'export sera bientôt disponible')
}

// Rafraîchir les données
const refreshData = async () => {
  await fetchRequests()
  showNotification('success', 'Données actualisées', 'La liste des demandes a été mise à jour')
}

// Réinitialiser la pagination quand les filtres changent
watch([search, statusFilter, categoryFilter], () => {
  currentPage.value = 1
})

// Initialisation
onMounted(() => {
  fetchRequests()
})

definePageMeta({
  layout: 'admin'
})
</script>
