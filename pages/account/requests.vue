<template>
  <div class="max-w-7xl mx-auto px-4 py-8">
    <!-- En-tête de la page -->
    <div class="mb-8">
      <h1 class="text-2xl font-bold text-gray-900 dark:text-white">Mes demandes</h1>
      <p class="text-gray-600 dark:text-gray-400 mt-1">Gérez vos demandes de services publiées</p>
    </div>
    
    <!-- Alerte de statut -->
    <ErrorAlert 
      v-if="statusMessage.show"
      :type="statusMessage.type"
      :message="statusMessage.message"
      dismissible
      @dismiss="statusMessage.show = false"
      class="mb-6"
    />
    
    <!-- Filtres et recherche -->
    <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 p-6 mb-8 shadow-sm">
      <div class="flex flex-wrap gap-4 items-end">
        <div class="flex-1 min-w-[250px]">
          <label for="search" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">Rechercher</label>
          <div class="relative">
            <input
              v-model="search"
              type="text"
              id="search"
              placeholder="Rechercher dans mes demandes..."
              class="w-full px-4 py-2.5 border border-gray-300 dark:border-gray-600 rounded-full shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white pl-10"
            />
            <Search class="absolute left-3 top-3 h-4 w-4 text-gray-400" />
          </div>
        </div>
        
        <div class="w-44">
          <label for="status" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">Statut</label>
          <select
            v-model="statusFilter"
            id="status"
            class="w-full px-4 py-2.5 border border-gray-300 dark:border-gray-600 rounded-full shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white appearance-none bg-no-repeat"
          >
            <option value="all">Tous les statuts</option>
            <option value="open">Ouverte</option>
            <option value="in_progress">En cours</option>
            <option value="closed">Fermée</option>
          </select>
        </div>
        
        <div class="w-52">
          <label for="sort" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">Trier par</label>
          <select
            v-model="sortOption"
            id="sort"
            class="w-full px-4 py-2.5 border border-gray-300 dark:border-gray-600 rounded-full shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white appearance-none bg-no-repeat"
          >
            <option value="recent">Plus récentes</option>
            <option value="oldest">Plus anciennes</option>
            <option value="budget_high">Budget (élevé à bas)</option>
            <option value="budget_low">Budget (bas à élevé)</option>
            <option value="deadline">Date limite</option>
          </select>
        </div>
        
        <div>
          <NuxtLink 
            to="/requests/create" 
            class="h-full px-6 py-2.5 bg-primary-600 hover:bg-primary-700 text-white text-sm font-medium rounded-full transition-colors shadow-sm flex items-center"
          >
            <Plus class="h-4 w-4 mr-1.5" />
            Nouvelle demande
          </NuxtLink>
        </div>
      </div>
    </div>
    
    <!-- Section de chargement -->
    <div v-if="isLoading" class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 p-16 animate-pulse shadow-sm">
      <div class="flex flex-col items-center justify-center">
        <div class="h-10 w-10 border-4 border-primary-500 border-t-transparent rounded-full animate-spin"></div>
        <p class="mt-4 text-gray-600 dark:text-gray-400 font-medium">Chargement de vos demandes...</p>
      </div>
    </div>
    
    <!-- Message si aucune demande -->
    <div v-else-if="filteredRequests.length === 0" class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 p-16 text-center shadow-sm">
      <div class="flex flex-col items-center justify-center">
        <FileQuestion class="h-16 w-16 text-gray-400 mb-3" />
        <h3 class="text-lg font-medium text-gray-900 dark:text-gray-100 mb-1">Aucune demande trouvée</h3>
        <p class="text-gray-600 dark:text-gray-400 max-w-md mb-6">
          {{ search ? `Aucun résultat pour "${search}"` : 'Vous n\'avez pas encore publié de demande de service.' }}
        </p>
        <NuxtLink 
          to="/requests/create" 
          class="px-6 py-2.5 bg-primary-600 hover:bg-primary-700 text-white text-sm font-medium rounded-full transition-colors shadow-sm flex items-center"
        >
          <Plus class="h-4 w-4 mr-1.5" />
          Publier une demande
        </NuxtLink>
      </div>
    </div>
    
    <!-- Liste des demandes -->
    <div v-else class="space-y-6">
      <div 
        v-for="request in paginatedRequests" 
        :key="request.id" 
        class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 overflow-hidden shadow-sm hover:shadow-md transition-shadow"
      >
        <div class="p-6">
          <div class="flex flex-col md:flex-row gap-6">
            <!-- Icône de catégorie et statut -->
            <div class="md:w-1/6 flex flex-col items-center">
              <div class="w-16 h-16 rounded-full bg-primary-100 dark:bg-primary-900/30 flex items-center justify-center mb-2">
                <component 
                  :is="getCategoryIcon(request.category_id)" 
                  class="h-8 w-8 text-primary-600 dark:text-primary-400" 
                />
              </div>
              <span class="text-sm font-medium text-gray-700 dark:text-gray-300 text-center">
                {{ getCategoryName(request.category_id) }}
              </span>
              
              <div class="mt-3 flex items-center">
                <span 
                  class="px-3 py-1 text-xs font-medium rounded-full"
                  :class="{
                    'bg-green-100 text-green-800 dark:bg-green-900/40 dark:text-green-300': request.status === 'open',
                    'bg-yellow-100 text-yellow-800 dark:bg-yellow-900/40 dark:text-yellow-300': request.status === 'in_progress',
                    'bg-gray-100 text-gray-800 dark:bg-gray-700 dark:text-gray-300': request.status === 'closed'
                  }"
                >
                  {{ formatStatus(request.status) }}
                </span>
              </div>
              
              <span v-if="request.is_urgent" class="mt-2 flex items-center text-xs font-medium text-red-600 dark:text-red-400">
                <Clock class="h-3 w-3 mr-1" />
                Urgent
              </span>
            </div>
            
            <!-- Détails de la demande -->
            <div class="md:w-3/6">
              <NuxtLink :to="`/requests/${request.id}`">
                <h3 class="text-lg font-semibold text-gray-900 dark:text-white hover:text-primary-600 dark:hover:text-primary-400 transition-colors">
                  {{ request.title }}
                </h3>
              </NuxtLink>
              
              <div class="mt-2 text-sm text-gray-600 dark:text-gray-400 line-clamp-2">
                {{ request.description }}
              </div>
              
              <div class="mt-4 space-y-2">
                <!-- Lieu -->
                <div class="flex items-center text-sm text-gray-600 dark:text-gray-400">
                  <MapPin class="h-4 w-4 mr-2 text-gray-500 dark:text-gray-500" />
                  <span>{{ request.location || 'Non spécifié' }}</span>
                </div>
                
                <!-- Date d'échéance -->
                <div class="flex items-center text-sm text-gray-600 dark:text-gray-400">
                  <Calendar class="h-4 w-4 mr-2 text-gray-500 dark:text-gray-500" />
                  <span>Deadline: {{ formatDate(request.deadline) }}</span>
                </div>
                
                <!-- Date de publication -->
                <div class="flex items-center text-sm text-gray-600 dark:text-gray-400">
                  <Clock class="h-4 w-4 mr-2 text-gray-500 dark:text-gray-500" />
                  <span>Publiée le {{ formatDate(request.created_at) }}</span>
                </div>
              </div>
            </div>
            
            <!-- Statistiques et actions -->
            <div class="md:w-2/6 flex flex-col justify-between">
              <div>
                <!-- Budget -->
                <div class="bg-primary-50 dark:bg-primary-900/20 px-4 py-2 rounded-full inline-flex items-center">
                  <DollarSign class="h-4 w-4 text-primary-600 dark:text-primary-400 mr-1" />
                  <span class="text-base font-bold text-primary-700 dark:text-primary-400">
                    {{ request.budget ? `${request.budget}€` : 'Budget non spécifié' }}
                  </span>
                </div>
                
                <!-- Statistiques -->
                <div class="mt-4 grid grid-cols-2 gap-3">
                  <div class="bg-gray-50 dark:bg-gray-700/50 rounded-lg p-3 text-center">
                    <div class="text-xl font-semibold text-gray-900 dark:text-white">{{ request.proposal_count || 0 }}</div>
                    <div class="text-xs text-gray-600 dark:text-gray-400">Propositions</div>
                  </div>
                  
                  <div class="bg-gray-50 dark:bg-gray-700/50 rounded-lg p-3 text-center">
                    <div class="text-xl font-semibold text-gray-900 dark:text-white">{{ request.view_count || 0 }}</div>
                    <div class="text-xs text-gray-600 dark:text-gray-400">Vues</div>
                  </div>
                </div>
              </div>
              
              <!-- Actions -->
              <div class="mt-4 flex flex-wrap gap-2">
                <NuxtLink 
                  :to="`/requests/${request.id}/edit`" 
                  class="px-4 py-2 bg-white dark:bg-gray-700 border border-gray-300 dark:border-gray-600 text-gray-700 dark:text-gray-300 text-sm font-medium rounded-full hover:bg-gray-50 dark:hover:bg-gray-600 transition-colors flex items-center"
                >
                  <Pencil class="h-4 w-4 mr-1.5" />
                  Modifier
                </NuxtLink>
                
                <button 
                  @click="confirmDelete(request)"
                  class="px-4 py-2 bg-white dark:bg-gray-700 border border-gray-300 dark:border-gray-600 text-red-600 dark:text-red-400 text-sm font-medium rounded-full hover:bg-gray-50 dark:hover:bg-gray-600 transition-colors flex items-center"
                >
                  <Trash2 class="h-4 w-4 mr-1.5" />
                  Supprimer
                </button>
                
                <NuxtLink 
                  :to="`/requests/${request.id}/proposals`" 
                  class="px-4 py-2 bg-primary-600 hover:bg-primary-700 text-white text-sm font-medium rounded-full transition-colors flex items-center"
                >
                  <ListChecks class="h-4 w-4 mr-1.5" />
                  Voir les propositions
                </NuxtLink>
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Pagination -->
      <div v-if="totalPages > 1" class="flex justify-center mt-8">
        <div class="flex space-x-1">
          <button 
            @click="currentPage = Math.max(1, currentPage - 1)"
            :disabled="currentPage === 1"
            class="h-10 w-10 rounded-full flex items-center justify-center border border-gray-300 dark:border-gray-600 disabled:opacity-50 disabled:cursor-not-allowed text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700"
          >
            <ChevronLeft class="h-5 w-5" />
          </button>
          
          <button 
            v-for="page in displayedPages" 
            :key="page"
            @click="page !== '...' ? currentPage = page : null"
            :disabled="page === '...'"
            :class="[
              'h-10 w-10 flex items-center justify-center rounded-full text-sm font-medium',
              currentPage === page
                ? 'bg-primary-600 text-white'
                : page === '...'
                  ? 'text-gray-400 cursor-default'
                  : 'border border-gray-300 dark:border-gray-600 text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700'
            ]"
          >
            {{ page }}
          </button>
          
          <button 
            @click="currentPage = Math.min(totalPages, currentPage + 1)"
            :disabled="currentPage === totalPages"
            class="h-10 w-10 rounded-full flex items-center justify-center border border-gray-300 dark:border-gray-600 disabled:opacity-50 disabled:cursor-not-allowed text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700"
          >
            <ChevronRight class="h-5 w-5" />
          </button>
        </div>
      </div>
    </div>
    
    <!-- Modal de confirmation de suppression -->
    <Teleport to="body">
      <div v-if="showDeleteModal" class="fixed inset-0 bg-black/60 backdrop-blur-sm z-50 flex items-center justify-center p-4">
        <div @click.stop class="bg-white dark:bg-gray-800 rounded-2xl w-full max-w-md shadow-xl overflow-hidden">
          <div class="px-6 py-4 border-b border-gray-200 dark:border-gray-700 flex justify-between items-center">
            <h3 class="text-lg font-medium text-gray-900 dark:text-white">Confirmer la suppression</h3>
            <button @click="showDeleteModal = false" class="text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200">
              <X class="h-5 w-5" />
            </button>
          </div>
          
          <div class="p-6">
            <p class="text-gray-600 dark:text-gray-300">
              Êtes-vous sûr de vouloir supprimer la demande <span class="font-medium text-gray-900 dark:text-white">{{ deleteTarget?.title }}</span> ?
              Cette action est irréversible.
            </p>
            
            <div class="mt-8 flex justify-end space-x-3">
              <button
                @click="showDeleteModal = false"
                type="button"
                class="px-5 py-2.5 bg-white dark:bg-gray-700 border border-gray-300 dark:border-gray-600 rounded-full text-gray-700 dark:text-gray-300 font-medium hover:bg-gray-50 dark:hover:bg-gray-600 focus:outline-none"
              >
                Annuler
              </button>
              <button
                @click="deleteRequest"
                type="button"
                class="px-5 py-2.5 bg-red-600 hover:bg-red-700 rounded-full text-white font-medium focus:outline-none flex items-center justify-center min-w-[100px]"
                :disabled="isDeleting"
              >
                <div v-if="isDeleting" class="h-4 w-4 border-2 border-white border-t-transparent rounded-full animate-spin mr-2"></div>
                {{ isDeleting ? 'Suppression...' : 'Supprimer' }}
              </button>
            </div>
          </div>
        </div>
      </div>
    </Teleport>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import useCategories from '~/composables/useCategories'
