<template>
  <div class="max-w-2xl mx-auto p-4 space-y-8">
    <!-- En-tête du profil -->
    <div class="flex flex-col items-center space-y-4">
      <!-- Avatar avec upload -->
      <div class="relative group">
        <div class="w-24 h-24 rounded-full overflow-hidden bg-gray-100 dark:bg-gray-800">
          <img 
            v-if="form.avatar_url" 
            :src="form.avatar_url" 
            class="w-full h-full object-cover"
            alt="Photo de profil"
          />
          <div v-else class="w-full h-full flex items-center justify-center text-gray-400">
            <UIcon name="i-heroicons-user" class="w-12 h-12" />
          </div>
        </div>
        <button 
          @click="uploadAvatar"
          class="absolute bottom-0 right-0 bg-primary-500 text-white p-2 rounded-full shadow-lg hover:bg-primary-600 transition-colors"
        >
          <UIcon name="i-heroicons-camera" class="w-4 h-4" />
        </button>
      </div>

      <!-- Barre de progression -->
      <div class="w-full max-w-xs">
        <div class="flex items-center justify-between text-sm mb-2">
          <span class="text-gray-600 dark:text-gray-400">Profil complété à</span>
          <span class="font-medium">{{ form.profile_completion_percentage }}%</span>
        </div>
        <div class="h-2 bg-gray-200 dark:bg-gray-700 rounded-full overflow-hidden">
          <div 
            class="h-full bg-primary-500 transition-all duration-500"
            :style="{ width: form.profile_completion_percentage + '%' }"
          />
        </div>
      </div>
    </div>

    <!-- Formulaire principal -->
    <form @submit.prevent="saveProfile" class="space-y-6">
      <!-- Informations de base -->
      <div class="space-y-4">
        <h2 class="text-lg font-medium flex items-center gap-2 text-gray-900 dark:text-white">
          <UIcon name="i-heroicons-user-circle" class="w-5 h-5" />
          Informations personnelles
        </h2>
        
        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
          <FloatingLabelInput
            v-model="form.first_name"
            label="Prénom"
            required
          />
          <FloatingLabelInput
            v-model="form.last_name"
            label="Nom"
            required
          />
        </div>
      </div>

      <!-- Contact -->
      <div class="space-y-4">
        <h2 class="text-lg font-medium flex items-center gap-2 text-gray-900 dark:text-white">
          <UIcon name="i-heroicons-phone" class="w-5 h-5" />
          Contact
        </h2>
        
        <div class="space-y-4">
          <FloatingLabelInput
            v-model="form.phone"
            label="Téléphone"
            type="tel"
            placeholder="+221 XX XXX XX XX"
          />
          <FloatingLabelInput
            v-model="form.whatsapp"
            label="WhatsApp"
            type="tel"
            placeholder="+221 XX XXX XX XX"
          >
            <template #append>
              <img src="/icons/whatsapp.svg" class="w-5 h-5" alt="WhatsApp" />
            </template>
          </FloatingLabelInput>
        </div>
      </div>

      <!-- Localisation -->
      <div class="space-y-4">
        <h2 class="text-lg font-medium flex items-center gap-2 text-gray-900 dark:text-white">
          <UIcon name="i-heroicons-map-pin" class="w-5 h-5" />
          Localisation
        </h2>
        
        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
          <FloatingLabelInput
            v-model="form.city"
            label="Ville"
          />
          <USelect
            v-model="form.country"
            :options="africanCountries"
            label="Pays"
            placeholder="Sélectionnez votre pays"
          />
        </div>
      </div>

      <!-- Paiement -->
      <div class="space-y-4">
        <h2 class="text-lg font-medium flex items-center gap-2 text-gray-900 dark:text-white">
          <UIcon name="i-heroicons-credit-card" class="w-5 h-5" />
          Paiement
        </h2>
        
        <div class="space-y-4">
          <div class="grid grid-cols-2 sm:grid-cols-3 gap-3">
            <button
              v-for="method in paymentMethods"
              :key="method.value"
              type="button"
              @click="form.preferred_payment_method = method.value"
              class="flex flex-col items-center p-3 border rounded-xl transition-colors"
              :class="[
                form.preferred_payment_method === method.value
                  ? 'border-primary-500 bg-primary-50 dark:bg-primary-900/20'
                  : 'border-gray-200 dark:border-gray-700'
              ]"
            >
              <img :src="method.icon" class="w-8 h-8 mb-2" :alt="method.label">
              <span class="text-sm">{{ method.label }}</span>
            </button>
          </div>

          <FloatingLabelInput
            v-if="form.preferred_payment_method"
            v-model="form.mobile_money_number"
            label="Numéro de paiement"
            type="tel"
            placeholder="+221 XX XXX XX XX"
          />
        </div>
      </div>

      <!-- Profil professionnel -->
      <div class="space-y-4">
        <h2 class="text-lg font-medium flex items-center gap-2 text-gray-900 dark:text-white">
          <UIcon name="i-heroicons-briefcase" class="w-5 h-5" />
          Profil professionnel
        </h2>
        
        <div class="space-y-4">
          <FloatingLabelInput
            v-model="form.profession"
            label="Métier / Expertise"
            placeholder="Ex: Développeur web, Designer..."
          />

          <USelect
            v-model="form.education_level"
            :options="educationLevels"
            label="Niveau d'études"
          />

          <UTextarea
            v-model="form.bio"
            label="Bio"
            placeholder="Parlez-nous un peu de vous..."
            rows="4"
          />
        </div>
      </div>

      <!-- Disponibilité -->
      <div class="space-y-4">
        <h2 class="text-lg font-medium flex items-center gap-2 text-gray-900 dark:text-white">
          <UIcon name="i-heroicons-clock" class="w-5 h-5" />
          Disponibilité
        </h2>
        
        <div class="space-y-6">
          <!-- Semaine -->
          <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
              Heures de travail (Lundi - Vendredi)
            </label>
            <div class="flex items-center gap-3">
              <USelect
                v-model="form.availability_hours.weekdays[0]"
                :options="timeSlots"
                class="w-32"
              />
              <span class="text-gray-500">à</span>
              <USelect
                v-model="form.availability_hours.weekdays[1]"
                :options="timeSlots"
                class="w-32"
              />
            </div>
          </div>

          <!-- Weekend -->
          <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
              Heures de travail (Weekend)
            </label>
            <div class="flex items-center gap-3">
              <USelect
                v-model="form.availability_hours.weekend[0]"
                :options="timeSlots"
                class="w-32"
              />
              <span class="text-gray-500">à</span>
              <USelect
                v-model="form.availability_hours.weekend[1]"
                :options="timeSlots"
                class="w-32"
              />
            </div>
          </div>
        </div>
      </div>

      <!-- Boutons d'action -->
      <div class="flex justify-end gap-4 pt-4">
        <UButton
          type="button"
          variant="ghost"
          @click="resetForm"
        >
          Annuler
        </UButton>
        <UButton
          type="submit"
          :loading="isSaving"
          :disabled="isSaving"
        >
          {{ isSaving ? 'Enregistrement...' : 'Enregistrer' }}
        </UButton>
      </div>
    </form>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive } from 'vue'
