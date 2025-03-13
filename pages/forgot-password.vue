<template>
  <div class="min-h-screen flex flex-col bg-white dark:bg-black">
    <!-- Côté visuel (visible uniquement sur desktop) -->
    <div class="fixed inset-0 z-0 hidden lg:block">
      <div class="absolute inset-0 bg-gradient-to-br from-primary-500/10 to-primary-700/20 dark:from-primary-900/20 dark:to-primary-800/10 z-0"></div>
      <div class="absolute left-0 bottom-0 w-3/4 h-3/4 bg-primary-50 dark:bg-primary-950 rounded-tr-[120px] opacity-30 dark:opacity-20 z-0"></div>
    </div>
    
    <!-- Contenu principal -->
    <div class="relative z-10 flex-1 flex flex-col justify-center px-6 py-12 lg:px-8 max-w-md mx-auto w-full">
      <!-- Bouton de retour -->
      <div class="absolute top-8 left-6">
        <NuxtLink 
          to="/login"
          class="p-2 -m-2 rounded-full hover:bg-gray-100 dark:hover:bg-gray-800 transition-colors inline-flex items-center text-gray-500 dark:text-gray-400"
        >
          <ArrowLeft class="h-5 w-5" />
          <span class="ml-1 text-sm font-medium">Retour</span>
        </NuxtLink>
      </div>
      
      <!-- Logo -->
      <div class="mb-10 sm:mb-14">
        <Logo class="h-14 w-auto mx-auto" />
      </div>
      
      <!-- Titre -->
      <h1 class="text-4xl font-bold tracking-tight text-center text-gray-900 dark:text-white mb-2">
        Mot de passe oublié ?
      </h1>
      <p class="text-center text-gray-600 dark:text-gray-400 mb-10">
        Nous vous enverrons un lien pour réinitialiser
      </p>

      <!-- Message de succès -->
      <div 
        v-if="successMessage" 
        class="mb-8 p-5 bg-green-50 dark:bg-green-900/20 border-l-4 border-green-500 text-base text-green-700 dark:text-green-400 rounded-r-xl animate-slideIn"
      >
        <CheckCircle class="h-6 w-6 mb-2" />
        <p>{{ successMessage }}</p>
        <NuxtLink 
          to="/login" 
          class="mt-4 inline-flex items-center text-sm font-medium text-green-600 dark:text-green-400 hover:text-green-500"
        >
          <ArrowLeft class="h-4 w-4 mr-1" />
          Retourner à la connexion
        </NuxtLink>
      </div>
      
      <!-- Message d'erreur -->
      <div 
        v-if="errorMessage && !successMessage" 
        class="mb-6 p-4 bg-red-50 dark:bg-red-900/20 border-l-4 border-red-500 text-sm text-red-700 dark:text-red-400 animate-slideIn"
      >
        {{ errorMessage }}
      </div>

      <form v-if="!successMessage" class="space-y-6" @submit.prevent="sendResetLink">
        <!-- Email -->
        <div class="space-y-2">
          <label for="email" class="block text-sm font-medium text-gray-700 dark:text-gray-300">
            Adresse email
          </label>
          <input
            id="email"
            v-model="email"
            type="email"
            autocomplete="email"
            required
            class="w-full px-4 py-3 border border-gray-300 dark:border-gray-700 rounded-xl bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-shadow"
            :class="{'shadow-md': email}"
          />
        </div>

        <!-- Bouton d'envoi -->
        <div>
          <button
            type="submit"
            :disabled="isLoading"
            class="w-full flex justify-center py-3 px-4 border border-transparent rounded-xl shadow-sm text-base font-medium text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 disabled:bg-primary-400 transition-all duration-200 transform hover:scale-[1.02]"
          >
            <div v-if="isLoading" class="flex items-center">
              <div class="h-4 w-4 border-2 border-white/30 border-t-white rounded-full animate-spin mr-1.5"></div>
              <span>Envoi en cours...</span>
            </div>
            <span v-else>Réinitialiser mon mot de passe</span>
          </button>
        </div>
      </form>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { ArrowLeft, CheckCircle } from 'lucide-vue-next'

// États réactifs
const email = ref('')
const isLoading = ref(false)
const errorMessage = ref('')
const successMessage = ref('')

// Fonction d'envoi du lien de réinitialisation
const sendResetLink = async () => {
  // Réinitialiser les erreurs
  errorMessage.value = ''
  
  // Validation basique
  if (!email.value) {
    errorMessage.value = 'Veuillez renseigner votre adresse email'
    return
  }
  
  isLoading.value = true
  
  try {
    // Dans un environnement réel, nous utiliserions Supabase
    /*
    const { error } = await supabase.auth.api.resetPasswordForEmail(email.value)
    
    if (error) throw error
    */
    
    // Simuler un délai
    await new Promise(resolve => setTimeout(resolve, 1500))
    
    // Afficher le message de succès
    successMessage.value = `Un email avec les instructions de réinitialisation a été envoyé à ${email.value}`
  } catch (error) {
    console.error('Erreur lors de l\'envoi du lien de réinitialisation:', error)
    errorMessage.value = 'Une erreur est survenue. Veuillez réessayer.'
  } finally {
    isLoading.value = false
  }
}
</script>

<style scoped>
.animate-spin {
  animation: spin 1s linear infinite;
}

@keyframes spin {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}

.animate-slideIn {
  animation: slideIn 0.4s forwards;
}

@keyframes slideIn {
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