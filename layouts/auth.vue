<template>
  <div class="min-h-screen flex flex-col bg-white">
    <!-- Barre de navigation minimaliste -->
    <nav class="py-3 px-6 border-b border-gray-100">
      <div class="max-w-7xl mx-auto flex items-center justify-between">
        <NuxtLink to="/" class="outline-none">
          <Logo class="h-7 w-auto" />
        </NuxtLink>
        
        <!-- Liens de navigation selon le contexte -->
        <div class="flex items-center space-x-6">
          <NuxtLink 
            v-if="!isLoginPage" 
            to="/auth/login"
            class="text-sm font-medium text-gray-600 hover:text-gray-900"
          >
            Se connecter
          </NuxtLink>
          <NuxtLink 
            v-if="!isRegisterPage" 
            to="/auth/register"
            class="text-sm font-medium text-gray-600 hover:text-gray-900"
          >
            S'inscrire
          </NuxtLink>
        </div>
      </div>
    </nav>

    <!-- Contenu principal centré -->
    <div class="flex-1 flex items-center justify-center">
      <slot />
    </div>

    <!-- Pied de page réduit -->
    <footer class="py-4 border-t border-gray-100">
      <div class="max-w-7xl mx-auto px-6">
        <div class="flex flex-col md:flex-row items-center justify-between">
          <div class="text-xs text-gray-500">
            © {{ new Date().getFullYear() }} Havoo. Tous droits réservés.
          </div>
          <div class="mt-2 md:mt-0 flex space-x-4">
            <a href="#" class="text-xs text-gray-500 hover:text-gray-700">Conditions d'utilisation</a>
            <a href="#" class="text-xs text-gray-500 hover:text-gray-700">Politique de confidentialité</a>
            <a href="#" class="text-xs text-gray-500 hover:text-gray-700">Aide</a>
          </div>
        </div>
      </div>
    </footer>
  </div>
</template>

<script setup>
import { ChevronLeft } from 'lucide-vue-next'
import { useRoute } from 'vue-router'
import { computed } from 'vue'

const route = useRoute()

// Déterminer la page actuelle pour afficher les liens de navigation appropriés
const isLoginPage = computed(() => route.path === '/auth/login')
const isRegisterPage = computed(() => 
  route.path === '/auth/register' || route.path === '/auth/register-expert'
)

const footerLinks = [
  { name: 'Confidentialité', to: '/legal/privacy' },
  { name: 'Conditions', to: '/legal/terms' },
  { name: 'Mentions légales', to: '/legal/mentions' }
]
</script>

<style scoped>

/* Effet de focus personnalisé */
*:focus-visible {
  @apply outline-none ring-2 ring-indigo-500 ring-offset-2;
}

/* Amélioration du rendu des polices */
@supports (font-smooth: auto) {
  html {
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
    font-smooth: auto;
  }
}

/* Animation de transition pour la navbar */
nav {
  transform: translateZ(0);
  will-change: backdrop-filter;
}

/* Effet de glassmorphism */
.backdrop-blur-lg {
  backdrop-filter: blur(16px);
  -webkit-backdrop-filter: blur(16px);
}
</style> 