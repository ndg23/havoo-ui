<template>
  <NuxtLayout name="default">
    <template #default>
      <!-- Loading state -->
      <div v-if="isLoading" class="min-h-screen flex items-center justify-center">
        <div class="animate-spin rounded-full h-10 w-10 border-b-2 border-blue-500"></div>
      </div>

      <!-- Content when loaded -->
      <div v-else class="min-h-screen bg-white dark:bg-gray-900">
        <!-- Twitter-inspired header -->
        <header class="sticky top-0 z-40 backdrop-blur-xl">
          <div class="bg-white/90 dark:bg-gray-900/90 border rounded mt-12- border-gray-100/50 dark:border-gray-800/50">
            <div class="max-w-6xl mx-auto px-4">
              <div class="h-16 flex items-center justify-center">
                <!-- Logo/Brand -->
               
                
                <!-- Navigation desktop -->
                <nav class="hidden md:flex h-full">
                  <div class="flex h-full space-x-6">
                    <NuxtLink 
                      v-for="item in navigationItems"
                      :key="item.to"
                      :to="item.to"
                      class="twitter-tab group  relative flex items-center px-4 h-full"
                      :class="[
                        isActivePath(item.to) 
                          ? 'twitter-tab-active' 
                          : ''
                      ]"
                    >
                      <div class="flex flex-col items-center">
                        <v-icon 
                          :name="item.icon" 
                          class="w-6 h-6 transition-all duration-300"
                          :class="[
                            isActivePath(item.to) 
                              ? 'text-primary-500' 
                              : 'text-gray-600 group-hover:text-gray-900 dark:text-gray-400 dark:group-hover:text-white'
                          ]"
                        />
                        <span 
                          class="text-sm font-semibold transition-colors duration-300 mt-1"
                          :class="[
                            isActivePath(item.to) 
                              ? 'text-primary-500' 
                              : 'text-gray-600 group-hover:text-gray-900 dark:text-gray-400 dark:group-hover:text-white'
                          ]"
                        >
                          {{ item.label }}
                        </span>
                      </div>
                      
                      <!-- Twitter-style indicator -->
                      <div 
                        class="absolute bottom-0 left-1/2 transform -translate-x-1/2 w-1/2 h-1 bg-primary-500 rounded-full transition-all duration-300"
                        :class="[
                          isActivePath(item.to) 
                            ? 'opacity-100 scale-x-100' 
                            : 'opacity-0 scale-x-0 group-hover:opacity-40 group-hover:scale-x-50'
                        ]"
                      />
                    </NuxtLink>
                  </div>
                </nav>

             
              </div>
            </div>
          </div>
        </header>

        <!-- Main container with Twitter-style layout -->
        <div class="max-w-6xl mx-auto px-4 py-6 md:flex">
          <!-- Left sidebar (desktop only) -->
         
          
          <!-- Main content area -->
          <main class="flex-1">
            <slot />
          </main>
        </div>

        <!-- Navigation mobile with Twitter style -->
        <div class="md:hidden fixed bottom-0 inset-x-0 bg-white/90 dark:bg-gray-900/90 backdrop-blur-xl border-t border-gray-100/50 dark:border-gray-800/50 z-50">
          <div class="flex justify-around">
            <NuxtLink 
              v-for="item in navigationItems"
              :key="item.to"
              :to="item.to"
              class="flex-1 flex flex-col items-center py-3 relative"
              :class="[
                isActivePath(item.to) 
                  ? 'text-blue-500' 
                  : 'text-gray-500 dark:text-gray-400'
              ]"
            >
              <v-icon 
                :name="item.icon" 
                class="w-6 h-6 transition-all duration-300"
                :class="{ 'scale-110': isActivePath(item.to) }"
              />
              <span class="text-xs font-medium mt-1">
                {{ item.label }}
              </span>
              
              <!-- Twitter-style dot indicator for mobile -->
              <div 
                v-if="isActivePath(item.to)"
                class="absolute bottom-0 w-1 h-1 bg-blue-500 rounded-full"
              />
            </NuxtLink>
          </div>
        </div>
      </div>
    </template>
  </NuxtLayout>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useSupabaseClient, useSupabaseUser, useRoute } from '#imports'
