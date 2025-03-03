<template>
  <div class="min-h-screen bg-gray-50">
    <!-- Navbar -->
    <nav class="fixed top-0 inset-x-0 bg-white/70 backdrop-blur-lg border-b border-gray-200/80 z-50">
      <div class="max-w-screen-xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex h-16 items-center justify-between">
          <!-- Back Button -->
          <button 
            @click="router.back()" 
            class="group inline-flex items-center px-3 py-2 rounded-lg text-sm font-medium text-gray-700 hover:text-gray-900 hover:bg-gray-100/80 transition-all duration-200"
          >
            <svg 
              class="mr-1.5 h-5 w-5 text-gray-500 transition-transform duration-200 group-hover:-translate-x-0.5" 
              viewBox="0 0 24 24" 
              fill="none" 
              stroke="currentColor"
            >
              <path 
                stroke-linecap="round" 
                stroke-linejoin="round" 
                stroke-width="2" 
                d="M15 19l-7-7 7-7"
              />
            </svg>
            Retour
          </button>

          <!-- Logo -->
          <div class="absolute left-1/2 top-1/2 -translate-x-1/2 -translate-y-1/2">
            <Logo />
          </div>

          <!-- Right side spacer to maintain centering -->
          <div class="w-[88px]"></div>
        </div>
      </div>
    </nav>

    <!-- Main Content -->
    <main class="pt-16 min-h-screen">
      <slot />
    </main>
  </div>
</template>

<script setup lang="ts">
import Logo from '~/components/shared/Logo.vue';
const router = useRouter()
</script>

<style>
/* Effet de focus personnalisé */
*:focus-visible {
  @apply outline-none ring-2 ring-orange-500 ring-offset-2;
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
</style> 