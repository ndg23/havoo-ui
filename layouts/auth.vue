<template>
  <div class="min-h-screen bg-white">
    <div class="flex flex-col min-h-s">
      <!-- Header avec logo principal -->
      <header class="w-full border-b border-gray-100 py-5">
        <div class="max-w-5xl mx-auto px-6">
          <div class="flex items-center justify-between">
            <NuxtLink to="/" class="block">
              <Logo :small="false" />
            </NuxtLink>
            
            <!-- Bouton retour au site -->
            <NuxtLink to="/auth/register-expert" class="text-primary-500 hover:text-primary-600 flex items-center text-md font-bold">
Devenir expert
            </NuxtLink>
          </div>
        </div>
      </header>
      
      <!-- Contenu principal -->
      <div class="flex-1 flex flex-col items-center justify-center w-full">
        <div class="w-full max-w-md mx-auto px-6">
          <!-- En-tête de la page -->
      
        
          
          <!-- Contenu principal -->
          <main class="w-full max-w-full mx-auto">
            <slot />
          </main>
          
          <!-- Footer -->
          <footer class="mt-12 text-center">
            <p class="text-sm text-gray-500">
              © 2022 - {{ new Date().getFullYear() }} Sunutaf. Tous droits réservés.
            </p>
            
            <div class="mt-4 flex justify-center space-x-6">
              <NuxtLink to="/privacy" class="text-sm text-gray-500 hover:text-gray-700 hover:underline">
                Confidentialité
              </NuxtLink>
              <NuxtLink to="/terms" class="text-sm text-gray-500 hover:text-gray-700 hover:underline">
                Conditions
              </NuxtLink>
              <NuxtLink to="/help" class="text-sm text-gray-500 hover:text-gray-700 hover:underline">
                Aide
              </NuxtLink>
            </div>
          </footer>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { useRoute } from 'vue-router'
import { ArrowLeft } from 'lucide-vue-next'

const route = useRoute()

// Liens de navigation
const navLinks = [
  { to: '/login', label: 'Connexion' },
  { to: '/register', label: 'Inscription' },
  { to: '/forgot-password', label: 'Mot de passe' }
]

// Obtenir le titre de la page
const getPageTitle = () => {
  switch (route.path) {
    case '/login': return 'Bienvenue sur ServX'
    case '/register': return 'Créer un compte'
    case '/forgot-password': return 'Récupération du mot de passe'
    case '/reset-password': return 'Nouveau mot de passe'
    case '/auth/callback': return 'Authentification'
    default: return 'Connexion'
  }
}

// Obtenir la description de la page
const getPageDescription = () => {
  switch (route.path) {
    case '/login': return 'Connectez-vous pour accéder à votre espace personnel'
    case '/register': return 'Rejoignez notre communauté en quelques étapes simples'
    case '/forgot-password': return 'Recevez un lien pour réinitialiser votre mot de passe'
    case '/reset-password': return 'Créez un nouveau mot de passe sécurisé'
    case '/auth/callback': return 'Finalisation de votre connexion'
    default: return 'Gérez vos services et demandes en quelques clics'
  }
}
</script>

<style scoped>
.bg-pattern {
  background-image: url("data:image/svg+xml,%3Csvg width='100' height='100' viewBox='0 0 100 100' xmlns='http://www.w3.org/2000/svg'%3E%3Cpath d='M11 18c3.866 0 7-3.134 7-7s-3.134-7-7-7-7 3.134-7 7 3.134 7 7 7zm48 25c3.866 0 7-3.134 7-7s-3.134-7-7-7-7 3.134-7 7 3.134 7 7 7zm-43-7c1.657 0 3-1.343 3-3s-1.343-3-3-3-3 1.343-3 3 1.343 3 3 3zm63 31c1.657 0 3-1.343 3-3s-1.343-3-3-3-3 1.343-3 3 1.343 3 3 3zM34 90c1.657 0 3-1.343 3-3s-1.343-3-3-3-3 1.343-3 3 1.343 3 3 3zm56-76c1.657 0 3-1.343 3-3s-1.343-3-3-3-3 1.343-3 3 1.343 3 3 3zM12 86c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm28-65c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm23-11c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5zm-6 60c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm29 22c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5zM32 63c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5zm57-13c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5zm-9-21c1.105 0 2-.895 2-2s-.895-2-2-2-2 .895-2 2 .895 2 2 2zM60 91c1.105 0 2-.895 2-2s-.895-2-2-2-2 .895-2 2 .895 2 2 2zM35 41c1.105 0 2-.895 2-2s-.895-2-2-2-2 .895-2 2 .895 2 2 2zM12 60c1.105 0 2-.895 2-2s-.895-2-2-2-2 .895-2 2 .895 2 2 2z' fill='%23ffffff' fill-opacity='1' fill-rule='evenodd'/%3E%3C/svg%3E");
}
</style> 