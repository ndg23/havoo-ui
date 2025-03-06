<template>
  <div 
    class="min-h-screen"
    :class="{ 'dark': darkMode }"
  >
    <div class="flex h-screen bg-white dark:bg-black text-gray-900 dark:text-gray-100">
      <!-- Sidebar - Twitter inspired -->
      <div 
        class="fixed inset-y-0 z-50 flex flex-col transition-all duration-300 border-r border-gray-200 dark:border-gray-800 bg-white dark:bg-black"
        :class="{ 'w-20 sm:w-20': sidebarCollapsed, 'w-72': !sidebarCollapsed, '-translate-x-full sm:translate-x-0': !sidebarOpen }"
      >
        <!-- Logo area -->
        <div class="flex items-center h-16 px-3 py-4">
          <button 
            @click="toggleSidebarCollapse" 
            class="p-3 rounded-full hover:bg-gray-100 dark:hover:bg-gray-900 transition-colors"
          >
            <div class="p-0 rounded-full bg-blue-500 text-white w-10 h-10 flex items-center justify-center">
              <LayoutDashboard v-if="sidebarCollapsed" size="20" />
              <span v-else class="text-xl font-bold">N</span>
            </div>
          </button>
          <span v-if="!sidebarCollapsed" class="ml-3 text-xl font-extrabold">NEXUS</span>
        </div>
        
        <!-- Navigation -->
        <nav class="flex-1 overflow-y-auto py-6">
          <div class="space-y-1 px-2">
            <NuxtLink 
              to="/admin/dashboard" 
              class="group flex items-center py-3 px-3 rounded-full transition-colors relative"
              :class="activePath === '/admin/dashboard' ? 'font-bold' : 'font-medium text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-900'"
            >
              <ActivitySquare :size="sidebarCollapsed ? 24 : 22" :strokeWidth="activePath === '/admin/dashboard' ? 2.5 : 2" class="flex-shrink-0" />
              <span v-if="!sidebarCollapsed" class="ml-4">Dashboard</span>
            </NuxtLink>
            
            <NuxtLink 
              to="/admin/users" 
              class="group flex items-center py-3 px-3 rounded-full transition-colors relative"
              :class="activePath.startsWith('/admin/users') ? 'font-bold' : 'font-medium text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-900'"
            >
              <div class="relative">
                <Users :size="sidebarCollapsed ? 24 : 22" :strokeWidth="activePath.startsWith('/admin/users') ? 2.5 : 2" class="flex-shrink-0" />
                <div 
                  v-if="notificationCount.users > 0"
                  class="absolute -top-1 -right-1 w-5 h-5 bg-blue-500 text-white text-xs font-bold rounded-full flex items-center justify-center"
                >
                  {{ notificationCount.users }}
                </div>
              </div>
              <span v-if="!sidebarCollapsed" class="ml-4">Users</span>
              <span 
                v-if="!sidebarCollapsed && notificationCount.users > 0"
                class="ml-auto bg-blue-500 text-white text-xs font-bold px-2 py-0.5 rounded-full"
              >
                {{ notificationCount.users }}
              </span>
            </NuxtLink>
            
            <NuxtLink 
              to="/admin/requests" 
              class="group flex items-center py-3 px-3 rounded-full transition-colors relative"
              :class="activePath.startsWith('/admin/requests') ? 'font-bold' : 'font-medium text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-900'"
            >
              <ClipboardList :size="sidebarCollapsed ? 24 : 22" :strokeWidth="activePath.startsWith('/admin/requests') ? 2.5 : 2" class="flex-shrink-0" />
              <span v-if="!sidebarCollapsed" class="ml-4">Requests</span>
            </NuxtLink>
            
            <NuxtLink 
              to="/admin/experts" 
              class="group flex items-center py-3 px-3 rounded-full transition-colors relative"
              :class="activePath.startsWith('/admin/experts') ? 'font-bold' : 'font-medium text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-900'"
            >
              <div class="relative">
                <Award :size="sidebarCollapsed ? 24 : 22" :strokeWidth="activePath.startsWith('/admin/experts') ? 2.5 : 2" class="flex-shrink-0" />
                <div 
                  v-if="notificationCount.experts > 0"
                  class="absolute -top-1 -right-1 w-5 h-5 bg-green-500 text-white text-xs font-bold rounded-full flex items-center justify-center"
                >
                  {{ notificationCount.experts }}
                </div>
              </div>
              <span v-if="!sidebarCollapsed" class="ml-4">Experts</span>
              <span 
                v-if="!sidebarCollapsed && notificationCount.experts > 0"
                class="ml-auto bg-green-500 text-white text-xs font-bold px-2 py-0.5 rounded-full flex items-center"
              >
                {{ notificationCount.experts }}
              </span>
            </NuxtLink>
            
            <NuxtLink 
              to="/admin/analytics" 
              class="group flex items-center py-3 px-3 rounded-full transition-colors relative"
              :class="activePath === '/admin/analytics' ? 'font-bold' : 'font-medium text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-900'"
            >
              <BarChart3 :size="sidebarCollapsed ? 24 : 22" :strokeWidth="activePath === '/admin/analytics' ? 2.5 : 2" class="flex-shrink-0" />
              <span v-if="!sidebarCollapsed" class="ml-4">Analytics</span>
            </NuxtLink>
            
            <NuxtLink 
              to="/admin/settings" 
              class="group flex items-center py-3 px-3 rounded-full transition-colors relative"
              :class="activePath === '/admin/settings' ? 'font-bold' : 'font-medium text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-900'"
            >
              <Settings :size="sidebarCollapsed ? 24 : 22" :strokeWidth="activePath === '/admin/settings' ? 2.5 : 2" class="flex-shrink-0" />
              <span v-if="!sidebarCollapsed" class="ml-4">Settings</span>
            </NuxtLink>
          </div>
          
          <div v-if="!sidebarCollapsed" class="mt-8 px-4">
            <button class="w-full bg-blue-500 hover:bg-blue-600 text-white font-bold py-3 px-4 rounded-full transition-colors">
              New Action
            </button>
          </div>
          <div v-else class="mt-8 px-3">
            <button class="w-14 h-14 bg-blue-500 hover:bg-blue-600 text-white font-bold rounded-full transition-colors flex items-center justify-center">
              <Plus size="24" />
            </button>
          </div>
        </nav>
        
        <!-- User profile -->
        <div class="p-3 mt-auto">
          <button class="flex items-center w-full p-2 rounded-full hover:bg-gray-100 dark:hover:bg-gray-900 transition-colors">
            <div class="w-10 h-10 rounded-full bg-gray-200 dark:bg-gray-800 overflow-hidden flex-shrink-0">
              <img 
                v-if="user?.avatar_url" 
                :src="user.avatar_url" 
                alt="Avatar"
                class="w-full h-full object-cover"
              />
              <UserCircle v-else size="40" class="w-full h-full text-gray-500 dark:text-gray-400" />
            </div>
            <div v-if="!sidebarCollapsed" class="ml-3 text-left overflow-hidden">
              <p class="font-bold text-sm truncate">{{ user?.first_name }} {{ user?.last_name }}</p>
              <p class="text-xs text-gray-500 dark:text-gray-400 truncate">{{ user?.email }}</p>
            </div>
            <Moon v-if="!sidebarCollapsed && darkMode" size="18" class="ml-auto text-gray-500" @click.stop="toggleDarkMode" />
            <Sun v-if="!sidebarCollapsed && !darkMode" size="18" class="ml-auto text-gray-500" @click.stop="toggleDarkMode" />
          </button>
        </div>
      </div>
      
      <!-- Main Content -->
      <div class="flex-1 flex flex-col" :class="sidebarCollapsed ? 'sm:ml-20' : 'sm:ml-72'">
        <!-- Header -->
        <header class="h-16 flex items-center justify-between px-4 border-b border-gray-200 dark:border-gray-800 bg-white dark:bg-black sticky top-0 z-30">
          <div class="flex items-center">
            <button 
              @click="toggleSidebar" 
              class="p-2 rounded-full hover:bg-gray-100 dark:hover:bg-gray-900 transition-colors mr-3 sm:hidden"
            >
              <span><Menu size="24" /></span>
            </button>
            <h1 class="text-xl font-extrabold">{{ pageTitle }}</h1>
          </div>
          
          <div class="flex items-center space-x-1">
            <!-- Search -->
            <div class="relative hidden md:block">
              <div class="flex items-center bg-gray-100 dark:bg-gray-900 rounded-full pl-3 pr-4 py-2">
                <Search size="18" class="text-gray-500 dark:text-gray-400" />
                <input 
                  type="text" 
                  placeholder="Search" 
                  class="ml-2 bg-transparent border-0 focus:ring-0 text-sm w-40 lg:w-64"
                />
              </div>
            </div>
            
            <!-- Notifications -->
            <button class="p-2 rounded-full hover:bg-gray-100 dark:hover:bg-gray-900 transition-colors relative">
              <Bell size="22" />
              <span v-if="totalNotifications > 0" class="absolute top-0 right-0 w-5 h-5 bg-blue-500 text-white text-xs font-bold rounded-full flex items-center justify-center transform translate-x-1 -translate-y-1">
                {{ totalNotifications > 99 ? '99+' : totalNotifications }}
              </span>
            </button>
            
            <!-- Messages -->
            <button class="p-2 rounded-full hover:bg-gray-100 dark:hover:bg-gray-900 transition-colors">
              <MessageCircle size="22" />
            </button>
            
            <!-- Theme toggle for mobile when sidebar is collapsed -->
            <button 
              @click="toggleDarkMode" 
              class="p-2 rounded-full hover:bg-gray-100 dark:hover:bg-gray-900 transition-colors sm:hidden"
            >
              <Sun v-if="darkMode" size="22" />
              <Moon v-else size="22" />
            </button>
          </div>
        </header>
        
        <!-- Content -->
        <main class="flex-1 overflow-auto bg-gray-50 dark:bg-black p-4 md:p-6">
          <div class="max-w-7xl mx-auto">
            <slot />
            
          
          </div>
        </main>
      </div>
    </div>
    
    <!-- Mobile overlay -->
    <div 
      v-if="sidebarOpen" 
      class="fixed inset-0 bg-black bg-opacity-50 sm:hidden z-40"
      @click="toggleSidebar"
    ></div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { 
  LayoutDashboard, X, Menu, ActivitySquare, Users, ClipboardList, 
  Award, Settings, Bell, Sun, Moon, Search, UserCircle, ListTree, 
  CheckCircle2, BarChart3, TrendingUp, TrendingDown, BarChart,
  LineChart, Plus, Users2, ClipboardEdit, UserPlus, Timer,
  MessageCircle, MoreHorizontal
} from 'lucide-vue-next'

