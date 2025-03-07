<template>
  <div class="h-screen flex bg-neutral-50 dark:bg-gray-950 text-gray-900 dark:text-white overflow-hidden font-sans">
    <!-- Sidebar GAFAM-style - plus bold et impactant -->
    <aside 
      class="transition-all duration-300 ease-in-out flex flex-col z-30"
      :class="{ 
        'w-[280px]': !sidebarCollapsed, 
        'w-[80px]': sidebarCollapsed,
        'shadow-lg': !isMobile
      }"
    >
      <!-- Logo area - plus distinctive -->
      <div class="h-[76px] flex items-center justify-center bg-white dark:bg-gray-900 border-b border-neutral-100 dark:border-gray-800">
        <NuxtLink to="/admin" class="flex items-center space-x-3">
          <div class="flex-shrink-0 flex items-center justify-center h-11 w-11 rounded-xl bg-gradient-to-br from-primary-600 to-primary-500 shadow-md shadow-primary-600/20">
            <Component :is="LogoIcon" class="h-6 w-6 text-white" />
            </div>
          <span v-if="!sidebarCollapsed" class="text-xl font-bold text-primary-600 tracking-tight">
            Admin<span class="text-gray-800 dark:text-white">Pro</span>
          </span>
        </NuxtLink>
        </div>
        
      <!-- Navigation links - design plus impactant -->
      <div class="flex-1 bg-white dark:bg-gray-900 overflow-y-auto scrollbar-none">
        <div class="py-7 px-5">
          <div v-for="section in simplifiedNav" :key="section.title" class="mb-8">
            <div 
              v-if="!sidebarCollapsed && section.title" 
              class="px-4 text-[13px] uppercase font-semibold text-neutral-400 dark:text-neutral-500 tracking-widest py-2 mb-3"
            >
              {{ section.title }}
              </div>
            
            <div v-if="sidebarCollapsed && section.title" class="h-8"></div>
            
            <NuxtLink 
              v-for="item in section.items"
              :key="item.to"
              :to="item.to"
              class="flex items-center py-[14px] px-4 my-[6px] rounded-xl text-[15px] font-medium transition-all duration-200"
              :class="[
                isActive(item.to)
                  ? 'bg-primary-50 dark:bg-primary-950 text-primary-600 dark:text-primary-400 shadow-sm'
                  : 'text-gray-700 dark:text-gray-300 hover:bg-neutral-50 dark:hover:bg-gray-800/60'
              ]"
              :title="sidebarCollapsed ? item.label : ''"
            >
              <div 
                class="flex items-center justify-center h-10 w-10 rounded-xl mr-3"
                :class="[
                  isActive(item.to)
                    ? 'bg-primary-100 dark:bg-primary-900/30 text-primary-600 dark:text-primary-400'
                    : 'text-neutral-500 dark:text-neutral-400'
                ]"
              >
                <component :is="item.icon" class="h-[21px] w-[21px]" />
              </div>
              <span v-if="!sidebarCollapsed" class="truncate">{{ item.label }}</span>
            </NuxtLink>
          </div>
          </div>
          </div>
      
      <!-- User profile - plus élégant -->
      <div class="bg-white dark:bg-gray-900 border-t border-neutral-100 dark:border-gray-800 p-5">
        <div 
          class="flex items-center space-x-3 rounded-xl p-3 hover:bg-neutral-50 dark:hover:bg-gray-800/60 transition-colors cursor-pointer"
          @click="logout"
        >
          <div class="relative h-10 w-10 rounded-xl bg-neutral-100 dark:bg-gray-800 overflow-hidden flex-shrink-0 shadow-inner">
              <img 
                v-if="user?.avatar_url" 
                :src="user.avatar_url" 
                alt="Avatar"
              class="h-full w-full object-cover"
              />
            <User v-else class="h-5 w-5 text-neutral-400 m-2.5" />
            </div>
          
          <div v-if="!sidebarCollapsed" class="flex-1 min-w-0">
            <div class="font-medium text-gray-900 dark:text-white">{{ user?.first_name || 'Admin' }}</div>
            <div class="text-xs text-neutral-500 dark:text-neutral-400">Déconnexion</div>
            </div>
        </div>
      </div>
    </aside>
    
    <!-- Overlay for mobile -->
    <div 
      v-if="isMobile && !sidebarCollapsed" 
      class="fixed inset-0 bg-black/50 backdrop-blur-sm z-20"
      @click="sidebarCollapsed = true"
    ></div>
    
    <!-- Main content area - design plus raffiné -->
    <div class="flex-1 flex flex-col overflow-hidden">
      <!-- Top header - plus léger et élégant -->
      <header class="h-[76px] flex items-center justify-between bg-white dark:bg-gray-900 border-b border-neutral-100 dark:border-gray-800 z-10 px-6">
          <div class="flex items-center">
          <!-- Mobile menu button - plus élégant -->
            <button 
            v-if="isMobile" 
            @click="sidebarCollapsed = false"
            class="h-10 w-10 flex items-center justify-center rounded-xl text-neutral-500 hover:bg-neutral-50 dark:hover:bg-gray-800"
            >
            <Menu class="h-5 w-5" />
            </button>
          
          <!-- Page title - typographie améliorée -->
          <h1 class="text-xl font-semibold text-gray-900 dark:text-white ml-2">
            {{ pageTitle || 'Dashboard' }}
          </h1>
            </div>
            
        <!-- Right side actions - design plus cohérent -->
        <div class="flex items-center space-x-2">
          <!-- Toggle sidebar -->
          <button 
            @click="toggleSidebar" 
            class="hidden md:flex h-10 w-10 items-center justify-center rounded-xl text-neutral-500 hover:bg-neutral-50 dark:hover:bg-gray-800"
          >
            <PanelLeftClose v-if="!sidebarCollapsed" class="h-5 w-5" />
            <PanelLeftOpen v-else class="h-5 w-5" />
            </button>
            
          <!-- Dark mode toggle - design amélioré -->
            <button 
              @click="toggleDarkMode" 
            class="h-10 w-10 flex items-center justify-center rounded-xl text-neutral-500 hover:bg-neutral-50 dark:hover:bg-gray-800"
            >
            <Sun v-if="isDarkMode" class="h-[21px] w-[21px]" />
            <Moon v-else class="h-[21px] w-[21px]" />
            </button>
          </div>
        </header>
        
      <!-- Main content - padding optimisé -->
      <main class="flex-1 overflow-y-auto bg-neutral-50 dark:bg-gray-950 p-8">
            <slot />
        </main>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onBeforeUnmount, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useSupabaseClient, useSupabaseUser } from '#imports'
