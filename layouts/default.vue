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
        <div class="hidden sm:flex space-x-8">
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

          <NuxtLink to="/account/messages" class="flex hidden flex-col items-center pb-1 pt-1 border-b-2 relative"
            :class="[$route.path.includes('/account/messages') ? 'border-primary-500 text-primary-600 dark:text-primary-400 font-medium' : 'border-transparent text-gray-500 hover:text-gray-700 dark:text-gray-400']">
            <MessageSquare class="h-6 w-6" />
            <span class="text-sm text-gray-800 font-semibold  mt-1">Messages</span>
            <span v-if="unreadCount > 0"
              class="absolute -top-1 -right-1 bg-primary-500 text-white text-xs rounded-full h-5 w-5 flex items-center justify-center">
              {{ unreadCount }}
            </span>
          </NuxtLink>
        </div>

        <!-- User menu -->
        <div class="flex items-center space-x-4">
          <NuxtLink v-if="!user" to="/auth/login"
            class="px-4 py-2.5 bg-white hover:bg-gray-50 text-gray-700 border border-gray-300 font-medium rounded-full transition-colors flex items-center gap-2 shadow-sm">
            Se connecter
          </NuxtLink>

          <div v-else class="relative">
            <button @click="showProfileMenu = !showProfileMenu"
              class="flex items-center  focus:outline-none profile-menu-button">
              <img v-if="userProfile?.avatar_url" :src="userProfile.avatar_url" alt="Avatar"
                class="h-10 w-10 border border-primary-600 rounded-full" />
              <div v-else
                class="h-10 w-10 text-xl uppercase rounded-full bg-primary-100 dark:bg-primary-900 flex items-center justify-center text-primary-700 dark:text-primary-300 font-medium">
                {{ getInitials(userProfile?.first_name, userProfile?.last_name) }}
              </div>
            </button>

            <!-- Menu déroulant du profil -->
            <div v-if="showProfileMenu"
              class="absolute right-0 mt-2 w-48 bg-white dark:bg-gray-800 rounded-md shadow-lg py-1 z-20 border border-gray-200 dark:border-gray-700 animate-scaleUp">
              <div class="px-4 py-2 border-b border-gray-200 dark:border-gray-700">
                <p class="text-sm font-medium text-gray-900 dark:text-white">
                  {{ userProfile?.first_name }} {{ userProfile?.last_name }}
                </p>
                <p class="text-xs text-gray-500 dark:text-gray-400 truncate">
                  {{ userProfile?.email }}
                </p>
              </div>

              <NuxtLink to="/account"
                class="block px-4 py-2 text-sm text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700"
                @click="showProfileMenu = false">
                Tableau de bord
              </NuxtLink>

              <NuxtLink to="/account/edit-profile"
                class="block px-4 py-2 text-sm text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700"
                @click="showProfileMenu = false">
                Modifier le profil
              </NuxtLink>

              <NuxtLink v-if="userProfile?.is_expert" to="/account/services"
                class="block px-4 py-2 text-sm text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700"
                @click="showProfileMenu = false">
                Mes services
              </NuxtLink>

              <div class="border-t border-gray-200 dark:border-gray-700 mt-1 pt-1">
                <button @click="logout"
                  class="block w-full text-left px-4 py-2 text-sm text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700">
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
          <FileText class="h-6 w-6" />
          <span class="text-xs mt-0.5">Demandes</span>
        </NuxtLink>

        <NuxtLink to="/experts" class="flex flex-col items-center py-2 flex-1"
          :class="[$route.path.includes('/experts') ? 'text-primary-600 dark:text-primary-400' : 'text-gray-500 dark:text-gray-400']">
          <Users class="h-6 w-6" />
          <span class="text-xs mt-0.5">Experts</span>
        </NuxtLink>

        <NuxtLink to="/account" class="flex flex-col items-center py-2 flex-1"
          :class="[$route.path.includes('/account') ? 'text-primary-600 dark:text-primary-400' : 'text-gray-500 dark:text-gray-400']">
          <User class="h-6 w-6" />
          <span class="text-xs mt-0.5">Compte</span>
        </NuxtLink>
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
  User
} from 'lucide-vue-next'
import Footer from '@/components/Footer.vue'

const supabase = useSupabaseClient()
const user = useSupabaseUser()
const router = useRouter()

// État
const userProfile = ref(null)
const unreadCount = ref(0)
const showProfileMenu = ref(false)

// Fermer le menu en cliquant ailleurs
const handleClickOutside = (event) => {
  if (showProfileMenu.value && !event.target.closest('.profile-menu-button') && !event.target.closest('.profile-menu')) {
    showProfileMenu.value = false
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
    await fetchUnreadMessages()
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
    router.push('/login')
  } catch (err) {
    console.error('Error during logout:', err)
  }
}

// Obtenir les initiales
const getInitials = (firstName, lastName) => {
  if (!firstName && !lastName) return '?'
  return `${firstName ? firstName.charAt(0) : ''}${lastName ? lastName.charAt(0) : ''}`.toUpperCase()
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
</style>