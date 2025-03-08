<template>
  <div>
    <form @submit.prevent="login" class="space-y-6">
      <!-- Email/Username -->
      <div>
        <label for="email" class="block text-sm font-medium text-gray-700 mb-1">
          Email ou nom d'utilisateur
        </label>
        <input
          id="email"
          v-model="form.email"
          type="text"
          required
          class="w-full px-4 py-3 bg-white border border-gray-200 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors"
          placeholder="nom@exemple.com"
        />
      </div>
      
      <!-- Mot de passe -->
      <div>
        <div class="flex items-center justify-between mb-1">
          <label for="password" class="block text-sm font-medium text-gray-700">
            Mot de passe
          </label>
          <NuxtLink to="/forgot-password" class="text-sm text-primary-600 hover:text-primary-700">
            Oublié?
          </NuxtLink>
        </div>
        <div class="relative">
          <input
            id="password"
            v-model="form.password"
            :type="showPassword ? 'text' : 'password'"
            required
            class="w-full px-4 py-3 bg-white border border-gray-200 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors"
            placeholder="••••••••"
          />
          <button 
            type="button"
            @click="showPassword = !showPassword"
            class="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-500"
          >
            <Eye v-if="!showPassword" class="h-5 w-5" />
            <EyeOff v-else class="h-5 w-5" />
          </button>
        </div>
      </div>
      
      <!-- Se souvenir de moi -->
      <div class="flex items-center">
        <input
          id="remember"
          v-model="form.remember"
          type="checkbox"
          class="h-4 w-4 text-primary-600 focus:ring-primary-500 border-gray-300 rounded"
        />
        <label for="remember" class="ml-2 block text-sm text-gray-700">
          Se souvenir de moi
        </label>
      </div>
      
      <!-- Message d'erreur -->
      <div v-if="error" class="bg-red-50 text-red-600 p-3 rounded-xl text-sm">
        {{ error }}
      </div>
      
      <!-- Bouton de connexion -->
      <button
        type="submit"
        :disabled="loading"
        class="w-full bg-primary-500 hover:bg-primary-600 text-white rounded-full py-3.5 px-4 flex items-center justify-center font-bold text-lg transition-colors shadow-sm disabled:opacity-70"
      >
        <Loader2 v-if="loading" class="animate-spin mr-2 h-5 w-5" />
        {{ loading ? 'Connexion en cours...' : 'Se connecter' }}
      </button>
      
      <!-- Séparateur -->
      <div class="relative">
        <div class="absolute inset-0 flex items-center">
          <div class="w-full border-t border-gray-200"></div>
        </div>
        <div class="relative flex justify-center text-sm">
          <span class="px-2 bg-white text-gray-500">ou continuer avec</span>
        </div>
      </div>
      
      <!-- Authentification sociale -->
      <div class="grid grid-cols-2 gap-4">
        <button
          type="button"
          class="flex items-center justify-center py-2.5 border border-gray-200 rounded-xl hover:bg-gray-50 transition-colors"
        >
          <img src="/icons/google.svg" alt="Google" class="h-5 w-5 mr-2" />
          <span class="text-gray-700 font-medium">Google</span>
        </button>
        <button
          type="button"
          class="flex items-center justify-center py-2.5 border border-gray-200 rounded-xl hover:bg-gray-50 transition-colors"
        >
          <img src="/icons/facebook.svg" alt="Facebook" class="h-5 w-5 mr-2" />
          <span class="text-gray-700 font-medium">Facebook</span>
        </button>
      </div>
      
      <!-- Lien d'inscription -->
      <div class="text-center pt-4">
        <p class="text-gray-600 text-sm">
          Pas encore de compte? 
          <NuxtLink to="/register" class="text-primary-600 hover:text-primary-700 font-medium">
            Inscrivez-vous
          </NuxtLink>
        </p>
      </div>
    </form>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { useSupabaseClient } from '#imports'
import { Eye, EyeOff, Loader2 } from 'lucide-vue-next'

const client = useSupabaseClient()
const router = useRouter()

// États
const form = reactive({
  email: '',
  password: '',
  remember: false
})
const loading = ref(false)
const error = ref(null)
const showPassword = ref(false)

// Connexion
const login = async () => {
  loading.value = true
  error.value = null
  
  try {
    const { data, error: err } = await client.auth.signInWithPassword({
      email: form.email,
      password: form.password
    })
    
    if (err) throw err
    
    // Redirection après connexion réussie
    router.push('/account')
  } catch (err) {
    console.error('Erreur de connexion:', err)
    error.value = err.message === 'Invalid login credentials'
      ? 'Identifiants incorrects. Veuillez vérifier votre email et mot de passe.'
      : `Erreur: ${err.message}`
  } finally {
    loading.value = false
  }
}

// Configuration de la page
definePageMeta({
  layout: 'auth'
})
</script> 