import { 
  Search, 
  MapPin, 
  Calendar, 
  Clock, 
  ChevronLeft, 
  ChevronRight,
  Plus,
  Pencil,
  Trash2,
  X,
  ListChecks,
  FileQuestion,
  DollarSign,
} from 'lucide-vue-next'

// Router
const router = useRouter()

// État
const requests = ref([])
const isLoading = ref(true)
const isDeleting = ref(false)
const search = ref('')
const statusFilter = ref('all')
const sortOption = ref('recent')
const currentPage = ref(1)
const perPage = ref(5)
const showDeleteModal = ref(false)
const deleteTarget = ref(null)
const statusMessage = ref({
  show: false,
  type: 'info',
  message: ''
})

// Composables
const supabase = useSupabaseClient()
const { categories, getCategoryName, getCategoryIcon } = useCategories()

// Filtrer les demandes
const filteredRequests = computed(() => {
  let filtered = [...requests.value]
  
  // Filtre par recherche
  if (search.value) {
    const searchLower = search.value.toLowerCase()
    filtered = filtered.filter(request => 
      request.title.toLowerCase().includes(searchLower) || 
      (request.description && request.description.toLowerCase().includes(searchLower))
    )
  }
  
  // Filtre par statut
  if (statusFilter.value !== 'all') {
    filtered = filtered.filter(request => request.status === statusFilter.value)
  }
  
  // Tri
  switch (sortOption.value) {
    case 'recent':
      filtered.sort((a, b) => new Date(b.created_at) - new Date(a.created_at))
      break
    case 'oldest':
      filtered.sort((a, b) => new Date(a.created_at) - new Date(b.created_at))
      break
    case 'budget_high':
      filtered.sort((a, b) => (b.budget || 0) - (a.budget || 0))
      break
    case 'budget_low':
      filtered.sort((a, b) => (a.budget || 0) - (b.budget || 0))
      break
    case 'deadline':
      filtered.sort((a, b) => {
        if (!a.deadline) return 1
        if (!b.deadline) return -1
        return new Date(a.deadline) - new Date(b.deadline)
      })
      break
  }
  
  return filtered
})

