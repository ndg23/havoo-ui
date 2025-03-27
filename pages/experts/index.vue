<template>
  <div class="min-h-screen bg-white dark:bg-gray-900">
    <!-- Twitter-style sticky header with blur effect -->
    <div class="sticky top-0 z-30 bg-white/90 dark:bg-gray-900/90 backdrop-blur-sm border-b border-gray-200 dark:border-gray-800">
      <div class="max-w-3xl mx-auto px-4 py-3 flex justify-between items-center">
        <h1 class="text-xl font-bold text-gray-900 dark:text-white">Trouver un expert</h1>
      </div>
      
      <!-- Twitter-style search bar -->
      <div class="max-w-3xl mx-auto px-4 pb-3">
        <div class="relative">
          <div class="absolute inset-y-0 left-3 flex items-center pointer-events-none">
            <svg class="h-5 w-5 text-gray-400 dark:text-gray-500" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
              <path fill-rule="evenodd" d="M8 4a4 4 0 100 8 4 4 0 000-8zM2 8a6 6 0 1110.89 3.476l4.817 4.817a1 1 0 01-1.414 1.414l-4.816-4.816A6 6 0 012 8z" clip-rule="evenodd" />
            </svg>
          </div>
          <input 
            v-model="searchQuery" 
            type="text" 
            placeholder="Rechercher un expert..." 
            class="block w-full bg-gray-100 dark:bg-gray-800 border-none rounded-full pl-10 pr-4 py-2.5 text-gray-900 dark:text-gray-100 focus:ring-2 focus:ring-primary-500 transition-all"
          />
        </div>
      </div>
      
      <!-- Twitter-style filters row -->
      <div class="max-w-3xl mx-auto px-4 pb-3 flex gap-2 overflow-x-auto scrollbar-hide">
        <button 
          @click="showAdvancedFilters = !showAdvancedFilters"
          class="flex items-center gap-1.5 px-3.5 py-1.5 text-sm rounded-full border border-gray-200 dark:border-gray-700 bg-white dark:bg-gray-800 hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors"
        >
          <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 4a1 1 0 011-1h16a1 1 0 011 1v2.586a1 1 0 01-.293.707l-6.414 6.414a1 1 0 00-.293.707V17l-4 4v-6.586a1 1 0 00-.293-.707L3.293 7.293A1 1 0 013 6.586V4z" />
          </svg>
          Filtres
          <span v-if="activeFilters.length > 0" class="ml-0.5 flex items-center justify-center h-5 w-5 text-xs bg-primary-500 text-white rounded-full">{{ activeFilters.length }}</span>
        </button>
        
        <!-- Active filters pills with Twitter style -->
        <div v-for="filter in activeFilters" :key="filter.id" class="inline-flex">
          <span class="inline-flex items-center px-3 py-1.5 rounded-full text-xs font-medium bg-primary-50 dark:bg-primary-900/30 text-primary-800 dark:text-primary-200 border border-primary-100 dark:border-primary-800/30 transition-colors">
            {{ filter.name }}
            <button 
              @click="removeFilter(filter)"
              class="ml-1.5 h-4 w-4 rounded-full inline-flex items-center justify-center hover:bg-primary-200/70 dark:hover:bg-primary-800/70"
              aria-label="Supprimer le filtre"
            >
              <svg class="h-3 w-3" fill="currentColor" viewBox="0 0 20 20">
                <path d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd"></path>
              </svg>
            </button>
          </span>
        </div>
        
        <!-- Clear filters button with Twitter style -->
        <button 
          v-if="activeFilters.length > 0"
          @click="clearFilters"
          class="text-xs text-gray-600 dark:text-gray-300 hover:text-gray-900 dark:hover:text-white px-3.5 py-1.5 rounded-full border border-gray-200 dark:border-gray-700 transition-colors"
        >
          Effacer tous
        </button>
      </div>
    </div>
    
    <!-- Advanced filters panel with Twitter style -->
    <div 
      v-if="showAdvancedFilters" 
      class="border-b border-gray-200 dark:border-gray-800 bg-white dark:bg-gray-800 shadow-sm animate-slide-down"
    >
      <div class="max-w-3xl mx-auto px-4 py-4">
        <div class="grid grid-cols-2 md:grid-cols-3 gap-3">
          <!-- Category filter with Twitter style -->
          <div>
            <select 
              v-model="filters.categoryId" 
              class="w-full pl-3 pr-8 py-2 rounded-lg border border-gray-200 dark:border-gray-700 bg-white dark:bg-gray-800 text-sm focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors"
            >
              <option value="">Catégorie</option>
              <option v-for="category in professions" :key="category.id" :value="category.id">
                {{ category.name }}
              </option>
            </select>
          </div>
          
          <!-- Rating filter with Twitter style -->
          <div>
            <select 
              v-model="filters.minRating" 
              class="w-full pl-3 pr-8 py-2 rounded-lg border border-gray-200 dark:border-gray-700 bg-white dark:bg-gray-800 text-sm focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors"
            >
              <option value="">Note</option>
              <option value="5">5 étoiles</option>
              <option value="4">4+ étoiles</option>
              <option value="3">3+ étoiles</option>
            </select>
          </div>
          
          <!-- Search button with Twitter style -->
          <div>
            <button
              @click="applyFilters"
              class="w-full px-4 py-2 bg-primary-600 hover:bg-primary-700 text-white rounded-lg text-sm font-medium transition-colors focus:ring-2 focus:ring-primary-500 focus:ring-offset-2"
            >
              Rechercher
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Twitter-style loading state -->
    <div v-if="isLoading" class="max-w-3xl mx-auto flex justify-center items-center py-16">
      <div class="animate-spin h-10 w-10 text-primary-500">
        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
          <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
          <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
        </svg>
      </div>
    </div>

    <!-- Twitter-style error state -->
    <div v-else-if="error" class="max-w-3xl mx-auto bg-red-50 dark:bg-red-900/20 p-5 rounded-xl border border-red-100 dark:border-red-800/40 text-red-700 dark:text-red-400 mx-4 my-6">
      <div class="flex">
        <svg class="h-5 w-5 text-red-500 dark:text-red-400 mr-3" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
        </svg>
        <p>{{ error }}</p>
      </div>
      <button 
        @click="fetchExperts" 
        class="mt-3 text-sm font-medium text-red-600 dark:text-red-400 hover:text-red-500"
      >
        Réessayer
      </button>
    </div>

    <!-- Twitter-style empty state -->
    <div v-else-if="filteredExperts.length === 0" class="text-center py-16 max-w-3xl mx-auto px-4">
      <div class="mx-auto h-16 w-16 text-gray-300 dark:text-gray-600 bg-gray-50 dark:bg-gray-800 rounded-full flex items-center justify-center">
        <svg class="h-8 w-8" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M15.75 6a3.75 3.75 0 11-7.5 0 3.75 3.75 0 017.5 0zM4.501 20.118a7.5 7.5 0 0114.998 0A17.933 17.933 0 0112 21.75c-2.676 0-5.216-.584-7.499-1.632z" />
        </svg>
      </div>
      <h3 class="mt-4 text-base font-medium text-gray-900 dark:text-white">Aucun expert trouvé</h3>
      <p class="mt-1 text-sm text-gray-500 dark:text-gray-400 max-w-md mx-auto">
        Essayez de modifier vos filtres ou revenez plus tard pour découvrir de nouveaux experts.
      </p>
      <button 
        @click="clearFilters" 
        v-if="activeFilters.length > 0"
        class="mt-4 px-4 py-2 text-sm font-medium text-primary-600 dark:text-primary-400 bg-primary-50 dark:bg-primary-900/20 hover:bg-primary-100 dark:hover:bg-primary-900/30 rounded-full transition-colors"
      >
        Effacer les filtres
      </button>
    </div>
    
    <!-- Liste des experts avec style Twitter/GAFAM -->
    <div v-else class="max-w-3xl mx-auto divide-y divide-gray-200 dark:divide-gray-800">
      <div 
        v-for="expert in filteredExperts" 
        :key="expert.id"
        class="hover:bg-gray-50 dark:hover:bg-gray-800/50 transition-all duration-200"
      >
        <NuxtLink :to="`/experts/${expert.id}`" class="block p-6">
          <!-- En-tête avec avatar et infos principales -->
          <div class="flex space-x-5">
            <!-- Avatar + Statut -->
            <div class="relative flex-shrink-0">
              <div class="w-16 h-16 rounded-full overflow-hidden ring-4 ring-white dark:ring-gray-800 shadow-sm">
                <img 
                  v-if="expert.avatar_url" 
                  :src="expert.avatar_url" 
                  :alt="`Photo de ${expert.first_name}`"
                  class="w-full h-full object-cover" 
                />
                <div 
                  v-else 
                  class="w-full h-full bg-gradient-to-br from-primary-400 to-primary-600 dark:from-primary-600 dark:to-primary-800 flex items-center justify-center text-xl font-bold text-white"
                >
                  {{ getInitials(expert.first_name, expert.last_name) }}
                </div>
              </div>
              <!-- Badge de statut -->
              <div 
                class="absolute -bottom-1 -right-1 ring-4 ring-white dark:ring-gray-800"
                :class="{
                  'bg-green-500': expert.availability_status === 'available',
                  'bg-yellow-500': expert.availability_status === 'busy',
                  'bg-red-500': expert.availability_status === 'unavailable'
                }"
              >
                <div class="w-5 h-5 rounded-full flex items-center justify-center">
                  <div class="w-2.5 h-2.5 rounded-full bg-white"></div>
                </div>
              </div>
            </div>

            <!-- Informations principales -->
            <div class="flex-1 min-w-0">
              <div class="flex items-center justify-between mb-1">
                <div>
                  <!-- Nom et badges -->
                  <div class="flex items-center space-x-2">
                    <h3 class="text-lg font-bold text-gray-900 dark:text-white hover:text-primary-600 dark:hover:text-primary-400">
                      {{ expert.first_name }} {{ expert.last_name }}
                    </h3>
                    <CheckBadgeIcon v-if="expert.is_verified" class="w-5 h-5 text-primary-500" />
                    <span 
                      v-if="expert.profile_completion_percentage >= 80"
                      class="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-blue-100 text-blue-800 dark:bg-blue-900/20 dark:text-blue-300"
                    >
                      Profil complet
                    </span>
                  </div>
                  <!-- Localisation -->
                  <div class="flex items-center space-x-2 text-sm text-gray-500 dark:text-gray-400 mt-0.5">
                    <MapPinIcon class="w-4 h-4" />
                    <span>{{ expert.city }}, {{ expert.country }}</span>
                  </div>
                </div>
                <!-- Tarif horaire -->
                <div v-if="expert.hourly_rate" class="text-right">
                  <div class="text-lg font-bold text-gray-900 dark:text-white">
                    {{ formatPrice(expert.hourly_rate) }}
                  </div>
                  <div class="text-sm text-gray-500 dark:text-gray-400">
                    par heure
                  </div>
                </div>
              </div>

              <!-- Bio -->
              <p v-if="expert.bio" class="text-gray-600 dark:text-gray-300 line-clamp-2 mb-4">
                {{ expert.bio }}
              </p>

              <!-- Métriques -->
              <div class="flex items-center space-x-6 mb-4">
                <!-- Note -->
                <div class="flex items-center">
                  <div class="flex items-center text-yellow-400 mr-1.5">
                    <StarIcon v-for="i in 5" :key="i" class="w-5 h-5" :class="{ 'text-gray-300': i > (expert.average_rating || 5) }" />
                  </div>
                  <span class="font-medium text-gray-900 dark:text-white">{{ expert.average_rating || '5.0' }}</span>
                  <span class="ml-1 text-sm text-gray-500">({{ expert.review_count || '0' }})</span>
                </div>
                
                <!-- Missions complétées -->
                <div class="flex items-center text-gray-500 dark:text-gray-400">
                  <BriefcaseIcon class="w-5 h-5 mr-2" />
                  <span class="font-medium text-gray-900 dark:text-white">{{ expert.missions_count || '0' }}</span>
                  <span class="ml-1">missions</span>
                </div>

                <!-- Taux de réponse -->
                <div class="flex items-center text-gray-500 dark:text-gray-400">
                  <ClockIcon class="w-5 h-5 mr-2" />
                  <span>Répond en &lt; 1h</span>
                </div>
              </div>

              <!-- Compétences -->
              <div class="flex flex-wrap gap-2">
                <!-- Profession -->
                <span 
                  v-if="expert.profession?.name"
                  class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-primary-50 text-primary-700 dark:bg-primary-900/20 dark:text-primary-300 border border-primary-100 dark:border-primary-800/30"
                >
                  {{ expert.profession.name }}
                </span>
                <!-- Skills -->
                <span 
                  v-for="skill in expert.skills?.slice(0, 3)" 
                  :key="skill.id"
                  class="inline-flex items-center px-2.5 py-0.5 rounded-full text-sm font-medium bg-gray-100 text-gray-800 dark:bg-gray-800 dark:text-gray-200"
                >
                  {{ skill.name }}
                </span>
                <!-- More skills -->
                <span 
                  v-if="(expert.skills?.length || 0) > 3" 
                  class="inline-flex items-center px-2.5 py-0.5 rounded-full text-sm font-medium bg-gray-50 text-gray-600 dark:bg-gray-800/50 dark:text-gray-400"
                >
                  +{{ expert.skills.length - 3 }}
                </span>
              </div>
            </div>
          </div>
        </NuxtLink>
      </div>
    </div>
    
    <!-- Twitter-style pagination button -->
    <div v-if="hasMoreExperts && !isLoading" class="p-5 text-center">
      <button 
        @click="loadMoreExperts" 
        class="px-6 py-2.5 border border-gray-200 dark:border-gray-700 rounded-full text-sm font-medium text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-800 transition-colors shadow-sm"
        :disabled="isLoadingMore"
      >
        <span v-if="isLoadingMore" class="flex items-center justify-center">
          <svg class="animate-spin -ml-1 mr-2 h-4 w-4 text-gray-600 dark:text-gray-400" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
          </svg>
          Chargement...
        </span>
        <span v-else>Charger plus d'experts</span>
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue';
import { useSupabaseClient } from '#imports';
import { 
  CheckBadgeIcon, 
  StarIcon, 
  MapPinIcon, 
  BriefcaseIcon,
  ClockIcon 
} from '@heroicons/vue/24/solid'

