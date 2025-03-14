<template>
  <div class="max-w-md mx-auto px-4 pt-10 pb-16">
    <!-- En-tête avec logo -->
    <div class="mb-7 text-center">
      <h1 class="text-2xl font-bold text-gray-900 dark:text-white">Choisissez votre profil</h1>
      <p class="text-gray-600 dark:text-gray-400 mt-1">
        Pour finaliser votre inscription avec Google
      </p>
    </div>

    <!-- Informations utilisateur -->
    <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 p-5 mb-6 flex items-center">
      <div class="flex-shrink-0 mr-4">
        <img 
          v-if="userData.avatar_url" 
          :src="userData.avatar_url" 
          alt="Avatar" 
          class="h-14 w-14 rounded-full object-cover"
        />
        <div 
          v-else 
          class="h-14 w-14 rounded-full bg-primary-100 dark:bg-primary-900 flex items-center justify-center"
        >
          <span class="text-primary-600 dark:text-primary-400 text-xl font-medium">
            {{ userInitials }}
          </span>
        </div>
      </div>
      <div>
        <h2 class="text-lg font-medium text-gray-900 dark:text-white">
          {{ userData.full_name || `${userData.first_name} ${userData.last_name}` }}
        </h2>
        <p class="text-gray-500 dark:text-gray-400">{{ userData.email }}</p>
      </div>
    </div>

    <!-- Sélection du type de compte -->
    <div class="space-y-4 mb-6">
      <div 
        @click="selectRole('client')" 
        class="bg-white dark:bg-gray-800 rounded-xl border transition-all cursor-pointer p-5"
        :class="selectedRole === 'client' 
          ? 'border-primary-500 dark:border-primary-500 shadow-sm' 
          : 'border-gray-200 dark:border-gray-700 hover:border-gray-300 dark:hover:border-gray-600'"
      >
        <div class="flex items-start">
          <div class="flex-shrink-0">
            <div class="h-10 w-10 rounded-full bg-primary-100 dark:bg-primary-900 flex items-center justify-center">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-primary-600 dark:text-primary-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
              </svg>
            </div>
          </div>
          <div class="ml-4 flex-1">
            <div class="flex items-center justify-between">
              <h3 class="text-lg font-medium text-gray-900 dark:text-white">Client</h3>
              <div class="h-5 w-5 rounded-full border-2 flex items-center justify-center"
                :class="selectedRole === 'client' 
                  ? 'border-primary-500 dark:border-primary-500' 
                  : 'border-gray-300 dark:border-gray-600'"
              >
                <div v-if="selectedRole === 'client'" class="h-3 w-3 rounded-full bg-primary-500 dark:bg-primary-500"></div>
              </div>
            </div>
            <p class="mt-1 text-gray-600 dark:text-gray-400">
              Je souhaite publier des demandes et trouver des experts pour m'aider.
            </p>
          </div>
        </div>
      </div>
      
      <div 
        @click="selectRole('expert')" 
        class="bg-white dark:bg-gray-800 rounded-xl border transition-all cursor-pointer p-5"
        :class="selectedRole === 'expert' 
          ? 'border-primary-500 dark:border-primary-500 shadow-sm' 
          : 'border-gray-200 dark:border-gray-700 hover:border-gray-300 dark:hover:border-gray-600'"
      >
        <div class="flex items-start">
          <div class="flex-shrink-0">
            <div class="h-10 w-10 rounded-full bg-primary-100 dark:bg-primary-900 flex items-center justify-center">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-primary-600 dark:text-primary-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
              </svg>
            </div>
          </div>
          <div class="ml-4 flex-1">
            <div class="flex items-center justify-between">
              <h3 class="text-lg font-medium text-gray-900 dark:text-white">Expert</h3>
              <div class="h-5 w-5 rounded-full border-2 flex items-center justify-center"
                :class="selectedRole === 'expert' 
                  ? 'border-primary-500 dark:border-primary-500' 
                  : 'border-gray-300 dark:border-gray-600'"
              >
                <div v-if="selectedRole === 'expert'" class="h-3 w-3 rounded-full bg-primary-500 dark:bg-primary-500"></div>
              </div>
            </div>
            <p class="mt-1 text-gray-600 dark:text-gray-400">
              Je souhaite proposer mes services et répondre à des demandes.
            </p>
          </div>
        </div>
      </div>
    </div>

    <!-- Localisation (optionnel) -->
    <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 p-5 mb-6">
      <label for="location" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">
        Localisation (optionnel)
      </label>
      <input 
        id="location" 
        v-model="location" 
        type="text" 
        placeholder="Ville, Pays"
        class="w-full px-4 py-2.5 rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
      />
    </div>

    <!-- Conditions d'utilisation -->
    <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 p-5 mb-6">
      <div class="flex items-start">
        <div class="flex items-center h-5">
          <input 
            id="terms" 
            v-model="acceptTerms" 
            type="checkbox" 
            class="h-4 w-4 text-primary-600 focus:ring-primary-500 border-gray-300 rounded"
          />
        </div>
        <div class="ml-3 text-sm">
          <label for="terms" class="text-gray-700 dark:text-gray-300">
            J'accepte les <a href="#" class="text-primary-600 dark:text-primary-400 font-medium hover:underline">conditions d'utilisation</a> et la <a href="#" class="text-primary-600 dark:text-primary-400 font-medium hover:underline">politique de confidentialité</a>
          </label>
        </div>
      </div>
      <p v-if="errors.terms" class="text-red-600 dark:text-red-400 text-xs mt-1">{{ errors.terms }}</p>
    </div>

    <!-- Bouton de confirmation -->
    <button 
      @click="completeSignup" 
      class="w-full bg-primary-600 hover:bg-primary-700 text-white rounded-lg py-3 px-4 flex items-center justify-center font-medium text-lg transition-colors shadow-sm disabled:opacity-50 disabled:cursor-not-allowed"
      :disabled="isSubmitting || !isFormValid"
    >
      <span v-if="isSubmitting" class="flex items-center">
        <svg class="animate-spin -ml-1 mr-2 h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
          <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
          <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
        </svg>
        Finalisation en cours...
      </span>
      <span v-else>Finaliser mon inscription</span>
    </button>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useSupabaseClient, useSupabaseUser } from '#imports'

