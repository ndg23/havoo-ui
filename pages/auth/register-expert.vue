<template>
  <div class="max-w-3xl mx-auto px-4 py-12">
    <div class="bg-white rounded-2xl shadow-sm border border-gray-200 p-8">
      <!-- En-tête -->
      <div class="text-center mb-10">
        <h1 class="text-3xl font-bold text-gray-900">Rejoignez notre communauté d'experts</h1>
        <p class="mt-3 text-gray-600">Proposez vos services et développez votre activité</p>
      </div>
      
      <!-- Formulaire simplifié -->
      <form @submit.prevent="submitRegistration" class="space-y-6">
        <!-- Photo de profil -->
        <div class="flex flex-col items-center mb-8">
          <div class="relative">
            <div class="w-24 h-24 rounded-full bg-gray-100 flex items-center justify-center overflow-hidden">
              <img v-if="form.profileImage" :src="form.profileImage" alt="Profile" class="w-full h-full object-cover" />
              <User v-else class="w-10 h-10 text-gray-400" />
            </div>
            <button 
              type="button"
              class="absolute bottom-0 right-0 w-8 h-8 rounded-full bg-primary-600 flex items-center justify-center border-2 border-white"
            >
              <Camera class="w-4 h-4 text-white" />
            </button>
          </div>
          <button 
            type="button"
            class="mt-3 text-sm text-primary-600 font-medium"
          >
            Ajouter une photo
          </button>
        </div>
        
        <!-- Informations personnelles -->
        <div class="space-y-4">
          <!-- Nom et prénom -->
          <div class="grid grid-cols-2 gap-4">
            <FloatingInput
              label="Prénom"
              id="firstName"
              :model-value="form.firstName"
              @update:model-value="form.firstName = $event"
              placeholder="Votre prénom"
            />
              <FloatingInput
              id="lastName"
              label="Nom"
              :model-value="form.lastName"
              @update:model-value="form.lastName = $event"
              placeholder="Votre nom"
            />
          </div>
          
          <!-- Email et téléphone -->
          <div class="grid grid-cols-2 gap-4">
            <FloatingInput
              id="email"
              label="Email"
              type="email"
              :model-value="form.email"
              @update:model-value="form.email = $event"
              placeholder="votre@email.com"
            />
            <FloatingInput
              id="phone"
              label="Téléphone"
              type="tel"
              :model-value="form.phone"
              @update:model-value="form.phone = $event"
              placeholder="+229 00 00 00 00"
            />
          </div>
          
          <!-- Localisation -->
          <FloatingInput
            id="address"
            label="Adresse"
            :model-value="form.address"
            @update:model-value="form.address = $event"
            placeholder="Votre adresse complète"
            :icon="MapPin"
          />
        </div>
        
        <!-- Services proposés -->
        <div class="pt-4 border-t border-gray-200">
          <h2 class="text-lg font-medium text-gray-900 mb-4">Vos services</h2>
          
          <p class="text-sm text-gray-600 mb-4">
            Sélectionnez les services que vous souhaitez proposer (vous pourrez les modifier ultérieurement)
          </p>
          
          <div class="grid grid-cols-2 sm:grid-cols-4 gap-3">
            <button
              v-for="service in services"
              :key="service.id"
              type="button"
              @click="toggleService(service.id)"
              class="relative flex flex-col items-center p-3 rounded-xl border-2 transition-all duration-300"
              :class="form.services.includes(service.id) 
                ? 'border-primary-600 bg-primary-50' 
                : 'border-gray-200 hover:border-gray-300'"
            >
              <!-- Icône -->
              <div 
                class="w-10 h-10 rounded-full flex items-center justify-center mb-2 text-2xl"
                :class="form.services.includes(service.id) ? 'bg-primary-100' : 'bg-gray-100'"
              >
                {{ service.icon }}
              </div>
              
              <!-- Nom -->
              <span 
                class="text-xs font-medium text-center"
                :class="form.services.includes(service.id) ? 'text-primary-700' : 'text-gray-900'"
              >
                {{ service.name }}
              </span>
              
              <!-- Check icon -->
              <div 
                v-if="form.services.includes(service.id)"
                class="absolute top-2 right-2 w-4 h-4 rounded-full bg-primary-600 flex items-center justify-center"
              >
                <Check class="w-2 h-2 text-white" />
              </div>
            </button>
          </div>
        </div>
        
        <!-- Conditions d'utilisation -->
        <div class="pt-4 border-t border-gray-200">
          <div class="bg-gray-50 rounded-xl p-4">
            <div class="flex items-start gap-3">
              <div class="mt-0.5">
                <input 
                  type="checkbox" 
                  id="terms-agreement" 
                  v-model="form.termsAccepted"
                  class="rounded text-primary-600 focus:ring-primary-500"
                />
              </div>
              <label for="terms-agreement" class="text-sm text-gray-700">
                J'accepte les <a href="#" class="text-primary-600 underline">conditions d'utilisation</a> et la <a href="#" class="text-primary-600 underline">politique de confidentialité</a>. Je comprends que mes informations seront visibles par les utilisateurs de la plateforme.
              </label>
            </div>
          </div>
        </div>
        
        <!-- Bouton de soumission -->
        <div class="pt-4">
          <button 
            type="submit"
            class="w-full flex items-center justify-center gap-2 px-6 py-3 bg-primary-600 text-white rounded-full hover:bg-primary-700 transition-colors disabled:bg-gray-300 disabled:text-gray-500 disabled:cursor-not-allowed"
            :disabled="!isFormValid"
          >
            <span>Créer mon compte expert</span>
            <ArrowRight class="w-4 h-4" />
          </button>
          
          <p class="mt-4 text-center text-sm text-gray-500">
            Vous pourrez compléter votre profil après l'inscription
          </p>
        </div>
      </form>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { MapPin, User, Camera, Check, ArrowRight } from 'lucide-vue-next'
import FloatingInput from '~/components/shared/FloatingInput.vue'

// Services
const services = [
  { id: 'menage', name: 'Ménage', icon: '🧹' },
  { id: 'jardinage', name: 'Jardinage', icon: '🌱' },
  { id: 'bricolage', name: 'Bricolage', icon: '🔨' },
  { id: 'garde', name: "Garde d'enfants", icon: '👶' },
  { id: 'chauffeur', name: 'Chauffeur', icon: '🚗' },
  { id: 'demenagement', name: 'Déménagement', icon: '📦' },
  { id: 'coiffure', name: 'Coiffure', icon: '💇' },
  { id: 'massage', name: 'Massage', icon: '💆' }
]

// État du formulaire
const form = ref({
  profileImage: '',
  firstName: '',
  lastName: '',
  email: '',
  phone: '',
  address: '',
  services: [] as string[],
  termsAccepted: false
})

// Validation du formulaire
const isFormValid = computed(() => {
  return (
    !!form.value.firstName &&
    !!form.value.lastName &&
    !!form.value.email &&
    form.value.services.length > 0 &&
    form.value.termsAccepted
  )
})

// Méthodes
const toggleService = (serviceId: string) => {
  const index = form.value.services.indexOf(serviceId)
  if (index === -1) {
    form.value.services.push(serviceId)
  } else {
    form.value.services.splice(index, 1)
  }
}

const submitRegistration = async () => {
  if (!isFormValid.value) return
  
  try {
    // Simuler l'envoi des données
    console.log('Données soumises:', form.value)
    
    // Rediriger vers la page de succès
    navigateTo('/auth/registration-success')
  } catch (error) {
    console.error('Erreur lors de l\'inscription:', error)
  }
}
</script> 