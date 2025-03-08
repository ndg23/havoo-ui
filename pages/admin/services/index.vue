<template>
  <div class="max-w-7xl mx-auto px-4 py-8">
    <!-- En-tête de la page -->
    <div class="flex justify-between items-center mb-8">
      <div>
        <h1 class="text-2xl font-bold text-gray-900 dark:text-white">Gestion des services</h1>
        <p class="text-gray-600 dark:text-gray-400 mt-1">Visualisez et modérez les services proposés par les experts</p>
      </div>
      
      <div class="flex space-x-3">
        <button 
          @click="exportServices"
          class="flex items-center px-4 py-2 text-gray-700 dark:text-gray-300 bg-white dark:bg-gray-800 border border-gray-300 dark:border-gray-600 rounded-full text-sm font-medium hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors"
        >
          <Download class="h-4 w-4 mr-1.5" />
          Exporter
        </button>
        
        <button 
          @click="openServiceModal()"
          class="flex items-center px-6 py-2.5 bg-primary-600 hover:bg-primary-700 text-white text-sm font-medium rounded-full transition-colors shadow-sm"
        >
          <Plus class="h-4 w-4 mr-1.5" />
          Ajouter un service
        </button>
      </div>
    </div>
    
    <!-- Alerte de statut -->
    <div 
      v-if="statusMessage && statusMessage.show"
      :class="[
        'p-4 mb-6 rounded-xl border flex items-start',
        statusMessage.type === 'success' ? 'bg-green-50 border-green-200 text-green-800 dark:bg-green-900/30 dark:border-green-800 dark:text-green-300' : '',
        statusMessage.type === 'error' ? 'bg-red-50 border-red-200 text-red-800 dark:bg-red-900/30 dark:border-red-800 dark:text-red-300' : '',
        statusMessage.type === 'info' ? 'bg-blue-50 border-blue-200 text-blue-800 dark:bg-blue-900/30 dark:border-blue-800 dark:text-blue-300' : '',
        statusMessage.type === 'warning' ? 'bg-yellow-50 border-yellow-200 text-yellow-800 dark:bg-yellow-900/30 dark:border-yellow-800 dark:text-yellow-300' : ''
      ]"
    >
      <div class="flex-shrink-0 mr-3">
        <CheckCircle v-if="statusMessage.type === 'success'" class="h-5 w-5" />
        <XCircle v-if="statusMessage.type === 'error'" class="h-5 w-5" />
        <AlertCircle v-if="statusMessage.type === 'warning'" class="h-5 w-5" />
        <Info v-if="statusMessage.type === 'info'" class="h-5 w-5" />
      </div>
      <div class="flex-1">
        <p class="text-sm font-medium">{{ statusMessage.message }}</p>
      </div>
      <button 
        @click="statusMessage.show = false"
        class="p-1 ml-3 rounded-full hover:bg-black/10 dark:hover:bg-white/10 transition-colors"
      >
        <X class="h-4 w-4" />
      </button>
    </div>
    
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
              placeholder="Titre, description, compétences..."
              class="w-full px-4 py-2.5 border border-gray-300 dark:border-gray-600 rounded-full shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white pl-10"
            />
            <Search class="absolute left-3 top-3 h-4 w-4 text-gray-400" />
          </div>
        </div>
        
        <div class="w-52">
          <label for="category" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">Catégorie</label>
          <select
            v-model="categoryFilter"
            id="category"
            class="w-full px-4 py-2.5 border border-gray-300 dark:border-gray-600 rounded-full shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white appearance-none bg-no-repeat"
          >
            <option value="">Toutes les catégories</option>
            <option v-for="category in categories" :key="category.id" :value="category.id">
              {{ category.name }}
            </option>
          </select>
        </div>
        
        <div class="w-52">
          <label for="sort" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">Trier par</label>
          <select
            v-model="sortOption"
            id="sort"
            class="w-full px-4 py-2.5 border border-gray-300 dark:border-gray-600 rounded-full shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white appearance-none bg-no-repeat"
          >
            <option value="recent">Plus récents</option>
            <option value="oldest">Plus anciens</option>
            <option value="price_high">Prix (décroissant)</option>
            <option value="price_low">Prix (croissant)</option>
            <option value="title">Titre (A-Z)</option>
          </select>
        </div>
      </div>
    </div>
    
    <!-- Section de chargement -->
    <div v-if="loading" class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 p-16 animate-pulse shadow-sm">
      <div class="flex flex-col items-center justify-center">
        <div class="h-10 w-10 border-4 border-primary-500 border-t-transparent rounded-full animate-spin"></div>
        <p class="mt-4 text-gray-600 dark:text-gray-400 font-medium">Chargement des services...</p>
      </div>
    </div>
    
    <!-- Message si aucun résultat -->
    <div v-else-if="!filteredServices || filteredServices.length === 0" class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 p-16 text-center shadow-sm">
      <div class="flex flex-col items-center justify-center">
        <PackageOpen class="h-12 w-12 text-gray-400 mb-3" />
        <h3 class="text-lg font-medium text-gray-900 dark:text-gray-100 mb-1">Aucun service trouvé</h3>
        <p class="text-gray-600 dark:text-gray-400">
          {{ search || categoryFilter ? `Aucun résultat pour vos filtres actuels` : 'Aucun service disponible' }}
        </p>
        <button 
          @click="resetFilters"
          class="mt-4 px-4 py-2 bg-gray-100 dark:bg-gray-700 text-gray-700 dark:text-gray-300 rounded-full text-sm font-medium hover:bg-gray-200 dark:hover:bg-gray-600 transition-colors"
        >
          Réinitialiser les filtres
        </button>
      </div>
    </div>
    
    <!-- Liste des services -->
    <div v-else class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 overflow-hidden shadow-sm">
      <!-- En-tête du tableau -->
      <div class="bg-gray-50 dark:bg-gray-750 px-6 py-3 border-b border-gray-200 dark:border-gray-700 grid grid-cols-12 gap-4 text-left">
        <div class="col-span-5 text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
          Service
        </div>
        <div class="col-span-2 text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
          Catégorie
        </div>
        <div class="col-span-2 text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
          Prix
        </div>
        <div class="col-span-1 text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
          Date
        </div>
        <div class="col-span-2 text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider text-right">
          Actions
        </div>
      </div>
      
      <!-- Liste des services -->
      <div class="divide-y divide-gray-200 dark:divide-gray-700">
        <div 
          v-for="service in paginatedServices" 
          :key="service.id"
          class="px-6 py-4 grid grid-cols-12 gap-4 hover:bg-gray-50 dark:hover:bg-gray-750 transition-colors"
        >
          <!-- Colonne service -->
          <div class="col-span-5 flex items-center">
            <div class="flex-shrink-0 relative">
              <div class="h-10 w-10 bg-primary-100 dark:bg-primary-900/50 text-primary-700 dark:text-primary-300 flex items-center justify-center rounded-full">
                {{ service.icon || '🔧' }}
              </div>
            </div>
            <div class="ml-4">
              <div class="font-medium text-gray-900 dark:text-white">
                {{ service.name }}
              </div>
              <div class="text-sm text-gray-500 dark:text-gray-400 line-clamp-1">
                {{ service.description || 'Pas de description' }}
              </div>
            </div>
          </div>
          
          <!-- Catégorie -->
          <div class="col-span-2 flex items-center">
            <span 
              class="px-2.5 py-1 rounded-full text-xs font-medium bg-gray-100 dark:bg-gray-700 text-gray-800 dark:text-gray-300"
            >
              {{ getCategoryName(service.category_id) }}
            </span>
          </div>
          
          <!-- Prix -->
          <div class="col-span-2 flex items-center">
            <div class="font-medium text-gray-900 dark:text-white">
              {{ formatPrice(service.average_price || service.price) }}
            </div>
          </div>
          
          <!-- Date -->
          <div class="col-span-1 flex items-center">
            <div class="text-sm text-gray-500 dark:text-gray-400">
              {{ formatDate(service.created_at) }}
            </div>
          </div>
          
          <!-- Actions -->
          <div class="col-span-2 flex items-center justify-end space-x-2">
            <button 
              @click="editService(service)"
              class="p-2 text-primary-600 dark:text-primary-400 hover:bg-primary-50 dark:hover:bg-primary-900/20 rounded-full transition-colors"
              title="Modifier"
            >
              <Edit class="h-4 w-4" />
            </button>
            <button 
              @click="openDeleteModal(service)"
              class="p-2 text-red-600 dark:text-red-400 hover:bg-red-50 dark:hover:bg-red-900/20 rounded-full transition-colors"
              title="Supprimer"
            >
              <Trash class="h-4 w-4" />
            </button>
          </div>
        </div>
      </div>
      
      <!-- Pagination -->
      <div v-if="totalPages > 1" class="bg-gray-50 dark:bg-gray-750 px-6 py-4 border-t border-gray-200 dark:border-gray-700 flex items-center justify-between">
        <div class="text-sm text-gray-700 dark:text-gray-300 hidden sm:block">
          <span>Affichage de </span>
          <span class="font-medium">{{ paginationStart }}</span>
          <span> à </span>
          <span class="font-medium">{{ paginationEnd }}</span>
          <span> sur </span>
          <span class="font-medium">{{ filteredServices.length }}</span>
          <span> services</span>
        </div>
        
        <div class="flex justify-center flex-1 sm:justify-end">
          <nav class="flex items-center space-x-1">
            <button
              v-for="page in displayedPages"
              :key="page"
              v-if="page !== '...'"
              @click="currentPage = page"
              class="h-8 w-8 flex items-center justify-center rounded-full text-sm"
              :class="[
                currentPage === page 
                  ? 'bg-primary-50 dark:bg-primary-900/30 text-primary-600 dark:text-primary-400 font-medium' 
                  : 'text-gray-600 dark:text-gray-400 hover:bg-gray-100 dark:hover:bg-gray-700'
              ]"
            >
              {{ page }}
            </button>
            <span v-else class="px-2 text-gray-500 dark:text-gray-400">...</span>
          </nav>
        </div>
      </div>
    </div>
    
    <!-- Modales de confirmation et formulaires -->
    <!-- ... Les modales existantes ... -->
  </div>
