<template>
  <div class="max-w-6xl mx-auto px-4 py-12">
    <div class="flex items-center justify-between mb-8">
      <div>
        <h1 class="text-2xl font-bold text-gray-900">Demandes de services</h1>
        <p class="mt-1 text-gray-600">Trouvez des opportunités qui correspondent à vos compétences</p>
      </div>
      
      <button 
        @click="showNewRequestModal = true"
        class="flex items-center gap-2 px-5 py-2.5 bg-primary-600 text-white rounded-full hover:bg-primary-700 transition-colors"
      >
        <PlusCircle class="w-5 h-5" />
        <span>Nouvelle demande</span>
      </button>
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
            placeholder="Rechercher une demande..."
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
          <!-- Catégories de services -->
          <div>
            <h3 class="text-sm font-medium text-gray-700 mb-3">Catégories</h3>
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
          
          <!-- Statut -->
          <div>
            <h3 class="text-sm font-medium text-gray-700 mb-3">Statut</h3>
            <div class="flex flex-wrap gap-2">
              <button
                v-for="status in statusOptions"
                :key="status.value"
                @click="toggleStatusFilter(status.value)"
                class="px-3 py-1.5 rounded-full text-sm transition-colors"
                :class="selectedStatuses.includes(status.value) 
                  ? status.activeClass
                  : 'bg-gray-100 text-gray-700 hover:bg-gray-200'"
              >
                {{ status.label }}
            </button>
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
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
        <!-- Liste des demandes -->
      <div class="lg:col-span-2">
        <div v-if="filteredRequests.length === 0" class="bg-white rounded-2xl shadow-sm border border-gray-200 p-8 text-center">
          <div class="w-16 h-16 mx-auto bg-gray-100 rounded-full flex items-center justify-center">
            <Search class="w-8 h-8 text-gray-400" />
          </div>
          <h3 class="mt-4 text-lg font-medium text-gray-900">Aucune demande trouvée</h3>
          <p class="mt-2 text-gray-600">Essayez de modifier vos filtres ou revenez plus tard</p>
        </div>
        
        <div v-else class="space-y-4">
          <div 
            v-for="request in filteredRequests" 
            :key="request.id"
            class="bg-white rounded-2xl shadow-sm border border-gray-200 p-5 hover:shadow-md transition-shadow"
          >
            <!-- En-tête avec statut -->
            <div class="flex items-start justify-between">
              <div class="flex items-center gap-4">
                <div 
                  class="w-12 h-12 rounded-full flex items-center justify-center text-xl"
                  :class="getServiceColor(request.services[0])"
                >
                  {{ getServiceIcon(request.services[0]) }}
                </div>
              <div>
                  <h3 class="text-lg font-medium text-gray-900">{{ request.title }}</h3>
                  <p class="text-sm text-gray-500 flex items-center gap-1.5 mt-0.5">
                  <MapPin class="w-3.5 h-3.5" />
                  {{ request.location }}
                </p>
                </div>
              </div>
              
              <span 
                class="px-2.5 py-1 text-xs font-medium rounded-full"
                :class="getStatusClass(request.status)"
              >
                {{ getStatusLabel(request.status) }}
              </span>
            </div>
            
            <!-- Description -->
            <p class="mt-4 text-gray-600 line-clamp-2">
              {{ request.description }}
            </p>

            <!-- Services demandés -->
            <div class="mt-4 flex flex-wrap gap-2">
              <span 
                v-for="serviceId in request.services" 
                :key="serviceId"
                class="inline-flex items-center gap-1.5 px-2.5 py-1 bg-gray-50 rounded-full text-xs font-medium text-gray-700"
              >
                {{ getServiceIcon(serviceId) }}
                {{ getServiceName(serviceId) }}
              </span>
            </div>

            <!-- Informations et action -->
            <div class="mt-5 pt-4 border-t border-gray-100 flex items-center justify-between">
              <div class="flex items-center gap-4">
                <div class="flex items-center gap-1.5 text-sm text-gray-600">
                  <Calendar class="w-4 h-4 text-gray-400" />
                  {{ formatDate(request.date) }}
                </div>
                <div class="flex items-center gap-1.5 text-sm text-gray-600">
                  <Clock class="w-4 h-4 text-gray-400" />
                  {{ formatTime(request.time) }}
                </div>
              </div>
              
              <NuxtLink 
                :to="`/requests/${request.id}`"
                class="px-4 py-2 bg-primary-600 text-white text-sm rounded-full font-medium hover:bg-primary-700 transition-colors"
              >
                Voir les détails
              </NuxtLink>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Sidebar -->
      <div class="lg:col-span-1">
        <!-- Carte des demandes -->
        <div class="bg-white rounded-2xl shadow-sm border border-gray-200 overflow-hidden mb-6">
          <div class="h-48 bg-gray-200 relative">
            <!-- Placeholder pour la carte -->
            <div class="absolute inset-0 flex items-center justify-center text-gray-400">
              Carte des demandes
            </div>
          </div>
          <div class="p-4">
            <h3 class="font-medium text-gray-900">Demandes à proximité</h3>
            <p class="mt-1 text-sm text-gray-600">Visualisez les demandes autour de vous</p>
          </div>
        </div>
        
        <!-- Statistiques -->
        <div class="bg-white rounded-2xl shadow-sm border border-gray-200 p-5">
          <h3 class="font-medium text-gray-900 mb-4">Statistiques</h3>
          
          <div class="space-y-4">
            <div class="flex items-center justify-between">
              <span class="text-gray-600">Demandes actives</span>
              <span class="font-medium text-gray-900">{{ requests.length }}</span>
            </div>
            <div class="flex items-center justify-between">
              <span class="text-gray-600">Nouvelles aujourd'hui</span>
              <span class="font-medium text-gray-900">{{ getNewRequestsCount() }}</span>
            </div>
            <div class="flex items-center justify-between">
              <span class="text-gray-600">Taux de réponse</span>
              <span class="font-medium text-gray-900">87%</span>
            </div>
          </div>
          
          <div class="mt-6 pt-4 border-t border-gray-100">
            <h4 class="text-sm font-medium text-gray-700 mb-3">Services les plus demandés</h4>
            
            <div class="space-y-2">
              <div 
                v-for="(service, index) in topServices" 
                :key="service.id"
                class="flex items-center gap-3"
              >
                <div 
                  class="w-8 h-8 rounded-full flex items-center justify-center text-sm"
                  :class="getServiceColor(service.id)"
                >
                  {{ getServiceIcon(service.id) }}
                </div>
                <div class="flex-1">
                  <div class="flex items-center justify-between">
                    <span class="text-sm text-gray-700">{{ service.name }}</span>
                    <span class="text-sm font-medium text-gray-900">{{ service.count }}</span>
                  </div>
                  <div class="w-full h-1.5 bg-gray-100 rounded-full mt-1">
                    <div 
                      class="h-full rounded-full bg-primary-600"
                      :style="`width: ${service.percentage}%`"
                    ></div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Modal pour la création d'une nouvelle demande -->
    <Dialog :open="showNewRequestModal" @close="showNewRequestModal = false" class="relative z-50">
      <div class="fixed inset-0 bg-black/30" aria-hidden="true" />

      <div class="fixed inset-0 flex items-center justify-center p-4">
        <DialogPanel class="w-full max-w-md bg-white rounded-2xl p-6 shadow-xl">
          <DialogTitle class="text-xl font-bold text-gray-900 flex items-center gap-3">
            <div class="w-10 h-10 rounded-full bg-primary-100 flex items-center justify-center">
              <PlusCircle class="w-5 h-5 text-primary-600" />
            </div>
            <span>Publier une demande</span>
          </DialogTitle>

          <!-- Informations légales -->
          <div class="mt-6 p-4 bg-gray-50 rounded-xl text-sm text-gray-600 space-y-3">
            <p class="font-medium text-gray-900">Avant de publier votre demande :</p>
            <ul class="space-y-2">
              <li class="flex items-start gap-2">
                <Check class="w-5 h-5 text-primary-600 shrink-0 mt-0.5" />
                <span>Vos informations personnelles seront visibles par les experts</span>
              </li>
              <li class="flex items-start gap-2">
                <Check class="w-5 h-5 text-primary-600 shrink-0 mt-0.5" />
                <span>Vous acceptez d'être contacté(e) par les experts intéressés</span>
              </li>
              <li class="flex items-start gap-2">
                <Check class="w-5 h-5 text-primary-600 shrink-0 mt-0.5" />
                <span>Votre demande sera publique pendant 30 jours maximum</span>
              </li>
              <li class="flex items-start gap-2">
                <Check class="w-5 h-5 text-primary-600 shrink-0 mt-0.5" />
                <span>Vous pouvez supprimer votre demande à tout moment</span>
              </li>
            </ul>
          </div>
          
          <!-- Acceptation des conditions -->
          <div class="mt-6 flex items-start gap-3">
            <input 
              type="checkbox" 
              id="terms-agreement" 
              v-model="termsAccepted"
              class="mt-1 rounded text-primary-600 focus:ring-primary-500"
            />
            <label for="terms-agreement" class="text-sm text-gray-700">
              En continuant, j'accepte les 
              <NuxtLink to="/terms" class="text-primary-600 hover:text-primary-700">
                conditions d'utilisation
              </NuxtLink>
              et la
              <NuxtLink to="/legal/privacy" class="text-primary-600 hover:text-primary-700">
                politique de confidentialité
              </NuxtLink>
            </label>
          </div>

          <!-- Actions -->
          <div class="mt-8 flex gap-3">
            <button
              @click="showNewRequestModal = false"
              class="flex-1 px-4 py-2.5 border border-gray-300 rounded-xl text-gray-700 hover:bg-gray-50 transition-colors"
            >
              Annuler
            </button>
            <button
              @click="proceedToNewRequest"
              :disabled="!termsAccepted"
              class="flex-1 px-4 py-2.5 rounded-xl transition-colors flex items-center justify-center gap-2"
              :class="termsAccepted 
                ? 'bg-primary-600 text-white hover:bg-primary-700' 
                : 'bg-gray-200 text-gray-500 cursor-not-allowed'"
            >
              <span>Continuer</span>
              <ArrowRight v-if="termsAccepted" class="w-4 h-4" />
            </button>
          </div>
        </DialogPanel>
      </div>
    </Dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { Dialog, DialogPanel, DialogTitle } from '@headlessui/vue'
