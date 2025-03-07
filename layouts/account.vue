<template>
  <div class="min-h-screen bg-gray-50 dark:bg-gray-950">
    <!-- Header minimaliste style Apple/Google 2023 -->
    <header 
      class="fixed top-0 left-0 w-full z-50 transition-all duration-300"
      :class="{ 'bg-white/95 dark:bg-gray-900/98 shadow-sm backdrop-blur-md': isScrolled, 'bg-transparent': !isScrolled }"
    >
      <div class="max-w-6xl mx-auto px-4 lg:px-6 h-16 flex items-center justify-between">
        <!-- Logo avec animation subtile -->
        <NuxtLink to="/" class="flex-shrink-0">
          <Logo :small="true" class="transition-transform duration-300 hover:scale-105" />
        </NuxtLink>
        
        <!-- Actions - Design ultra minimaliste -->
        <div class="flex items-center gap-2 sm:gap-4">
          <!-- Bouton demande/proposition selon le rôle -->
          <NuxtLink 
            :to="isExpert ? '/requests' : '/requests/new'"
            class="hidden sm:flex items-center gap-2 py-1.5 px-3 bg-primary-600 hover:bg-primary-700 text-white rounded-full text-sm font-medium transition-colors"
          >
            <component :is="isExpert ? 'Search' : 'Plus'" class="h-3.5 w-3.5" />
            <span>{{ isExpert ? 'Voir les demandes' : 'Nouvelle demande' }}</span>
          </NuxtLink>
          
          <!-- Toggle mode sombre subtil -->
          <button 
            @click="toggleDarkMode"
            class="p-2 rounded-full text-gray-600 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-800/60 transition-colors"
            aria-label="Changer de thème"
          >
            <Sun v-if="isDarkMode" class="h-5 w-5" />
            <Moon v-else class="h-5 w-5" />
          </button>
          
          <!-- Avatar avec notification intégrée -->
          <div class="relative" ref="profileDropdown">
            <button 
              @click="toggleProfileDropdown"
              class="relative flex items-center h-9 w-9 rounded-full border border-gray-200 dark:border-gray-700 overflow-hidden transition-all hover:ring-2 hover:ring-primary-100 dark:hover:ring-primary-900/40"
              aria-label="Menu du profil"
            >
              <img 
                v-if="userData?.avatar_url" 
                :src="userData.avatar_url" 
                alt="Photo de profil"
                class="h-full w-full object-cover"
              />
              <div v-else class="h-full w-full flex items-center justify-center bg-gray-100 dark:bg-gray-800">
                <User class="h-4.5 w-4.5 text-gray-500 dark:text-gray-400" />
              </div>
              
              <!-- Indicateur de notification -->
              <div
                v-if="hasNotifications"
                class="absolute top-0 right-0 h-2.5 w-2.5 bg-primary-500 rounded-full border border-white dark:border-gray-900 transform translate-x-0.5 -translate-y-0.5"
              ></div>
            </button>
            
            <!-- Dropdown moderne et aéré style iOS/Android -->
            <div 
              v-if="isProfileOpen" 
              class="absolute right-0 mt-2 w-64 rounded-xl bg-white dark:bg-gray-800 shadow-lg border border-gray-100 dark:border-gray-700 overflow-hidden transform origin-top-right transition-all z-50"
            >
              <div class="p-4 border-b border-gray-100 dark:border-gray-700">
                <div class="flex items-center gap-3">
                  <div class="h-10 w-10 rounded-full bg-gray-100 dark:bg-gray-700 overflow-hidden">
                    <img 
                      v-if="userData?.avatar_url" 
                      :src="userData.avatar_url" 
                      alt="Photo de profil"
                      class="h-full w-full object-cover"
                    />
                    <div v-else class="h-full w-full flex items-center justify-center">
                      <User class="h-5 w-5 text-gray-500 dark:text-gray-400" />
                    </div>
                  </div>
                  <div>
                    <div class="font-medium text-gray-900 dark:text-white">{{ userData?.first_name }} {{ userData?.last_name }}</div>
                    <div class="text-xs text-gray-500 dark:text-gray-400 mt-0.5">{{ userData?.email }}</div>
                  </div>
                </div>
                
                <!-- Rôle utilisateur -->
                <div v-if="userData?.is_expert" class="mt-3 flex items-center">
                  <span class="text-xs font-medium text-primary-600 dark:text-primary-400 bg-primary-50 dark:bg-primary-900/20 px-2 py-0.5 rounded">Expert</span>
                  <StarIcon v-if="userData?.rating" class="h-3 w-3 text-yellow-400 ml-2" />
                  <span v-if="userData?.rating" class="text-xs text-gray-500 dark:text-gray-400 ml-1">{{ userData.rating }}</span>
                </div>
              </div>
              
              <!-- Options principales -->
              <div class="p-1">
                <NuxtLink 
                  to="/account"
                  class="flex items-center mx-1 px-3 py-2 rounded-lg text-sm text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors"
                  @click="isProfileOpen = false"
                >
                  <User class="h-4 w-4 mr-3 text-gray-500 dark:text-gray-400" />
                  Mon profil
                </NuxtLink>
                
                <NuxtLink 
                  v-if="userData?.is_expert"
                  to="/account/skills"
                  class="flex items-center mx-1 px-3 py-2 rounded-lg text-sm text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors"
                  @click="isProfileOpen = false"
                >
                  <Briefcase class="h-4 w-4 mr-3 text-gray-500 dark:text-gray-400" />
                  Mes compétences
                </NuxtLink>
                
                <NuxtLink 
                  to="/account/verification"
                  class="flex items-center mx-1 px-3 py-2 rounded-lg text-sm text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors"
                  @click="isProfileOpen = false"
                >
                  <Shield class="h-4 w-4 mr-3 text-gray-500 dark:text-gray-400" />
                  Vérification
                </NuxtLink>
                
                <NuxtLink 
                  to="/account/settings"
                  class="flex items-center mx-1 px-3 py-2 rounded-lg text-sm text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors"
                  @click="isProfileOpen = false"
                >
                  <Settings class="h-4 w-4 mr-3 text-gray-500 dark:text-gray-400" />
                  Paramètres
                </NuxtLink>
              </div>
              
              <!-- Déconnexion -->
              <div class="p-1 border-t border-gray-100 dark:border-gray-700">
                <button 
                  @click="logout"
                  class="flex w-full items-center mx-1 px-3 py-2 rounded-lg text-sm text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors"
                >
                  <LogOut class="h-4 w-4 mr-3 text-gray-500 dark:text-gray-400" />
                  Déconnexion
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </header>

    <!-- Zone principale avec espacement optimal -->
    <div class="pt-16">
      <!-- Affichage profil ultra-minimal style Google/Apple -->
      <section class="bg-white dark:bg-gray-900 border-b border-gray-100 dark:border-gray-800">
        <div class="max-w-6xl mx-auto px-4 lg:px-6 py-6">
          <!-- Onglets navigation intégrés - Style mobile-first -->
          <div class="overflow-x-auto hide-scrollbar mb-6">
            <nav class="flex space-x-2 md:space-x-4 min-w-max">
              <NuxtLink
                v-for="tab in filteredTabs"
                :key="tab.id"
                :to="tab.to"
                class="inline-flex items-center px-3 py-1.5 rounded-full text-sm font-medium transition-colors"
                :class="[
                  isActiveTab(tab.to)
                    ? 'bg-primary-50 text-primary-700 dark:bg-primary-900/20 dark:text-primary-400'
                    : 'text-gray-600 dark:text-gray-400 hover:bg-gray-100 dark:hover:bg-gray-800 hover:text-gray-900 dark:hover:text-white'
                ]"
              >
                <component :is="tab.icon" class="h-4 w-4 mr-1.5" />
                {{ tab.label }}
              </NuxtLink>
            </nav>
          </div>
        </div>
      </section>
      
      <!-- Section de contenu aérée -->
      <main class="max-w-6xl mx-auto px-4 lg:px-6 py-6">
        <slot />
      </main>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onBeforeUnmount, watch } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useSupabaseClient, useSupabaseUser } from '#imports'
