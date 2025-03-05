<template>
  <nav class="fixed top-0 left-0 right-0 h-16 bg-white border-b border-gray-200 z-50">
    <div class="max-w-7xl mx-auto px-4 h-full flex items-center justify-between">
      <!-- Logo -->
      <NuxtLink to="/" class="text-xl font-bold text-primary-600">
        <Logo class="h-8 w-auto" />
    </NuxtLink>

      <!-- Navigation principale -->
      <div class="hidden md:flex items-center gap-6">
        <NuxtLink 
          to="/experts"
          class="text-gray-600 hover:text-gray-900 transition-colors"
        >
          Experts
        </NuxtLink>
        <NuxtLink 
          to="/requests"
          class="text-gray-600 hover:text-gray-900 transition-colors"
        >
          Demandes
        </NuxtLink>
      </div>

      <!-- Actions -->
      <div class="flex items-center gap-4">
        <template v-if="!user">
          <NuxtLink 
            to="/auth/login"
            class="px-4 py-2 text-gray-600 hover:text-gray-900 transition-colors"
          >
            Connexion
          </NuxtLink>
          <NuxtLink 
            to="/auth/register"
            class="px-4 py-2 bg-primary-600 text-white rounded-lg hover:bg-primary-700 transition-colors"
          >
            Inscription
          </NuxtLink>
        </template>
        
        <!-- Menu utilisateur -->
        <Menu v-else as="div" class="relative">
          <MenuButton class="w-10 h-10 rounded-full overflow-hidden">
            <img 
              :src="user.avatar" 
              :alt="user.name"
              class="w-full h-full object-cover"
            />
          </MenuButton>

          <MenuItems class="absolute right-0 mt-2 w-48 bg-white rounded-xl shadow-lg border border-gray-200">
            <MenuItem v-slot="{ active }">
              <NuxtLink 
                to="/profile"
                :class="[
                  active ? 'bg-gray-50' : '',
                  'block px-4 py-2 text-gray-700'
                ]"
              >
                Mon profil
              </NuxtLink>
            </MenuItem>
            <MenuItem v-slot="{ active }">
              <button
                @click="logout"
                :class="[
                  active ? 'bg-gray-50' : '',
                  'block w-full text-left px-4 py-2 text-gray-700'
                ]"
              >
                Déconnexion
              </button>
            </MenuItem>
          </MenuItems>
        </Menu>
      </div>
    </div>
  </nav>
</template>

<script setup>
import { Menu, MenuButton, MenuItems, MenuItem } from '@headlessui/vue'
import Logo from '~/components/shared/Logo.vue'
// État utilisateur (à connecter avec votre système d'auth)
const user = ref(null)

const logout = () => {
  // Logique de déconnexion
}
</script> 