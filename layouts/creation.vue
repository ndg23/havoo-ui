<template>
    <div class="min-h-screen bg-white dark:bg-black">
      <!-- Header avec style Twitter moderne -->
      <header class="fixed top-0 inset-x-0 z-50 bg-white/90 dark:bg-black/90 backdrop-blur-xl border-b border-gray-100/50 dark:border-gray-800/50">
        <div class="max-w-2xl mx-auto px-4">
          <div class="flex items-center h-14">
            <button 
              @click="$router.back()" 
              class="rounded-full p-2 -ml-2 hover:bg-gray-100 dark:hover:bg-gray-800/60 transition-colors"
            >
              <UIcon name="i-heroicons-arrow-left" class="h-5 w-5 text-gray-900 dark:text-white" />
            </button>
            
            <!-- Indicateur de progression amélioré -->
            <div class="ml-auto flex items-center gap-1.5">
              <div 
                v-for="step in totalSteps" 
                :key="step"
                class="h-1 rounded-full transition-all duration-300 ease-spring"
                :class="[
                  step < currentStep 
                    ? 'w-8 bg-primary-500' 
                    : step === currentStep
                      ? 'w-12 bg-primary-500 animate-pulse'
                      : 'w-8 bg-gray-200 dark:bg-gray-800'
                ]"
              />
            </div>
          </div>
        </div>
      </header>
  
      <!-- Contenu principal avec animation de transition -->
      <main class="pt-20 pb-24">
        <slot />
      </main>
  
      <!-- Footer avec style Twitter moderne -->
      <footer class="fixed bottom-0 inset-x-0 z-50 bg-white/90 dark:bg-black/90 backdrop-blur-xl border-t border-gray-100/50 dark:border-gray-800/50">
        <div class="max-w-2xl mx-auto px-4 py-4">
          <slot name="footer" />
        </div>
      </footer>
    </div>
  </template>
  
  <script setup>
  const { currentStep, totalSteps } = defineProps({
    currentStep: {
      type: Number,
      required: true
    },
    totalSteps: {
      type: Number,
      required: true
    }
  })
  </script>
  
  <style scoped>
  /* Animation plus fluide */
  .ease-spring {
    transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
  }
  
  /* Effet de flou amélioré */
  @supports (backdrop-filter: blur(0px)) {
    header, footer {
      backdrop-filter: blur(12px);
      -webkit-backdrop-filter: blur(12px);
    }
  }
  
  /* Amélioration de l'accessibilité */
  @media (prefers-reduced-motion: reduce) {
    * {
      animation-duration: 0.01ms !important;
      transition-duration: 0.01ms !important;
    }
  }
  </style>