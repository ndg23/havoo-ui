<template>
  <div class="min-h-screen bg-gray-50">
    <!-- En-tête amélioré -->
    <div class="bg-white border-b border-gray-100 sticky top-0 z-10 shadow-sm">
      <div class="max-w-5xl mx-auto px-5 py-4">
        <div class="flex flex-col space-y-4">
          <!-- Titre et bouton de demande -->
          <div class="flex items-center justify-between">
            <h1 class="text-2xl font-bold text-gray-800">Demandes de services</h1>
        <NuxtLink 
              to="/experts" 
              class="px-6 py-2.5 bg-gradient-to-r from-primary-500 to-primary-600 text-white text-sm font-medium rounded-full shadow-sm hover:shadow-md transition-all duration-200 transform hover:-translate-y-0.5"
        >
              Trouver un expert
        </NuxtLink>
    </div>
    
          <!-- Barre de recherche améliorée -->
          <div class="relative">
            <Search class="absolute left-4 top-1/2 transform -translate-y-1/2 text-primary-400 h-5 w-5" />
              <input 
              v-model="search"
              type="text"
              placeholder="Rechercher une demande (ex: ménage, réparation...)"
              class="w-full pl-12 pr-4 py-3 border border-gray-200 rounded-full bg-gray-50 focus:outline-none focus:ring-2 focus:ring-primary-200 focus:border-primary-300 transition-all shadow-sm"
            />
        </div>
        
          <!-- Filtres horizontaux améliorés -->
          <div class="flex overflow-x-auto no-scrollbar gap-2 py-1">
            <button 
              v-for="category in categories" 
              :key="category.id"
              @click="toggleCategoryFilter(category.id)"
              :class="[
                'px-4 py-2 text-sm font-medium rounded-full whitespace-nowrap transition-all duration-200',
                selectedCategories.includes(category.id)
                  ? 'bg-gradient-to-r from-primary-500 to-primary-600 text-white shadow-sm'
                  : 'bg-white text-gray-700 border border-gray-200 hover:border-primary-300 hover:bg-gray-50'
              ]"
            >
              {{ category.name }}
            </button>
          </div>
        </div>
      </div>
    </div>
    
    <!-- Contenu principal amélioré -->
    <div class="max-w-5xl mx-auto px-5 py-6">
      <!-- État de chargement -->
      <div v-if="loading" class="flex justify-center py-16">
        <div class="flex flex-col items-center">
          <Loader2 class="h-10 w-10 text-primary-500 animate-spin mb-4" />
          <span class="text-gray-500">Recherche des demandes...</span>
        </div>
      </div>
      
      <!-- Nombre de résultats -->
      <div v-else-if="filteredRequests.length > 0" class="mb-4 flex justify-between items-center">
        <p class="text-sm text-gray-500 font-medium">
          {{ filteredRequests.length }} demande{{ filteredRequests.length > 1 ? 's' : '' }}
        </p>
        
        <!-- Tri -->
        <div class="relative">
          <select 
            v-model="sortOption"
            class="appearance-none bg-white border border-gray-200 rounded-full px-4 py-2 pr-8 text-sm focus:outline-none focus:ring-2 focus:ring-primary-200 focus:border-primary-300 transition-all cursor-pointer"
          >
            <option value="recent">Plus récentes</option>
            <option value="budget_high">Budget décroissant</option>
            <option value="budget_low">Budget croissant</option>
            <option value="deadline">Date limite</option>
          </select>
          <ChevronDown class="absolute right-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-gray-400 pointer-events-none" />
        </div>
      </div>
      
      <!-- Liste des demandes (version améliorée) -->
      <div v-if="!loading && filteredRequests.length > 0" class="space-y-4">
      <div 
        v-for="request in filteredRequests" 
        :key="request.id"
          class="bg-white border border-gray-200 rounded-xl overflow-hidden transition-all duration-200 hover:shadow-md hover:border-primary-200 transform hover:-translate-y-1"
        >
          <NuxtLink :to="`/requests/${request.id}`" class="block">
            <div class="flex flex-col md:flex-row">
              <!-- Icône de catégorie à gauche (ou en haut sur mobile) -->
              <div class="md:w-1/4 p-4">
                <div class="aspect-square bg-gray-100 overflow-hidden rounded-xl relative shadow-sm flex items-center justify-center">
                  <div class="flex flex-col items-center justify-center">
                    <!-- Icône du service -->
                    <div class="w-16 h-16 rounded-full bg-primary-100 flex items-center justify-center mb-2">
                      <component 
                        :is="getCategoryIcon(request.category_id)" 
                        class="h-8 w-8 text-primary-600" 
                      />
                    </div>
                    <span class="text-sm font-medium text-gray-700">
                      {{ getCategoryName(request.category_id) }}
                    </span>
            </div>
            
                  <!-- Badge pour les demandes urgentes -->
                  <div v-if="request.is_urgent" class="absolute top-2 left-2 bg-red-500 px-2.5 py-1 rounded-full flex items-center shadow-sm">
                    <Clock class="h-3.5 w-3.5 text-white mr-1" />
                    <span class="text-xs font-semibold text-white">Urgent</span>
                  </div>
                </div>
              </div>
              
              <!-- Infos à droite (ou en bas sur mobile) -->
              <div class="flex-1 p-4 flex flex-col">
                <div class="flex justify-between items-start">
                  <!-- Titre et infos principales -->
                  <div>
                    <div class="font-semibold text-lg text-gray-900">{{ request.title }}</div>
                    <div class="text-primary-600 font-medium mt-0.5">
                      Publié par {{ request.client_name }}
              </div>
                    
                    <!-- Localisation -->
                    <div class="text-sm text-gray-500 mt-2 flex items-center">
                      <MapPin class="h-3.5 w-3.5 mr-1.5" />
                      {{ request.location || 'Paris' }}
              </div>
            </div>
                  
                  <!-- Budget amélioré -->
                  <div class="bg-primary-50 px-3 py-1.5 rounded-full text-base font-bold text-primary-700">
                    {{ request.budget || '120' }}€
              </div>
            </div>
            
                <!-- Date limite -->
                <div class="flex items-center mt-3">
                  <Calendar class="h-4 w-4 text-gray-500 mr-2" />
                  <span class="text-sm text-gray-600">
                    <span class="font-medium">Date limite:</span>
                    <span class="ml-1">{{ formatDate(request.deadline) }}</span>
                  </span>
                </div>
                
                <!-- Description tronquée -->
                <div class="mt-3">
                  <p class="text-sm text-gray-600 line-clamp-2">
                {{ request.description }}
              </p>
                </div>
                
                <!-- Compétences requises -->
                <div class="mt-4 flex flex-wrap gap-1.5">
                  <span 
                    v-for="(skill, index) in getRequestSkills(request).slice(0, 3)" 
                    :key="index"
                    class="px-3 py-1 text-xs font-medium bg-gray-100 text-gray-700 rounded-full"
                  >
                    {{ skill }}
                  </span>
                  <span 
                    v-if="getRequestSkills(request).length > 3" 
                    class="px-3 py-1 text-xs font-medium bg-gray-100 text-gray-700 rounded-full"
                  >
                    +{{ getRequestSkills(request).length - 3 }}
                  </span>
                </div>
                
                <!-- Dernière ligne avec statut et CTA -->
                <div class="flex justify-between items-center mt-auto pt-4">
                  <div class="flex items-center text-sm font-medium" 
                    :class="{
                      'text-green-600': request.status === 'open',
                      'text-yellow-600': request.status === 'in_progress',
                      'text-gray-500': request.status === 'closed'
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
                  
                  <span class="px-4 py-1.5 bg-primary-100 text-primary-700 text-sm font-medium rounded-full hover:bg-primary-200 transition-colors">
                    Voir détails
                  </span>
                </div>
              </div>
            </div>
          </NuxtLink>
        </div>
        
        <!-- Pagination améliorée -->
        <div v-if="totalPages > 1" class="flex justify-center mt-8">
          <div class="inline-flex items-center rounded-full bg-white shadow-sm border border-gray-100 overflow-hidden">
            <button 
              @click="currentPage = Math.max(1, currentPage - 1)"
              :disabled="currentPage === 1"
              class="p-3 disabled:opacity-50 disabled:cursor-not-allowed hover:bg-gray-50 transition-colors"
            >
              <ChevronLeft class="h-5 w-5 text-gray-600" />
            </button>
            
            <div v-for="page in paginationArray" :key="page" class="border-l border-r border-gray-100">
              <button 
                v-if="page !== '...'"
                @click="currentPage = page"
                :class="[
                  'h-10 w-10 text-sm font-medium',
                  currentPage === page 
                    ? 'bg-primary-500 text-white' 
                    : 'hover:bg-gray-50 text-gray-600'
                ]"
              >
                {{ page }}
              </button>
              <span v-else class="h-10 w-10 flex items-center justify-center text-gray-400">...</span>
            </div>
            
            <button 
              @click="currentPage = Math.min(totalPages, currentPage + 1)"
              :disabled="currentPage === totalPages"
              class="p-3 disabled:opacity-50 disabled:cursor-not-allowed hover:bg-gray-50 transition-colors"
            >
              <ChevronRight class="h-5 w-5 text-gray-600" />
            </button>
          </div>
        </div>
      </div>
      
      <!-- Message si aucun résultat -->
      <div v-else-if="!loading && filteredRequests.length === 0" class="bg-white rounded-xl p-8 text-center border border-gray-200">
        <FileSearch class="h-12 w-12 text-gray-400 mx-auto mb-4" />
        <h3 class="text-lg font-medium text-gray-900 mb-2">Aucune demande trouvée</h3>
        <p class="text-gray-600 mb-6">
          Aucune demande ne correspond à vos critères de recherche. Essayez d'autres filtres ou publiez vous-même une demande.
        </p>
        <NuxtLink 
          to="/requests/new" 
          class="px-6 py-2.5 bg-primary-600 text-white text-sm font-medium rounded-full inline-flex items-center hover:bg-primary-700 transition-colors"
        >
          <Plus class="h-4 w-4 mr-2" />
          Publier une demande
        </NuxtLink>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue'
