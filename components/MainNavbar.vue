<template>
  <header class="bg-white dark:bg-gray-900 border-b border-gray-200 dark:border-gray-700 sticky top-0 z-50">
    <div class="max-w-7xl mx-auto px-4">
      <div class="flex items-center justify-between h-16">
        <!-- Logo -->
        <NuxtLink to="/" class="flex-shrink-0">
          <Logo class="h-10 w-auto" />
          </NuxtLink>
        
        <!-- Navigation (version desktop) -->
        <nav class="hidden md:flex items-center space-x-6">
            <NuxtLink 
              to="/" 
            class="text-sm font-medium hover:text-primary-600 dark:hover:text-primary-400 transition-colors"
            :class="$route.path === '/' ? 'text-primary-600 dark:text-primary-400' : 'text-gray-700 dark:text-gray-300'"
          >
            Accueil
            </NuxtLink>
            
            <NuxtLink 
              to="/requests" 
            class="text-sm font-medium hover:text-primary-600 dark:hover:text-primary-400 transition-colors"
            :class="$route.path.startsWith('/requests') ? 'text-primary-600 dark:text-primary-400' : 'text-gray-700 dark:text-gray-300'"
          >
            Demandes
            </NuxtLink>
            
            <NuxtLink 
              v-if="user?.is_expert"
              to="/account/my-proposals" 
            class="text-sm font-medium hover:text-primary-600 dark:hover:text-primary-400 transition-colors"
            :class="$route.path.startsWith('/account/my-proposals') ? 'text-primary-600 dark:text-primary-400' : 'text-gray-700 dark:text-gray-300'"
          >
            Mes propositions
            </NuxtLink>
            
            <NuxtLink 
              v-if="user"
              to="/account/feedback" 
            class="text-sm font-medium hover:text-primary-600 dark:hover:text-primary-400 transition-colors"
            :class="$route.path.startsWith('/account/feedback') ? 'text-primary-600 dark:text-primary-400' : 'text-gray-700 dark:text-gray-300'"
          >
            Retours
            </NuxtLink>
          </nav>
        
        <!-- Actions utilisateur -->
        <div class="flex items-center gap-4">
          <!-- Barre de recherche simplifiée -->
          <div class="relative hidden md:block">
            <div class="flex items-center border border-gray-300 dark:border-gray-600 rounded-lg overflow-hidden focus-within:border-primary-500 dark:focus-within:border-primary-400">
              <input 
                type="text" 
                placeholder="Rechercher..." 
                class="block w-60 px-3 py-2 text-sm border-none focus:ring-0 bg-transparent"
              />
              <button class="p-2 text-gray-500 dark:text-gray-400 focus:outline-none hover:text-primary-600 dark:hover:text-primary-400">
                <Search class="h-4 w-4" />
          </button>
            </div>
          </div>
          
          <!-- Bouton principal style Leboncoin -->
          <NuxtLink 
            v-if="user && !user.is_expert"
            to="/requests/new" 
            class="hidden sm:flex items-center px-4 py-2 bg-primary-600 hover:bg-primary-700 text-white text-sm font-medium rounded-md transition-colors"
          >
            <Plus class="h-4 w-4 mr-1.5" />
            Déposer une demande
          </NuxtLink>
          
          <!-- Menu utilisateur simplifié -->
          <div class="relative" v-if="user">
            <button
              @click="toggleUserMenu"
              class="flex items-center space-x-2 text-gray-700 dark:text-gray-300 hover:text-primary-600 dark:hover:text-primary-400 focus:outline-none"
            >
              <div class="h-8 w-8 rounded-full bg-gray-200 dark:bg-gray-700 overflow-hidden">
                <img
                  v-if="user.avatar_url"
                  :src="user.avatar_url"
                  alt="Avatar"
                  class="h-full w-full object-cover"
                />
                <div v-else class="h-full w-full flex items-center justify-center">
                  <User class="h-4 w-4 text-gray-500" />
                </div>
              </div>
              <span class="hidden md:inline text-sm font-medium">{{ user.first_name }}</span>
              <ChevronDown class="h-4 w-4" />
            </button>
            
            <!-- Menu déroulant simplifié -->
            <div
              v-if="isUserMenuOpen"
              class="absolute right-0 mt-2 w-48 bg-white dark:bg-gray-800 rounded-md shadow-lg border border-gray-200 dark:border-gray-700 py-1 z-10"
            >
                <NuxtLink
                  to="/account"
                class="block px-4 py-2 text-sm text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700"
                  @click="isUserMenuOpen = false"
                >
                Mon profil
                </NuxtLink>
                
                <NuxtLink
                  to="/account/edit-profile"
                class="block px-4 py-2 text-sm text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700"
                  @click="isUserMenuOpen = false"
                >
                Modifier mon profil
                </NuxtLink>
              
              <div class="border-t border-gray-200 dark:border-gray-700 my-1"></div>
              
                <button
                  @click="logout"
                class="block w-full text-left px-4 py-2 text-sm text-red-600 dark:text-red-400 hover:bg-red-50 dark:hover:bg-red-900/20"
                >
                Déconnexion
                </button>
            </div>
          </div>
          
          <!-- Boutons de connexion (si non connecté) -->
          <div v-if="!user" class="flex items-center space-x-4">
            <NuxtLink
              to="/login"
              class="text-sm font-medium text-gray-700 dark:text-gray-300 hover:text-primary-600 dark:hover:text-primary-400"
            >
              Connexion
            </NuxtLink>
            
            <NuxtLink
              to="/register"
              class="px-4 py-2 bg-primary-600 hover:bg-primary-700 text-white text-sm font-medium rounded-md transition-colors"
            >
              S'inscrire
            </NuxtLink>
          </div>
          
          <!-- Bouton mobile -->
          <button 
            @click="mobileMenuOpen = !mobileMenuOpen"
            class="md:hidden p-2 text-gray-700 dark:text-gray-300 hover:text-primary-600 dark:hover:text-primary-400 focus:outline-none"
          >
            <Menu v-if="!mobileMenuOpen" class="h-6 w-6" />
            <X v-else class="h-6 w-6" />
          </button>
      </div>
    </div>
    
      <!-- Menu mobile -->
      <div v-if="mobileMenuOpen" class="md:hidden border-t border-gray-200 dark:border-gray-700 py-3">
        <!-- Navigation mobile -->
        <nav class="flex flex-col space-y-2 mb-4">
        <NuxtLink 
          to="/" 
            class="px-4 py-2 text-base font-medium hover:bg-gray-100 dark:hover:bg-gray-800 rounded-md"
            :class="$route.path === '/' ? 'text-primary-600 dark:text-primary-400' : 'text-gray-700 dark:text-gray-300'"
          @click="mobileMenuOpen = false"
        >
          Accueil
        </NuxtLink>
        
        <NuxtLink 
          to="/requests" 
            class="px-4 py-2 text-base font-medium hover:bg-gray-100 dark:hover:bg-gray-800 rounded-md"
            :class="$route.path.startsWith('/requests') ? 'text-primary-600 dark:text-primary-400' : 'text-gray-700 dark:text-gray-300'"
          @click="mobileMenuOpen = false"
        >
          Demandes
        </NuxtLink>
        
        <NuxtLink 
          v-if="user?.is_expert"
          to="/account/my-proposals" 
            class="px-4 py-2 text-base font-medium hover:bg-gray-100 dark:hover:bg-gray-800 rounded-md"
            :class="$route.path.startsWith('/account/my-proposals') ? 'text-primary-600 dark:text-primary-400' : 'text-gray-700 dark:text-gray-300'"
          @click="mobileMenuOpen = false"
        >
          Mes propositions
        </NuxtLink>
        
        <NuxtLink 
          v-if="user"
          to="/account/feedback" 
            class="px-4 py-2 text-base font-medium hover:bg-gray-100 dark:hover:bg-gray-800 rounded-md"
            :class="$route.path.startsWith('/account/feedback') ? 'text-primary-600 dark:text-primary-400' : 'text-gray-700 dark:text-gray-300'"
          @click="mobileMenuOpen = false"
        >
          Retours
        </NuxtLink>
        </nav>
        
        <!-- Barre de recherche mobile -->
        <div class="px-4 mb-3">
          <div class="flex items-center border border-gray-300 dark:border-gray-600 rounded-lg overflow-hidden">
            <input 
              type="text" 
              placeholder="Rechercher..." 
              class="block w-full px-3 py-2 text-sm border-none focus:ring-0 bg-transparent"
            />
            <button class="p-2 text-gray-500 dark:text-gray-400">
              <Search class="h-4 w-4" />
            </button>
          </div>
      </div>
        
        <!-- Bouton principal mobile -->
        <div class="px-4" v-if="user && !user.is_expert">
        <NuxtLink
            to="/requests/new" 
            class="flex items-center justify-center w-full px-4 py-2 bg-primary-600 hover:bg-primary-700 text-white text-sm font-medium rounded-md transition-colors"
          @click="mobileMenuOpen = false"
        >
            <Plus class="h-4 w-4 mr-1.5" />
            Déposer une demande
        </NuxtLink>
        </div>
      </div>
    </div>
  </header>
