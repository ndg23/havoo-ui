<template>
  <div class="min-h-screen bg-gray-50">
    <!-- En-tête amélioré -->
    <div class="bg-white border-b border-gray-100 sticky top-0 z-10 shadow-sm">
      <div class="max-w-5xl mx-auto px-5 py-4">
        <div class="flex flex-col space-y-4">
          <!-- Titre et bouton de demande -->
          <div class="flex items-center justify-between">
            <h1 class="text-2xl font-bold text-gray-800">Experts disponibles</h1>
            <NuxtLink 
              to="/requests/new" 
              class="px-6 py-2.5 bg-gradient-to-r from-primary-500 to-primary-600 text-white text-sm font-medium rounded-full shadow-sm hover:shadow-md transition-all duration-200 transform hover:-translate-y-0.5"
            >
              Publier une demande
            </NuxtLink>
          </div>
          
          <!-- Barre de recherche améliorée -->
          <div class="relative">
            <Search class="absolute left-4 top-1/2 transform -translate-y-1/2 text-primary-400 h-5 w-5" />
            <input 
              v-model="search"
              type="text"
              placeholder="Que recherchez-vous ? (ex: plombier, ménage...)"
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
          <span class="text-gray-500">Recherche des experts...</span>
        </div>
      </div>
      
      <!-- Nombre de résultats -->
      <div v-else-if="filteredExperts.length > 0" class="mb-4 flex justify-between items-center">
        <p class="text-sm text-gray-500 font-medium">
          {{ filteredExperts.length }} résultat{{ filteredExperts.length > 1 ? 's' : '' }}
        </p>
        
        <!-- Tri -->
        <div class="relative">
          <select 
            v-model="sortOption"
            class="appearance-none bg-white border border-gray-200 rounded-full px-4 py-2 pr-8 text-sm focus:outline-none focus:ring-2 focus:ring-primary-200 focus:border-primary-300 transition-all cursor-pointer"
          >
            <option value="rating">Mieux notés</option>
            <option value="price_low">Prix croissant</option>
            <option value="price_high">Prix décroissant</option>
            <option value="recent">Plus récents</option>
          </select>
          <ChevronDown class="absolute right-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-gray-400 pointer-events-none" />
        </div>
      </div>
      
      <!-- Liste des experts (version améliorée) -->
      <div v-if="!loading && filteredExperts.length > 0" class="space-y-4">
        <div 
          v-for="expert in filteredExperts" 
          :key="expert.id"
          class="bg-white border border-gray-200 rounded-xl overflow-hidden transition-all duration-200 hover:shadow-md hover:border-primary-200 transform hover:-translate-y-1"
        >
          <NuxtLink :to="`/experts/${expert.id}`" class="block">
            <div class="flex flex-col md:flex-row">
              <!-- Image à gauche (ou en haut sur mobile) -->
              <div class="md:w-1/4 p-4">
                <div class="aspect-square bg-gray-100 overflow-hidden rounded-xl relative shadow-sm">
                  <img 
                    v-if="expert.profile_image_url" 
                    :src="expert.profile_image_url" 
                    alt="Photo de profil" 
                    class="w-full h-full object-cover"
                  />
                  <div v-else class="w-full h-full flex items-center justify-center bg-gradient-to-br from-gray-100 to-gray-200">
                    <User class="h-12 w-12 text-gray-400" />
                  </div>
                  
                  <!-- Badge vérifié amélioré -->
                  <div v-if="expert.is_verified" class="absolute top-2 left-2 bg-white px-2.5 py-1 rounded-full flex items-center shadow-sm">
                    <CheckCircle class="h-3.5 w-3.5 text-green-500 mr-1" />
                    <span class="text-xs font-semibold text-gray-700">Vérifié</span>
                  </div>
                </div>
              </div>
              
              <!-- Infos à droite (ou en bas sur mobile) -->
              <div class="flex-1 p-4 flex flex-col">
                <div class="flex justify-between items-start">
                  <!-- Titre et infos principales -->
                  <div>
                    <div class="font-semibold text-lg text-gray-900">{{ expert.first_name }} {{ expert.last_name }}</div>
                    <div class="text-primary-600 font-medium mt-0.5">
                      {{ expert.title || getExpertiseAreas(expert)[0] || "Expert service" }}
                    </div>
                    
                    <!-- Localisation -->
                    <div class="text-sm text-gray-500 mt-2 flex items-center">
                      <MapPin class="h-3.5 w-3.5 mr-1.5" />
                      {{ expert.city || 'Paris' }}
                    </div>
                  </div>
                  
                  <!-- Prix amélioré -->
                  <div class="bg-primary-50 px-3 py-1.5 rounded-full text-base font-bold text-primary-700">
                    {{ expert.hourly_rate || '25' }}€<span class="text-sm font-normal">/h</span>
                  </div>
                </div>
                
                <!-- Note améliorée -->
                <div class="flex items-center mt-3">
                  <div class="flex">
                    <Star v-for="i in 5" :key="i" 
                      :class="[
                        'h-4 w-4 mr-0.5', 
                        i <= Math.round(expert.rating || 4.8) 
                          ? 'text-yellow-400 fill-yellow-400' 
                          : 'text-gray-300'
                      ]" 
                    />
                  </div>
                  <span class="ml-2 text-sm text-gray-600">
                    <span class="font-medium">{{ expert.rating || '4.8' }}</span>
                    <span class="text-gray-400">/5</span>
                    <span class="ml-1 text-gray-500">({{ expert.reviews_count || '12' }})</span>
                  </span>
                </div>
                
                <!-- Spécialités améliorées -->
                <div class="mt-4 flex flex-wrap gap-1.5">
                  <span 
                    v-for="(specialty, index) in getExpertiseAreas(expert).slice(0, 3)" 
                    :key="index"
                    class="px-3 py-1 text-xs font-medium bg-gray-100 text-gray-700 rounded-full"
                  >
                    {{ specialty }}
                  </span>
                  <span 
                    v-if="getExpertiseAreas(expert).length > 3" 
                    class="px-3 py-1 text-xs font-medium bg-gray-100 text-gray-700 rounded-full"
                  >
                    +{{ getExpertiseAreas(expert).length - 3 }}
                  </span>
                </div>
                
                <!-- Dernière ligne avec disponibilité et CTA -->
                <div class="flex justify-between items-center mt-auto pt-4">
                  <div class="flex items-center text-sm text-green-600 font-medium">
                    <div class="h-2 w-2 rounded-full bg-green-500 mr-2"></div>
                    Disponible maintenant
                  </div>
                  
                  <span class="px-4 py-1.5 bg-primary-100 text-primary-700 text-sm font-medium rounded-full hover:bg-primary-200 transition-colors">
                    Voir profil
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
      
      <!-- État vide amélioré -->
      <div v-else-if="!loading && filteredExperts.length === 0" class="bg-white border border-gray-200 rounded-xl p-10 text-center shadow-sm">
        <div class="bg-gray-50 h-20 w-20 rounded-full flex items-center justify-center mx-auto mb-6">
          <FileSearch class="h-10 w-10 text-gray-400" />
        </div>
        <h3 class="text-xl font-semibold text-gray-900 mb-3">
          {{ search || selectedCategories.length > 0 ? 'Aucun expert trouvé' : 'Aucun expert disponible' }}
        </h3>
        <p class="text-gray-500 max-w-md mx-auto mb-6">
          {{ search || selectedCategories.length > 0 
            ? 'Essayez avec d\'autres critères de recherche ou moins de filtres.' 
            : 'Aucun expert n\'est disponible dans cette catégorie pour le moment.' }}
        </p>
        <button 
          v-if="search || selectedCategories.length > 0"
          @click="resetFilters" 
          class="px-6 py-2.5 bg-primary-500 text-white font-medium rounded-full hover:bg-primary-600 transition-colors shadow-sm"
        >
          Effacer les filtres
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { 
  Search, Loader2, MapPin, Star, User, ChevronLeft, 
  ChevronRight, FileSearch, CheckCircle, ChevronDown
} from 'lucide-vue-next'

