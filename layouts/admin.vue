<template>
  <div class="min-h-screen bg-gray-50 flex">
    <!-- Sidebar - Version Desktop -->
    <div class="hidden md:flex md:w-64 md:flex-col h-screen sticky top-0">
      <div class="flex flex-col flex-grow bg-white border-r border-gray-200 pt-5 pb-4 overflow-y-auto">
        <!-- Logo -->
        <div class="flex items-center justify-center flex-shrink-0 px-4 mb-6">
          <div class="h-10 w-10 bg-black rounded-lg flex items-center justify-center mr-3">
            <ShieldCheck class="h-6 w-6 text-white" />
          </div>
          <h1 class="text-xl font-bold text-gray-900">Admin Panel</h1>
        </div>
        
        <!-- Menu de navigation -->
        <nav class="flex-1 px-3 space-y-2">
          <NuxtLink 
            to="/admin" 
            class="flex items-center px-3 py-2.5 text-sm font-medium rounded-lg transition-colors"
            :class="route.path === '/admin' ? 'bg-gray-100 text-black' : 'text-gray-700 hover:bg-gray-50'"
          >
            <LayoutDashboard class="w-5 h-5 mr-3" />
            Dashboard
          </NuxtLink>
          
          <NuxtLink 
            to="/admin/users" 
            class="flex items-center px-3 py-2.5 text-sm font-medium rounded-lg transition-colors"
            :class="route.path.includes('/admin/users') ? 'bg-gray-100 text-black' : 'text-gray-700 hover:bg-gray-50'"
          >
            <Users class="w-5 h-5 mr-3" />
            Utilisateurs
          </NuxtLink>
          
          <NuxtLink 
            to="/admin/categories" 
            class="flex items-center px-3 py-2.5 text-sm font-medium rounded-lg transition-colors"
            :class="route.path.includes('/admin/categories') ? 'bg-gray-100 text-black' : 'text-gray-700 hover:bg-gray-50'"
          >
            <Tag class="w-5 h-5 mr-3" />
            Catégories
          </NuxtLink>
          
          <NuxtLink 
            to="/admin/services" 
            class="flex items-center px-3 py-2.5 text-sm font-medium rounded-lg transition-colors"
            :class="route.path.includes('/admin/services') ? 'bg-gray-100 text-black' : 'text-gray-700 hover:bg-gray-50'"
          >
            <Package class="w-5 h-5 mr-3" />
            Services
          </NuxtLink>
          
          <NuxtLink 
            to="/admin/requests" 
            class="flex items-center px-3 py-2.5 text-sm font-medium rounded-lg transition-colors"
            :class="route.path.includes('/admin/requests') ? 'bg-gray-100 text-black' : 'text-gray-700 hover:bg-gray-50'"
          >
            <FileSpreadsheet class="w-5 h-5 mr-3" />
            Demandes
          </NuxtLink>
          
          <NuxtLink 
            to="/admin/payments" 
            class="flex items-center px-3 py-2.5 text-sm font-medium rounded-lg transition-colors"
            :class="route.path.includes('/admin/payments') ? 'bg-gray-100 text-black' : 'text-gray-700 hover:bg-gray-50'"
          >
            <CreditCard class="w-5 h-5 mr-3" />
            Paiements
          </NuxtLink>
          
            <NuxtLink 
            to="/admin/settings" 
            class="flex items-center px-3 py-2.5 text-sm font-medium rounded-lg transition-colors"
            :class="route.path.includes('/admin/settings') ? 'bg-gray-100 text-black' : 'text-gray-700 hover:bg-gray-50'"
          >
            <Settings class="w-5 h-5 mr-3" />
            Paramètres
            </NuxtLink>
        </nav>
        
        <!-- Profil et déconnexion -->
        <div class="mt-6 px-3">
          <div class="flex items-center px-3 py-3 text-sm font-medium text-gray-700">
            <div class="flex-shrink-0 h-8 w-8 rounded-full bg-gray-100 flex items-center justify-center">
                <User class="h-4 w-4 text-gray-500" />
            </div>
            <div class="ml-3">
              <p class="text-sm font-medium text-gray-900">{{ fullName }}</p>
              <p class="text-xs text-gray-500">Administrateur</p>
            </div>
          </div>
          
          <button 
            @click="logout"
            class="mt-2 w-full flex items-center justify-center px-3 py-2 text-sm font-medium text-gray-700 hover:text-gray-900 hover:bg-gray-100 rounded-lg transition-colors"
          >
            <LogOut class="w-4 h-4 mr-2" />
            Déconnexion
          </button>
        </div>
      </div>
    </div>
    
    <!-- Mobile header -->
    <div class="md:hidden fixed top-0 inset-x-0 z-10 bg-white border-b border-gray-200">
      <div class="flex items-center justify-between h-16 px-4">
        <button @click="isMobileMenuOpen = !isMobileMenuOpen" class="p-2 rounded-md text-gray-500 hover:text-gray-900 hover:bg-gray-100">
          <Menu v-if="!isMobileMenuOpen" class="h-6 w-6" />
          <X v-else class="h-6 w-6" />
        </button>
        
        <div class="flex items-center">
          <div class="h-8 w-8 bg-black rounded-lg flex items-center justify-center">
            <ShieldCheck class="h-4 w-4 text-white" />
          </div>
          <h1 class="ml-2 text-lg font-bold text-gray-900">Admin</h1>
        </div>
        
        <div class="h-8 w-8 rounded-full bg-gray-100 flex items-center justify-center">
          <User class="h-4 w-4 text-gray-500" />
        </div>
      </div>
      
      <!-- Mobile menu -->
      <div v-if="isMobileMenuOpen" class="bg-white border-b border-gray-200 px-2 py-3">
        <nav class="grid gap-y-2">
          <NuxtLink 
            to="/admin" 
            class="flex items-center px-3 py-2 text-sm font-medium rounded-md"
            :class="route.path === '/admin' ? 'bg-gray-100 text-black' : 'text-gray-700'"
            @click="isMobileMenuOpen = false"
          >
            <LayoutDashboard class="w-5 h-5 mr-3" />
            Dashboard
          </NuxtLink>
          
          <NuxtLink 
            to="/admin/users" 
            class="flex items-center px-3 py-2 text-sm font-medium rounded-md"
            :class="route.path.includes('/admin/users') ? 'bg-gray-100 text-black' : 'text-gray-700'"
            @click="isMobileMenuOpen = false"
          >
            <Users class="w-5 h-5 mr-3" />
            Utilisateurs
          </NuxtLink>
          
          <NuxtLink 
            to="/admin/categories" 
            class="flex items-center px-3 py-2 text-sm font-medium rounded-md"
            :class="route.path.includes('/admin/categories') ? 'bg-gray-100 text-black' : 'text-gray-700'"
            @click="isMobileMenuOpen = false"
          >
            <Tag class="w-5 h-5 mr-3" />
            Catégories
          </NuxtLink>
          
          <NuxtLink 
            to="/admin/services" 
            class="flex items-center px-3 py-2 text-sm font-medium rounded-md"
            :class="route.path.includes('/admin/services') ? 'bg-gray-100 text-black' : 'text-gray-700'"
            @click="isMobileMenuOpen = false"
          >
            <Package class="w-5 h-5 mr-3" />
            Services
          </NuxtLink>
          
          <NuxtLink 
            to="/admin/requests" 
            class="flex items-center px-3 py-2 text-sm font-medium rounded-md"
            :class="route.path.includes('/admin/requests') ? 'bg-gray-100 text-black' : 'text-gray-700'"
            @click="isMobileMenuOpen = false"
          >
            <FileSpreadsheet class="w-5 h-5 mr-3" />
            Demandes
          </NuxtLink>
          
          <NuxtLink 
            to="/admin/payments" 
            class="flex items-center px-3 py-2 text-sm font-medium rounded-md"
            :class="route.path.includes('/admin/payments') ? 'bg-gray-100 text-black' : 'text-gray-700'"
            @click="isMobileMenuOpen = false"
          >
            <CreditCard class="w-5 h-5 mr-3" />
            Paiements
          </NuxtLink>
          
          <NuxtLink 
            to="/admin/settings" 
            class="flex items-center px-3 py-2 text-sm font-medium rounded-md"
            :class="route.path.includes('/admin/settings') ? 'bg-gray-100 text-black' : 'text-gray-700'"
            @click="isMobileMenuOpen = false"
          >
            <Settings class="w-5 h-5 mr-3" />
            Paramètres
          </NuxtLink>
          
          <button 
            @click="logout" 
            class="flex items-center px-3 py-2 text-sm font-medium text-gray-700 hover:text-gray-900 hover:bg-gray-100 rounded-md w-full mt-2"
          >
            <LogOut class="w-5 h-5 mr-3" />
            Déconnexion
          </button>
        </nav>
      </div>
    </div>
    
    <!-- Contenu principal -->
    <div class="flex-1 w-full">
      <div class="md:p-8 p-4 md:pt-6 pt-20 pb-24 md:pb-8 max-w-7xl mx-auto">
        <slot />
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { 
  Users, 
  Settings, 
  LogOut, 
  User, 
  ShieldCheck, 
  Menu, 
  X, 
  Tag, 
  Package, 
  FileSpreadsheet, 
  CreditCard,
  LayoutDashboard
} from 'lucide-vue-next'

const route = useRoute()
const router = useRouter()
const client = useSupabaseClient()
const user = useSupabaseUser()

const isMobileMenuOpen = ref(false)

// Déconnexion
const logout = async () => {
  try {
    await client.auth.signOut()
    router.push('/auth/login')
  } catch (error) {
    console.error('Erreur lors de la déconnexion', error)
  }
}

// Récupérer le nom complet de l'utilisateur
const fullName = computed(() => {
  return user.value?.user_metadata?.full_name || 'Administrateur'
})
</script> 