import { 
  Loader2, Plus, Search, MapPin, Calendar, Clock, DollarSign,
  Tag, Users, FileSearch, ChevronLeft, ChevronRight, ChevronDown
} from 'lucide-vue-next'

const router = useRouter()
const client = useSupabaseClient()

// États
const loading = ref(true)
const requests = ref([])
const categories = ref([])
const search = ref('')
const selectedCategories = ref([])
const currentPage = ref(1)
const sortOption = ref('recent')
const itemsPerPage = 10

// Filtrage des demandes
const filteredRequests = computed(() => {
  let filtered = [...requests.value]
  
  // Filtrer par recherche
  if (search.value) {
    const searchLower = search.value.toLowerCase()
    filtered = filtered.filter(request => 
      request.title.toLowerCase().includes(searchLower) || 
      (request.description && request.description.toLowerCase().includes(searchLower)) ||
      (request.skills && request.skills.some(s => s.toLowerCase().includes(searchLower)))
    )
  }
  
  // Filtrer par catégories sélectionnées
  if (selectedCategories.value.length > 0) {
    filtered = filtered.filter(request => 
      selectedCategories.value.includes(request.category_id)
    )
  }
  
  // Tri
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
  
  // Pagination
  const startIndex = (currentPage.value - 1) * itemsPerPage
  return filtered.slice(startIndex, startIndex + itemsPerPage)
})

