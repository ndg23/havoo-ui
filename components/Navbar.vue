<template>
  <header class="fixed top-0 z-40 w-full bg-white/90 dark:bg-gray-900/90 backdrop-blur-sm border-b border-gray-200/80 dark:border-gray-800/80">
    <!-- Légère lueur subtile sur la bordure -->
    <div class="absolute inset-x-0 bottom-0 h-[1px] bg-gradient-to-r from-transparent via-primary-500/30 to-transparent"></div>
    
    <div class="mx-auto px-4 sm:px-6 lg:px-8 max-w-7xl">
      <div class="flex h-16 items-center justify-between">
        <!-- Logo avec effet hover -->
        <NuxtLink to="/" class="flex-shrink-0 group transition-transform duration-300 hover:scale-105">
          <Logo class="h-8 w-auto" />
        </NuxtLink>
        
        <!-- Navigation principale (desktop) -->
        <nav class="hidden md:flex items-center space-x-8">
          <NuxtLink 
            v-for="item in navItems" 
            :key="item.name"
            :to="item.href" 
            class="group flex items-center text-sm font-medium py-2 relative transition-colors duration-200"
            :class="[
              item.current 
                ? 'text-primary-600 dark:text-primary-400' 
                : 'text-gray-700 dark:text-gray-300 hover:text-primary-600 dark:hover:text-primary-400'
            ]"
          >
            <component 
              :is="item.icon" 
              class="h-5 w-5 mr-1.5 transition-transform duration-300 group-hover:scale-110" 
              :class="item.current ? 'text-primary-500' : 'text-gray-500 dark:text-gray-400'"
            />
            {{ item.name }}
            
            <!-- Indicateur animé -->
            <span 
              class="absolute -bottom-1 left-0 w-full h-0.5 bg-primary-500 dark:bg-primary-400 transform origin-left transition-transform duration-300"
              :class="item.current ? 'scale-x-100' : 'scale-x-0 group-hover:scale-x-100'"
            ></span>
          </NuxtLink>
        </nav>
        
        <!-- Actions -->
        <div class="flex items-center gap-2 md:gap-4">
          <!-- Thème -->
          <button 
            @click="toggleTheme"
            class="p-2 rounded-full text-gray-500 dark:text-gray-400 hover:bg-gray-100 dark:hover:bg-gray-800 transition-colors relative overflow-hidden"
            aria-label="Changer de thème"
          >
            <div class="relative">
              <Sun 
                class="h-5 w-5 transition-all duration-500 ease-out"
                :class="isDark ? 'opacity-0 rotate-90 scale-0' : 'opacity-100 rotate-0 scale-100'"
              />
              <Moon 
                class="h-5 w-5 absolute top-0 left-0 transition-all duration-500 ease-out"
                :class="isDark ? 'opacity-100 rotate-0 scale-100' : 'opacity-0 -rotate-90 scale-0'"
              />
            </div>
          </button>
          
          <!-- Profil utilisateur (connecté) -->
          <div v-if="isAuthenticated" class="relative">
            <button 
              @click="isProfileOpen = !isProfileOpen"
              class="flex rounded-full overflow-hidden border-2 border-gray-200 dark:border-gray-700 focus:outline-none focus:ring-2 focus:ring-primary-500 hover:border-primary-200 dark:hover:border-primary-700 transition-colors duration-200"
              data-profile="true"
            >
              <img 
                :src="user.avatarUrl || '/img/default-avatar.png'" 
                alt="Avatar" 
                class="h-8 w-8 object-cover"
              />
            </button>
            
            <!-- Menu profil -->
            <transition
              enter-active-class="transition ease-out duration-200"
              enter-from-class="transform opacity-0 scale-95"
              enter-to-class="transform opacity-100 scale-100"
              leave-active-class="transition ease-in duration-150"
              leave-from-class="transform opacity-100 scale-100"
              leave-to-class="transform opacity-0 scale-95"
            >
              <div 
                v-if="isProfileOpen"
                class="absolute right-0 mt-2 w-56 bg-white dark:bg-gray-800 rounded-lg shadow-lg overflow-hidden border border-gray-200 dark:border-gray-700"
                data-profile="true"
              >
                <!-- En-tête -->
                <div class="p-3 border-b border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-900/50">
                  <div class="font-medium text-gray-900 dark:text-white">{{ user.name }}</div>
                  <div class="text-xs text-gray-500 dark:text-gray-400">{{ user.email }}</div>
                </div>
                
                <!-- Liens -->
                <div class="py-1">
                  <NuxtLink 
                    v-for="item in userMenuItems" 
                    :key="item.name"
                    :to="item.href"
                    class="flex items-center px-4 py-2 text-sm text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors duration-150"
                  >
                    <component :is="item.icon" class="h-4 w-4 mr-3 text-gray-500 dark:text-gray-400" />
                    {{ item.name }}
                  </NuxtLink>
                  
                  <div class="border-t border-gray-200 dark:border-gray-700 my-1"></div>
                  
                  <button 
                    @click="logout"
                    class="flex w-full items-center px-4 py-2 text-sm text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors duration-150 text-left"
                  >
                    <LogOut class="h-4 w-4 mr-3 text-gray-500 dark:text-gray-400" />
                    Déconnexion
                  </button>
                </div>
              </div>
            </transition>
          </div>
          
          <!-- Boutons d'authentification (non connecté) -->
          <div v-else class="flex items-center gap-3">
            <NuxtLink 
              to="/login"
              class="text-sm font-medium text-gray-700 dark:text-gray-300 hover:text-primary-600 dark:hover:text-primary-400 transition-colors duration-200"
            >
              Connexion
            </NuxtLink>
            
            <NuxtLink 
              to="/signup"
              class="px-4 py-2 text-sm font-medium text-white bg-primary-600 hover:bg-primary-500 active:bg-primary-700 rounded-lg shadow-sm hover:shadow transition-all duration-200"
            >
              S'inscrire
            </NuxtLink>
          </div>
          
          <!-- Menu hamburger (mobile) -->
          <button 
            @click="isMobileMenuOpen = !isMobileMenuOpen"
            class="md:hidden p-2 rounded-lg text-gray-500 hover:bg-gray-100 dark:hover:bg-gray-800 transition-colors"
            aria-label="Menu"
          >
            <div class="w-6 h-5 flex flex-col justify-between relative">
              <!-- Lignes animées du hamburger -->
              <span 
                class="w-full h-0.5 bg-gray-600 dark:bg-gray-300 rounded-full transform transition-all duration-300"
                :class="isMobileMenuOpen ? 'rotate-45 translate-y-2' : ''"
              ></span>
              <span 
                class="w-full h-0.5 bg-gray-600 dark:bg-gray-300 rounded-full transition-opacity duration-300"
                :class="isMobileMenuOpen ? 'opacity-0' : 'opacity-100'"
              ></span>
              <span 
                class="w-full h-0.5 bg-gray-600 dark:bg-gray-300 rounded-full transform transition-all duration-300"
                :class="isMobileMenuOpen ? '-rotate-45 -translate-y-2' : ''"
              ></span>
            </div>
          </button>
        </div>
      </div>
      
      <!-- Menu mobile -->
      <transition
        enter-active-class="transition-all duration-300 ease-out"
        enter-from-class="opacity-0 -translate-y-4"
        enter-to-class="opacity-100 translate-y-0"
        leave-active-class="transition-all duration-200 ease-in"
        leave-from-class="opacity-100 translate-y-0"
        leave-to-class="opacity-0 -translate-y-4"
      >
        <div 
          v-if="isMobileMenuOpen"
          class="md:hidden py-3 border-t border-gray-200 dark:border-gray-700"
        >
          <div class="space-y-1 px-2">
            <NuxtLink 
              v-for="item in navItems" 
              :key="item.name"
              :to="item.href" 
              class="flex items-center py-2 px-3 text-base rounded-lg transition-colors duration-200"
              :class="[
                item.current 
                  ? 'bg-gray-100 dark:bg-gray-800 text-primary-600 dark:text-primary-400' 
                  : 'text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-800'
              ]"
              @click="isMobileMenuOpen = false"
            >
              <component :is="item.icon" class="h-5 w-5 mr-3" />
              {{ item.name }}
            </NuxtLink>
          </div>
        </div>
      </transition>
    </div>
  </header>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount } from 'vue'
