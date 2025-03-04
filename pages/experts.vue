<template>
  <div class="min-h-screen bg-gray-50">
    <!-- Header fixe -->
    <header class="fixed top-0 left-0 right-0 z-50 bg-white border-b border-gray-200">
      <div class="max-w-7xl mx-auto px-4 py-3">
        <!-- Filtres principaux -->
        <div class="flex items-center gap-4 mb-3">
          <h1 class="text-xl font-bold text-gray-900">Experts</h1>
          
          <div class="flex-1 flex gap-3 overflow-x-auto scrollbar-hide">
            <button
              @click="selectedService = null"
              class="shrink-0 px-4 py-2 rounded-full text-sm font-medium transition-all"
              :class="!selectedService ? 'bg-primary-500 text-white' : 'bg-gray-100 text-gray-600 hover:bg-gray-200'"
            >
              Pour vous
            </button>
            <button
              v-for="service in services"
              :key="service.id"
              @click="selectService(service.id)"
              class="shrink-0 px-4 py-2 rounded-full text-sm font-medium transition-all flex items-center gap-2"
              :class="selectedService === service.id ? 'bg-primary-500 text-white' : 'bg-gray-100 text-gray-600 hover:bg-gray-200'"
            >
              <span>{{ service.icon }}</span>
              <span>{{ service.name }}</span>
            </button>
          </div>

          <!-- Boutons d'action -->
          <div class="flex items-center gap-2">
            <button
              @click="showFilters = !showFilters"
              class="p-2.5 rounded-full bg-gray-100 text-gray-600 hover:bg-gray-200 relative"
              title="Filtres avancés"
            >
              <FunnelIcon class="w-5 h-5" />
              <span v-if="activeFiltersCount" 
                class="absolute -top-1 -right-1 w-5 h-5 rounded-full bg-primary-500 text-white text-xs flex items-center justify-center">
                {{ activeFiltersCount }}
              </span>
            </button>
            <button
              @click="shuffleExperts"
              class="p-2.5 rounded-full bg-gray-100 text-gray-600 hover:bg-gray-200"
              title="Mélanger"
            >
              <ArrowPathIcon class="w-5 h-5" />
            </button>
            <button
              @click="toggleFavoritesOnly"
              class="p-2.5 rounded-full transition-colors"
              :class="showFavoritesOnly ? 'bg-primary-500 text-white' : 'bg-gray-100 text-gray-600 hover:bg-gray-200'"
              title="Favoris uniquement"
            >
              <HeartIcon class="w-5 h-5" />
            </button>
          </div>
        </div>

        <!-- Filtres avancés -->
        <div v-if="showFilters" 
          class="py-4 space-y-4 animate-slideDown"
        >
          <!-- Disponibilités -->
          <div>
            <h3 class="text-sm font-medium text-gray-700 mb-2">Disponibilités</h3>
            <div class="flex flex-wrap gap-2">
              <button
                v-for="day in ['Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi']"
                :key="day"
                @click="toggleDayFilter(day)"
                class="px-3 py-1 rounded-full text-sm transition-colors"
                :class="filters.days.includes(day) ? 'bg-primary-500 text-white' : 'bg-gray-100 text-gray-600 hover:bg-gray-200'"
              >
                {{ day }}
              </button>
            </div>
          </div>

          <!-- Note minimum -->
          <div>
            <h3 class="text-sm font-medium text-gray-700 mb-2">Note minimum</h3>
            <div class="flex items-center gap-2">
              <input
                v-model="filters.minRating"
                type="range"
                min="0"
                max="5"
                step="0.5"
                class="w-48"
              />
              <span class="flex items-center gap-1 text-sm text-gray-600">
                <StarIcon class="w-4 h-4 text-yellow-400" />
                {{ filters.minRating }}
              </span>
            </div>
          </div>

          <!-- Langues -->
          <div>
            <h3 class="text-sm font-medium text-gray-700 mb-2">Langues parlées</h3>
            <div class="flex flex-wrap gap-2">
              <button
                v-for="lang in ['Français', 'Anglais', 'Arabe', 'Espagnol']"
                :key="lang"
                @click="toggleLanguageFilter(lang)"
                class="px-3 py-1 rounded-full text-sm transition-colors"
                :class="filters.languages.includes(lang) ? 'bg-primary-500 text-white' : 'bg-gray-100 text-gray-600 hover:bg-gray-200'"
              >
                {{ lang }}
              </button>
            </div>
          </div>
        </div>
      </div>
    </header>

    <!-- Layout principal -->
    <div class="pt-[88px] pb-8">
      <div class="max-w-7xl mx-auto px-4 flex gap-8">
        <!-- Sidebar fixe gauche -->
        <div class="w-80 sticky top-20 self-start hidden lg:block">
          <div class="bg-white rounded-xl border border-gray-200 p-4">
            <h2 class="font-medium text-gray-900 mb-4">Services populaires</h2>
            <div class="space-y-2">
              <button
                v-for="service in services"
                :key="service.id"
                @click="selectService(service.id)"
                class="w-full flex items-center gap-3 p-2 rounded-lg hover:bg-gray-50 transition-colors"
                :class="selectedService === service.id ? 'bg-primary-50 text-primary-600' : 'text-gray-600'"
              >
                <span class="text-2xl">{{ service.icon }}</span>
                <div class="text-left">
                  <div class="font-medium">{{ service.name }}</div>
                  <div class="text-sm text-gray-500">{{ service.price }}</div>
                </div>
              </button>
            </div>
          </div>
        </div>

        <!-- Feed central défilant -->
        <div class="flex-1 max-w-2xl">
          <!-- Skeleton loader -->
          <div v-if="loading" class="space-y-6">
            <div v-for="i in 3" :key="i" class="animate-pulse">
              <!-- ... skeleton content ... -->
            </div>
          </div>

          <!-- Liste des experts -->
          <div v-else class="space-y-6">
            <div 
              v-for="expert in filteredExperts" 
              :key="expert.id"
              class="bg-white rounded-xl border border-gray-200 overflow-hidden"
            >
              <div class="relative">
                <img 
                  :src="expert.avatar" 
                  class="w-full h-64 object-cover"
                  alt=""
                />
                
                <!-- Info overlay -->
                <div class="absolute bottom-0 left-0 right-0 p-4 bg-gradient-to-t from-black/60 to-transparent">
                  <div class="flex items-start justify-between">
                    <div>
                      <h3 class="text-xl font-bold text-white">{{ expert.name }}</h3>
                      <p class="text-white/90">{{ expert.services.map(s => getServiceName(s)).join(' • ') }}</p>
                    </div>
                    <div class="flex items-center gap-1 px-3 py-1.5 rounded-full bg-black/30 backdrop-blur-sm">
                      <StarIcon class="w-4 h-4 text-yellow-400" />
                      <span class="font-medium text-white">{{ expert.rating }}</span>
                    </div>
                  </div>
                </div>
              </div>

              <div class="p-6 space-y-4">
                <p class="text-gray-600">{{ expert.description }}</p>
                
                <!-- Tags -->
                <div class="flex flex-wrap gap-2">
                  <span 
                    v-for="tag in expert.tags"
                    :key="tag"
                    class="px-3 py-1 rounded-full text-xs font-medium bg-gray-100 text-gray-600"
                  >
                    {{ tag }}
                  </span>
                </div>

                <!-- Disponibilités -->
                <div class="space-y-2">
                  <h4 class="text-sm font-medium text-gray-900">Disponibilités</h4>
                  <div class="flex flex-wrap gap-2">
                    <span 
                      v-for="day in expert.availability"
                      :key="day"
                      class="px-3 py-1 rounded-full text-xs bg-primary-50 text-primary-600"
                    >
                      {{ day }}
                    </span>
                  </div>
                </div>

                <!-- Actions -->
                <div class="flex gap-3 pt-2">
                  <button
                    @click="contactExpert(expert.id)"
                    class="flex-1 py-3 rounded-xl bg-primary-500 text-white font-medium hover:bg-primary-600 transition-all"
                  >
                    Contacter
                  </button>
                  <button
                    @click="viewProfile(expert.id)"
                    class="w-12 h-12 rounded-xl border border-gray-200 flex items-center justify-center text-gray-600 hover:bg-gray-50"
                  >
                    <UserIcon class="w-5 h-5" />
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Sidebar fixe droite -->
        <div class="w-80 sticky top-20 self-start hidden lg:block">
          <div class="bg-white rounded-xl border border-gray-200 p-4">
            <h2 class="font-medium text-gray-900 mb-4">Experts recommandés</h2>
            <div class="space-y-4">
              <div 
                v-for="expert in experts.slice(0, 3)" 
                :key="expert.id"
                class="flex items-center gap-3"
              >
                <img 
                  :src="expert.avatar" 
                  class="w-12 h-12 rounded-full object-cover"
                  alt=""
                />
                <div>
                  <div class="font-medium text-gray-900">{{ expert.name }}</div>
                  <div class="text-sm text-gray-500">{{ expert.services.map(s => getServiceName(s)).join(', ') }}</div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { 
  StarIcon, 
  UserIcon, 
  ChevronUpIcon, 
  ChevronDownIcon,
  ArrowPathIcon,
  FunnelIcon,
  HeartIcon
} from '@heroicons/vue/24/solid'

