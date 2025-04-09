<template>
  <div class="max-w-6xl mx-auto px-4 py-12">
    <div class="flex items-center justify-between mb-8">
      <div>
        <h1 class="text-2xl font-bold text-gray-900">Nos experts</h1>
        <p class="mt-1 text-gray-600">Trouvez le professionnel idéal pour vos besoins</p>
      </div>
      
      <NuxtLink 
        to="/auth/register-expert"
        class="flex items-center gap-2 px-5 py-2.5 bg-primary-600 text-white rounded-full hover:bg-primary-700 transition-colors"
      >
        <UserPlus class="w-5 h-5" />
        <span>Devenir expert</span>
      </NuxtLink>
    </div>
    
    <!-- Filtres et recherche -->
    <div class="bg-white rounded-2xl shadow-sm border border-gray-200 p-6 mb-8">
      <div class="flex flex-wrap items-center gap-4">
        <!-- Recherche -->
        <div class="relative flex-1 min-w-[240px]">
          <Search class="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" />
          <input 
            type="text"
            v-model="searchQuery"
            placeholder="Rechercher un expert..."
            class="w-full pl-10 pr-4 py-2.5 rounded-xl border border-gray-200 focus:border-primary-500 focus:ring-primary-500"
          />
        </div>
        
        <!-- Filtres -->
        <div class="flex items-center gap-3">
          <button 
            @click="showFilters = !showFilters"
            class="flex items-center gap-2 px-4 py-2.5 border border-gray-200 rounded-xl hover:bg-gray-50 transition-colors"
          >
            <SlidersHorizontal class="w-5 h-5 text-gray-500" />
            <span class="text-gray-700">Filtres</span>
            <ChevronDown 
              class="w-4 h-4 text-gray-500 transition-transform" 
              :class="showFilters ? 'rotate-180' : ''"
            />
          </button>
          
          <!-- Tri -->
          <div class="relative">
            <button
              @click="showSortOptions = !showSortOptions"
              class="flex items-center gap-2 px-4 py-2.5 border border-gray-200 rounded-xl hover:bg-gray-50 transition-colors"
            >
              <ArrowUpDown class="w-5 h-5 text-gray-500" />
              <span class="text-gray-700">Trier par</span>
              <ChevronDown 
                class="w-4 h-4 text-gray-500 transition-transform" 
                :class="showSortOptions ? 'rotate-180' : ''"
              />
            </button>
            
            <!-- Options de tri -->
            <div 
              v-if="showSortOptions" 
              class="absolute right-0 mt-2 w-48 bg-white rounded-xl shadow-lg border border-gray-200 py-2 z-10"
            >
              <button 
                v-for="option in sortOptions" 
                :key="option.value"
                @click="selectSortOption(option.value)"
                class="w-full px-4 py-2 text-left hover:bg-gray-50 flex items-center gap-2"
                :class="sortBy === option.value ? 'text-primary-600 font-medium' : 'text-gray-700'"
              >
                <Check v-if="sortBy === option.value" class="w-4 h-4" />
                <div v-else class="w-4"></div>
                {{ option.label }}
            </button>
            </div>
          </div>
          </div>
        </div>

      <!-- Filtres étendus -->
      <div v-if="showFilters" class="mt-6 pt-6 border-t border-gray-200">
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
          <!-- Spécialités -->
          <div>
            <h3 class="text-sm font-medium text-gray-700 mb-3">Spécialités</h3>
            <div class="flex flex-wrap gap-2">
              <button
                v-for="service in services"
                :key="service.id"
                @click="toggleServiceFilter(service.id)"
                class="flex items-center gap-1.5 px-3 py-1.5 rounded-full text-sm transition-colors"
                :class="selectedServices.includes(service.id) 
                  ? 'bg-primary-100 text-primary-700 border border-primary-200' 
                  : 'bg-gray-100 text-gray-700 border border-gray-200 hover:bg-gray-200'"
              >
                <span>{{ service.icon }}</span>
                {{ service.name }}
                <XCircle 
                  v-if="selectedServices.includes(service.id)"
                  @click.stop="toggleServiceFilter(service.id)"
                  class="w-4 h-4 text-primary-500 hover:text-primary-700" 
                />
              </button>
            </div>
          </div>

          <!-- Localisation -->
          <div>
            <h3 class="text-sm font-medium text-gray-700 mb-3">Localisation</h3>
            <div class="relative">
              <MapPin class="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" />
              <input
                type="text"
                v-model="locationFilter"
                placeholder="Ville ou quartier..."
                class="w-full pl-10 pr-4 py-2 rounded-xl border border-gray-200 focus:border-primary-500 focus:ring-primary-500"
              />
            </div>
          </div>

          <!-- Évaluation -->
          <div>
            <h3 class="text-sm font-medium text-gray-700 mb-3">Évaluation minimum</h3>
            <div class="flex items-center gap-2">
              <button
                v-for="rating in [1, 2, 3, 4, 5]"
                :key="rating"
                @click="setMinRating(rating)"
                class="flex items-center justify-center w-10 h-10 rounded-full transition-colors"
                :class="minRating >= rating 
                  ? 'bg-amber-100 text-amber-600' 
                  : 'bg-gray-100 text-gray-400 hover:bg-gray-200'"
              >
                <Star class="w-5 h-5" :fill="minRating >= rating ? 'currentColor' : 'none'" />
              </button>
              <span class="ml-2 text-sm text-gray-700">
                {{ minRating }} étoile{{ minRating > 1 ? 's' : '' }} ou plus
              </span>
            </div>
          </div>
        </div>
        
        <!-- Actions des filtres -->
        <div class="flex justify-end mt-6">
            <button
            @click="resetFilters"
            class="px-4 py-2 text-gray-600 hover:text-gray-900"
            >
            Réinitialiser
            </button>
            <button
            @click="applyFilters"
            class="ml-3 px-4 py-2 bg-primary-600 text-white rounded-lg hover:bg-primary-700"
          >
            Appliquer
            </button>
        </div>
          </div>
        </div>

    <!-- Contenu principal -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          <div 
            v-for="expert in filteredExperts" 
            :key="expert.id"
        class="bg-white rounded-2xl shadow-sm border border-gray-200 overflow-hidden hover:shadow-md transition-shadow"
      >
        <!-- Bannière et photo de profil -->
        <div class="relative h-32 bg-gradient-to-r from-primary-600 to-primary-400">
          <div class="absolute -bottom-10 left-6">
            <div class="w-20 h-20 rounded-full border-4 border-white bg-white overflow-hidden">
              <img 
                :src="expert.avatar || 'https://via.placeholder.com/80'" 
                    :alt="expert.name"
                    class="w-full h-full object-cover"
                  />
                </div>
                </div>
              </div>

        <!-- Informations de l'expert -->
        <div class="pt-12 px-6 pb-6">
          <div class="flex items-start justify-between">
                  <div>
              <h3 class="text-lg font-medium text-gray-900">{{ expert.name }}</h3>
                    <p class="text-sm text-gray-500 flex items-center gap-1 mt-0.5">
                      <MapPin class="w-3.5 h-3.5" />
                {{ expert.location }}
                    </p>
                  </div>
            
            <!-- Évaluation -->
            <div class="flex items-center gap-1">
              <Star class="w-4 h-4 text-amber-500" fill="currentColor" />
              <span class="text-sm font-medium text-gray-700">{{ expert.rating }}</span>
              <span class="text-xs text-gray-500">({{ expert.reviewCount }})</span>
            </div>
                </div>

          <!-- Spécialités -->
          <div class="mt-4 flex flex-wrap gap-1.5">
                  <span 
              v-for="serviceId in expert.services" 
                    :key="serviceId"
              class="inline-flex items-center gap-1 px-2.5 py-1 bg-gray-100 rounded-full text-xs font-medium text-gray-700"
            >
              <span>{{ getServiceIcon(serviceId) }}</span>
              {{ getServiceName(serviceId) }}
                  </span>
                </div>

          <!-- Bio -->
          <p class="mt-4 text-sm text-gray-600 line-clamp-2">
            {{ expert.bio }}
          </p>
          
          <!-- Tarifs -->
          <div class="mt-4 flex items-center justify-between">
            <div class="text-sm">
              <span class="font-medium text-gray-900">{{ expert.hourlyRate }}</span>
              <span class="text-gray-500">/heure</span>
                    </div>
            
            <!-- Actions -->
            <div class="flex gap-2">
              <button class="p-2 rounded-full text-gray-500 hover:bg-gray-100">
                <Heart class="w-5 h-5" />
              </button>
              <button class="px-4 py-1.5 bg-primary-600 text-white text-sm rounded-full font-medium hover:bg-primary-700 transition-colors">
                    Contacter
                  </button>
                </div>
              </div>
            </div>
          </div>
      
      <!-- Message si aucun expert trouvé -->
      <div 
        v-if="filteredExperts.length === 0" 
        class="col-span-full bg-white rounded-2xl shadow-sm border border-gray-200 p-8 text-center"
      >
        <div class="w-16 h-16 mx-auto bg-gray-100 rounded-full flex items-center justify-center">
          <Search class="w-8 h-8 text-gray-400" />
        </div>
        <h3 class="mt-4 text-lg font-medium text-gray-900">Aucun expert trouvé</h3>
        <p class="mt-2 text-gray-600">Essayez de modifier vos filtres ou revenez plus tard</p>
      </div>
    </div>

    <!-- Pagination -->
    <div class="mt-10 flex justify-center">
      <div class="flex items-center gap-2">
        <button class="w-10 h-10 rounded-full flex items-center justify-center border border-gray-200 text-gray-500 hover:bg-gray-50">
          <ChevronLeft class="w-5 h-5" />
        </button>
        <button
          v-for="page in 5" 
          :key="page"
          class="w-10 h-10 rounded-full flex items-center justify-center text-sm font-medium transition-colors"
          :class="currentPage === page 
            ? 'bg-primary-600 text-white' 
            : 'border border-gray-200 text-gray-700 hover:bg-gray-50'"
        >
          {{ page }}
        </button>
        <button class="w-10 h-10 rounded-full flex items-center justify-center border border-gray-200 text-gray-500 hover:bg-gray-50">
          <ChevronRight class="w-5 h-5" />
        </button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { 
  Search, SlidersHorizontal, ArrowUpDown, ChevronDown, Check, XCircle, 
  MapPin, Star, Heart, ChevronLeft, ChevronRight, UserPlus 
} from 'lucide-vue-next'

