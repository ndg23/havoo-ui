<template>
  <div class="max-w-6xl mx-auto px-4 pt-5 pb-16">
    <!-- En-tête de la page -->
    <div class="mb-6 bg-white dark:bg-gray-800 rounded-xl p-5 border-l-4 border-primary-500 shadow-sm">
      <h1 class="text-2xl font-bold text-gray-900 dark:text-white flex items-center">
        <PackageIcon class="h-6 w-6 mr-3 text-primary-600 dark:text-primary-400" />
        Services disponibles
      </h1>
      <p class="text-gray-600 dark:text-gray-400 mt-1">
        Découvrez les services proposés par nos experts qualifiés
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
            type="text" 
            placeholder="Quel service recherchez-vous ?"
            v-model="searchQuery"
            class="pl-12 pr-4 py-3.5 w-full text-base rounded-lg border-2 border-primary-200 dark:border-primary-900/50 bg-white dark:bg-gray-800 text-gray-800 dark:text-gray-200 focus:ring-3 focus:ring-primary-500/30 focus:border-primary-500 transition-shadow shadow-sm hover:shadow-md"
          />
        </div>
        <button 
          @click="fetchServices"
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
            @click="activeCategory = 'all'"
            class="px-4 py-2 rounded-full text-sm font-medium transition-all shrink-0"
            :class="activeCategory === 'all' ? 'bg-primary-600 text-white shadow-md' : 'bg-gray-100 text-gray-800 dark:bg-gray-700 dark:text-gray-400 hover:bg-gray-200'"
          >
            Toutes les catégories
          </button>
          <button 
            v-for="category in categories" 
            :key="category"
            @click="activeCategory = category"
            class="px-4 py-2 rounded-full text-sm font-medium transition-all shrink-0"
            :class="activeCategory === category ? 'bg-primary-600 text-white shadow-md' : 'bg-gray-100 text-gray-800 dark:bg-gray-700 dark:text-gray-400 hover:bg-gray-200'"
          >
            {{ category }}
          </button>
        </div>

        <div class="flex items-center gap-3">
          <!-- Filtre de prix -->
          <div class="relative z-10">
            <button 
              @click="isOpenPrice = !isOpenPrice"
              class="px-4 py-2 rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-700 dark:text-gray-300 font-medium flex items-center"
            >
              <DollarSignIcon class="h-4 w-4 mr-2" />
              Prix
              <ChevronDownIcon class="h-4 w-4 ml-2" :class="{ 'transform rotate-180': isOpenPrice }" />
            </button>

            <!-- Options de prix -->
            <div v-if="isOpenPrice" class="absolute right-0 mt-1 bg-white dark:bg-gray-800 rounded-lg shadow-lg border border-gray-200 dark:border-gray-700 py-1 w-48">
              <button 
                @click="() => { priceRange = 'all'; isOpenPrice = false; }"
                class="w-full px-4 py-2 text-left text-sm hover:bg-gray-100 dark:hover:bg-gray-700"
                :class="priceRange === 'all' ? 'text-primary-600 dark:text-primary-400 font-medium' : 'text-gray-700 dark:text-gray-300'"
              >
                Tous les prix
              </button>
              <button 
                @click="() => { priceRange = 'low'; isOpenPrice = false; }"
                class="w-full px-4 py-2 text-left text-sm hover:bg-gray-100 dark:hover:bg-gray-700"
                :class="priceRange === 'low' ? 'text-primary-600 dark:text-primary-400 font-medium' : 'text-gray-700 dark:text-gray-300'"
              >
                < 50€
              </button>
              <button 
                @click="() => { priceRange = 'medium'; isOpenPrice = false; }"
                class="w-full px-4 py-2 text-left text-sm hover:bg-gray-100 dark:hover:bg-gray-700"
                :class="priceRange === 'medium' ? 'text-primary-600 dark:text-primary-400 font-medium' : 'text-gray-700 dark:text-gray-300'"
              >
                50€ - 100€
              </button>
              <button 
                @click="() => { priceRange = 'high'; isOpenPrice = false; }"
                class="w-full px-4 py-2 text-left text-sm hover:bg-gray-100 dark:hover:bg-gray-700"
                :class="priceRange === 'high' ? 'text-primary-600 dark:text-primary-400 font-medium' : 'text-gray-700 dark:text-gray-300'"
              >
                > 100€
              </button>
            </div>
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
                @click="() => { sortBy = 'recent'; isOpenSort = false; }"
                class="w-full px-4 py-2 text-left text-sm hover:bg-gray-100 dark:hover:bg-gray-700"
                :class="sortBy === 'recent' ? 'text-primary-600 dark:text-primary-400 font-medium' : 'text-gray-700 dark:text-gray-300'"
              >
                Plus récents
              </button>
              <button 
                @click="() => { sortBy = 'popular'; isOpenSort = false; }"
                class="w-full px-4 py-2 text-left text-sm hover:bg-gray-100 dark:hover:bg-gray-700"
                :class="sortBy === 'popular' ? 'text-primary-600 dark:text-primary-400 font-medium' : 'text-gray-700 dark:text-gray-300'"
              >
                Plus populaires
              </button>
              <button 
                @click="() => { sortBy = 'price_low'; isOpenSort = false; }"
                class="w-full px-4 py-2 text-left text-sm hover:bg-gray-100 dark:hover:bg-gray-700"
                :class="sortBy === 'price_low' ? 'text-primary-600 dark:text-primary-400 font-medium' : 'text-gray-700 dark:text-gray-300'"
              >
                Prix croissant
              </button>
              <button 
                @click="() => { sortBy = 'price_high'; isOpenSort = false; }"
                class="w-full px-4 py-2 text-left text-sm hover:bg-gray-100 dark:hover:bg-gray-700"
                :class="sortBy === 'price_high' ? 'text-primary-600 dark:text-primary-400 font-medium' : 'text-gray-700 dark:text-gray-300'"
              >
                Prix décroissant
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Chargement -->
    <div v-if="isLoading" class="bg-white dark:bg-gray-800 rounded-xl p-12 flex flex-col items-center">
      <div class="h-12 w-12 border-4 border-primary-500 border-t-transparent rounded-full animate-spin"></div>
      <p class="mt-4 text-gray-600 dark:text-gray-400 text-lg">Recherche des services disponibles...</p>
    </div>

    <!-- Aucun service trouvé -->
    <div v-else-if="filteredServices.length === 0" class="bg-white dark:bg-gray-800 rounded-xl p-10 text-center border border-gray-200 dark:border-gray-700">
      <div class="mb-6 flex justify-center">
        <div class="bg-gray-100 dark:bg-gray-700 p-5 rounded-full">
          <SearchIcon class="h-10 w-10 text-gray-500 dark:text-gray-400" />
        </div>
      </div>
      <h3 class="text-xl font-medium text-gray-900 dark:text-white mb-3">Aucun service trouvé</h3>
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

    <!-- Liste des services - Format horizontal -->
    <div v-else class="space-y-5">
      <div v-for="service in filteredServices" :key="service.id" 
        class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 overflow-hidden hover:shadow-md transition-all duration-300 hover:scale-[1.01] hover:border-primary-300 dark:hover:border-primary-700">
        
        <!-- Format horizontal -->
        <div class="flex flex-col md:flex-row">
          <!-- Partie gauche avec image et prix -->
          <div class="md:w-1/3 relative">
            <img 
              :src="service.image_url || '/img/default-service.jpg'" 
              :alt="service.title"
              class="w-full h-full object-cover md:h-64 md:max-h-full" 
            />
            <div class="absolute top-3 left-3">
              <span class="px-3 py-1 rounded-full text-xs font-semibold bg-primary-600 text-white shadow-sm">
                {{ service.category }}
              </span>
            </div>
            <div class="absolute bottom-3 left-3 right-3 bg-white dark:bg-gray-800/90 rounded-lg p-2 shadow-md backdrop-blur-sm">
              <div class="text-base text-center">
                <span class="font-bold text-primary-700 dark:text-primary-400 text-lg">{{ service.price }}€</span>
                <span v-if="service.price_type === 'hourly'" class="text-gray-600 dark:text-gray-400 text-sm">/heure</span>
              </div>
            </div>
          </div>
          
          <!-- Partie droite avec détails du service -->
          <div class="md:w-2/3 p-5 flex flex-col">
            <!-- Titre et infos expert -->
            <div class="mb-3">
              <h3 class="text-xl font-bold text-gray-900 dark:text-white mb-1">
                {{ service.title }}
              </h3>
              <div class="flex items-center gap-3">
                <div class="flex items-center">
                  <img 
                    :src="service.expert.avatar_url || '/img/default-avatar.png'" 
                    :alt="service.expert.name"
                    class="h-6 w-6 rounded-full object-cover mr-1.5" 
                  />
                  <span class="text-sm text-gray-600 dark:text-gray-400">
                    par <span class="text-primary-600 dark:text-primary-400 font-medium">{{ service.expert.name }}</span>
                  </span>
                </div>
                <div class="flex items-center text-sm text-gray-600 dark:text-gray-400">
                  <StarIcon class="h-4 w-4 text-amber-400 mr-1" fill="currentColor" />
                  <span>{{ service.rating }}</span>
                  <span class="mx-1 text-gray-400">•</span>
                  <span>{{ service.reviews_count }} avis</span>
                </div>
              </div>
            </div>
            
            <!-- Description -->
            <p class="text-gray-700 dark:text-gray-300 mb-4 line-clamp-3">
              {{ service.description }}
            </p>
            
            <!-- Détails du service -->
            <div class="mb-4 grid grid-cols-2 gap-3">
              <div class="flex items-center text-sm text-gray-600 dark:text-gray-400">
                <ClockIcon class="h-4 w-4 mr-1.5 text-gray-500 dark:text-gray-400" />
                <span>{{ service.delivery_time }} jours</span>
              </div>
              <div class="flex items-center text-sm text-gray-600 dark:text-gray-400">
                <ActivityIcon class="h-4 w-4 mr-1.5 text-gray-500 dark:text-gray-400" />
                <span>{{ service.orders_in_queue }} en cours</span>
              </div>
              <div class="flex items-center text-sm text-gray-600 dark:text-gray-400">
                <CheckCircleIcon class="h-4 w-4 mr-1.5 text-gray-500 dark:text-gray-400" />
                <span>{{ service.revisions }} révisions</span>
              </div>
              <div class="flex items-center text-sm text-gray-600 dark:text-gray-400" v-if="service.is_remote">
                <GlobeIcon class="h-4 w-4 mr-1.5 text-gray-500 dark:text-gray-400" />
                <span>À distance</span>
              </div>
              <div class="flex items-center text-sm text-gray-600 dark:text-gray-400" v-else>
                <MapPinIcon class="h-4 w-4 mr-1.5 text-gray-500 dark:text-gray-400" />
                <span>{{ service.location }}</span>
              </div>
            </div>
            
            <!-- Actions -->
            <div class="mt-auto flex gap-3 justify-end">
              <NuxtLink 
                :to="`/services/${service.id}`"
                class="px-4 py-2 text-gray-700 dark:text-gray-300 border border-gray-300 dark:border-gray-600 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-700 font-medium"
              >
                Détails
              </NuxtLink>
              <NuxtLink 
                :to="`/services/${service.id}/order`"
                class="px-4 py-2 bg-primary-600 hover:bg-primary-700 text-white rounded-lg font-medium inline-flex items-center"
              >
                <ShoppingBagIcon class="h-4 w-4 mr-2" />
                Commander
              </NuxtLink>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Pagination -->
    <div v-if="filteredServices.length > 0" class="mt-8 flex justify-center">
      <div class="inline-flex rounded-md shadow-sm" role="group">
        <button 
          @click="page > 1 ? page-- : null"
          :disabled="page === 1"
          class="px-4 py-2 text-sm font-medium rounded-l-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800"
          :class="page === 1 ? 'text-gray-400 dark:text-gray-600' : 'text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700'"
        >
          <ChevronLeftIcon class="h-5 w-5" />
        </button>
        <div class="px-4 py-2 text-sm font-medium border-t border-b border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-800 dark:text-gray-200">
          Page {{ page }} sur {{ totalPages }}
        </div>
        <button 
          @click="page < totalPages ? page++ : null"
          :disabled="page === totalPages"
          class="px-4 py-2 text-sm font-medium rounded-r-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800"
          :class="page === totalPages ? 'text-gray-400 dark:text-gray-600' : 'text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700'"
        >
          <ChevronRightIcon class="h-5 w-5" />
        </button>
      </div>
    </div>

    <!-- Créer une demande -->
    <div class="fixed bottom-6 right-6">
      <NuxtLink to="/requests/new" class="bg-primary-600 hover:bg-primary-700 text-white rounded-full p-4 shadow-lg flex items-center justify-center hover:scale-110 transition-transform duration-300">
        <PlusIcon class="h-6 w-6" />
      </NuxtLink>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { 
  PackageIcon, Search, ArrowDownUpIcon, ChevronDownIcon, DollarSignIcon,
  StarIcon, ClockIcon, ActivityIcon, CheckCircleIcon, GlobeIcon, MapPinIcon,
  RefreshCwIcon, ChevronLeftIcon, ChevronRightIcon, ShoppingBagIcon, PlusIcon
} from 'lucide-vue-next'

