<template>
  <div class="min-h-screen flex">
    <!-- Main Container -->
    <div class="flex-1 flex items-center justify-center bg-gray-50">
      <div class="w-full max-w-[400px] px-6">
        <!-- Logo and Header -->
        <div class="text-center mb-6">
          <Logo class="h-8 w-auto mx-auto" />
          <h1 class="mt-8 text-3xl font-bold text-gray-900">
            Connexion à Havoo
          </h1>
          <p class="text-sm text-gray-500">
            Connectez-vous à votre compte Havoo pour accéder à votre espace personnel.
          </p>
        </div>

        <!-- Login Form -->
        <form @submit.prevent="handleEmailLogin" class="space-y-5">
          <!-- Email Input -->
          <div class="relative">
            <input
              v-model="email"
              id="email"
              type="email"
              required
              placeholder=" "
              class="peer w-full pl-8 px-4 pt-6 pb-2 rounded-[14px] border border-gray-300 
                text-gray-900 text-base placeholder-transparent
                focus:border-primary-500 focus:ring-1 focus:ring-primary-500 
                transition-all duration-200"
            />
            <label 
              for="email"
              class="absolute left-4 top-4 text-gray-500 text-md transition-all duration-200 
                -translate-y-3 scale-75 peer-placeholder-shown:translate-y-0 
                peer-placeholder-shown:scale-100 peer-focus:-translate-y-2
                peer-focus:scale-75 peer-focus:text-primary-500 pointer-events-none"
            >
              Adresse e-mail
            </label>
          </div>

          <!-- Password Input -->
          <div class="relative">
            <input
              v-model="password"
              id="password"
              :type="showPassword ? 'text' : 'password'"
              required
              placeholder=" "
              class="peer w-full pl-8 px-4 pt-6 pb-2 rounded-[14px] border border-gray-300 
                text-gray-900 text-base placeholder-transparent
                focus:border-primary-500 focus:ring-1 focus:ring-primary-500 
                transition-all duration-200"
            />
            <label 
              for="password"
              class="absolute left-4 top-4 text-gray-500 text-md transition-all duration-200 
                -translate-y-3 scale-75 peer-placeholder-shown:translate-y-0 
                peer-placeholder-shown:scale-100 peer-focus:-translate-y-2
                peer-focus:scale-75 peer-focus:text-primary-500 pointer-events-none"
            >
              Mot de passe
            </label>
            <button 
              type="button"
              @click="showPassword = !showPassword"
              class="absolute right-4 top-1/2 -translate-y-1/2 text-gray-400 
                hover:text-gray-600 transition-colors"
            >
              <Eye v-if="!showPassword" class="w-5 h-5" />
              <EyeOff v-else class="w-5 h-5" />
            </button>
          </div>

          <!-- Sign In Button -->
          <button
            type="submit"
            :disabled="loading"
            class="w-full flex items-center justify-center px-4 py-3.5 rounded-[14px] 
              bg-gray-900 text-white font-medium text-base hover:bg-gray-800 
              focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-gray-900 
              transition-colors disabled:opacity-50 mt-6"
          >
            <Loader2 v-if="loading" class="w-5 h-5 animate-spin mr-2" />
            {{ loading ? 'Connexion...' : 'Se connecter' }}
          </button>
        </form>

        <!-- Add this after the form tag -->
        <ErrorAlert 
          :message="error" 
          @dismiss="error = null"
          class="mt-4"
        />

        <!-- Divider -->
        <div class="relative my-8">
          <div class="absolute inset-0 flex items-center">
            <div class="w-full border-t border-gray-200"></div>
          </div>
          <div class="relative flex justify-center text-sm">
            <span class="px-4 bg-gray-50 text-gray-500">ou </span>
          </div>
        </div>

        <!-- Social Buttons -->
        <div class="space-y-3">
          <button
            @click="signInWithGoogle"
            class="w-full flex items-center justify-center gap-3 px-4 py-3.5 rounded-[14px]
              border border-gray-300 bg-white hover:bg-gray-50 transition-colors
              focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-gray-500"
          >
          <svg xmlns="http://www.w3.org/2000/svg" width="0.98em" height="1em" viewBox="0 0 256 262"><!-- Icon from SVG Logos by Gil Barbara - https://raw.githubusercontent.com/gilbarbara/logos/master/LICENSE.txt --><path fill="#4285F4" d="M255.878 133.451c0-10.734-.871-18.567-2.756-26.69H130.55v48.448h71.947c-1.45 12.04-9.283 30.172-26.69 42.356l-.244 1.622l38.755 30.023l2.685.268c24.659-22.774 38.875-56.282 38.875-96.027"></path><path fill="#34A853" d="M130.55 261.1c35.248 0 64.839-11.605 86.453-31.622l-41.196-31.913c-11.024 7.688-25.82 13.055-45.257 13.055c-34.523 0-63.824-22.773-74.269-54.25l-1.531.13l-40.298 31.187l-.527 1.465C35.393 231.798 79.49 261.1 130.55 261.1"></path><path fill="#FBBC05" d="M56.281 156.37c-2.756-8.123-4.351-16.827-4.351-25.82c0-8.994 1.595-17.697 4.206-25.82l-.073-1.73L15.26 71.312l-1.335.635C5.077 89.644 0 109.517 0 130.55s5.077 40.905 13.925 58.602z"></path><path fill="#EB4335" d="M130.55 50.479c24.514 0 41.05 10.589 50.479 19.438l36.844-35.974C195.245 12.91 165.798 0 130.55 0C79.49 0 35.393 29.301 13.925 71.947l42.211 32.783c10.59-31.477 39.891-54.251 74.414-54.251"></path></svg>
          <span class="text-base font-medium text-gray-700">Continuer avec Google</span>
          </button>

          <button
            @click="signInWithFacebook"
            class="w-full flex items-center justify-center gap-3 px-4 py-3.5 rounded-[14px]
              border border-gray-300 bg-white hover:bg-gray-50 transition-colors
              focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-gray-500"
          >
          <svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 256 256"><!-- Icon from SVG Logos by Gil Barbara - https://raw.githubusercontent.com/gilbarbara/logos/master/LICENSE.txt --><path fill="#1877F2" d="M256 128C256 57.308 198.692 0 128 0S0 57.308 0 128c0 63.888 46.808 116.843 108 126.445V165H75.5v-37H108V99.8c0-32.08 19.11-49.8 48.348-49.8C170.352 50 185 52.5 185 52.5V84h-16.14C152.959 84 148 93.867 148 103.99V128h35.5l-5.675 37H148v89.445c61.192-9.602 108-62.556 108-126.445"></path><path fill="#FFF" d="m177.825 165l5.675-37H148v-24.01C148 93.866 152.959 84 168.86 84H185V52.5S170.352 50 156.347 50C127.11 50 108 67.72 108 99.8V128H75.5v37H108v89.445A129 129 0 0 0 128 256a129 129 0 0 0 20-1.555V165z"></path></svg>
          <span class="text-base font-medium text-gray-700">Continuer avec Facebook</span>
          </button>
        </div>

        <!-- Footer Links -->
        <div class="mt-8 space-y-4">
          <p class="text-center">
            <NuxtLink
              to="/auth/forgot-password"
              class="text-sm text-primary-600 hover:text-primary-700 font-medium"
            >
              Mot de passe oublié ?
            </NuxtLink>
          </p>
          <p class="text-center text-sm text-gray-600">
            Vous n'avez pas de compte ?
            <NuxtLink
              to="/auth/register"
              class="font-medium text-primary-600 hover:text-primary-700"
            >
              Créer un compte
            </NuxtLink>
          </p>
        </div>
      </div>
    </div>

    <!-- Background Pattern -->
    <!-- <div class="hidden lg:block relative w-0 flex-1 bg-gradient-to-br from-gray-900 to-gray-800">
      <div class="absolute inset-0" style="background-image: radial-gradient(rgba(255, 255, 255, 0.1) 1px, transparent 1px); background-size: 24px 24px;"></div>
    </div> -->
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { Chrome, Facebook, Mail, Lock, Eye, EyeOff, Loader2 } from 'lucide-vue-next'
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
  layout:'auth'
})
</script>