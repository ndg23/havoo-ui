<template>
  <div class="min-h-screen bg-white dark:bg-black wrapper">
    <div class="flex">
      <!-- Sidebar Admin Twitter-style -->
      <aside class="hidden md:flex h-screen w-72 lg:w-80 fixed flex-col py-4 border-r border-gray-200 dark:border-gray-800 bg-white dark:bg-gray-950">
        <!-- Logo et titre Admin -->
        <div class="px-4 mb-8">
          <div class="flex items-center">
            <NuxtLink to="/" class="inline-block">
              <Logo :small="false" />
            </NuxtLink>
            <div class="ml-2 px-2 py-1 bg-gray-800 dark:bg-gray-700 rounded text-xs font-bold text-white">
              ADMIN
            </div>
          </div>
        </div>
        
        <!-- Menu principal (Twitter-style) -->
        <nav class="flex-1 px-2">
          <!-- Section "Vue d'ensemble" -->
          <div class="mb-2 px-4 text-xs font-bold uppercase tracking-wider text-gray-500 dark:text-gray-400">
            Vue d'ensemble
          </div>
          <div class="space-y-1 mb-6">
            <NuxtLink 
              v-for="item in dashboardItems" 
              :key="item.to" 
              :to="item.to"
              class="flex items-center p-3 text-lg rounded-full transition-colors group relative hover:bg-gray-100 dark:hover:bg-gray-900"
              :class="route.path === item.to ? 'font-bold' : 'font-medium text-gray-700 dark:text-gray-300'"
            >
              <v-icon 
                :name="item.icon"
                class="h-7 w-7 mr-4"
                :class="route.path === item.to ? 'text-blue-500' : ''"
              />
              <span>{{ item.label }}</span>
              <div 
                v-if="route.path === item.to" 
                class="absolute right-4 h-2 w-2 rounded-full bg-blue-500"
              ></div>
            </NuxtLink>
          </div>
          
          <!-- Section "Gestion" -->
          <div class="mb-2 px-4 text-xs font-bold uppercase tracking-wider text-gray-500 dark:text-gray-400">
            Gestion
          </div>
          <div class="space-y-1 mb-6">
            <NuxtLink 
              v-for="item in managementItems" 
              :key="item.to" 
              :to="item.to"
              class="flex items-center p-3 text-lg rounded-full transition-colors group relative hover:bg-gray-100 dark:hover:bg-gray-900"
              :class="route.path === item.to ? 'font-bold' : 'font-medium text-gray-700 dark:text-gray-300'"
            >
              <v-icon 
                :name="item.icon"
                class="h-7 w-7 mr-4"
                :class="route.path.includes(item.to) ? 'text-blue-500' : ''"
              />
              <span>{{ item.label }}</span>
              <div 
                v-if="route.path.includes(item.to)" 
                class="absolute right-4 h-2 w-2 rounded-full bg-blue-500"
              ></div>
            </NuxtLink>
          </div>
          
          <!-- Section "Configuration" -->
          <div class="mb-2 px-4 text-xs font-bold uppercase tracking-wider text-gray-500 dark:text-gray-400">
            Configuration
          </div>
          <div class="space-y-1">
            <NuxtLink 
              v-for="item in configItems" 
              :key="item.to" 
              :to="item.to"
              class="flex items-center p-3 text-lg rounded-full transition-colors group relative hover:bg-gray-100 dark:hover:bg-gray-900"
              :class="route.path === item.to ? 'font-bold' : 'font-medium text-gray-700 dark:text-gray-300'"
            >
              <v-icon 
                :name="item.icon"
                class="h-7 w-7 mr-4"
                :class="route.path === item.to ? 'text-blue-500' : ''"
              />
              <span>{{ item.label }}</span>
              <div 
                v-if="route.path === item.to" 
                class="absolute right-4 h-2 w-2 rounded-full bg-blue-500"
              ></div>
            </NuxtLink>
          </div>
          
          <!-- Bouton "Retour au site" (style badge Twitter) -->
          <div class="mt-8 px-2">
            <NuxtLink 
              to="/"
              class="bg-gray-900 dark:bg-gray-800 hover:bg-gray-800 dark:hover:bg-gray-700 text-white rounded-full py-3.5 px-4 w-full flex items-center justify-center font-bold text-lg transition-colors shadow-sm"
            >
              <v-icon name="ri-arrow-left-line" class="h-5 w-5 mr-2" />
              Retour au site
            </NuxtLink>
          </div>
        </nav>
        
        <!-- Profil administrateur en bas (Twitter-style) -->
        <div class="mt-auto px-4">
          <button 
            @click="showUserMenu = !showUserMenu"
            class="flex items-center p-3 w-full rounded-full hover:bg-gray-100 dark:hover:bg-gray-900 transition-colors relative group"
          >
            <div class="flex items-center flex-1 min-w-0">
              <div class="h-10 w-10 rounded-full bg-blue-500 flex items-center justify-center text-white font-bold mr-3">
                <v-icon name="ri-shield-user-fill" class="h-5 w-5" />
              </div>
              <div class="flex flex-col min-w-0">
                <span class="font-bold text-black dark:text-white truncate">{{ adminName || 'Admin' }}</span>
                <span class="text-gray-500 dark:text-gray-400 text-sm truncate">
                  Administrateur
                </span>
              </div>
            </div>
            <v-icon name="ri-more-fill" class="h-5 w-5 text-gray-500 dark:text-gray-400 ml-2" />
            
            <!-- Menu contextuel administrateur -->
            <div 
              v-if="showUserMenu" 
              class="absolute bottom-full left-0 mb-2 w-full bg-white dark:bg-gray-900 rounded-xl shadow-lg border border-gray-200 dark:border-gray-800 py-2 z-50"
            >
              <NuxtLink 
                to="/admin/" 
                class="flex items-center w-full px-4 py-2.5 text-left hover:bg-gray-100 dark:hover:bg-gray-800"
              >
                <v-icon name="ri-user-fill" class="h-5 w-5 mr-3 text-gray-500 dark:text-gray-400" />
                <span>Mon profil admin</span>
              </NuxtLink>
              <NuxtLink 
                to="/admin/settings" 
                class="flex items-center w-full px-4 py-2.5 text-left hover:bg-gray-100 dark:hover:bg-gray-800"
              >
                <v-icon name="ri-settings-4-fill" class="h-5 w-5 mr-3 text-gray-500 dark:text-gray-400" />
                <span>Paramètres admin</span>
              </NuxtLink>
              <button 
                @click="logout" 
                class="flex items-center w-full px-4 py-2.5 text-left hover:bg-gray-100 dark:hover:bg-gray-800 text-red-600 dark:text-red-400"
              >
                <v-icon name="ri-logout-box-r-line" class="h-5 w-5 mr-3" />
                <span>Déconnexion</span>
              </button>
            </div>
          </button>
        </div>
      </aside>
      
      <!-- Menu mobile admin (bottom bar) -->
      <div class="md:hidden fixed bottom-0 left-0 right-0 bg-white dark:bg-gray-900 border-t border-gray-200 dark:border-gray-800 z-50">
        <div class="flex justify-around py-2">
          <NuxtLink 
            v-for="item in mobileMenuItems" 
            :key="item.to" 
            :to="item.to"
            class="flex flex-col items-center p-2 rounded-full"
            :class="route.path.includes(item.to) ? 'text-blue-500' : 'text-gray-600 dark:text-gray-400'"
          >
            <v-icon :name="item.icon" class="h-6 w-6 mb-1" />
            <span class="text-xs">{{ item.label }}</span>
          </NuxtLink>
        </div>
      </div>
      
      <!-- Header Mobile -->
      <header class="md:hidden fixed top-0 left-0 right-0 z-40 bg-white/80 dark:bg-gray-900/80 backdrop-blur-lg border-b border-gray-200 dark:border-gray-800">
        <div class="flex items-center justify-between p-4">
          <div class="flex items-center gap-3">
            <UButton
              icon="i-heroicons-bars-3"
              color="gray"
              variant="ghost"
              class="h-10 w-10 rounded-full hover:bg-gray-100 dark:hover:bg-gray-800"
              @click="isMobileMenuOpen = true"
            />
            <h1 class="font-bold text-xl">{{ getPageTitle() }}</h1>
          </div>
          <UButton
            icon="i-heroicons-user-circle"
            color="gray"
            variant="ghost"
            class="h-10 w-10 rounded-full hover:bg-gray-100 dark:hover:bg-gray-800"
          />
        </div>
      </header>

      <!-- Sidebar Mobile -->
      <div 
        class="fixed inset-0 bg-gray-900/60 backdrop-blur-sm z-50 transition-opacity duration-300"
        :class="isMobileMenuOpen ? 'opacity-100' : 'opacity-0 pointer-events-none'"
        @click="isMobileMenuOpen = false"
      >
        <div 
          class="fixed inset-y-0 left-0 w-[280px] bg-white dark:bg-gray-900 transform transition-transform duration-300 ease-out"
          :class="isMobileMenuOpen ? 'translate-x-0' : '-translate-x-full'"
          @click.stop
        >
          <!-- Sidebar Content -->
          <div class="flex flex-col h-full">
            <!-- Header -->
            <div class="p-4 flex items-center justify-between border-b border-gray-200 dark:border-gray-800">
              <Logo class="h-8" />
              <UButton
                icon="i-heroicons-x-mark"
                color="gray"
                variant="ghost"
                class="h-10 w-10 rounded-full hover:bg-gray-100 dark:hover:bg-gray-800"
                @click="isMobileMenuOpen = false"
              />
            </div>

            <!-- Navigation -->
            <div class="flex-1 overflow-y-auto">
              <nav class="p-4 space-y-1">
                <NuxtLink
                  v-for="item in navigationItems"
                  :key="item.to"
                  :to="item.to"
                  class="flex items-center gap-3 p-3 rounded-full transition-colors text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-800"
                  :class="route.path === item.to ? 'font-bold bg-gray-100 dark:bg-gray-800' : ''"
                  @click="isMobileMenuOpen = false"
                >
                  <v-icon 
                    :name="item.icon" 
                    class="h-6 w-6"
                    :class="route.path === item.to ? 'text-primary-500' : ''"
                  />
                  {{ item.label }}
                </NuxtLink>
              </nav>
            </div>

            <!-- Footer -->
            <div class="p-4 border-t border-gray-200 dark:border-gray-800">
              <div class="space-y-2">
                <NuxtLink
                  to="/"
                  class="flex items-center gap-3 p-3 rounded-full text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-800"
                  @click="isMobileMenuOpen = false"
                >
                  <v-icon name="ri-arrow-left-line" class="h-6 w-6" />
                  Retour au site
                </NuxtLink>
                <button
                  @click="logout"
                  class="w-full flex items-center gap-3 p-3 rounded-full text-red-600 dark:text-red-400 hover:bg-gray-100 dark:hover:bg-gray-800"
                >
                  <v-icon name="ri-logout-box-r-line" class="h-6 w-6" />
                  Déconnexion
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Contenu principal -->
      <main class="flex-1 md:ml-72 lg:ml-80 min-h-screen pb-16 md:pb-0">
        <!-- Contenu de la page admin -->
        <div class="p-4 md:p-8 max-w-7xl mx-auto">
          <slot />
        </div>
      </main>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useSupabaseClient, useSupabaseUser } from '#imports'


