<template>
  <div class="max-w-3xl mx-auto px-4 lg:px-6 py-8">
    <!-- En-tête avec recherche et localisation -->
    <div class="bg-white dark:bg-gray-800 rounded-2xl border border-gray-200 dark:border-gray-700 shadow-sm mb-8 overflow-hidden">
      <div class="p-6 pb-3">
        <h1 class="text-2xl font-bold text-gray-900 dark:text-white mb-6">
          Experts près de chez vous
        </h1>
        
        <!-- Barre de recherche moderne -->
        <div class="flex space-x-4 mb-6">
          <div class="flex-1 relative">
            <div class="absolute inset-y-0 left-0 flex items-center pl-4 pointer-events-none">
              <Search class="h-5 w-5 text-gray-400" />
          </div>
            <input 
              v-model="search"
              type="text"
              class="w-full pl-11 pr-4 py-3 bg-gray-50 dark:bg-gray-700/50 border border-gray-200 dark:border-gray-600 rounded-xl text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500/30 focus:border-primary-500"
              placeholder="Rechercher un service, une compétence..."
            />
          </div>
          
          <!-- Sélecteur de localisation -->
          <div class="relative min-w-[180px]">
            <div class="absolute inset-y-0 left-0 flex items-center pl-4 pointer-events-none">
              <MapPin class="h-5 w-5 text-gray-400" />
            </div>
            <select
              v-model="location"
              class="w-full pl-11 pr-10 py-3 bg-gray-50 dark:bg-gray-700/50 border border-gray-200 dark:border-gray-600 rounded-xl text-gray-900 dark:text-white appearance-none focus:ring-2 focus:ring-primary-500/30 focus:border-primary-500"
            >
              <option value="paris">Paris, France</option>
              <option value="lyon">Lyon, France</option>
              <option value="marseille">Marseille, France</option>
              <option value="bordeaux">Bordeaux, France</option>
            </select>
            <div class="absolute inset-y-0 right-0 flex items-center pr-3 pointer-events-none">
              <ChevronDown class="h-5 w-5 text-gray-400" />
            </div>
          </div>
        </div>
        
        <!-- Filtres de catégories -->
        <div class="overflow-x-auto hide-scrollbar pb-4">
          <div class="flex space-x-2 min-w-max">
            <button 
              @click="categoryFilter = 'all'"
              :class="[
                'px-4 py-2 text-sm font-medium rounded-full whitespace-nowrap transition-all duration-200',
                categoryFilter === 'all' 
                  ? 'bg-primary-500 text-white shadow-sm' 
                  : 'bg-white dark:bg-gray-700 text-gray-700 dark:text-gray-300 border border-gray-200 dark:border-gray-600 hover:border-primary-300 dark:hover:border-primary-700 hover:bg-gray-50 dark:hover:bg-gray-800'
              ]"
            >
              Tous
            </button>
            <button 
              v-for="category in categories" 
              :key="category.id"
              @click="categoryFilter = category.id"
              :class="[
                'px-4 py-2 text-sm font-medium rounded-full whitespace-nowrap transition-all duration-200',
                categoryFilter === category.id 
                  ? 'bg-primary-500 text-white shadow-sm' 
                  : 'bg-white dark:bg-gray-700 text-gray-700 dark:text-gray-300 border border-gray-200 dark:border-gray-600 hover:border-primary-300 dark:hover:border-primary-700 hover:bg-gray-50 dark:hover:bg-gray-800'
              ]"
            >
              {{ category.name }}
            </button>
          </div>
        </div>
      </div>
    </div>
    
    <!-- Catégories populaires -->
    <div class="mb-8">
      <h2 class="text-xl font-semibold text-gray-900 dark:text-white mb-4">
        Catégories populaires
      </h2>
      
      <div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-5 gap-4">
        <div 
          v-for="category in popularCategories" 
          :key="category.id"
          @click="categoryFilter = category.id"
          class="bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-xl p-4 text-center transition-all duration-200 hover:shadow-md hover:border-primary-300 dark:hover:border-primary-700 cursor-pointer group"
        >
          <div class="w-16 h-16 rounded-full bg-gray-100 dark:bg-gray-700 flex items-center justify-center text-2xl mb-3 mx-auto transition-transform group-hover:scale-110">
            {{ category.icon }}
          </div>
          <div class="font-medium text-gray-900 dark:text-white">{{ category.name }}</div>
        </div>
        </div>
      </div>
      
    <!-- Liste des experts -->
    <div>
      <div class="flex justify-between items-center mb-4">
        <h2 class="text-xl font-semibold text-gray-900 dark:text-white">
          {{ filteredExperts.length }} experts disponibles
        </h2>
        
        <div class="flex items-center space-x-2">
          <label for="sort" class="text-sm text-gray-600 dark:text-gray-400">Trier par:</label>
          <select 
            v-model="sortBy"
            id="sort"
            class="text-sm bg-white dark:bg-gray-700 border border-gray-200 dark:border-gray-600 rounded-lg px-3 py-1.5"
          >
            <option value="rating">Meilleures évaluations</option>
            <option value="price_low">Prix croissant</option>
            <option value="price_high">Prix décroissant</option>
            <option value="reviews">Nombre d'avis</option>
          </select>
        </div>
      </div>
      
      <!-- Cartes expert -->
      <div class="grid grid-cols-1 lg:grid-cols-1 gap-6 mb-8">
        <div 
          v-for="expert in displayedExperts"
          :key="expert.id"
          class="bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-xl overflow-hidden shadow-sm transition-all duration-200 hover:shadow-md hover:border-primary-300 dark:hover:border-primary-700"
        >
          <div class="p-6">
            <!-- Info de l'expert -->
            <div class="flex gap-4">
              <!-- Avatar -->
              <div class="relative">
                <img 
                  :src="expert.avatar_url || '/img/default-avatar.png'" 
                  :alt="expert.first_name + ' ' + expert.last_name"
                  class="w-20 h-20 rounded-full object-cover border border-gray-200 dark:border-gray-700"
                />
                <div
                  v-if="expert.is_verified"
                  class="absolute -top-1 -right-1 bg-blue-100 dark:bg-blue-900/40 text-blue-700 dark:text-blue-400 w-6 h-6 rounded-full flex items-center justify-center shadow-sm border border-white dark:border-gray-800"
                >
                  <CheckCircle class="w-4 h-4" />
                </div>
              </div>
              
              <!-- Détails -->
              <div class="flex-1">
                <h3 class="text-lg font-semibold text-gray-900 dark:text-white">
                  {{ expert.first_name }} {{ expert.last_name }}
                </h3>
                
                <!-- Évaluations -->
                <div class="flex items-center mt-1 mb-1.5">
                  <div class="flex mr-1.5">
                    <Star v-for="i in 5" :key="i" 
                      :class="[
                        'h-4 w-4', 
                        i <= expert.average_rating 
                          ? 'text-yellow-400 fill-current' 
                          : 'text-gray-300 dark:text-gray-600'
                      ]" 
                    />
                  </div>
                  <span class="text-sm text-gray-600 dark:text-gray-400">
                    ({{ expert.review_count }} avis)
                  </span>
                </div>
                
                <!-- Localisation -->
                <div class="flex items-center text-sm text-gray-600 dark:text-gray-400 mb-1.5">
                  <MapPin class="h-3.5 w-3.5 mr-1" />
                  {{ expert.city || 'Paris' }}, {{ expert.country || 'France' }}
                </div>
                
                <!-- Prix -->
                <div class="text-primary-600 dark:text-primary-400 font-semibold">
                  À partir de {{ expert.hourly_rate }}€/h
                </div>
              </div>
            </div>
            
            <!-- Compétences -->
            <div class="flex flex-wrap gap-2 mt-4">
              <div 
                v-for="skill in expert.skills" 
                :key="skill.id"
                class="px-3 py-1 bg-gray-100 dark:bg-gray-700 text-gray-700 dark:text-gray-300 text-sm rounded-full"
              >
                {{ skill.icon }} {{ skill.name }}
              </div>
            </div>
          </div>
          
          <!-- Disponibilité et action -->
          <div class="border-t border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-700/30 px-6 py-4 flex justify-between items-center">
            <div class="flex items-center">
              <div 
                :class="[
                  'h-2.5 w-2.5 rounded-full mr-2',
                  expert.availability_status === 'available' ? 'bg-green-500' : 'bg-amber-500'
                ]"
              ></div>
              <span class="text-sm text-gray-700 dark:text-gray-300">
                {{ expert.availability_status === 'available' ? 'Disponible aujourd\'hui' : 'Disponible prochainement' }}
              </span>
            </div>
            
            <NuxtLink 
              :to="`/experts/${expert.id}`"
              class="px-4 py-2 bg-primary-600 hover:bg-primary-700 text-white text-sm font-medium rounded-full shadow-sm transition-colors duration-200"
            >
              Voir profil
            </NuxtLink>
          </div>
        </div>
      </div>
      
      <!-- Pagination ou Charger plus -->
      <div v-if="hasMoreExperts" class="flex justify-center mt-4 mb-12">
        <button 
          @click="loadMoreExperts"
          class="px-6 py-3 bg-white dark:bg-gray-700 border border-gray-200 dark:border-gray-600 text-primary-600 dark:text-primary-400 font-medium rounded-xl hover:bg-gray-50 dark:hover:bg-gray-600 transition-colors duration-200"
        >
          {{ isLoading ? 'Chargement...' : 'Voir plus d\'experts' }}
        </button>
      </div>
    </div>
    
    <!-- Bouton filtres flottant (mobile) -->
    <div 
      class="md:hidden fixed bottom-6 left-1/2 transform -translate-x-1/2 z-10"
      @click="showFilterModal = true"
    >
      <button class="flex items-center gap-2 px-5 py-3 bg-gray-900 dark:bg-gray-700 text-white rounded-full shadow-lg">
        <Filter class="h-4 w-4" />
        <span class="font-medium">Filtres</span>
      </button>
    </div>
    
    <!-- Modal de filtres (mobile) -->
    <Teleport to="body">
      <div 
        v-if="showFilterModal"
        class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/50 backdrop-blur-sm"
        @click.self="showFilterModal = false"
      >
        <div class="bg-white dark:bg-gray-800 rounded-xl shadow-xl w-full max-w-md max-h-[90vh] overflow-y-auto">
          <div class="flex justify-between items-center p-4 border-b border-gray-200 dark:border-gray-700">
            <h3 class="text-lg font-medium text-gray-900 dark:text-white">Filtres</h3>
            <button 
              @click="showFilterModal = false"
              class="text-gray-400 hover:text-gray-500 dark:hover:text-gray-300"
            >
              <X class="h-5 w-5" />
            </button>
          </div>
          
          <div class="p-4 space-y-6">
            <!-- Catégories -->
            <div>
              <h4 class="font-medium text-gray-900 dark:text-white mb-3">Catégories</h4>
              <div class="space-y-2">
                <div class="flex items-center">
                  <input 
                    id="filter-all"
                    type="radio" 
                    v-model="categoryFilter" 
                    value="all"
                    class="h-4 w-4 text-primary-600 focus:ring-primary-500"
                  />
                  <label for="filter-all" class="ml-2 text-gray-700 dark:text-gray-300">
                    Toutes les catégories
                  </label>
                </div>
                <div 
                  v-for="category in categories"
                  :key="'filter-'+category.id"
                  class="flex items-center"
                >
                  <input 
                    :id="'filter-'+category.id"
                    type="radio" 
                    v-model="categoryFilter" 
                    :value="category.id"
                    class="h-4 w-4 text-primary-600 focus:ring-primary-500"
                  />
                  <label :for="'filter-'+category.id" class="ml-2 text-gray-700 dark:text-gray-300">
                    {{ category.name }}
                  </label>
                </div>
              </div>
            </div>
            
            <!-- Prix -->
            <div>
              <h4 class="font-medium text-gray-900 dark:text-white mb-3">Prix horaire</h4>
              <div class="flex items-center space-x-4">
                <input 
                  v-model="priceRange.min"
                  type="number" 
                  placeholder="Min"
                  class="w-full px-3 py-2 bg-gray-50 dark:bg-gray-700 border border-gray-200 dark:border-gray-600 rounded-lg"
                />
                <span class="text-gray-500">-</span>
                <input 
                  v-model="priceRange.max"
                  type="number" 
                  placeholder="Max"
                  class="w-full px-3 py-2 bg-gray-50 dark:bg-gray-700 border border-gray-200 dark:border-gray-600 rounded-lg"
                />
                <span class="text-gray-700 dark:text-gray-300">€</span>
              </div>
            </div>
            
            <!-- Disponibilité -->
            <div>
              <h4 class="font-medium text-gray-900 dark:text-white mb-3">Disponibilité</h4>
              <div class="space-y-2">
                <div class="flex items-center">
                  <input 
                    id="avail-all"
                    type="radio" 
                    v-model="availabilityFilter" 
                    value="all"
                    class="h-4 w-4 text-primary-600 focus:ring-primary-500"
                  />
                  <label for="avail-all" class="ml-2 text-gray-700 dark:text-gray-300">
                    Tous
                  </label>
                </div>
                <div class="flex items-center">
                  <input 
                    id="avail-today"
                    type="radio" 
                    v-model="availabilityFilter" 
                    value="available"
                    class="h-4 w-4 text-primary-600 focus:ring-primary-500"
                  />
                  <label for="avail-today" class="ml-2 text-gray-700 dark:text-gray-300">
                    Disponible aujourd'hui
                  </label>
                </div>
              </div>
            </div>
          </div>
          
          <div class="p-4 border-t border-gray-200 dark:border-gray-700 flex gap-4">
            <button 
              @click="resetFilters"
              class="flex-1 px-4 py-2 bg-white dark:bg-gray-700 text-gray-700 dark:text-gray-300 border border-gray-200 dark:border-gray-600 rounded-lg"
            >
              Réinitialiser
            </button>
            <button 
              @click="applyFilters"
              class="flex-1 px-4 py-2 bg-primary-600 hover:bg-primary-700 text-white rounded-lg"
            >
              Appliquer
            </button>
          </div>
        </div>
      </div>
    </Teleport>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { 
  Search, MapPin, Star, CheckCircle, ChevronDown, 
  Filter, X, Clock
} from 'lucide-vue-next'

