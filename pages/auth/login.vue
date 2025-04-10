<template>
  <div class="min-h-screen bg-white dark:bg-gray-900">
    <!-- Header -->
    <header class="fixed top-0 left-0 right-0 h-14 bg-white/80 dark:bg-gray-900/80 backdrop-blur-sm border-b border-gray-100 dark:border-gray-800">
      <div class="max-w-lg mx-auto px-4 h-full flex items-center">
        <Logo class="w-8 h-8" />
      </div>
    </header>

    <!-- Main content -->
    <main class="pt-20 pb-10 px-4 max-w-lg mx-auto sm:mx-auto sm:w-full sm:max-w-md">
      <div class="max-w-lg mx-auto">
        <div class="text-center mb-12">
          <h1 class="text-5xl font-extrabold text-gray-900 mb-4">
            Se connecter à Keetaf
          </h1>
      <p class="mt-2 text-center text-gray-600">
        Ou
        <NuxtLink to="/auth/register" class="font-medium text-primary-600 hover:text-primary-500">
          créez un compte
        </NuxtLink>
        en quelques clics
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

        <!-- Bouton Google -->
        <button
          @click="socialLogin('google')"
          type="button"
          class="flex w-full justify-center items-center gap-3 rounded-full border border-gray-300 bg-white px-6 py-3.5 text-base font-medium text-gray-700 shadow-sm hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-primary-500 focus:ring-offset-2"
        >
        <svg class="w-5 h-5 mr-2" viewBox="0 0 24 24" fill="currentColor">
                <path d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z" fill="#4285F4"/>
                <path d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z" fill="#34A853"/>
                <path d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z" fill="#FBBC05"/>
                <path d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z" fill="#EA4335"/>
              </svg>
          Continuer avec Google
        </button>

        <!-- Séparateur -->
        <div class="relative my-6">
          <div class="absolute inset-0 flex items-center">
            <div class="w-full border-t border-gray-200 dark:border-gray-700"></div>
          </div>
          <div class="relative flex justify-center text-sm">
            <span class="px-4 bg-white dark:bg-gray-900 text-gray-500">ou</span>
          </div>
        </div>

        <!-- Formulaire -->
        <form @submit.prevent="login" class="space-y-4">
          <FloatingLabelInput
            id="email"
            v-model="email"
            type="email"
            label="Adresse email"
            required
            autocomplete="email"
          />

          <div class="relative">
            <FloatingLabelInput
              id="password"
              v-model="password"
              :type="showPassword ? 'text' : 'password'"
              label="Mot de passe"
              required
              autocomplete="current-password"
            />
            <button 
              type="button"
              @click="showPassword = !showPassword"
              class="absolute right-4 top-1/2 -translate-y-1/2 p-2 text-gray-400 hover:text-gray-600"
            >
              <UIcon 
                :name="showPassword ? 'i-heroicons-eye' : 'i-heroicons-eye-slash'" 
                class="w-5 h-5"
              />
            </button>
          </div>

          <div class="flex items-center justify-end pt-2">
            <!-- <label class="flex items-center gap-2">
              <input 
                type="checkbox" 
                v-model="rememberMe"
                class="w-4 h-4 rounded text-primary focus:ring-primary border-gray-300"
              />
              <span class="text-sm text-gray-600 dark:text-gray-400">
                Se souvenir de moi
              </span>
            </label> -->
            <NuxtLink 
              to="/auth/reset-password"
              class="text-sm text-primary hover:text-primary-600 transition-colors"
            >
              Mot de passe oublié ?
            </NuxtLink>
          </div>

          <!-- Bouton de connexion -->
          <button
            type="submit"
            :disabled="isLoading"
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
            <span>{{ isLoading ? 'Connexion...' : 'Se connecter' }}</span>
          </button>
        </form>

        <!-- Lien d'inscription -->
        <p class="mt-8 text-center text-[15px] text-gray-600 dark:text-gray-400">
          Pas encore de compte ?
          <NuxtLink 
            to="/auth/register"
            class="text-black dark:text-white hover:text-gray-800 dark:hover:text-gray-200 
                   font-medium transition-colors"
          >
            S'inscrire
          </NuxtLink>
        </p>
      </div>
    </main>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useSupabaseClient } from '#imports'
import FloatingLabelInput from '~/components/ui/FloatingLabelInput.vue'

// Données du formulaire
const email = ref('')
const password = ref('')
const rememberMe = ref(false)
const showPassword = ref(false)

// État
const isLoading = ref(false)
const messageText = ref('')
const messageType = ref('error')

// Services
const router = useRouter()
const route = useRoute()
const supabase = useSupabaseClient()

// Vérifier le message d'URL au chargement
onMounted(() => {
  if (route.query.message) {
    messageText.value = route.query.message
    messageType.value = 'success'
    
    // Nettoyer l'URL après quelques secondes
    setTimeout(() => {
      router.replace({ query: {} })
    }, 5000)
  }
})

// Connexion avec email/password
const login = async () => {
  isLoading.value = true
  messageText.value = ''
  
  try {
    const { data, error } = await supabase.auth.signInWithPassword({
      email: email.value,
      password: password.value
    })
    
    if (error) throw error
    
    if (data.user) {
      router.push('/')
    }
  } catch (error) {
    console.error('Erreur de connexion:', error)
    
    if (error.message.includes('Invalid login credentials')) {
      messageText.value = 'Email ou mot de passe incorrect'
    } else if (error.message.includes('Email not confirmed')) {
      messageText.value = 'Veuillez confirmer votre email avant de vous connecter'
    } else if (error.message.includes('User not found')) {
      messageText.value = 'Aucun utilisateur trouvé avec cette adresse email'
    } else if (error.message.includes('missing email or phone')) {
      messageText.value = 'Veuillez entrer un mot de passe ou une adresse email'
    } else {
      messageText.value = error.message || 'Une erreur est survenue lors de la connexion'
    }
    
    messageType.value = 'error'
  } finally {
    isLoading.value = false
  }
}

// Connexion avec fournisseur social
const socialLogin = async (provider) => {
  try {
    const { error } = await supabase.auth.signInWithOAuth({
      provider,
      options: {
        redirectTo: `${window.location.origin}/auth/callback`
      }
    })
    
    if (error) throw error
  } catch (error) {
    console.error(`Erreur de connexion avec ${provider}:`, error)
    messageText.value = `Erreur de connexion avec ${provider}`
    messageType.value = 'error'
  }
}

// definePageMeta({
//   layout: 'auth'
// })

</script>

<style scoped>
.bg-grid-white {
  background-size: 40px 40px;
  background-image: linear-gradient(to right, rgba(255,255,255,0.1) 1px, transparent 1px),
    linear-gradient(to bottom, rgba(255,255,255,0.1) 1px, transparent 1px);
}

/* Effet de pression sur les boutons */
button:active:not(:disabled) {
  transform: scale(0.98);
}
</style>
