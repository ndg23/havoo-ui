<template>
  <div class="min-h-screen bg-white flex flex-col justify-center px-4 sm:px-6 lg:px-8">
    <div class="sm:mx-auto sm:w-full sm:max-w-md">
      <!-- <img class="mx-auto h-14 w-auto" src="/logo.svg" alt="Logo" /> -->
      <h1 class="mt-8 text-center text-3xl font-bold tracking-tight text-gray-900">
        Connectez-vous
      </h1>
      <p class="mt-2 text-center text-gray-600">
        Ou
        <NuxtLink to="/auth/register" class="font-medium text-primary-600 hover:text-primary-500">
          créez un compte
        </NuxtLink>
        en quelques clics
      </p>
    </div>

    <div class="mt-10 sm:mx-auto sm:w-full sm:max-w-md">
      <!-- Message de succès/erreur -->
      <div v-if="messageText" class="mb-6 rounded-lg p-4 text-sm" :class="messageType === 'success' ? 'bg-green-50 text-green-800' : 'bg-red-50 text-red-800'">
        {{ messageText }}
      </div>

      <!-- Boutons de connexion sociale -->
      <div class="space-y-3">
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
      </div>

      <div class="relative my-8">
        <div class="absolute inset-0 flex items-center">
          <div class="w-full border-t border-gray-200"></div>
        </div>
        <div class="relative flex justify-center">
          <span class="bg-white px-4 text-sm text-gray-500">ou</span>
        </div>
      </div>

      <!-- Formulaire de connexion -->
      <form @submit.prevent="login" class="space-y-5">
        <FloatingLabelInput
          id="email"
          label="Email"
          type="email"
          v-model="email"
          required
          autocomplete="email"
        />

        <div class="relative">
          <FloatingLabelInput
            id="password"
            label="Mot de passe"
            :type="showPassword ? 'text' : 'password'"
            v-model="password"
            required
            autocomplete="current-password"
          />
          <button 
            type="button"
            @click="showPassword = !showPassword"
            class="absolute right-4 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-600"
          >
            <svg v-if="showPassword" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
            </svg>
            <svg v-else class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.88 9.88l-3.29-3.29m7.532 7.532l3.29 3.29M3 3l3.59 3.59m0 0A9.953 9.953 0 0112 5c4.478 0 8.268 2.943 9.543 7a10.025 10.025 0 01-4.132 5.411m0 0L21 21" />
            </svg>
          </button>
        </div>

        <div class="flex items-center justify-between">
          <div class="flex items-center">
            <input
              id="remember-me"
              name="remember-me"
              type="checkbox"
              v-model="rememberMe"
              class="h-4 w-4 rounded border-gray-300 text-primary-600 focus:ring-primary-500"
            />
            <label for="remember-me" class="ml-2 block text-sm text-gray-700">
              Se souvenir de moi
            </label>
          </div>

          <div class="text-sm">
            <NuxtLink to="/auth/reset-password" class="font-medium text-primary-600 hover:text-primary-500">
              Mot de passe oublié?
            </NuxtLink>
          </div>
        </div>

        <div>
          <button
            type="submit"
            :disabled="isLoading"
            class="flex w-full justify-center items-center rounded-full bg-primary-600 px-6 py-3.5 text-base font-semibold text-white shadow-sm hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-primary-500 focus:ring-offset-2 disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
          >
            <span v-if="isLoading" class="inline-block h-4 w-4 animate-spin rounded-full border-2 border-solid border-current border-t-transparent mr-2"></span>
            Se connecter
          </button>
        </div>
      </form>
    </div>
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
</script>
