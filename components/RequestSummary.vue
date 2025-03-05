<template>
  <div class="space-y-8">
    <h3 class="text-xl font-medium text-gray-900">Récapitulatif de votre demande</h3>
    
    <!-- Service sélectionné -->
    <div class="bg-white border border-gray-100 rounded-xl p-5 shadow-sm">
      <div class="flex items-start gap-5">
        <div 
          class="w-14 h-14 rounded-full flex items-center justify-center text-2xl"
          :class="getServiceColor(form.serviceId)"
        >
          {{ getServiceIcon(form.serviceId) }}
        </div>
        <div class="flex-1">
          <h4 class="text-lg font-medium text-gray-900">{{ getServiceName(form.serviceId) }}</h4>
          <div class="mt-1 text-sm text-gray-500 line-clamp-2">{{ form.description }}</div>
          
          <!-- Tags -->
          <div class="mt-3 flex flex-wrap gap-2">
            <span class="inline-flex items-center gap-1.5 px-3 py-1 bg-gray-100 rounded-full text-xs font-medium text-gray-700">
              <MapPin class="w-3.5 h-3.5" />
              {{ form.location }}
            </span>
            
            <span class="inline-flex items-center gap-1.5 px-3 py-1 bg-gray-100 rounded-full text-xs font-medium text-gray-700">
              <Calendar class="w-3.5 h-3.5" />
              {{ formatDates(form.dates) }}
            </span>
            
            <span class="inline-flex items-center gap-1.5 px-3 py-1 bg-gray-100 rounded-full text-xs font-medium text-gray-700">
              <Clock class="w-3.5 h-3.5" />
              {{ form.time }}
            </span>
          </div>
        </div>
      </div>
    </div>
    
    <!-- Détails de la demande -->
    <div class="space-y-5">
      <h4 class="font-medium text-gray-900">Détails de votre demande</h4>
      
      <div class="space-y-4">
        <!-- Description -->
        <div class="bg-gray-50 rounded-xl p-4">
          <div class="flex items-start gap-3">
            <div class="w-8 h-8 rounded-full bg-gray-200 flex items-center justify-center shrink-0">
              <FileText class="w-4 h-4 text-gray-600" />
            </div>
            <div>
              <div class="text-sm font-medium text-gray-700">Description</div>
              <p class="mt-1 text-sm text-gray-600">
                {{ form.description || "Aucune description fournie" }}
              </p>
            </div>
          </div>
        </div>
        
        <!-- Localisation -->
        <div class="bg-gray-50 rounded-xl p-4">
          <div class="flex items-start gap-3">
            <div class="w-8 h-8 rounded-full bg-gray-200 flex items-center justify-center shrink-0">
              <MapPin class="w-4 h-4 text-gray-600" />
            </div>
            <div>
              <div class="text-sm font-medium text-gray-700">Localisation</div>
              <p class="mt-1 text-sm text-gray-600">{{ form.location }}</p>
            </div>
          </div>
        </div>
        
        <!-- Dates -->
        <div class="bg-gray-50 rounded-xl p-4">
          <div class="flex items-start gap-3">
            <div class="w-8 h-8 rounded-full bg-gray-200 flex items-center justify-center shrink-0">
              <Calendar class="w-4 h-4 text-gray-600" />
            </div>
            <div>
              <div class="text-sm font-medium text-gray-700">Dates</div>
              <p class="mt-1 text-sm text-gray-600">
                {{ formatDates(form.dates) }}
              </p>
            </div>
          </div>
        </div>
        
        <!-- Horaire -->
        <div class="bg-gray-50 rounded-xl p-4">
          <div class="flex items-start gap-3">
            <div class="w-8 h-8 rounded-full bg-gray-200 flex items-center justify-center shrink-0">
              <Clock class="w-4 h-4 text-gray-600" />
            </div>
            <div>
              <div class="text-sm font-medium text-gray-700">Horaire</div>
              <p class="mt-1 text-sm text-gray-600">{{ form.time }}</p>
            </div>
          </div>
        </div>
      </div>
    </div>
    
    <!-- Informations légales -->
    <div class="bg-primary-50 rounded-xl p-5 border border-primary-100">
      <div class="flex items-start gap-4">
        <div class="w-10 h-10 rounded-full bg-primary-100 flex items-center justify-center shrink-0">
          <Info class="w-5 h-5 text-primary-600" />
        </div>
        <div>
          <h4 class="font-medium text-primary-800">Avant de publier</h4>
          <p class="mt-2 text-sm text-primary-700">
            En publiant cette demande, vous acceptez que vos informations soient visibles par les experts qualifiés.
            Vous pourrez supprimer votre demande à tout moment.
          </p>
          <div class="mt-3 flex items-center gap-2">
            <input 
              type="checkbox" 
              id="terms-agreement" 
              class="rounded text-primary-600 focus:ring-primary-500"
            />
            <label for="terms-agreement" class="text-sm text-primary-700">
              J'accepte les <a href="#" class="underline">conditions d'utilisation</a>
            </label>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { MapPin, Calendar, Clock, Info, FileText } from 'lucide-vue-next'

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
  { id: 'menage', name: 'Ménage', icon: '🧹', color: 'bg-blue-100' },
  { id: 'jardinage', name: 'Jardinage', icon: '🌱', color: 'bg-green-100' },
  { id: 'bricolage', name: 'Bricolage', icon: '🔨', color: 'bg-amber-100' },
  { id: 'garde', name: "Garde d'enfants", icon: '👶', color: 'bg-purple-100' },
  { id: 'chauffeur', name: 'Chauffeur', icon: '🚗', color: 'bg-red-100' },
  { id: 'demenagement', name: 'Déménagement', icon: '📦', color: 'bg-orange-100' },
  { id: 'coiffure', name: 'Coiffure', icon: '💇', color: 'bg-pink-100' },
  { id: 'massage', name: 'Massage', icon: '💆', color: 'bg-indigo-100' },
  { id: 'comptabilite', name: 'Comptabilité', icon: '📊', color: 'bg-gray-100' },
  { id: 'marketing', name: 'Marketing', icon: '📱', color: 'bg-teal-100' }
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

// Obtenir la couleur du service
const getServiceColor = (serviceId: string) => {
  const service = services.find(s => s.id === serviceId)
  return service ? service.color : 'bg-gray-100'
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