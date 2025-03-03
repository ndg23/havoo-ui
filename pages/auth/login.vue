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
      <div class="bg-white rounded-xl -shadow-sm border border-gray-200 p-6">
        <form @submit.prevent="handleSubmit" class="space-y-5">
          <!-- Email Input -->
          <div class="relative">
            <input
              v-model="form.email"
              type="email"
              required
              class="peer w-full h-14 px-4 pt-2 rounded-xl border-2 border-gray-200 placeholder-transparent focus:border-blue-500 focus:ring-0 focus:outline-none transition-colors"
              placeholder=" "
              :class="{ 'border-red-300': errors.email }"
            />
            <label 
              class="absolute left-4 top-4 text-gray-500 text-sm transition-all duration-200 
                -translate-y-3 scale-85 peer-placeholder-shown:translate-y-0 
                peer-placeholder-shown:scale-100 peer-focus:-translate-y-3 
                peer-focus:scale-85"
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
              class="peer w-full h-14 px-4 pt-2 rounded-xl border-2 border-gray-200 placeholder-transparent focus:border-blue-500 focus:ring-0 focus:outline-none transition-colors"
              placeholder=" "
              :class="{ 'border-red-300': errors.password }"
            />
            <label 
              class="absolute left-4 top-4 text-gray-500 text-sm transition-all duration-200 
                -translate-y-3 scale-85 peer-placeholder-shown:translate-y-0 
                peer-placeholder-shown:scale-100 peer-focus:-translate-y-3 
                peer-focus:scale-85"
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

          <!-- Remember Me & Forgot Password -->
          <div class="flex items-center justify-between">
            <label class="flex items-center gap-2">
              <input
                v-model="form.remember"
                type="checkbox"
                class="w-4 h-4 rounded border-gray-300 text-blue-600 focus:ring-blue-500"
              />
              <span class="text-sm text-gray-600">Se souvenir de moi</span>
            </label>
            <NuxtLink 
              to="/auth/forgot-password"
              class="text-sm text-blue-600 hover:text-blue-700 font-medium"
            >
              Mot de passe oublié ?
            </NuxtLink>
          </div>

          <!-- Submit Button -->
          <button
            type="submit"
            class="w-full bg-blue-600 text-white h-12 rounded-xl font-medium hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 transition-colors"
            :class="{ 'opacity-50 cursor-not-allowed': loading }"
            :disabled="loading"
          >
            <span v-if="loading">Connexion en cours...</span>
            <span v-else>Se connecter</span>
          </button>

          <!-- Divider -->
          <div class="relative my-8">
            <div class="absolute inset-0 flex items-center">
              <div class="w-full border-t border-gray-200"></div>
            </div>
            <div class="relative flex justify-center text-sm">
              <span class="px-4 bg-white text-gray-500">ou</span>
            </div>
          </div>

          <!-- Social Login -->
          <div class="space-y-3">
            <button
              type="button"
              @click="signInWithGoogle"
              class="w-full h-12 px-4 flex items-center justify-center gap-3 border-2 border-gray-200 rounded-xl text-gray-700 hover:bg-gray-50 font-medium transition-colors"
            >
              Continuer avec Google
            </button>
          </div>
        </form>
      </div>

      <!-- Register Link -->
      <p class="mt-8 text-center text-sm text-gray-600">
        Pas encore de compte ?
        <NuxtLink 
          to="/auth/register" 
          class="font-medium text-blue-600 hover:text-blue-700"
        >
          Créer un compte
        </NuxtLink>
      </p>
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