<template>
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
    <!-- Page header -->
    <div class="mb-8">
      <h1 class="text-2xl font-bold text-gray-900 dark:text-white mb-2">Explorer les services</h1>
      <p class="text-gray-600 dark:text-gray-400">Découvrez des services proposés par nos experts qualifiés</p>
    </div>

    <!-- Filters and search -->
    <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-100 dark:border-gray-700 p-4 mb-6">
      <div class="flex flex-col md:flex-row gap-4">
        <!-- Search input -->
        <div class="w-full md:w-1/3">
          <div class="relative">
            <input 
              v-model="searchQuery" 
              type="text" 
              placeholder="Rechercher un service..." 
              class="w-full pl-10 pr-4 py-2.5 rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
              @keyup.enter="fetchServices"
            />
            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
              <Search class="h-5 w-5 text-gray-400" />
            </div>
          </div>
        </div>

        <!-- Category filter -->
        <div class="w-full md:w-1/4">
          <select 
            v-model="selectedCategory" 
            class="w-full px-3 py-2.5 rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
            @change="fetchServices"
          >
            <option value="">Toutes les catégories</option>
            <option v-for="category in professions" :key="category.id" :value="category.id">
              {{ category.name }}
            </option>
          </select>
        </div>

        <!-- Price filter -->
        <div class="w-full md:w-1/4">
          <select 
            v-model="priceSort" 
            class="w-full px-3 py-2.5 rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
            @change="fetchServices"
          >
            <option value="">Trier par prix</option>
            <option value="asc">Prix croissant</option>
            <option value="desc">Prix décroissant</option>
          </select>
        </div>
        
        <!-- Filter button for mobile -->
        <div class="md:hidden">
          <button 
            @click="showMobileFilters = !showMobileFilters" 
            class="w-full flex items-center justify-center px-4 py-2.5 bg-gray-100 dark:bg-gray-700 text-gray-700 dark:text-gray-300 rounded-lg hover:bg-gray-200 dark:hover:bg-gray-600"
          >
            <Filter class="h-5 w-5 mr-2" />
            Filtres
          </button>
        </div>

        <!-- Apply button -->
        <div class="w-full md:w-auto">
          <button 
            @click="fetchServices" 
            class="w-full md:w-auto flex items-center justify-center px-6 py-2.5 bg-primary-500 hover:bg-primary-600 text-white rounded-lg"
          >
            <RefreshCcw v-if="isLoading" class="h-4 w-4 animate-spin mr-2" />
            <Search v-else class="h-4 w-4 mr-2" />
            Appliquer
          </button>
        </div>
      </div>
      
      <!-- Mobile filters (expandable) -->
      <div v-if="showMobileFilters" class="mt-4 md:hidden space-y-4 border-t border-gray-100 dark:border-gray-700 pt-4">
        <!-- Additional mobile filters can go here -->
        <div>
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Prix maximum</label>
          <input 
            v-model="maxPrice"
            type="range" 
            min="0" 
            max="1000" 
            step="50"
            class="w-full h-2 bg-gray-200 dark:bg-gray-700 rounded-full accent-primary-500"
          />
          <div class="flex justify-between mt-1">
            <span class="text-xs text-gray-500 dark:text-gray-400">0FCFA</span>
            <span class="text-xs text-gray-700 dark:text-gray-300">{{ maxPrice }}FCFA</span>
            <span class="text-xs text-gray-500 dark:text-gray-400">1000FCFA+</span>
          </div>
        </div>
      </div>
    </div>

    <!-- Services grid -->
    <div v-if="services.length > 0" class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
      <NuxtLink 
        v-for="service in services" 
        :key="service.id"
        :to="`/services/${service.id}`"
        class="group"
      >
        <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-100 dark:border-gray-700 overflow-hidden transition-all duration-200 hover:shadow-md">
          <!-- Service image -->
          <div class="relative h-40 bg-gray-200 dark:bg-gray-700">
            <img 
              v-if="service.thumbnail_url" 
              :src="service.thumbnail_url" 
              :alt="service.title"
              class="w-full h-full object-cover"
            />
            <div v-else class="w-full h-full flex items-center justify-center">
              <Briefcase class="h-12 w-12 text-gray-400" />
            </div>
            
            <!-- Price badge -->
            <div class="absolute bottom-3 right-3 bg-white dark:bg-gray-800 text-primary-600 dark:text-primary-400 px-3 py-1 rounded-full text-sm font-semibold shadow-sm">
              {{ formatPrice(service.price) }}
              <span class="text-xs font-normal text-gray-500 dark:text-gray-400">
                {{ formatPriceType(service.price_type) }}
              </span>
            </div>
          </div>
          
          <!-- Service info -->
          <div class="p-4">
            <div class="flex items-start justify-between">
              <div>
                <h3 class="text-lg font-semibold text-gray-900 dark:text-white group-hover:text-primary-500 dark:group-hover:text-primary-400 transition-colors">
                  {{ service.title }}
                </h3>
                <p class="text-sm text-gray-600 dark:text-gray-400 mt-1 line-clamp-2">
                  {{ service.description }}
                </p>
              </div>
            </div>
            
            <!-- Expert info -->
            <div class="mt-4 pt-4 border-t border-gray-100 dark:border-gray-700 flex items-center">
              <div class="h-8 w-8 rounded-full bg-gray-200 dark:bg-gray-700 overflow-hidden">
                <img 
                  v-if="service.expert?.avatar_url" 
                  :src="service.expert.avatar_url" 
                  alt="Expert" 
                  class="h-full w-full object-cover"
                />
                <User v-else class="h-full w-full p-1.5 text-gray-400" />
              </div>
              <div class="ml-2">
                <p class="text-sm font-medium text-gray-900 dark:text-white">
                  {{ getExpertName(service.expert) }}
                </p>
                <div class="flex items-center text-xs text-gray-500 dark:text-gray-400">
                  <Star class="h-3 w-3 text-yellow-400 mr-1" />
                  {{ service.expert?.rating || '4.5' }}
                  <span class="mx-1">•</span>
                  {{ service.expert?.completed_contracts || '10' }} projets
                </div>
              </div>
            </div>
            
            <!-- Skills/tags -->
            <div class="mt-3 flex flex-wrap gap-1">
              <span 
                v-for="skill in service.skills?.slice(0, 3)" 
                :key="skill.id"
                class="inline-flex items-center px-2 py-0.5 rounded-full text-xs bg-primary-50 text-primary-700 dark:bg-primary-900/30 dark:text-primary-400"
              >
                {{ skill.name }}
              </span>
              <span 
                v-if="service.skills?.length > 3" 
                class="inline-flex items-center px-2 py-0.5 rounded-full text-xs bg-gray-100 text-gray-700 dark:bg-gray-700 dark:text-gray-300"
              >
                +{{ service.skills.length - 3 }}
              </span>
            </div>
          </div>
        </div>
      </NuxtLink>
    </div>
    
    <!-- Empty state -->
    <div 
      v-else-if="!isLoading" 
      class="bg-white dark:bg-gray-800 rounded-xl border border-gray-100 dark:border-gray-700 p-8 text-center"
    >
      <div class="mx-auto h-16 w-16 flex items-center justify-center rounded-full bg-gray-100 dark:bg-gray-700 mb-4">
        <Search class="h-8 w-8 text-gray-400" />
      </div>
      <h3 class="text-lg font-medium text-gray-900 dark:text-white">Aucun service trouvé</h3>
      <p class="mt-2 text-sm text-gray-500 dark:text-gray-400">
        Essayez de modifier vos filtres ou d'effectuer une recherche différente.
      </p>
      <button 
        @click="resetFilters" 
        class="mt-4 inline-flex items-center px-4 py-2 bg-primary-500 hover:bg-primary-600 text-white rounded-lg"
      >
        <RefreshCw class="h-4 w-4 mr-2" />
        Réinitialiser les filtres
      </button>
    </div>
    
    <!-- Loading state -->
    <div v-else class="py-20 flex justify-center">
      <div class="h-10 w-10 border-4 border-primary-200 dark:border-primary-900/40 border-t-primary-500 rounded-full animate-spin"></div>
    </div>
    
    <!-- Pagination -->
    <div v-if="services.length > 0 && totalPages > 1" class="mt-10 flex justify-center">
      <div class="flex space-x-2">
        <button 
          @click="changePage(currentPage - 1)" 
          class="p-2 rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-700 dark:text-gray-300 disabled:opacity-50"
          :disabled="currentPage === 1"
        >
          <ChevronLeft class="h-5 w-5" />
        </button>
        
        <button 
          v-for="page in paginationArray" 
          :key="page"
          @click="changePage(page)"
          class="min-w-[40px] px-3 py-2 rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-700 dark:text-gray-300"
          :class="{ 'bg-primary-50 dark:bg-primary-900/30 text-primary-600 dark:text-primary-400 border-primary-500 dark:border-primary-500': currentPage === page }"
        >
          {{ page }}
        </button>
        
        <button 
          @click="changePage(currentPage + 1)" 
          class="p-2 rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-700 dark:text-gray-300 disabled:opacity-50"
          :disabled="currentPage === totalPages"
        >
          <ChevronRight class="h-5 w-5" />
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { 
  Search,
  Filter,
  Briefcase,
  User,
  Star,
  ChevronLeft,
  ChevronRight,
  RefreshCw,
  RefreshCcw
} from 'lucide-vue-next'
import { useSupabaseClient } from '#imports'

