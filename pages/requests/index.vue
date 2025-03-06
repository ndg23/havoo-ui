<template>
  <div class="min-h-screen bg-white">
    <!-- En-tête minimaliste -->
    <div class="border-b border-gray-200">
      <div class="max-w-4xl mx-auto px-5 py-4 flex items-center justify-between">
        <h1 class="text-xl font-bold text-black">Demandes de service</h1>
        <NuxtLink 
          to="/requests/new" 
          class="px-5 py-2.5 bg-black text-white text-sm font-medium rounded-full hover:bg-gray-800 transition-colors flex items-center"
        >
          <Plus class="h-4 w-4 mr-1" />
          Nouvelle demande
        </NuxtLink>
      </div>
    </div>
    
    <!-- Filtres et recherche -->
    <div class="border-b border-gray-100">
      <div class="max-w-4xl mx-auto px-5 py-3">
        <div class="flex flex-col sm:flex-row sm:items-center gap-4">
          <!-- Recherche -->
          <div class="relative flex-1">
            <Search class="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 h-4 w-4" />
              <input 
              v-model="search"
              type="text"
              placeholder="Rechercher une demande..."
              class="w-full pl-10 pr-4 py-2.5 border border-gray-200 rounded-full focus:outline-none focus:border-black transition-colors text-sm"
            />
        </div>
        
          <!-- Filtres -->
          <div class="flex overflow-x-auto no-scrollbar gap-2">
            <button 
              v-for="category in categories" 
              :key="category.id"
              @click="toggleCategoryFilter(category.id)"
              :class="[
                'px-4 py-2 text-sm font-medium rounded-full whitespace-nowrap transition-colors',
                selectedCategories.includes(category.id)
                  ? 'bg-black text-white'
                  : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
              ]"
            >
              {{ category.name }}
            </button>
          </div>
        </div>
      </div>
    </div>
    
    <!-- Contenu principal -->
    <div class="max-w-4xl mx-auto px-5 py-8">
      <!-- État de chargement -->
      <div v-if="loading" class="flex justify-center py-12">
        <Loader2 class="h-8 w-8 text-gray-400 animate-spin" />
      </div>
      
      <!-- Liste des demandes -->
      <div v-else-if="filteredRequests.length > 0" class="space-y-6">
      <div 
        v-for="request in filteredRequests" 
        :key="request.id"
          class="border border-gray-200 rounded-xl overflow-hidden hover:shadow-md transition-shadow"
        >
          <div class="p-5">
            <!-- En-tête de la demande -->
            <div class="flex justify-between items-start mb-3">
              <h3 class="font-semibold text-lg text-gray-900">{{ request.title }}</h3>
              <span class="text-sm text-gray-500">{{ formatDate(request.created_at) }}</span>
            </div>
            
            <!-- Informations de la demande -->
            <div class="flex flex-wrap gap-4 mb-3">
              <div class="flex items-center text-sm text-gray-600">
                <Tag class="h-4 w-4 mr-1.5 flex-shrink-0" />
                <span>{{ getCategoryName(request.category_id) }}</span>
              </div>
              <div class="flex items-center text-sm text-gray-600">
                <MapPin class="h-4 w-4 mr-1.5 flex-shrink-0" />
                <span>{{ request.location }}</span>
              </div>
              <div class="flex items-center text-sm text-gray-600">
                <Calendar class="h-4 w-4 mr-1.5 flex-shrink-0" />
                <span>{{ formatDate(request.date) }}</span>
              </div>
              <div class="flex items-center text-sm text-gray-600">
                <Clock class="h-4 w-4 mr-1.5 flex-shrink-0" />
                <span>{{ request.duration }} min</span>
            </div>
              <div class="flex items-center text-sm text-gray-600 font-medium">
                <DollarSign class="h-4 w-4 mr-1.5 flex-shrink-0" />
                <span>{{ request.budget }} €</span>
              </div>
            </div>
            
            <!-- Description (tronquée) -->
            <p class="text-gray-700 text-sm line-clamp-2 mb-4">
                {{ request.description }}
              </p>
            
            <!-- Actions -->
            <div class="flex justify-between items-center pt-2">
              <div class="flex items-center text-sm">
                <div v-if="request.proposals_count > 0" class="flex items-center text-sm font-medium text-green-600">
                  <Users class="h-4 w-4 mr-1.5" />
                  {{ request.proposals_count }} proposition{{ request.proposals_count > 1 ? 's' : '' }}
                </div>
                <div v-else class="text-sm text-gray-500">
                  Aucune proposition
                </div>
              </div>
              
              <NuxtLink 
                :to="`/requests/${request.id}`" 
                class="px-4 py-2 text-sm font-medium bg-black text-white rounded-full hover:bg-gray-800 transition-colors"
              >
                Voir détails
              </NuxtLink>
            </div>
          </div>
        </div>
        
        <!-- Pagination simplifiée -->
        <div v-if="totalPages > 1" class="flex justify-center mt-8">
          <div class="flex items-center gap-2">
            <button 
              @click="currentPage = Math.max(1, currentPage - 1)"
              :disabled="currentPage === 1"
              class="p-2 rounded-full border border-gray-200 disabled:opacity-50 disabled:cursor-not-allowed hover:bg-gray-100 transition-colors"
            >
              <ChevronLeft class="h-5 w-5" />
            </button>
            
            <div class="px-4 py-2 text-sm font-medium">
              Page {{ currentPage }} sur {{ totalPages }}
            </div>
            
            <button 
              @click="currentPage = Math.min(totalPages, currentPage + 1)"
              :disabled="currentPage === totalPages"
              class="p-2 rounded-full border border-gray-200 disabled:opacity-50 disabled:cursor-not-allowed hover:bg-gray-100 transition-colors"
            >
              <ChevronRight class="h-5 w-5" />
            </button>
          </div>
        </div>
      </div>
      
      <!-- État vide -->
      <div v-else class="py-16 text-center">
        <div class="rounded-full bg-gray-100 h-20 w-20 flex items-center justify-center mx-auto mb-6">
          <FileSearch class="h-10 w-10 text-gray-400" />
        </div>
        <h3 class="text-xl font-semibold text-gray-900 mb-2">Aucune demande trouvée</h3>
        <p class="text-gray-500 max-w-md mx-auto mb-8">
          {{ 
            search || selectedCategories.length > 0 
              ? 'Aucune demande ne correspond à vos critères de recherche. Essayez de modifier vos filtres.'
              : 'Aucune demande de service n\'est actuellement disponible. Soyez le premier à publier une demande !'
          }}
        </p>
        <NuxtLink 
          to="/requests/new" 
          class="inline-flex items-center px-6 py-3 bg-black text-white font-medium rounded-full hover:bg-gray-800 transition-colors"
        >
          <Plus class="h-5 w-5 mr-2" />
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
  Tag, Users, FileSearch, ChevronLeft, ChevronRight 
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
const itemsPerPage = 10

