<template>
  <div class="min-h-screen bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
    <div class="max-w-[400px] mx-auto">
      <!-- Logo -->
      <div class="text-center mb-8">
        <NuxtLink to="/" class="inline-flex items-center gap-2">
          <span class="text-3xl">⚡</span>
          <span class="text-2xl font-bold text-gray-900">DomiServices</span>
        </NuxtLink>
        <h2 class="mt-2 text-gray-600">Connectez-vous à votre compte</h2>
      </div>

      <!-- Auth Card -->
      <div class="bg-white rounded-xl -shadow-sm border border-gray-200 p-8">
        <form @submit.prevent="handleSubmit" class="space-y-5">
          <!-- Email Input -->
          <div class="relative">
            <input
              v-model="form.email"
              type="email"
              required
              class="peer w-full px-4 py-4 pt-6 rounded-xl border border-gray-200 focus:ring-primary-500 focus:border-primary-500 placeholder-transparent transition-all duration-200"
              placeholder="Email"
              :class="{ 'border-red-300': errors.email }"
            />
            <label 
              class="absolute left-4 top-4 text-gray-500 text-sm transition-all duration-200 
                -translate-y-3 scale-85 peer-placeholder-shown:translate-y-0 
                peer-placeholder-shown:scale-100 peer-focus:-translate-y-3 
                peer-focus:scale-85 pointer-events-none"
            >
              Adresse email
            </label>
            <p v-if="errors.email" class="mt-1 text-xs text-red-500">
              {{ errors.email }}
            </p>
          </div>

          <!-- Password Input -->
          <div class="relative">
            <input
              v-model="form.password"
              :type="showPassword ? 'text' : 'password'"
              required
              class="peer w-full px-4 py-4 pt-6 rounded-xl border border-gray-200 focus:ring-primary-500 focus:border-primary-500 placeholder-transparent transition-all duration-200"
              placeholder="Password"
              :class="{ 'border-red-300': errors.password }"
            />
            <label 
              class="absolute left-4 top-4 text-gray-500 text-sm transition-all duration-200 
                -translate-y-3 scale-85 peer-placeholder-shown:translate-y-0 
                peer-placeholder-shown:scale-100 peer-focus:-translate-y-3 
                peer-focus:scale-85 pointer-events-none"
            >
              Mot de passe
            </label>
            <button 
              type="button"
              @click="showPassword = !showPassword"
              class="absolute right-4 top-1/2 -translate-y-1/2 text-gray-500 hover:text-gray-700"
            >
              <EyeIcon v-if="showPassword" class="w-5 h-5" />
              <EyeSlashIcon v-else class="w-5 h-5" />
            </button>
            <p v-if="errors.password" class="mt-1 text-xs text-red-500">
              {{ errors.password }}
            </p>
          </div>

          <!-- Remember & Forgot -->
          <div class="flex items-center justify-between">
            <label class="flex items-center">
              <input
                v-model="form.remember"
                type="checkbox"
                class="w-4 h-4 rounded border-gray-300 text-primary-500 focus:ring-primary-500"
              />
              <span class="ml-2 text-sm text-gray-600">Se souvenir de moi</span>
            </label>
            <NuxtLink 
              to="/auth/forgot-password"
              class="text-sm text-primary-600 hover:text-primary-700"
            >
              Mot de passe oublié ?
            </NuxtLink>
          </div>

          <!-- Submit Button -->
          <button
            type="submit"
            class="w-full py-4 bg-primary-500 text-white font-medium rounded-xl hover:bg-primary-600 transition-colors"
            :class="{ 'opacity-75 cursor-not-allowed': loading }"
            :disabled="loading"
          >
            <span v-if="loading">Connexion en cours...</span>
            <span v-else>Se connecter</span>
          </button>

          <!-- Social Login -->
          <div class="relative my-6">
            <div class="absolute inset-0 flex items-center">
              <div class="w-full border-t border-gray-200"></div>
            </div>
            <div class="relative flex justify-center text-sm">
              <span class="px-4 bg-white text-gray-500">Ou continuer avec</span>
            </div>
          </div>

          <button
            type="button"
            @click="signInWithGoogle"
            class="w-full py-3 px-4 flex items-center justify-center gap-3 bg-white border-2 border-gray-200 rounded-xl hover:bg-gray-50 transition-colors"
          >
            <svg class="w-5 h-5" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
              <path d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z" fill="#4285F4"/>
              <path d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z" fill="#34A853"/>
              <path d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z" fill="#FBBC05"/>
              <path d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z" fill="#EA4335"/>
            </svg>
            <span class="text-gray-700 font-medium">Google</span>
          </button>

          <!-- Register Link -->
          <p class="text-center text-sm text-gray-600">
            Pas encore de compte ?
            <NuxtLink to="/auth/register" class="text-primary-600 hover:text-primary-700 font-medium">
              S'inscrire
            </NuxtLink>
          </p>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { EyeIcon, EyeSlashIcon } from '@heroicons/vue/24/outline'

const client = useSupabaseClient()
const loading = ref(false)
const showPassword = ref(false)

const form = reactive({
  email: '',
  password: '',
  remember: false
})

const errors = reactive({
  email: '',
  password: ''
})

const handleSubmit = async () => {
  // Reset errors
  errors.email = ''
  errors.password = ''

  try {
    loading.value = true
    const { error } = await client.auth.signInWithPassword({
      email: form.email,
      password: form.password
    })

    if (error) throw error

    // Redirect to dashboard
    navigateTo('/dashboard')
  } catch (error) {
    if (error.message.includes('email')) {
      errors.email = 'Email invalide'
    } else if (error.message.includes('password')) {
      errors.password = 'Mot de passe incorrect'
    } else {
      console.error('Error:', error.message)
    }
  } finally {
    loading.value = false
  }
}

const signInWithGoogle = async () => {
  try {
    const { error } = await client.auth.signInWithOAuth({
      provider: 'google'
    })
    if (error) throw error
  } catch (error) {
    console.error('Error:', error.message)
  }
}

definePageMeta({
  layout: 'auth'
})
</script>