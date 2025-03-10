<template>
  <div class="max-w-6xl mx-auto px-4 pt-5 pb-16">
    <!-- En-tête de la page -->
    <div class="mb-6 bg-white dark:bg-gray-800 rounded-xl p-5 border-l-4 border-primary-500 shadow-sm">
      <h1 class="text-2xl font-bold text-gray-900 dark:text-white flex items-center">
        <UsersIcon class="h-6 w-6 mr-3 text-primary-600 dark:text-primary-400" />
        Nos experts certifiés
      </h1>
      <p class="text-gray-600 dark:text-gray-400 mt-1">
        Trouvez les meilleurs spécialistes pour répondre à votre besoin
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
            placeholder="Rechercher un expert par nom, compétence ou domaine..."
            v-model="searchQuery"
            class="pl-12 pr-4 py-3.5 w-full text-base rounded-lg border-2 border-primary-200 dark:border-primary-900/50 bg-white dark:bg-gray-800 text-gray-800 dark:text-gray-200 focus:ring-3 focus:ring-primary-500/30 focus:border-primary-500 transition-shadow shadow-sm hover:shadow-md"
          />
        </div>
        <button 
          @click="fetchExperts"
          class="bg-primary-600 hover:bg-primary-700 text-white font-medium rounded-lg text-base px-6 py-3.5 inline-flex items-center justify-center transition-colors shadow-sm min-w-[120px]"
        >
          <SearchIcon class="h-5 w-5 mr-2" />
          Trouver
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

        <!-- Tri -->
        <div class="relative z-10">
          <button 
            @click="isOpenSort = !isOpenSort"
            class="px-4 py-2 rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-700 dark:text-gray-300 font-medium flex items-center"
          >
            <SortAscIcon v-if="sortBy === 'rating'" class="h-4 w-4 mr-2" />
            <TrendingUpIcon v-else-if="sortBy === 'completed'" class="h-4 w-4 mr-2" />
            <ClockIcon v-else class="h-4 w-4 mr-2" />
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
              <ClockIcon class="h-4 w-4 inline-block mr-2" />
              Plus récents
            </button>
            <button 
              @click="() => { sortBy = 'rating'; isOpenSort = false; }"
              class="w-full px-4 py-2 text-left text-sm hover:bg-gray-100 dark:hover:bg-gray-700"
              :class="sortBy === 'rating' ? 'text-primary-600 dark:text-primary-400 font-medium' : 'text-gray-700 dark:text-gray-300'"
            >
              <SortAscIcon class="h-4 w-4 inline-block mr-2" />
              Mieux notés
            </button>
            <button 
              @click="() => { sortBy = 'completed'; isOpenSort = false; }"
              class="w-full px-4 py-2 text-left text-sm hover:bg-gray-100 dark:hover:bg-gray-700"
              :class="sortBy === 'completed' ? 'text-primary-600 dark:text-primary-400 font-medium' : 'text-gray-700 dark:text-gray-300'"
            >
              <TrendingUpIcon class="h-4 w-4 inline-block mr-2" />
              Plus expérimentés
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Chargement -->
    <div v-if="isLoading" class="bg-white dark:bg-gray-800 rounded-xl p-12 flex flex-col items-center">
      <div class="h-12 w-12 border-4 border-primary-500 border-t-transparent rounded-full animate-spin"></div>
      <p class="mt-4 text-gray-600 dark:text-gray-400 text-lg">Recherche des meilleurs experts...</p>
    </div>

    <!-- Aucun expert trouvé -->
    <div v-else-if="filteredExperts.length === 0" class="bg-white dark:bg-gray-800 rounded-xl p-10 text-center border border-gray-200 dark:border-gray-700">
      <div class="mb-6 flex justify-center">
        <div class="bg-gray-100 dark:bg-gray-700 p-5 rounded-full">
          <UserSearchIcon class="h-10 w-10 text-gray-500 dark:text-gray-400" />
        </div>
      </div>
      <h3 class="text-xl font-medium text-gray-900 dark:text-white mb-3">Aucun expert trouvé</h3>
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

    <!-- Liste des experts - Format horizontal -->
    <div v-else class="space-y-5">
      <div v-for="expert in filteredExperts" :key="expert.id" 
        class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 overflow-hidden hover:shadow-md transition-all duration-300 hover:scale-[1.01] hover:border-primary-300 dark:hover:border-primary-700">
        
        <!-- Format horizontal -->
        <div class="flex flex-col md:flex-row">
          <!-- Partie gauche avec photo et infos principales -->
          <div class="md:w-1/3 p-5 md:border-r border-gray-200 dark:border-gray-700 flex flex-col">
            <div class="flex items-center gap-3 mb-4">
              <div class="relative">
                <img 
                  :src="expert.avatar_url || '/img/default-avatar.png'" 
                  :alt="expert.first_name + ' ' + expert.last_name"
                  class="h-16 w-16 rounded-full object-cover border-2 border-gray-200 dark:border-gray-700" 
                />
                <div v-if="expert.is_verified" class="absolute -bottom-1 -right-1 bg-primary-500 rounded-full p-0.5 border-2 border-white dark:border-gray-800">
                  <CheckIcon class="h-4 w-4 text-white" />
                </div>
              </div>
              <div>
                <h3 class="text-xl font-semibold text-gray-900 dark:text-white flex items-center">
                  {{ expert.first_name }} {{ expert.last_name }}
                </h3>
                <p class="text-sm text-gray-600 dark:text-gray-400">{{ expert.profession }}</p>
              </div>
            </div>
            
            <!-- Statistiques et prix -->
            <div class="mt-auto space-y-3">
              <div class="flex items-center justify-between text-sm">
                <div class="flex items-center">
                  <StarIcon class="h-5 w-5 text-amber-500 mr-1" fill="currentColor" />
                  <span class="font-bold text-gray-800 dark:text-gray-200">{{ expert.rating }}</span>
                  <span class="ml-1 text-gray-600 dark:text-gray-400">({{ expert.reviews_count }})</span>
                </div>
                <div class="flex items-center">
                  <CheckCircleIcon class="h-5 w-5 text-green-500 mr-1" />
                  <span>{{ expert.completed_projects }} projets</span>
                </div>
              </div>
              
              <div class="text-base bg-primary-50 dark:bg-primary-900/20 p-2 rounded-lg text-center">
                <span class="text-gray-600 dark:text-gray-400">À partir de </span>
                <span class="font-bold text-primary-700 dark:text-primary-400">{{ expert.hourly_rate }}€</span>
                <span class="text-gray-600 dark:text-gray-400">/h</span>
              </div>
            </div>
          </div>
          
          <!-- Partie droite avec bio et compétences -->
          <div class="md:w-2/3 p-5 flex flex-col">
            <!-- Bio -->
            <div class="mb-4">
              <h4 class="text-sm font-medium text-gray-500 dark:text-gray-400 mb-1">À propos</h4>
              <p class="text-gray-800 dark:text-gray-200 line-clamp-3">
                {{ expert.bio }}
              </p>
            </div>
            
            <!-- Compétences -->
            <div class="mb-5">
              <h4 class="text-sm font-medium text-gray-500 dark:text-gray-400 mb-2">Compétences</h4>
              <div class="flex flex-wrap gap-2">
                <span 
                  v-for="skill in expert.skills" :key="skill"
                  class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-primary-50 text-primary-700 dark:bg-primary-900/20 dark:text-primary-400"
                >
                  {{ skill }}
                </span>
              </div>
            </div>
            
            <!-- Actions -->
            <div class="mt-auto flex gap-3 justify-end">
              <NuxtLink 
                :to="`/experts/${expert.id}`"
                class="px-4 py-2 text-gray-700 dark:text-gray-300 border border-gray-300 dark:border-gray-600 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-700 font-medium"
              >
                Voir le profil
              </NuxtLink>
              <NuxtLink 
                :to="`/messages/new?expert=${expert.id}`"
                class="px-4 py-2 bg-primary-600 hover:bg-primary-700 text-white rounded-lg font-medium inline-flex items-center"
              >
                <MessageSquareIcon class="h-4 w-4 mr-2" />
                Contacter
              </NuxtLink>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Pagination -->
    <div v-if="filteredExperts.length > 0" class="mt-8 flex justify-center">
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
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { 
  UsersIcon, Search, SortAscIcon, TrendingUpIcon, ClockIcon, ChevronDownIcon, 
  StarIcon, CheckCircleIcon, UserSearchIcon, RefreshCwIcon, CheckIcon,
  ChevronLeftIcon, ChevronRightIcon, MessageSquareIcon
} from 'lucide-vue-next'