const selectedService = ref(null)
const currentIndex = ref(0)
const loading = ref(true)
const feedContainer = ref(null)

const services = ref([
  { id: 'menage', name: 'Ménage', icon: '🧹', price: 'Dès 500 FCFA' },
  { id: 'jardinage', name: 'Jardinage', icon: '🌱', price: 'Dès 1000 FCFA' },
  { id: 'bricolage', name: 'Bricolage', icon: '��', price: 'Dès 1500 FCFA' },
  { id: 'garde', name: "Garde d'enfants", icon: '👶', price: 'Dès 800 FCFA' }
])

const experts = ref([
  {
    id: 1,
    name: 'Sophie Martin',
    avatar: 'https://randomuser.me/api/portraits/women/1.jpg',
    services: ['menage', 'garde'],
    rating: 4.8,
    reviewsCount: 124,
    description: 'Experte en ménage et garde d\'enfants avec 5 ans d\'expérience. Disponible en semaine et week-end.',
    tags: ['Ponctuelle', 'Organisée', 'Douce avec les enfants'],
    availability: ['Lundi', 'Mercredi', 'Vendredi'],
    languages: ['Français', 'Anglais']
  },
  {
    id: 2,
    name: 'Jean Dupont',
    avatar: 'https://randomuser.me/api/portraits/men/1.jpg',
    services: ['bricolage', 'jardinage'],
    rating: 4.9,
    reviewsCount: 89,
    description: 'Bricoleur professionnel, spécialisé dans la rénovation et l\'entretien des jardins.',
    tags: ['Professionnel', 'Outillé', 'Expérimenté'],
    availability: ['Mardi', 'Jeudi', 'Samedi'],
    languages: ['Français']
  },
  {
    id: 3,
    name: 'Marie Dubois',
    avatar: 'https://randomuser.me/api/portraits/women/2.jpg',
    services: ['menage', 'garde'],
    rating: 4.7,
    reviewsCount: 56,
    description: 'Aide ménagère professionnelle, attentionnée avec les enfants et les animaux.',
    tags: ['Méticuleuse', 'Fiable', 'Dynamique'],
    availability: ['Lundi', 'Mardi', 'Mercredi'],
    languages: ['Français', 'Espagnol']
  },
  {
    id: 4,
    name: 'Ahmed Benhadi',
    avatar: 'https://randomuser.me/api/portraits/men/2.jpg',
    services: ['jardinage', 'bricolage'],
    rating: 5.0,
    reviewsCount: 73,
    description: 'Jardinier passionné, expert en aménagement paysager et petit bricolage.',
    tags: ['Créatif', 'Minutieux', 'Polyvalent'],
    availability: ['Mercredi', 'Jeudi', 'Vendredi'],
    languages: ['Français', 'Arabe']
  },
  {
    id: 5,
    name: 'Claire Leroy',
    avatar: 'https://randomuser.me/api/portraits/women/3.jpg',
    services: ['garde', 'menage'],
    rating: 4.9,
    reviewsCount: 92,
    description: 'Ancienne institutrice, spécialisée dans la garde d\'enfants et l\'aide aux devoirs.',
    tags: ['Pédagogue', 'Patiente', 'Attentive'],
    availability: ['Lundi', 'Mardi', 'Mercredi'],
    languages: ['Français', 'Anglais']
  },
  {
    id: 6,
    name: 'Thomas Petit',
    avatar: 'https://randomuser.me/api/portraits/men/3.jpg',
    services: ['bricolage'],
    rating: 4.8,
    reviewsCount: 45,
    description: 'Artisan bricoleur, spécialisé dans la réparation et l\'installation.',
    tags: ['Précis', 'Rapide', 'Professionnel'],
    availability: ['Jeudi', 'Vendredi', 'Samedi'],
    languages: ['Français']
  },
  {
    id: 7,
    name: 'Fatima Alami',
    avatar: 'https://randomuser.me/api/portraits/women/4.jpg',
    services: ['menage', 'garde'],
    rating: 4.7,
    reviewsCount: 68,
    description: 'Aide à domicile expérimentée, disponible pour ménage et garde d\'enfants.',
    tags: ['Organisée', 'Flexible', 'Consciencieuse'],
    availability: ['Mardi', 'Jeudi', 'Samedi'],
    languages: ['Français', 'Arabe']
  },
  {
    id: 8,
    name: 'Pierre Moreau',
    avatar: 'https://randomuser.me/api/portraits/men/4.jpg',
    services: ['jardinage'],
    rating: 4.9,
    reviewsCount: 34,
    description: 'Paysagiste de formation, passionné par l\'entretien des espaces verts.',
    tags: ['Expert', 'Passionné', 'Créatif'],
    availability: ['Lundi', 'Mercredi', 'Vendredi'],
    languages: ['Français', 'Anglais']
  }
])