const supabase = useSupabaseClient()
const user = useSupabaseUser()
const router = useRouter()
const route = useRoute()

// État du formulaire
const userData = ref({
  email: '',
  first_name: '',
  last_name: '',
  full_name: '',
  avatar_url: ''
})
const selectedRole = ref('client')
const location = ref('')
const acceptTerms = ref(false)
const isSubmitting = ref(false)
const errors = ref({})

// Récupération des initiales de l'utilisateur
const userInitials = computed(() => {
  if (userData.value.full_name) {
    const nameParts = userData.value.full_name.split(' ')
    return nameParts.length > 1 
      ? `${nameParts[0][0]}${nameParts[1][0]}` 
      : nameParts[0][0]
  }
  
  if (userData.value.first_name && userData.value.last_name) {
    return `${userData.value.first_name[0]}${userData.value.last_name[0]}`
  }
  
  return '?'
})

// Validation du formulaire
const isFormValid = computed(() => {
  return selectedRole.value && acceptTerms.value
})

// Sélection du rôle
const selectRole = (role) => {
  selectedRole.value = role
}

// Finalisation de l'inscription
const completeSignup = async () => {
  // Validation
  errors.value = {}
  
  if (!acceptTerms.value) {
    errors.value.terms = 'Vous devez accepter les conditions d\'utilisation'
    return
  }
  
  if (!selectedRole.value) {
    return
  }
  
  isSubmitting.value = true
  
  try {
    // Mettre à jour les métadonnées de l'utilisateur avec le rôle sélectionné
    const { error } = await supabase.auth.updateUser({
      data: {
        is_expert: selectedRole.value === 'expert',
        location: location.value || null,
        role: selectedRole.value
      }
    })
    
    if (error) throw error
    
    // Créer ou mettre à jour le profil dans la base de données
    const { error: profileError } = await supabase
      .from('profiles')
      .upsert({
        id: user.value.id,
        first_name: userData.value.first_name || userData.value.full_name?.split(' ')[0] || '',
        last_name: userData.value.last_name || userData.value.full_name?.split(' ').slice(1).join(' ') || '',
        email: userData.value.email,
        avatar_url: userData.value.avatar_url,
        is_expert: selectedRole.value === 'expert',
        location: location.value || null,
        updated_at: new Date().toISOString()
      })
    
    if (profileError) throw profileError
    
    // Redirection en fonction du rôle
    if (selectedRole.value === 'expert') {
      router.push('/auth/expert-onboarding')
    } else {
      router.push('/account')
    }
  } catch (error) {
    console.error('Erreur lors de la finalisation de l\'inscription:', error)
    alert('Une erreur est survenue lors de la finalisation de votre inscription. Veuillez réessayer.')
  } finally {
    isSubmitting.value = false
  }
}

// Initialisation des données utilisateur
onMounted(async () => {
  if (!user.value) {
    router.push('/auth/login')
    return
  }
  
  try {
    // Vérifier si l'utilisateur a déjà un profil
    const { data: profile } = await supabase
      .from('profiles')
      .select('*')
      .eq('id', user.value.id)
      .single()
    
    // Si l'utilisateur a déjà un profil complet, rediriger
    if (profile && profile.is_expert !== null) {
      if (profile.is_expert) {
        router.push('/auth/expert-onboarding')
      } else {
        router.push('/account')
      }
      return
    }
    
    // Récupérer les données de l'utilisateur depuis les métadonnées
    userData.value = {
      email: user.value.email,
      first_name: user.value.user_metadata?.first_name || '',
      last_name: user.value.user_metadata?.last_name || '',
      full_name: user.value.user_metadata?.full_name || '',
      avatar_url: user.value.user_metadata?.avatar_url || ''
    }
  } catch (error) {
    console.error('Erreur lors de la récupération des données utilisateur:', error)
  }
})

// Définir le layout
definePageMeta({
  layout: 'auth'
})
</script>

<style scoped>
/* Animation des composants */
.space-y-4 > div {
  animation: fadeIn 0.4s ease;
  animation-fill-mode: both;
}

/* Animation séquentielle pour chaque section */
.space-y-4 > div:nth-child(1) { animation-delay: 0.05s; }
.space-y-4 > div:nth-child(2) { animation-delay: 0.1s; }

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(8px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
</style> 