// Pagination
const totalPages = computed(() => Math.ceil(filteredRequests.value.length / perPage.value))

const displayedPages = computed(() => {
  const pages = []
  const maxVisiblePages = 5
  
  if (totalPages.value <= maxVisiblePages) {
    // Afficher toutes les pages si moins que maxVisiblePages
    for (let i = 1; i <= totalPages.value; i++) {
      pages.push(i)
    }
  } else {
    // Toujours afficher la première page
    pages.push(1)
    
    // Décider quelles pages du milieu afficher
    if (currentPage.value < 4) {
      // Près du début
      for (let i = 2; i <= 4; i++) {
        pages.push(i)
      }
      pages.push('...')
    } else if (currentPage.value > totalPages.value - 3) {
      // Près de la fin
      pages.push('...')
      for (let i = totalPages.value - 3; i < totalPages.value; i++) {
        pages.push(i)
      }
    } else {
      // Au milieu
      pages.push('...')
      pages.push(currentPage.value - 1)
      pages.push(currentPage.value)
      pages.push(currentPage.value + 1)
      pages.push('...')
    }
    
    // Toujours afficher la dernière page
    if (totalPages.value > 1) {
      pages.push(totalPages.value)
    }
  }
  
  return pages
})

const paginatedRequests = computed(() => {
  const start = (currentPage.value - 1) * perPage.value
  const end = start + perPage.value
  return filteredRequests.value.slice(start, end)
})

