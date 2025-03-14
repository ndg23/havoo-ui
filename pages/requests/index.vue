<template>
  <div class="max-w-3xl mx-auto px-4 pt-5 pb-16">
    <!-- En-tête minimaliste style Twitter -->
    <div class="mb-6">
      <h1 class="text-2xl font-bold text-gray-900 dark:text-white">Explorer les demandes</h1>
    </div>

    <!-- Menu sticky -->
    <div 
      ref="stickyMenu" 
      class="sticky top-16 z-30 bg-white/95 dark:bg-gray-900/95 backdrop-blur-sm border-b border-gray-200 dark:border-gray-800 transition-all duration-300 py-4"
      :class="isSticky ? 'shadow-md' : ''"
    >
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <!-- Recherche et filtres rapides -->
        <div class="flex flex-col sm:flex-row items-stretch sm:items-center gap-3 mb-4">
          <!-- Barre de recherche -->
          <div class="relative flex-grow">
            <input 
              v-model="searchQuery" 
              type="text" 
              placeholder="Rechercher des demandes..." 
              class="w-full pl-10 pr-4 py-2 border border-gray-300 dark:border-gray-700 rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-gray-100 focus:ring-2 focus:ring-primary-500 dark:focus:ring-primary-400 focus:border-transparent"
            />
            <Search class="absolute left-3 top-1/2 transform -translate-y-1/2 h-5 w-5 text-gray-400" />
          </div>
          
          <!-- Filtres par statut -->
          <div class="flex flex-wrap gap-2">
            <button 
              v-for="status in ['all', 'open', 'urgent']" 
              :key="status"
              @click="currentStatusFilter = status"
              class="px-3 py-2 rounded-lg text-sm font-medium transition-colors whitespace-nowrap"
              :class="currentStatusFilter === status 
                ? 'bg-primary-100 dark:bg-primary-900/30 text-primary-600 dark:text-primary-400' 
                : 'bg-gray-100 dark:bg-gray-800 text-gray-700 dark:text-gray-300 hover:bg-gray-200 dark:hover:bg-gray-700'"
            >
              {{ getStatusFilterText(status) }}
            </button>
          </div>
        </div>
        
        <!-- Filtres avancés -->
        <div class="flex flex-wrap items-center justify-between gap-3">
          <!-- Filtres par catégorie -->
          <div class="flex items-center gap-2 overflow-x-auto py-1 scrollbar-hide">
            <button 
              v-for="category in categories" 
              :key="category.id"
              @click="toggleCategoryFilter(category.id)"
              class="px-3 py-1.5 rounded-full text-xs font-medium transition-colors whitespace-nowrap"
              :class="selectedCategories.includes(category.id) 
                ? 'bg-primary-100 dark:bg-primary-900/30 text-primary-600 dark:text-primary-400' 
                : 'bg-gray-100 dark:bg-gray-800 text-gray-700 dark:text-gray-300 hover:bg-gray-200 dark:hover:bg-gray-700'"
            >
              {{ category.name }}
            </button>
          </div>
          
          <!-- Tri -->
          <div class="flex items-center">
            <span class="text-sm text-gray-500 dark:text-gray-400 mr-2">Trier par:</span>
            <select 
              v-model="sortOption"
              class="bg-white dark:bg-gray-800 border border-gray-300 dark:border-gray-700 rounded-lg text-sm px-3 py-1.5 text-gray-700 dark:text-gray-300"
            >
              <option value="newest">Plus récentes</option>
              <option value="oldest">Plus anciennes</option>
              <option value="budget_high">Budget (élevé → bas)</option>
              <option value="budget_low">Budget (bas → élevé)</option>
            </select>
          </div>
        </div>
      </div>
    </div>

    <!-- État de chargement -->
    <div v-if="isLoading" class="flex justify-center items-center py-20">
      <div class="h-10 w-10 border-4 border-gray-200 dark:border-gray-700 border-t-primary-500 dark:border-t-primary-400 rounded-full animate-spin"></div>
    </div>

    <!-- Aucune demande trouvée -->
    <div v-else-if="filteredRequests.length === 0" class="py-16 text-center">
      <div class="mb-4 flex justify-center">
        <div class="bg-primary-50 dark:bg-primary-900/20 p-4 rounded-full">
          <SearchX class="h-8 w-8 text-primary-500 dark:text-primary-400" />
        </div>
      </div>
      <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-2">Aucune demande trouvée</h3>
      <p class="text-gray-600 dark:text-gray-400 mb-6 max-w-sm mx-auto">
        Aucune demande ne correspond à votre recherche
      </p>
    </div>

    <!-- Liste des demandes style Twitter avec séparation horizontale -->
    <div v-else>
      <div v-for="(request, index) in filteredRequests" :key="request.id" 
        class="py-5 hover:bg-gray-50 dark:hover:bg-gray-800/50 transition-all"
        :class="{ 'border-b border-gray-200 dark:border-gray-700': index !== filteredRequests.length - 1 }">
        <!-- En-tête avec avatar et nom -->
        <div class="flex items-center mb-3">
          <img 
            :src="request.avatar || '/img/default-avatar.png'" 
            :alt="request.clientName"
            class="w-10 h-10 rounded-full object-cover border border-gray-100 dark:border-gray-700"
          />
          <div class="ml-3">
            <span class="font-semibold text-gray-900 dark:text-white">{{ request.clientName }}</span>
            <div class="flex items-center text-xs text-gray-500 dark:text-gray-400">
              <span>{{ request.postedTime }}</span>
              <span class="mx-1">•</span>
              <span class="text-primary-600 dark:text-primary-400 font-medium">{{ request.category }}</span>
            </div>
          </div>
        </div>

        <!-- Contenu de la demande -->
        <div class="mb-3 cursor-pointer" @click="viewRequestDetails(request.id)">
          <h3 class="text-lg font-bold text-gray-900 dark:text-white mb-2">{{ request.title }}</h3>
          <p class="text-gray-700 dark:text-gray-300 mb-3 line-clamp-2">{{ request.description }}</p>

          <!-- Tags avec couleurs -->
          <div class="flex flex-wrap gap-1.5 mb-3">
            <span 
              v-for="(tag, tagIndex) in request.tags" 
              :key="tagIndex" 
              class="rounded-full px-3 py-1 text-xs font-medium"
              :class="getTagColor(tagIndex)"
            >
              {{ tag }}
            </span>
          </div>
          
          <!-- Indicateurs -->
          <div class="flex items-center justify-between mt-4">
            <!-- Budget avec couleur -->
            <div class="font-bold text-xl text-primary-600 dark:text-primary-400">{{ request.budget }}</div>
            
            <!-- Deadline -->
            <div :class="['flex items-center text-xs px-2 py-1 rounded-full', request.isUrgent ? 'bg-red-100 text-red-600 dark:bg-red-900/20 dark:text-red-400' : 'bg-gray-100 text-gray-700 dark:bg-gray-800 dark:text-gray-300']">
              <Clock class="h-3.5 w-3.5 mr-1" />
              <span>{{ request.deadline }}</span>
            </div>
          </div>
        </div>

        <!-- Pied avec engagement et action -->
        <div class="flex items-center justify-between mt-4">
          <div class="text-sm text-gray-500 dark:text-gray-400 flex items-center">
            <MessageSquare class="h-4 w-4 mr-1.5" />
            <span>{{ request.proposalCount }} proposition{{ request.proposalCount !== 1 ? 's' : '' }}</span>
          </div>

          <button class="px-4 py-2 bg-primary-600 hover:bg-primary-700 dark:bg-primary-500 dark:hover:bg-primary-600 text-white rounded-full text-sm font-medium transition-transform hover:scale-105">
            Proposer mes services
          </button>
        </div>
      </div>
    </div>

    <!-- Bouton flottant pour créer une nouvelle demande avec couleur -->
    <button @click="navigateToNewRequest" class="fixed bottom-6 right-6 w-14 h-14 bg-primary-600 hover:bg-primary-700 text-white rounded-full shadow-lg flex items-center justify-center hover:scale-105 transition-transform">
      <Plus class="h-6 w-6" />
    </button>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted, watch } from 'vue'
