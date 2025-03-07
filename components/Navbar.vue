<template>
  <nav class="fixed top-0 left-0 right-0 h-16 bg-white/80 backdrop-blur-md border-b border-gray-200 z-50 dark:bg-gray-900/80 dark:border-gray-800 transition-all duration-300">
    <div class="max-w-7xl mx-auto px-4 h-full flex items-center justify-between">
      <!-- Logo -->
      <NuxtLink to="/" class="text-xl font-bold text-primary-600 flex items-center">
        <Logo class="h-9 w-auto" />
      </NuxtLink>

      <!-- Navigation principale -->
      <div class="hidden md:flex items-center gap-6">
        <NuxtLink 
          v-for="item in navItems" 
          :key="item.path"
          :to="item.path"
          class="text-gray-600 dark:text-gray-300 hover:text-gray-900 dark:hover:text-white font-medium px-3 py-2 rounded-full transition-colors relative group"
          active-class="text-primary-600 dark:text-primary-400"
        >
          {{ item.label }}
          <span class="absolute inset-x-0 -bottom-0.5 h-0.5 bg-primary-500 scale-x-0 group-hover:scale-x-100 transition-transform origin-left rounded-full"></span>
        </NuxtLink>
      </div>

      <!-- Actions -->
      <div class="flex items-center gap-3">
        <!-- Recherche -->
        <button class="p-2 text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200 rounded-full hover:bg-gray-100 dark:hover:bg-gray-800 transition-colors">
          <LucideIcon :icon="Search" size="20" />
        </button>
        
        <!-- Thème -->
        <button 
          @click="toggleDarkMode" 
          class="p-2 text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200 rounded-full hover:bg-gray-100 dark:hover:bg-gray-800 transition-colors"
        >
          <LucideIcon v-if="isDarkMode" :icon="Sun" size="20" />
          <LucideIcon v-else :icon="Moon" size="20" />
        </button>

        <template v-if="!user">
          <NuxtLink 
            to="/auth/login" 
            class="px-4 py-2 text-gray-600 dark:text-gray-300 hover:text-gray-900 dark:hover:text-white font-medium transition-colors"
          >
            Connexion
          </NuxtLink>
          <NuxtLink 
            to="/auth/register" 
            class="px-4 py-2 bg-primary-600 text-white rounded-full hover:bg-primary-700 transition-all shadow-sm hover:shadow btn-gafam"
          >
            Inscription
          </NuxtLink>
        </template>

        <!-- Menu utilisateur -->
        <Menu v-else as="div" class="relative">
          <MenuButton class="flex items-center gap-2 p-1.5 hover:bg-gray-100 dark:hover:bg-gray-800 rounded-full transition-colors">
            <div class="w-8 h-8 rounded-full overflow-hidden bg-gray-200 dark:bg-gray-700 flex-shrink-0">
              <img 
                v-if="user.user_metadata?.avatar_url || user.user_metadata?.picture"
                :src="user.user_metadata?.avatar_url || user.user_metadata?.picture" 
                :alt="user.user_metadata?.name || user.user_metadata?.full_name || user.email"
                class="w-full h-full object-cover"
                @error="handleAvatarError"
              />
              <LucideIcon v-else :icon="UserCircle" size="32" class="text-gray-500 dark:text-gray-400 w-full h-full" />
            </div>
            <LucideIcon :icon="ChevronDown" size="16" class="text-gray-500 dark:text-gray-400" />
          </MenuButton>
          
          <transition
            enter-active-class="transition duration-200 ease-out"
            enter-from-class="opacity-0 scale-95"
            enter-to-class="opacity-100 scale-100"
            leave-active-class="transition duration-150 ease-in"
            leave-from-class="opacity-100 scale-100"
            leave-to-class="opacity-0 scale-95"
          >
            <MenuItems class="absolute right-0 mt-2 w-56 bg-white dark:bg-gray-800 rounded-xl shadow-lg border border-gray-200 dark:border-gray-700 overflow-hidden z-50">
              <div class="p-3 border-b border-gray-100 dark:border-gray-700">
                <div class="font-medium text-gray-900 dark:text-white">
                  {{ userDisplayName }}
                </div>
                <div class="text-sm text-gray-500 dark:text-gray-400 truncate">
                  {{ user.email }}
                </div>
              </div>
              <div class="py-1">
                <MenuItem v-slot="{ active }" v-for="item in userMenuItems" :key="item.label">
                  <NuxtLink 
                    :to="item.path"
                    :class="[
                      active ? 'bg-gray-50 dark:bg-gray-700' : '',
                      'flex items-center px-4 py-2 text-gray-700 dark:text-gray-300'
                    ]"
                  >
                    <LucideIcon :icon="item.icon" size="18" class="mr-2 text-gray-500 dark:text-gray-400" />
                    {{ item.label }}
                  </NuxtLink>
                </MenuItem>
                
                <div class="border-t border-gray-100 dark:border-gray-700 my-1"></div>
              
                <MenuItem v-slot="{ active }">
                  <button
                    @click="handleLogout"
                    :class="[
                      active ? 'bg-gray-50 dark:bg-gray-700' : '',
                      'flex items-center px-4 py-2 text-gray-700 dark:text-gray-300 w-full'
                    ]"
                  >
                    <LucideIcon :icon="LogOut" size="18" class="mr-2 text-gray-500 dark:text-gray-400" />
                    Déconnexion
                  </button>
                </MenuItem>
              </div>
            </MenuItems>
          </transition>
        </Menu>

        <!-- Menu mobile -->
        <button 
          @click="mobileMenuOpen = !mobileMenuOpen"
          class="md:hidden p-2 text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200 rounded-full hover:bg-gray-100 dark:hover:bg-gray-800 transition-colors"
        >
          <LucideIcon v-if="mobileMenuOpen" :icon="X" size="20" />
          <LucideIcon v-else :icon="MenuIcon" size="20" />
        </button>
      </div>
    </div>

    <!-- Menu mobile -->
    <transition
      enter-active-class="transition duration-300 ease-out"
      enter-from-class="opacity-0 -translate-y-4"
      enter-to-class="opacity-100 translate-y-0"
      leave-active-class="transition duration-200 ease-in"
      leave-from-class="opacity-100 translate-y-0"
      leave-to-class="opacity-0 -translate-y-4"
    >
      <div v-if="mobileMenuOpen" class="md:hidden absolute inset-x-0 top-16 bg-white dark:bg-gray-900 border-b border-gray-200 dark:border-gray-800 shadow-lg">
        <div class="px-4 py-3 space-y-1">
          <NuxtLink 
            v-for="item in navItems" 
            :key="item.path"
            :to="item.path"
            class="block px-4 py-2 text-gray-700 dark:text-gray-300 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-800 transition-colors"
            @click="mobileMenuOpen = false"
          >
            {{ item.label }}
          </NuxtLink>
        </div>
      </div>
    </transition>
  </nav>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { Menu, MenuButton, MenuItems, MenuItem } from '@headlessui/vue'
