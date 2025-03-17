<template>
  <div class="max-w-4xl mx-auto px-4 py-6 bg-white">
    <div class="flex justify-between items-center mb-5">
      <h1 class="text-xl font-bold text-gray-900">Services disponibles</h1>
      
      <!-- Create service button for experts -->
      <NuxtLink 
        v-if="isExpert"
        to="/account/services/new" 
        class="px-4 py-2 bg-primary-600 text-white rounded-full text-sm font-medium shadow-sm hover:bg-primary-700"
      >
        Créer un service
      </NuxtLink>
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

    <!-- Filters -->
    <div class="bg-white rounded-xl border border-gray-200 mb-5 shadow-sm">
      <div class="p-4">
        <div class="flex flex-wrap gap-3 mb-3">
          <!-- Price filter -->
          <div class="relative">
            <select 
              v-model="filters.price" 
              class="pl-3 pr-8 py-2 rounded-full border border-gray-300 bg-white text-sm"
            >
              <option value="">Prix</option>
              <option value="0-50">Moins de 50€</option>
              <option value="50-100">50€ - 100€</option>
              <option value="100-200">100€ - 200€</option>
              <option value="200+">Plus de 200€</option>
            </select>
          </div>
          
          <!-- Delivery time filter -->
          <div class="relative">
            <select 
              v-model="filters.deliveryTime" 
              class="pl-3 pr-8 py-2 rounded-full border border-gray-300 bg-white text-sm"
            >
              <option value="">Délai</option>
              <option value="1-2">1-2 jours</option>
              <option value="3-5">3-5 jours</option>
              <option value="6-10">6-10 jours</option>
              <option value="10+">Plus de 10 jours</option>
            </select>
          </div>
          
          <!-- Category filter -->
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
        </div>
        
        <!-- Search and skills -->
        <div class="flex flex-col sm:flex-row gap-3">
          <div class="relative flex-grow">
            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
              <svg class="h-4 w-4 text-gray-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                <path fill-rule="evenodd" d="M8 4a4 4 0 100 8 4 4 0 000-8zM2 8a6 6 0 1110.89 3.476l4.817 4.817a1 1 0 01-1.414 1.414l-4.816-4.816A6 6 0 012 8z" clip-rule="evenodd" />
              </svg>
            </div>
            <input 
              v-model="searchQuery" 
              type="text" 
              placeholder="Rechercher un service..." 
              class="w-full pl-10 pr-3 py-2 rounded-full border border-gray-300 bg-white text-sm"
            />
          </div>
          
          <!-- Skills filter -->
          <div class="relative" data-skills-dropdown>
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
    </div>

    <!-- Loading state -->
    <div v-if="isLoading" class="py-10 flex justify-center">
      <svg class="animate-spin h-6 w-6 text-primary-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
      </svg>
    </div>

    <!-- Empty state -->
    <div v-else-if="filteredServices.length === 0" class="bg-white rounded-xl border border-gray-200 p-8 text-center shadow-sm">
      <div class="mx-auto flex items-center justify-center h-12 w-12 rounded-full bg-gray-100 mb-4">
        <svg class="h-6 w-6 text-gray-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
        </svg>
      </div>
      <h3 class="text-lg font-medium text-gray-900 mb-1">Aucun service trouvé</h3>
      <p class="text-gray-500">
        Essayez d'ajuster vos filtres ou votre recherche
      </p>
    </div>
    
    <!-- Services grid -->
    <div v-else class="grid grid-cols-1 md:grid-cols-2 gap-4">
      <div 
        v-for="service in filteredServices" 
        :key="service.id"
        class="bg-white border border-gray-200 rounded-xl overflow-hidden shadow-sm hover:shadow-md transition-shadow"
      >
        <!-- Service card -->
        <div>
          <!-- Cover image -->
          <img 
            :src="service.cover_image || '/images/default-service.jpg'" 
            :alt="service.title" 
            class="w-full h-40 object-cover"
          />
          
          <!-- Content -->
          <div class="p-4">
            <!-- Category and price -->
            <div class="flex justify-between items-center mb-2">
              <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-blue-100 text-blue-800">
                {{ service.category_name }}
              </span>
              <span class="font-medium text-gray-900">{{ service.formatted_price }}</span>
            </div>
            
            <!-- Title -->
            <h3 class="font-medium text-gray-900 mb-1">{{ service.title }}</h3>
            
            <!-- Description -->
            <p class="text-sm text-gray-500 mb-3 line-clamp-2">{{ service.description }}</p>
            
            <!-- Expert details -->
            <div class="flex items-center justify-between">
              <div class="flex items-center">
                <img 
                  :src="service.expert_avatar || '/images/default-avatar.png'" 
                  :alt="service.expert_name" 
                  class="h-8 w-8 rounded-full object-cover border border-gray-200"
                />
                <div class="ml-2">
                  <div class="text-sm font-medium text-gray-900">{{ service.expert_name }}</div>
                  <!-- Rating -->
                  <div class="flex items-center">
                    <div class="flex items-center">
                      <svg class="h-3 w-3 text-yellow-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                        <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
                      </svg>
                      <span class="ml-1 text-xs text-gray-500">{{ service.expert_rating }}</span>
                    </div>
                  </div>
                </div>
              </div>
              
              <!-- View button -->
              <NuxtLink 
                :to="`/services/${service.id}`"
                class="px-3 py-1 text-xs rounded-full bg-gray-100 text-gray-800 hover:bg-gray-200"
              >
                Voir
              </NuxtLink>
            </div>
          </div>
        </div>
      </div>
    </div>
    
    <!-- Load more -->
    <div v-if="hasMoreServices && !isLoading" class="mt-6 flex justify-center">
      <button 
        @click="loadMoreServices" 
        class="px-4 py-2 text-sm text-primary-600 hover:text-primary-700 flex items-center"
      >
        Voir plus de services
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
const {profile} = useProfile()