const supabase = useSupabaseClient()
const isLoading = ref(true)
const services = ref([])
const activeCategory = ref('all')
const searchQuery = ref('')
const sortBy = ref('recent') // 'recent', 'popular', 'price_low', 'price_high'
const priceRange = ref('all') // 'all', 'low', 'medium', 'high'
const isOpenSort = ref(false)
const isOpenPrice = ref(false)
const page = ref(1)
const perPage = 10
const totalServices = ref(0)

// Catégories disponibles
const categories = [
  'Développement web',
  'Design graphique',
  'Marketing digital',
  'Traduction',
  'Rédaction',
  'Finance',
  'Juridique'
]

// Computed pour les services filtrés
const filteredServices = computed(() => {
  let result = [...services.value]
  
  // Filtre par catégorie
  if (activeCategory.value !== 'all') {
    result = result.filter(service => service.category === activeCategory.value)
  }
  
  // Filtre par recherche
  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase()
    result = result.filter(service => 
      service.title.toLowerCase().includes(query) || 
      service.description.toLowerCase().includes(query) ||
      service.expert.name.toLowerCase().includes(query)
    )
  }
  
  // Filtre par prix
  if (priceRange.value !== 'all') {
    if (priceRange.value === 'low') {
      result = result.filter(service => service.price < 50)
    } else if (priceRange.value === 'medium') {
      result = result.filter(service => service.price >= 50 && service.price <= 100)
    } else if (priceRange.value === 'high') {
      result = result.filter(service => service.price > 100)
    }
  }
  
  // Tri
  if (sortBy.value === 'recent') {
    result.sort((a, b) => new Date(b.created_at) - new Date(a.created_at))
  } else if (sortBy.value === 'popular') {
    result.sort((a, b) => b.views - a.views)
  } else if (sortBy.value === 'price_low') {
    result.sort((a, b) => a.price - b.price)
  } else if (sortBy.value === 'price_high') {
    result.sort((a, b) => b.price - a.price)
  }
  
  // Mise à jour du total pour la pagination
  totalServices.value = result.length
  
  // Appliquer la pagination
  const start = (page.value - 1) * perPage
  const end = start + perPage
  return result.slice(start, end)
})