const supabase = useSupabaseClient()

// State
const services = ref([])
const professions = ref([])
const isLoading = ref(false)
const selectedCategory = ref('')
const searchQuery = ref('')
const priceSort = ref('')
const maxPrice = ref(1000)
const showMobileFilters = ref(false)

// Pagination
const currentPage = ref(1)
const totalPages = ref(1)
const servicesPerPage = 9

// Computed properties
const paginationArray = computed(() => {
  const pages = []
  const maxVisible = 5
  
  if (totalPages.value <= maxVisible) {
    // Show all pages if there are fewer than maxVisible
    for (let i = 1; i <= totalPages.value; i++) {
      pages.push(i)
    }
  } else {
    // Always include first page
    pages.push(1)
    
    // Calculate start and end of visible pages
    let start = Math.max(2, currentPage.value - Math.floor(maxVisible / 2))
    let end = Math.min(totalPages.value - 1, start + maxVisible - 3)
    
    // Adjust start if needed
    if (end === totalPages.value - 1) start = Math.max(2, end - (maxVisible - 3))
    
    // Add ellipsis after first page if needed
    if (start > 2) pages.push('...')
    
    // Add visible page numbers
    for (let i = start; i <= end; i++) {
      pages.push(i)
    }
    
    // Add ellipsis before last page if needed
    if (end < totalPages.value - 1) pages.push('...')
    
    // Always include last page
    pages.push(totalPages.value)
  }
  
  return pages
})