// User
const isExpert = computed(() => profile.isExpert)

// States
const isLoading = ref(true)
const services = ref([])
const categories = ref([])
const skills = ref([])
const searchQuery = ref('')
const hasMoreServices = ref(false)
const currentPage = ref(1)
const pageSize = 12

// Filters
const filters = reactive({
  price: '',
  deliveryTime: '',
  categoryId: ''
})
const skillSearchQuery = ref('')
const selectedSkillFilters = ref([])
const showSkillsDropdown = ref(false)

// Computed
const filteredServices = computed(() => {
  let result = [...services.value]
  
  // Search
  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase()
    result = result.filter(service => 
      service.title.toLowerCase().includes(query) || 
      service.description.toLowerCase().includes(query)
    )
  }
  
  // Price filter
  if (filters.price) {
    const [min, max] = filters.price.split('-')
    if (max === '+') {
      result = result.filter(service => service.price >= parseInt(min))
    } else {
      result = result.filter(service => 
        service.price >= parseInt(min) && 
        (max ? service.price <= parseInt(max) : true)
      )
    }
  }
  
  // Delivery time filter
  if (filters.deliveryTime) {
    const [min, max] = filters.deliveryTime.split('-')
    if (max === '+') {
      result = result.filter(service => service.delivery_time >= parseInt(min))
    } else {
      result = result.filter(service => 
        service.delivery_time >= parseInt(min) && 
        (max ? service.delivery_time <= parseInt(max) : true)
      )
    }
  }
  
  // Category filter
  if (filters.categoryId) {
    result = result.filter(service => service.category_id === filters.categoryId)
  }
  
  // Skills filter
  if (selectedSkillFilters.value.length > 0) {
    result = result.filter(service => {
      // Check if any of the selected skills exist in this service's skills
      return selectedSkillFilters.value.some(selectedSkill => 
        service.skills.some(serviceSkill => serviceSkill.id === selectedSkill.id)
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
  
  // Price filter
  if (filters.price) {
    let label
    if (filters.price === '0-50') label = 'Moins de 50€'
    else if (filters.price === '50-100') label = '50€ - 100€'
    else if (filters.price === '100-200') label = '100€ - 200€'
    else if (filters.price === '200+') label = 'Plus de 200€'
    
    result.push({ id: 'price', name: label })
  }
  
  // Delivery time filter
  if (filters.deliveryTime) {
    let label
    if (filters.deliveryTime === '1-2') label = '1-2 jours'
    else if (filters.deliveryTime === '3-5') label = '3-5 jours'
    else if (filters.deliveryTime === '6-10') label = '6-10 jours'
    else if (filters.deliveryTime === '10+') label = 'Plus de 10 jours'
    
    result.push({ id: 'delivery', name: label })
  }
  
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
const fetchServices = async () => {
  isLoading.value = true
  
  try {
    let query = supabase
      .from('services')
      .select(`
        id, 
        title, 
        description, 
        price, 
        delivery_time,
        cover_image,
        created_at,
        category_id,
        categories(name),
        service_skills(skills(id, name)),
        expert_id,
        profiles(first_name, last_name, avatar_url, reviews(rating))
      `)
      .eq('status', 'active')
      .order('created_at', { ascending: false })
      .range((currentPage.value - 1) * pageSize, currentPage.value * pageSize)
    
    const { data, error } = await query
    
    if (error) throw error
    
    // Format services
    services.value = data.map(service => {
      // Calculate expert's average rating
      let avgRating = 0
      if (service.profiles.reviews && service.profiles.reviews.length > 0) {
        avgRating = service.profiles.reviews.reduce((acc, review) => acc + review.rating, 0) / service.profiles.reviews.length
      }
      
      return {
        id: service.id,
        title: service.title,
        description: service.description,
        price: service.price,
        delivery_time: service.delivery_time,
        cover_image: service.cover_image,
        created_at: service.created_at,
        category_id: service.category_id,
        category_name: service.categories?.name || 'Non catégorisé',
        skills: service.service_skills.map(ss => ss.skills),
        expert_id: service.expert_id,
        expert_name: `${service.profiles.first_name} ${service.profiles.last_name}`,
        expert_avatar: service.profiles.avatar_url,
        expert_rating: avgRating ? avgRating.toFixed(1) : '0.0',
        formatted_price: new Intl.NumberFormat('fr-FR', { style: 'currency', currency: 'EUR' }).format(service.price)
      }
    })
    
    // Check for more services
    const { count } = await supabase
      .from('services')
      .select('*', { count: 'exact', head: true })
      .eq('status', 'active')
    
    hasMoreServices.value = count > currentPage.value * pageSize
    
  } catch (error) {
    console.error('Error fetching services:', error)
    toast.error('Erreur lors du chargement des services')
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

const loadMoreServices = async () => {
  if (!hasMoreServices.value) return
  
  currentPage.value++
  await fetchServices()
}

const removeFilter = (filter) => {
  if (filter.id === 'price') {
    filters.price = ''
  } else if (filter.id === 'delivery') {
    filters.deliveryTime = ''
  } else if (filter.id === 'category') {
    filters.categoryId = ''
  } else if (filter.skillId) {
    selectedSkillFilters.value = selectedSkillFilters.value.filter(
      skill => skill.id !== filter.skillId
    )
  }
}

const clearFilters = () => {
  filters.price = ''
  filters.deliveryTime = ''
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
    fetchServices(),
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