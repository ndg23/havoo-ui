<template>
  <div class="min-h-screen bg-white dark:bg-gray-900">
    <div class="flex max-w-7xl mx-auto">
      <!-- Sidebar -->
      <aside class="fixed w-[75px] sm:w-[240px] h-screen py-2 z-40">
        <div class="h-full bg-white dark:bg-gray-900 rounded-xl">
          <!-- Logo -->
          <div class="p-4">
            <NuxtLink to="/account" class="inline-flex">
              <span class="hidden sm:block text-2xl font-bold text-primary-600">HAVOO</span>
              <span class="sm:hidden text-2xl font-bold text-primary-600">H</span>
            </NuxtLink>
          </div>

          <!-- Navigation principale -->
          <nav class="px-2">
            <div class="space-y-1">
              <NuxtLink 
                to="/account" 
                class="flex items-center justify-center sm:justify-start gap-4 p-3 text-xl text-gray-900 dark:text-white rounded-full hover:bg-gray-50 dark:hover:bg-gray-800 transition-colors"
              >
                <UIcon name="i-heroicons-home" class="w-7 h-7" />
                <span class="hidden sm:block">Tableau de bord</span>
              </NuxtLink>
              
              <NuxtLink 
                to="/account/missions" 
                class="flex items-center justify-center sm:justify-start gap-4 p-3 text-xl text-gray-900 dark:text-white rounded-full hover:bg-gray-50 dark:hover:bg-gray-800 transition-colors"
              >
                <UIcon name="i-heroicons-briefcase" class="w-7 h-7" />
                <span class="hidden sm:block">Mes missions</span>
              </NuxtLink>

              <NuxtLink 
                to="/account/messages" 
                class="flex items-center justify-center sm:justify-start gap-4 p-3 text-xl text-gray-900 dark:text-white rounded-full hover:bg-gray-50 dark:hover:bg-gray-800 transition-colors"
              >
                <UIcon name="i-heroicons-chat-bubble-left-right" class="w-7 h-7" />
                <span class="hidden sm:block">Messages</span>
              </NuxtLink>

              <NuxtLink 
                to="/account/settings" 
                class="flex items-center justify-center sm:justify-start gap-4 p-3 text-xl text-gray-900 dark:text-white rounded-full hover:bg-gray-50 dark:hover:bg-gray-800 transition-colors"
              >
                <UIcon name="i-heroicons-cog-6-tooth" class="w-7 h-7" />
                <span class="hidden sm:block">Paramètres</span>
              </NuxtLink>
            </div>

            <!-- Bouton disponibilité -->
            <div class="px-3 mt-4">
              <UButton
                @click="toggleAvailability"
                :color="profile?.availability_status === 'available' ? 'green' : 'gray'"
                size="xl"
                class="w-full justify-center rounded-full"
              >
                <UIcon :name="profile?.availability_status === 'available' ? 'i-heroicons-check-circle' : 'i-heroicons-x-circle'" class="w-6 h-6 sm:hidden" />
                <span class="hidden sm:block">{{ profile?.availability_status === 'available' ? 'Disponible' : 'Indisponible' }}</span>
              </UButton>
            </div>
          </nav>

          <!-- Profil et statistiques -->
          <div class="absolute bottom-4 left-0 right-0 px-4">
            <!-- Stats rapides -->
            <div class="hidden sm:block mb-4 p-3 bg-gray-50 dark:bg-gray-800 rounded-2xl">
              <div class="flex items-center gap-3 mb-2">
                <UIcon name="i-heroicons-star" class="w-6 h-6 text-amber-500" />
                <span class="text-sm font-medium">Note moyenne</span>
              </div>
              <p class="text-2xl font-bold text-gray-900 dark:text-white">{{ averageRating.toFixed(1) }}/5</p>
            </div>

            <!-- Menu utilisateur -->
            <UDropdown :items="userMenuItems" :ui="{ item: { base: 'p-2' }, trigger: 'w-full' }">
              <div class="flex items-center justify-center sm:justify-start gap-3 p-2 rounded-full hover:bg-gray-50 dark:hover:bg-gray-800 cursor-pointer transition-colors">
                <UAvatar
                  :src="profile?.avatar_url || defaultAvatar"
                  :alt="`Photo de profil de ${profile?.first_name || 'utilisateur'}`"
                  size="lg"
                />
                <div class="hidden sm:block min-w-0">
                  <p class="font-medium text-gray-900 dark:text-white truncate">{{ profile?.first_name }} {{ profile?.last_name }}</p>
                  <p class="text-sm text-gray-500 dark:text-gray-400 truncate">{{ profile?.profession?.name }}</p>
                </div>
              </div>
            </UDropdown>
          </div>
        </div>
      </aside>

      <!-- Main content -->
      <main class="flex-1 ml-[75px] sm:ml-[240px]">
        <!-- Header -->
        <header class="sticky top-0 z-30 bg-white/80 dark:bg-gray-900/80 backdrop-blur-sm border-b border-gray-100 dark:border-gray-800">
          <div class="flex items-center justify-between h-16 px-4 max-w-[800px] mx-auto">
            <h1 class="text-xl font-semibold text-gray-900 dark:text-white truncate">{{ $route.name }}</h1>
            
            <div class="flex items-center gap-4">
              <UButton
                color="gray"
                variant="ghost"
                icon="i-heroicons-bell"
              />
              <UInput
                icon="i-heroicons-magnifying-glass"
                placeholder="Rechercher..."
                class="hidden sm:flex w-64"
              />
            </div>
          </div>
        </header>

        <!-- Page content -->
        <div class="max-w-[800px] mx-auto px-4 py-6">
          <slot />
        </div>
      </main>

      <!-- Right sidebar -->
      <div class="hidden xl:block w-[240px]">
        <!-- Contenu futur -->
      </div>
    </div>

    <!-- Mobile navigation (xs screens only) -->
    <nav class="fixed bottom-0 left-0 right-0 bg-white dark:bg-gray-900 border-t border-gray-100 dark:border-gray-800 sm:hidden z-40">
      <div class="grid grid-cols-4 gap-1">
        <NuxtLink 
          to="/account" 
          class="flex flex-col items-center py-3 text-gray-600 dark:text-gray-400"
        >
          <UIcon name="i-heroicons-home" class="w-6 h-6" />
          <span class="text-xs mt-1">Accueil</span>
        </NuxtLink>
        
        <NuxtLink 
          to="/account/missions" 
          class="flex flex-col items-center py-3 text-gray-600 dark:text-gray-400"
        >
          <UIcon name="i-heroicons-briefcase" class="w-6 h-6" />
          <span class="text-xs mt-1">Missions</span>
        </NuxtLink>
        
        <NuxtLink 
          to="/account/messages" 
          class="flex flex-col items-center py-3 text-gray-600 dark:text-gray-400"
        >
          <UIcon name="i-heroicons-chat-bubble-left-right" class="w-6 h-6" />
          <span class="text-xs mt-1">Messages</span>
        </NuxtLink>
        
        <NuxtLink 
          to="/account/settings" 
          class="flex flex-col items-center py-3 text-gray-600 dark:text-gray-400"
        >
          <UIcon name="i-heroicons-cog-6-tooth" class="w-6 h-6" />
          <span class="text-xs mt-1">Paramètres</span>
        </NuxtLink>
      </div>
    </nav>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { useSupabaseClient, useSupabaseUser } from '#imports'