import { useRouter } from 'vue-router'
import { useRequests } from '~/composables/useRequests'
import { useSupabaseClient } from '#imports'
import {
  Search,
  SearchX,
  UserCircle,
  Calendar,
  Banknote,
  Tag,
  PlusCircle
} from 'lucide-vue-next'

const router = useRouter()
const supabase = useSupabaseClient()

// Référence pour le menu sticky
const stickyMenu = ref(null)
const isSticky = ref(false)

// Filtres
const searchQuery = ref('')
const currentStatusFilter = ref('all')
const selectedCategories = ref([])
const sortOption = ref('newest')

// Récupération des catégories
const categories = ref([])
const fetchCategories = async () => {
  try {
    const { data, error } = await supabase
      .from('categories')
      .select('id, name')
      .eq('is_active', true)
      .order('name')
    
    if (error) throw error
    
    categories.value = data
  } catch (error) {
    console.error('Error fetching categories:', error)
    // Fallback à des catégories par défaut
    categories.value = [
      { id: 1, name: 'Développement web' },
      { id: 2, name: 'Design graphique' },
      { id: 3, name: 'Marketing digital' },
      { id: 4, name: 'Rédaction' },
      { id: 5, name: 'Traduction' },
      { id: 6, name: 'SEO' },
    ]
  }
}