const route = useRoute()
const router = useRouter()
const client = useSupabaseClient()
const user = useSupabaseUser()

// État utilisateur
const adminName = ref('')
const showUserMenu = ref(false)
const isMobileMenuOpen = ref(false)

// Fermer le menu utilisateur quand on clique ailleurs
const closeUserMenu = (event) => {
  if (showUserMenu.value && !event.target.closest('button')) {
    showUserMenu.value = false
  }
}

// Fermer le menu mobile avec la touche Échap
const handleKeyDown = (event) => {
  if (event.key === 'Escape') {
    isMobileMenuOpen.value = false
    showUserMenu.value = false
  }
}

// Écouter les clics et touches
onMounted(() => {
  document.addEventListener('click', closeUserMenu)
  document.addEventListener('keydown', handleKeyDown)
  
  // Récupérer les infos administrateur
  fetchAdminInfo()
})

// Nettoyer les écouteurs
onUnmounted(() => {
  document.removeEventListener('click', closeUserMenu)
  document.removeEventListener('keydown', handleKeyDown)
})

// Récupérer les infos de l'administrateur
const fetchAdminInfo = async () => {
  if (user.value) {
    try {
      const { data, error } = await client
        .from('profiles')
        .select('first_name, last_name, role')
        .eq('id', user.value.id)
        .single()
      
      if (error) throw error
      
      if (data) {
        adminName.value = `${data.first_name || ''} ${data.last_name || ''}`.trim() || 'Admin'
      }
    } catch (error) {
      console.error('Erreur lors de la récupération du profil:', error)
    }
  }
}

