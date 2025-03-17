<template>
  <div class="min-h-screen flex flex-col bg-gray-50 dark:bg-gray-900">
    <!-- Header premium avec effet de verre et gradient subtil -->
 <NavbarMain />

    <!-- Search modal - simplified -->
    <transition
      enter-active-class="ease-out duration-200"
      enter-from-class="opacity-0"
      enter-to-class="opacity-100"
      leave-active-class="ease-in duration-150"
      leave-from-class="opacity-100"
      leave-to-class="opacity-0"
    >
      <div v-if="showSearch" class="fixed inset-0 z-50 overflow-y-auto">
        <div class="flex items-start justify-center min-h-screen pt-16 px-4 pb-20 text-center">
          <div 
            class="fixed inset-0 bg-gray-900/50 dark:bg-gray-900/70 transition-opacity"
            @click="showSearch = false"
          ></div>

          <!-- Search box -->
          <div class="relative bg-white dark:bg-gray-800 rounded-xl max-w-md w-full p-6 shadow-xl transform transition-all">
            <div class="relative">
              <Search class="h-5 w-5 absolute left-3 top-1/2 -translate-y-1/2 text-gray-400" />
              <input
                ref="searchInput"
                v-model="searchQuery"
                type="text"
                placeholder="Rechercher..."
                class="w-full pl-10 pr-10 py-2.5 border border-gray-300 dark:border-gray-600 rounded-full bg-white dark:bg-gray-800 text-gray-700 dark:text-white focus:outline-none focus:ring-2 focus:ring-primary-500"
                @keyup.enter="performSearch"
              />
              <button 
                @click="showSearch = false"
                class="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-600"
              >
                <X class="h-5 w-5" />
              </button>
            </div>
          </div>
        </div>
      </div>
    </transition>

    <!-- Page content -->
    <main class="flex-1">
      <slot />
    </main>

    <!-- Footer would go here -->
  </div>
</template>

<script setup>
import { ref, onMounted, watch, nextTick } from 'vue'
import { useRouter } from 'vue-router'
import { useSupabaseClient, useSupabaseUser } from '#imports'
import { User, Search, Menu, X, Sun, Moon } from 'lucide-vue-next'
import NavbarMain from '@/components/NavbarMain.vue'
const router = useRouter()
const supabase = useSupabaseClient()
const user = useSupabaseUser()

// State variables
const userMenuOpen = ref(false)
const mobileMenuOpen = ref(false)
const showSearch = ref(false)
const searchQuery = ref('')
const searchInput = ref(null)
const userProfile = ref(null)
const hasNotifications = ref(true)
const hasRequestNotifications = ref(true)

// Log out the user
const logout = async () => {
  try {
    await supabase.auth.signOut()
    userMenuOpen.value = false
    mobileMenuOpen.value = false
    router.push('/')
  } catch (error) {
    console.error('Error logging out:', error)
  }
}

// Perform search
const performSearch = () => {
  if (!searchQuery.value.trim()) return
  
  router.push(`/search?q=${encodeURIComponent(searchQuery.value)}`)
  showSearch.value = false
  searchQuery.value = ''
}

// Fetch user profile from Supabase
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
  } catch (error) {
    console.error('Error fetching user profile:', error)
  }
}

// Get user display name
const getUserDisplayName = () => {
  if (!userProfile.value) return 'Mon compte'
  
  if (userProfile.value.first_name && userProfile.value.last_name) {
    return `${userProfile.value.first_name} ${userProfile.value.last_name}`
  } else if (userProfile.value.first_name) {
    return userProfile.value.first_name
  } else {
    return 'Mon compte'
  }
}

// Get user initials for avatar placeholder
const getUserInitials = () => {
  if (!userProfile.value) return '?'
  
  if (userProfile.value.first_name && userProfile.value.last_name) {
    return userProfile.value.first_name.charAt(0) + userProfile.value.last_name.charAt(0)
  } else if (userProfile.value.first_name) {
    return userProfile.value.first_name.charAt(0)
  } else if (user.value?.email) {
    return user.value.email.charAt(0).toUpperCase()
  } else {
    return '?'
  }
}

// Toggle user menu
const toggleUserMenu = () => {
  userMenuOpen.value = !userMenuOpen.value
}

// Handle click outside
const handleClickOutside = (event) => {
  const target = event.target
  if (userMenuOpen.value && !target.closest('.user-menu')) {
    userMenuOpen.value = false
  }
}

// Initialize
onMounted(() => {
  // Set up click outside listener
  window.addEventListener('click', handleClickOutside)
  
  // Fetch user profile if logged in
  if (user.value) {
    fetchUserProfile()
  }
})

// Focus search input when search modal opens
watch(showSearch, (newVal) => {
  if (newVal) {
    nextTick(() => {
      searchInput.value?.focus()
    })
  }
})

// Watch for user changes
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
.active, .router-link-active {
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
  from { opacity: 0; transform: scaleX(0.5); }
  to { opacity: 1; transform: scaleX(1); }
}

.animate-fadeIn {
  animation: fadeIn 0.3s ease forwards;
}

/* Animation pour le menu utilisateur */
@keyframes scaleUp {
  from { opacity: 0; transform: scale(0.95); }
  to { opacity: 1; transform: scale(1); }
}

.animate-scaleUp {
  animation: scaleUp 0.2s ease forwards;
}

/* Animation pour le menu mobile */
@keyframes slideDown {
  from { opacity: 0; transform: translateY(-10px); }
  to { opacity: 1; transform: translateY(0); }
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