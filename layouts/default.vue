<template>
  <div class="min-h-screen flex flex-col bg-white dark:bg-gray-900">
    <!-- Header principal style Wave -->
    <header class="sticky top-0 z-50 bg-white dark:bg-gray-800 border- dark:border-gray-700 px-4 py-1">
      <div class="max-w-5xl mx-auto flex items-center justify-between">
        <!-- Logo -->
        <div class="flex items-center">
          <NuxtLink to="/" class="flex items-center">
            <Logo />
          </NuxtLink>
        </div>

        <!-- Navigation centrale (style Wave) -->
        <div class="hidden md:flex space-x-8">
          <!-- <NuxtLink 
            to="/" 
            class="flex flex-col items-center pb-1 pt-1 border-b-2"
            :class="[$route.path === '/' ? 'border-primary-500 text-primary-600 dark:text-primary-400 font-medium' : 'border-transparent text-gray-500 hover:text-gray-700 dark:text-gray-400']"
          >
            <Home class="h-6 w-6" />
            <span class="text-xs mt-1">Accueil</span>
          </NuxtLink> -->

          <NuxtLink to="/requests" class="flex flex-col items-center pb-1 pt-1 border-b-2"
            :class="[$route.path.includes('/requests') ? 'border-primary-500 text-primary-600 dark:text-primary-400 font-medium' : 'border-transparent text-gray-500 hover:text-gray-700 dark:text-gray-400']">
            <svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" viewBox="0 0 24 24">
              <path fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                d="M12.53 2c3.993 0 5.989 0 7.23 1.172C21 4.343 21 6.229 21 10v4c0 3.771 0 5.657-1.24 6.828C18.519 22 16.522 22 12.53 22h-1.06c-3.992 0-5.989 0-7.23-1.172C3 19.657 3 17.771 3 14v-4c0-3.771 0-5.657 1.24-6.828C5.481 2 7.478 2 11.47 2zM8 7h8m-8 5h8m-8 5h4"
                color="currentColor" />
            </svg> <span class="text-sm text-gray-800 font-semibold  mt-1">Demandes</span>
          </NuxtLink>

          <NuxtLink to="/experts" class="flex flex-col items-center pb-1 pt-1 border-b-2"
            :class="[$route.path.includes('/experts') ? 'border-primary-500 text-primary-600 dark:text-primary-400 font-medium' : 'border-transparent text-gray-500 hover:text-gray-700 dark:text-gray-400']">
            <svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" viewBox="0 0 24 24">
              <path fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                d="M13 7a4 4 0 1 1-8 0a4 4 0 0 1 8 0m2 4a4 4 0 0 0 0-8m-4 11H7a5 5 0 0 0-5 5a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2a5 5 0 0 0-5-5m6 0a5 5 0 0 1 5 5a2 2 0 0 1-2 2h-1.5"
                color="currentColor" />
            </svg> <span class="text-sm text-gray-800 font-semibold  mt-1">Experts</span>
          </NuxtLink>

         
        </div>

        <!-- Créer Button -->
       

        <!-- User menu -->
        <div class="flex items-center space-x-4">
          <div class="relative hidden md:block">
          <button 
            @click="showCreateMenu = !showCreateMenu"
            class="create-menu-button px-5 py-2 bg-primary-500 hover:bg-primary-600 text-white rounded-full font-medium transition-colors flex items-center gap-2"
          >
          <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><path fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M12 4v16m-8-8h16" color="currentColor"/></svg>

            Créer
          </button>
          
          <!-- Dropdown menu for "Créer" button -->
          <div v-if="showCreateMenu" 
            class="create-menu absolute right-0 mt-2 w-56 bg-white dark:bg-gray-800 rounded-md shadow-lg py-1 z-20 border border-gray-200 dark:border-gray-700 animate-scaleUp">
            <NuxtLink to="/requests/new"
              class="flex items-center px-4 py-2.5 text-sm text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700"
              @click="showCreateMenu = false">
              <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" class="mr-3 text-primary-500">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"></path>
              </svg>
              Nouvelle demande
            </NuxtLink>
            
            <NuxtLink v-if="userProfile?.is_expert" to="/account/services/new"
              class="flex items-center px-4 py-2.5 text-sm text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700"
              @click="showCreateMenu = false">
              <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" class="mr-3 text-primary-500">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"></path>
              </svg>
              Nouveau service
            </NuxtLink>
          </div>
        </div>
          <NuxtLink v-if="!user" to="/auth/login"
            class="px-4 py-2.5 bg-white hover:bg-gray-50 text-gray-700 border border-gray-300 font-medium rounded-full transition-colors flex items-center gap-2 shadow-sm">
            Se connecter
          </NuxtLink>

          <div v-else class="relative group">
            <button 
              class="flex items-center gap-2 p-2 rounded-full hover: bg-gray-100 dark:hover:bg-gray-800 transition-colors"
              @click="toggleUserMenu"
            >
              <!-- Avatar -->
              <img 
                v-if="userProfile?.avatar_url" 
                :src="userProfile.avatar_url" 
                :alt="`${userProfile?.first_name} ${userProfile?.last_name}`"
                class="h-10 w-10 rounded-full object-cover ring-2 ring-offset-2 ring-transparent group-hover:ring-primary-500"
                @error="handleImageError"
              />
              <div 
                v-else
                class="h-10 w-10 rounded-full bg-gray-200 dark:bg-gray-700 flex items-center justify-center text-gray-600 dark:text-gray-300 font-medium text-lg"
              >
                {{ getInitials(userProfile?.first_name, userProfile?.last_name) }}
              </div>

              <!-- Nom et chevron -->
              <div class="hidden md:flex items-center">
                <span class="text-sm font-medium text-gray-700 dark:text-gray-300">
                  {{ userProfile?.first_name }}
                </span>
                <ChevronDown class="h-4 w-4 ml-1 text-gray-500" />
              </div>
            </button>

            <!-- Menu déroulant -->
            <div 
              v-if="isUserMenuOpen"
              class="absolute right-0 mt-2 w-64 bg-white dark:bg-gray-800 rounded-xl shadow-lg ring-1 ring-black ring-opacity-5 divide-y divide-gray-100 dark:divide-gray-700"
            >
              <!-- En-tête du menu -->
              <div class="p-4">
                <div class="flex items-center gap-3">
                  <img 
                    v-if="userProfile?.avatar_url" 
                    :src="userProfile.avatar_url" 
                    :alt="`${userProfile?.first_name} ${userProfile?.last_name}`"
                    class="h-14 w-14 rounded-full object-cover border-4 border-white dark:border-gray-800 shadow-sm"
                    @error="handleImageError"
                  />
                  <div 
                    v-else
                    class="h-14 w-14 rounded-full bg-gray-200 dark:bg-gray-700 flex items-center justify-center text-xl font-medium"
                  >
                    {{ getInitials(userProfile?.first_name, userProfile?.last_name) }}
                  </div>
                  
                  <div>
                    <div class="font-medium text-gray-900 dark:text-white">
                      {{ userProfile?.first_name }} {{ userProfile?.last_name }}
                    </div>
                    <div class="text-sm text-gray-500 dark:text-gray-400">
                      {{ userProfile?.email }}
                    </div>
                  </div>
                </div>
              </div>

              <!-- Liste des options -->
              <div class="py-2">
                <NuxtLink 
                  to="/account"
                  class="flex items-center gap-3 px-4 py-3 text-sm text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700"
                >
                  <User class="h-5 w-5 text-gray-500" />
                  Mon compte
                </NuxtLink>
                
                <NuxtLink 
                  to="/account/edit-profile"
                  class="flex items-center gap-3 px-4 py-3 text-sm text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700"
                >
                  <Settings class="h-5 w-5 text-gray-500" />
                  Paramètres
                </NuxtLink>
              </div>

              <!-- Déconnexion -->
              <div class="py-2">
                <button 
                  @click="logout"
                  class="flex w-full items-center gap-3 px-4 py-3 text-sm text-red-600 dark:text-red-400 hover:bg-gray-50 dark:hover:bg-gray-700"
                >
                  <LogOut class="h-5 w-5" />
                  Déconnexion
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </header>

    <!-- Mobile navigation (bottom bar) -->
    <div
      class="md:hidden fixed bottom-0 left-0 right-0 z-10 bg-white dark:bg-gray-800 border-t border-gray-200 dark:border-gray-700">
      <div class="flex justify-around">
        <!-- <NuxtLink to="/" class="flex flex-col items-center py-2 flex-1"
          :class="[$route.path === '/' ? 'text-primary-600 dark:text-primary-400' : 'text-gray-500 dark:text-gray-400']">
          <Home class="h-6 w-6" />
          <span class="text-xs mt-0.5">Accueil</span>
        </NuxtLink> -->

        <NuxtLink to="/requests" class="flex flex-col items-center py-2 flex-1"
          :class="[$route.path.includes('/requests') ? 'text-primary-600 dark:text-primary-400' : 'text-gray-500 dark:text-gray-400']">
          <svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" viewBox="0 0 24 24">
              <path fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                d="M12.53 2c3.993 0 5.989 0 7.23 1.172C21 4.343 21 6.229 21 10v4c0 3.771 0 5.657-1.24 6.828C18.519 22 16.522 22 12.53 22h-1.06c-3.992 0-5.989 0-7.23-1.172C3 19.657 3 17.771 3 14v-4c0-3.771 0-5.657 1.24-6.828C5.481 2 7.478 2 11.47 2zM8 7h8m-8 5h8m-8 5h4"
                color="currentColor" />
            </svg> <span class="text-sm text-gray-800 font-semibold  mt-1">Demandes</span>
        </NuxtLink>
        <button @click="showMobileCreateMenu = !showMobileCreateMenu" class="mobile-create-button flex flex-col items-center py-2 flex-1 relative">
          <div class="h-12 w-12 bg-primary-600 rounded-full flex items-center justify-center text-white">
            <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24"><path fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M12 4v16m-8-8h16" color="currentColor"/></svg>
          </div>
          <span class="text-xs mt-0.5 text-primary-600 font-medium">Créer</span>
          
          <!-- Mobile Create Menu -->
          <div v-if="showMobileCreateMenu" 
               class="mobile-create-menu absolute bottom-16 left-1/2 transform -translate-x-1/2 w-56 bg-white rounded-lg shadow-lg py-2 z-30 border border-gray-200 animate-rise">
            <NuxtLink to="/requests/new" 
                     class="flex items-center px-4 py-3 text-gray-700 hover:bg-gray-100"
                     @click="showMobileCreateMenu = false">
              <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" class="mr-3 text-primary-500">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"></path>
              </svg>
              Nouvelle demande
            </NuxtLink>
            
            <NuxtLink v-if="userProfile?.is_expert" to="/account/services/new"
                     class="flex items-center px-4 py-3 text-gray-700 hover:bg-gray-100"
                     @click="showMobileCreateMenu = false">
              <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" class="mr-3 text-primary-500">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"></path>
              </svg>
              Nouveau service
            </NuxtLink>
          </div>
        </button>
        <NuxtLink to="/experts" class="flex flex-col items-center py-2 flex-1"
          :class="[$route.path.includes('/experts') ? 'text-primary-600 dark:text-primary-400' : 'text-gray-500 dark:text-gray-400']">
          <svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" viewBox="0 0 24 24">
              <path fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                d="M13 7a4 4 0 1 1-8 0a4 4 0 0 1 8 0m2 4a4 4 0 0 0 0-8m-4 11H7a5 5 0 0 0-5 5a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2a5 5 0 0 0-5-5m6 0a5 5 0 0 1 5 5a2 2 0 0 1-2 2h-1.5"
                color="currentColor" />
            </svg> <span class="text-sm text-gray-800 font-semibold  mt-1">Experts</span>
        </NuxtLink>

        <!-- Create Button for Mobile -->
      

        <!-- <NuxtLink to="/account" class="flex flex-col items-center py-2 flex-1"
          :class="[$route.path.includes('/account') ? 'text-primary-600 dark:text-primary-400' : 'text-gray-500 dark:text-gray-400']">
          <User class="h-6 w-6" />
          <span class="text-xs mt-0.5">Compte</span>
        </NuxtLink> -->
      </div>
    </div>

    <!-- Main content -->
    <main class="flex-1 pb-16 md:pb-0">
      <slot />
    </main>

    <!-- Footer -->
    <Footer />
  </div>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount, watch } from 'vue'