const client = useSupabaseClient()

// États
const loading = ref(true)
const experts = ref([])
const categories = ref([])
const search = ref('')
const selectedCategories = ref([])
const currentPage = ref(1)
const sortOption = ref('rating')
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
  
  // Tri
  switch (sortOption.value) {
    case 'rating':
      filtered.sort((a, b) => (b.rating || 4.5) - (a.rating || 4.5))
      break
    case 'price_low':
      filtered.sort((a, b) => (a.hourly_rate || 25) - (b.hourly_rate || 25))
      break
    case 'price_high':
      filtered.sort((a, b) => (b.hourly_rate || 25) - (a.hourly_rate || 25))
      break
    case 'recent':
      filtered.sort((a, b) => new Date(b.created_at || Date.now()) - new Date(a.created_at || Date.now()))
      break
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

// Génération du tableau de pagination amélioré
const paginationArray = computed(() => {
  const totalPages = Math.ceil(experts.value.length / itemsPerPage)
  const current = currentPage.value
  
  if (totalPages <= 7) {
    return Array.from({ length: totalPages }, (_, i) => i + 1)
  }
  
  if (current <= 3) {
    return [1, 2, 3, 4, 5, '...', totalPages]
  }
  
  if (current >= totalPages - 2) {
    return [1, '...', totalPages - 4, totalPages - 3, totalPages - 2, totalPages - 1, totalPages]
  }
  
  return [1, '...', current - 1, current, current + 1, '...', totalPages]
})

// Réinitialiser les filtres
const resetFilters = () => {
  search.value = ''
  selectedCategories.value = []
  currentPage.value = 1
  sortOption.value = 'rating'
}

// Obtenir les domaines d'expertise d'un expert
const getExpertiseAreas = (expert) => {
  if (!expert.expertise_areas) return expert.specialties || ['Service général']
  
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
    
    // Récupérer les experts (utilisateurs avec le rôle expert)
    const { data: expertsData, error: expertsError } = await client
      .from('profiles')
      .select(`*`)
      .eq('role', 'expert')
    
    if (expertsError) throw expertsError
    
    // Transformer les données des experts
    experts.value = expertsData.map(expert => ({
      ...expert,
      // Générer des données fictives pour les démos
      is_verified: Math.random() > 0.5, 
      hourly_rate: Math.floor(Math.random() * 30) + 20,
      rating: (Math.random() * 1.5 + 3.5).toFixed(1),
      reviews_count: Math.floor(Math.random() * 50) + 5,
      specialties: ['Ménage', 'Jardinage', 'Bricolage', 'Peinture', 'Plomberie', 'Électricité', 'Rénovation', 'Montage de meubles'].sort(() => .5 - Math.random()).slice(0, Math.floor(Math.random() * 3) + 2)
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

/* Animation des étoiles */
.fill-yellow-400 {
  fill: #facc15;
}
</style> 
