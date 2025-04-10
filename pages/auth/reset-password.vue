<template>
  <div class="min-h-screen bg-white dark:bg-gray-900">
    <!-- Header -->
    <header class="fixed top-0 left-0 right-0 h-14 bg-white/80 dark:bg-gray-900/80 backdrop-blur-sm border-b border-gray-100 dark:border-gray-800">
      <div class="max-w-lg mx-auto px-4 h-full flex items-center">
        <NuxtLink to="/auth/login" class="p-2 -ml-2 rounded-full hover:bg-gray-100 dark:hover:bg-gray-800 transition-colors">
          <UIcon name="i-heroicons-arrow-left" class="w-5 h-5 text-gray-700 dark:text-gray-300" />
        </NuxtLink>
      </div>
    </header>

    <!-- Main content -->
    <main class="pt-20 pb-10 px-4 max-w-lg mx-auto sm:mx-auto sm:w-full sm:max-w-md">
      <div class="max-w-lg mx-auto">
        <div class="text-center mb-12">
          <h1 class="text-5xl font-extrabold text-gray-900 dark:text-white mb-4">
            Mot de passe oublié ?
          </h1>
          <p class="text-xl text-gray-600 dark:text-gray-400">
            Entrez votre email pour réinitialiser votre mot de passe
          </p>
        </div>

        <!-- Message d'erreur/succès -->
        <div 
          v-if="messageText" 
          class="mb-6 p-4 rounded-xl text-sm flex items-center gap-3"
          :class="messageType === 'success' ? 'bg-green-50 text-green-800' : 'bg-red-50 text-red-800'"
        >
          <UIcon 
            :name="messageType === 'success' ? 'i-heroicons-check-circle' : 'i-heroicons-exclamation-circle'" 
            class="w-5 h-5 flex-shrink-0"
          />
          {{ messageText }}
        </div>

        <!-- Formulaire -->
        <form @submit.prevent="handleReset" class="space-y-4">
          <FloatingLabelInput
            id="email"
            v-model="email"
            type="email"
            label="Adresse email"
            required
            autocomplete="email"
          />

          <button
            type="submit"
            :disabled="isLoading || !email"
            class="relative w-full h-14 rounded-full font-medium text-lg
                   bg-black dark:bg-white text-white dark:text-gray-900
                   hover:bg-gray-800 dark:hover:bg-gray-100
                   disabled:opacity-50 disabled:cursor-not-allowed 
                   transition-all duration-200 transform hover:scale-[1.02]
                   flex items-center justify-center gap-3 mt-6"
          >
            <UIcon 
              v-if="isLoading"
              name="i-heroicons-arrow-path" 
              class="w-5 h-5 animate-spin"
            />
            <span>{{ isLoading ? 'Envoi en cours...' : 'Réinitialiser le mot de passe' }}</span>
          </button>
        </form>

        <!-- Lien de retour -->
        <p class="mt-8 text-center text-[15px] text-gray-600 dark:text-gray-400">
          Vous vous souvenez de votre mot de passe ?
          <NuxtLink 
            to="/auth/login"
            class="text-black dark:text-white hover:text-gray-800 dark:hover:text-gray-200 
                   font-medium transition-colors"
          >
            Se connecter
          </NuxtLink>
        </p>
      </div>
    </main>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useSupabaseClient } from '#imports'

const router = useRouter()
const supabase = useSupabaseClient()

// États
const email = ref('')
const isLoading = ref(false)
const messageText = ref('')
const messageType = ref('error')

// Gestion de la réinitialisation
const handleReset = async () => {
  if (!email.value) return
  
  isLoading.value = true
  messageText.value = ''
  
  try {
    const { error } = await supabase.auth.resetPasswordForEmail(email.value, {
      redirectTo: `${window.location.origin}/auth/update-password`
    })
    
    if (error) throw error
    
    messageText.value = 'Un email de réinitialisation vous a été envoyé'
    messageType.value = 'success'
    
    // Redirection après quelques secondes
    setTimeout(() => {
      router.push('/auth/login?message=Vérifiez votre boîte mail pour réinitialiser votre mot de passe')
    }, 3000)
  } catch (error) {
    console.error('Erreur:', error)
    
    if (error.message.includes('User not found')) {
      messageText.value = 'Aucun compte trouvé avec cette adresse email'
    } else {
      messageText.value = 'Une erreur est survenue lors de l\'envoi de l\'email'
    }
    messageType.value = 'error'
  } finally {
    isLoading.value = false
  }
}
</script>

<style scoped>
/* Effet de pression sur les boutons */
button:active:not(:disabled) {
  transform: scale(0.98);
}
</style>
