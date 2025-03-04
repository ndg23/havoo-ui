<template>
  <div class="min-h-screen bg-white">
    <!-- User Header -->
    <header class="fixed top-0 left-0 right-0 bg-white/95 backdrop-blur-sm z-50 border-b border-gray-100">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex items-center justify-between h-16">
          <!-- Logo -->
          <NuxtLink to="/" class="flex items-center gap-2">
            <Logo class="h-8 w-auto" />
          </NuxtLink>

          <!-- Navigation -->
          <nav class="hidden md:flex items-center gap-6">
            <NuxtLink 
              v-for="item in navigation" 
              :key="item.name"
              :to="item.to"
              class="px-3 py-2 text-sm text-gray-600 hover:text-gray-900 font-medium rounded-lg hover:bg-gray-50 transition-colors"
            >
              {{ item.name }}
            </NuxtLink>
          </nav>

          <!-- User Actions -->
          <div class="flex items-center gap-4">
            <template v-if="user">
              <div class="relative">
                <button 
                  @click="isMenuOpen = !isMenuOpen"
                  class="flex items-center gap-2 p-2 rounded-xl hover:bg-gray-50 transition-colors"
                >
                  <img :src="`https://ui-avatars.com/api/?name=${user.email}`" class="w-8 h-8 rounded-full" />
                  <span class="text-sm font-medium text-gray-700">{{ user.email }}</span>
                  <ChevronDownIcon class="w-4 h-4 text-gray-400" :class="{ 'rotate-180': isMenuOpen }" />
                </button>
                <!-- Dropdown -->
                <div 
                  v-if="isMenuOpen"
                  class="absolute right-0 mt-2 w-48 bg-white rounded-xl shadow-lg py-1 border border-gray-100"
                >
                  <NuxtLink 
                    v-for="item in userMenu" 
                    :key="item.name"
                    :to="item.to"
                    class="flex items-center gap-2 px-4 py-2 text-sm text-gray-700 hover:bg-gray-50 transition-colors"
                    @click="isMenuOpen = false"
                  >
                    <component :is="item.icon" class="w-4 h-4 text-gray-400" />
                    {{ item.name }}
                  </NuxtLink>
                  <button 
                    @click="handleLogout"
                    class="flex items-center gap-2 w-full text-left px-4 py-2 text-sm text-red-600 hover:bg-red-50 transition-colors"
                  >
                    <ArrowRightOnRectangleIcon class="w-4 h-4" />
                    Déconnexion
                  </button>
                </div>
              </div>
            </template>
            <template v-else>
              <NuxtLink 
                to="/auth/login"
                class="px-4 py-2 text-sm text-gray-600 hover:text-gray-900 font-medium hidden md:block hover:bg-gray-50 rounded-lg transition-colors"
              >
                Connexion
              </NuxtLink>
            </template>
            <NuxtLink 
              to="/demande"
              class="bg-primary-500 text-white px-4 py-2 text-sm rounded-xl hover:bg-primary-600 transition-all duration-300 font-medium hover:shadow-lg hover:-translate-y-0.5"
            >
              Demander un service
            </NuxtLink>
          </div>
        </div>
      </div>
    </header>

    <!-- Main Content -->
    <main class="pt-16">
      <slot />
    </main>

    <!-- Footer simplifié -->
    <footer class="bg-gray-50 border-t border-gray-200">
      <div class="max-w-7xl mx-auto px-4 py-12">
        <div class="grid md:grid-cols-4 gap-8">
          <!-- Logo et description -->
          <div class="md:col-span-2">
            <Logo class="h-8 w-auto" />
            <p class="mt-4 text-sm text-gray-600 max-w-md">
              La meilleure plateforme pour trouver des experts qualifiés pour vos services à domicile.
            </p>
          </div>

          <!-- Services -->
          <div>
            <h3 class="font-medium text-gray-900 mb-4">Services</h3>
            <ul class="space-y-3">
              <li v-for="service in services" :key="service.id">
                <NuxtLink 
                  :to="`/demande?service=${service.id}`"
                  class="text-sm text-gray-600 hover:text-primary-600"
                >
                  {{ service.name }}
                </NuxtLink>
              </li>
            </ul>
          </div>

          <!-- Contact -->
          <div>
            <h3 class="font-medium text-gray-900 mb-4">Contact</h3>
            <ul class="space-y-3 text-sm text-gray-600">
              <li class="flex items-center gap-2">
                <PhoneIcon class="w-4 h-4" />
                <span>+229 00 00 00 00</span>
              </li>
              <li class="flex items-center gap-2">
                <EnvelopeIcon class="w-4 h-4" />
                <span>contact@example.com</span>
              </li>
            </ul>
          </div>
        </div>

        <!-- Copyright -->
        <div class="mt-8 pt-8 border-t border-gray-200 flex flex-col sm:flex-row justify-between items-center gap-4">
          <p class="text-sm text-gray-600">
            © {{ new Date().getFullYear() }} Tous droits réservés
          </p>
          <div class="flex items-center gap-6">
            <NuxtLink to="/mentions-legales" class="text-sm text-gray-600 hover:text-primary-600">
              Mentions légales
            </NuxtLink>
            <NuxtLink to="/confidentialite" class="text-sm text-gray-600 hover:text-primary-600">
              Confidentialité
            </NuxtLink>
          </div>
        </div>
      </div>
    </footer>
  </div>
</template>

<script setup>
import { 
  PhoneIcon, 
  EnvelopeIcon,
  UserCircleIcon,
  DocumentTextIcon,
  Cog6ToothIcon,
  ArrowRightOnRectangleIcon,
  ChevronDownIcon
} from '@heroicons/vue/24/outline'
import Logo from '~/components/shared/Logo.vue'

const user = useSupabaseUser()
const client = useSupabaseClient()
const isMenuOpen = ref(false)

const navigation = [
  { name: 'Experts', to: '/experts' },
  { name: 'Services', to: '/#services' },
  { name: 'Comment ça marche', to: '/#comment-ca-marche' },
  { name: 'Devenir expert', to: '/auth/register-expert' }
]

const userMenu = [
  { name: 'Mon compte', to: '/compte', icon: UserCircleIcon },
  { name: 'Mes demandes', to: '/compte/demandes', icon: DocumentTextIcon },
  { name: 'Paramètres', to: '/compte/parametres', icon: Cog6ToothIcon }
]

// Fermer le menu au clic en dehors
onMounted(() => {
  document.addEventListener('click', (e) => {
    if (isMenuOpen.value && !e.target.closest('.relative')) {
      isMenuOpen.value = false
    }
  })
})

const handleLogout = async () => {
  try {
    await client.auth.signOut()
    isMenuOpen.value = false
    navigateTo('/auth/login')
  } catch (error) {
    console.error('Error logging out:', error)
  }
}

const services = [
  { id: 'menage', name: 'Ménage' },
  { id: 'jardinage', name: 'Jardinage' },
  { id: 'bricolage', name: 'Bricolage' },
  { id: 'garde', name: "Garde d'enfants" }
]
</script>

<style scoped>
/* Add smooth scroll behavior */
html {
  scroll-behavior: smooth;
}

/* Active link styles */
.router-link-active {
  color: theme('colors.primary.600');
}
</style> 