</template>

<script setup>
import { ref, computed, watch, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import {
  Search, Plus, Download, CheckCircle, XCircle, AlertCircle, Info, X,
  ChevronLeft, ChevronRight, ChevronsLeft, ChevronsRight,
  Package, PackageOpen, Edit, Trash, FileText
} from 'lucide-vue-next'

const router = useRouter()
const client = useSupabaseClient()

// État
const services = ref([])
const categories = ref([])
const loading = ref(true)
const search = ref('')
const categoryFilter = ref('')
const sortOption = ref('recent')
const currentPage = ref(1)
const itemsPerPage = 10
const serviceToDelete = ref(null)
const showDeleteModal = ref(false)
const serviceToEdit = ref(null)
const showServiceModal = ref(false)
const statusMessage = ref({
  show: false,
  type: 'info',
  message: ''
})

const filteredServices = computed(() => {
  if (!search.value && !categoryFilter.value) return services.value
  
  const searchLower = search.value?.toLowerCase() || ''
  const categoryId = categoryFilter.value
  
  return services.value.filter(service => 
    service.name?.toLowerCase().includes(searchLower) ||
    service.description?.toLowerCase().includes(searchLower) ||
    (categoryId && service.category_id === categoryId)
  )
})

const totalPages = computed(() => Math.ceil(filteredServices.value.length / itemsPerPage))
const paginatedServices = computed(() => {
  const start = (currentPage.value - 1) * itemsPerPage
  const end = start + itemsPerPage
  return filteredServices.value.slice(start, end)
})

const paginationStart = computed(() => {
  if (filteredServices.value.length === 0) return 0
  return (currentPage.value - 1) * itemsPerPage + 1
})

const paginationEnd = computed(() => {
  const end = currentPage.value * itemsPerPage
  return end > filteredServices.value.length ? filteredServices.value.length : end
})

const displayedPages = computed(() => {
  if (totalPages.value <= 7) {
    return Array.from({ length: totalPages.value }, (_, i) => i + 1)
  }
  
  if (currentPage.value <= 4) {
    return [1, 2, 3, 4, 5, '...', totalPages.value]
  }
  
  if (currentPage.value >= totalPages.value - 3) {
    return [1, '...', totalPages.value - 4, totalPages.value - 3, totalPages.value - 2, totalPages.value - 1, totalPages.value]
  }
  
  return [1, '...', currentPage.value - 1, currentPage.value, currentPage.value + 1, '...', totalPages.value]
})

function formatDate(dateString) {
  if (!dateString) return '—'
  const date = new Date(dateString)
  return date.toLocaleDateString('fr-FR', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  })
}

