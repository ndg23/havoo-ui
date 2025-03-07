<template>
  <div class="h-screen flex bg-white dark:bg-gray-950 text-gray-900 dark:text-white overflow-hidden font-sans">
    <!-- Sidebar style Twitter 2024 -->
    <aside 
      class="transition-all duration-300 ease-in-out flex flex-col z-30 border-r border-gray-100 dark:border-gray-800/60"
      :class="{ 
        'w-[260px]': !sidebarCollapsed, 
        'w-[68px]': sidebarCollapsed,
      }"
    >
      <!-- Logo area -->
      <div class="h-[72px] flex items-center px-3">
        <NuxtLink to="/admin" class="flex items-center">
          <div class="flex-shrink-0 p-1.5">
            <Logo :icon-only="sidebarCollapsed" :small="false" />
          </div>
        </NuxtLink>
      </div>
      
      <!-- Navigation links - Twitter 2024 style -->
      <div class="flex-1 overflow-y-auto scrollbar-none pt-2">
        <div v-for="section in simplifiedNav" :key="section.title" class="mb-6">
          <h3 
            v-if="!sidebarCollapsed && section.title" 
            class="px-5 text-xs uppercase font-semibold text-gray-500 dark:text-gray-400 tracking-wider mb-2"
          >
            {{ section.title }}
          </h3>
          
          <div v-if="sidebarCollapsed && section.title" class="h-4"></div>
          
          <NuxtLink 
            v-for="item in section.items"
            :key="item.to"
            :to="item.to"
            class="flex items-center py-2.5 px-3 mx-2 rounded-full text-[15px] transition-all"
            :class="[
              isActive(item.to)
                ? 'bg-gray-100 dark:bg-gray-800 text-gray-900 dark:text-white font-medium'
                : 'text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-800/60'
            ]"
            :title="sidebarCollapsed ? item.label : ''"
          >
            <div 
              class="flex items-center justify-center h-[22px] w-[22px] mr-4"
              :class="[
                isActive(item.to)
                  ? 'text-gray-900 dark:text-white'
                  : 'text-gray-600 dark:text-gray-400'
              ]"
            >
              <component :is="item.icon" class="h-[22px] w-[22px]" />
            </div>
            <span v-if="!sidebarCollapsed" class="truncate">{{ item.label }}</span>
          </NuxtLink>
        </div>
      </div>
      
      <!-- Bottom actions -->
      <div class="py-4 px-2">
        <!-- Toggle sidebar button -->
        <button 
          @click="toggleSidebar"
          class="flex items-center justify-center h-10 w-10 rounded-full hover:bg-gray-100 dark:hover:bg-gray-800 text-gray-600 dark:text-gray-400"
        >
          <PanelLeftClose v-if="!sidebarCollapsed" class="h-5 w-5" />
          <PanelLeftOpen v-else class="h-5 w-5" />
        </button>
      </div>
      
      <!-- User profile -->
      <div class="border-t border-gray-100 dark:border-gray-800/60 p-3">
        <div 
          class="flex items-center gap-3 p-2 rounded-full hover:bg-gray-100 dark:hover:bg-gray-800/60 transition-colors cursor-pointer"
          @click="showUserMenu = !showUserMenu"
        >
          <div class="relative h-10 w-10 rounded-full bg-gray-200 dark:bg-gray-800 overflow-hidden flex-shrink-0">
            <img 
              v-if="user?.avatar_url" 
              :src="user.avatar_url" 
              alt="Avatar"
              class="h-full w-full object-cover"
            />
            <User v-else class="h-5 w-5 text-gray-400 m-2.5" />
          </div>
          
          <div v-if="!sidebarCollapsed" class="flex-1 min-w-0">
            <div class="font-medium text-gray-900 dark:text-white truncate">
              {{ user?.full_name || user?.email?.split('@')[0] || 'Admin' }}
            </div>
            <div class="text-xs text-gray-500 dark:text-gray-400 truncate">
              {{ user?.email || 'admin@example.com' }}
            </div>
          </div>
          
          <ChevronDown v-if="!sidebarCollapsed" class="h-4 w-4 text-gray-400" />
        </div>
        
        <!-- User menu dropdown -->
        <div 
          v-if="showUserMenu && !sidebarCollapsed" 
          class="absolute bottom-20 left-4 w-[240px] bg-white dark:bg-gray-900 rounded-2xl shadow-lg border border-gray-100 dark:border-gray-800 overflow-hidden z-50"
        >
          <div class="px-4 py-3 border-b border-gray-100 dark:border-gray-800">
            <div class="font-medium text-gray-900 dark:text-white">
              {{ user?.full_name || user?.email?.split('@')[0] || 'Admin' }}
            </div>
            <div class="text-xs text-gray-500 dark:text-gray-400">
              {{ user?.email || 'admin@example.com' }}
            </div>
          </div>
          <div class="py-2">
            <button 
              @click="toggleDarkMode"
              class="flex items-center w-full px-4 py-2.5 text-sm text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-800/60"
            >
              <Sun v-if="isDarkMode" class="h-4 w-4 mr-3" />
              <Moon v-else class="h-4 w-4 mr-3" />
              {{ isDarkMode ? 'Mode clair' : 'Mode sombre' }}
            </button>
            <button 
              @click="logout"
              class="flex items-center w-full px-4 py-2.5 text-sm text-red-600 dark:text-red-400 hover:bg-gray-50 dark:hover:bg-gray-800/60"
            >
              <LogOut class="h-4 w-4 mr-3" />
              Déconnexion
            </button>
          </div>
        </div>
      </div>
    </aside>
    
    <!-- Overlay for mobile sidebar -->
    <div 
      v-if="isMobile && !sidebarCollapsed" 
      class="fixed inset-0 bg-black/30 backdrop-blur-sm z-20"
      @click="closeSidebar"
    ></div>

    <!-- Main content -->
    <div class="flex-1 flex flex-col overflow-hidden">
      <!-- Top header -->
      <header class="h-[72px] border-b border-gray-100 dark:border-gray-800/60 flex items-center justify-between px-6 bg-white dark:bg-gray-900">
        <!-- Mobile menu button -->
        <button 
          v-if="isMobile" 
          @click="openSidebar"
          class="h-10 w-10 flex items-center justify-center rounded-full hover:bg-gray-100 dark:hover:bg-gray-800 text-gray-600 dark:text-gray-400"
        >
          <Menu class="h-5 w-5" />
        </button>
        
        <!-- Page title -->
        <h1 class="text-xl font-semibold text-gray-900 dark:text-white">
          {{ pageTitle }}
        </h1>
        
        <!-- Header actions -->
        <div class="flex items-center gap-2">
          <!-- Dark mode toggle -->
          <button 
            @click="toggleDarkMode"
            class="h-10 w-10 flex items-center justify-center rounded-full hover:bg-gray-100 dark:hover:bg-gray-800 text-gray-600 dark:text-gray-400"
          >
            <Sun v-if="isDarkMode" class="h-5 w-5" />
            <Moon v-else class="h-5 w-5" />
          </button>
          
          <!-- Notifications -->
          <button class="h-10 w-10 flex items-center justify-center rounded-full hover:bg-gray-100 dark:hover:bg-gray-800 text-gray-600 dark:text-gray-400 relative">
            <Bell class="h-5 w-5" />
            <span class="absolute top-1.5 right-1.5 h-2 w-2 bg-primary-500 rounded-full"></span>
          </button>
        </div>
      </header>
      
      <!-- Page content -->
      <main class="flex-1 overflow-auto bg-neutral-50 dark:bg-gray-950">
        <slot />
      </main>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, watch, onMounted, onBeforeUnmount } from 'vue'
