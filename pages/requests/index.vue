<template>
  <div class="max-w-3xl mx-auto px-4 py-12">
    <!-- En-tête -->
    <div class="flex flex-col md:flex-row justify-between items-start md:items-center gap-6 mb-8">
      <div>
        <h1 class="text-3xl font-bold text-gray-900">Demandes de services</h1>
        <p class="mt-2 text-gray-600">Trouvez des opportunités et proposez vos services</p>
      </div>
      
      <!-- Filtres et nouvelle demande -->
      <div class="flex items-center gap-3">
        <div class="relative">
          <input 
            type="text" 
            placeholder="Rechercher..." 
            class="pl-10 pr-4 py-2.5 w-64 rounded-xl border border-gray-200 focus:border-primary-300 focus:ring focus:ring-primary-200 focus:ring-opacity-50"
          />
          <Search class="w-5 h-5 text-gray-400 absolute left-3 top-1/2 transform -translate-y-1/2" />
        </div>
        
        <button 
          @click="showFilters = !showFilters"
          class="p-2.5 rounded-xl border border-gray-200 text-gray-700 hover:bg-gray-50"
        >
          <SlidersHorizontal class="w-5 h-5" />
        </button>
        
        <button 
          @click="showNewRequestModal = true"
          class="p-2.5 rounded-xl bg-primary-600 text-white hover:bg-primary-700"
        >
          <Plus class="w-5 h-5" />
        </button>
      </div>
    </div>
    
    <!-- Filtres avancés (collapsible) -->
    <div v-if="showFilters" class="bg-white rounded-2xl shadow-sm border border-gray-200 p-6 mb-8">
      <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
        <!-- Services -->
        <div>
          <h3 class="font-medium text-gray-900 mb-3">Services</h3>
          <div class="space-y-2">
            <label v-for="service in services" :key="service.id" class="flex items-center gap-2">
              <input 
                type="radio" 
                :value="service.id" 
                v-model="selectedService"
                class="text-primary-600 focus:ring-primary-500"
              />
              <span class="text-gray-700">{{ service.icon }} {{ service.name }}</span>
            </label>
            <label class="flex items-center gap-2">
              <input 
                type="radio" 
                value="" 
                v-model="selectedService"
                class="text-primary-600 focus:ring-primary-500"
              />
              <span class="text-gray-700">Tous les services</span>
            </label>
          </div>
        </div>
        
        <!-- Localisation -->
        <div>
          <h3 class="font-medium text-gray-900 mb-3">Localisation</h3>
          <select 
            v-model="selectedLocation" 
            class="w-full rounded-lg border-gray-300 focus:border-primary-300 focus:ring focus:ring-primary-200 focus:ring-opacity-50"
          >
            <option value="">Toutes les localisations</option>
            <option v-for="location in locations" :key="location" :value="location">
              {{ location }}
            </option>
          </select>
        </div>
        
        <!-- Statut -->
        <div>
          <h3 class="font-medium text-gray-900 mb-3">Statut</h3>
          <div class="space-y-2">
            <label v-for="status in statuses" :key="status.value" class="flex items-center gap-2">
              <input 
                type="radio" 
                :value="status.value" 
                v-model="selectedStatus"
                class="text-primary-600 focus:ring-primary-500"
              />
              <span class="text-gray-700">{{ status.label }}</span>
            </label>
            <label class="flex items-center gap-2">
              <input 
                type="radio" 
                value="" 
                v-model="selectedStatus"
                class="text-primary-600 focus:ring-primary-500"
              />
              <span class="text-gray-700">Tous les statuts</span>
            </label>
          </div>
        </div>
      </div>
      
      <!-- Actions -->
      <div class="flex justify-end mt-6">
        <button 
          @click="applyFilters"
          class="px-4 py-2 bg-primary-600 text-white rounded-lg hover:bg-primary-700"
        >
          Appliquer les filtres
        </button>
      </div>
    </div>
    
    <!-- Liste des demandes style CNI française -->
    <div class="space-y-4">
      <div 
        v-for="request in filteredRequests" 
        :key="request.id"
        class="bg-white rounded-xl border border-gray-200 overflow-hidden hover:shadow-md transition-shadow"
      >
        <!-- En-tête style CNI (version blanche) -->
        <div class="h-10 bg-white border-b border-gray-200 flex items-center justify-between px-4">
          <div class="flex items-center gap-2">
            <!-- Logo/Emblème République -->
            <div class="flex items-center gap-1.5">
              <span class="text-primary-600 font-semibold text-sm">№</span>
              <span class="text-gray-900 font-medium text-sm">{{ String(request.id).padStart(6, '0') }}</span>
            </div>
            <span class="text-gray-300">|</span>
            <span class="text-gray-600 text-sm">{{ formatDate(request.date) }}</span>
          </div>
          <div class="px-2 py-0.5 rounded-full text-xs font-medium"
            :class="getStatusBadgeClass(request.status)"
          >
            {{ getStatusLabel(request.status) }}
          </div>
        </div>
        
        <div class="flex">
          <!-- Partie gauche (icône) - ratio d'or: 38.2% -->
          <div class="w-[38.2%] p-4 flex flex-col items-center justify-center border-r border-gray-100">
            <!-- Icône du service -->
            <div class="w-24 h-24 rounded-full bg-gray-100 flex items-center justify-center text-4xl">
              {{ getServiceIcon(request.services[0]) }}
            </div>
            
            <!-- Informations temporelles -->
            <div class="mt-4 space-y-2 w-full">
              <div class="flex items-center gap-2 text-gray-600">
                <Calendar class="w-4 h-4" />
                <span class="text-sm">{{ formatDate(request.date) }}</span>
              </div>
              <div class="flex items-center gap-2 text-gray-600">
                <Clock class="w-4 h-4" />
                <span class="text-sm">{{ request.time }}</span>
              </div>
            </div>
          </div>
          
          <!-- Partie droite (informations) - ratio d'or: 61.8% -->
          <div class="w-[61.8%] p-4">
            <!-- En-tête -->
            <div class="border-b border-gray-100 pb-2">
              <h3 class="text-base font-bold text-gray-900">{{ request.title }}</h3>
              <div class="flex items-center gap-2 mt-1">
                <MapPin class="w-4 h-4 text-gray-400" />
                <span class="text-sm text-gray-600">{{ request.location }}</span>
              </div>
            </div>
            
            <!-- Services demandés -->
            <div class="mt-3">
              <p class="text-xs font-medium text-gray-700">Services demandés</p>
              <div class="flex flex-wrap gap-1 mt-1">
                <span 
                  v-for="serviceId in request.services" 
                  :key="serviceId"
                  class="px-1.5 py-0.5 bg-gray-100 rounded-full text-xs text-gray-700 flex items-center gap-0.5"
                >
                  <span>{{ getServiceIcon(serviceId) }}</span>
                  <span>{{ getServiceName(serviceId) }}</span>
                </span>
              </div>
            </div>
            
            <!-- Description -->
            <div class="mt-3">
              <p class="text-xs font-medium text-gray-700">Description</p>
              <p class="mt-1 text-sm text-gray-600 line-clamp-3">
                {{ request.description }}
              </p>
            </div>
            
            <!-- Actions -->
            <div class="mt-4 flex justify-end">
              <button 
                @click="proposeService(request.id)"
                class="px-3 py-1.5 bg-primary-600 text-white text-sm rounded-lg hover:bg-primary-700 transition-colors flex items-center gap-1"
              >
                <Sparkles class="w-4 h-4" />
                <span>Proposer mes services</span>
              </button>
            </div>
          </div>
        </div>
        
        <!-- Pied de carte (optionnel) -->
        <div class="px-4 py-2 bg-gray-50 border-t border-gray-200 flex justify-between items-center text-xs text-gray-500">
          <span>Havoo</span>
          <span>Valide jusqu'au {{ getExpiryDate(request.date) }}</span>
        </div>
      </div>
      
      <!-- État vide -->
      <div v-if="filteredRequests.length === 0" class="bg-white rounded-xl border border-gray-200 p-8 text-center">
        <div class="w-16 h-16 mx-auto bg-gray-100 rounded-full flex items-center justify-center">
          <Search class="w-8 h-8 text-gray-400" />
        </div>
        <h3 class="mt-4 text-lg font-medium text-gray-900">Aucune demande trouvée</h3>
        <p class="mt-2 text-gray-600">Essayez de modifier vos filtres ou revenez plus tard</p>
      </div>
    </div>
    
    <!-- Pagination -->
    <div class="mt-8 flex justify-center">
      <div class="flex items-center gap-1">
        <button class="w-8 h-8 rounded-lg border border-gray-200 flex items-center justify-center text-gray-500 hover:bg-gray-50">
          <ChevronLeft class="w-4 h-4" />
        </button>
        <button class="w-8 h-8 rounded-lg border border-gray-200 flex items-center justify-center bg-primary-50 text-primary-600 border-primary-200 font-medium">
          1
        </button>
        <button class="w-8 h-8 rounded-lg border border-gray-200 flex items-center justify-center text-gray-700 hover:bg-gray-50">
          2
        </button>
        <button class="w-8 h-8 rounded-lg border border-gray-200 flex items-center justify-center text-gray-500 hover:bg-gray-50">
          <ChevronRight class="w-4 h-4" />
        </button>
      </div>
    </div>
    
    <!-- Modal pour la création d'une nouvelle demande -->
    <Dialog :open="showNewRequestModal" @close="showNewRequestModal = false" class="relative z-50">
      <div class="fixed inset-0 bg-black/30" aria-hidden="true" />

      <div class="fixed inset-0 flex items-center justify-center p-4">
        <DialogPanel class="w-full max-w-md bg-white rounded-2xl p-6">
          <DialogTitle class="text-xl font-bold text-gray-900">
            Publier une demande
          </DialogTitle>

          <!-- Informations légales -->
          <div class="mt-4 p-4 bg-gray-50 rounded-xl text-sm text-gray-600 space-y-2">
            <p class="font-medium text-gray-900">Avant de publier votre demande :</p>
            <ul class="list-disc list-inside space-y-1">
              <li>Vos informations personnelles seront visibles par les experts</li>
              <li>Vous acceptez d'être contacté(e) par les experts intéressés</li>
              <li>Votre demande sera publique pendant 30 jours maximum</li>
              <li>Vous pouvez supprimer votre demande à tout moment</li>
            </ul>
            <p class="mt-4">
              En continuant, vous acceptez nos 
              <NuxtLink to="/terms" class="text-primary-600 hover:text-primary-700">
                conditions d'utilisation
              </NuxtLink>
              et notre
              <NuxtLink to="/privacy" class="text-primary-600 hover:text-primary-700">
                politique de confidentialité
              </NuxtLink>
            </p>
          </div>

          <!-- Actions -->
          <div class="mt-6 flex gap-3">
            <button
              @click="showNewRequestModal = false"
              class="flex-1 px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50"
            >
              Annuler
            </button>
            <button
              @click="proceedToNewRequest"
              class="flex-1 px-4 py-2 bg-primary-600 text-white rounded-lg hover:bg-primary-700"
            >
              Continuer
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
  SlidersHorizontal, Sparkles, MapPin, Calendar, Clock, 
  Search, Plus, ChevronLeft, ChevronRight
} from 'lucide-vue-next'