// États
const showFilters = ref(false)
const showSortOptions = ref(false)
const searchQuery = ref('')
const locationFilter = ref('')
const selectedServices = ref<string[]>([])
const minRating = ref(0)
const sortBy = ref('rating_desc')
const currentPage = ref(1)

// Options de tri
const sortOptions = [
  { label: 'Mieux notés', value: 'rating_desc' },
  { label: 'Prix croissant', value: 'price_asc' },
  { label: 'Prix décroissant', value: 'price_desc' },
  { label: 'Disponibilité', value: 'availability' }
]

// Services
const services = [
  { id: 'menage', name: 'Ménage', icon: '🧹', color: 'bg-blue-100' },
  { id: 'jardinage', name: 'Jardinage', icon: '🌱', color: 'bg-green-100' },
  { id: 'bricolage', name: 'Bricolage', icon: '🔨', color: 'bg-amber-100' },
  { id: 'garde', name: "Garde d'enfants", icon: '👶', color: 'bg-purple-100' },
  { id: 'chauffeur', name: 'Chauffeur', icon: '🚗', color: 'bg-red-100' },
  { id: 'demenagement', name: 'Déménagement', icon: '📦', color: 'bg-orange-100' },
  { id: 'coiffure', name: 'Coiffure', icon: '💇', color: 'bg-pink-100' },
  { id: 'massage', name: 'Massage', icon: '💆', color: 'bg-indigo-100' }
]

