<template>
  <div class="space-y-6">
    <h3 class="text-lg font-medium text-gray-900">Récapitulatif de votre demande</h3>
    
    <!-- Service -->
    <div class="bg-gray-50 rounded-xl p-4">
      <div class="flex items-start gap-4">
        <div class="w-10 h-10 rounded-full bg-primary-100 flex items-center justify-center text-xl">
          {{ getServiceIcon(form.serviceId) }}
        </div>
        <div>
          <h4 class="font-medium text-gray-900">{{ getServiceName(form.serviceId) }}</h4>
          <p class="text-sm text-gray-500">{{ form.description }}</p>
        </div>
      </div>
    </div>
    
    <!-- Localisation -->
    <div class="flex items-center gap-3">
      <MapPin class="w-5 h-5 text-gray-400" />
      <span class="text-gray-700">{{ form.location }}</span>
    </div>
    
    <!-- Dates et horaires -->
    <div class="space-y-2">
      <div class="flex items-center gap-3">
        <Calendar class="w-5 h-5 text-gray-400" />
        <span class="text-gray-700">
          {{ formatDates(form.dates) }}
        </span>
      </div>
      <div class="flex items-center gap-3">
        <Clock class="w-5 h-5 text-gray-400" />
        <span class="text-gray-700">{{ form.time }}</span>
      </div>
    </div>
    
    <!-- Informations légales -->
    <div class="mt-6 p-4 bg-gray-50 rounded-xl text-sm text-gray-600">
      <p class="flex items-start gap-2">
        <Info class="w-5 h-5 text-primary-600 shrink-0" />
        <span>
          En publiant cette demande, vous acceptez que vos informations soient visibles par les experts qualifiés.
          Vous pourrez supprimer votre demande à tout moment.
        </span>
      </p>
    </div>
  </div>
</template>

<script setup lang="ts">
import { MapPin, Calendar, Clock, Info } from 'lucide-vue-next'

// Types
interface RequestForm {
  serviceId: string
  description: string
  location: string
  dates: string[]
  time: string
}

defineProps<{
  form: RequestForm
}>()

// Services
const services = [
  { id: 'menage', name: 'Ménage', icon: '🧹' },
  { id: 'jardinage', name: 'Jardinage', icon: '🌱' },
  { id: 'bricolage', name: 'Bricolage', icon: '🔨' },
  { id: 'garde', name: "Garde d'enfants", icon: '👶' }
]

// Obtenir le nom du service
const getServiceName = (serviceId: string) => {
  const service = services.find(s => s.id === serviceId)
  return service ? service.name : 'Service'
}

// Obtenir l'icône du service
const getServiceIcon = (serviceId: string) => {
  const service = services.find(s => s.id === serviceId)
  return service ? service.icon : '📋'
}

// Formater les dates pour l'affichage
const formatDates = (dates: string[]) => {
  if (!dates.length) return 'Non spécifié'
  
  if (dates.includes('this_week')) return 'Cette semaine'
  if (dates.includes('next_week')) return 'Semaine prochaine'
  
  if (dates.length === 1) {
    return new Date(dates[0]).toLocaleDateString('fr-FR', { 
      day: 'numeric', 
      month: 'long' 
    })
  }
  
  return `${dates.length} dates sélectionnées`
}
</script> 