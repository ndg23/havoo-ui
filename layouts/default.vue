<template>
  <div class="min-h-screen bg-white">
    <!-- User Header -->
    <header class="fixed top-0 left-0 right-0 bg-white/80 backdrop-blur-lg z-50 border-b border-gray-100">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex items-center justify-between h-16">
          <!-- Logo -->
          <NuxtLink to="/" class="flex items-center gap-2">
            <span class="text-2xl text-primary-500">⚡</span>
            <span class="font-bold text-gray-900">DomiServices</span>
          </NuxtLink>

          <!-- Navigation -->
          <nav class="hidden md:flex items-center gap-8">
            <NuxtLink 
              v-for="item in navigation" 
              :key="item.name"
              :to="item.to"
              class="text-gray-600 hover:text-gray-900 font-medium"
            >
              {{ item.name }}
            </NuxtLink>
          </nav>

          <!-- User Actions -->
          <div class="flex items-center gap-4">
            <template v-if="user">
              <div class="relative group">
                <button class="flex items-center gap-2 p-2 rounded-xl hover:bg-gray-50">
                  <img :src="`https://ui-avatars.com/api/?name=${user.email}`" class="w-8 h-8 rounded-full" />
                  <span class="text-sm font-medium">{{ user.email }}</span>
                </button>
                <!-- Dropdown -->
                <div class="absolute right-0 mt-2 w-48 bg-white rounded-xl shadow-lg py-1 border border-gray-100 hidden group-hover:block">
                  <NuxtLink 
                    v-for="item in userMenu" 
                    :key="item.name"
                    :to="item.to"
                    class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-50"
                  >
                    {{ item.name }}
                  </NuxtLink>
                  <button 
                    @click="handleLogout"
                    class="block w-full text-left px-4 py-2 text-sm text-red-600 hover:bg-red-50"
                  >
                    Déconnexion
                  </button>
                </div>
              </div>
            </template>
            <template v-else>
              <NuxtLink 
                to="/connexion"
                class="text-gray-600 hover:text-gray-900 font-medium hidden md:block"
              >
                Connexion
              </NuxtLink>
            </template>
            <NuxtLink 
              to="/demande"
              class="bg-primary-500 text-white px-4 py-2 rounded-xl hover:bg-primary-600 transition-colors font-medium"
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

    <!-- Footer -->
    <footer class="bg-gray-50 border-t border-gray-100">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <div class="grid grid-cols-2 md:grid-cols-4 gap-8">
          <!-- Company Info -->
          <div class="col-span-2 md:col-span-1">
            <span class="text-xl font-bold text-primary-600">DomiServices</span>
            <p class="mt-4 text-gray-500 text-sm">
              La plateforme qui connecte particuliers et professionnels pour des services à domicile de qualité.
            </p>
          </div>

          <!-- Quick Links -->
          <div>
            <h3 class="font-medium text-gray-900 mb-4">Services</h3>
            <ul class="space-y-3 text-sm">
              <li v-for="service in services" :key="service.id">
                <NuxtLink :to="`/services/${service.id}`" class="text-gray-500 hover:text-gray-700">
                  {{ service.name }}
                </NuxtLink>
              </li>
            </ul>
          </div>

          <!-- Company -->
          <div>
            <h3 class="font-medium text-gray-900 mb-4">Entreprise</h3>
            <ul class="space-y-3 text-sm">
              <li><NuxtLink to="/about" class="text-gray-500 hover:text-gray-700">À propos</NuxtLink></li>
              <li><NuxtLink to="/contact" class="text-gray-500 hover:text-gray-700">Contact</NuxtLink></li>
              <li><NuxtLink to="/blog" class="text-gray-500 hover:text-gray-700">Blog</NuxtLink></li>
            </ul>
          </div>

          <!-- Legal -->
          <div>
            <h3 class="font-medium text-gray-900 mb-4">Légal</h3>
            <ul class="space-y-3 text-sm">
              <li><NuxtLink to="/confidentialite" class="text-gray-500 hover:text-gray-700">Confidentialité</NuxtLink></li>
              <li><NuxtLink to="/conditions" class="text-gray-500 hover:text-gray-700">Conditions d'utilisation</NuxtLink></li>
            </ul>
          </div>
        </div>

        <div class="mt-12 pt-8 border-t border-gray-200">
          <p class="text-center text-gray-400 text-sm">
            © {{ new Date().getFullYear() }} DomiServices. Tous droits réservés.
          </p>
        </div>
      </div>
    </footer>
  </div>
</template>

<script setup>
const user = useSupabaseUser()
const client = useSupabaseClient()

const navigation = [
  { name: 'Services', to: '/services' },
  { name: 'Comment ça marche', to: '/#comment-ca-marche' },
  { name: 'Tarifs', to: '/tarifs' },
  { name: 'Professionnels', to: '/pro' }
]

const userMenu = [
  { name: 'Mon compte', to: '/compte' },
  { name: 'Mes demandes', to: '/compte/demandes' },
  { name: 'Paramètres', to: '/compte/parametres' }
]

const handleLogout = async () => {
  try {
    await client.auth.signOut()
    navigateTo('/connexion')
  } catch (error) {
    console.error('Error logging out:', error)
  }
}

const services = [
  { id: 'menage', name: 'Ménage à domicile' },
  { id: 'jardinage', name: 'Jardinage' },
  { id: 'bricolage', name: 'Bricolage' },
  { id: 'garde', name: 'Garde d\'enfants' },
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