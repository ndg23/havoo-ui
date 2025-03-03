<template>
  <div class="min-h-screen bg-gray-50">
    <!-- Header -->
    <header class="bg-white border-b border-gray-200">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between h-16 items-center">
          <NuxtLink to="/" class="flex items-center gap-2">
            <span class="text-2xl text-primary-500">⚡</span>
            <span class="font-bold text-gray-900">DomiServices</span>
          </NuxtLink>
          
          <!-- User Menu -->
          <Menu as="div" class="relative">
            <MenuButton class="flex items-center gap-3 p-2 rounded-xl hover:bg-gray-50">
              <img 
                :src="user?.avatar || '/images/default-avatar.png'"
                class="w-8 h-8 rounded-full object-cover"
              />
              <span class="text-sm font-medium text-gray-900">{{ user?.email }}</span>
              <ChevronDownIcon class="w-5 h-5 text-gray-500" />
            </MenuButton>

            <transition
              enter-active-class="transition ease-out duration-100"
              enter-from-class="transform opacity-0 scale-95"
              enter-to-class="transform opacity-100 scale-100"
              leave-active-class="transition ease-in duration-75"
              leave-from-class="transform opacity-100 scale-100"
              leave-to-class="transform opacity-0 scale-95"
            >
              <MenuItems class="absolute right-0 mt-2 w-48 bg-white rounded-xl shadow-lg border focus:outline-none">
                <MenuItem v-slot="{ active }">
                  <button
                    @click="handleLogout"
                    :class="[
                      active ? 'bg-gray-50' : '',
                      'block w-full text-left px-4 py-2 text-sm text-red-600'
                    ]"
                  >
                    Déconnexion
                  </button>
                </MenuItem>
              </MenuItems>
            </transition>
          </Menu>
        </div>
      </div>
    </header>

    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      <div class="lg:grid lg:grid-cols-12 lg:gap-8">
        <!-- Sidebar -->
        <aside class="lg:col-span-3">
          <nav class="space-y-1">
            <NuxtLink
              v-for="item in navigation"
              :key="item.name"
              :to="item.to"
              class="flex items-center gap-3 px-4 py-3 text-sm font-medium rounded-xl transition-colors"
              :class="[
                route.path === item.to
                  ? 'bg-primary-50 text-primary-600'
                  : 'text-gray-900 hover:bg-gray-50'
              ]"
            >
              <component :is="item.icon" class="w-5 h-5" />
              {{ item.name }}
            </NuxtLink>
          </nav>
        </aside>

        <!-- Main content -->
        <main class="lg:col-span-9 mt-8 lg:mt-0">
          <slot />
        </main>
      </div>
    </div>
  </div>
</template>

<script setup>
import { Menu, MenuButton, MenuItems, MenuItem } from '@headlessui/vue'
import { ChevronDownIcon } from '@heroicons/vue/24/outline'
import {
  UserIcon,
  DocumentTextIcon,
  BellIcon,
  Cog6ToothIcon
} from '@heroicons/vue/24/outline'

const user = useSupabaseUser()
const client = useSupabaseClient()
const route = useRoute()

const navigation = [
  { name: 'Mon profil', to: '/compte', icon: UserIcon },
  { name: 'Mes demandes', to: '/compte/demandes', icon: DocumentTextIcon },
  { name: 'Notifications', to: '/compte/notifications', icon: BellIcon },
  { name: 'Paramètres', to: '/compte/parametres', icon: Cog6ToothIcon }
]

const handleLogout = async () => {
  try {
    await client.auth.signOut()
    navigateTo('/auth/login')
  } catch (error) {
    console.error('Error logging out:', error)
  }
}
</script> 