import { useRouter, useRoute } from 'vue-router'
// import { useSupabaseClient, useSupabaseUser } from '#imports'
import {
  LayoutDashboard, Users, ShoppingCart, MessageSquare, Settings,
  FileText, BarChart3, Package, Shield, LogOut, Sun, Moon,
  PanelLeftClose, PanelLeftOpen, Menu, Bell, User, 
  ChevronDown, MoreHorizontal, Home, List
} from 'lucide-vue-next'
import Logo from '~/components/Logo.vue'

// State
const router = useRouter()
const route = useRoute()
const client = useSupabaseClient()
const user = useSupabaseUser()
const isDarkMode = ref(false)
const sidebarCollapsed = ref(false)
const isMobile = ref(false)
const showUserMenu = ref(false)

// Page title based on current route
const pageTitle = computed(() => {
  const path = route.path
  if (path === '/admin' || path === '/admin/dashboard') return 'Tableau de bord'
  if (path.includes('/admin/users')) return 'Utilisateurs'
  if (path.includes('/admin/requests')) return 'Demandes'
  if (path.includes('/admin/messages')) return 'Messages'
  if (path.includes('/admin/services')) return 'Services'
  if (path.includes('/admin/categories')) return 'Catégories'
  if (path.includes('/admin/settings')) return 'Paramètres'
  return 'Administration'
})

