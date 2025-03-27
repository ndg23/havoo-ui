<template>
  <NuxtLayout name="default">
    <template #default>
      <!-- Loading state -->
      <div v-if="isLoading" class="min-h-screen flex items-center justify-center">
        <div class="animate-spin rounded-full h-8 w-8 border-b-2 border-primary-500"></div>
      </div>

      <!-- Content when loaded -->
      <div v-else class="min-h-screen bg-white dark:bg-gray-900">
        <!-- Header fixe avec design Twitter -->
        <header class="sticky top-0 z-40 backdrop-blur-sm">
          <div class="bg-white/80 dark:bg-gray-900/80 border-b border-gray-200 dark:border-gray-800">
            <!-- Profil condensé -->
            <div class="max-w-6xl mx-auto px-4">
              <div class="h-16 flex items-center justify-between gap-4">
                <!-- Info utilisateur -->
                <div class="flex items-center gap-3">
                  <div class="relative">
                    <div class="w-9 h-9 rounded-full ring-2 ring-white dark:ring-gray-800 overflow-hidden">
                      <img 
                        v-if="user?.avatar_url" 
                        :src="user.avatar_url" 
                        :alt="user?.first_name"
                        class="w-full h-full object-cover"
                      />
                      <div 
                        v-else 
                        class="w-full h-full bg-gradient-to-br from-primary-400 to-primary-600 flex items-center justify-center text-sm font-bold text-white"
                      >
                        {{ getInitials(user?.first_name, user?.last_name) }}
                      </div>
                    </div>
                    <div 
                      class="absolute -bottom-0.5 -right-0.5 w-3.5 h-3.5 rounded-full ring-2 ring-white dark:ring-gray-800"
                      :class="{
                        'bg-green-500': user?.availability_status === 'available',
                        'bg-yellow-500': user?.availability_status === 'busy',
                        'bg-red-500': user?.availability_status === 'unavailable'
                      }"
                    />
                  </div>
                  <div class="hidden sm:block">
                    <div class="font-bold text-gray-900 dark:text-white">
                      {{ user?.first_name }} {{ user?.last_name }}
                    </div>
                    <div class="text-sm text-gray-800 dark:text-gray-400">
                      {{ user?.role === 'expert' ? 'Expert' : 'Client' }}
                      <span v-if="user?.is_verified" class="ml-1 text-primary-500">
                        <v-icon name="bi-patch-check-fill" scale="1.1" />
                      </span>
                    </div>
                  </div>
                </div>

                <!-- Navigation desktop -->
                <nav class="hidden md:flex h-full flex-1 items-center justify-center">
                  <div class="flex h-full space-x-1">
                    <NuxtLink 
                      v-for="item in navigationItems"
                      :key="item.to"
                      :to="item.to"
                      class="twitter-tab group relative flex items-center px-8 h-full"
                      :class="[
                        isActivePath(item.to) 
                          ? 'twitter-tab-active' 
                          : ''
                      ]"
                    >
                      <!-- Icône et label avec effet hover -->
                      <div class="flex flex-col items-center">
                        <v-icon 
                          :name="item.icon" 
                          class="w-6 h-6 mb-0.5 transition-colors duration-200"
                          :class="[
                            isActivePath(item.to) 
                              ? 'text-primary-500 dark:text-primary-400' 
                              : 'text-gray-800 dark:text-gray-400 group-hover:text-gray-900 dark:group-hover:text-white'
                          ]"
                        />
                        <span 
                          class="text-sm font-medium transition-colors duration-200"
                          :class="[
                            isActivePath(item.to) 
                              ? 'text-gray-900 dark:text-white' 
                              : 'text-gray-800 dark:text-gray-400 group-hover:text-gray-900 dark:group-hover:text-white'
                          ]"
                        >
                          {{ item.label }}
                        </span>
                      </div>

                      <!-- Indicateur actif -->
                      <div 
                        class="absolute bottom-0 left-0 right-0 h-1 bg-primary-500 dark:bg-primary-400 transition-all duration-200"
                        :class="[
                          isActivePath(item.to) 
                            ? 'opacity-100' 
                            : 'opacity-0 group-hover:opacity-100'
                        ]"
                      />
                    </NuxtLink>
                  </div>
                </nav>

                <!-- Actions -->
                <!-- <div class="flex items-center gap-3">
                  <button class="p-2 text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200">
                    <v-icon name="bi-bell" class="w-6 h-6" />
                  </button>
                </div> -->
              </div>
            </div>

            <!-- Navigation mobile -->
            <div class="md:hidden fixed bottom-0 left-0 right-0 bg-white dark:bg-gray-900 border-t border-gray-200 dark:border-gray-800 z-50">
              <div class="flex justify-around">
                <NuxtLink 
                  v-for="item in navigationItems"
                  :key="item.to"
                  :to="item.to"
                  class="flex-1 flex flex-col items-center py-3 relative"
                  :class="[
                    isActivePath(item.to) 
                      ? 'text-primary-500 dark:text-primary-400' 
                      : 'text-gray-800 dark:text-gray-400'
                  ]"
                >
                  <v-icon 
                    :name="item.icon" 
                    class="w-6 h-6 mb-1"
                  />
                  <span class="text-xs font-medium">
                    {{ item.label }}
                  </span>

                  <!-- Indicateur actif mobile -->
                  <div 
                    class="absolute -top-px left-0 right-0 h-0.5 bg-primary-500 dark:bg-primary-400 transition-all duration-200"
                    :class="[
                      isActivePath(item.to) 
                        ? 'opacity-100' 
                        : 'opacity-0'
                    ]"
                  />
                </NuxtLink>
              </div>
            </div>
          </div>
        </header>

        <!-- Contenu principal -->
        <main class="max-w-6xl mx-auto px-4 py-6">
          <slot />
        </main>
      </div>
    </template>
  </NuxtLayout>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useSupabaseClient, useSupabaseUser, useRoute } from '#imports'
