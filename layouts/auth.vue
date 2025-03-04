<template>
  <div class="min-h-screen bg-gradient-to-br from-gray-50 to-gray-100">
    <!-- Navbar -->
    <nav class="fixed top-0 inset-x-0 bg-white/80 backdrop-blur-lg border-b border-gray-200/80 z-50">
      <div class="max-w-screen-xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex h-16 items-center justify-between">
          <!-- Logo -->
          <div class="flex-1 flex justify-center lg:justify-start">
            <Logo />
          </div>

          <!-- Right Navigation -->
          <div class="hidden lg:flex items-center gap-6">
            <NuxtLink 
              to="/auth/login" 
              class="text-sm font-medium text-gray-700 hover:text-gray-900"
            >
              Se connecter
            </NuxtLink>
            <NuxtLink 
              to="/auth/register-expert" 
              class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-lg text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
            >
              Devenir expert
            </NuxtLink>
          </div>
        </div>
      </div>
    </nav>

    <!-- Main Content -->
    <main class="pt-16 min-h-screen">
      <div class="max-w-screen-xl mx-auto">
        <!-- Background Decoration -->
        <div class="fixed inset-0 overflow-hidden pointer-events-none">
          <div class="absolute -top-40 -right-32 w-[600px] h-[600px] rounded-full bg-indigo-50 blur-3xl opacity-20"></div>
          <div class="absolute top-1/2 -left-64 w-[800px] h-[800px] rounded-full bg-orange-50 blur-3xl opacity-20"></div>
        </div>

        <!-- Content -->
        <div class="relative">
          <slot />
        </div>
      </div>
    </main>

    <!-- Footer -->
    <footer class="mt-auto py-8 border-t border-gray-200/80 bg-white/50 backdrop-blur-sm">
      <div class="max-w-screen-xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex flex-col items-center justify-between gap-4 sm:flex-row">
          <!-- Copyright -->
          <p class="text-sm text-gray-500">
            © {{ new Date().getFullYear() }} Havoo Services. Tous droits réservés.
          </p>

          <!-- Links -->
          <div class="flex items-center gap-6">
            <NuxtLink 
              v-for="link in footerLinks" 
              :key="link.to"
              :to="link.to"
              class="text-sm text-gray-500 hover:text-gray-900 transition-colors"
            >
              {{ link.name }}
            </NuxtLink>
          </div>

          <!-- Social Links -->
          <div class="flex items-center gap-4">
            <a 
              v-for="social in socialLinks" 
              :key="social.name"
              :href="social.href"
              target="_blank"
              rel="noopener noreferrer"
              class="text-gray-400 hover:text-gray-600 transition-colors"
            >
              <component :is="social.icon" class="w-5 h-5" />
              <span class="sr-only">{{ social.name }}</span>
            </a>
          </div>
        </div>
      </div>
    </footer>
  </div>
</template>

<script setup lang="ts">
import Logo from '~/components/shared/Logo.vue'

const footerLinks = [
  { name: 'À propos', to: '/about' },
  { name: 'Mentions légales', to: '/legal/mentions' },
  { name: 'Confidentialité', to: '/legal/privacy' },
  { name: 'Contact', to: '/contact' }
]

const socialLinks = [
  {
    name: 'Facebook',
    href: '#',
    icon: defineComponent({
      template: `<svg fill="currentColor" viewBox="0 0 24 24"><path d="M9 8h-3v4h3v12h5v-12h3.642l.358-4h-4v-1.667c0-.955.192-1.333 1.115-1.333h2.885v-5h-3.808c-3.596 0-5.192 1.583-5.192 4.615v3.385z"/></svg>`
    })
  },
  {
    name: 'Twitter',
    href: '#',
    icon: defineComponent({
      template: `<svg fill="currentColor" viewBox="0 0 24 24"><path d="M23 3a10.9 10.9 0 0 1-3.14 1.53 4.48 4.48 0 0 0-7.86 3v1A10.66 10.66 0 0 1 3 4s-4 9 5 13a11.64 11.64 0 0 1-7 2c9 5 20 0 20-11.5a4.5 4.5 0 0 0-.08-.83A7.72 7.72 0 0 0 23 3z"/></svg>`
    })
  },
  {
    name: 'LinkedIn',
    href: '#',
    icon: defineComponent({
      template: `<svg fill="currentColor" viewBox="0 0 24 24"><path d="M20.447 20.452h-3.554v-5.569c0-1.328-.027-3.037-1.852-3.037-1.853 0-2.136 1.445-2.136 2.939v5.667H9.351V9h3.414v1.561h.046c.477-.9 1.637-1.85 3.37-1.85 3.601 0 4.267 2.37 4.267 5.455v6.286zM5.337 7.433c-1.144 0-2.063-.926-2.063-2.065 0-1.138.92-2.063 2.063-2.063 1.14 0 2.064.925 2.064 2.063 0 1.139-.925 2.065-2.064 2.065zm1.782 13.019H3.555V9h3.564v11.452zM22.225 0H1.771C.792 0 0 .774 0 1.729v20.542C0 23.227.792 24 1.771 24h20.451C23.2 24 24 23.227 24 22.271V1.729C24 .774 23.2 0 22.222 0h.003z"/></svg>`
    })
  }
]
</script>

<style>
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