// Total des pages pour la pagination
const totalPages = computed(() => Math.ceil(totalServices.value / perPage))

// Libellé pour le tri sélectionné
const getSortLabel = () => {
  switch (sortBy.value) {
    case 'recent': return 'Plus récents'
    case 'popular': return 'Plus populaires'
    case 'price_low': return 'Prix croissant'
    case 'price_high': return 'Prix décroissant'
    default: return 'Trier par'
  }
}

// Récupérer les services
const fetchServices = async () => {
  isLoading.value = true
  
  try {
    // Dans un cas réel, cette fonction ferait une requête à l'API
    // Pour la démo, on utilise des données fictives
    services.value = mockServices
    
    // Simulation de délai réseau
    await new Promise(resolve => setTimeout(resolve, 800))
  } catch (error) {
    console.error('Erreur lors de la récupération des services:', error)
  } finally {
    isLoading.value = false
  }
}

// Réinitialiser les filtres
const resetFilters = () => {
  activeCategory.value = 'all'
  searchQuery.value = ''
  sortBy.value = 'recent'
  priceRange.value = 'all'
  page.value = 1
  fetchServices()
}

// Fermer les dropdowns quand on clique en dehors
const handleClickOutside = (event) => {
  if (isOpenSort.value && !event.target.closest('.sort-dropdown')) {
    isOpenSort.value = false
  }
  if (isOpenPrice.value && !event.target.closest('.price-dropdown')) {
    isOpenPrice.value = false
  }
}