// Données simulées (à remplacer par une API)
const experts = ref([
  {
    id: 1,
    name: 'Sophie Mensah',
    avatar: 'https://randomuser.me/api/portraits/women/44.jpg',
    location: 'Cotonou, Bénin',
    services: ['menage', 'garde'],
    bio: 'Professionnelle du ménage avec 5 ans d\'expérience. Je propose des services de qualité pour particuliers et entreprises.',
    hourlyRate: '1500 FCFA',
    rating: 4.8,
    reviewCount: 27
  },
  {
    id: 2,
    name: 'Jean Kokou',
    avatar: 'https://randomuser.me/api/portraits/men/32.jpg',
    location: 'Porto-Novo, Bénin',
    services: ['bricolage', 'jardinage'],
    bio: 'Bricoleur polyvalent et jardinier passionné. Je vous aide pour tous vos travaux d\'intérieur et d\'extérieur.',
    hourlyRate: '2000 FCFA',
    rating: 4.6,
    reviewCount: 18
  },
  {
    id: 3,
    name: 'Amina Diallo',
    avatar: 'https://randomuser.me/api/portraits/women/65.jpg',
    location: 'Cotonou, Bénin',
    services: ['garde', 'menage'],
    bio: 'Éducatrice spécialisée, je propose des services de garde d\'enfants avec activités éducatives et ludiques.',
    hourlyRate: '1800 FCFA',
    rating: 4.9,
    reviewCount: 32
  },
  {
    id: 4,
    name: 'Paul Agossou',
    avatar: 'https://randomuser.me/api/portraits/men/22.jpg',
    location: 'Cotonou, Bénin',
    services: ['chauffeur', 'demenagement'],
    bio: 'Chauffeur professionnel avec permis toutes catégories. Disponible pour trajets réguliers ou ponctuels.',
    hourlyRate: '2500 FCFA',
    rating: 4.7,
    reviewCount: 15
  },
  {
    id: 5,
    name: 'Fatou Sow',
    avatar: 'https://randomuser.me/api/portraits/women/28.jpg',
    location: 'Parakou, Bénin',
    services: ['coiffure', 'massage'],
    bio: 'Coiffeuse et esthéticienne à domicile. Je vous propose des soins personnalisés pour votre bien-être.',
    hourlyRate: '3000 FCFA',
    rating: 4.5,
    reviewCount: 23
  },
  {
    id: 6,
    name: 'Ibrahim Ouedraogo',
    avatar: 'https://randomuser.me/api/portraits/men/55.jpg',
    location: 'Cotonou, Bénin',
    services: ['bricolage', 'demenagement'],
    bio: 'Expert en rénovation et aménagement intérieur. Je réalise tous vos projets de A à Z.',
    hourlyRate: '2200 FCFA',
    rating: 4.4,
    reviewCount: 19
  }
])