// Sidebar state
const sidebarOpen = ref(true)
const sidebarCollapsed = ref(false)

const toggleSidebar = () => {
  sidebarOpen.value = !sidebarOpen.value
}

const toggleSidebarCollapse = () => {
  sidebarCollapsed.value = !sidebarCollapsed.value
  localStorage.setItem('sidebarCollapsed', sidebarCollapsed.value ? 'collapsed' : 'expanded')
}

// Dark mode
const darkMode = ref(false)
const toggleDarkMode = () => {
  darkMode.value = !darkMode.value
  localStorage.setItem('adminDarkMode', darkMode.value ? 'dark' : 'light')
  if (darkMode.value) {
    document.documentElement.classList.add('dark')
  } else {
    document.documentElement.classList.remove('dark')
  }
}


 

// Route active
const route = useRoute()
const activePath = computed(() => route.path)

// Titre de la page
const pageTitles = {
  '/admin/dashboard': 'Tableau de bord',
  '/admin/users': 'Utilisateurs',
  '/admin/requests': 'Demandes',
  '/admin/experts': 'Experts',
  '/admin/settings': 'Paramètres',
  '/admin/services': 'Services'
}

const pageTitle = computed(() => {
  const path = route.path
  // Vérifie les correspondances exactes
  if (pageTitles[path]) return pageTitles[path]
  
  // Vérifie les correspondances partielles
  for (const [routePath, title] of Object.entries(pageTitles)) {
    if (path.startsWith(routePath)) return title
  }
  
  return 'Administration'
})