import { 
  Menu, PanelLeftClose, PanelLeftOpen, Sun, Moon, User,
  LayoutDashboard, Users, Package, Tag, FileText, Settings, FileCheck,
  LayoutGrid
} from 'lucide-vue-next'

const route = useRoute()
const router = useRouter()
const client = useSupabaseClient()
const user = useSupabaseUser()

// App state
const sidebarCollapsed = ref(false)
const isDarkMode = ref(false)
const isMobile = ref(false)

// Logo icon component
const LogoIcon = LayoutGrid

// Simplified navigation items
const simplifiedNav = ref([
  {
    title: 'Core',
    items: [
      { 
        label: 'Dashboard', 
        to: '/admin',
        icon: LayoutDashboard
      },
      { 
        label: 'Utilisateurs', 
        to: '/admin/users',
        icon: Users
      }
    ]
  },
  {
    title: 'Catalogue',
    items: [
      { 
        label: 'Services', 
        to: '/admin/services',
        icon: Package
      },
      { 
        label: 'Catégories', 
        to: '/admin/categories',
        icon: Tag
      }
    ]
  },
  {
    title: 'Gestion',
    items: [
      { 
        label: 'Demandes', 
        to: '/admin/requests',
        icon: FileText
      },
      { 
        label: 'Vérifications', 
        to: '/admin/verifications',
        icon: FileCheck
      },
      { 
        label: 'Paramètres', 
        to: '/admin/settings',
        icon: Settings
      }
    ]
  }
])

// Computed page title
const pageTitle = computed(() => {
  const path = route.path
  
  // Match direct paths for more precise page titles
  if (path === '/admin') return 'Dashboard'
  if (path === '/admin/users') return 'Utilisateurs'
  if (path === '/admin/services') return 'Services'
  if (path === '/admin/categories') return 'Catégories'
  if (path === '/admin/requests') return 'Demandes'
  if (path === '/admin/verifications') return 'Vérifications'
  if (path === '/admin/settings') return 'Paramètres'
  
  // Dynamic path handling
  if (path.startsWith('/admin/users/')) {
    return 'Détail utilisateur'
  }
  
  return getLastPathSegment(path)
})

// Check if route is active
const isActive = (path) => {
  if (path === '/admin' && route.path === '/admin') {
    return true
  }
  return route.path.startsWith(path) && path !== '/admin'
}

// Get human-readable page title from URL
const getLastPathSegment = (path) => {
  const segment = path.split('/').filter(Boolean).pop()
  if (!segment) return ''
  
  // Capitalize and beautify
  const humanized = segment.replace(/-/g, ' ')
  return humanized.charAt(0).toUpperCase() + humanized.slice(1)
}

// Toggle dark mode
const toggleDarkMode = () => {
  isDarkMode.value = !isDarkMode.value
  
  if (isDarkMode.value) {
    document.documentElement.classList.add('dark')
    localStorage.setItem('darkMode', 'true')
  } else {
    document.documentElement.classList.remove('dark')
    localStorage.setItem('darkMode', 'false')
  }
}

// Toggle sidebar
const toggleSidebar = () => {
  sidebarCollapsed.value = !sidebarCollapsed.value
}

// Logout handler
const logout = async () => {
  try {
    await client.auth.signOut()
    router.push('/login')
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
})

// Clean up
onBeforeUnmount(() => {
  window.removeEventListener('resize', checkScreenSize)
})

// Save sidebar state
watch(sidebarCollapsed, (value) => {
  localStorage.setItem('sidebarCollapsed', value)
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