<template>
  <div class="min-h-screen bg-white">
    <!-- Minimal Navbar -->
    <nav class="fixed top-0 inset-x-0 h-16 bg-white/80 backdrop-blur-sm border-b border-gray-100">
      <div class="max-w-screen-xl mx-auto px-4 h-full flex items-center justify-between">
        <!-- Back Button -->
        <NuxtLink 
          to="/" 
          class="flex items-center justify-center w-10 h-10 rounded-full 
            bg-gray-100 hover:bg-gray-200 transition-colors"
        >
          <ChevronLeft class="w-5 h-5 text-gray-700" />
        </NuxtLink>

        <!-- Right Nav -->
        <div class="flex items-center gap-6">
          <NuxtLink 
            to="/auth/register-expert" 
            class="text-sm font-medium text-gray-700 hover:text-gray-900"
          >
            Devenir expert
          </NuxtLink>
          <NuxtLink 
            to="/contact" 
            class="hidden sm:inline-flex items-center px-4 py-2 text-sm font-medium 
              text-gray-700 bg-gray-50 hover:bg-gray-100 rounded-full transition-colors"
          >
            Besoin d'aide ?
          </NuxtLink>
        </div>
      </div>
    </nav>

    <!-- Main Content -->
    <main class="pt-16 min-h-screen">
      <slot />
    </main>

    <!-- Simple Footer -->
    <footer class="py-8 border-t border-gray-100">
      <div class="max-w-screen-xl mx-auto px-4">
        <div class="flex flex-col sm:flex-row items-center justify-between gap-4">
          <!-- Copyright -->
          <p class="text-sm text-gray-500">
            © {{ new Date().getFullYear() }} Havoo. Tous droits réservés.
          </p>

          <!-- Links -->
          <div class="flex items-center gap-6">
            <NuxtLink 
              v-for="link in footerLinks" 
              :key="link.to"
              :to="link.to"
              class="text-sm text-gray-500 hover:text-gray-900"
            >
              {{ link.name }}
            </NuxtLink>
          </div>
        </div>
      </div>
    </footer>
  </div>
</template>

<script setup>
import { ChevronLeft } from 'lucide-vue-next'

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