const supabase = useSupabaseClient();

// État
const isLoading = ref(true);
const error = ref(null);
const experts = ref([]);
const professions = ref([]);
const searchQuery = ref('');
const filters = ref({
  categoryId: '',
  minRating: ''
});
const currentPage = ref(1);
const pageSize = 10;
const hasMoreExperts = ref(false);
const showAdvancedFilters = ref(false);

// Computed
const activeFilters = computed(() => {
  const result = [];
  
  if (filters.value.categoryId) {
    const category = professions.value.find(c => c.id === parseInt(filters.value.categoryId));
    if (category) {
      result.push({
        id: 'category',
        name: `Catégorie: ${category.name}`
      });
    }
  }
  
  if (filters.value.minRating) {
    result.push({
      id: 'rating',
      name: `Note: ${filters.value.minRating}+ étoiles`
    });
  }
  
  if (searchQuery.value) {
    result.push({
      id: 'search',
      name: `Recherche: ${searchQuery.value}`
    });
  }
  
  return result;
});

const filteredExperts = computed(() => {
  return experts.value;
});

// Méthodes
const fetchExperts = async () => {
  isLoading.value = true;
  error.value = null;
  
  try {
    // Construire la requête de base
    let query = supabase
      .from('profiles')
      .select(`
        id,
        first_name,
        last_name,
        avatar_url,
        bio,
        created_at,
        is_expert,
         profession:profession_id (
              name
            )
        user_skills (
          skills (
            id,
            name,
            profession_id,
            professions:profession_id (
              name
            )
          )
        )
      `)
      .eq('is_expert', true)
      .range((currentPage.value - 1) * pageSize, currentPage.value * pageSize - 1);
    
    // Appliquer les filtres
    if (searchQuery.value) {
      query = query.or(`first_name.ilike.%${searchQuery.value}%,last_name.ilike.%${searchQuery.value}%`);
    }
    
    if (filters.value.categoryId) {
      // Cette requête est plus complexe et nécessiterait une jointure ou une sous-requête
      // Pour simplifier, nous filtrerons les résultats côté client
    }
    
    // Exécuter la requête
    const { data, error: fetchError } = await query;
    
    if (fetchError) throw fetchError;
    
    // Transformer les données pour faciliter l'affichage
    const transformedExperts = data.map(expert => {
      // Extraire les compétences et catégories uniques
      const skills = [];
      const professions = new Set();
      
      if (expert.user_skills) {
        expert.user_skills.forEach(userSkill => {
          if (userSkill.skills) {
            skills.push(userSkill.skills.name);
            
            if (userSkill.skills.professions) {
              professions.add(userSkill.skills.professions.name);
            }
          }
        });
      }
      
      return {
        ...expert,
        skills,
        professions: Array.from(professions),
        average_rating: 4.5, // Valeur fictive pour l'exemple
        review_count: 12 // Valeur fictive pour l'exemple
      };
    });
    
    // Filtrer par catégorie côté client si nécessaire
    let filteredResults = transformedExperts;
    if (filters.value.categoryId) {
      const categoryId = parseInt(filters.value.categoryId);
      filteredResults = transformedExperts.filter(expert => {
        return expert.user_skills && expert.user_skills.some(userSkill => 
          userSkill.skills && userSkill.skills.profession_id === categoryId
        );
      });
    }
    
    if (currentPage.value === 1) {
      experts.value = filteredResults;
    } else {
      experts.value = [...experts.value, ...filteredResults];
    }
    
    // Vérifier s'il y a plus d'experts à charger
    const { count, error: countError } = await supabase
      .from('profiles')
      .select('*', { count: 'exact', head: true })
      .eq('is_expert', true);
    
    if (countError) throw countError;
    
    hasMoreExperts.value = count > currentPage.value * pageSize;
    
  } catch (err) {
    console.error('Error fetching experts:', err);
    error.value = "Une erreur est survenue lors du chargement des experts. Veuillez réessayer.";
  } finally {
    isLoading.value = false;
  }
};