import {
  User, Sun, Moon, Bell, Settings, LogOut, Shield, Star as StarIcon, Plus, 
  Search, Briefcase, ChevronDown
} from 'lucide-vue-next'

// Composables
const supabase = useSupabaseClient()
const currentUser = useSupabaseUser()
const router = useRouter()
const route = useRoute()

// État
const isDarkMode = ref(false)
const isScrolled = ref(false)
const isProfileOpen = ref(false)
const profileDropdown = ref(null)
const userData = ref(null)
const hasNotifications = ref(false)

// Statistiques
const stats = ref({
  requests: 0,
  proposals: 0,
  contracts: 0,
  newRequestsPercent: 5,
  newProposalsPercent: 8,
  newContractsPercent: 3
})

// Tabs de navigation
const tabs = [
  { id: 'dashboard', label: 'Tableau de bord', to: '/account', icon: 'LayoutDashboard', roles: ['all'] },
  { id: 'requests', label: 'Mes demandes', to: '/account/requests', icon: 'FileText', roles: ['all'] },
  { id: 'proposals', label: 'Mes propositions', to: '/account/my-proposals', icon: 'FileCheck', roles: ['expert'] },
  { id: 'skills', label: 'Compétences', to: '/account/skills', icon: 'Star', roles: ['expert'] },
  { id: 'messages', label: 'Messages', to: '/account/messages', icon: 'MessageSquare', roles: ['all'] },
  { id: 'verification', label: 'Vérification', to: '/account/verification', icon: 'Shield', roles: ['all'] },
]