// Notifications fictives pour la démo
const notificationCount = ref({
  users: 5,
  experts: 3,
  requests: 0
})

const totalNotifications = computed(() => 
  notificationCount.value.users + 
  notificationCount.value.experts + 
  notificationCount.value.requests
)

// Utilisateur connecté (à remplacer par les données réelles)
const user = ref({
  first_name: 'Sarah',
  last_name: 'Admin',
  email: 'admin@example.com',
  avatar_url: 'https://randomuser.me/api/portraits/women/44.jpg'
})

// Déconnexion
const logout = () => {
  // Logique de déconnexion à implémenter
  console.log('Déconnexion')
}

// Initialisation
onMounted(() => {
  // Récupérer le thème des préférences
  const savedTheme = localStorage.getItem('adminDarkMode')
  darkMode.value = savedTheme === 'dark'
  
  // Appliquer le mode sombre si nécessaire
  if (darkMode.value) {
    document.documentElement.classList.add('dark')
  }
})

// Définir le layout pour toutes les pages admin
definePageMeta({
  layout: 'admin'
})
</script>

<style>
/* Animations */
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

/* Pour le dark mode */
.dark {
  color-scheme: dark;
}

/* Scrollbar personnalisée */
::-webkit-scrollbar {
  width: 8px;
  height: 8px;
}

