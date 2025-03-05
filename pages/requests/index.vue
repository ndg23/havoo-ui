<template>
  <div class="min-h-screen bg-gray-50">
    <!-- Header avec filtres -->
    <header class="fixed top-[64px] left-0 right-0 z-40 bg-white border-b border-gray-200">
      <div class="max-w-7xl mx-auto px-4 py-3">
        <div class="flex items-center justify-between">
          <h1 class="text-xl font-bold text-gray-900">Demandes de services</h1>
          
          <div class="flex items-center gap-2">
            <button
              @click="showFilters = !showFilters"
              class="p-2.5 rounded-full bg-gray-100 text-gray-600 hover:bg-gray-200"
            >
              <SlidersHorizontal class="w-5 h-5" />
            </button>
            <button
              @click="showNewRequestModal = true"
              class="px-4 py-2 bg-primary-600 text-white rounded-full font-medium hover:bg-primary-700"
            >
              Publier une demande
            </button>
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
              <span>Toutes les demandes</span>
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

        <!-- Liste des demandes -->
        <div class="mt-4 space-y-3">
          <div 
            v-for="request in filteredRequests" 
            :key="request.id"
            class="bg-white hover:bg-gray-50 transition-colors cursor-pointer border border-gray-200 rounded-xl p-4"
          >
            <!-- En-tête de la demande -->
            <div class="flex items-start justify-between">
              <div>
                <h3 class="font-semibold text-gray-900">{{ request.title }}</h3>
                <p class="text-sm text-gray-500 flex items-center gap-1 mt-0.5">
                  <MapPin class="w-3.5 h-3.5" />
                  {{ request.location }}
                </p>
              </div>
              <span class="px-2 py-1 text-xs font-medium rounded-full"
                :class="getStatusClass(request.status)"
              >
                {{ request.status }}
              </span>
            </div>

            <!-- Services demandés -->
            <div class="mt-2 flex flex-wrap gap-1">
              <span 
                v-for="serviceId in request.services" 
                :key="serviceId"
                class="inline-flex items-center gap-1 px-2 py-0.5 bg-gray-50 rounded-md text-xs text-gray-600"
              >
                {{ services.find(s => s.id === serviceId)?.icon }}
                {{ services.find(s => s.id === serviceId)?.name }}
              </span>
            </div>

            <!-- Description -->
            <p class="mt-2 text-sm text-gray-600 line-clamp-2">
              {{ request.description }}
            </p>

            <!-- Footer -->
            <div class="mt-3 flex items-center justify-between">
              <div class="flex items-center gap-4">
                <div class="flex items-center gap-2">
                  <Calendar class="w-4 h-4 text-gray-400" />
                  <span class="text-sm text-gray-600">
                    {{ request.date }}
                  </span>
                </div>
                <div class="flex items-center gap-2">
                  <Clock class="w-4 h-4 text-gray-400" />
                  <span class="text-sm text-gray-600">
                    {{ request.time }}
                  </span>
                </div>
              </div>
              <button
                class="px-4 py-1.5 bg-primary-600 text-white text-sm rounded-lg font-medium hover:bg-primary-700 transition-colors"
              >
                Proposer mes services
              </button>
            </div>
          </div>
        </div>
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
import { SlidersHorizontal, Sparkles, MapPin, Calendar, Clock } from 'lucide-vue-next'

// États
const showFilters = ref(false)
const showNewRequestModal = ref(false)
const selectedService = ref<string | null>(null)

// Services (à déplacer vers un store plus tard)
const services = ref([
  { id: 'menage', name: 'Ménage', icon: '🧹' },
  { id: 'jardinage', name: 'Jardinage', icon: '🌱' },
  { id: 'bricolage', name: 'Bricolage', icon: '🔨' },
  { id: 'garde', name: "Garde d'enfants", icon: '👶' }
])

// Données simulées (à remplacer par une API)
const requests = ref([
  {
    id: 1,
    title: 'Ménage hebdomadaire',
    location: 'Cotonou, Bénin',
    services: ['menage'],
    description: 'Recherche personne pour ménage hebdomadaire...',
    date: '2024-02-20',
    time: '14:00',
    status: 'nouveau'
  }
  // ... autres demandes
])

// Computed
const filteredRequests = computed(() => {
  if (!selectedService.value) return requests.value
  return requests.value.filter(request => 
    request.services.includes(selectedService.value as string)
  )
})

// Méthodes
const selectService = (serviceId: string) => {
  selectedService.value = serviceId
}

const getStatusClass = (status: string) => {
  const classes = {
    'nouveau': 'bg-green-100 text-green-800',
    'en_cours': 'bg-blue-100 text-blue-800',
    'termine': 'bg-gray-100 text-gray-800'
  }
  return classes[status as keyof typeof classes] || ''
}

// Méthode pour continuer vers le formulaire
const proceedToNewRequest = () => {
  showNewRequestModal.value = false
  // Rediriger vers le formulaire de création
  navigateTo('/requests/new')
}
</script> 