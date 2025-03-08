<template>
  <Menu as="div" class="relative">
    <MenuButton class="flex items-center gap-3 p-2 rounded-xl hover:bg-gray-50 dark:hover:bg-gray-800/60 transition-colors">
      <!-- Avatar -->
      <div class="relative h-10 w-10 rounded-xl bg-gray-100 dark:bg-gray-800 overflow-hidden flex-shrink-0">
        <img 
          v-if="user?.avatar_url" 
          :src="user.avatar_url" 
          alt="Avatar"
          class="h-full w-full object-cover"
        />
        <User v-else class="h-5 w-5 text-gray-400 m-2.5" />
      </div>
      
      <!-- User info -->
      <div class="hidden md:block text-left">
        <div class="font-medium text-gray-900 dark:text-white">
          {{ user?.first_name || 'Mon profil' }}
        </div>
        <div class="text-sm text-gray-500 dark:text-gray-400">
          {{ user?.email }}
        </div>
      </div>
      
      <ChevronDown class="h-5 w-5 text-gray-400" />
    </MenuButton>

    <transition
      enter-active-class="transition duration-100 ease-out"
      enter-from-class="transform scale-95 opacity-0"
      enter-to-class="transform scale-100 opacity-100"
      leave-active-class="transition duration-75 ease-in"
      leave-from-class="transform scale-100 opacity-100"
      leave-to-class="transform scale-95 opacity-0"
    >
      <MenuItems class="absolute right-0 mt-2 w-72 bg-white dark:bg-gray-800 rounded-xl shadow-lg border border-gray-200 dark:border-gray-700 overflow-hidden z-50">
        <!-- Profile header -->
        <div class="p-4 border-b border-gray-100 dark:border-gray-700">
          <div class="font-medium text-gray-900 dark:text-white">
            {{ user?.first_name }} {{ user?.last_name }}
          </div>
          <div class="text-sm text-gray-500 dark:text-gray-400 truncate">
            {{ user?.email }}
          </div>
        </div>

        <!-- Menu sections -->
        <div class="py-2">
          <!-- Profile section -->
          <div>
            <MenuItem v-slot="{ active }">
              <NuxtLink 
                to="/account" 
                :class="[
                  active ? 'bg-gray-50 dark:bg-gray-700/50' : '',
                  'flex items-center px-4 py-3 text-sm text-gray-700 dark:text-gray-200'
                ]"
              >
                <User class="h-5 w-5 mr-3 text-gray-400" />
                Mon profil
              </NuxtLink>
            </MenuItem>
          </div>

          <!-- Activity section -->
          <div>
            <div class="px-4 py-2 text-xs font-semibold text-gray-400 dark:text-gray-500 uppercase tracking-wider">
              Activité
            </div>
            <MenuItem v-slot="{ active }">
              <NuxtLink 
                to="/account/my-demands" 
                :class="[
                  active ? 'bg-gray-50 dark:bg-gray-700/50' : '',
                  'flex items-center px-4 py-3 text-sm text-gray-700 dark:text-gray-200'
                ]"
              >
                <FileText class="h-5 w-5 mr-3 text-gray-400" />
                Mes demandes
                <span class="ml-auto bg-primary-50 text-primary-600 text-xs font-medium px-2 py-0.5 rounded-full">
                  {{ demandsCount }}
                </span>
              </NuxtLink>
            </MenuItem>
            <MenuItem v-slot="{ active }">
              <NuxtLink 
                to="/account/my-proposals" 
                :class="[
                  active ? 'bg-gray-50 dark:bg-gray-700/50' : '',
                  'flex items-center px-4 py-3 text-sm text-gray-700 dark:text-gray-200'
                ]"
              >
                <MessageSquare class="h-5 w-5 mr-3 text-gray-400" />
                Mes propositions
                <span class="ml-auto bg-primary-50 text-primary-600 text-xs font-medium px-2 py-0.5 rounded-full">
                  {{ proposalsCount }}
                </span>
              </NuxtLink>
            </MenuItem>
          </div>

          <!-- Settings section -->
          <div>
            <div class="px-4 py-2 text-xs font-semibold text-gray-400 dark:text-gray-500 uppercase tracking-wider">
              Paramètres
            </div>
            <MenuItem v-slot="{ active }">
              <NuxtLink 
                to="/account/settings" 
                :class="[
                  active ? 'bg-gray-50 dark:bg-gray-700/50' : '',
                  'flex items-center px-4 py-3 text-sm text-gray-700 dark:text-gray-200'
                ]"
              >
                <Settings class="h-5 w-5 mr-3 text-gray-400" />
                Paramètres
              </NuxtLink>
            </MenuItem>
            <MenuItem v-slot="{ active }">
              <button
                @click="logout"
                :class="[
                  active ? 'bg-gray-50 dark:bg-gray-700/50' : '',
                  'flex items-center px-4 py-3 text-sm text-red-600 dark:text-red-400 w-full'
                ]"
              >
                <LogOut class="h-5 w-5 mr-3" />
                Déconnexion
              </button>
            </MenuItem>
          </div>
        </div>
      </MenuItems>
    </transition>
  </Menu>
</template>

<script setup>
import { Menu, MenuButton, MenuItems, MenuItem } from '@headlessui/vue'
import { 
  User, ChevronDown, FileText, MessageSquare, 
  Settings, LogOut 
} from 'lucide-vue-next'
import { useRouter } from 'vue-router'
import { useSupabaseClient } from '#imports'

const props = defineProps({
  user: {
    type: Object,
    required: true
  },
  demandsCount: {
    type: Number,
    default: 0
  },
  proposalsCount: {
    type: Number,
    default: 0
  }
})

const router = useRouter()
const client = useSupabaseClient()

const logout = async () => {
  try {
    await client.auth.signOut()
    router.push('/')
  } catch (error) {
    console.error('Erreur lors de la déconnexion:', error)
  }
}
</script> 