import { useSupabaseClient, useSupabaseUser, useRouter } from '#imports'
import {
  Home,
  FileText,
  Users,
  MessageSquare,
  User,
  PlusIcon,
  Settings,
  LogOut,
  ChevronDown
} from 'lucide-vue-next'
import Footer from '@/components/Footer.vue'

const supabase = useSupabaseClient()
const user = useSupabaseUser()
const router = useRouter()

// État
const userProfile = ref(null)
const unreadCount = ref(0)
const showProfileMenu = ref(false)
const showCreateMenu = ref(false)
const showMobileCreateMenu = ref(false)
const isUserMenuOpen = ref(false)

// Fermer le menu en cliquant ailleurs
const handleClickOutside = (event) => {
  if (isUserMenuOpen.value && !event.target.closest('.relative')) {
    isUserMenuOpen.value = false
  }
  if (showProfileMenu.value && !event.target.closest('.profile-menu-button') && !event.target.closest('.profile-menu')) {
    showProfileMenu.value = false
  }
  if (showCreateMenu.value && !event.target.closest('.create-menu-button') && !event.target.closest('.create-menu')) {
    showCreateMenu.value = false
  }
  if (showMobileCreateMenu.value && !event.target.closest('.mobile-create-button') && !event.target.closest('.mobile-create-menu')) {
    showMobileCreateMenu.value = false
  }
}

