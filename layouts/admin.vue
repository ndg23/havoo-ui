<template>
  <div class="min-h-screen bg-white">
    <!-- Sidebar Twitter-style -->
    <div class="fixed inset-y-0 left-0 w-[275px] border-r border-gray-100">
      <div class="flex flex-col h-full px-3">
        <!-- Logo -->
        <div class="flex-shrink-0 h-16 flex items-center">
          <NuxtLink to="/admin" class="px-3">
            Havoo Services
          </NuxtLink>
        </div>

        <!-- Navigation principale -->
        <nav class="flex-1 mt-2">
          <div class="space-y-1">
            <NuxtLink
              v-for="item in navigation"
              :key="item.path"
              :to="item.path"
              class="group flex items-center gap-5 px-3 py-3 text-[15px] font-medium rounded-full transition-colors"
              :class="[
                isActive(item.path)
                  ? 'text-indigo-600 bg-indigo-50 font-semibold'
                  : 'text-gray-900 hover:bg-gray-50'
              ]"
            >
              <component 
                :is="item.icon" 
                class="w-6 h-6"
                :class="[
                  isActive(item.path)
                    ? 'text-indigo-600'
                    : 'text-gray-800'
                ]"
              />
              {{ item.name }}
            </NuxtLink>
          </div>
        </nav>

        <!-- User Menu -->
        <div class="flex-shrink-0 py-4">
          <Menu as="div" class="relative">
            <MenuButton class="flex items-center w-full gap-3 p-3 rounded-full hover:bg-gray-50 transition-colors">
              <img 
                :src="user?.avatar || '/images/default-avatar.png'"
                class="w-10 h-10 rounded-full object-cover"
                alt=""
              />
              <div class="flex-1 text-left">
                <p class="text-sm font-semibold text-gray-900 leading-tight">
                  {{ user?.name || 'Administrateur' }}
                </p>
                <p class="text-sm text-gray-500 truncate">
                  {{ user?.email }}
                </p>
              </div>
              <EllipsisHorizontalIcon class="w-5 h-5 text-gray-500" />
            </MenuButton>

            <transition
              enter-active-class="transition duration-100 ease-out"
              enter-from-class="transform scale-95 opacity-0"
              enter-to-class="transform scale-100 opacity-100"
              leave-active-class="transition duration-75 ease-in"
              leave-from-class="transform scale-100 opacity-100"
              leave-to-class="transform scale-95 opacity-0"
            >
              <MenuItems class="absolute left-0 bottom-full mb-2 w-full bg-white rounded-2xl -shadow-lg border focus:outline-none">
                <div class="py-1">
                  <MenuItem v-slot="{ active }">
                    <button
                      @click="logout"
                      :class="[
                        active ? 'bg-gray-50' : '',
                        'block w-full text-left px-4 py-2 text-sm text-red-600'
                      ]"
                    >
                      Déconnexion
                    </button>
                  </MenuItem>
                </div>
              </MenuItems>
            </transition>
          </Menu>
        </div>
      </div>
    </div>

    <!-- Main content -->
    <main class="pl-[275px] border-l border-gray-100">
      <!-- Header avec recherche et notifications -->
      <div class="sticky top-0 z-40 bg-white/80 backdrop-blur-md border-b border-gray-100">
        <div class="flex items-center justify-between h-16 px-4">
          <div class="w-72">
            <div class="relative">
              <input 
                type="text"
                placeholder="Rechercher..."
                class="w-full pl-10 pr-4 py-2 text-sm bg-gray-100 border-none rounded-full focus:outline-none focus:ring-2 focus:ring-indigo-500/20 focus:bg-white"
              />
              <MagnifyingGlassIcon class="w-5 h-5 text-gray-500 absolute left-3 top-1/2 -translate-y-1/2" />
            </div>
          </div>

          <!-- Notifications -->
          <Menu as="div" class="relative">
            <MenuButton class="relative p-2 text-gray-700 hover:text-indigo-500 transition-colors">
              <BellIcon class="w-6 h-6" />
              <span 
                v-if="unreadNotifications"
                class="absolute top-1 right-1 w-2 h-2 bg-indigo-500 rounded-full ring-2 ring-white"
              />
            </MenuButton>

            <TransitionRoot
              enter="transition ease-out duration-100"
              enter-from="transform opacity-0 scale-95"
              enter-to="transform opacity-100 scale-100"
              leave="transition ease-in duration-75"
              leave-from="transform opacity-100 scale-100"
              leave-to="transform opacity-0 scale-95"
            >
              <MenuItems class="absolute right-0 mt-2 w-80 bg-white rounded-xl -shadow-lg border border-gray-200 focus:outline-none overflow-hidden">
                <div class="p-4 border-b border-gray-100">
                  <div class="flex items-center justify-between">
                    <h3 class="text-sm font-medium text-gray-900">Notifications</h3>
                    <button class="text-xs text-indigo-500 hover:text-indigo-600">
                      Tout marquer comme lu
                    </button>
                  </div>
                </div>
                <div class="max-h-96 overflow-y-auto">
                  <!-- Notifications list -->
                </div>
              </MenuItems>
            </TransitionRoot>
          </Menu>
        </div>
      </div>

      <div class="py-4 px-4">
        <slot />
      </div>
    </main>
  </div>
</template>

<script setup lang="ts">
import { Menu, MenuButton, MenuItems, MenuItem } from '@headlessui/vue'
import {
  BellIcon,
  HomeIcon,
  UsersIcon,
  CubeIcon,
  ChartBarIcon,
  CogIcon,
  MagnifyingGlassIcon,
  EllipsisHorizontalIcon
} from '@heroicons/vue/24/outline'
import { useRoute } from 'vue-router'
import { useAuthStore } from '~/stores/auth'
import Logo from '~/components/shared/Logo.vue'

const route = useRoute()
const authStore = useAuthStore()

const navigation = [
  { name: 'Tableau de bord', path: '/admin', icon: HomeIcon },
  { name: 'Utilisateurs', path: '/admin/users', icon: UsersIcon },
  { name: 'Objets', path: '/admin/items', icon: CubeIcon },
  { name: 'Statistiques', path: '/admin/analytics', icon: ChartBarIcon },
  { name: 'Paramètres', path: '/admin/settings', icon: CogIcon }
]

const user = computed(() => authStore.user)
const unreadNotifications = ref(2)

const isActive = (path: string) => {
  return route.path.startsWith(path)
}

const logout = () => {
  authStore.logout()
}
</script> 