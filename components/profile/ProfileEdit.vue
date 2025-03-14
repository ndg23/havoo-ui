<template>
  <div>
    <h2 class="text-xl font-medium text-gray-900 dark:text-white mb-8">
      Informations personnelles
    </h2>
    
    <form @submit.prevent="saveProfile">
      <div class="grid grid-cols-1 md:grid-cols-2 gap-x-8 gap-y-6 mb-8">
        <!-- Prénom -->
        <div>
          <label for="firstName" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
            Prénom
          </label>
          <input
            id="firstName"
            v-model="form.firstName"
            type="text"
            class="block w-full rounded-lg border-gray-200 dark:border-gray-700 shadow-sm dark:bg-gray-800 dark:text-white px-4 h-11 focus:ring-1 focus:ring-primary-500 focus:border-primary-500 transition-colors"
            required
          />
        </div>
        
        <!-- Nom -->
        <div>
          <label for="lastName" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
            Nom
          </label>
          <input
            id="lastName"
            v-model="form.lastName"
            type="text"
            class="block w-full rounded-lg border-gray-200 dark:border-gray-700 shadow-sm dark:bg-gray-800 dark:text-white px-4 h-11 focus:ring-1 focus:ring-primary-500 focus:border-primary-500 transition-colors"
            required
          />
        </div>
        
        <!-- Email -->
        <div>
          <label for="email" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
            Email
          </label>
          <input
            id="email"
            v-model="form.email"
            type="email"
            class="block w-full rounded-lg border-gray-200 dark:border-gray-700 shadow-sm dark:bg-gray-800 dark:text-white px-4 h-11 focus:ring-1 focus:ring-primary-500 focus:border-primary-500 transition-colors"
            required
          />
        </div>
        
        <!-- Téléphone -->
        <div>
          <label for="phone" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
            Téléphone
          </label>
          <input
            id="phone"
            v-model="form.phone"
            type="tel"
            class="block w-full rounded-lg border-gray-200 dark:border-gray-700 shadow-sm dark:bg-gray-800 dark:text-white px-4 h-11 focus:ring-1 focus:ring-primary-500 focus:border-primary-500 transition-colors"
          />
        </div>
      </div>
      
      <!-- Adresse -->
      <div class="mb-8">
        <label for="address" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
          Adresse
        </label>
        <textarea
          id="address"
          v-model="form.address"
          rows="3"
          class="block w-full rounded-lg border-gray-200 dark:border-gray-700 shadow-sm dark:bg-gray-800 dark:text-white px-4 py-3 focus:ring-1 focus:ring-primary-500 focus:border-primary-500 transition-colors"
        ></textarea>
      </div>
      
      <!-- Boutons de contrôle -->
      <div class="flex justify-end space-x-4">
        <button
          type="button"
          @click="resetForm"
          class="px-6 py-2.5 border border-gray-200 dark:border-gray-700 rounded-lg text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700 font-medium transition-colors"
        >
          Annuler
        </button>
        <button
          type="submit"
          class="px-6 py-2.5 bg-primary-600 text-white rounded-lg hover:bg-primary-700 flex items-center font-medium transition-colors hover:shadow-sm"
          :disabled="isSubmitting"
        >
          <span v-if="isSubmitting">
            <span class="inline-block animate-spin rounded-full h-4 w-4 border-2 border-white/30 border-t-white mr-2"></span>
            Enregistrement...
          </span>
          <span v-else>Enregistrer</span>
        </button>
      </div>
    </form>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useProfile } from '~/composables/useProfile'

const props = defineProps({
  profile: {
    type: Object,
    required: true
  }
})

const emit = defineEmits(['update'])

const { updateProfile } = useProfile()
const isSubmitting = ref(false)

// Formulaire
const form = ref({
  firstName: '',
  lastName: '',
  email: '',
  phone: '',
  address: ''
})

// Initialiser le formulaire avec les données du profil
onMounted(() => {
  if (props.profile) {
    form.value = {
      firstName: props.profile.firstName || '',
      lastName: props.profile.lastName || '',
      email: props.profile.email || '',
      phone: props.profile.phone || '',
      address: props.profile.address || ''
    }
  }
})

// Réinitialiser le formulaire
const resetForm = () => {
  if (props.profile) {
    form.value = {
      firstName: props.profile.firstName || '',
      lastName: props.profile.lastName || '',
      email: props.profile.email || '',
      phone: props.profile.phone || '',
      address: props.profile.address || ''
    }
  }
}

// Enregistrer les modifications
const saveProfile = async () => {
  isSubmitting.value = true
  
  try {
    await updateProfile({
      firstName: form.value.firstName,
      lastName: form.value.lastName,
      email: form.value.email,
      phone: form.value.phone,
      address: form.value.address
    })
    
    // Émettre l'événement pour rafraîchir les données du profil
    emit('update')
  } catch (error) {
    console.error('Erreur lors de la mise à jour du profil:', error)
  } finally {
    isSubmitting.value = false
  }
}
</script>

<style scoped>
/* Style minimaliste pour les inputs */
input, textarea {
  @apply border-gray-200 dark:border-gray-700 focus:ring-1 focus:ring-primary-500 focus:border-primary-500;
  transition: all 0.2s ease;
}

/* Style pour les boutons */
.btn-secondary {
  @apply px-4 py-2 border border-gray-200 dark:border-gray-700 rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors;
}

.btn-primary {
  @apply px-4 py-2 bg-primary-500 hover:bg-primary-600 text-white rounded-md transition-colors;
}

/* Amélioration des étiquettes */
label {
  @apply text-sm font-medium text-gray-600 dark:text-gray-400 mb-1;
}
</style> 