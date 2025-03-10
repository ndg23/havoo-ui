<template>
  <div class="max-w-6xl mx-auto px-4 pt-5 pb-16">
    <!-- En-tête de la page -->
    <div class="mb-6 bg-white dark:bg-gray-800 rounded-xl p-5 border-l-4 border-primary-500 shadow-sm">
      <h1 class="text-2xl font-bold text-gray-900 dark:text-white flex items-center">
        <ClipboardListIcon class="h-6 w-6 mr-3 text-primary-600 dark:text-primary-400" />
        Demandes de services
      </h1>
      <p class="text-gray-600 dark:text-gray-400 mt-1">
        Découvrez les demandes publiées par les clients en recherche d'expertise
      </p>
    </div>

    <!-- Section de recherche mise en valeur -->
    <div class="mb-8 bg-gradient-to-r from-primary-50 to-primary-100 dark:from-gray-800 dark:to-primary-900/20 p-6 rounded-xl shadow-sm">
      <div class="flex flex-col md:flex-row gap-4">
        <div class="relative flex-1">
          <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
            <Search class="h-5 w-5 text-primary-500" />
          </div>
          <input 
            v-model="search"
            type="text" 
            placeholder="Rechercher une demande par titre, description ou compétence..."
            class="pl-12 pr-4 py-3.5 w-full text-base rounded-lg border-2 border-primary-200 dark:border-primary-900/50 bg-white dark:bg-gray-800 text-gray-800 dark:text-gray-200 focus:ring-3 focus:ring-primary-500/30 focus:border-primary-500 transition-shadow shadow-sm hover:shadow-md"
          />
        </div>
        <button 
          class="bg-primary-600 hover:bg-primary-700 text-white font-medium rounded-lg text-base px-6 py-3.5 inline-flex items-center justify-center transition-colors shadow-sm min-w-[120px]"
        >
          <SearchIcon class="h-5 w-5 mr-2" />
          Rechercher
        </button>
      </div>
    </div>

    <!-- Filtres et tri -->
    <div class="mb-7">
      <div class="flex flex-col md:flex-row items-start md:items-center justify-between gap-4 bg-white dark:bg-gray-800 p-4 rounded-xl shadow-sm">
        <!-- Catégories -->
        <div class="flex items-center gap-2 overflow-x-auto pb-2 w-full md:w-auto whitespace-nowrap">
          <button 
            @click="selectedCategories = []"
            class="px-4 py-2 rounded-full text-sm font-medium transition-all shrink-0"
            :class="selectedCategories.length === 0 ? 'bg-primary-600 text-white shadow-md' : 'bg-gray-100 text-gray-800 dark:bg-gray-700 dark:text-gray-400 hover:bg-gray-200'"
          >
            Toutes les catégories
          </button>
          <button 
            v-for="category in categories" 
            :key="category.id"
            @click="toggleCategoryFilter(category.id)"
            class="px-4 py-2 rounded-full text-sm font-medium transition-all shrink-0"
            :class="selectedCategories.includes(category.id) ? 'bg-primary-600 text-white shadow-md' : 'bg-gray-100 text-gray-800 dark:bg-gray-700 dark:text-gray-400 hover:bg-gray-200'"
          >
            {{ category.name }}
          </button>
        </div>

        <!-- Tri -->
        <div class="relative z-10">
          <button 
            @click="isOpenSort = !isOpenSort"
            class="px-4 py-2 rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-700 dark:text-gray-300 font-medium flex items-center"
          >
            <ArrowDownUpIcon class="h-4 w-4 mr-2" />
            {{ getSortLabel() }}
            <ChevronDownIcon class="h-4 w-4 ml-2" :class="{ 'transform rotate-180': isOpenSort }" />
          </button>

          <!-- Options de tri -->
          <div v-if="isOpenSort" class="absolute right-0 mt-1 bg-white dark:bg-gray-800 rounded-lg shadow-lg border border-gray-200 dark:border-gray-700 py-1 w-48">
            <button 
              @click="() => { sortOption = 'recent'; isOpenSort = false; }"
              class="w-full px-4 py-2 text-left text-sm hover:bg-gray-100 dark:hover:bg-gray-700"
              :class="sortOption === 'recent' ? 'text-primary-600 dark:text-primary-400 font-medium' : 'text-gray-700 dark:text-gray-300'"
            >
              <ClockIcon class="h-4 w-4 inline-block mr-2" />
              Plus récentes
            </button>
            <button 
              @click="() => { sortOption = 'budget_high'; isOpenSort = false; }"
              class="w-full px-4 py-2 text-left text-sm hover:bg-gray-100 dark:hover:bg-gray-700"
              :class="sortOption === 'budget_high' ? 'text-primary-600 dark:text-primary-400 font-medium' : 'text-gray-700 dark:text-gray-300'"
            >
              <TrendingUpIcon class="h-4 w-4 inline-block mr-2" />
              Budget décroissant
            </button>
            <button 
              @click="() => { sortOption = 'budget_low'; isOpenSort = false; }"
              class="w-full px-4 py-2 text-left text-sm hover:bg-gray-100 dark:hover:bg-gray-700"
              :class="sortOption === 'budget_low' ? 'text-primary-600 dark:text-primary-400 font-medium' : 'text-gray-700 dark:text-gray-300'"
            >
              <TrendingDownIcon class="h-4 w-4 inline-block mr-2" />
              Budget croissant
            </button>
            <button 
              @click="() => { sortOption = 'deadline'; isOpenSort = false; }"
              class="w-full px-4 py-2 text-left text-sm hover:bg-gray-100 dark:hover:bg-gray-700"
              :class="sortOption === 'deadline' ? 'text-primary-600 dark:text-primary-400 font-medium' : 'text-gray-700 dark:text-gray-300'"
            >
              <CalendarIcon class="h-4 w-4 inline-block mr-2" />
              Date limite
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Chargement -->
    <div v-if="loading" class="bg-white dark:bg-gray-800 rounded-xl p-12 flex flex-col items-center">
      <div class="h-12 w-12 border-4 border-primary-500 border-t-transparent rounded-full animate-spin"></div>
      <p class="mt-4 text-gray-600 dark:text-gray-400 text-lg">Recherche des demandes...</p>
    </div>

    <!-- Aucune demande trouvée -->
    <div v-else-if="filteredRequests.length === 0" class="bg-white dark:bg-gray-800 rounded-xl p-10 text-center border border-gray-200 dark:border-gray-700">
      <div class="mb-6 flex justify-center">
        <div class="bg-gray-100 dark:bg-gray-700 p-5 rounded-full">
          <SearchIcon class="h-10 w-10 text-gray-500 dark:text-gray-400" />
        </div>
      </div>
      <h3 class="text-xl font-medium text-gray-900 dark:text-white mb-3">Aucune demande trouvée</h3>
      <p class="text-gray-600 dark:text-gray-400 mb-6 max-w-md mx-auto">
        Essayez de modifier vos critères de recherche ou d'explorer d'autres catégories.
      </p>
      <button 
        @click="resetFilters"
        class="px-5 py-3 bg-primary-600 hover:bg-primary-700 text-white text-base font-medium rounded-lg shadow-md inline-flex items-center transition-transform hover:scale-105"
      >
        <RefreshCwIcon class="h-5 w-5 mr-2" />
        Réinitialiser les filtres
      </button>
    </div>

    <!-- Liste des demandes - Format horizontal -->
    <div v-else class="space-y-5">
      <div v-for="request in displayedRequests" :key="request.id" 
        class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 overflow-hidden hover:shadow-md transition-all duration-300 hover:scale-[1.01] hover:border-primary-300 dark:hover:border-primary-700">
        
        <!-- Format horizontal -->
        <div class="flex flex-col md:flex-row">
          <!-- Partie gauche avec icône de catégorie -->
          <div class="md:w-1/4 p-5 flex items-center justify-center relative">
            <div class="w-24 h-24 rounded-full bg-primary-100 dark:bg-primary-900/30 flex items-center justify-center">
              <component 
                :is="getCategoryIcon(request.category_id)" 
                class="h-12 w-12 text-primary-600 dark:text-primary-400" 
              />
            </div>
            
            <!-- Badge pour les demandes urgentes -->
            <div v-if="request.is_urgent" class="absolute top-3 left-3 bg-red-500 px-2.5 py-1 rounded-full flex items-center shadow-sm">
              <ClockIcon class="h-3.5 w-3.5 text-white mr-1" />
              <span class="text-xs font-semibold text-white">Urgent</span>
            </div>
          </div>
          
          <!-- Partie droite avec détails de la demande -->
          <div class="md:w-3/4 p-5 flex flex-col">
            <div class="flex justify-between items-start mb-3">
              <!-- Titre et infos client -->
              <div>
                <h3 class="text-xl font-bold text-gray-900 dark:text-white">
                  {{ request.title }}
                </h3>
                <p class="text-primary-600 dark:text-primary-400 font-medium">
                  Par {{ request.client_name }}
                </p>
                <div class="flex items-center mt-2 text-sm text-gray-600 dark:text-gray-400">
                  <MapPinIcon class="h-4 w-4 mr-1.5" />
                  {{ request.location || 'Paris' }}
                </div>
              </div>
              
              <!-- Budget et statut -->
              <div class="flex flex-col items-end">
                <div class="bg-primary-50 dark:bg-primary-900/20 px-4 py-2 rounded-lg shadow-sm">
                  <span class="font-bold text-xl text-primary-700 dark:text-primary-400">{{ request.budget || '120' }}€</span>
                </div>
                
                <div class="mt-2 flex items-center text-sm font-medium" 
                  :class="{
                    'text-green-600 dark:text-green-400': request.status === 'open',
                    'text-yellow-600 dark:text-yellow-400': request.status === 'in_progress',
                    'text-gray-500 dark:text-gray-400': request.status === 'closed'
                  }"
                >
                  <div class="h-2 w-2 rounded-full mr-2"
                    :class="{
                      'bg-green-500': request.status === 'open',
                      'bg-yellow-500': request.status === 'in_progress',
                      'bg-gray-400': request.status === 'closed'
                    }"
                  ></div>
                  {{ formatStatus(request.status) }}
                </div>
              </div>
            </div>
            
            <!-- Description -->
            <p class="text-gray-600 dark:text-gray-400 line-clamp-3 mb-4">
              {{ request.description }}
            </p>
            
            <!-- Informations complémentaires -->
            <div class="flex flex-wrap justify-between items-end mt-auto">
              <!-- Date limite -->
              <div class="flex items-center text-sm text-gray-600 dark:text-gray-400 mb-3 md:mb-0">
                <CalendarIcon class="h-4 w-4 mr-1.5" />
                <span><span class="font-medium">Date limite:</span> {{ formatDate(request.deadline) }}</span>
              </div>
              
              <!-- Compétences requises -->
              <div class="flex flex-wrap gap-1.5">
                <span 
                  v-for="(skill, index) in getRequestSkills(request).slice(0, 3)" 
                  :key="index"
                  class="px-3 py-1 text-xs font-medium bg-gray-100 dark:bg-gray-700 text-gray-700 dark:text-gray-300 rounded-full"
                >
                  {{ skill }}
                </span>
                <span 
                  v-if="getRequestSkills(request).length > 3" 
                  class="px-3 py-1 text-xs font-medium bg-gray-100 dark:bg-gray-700 text-gray-700 dark:text-gray-300 rounded-full"
                >
                  +{{ getRequestSkills(request).length - 3 }}
                </span>
              </div>
            </div>
            
            <!-- Bouton d'action -->
            <div class="mt-4 flex justify-end">
              <NuxtLink :to="`/requests/${request.id}`" class="px-5 py-2.5 bg-primary-600 hover:bg-primary-700 text-white rounded-full font-medium inline-flex items-center shadow-sm transition-all">
                <SunriseIcon class="h-4 w-4 mr-2" />
                Répondre à cette demande
              </NuxtLink>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Pagination -->
    <div v-if="!loading && filteredRequests.length > 0" class="mt-8 flex justify-center">
      <div class="inline-flex rounded-md shadow-sm" role="group">
        <button 
          @click="currentPage > 1 ? currentPage-- : null"
          :disabled="currentPage === 1"
          class="px-4 py-2 text-sm font-medium rounded-l-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800"
          :class="currentPage === 1 ? 'text-gray-400 dark:text-gray-600' : 'text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700'"
        >
          <ChevronLeftIcon class="h-5 w-5" />
        </button>
        
        <button 
          v-for="page in paginationArray"
          :key="page"
          @click="page !== '...' ? currentPage = page : null"
          :disabled="page === '...'"
          class="px-4 py-2 text-sm font-medium border border-gray-300 dark:border-gray-600 border-l-0 bg-white dark:bg-gray-800"
          :class="[
            page === '...' ? 'text-gray-400 dark:text-gray-600' : 
            currentPage === page ? 'bg-primary-50 dark:bg-primary-900/20 text-primary-700 dark:text-primary-400 font-bold' : 
            'text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700'
          ]"
        >
          {{ page }}
        </button>
        
        <button 
          @click="currentPage < totalPages ? currentPage++ : null"
          :disabled="currentPage === totalPages"
          class="px-4 py-2 text-sm font-medium rounded-r-lg border border-gray-300 dark:border-gray-600 border-l-0 bg-white dark:bg-gray-800"
          :class="currentPage === totalPages ? 'text-gray-400 dark:text-gray-600' : 'text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700'"
        >
          <ChevronRightIcon class="h-5 w-5" />
        </button>
      </div>
    </div>
    
    <!-- Bouton flottant pour créer une nouvelle demande -->
    <NuxtLink to="/requests/new" class="fixed bottom-8 right-8 h-14 w-14 bg-primary-600 hover:bg-primary-700 text-white rounded-full flex items-center justify-center shadow-lg hover:shadow-xl transition-all duration-300 transform hover:scale-110">
      <PlusIcon class="h-7 w-7" />
    </NuxtLink>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue'
