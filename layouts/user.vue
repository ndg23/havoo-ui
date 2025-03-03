<template>
  <div class="min-h-screen bg-gray-50">
    <!-- Header -->
    <header class="bg-white border-b sticky top-0 z-50">
      <div class="max-w-7xl mx-auto px-4">
        <div class="flex items-center justify-between h-16">
          <!-- Logo -->
          <NuxtLink to="/" class="flex items-center gap-2">
            <span class="text-xl font-bold text-gray-900">Kilou</span>
          </NuxtLink>

          <!-- Navigation -->
          <nav class="flex items-center gap-6">
            <NuxtLink 
              to="/rentals"
              class="text-sm font-medium text-gray-700 hover:text-gray-900"
            >
              Mes locations
            </NuxtLink>
            <NuxtLink 
              to="/favorites"
              class="text-sm font-medium text-gray-700 hover:text-gray-900"
            >
              Favoris
            </NuxtLink>
          </nav>

          <!-- User Menu -->
          <Menu as="div" class="relative">
            <MenuButton class="flex items-center gap-2 text-sm font-medium text-gray-700">
              <Avatar
                :src="user?.avatar"
                :alt="user?.name"
                size="sm"
              />
              <ChevronDownIcon class="w-4 h-4" />
            </MenuButton>
            <MenuItems class="absolute right-0 mt-2 w-48 bg-white rounded-lg -shadow-lg border">
              <MenuItem v-slot="{ active }">
                <NuxtLink 
                  to="/profile"
                  :class="[
                    'block px-4 py-2 text-sm',
                    active ? 'bg-gray-50 text-gray-900' : 'text-gray-700'
                  ]"
                >
                  Mon profil
                </NuxtLink>
              </MenuItem>
              <MenuItem v-slot="{ active }">
                <button 
                  @click="logout"
                  :class="[
                    'block w-full text-left px-4 py-2 text-sm',
                    active ? 'bg-gray-50 text-gray-900' : 'text-gray-700'
                  ]"
                >
                  Déconnexion
                </button>
              </MenuItem>
            </MenuItems>
          </Menu>
        </div>
      </div>
    </header>

    <!-- Main -->
    <main class="py-8">
      <slot />
    </main>
  </div>
</template>

<script setup lang="ts">
import { Menu, MenuButton, MenuItems, MenuItem } from '@headlessui/vue'
import { ChevronDownIcon } from '@heroicons/vue/24/outline'
import { useAuthStore } from '~/stores/auth'
import Avatar from '~/components/shared/Avatar.vue'

const authStore = useAuthStore()
const router = useRouter()
const user = computed(() => authStore.user)

const logout = async () => {
  await authStore.logout()
  router.push('/login')
}
</script> 