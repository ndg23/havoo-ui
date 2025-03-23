<template>
  <div class="max-w-4xl mx-auto px-4 py-6 bg-white">
    <div class="flex justify-between items-center mb-5">
      <h1 class="text-xl font-bold text-gray-900">Trouver un expert</h1>
    </div>

    <!-- Filtres et recherche -->
    <div class="bg-white rounded-xl border border-gray-200 mb-5 shadow-sm">
      <div class="p-4">
        <div class="flex flex-wrap gap-3 mb-3">
          <!-- Recherche par nom -->
          <div class="relative flex-grow">
            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
              <svg class="h-5 w-5 text-gray-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                <path fill-rule="evenodd" d="M8 4a4 4 0 100 8 4 4 0 000-8zM2 8a6 6 0 1110.89 3.476l4.817 4.817a1 1 0 01-1.414 1.414l-4.816-4.816A6 6 0 012 8z" clip-rule="evenodd" />
              </svg>
            </div>
            <input
              v-model="searchQuery"
              type="text"
              placeholder="Rechercher un expert..."
              class="block w-full pl-10 pr-3 py-2 border border-gray-300 rounded-full focus:ring-primary-500 focus:border-primary-500"
            />
          </div>
          
          <!-- Filtre par catégorie -->
          <div class="relative">
            <select
              v-model="filters.categoryId"
              class="pl-3 pr-8 py-2 rounded-full border border-gray-300 bg-white text-sm"
            >
              <option value="">Catégorie</option>
              <option v-for="category in categories" :key="category.id" :value="category.id">
                {{ category.name }}
              </option>
            </select>
          </div>
          
          <!-- Filtre par note -->
          <div class="relative">
            <select
              v-model="filters.minRating"
              class="pl-3 pr-8 py-2 rounded-full border border-gray-300 bg-white text-sm"
            >
              <option value="">Note</option>
              <option value="5">5 étoiles</option>
              <option value="4">4+ étoiles</option>
              <option value="3">3+ étoiles</option>
            </select>
          </div>
          
          <!-- Bouton de recherche -->
          <button
            @click="applyFilters"
            class="px-4 py-2 bg-primary-600 text-white rounded-full text-sm font-medium shadow-sm hover:bg-primary-700"
          >
            Rechercher
          </button>
        </div>
        
        <!-- Filtres actifs -->
        <div v-if="activeFilters.length > 0" class="flex items-center flex-wrap gap-2">
          <div class="text-sm text-gray-500 mr-1">Filtres actifs:</div>
          <span 
            v-for="filter in activeFilters" 
            :key="filter.id"
            class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-primary-100 text-primary-800"
          >
            {{ filter.name }}
            <button 
              @click="removeFilter(filter)"
              class="ml-1.5 h-4 w-4 rounded-full inline-flex items-center justify-center text-primary-600 hover:bg-primary-200"
            >
              <svg class="h-3 w-3" fill="currentColor" viewBox="0 0 20 20">
                <path d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd"></path>
              </svg>
            </button>
          </span>
          <button 
            @click="clearFilters"
            class="text-xs text-gray-500 hover:text-gray-700 ml-1"
          >
            Effacer tous
          </button>
        </div>
      </div>
    </div>

    <!-- État de chargement -->
    <div v-if="isLoading" class="flex justify-center items-center py-12">
      <div class="animate-spin rounded-full h-10 w-10 border-b-2 border-primary-600"></div>
    </div>
    
    <!-- Message d'erreur -->
    <div v-else-if="error" class="bg-red-50 p-4 rounded-lg text-red-700 my-6">
      <div class="flex">
        <svg class="h-5 w-5 text-red-400 mr-3" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
        </svg>
        <p>{{ error }}</p>
      </div>
      <button 
        @click="fetchExperts" 
        class="mt-3 text-sm font-medium text-red-600 hover:text-red-500"
      >
        Réessayer
      </button>
    </div>
    
    <!-- Aucun résultat -->
    <div v-else-if="filteredExperts.length === 0" class="text-center py-12">
      <svg class="mx-auto h-12 w-12 text-gray-300" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M15.75 6a3.75 3.75 0 11-7.5 0 3.75 3.75 0 017.5 0zM4.501 20.118a7.5 7.5 0 0114.998 0A17.933 17.933 0 0112 21.75c-2.676 0-5.216-.584-7.499-1.632z" />
      </svg>
      <h3 class="mt-2 text-sm font-medium text-gray-900">Aucun expert trouvé</h3>
      <p class="mt-1 text-sm text-gray-500">
        Essayez de modifier vos filtres ou revenez plus tard.
      </p>
    </div>
    
    <!-- Liste des experts (style horizontal) -->
    <div v-else class="grid grid-cols-1 gap-4">
      <NuxtLink 
        v-for="expert in filteredExperts" 
        :key="expert.id"
        :to="`/experts/${expert.id}`"
        class="bg-white rounded-lg shadow overflow-hidden hover:shadow-md transition-shadow duration-200"
      >
        <div class="p-5">
          <div class="flex items-start">
            <div class="flex-shrink-0 mr-4">
              <div v-if="expert.avatar_url" class="h-16 w-16 rounded-full overflow-hidden">
                <img :src="expert.avatar_url" alt="Avatar" class="h-full w-full object-cover" />
              </div>
              <div v-else class="h-16 w-16 rounded-full bg-gray-200 flex items-center justify-center text-gray-600 text-xl font-medium">
                {{ getInitials(expert.first_name, expert.last_name) }}
              </div>
            </div>
            
            <div class="flex-1">
              <div class="flex items-center justify-between mb-2">
                <div>
                  <h3 class="text-lg font-medium text-gray-900">
                    {{ expert.first_name }} {{ expert.last_name }}
                  </h3>
                  <div class="flex items-center mt-1">
                    <div class="flex items-center">
                      <svg class="w-4 h-4 text-yellow-400" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg">
                        <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
                      </svg>
                      <span class="ml-1 text-sm text-gray-500">{{ expert.average_rating || 'Nouveau' }}</span>
                      <span v-if="expert.review_count" class="ml-1 text-sm text-gray-500">({{ expert.review_count }})</span>
                    </div>
                    <span class="mx-2 text-gray-300">•</span>
                    <span class="text-sm text-gray-500">{{ formatDate(expert.created_at) }}</span>
                  </div>
                </div>
              </div>
              
              <p v-if="expert.bio" class="text-sm text-gray-600 mb-3 line-clamp-2">{{ expert.bio }}</p>
              <p v-else class="text-sm text-gray-500 italic mb-3">Aucune biographie disponible</p>
              
              <div class="flex flex-wrap gap-2 mb-2">
                <span 
                  v-for="(category, index) in expert.categories" 
                  :key="index"
                  class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-800"
                >
                  {{ category }}
                </span>
                <span 
                  v-for="(skill, index) in expert.skills.slice(0, 3)" 
                  :key="`skill-${index}`"
                  class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-primary-100 text-primary-800"
                >
                  {{ skill }}
                </span>
                <span 
                  v-if="expert.skills.length > 3" 
                  class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-600"
                >
                  +{{ expert.skills.length - 3 }}
                </span>
              </div>
            </div>
            
            <div class="flex-shrink-0 ml-4 flex flex-col items-end justify-between h-full">
              <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-green-100 text-green-800">
                Disponible
              </span>
              <div class="mt-auto">
                <span class="inline-flex items-center text-xs font-medium text-primary-600">
                  Voir le profil
                  <svg class="ml-1 w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
                  </svg>
                </span>
              </div>
            </div>
          </div>
        </div>
      </NuxtLink>
    </div>
    
    <!-- Pagination -->
    <div v-if="hasMoreExperts && !isLoading" class="mt-6 text-center">
      <button 
        @click="loadMoreExperts" 
        class="inline-flex items-center px-4 py-2 border border-gray-300 shadow-sm text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50"
      >
        Charger plus d'experts
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue';
import { useSupabaseClient } from '#imports';