// Récupérer le profil utilisateur
const fetchUserProfile = async () => {
  if (!user.value) return

  try {
    const { data, error } = await supabase
      .from('profiles')
      .select('*')
      .eq('id', user.value.id)
      .single()

    if (error) throw error

    userProfile.value = data

    // Récupérer le nombre de messages non lus
    // await fetchUnreadMessages()
  } catch (err) {
    console.error('Error fetching user profile:', err)
  }
}

// Récupérer le nombre de messages non lus
const fetchUnreadMessages = async () => {
  if (!user.value) return

  try {
    const { data, error } = await supabase
      .from('messages')
      .select('id', { count: 'exact' })
      .eq('is_read', false)
      .in('conversation_id',
        supabase
          .from('conversation_participants')
          .select('conversation_id')
          .eq('profile_id', user.value.id)
      )

    if (error) throw error

    unreadCount.value = data?.length || 0
  } catch (err) {
    console.error('Error fetching unread messages:', err)
  }
}

// Déconnexion
const logout = async () => {
  try {
    await supabase.auth.signOut()
    router.push('/auth/login')
  } catch (err) {
    console.error('Error during logout:', err)
  }
}

// Obtenir les initiales
const getInitials = (firstName, lastName) => {
  if (!firstName && !lastName) return '?'
  return `${firstName ? firstName.charAt(0) : ''}${lastName ? lastName.charAt(0) : ''}`.toUpperCase()
}