import type { Database } from '~/types/database'

type Profile = Database['public']['Tables']['profiles']['Row']

// État du formulaire
const form = reactive<Partial<Profile>>({
  first_name: '',
  last_name: '',
  email: '',
  phone: null,
  whatsapp: null,
  avatar_url: null,
  bio: null,
  city: null,
  country: 'Sénégal',
  profession: null,
  education_level: null,
  languages: ['Français'],
  preferred_payment_method: 'mobile_money',
  mobile_money_number: null,
  availability_hours: {
    weekdays: ['09:00', '18:00'],
    weekend: ['10:00', '16:00']
  },
  profile_completion_percentage: 20
})

const isSaving = ref(false)

// Options pour les sélecteurs
const paymentMethods = [
  { value: 'wave', label: 'Wave', icon: '/icons/wave.svg' },
  { value: 'orange_money', label: 'Orange Money', icon: '/icons/orange-money.svg' },
  { value: 'mobile_money', label: 'Mobile Money', icon: '/icons/mobile-money.svg' },
  { value: 'cash', label: 'Espèces', icon: '/icons/cash.svg' },
  { value: 'bank_transfer', label: 'Virement', icon: '/icons/bank.svg' }
]

const educationLevels = [
  { value: 'primaire', label: 'Primaire' },
  { value: 'secondaire', label: 'Secondaire' },
  { value: 'supérieur', label: 'Supérieur' },
  { value: 'autodidacte', label: 'Autodidacte' }
]

const timeSlots = Array.from({ length: 24 }, (_, i) => {
  const hour = i.toString().padStart(2, '0')
  return { value: `${hour}:00`, label: `${hour}:00` }
})

const africanCountries = [
  { value: 'Sénégal', label: 'Sénégal' },
  { value: 'Mali', label: 'Mali' },
  { value: 'Côte d\'Ivoire', label: 'Côte d\'Ivoire' },
  { value: 'Burkina Faso', label: 'Burkina Faso' },
  { value: 'Guinée', label: 'Guinée' },
  // Ajouter d'autres pays africains...
]

// Méthodes
const uploadAvatar = () => {
  // Implémenter la logique d'upload
}

const saveProfile = async () => {
  isSaving.value = true
  try {
    // Implémenter la logique de sauvegarde
    await new Promise(resolve => setTimeout(resolve, 1000))
    // Afficher un message de succès
  } catch (error) {
    // Gérer l'erreur
  } finally {
    isSaving.value = false
  }
}

const resetForm = () => {
  // Réinitialiser le formulaire
}
</script> 