import { 
  Search, ClipboardListIcon, ChevronDownIcon, ArrowDownUpIcon, 
  ClockIcon, TrendingUpIcon, TrendingDownIcon, CalendarIcon, 
  MapPinIcon, RefreshCwIcon, ChevronLeftIcon, ChevronRightIcon,
  PlusIcon, SunriseIcon, Home, Paintbrush, Wrench, Hammer, FileText, 
  Briefcase, LayoutGrid
} from 'lucide-vue-next'

const router = useRouter()
const client = useSupabaseClient()

// État du composant
const loading = ref(true)
const requests = ref([])
const categories = ref([])
const selectedCategories = ref([])
const search = ref('')
const sortOption = ref('recent')
const currentPage = ref(1)
const itemsPerPage = 5
const isOpenSort = ref(false)

// Filtrage des demandes
const filteredRequests = computed(() => {
  let filtered = [...requests.value]
  
  if (search.value) {
    const searchLower = search.value.toLowerCase()
    filtered = filtered.filter(request => 
      request.title?.toLowerCase().includes(searchLower) || 
      (request.description && request.description.toLowerCase().includes(searchLower)) ||
      (request.skills && request.skills.some(s => s.toLowerCase().includes(searchLower)))
    )
  }
  
  if (selectedCategories.value.length > 0) {
    filtered = filtered.filter(request => 
      selectedCategories.value.includes(request.category_id)
    )
  }
  
  switch (sortOption.value) {
    case 'recent':
      filtered.sort((a, b) => new Date(b.created_at || Date.now()) - new Date(a.created_at || Date.now()))
      break
    case 'budget_high':
      filtered.sort((a, b) => (b.budget || 0) - (a.budget || 0))
      break
    case 'budget_low':
      filtered.sort((a, b) => (a.budget || 0) - (b.budget || 0))
      break
    case 'deadline':
      filtered.sort((a, b) => new Date(a.deadline || Date.now()) - new Date(b.deadline || Date.now()))
      break
  }
  
  return filtered
})