// États des filtres
const showFilters = ref(false)
const showFavoritesOnly = ref(false)
const filters = ref({
  days: [],
  languages: [],
  minRating: 4,
})

// Favoris
const favorites = ref(new Set())

// Computed
const activeFiltersCount = computed(() => {
  return filters.value.days.length + 
         filters.value.languages.length + 
         (filters.value.minRating > 0 ? 1 : 0)
})

const filteredExperts = computed(() => {
  let result = experts.value

  // Filtre par service
  if (selectedService.value) {
    result = result.filter(expert => 
      expert.services.includes(selectedService.value)
    )
  }

  // Filtre par disponibilité
  if (filters.value.days.length) {
    result = result.filter(expert => 
      filters.value.days.some(day => expert.availability.includes(day))
    )
  }

  // Filtre par langue
  if (filters.value.languages.length) {
    result = result.filter(expert => 
      filters.value.languages.some(lang => expert.languages.includes(lang))
    )
  }

  // Filtre par note minimum
  if (filters.value.minRating > 0) {
    result = result.filter(expert => expert.rating >= filters.value.minRating)
  }

  // Filtre favoris
  if (showFavoritesOnly.value) {
    result = result.filter(expert => favorites.value.has(expert.id))
  }

  return result
})

const swipeExperts = computed(() => {
  return experts.value.slice(currentIndex.value, currentIndex.value + 3)
})

