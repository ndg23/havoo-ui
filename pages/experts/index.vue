<template>
  <div class="min-h-screen bg-white">
    <!-- En-tête minimaliste -->
    <div class="border-b border-gray-200">
      <div class="max-w-4xl mx-auto px-5 py-4 flex items-center justify-between">
        <h1 class="text-xl font-bold text-black">Experts disponibles</h1>
        <NuxtLink 
          to="/" 
          class="px-5 py-2.5 bg-primary-600 text-white text-sm font-medium rounded-full hover:bg-primary-700 transition-colors flex items-center"
        >
          <Search class="h-4 w-4 mr-1" />
          Rechercher un service
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
              placeholder="Rechercher un expert par nom, compétence..."
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
                  ? 'bg-primary-600 text-white'
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
      
      <!-- Liste des experts -->
      <div v-else-if="filteredExperts.length > 0" class="space-y-6">
        <div 
        v-for="expert in filteredExperts" 
        :key="expert.id"
          class="border border-gray-200 rounded-xl overflow-hidden hover:shadow-md transition-shadow"
        >
          <div class="p-5">
            <!-- En-tête avec photo de profil -->
            <div class="flex items-start gap-4 mb-4">
              <div class="h-16 w-16 rounded-full bg-gray-100 overflow-hidden flex-shrink-0">
                <img 
                  v-if="expert.profile_image_url" 
                  :src="expert.profile_image_url" 
                  alt="Photo de profil" 
                  class="w-full h-full object-cover"
                />
                <div v-else class="w-full h-full flex items-center justify-center bg-gray-200">
                  <User class="h-8 w-8 text-gray-400" />
                </div>
              </div>
              
              <div class="flex-1">
                <div class="flex justify-between items-start">
                  <div>
                    <h3 class="font-semibold text-lg text-gray-900">{{ expert.first_name }} {{ expert.last_name }}</h3>
                    <div class="flex items-center gap-1 mt-1">
                      <Star class="h-4 w-4 text-yellow-400 fill-yellow-400" />
                      <span class="text-sm font-medium">{{ expert.rating || '4.8' }}</span>
                      <span class="text-sm text-gray-500">({{ expert.reviews_count || '12' }} avis)</span>
                  </div>
                </div>
                
                  <div class="text-sm text-gray-500">
                    <div class="flex items-center">
                      <MapPin class="h-3.5 w-3.5 mr-1 text-gray-400" />
                      {{ expert.city || 'Paris' }}
                    </div>
                    </div>
                  </div>
                </div>
              </div>
              
            <!-- Spécialités -->
            <div class="mb-4">
              <div class="flex flex-wrap gap-2">
                <span 
                  v-for="(specialty, index) in getExpertiseAreas(expert)" 
                  :key="index"
                  class="px-2.5 py-1 text-xs bg-gray-100 text-gray-800 rounded-full"
                >
                  {{ specialty }}
                </span>
              </div>
            </div>
            
            <!-- Bio -->
            <p class="text-gray-700 text-sm line-clamp-2 mb-4">
              {{ expert.bio || 'Expert disponible pour vous aider avec vos besoins de services.' }}
            </p>
            
            <!-- Tarifs et actions -->
            <div class="flex justify-between items-center pt-2">
              <div class="text-sm font-medium text-gray-900">
                À partir de {{ expert.hourly_rate || '25' }}€/heure
          </div>
          
              <NuxtLink 
                :to="`/experts/${expert.id}`" 
                class="px-4 py-2 text-sm font-medium bg-primary-600 text-white rounded-full hover:bg-primary-700 transition-colors"
              >
                Voir profil
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
          <Users class="h-10 w-10 text-gray-400" />
        </div>
        <h3 class="text-xl font-semibold text-gray-900 mb-2">
          {{ search || selectedCategories.length > 0 ? 'Aucun expert trouvé' : 'Aucun expert disponible' }}
        </h3>
        <p class="text-gray-500 max-w-md mx-auto mb-8">
          {{ search || selectedCategories.length > 0 
            ? 'Essayez de modifier vos critères de recherche pour trouver des experts disponibles.' 
            : 'Aucun expert n\'est disponible pour le moment. Revenez plus tard.' }}
        </p>
        <button 
          v-if="search || selectedCategories.length > 0"
          @click="resetFilters" 
          class="inline-flex items-center px-6 py-3 bg-primary-600 text-white font-medium rounded-full hover:bg-primary-700 transition-colors"
        >
          <RefreshCw class="h-5 w-5 mr-2" />
          Réinitialiser les filtres
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { 
  Search, Loader2, MapPin, Star, User, Users, 
  ChevronLeft, ChevronRight, RefreshCw 
} from 'lucide-vue-next'