import Logo from '~/components/shared/Logo.vue'
import LucideIcon from '~/components/LucideIcon.vue'
import { 
  Search, Moon, Sun, UserCircle, Settings, LogOut, User, Bell, 
  Calendar, ChevronDown, X,  MenuIcon, Shield, Home, FileText
} from 'lucide-vue-next'

// État UI
const mobileMenuOpen = ref(false)
const avatarError = ref(false)

// Dark mode
const isDarkMode = ref(false)

const toggleDarkMode = () => {
  isDarkMode.value = !isDarkMode.value
  localStorage.setItem('theme', isDarkMode.value ? 'dark' : 'light')
  
  if (isDarkMode.value) {
    document.documentElement.classList.add('dark')
  } else {
    document.documentElement.classList.remove('dark')
  }
}

// Éléments de navigation
const navItems = [
  { path: '/experts', label: 'Experts' },
  { path: '/requests', label: 'Demandes' },
  { path: '/pricing', label: 'Tarifs' },
  { path: '/about', label: 'À propos' }
]

// Menu utilisateur
const userMenuItems = computed(() => {
  const items = [
    { path: '/profile', label: 'Mon profil', icon: User },
    { path: '/dashboard', label: 'Tableau de bord', icon: Home }
  ]
  
  // Ajouter des éléments selon le rôle de l'utilisateur
  if (user.value?.user_metadata?.role === 'admin') {
    items.push({ path: '/admin/dashboard', label: 'Administration', icon: Shield })
  }
  
  items.push({ path: '/settings', label: 'Paramètres', icon: Settings })
  
  return items
})

// Connexion Supabase
const supabase = useSupabaseClient()
const user = useSupabaseUser()

const userDisplayName = computed(() => {
  if (!user.value) return ''
  
  const metadata = user.value.user_metadata || {}
  return metadata.name || 
         metadata.full_name || 
         metadata.first_name ? `${metadata.first_name} ${metadata.last_name || ''}` : 
         user.value.email.split('@')[0]
})

const handleAvatarError = () => {
  avatarError.value = true
}

const handleLogout = async () => {
  try {
    const { error } = await supabase.auth.signOut()
    if (error) throw error
    
    // Rediriger vers la page d'accueil
    navigateTo('/')
  } catch (error) {
    console.error('Erreur lors de la déconnexion:', error)
  }
}

// Initialisation
onMounted(() => {
  // Récupérer le thème des préférences
  const savedTheme = localStorage.getItem('theme')
  const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches
  
  isDarkMode.value = savedTheme === 'dark' || (!savedTheme && prefersDark)
  
  // Appliquer le thème
  if (isDarkMode.value) {
    document.documentElement.classList.add('dark')
  }
})

// Fermer le menu mobile lors du changement de route
watch(() => useRoute().fullPath, () => {
  mobileMenuOpen.value = false
})
</script> 