import { useCustomToast } from '~/composables/useCustomToast'
import { useDefaultAvatar } from '~/composables/useDefaultAvatar'

const supabase = useSupabaseClient()
const user = useSupabaseUser()

interface Client {
  id: string
  first_name: string
  last_name: string
  avatar_url: string | null
}

interface Deal {
  id: string
  expert_rating: number
  expert_review: string
  status: string
  created_at: string
  client: Client
}

interface Profession {
  name: string
}

interface Profile {
  id: string
  first_name: string
  last_name: string
  avatar_url: string | null
  bio: string
  city: string
  website: string
  availability_status: 'available' | 'unavailable'
  created_at: string
  profession: Profession
  deals: Deal[]
}

const profile = ref<Profile | null>(null)
const { showToast } = useCustomToast()
const { defaultAvatar } = useDefaultAvatar()

const userMenuItems = [
  [
    {
      label: 'Mon profil',
      icon: 'i-heroicons-user-circle',
      to: '/account/edit-profile'
    },
    {
      label: 'Paramètres',
      icon: 'i-heroicons-cog-6-tooth',
      to: '/account/settings'
    }
  ],
  [
    {
      label: 'Déconnexion',
      icon: 'i-heroicons-arrow-right-on-rectangle',
      click: async () => {
        try {
          const { error } = await supabase.auth.signOut()
          if (error) throw error
          showToast.success('Déconnexion réussie')
          navigateTo('/login')
        } catch (error) {
          console.error('Erreur:', error)
          showToast.error('Erreur lors de la déconnexion')
        }
      }
    }
  ]
]

