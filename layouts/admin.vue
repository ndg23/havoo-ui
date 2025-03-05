<template>
  <div class="min-h-screen bg-gray-50">
    <!-- Sidebar -->
    <aside class="fixed inset-y-0 left-0 w-64 bg-white border-r border-gray-200 z-30">
      <!-- Logo -->
      <div class="p-4 border-b border-gray-200">
        <Logo />
      </div>

      <!-- Navigation -->
      <nav class="p-4 space-y-1">
        <NuxtLink
          v-for="item in navigation"
          :key="item.name"
          :to="item.to"
          class="flex items-center gap-3 px-3 py-2 rounded-lg text-sm font-medium transition-colors"
          :class="route.path === item.to ? 'bg-primary-50 text-primary-600' : 'text-gray-600 hover:bg-gray-50'"
        >
          <component :is="item.icon" class="w-5 h-5" />
          {{ item.name }}
        </NuxtLink>
      </nav>
    </aside>

    <!-- Main content -->
    <main class="pl-64">
      <!-- Top bar -->
      <header class="sticky top-0 z-20 bg-white border-b border-gray-200">
        <div class="flex items-center justify-between px-8 py-4">
          <!-- Page title -->
          <h1 class="text-2xl font-bold text-gray-900">
            {{ currentPage }}
          </h1>

          <!-- User menu -->
          <div class="relative">
            <button 
              @click="isMenuOpen = !isMenuOpen"
              class="flex items-center gap-2 p-2 rounded-lg hover:bg-gray-50"
            >
              <img 
                :src="`https://ui-avatars.com/api/?name=${user?.email}`" 
                class="w-8 h-8 rounded-full"
              />
              <span class="text-sm font-medium text-gray-700">{{ user?.email }}</span>
              <ChevronDownIcon class="w-4 h-4 text-gray-400" :class="{ 'rotate-180': isMenuOpen }" />
            </button>

            <!-- Dropdown -->
            <div 
              v-if="isMenuOpen"
              class="absolute right-0 mt-2 w-48 bg-white rounded-lg shadow-lg py-1 border border-gray-200"
            >
              <button 
                @click="handleLogout"
                class="flex items-center gap-2 w-full px-4 py-2 text-sm text-red-600 hover:bg-red-50"
              >
                <ArrowRightOnRectangleIcon class="w-4 h-4" />
                Déconnexion
              </button>
            </div>
          </div>
        </div>
      </header>

      <!-- Page content -->
      <div class="p-8">
        <slot />
      </div>
    </main>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useRoute } from 'vue-router'
import {
  ChartBarIcon,
  UsersIcon,
  WrenchScrewdriverIcon,
  ClipboardDocumentListIcon,
  BriefcaseIcon,
  CurrencyDollarIcon,
  Cog6ToothIcon,
  ChevronDownIcon,
  ArrowRightOnRectangleIcon
} from '@heroicons/vue/24/outline'

const route = useRoute()
const user = useSupabaseUser()
const client = useSupabaseClient()
const isMenuOpen = ref(false)

const navigation = [
  { name: 'Tableau de bord', to: '/admin', icon: ChartBarIcon },
  { name: 'Utilisateurs', to: '/admin/users', icon: UsersIcon },
  { name: 'Experts', to: '/admin/experts', icon: WrenchScrewdriverIcon },
  { name: 'Services', to: '/admin/services', icon: ClipboardDocumentListIcon },
  { name: 'Demandes', to: '/admin/requests', icon: BriefcaseIcon },
  { name: 'Paiements', to: '/admin/payments', icon: CurrencyDollarIcon },
  { name: 'Paramètres', to: '/admin/settings', icon: Cog6ToothIcon }
]

const currentPage = computed(() => {
  const current = navigation.find(item => item.to === route.path)
  return current ? current.name : ''
})

const handleLogout = async () => {
  try {
    await client.auth.signOut()
    navigateTo('/auth/login')
  } catch (error) {
    console.error('Error logging out:', error)
  }
}

// Protection de la route admin
const { data: profile } = await useAsyncData('profile', async () => {
  const { data: { user } } = await client.auth.getUser()
  if (!user) return null

  const { data } = await client.from('profiles').select('*').eq('id', user.id).single()
  return data
})

// if (!profile.value || profile.value.role !== 'admin') {
//   navigateTo('/')
// }
</script> 