import { useRouter } from 'vue-router'
import { 
  User, Menu, X, LogOut,
  Home, Briefcase, MessageSquare, FileText,
  Settings, Moon, Sun
} from 'lucide-vue-next'

const router = useRouter()

// États
const isAuthenticated = ref(true) // À connecter avec votre système d'auth
const isMobileMenuOpen = ref(false)
const isProfileOpen = ref(false)
const isDark = ref(false)

// Données utilisateur
const user = ref({
  name: 'John Doe',
  email: 'john@example.com',
  avatarUrl: null
})

// Navigation principale - Élements clés
const navItems = [
  { name: 'Accueil', href: '/', current: true, icon: Home },
  { name: 'Experts', href: '/experts', current: false, icon: Briefcase },
  { name: 'Demandes', href: '/requests', current: false, icon: MessageSquare },
  { name: 'Contrats', href: '/contracts', current: false, icon: FileText },
]

// Menu utilisateur - Focus sur l'essentiel
const userMenuItems = [
  { name: 'Mon profil', href: '/profile', icon: User },
  { name: 'Messages', href: '/messages', icon: MessageSquare },
  { name: 'Paramètres', href: '/settings', icon: Settings },
]

// Fonctions
const toggleTheme = () => {
  isDark.value = !isDark.value
  
  if (isDark.value) {
    document.documentElement.classList.add('dark')
    localStorage.setItem('theme', 'dark')
  } else {
    document.documentElement.classList.remove('dark')
    localStorage.setItem('theme', 'light')
  }
}

const logout = () => {
  isAuthenticated.value = false
  isProfileOpen.value = false
  router.push('/login')
}

// Fermer les menus au clic à l'extérieur
const handleClickOutside = (event) => {
  const target = event.target
  const isClickInsideProfile = target.closest('[data-profile]')
  
  if (isProfileOpen.value && !isClickInsideProfile) {
    isProfileOpen.value = false
  }
}

// Cycle de vie
onMounted(() => {
  // Initialiser le thème
  isDark.value = localStorage.getItem('theme') === 'dark' || 
    (!localStorage.getItem('theme') && window.matchMedia('(prefers-color-scheme: dark)').matches)
  
  if (isDark.value) {
    document.documentElement.classList.add('dark')
  }
  
  document.addEventListener('click', handleClickOutside)
  
  // Fermer le menu mobile au changement de route
  router.afterEach(() => {
    isMobileMenuOpen.value = false
  })
})

onBeforeUnmount(() => {
  document.removeEventListener('click', handleClickOutside)
})
</script>

<style scoped>
/* Espacement en haut pour compenser la navbar fixe */
:deep(main) {
  padding-top: 64px;
}
</style> 