// Methods
const fetchServices = async () => {
  isLoading.value = true
  
  try {
    let query = supabase
      .from('services')
      .select(`
        *`)
    
    // Apply filters
    if (selectedCategory.value) {
      query = query.eq('profession_id', selectedCategory.value)
    }
    
    if (searchQuery.value) {
      query = query.or(`title.ilike.%${searchQuery.value}%,description.ilike.%${searchQuery.value}%`)
    }
    
    if (maxPrice.value < 1000) {
      query = query.lte('price', maxPrice.value)
    }
    
    // Apply sorting
    if (priceSort.value) {
      query = query.order('price', { ascending: priceSort.value === 'asc' })
    } else {
      query = query.order('created_at', { ascending: false })
    }
    
    // Count total for pagination
    const { count, error: countError } = await supabase
      .from('services')
      .select('*', { count: 'exact', head: true })
    
    if (countError) throw countError
    
    totalPages.value = Math.ceil(count / servicesPerPage)
    
    // Apply pagination
    const from = (currentPage.value - 1) * servicesPerPage
    const to = from + servicesPerPage - 1
    
    query = query.range(from, to)
    
    // Execute query
    const { data, error } = await query
    
    if (error) throw error
    
    // Format the data - transform skills into a flat array
    services.value = data.map(service => ({
      ...service,
      skills: service.skills?.map(item => item.skills)
    }))
  } catch (error) {
    console.error('Error fetching services:', error)
  } finally {
    isLoading.value = false
  }
}

const fetchCategories = async () => {
  try {
    const { data, error } = await supabase
      .from('professions')
      .select('*')
      .order('name')
    
    if (error) throw error
    
    professions.value = data
  } catch (error) {
    console.error('Error fetching professions:', error)
  }
}

const changePage = (page) => {
  if (page === '...') return
  currentPage.value = page
  fetchServices()
  window.scrollTo({ top: 0, behavior: 'smooth' })
}

const resetFilters = () => {
  selectedCategory.value = ''
  searchQuery.value = ''
  priceSort.value = ''
  maxPrice.value = 1000
  showMobileFilters.value = false
  currentPage.value = 1
  fetchServices()
}

const getExpertName = (expert) => {
  if (!expert) return 'Expert'
  
  if (expert.first_name && expert.last_name) {
    return `${expert.first_name} ${expert.last_name}`
  } else if (expert.first_name) {
    return expert.first_name
  } else {
    return 'Expert'
  }
}

const formatPrice = (price) => {
  return new Intl.NumberFormat('fr-FR', { style: 'currency', currency: 'EUR' }).format(price)
}

const formatPriceType = (type) => {
  switch (type) {
    case 'hourly': return '/heure'
    case 'daily': return '/jour'
    case 'fixed': return ' forfait'
    default: return ''
  }
}

// Initialize
onMounted(() => {
  fetchCategories()
  fetchServices()
})
</script>

<style scoped>
/* Animation for page elements */
@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.grid > a {
  animation: fadeIn 0.4s ease-out forwards;
  animation-fill-mode: both;
}

/* Staggered animation for service cards */
.grid > a:nth-child(1) { animation-delay: 0.05s; }
.grid > a:nth-child(2) { animation-delay: 0.1s; }
.grid > a:nth-child(3) { animation-delay: 0.15s; }
.grid > a:nth-child(4) { animation-delay: 0.2s; }
.grid > a:nth-child(5) { animation-delay: 0.25s; }
.grid > a:nth-child(6) { animation-delay: 0.3s; }
.grid > a:nth-child(7) { animation-delay: 0.35s; }
.grid > a:nth-child(8) { animation-delay: 0.4s; }
.grid > a:nth-child(9) { animation-delay: 0.45s; }

/* Improved focus states */
button:focus, a:focus, input:focus, select:focus {
  outline: none;
  @apply ring-offset-2;
  @apply ring-2;
  @apply ring-primary-500;
}

/* Line clamp for text */
.line-clamp-2 {
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
</style> 