const toggleAvailability = async () => {
  try {
    const newStatus = profile.value?.availability_status === 'available' ? 'unavailable' : 'available'
    
    const { error } = await supabase
      .from('profiles')
      .update({ 
        availability_status: newStatus,
        updated_at: new Date().toISOString()
      })
      .eq('id', user.value?.id)

    if (error) throw error
    
    profile.value.availability_status = newStatus
    showToast.success(`Statut mis à jour : ${newStatus === 'available' ? 'Disponible' : 'Indisponible'}`)
  } catch (error) {
    console.error('Erreur:', error)
    showToast.error('Erreur lors de la mise à jour du statut')
  }
}

const fetchProfile = async () => {
  try {
    const { data, error } = await supabase
      .from('profiles')
      .select(`
        *,
        profession:profession_id (name),
        deals!deals_expert_id_fkey (
          id,
          expert_rating,
          expert_review,
          status,
          created_at,
          client:client_id (
            id,
            first_name,
            last_name,
            avatar_url
          )
        )
      `)
      .eq('id', user.value?.id)
      .single()

    if (error) throw error
    profile.value = data
  } catch (error) {
    console.error('Erreur:', error)
    showToast.error('Erreur lors du chargement du profil')
  }
}

const averageRating = computed(() => {
  if (!profile.value?.deals?.length) return 0
  const completedDeals = profile.value.deals.filter(deal => 
    deal.status === 'completed' && deal.expert_rating !== null
  )
  if (!completedDeals.length) return 0
  const total = completedDeals.reduce((sum, deal) => sum + (deal.expert_rating || 0), 0)
  return total / completedDeals.length
})

onMounted(async () => {
  if (user.value) {
    await fetchProfile()
  } else {
    showToast.error('Veuillez vous connecter pour accéder à votre profil')
    navigateTo('/login')
  }
})

definePageMeta({
  middleware: ['auth']
})
</script>

<style scoped>
/* Transitions douces */
.transition-all {
  transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
}

/* Ombre subtile */
.shadow-sm {
  box-shadow: 0 1px 2px 0 rgb(0 0 0 / 0.05), 0 1px 3px 0 rgb(0 0 0 / 0.1);
}

/* Animation du statut */
@keyframes ping {
  75%, 100% {
    transform: scale(2);
    opacity: 0;
  }
}

.animate-ping {
  animation: ping 1.5s cubic-bezier(0, 0, 0.2, 1) infinite;
}

.animate-pulse {
  animation: pulse 2s cubic-bezier(0.4, 0, 0.6, 1) infinite;
}

@keyframes pulse {
  0%, 100% {
    opacity: 1;
  }
  50% {
    opacity: .5;
  }
}

/* Effet de survol */
.hover-lift {
  transition: transform 0.2s cubic-bezier(0.4, 0, 0.2, 1);
}

.hover-lift:hover {
  transform: translateY(-2px);
}

/* Effet de focus */
.focus-ring {
  @apply focus:outline-none focus:ring-2 focus:ring-primary-500 focus:ring-offset-2 dark:focus:ring-offset-gray-900;
}

/* Effet de glassmorphism */
.glass-effect {
  @apply bg-white/80 dark:bg-gray-900/80 backdrop-blur-xl;
}
</style>