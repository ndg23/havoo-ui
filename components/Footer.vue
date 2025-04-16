<template>
  <footer class="bg-white dark:bg-gray-900 border-t border-gray-100 dark:border-gray-800">
    <div class="max-w-7xl mx-auto px-4 py-12 sm:px-6 lg:px-8">
      <!-- Liens essentiels -->
      <nav class="flex flex-wrap justify-center gap-x-8 gap-y-4 mb-8">
        <NuxtLink 
          v-for="link in essentialLinks" 
          :key="link.to"
          :to="link.to"
          class="text-sm text-gray-500 hover:text-gray-900 dark:text-gray-400 dark:hover:text-white transition-colors"
        >
          {{ link.text }}
        </NuxtLink>
      </nav>

      <!-- Réseaux sociaux -->
      <div class="flex justify-center gap-6 mb-8">
        <a 
          v-for="social in socialLinks"
          :key="social.url"
          :href="social.url"
          target="_blank"
          rel="noopener noreferrer"
          class="text-gray-400 hover:text-gray-500 dark:hover:text-gray-300 transition-colors"
        >
          <span class="sr-only">{{ social.name }}</span>
          <UIcon :name="social.icon" class="w-6 h-6" />
        </a>
      </div>

      <!-- Copyright et langue -->
      <div class="flex flex-col sm:flex-row items-center justify-between text-sm text-gray-400">
        <p>© {{ new Date().getFullYear() }} Keetaf. Tous droits réservés.</p>
        <div class="flex items-center gap-4 mt-4 sm:mt-0">
          <button 
            class="flex items-center gap-2 hover:text-gray-500 dark:hover:text-gray-300 transition-colors"
            @click="toggleLanguage"
          >
            <UIcon name="i-heroicons-globe-alt" class="w-5 h-5" />
            <span>{{ currentLanguage }}</span>
          </button>
          <button
            class="flex items-center gap-2 hover:text-gray-500 dark:hover:text-gray-300 transition-colors"
            @click="toggleTheme"
          >
            <UIcon :name="isDark ? 'i-heroicons-sun' : 'i-heroicons-moon'" class="w-5 h-5" />
            <span>{{ isDark ? 'Clair' : 'Sombre' }}</span>
          </button>
        </div>
      </div>
    </div>
  </footer>
</template>

<script setup>
const essentialLinks = [
  { text: 'À propos', to: '/about' },
  { text: 'Blog', to: '/blog' },
  { text: 'Carrières', to: '/careers' },
  { text: 'Aide', to: '/help' },
  { text: 'Confidentialité', to: '/privacy' },
  { text: 'Conditions', to: '/terms' }
]

const socialLinks = [
  { name: 'Twitter', url: 'https://twitter.com/keetaf', icon: 'i-simple-icons-twitter' },
  { name: 'LinkedIn', url: 'https://linkedin.com/company/keetaf', icon: 'i-simple-icons-linkedin' },
  { name: 'Instagram', url: 'https://instagram.com/keetaf', icon: 'i-simple-icons-instagram' }
]

// État du thème
const colorMode = useColorMode()
const isDark = computed(() => colorMode.value === 'dark')
const toggleTheme = () => {
  colorMode.preference = isDark.value ? 'light' : 'dark'
}

// État de la langue
const currentLanguage = ref('Français')
const toggleLanguage = () => {
  // TODO: Implémenter le changement de langue
  currentLanguage.value = currentLanguage.value === 'Français' ? 'English' : 'Français'
}
</script> 