// Charger les demandes
const fetchRequests = async () => {
  isLoading.value = true
  
  try {
    const { data: userData } = await supabase.auth.getUser()
    
    if (!userData?.user) {
      router.push('/auth/login')
      return
    }
    
    const { data, error } = await supabase
      .from('requests')
      .select(`
        id, 
        title, 
        description, 
        budget, 
        location, 
        deadline, 
        status, 
        is_urgent, 
        category_id, 
        created_at,
        view_count,
        proposals(count)
      `)
      .eq('client_id', userData.user.id)
      .order('created_at', { ascending: false })
    
    if (error) throw error
    
    // Transformer les données pour ajouter le nombre de propositions
    requests.value = data.map(request => ({
      ...request,
      proposal_count: request.proposals?.count || 0
    }))
    
  } catch (error) {
    console.error('Erreur lors du chargement des demandes:', error)
    showStatusMessage('error', 'Erreur lors du chargement de vos demandes')
  } finally {
    isLoading.value = false
  }
}

// Formater le statut
const formatStatus = (status) => {
  switch (status) {
    case 'open':
      return 'Ouverte'
    case 'in_progress':
      return 'En cours'
    case 'closed':
      return 'Fermée'
    default:
      return status
  }
}

// Formater la date
const formatDate = (dateString) => {
  if (!dateString) return 'Non spécifiée'
  
  const date = new Date(dateString)
  return new Intl.DateTimeFormat('fr-FR', {
    day: 'numeric',
    month: 'long',
    year: 'numeric'
  }).format(date)
}

