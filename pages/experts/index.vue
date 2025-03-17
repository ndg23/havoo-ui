<template>
  <div class="max-w-4xl mx-auto px-4 py-6 bg-white">
    <div class="flex justify-between items-center mb-5">
      <h1 class="text-xl font-bold text-gray-900">Trouver un expert</h1>
    </div>

    <!-- Active filters display -->
    <div v-if="activeFilters.length > 0" class="mb-4">
      <div class="flex items-center flex-wrap gap-2">
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

    <!-- Search and filters -->
    <div class="bg-white rounded-xl border border-gray-200 mb-5 shadow-sm">
      <div class="p-4">
        <!-- Search and categories -->
        <div class="flex flex-col sm:flex-row gap-3 mb-3">
          <div class="relative flex-grow">
            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
              <svg class="h-4 w-4 text-gray-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                <path fill-rule="evenodd" d="M8 4a4 4 0 100 8 4 4 0 000-8zM2 8a6 6 0 1110.89 3.476l4.817 4.817a1 1 0 01-1.414 1.414l-4.816-4.816A6 6 0 012 8z" clip-rule="evenodd" />
              </svg>
            </div>
            <input 
              v-model="searchQuery" 
              type="text" 
              placeholder="Rechercher un expert..." 
              class="w-full pl-10 pr-3 py-2 rounded-full border border-gray-300 bg-white text-sm"
            />
          </div>
          
          <!-- Category filter -->
          <div class="relative">
            <select 
              v-model="filters.categoryId" 
              class="pl-3 pr-8 py-2 rounded-full border border-gray-300 bg-white text-sm appearance-none"
            >
              <option value="">Toutes catégories</option>
              <option v-for="category in categories" :key="category.id" :value="category.id">
                {{ category.name }}
              </option>
            </select>
            <div class="absolute inset-y-0 right-0 flex items-center pr-2 pointer-events-none">
              <svg class="h-4 w-4 text-gray-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                <path fill-rule="evenodd" d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z" clip-rule="evenodd" />
              </svg>
            </div>
          </div>
        </div>
        
        <!-- Skills filter -->
        <div class="relative" data-skills-dropdown>
          <div class="flex items-center">
            <button 
              @click="showSkillsDropdown = !showSkillsDropdown"
              class="px-4 py-2 rounded-full border border-gray-300 bg-white text-sm flex items-center"
            >
              Compétences
              <svg 
                class="ml-1 h-4 w-4 text-gray-400" 
                :class="{ 'transform rotate-180': showSkillsDropdown }"
                xmlns="http://www.w3.org/2000/svg" 
                viewBox="0 0 20 20" 
                fill="currentColor"
              >
                <path fill-rule="evenodd" d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z" clip-rule="evenodd" />
              </svg>
            </button>
            
            <!-- Selected skills display -->
            <div v-if="selectedSkillFilters.length > 0" class="ml-2 flex flex-wrap gap-1">
              <span 
                v-for="(skill, index) in selectedSkillFilters.slice(0, 2)" 
                :key="skill.id"
                class="inline-flex items-center px-2 py-0.5 rounded-full text-xs font-medium bg-primary-100 text-primary-800"
              >
                {{ skill.name }}
              </span>
              <span 
                v-if="selectedSkillFilters.length > 2" 
                class="inline-flex items-center px-2 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-700"
              >
                +{{ selectedSkillFilters.length - 2 }}
              </span>
            </div>
          </div>
          
          <!-- Skills dropdown -->
          <div 
            v-show="showSkillsDropdown" 
            class="absolute z-10 mt-1 w-64 bg-white shadow-lg rounded-lg border border-gray-200"
          >
            <div class="p-2">
              <input 
                v-model="skillSearchQuery" 
                type="text" 
                placeholder="Rechercher une compétence..."
                class="w-full px-3 py-1.5 border border-gray-300 rounded-lg text-sm bg-white"
              />
            </div>
            <div class="max-h-60 overflow-y-auto p-2">
              <div 
                v-for="skill in filteredSkills" 
                :key="skill.id"
                @click="toggleSkillFilter(skill)"
                class="flex items-center px-3 py-2 hover:bg-gray-100 rounded-lg cursor-pointer"
              >
                <input 
                  type="checkbox" 
                  :checked="selectedSkillFilters.some(s => s.id === skill.id)" 
                  class="h-4 w-4 text-primary-600 border-gray-300 rounded focus:ring-primary-500"
                />
                <span class="ml-2 text-sm">{{ skill.name }}</span>
              </div>
            </div>
            <div v-if="selectedSkillFilters.length > 0" class="p-2 flex justify-between border-t border-gray-200">
              <span class="text-xs text-gray-500">{{ selectedSkillFilters.length }} sélectionnée(s)</span>
              <button 
                @click="clearSkillFilters" 
                class="text-xs text-primary-600 hover:text-primary-700"
              >
                Effacer
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Loading state -->
    <div v-if="isLoading" class="py-10 flex justify-center">
      <svg class="animate-spin h-6 w-6 text-primary-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
      </svg>
    </div>

    <!-- Empty state -->
    <div v-else-if="filteredExperts.length === 0" class="bg-white rounded-xl border border-gray-200 p-8 text-center shadow-sm">
      <div class="mx-auto flex items-center justify-center h-12 w-12 rounded-full bg-gray-100 mb-4">
        <svg class="h-6 w-6 text-gray-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
        </svg>
      </div>
      <h3 class="text-lg font-medium text-gray-900 mb-1">Aucun expert trouvé</h3>
      <p class="text-gray-500">
        Essayez d'ajuster vos filtres ou votre recherche
      </p>
    </div>
    
    <!-- Experts grid -->
    <div v-else class="grid grid-cols-1 gap-4">
      <div 
        v-for="expert in filteredExperts" 
        :key="expert.id"
        class="bg-white border border-gray-200 rounded-xl overflow-hidden shadow-sm hover:shadow-md transition-shadow"
      >
        <!-- Expert card -->
        <div class="px-5 py-4 flex flex-col sm:flex-row sm:items-center">
          <!-- Avatar and name -->
          <div class="flex items-center mb-4 sm:mb-0">
            <img 
              :src="expert.avatar_url || '/images/default-avatar.png'" 
              :alt="expert.name" 
              class="h-12 w-12 rounded-full object-cover border border-gray-200"
            />
            <div class="ml-4">
              <div class="font-medium text-gray-900">{{ expert.name }}</div>
              <!-- Rating -->
              <div class="flex items-center mt-0.5">
                <div class="flex items-center">
                  <svg v-for="i in 5" :key="i" class="h-4 w-4" :class="i <= Math.round(expert.avg_rating) ? 'text-yellow-400' : 'text-gray-300'" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                    <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
                  </svg>
                </div>
                <span class="ml-1 text-xs text-gray-500">
                  {{ expert.avg_rating.toFixed(1) }} ({{ expert.reviews_count }} avis)
                </span>
              </div>
            </div>
          </div>
          
          <!-- Skills and category -->
          <div class="sm:ml-auto text-right flex flex-col items-start sm:items-end">
            <div class="text-sm text-gray-600 mb-1">
              {{ expert.category_name }}
            </div>
            <div class="flex flex-wrap gap-1.5 mt-1 justify-end">
              <span 
                v-for="skill in expert.skills.slice(0, 3)" 
                :key="skill.id"
                class="inline-flex items-center px-2 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-700"
              >
                {{ skill.name }}
              </span>
              <span 
                v-if="expert.skills.length > 3" 
                class="inline-flex items-center px-2 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-700"
              >
                +{{ expert.skills.length - 3 }}
              </span>
            </div>
          </div>
        </div>
        
        <!-- About and actions -->
        <div class="px-5 py-3 border-t border-gray-200">
          <p class="text-sm text-gray-600 line-clamp-2 mb-3">
            {{ expert.bio || "Cet expert n'a pas encore ajouté de bio." }}
          </p>
          
          <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-2">
            <div class="flex items-center text-gray-700">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 mr-1" viewBox="0 0 20 20" fill="currentColor">
                <path fill-rule="evenodd" d="M6 2a1 1 0 00-1 1v1H4a2 2 0 00-2 2v10a2 2 0 002 2h12a2 2 0 002-2V6a2 2 0 00-2-2h-1V3a1 1 0 10-2 0v1H7V3a1 1 0 00-1-1zm0 5a1 1 0 000 2h8a1 1 0 100-2H6z" clip-rule="evenodd" />
              </svg>
              <span class="text-xs">Membre depuis {{ formatDate(expert.created_at) }}</span>
            </div>
            
            <div class="flex gap-2">
              <NuxtLink 
                :to="`/experts/${expert.id}`"
                class="px-4 py-1.5 text-sm border border-gray-300 rounded-full hover:bg-gray-50"
              >
                Voir le profil
              </NuxtLink>
              <NuxtLink 
                :to="`/messages/new?expertId=${expert.id}`"
                class="px-4 py-1.5 text-sm bg-primary-600 text-white rounded-full hover:bg-primary-700"
              >
                Contacter
              </NuxtLink>
            </div>
          </div>
        </div>
      </div>
    </div>
    
    <!-- Load more -->
    <div v-if="hasMoreExperts && !isLoading" class="mt-6 flex justify-center">
      <button 
        @click="loadMoreExperts" 
        class="px-4 py-2 text-sm text-primary-600 hover:text-primary-700 flex items-center"
      >
        Voir plus d'experts
        <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 ml-1" viewBox="0 0 20 20" fill="currentColor">
          <path fill-rule="evenodd" d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z" clip-rule="evenodd" />
        </svg>
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, reactive, onMounted, onBeforeUnmount } from 'vue'
import { useSupabaseClient } from '#imports'
// import { useToast } from 'vue-toastification'