const supabase = useSupabaseClient()
const isLoading = ref(true)
const experts = ref([])
const activeCategory = ref('all')
const searchQuery = ref('')
const sortBy = ref('rating') // 'rating', 'recent', 'completed'
const isOpenSort = ref(false)
const page = ref(1)
const perPage = 12
const totalExperts = ref(0)

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

// Récupérer les experts
const fetchExperts = async () => {
  isLoading.value = true
  
  try {
    // Simulation de récupération depuis Supabase
    const { data, error, count } = await supabase
      .from('experts')
      .select('*', { count: 'exact' })
      .order(getSortColumn(), { ascending: sortBy.value !== 'rating' && sortBy.value !== 'completed' })
      .range((page.value - 1) * perPage, page.value * perPage - 1)
    
    if (error) throw error
    
    experts.value = data || mockExperts // Utilisation de données simulées si nécessaire
    totalExperts.value = count || mockExperts.length
  } catch (error) {
    console.error('Erreur lors de la récupération des experts:', error)
    experts.value = mockExperts // Utilisation de données simulées en cas d'erreur
    totalExperts.value = mockExperts.length
  } finally {
    isLoading.value = false
  }
}

// Filtrage des experts
const filteredExperts = computed(() => {
  return experts.value.filter(expert => {
    // Filtre par catégorie
    const categoryMatch = activeCategory.value === 'all' || expert.categories.includes(activeCategory.value)
    
    // Filtre par recherche
    const searchMatch = 
      searchQuery.value === '' || 
      expert.first_name.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
      expert.last_name.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
      expert.profession.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
      expert.bio.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
      expert.skills.some(skill => skill.toLowerCase().includes(searchQuery.value.toLowerCase()))
    
    return categoryMatch && searchMatch
  })
})