import { 
  SlidersHorizontal, Search, MapPin, Calendar, Clock, Check, 
  ChevronDown, ArrowUpDown, XCircle, PlusCircle, ArrowRight 
} from 'lucide-vue-next'

// États
const showFilters = ref(false)
const showSortOptions = ref(false)
const showNewRequestModal = ref(false)
const termsAccepted = ref(false)
const searchQuery = ref('')
const locationFilter = ref('')
const selectedServices = ref<string[]>([])
const selectedStatuses = ref<string[]>([])
const sortBy = ref('date_desc')

// Services
const services = [
  { id: 'menage', name: 'Ménage', icon: '🧹', color: 'bg-blue-100' },
  { id: 'jardinage', name: 'Jardinage', icon: '🌱', color: 'bg-green-100' },
  { id: 'bricolage', name: 'Bricolage', icon: '🔨', color: 'bg-amber-100' },
  { id: 'garde', name: "Garde d'enfants", icon: '👶', color: 'bg-purple-100' },
  { id: 'chauffeur', name: 'Chauffeur', icon: '🚗', color: 'bg-red-100' },
  { id: 'demenagement', name: 'Déménagement', icon: '📦', color: 'bg-orange-100' }
]

// Options de statut
const statusOptions = [
  { value: 'nouveau', label: 'Nouveau', activeClass: 'bg-green-100 text-green-800' },
  { value: 'en_cours', label: 'En cours', activeClass: 'bg-blue-100 text-blue-800' },
  { value: 'termine', label: 'Terminé', activeClass: 'bg-gray-100 text-gray-800' }
]

