<template>
  <div class="p-6 max-w-7xl mx-auto">
    <!-- En-tête avec titre et actions -->
    <div class="flex items-center justify-between mb-6">
      <h1 class="text-2xl font-semibold text-gray-900 dark:text-white">Catégories de services</h1>
      
      <div class="flex space-x-3">
        <button 
          @click="exportCategories"
          class="px-3 py-2 flex items-center text-sm font-medium rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-700 dark:text-gray-200 hover:bg-gray-50 dark:hover:bg-gray-700"
        >
          <Download class="h-4 w-4 mr-2" />
          Exporter
        </button>
        
        <button 
          @click="openCategoryModal()"
          class="px-3 py-2 flex items-center text-sm font-medium rounded-lg bg-primary-600 text-white hover:bg-primary-700"
        >
          <Plus class="h-4 w-4 mr-2" />
          Ajouter une catégorie
        </button>
      </div>
              </div>
              
    <!-- Filtres et recherche -->
    <div class="bg-white dark:bg-gray-800 rounded-xl shadow-sm mb-6 overflow-hidden">
      <div class="p-5 border-b dark:border-gray-700">
        <h2 class="text-lg font-medium text-gray-900 dark:text-white">Filtres</h2>
            </div>
            
      <div class="p-5">
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
              placeholder="Nom de catégorie..."
              class="block w-full pl-10 pr-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
            />
          </div>
        </div>
      </div>
    </div>
    
    <!-- État de chargement -->
    <div v-if="loading" class="flex justify-center py-20">
      <Loader2 class="h-10 w-10 text-primary-500 animate-spin" />
    </div>
    
    <!-- Table des catégories -->
    <div v-else-if="filteredCategories.length > 0" class="bg-white dark:bg-gray-800 rounded-xl shadow-sm overflow-hidden">
      <div class="overflow-x-auto">
        <table class="min-w-full divide-y divide-gray-200 dark:divide-gray-700">
          <thead class="bg-gray-50 dark:bg-gray-700">
            <tr>
              <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                Icône
              </th>
              <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                Nom
              </th>
              <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                Services
              </th>
              <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                Date de création
              </th>
              <th scope="col" class="px-6 py-3 text-center text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                Actions
              </th>
            </tr>
          </thead>
          <tbody class="bg-white dark:bg-gray-800 divide-y divide-gray-200 dark:divide-gray-700">
            <tr v-for="category in paginatedCategories" :key="category.id" class="hover:bg-gray-50 dark:hover:bg-gray-700">
              <td class="px-6 py-4 whitespace-nowrap">
                <div class="text-2xl">{{ category.icon }}</div>
              </td>
              <td class="px-6 py-4 whitespace-nowrap">
                <div class="font-medium text-gray-900 dark:text-white">{{ category.name }}</div>
                <div class="text-sm text-gray-500 dark:text-gray-400">{{ category.description || 'Pas de description' }}</div>
              </td>
              <td class="px-6 py-4 whitespace-nowrap">
                <div class="text-sm text-gray-900 dark:text-white">{{ category.services_count || 0 }} services</div>
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 dark:text-gray-400">
                {{ formatDate(category.created_at) }}
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-center text-sm">
                <div class="flex justify-center space-x-2">
                  <button 
                    @click="editCategory(category)"
                    class="p-1.5 text-blue-600 dark:text-blue-400 hover:bg-blue-50 dark:hover:bg-blue-900/20 rounded-lg"
                    title="Modifier"
                  >
                    <Edit class="h-4 w-4" />
                  </button>
                  <button 
                    @click="openDeleteModal(category)"
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
          Affichage de <span class="font-medium">{{ paginationStart }}</span> à <span class="font-medium">{{ paginationEnd }}</span> sur <span class="font-medium">{{ filteredCategories.length }}</span> catégories
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
      <Package class="h-16 w-16 mx-auto text-gray-300 dark:text-gray-600 mb-4" />
      <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-2">Aucune catégorie trouvée</h3>
      <p class="text-gray-500 dark:text-gray-400 mb-6">
        {{ search ? 'Essayez d\'autres termes de recherche' : 'Commencez par ajouter une nouvelle catégorie' }}
      </p>
      <button 
        @click="openCategoryModal()"
        class="px-4 py-2 flex items-center justify-center mx-auto bg-primary-600 text-white rounded-lg hover:bg-primary-700"
      >
        <Plus class="h-4 w-4 mr-2" />
        Ajouter une catégorie
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { useSupabaseClient } from '#imports'
import { 
  Search, Download, Plus, Edit, Trash, Loader2,
  ChevronLeft, ChevronRight, ChevronsLeft, ChevronsRight,
  Package
} from 'lucide-vue-next'

const client = useSupabaseClient()
const categories = ref([])
const loading = ref(true)
const search = ref('')
const currentPage = ref(1)
const itemsPerPage = 10
const categoryToDelete = ref(null)
const showDeleteModal = ref(false)
const categoryToEdit = ref(null)
const showCategoryModal = ref(false)

// Filtrer les catégories par recherche
const filteredCategories = computed(() => {
  if (!search.value) return categories.value
  
  const searchLower = search.value.toLowerCase()
  return categories.value.filter(category => 
    category.name.toLowerCase().includes(searchLower) ||
    (category.description && category.description.toLowerCase().includes(searchLower))
  )
})

// Pagination
const totalPages = computed(() => Math.ceil(filteredCategories.value.length / itemsPerPage))
const paginatedCategories = computed(() => {
  const start = (currentPage.value - 1) * itemsPerPage
  const end = start + itemsPerPage
  return filteredCategories.value.slice(start, end)
})

const paginationStart = computed(() => {
  if (filteredCategories.value.length === 0) return 0
  return (currentPage.value - 1) * itemsPerPage + 1
})

const paginationEnd = computed(() => {
  const end = currentPage.value * itemsPerPage
  return end > filteredCategories.value.length ? filteredCategories.value.length : end
})

// Pages à afficher dans la pagination
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

// Formater la date
const formatDate = (dateString) => {
  if (!dateString) return '—'
  const date = new Date(dateString)
  return date.toLocaleDateString('fr-FR', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  })
}

// Ouvrir le modal d'ajout/édition
const openCategoryModal = (category = null) => {
  categoryToEdit.value = category ? { ...category } : {
    name: '',
    icon: '📦',
    description: ''
  }
  showCategoryModal.value = true
}

// Éditer une catégorie
const editCategory = (category) => {
  openCategoryModal(category)
}

// Ouvrir le modal de suppression
const openDeleteModal = (category) => {
  categoryToDelete.value = category
  showDeleteModal.value = true
}

// Exporter les catégories
const exportCategories = () => {
  // Logique d'exportation
  console.log('Exporter les catégories')
}

// Chargement des données
const fetchCategories = async () => {
  try {
    loading.value = true
    
    // Récupérer les catégories depuis la base de données
    const { data, error } = await client
      .from('service_categories')
      .select('*')
      .order('name')
    
    if (error) throw error
    categories.value = data || []
  } catch (error) {
    console.error('Erreur lors du chargement des catégories:', error)
  } finally {
    loading.value = false
  }
}

// Réinitialiser la pagination quand les filtres changent
watch(search, () => {
  currentPage.value = 1
})

// Charger les catégories au montage du composant
onMounted(fetchCategories)

definePageMeta({
  layout: 'admin'
})
</script> 