// Utilisation du composable
const { requests, isLoading, error, fetchRequests } = useRequests()

// Calculer les demandes filtrées
const filteredRequests = computed(() => {
  let filtered = [...requests.value]
  
  // On applique les filtres côté client pour éviter trop de requêtes API
  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase()
    filtered = filtered.filter(request => 
      request.title.toLowerCase().includes(query) || 
      request.description.toLowerCase().includes(query)
    )
  }
  
  if (selectedCategories.value.length > 0) {
    filtered = filtered.filter(request => {
      return request.categories.some(category => 
        selectedCategories.value.includes(category.id)
      )
    })
  }
  
  // Tri
  switch (sortOption.value) {
    case 'newest':
      filtered.sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt))
      break
    case 'oldest':
      filtered.sort((a, b) => new Date(a.createdAt) - new Date(b.createdAt))
      break
    case 'budget_high':
      filtered.sort((a, b) => (b.budget || 0) - (a.budget || 0))
      break
    case 'budget_low':
      filtered.sort((a, b) => (a.budget || 0) - (b.budget || 0))
      break
  }
  
  return filtered
})

// Chargement des données
const loadData = async () => {
  const filters = {
    status: currentStatusFilter.value === 'all' ? null : currentStatusFilter.value,
    urgent: currentStatusFilter.value === 'urgent',
    search: searchQuery.value
  }
  
  await fetchRequests(filters)
}

// Observer les changements de filtres
watch([currentStatusFilter, searchQuery], () => {
  loadData()
})

// Gestion du menu sticky
const handleScroll = () => {
  if (!stickyMenu.value) return
  
  const rect = stickyMenu.value.getBoundingClientRect()
  const menuTop = rect.top + window.scrollY
  
  isSticky.value = window.scrollY > menuTop
}

// Méthodes
const getStatusFilterText = (status) => {
  const statusMap = {
    'all': 'Toutes',
    'open': 'Ouvertes',
    'urgent': 'Urgentes'
  }
  return statusMap[status] || status
}

const toggleCategoryFilter = (categoryId) => {
  if (selectedCategories.value.includes(categoryId)) {
    selectedCategories.value = selectedCategories.value.filter(id => id !== categoryId)
  } else {
    selectedCategories.value.push(categoryId)
  }
}

const resetFilters = () => {
  searchQuery.value = ''
  currentStatusFilter.value = 'all'
  selectedCategories.value = []
  sortOption.value = 'newest'
}

const viewRequest = (requestId) => {
  router.push(`/requests/${requestId}`)
}

const createNewRequest = () => {
  router.push('/requests/new')
}

onMounted(async () => {
  window.addEventListener('scroll', handleScroll)
  await Promise.all([fetchCategories(), loadData()])
})

onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll)
})

definePageMeta({
  layout: 'default'
})
</script>

<style scoped>
/* Masquer la barre de défilement tout en gardant la fonctionnalité */
.no-scrollbar {
  -ms-overflow-style: none;
  scrollbar-width: none;
}
.no-scrollbar::-webkit-scrollbar {
  display: none;
}

/* Animation pour l'apparition des composants */
.py-5 {
  animation: fadeIn 0.3s ease-out;
  animation-fill-mode: both;
}

/* Animation séquentielle pour les items */
div > div:nth-child(1) { animation-delay: 0.05s; }
div > div:nth-child(2) { animation-delay: 0.1s; }
div > div:nth-child(3) { animation-delay: 0.15s; }
div > div:nth-child(4) { animation-delay: 0.2s; }
div > div:nth-child(5) { animation-delay: 0.25s; }

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(8px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.scrollbar-hide {
  -ms-overflow-style: none;  /* Pour Internet Explorer et Edge */
  scrollbar-width: none;  /* Pour Firefox */
}

.scrollbar-hide::-webkit-scrollbar {
  display: none;  /* Pour Chrome, Safari et Opera */
}
</style>