// Simplified navigation structure
const simplifiedNav = [
  {
    title: 'Principal',
    items: [
      { label: 'Tableau de bord', to: '/admin/dashboard', icon: LayoutDashboard },
      { label: 'Utilisateurs', to: '/admin/users', icon: Users },
      { label: 'Demandes', to: '/admin/requests', icon: FileText },
      { label: 'Messages', to: '/admin/messages', icon: MessageSquare },
    ]
  },
  {
    title: 'Gestion',
    items: [
      { label: 'Services', to: '/admin/services', icon: Package },
      { label: 'Catégories', to: '/admin/categories', icon: List },
      { label: 'Vérifications', to: '/admin/verifications', icon: Shield },
      { label: 'Statistiques', to: '/admin/analytics', icon: BarChart3 },
    ]
  },
  {
    title: 'Configuration',
    items: [
      { label: 'Paramètres', to: '/admin/settings', icon: Settings },
    ]
  }
]

// Check if a link is active
const isActive = (path) => {
  if (path === '/admin' && route.path === '/admin') return true
  if (path === '/admin/dashboard' && route.path === '/admin') return true
  return route.path.startsWith(path)
}

// Toggle sidebar
const toggleSidebar = () => {
  sidebarCollapsed.value = !sidebarCollapsed.value
}

// Open sidebar (mobile)
const openSidebar = () => {
  sidebarCollapsed.value = false
}

// Close sidebar (mobile)
const closeSidebar = () => {
  if (isMobile.value) {
    sidebarCollapsed.value = true
  }
}

// Toggle dark mode
const toggleDarkMode = () => {
  isDarkMode.value = !isDarkMode.value
  localStorage.setItem('darkMode', isDarkMode.value)
  
  if (isDarkMode.value) {
    document.documentElement.classList.add('dark')
  } else {
    document.documentElement.classList.remove('dark')
  }
}

// Logout
const logout = async () => {
  try {
    await client.auth.signOut()
    router.push('/auth/login')
  } catch (error) {
    console.error('Error logging out:', error)
  }
}

// Check screen size
const checkScreenSize = () => {
  isMobile.value = window.innerWidth < 768
  if (isMobile.value && !sidebarCollapsed.value) {
    sidebarCollapsed.value = true
  }
}

// Click outside to close user menu
const closeUserMenu = (event) => {
  if (showUserMenu.value && !event.target.closest('.user-menu')) {
    showUserMenu.value = false
  }
}

// Initialize theme and responsive behavior
onMounted(() => {
  // Initialize dark mode from preferences
  const savedMode = localStorage.getItem('darkMode')
  const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches
  
  if (savedMode === 'true' || (savedMode !== 'false' && prefersDark)) {
    isDarkMode.value = true
    document.documentElement.classList.add('dark')
  }
  
  // Initialize sidebar state
  const savedSidebar = localStorage.getItem('sidebarCollapsed')
  if (savedSidebar === 'true') {
    sidebarCollapsed.value = true
  }
  
  // Check screen size
  checkScreenSize()
  window.addEventListener('resize', checkScreenSize)
  document.addEventListener('click', closeUserMenu)
})

// Clean up
onBeforeUnmount(() => {
  window.removeEventListener('resize', checkScreenSize)
  document.removeEventListener('click', closeUserMenu)
})

// Save sidebar state
watch(sidebarCollapsed, (value) => {
  localStorage.setItem('sidebarCollapsed', value)
})

// Close user menu when clicking elsewhere
watch(showUserMenu, (value) => {
  if (value) {
    nextTick(() => {
      document.addEventListener('click', closeUserMenu)
    })
  } else {
    document.removeEventListener('click', closeUserMenu)
  }
})
</script>

<style>
/* Remove default outline */
*:focus {
  outline: none;
}

/* Smooth scrolling */
html {
  scroll-behavior: smooth;
}

/* Dark mode transitions */
.dark body {
  background-color: #030712;
  color: white;
}

/* Transitions for theme switching */
* {
  transition-property: color, background-color, border-color, transform, opacity;
  transition-duration: 200ms;
}

/* Hide default scrollbars */
.scrollbar-none::-webkit-scrollbar {
  display: none;
}
.scrollbar-none {
  -ms-overflow-style: none;
  scrollbar-width: none;
}

/* Improved font rendering */
body {
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}
</style> 
