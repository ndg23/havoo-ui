<template>
  <div class="min-h-screen bg-white dark:bg-black">
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
              <component :is="item.icon" class="h-7 w-7 mr-4" :class="route.path === item.to ? 'text-blue-500' : ''" />
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
              <component :is="item.icon" class="h-7 w-7 mr-4" :class="route.path.includes(item.to) ? 'text-blue-500' : ''" />
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
              <component :is="item.icon" class="h-7 w-7 mr-4" :class="route.path === item.to ? 'text-blue-500' : ''" />
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
              <ArrowLeft class="h-5 w-5 mr-2" />
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
                <Shield class="h-5 w-5" />
              </div>
              <div class="flex flex-col min-w-0">
                <span class="font-bold text-black dark:text-white truncate">{{ adminName || 'Admin' }}</span>
                <span class="text-gray-500 dark:text-gray-400 text-sm truncate">
                  Administrateur
                </span>
              </div>
            </div>
            <MoreHorizontal class="h-5 w-5 text-gray-500 dark:text-gray-400 ml-2" />
            
            <!-- Menu contextuel administrateur -->
            <div 
              v-if="showUserMenu" 
              class="absolute bottom-full left-0 mb-2 w-full bg-white dark:bg-gray-900 rounded-xl shadow-lg border border-gray-200 dark:border-gray-800 py-2 z-50"
            >
              <NuxtLink 
                to="/admin/profile" 
                class="flex items-center w-full px-4 py-2.5 text-left hover:bg-gray-100 dark:hover:bg-gray-800"
              >
                <User class="h-5 w-5 mr-3 text-gray-500 dark:text-gray-400" />
                <span>Mon profil admin</span>
              </NuxtLink>
              <NuxtLink 
                to="/admin/settings" 
                class="flex items-center w-full px-4 py-2.5 text-left hover:bg-gray-100 dark:hover:bg-gray-800"
              >
                <Settings class="h-5 w-5 mr-3 text-gray-500 dark:text-gray-400" />
                <span>Paramètres admin</span>
              </NuxtLink>
              <button 
                @click="logout" 
                class="flex items-center w-full px-4 py-2.5 text-left hover:bg-gray-100 dark:hover:bg-gray-800 text-red-600 dark:text-red-400"
              >
                <LogOut class="h-5 w-5 mr-3" />
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
            <component :is="item.icon" class="h-6 w-6 mb-1" />
            <span class="text-xs">{{ item.label }}</span>
          </NuxtLink>
        </div>
      </div>
      
      <!-- Contenu principal -->
      <main class="flex-1 md:ml-72 lg:ml-80 min-h-screen pb-16 md:pb-0">
        <!-- Header mobile -->
        <header class="md:hidden flex items-center justify-between p-4 border-b border-gray-200 dark:border-gray-800 bg-white dark:bg-gray-900 sticky top-0 z-40">
          <div class="flex items-center">
            <h1 class="font-bold text-xl">{{ getPageTitle() }}</h1>
            <div class="ml-2 px-2 py-0.5 bg-gray-800 dark:bg-gray-700 rounded text-xs font-bold text-white">
              ADMIN
            </div>
          </div>
          <button @click="isMobileMenuOpen = true" class="p-2">
            <div class="h-8 w-8 rounded-full bg-blue-500 flex items-center justify-center text-white">
              <Shield class="h-4 w-4" />
            </div>
        </button>
        </header>
        
        <!-- Menu mobile slide-out -->
        <div 
          v-if="isMobileMenuOpen" 
          class="fixed inset-0 z-50 md:hidden"
        >
          <!-- Backdrop -->
          <div 
            class="absolute inset-0 bg-black/50" 
            @click="isMobileMenuOpen = false"
          ></div>
          
          <!-- Menu slide-in -->
          <div class="absolute top-0 left-0 h-full w-4/5 max-w-xs bg-white dark:bg-gray-900 transform transition-transform duration-300 ease-in-out animate-slide-in">
            <div class="p-4 flex justify-between items-center border-b border-gray-200 dark:border-gray-800">
              <div class="flex items-center">
                <Logo :small="true" />
                <div class="ml-2 px-2 py-0.5 bg-gray-800 dark:bg-gray-700 rounded text-xs font-bold text-white">
                  ADMIN
                </div>
              </div>
              <button @click="isMobileMenuOpen = false" class="p-2 rounded-full hover:bg-gray-100 dark:hover:bg-gray-800">
                <X class="h-6 w-6 text-gray-500 dark:text-gray-400" />
              </button>
            </div>
            
            <div class="p-4">
              <div class="flex items-center mb-6">
                <div class="h-14 w-14 rounded-full bg-blue-500 flex items-center justify-center text-white font-bold mr-3">
                  <Shield class="h-7 w-7" />
                </div>
                <div>
                  <div class="font-bold text-lg">{{ adminName || 'Admin' }}</div>
                  <div class="text-gray-500 dark:text-gray-400">
                    Administrateur
                  </div>
            </div>
          </div>
          
              <!-- Sections de navigation mobile -->
              <div class="space-y-6">
                <!-- Vue d'ensemble -->
                <div>
                  <div class="text-xs font-bold uppercase tracking-wider text-gray-500 dark:text-gray-400 mb-2">
                    Vue d'ensemble
                  </div>
                  <nav class="space-y-1">
                    <NuxtLink 
                      v-for="item in dashboardItems" 
                      :key="item.to" 
                      :to="item.to"
                      class="flex items-center p-3 rounded-xl hover:bg-gray-100 dark:hover:bg-gray-800 transition-colors"
                      :class="route.path === item.to ? 'font-bold' : 'font-medium text-gray-700 dark:text-gray-300'"
                      @click="isMobileMenuOpen = false"
                    >
                      <component :is="item.icon" class="h-6 w-6 mr-3" :class="route.path === item.to ? 'text-blue-500' : ''" />
                      <span>{{ item.label }}</span>
                    </NuxtLink>
                  </nav>
        </div>
        
                <!-- Gestion -->
                <div>
                  <div class="text-xs font-bold uppercase tracking-wider text-gray-500 dark:text-gray-400 mb-2">
                    Gestion
                  </div>
                  <nav class="space-y-1">
                    <NuxtLink 
                      v-for="item in managementItems" 
                      :key="item.to" 
                      :to="item.to"
                      class="flex items-center p-3 rounded-xl hover:bg-gray-100 dark:hover:bg-gray-800 transition-colors"
                      :class="route.path.includes(item.to) ? 'font-bold' : 'font-medium text-gray-700 dark:text-gray-300'"
                      @click="isMobileMenuOpen = false"
                    >
                      <component :is="item.icon" class="h-6 w-6 mr-3" :class="route.path.includes(item.to) ? 'text-blue-500' : ''" />
                      <span>{{ item.label }}</span>
                    </NuxtLink>
                  </nav>
                </div>
                
                <!-- Configuration -->
                <div>
                  <div class="text-xs font-bold uppercase tracking-wider text-gray-500 dark:text-gray-400 mb-2">
                    Configuration
            </div>
                  <nav class="space-y-1">
                    <NuxtLink 
                      v-for="item in configItems" 
                      :key="item.to" 
                      :to="item.to"
                      class="flex items-center p-3 rounded-xl hover:bg-gray-100 dark:hover:bg-gray-800 transition-colors"
                      :class="route.path === item.to ? 'font-bold' : 'font-medium text-gray-700 dark:text-gray-300'"
                      @click="isMobileMenuOpen = false"
                    >
                      <component :is="item.icon" class="h-6 w-6 mr-3" :class="route.path === item.to ? 'text-blue-500' : ''" />
                      <span>{{ item.label }}</span>
                    </NuxtLink>
                  </nav>
            </div>
          </div>
              
              <div class="mt-6 pt-6 border-t border-gray-200 dark:border-gray-800">
                <NuxtLink 
                  to="/" 
                  class="flex items-center w-full p-3 rounded-xl hover:bg-gray-100 dark:hover:bg-gray-800 font-medium"
                  @click="isMobileMenuOpen = false"
                >
                  <ArrowLeft class="h-6 w-6 mr-3" />
                  <span>Retour au site</span>
                </NuxtLink>
                
            <button 
              @click="logout"
                  class="flex items-center w-full p-3 rounded-xl hover:bg-gray-100 dark:hover:bg-gray-800 text-red-600 dark:text-red-400 font-medium mt-2"
            >
                  <LogOut class="h-6 w-6 mr-3" />
                  <span>Déconnexion</span>
            </button>
          </div>
        </div>
      </div>
        </div>
        
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
import {
  Home, Users, Settings, Database, LogOut, LayoutDashboard,
  FileText, PanelLeft, Shield, ChevronDown, MessageSquare,
  MoreHorizontal, X, Gauge, BarChart2, ArrowLeft, Bell,
  User, ShoppingBag, Calendar, Globe, Lock, Cog, HelpCircle,
  Layers, FileSpreadsheet, CreditCard, LayoutList, LayoutGrid
} from 'lucide-vue-next'

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
  if (route.path.includes('/admin/categories')) return 'Catégories'
  if (route.path.includes('/admin/services')) return 'Services'
  if (route.path.includes('/admin/settings')) return 'Paramètres'
  return 'Administration'
}