// Filtrage des demandes
const filteredRequests = computed(() => {
  let filtered = [...requests.value]
  
  // Filtrer par recherche
  if (search.value) {
    const searchLower = search.value.toLowerCase()
    filtered = filtered.filter(request => 
      request.title.toLowerCase().includes(searchLower) || 
      request.description.toLowerCase().includes(searchLower)
    )
  }
  
  // Filtrer par catégories sélectionnées
  if (selectedCategories.value.length > 0) {
    filtered = filtered.filter(request => 
      selectedCategories.value.includes(request.category_id)
    )
  }
  
  // Pagination simple
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
      request.description.toLowerCase().includes(searchLower)
    )
  }
  
  if (selectedCategories.value.length > 0) {
    filtered = filtered.filter(request => 
      selectedCategories.value.includes(request.category_id)
    )
  }
  
  return Math.ceil(filtered.length / itemsPerPage)
})

// Réinitialiser la pagination quand les filtres changent
watch([search, selectedCategories], () => {
  currentPage.value = 1
})

// Formater la date
const formatDate = (dateString) => {
  if (!dateString) return ''
  const date = new Date(dateString)
  return date.toLocaleDateString('fr-FR', {
    day: 'numeric',
    month: 'long',
    year: 'numeric'
  })
}

// Récupérer le nom d'une catégorie
const getCategoryName = (categoryId) => {
  const category = categories.value.find(c => c.id === categoryId)
  return category ? category.name : 'Catégorie inconnue'
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
        *,
        proposals:proposals(count)
      `)
      .eq('status', 'active')
      .order('created_at', { ascending: false })
    
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

/* Animation de la ligne clamp */
.line-clamp-2 {
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
</style> 