// Obtenir le titre de la page actuelle
const getPageTitle = () => {
  if (route.path === '/admin') return 'Tableau de bord'
  if (route.path.includes('/admin/users')) return 'Gestion des utilisateurs'
  if (route.path.includes('/admin/requests')) return 'Demandes de service'
  if (route.path.includes('/admin/professions')) return 'Catégories'
  if (route.path.includes('/admin/services')) return 'Services'
  if (route.path.includes('/admin/settings')) return 'Paramètres'
  return 'Administration'
}

// Menu de tableau de bord
const dashboardItems = computed(() => [
  { to: '/admin', label: 'Tableau de bord', icon: 'ri-dashboard-3-line' },
])

// Menu de gestion
const managementItems = computed(() => [
  // Gestion des utilisateurs
  { to: '/admin/users', label: 'Utilisateurs', icon: 'hi-users' },
  // { to: '/admin/experts', label: 'Experts', icon: 'ri-user-star-fill' },
  
  // Gestion des missions et deals
  { to: '/admin/missions', label: 'Missions', icon: 'io-briefcase-outline' },
  { to: '/admin/deals', label: 'Deals', icon: 'fa-regular-handshake' },
  
  // Gestion du catalogue
  { to: '/admin/professions', label: 'Professions', icon: 'la-graduation-cap-solid' },
    { to: '/admin/skills', label: 'Compétences', icon: 'bi-star' },
  { to: '/admin/activities', label: 'Activités', icon: 'la-clock' },
  
  // Communication
  // { to: '/admin/conversations', label: 'Conversations', icon: 'ri-message2-fill' },
  { to: '/admin/reviews', label: 'Avis', icon: 'bi-chat-text' },
])