const selectService = (serviceId) => {
  selectedService.value = serviceId
}

const nextExpert = () => {
  if (currentIndex.value < experts.value.length - 1) {
    currentIndex.value++
  }
}

const likeExpert = (expertId) => {
  // Logique pour liker/contacter l'expert
  nextExpert()
}

const getServiceName = (serviceId) => {
  return services.value.find(s => s.id === serviceId)?.name
}

const contactExpert = (id) => {
  // logique de contact
}

const viewProfile = (id) => {
  // logique de visualisation
}

// Fonction de mélange aléatoire
const shuffleExperts = () => {
  experts.value = [...experts.value].sort(() => Math.random() - 0.5)
}

// Navigation avec les flèches du clavier
onMounted(() => {
  loading.value = false // Simuler le chargement
  
  window.addEventListener('keydown', (e) => {
    const currentIndex = Math.floor(feedContainer.value.scrollTop / window.innerHeight)
    
    if (e.key === 'ArrowUp' && currentIndex > 0) {
      scrollToCard(currentIndex - 1)
    } else if (e.key === 'ArrowDown' && currentIndex < filteredExperts.value.length - 1) {
      scrollToCard(currentIndex + 1)
    }
  })
})

const scrollToCard = (index) => {
  feedContainer.value.scrollTo({
    top: index * window.innerHeight,
    behavior: 'smooth'
  })
}

// Ajout de la gestion du scroll
const handleScroll = () => {
  if (!feedContainer.value) return
  const index = Math.round(feedContainer.value.scrollTop / window.innerHeight)
  currentIndex.value = index
}

// Méthodes
const toggleDayFilter = (day) => {
  const index = filters.value.days.indexOf(day)
  if (index === -1) {
    filters.value.days.push(day)
  } else {
    filters.value.days.splice(index, 1)
  }
}

const toggleLanguageFilter = (lang) => {
  const index = filters.value.languages.indexOf(lang)
  if (index === -1) {
    filters.value.languages.push(lang)
  } else {
    filters.value.languages.splice(index, 1)
  }
}

const toggleFavoritesOnly = () => {
  showFavoritesOnly.value = !showFavoritesOnly.value
}

const toggleFavorite = (expertId) => {
  if (favorites.value.has(expertId)) {
    favorites.value.delete(expertId)
  } else {
    favorites.value.add(expertId)
  }
}
</script>

<style scoped>
.scrollbar-hide {
  -ms-overflow-style: none;
  scrollbar-width: none;
}
.scrollbar-hide::-webkit-scrollbar {
  display: none;
}

@keyframes pulse {
  0%, 100% { opacity: 1 }
  50% { opacity: .5 }
}
.animate-pulse {
  animation: pulse 2s cubic-bezier(0.4, 0, 0.6, 1) infinite;
}

/* Transitions douces */
.transition-all {
  transition-property: all;
  transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
  transition-duration: 300ms;
}

.animate-slideDown {
  animation: slideDown 0.2s ease-out;
}

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
</style> 