const supabase = useSupabaseClient()
const toast = useToast()

// States
const isLoading = ref(true)
const experts = ref([])
const categories = ref([])
const skills = ref([])
const searchQuery = ref('')
const hasMoreExperts = ref(false)
const currentPage = ref(1)
const pageSize = 12

// Filters
const filters = reactive({
  categoryId: ''
})
const skillSearchQuery = ref('')
const selectedSkillFilters = ref([])
const showSkillsDropdown = ref(false)

// Computed
const filteredExperts = computed(() => {
  let result = [...experts.value]
  
  // Search
  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase()
    result = result.filter(expert => 
      expert.name.toLowerCase().includes(query) || 
      (expert.bio && expert.bio.toLowerCase().includes(query))
    )
  }
  
  // Category filter
  if (filters.categoryId) {
    result = result.filter(expert => expert.category_id === filters.categoryId)
  }
  
  // Skills filter
  if (selectedSkillFilters.value.length > 0) {
    result = result.filter(expert => {
      // Check if any of the selected skills exist in this expert's skills
      return selectedSkillFilters.value.some(selectedSkill => 
        expert.skills.some(expertSkill => expertSkill.id === selectedSkill.id)
      )
    })
  }
  
  return result
})

const filteredSkills = computed(() => {
  if (!skillSearchQuery.value) return skills.value
  
  const query = skillSearchQuery.value.toLowerCase()
  return skills.value.filter(skill => 
    skill.name.toLowerCase().includes(query)
  )
})