// Nombre total de pages
const totalPages = computed(() => {
  let filtered = [...requests.value]
  
  if (search.value) {
    const searchLower = search.value.toLowerCase()
    filtered = filtered.filter(request => 
      request.title.toLowerCase().includes(searchLower) || 
      (request.description && request.description.toLowerCase().includes(searchLower)) ||
      (request.skills && request.skills.some(s => s.toLowerCase().includes(searchLower)))
    )
  }
  
  if (selectedCategories.value.length > 0) {
    filtered = filtered.filter(request => 
      selectedCategories.value.includes(request.category_id)
    )
  }
  
  return Math.ceil(filtered.length / itemsPerPage)
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
    loading.value = true
    
    // Récupérer les catégories
    const { data: categoriesData, error: categoriesError } = await client
      .from('service_categories')
      .select('id, name')
    
    if (categoriesError) throw categoriesError
    categories.value = categoriesData || []
    
    // Récupérer les demandes
    const { data: requestsData, error: requestsError } = await client
      .from('requests')
      .select(`
        *
      `)
    
    if (requestsError) throw requestsError
    
    // Transformer les demandes pour avoir le nombre de propositions
    requests.value = requestsData.map(request => ({
      ...request,
      proposals_count: request.proposals[0]?.count || 0
    }))
  } catch (error) {
    console.error('Erreur lors du chargement des données:', error)
  } finally {
    loading.value = false
  }
}

// Charger les données lors du montage du composant
onMounted(fetchData)

definePageMeta({
  layout: 'default'
})
</script>

<style scoped>
/* Masquer la barre de défilement tout en permettant le défilement */
.no-scrollbar::-webkit-scrollbar {
  display: none;
}
.no-scrollbar {
  -ms-overflow-style: none;
  scrollbar-width: none;
}

/* Animation des éléments */
.transform {
  will-change: transform;
}

/* Line clamp pour limiter le nombre de lignes */
.line-clamp-2 {
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
</style> 