</template>

<script setup>
import { ref, onMounted, onUnmounted, watch } from 'vue'
import { useSupabaseClient, useSupabaseUser } from '#imports'
import { useRouter, useRoute } from 'vue-router'
import { 
  User, 
  Plus, 
  Menu, 
  X, 
  Search,
  ChevronDown
} from 'lucide-vue-next'

// Composables
const supabase = useSupabaseClient()
const currentUser = useSupabaseUser()
const router = useRouter()
const route = useRoute()

// États
const isUserMenuOpen = ref(false)
const mobileMenuOpen = ref(false)
const user = ref(null)

// Méthodes
const toggleUserMenu = () => {
  isUserMenuOpen.value = !isUserMenuOpen.value
  if (isUserMenuOpen.value) {
    mobileMenuOpen.value = false
  }
}

const logout = async () => {
  try {
    isUserMenuOpen.value = false
    const { error } = await supabase.auth.signOut()
    if (error) throw error
    router.push('/login')
  } catch (error) {
    console.error('Erreur lors de la déconnexion:', error)
  }
}

const fetchUserData = async () => {
  try {
    if (!currentUser.value) return
    
    const { data, error } = await supabase
      .from('profiles')
      .select('*')
      .eq('id', currentUser.value.id)
      .single()
    
    if (error) throw error
    user.value = {
      ...data,
      email: currentUser.value.email
    }
  } catch (error) {
    console.error('Erreur lors du chargement des données utilisateur:', error)
  }
}

// Fermeture des menus en cliquant à l'extérieur
const handleClickOutside = (e) => {
  if (isUserMenuOpen.value && !e.target.closest('.relative')) {
    isUserMenuOpen.value = false
  }
}

// Fermeture du menu mobile lors du changement de route
watch(() => route.path, () => {
  mobileMenuOpen.value = false
})

// Initialisation
onMounted(() => {
  fetchUserData()
  document.addEventListener('click', handleClickOutside)
  
  // Écouter les changements d'auth
  const { data: { subscription } } = supabase.auth.onAuthStateChange(() => {
    fetchUserData()
  })
  
  // Nettoyage
  onUnmounted(() => {
    document.removeEventListener('click', handleClickOutside)
    subscription?.unsubscribe()
  })
})
</script>