const activeFilters = computed(() => {
  const result = []
  
  // Category filter
  if (filters.categoryId) {
    const category = categories.value.find(c => c.id === filters.categoryId)
    if (category) {
      result.push({ id: 'category', name: category.name })
    }
  }
  
  // Skills filters
  selectedSkillFilters.value.forEach(skill => {
    result.push({ id: `skill-${skill.id}`, name: skill.name, skillId: skill.id })
  })
  
  return result
})

// Methods
const fetchExperts = async () => {
  isLoading.value = true
  
  try {
    let query = supabase
      .from('profiles')
      .select(`
        id, 
        first_name,
        last_name,
        bio,
        avatar_url,
        created_at,
        is_expert,
        category_id,
        categories(name),
        user_skills(skills(id, name)),
        reviews(rating)
      `)
      .eq('is_expert', true)
      .order('created_at', { ascending: false })
      .range((currentPage.value - 1) * pageSize, currentPage.value * pageSize)
    
    const { data, error } = await query
    
    if (error) throw error
    
    // Format experts
    experts.value = data.map(expert => {
      // Calculate average rating
      let avgRating = 0
      if (expert.reviews && expert.reviews.length > 0) {
        avgRating = expert.reviews.reduce((acc, review) => acc + review.rating, 0) / expert.reviews.length
      }
      
      return {
        id: expert.id,
        name: `${expert.first_name} ${expert.last_name}`,
        bio: expert.bio,
        avatar_url: expert.avatar_url,
        created_at: expert.created_at,
        category_id: expert.category_id,
        category_name: expert.categories?.name || 'Non catégorisé',
        skills: expert.user_skills.map(us => us.skills),
        avg_rating: avgRating || 0,
        reviews_count: expert.reviews?.length || 0
      }
    })
    
    // Check for more experts
    const { count } = await supabase
      .from('profiles')
      .select('*', { count: 'exact', head: true })
      .eq('is_expert', true)
    
    hasMoreExperts.value = count > currentPage.value * pageSize
    
  } catch (error) {
    console.error('Error fetching experts:', error)
    toast.error('Erreur lors du chargement des experts')
  } finally {
    isLoading.value = false
  }
}