// Demandes à afficher pour la page actuelle
const displayedRequests = computed(() => {
  const start = (currentPage.value - 1) * itemsPerPage
  const end = start + itemsPerPage
  return filteredRequests.value.slice(start, end)
})

// Nombre total de pages
const totalPages = computed(() => {
  return Math.ceil(filteredRequests.value.length / itemsPerPage)
})

// Génération du tableau de pagination
const paginationArray = computed(() => {
  const totalPagesVal = totalPages.value
  const current = currentPage.value
  
  if (totalPagesVal <= 7) {
    return Array.from({ length: totalPagesVal }, (_, i) => i + 1)
  }
  
  if (current <= 3) {
    return [1, 2, 3, 4, 5, '...', totalPagesVal]
  }
  
  if (current >= totalPagesVal - 2) {
    return [1, '...', totalPagesVal - 4, totalPagesVal - 3, totalPagesVal - 2, totalPagesVal - 1, totalPagesVal]
  }
  
  return [1, '...', current - 1, current, current + 1, '...', totalPagesVal]
})

// Formater une date
const formatDate = (dateString) => {
  if (!dateString) return 'Non spécifiée'
  
  const date = new Date(dateString)
  return new Intl.DateTimeFormat('fr-FR', { 
    day: 'numeric',
    month: 'short', 
    year: 'numeric'
  }).format(date)
}