import { OhVueIcon as VIcon, addIcons } from 'oh-vue-icons'
import { 
  BiHouseDoor,
  BiBriefcase,
  BiFileText,
  BiGear,
  BiPerson,
  BiBell,
  BiPlusCircle,
  BiCheckCircleFill,
  BiChevronRight
} from 'oh-vue-icons/icons'

// Register icons
addIcons(
  BiHouseDoor,
  BiBriefcase,
  BiFileText,
  BiGear,
  BiPerson,
  BiBell,
  BiPlusCircle,
  BiCheckCircleFill,
  BiChevronRight
)

const route = useRoute()
const supabase = useSupabaseClient()
const supabaseUser = useSupabaseUser()

const user = ref(null)
const isLoading = ref(true)

// Fetch user profile
const fetchUserProfile = async () => {
  try {
    const { data, error } = await supabase
      .from('profiles')
      .select(`
        *,
        missions_count:missions(count),
        contracts_count:contracts(count)
      `)
      .eq('id', supabaseUser.value.id)
      .single()

    if (error) throw error
    user.value = data
  } catch (error) {
    console.error('Error fetching user profile:', error)
  } finally {
    isLoading.value = false
  }
}

// Computed properties
const isExpert = computed(() => user.value?.role === 'expert')
const isVerified = computed(() => user.value?.is_verified)
const isAdmin = computed(() => user.value?.is_admin)

const navigationItems = computed(() => [
  { 
    label: 'Accueil', 
    to: '/account', 
    icon: 'bi-house-door',
    exact: true
  },
  { 
    label: 'Missions', 
    to: '/account/missions', 
    icon: 'bi-briefcase'
  },
  ...(isExpert.value ? [{
    label: 'Services',
    to: '/account/services',
    icon: 'bi-file-text'
  }] : []),
  { 
    label: 'Contrats',
    to: '/account/contracts',
    icon: 'bi-file-text'
  },
  { 
    label: 'Paramètres',
    to: '/account/edit-profile',
    icon: 'bi-gear'
  },
  ...(isAdmin.value ? [{
    label: 'Admin',
    to: '/admin',
    icon: 'bi-gear'
  }] : [])
])

// Load data on mount
onMounted(() => {
  fetchUserProfile()
})

const isActivePath = (path) => {
  if (path === '/account') {
    // Exact match for home page
    return route.path === path
  }
  // Prefix match for other pages
  return route.path.startsWith(path) && path !== '/account'
}

const getInitials = (firstName, lastName) => {
  return `${firstName?.[0] || ''}${lastName?.[0] || ''}`.toUpperCase()
}
</script>

<style scoped>
/* Twitter-inspired styles */
.twitter-tab {
  @apply relative transition-all duration-300;
}

.twitter-tab:hover {
  @apply bg-gray-50/50 dark:bg-gray-800/30;
}

.twitter-tab-active {
  @apply font-bold;
}

/* Smooth transition effects */
.v-icon {
  @apply transform transition-all duration-300 ease-out;
}

/* Subtle hover animation */
.twitter-tab:hover .v-icon {
  @apply scale-110;
}

/* Click effect */
.twitter-tab:active {
  @apply scale-95;
}

/* Entrance/exit animations */
@keyframes slideIn {
  from { opacity: 0; transform: translateY(-20px); }
  to { opacity: 1; transform: translateY(0); }
}

@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

.header-content {
  animation: slideIn 0.4s cubic-bezier(0.16, 1, 0.3, 1);
}

main {
  animation: fadeIn 0.5s ease-out;
}
</style>