// Menu de tableau de bord
const dashboardItems = computed(() => [
  { to: '/admin', label: 'Tableau de bord', icon: LayoutDashboard },
  { to: '/admin/analytics', label: 'Statistiques', icon: BarChart2 },
  { to: '/admin/activity', label: 'Activité récente', icon: Bell },
])

// Menu de gestion
const managementItems = computed(() => [
  { to: '/admin/users', label: 'Utilisateurs', icon: Users },
  { to: '/admin/requests', label: 'Demandes', icon: FileText },
  { to: '/admin/categories', label: 'Catégories', icon: LayoutGrid },
  { to: '/admin/services', label: 'Services', icon: ShoppingBag },
  { to: '/admin/payments', label: 'Paiements', icon: CreditCard },
])

// Menu de configuration
const configItems = computed(() => [
  { to: '/admin/settings', label: 'Paramètres site', icon: Settings },
  { to: '/admin/permissions', label: 'Permissions', icon: Lock },
  { to: '/admin/maintenance', label: 'Maintenance', icon: Cog },
])

// Menu mobile simplifié
const mobileMenuItems = computed(() => [
  { to: '/admin', label: 'Accueil', icon: Home },
  { to: '/admin/users', label: 'Utilisateurs', icon: Users },
  { to: '/admin/requests', label: 'Demandes', icon: FileText },
  { to: '/admin/settings', label: 'Réglages', icon: Settings },
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
</script>

<style scoped>
/* Effet de transition pour le menu mobile */
@keyframes slide-in {
  0% { transform: translateX(-100%); }
  100% { transform: translateX(0); }
}

.animate-slide-in {
  animation: slide-in 0.3s ease-out forwards;
}

/* Prévenir le scrolling quand le menu mobile est ouvert */
:global(body) {
  overflow: v-bind(isMobileMenuOpen ? 'hidden' : 'auto');
}
</style> 
