<template>
  <div class="min-h-screen bg-gray-50 dark:bg-gray-900">
    <!-- Header -->
    <header class="fixed top-0 left-0 right-0 z-30 bg-white dark:bg-gray-800 border-b border-gray-200 dark:border-gray-700">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex items-center justify-between h-16">
          <!-- Logo -->
          <NuxtLink to="/" class="flex-shrink-0">
            <Logo class="h-8 w-auto" />
          </NuxtLink>

          <!-- Navigation -->
          <nav class="hidden md:flex items-center space-x-4">
            <NuxtLink 
              v-for="link in navigationLinks"
              :key="link.to"
              :to="link.to"
              class="text-sm font-medium text-gray-700 dark:text-gray-300 hover:text-primary-600 dark:hover:text-primary-400"
            >
              {{ link.label }}
            </NuxtLink>
          </nav>

          <!-- Expert CTA -->
          <div class="flex items-center">
            <NuxtLink
              to="/auth/register-expert"
              class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-full shadow-sm text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500"
            >
              Devenir expert
            </NuxtLink>
          </div>
        </div>
      </div>
    </header>

    <!-- Main content -->
    <main class="pt-16 min-h-screen">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex min-h-[calc(100vh-4rem)] items-center justify-center py-12">
          <div class="w-full max-w-md space-y-8">
            <!-- Page header -->
            <div class="text-center">
              <h2 class="text-3xl font-bold tracking-tight text-gray-900 dark:text-white">
                {{ pageTitle }}
              </h2>
              <p class="mt-2 text-sm text-gray-600 dark:text-gray-400">
                {{ pageDescription }}
              </p>
            </div>

            <!-- Main content slot -->
            <div class="bg-white dark:bg-gray-800 py-8 px-4 shadow sm:rounded-lg sm:px-10">
              <slot />
            </div>

            <!-- Help links -->
            <div class="text-center space-y-4">
              <p class="text-sm text-gray-600 dark:text-gray-400">
                {{ helpText }}
                <NuxtLink 
                  :to="helpLink.to" 
                  class="font-medium text-primary-600 hover:text-primary-500 dark:text-primary-400"
                >
                  {{ helpLink.label }}
                </NuxtLink>
              </p>
            </div>
          </div>
        </div>
      </div>
    </main>

    <!-- Footer -->
    <footer class="bg-white dark:bg-gray-800 border-t border-gray-200 dark:border-gray-700">
      <div class="max-w-7xl mx-auto py-12 px-4 sm:px-6 lg:px-8">
        <div class="grid grid-cols-2 gap-8 md:grid-cols-4">
          <!-- Company info -->
          <div class="col-span-2 md:col-span-1">
            <Logo class="h-8 w-auto mb-4" />
            <p class="text-sm text-gray-600 dark:text-gray-400">
              © {{ new Date().getFullYear() }} Havoo.
              <br />Tous droits réservés.
            </p>
          </div>

          <!-- Links -->
          <div>
            <h3 class="text-sm font-semibold text-gray-900 dark:text-white tracking-wider uppercase">
              Légal
            </h3>
            <ul class="mt-4 space-y-4">
              <li>
                <NuxtLink to="/privacy" class="text-sm text-gray-600 dark:text-gray-400 hover:text-gray-900 dark:hover:text-white">
                  Confidentialité
                </NuxtLink>
              </li>
              <li>
                <NuxtLink to="/terms" class="text-sm text-gray-600 dark:text-gray-400 hover:text-gray-900 dark:hover:text-white">
                  Conditions
                </NuxtLink>
              </li>
            </ul>
          </div>

          <div>
            <h3 class="text-sm font-semibold text-gray-900 dark:text-white tracking-wider uppercase">
              Support
            </h3>
            <ul class="mt-4 space-y-4">
              <li>
                <NuxtLink to="/help" class="text-sm text-gray-600 dark:text-gray-400 hover:text-gray-900 dark:hover:text-white">
                  Centre d'aide
                </NuxtLink>
              </li>
              <li>
                <NuxtLink to="/contact" class="text-sm text-gray-600 dark:text-gray-400 hover:text-gray-900 dark:hover:text-white">
                  Contact
                </NuxtLink>
              </li>
            </ul>
          </div>

          <div>
            <h3 class="text-sm font-semibold text-gray-900 dark:text-white tracking-wider uppercase">
              Réseaux
            </h3>
            <ul class="mt-4 space-y-4">
              <li>
                <a href="#" class="text-sm text-gray-600 dark:text-gray-400 hover:text-gray-900 dark:hover:text-white">
                  Twitter
                </a>
              </li>
              <li>
                <a href="#" class="text-sm text-gray-600 dark:text-gray-400 hover:text-gray-900 dark:hover:text-white">
                  LinkedIn
                </a>
              </li>
            </ul>
          </div>
        </div>
      </div>
    </footer>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useRoute } from 'vue-router'

