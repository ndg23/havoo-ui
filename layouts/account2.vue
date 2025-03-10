<template>
  <div class="min-h-screen bg-white dark:bg-black">
    <div class="flex">
      <!-- Sidebar Twitter-style -->
      <aside class="hidden md:flex h-screen w-72 lg:w-80 fixed flex-col py-4 border-r border-gray-200 dark:border-gray-800">
        <!-- Logo -->
        <div class="px-4 mb-6">
          <NuxtLink to="/" class="inline-block">
            <Logo :small="false" />
          </NuxtLink>
        </div>
        
        <!-- Menu principal (Twitter-style) -->
        <nav class="flex-1 px-2">
          <div class="space-y-1">
            <NuxtLink 
              v-for="item in mainMenuItems" 
              :key="item.to" 
              :to="item.to"
              class="flex items-center p-3 text-xl rounded-full transition-colors group relative hover:bg-gray-100 dark:hover:bg-gray-900"
              :class="route.path === item.to ? 'font-bold' : 'font-medium text-gray-700 dark:text-gray-300'"
            >
              <component :is="item.icon" class="h-7 w-7 mr-4" :class="route.path === item.to ? 'text-primary-500' : ''" />
              <span>{{ item.label }}</span>
              <div 
                v-if="route.path === item.to" 
                class="absolute right-4 h-2 w-2 rounded-full bg-primary-500"
              ></div>
            </NuxtLink>
          </div>
          
          <!-- Bouton "Créer" (style Twitter "Tweet") -->
          <div class="mt-8 px-2">
            <NuxtLink 
              to="/requests/new"
              class="bg-primary-500 hover:bg-primary-600 text-white rounded-full py-3.5 px-4 w-full flex items-center justify-center font-bold text-lg transition-colors shadow-sm"
            >
              <Plus class="h-5 w-5 mr-2" />
              Créer une demande
            </NuxtLink>
          </div>
          
          <!-- Liens existants... -->
          
          <NuxtLink 
            to="/account/skills" 
            class="group flex items-center px-3 py-2.5 text-sm font-medium rounded-lg"
            :class="route.path.includes('/account/skills') 
              ? 'bg-primary-500 text-white' 
              : 'text-gray-700 hover:bg-gray-100'"
          >
            <Badge class="mr-3 h-5 w-5" :class="route.path.includes('/account/skills') ? 'text-white' : 'text-gray-500'" />
            <span>Mes compétences</span>
          </NuxtLink>
          
          <!-- Autres liens... -->
        </nav>
        
        <!-- Profil utilisateur en bas (Twitter-style) -->
        <div class="mt-auto px-4">
          <button 
            @click="showUserMenu = !showUserMenu"
            class="flex items-center p-3 w-full rounded-full hover:bg-gray-100 dark:hover:bg-gray-900 transition-colors relative group"
          >
            <div class="flex items-center flex-1 min-w-0">
                <img 
                  :src="userAvatar || '/images/default-avatar.png'" 
                  alt="Photo de profil"
                class="h-10 w-10 rounded-full mr-3 object-cover border border-gray-200 dark:border-gray-700"
              />
              <div class="flex flex-col min-w-0">
                <span class="font-bold text-black dark:text-white truncate">{{ userName || 'Utilisateur' }}</span>
                <span class="text-gray-500 dark:text-gray-400 text-sm truncate">
                  @{{ userHandle || userName?.toLowerCase().replace(/\s/g, '') || 'user' }}
                </span>
              </div>
            </div>
            <MoreHorizontal class="h-5 w-5 text-gray-500 dark:text-gray-400 ml-2" />
            
            <!-- Menu contextuel utilisateur -->
            <div 
              v-if="showUserMenu" 
              class="absolute bottom-full left-0 mb-2 w-full bg-white dark:bg-gray-900 rounded-xl shadow-lg border border-gray-200 dark:border-gray-800 py-2 z-50"
            >
              <NuxtLink 
                to="/account/edit-profile" 
                class="flex items-center w-full px-4 py-2.5 text-left hover:bg-gray-100 dark:hover:bg-gray-800"
              >
                <User class="h-5 w-5 mr-3 text-gray-500 dark:text-gray-400" />
                <span>Modifier mon profil</span>
              </NuxtLink>
                      <NuxtLink 
                to="/account/settings" 
                class="flex items-center w-full px-4 py-2.5 text-left hover:bg-gray-100 dark:hover:bg-gray-800"
              >
                <Settings class="h-5 w-5 mr-3 text-gray-500 dark:text-gray-400" />
                <span>Paramètres</span>
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
        
      <!-- Menu mobile (bottom bar) -->
      <div class="md:hidden fixed bottom-0 left-0 right-0 bg-white dark:bg-gray-900 border-t border-gray-200 dark:border-gray-800 z-50">
        <div class="flex justify-around py-2">
            <NuxtLink 
              v-for="item in mobileMenuItems" 
              :key="item.to" 
              :to="item.to"
            class="flex flex-col items-center p-2 rounded-full"
            :class="route.path === item.to ? 'text-primary-500' : 'text-gray-600 dark:text-gray-400'"
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
          <h1 class="font-bold text-xl">{{ getPageTitle() }}</h1>
          <button @click="isMobileMenuOpen = true" class="p-2">
            <img 
              :src="userAvatar || '/images/default-avatar.png'" 
              alt="Menu"
              class="h-8 w-8 rounded-full object-cover"
            />
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
          <div class="absolute top-0 left-0 h-full w-4/5 max-w-xs bg-white dark:bg-gray-900 transform transition-transform duration-300 ease-in-out">
            <div class="p-4 flex justify-between items-center border-b border-gray-200 dark:border-gray-800">
              <Logo :small="true" />
              <button @click="isMobileMenuOpen = false" class="p-2 rounded-full hover:bg-gray-100 dark:hover:bg-gray-800">
                <X class="h-6 w-6 text-gray-500 dark:text-gray-400" />
              </button>
            </div>
            
            <div class="p-4">
              <div class="flex items-center mb-6">
                <img 
                  :src="userAvatar || '/images/default-avatar.png'" 
                  alt="Photo de profil"
                  class="h-14 w-14 rounded-full mr-3 object-cover"
                />
                <div>
                  <div class="font-bold text-lg">{{ userName || 'Utilisateur' }}</div>
                  <div class="text-gray-500 dark:text-gray-400">
                    @{{ userHandle || userName?.toLowerCase().replace(/\s/g, '') || 'user' }}
                  </div>
                </div>
              </div>
              
              <nav class="space-y-1">
                <NuxtLink 
                  v-for="item in mainMenuItems" 
                  :key="item.to" 
                  :to="item.to"
                  class="flex items-center p-3 rounded-xl hover:bg-gray-100 dark:hover:bg-gray-800 transition-colors"
                  :class="route.path === item.to ? 'font-bold' : 'font-medium text-gray-700 dark:text-gray-300'"
                  @click="isMobileMenuOpen = false"
                >
                  <component :is="item.icon" class="h-6 w-6 mr-3" :class="route.path === item.to ? 'text-primary-500' : ''" />
                  <span>{{ item.label }}</span>
                </NuxtLink>
              </nav>
              
              <div class="mt-6 pt-6 border-t border-gray-200 dark:border-gray-800">
                <button 
                  @click="logout" 
                  class="flex items-center w-full p-3 rounded-xl hover:bg-gray-100 dark:hover:bg-gray-800 text-red-600 dark:text-red-400"
                >
                  <LogOut class="h-6 w-6 mr-3" />
                  <span class="font-medium">Déconnexion</span>
                </button>
              </div>
            </div>
          </div>
        </div>
        
        <div class="p-4 md:p-8 max-w-4xl mx-auto">
          <slot />
          </div>
        </main>
      </div>
    </div>
  </template>
  
  <script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
  import { useSupabaseClient, useSupabaseUser } from '#imports'
  import { 
  Home, User, Settings, Bell, LogOut, PackageOpen,
  FileText, PanelLeft, Briefcase, Wrench, MessageSquare, 
  Shield, MoreHorizontal, X, Plus, UserPlus,
  Clock, Bookmark, LayoutDashboard, Activity, Badge, Search, CheckCircle
  } from 'lucide-vue-next'
  
  const route = useRoute()
  const router = useRouter()
  const client = useSupabaseClient()
  const user = useSupabaseUser()
  