// Confirmer la suppression
const confirmDelete = (request) => {
  deleteTarget.value = request
  showDeleteModal.value = true
}

// Supprimer une demande
const deleteRequest = async () => {
  if (!deleteTarget.value) return
  
  isDeleting.value = true
  
  try {
    const { error } = await supabase
      .from('requests')
      .delete()
      .eq('id', deleteTarget.value.id)
    
    if (error) throw error
    
    // Mettre à jour la liste des demandes
    requests.value = requests.value.filter(request => request.id !== deleteTarget.value.id)
    
    showStatusMessage('success', 'Demande supprimée avec succès')
    showDeleteModal.value = false
    deleteTarget.value = null
    
    // Revenir à la page 1 si nécessaire
    if (currentPage.value > totalPages.value && totalPages.value > 0) {
      currentPage.value = totalPages.value
    }
    
  } catch (error) {
    console.error('Erreur lors de la suppression:', error)
    showStatusMessage('error', 'Erreur lors de la suppression de la demande')
  } finally {
    isDeleting.value = false
  }
}

// Afficher un message de statut
const showStatusMessage = (type, message, duration = 5000) => {
  statusMessage.value = {
    show: true,
    type,
    message
  }
  
  setTimeout(() => {
    statusMessage.value.show = false
  }, duration)
}

// Initialisation
onMounted(() => {
  fetchRequests()
})

// Vous pouvez ajouter ce bloc en haut de chaque fichier
definePageMeta({
  layout: 'account'
})
</script> 