// Formater le statut
const formatStatus = (status) => {
  switch (status) {
    case 'open': return 'Ouverte'
    case 'in_progress': return 'En cours'
    case 'closed': return 'Fermée'
    default: return 'Ouverte'
  }
}

// Obtenir le libellé du tri actuel
const getSortLabel = () => {
  switch (sortOption.value) {
    case 'recent':
      return 'Plus récentes'
    case 'budget_high':
      return 'Budget décroissant'
    case 'budget_low':
      return 'Budget croissant'
    case 'deadline':
      return 'Date limite'
    default:
      return 'Trier par'
  }
}

// Obtenir le nom de la catégorie
const getCategoryName = (categoryId) => {
  const category = categories.value.find(c => c.id === categoryId)
  return category ? category.name : 'Service général'
}

// Obtenir l'icône de la catégorie
const getCategoryIcon = (categoryId) => {
  const iconMap = {
    1: Home, // Ménage
    2: Paintbrush, // Peinture
    3: Wrench, // Plomberie
    4: Hammer, // Bricolage
    5: FileText, // Administration
    6: Briefcase // Services professionnels
  }
  
  return iconMap[categoryId] || LayoutGrid
}

// Obtenir les compétences requises
const getRequestSkills = (request) => {
  return request.skills || ['Compétence générale']
}