// État utilisateur
  const userName = ref('')
  const userAvatar = ref('')
const userHandle = ref('')
const showUserMenu = ref(false)
const isMobileMenuOpen = ref(false)
const userRole = ref('')

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
  
  // Récupérer les infos utilisateur
  fetchUserInfo()
})

// Nettoyer les écouteurs
onUnmounted(() => {
  document.removeEventListener('click', closeUserMenu)
  document.removeEventListener('keydown', handleKeyDown)
})
  
  // Récupérer les infos de l'utilisateur
const fetchUserInfo = async () => {
    if (user.value) {
      try {
        const { data, error } = await client
          .from('users')
          .select('first_name, last_name, avatar_url, is_expert')
          .eq('id', user.value.id)
          .single()
        
        if (error) throw error
        
        if (data) {
          userName.value = `${data.first_name || ''} ${data.last_name || ''}`.trim()
          userAvatar.value = data.avatar_url
          userRole.value = data.is_expert ? 'expert' : 'client'
        }
      } catch (error) {
        console.error('Erreur lors de la récupération du profil:', error)
      }
    }
}

// Obtenir le titre de la page actuelle
const getPageTitle = () => {
  switch (route.path) {
    case '/account': return 'Tableau de bord'
    case '/account/edit-profile': return 'Profil'
    case '/account/requests': return 'Mes demandes'
    case '/account/my-proposals': return 'Mes propositions'
    case '/account/services': return 'Services'
    case '/account/feedback': return 'Avis'
    case '/account/settings': return 'Paramètres'
    case '/account/verification': return 'Vérification'
    default: return 'Compte'
  }
}

// Menu principal (style Twitter avec grandes icônes)
const mainMenuItems = computed(() => [
  { to: '/account', label: 'Accueil', icon: Home },
        { to: '/account/requests', label: 'Mes demandes', icon: FileText },
  { to: '/account/my-proposals', label: 'Propositions', icon: PackageOpen },
  { to: '/account/services', label: 'Services', icon: Briefcase },
  { to: '/account/edit-profile', label: 'Profil', icon: User },
  { to: '/account/feedback', label: 'Avis reçus', icon: MessageSquare },
  { to: '/account/settings', label: 'Paramètres', icon: Settings },
  ])
  
  // Menu mobile simplifié
  const mobileMenuItems = computed(() => [
    { to: '/account', label: 'Accueil', icon: Home },
    { to: '/account/requests', label: 'Demandes', icon: FileText },
  { to: '/account/my-proposals', label: 'Offres', icon: PackageOpen },
    { to: '/account/edit-profile', label: 'Profil', icon: User },
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
@keyframes slideIn {
  0% { transform: translateX(-100%); }
  100% { transform: translateX(0); }
}

/* Prévenir le scrolling quand le menu mobile est ouvert */
:global(body) {
  overflow: v-bind(isMobileMenuOpen ? 'hidden' : 'auto');
}
</style>