// Menu de configuration
const configItems = computed(() => [
  { to: '/admin/settings', label: 'Paramètres', icon: 'ri-settings-2-line' },
])

// Menu mobile (version simplifiée)
const mobileMenuItems = computed(() => [
  { to: '/admin', label: 'Accueil', icon: 'ri-home4-fill' },
  { to: '/admin/users', label: 'Utilisateurs', icon: 'ri-user3-fill' },
  { to: '/admin/missions', label: 'Missions', icon: 'ri-file-text-fill' },
  { to: '/admin/settings', label: 'Réglages', icon: 'ri-settings4-fill' },
])

// Déconnexion
const logout = async () => {
  try {
    const { error } = await client.auth.signOut()
    if (error) throw error
    router.push('/login')
  } catch (error) {
    console.error('Erreur lors de la déconnexion:', error)
  }
}

const navigationLinks = [
  {
    to: '/admin',
    icon: 'i-heroicons-home',
    label: 'Tableau de bord'
  },
  {
    to: '/admin/activities',
    icon: 'i-heroicons-clock',
    label: 'Activités'
  },
  {
    to: '/admin/users',
    icon: 'i-heroicons-users',
    label: 'Utilisateurs'
  },
  {
    to: '/admin/missions',
    icon: 'i-heroicons-briefcase',
    label: 'Missions'
  }
  // ... autres liens ...
]

const isActiveRoute = (path) => {
  if (path === '/admin') {
    return route.path === path
  }
  return route.path.startsWith(path)
}
</script>

<style scoped>
/* Supprimer le padding du bas sur mobile */
@media (max-width: 768px) {
  main {
    padding-bottom: 0 !important;
  }
}

/* Prévenir le scrolling quand le menu mobile est ouvert */
:global(body) {
  overflow: v-bind(isMobileMenuOpen ? 'hidden' : 'auto');
}

/* Nouveaux styles pour corriger l'overflow */
.wrapper {
  @apply min-h-screen w-full overflow-x-hidden;
}

main {
  @apply w-full overflow-x-hidden;
}

/* Ajustements pour le menu mobile */
.dialog-panel {
  @apply w-[280px] max-w-[80vw] h-[100dvh] overflow-hidden;
}

/* Ajustements pour le contenu scrollable */
.mobile-menu-content {
  @apply flex-1 overflow-y-auto overflow-x-hidden;
}
</style> 
