<template>
  <div class="space-y-4">
    <!-- Google -->
    <button
      type="button"
      @click="signInWithProvider('google')"
      :disabled="isLoading === 'google'"
      class="w-full flex items-center justify-center gap-3 px-4 py-3 border border-gray-300 dark:border-gray-600 rounded-full bg-white dark:bg-gray-800 hover:bg-gray-50 dark:hover:bg-gray-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 transition-colors"
    >
      <svg v-if="!isLoading || isLoading !== 'google'" class="h-5 w-5" viewBox="0 0 24 24">
        <path d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z" fill="#4285F4"/>
        <path d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z" fill="#34A853"/>
        <path d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z" fill="#FBBC05"/>
        <path d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z" fill="#EA4335"/>
      </svg>
      <svg
        v-else
        class="animate-spin h-5 w-5 text-gray-600 dark:text-gray-400"
        xmlns="http://www.w3.org/2000/svg"
        fill="none"
        viewBox="0 0 24 24"
      >
        <circle
          class="opacity-25"
          cx="12"
          cy="12"
          r="10"
          stroke="currentColor"
          stroke-width="4"
        />
        <path
          class="opacity-75"
          fill="currentColor"
          d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
        />
      </svg>
      <span class="text-gray-700 dark:text-gray-300 font-medium">
        {{ isLoading === 'google' ? 'Connexion en cours...' : 'Continuer avec Google' }}
      </span>
    </button>

    <!-- Apple -->
    <button
      type="button"
      @click="signInWithProvider('apple')"
      :disabled="isLoading === 'apple'"
      class="w-full flex items-center justify-center gap-3 px-4 py-3 border border-gray-300 dark:border-gray-600 rounded-full bg-white dark:bg-gray-800 hover:bg-gray-50 dark:hover:bg-gray-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 transition-colors"
    >
      <svg v-if="!isLoading || isLoading !== 'apple'" class="h-5 w-5 text-gray-900 dark:text-white" fill="currentColor" viewBox="0 0 24 24">
        <path d="M12.152 6.896c-.948 0-2.415-1.078-3.96-1.04-2.04.027-3.91 1.183-4.961 3.014-2.117 3.675-.546 9.103 1.519 12.09 1.013 1.454 2.208 3.09 3.792 3.039 1.52-.065 2.09-.987 3.935-.987 1.831 0 2.35.987 3.96.948 1.637-.026 2.676-1.48 3.676-2.948 1.156-1.688 1.636-3.325 1.662-3.415-.039-.013-3.182-1.221-3.22-4.857-.026-3.04 2.48-4.494 2.597-4.559-1.429-2.09-3.623-2.324-4.39-2.376-2-.156-3.675 1.09-4.61 1.09zM15.53 3.83c.843-1.012 1.4-2.427 1.245-3.83-1.207.052-2.662.805-3.532 1.818-.78.896-1.454 2.338-1.273 3.714 1.338.104 2.715-.688 3.559-1.701"/>
      </svg>
      <svg
        v-else
        class="animate-spin h-5 w-5 text-gray-600 dark:text-gray-400"
        xmlns="http://www.w3.org/2000/svg"
        fill="none"
        viewBox="0 0 24 24"
      >
        <circle
          class="opacity-25"
          cx="12"
          cy="12"
          r="10"
          stroke="currentColor"
          stroke-width="4"
        />
        <path
          class="opacity-75"
          fill="currentColor"
          d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
        />
      </svg>
      <span class="text-gray-700 dark:text-gray-300 font-medium">
        {{ isLoading === 'apple' ? 'Connexion en cours...' : 'Continuer avec Apple' }}
      </span>
    </button>

    <!-- Divider -->
    <div class="relative my-6">
      <div class="absolute inset-0 flex items-center">
        <div class="w-full border-t border-gray-300 dark:border-gray-600" />
      </div>
      <div class="relative flex justify-center text-sm">
        <span class="px-2 bg-white dark:bg-gray-800 text-gray-500 dark:text-gray-400">
          ou continuer avec
        </span>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import type { Provider } from '@supabase/supabase-js'
import { useAuth } from '~/composables/useAuth'

const { signInWithProvider } = useAuth()
const isLoading = ref<Provider | null>(null)

const emit = defineEmits<{
  (e: 'success'): void
  (e: 'error', error: Error): void
}>()

const handleProviderSignIn = async (provider: Provider) => {
  try {
    isLoading.value = provider
    const { success, error } = await signInWithProvider(provider)
    
    if (success) {
      emit('success')
    } else if (error) {
      throw error
    }
  } catch (error) {
    const authError = error as Error
    emit('error', authError)
  } finally {
    isLoading.value = null
  }
}
</script> 