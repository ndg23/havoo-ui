<template>
  <div class="min-h-screen flex flex-col lg:flex-row">
    <!-- Section gauche (Formulaire) -->
    <div class="flex-1 flex flex-col justify-center px-4 sm:px-6 lg:px-20 xl:px-24 bg-white">
      <div class="w-full max-w-md mx-auto space-y-10">
        <!-- Logo et Titre -->
        <div>
          <Logo class="h-12 w-auto mx-auto lg:mx-0" />
          <h1 class="mt-10 text-4xl font-bold tracking-tight text-gray-900">
            Bienvenue
          </h1>
          <p class="mt-3 text-base text-gray-600">
            Connectez-vous pour accéder à votre espace
          </p>
        </div>

        <!-- Formulaire -->
        <form @submit.prevent="handleEmailLogin" class="space-y-6">
          <!-- Email -->
          <div class="relative">
            <Mail class="w-5 h-5 text-gray-400 absolute left-3 top-1/2 -translate-y-1/2 pointer-events-none" />
            <input
              v-model="email"
              id="email"
              type="email"
              required
              class="peer w-full pl-10 pr-4 py-4 pt-6 text-gray-900 rounded-xl border-2 border-gray-200 
                focus:border-primary-500 focus:ring-0 placeholder-transparent transition-all duration-200"
              placeholder="Email"
            />
            <label 
              for="email"
              class="absolute left-10 top-4 text-gray-500 text-sm transition-all duration-200 
                -translate-y-3 scale-85 peer-placeholder-shown:translate-y-0 
                peer-placeholder-shown:scale-100 peer-focus:-translate-y-3 
                peer-focus:scale-85 peer-focus:text-primary-600 pointer-events-none"
            >
              Adresse email
            </label>
          </div>

          <!-- Mot de passe -->
          <div class="relative">
            <Lock class="w-5 h-5 text-gray-400 absolute left-3 top-1/2 -translate-y-1/2 pointer-events-none" />
            <input
              v-model="password"
              id="password"
              :type="showPassword ? 'text' : 'password'"
              required
              class="peer w-full pl-10 pr-10 py-4 pt-6 text-gray-900 rounded-xl border-2 border-gray-200 
                focus:border-primary-500 focus:ring-0 placeholder-transparent transition-all duration-200"
              placeholder="Mot de passe"
            />
            <label 
              for="password"
              class="absolute left-10 top-4 text-gray-500 text-sm transition-all duration-200 
                -translate-y-3 scale-85 peer-placeholder-shown:translate-y-0 
                peer-placeholder-shown:scale-100 peer-focus:-translate-y-3 
                peer-focus:scale-85 peer-focus:text-primary-600 pointer-events-none"
            >
              Mot de passe
            </label>
            <button 
              type="button"
              @click="showPassword = !showPassword"
              class="absolute right-3 top-1/2 -translate-y-1/2 p-1 rounded-lg hover:bg-gray-100 transition-colors"
            >
              <Eye v-if="!showPassword" class="w-5 h-5 text-gray-400" />
              <EyeOff v-else class="w-5 h-5 text-gray-400" />
            </button>
          </div>

          <!-- Options -->
          <div class="flex items-center justify-between">
            <div class="flex items-center">
              <input
                id="remember-me"
                type="checkbox"
                class="h-4 w-4 rounded-lg border-2 border-gray-300 text-primary-600 focus:ring-primary-500"
              />
              <label for="remember-me" class="ml-2 block text-sm text-gray-600">
                Se souvenir de moi
              </label>
            </div>
            <NuxtLink
              to="/auth/forgot-password"
              class="text-sm font-medium text-primary-600 hover:text-primary-700"
            >
              Mot de passe oublié ?
            </NuxtLink>
          </div>

          <!-- Bouton de connexion -->
          <button
            type="submit"
            :disabled="loading"
            class="relative w-full inline-flex items-center justify-center px-6 py-4 text-base font-medium text-white 
              bg-primary-600 rounded-xl hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 
              focus:ring-primary-500 transition-all duration-200 disabled:opacity-50 disabled:hover:bg-primary-600
              shadow-lg shadow-primary-600/25 hover:shadow-xl hover:shadow-primary-600/30"
          >
            <Loader2 v-if="loading" class="w-5 h-5 animate-spin mr-2" />
            <span>{{ loading ? 'Connexion en cours...' : 'Se connecter' }}</span>
          </button>
        </form>

        <!-- Séparateur -->
        <div class="relative">
          <div class="absolute inset-0 flex items-center">
            <div class="w-full border-t border-gray-200" />
          </div>
          <div class="relative flex justify-center text-sm">
            <span class="px-4 bg-white text-gray-500">ou continuer avec</span>
          </div>
        </div>

        <!-- Boutons de connexion sociale -->
        <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
          <button
            @click="signInWithGoogle"
            class="group relative flex items-center justify-center gap-3 px-4 py-3.5 border-2 border-gray-200 
              rounded-xl hover:border-gray-300 transition-all duration-200 bg-white hover:bg-gray-50"
          >
            <Chrome class="w-5 h-5 text-[#4285F4]" />
            <span class="text-sm font-medium text-gray-700">Google</span>
          </button>

          <button
            @click="signInWithFacebook"
            class="group relative flex items-center justify-center gap-3 px-4 py-3.5 border-2 border-gray-200 
              rounded-xl hover:border-gray-300 transition-all duration-200 bg-white hover:bg-gray-50"
          >
            <Facebook class="w-5 h-5 text-[#1877F2]" />
            <span class="text-sm font-medium text-gray-700">Facebook</span>
          </button>
        </div>

        <!-- Lien inscription -->
        <p class="text-center text-sm text-gray-600">
          Pas encore de compte ?
          <NuxtLink
            to="/auth/register"
            class="font-medium text-primary-600 hover:text-primary-700"
          >
            S'inscrire gratuitement
          </NuxtLink>
        </p>
      </div>
    </div>

    <!-- Section droite (Background) -->
    <div class="hidden lg:block relative w-0 flex-1">
      <div class="absolute inset-0 bg-gradient-to-br from-primary-600 to-primary-800">
        <div class="absolute inset-0 bg-grid-white/[0.05] bg-[length:32px_32px]" />
        <div class="absolute inset-0 flex items-center justify-center p-12">
          <div class="max-w-xl text-center">
            <h2 class="text-5xl font-bold text-white mb-6">
              Trouvez l'expert qu'il vous faut
            </h2>
            <p class="text-xl text-white/90">
              Accédez à notre réseau d'experts qualifiés pour tous vos besoins de services
            </p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { Chrome, Apple, Facebook, Mail, Lock, Eye, EyeOff, Loader2 } from 'lucide-vue-next'