const fetchCategories = async () => {
  try {
    const { data, error } = await supabase
      .from('professions')
      .select('*')
      .order('name');
    
    if (error) throw error;
    
    professions.value = data;
  } catch (err) {
    console.error('Error fetching professions:', err);
  }
};

const loadMoreExperts = () => {
  currentPage.value++;
  fetchExperts();
};

const applyFilters = () => {
  currentPage.value = 1;
  fetchExperts();
};

const removeFilter = (filter) => {
  if (filter.id === 'category') {
    filters.value.categoryId = '';
  } else if (filter.id === 'rating') {
    filters.value.minRating = '';
  } else if (filter.id === 'search') {
    searchQuery.value = '';
  }
  
  applyFilters();
};

const clearFilters = () => {
  filters.value.categoryId = '';
  filters.value.minRating = '';
  searchQuery.value = '';
  
  applyFilters();
};

const formatDate = (dateString) => {
  if (!dateString) return 'Date inconnue';
  
  const date = new Date(dateString);
  const now = new Date();
  const diffTime = Math.abs(now - date);
  const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
  
  if (diffDays <= 30) {
    return 'Nouveau';
  } else {
    return `Membre depuis ${date.toLocaleDateString('fr-FR', { month: 'long', year: 'numeric' })}`;
  }
};

