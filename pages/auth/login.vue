<template>
  <div class="max-w-md mx-auto px-6 py-16">
    <!-- En-tête -->
    <div class="mb-14 text-center">
      <h1 class="text-3xl font-semibold text-gray-900">
        Connexion à votre compte
      </h1>
      <p class="mt-3 text-gray-600">
        Bienvenue ! Connectez-vous pour continuer.
      </p>
    </div>

    <!-- Social Buttons -->
    <div class="space-y-4 mb-8">
      <button
        @click="signInWithGoogle"
        class="w-full flex items-center justify-center gap-3 px-4 py-4 rounded-full
          border border-gray-300 bg-white hover:bg-gray-50 transition-colors
          focus:outline-none focus:ring-2 focus:ring-blue-500"
      >
        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 256 262">
          <path fill="#4285F4" d="M255.878 133.451c0-10.734-.871-18.567-2.756-26.69H130.55v48.448h71.947c-1.45 12.04-9.283 30.172-26.69 42.356l-.244 1.622l38.755 30.023l2.685.268c24.659-22.774 38.875-56.282 38.875-96.027"></path>
          <path fill="#34A853" d="M130.55 261.1c35.248 0 64.839-11.605 86.453-31.622l-41.196-31.913c-11.024 7.688-25.82 13.055-45.257 13.055c-34.523 0-63.824-22.773-74.269-54.25l-1.531.13l-40.298 31.187l-.527 1.465C35.393 231.798 79.49 261.1 130.55 261.1"></path>
          <path fill="#FBBC05" d="M56.281 156.37c-2.756-8.123-4.351-16.827-4.351-25.82c0-8.994 1.595-17.697 4.206-25.82l-.073-1.73L15.26 71.312l-1.335.635C5.077 89.644 0 109.517 0 130.55s5.077 40.905 13.925 58.602z"></path>
          <path fill="#EB4335" d="M130.55 50.479c24.514 0 41.05 10.589 50.479 19.438l36.844-35.974C195.245 12.91 165.798 0 130.55 0C79.49 0 35.393 29.301 13.925 71.947l42.211 32.783c10.59-31.477 39.891-54.251 74.414-54.251"></path>
        </svg>
        <span class="text-base font-medium text-gray-700">Continuer avec Google</span>
      </button>

      <button
        @click="signInWithFacebook"
        class="w-full flex items-center justify-center gap-3 px-4 py-4 rounded-full
          border border-gray-300 bg-white hover:bg-gray-50 transition-colors
          focus:outline-none focus:ring-2 focus:ring-blue-500"
      >
        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 256 256">
          <path fill="#1877F2" d="M256 128C256 57.308 198.692 0 128 0S0 57.308 0 128c0 63.888 46.808 116.843 108 126.445V165H75.5v-37H108V99.8c0-32.08 19.11-49.8 48.348-49.8C170.352 50 185 52.5 185 52.5V84h-16.14C152.959 84 148 93.867 148 103.99V128h35.5l-5.675 37H148v89.445c61.192-9.602 108-62.556 108-126.445"></path>
          <path fill="#FFF" d="m177.825 165l5.675-37H148v-24.01C148 93.866 152.959 84 168.86 84H185V52.5S170.352 50 156.347 50C127.11 50 108 67.72 108 99.8V128H75.5v37H108v89.445A129 129 0 0 0 128 256a129 129 0 0 0 20-1.555V165z"></path>
        </svg>
        <span class="text-base font-medium text-gray-700">Continuer avec Facebook</span>
      </button>
    </div>

    <!-- Divider -->
    <div class="relative my-8">
      <div class="absolute inset-0 flex items-center">
        <div class="w-full border-t border-gray-200"></div>
      </div>
      <div class="relative flex justify-center">
        <span class="px-4 bg-white text-sm text-gray-500">ou</span>
      </div>
    </div>

    <!-- Login Form -->
    <form @submit.prevent="handleEmailLogin" class="space-y-8">
      <!-- Email Input -->
      <div class="space-y-2">
        <input
          v-model="email"
          id="email"
          type="email"
          placeholder="Adresse e-mail"
          required
          class="w-full p-4 text-xl border-b-2 border-gray-200 focus:border-blue-500 focus:outline-none transition-colors"
        />
      </div>

      <!-- Password Input -->
      <div class="space-y-2">
        <div class="relative">
          <input
            v-model="password"
            id="password"
            :type="showPassword ? 'text' : 'password'"
            placeholder="Mot de passe"
            required
            class="w-full p-4 text-xl border-b-2 border-gray-200 focus:border-blue-500 focus:outline-none transition-colors"
          />
          <button 
            type="button"
            @click="showPassword = !showPassword"
            class="absolute right-2 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-600"
          >
            <Eye v-if="!showPassword" class="h-5 w-5" />
            <EyeOff v-else class="h-5 w-5" />
          </button>
        </div>
        <div class="flex justify-end">
          <NuxtLink
            to="/auth/forgot-password"
            class="text-sm text-blue-600 hover:underline"
          >
            Mot de passe oublié ?
          </NuxtLink>
        </div>
      </div>

      <!-- Sign In Button -->
      <button
        type="submit"
        :disabled="loading"
        class="w-full py-4 bg-blue-600 text-white font-medium rounded-full
          hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed
          transition-colors shadow-md flex items-center justify-center mt-10"
      >
        <Loader2 v-if="loading" class="animate-spin -ml-1 mr-2 h-5 w-5" />
        {{ loading ? 'Connexion en cours...' : 'Se connecter' }}
      </button>
    </form>

    <!-- Error Alert -->
    <ErrorAlert 
      :message="error" 
      @dismiss="error = null"
      class="mt-6"
    />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { Eye, EyeOff, Loader2 } from 'lucide-vue-next'