const client = useSupabaseClient()
const router = useRouter()

// État
const email = ref('')
const password = ref('')
const loading = ref(false)
const error = ref(null)
const showPassword = ref(false)

// Connexion email/mot de passe
const handleEmailLogin = async () => {
  try {
    loading.value = true
    error.value = null

    const { data: { user }, error: signInError } = await client.auth.signInWithPassword({
      email: email.value,
      password: password.value
    })

    if (signInError) throw signInError

    // Vérifier le rôle
    const { data: profile } = await client
      .from('profiles')
      .select('role')
      .eq('id', user.id)
      .single()

    if (profile?.role === 'admin') {
      router.push('/admin')
    } else {
      router.push('/dashboard')
    }

  } catch (e) {
    error.value = e.message
  } finally {
    loading.value = false
  }
}

// Connexion OAuth
const handleOAuthLogin = async (provider) => {
  try {
    const { data, error } = await client.auth.signInWithOAuth({
      provider,
      options: {
        redirectTo: `${window.location.origin}/auth/callback`,
        queryParams: provider === 'google' 
          ? { access_type: 'offline', prompt: 'consent' }
          : undefined
      }
    })

    if (error) throw error

  } catch (e) {
    console.error(`Erreur ${provider}:`, e.message)
  }
}

// Méthodes de connexion sociale
const signInWithGoogle = () => handleOAuthLogin('google')
const signInWithApple = () => handleOAuthLogin('apple')
const signInWithFacebook = () => handleOAuthLogin('facebook')
const signInWithMicrosoft = () => handleOAuthLogin('azure')

// Protection de la route
definePageMeta({

})
</script>

<style scoped>
.bg-grid-white {
  background-image: linear-gradient(to right, rgba(255, 255, 255, 0.1) 1px, transparent 1px),
    linear-gradient(to bottom, rgba(255, 255, 255, 0.1) 1px, transparent 1px);
}
</style>