function formatPrice(price) {
  return new Intl.NumberFormat('fr-FR', {
    style: 'currency',
    currency: 'EUR',
    minimumFractionDigits: 0
  }).format(price)
}

function getCategoryName(categoryId) {
  const category = categories.value.find(c => c.id === categoryId)
  return category ? category.name : 'Non catégorisé'
}

function openServiceModal() {
  serviceToEdit.value = {
    name: '',
    description: '',
    category_id: '',
    price: 0,
    duration: 60,
    active: true,
    icon: '🔧'
  }
  showServiceModal.value = true
}

function editService(service) {
  serviceToEdit.value = { ...service }
  showServiceModal.value = true
}

function openDeleteModal(service) {
  serviceToDelete.value = service
  showDeleteModal.value = true
}

function exportServices() {
  // Logique d'exportation
  console.log('Exporter les services')
}

async function fetchServices() {
  try {
    loading.value = true
    
    const { data: categoriesData, error: categoriesError } = await client
      .from('service_categories')
      .select('*')
    
    if (categoriesError) throw categoriesError
    categories.value = categoriesData || []
    
    const { data: servicesData, error: servicesError } = await client
      .from('services')
      .select('*')
      .order('updated_at', { ascending: false })
    
    if (servicesError) throw servicesError
    services.value = servicesData || []
  } catch (error) {
    console.error('Erreur lors du chargement des services:', error)
  } finally {
    loading.value = false
  }
}