const fetchCategories = async () => {
  try {
    const { data, error } = await supabase
      .from('categories')
      .select('id, name')
      .order('name')
    
    if (error) throw error
    
    categories.value = data
  } catch (error) {
    console.error('Error fetching categories:', error)
  }
}

const fetchSkills = async () => {
  try {
    const { data, error } = await supabase
      .from('skills')
      .select('id, name')
      .order('name')
    
    if (error) throw error
    
    skills.value = data
  } catch (error) {
    console.error('Error fetching skills:', error)
  }
}

const loadMoreExperts = async () => {
  if (!hasMoreExperts.value) return
  
  currentPage.value++
  await fetchExperts()
}

const formatDate = (dateString) => {
  const date = new Date(dateString)
  return new Intl.DateTimeFormat('fr-FR', {
    month: 'long',
    year: 'numeric'
  }).format(date)
}

const removeFilter = (filter) => {
  if (filter.id === 'category') {
    filters.categoryId = ''
  } else if (filter.skillId) {
    selectedSkillFilters.value = selectedSkillFilters.value.filter(
      skill => skill.id !== filter.skillId
    )
  }
}

const clearFilters = () => {
  filters.categoryId = ''
  selectedSkillFilters.value = []
  searchQuery.value = ''
}

const toggleSkillFilter = (skill) => {
  const index = selectedSkillFilters.value.findIndex(s => s.id === skill.id)
  if (index === -1) {
    selectedSkillFilters.value.push(skill)
  } else {
    selectedSkillFilters.value.splice(index, 1)
  }
}

const clearSkillFilters = () => {
  selectedSkillFilters.value = []
}

// Click outside for dropdowns
const handleClickOutside = (event) => {
  if (showSkillsDropdown.value && !event.target.closest('[data-skills-dropdown]')) {
    showSkillsDropdown.value = false
  }
}

// Lifecycle hooks
onMounted(async () => {
  document.addEventListener('click', handleClickOutside)
  
  await Promise.all([
    fetchExperts(),
    fetchCategories(),
    fetchSkills()
  ])
})

onBeforeUnmount(() => {
  document.removeEventListener('click', handleClickOutside)
})
</script>

<style scoped>
.line-clamp-2 {
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
</style>