::-webkit-scrollbar-track {
  background: transparent;
}

::-webkit-scrollbar-thumb {
  background: #d1d5db;
  border-radius: 4px;
}

.dark ::-webkit-scrollbar-thumb {
  background: #4b5563;
}

::-webkit-scrollbar-thumb:hover {
  background: #9ca3af;
}

.dark ::-webkit-scrollbar-thumb:hover {
  background: #6b7280;
}


/* These styles can be added to your global CSS or as a style block in your App.vue */

/* GAFAM-inspired design enhancements */

/* Better shadows for depth */
.shadow-gafam {
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.08), 
              0 1px 1px rgba(0, 0, 0, 0.04),
              0 20px 25px -5px rgba(0, 0, 0, 0.05), 
              0 10px 10px -5px rgba(0, 0, 0, 0.01);
}

/* Improved modal animations */
.modal-enter-active,
.modal-leave-active {
  transition: all 0.25s ease-out;
}

.modal-enter-from {
  opacity: 0;
  transform: scale(0.95);
}

.modal-leave-to {
  opacity: 0;
  transform: scale(0.95);
}

/* Google-style buttons with subtle depth */
.btn-gafam {
  transition: all 0.2s;
  box-shadow: 0 1px 2px rgba(0,0,0,0.1);
  font-weight: 500;
}

.btn-gafam:hover {
  box-shadow: 0 1px 4px rgba(0,0,0,0.1), 0 2px 8px rgba(0,0,0,0.1);
  transform: translateY(-1px);
}

.btn-gafam:active {
  box-shadow: 0 1px 1px rgba(0,0,0,0.1);
  transform: translateY(0);
}

/* Apple-style toggle animations */
.toggle-dot {
  transition: transform 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
}

/* Better card hover effects */
.card-gafam {
  transition: all 0.3s cubic-bezier(0.25, 1, 0.5, 1);
}

.card-gafam:hover {
  transform: translateY(-2px);
  box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
}

/* Microsoft-style circular progress indicators */
.progress-circle {
  stroke-dasharray: 100;
  stroke-dashoffset: 100;
  animation: progress 1.5s ease-in-out forwards;
  transform-origin: center;
  transform: rotate(-90deg);
}

@keyframes progress {
  to {
    stroke-dashoffset: var(--progress-value);
  }
}

/* Dark mode enhancements for better contrast */
.dark .dark\:bg-gray-850 {
  background-color: #1a1c23;
}

.dark .dark\:bg-gray-750 {
  background-color: #2a2c35;
}

/* Facebook-style subtle blue focus outlines */
.focus-blue:focus {
  box-shadow: 0 0 0 2px rgba(59, 130, 246, 0.3);
  outline: none;
}

/* Amazon-style alert colors */
.alert-warning {
  background-color: #fff8e6;
  border-color: #ffe8a8;
  color: #c26b00;
}

.dark .alert-warning {
  background-color: #3d3016;
  border-color: #8f6010;
  color: #ffce75;
}

/* Improved form controls */
.form-control-gafam {
  transition: all 0.2s;
  border-radius: 8px;
  border-width: 1px;
  padding: 12px 16px;
  font-size: 14px;
}

.form-control-gafam:focus {
  border-color: transparent;
  box-shadow: 0 0 0 2px #3b82f6, 0 1px 3px rgba(0, 0, 0, 0.1);
}

/* Micro-interactions */
.button-gafam {
  position: relative;
  overflow: hidden;
}

.button-gafam::after {
  content: '';
  position: absolute;
  top: 50%;
  left: 50%;
  width: 5px;
  height: 5px;
  background: rgba(255, 255, 255, 0.4);
  opacity: 0;
  border-radius: 100%;
  transform: scale(1, 1) translate(-50%, -50%);
  transform-origin: 50% 50%;
}

.button-gafam:active::after {
  opacity: 0.2;
  transform: scale(50, 50) translate(-50%, -50%);
  transition: transform 0.5s, opacity 1s;
}
</style> 