// Layout
definePageMeta({
  layout: 'default'
})

// État
const supabase = useSupabaseClient()
const isLoading = ref(false)
const showFilterModal = ref(false)
const experts = ref([])
const search = ref('')
const location = ref('paris')
const categoryFilter = ref('all')
const sortBy = ref('rating')
const currentPage = ref(1)
const perPage = ref(6)
const availabilityFilter = ref('all')
const priceRange = ref({
  min: null,
  max: null
})

// Catégories
const categories = ref([
  { id: 1, name: 'Jardinage', icon: '🌿' },
  { id: 2, name: 'Bricolage', icon: '🔨' },
  { id: 3, name: 'Plomberie', icon: '🚿' },
  { id: 4, name: 'Électricité', icon: '💡' },
  { id: 5, name: 'Ménage', icon: '🧹' },
  { id: 6, name: 'Peinture', icon: '🎨' },
])

// Catégories populaires (peut être différent des catégories standards)
const popularCategories = computed(() => {
  return categories.value.slice(0, 5)
})

// Filtrer les experts
const filteredExperts = computed(() => {
  let filtered = [...experts.value]
  
  // Filtre par recherche
  if (search.value) {
    const searchLower = search.value.toLowerCase()
    filtered = filtered.filter(expert => 
      expert.first_name.toLowerCase().includes(searchLower) || 
      expert.last_name.toLowerCase().includes(searchLower) ||
      expert.skills.some(skill => skill.name.toLowerCase().includes(searchLower))
    )
  }
  
  // Filtre par catégorie
  if (categoryFilter.value !== 'all') {
    filtered = filtered.filter(expert => 
      expert.services.some(service => service.category_id === categoryFilter.value)
    )
  }
  
  // Filtre par disponibilité
  if (availabilityFilter.value !== 'all') {
    filtered = filtered.filter(expert => expert.availability_status === availabilityFilter.value)
  }
  
  // Filtre par prix
  if (priceRange.value.min) {
    filtered = filtered.filter(expert => expert.hourly_rate >= priceRange.value.min)
  }
  if (priceRange.value.max) {
    filtered = filtered.filter(expert => expert.hourly_rate <= priceRange.value.max)
  }
  
  // Tri
  switch (sortBy.value) {
    case 'rating':
      filtered.sort((a, b) => b.average_rating - a.average_rating)
      break
    case 'price_low':
      filtered.sort((a, b) => a.hourly_rate - b.hourly_rate)
      break
    case 'price_high':
      filtered.sort((a, b) => b.hourly_rate - a.hourly_rate)
      break
    case 'reviews':
      filtered.sort((a, b) => b.review_count - a.review_count)
      break
  }
  
  return filtered
})

