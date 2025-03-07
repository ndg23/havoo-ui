<template>
  <div class="p-6 max-w-7xl mx-auto">
    <!-- En-tête avec titre et actions -->
    <div class="flex items-center justify-between mb-6">
      <h1 class="text-2xl font-semibold text-gray-900 dark:text-white">Services</h1>
      
      <div class="flex space-x-3">
        <button 
          @click="exportServices"
          class="px-3 py-2 flex items-center text-sm font-medium rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-700 dark:text-gray-200 hover:bg-gray-50 dark:hover:bg-gray-700"
        >
          <Download class="h-4 w-4 mr-2" />
          Exporter
        </button>
        
        <button 
          @click="openServiceModal()"
          class="px-3 py-2 flex items-center text-sm font-medium rounded-lg bg-primary-600 text-white hover:bg-primary-700"
        >
          <Plus class="h-4 w-4 mr-2" />
          Ajouter un service
        </button>
      </div>
    </div>
    
    <!-- Filtres et recherche -->
    <div class="bg-white dark:bg-gray-800 rounded-xl shadow-sm mb-6 overflow-hidden">
      <div class="p-5 border-b dark:border-gray-700">
        <h2 class="text-lg font-medium text-gray-900 dark:text-white">Filtres</h2>
      </div>
      
      <div class="p-5 grid grid-cols-1 md:grid-cols-2 gap-4">
        <!-- Recherche -->
          <div>
          <label for="search" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Recherche</label>
          <div class="relative">
            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
              <Search class="h-4 w-4 text-gray-400" />
            </div>
            <input
              id="search"
              v-model="search"
              type="text"
              placeholder="Nom du service..."
              class="block w-full pl-10 pr-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
            />
        </div>
      </div>
      
        <!-- Filtre par catégorie -->
          <div>
          <label for="category-filter" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Catégorie</label>
          <select
            id="category-filter"
            v-model="categoryFilter"
            class="block w-full py-2 pl-3 pr-10 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
          >
            <option value="">Toutes les catégories</option>
            <option 
              v-for="category in categories" 
              :key="category.id" 
              :value="category.id"
            >
              {{ category.name }}
            </option>
          </select>
        </div>
      </div>
    </div>
    
    <!-- État de chargement -->
    <div v-if="loading" class="flex justify-center py-20">
      <Loader2 class="h-10 w-10 text-primary-500 animate-spin" />
        </div>
        
    <!-- Table des services -->
    <div v-else-if="filteredServices.length > 0" class="bg-white dark:bg-gray-800 rounded-xl shadow-sm overflow-hidden">
      <div class="overflow-x-auto">
        <table class="min-w-full divide-y divide-gray-200 dark:divide-gray-700">
          <thead class="bg-gray-50 dark:bg-gray-700">
            <tr>
              <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                Service
              </th>
              <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                Catégorie
              </th>
              <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                Prix moyen
              </th>
              <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                Date d'ajout
              </th>
              <th scope="col" class="px-6 py-3 text-center text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                Actions
              </th>
            </tr>
          </thead>
          <tbody class="bg-white dark:bg-gray-800 divide-y divide-gray-200 dark:divide-gray-700">
            <tr v-for="service in paginatedServices" :key="service.id" class="hover:bg-gray-50 dark:hover:bg-gray-700">
              <td class="px-6 py-4 whitespace-nowrap">
                <div class="font-medium text-gray-900 dark:text-white">{{ service.name }}</div>
                <div class="text-sm text-gray-500 dark:text-gray-400">{{ service.description || 'Pas de description' }}</div>
              </td>
              <td class="px-6 py-4 whitespace-nowrap">
                <div class="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-medium bg-gray-100 dark:bg-gray-700 text-gray-800 dark:text-gray-300">
                  {{ getCategoryName(service.category_id) }}
                </div>
              </td>
              <td class="px-6 py-4 whitespace-nowrap">
                <div class="text-sm text-gray-900 dark:text-white">{{ formatPrice(service.average_price) }}</div>
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 dark:text-gray-400">
                {{ formatDate(service.created_at) }}
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-center text-sm">
                <div class="flex justify-center space-x-2">
                  <button 
                    @click="editService(service)"
                    class="p-1.5 text-blue-600 dark:text-blue-400 hover:bg-blue-50 dark:hover:bg-blue-900/20 rounded-lg"
                    title="Modifier"
                  >
                    <Edit class="h-4 w-4" />
                  </button>
                  <button 
                    @click="openDeleteModal(service)"
                    class="p-1.5 text-red-600 dark:text-red-400 hover:bg-red-50 dark:hover:bg-red-900/20 rounded-lg"
                    title="Supprimer"
                  >
                    <Trash class="h-4 w-4" />
                  </button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
          </div>
          
      <!-- Pagination -->
      <div class="px-6 py-4 bg-white dark:bg-gray-800 border-t dark:border-gray-700 flex items-center justify-between">
        <div class="text-sm text-gray-700 dark:text-gray-300">
          Affichage de <span class="font-medium">{{ paginationStart }}</span> à <span class="font-medium">{{ paginationEnd }}</span> sur <span class="font-medium">{{ filteredServices.length }}</span> services
          </div>
          
        <div class="flex space-x-1">
          <button 
            @click="currentPage = 1" 
            :disabled="currentPage === 1"
            class="px-3 py-1 rounded border border-gray-300 dark:border-gray-600 text-sm font-medium text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700 disabled:opacity-50 disabled:cursor-not-allowed"
          >
            <ChevronsLeft class="h-4 w-4" />
          </button>
          <button 
            @click="currentPage--" 
            :disabled="currentPage === 1"
            class="px-3 py-1 rounded border border-gray-300 dark:border-gray-600 text-sm font-medium text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700 disabled:opacity-50 disabled:cursor-not-allowed"
          >
            <ChevronLeft class="h-4 w-4" />
          </button>
          
          <div 
            v-for="page in displayedPages" 
            :key="page"
            class="hidden sm:block"
          >
            <button 
              v-if="page !== '...'"
              @click="currentPage = page"
              :class="[
                'h-8 w-8 text-sm font-medium rounded',
                currentPage === page 
                  ? 'bg-primary-100 dark:bg-primary-900/30 text-primary-700 dark:text-primary-400'
                  : 'text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700'
              ]"
            >
              {{ page }}
            </button>
            <span 
              v-else 
              class="h-8 w-8 flex items-center justify-center text-gray-500"
            >...</span>
          </div>
          
            <button
            @click="currentPage++" 
            :disabled="currentPage === totalPages"
            class="px-3 py-1 rounded border border-gray-300 dark:border-gray-600 text-sm font-medium text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700 disabled:opacity-50 disabled:cursor-not-allowed"
            >
            <ChevronRight class="h-4 w-4" />
            </button>
            <button
            @click="currentPage = totalPages" 
            :disabled="currentPage === totalPages"
            class="px-3 py-1 rounded border border-gray-300 dark:border-gray-600 text-sm font-medium text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700 disabled:opacity-50 disabled:cursor-not-allowed"
            >
            <ChevronsRight class="h-4 w-4" />
            </button>
        </div>
      </div>
    </div>
    
    <!-- Pas de résultats -->
    <div v-else class="bg-white dark:bg-gray-800 rounded-xl shadow-sm p-12 text-center">
      <PackageOpen class="h-16 w-16 mx-auto text-gray-300 dark:text-gray-600 mb-4" />
      <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-2">Aucun service trouvé</h3>
      <p class="text-gray-500 dark:text-gray-400 mb-6">
        {{ search || categoryFilter ? 'Essayez d\'autres filtres' : 'Commencez par ajouter un nouveau service' }}
      </p>
        <button 
        @click="openServiceModal()"
        class="px-4 py-2 flex items-center justify-center mx-auto bg-primary-600 text-white rounded-lg hover:bg-primary-700"
        >
        <Plus class="h-4 w-4 mr-2" />
        Ajouter un service
        </button>
    </div>
    
    <!-- Modals and other components will go here -->
  </div>
</template>

<script setup>
import { ref, computed, watch, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { createClient } from '@supabase/supabase-js'
import {
  Search, Plus, Download, Loader2, ChevronLeft, ChevronRight, ChevronsLeft, ChevronsRight,
  Package, PackageOpen, Edit, Trash
} from 'lucide-vue-next'

const router = useRouter()
const client = createClient(process.env.SUPABASE_URL, process.env.SUPABASE_KEY)

const services = ref([])
const categories = ref([])
const loading = ref(true)
const search = ref('')
const categoryFilter = ref('')
const currentPage = ref(1)
const itemsPerPage = 10
const serviceToDelete = ref(null)
const showDeleteModal = ref(false)
const serviceToEdit = ref(null)
const showServiceModal = ref(false)

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
      .from('categories')
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

watch(search, () => {
  currentPage.value = 1
})

onMounted(fetchServices)

definePageMeta({
  layout: 'admin'
})
</script> 