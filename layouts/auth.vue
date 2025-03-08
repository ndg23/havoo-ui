<template>
  <div class="min-h-screen bg-white">
    <div class="flex flex-col md:flex-row min-h-screen">
      <!-- Bannière latérale (masquée sur mobile) -->
      <div class="hidden md:flex md:w-1/2 lg:w-7/12 bg-gradient-to-br from-primary-400 to-primary-600 relative overflow-hidden">
        <div class="absolute inset-0 bg-pattern opacity-10"></div>
        
        <!-- Logo et titre -->
        <div class="relative z-10 w-full h-full flex flex-col p-12">
          <div class="mb-auto">
            <Logo :small="false" :white="true" />
          </div>
          
          <!-- Bannière principale -->
          <div class="flex flex-col mb-auto max-w-md">
            <h1 class="text-4xl lg:text-5xl font-bold text-white mb-6 leading-tight">
              Connectez-vous et trouvez les meilleurs experts
            </h1>
            <p class="text-xl text-white text-opacity-90">
              Rejoignez notre communauté et accédez à des milliers de services en quelques clics.
            </p>
            
            <!-- Mentions -->
            <div class="mt-12 flex flex-wrap gap-4">
              <div class="bg-white/20 backdrop-blur-sm rounded-xl px-4 py-3 flex items-center">
                <Users class="h-5 w-5 text-white mr-2" />
                <span class="text-white font-medium">+15 000 experts</span>
              </div>
              <div class="bg-white/20 backdrop-blur-sm rounded-xl px-4 py-3 flex items-center">
                <Star class="h-5 w-5 text-white mr-2" />
                <span class="text-white font-medium">4.8/5 satisfaction</span>
              </div>
              <div class="bg-white/20 backdrop-blur-sm rounded-xl px-4 py-3 flex items-center">
                <Shield class="h-5 w-5 text-white mr-2" />
                <span class="text-white font-medium">Sécurité garantie</span>
              </div>
            </div>
          </div>
          
          <!-- Footer -->
          <div class="mt-auto">
            <p class="text-white text-opacity-80 text-sm">
              © {{ new Date().getFullYear() }} ServX. Tous droits réservés.
            </p>
          </div>
        </div>
      </div>
      
      <!-- Partie formulaire -->
      <div class="w-full md:w-1/2 lg:w-5/12 flex flex-col p-4 md:p-0">
        <div class="md:max-w-md w-full mx-auto flex flex-col justify-center min-h-screen p-4 md:px-8 md:py-12">
          <!-- Logo mobile -->
          <div class="md:hidden mb-8">
            <Logo :small="true" />
          </div>
          
          <!-- Navigation secondaire -->
          <nav class="flex justify-between mb-8">
            <NuxtLink 
              v-for="link in navLinks" 
              :key="link.to" 
              :to="link.to"
              class="text-sm font-medium px-4 py-2 rounded-full transition-colors"
              :class="route.path === link.to 
                ? 'bg-primary-50 text-primary-600' 
                : 'text-gray-700 hover:bg-gray-50'"
            >
              {{ link.label }}
            </NuxtLink>
          </nav>
          
          <!-- En-tête du formulaire -->
          <div class="mb-8">
            <h2 class="text-2xl font-bold text-gray-900 mb-2">{{ getPageTitle() }}</h2>
            <p class="text-gray-600">{{ getPageDescription() }}</p>
          </div>
          
          <!-- Contenu principal -->
          <main class="flex-1 w-full max-w-full">
            <slot />
          </main>
          
          <!-- Footer mobile -->
          <div class="md:hidden mt-12 text-center text-sm text-gray-500">
            <p>© {{ new Date().getFullYear() }} ServX. Tous droits réservés.</p>
            
            <div class="mt-4 flex justify-center space-x-4">
              <NuxtLink to="/privacy" class="text-gray-500 hover:text-gray-700">
                Confidentialité
              </NuxtLink>
              <NuxtLink to="/terms" class="text-gray-500 hover:text-gray-700">
                Conditions
              </NuxtLink>
              <NuxtLink to="/help" class="text-gray-500 hover:text-gray-700">
                Aide
              </NuxtLink>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { useRoute } from 'vue-router'
import { Users, Star, Shield } from 'lucide-vue-next'

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
    case '/login': return 'Connexion'
    case '/register': return 'Créer un compte'
    case '/forgot-password': return 'Réinitialiser'
    case '/reset-password': return 'Nouveau mot de passe'
    default: return 'Authentification'
  }
}

// Obtenir la description de la page
const getPageDescription = () => {
  switch (route.path) {
    case '/login': return 'Connectez-vous pour accéder à votre compte'
    case '/register': return 'Rejoignez notre communauté en quelques étapes'
    case '/forgot-password': return 'Recevez un lien pour réinitialiser votre mot de passe'
    case '/reset-password': return 'Créez un nouveau mot de passe sécurisé'
    default: return 'Bienvenue sur notre plateforme'
  }
}
</script>

<style scoped>
.bg-pattern {
  background-image: url("data:image/svg+xml,%3Csvg width='100' height='100' viewBox='0 0 100 100' xmlns='http://www.w3.org/2000/svg'%3E%3Cpath d='M11 18c3.866 0 7-3.134 7-7s-3.134-7-7-7-7 3.134-7 7 3.134 7 7 7zm48 25c3.866 0 7-3.134 7-7s-3.134-7-7-7-7 3.134-7 7 3.134 7 7 7zm-43-7c1.657 0 3-1.343 3-3s-1.343-3-3-3-3 1.343-3 3 1.343 3 3 3zm63 31c1.657 0 3-1.343 3-3s-1.343-3-3-3-3 1.343-3 3 1.343 3 3 3zM34 90c1.657 0 3-1.343 3-3s-1.343-3-3-3-3 1.343-3 3 1.343 3 3 3zm56-76c1.657 0 3-1.343 3-3s-1.343-3-3-3-3 1.343-3 3 1.343 3 3 3zM12 86c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm28-65c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm23-11c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5zm-6 60c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm29 22c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5zM32 63c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5zm57-13c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5zm-9-21c1.105 0 2-.895 2-2s-.895-2-2-2-2 .895-2 2 .895 2 2 2zM60 91c1.105 0 2-.895 2-2s-.895-2-2-2-2 .895-2 2 .895 2 2 2zM35 41c1.105 0 2-.895 2-2s-.895-2-2-2-2 .895-2 2 .895 2 2 2zM12 60c1.105 0 2-.895 2-2s-.895-2-2-2-2 .895-2 2 .895 2 2 2z' fill='%23ffffff' fill-opacity='1' fill-rule='evenodd'/%3E%3C/svg%3E");
}
</style> 