// États
const showFilters = ref(false)
const showNewRequestModal = ref(false)
const selectedService = ref('')
const selectedLocation = ref('')
const selectedStatus = ref('')

// Services
const services = ref([
  { id: 'menage', name: 'Ménage', icon: '🧹' },
  { id: 'jardinage', name: 'Jardinage', icon: '🌱' },
  { id: 'bricolage', name: 'Bricolage', icon: '🔨' },
  { id: 'garde', name: "Garde d'enfants", icon: '👶' }
])

// Localisations
const locations = ref([
  'Cotonou, Bénin',
  'Abidjan, Côte d\'Ivoire',
  'Lomé, Togo',
  'Dakar, Sénégal',
  'Ouagadougou, Burkina Faso'
])

// Statuts
const statuses = ref([
  { value: 'nouveau', label: 'Nouvelles demandes' },
  { value: 'en_cours', label: 'En cours' },
  { value: 'termine', label: 'Terminées' }
])

// Données simulées
const requests = ref([
  {
    id: 1,
    title: 'Ménage hebdomadaire',
    location: 'Cotonou, Bénin',
    services: ['menage'],
    description: 'Recherche personne pour ménage hebdomadaire d\'un appartement de 3 pièces. Nettoyage complet incluant sols, salle de bain, cuisine et dépoussiérage. Matériel fourni. Disponibilité souhaitée le samedi matin.',
    date: '2024-02-20',
    time: '14:00',
    status: 'nouveau'
  },
  {
    id: 2,
    title: 'Tonte de pelouse et taille de haies',
    location: 'Abidjan, Côte d\'Ivoire',
    services: ['jardinage'],
    description: 'Besoin d\'un jardinier pour tondre une pelouse de 200m² et tailler des haies sur 15 mètres linéaires. Travail régulier possible si satisfaction.',
    date: '2024-02-22',
    time: '09:00',
    status: 'nouveau'
  },
  {
    id: 3,
    title: 'Réparation robinet qui fuit',
    location: 'Lomé, Togo',
    services: ['bricolage'],
    description: 'Urgent : robinet de cuisine qui fuit. Besoin d\'un plombier pour diagnostic et réparation rapide. Disponibilité immédiate souhaitée.',
    date: '2024-02-18',
    time: '16:30',
    status: 'en_cours'
  },
  {
    id: 4,
    title: 'Garde d\'enfants après l\'école',
    location: 'Dakar, Sénégal',
    services: ['garde'],
    description: 'Recherche personne de confiance pour chercher mes deux enfants (6 et 8 ans) à l\'école et les garder jusqu\'à mon retour du travail. Aide aux devoirs souhaitée. Horaires : lundi au vendredi de 16h à 19h.',
    date: '2024-02-25',
    time: '16:00',
    status: 'nouveau'
  },
  {
    id: 5,
    title: 'Installation étagères et montage meuble',
    location: 'Ouagadougou, Burkina Faso',
    services: ['bricolage'],
    description: 'Besoin d\'aide pour installer 3 étagères murales et monter un meuble TV. Matériel de fixation fourni, prévoir perceuse et outils de base.',
    date: '2024-02-19',
    time: '10:00',
    status: 'termine'
  }
])