async function saveService(serviceData) {
  try {
    // Logique pour enregistrer le service
    await fetchServices()
    showServiceModal.value = false
  } catch (error) {
    console.error('Erreur lors de l\'enregistrement du service:', error)
    alert('Erreur lors de l\'enregistrement du service: ' + error.message)
  }
}

async function deleteService() {
  if (!serviceToDelete.value) return
  
  try {
    // Logique pour supprimer le service
    await fetchServices()
    showDeleteModal.value = false
    serviceToDelete.value = null
  } catch (error) {
    console.error('Erreur lors de la suppression du service:', error)
    alert('Erreur lors de la suppression du service: ' + error.message)
  }
}

// Réinitialiser les filtres
const resetFilters = () => {
  search.value = ''
  categoryFilter.value = ''
  sortOption.value = 'recent'
  currentPage.value = 1
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

watch([search, categoryFilter, sortOption], () => {
  currentPage.value = 1
})

onMounted(() => {
  fetchServices()
})
definePageMeta({
  layout: 'admin'
})
</script>

<style scoped>
/* Style pour les sélecteurs avec flèche dropdown */
select {
  background-position: right 1rem center;
  background-repeat: no-repeat;
  background-size: 1em;
  background-image: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/></svg>');
}

/* Animation pour le modal */
.modal-enter-active,
.modal-leave-active {
  transition: opacity 0.25s ease, transform 0.25s ease;
}

.modal-enter-from,
.modal-leave-to {
  opacity: 0;
  transform: scale(0.95);
}
</style>