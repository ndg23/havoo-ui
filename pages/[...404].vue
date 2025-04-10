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
      <div class="max-w-lg mx-auto text-center">
        <div class="mb-8">
          <div class="w-24 h-24 mx-auto mb-6 rounded-full bg-gray-100 dark:bg-gray-800 flex items-center justify-center">
            <UIcon name="i-heroicons-face-frown" class="w-12 h-12 text-gray-400" />
          </div>
          <h1 class="text-5xl font-extrabold text-gray-900 dark:text-white mb-4">
            404
          </h1>
          <p class="text-xl text-gray-600 dark:text-gray-400 mb-8">
            Oups ! Cette page n'existe pas.
          </p>
          <p class="text-gray-500 dark:text-gray-500 mb-12">
            La page que vous recherchez a peut-être été déplacée ou supprimée.
          </p>
        </div>

        <!-- Boutons d'action -->
        <div class="space-y-4">
          <button
            @click="router.back()"
            class="w-full h-14 rounded-full border-2 border-gray-200 dark:border-gray-700 font-medium 
                   bg-white dark:bg-gray-900 hover:bg-gray-50 dark:hover:bg-gray-800 
                   transition-all duration-200 transform hover:scale-[1.02]
                   flex items-center justify-center gap-3 text-gray-700 dark:text-white"
          >
            <UIcon name="i-heroicons-arrow-left" class="w-5 h-5" />
            <span>Retour</span>
          </button>

          <NuxtLink 
            to="/"
            class="relative w-full h-14 rounded-full font-medium text-lg
                   bg-black dark:bg-white text-white dark:text-gray-900
                   hover:bg-gray-800 dark:hover:bg-gray-100
                   transition-all duration-200 transform hover:scale-[1.02]
                   flex items-center justify-center gap-3"
          >
            <UIcon name="i-heroicons-home" class="w-5 h-5" />
            <span>Retour à l'accueil</span>
          </NuxtLink>
        </div>

        <!-- Liens utiles -->
        <div class="mt-12">
          <p class="text-sm text-gray-500 dark:text-gray-400">
            Liens utiles :
          </p>
          <div class="mt-3 flex items-center justify-center gap-6 text-sm">
            <NuxtLink 
              to="/contact"
              class="text-black dark:text-white hover:text-gray-800 dark:hover:text-gray-200 
                     font-medium transition-colors"
            >
              Contact
            </NuxtLink>
            <NuxtLink 
              to="/help"
              class="text-black dark:text-white hover:text-gray-800 dark:hover:text-gray-200 
                     font-medium transition-colors"
            >
              Aide
            </NuxtLink>
          </div>
        </div>
      </div>
    </main>
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router'

const router = useRouter()
</script>

<style scoped>
/* Effet de pression sur les boutons */
button:active:not(:disabled) {
  transform: scale(0.98);
}
</style> 