// Basculer la sélection d'une catégorie
const toggleCategoryFilter = (categoryId) => {
  const index = selectedCategories.value.indexOf(categoryId)
  if (index === -1) {
    selectedCategories.value.push(categoryId)
  } else {
    selectedCategories.value.splice(index, 1)
  }
}

// Réinitialiser les filtres
const resetFilters = () => {
  search.value = ''
  selectedCategories.value = []
  currentPage.value = 1
  sortOption.value = 'recent'
}

// Réinitialiser la pagination quand les filtres changent
watch([search, selectedCategories, sortOption], () => {
  currentPage.value = 1
})

// Charger les données
const fetchData = async () => {
  try {
    loading.value = true;
    
    // Récupérer les catégories
    const { data: categoriesData, error: categoriesError } = await client
      .from('categories')
      .select('id, name');
    
    if (categoriesError) throw categoriesError;
    categories.value = categoriesData || [];
    
    // Récupérer les demandes en utilisant la vue request_details
    const { data: requestsData, error: requestsError } = await client
      .from('request_details')
      .select('*');
    
    if (requestsError) throw requestsError;
    
    // Assigner les données
    requests.value = requestsData || [];
  } catch (error) {
    console.error('Erreur lors du chargement des données:', error);
  } finally {
    loading.value = false;
  }
};

// Charger les données lors du montage du composant
onMounted(fetchData)

definePageMeta({
  layout: 'default'
})
</script>

<style scoped>
/* Animation des composants */
.space-y-5 > div {
  animation: slideIn 0.6s cubic-bezier(0.16, 1, 0.3, 1);
  animation-fill-mode: both;
}

.space-y-5 > div:nth-child(1) { animation-delay: 0.05s; }
.space-y-5 > div:nth-child(2) { animation-delay: 0.1s; }
.space-y-5 > div:nth-child(3) { animation-delay: 0.15s; }
.space-y-5 > div:nth-child(4) { animation-delay: 0.2s; }
.space-y-5 > div:nth-child(5) { animation-delay: 0.25s; }

@keyframes slideIn {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* Style limitant le nombre de lignes */
.line-clamp-3 {
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

/* Animation sur la barre de recherche */
input[type="text"] {
  transition: all 0.3s ease;
}

input[type="text"]:focus {
  transform: translateY(-2px);
}

/* Mises en valeur des boutons au survol */
button, a {
  transition: all 0.2s ease;
}

button:hover:not(:disabled), a:hover {
  transform: translateY(-1px);
}

/* Masquer la barre de défilement tout en permettant le défilement */
.no-scrollbar::-webkit-scrollbar {
  display: none;
}
.no-scrollbar {
  -ms-overflow-style: none;
  scrollbar-width: none;
}
</style> 