// Nombre total de pages
const totalPages = computed(() => {
  return Math.ceil(totalExperts.value / perPage)
})

// Obtenir la colonne de tri
const getSortColumn = () => {
  switch(sortBy.value) {
    case 'rating':
      return 'rating'
    case 'completed':
      return 'completed_projects'
    case 'recent':
    default:
      return 'created_at'
  }
}

// Obtenir le libellé du tri
const getSortLabel = () => {
  switch(sortBy.value) {
    case 'rating':
      return 'Mieux notés'
    case 'completed':
      return 'Plus expérimentés'
    case 'recent':
    default:
      return 'Plus récents'
  }
}

// Réinitialiser les filtres
const resetFilters = () => {
  activeCategory.value = 'all'
  searchQuery.value = ''
  sortBy.value = 'rating'
  page.value = 1
  fetchExperts()
}

// Fermer le menu de tri en cliquant en dehors
const handleClickOutside = (event) => {
  if (isOpenSort.value && !event.target.closest('.relative')) {
    isOpenSort.value = false
  }
}

// Surveiller les changements de filtre et trier
watch([activeCategory, searchQuery, sortBy], () => {
  page.value = 1 // Réinitialiser la page lors du changement de filtre
  fetchExperts()
})

// Surveiller les changements de page
watch(page, () => {
  fetchExperts()
  // Scroll vers le haut
  window.scrollTo({
    top: 0,
    behavior: 'smooth'
  })
})

// Initialisation
onMounted(() => {
  fetchExperts()
  document.addEventListener('click', handleClickOutside)
})

// Nettoyage
onUnmounted(() => {
  document.removeEventListener('click', handleClickOutside)
})