const client = useSupabaseClient()

// États
const loading = ref(true)
const experts = ref([])
const categories = ref([])
const search = ref('')
const selectedCategories = ref([])
const currentPage = ref(1)
const itemsPerPage = 10

// Filtrage des experts
const filteredExperts = computed(() => {
  let filtered = [...experts.value]
  
  // Filtrer par recherche
  if (search.value) {
    const searchLower = search.value.toLowerCase()
    filtered = filtered.filter(expert => 
      `${expert.first_name} ${expert.last_name}`.toLowerCase().includes(searchLower) ||
      (expert.bio && expert.bio.toLowerCase().includes(searchLower)) ||
      (expert.specialties && expert.specialties.some(s => s.toLowerCase().includes(searchLower)))
    )
  }
  
  // Filtrer par catégories sélectionnées
  if (selectedCategories.value.length > 0) {
    filtered = filtered.filter(expert => 
      expert.expertise_areas && expert.expertise_areas.some(area => 
        selectedCategories.value.includes(area.category_id)
      )
    )
  }
  
  // Pagination simple
  const startIndex = (currentPage.value - 1) * itemsPerPage
  return filtered.slice(startIndex, startIndex + itemsPerPage)
})

// Nombre total de pages
const totalPages = computed(() => {
  let filtered = [...experts.value]
  
  if (search.value) {
    const searchLower = search.value.toLowerCase()
    filtered = filtered.filter(expert => 
      `${expert.first_name} ${expert.last_name}`.toLowerCase().includes(searchLower) ||
      (expert.bio && expert.bio.toLowerCase().includes(searchLower)) ||
      (expert.specialties && expert.specialties.some(s => s.toLowerCase().includes(searchLower)))
    )
  }
  
  if (selectedCategories.value.length > 0) {
    filtered = filtered.filter(expert => 
      expert.expertise_areas && expert.expertise_areas.some(area => 
        selectedCategories.value.includes(area.category_id)
      )
    )
  }
  
  return Math.ceil(filtered.length / itemsPerPage)
})

// Réinitialiser les filtres
const resetFilters = () => {
  search.value = ''
  selectedCategories.value = []
  currentPage.value = 1
}

// Obtenir les domaines d'expertise d'un expert
const getExpertiseAreas = (expert) => {
  if (!expert.expertise_areas) return []
  
  return expert.expertise_areas.map(area => {
    const category = categories.value.find(c => c.id === area.category_id)
    return area.service_name || (category ? category.name : 'Service')
  })
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

// Réinitialiser la pagination quand les filtres changent
watch([search, selectedCategories], () => {
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
    
    // Récupérer les experts (utilisateurs avec le rôle expert)
    const { data: expertsData, error: expertsError } = await client
      .from('profiles')
      .select(`
        *
      `)
      .eq('role', 'expert')
    
    if (expertsError) throw expertsError
    
    // Transformer les données des experts
    experts.value = expertsData.map(expert => ({
      ...expert,
      // Si les services ne sont pas encore renseignés, on ajoute quelques spécialités factices
      specialties: ['Ménage', 'Jardinage', 'Bricolage']
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

/* Animation des étoiles */
.fill-yellow-400 {
  fill: #facc15;
}
</style> 