// Experts affichés (pagination)
const displayedExperts = computed(() => {
  return filteredExperts.value.slice(0, currentPage.value * perPage.value)
})

// Vérifier s'il y a plus d'experts à charger
const hasMoreExperts = computed(() => {
  return displayedExperts.value.length < filteredExperts.value.length
})

// Charger plus d'experts
const loadMoreExperts = () => {
  currentPage.value++
}

// Réinitialiser les filtres
const resetFilters = () => {
  categoryFilter.value = 'all'
  availabilityFilter.value = 'all'
  priceRange.value = {
    min: null,
    max: null
  }
}

// Appliquer les filtres
const applyFilters = () => {
  showFilterModal.value = false
  // Les filtres sont déjà appliqués via les computed properties
}

// Récupérer les experts
const fetchExperts = async () => {
  try {
    isLoading.value = true
    
    // En réalité, cette requête serait plus complexe
    // pour joindre les tables profiles, experts, profile_skills, etc.
    const { data, error } = await supabase
      .from('profiles')
      .select('*')
    
    if (error) throw error
    
    // Transformer les données pour simuler les jointures complètes
    // Dans une application réelle, ce traitement serait fait côté serveur
    experts.value = data.map(expert => ({
      ...expert,
      average_rating: Math.floor(Math.random() * 5) + 3, // Simulé
      review_count: Math.floor(Math.random() * 50) + 5, // Simulé
      hourly_rate: Math.floor(Math.random() * 30) + 25, // Simulé
      availability_status: Math.random() > 0.3 ? 'available' : 'busy', // Simulé
      skills: [
        { id: 1, name: 'Jardinage', icon: '🌿' },
        { id: 2, name: 'Bricolage', icon: '🔨' }
      ].slice(0, Math.floor(Math.random() * 2) + 1), // Simulé
      services: [
        { category_id: Math.floor(Math.random() * 6) + 1 }
      ] // Simulé
    }))
    
  } catch (error) {
    console.error('Erreur lors de la récupération des experts:', error)
  } finally {
    isLoading.value = false
  }
}

// Initialisation
onMounted(() => {
  fetchExperts()
})
</script>

<style scoped>
.hide-scrollbar::-webkit-scrollbar {
  display: none;
}

.hide-scrollbar {
  -ms-overflow-style: none;
  scrollbar-width: none;
}
</style> 