// Mise en place des événements
onMounted(() => {
  fetchServices()
  document.addEventListener('click', handleClickOutside)
})

// Nettoyage
onUnmounted(() => {
  document.removeEventListener('click', handleClickOutside)
})

// Surveiller les changements des filtres pour revenir à la première page
watch([activeCategory, priceRange, sortBy, searchQuery], () => {
  page.value = 1
})

// Données fictives pour la démonstration
const mockServices = [
  {
    id: 1,
    title: "Développement site web responsive",
    description: "Je crée des sites web modernes, responsive et optimisés pour les moteurs de recherche. Développement sur mesure adapté à votre activité avec des technologies actuelles.",
    price: 450,
    price_type: "fixed",
    category: "Développement web",
    image_url: "https://images.unsplash.com/photo-1498050108023-c5249f4df085?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=600&q=80",
    rating: 4.9,
    reviews_count: 87,
    created_at: "2023-08-12T09:30:00Z",
    delivery_time: 14,
    revisions: 3,
    orders_in_queue: 2,
    is_remote: true,
    views: 1250,
    location: null,
    expert: {
      name: "Thomas Dubois",
      avatar_url: "https://randomuser.me/api/portraits/men/32.jpg"
    }
  },
  {
    id: 2,
    title: "Design logo professionnel",
    description: "Création de logo unique et moderne pour votre entreprise. Je vous propose 3 concepts initiaux et jusqu'à 5 révisions pour un résultat parfait. Tous les formats de fichiers inclus.",
    price: 120,
    price_type: "fixed",
    category: "Design graphique",
    image_url: "https://images.unsplash.com/photo-1626785774573-4b799315345d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=600&q=80",
    rating: 4.8,
    reviews_count: 124,
    created_at: "2023-08-15T14:20:00Z",
    delivery_time: 5,
    revisions: 5,
    orders_in_queue: 4,
    is_remote: true,
    views: 2340,
    location: null,
    expert: {
      name: "Émilie Martin",
      avatar_url: "https://randomuser.me/api/portraits/women/44.jpg"
    }
  },
  {
    id: 3,
    title: "Campagne Google Ads optimisée",
    description: "Je configure et optimise vos campagnes Google Ads pour maximiser votre ROI. Analyse de mots-clés, création d'annonces persuasives et suivi détaillé des performances.",
    price: 80,
    price_type: "hourly",
    category: "Marketing digital",
    image_url: "https://images.unsplash.com/photo-1533750516457-a7f992034fec?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=600&q=80",
    rating: 4.7,
    reviews_count: 63,
    created_at: "2023-08-20T10:10:00Z",
    delivery_time: 7,
    revisions: 2,
    orders_in_queue: 1,
    is_remote: true,
    views: 980,
    location: null,
    expert: {
      name: "Karim Benali",
      avatar_url: "https://randomuser.me/api/portraits/men/22.jpg"
    }
  },
  {
    id: 4,
    title: "Traduction professionnelle FR-EN-ES",
    description: "Service de traduction de haute qualité entre français, anglais et espagnol. Spécialisation en documents techniques, marketing et juridiques avec garantie de précision.",
    price: 40,
    price_type: "hourly",
    category: "Traduction",
    image_url: "https://images.unsplash.com/photo-1456513080510-7bf3a84b82f8?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=600&q=80",
    rating: 4.9,
    reviews_count: 192,
    created_at: "2023-08-05T16:30:00Z",
    delivery_time: 3,
    revisions: 2,
    orders_in_queue: 5,
    is_remote: true,
    views: 1850,
    location: null,
    expert: {
      name: "Sophie Leroy",
      avatar_url: "https://randomuser.me/api/portraits/women/28.jpg"
    }
  },
  {
    id: 5,
    title: "Rédaction d'articles SEO",
    description: "Rédaction d'articles optimisés pour le référencement naturel. Recherche de mots-clés, structure adaptée et contenu engageant pour améliorer votre visibilité sur Google.",
    price: 35,
    price_type: "hourly",
    category: "Rédaction",
    image_url: "https://images.unsplash.com/photo-1455390582262-044cdead277a?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=600&q=80",
    rating: 4.7,
    reviews_count: 78,
    created_at: "2023-08-18T08:45:00Z",
    delivery_time: 2,
    revisions: 1,
    orders_in_queue: 3,
    is_remote: true,
    views: 1120,
    location: null,
    expert: {
      name: "Antoine Girard",
      avatar_url: "https://randomuser.me/api/portraits/men/62.jpg"
    }
  },
  {
    id: 6,
    title: "Développement application mobile React Native",
    description: "Création d'applications mobiles multiplateformes avec React Native. Performance native, design sur mesure et support technique inclus pendant 3 mois.",
    price: 65,
    price_type: "hourly",
    category: "Développement web",
    image_url: "https://images.unsplash.com/photo-1551650975-87deedd944c3?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=600&q=80",
    rating: 4.8,
    reviews_count: 41,
    created_at: "2023-08-22T11:20:00Z",
    delivery_time: 21,
    revisions: 4,
    orders_in_queue: 2,
    is_remote: true,
    views: 890,
    location: null,
    expert: {
      name: "Léa Gauthier",
      avatar_url: "https://randomuser.me/api/portraits/women/56.jpg"
    }
  }
];

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
.space-y-5 > div:nth-child(6) { animation-delay: 0.3s; }

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
</style> 