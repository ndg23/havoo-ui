<template>
  <div class="min-h-screen bg-gray-50">
    <!-- Header fixe avec filtres avancés uniquement -->
    <header class="fixed top-[64px] left-0 right-0 z-40 bg-white border-b border-gray-200">
      <div class="max-w-7xl mx-auto px-4 py-3">
        <!-- Boutons d'action -->
        <div class="flex items-center justify-between">
          <h1 class="text-xl font-bold text-gray-900">Experts</h1>
          
          <div class="flex items-center gap-2">
            <button
              @click="showFilters = !showFilters"
              class="p-2.5 rounded-full bg-gray-100 text-gray-600 hover:bg-gray-200 relative"
              title="Filtres avancés"
            >
              <SlidersHorizontal class="w-5 h-5" />
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
              <Repeat class="w-5 h-5" />
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
                <Star class="w-4 h-4 text-yellow-400" />
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
    <div class="pt-[120px] pb-20 lg:pb-8">
      <div class="max-w-4xl mx-auto px-4">
        <!-- Services en sticky -->
        <div class="sticky top-[120px] bg-white z-30 -mx-4 px-4 py-3 border-b border-gray-100">
          <div class="flex gap-2 overflow-x-auto scrollbar-hide">
            <button
              @click="selectedService = null"
              class="flex items-center gap-2 px-4 py-2 rounded-full whitespace-nowrap transition-colors"
              :class="!selectedService ? 'bg-primary-50 text-primary-600 font-medium' : 'bg-gray-100 text-gray-600 hover:bg-gray-200'"
            >
              <Sparkles class="w-4 h-4" />
              <span>Pour vous</span>
            </button>

            <button
              v-for="service in services"
              :key="service.id"
              @click="selectService(service.id)"
              class="flex items-center gap-2 px-4 py-2 rounded-full whitespace-nowrap transition-colors"
              :class="selectedService === service.id ? 'bg-primary-50 text-primary-600 font-medium' : 'bg-gray-100 text-gray-600 hover:bg-gray-200'"
            >
              <span>{{ service.icon }}</span>
              <span>{{ service.name }}</span>
            </button>
          </div>
        </div>

        <!-- Feed des experts -->
        <div class="mt-4 space-y-3">
          <div 
            v-for="expert in filteredExperts" 
            :key="expert.id"
            class="bg-white hover:bg-gray-50 transition-colors cursor-pointer"
            @click="viewProfile(expert.id)"
          >
            <div class="flex gap-4 p-4 border border-gray-200 rounded-xl">
              <!-- Image -->
              <div class="relative shrink-0">
                <div class="w-32 h-32 rounded-lg overflow-hidden bg-gray-100">
                  <img 
                    :src="expert.avatar" 
                    :alt="expert.name"
                    class="w-full h-full object-cover"
                  />
                </div>
                <div 
                  v-if="expert.verified"
                  class="absolute top-2 right-2 w-6 h-6 rounded-full bg-primary-500 flex items-center justify-center"
                >
                  <CheckCircle class="w-4 h-4 text-white" />
                </div>
              </div>

              <!-- Informations -->
              <div class="flex-1 min-w-0">
                <!-- En-tête -->
                <div class="flex items-start justify-between gap-4">
                  <div>
                    <h3 class="font-semibold text-gray-900 truncate">
                      {{ expert.name }}
                    </h3>
                    <p class="text-sm text-gray-500 flex items-center gap-1 mt-0.5">
                      <MapPin class="w-3.5 h-3.5" />
                      {{ expert.city }}
                    </p>
                  </div>
                  <button 
                    @click.stop="toggleFavorite(expert.id)"
                    class="p-2 rounded-full hover:bg-gray-100 transition-colors"
                  >
                    <Heart 
                      class="w-5 h-5" 
                      :class="favorites.has(expert.id) ? 'fill-red-500 text-red-500' : 'text-gray-400'" 
                    />
                  </button>
                </div>

                <!-- Services -->
                <div class="mt-2 flex flex-wrap gap-1">
                  <span 
                    v-for="serviceId in expert.services.slice(0, 2)" 
                    :key="serviceId"
                    class="inline-flex items-center gap-1 px-2 py-0.5 bg-gray-50 rounded-md text-xs text-gray-600"
                  >
                    {{ services.find(s => s.id === serviceId)?.icon }}
                    {{ services.find(s => s.id === serviceId)?.name }}
                  </span>
                  <span 
                    v-if="expert.services.length > 2"
                    class="inline-flex items-center px-2 py-0.5 bg-gray-50 rounded-md text-xs text-gray-500"
                  >
                    +{{ expert.services.length - 2 }}
                  </span>
                </div>

                <!-- Description -->
                <p class="mt-2 text-sm text-gray-600 line-clamp-2">
                  {{ expert.description }}
                </p>

                <!-- Footer -->
                <div class="mt-3 flex items-center justify-between">
                  <div class="flex items-center gap-4">
                    <div class="flex items-center gap-1">
                      <Star class="w-4 h-4 text-yellow-400 fill-current" />
                      <span class="text-sm font-medium text-gray-900">{{ expert.rating }}</span>
                      <span class="text-xs text-gray-500">({{ expert.reviewsCount }})</span>
                    </div>
                    <div class="flex flex-wrap items-center gap-2">
                      <Calendar class="w-4 h-4 text-gray-400" />
                      <div class="flex gap-1">
                        <span 
                          v-for="day in expert.availability" 
                          :key="day"
                          class="text-xs px-2 py-0.5 bg-gray-100 text-gray-600 rounded-full"
                        >
                          {{ day.slice(0, 3) }}
                        </span>
                      </div>
                    </div>
                  </div>
                  <button
                    @click.stop="contactExpert(expert.id)"
                    class="px-4 py-1.5 bg-primary-600 text-white text-sm rounded-lg font-medium hover:bg-primary-700 transition-colors"
                  >
                    Contacter
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Bottom Navigation Mobile -->
    <div class="fixed bottom-0 left-0 right-0 bg-white border-t border-gray-200 lg:hidden">
      <div class="flex items-center justify-around">
        <button
          @click="selectedService = null"
          class="flex flex-col items-center py-3 px-5 text-gray-700"
          :class="!selectedService && 'text-primary-600'"
        >
          <Sparkles class="w-6 h-6" />
          <span class="text-xs mt-1">Pour vous</span>
        </button>

        <button
          @click="showFilters = !showFilters"
          class="flex flex-col items-center py-3 px-5 text-gray-700 relative"
          :class="showFilters && 'text-primary-600'"
        >
          <SlidersHorizontal class="w-6 h-6" />
          <span class="text-xs mt-1">Filtres</span>
          <span 
            v-if="activeFiltersCount" 
            class="absolute -top-1 right-3 w-5 h-5 rounded-full bg-primary-500 text-white text-xs flex items-center justify-center"
          >
            {{ activeFiltersCount }}
          </span>
        </button>

        <button
          @click="showFavoritesOnly = !showFavoritesOnly"
          class="flex flex-col items-center py-3 px-5"
          :class="showFavoritesOnly ? 'text-primary-600' : 'text-gray-700'"
        >
          <Heart class="w-6 h-6" :class="showFavoritesOnly && 'fill-current'" />
          <span class="text-xs mt-1">Favoris</span>
        </button>

        <button
          @click="showServices = !showServices"
          class="flex flex-col items-center py-3 px-5 text-gray-700"
          :class="showServices && 'text-primary-600'"
        >
          <Grid class="w-6 h-6" />
          <span class="text-xs mt-1">Services</span>
        </button>
      </div>
    </div>

    <!-- Modal Services (Mobile) -->
    <TransitionRoot appear :show="showServices" as="template">
      <Dialog as="div" @close="showServices = false" class="relative z-50">
        <TransitionChild
          enter="duration-300 ease-out"
          enter-from="opacity-0"
          enter-to="opacity-100"
          leave="duration-200 ease-in"
          leave-from="opacity-100"
          leave-to="opacity-0"
        >
          <div class="fixed inset-0 bg-black/25" />
        </TransitionChild>

        <div class="fixed inset-0">
          <div class="flex min-h-full items-end justify-center">
            <TransitionChild
              enter="duration-300 ease-out"
              enter-from="opacity-0 translate-y-4"
              enter-to="opacity-100 translate-y-0"
              leave="duration-200 ease-in"
              leave-from="opacity-100 translate-y-0"
              leave-to="opacity-0 translate-y-4"
            >
              <DialogPanel class="w-full max-w-md transform overflow-hidden rounded-t-2xl bg-white p-6">
                <h3 class="text-lg font-bold text-gray-900 mb-4">Services</h3>
                <div class="grid grid-cols-2 gap-3">
                  <button
                    v-for="service in services"
                    :key="service.id"
                    @click="selectServiceMobile(service.id)"
                    class="flex items-center gap-3 p-4 rounded-xl border-2 transition-all"
                    :class="selectedService === service.id 
                      ? 'border-primary-500 bg-primary-50 text-primary-600' 
                      : 'border-gray-200 hover:border-gray-300'"
                  >
                    <span class="text-2xl">{{ service.icon }}</span>
                    <span class="font-medium">{{ service.name }}</span>
                  </button>
                </div>
              </DialogPanel>
            </TransitionChild>
          </div>
        </div>
      </Dialog>
    </TransitionRoot>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { 
  Star,
  User,
  ChevronUp,
  ChevronDown,
  Repeat,
  SlidersHorizontal,
  Heart,
  Sparkles,
  Sliders,
  ChevronRight,
  Languages,
  Calendar,
  MapPin,
  MessageCircle,
  Grid,
  CheckCircle
} from 'lucide-vue-next'
import { Dialog, DialogPanel, TransitionRoot, TransitionChild } from '@headlessui/vue'

const selectedService = ref(null)
const currentIndex = ref(0)
const loading = ref(true)
const feedContainer = ref(null)
const showServices = ref(false)

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
    languages: ['Français', 'Anglais'],
    verified: true
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
    languages: ['Français'],
    verified: true
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
    languages: ['Français', 'Espagnol'],
    verified: true
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
    languages: ['Français', 'Arabe'],
    verified: true
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
    languages: ['Français', 'Anglais'],
    verified: true
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
    languages: ['Français'],
    verified: true
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
    languages: ['Français', 'Arabe'],
    verified: true
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
    languages: ['Français', 'Anglais'],
    verified: true
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

const selectServiceMobile = (serviceId) => {
  selectedService.value = serviceId
  showServices.value = false
}

const formatAvailability = (days) => {
  return days.map(day => day.slice(0, 3)).join(', ')
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