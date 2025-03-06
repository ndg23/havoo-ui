<template>
  <div class="min-h-screen flex flex-col md:flex-row">
    <!-- Sidebar de navigation (fixe sur desktop, menu du bas sur mobile) -->
    <div class="w-full md:w-64 flex-shrink-0 bg-gray-50 border-r border-gray-200 md:min-h-screen">
      <!-- Logo et titre -->
      <div class="px-5 py-4 border-b border-gray-200 flex items-center justify-between md:justify-start">
        <NuxtLink to="/admin" class="flex items-center">
          <div class="h-8 w-8 bg-primary-600 rounded-md flex items-center justify-center mr-3">
            <ShieldCheck class="h-5 w-5 text-white" />
          </div>
          <span class="font-bold text-lg">Havoo Admin</span>
        </NuxtLink>
        
        <!-- Bouton menu mobile -->
        <button 
          @click="mobileMenuOpen = !mobileMenuOpen"
          class="p-2 text-gray-500 md:hidden"
        >
          <Menu v-if="!mobileMenuOpen" class="h-6 w-6" />
          <X v-else class="h-6 w-6" />
        </button>
      </div>
      
      <!-- Navigation -->
      <div 
        class="md:block"
        :class="{ 'hidden': !mobileMenuOpen, 'block': mobileMenuOpen }"
      >
        <div class="px-2 py-4">
          <div class="space-y-1">
            <NuxtLink 
              v-for="item in menuItems" 
              :key="item.path"
              :to="item.path"
              class="flex items-center px-3 py-3 rounded-lg transition-colors text-sm font-medium"
              :class="$route.path.startsWith(item.path) ? 'bg-primary-50 text-primary-700' : 'text-gray-700 hover:bg-gray-100'"
            >
              <component :is="item.icon" class="h-5 w-5 mr-3" />
              {{ item.name }}
            </NuxtLink>
          </div>
        </div>
        
        <div class="px-4 py-4 mt-4 border-t border-gray-200">
          <div class="flex items-center mb-4">
            <div class="h-8 w-8 rounded-full bg-gray-200 flex-shrink-0 mr-3">
              <img 
                v-if="user?.user_metadata?.avatar_url"
                :src="user.user_metadata.avatar_url"
                class="h-full w-full object-cover rounded-full"
                alt="Avatar"
              />
              <div v-else class="h-full w-full flex items-center justify-center">
                <User class="h-4 w-4 text-gray-500" />
              </div>
            </div>
            <div>
              <div class="font-medium text-sm">
                {{ user?.user_metadata?.full_name || user?.email || 'Admin' }}
              </div>
              <div class="text-xs text-gray-500">Administrateur</div>
            </div>
          </div>
          
          <button 
            @click="logout"
            class="flex items-center w-full py-2 px-3 text-sm text-gray-700 hover:bg-gray-100 rounded-lg transition-colors"
          >
            <LogOut class="h-5 w-5 mr-3 text-gray-500" />
            Déconnexion
          </button>
        </div>
      </div>
    </div>
    
    <!-- Contenu principal -->
    <div class="flex-1 flex flex-col overflow-hidden">
      <!-- En-tête du contenu -->
      <div class="border-b border-gray-200 bg-white">
        <div class="px-5 py-4">
          <h1 class="text-xl font-bold text-gray-900">
            {{ pageTitle }}
          </h1>
        </div>
      </div>
      
      <!-- Contenu de la page -->
      <div class="flex-1 overflow-auto p-5">
        <slot />
      </div>
    </div>
  </div>
</template>

<script setup>
import { 
  ShieldCheck, Menu, X, Home, Users, FileText, 
  Tag, Settings, LogOut, User, BarChart
} from 'lucide-vue-next'
import { ref, computed } from 'vue'

const mobileMenuOpen = ref(false)
const router = useRouter()
const route = useRoute()
const user = useSupabaseUser()
const client = useSupabaseClient()

// Éléments du menu
const menuItems = [
  { name: 'Tableau de bord', path: '/admin', icon: BarChart },
  { name: 'Utilisateurs', path: '/admin/users', icon: Users },
  { name: 'Demandes', path: '/admin/requests', icon: FileText },
  { name: 'Catégories & Services', path: '/admin/categories', icon: Tag },
  { name: 'Paramètres', path: '/admin/settings', icon: Settings },
]

// Titre de la page en fonction de la route
const pageTitle = computed(() => {
  const currentRoute = route.path
  
  if (currentRoute === '/admin') return 'Tableau de bord'
  if (currentRoute.startsWith('/admin/users')) return 'Gestion des utilisateurs'
  if (currentRoute.startsWith('/admin/requests')) return 'Gestion des demandes'
  if (currentRoute.startsWith('/admin/categories')) return 'Catégories & Services'
  if (currentRoute.startsWith('/admin/settings')) return 'Paramètres'
  
  return 'Administration'
})

// Déconnexion
const logout = async () => {
  try {
    await client.auth.signOut()
    router.push('/auth/login')
  } catch (error) {
    console.error('Erreur lors de la déconnexion', error)
  }
}
</script> 