const route = useRoute()

// Navigation links
const navigationLinks = [
  { to: '/auth/login', label: 'Connexion' },
  { to: '/auth/register', label: 'Inscription' },
  { to: '/help', label: 'Aide' }
]

// Dynamic page content
const pageTitle = computed(() => {
  switch (route.name) {
    case 'auth-login': return 'Connexion à votre compte'
    case 'auth-register': return 'Créer un compte'
    case 'auth-reset-password': return 'Réinitialiser le mot de passe'
    case 'auth-verify-email': return 'Vérification de l\'email'
    default: return 'Authentification'
  }
})

const pageDescription = computed(() => {
  switch (route.name) {
    case 'auth-login': return 'Connectez-vous pour accéder à votre espace'
    case 'auth-register': return 'Rejoignez notre communauté en quelques clics'
    case 'auth-reset-password': return 'Recevez un lien pour réinitialiser votre mot de passe'
    case 'auth-verify-email': return 'Vérifiez votre adresse email pour continuer'
    default: return 'Sécurisez votre accès'
  }
})

const helpText = computed(() => {
  switch (route.name) {
    case 'auth-login': return 'Vous n\'avez pas de compte ?'
    case 'auth-register': return 'Vous avez déjà un compte ?'
    case 'auth-reset-password': return 'Vous vous souvenez de votre mot de passe ?'
    default: return 'Besoin d\'aide ?'
  }
})

const helpLink = computed(() => {
  switch (route.name) {
    case 'auth-login': return { to: '/auth/register', label: 'Créer un compte' }
    case 'auth-register': return { to: '/auth/login', label: 'Se connecter' }
    case 'auth-reset-password': return { to: '/auth/login', label: 'Retour à la connexion' }
    default: return { to: '/help', label: 'Centre d\'aide' }
  }
})
</script>

<style scoped>
.bg-pattern {
  background-image: url("data:image/svg+xml,%3Csvg width='100' height='100' viewBox='0 0 100 100' xmlns='http://www.w3.org/2000/svg'%3E%3Cpath d='M11 18c3.866 0 7-3.134 7-7s-3.134-7-7-7-7 3.134-7 7 3.134 7 7 7zm48 25c3.866 0 7-3.134 7-7s-3.134-7-7-7-7 3.134-7 7 3.134 7 7 7zm-43-7c1.657 0 3-1.343 3-3s-1.343-3-3-3-3 1.343-3 3 1.343 3 3 3zm63 31c1.657 0 3-1.343 3-3s-1.343-3-3-3-3 1.343-3 3 1.343 3 3 3zM34 90c1.657 0 3-1.343 3-3s-1.343-3-3-3-3 1.343-3 3 1.343 3 3 3zm56-76c1.657 0 3-1.343 3-3s-1.343-3-3-3-3 1.343-3 3 1.343 3 3 3zM12 86c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm28-65c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm23-11c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5zm-6 60c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm29 22c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5zM32 63c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5zm57-13c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5zm-9-21c1.105 0 2-.895 2-2s-.895-2-2-2-2 .895-2 2 .895 2 2 2zM60 91c1.105 0 2-.895 2-2s-.895-2-2-2-2 .895-2 2 .895 2 2 2zM35 41c1.105 0 2-.895 2-2s-.895-2-2-2-2 .895-2 2 .895 2 2 2zM12 60c1.105 0 2-.895 2-2s-.895-2-2-2-2 .895-2 2 .895 2 2 2z' fill='%23ffffff' fill-opacity='1' fill-rule='evenodd'/%3E%3C/svg%3E");
}
</style> 