// Computed
const filteredExperts = computed(() => {
  let result = [...experts.value]

  // Filtre par recherche
  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase()
    result = result.filter(expert => 
      expert.name.toLowerCase().includes(query) || 
      expert.bio.toLowerCase().includes(query)
    )
  }

  // Filtre par services
  if (selectedServices.value.length > 0) {
    result = result.filter(expert => 
      expert.services.some(service => selectedServices.value.includes(service))
    )
  }

  // Filtre par localisation
  if (locationFilter.value) {
    const location = locationFilter.value.toLowerCase()
    result = result.filter(expert => 
      expert.location.toLowerCase().includes(location)
    )
  }
  
  // Filtre par évaluation minimum
  if (minRating.value > 0) {
    result = result.filter(expert => expert.rating >= minRating.value)
  }
  
  // Tri
  result.sort((a, b) => {
    switch (sortBy.value) {
      case 'rating_desc':
        return b.rating - a.rating
      case 'price_asc':
        return parseInt(a.hourlyRate) - parseInt(b.hourlyRate)
      case 'price_desc'   :
        return parseInt(b.hourlyRate) - parseInt(a.hourlyRate)
      default:
        return 0
    }
  })

  return result
})

// Méthodes
const toggleServiceFilter = (serviceId: string) => {
  const index = selectedServices.value.indexOf(serviceId)
  if (index === -1) {
    selectedServices.value.push(serviceId)
  } else {
    selectedServices.value.splice(index, 1)
  }
}

const setMinRating = (rating: number) => {
  minRating.value = rating === minRating.value ? 0 : rating
}

const selectSortOption = (option: string) => {
  sortBy.value = option
  showSortOptions.value = false
}

const resetFilters = () => {
  searchQuery.value = ''
  locationFilter.value = ''
  selectedServices.value = []
  minRating.value = 0
  sortBy.value = 'rating_desc'
}

const applyFilters = () => {
  showFilters.value = false
}

// Helpers
const getServiceName = (serviceId: string) => {
  const service = services.find(s => s.id === serviceId)
  return service ? service.name : 'Service'
}

const getServiceIcon = (serviceId: string) => {
  const service = services.find(s => s.id === serviceId)
  return service ? service.icon : '📋'
}
</script>