import ErrorAlert from '~/components/ErrorAlert.vue'

const client = useSupabaseClient()
const router = useRouter()
const route = useRoute()

const email = ref('')
const password = ref('')
const loading = ref(false)
const error = ref(null)
const showPassword = ref(false)

const handleEmailLogin = async () => {
  try {
    loading.value = true
    error.value = null

    const { data: { user }, error: signInError } = await client.auth.signInWithPassword({
      email: email.value,
      password: password.value
    })

    if (signInError) {
      // Translate common errors
      switch (signInError.message) {
        case 'Invalid login credentials':
          throw new Error('Email ou mot de passe incorrect')
        case 'Email not confirmed':
          throw new Error('Veuillez confirmer votre email avant de vous connecter')
        default:
          throw signInError
      }
    }

    const { data: profile } = await client
      .from('profiles')
      .select('role')
      .eq('id', user.id)
      .single()

    router.push(profile?.role === 'admin' ? '/admin' : '/dashboard')
  } catch (e) {
    error.value = e.message
  } finally {
    loading.value = false
  }
}

const handleOAuthLogin = async (provider) => {
  try {
    const { error } = await client.auth.signInWithOAuth({
      provider,
      options: {
        redirectTo: `${window.location.origin}/auth/callback`,
        queryParams: provider === 'google' 
          ? { access_type: 'offline', prompt: 'consent', scope: 'email profile' }
          : undefined
      }
    })
    if (error) throw error
  } catch (e) {
    console.error(`Error ${provider}:`, e.message)
  }
}

const signInWithGoogle = () => handleOAuthLogin('google')
const signInWithFacebook = () => handleOAuthLogin('facebook')

onMounted(() => {
  const errorType = route.query.error
  if (errorType) {
    switch (errorType) {
      case 'auth_failed':
        error.value = "Échec de l'authentification"
        break
      case 'profile_creation_failed':
        error.value = "Impossible de créer votre profil"
        break
      case 'no_user':
        error.value = "Aucun utilisateur trouvé"
        break
      default:
        error.value = "Une erreur est survenue"
    }
  }
})

definePageMeta({
  auth: false,
  layout: 'auth'
})
</script>