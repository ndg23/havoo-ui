<template>
  <div class="min-h-screen flex flex-col bg-white dark:bg-black">
    <!-- Côté visuel (visible uniquement sur desktop) -->
    <div class="fixed inset-0 z-0 hidden lg:block">
      <div class="absolute inset-0 bg-gradient-to-br from-primary-500/10 to-primary-700/20 dark:from-primary-900/20 dark:to-primary-800/10 z-0"></div>
      <div class="absolute right-0 bottom-0 w-3/4 h-3/4 bg-primary-50 dark:bg-primary-950 rounded-tl-[120px] opacity-30 dark:opacity-20 z-0"></div>
    </div>
    
    <!-- Contenu principal -->
    <div class="relative z-10 flex-1 flex flex-col justify-center px-6 py-12 lg:px-8 max-w-md mx-auto w-full">
      <!-- Logo -->
      <div class="mb-10 sm:mb-14">
        <Logo class="h-14 w-auto mx-auto" />
      </div>
      
      <!-- Titre -->
      <h1 class="text-4xl font-bold tracking-tight text-center text-gray-900 dark:text-white mb-2">
        Connexion
      </h1>
      <p class="text-center text-gray-600 dark:text-gray-400 mb-10">
        Accédez à votre espace
      </p>
      
      <!-- Notification d'erreur -->
      <div 
        v-if="errorMessage" 
        class="mb-6 p-4 bg-red-50 dark:bg-red-900/20 border-l-4 border-red-500 text-sm text-red-700 dark:text-red-400 animate-slideIn"
      >
        {{ errorMessage }}
      </div>

      <form class="space-y-6" @submit.prevent="login">
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

        <!-- Mot de passe -->
        <div class="space-y-2">
          <div class="flex items-center justify-between">
            <label for="password" class="block text-sm font-medium text-gray-700 dark:text-gray-300">
              Mot de passe
            </label>
            <div class="text-xs">
              <NuxtLink to="/forgot-password" class="font-medium text-primary-600 hover:text-primary-500 dark:text-primary-400">
                Oublié ?
              </NuxtLink>
            </div>
          </div>
          <div class="relative">
            <input
              id="password"
              v-model="password"
              :type="showPassword ? 'text' : 'password'"
              autocomplete="current-password"
              required
              class="w-full px-4 py-3 border border-gray-300 dark:border-gray-700 rounded-xl bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-shadow"
              :class="{'shadow-md': password}"
            />
            <button
              type="button"
              @click="showPassword = !showPassword"
              class="absolute inset-y-0 right-0 pr-4 flex items-center text-gray-400 hover:text-gray-600 dark:hover:text-gray-300"
            >
              <Eye v-if="showPassword" class="h-5 w-5" />
              <EyeOff v-else class="h-5 w-5" />
            </button>
          </div>
        </div>

        <!-- Se souvenir de moi -->
        <div class="flex items-center">
          <Switch
            v-model="rememberMe"
            :class="[rememberMe ? 'bg-primary-600' : 'bg-gray-200 dark:bg-gray-700', 'relative inline-flex h-5 w-10 flex-shrink-0 cursor-pointer rounded-full border-2 border-transparent transition-colors duration-200 ease-in-out focus:outline-none focus:ring-2 focus:ring-primary-500 focus:ring-offset-2']"
          >
            <span
              :class="[rememberMe ? 'translate-x-5' : 'translate-x-0', 'pointer-events-none relative inline-block h-4 w-4 transform rounded-full bg-white shadow ring-0 transition duration-200 ease-in-out']"
            />
          </Switch>
          <span class="ml-3 text-sm text-gray-700 dark:text-gray-300">Se souvenir de moi</span>
        </div>

        <!-- Bouton de connexion -->
        <div>
          <button
            type="submit"
            :disabled="isLoading"
            class="w-full flex justify-center py-3 px-4 border border-transparent rounded-xl shadow-sm text-base font-medium text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 disabled:bg-primary-400 transition-all duration-200 transform hover:scale-[1.02]"
          >
            <div v-if="isLoading" class="flex items-center">
              <div class="h-4 w-4 border-2 border-white/30 border-t-white rounded-full animate-spin mr-1.5"></div>
              <span>Connexion...</span>
            </div>
            <span v-else>Se connecter</span>
          </button>
        </div>
      </form>

      <!-- Options alternatives -->
      <div class="mt-8">
        <div class="relative">
          <div class="absolute inset-0 flex items-center">
            <div class="w-full border-t border-gray-200 dark:border-gray-700"></div>
          </div>
          <div class="relative flex justify-center text-sm">
            <span class="px-2 bg-white dark:bg-black text-gray-500 dark:text-gray-400">
              Ou
            </span>
          </div>
        </div>

        <div class="mt-6 grid grid-cols-1 gap-3">
          <button
            type="button"
            class="w-full inline-flex justify-center items-center py-3 px-4 border border-gray-300 dark:border-gray-700 rounded-xl shadow-sm bg-white dark:bg-gray-900 text-base font-medium text-gray-700 dark:text-gray-200 hover:bg-gray-50 dark:hover:bg-gray-800 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 transition-all duration-200"
          >
            <svg class="h-5 w-5 mr-3" fill="currentColor" viewBox="0 0 24 24">
              <path d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z" fill="#4285F4" />
              <path d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z" fill="#34A853" />
              <path d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z" fill="#FBBC05" />
              <path d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z" fill="#EA4335" />
            </svg>
            Continuer avec Google
          </button>
        </div>
      </div>

      <!-- Lien vers l'inscription -->
      <div class="mt-10 text-center">
        <p class="text-sm text-gray-600 dark:text-gray-400">
          Pas encore de compte ?
          <NuxtLink to="/signup" class="font-medium text-primary-600 hover:text-primary-500 dark:text-primary-400 ml-1">
            S'inscrire maintenant
          </NuxtLink>
        </p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { Eye, EyeOff } from 'lucide-vue-next'

const router = useRouter()

// États réactifs
const email = ref('')
const password = ref('')
const rememberMe = ref(false)
const showPassword = ref(false)
const isLoading = ref(false)
const errorMessage = ref('')

// Fonction de connexion
const login = async () => {
  // Réinitialiser les erreurs
  errorMessage.value = ''
  
  // Validation basique
  if (!email.value || !password.value) {
    errorMessage.value = 'Veuillez remplir tous les champs'
    return
  }
  
  isLoading.value = true
  
  try {
    // Dans un environnement réel, nous utiliserions Supabase
    /*
    const { user, error } = await supabase.auth.signIn({
      email: email.value,
      password: password.value
    }, {
      remember: rememberMe.value
    })
    
    if (error) throw error
    */
    
    // Simuler un délai
    await new Promise(resolve => setTimeout(resolve, 1500))
    
    // Simuler une vérification des identifiants (à supprimer en production)
    if (email.value === 'demo@example.com' && password.value === 'password') {
      // Rediriger vers le tableau de bord
      router.push('/profile')
    } else {
      errorMessage.value = 'Identifiants incorrects. Essayez avec demo@example.com / password'
    }
  } catch (error) {
    console.error('Erreur lors de la connexion:', error)
    errorMessage.value = 'Une erreur est survenue lors de la connexion. Veuillez réessayer.'
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
  animation: slideIn 0.3s forwards;
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