// Options de tri
const sortOptions = [
  { value: 'date_desc', label: 'Plus récentes' },
  { value: 'date_asc', label: 'Plus anciennes' },
  { value: 'price_desc', label: 'Prix décroissant' },
  { value: 'price_asc', label: 'Prix croissant' }
]

// Données simulées
const requests = ref([
  {
    id: 1,
    title: 'Ménage hebdomadaire',
    location: 'Cotonou, Bénin',
    services: ['menage'],
    description: 'Recherche personne pour ménage hebdomadaire d\'un appartement de 3 pièces. Tâches : nettoyage des sols, poussière, salle de bain et cuisine.',
    date: '2023-06-15',
    time: '14:00',
    status: 'nouveau'
  },
  {
    id: 2,
    title: 'Entretien de jardin',
    location: 'Abomey-Calavi, Bénin',
    services: ['jardinage'],
    description: 'Besoin d\'un jardinier pour l\'entretien mensuel d\'un jardin de 200m². Tonte de pelouse, taille des haies et désherbage.',
    date: '2023-06-12',
    time: '09:00',
    status: 'en_cours'
  },
  {
    id: 3,
    title: 'Garde d\'enfants après l\'école',
    location: 'Cotonou, Bénin',
    services: ['garde'],
    description: 'Recherche personne pour garder deux enfants (5 et 8 ans) après l\'école, de 16h à 19h, du lundi au vendredi.',
    date: '2023-06-10',
    time: '16:00',
    status: 'nouveau'
  },
  {
    id: 4,
    title: 'Réparation plomberie',
    location: 'Porto-Novo, Bénin',
    services: ['bricolage'],
    description: 'Fuite sous l\'évier de la cuisine à réparer rapidement. Disponibilité immédiate souhaitée.',
    date: '2023-06-08',
    time: '10:00',
    status: 'termine'
  },
  {
    id: 5,
    title: 'Déménagement studio',
    location: 'Cotonou, Bénin',
    services: ['demenagement'],
    description: 'Aide pour déménager un studio au 2ème étage vers un appartement au rez-de-chaussée, à 5km de distance.',
    date: '2023-06-20',
    time: '08:00',
    status: 'nouveau'
  }
])