const handleImageError = (e) => {
  e.target.src = '/assets/icons/avatar.svg'
}

const toggleUserMenu = () => {
  isUserMenuOpen.value = !isUserMenuOpen.value
}

// Initialisation
onMounted(() => {
  fetchUserProfile()
  document.addEventListener('click', handleClickOutside)
})

onBeforeUnmount(() => {
  document.removeEventListener('click', handleClickOutside)
})

// Surveiller les changements d'utilisateur
watch(user, (newUser) => {
  if (newUser) {
    fetchUserProfile()
  } else {
    userProfile.value = null
  }
})
</script>

<style scoped>
/* Core navigation links - more impactful */
.nav-link {
  @apply px-4 py-2 text-sm font-medium rounded-full text-gray-700 dark:text-gray-200 hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors;
}

.nav-link.active {
  @apply bg-primary-50 dark:bg-primary-900/30 text-primary-600 dark:text-primary-400 font-semibold;
}

/* Simplified button style */
.nav-button {
  @apply px-4 py-1.5 mx-1 text-sm font-medium rounded-full transition-colors;
}

/* User menu dropdown items */
.menu-item {
  @apply block px-4 py-2 text-sm text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700 w-full;
}

/* Mobile navigation */
.mobile-nav-link {
  @apply block px-4 py-3 text-base font-medium text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700 rounded-md;
}

/* Visual feedback for active elements */
.active,
.router-link-active {
  font-weight: 600;
}

/* Subtle shadow effect */
.sticky {
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
}

.dark .sticky {
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.2);
}

/* Animation pour les liens actifs */
@keyframes fadeIn {
  from {
    opacity: 0;
    transform: scaleX(0.5);
  }

  to {
    opacity: 1;
    transform: scaleX(1);
  }
}

.animate-fadeIn {
  animation: fadeIn 0.3s ease forwards;
}

/* Animation pour le menu utilisateur */
@keyframes scaleUp {
  from {
    opacity: 0;
    transform: scale(0.95);
  }

  to {
    opacity: 1;
    transform: scale(1);
  }
}

.animate-scaleUp {
  animation: scaleUp 0.2s ease forwards;
}

/* Animation pour le menu mobile */
@keyframes slideDown {
  from {
    opacity: 0;
    transform: translateY(-10px);
  }

  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.animate-slideDown {
  animation: slideDown 0.3s ease forwards;
}

/* Animation pour le menu mobile create */
@keyframes rise {
  from {
    opacity: 0;
    transform: translate(-50%, 10px);
  }

  to {
    opacity: 1;
    transform: translate(-50%, 0);
  }
}

.animate-rise {
  animation: rise 0.2s ease-out forwards;
}

/* Style des liens du menu mobile */
.mobile-nav-link {
  @apply block px-3 py-2.5 rounded-lg text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-800 font-medium flex items-center transition-colors;
}

/* Style des liens du menu utilisateur */
.menu-item {
  @apply flex items-center px-4 py-2 text-sm text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors;
}

/* Style spécial pour les liens actifs */
.active-link {
  @apply text-primary-600 dark:text-primary-400 font-medium;
}

/* Style pour le menu premium */
.premium-menu-item {
  @apply flex items-center px-5 py-3 text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700 transition-all duration-200;
}

.premium-menu-item:hover {
  @apply bg-gray-50 dark:bg-gray-700;
  transform: translateX(4px);
}

/* Animation du menu */
.absolute {
  transition: all 0.2s ease-out;
}

/* Effet de survol sur l'avatar */
.ring-2 {
  transition: all 0.2s ease-in-out;
}

/* Ombre portée plus douce */
.shadow-lg {
  box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 
              0 4px 6px -2px rgba(0, 0, 0, 0.05);
}
</style>