// Computed
const isExpert = computed(() => {
  return userData.value?.is_expert || false
})

const filteredTabs = computed(() => {
  return tabs.filter(tab => 
    tab.roles.includes('all') || 
    (isExpert.value && tab.roles.includes('expert'))
  )
})

// Méthodes
const isActiveTab = (path) => {
  return route.path === path
}

const handleScroll = () => {
  isScrolled.value = window.scrollY > 10
}

const toggleProfileDropdown = () => {
  isProfileOpen.value = !isProfileOpen.value
}

const handleClickOutside = (event) => {
  if (profileDropdown.value && !profileDropdown.value.contains(event.target)) {
    isProfileOpen.value = false
  }
}

// Récupérer les données utilisateur
const fetchUserData = async () => {
  if (!currentUser.value) return
  
  try {
    const { data: profile, error } = await supabase
      .from('profiles')
      .select('*')
      .eq('id', currentUser.value.id)
      .single()
    
    if (error) throw error
    
    userData.value = profile
    
    // Si c'est un expert, récupérer les données supplémentaires
    if (profile.is_expert) {
      const { data: expertData, error: expertError } = await supabase
        .from('experts')
        .select('*')
        .eq('id', currentUser.value.id)
        .single()
      
      if (!expertError && expertData) {
        userData.value = { ...profile, ...expertData }
      }
    }
    
    await fetchUserStats()
    await checkNotifications()
  } catch (error) {
    console.error('Erreur lors de la récupération des données utilisateur:', error)
  }
}

// Récupérer les statistiques de l'utilisateur
const fetchUserStats = async () => {
  try {
    // Statistiques communes
    const { data: contracts, error: contractsError } = await supabase
      .from('contracts')
      .select('id')
      .or(`client_id.eq.${currentUser.value.id},expert_id.eq.${currentUser.value.id}`)
    
    if (!contractsError) {
      stats.value.contracts = contracts.length
    }
    
    // Récupérer les demandes
    const { data: requests, error: requestsError } = await supabase
      .from('requests')
      .select('id')
      .eq('client_id', currentUser.value.id)
    
    if (!requestsError) {
      stats.value.requests = requests.length
    }
    
    // Statistiques spécifiques à l'expert
    if (isExpert.value) {
      const { data: proposals, error: proposalsError } = await supabase
        .from('proposals')
        .select('id')
        .eq('expert_id', currentUser.value.id)
      
      if (!proposalsError) {
        stats.value.proposals = proposals.length
      }
    }
  } catch (error) {
    console.error('Erreur lors de la récupération des statistiques:', error)
  }
}

// Vérifier les notifications
const checkNotifications = async () => {
  try {
    const { data, error } = await supabase
      .from('notifications')
      .select('id')
      .eq('user_id', currentUser.value.id)
      .eq('read', false)
      .limit(1)
    
    if (error) throw error
    
    hasNotifications.value = data.length > 0
  } catch (error) {
    console.error('Erreur lors de la vérification des notifications:', error)
  }
}

// Basculer le mode sombre
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

// Déconnexion
const logout = async () => {
  try {
    const { error } = await supabase.auth.signOut()
    if (error) throw error
    router.push('/login')
  } catch (error) {
    console.error('Erreur lors de la déconnexion:', error)
  }
}

// Lifecycle hooks
onMounted(() => {
  // Charger le thème des préférences
  const savedTheme = localStorage.getItem('darkMode')
  const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches
  
  isDarkMode.value = savedTheme === 'true' || (!savedTheme && prefersDark)
  
  if (isDarkMode.value) {
    document.documentElement.classList.add('dark')
  }
  
  window.addEventListener('scroll', handleScroll)
  document.addEventListener('click', handleClickOutside)
  
  handleScroll()
  fetchUserData()
})

onBeforeUnmount(() => {
  window.removeEventListener('scroll', handleScroll)
  document.removeEventListener('click', handleClickOutside)
})

// Observer le changement d'utilisateur
watch(currentUser, (newUser) => {
  if (newUser) {
    fetchUserData()
  } else {
    router.push('/login')
  }
})
</script>

<style scoped>
.hide-scrollbar::-webkit-scrollbar {
  display: none;
}

.hide-scrollbar {
  -ms-overflow-style: none;
  scrollbar-width: none;
}

/* Animations optimisées */
@keyframes fadeIn {
  from { opacity: 0; transform: translateY(-8px); }
  to { opacity: 1; transform: translateY(0); }
}

@keyframes pulse {
  0% { box-shadow: 0 0 0 0 rgba(var(--primary-color), 0.4); }
  70% { box-shadow: 0 0 0 6px rgba(var(--primary-color), 0); }
  100% { box-shadow: 0 0 0 0 rgba(var(--primary-color), 0); }
}
</style> 