// Services les plus demandés
const topServices = [
  { id: 'menage', name: 'Ménage', count: 12, percentage: 80 },
  { id: 'bricolage', name: 'Bricolage', count: 8, percentage: 53 },
  { id: 'jardinage', name: 'Jardinage', count: 5, percentage: 33 }
]

// Computed
const filteredRequests = computed(() => {
  let result = [...requests.value]
  
  // Filtre par recherche
  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase()
    result = result.filter(request => 
      request.title.toLowerCase().includes(query) || 
      request.description.toLowerCase().includes(query)
    )
  }
  
  // Filtre par services
  if (selectedServices.value.length > 0) {
    result = result.filter(request => 
      request.services.some(service => selectedServices.value.includes(service))
    )
  }
  
  // Filtre par localisation
  if (locationFilter.value) {
    const location = locationFilter.value.toLowerCase()
    result = result.filter(request => 
      request.location.toLowerCase().includes(location)
    )
  }
  
  // Filtre par statut
  if (selectedStatuses.value.length > 0) {
    result = result.filter(request => 
      selectedStatuses.value.includes(request.status)
    )
  }
  
  // Tri
  result.sort((a, b) => {
    switch (sortBy.value) {
      case 'date_asc':
        return new Date(a.date).getTime() - new Date(b.date).getTime()
      case 'date_desc':
        return new Date(b.date).getTime() - new Date(a.date).getTime()
      // Autres options de tri à implémenter
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

const toggleStatusFilter = (status: string) => {
  const index = selectedStatuses.value.indexOf(status)
  if (index === -1) {
    selectedStatuses.value.push(status)
  } else {
    selectedStatuses.value.splice(index, 1)
  }
}

const selectSortOption = (option: string) => {
  sortBy.value = option
  showSortOptions.value = false
}

const resetFilters = () => {
  searchQuery.value = ''
  locationFilter.value = ''
  selectedServices.value = []
  selectedStatuses.value = []
  sortBy.value = 'date_desc'
}

const applyFilters = () => {
  showFilters.value = false
}

const proceedToNewRequest = () => {
  if (termsAccepted.value) {
    showNewRequestModal.value = false
    navigateTo('/requests/new')
  }
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

const getServiceColor = (serviceId: string) => {
  const service = services.find(s => s.id === serviceId)
  return service ? service.color : 'bg-gray-100'
}

const getStatusClass = (status: string) => {
  const classes = {
    'nouveau': 'bg-green-100 text-green-800',
    'en_cours': 'bg-blue-100 text-blue-800',
    'termine': 'bg-gray-100 text-gray-800'
  }
  return classes[status as keyof typeof classes] || ''
}

const getStatusLabel = (status: string) => {
  const labels = {
    'nouveau': 'Nouveau',
    'en_cours': 'En cours',
    'termine': 'Terminé'
  }
  return labels[status as keyof typeof labels] || status
}

const formatDate = (dateString: string) => {
  const date = new Date(dateString)
  return date.toLocaleDateString('fr-FR', { day: 'numeric', month: 'short' })
}

const formatTime = (time: string) => {
  return time.replace(':', 'h')
}

const getNewRequestsCount = () => {
  const today = new Date()
  today.setHours(0, 0, 0, 0)
  
  return requests.value.filter(request => {
    const requestDate = new Date(request.date)
    return requestDate >= today
  }).length
}
</script> 