const supabase = useSupabaseClient();

// État
const isLoading = ref(true);
const error = ref(null);
const experts = ref([]);
const categories = ref([]);
const searchQuery = ref('');
const filters = ref({
  categoryId: '',
  minRating: ''
});
const currentPage = ref(1);
const pageSize = 10;
const hasMoreExperts = ref(false);

// Computed
const activeFilters = computed(() => {
  const result = [];
  
  if (filters.value.categoryId) {
    const category = categories.value.find(c => c.id === parseInt(filters.value.categoryId));
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
        user_skills (
          skills (
            id,
            name,
            category_id,
            categories:category_id (
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
      const categories = new Set();
      
      if (expert.user_skills) {
        expert.user_skills.forEach(userSkill => {
          if (userSkill.skills) {
            skills.push(userSkill.skills.name);
            
            if (userSkill.skills.categories) {
              categories.add(userSkill.skills.categories.name);
            }
          }
        });
      }
      
      return {
        ...expert,
        skills,
        categories: Array.from(categories),
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
          userSkill.skills && userSkill.skills.category_id === categoryId
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
      .from('categories')
      .select('*')
      .order('name');
    
    if (error) throw error;
    
    categories.value = data;
  } catch (err) {
    console.error('Error fetching categories:', err);
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
</style>