import { OhVueIcon as VIcon, addIcons } from 'oh-vue-icons'
import { 
  HomeIcon, 
  BriefcaseIcon,
  ChatBubbleLeftRightIcon,
  UserIcon,
  BellIcon,
  PlusIcon,
  ChevronRightIcon
} from '@heroicons/vue/24/outline'
import { 
  BiHouseDoor,
  BiBriefcase,
  BiFileText,
  BiGear
} from 'oh-vue-icons/icons'

// Mise à jour des icônes
addIcons(
  BiHouseDoor,
  BiBriefcase,
  BiFileText,
  BiGear
)

const route = useRoute()
const supabase = useSupabaseClient()
const supabaseUser = useSupabaseUser()

const user = ref(null)
const isLoading = ref(true)

// Récupérer le profil de l'utilisateur
const fetchUserProfile = async () => {
  try {
    const { data, error } = await supabase
      .from('profiles')
      .select(`
        *
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
    icon: 'bi-briefcase'
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

// Charger les données au montage
onMounted(() => {
  fetchUserProfile()
})

const isActivePath = (path) => {
  if (path === '/account') {
    // Exact match pour la page d'accueil
    return route.path === path
  }
  // Prefix match pour les autres pages
  return route.path.startsWith(path) && path !== '/account'
}

const getInitials = (firstName, lastName) => {
  return `${firstName?.[0] || ''}${lastName?.[0] || ''}`.toUpperCase()
}
</script>

<style scoped>
.twitter-tab {
  @apply relative transition-all duration-200;
}

.twitter-tab::after {
  content: '';
  @apply absolute bottom-0 left-0 right-0 h-1 bg-primary-500 dark:bg-primary-400 transform scale-x-0 transition-transform duration-200;
}

.twitter-tab:hover::after {
  @apply scale-x-100;
}

.twitter-tab-active::after {
  @apply scale-x-100;
}

/* Animation pour le hover */
.twitter-tab:hover {
  @apply bg-gray-50 dark:bg-gray-800;
}

/* Style actif */
.twitter-tab-active {
  @apply font-semibold;
}

/* Effet de transition pour les icônes */
.v-icon {
  @apply transform transition-transform duration-200;
}

.twitter-tab:hover .v-icon {
  @apply scale-110;
}
</style>