// Computed
const filteredRequests = computed(() => {
  let result = [...requests.value]
  
  // Filtrer par service
  if (selectedService.value) {
    result = result.filter(request => 
      request.services.includes(selectedService.value)
    )
  }
  
  // Filtrer par localisation
  if (selectedLocation.value) {
    result = result.filter(request => 
      request.location === selectedLocation.value
    )
  }
  
  // Filtrer par statut
  if (selectedStatus.value) {
    result = result.filter(request => 
      request.status === selectedStatus.value
    )
  }
  
  return result
})

// Méthodes
const applyFilters = () => {
  showFilters.value = false
}

const getServiceIcon = (serviceId: string) => {
  const service = services.value.find(s => s.id === serviceId)
  return service ? service.icon : '📋'
}

const getServiceName = (serviceId: string) => {
  const service = services.value.find(s => s.id === serviceId)
  return service ? service.name : 'Service'
}

const getStatusLabel = (status: string) => {
  const statusMap: Record<string, string> = {
    'nouveau': 'Nouvelle',
    'en_cours': 'En cours',
    'termine': 'Terminée'
  }
  return statusMap[status] || status
}

const getStatusBadgeClass = (status: string) => {
  const classMap: Record<string, string> = {
    'nouveau': 'bg-green-600 text-white',
    'en_cours': 'bg-blue-600 text-white',
    'termine': 'bg-gray-600 text-white'
  }
  return classMap[status] || 'bg-gray-600 text-white'
}

const formatDate = (dateString: string) => {
  const options: Intl.DateTimeFormatOptions = { day: 'numeric', month: 'long', year: 'numeric' }
  return new Date(dateString).toLocaleDateString('fr-FR', options)
}

const getExpiryDate = (dateString: string) => {
  const date = new Date(dateString)
  date.setDate(date.getDate() + 30)
  return date.toLocaleDateString('fr-FR', { day: 'numeric', month: 'long', year: 'numeric' })
}

const proposeService = (requestId: number) => {
  // Logique pour proposer un service
  console.log(`Proposer un service pour la demande ${requestId}`)
}

const proceedToNewRequest = () => {
  showNewRequestModal.value = false
  // Rediriger vers le formulaire de création
  navigateTo('/requests/new')
}
</script> 