// Données simulées pour démonstration
const mockExperts = [
  {
    id: 1,
    first_name: 'Thomas',
    last_name: 'Dubois',
    profession: 'Développeur Full-Stack',
    bio: 'Développeur passionné avec 8 ans d\'expérience dans la création d\'applications web et mobiles. Spécialisé en React, Vue.js et Node.js.',
    avatar_url: 'https://randomuser.me/api/portraits/men/32.jpg',
    rating: 4.9,
    reviews_count: 57,
    completed_projects: 82,
    hourly_rate: 55,
    is_verified: true,
    skills: ['JavaScript', 'React', 'Node.js', 'Vue.js', 'TypeScript'],
    categories: ['Développement web']
  },
  {
    id: 2,
    first_name: 'Émilie',
    last_name: 'Martin',
    profession: 'Designer UX/UI',
    bio: 'Designer UX/UI avec une approche centrée sur l\'utilisateur. Je transforme des concepts complexes en interfaces élégantes et intuitives.',
    avatar_url: 'https://randomuser.me/api/portraits/women/44.jpg',
    rating: 4.8,
    reviews_count: 43,
    completed_projects: 61,
    hourly_rate: 50,
    is_verified: true,
    skills: ['Figma', 'Adobe XD', 'Sketch', 'Design System', 'Prototypage'],
    categories: ['Design graphique']
  },
  {
    id: 3,
    first_name: 'Karim',
    last_name: 'Benali',
    profession: 'Expert Marketing Digital',
    bio: 'Stratège marketing digital spécialisé en acquisition et fidélisation client. J\'aide les entreprises à développer leur présence en ligne et générer des leads qualifiés.',
    avatar_url: 'https://randomuser.me/api/portraits/men/22.jpg',
    rating: 4.7,
    reviews_count: 29,
    completed_projects: 45,
    hourly_rate: 45,
    is_verified: true,
    skills: ['SEO', 'SEM', 'Google Ads', 'Analytics', 'Content Marketing'],
    categories: ['Marketing digital']
  },
  {
    id: 4,
    first_name: 'Sophie',
    last_name: 'Leroy',
    profession: 'Traductrice FR/EN/ES',
    bio: 'Traductrice trilingue avec 6 ans d\'expérience en traduction technique et marketing. Je garantis des traductions précises et culturellement adaptées.',
    avatar_url: 'https://randomuser.me/api/portraits/women/28.jpg',
    rating: 4.9,
    reviews_count: 64,
    completed_projects: 98,
    hourly_rate: 40,
    is_verified: true,
    skills: ['Traduction', 'Localisation', 'Correction', 'SEO multilingue'],
    categories: ['Traduction']
  },
  {
    id: 5,
    first_name: 'Antoine',
    last_name: 'Girard',
    profession: 'Rédacteur Web SEO',
    bio: 'Rédacteur web spécialisé en contenus optimisés pour le référencement. Je crée des textes engageants qui convertissent les visiteurs en clients.',
    avatar_url: 'https://randomuser.me/api/portraits/men/62.jpg',
    rating: 4.7,
    reviews_count: 38,
    completed_projects: 72,
    hourly_rate: 35,
    is_verified: false,
    skills: ['Copywriting', 'SEO', 'Content Marketing', 'Storytelling'],
    categories: ['Rédaction', 'Marketing digital']
  },
  {
    id: 6,
    first_name: 'Léa',
    last_name: 'Gauthier',
    profession: 'Développeuse Mobile',
    bio: 'Développeuse d\'applications mobiles natives et hybrides pour iOS et Android. Spécialisée en React Native et Flutter.',
    avatar_url: 'https://randomuser.me/api/portraits/women/56.jpg',
    rating: 4.8,
    reviews_count: 31,
    completed_projects: 47,
    hourly_rate: 60,
    is_verified: true,
    skills: ['React Native', 'Flutter', 'Swift', 'Kotlin', 'Firebase'],
    categories: ['Développement web']
  }
];

definePageMeta({
  layout: 'default'
})
</script>

<style scoped>
/* Animation des composants - Plus impactante */
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