const getInitials = (firstName, lastName) => {
  if (!firstName && !lastName) return '';
  if (!firstName) return lastName.charAt(0).toUpperCase();
  if (!lastName) return firstName.charAt(0).toUpperCase();
  
  return `${firstName.charAt(0)}${lastName.charAt(0)}`.toUpperCase();
};

const formatPrice = (price) => {
  return new Intl.NumberFormat('fr-FR', {
    style: 'currency',
    currency: 'EUR'
  }).format(price)
}

// Lifecycle hooks
onMounted(async () => {
  await Promise.all([
    fetchExperts(),
    fetchCategories()
  ]);
});

// Watch for search query changes
watch(searchQuery, () => {
  if (searchQuery.value === '') {
    applyFilters();
  }
});
</script>

<style scoped>
.line-clamp-2 {
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

/* Hide scrollbars but keep functionality */
.scrollbar-hide::-webkit-scrollbar {
  display: none;
}

.scrollbar-hide {
  -ms-overflow-style: none;
  scrollbar-width: none;
}

/* Animation for dropdown */
@keyframes slideDown {
  from { 
    opacity: 0;
    transform: translateY(-10px);
  }
  to { 
    opacity: 1;
    transform: translateY(0);
  }
}

.animate-slide-down {
  animation: slideDown 0.2s ease-out forwards;
}

@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

.animate-fade-in {
  animation: fadeIn 0.15s ease-out forwards;
}

/* Smooth transition effects */
button, a, .transition-colors {
  transition: all 0.2s ease;
}
</style>