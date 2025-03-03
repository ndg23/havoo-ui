<template>
  <nav class="fixed w-full top-0 z-50 bg-white border-b border-gray-100">
    <div class="max-w-7xl mx-auto px-4 sm:px-6">
      <div class="flex h-20 items-center justify-between">
        <!-- Logo with Softer Style -->
        <NuxtLink to="/" class="flex-shrink-0 group">
          <div class="flex flex-col">
            <div class="flex items-center gap-3">
              <!-- Logo Canard -->
              <svg class="w-12 h-12" viewBox="0 0 200 200" xmlns="http://www.w3.org/2000/svg">
                <!-- Tête du canard -->
                <circle cx="100" cy="100" r="60" fill="#FFDB99" />
                
                <!-- Bec -->
                <path 
                  d="M85 120 Q100 130 115 120" 
                  fill="#FF9A3C" 
                  stroke="#E87E2C" 
                  stroke-width="2" 
                />
                
                <!-- Yeux -->
                <circle cx="80" cy="90" r="6" fill="#333333" />
                <circle cx="120" cy="90" r="6" fill="#333333" />
                
                <!-- Reflets dans les yeux -->
                <circle cx="78" cy="88" r="2" fill="white" />
                <circle cx="118" cy="88" r="2" fill="white" />
                
                <!-- Toupet -->
                <path 
                  d="M70 70 Q100 55 130 70" 
                  fill="#FFE6B8" 
                  stroke="#FFD280" 
                  stroke-width="2"
                />
              </svg>
              
              <!-- Text with Warmer Colors -->
              <div class="flex flex-col">
                <span class="text-3xl font-bold tracking-tight flex items-baseline">
                  <span class="text-orange-400">KI</span>
                  <span class="text-orange-500">LOU</span>
                </span>
                <span class="text-xs text-gray-500 ml-1">Louez. Partagez. Économisez.</span>
              </div>
            </div>
          </div>
        </NuxtLink>

        <!-- Navigation Principale - Style Leboncoin -->
        <!-- <div class="hidden lg:flex items-center space-x-4">
          <NuxtLink
            v-for="item in menuItems"
            :key="item.path"
            :to="item.path"
            class="px-4 py-2.5 text-sm font-medium rounded-full transition-colors flex items-center gap-2.5"
            :class="[
              isCurrentRoute(item.path)
                ? 'bg-orange-50 text-orange-600 shadow-sm'
                : 'text-gray-600 hover:bg-gray-50'
            ]"
          >
            <component :is="item.icon" class="w-5 h-5" :class="isCurrentRoute(item.path) ? 'text-orange-500' : 'text-gray-400'" />
            {{ item.name }}
            <span 
              v-if="item.badge" 
              class="flex h-5 w-5 items-center justify-center rounded-full bg-orange-500 text-xs text-white"
            >
              {{ item.badge }}
            </span>
          </NuxtLink>
        </div> -->

        <!-- Actions - Style Leboncoin -->
        <div class="flex items-center gap-6">
          <!-- Bouton Déposer - Style Leboncoin -->
          <NuxtLink
            to="/user/items/new"
            class="hidden md:flex items-center gap-2 px-6 py-2.5 bg-orange-500 text-white 
                  rounded-full hover:bg-orange-600 transition-colors text-sm font-medium shadow-sm"
          >
            <PlusIcon class="w-5 h-5" />
            <span>Partager un objet</span>
          </NuxtLink>

          <!-- Notifications - Style plus doux -->
          <div class="relative" v-click-outside="closeNotifications">
            <!-- <button 
              @click="toggleNotifications"
              class="p-2.5 rounded-full bg-gray-50 hover:bg-gray-100 text-gray-600 transition-colors relative"
              :class="{ 'bg-orange-50 text-orange-500': isNotificationsOpen || notifications.some(n => !n.read) }"
            >
              <BellIcon class="w-6 h-6" />
              <span 
                v-if="notifications.some(n => !n.read)"
                class="absolute -top-1 -right-1 w-5 h-5 bg-orange-500 text-white text-xs 
                      flex items-center justify-center rounded-full"
              >
                {{ notifications.filter(n => !n.read).length }}
              </span>
            </button> -->

            <!-- Dropdown Notifications - Style Leboncoin -->
            <div
              v-if="isNotificationsOpen"
              class="absolute right-0 mt-2 w-80 bg-white rounded-xl shadow-lg border border-gray-100 py-2 z-50"
            >
              <div class="px-4 py-2 border-b border-gray-100">
                <div class="flex items-center justify-between">
                  <h3 class="font-medium text-gray-700">Notifications</h3>
                  <button 
                    v-if="notifications.some(n => !n.read)"
                    @click="markAllAsRead"
                    class="text-sm text-orange-500 hover:text-orange-600 transition-colors"
                  >
                    Tout marquer comme lu
                  </button>
                </div>
              </div>

              <div class="max-h-96 overflow-y-auto scrollbar-hide">
                <div 
                  v-if="notifications.length === 0" 
                  class="px-4 py-8 text-center text-gray-500"
                >
                  <div class="flex flex-col items-center gap-3">
                    <div class="w-16 h-16 rounded-full bg-gray-100 flex items-center justify-center">
                      <BellIcon class="w-8 h-8 text-gray-300" />
                    </div>
                    <p>Aucune notification</p>
                  </div>
                </div>
                
                <template v-else>
                  <div
                    v-for="notification in notifications"
                    :key="notification.id"
                    class="px-4 py-3 hover:bg-gray-50 transition-all cursor-pointer flex gap-3 items-center"
                    :class="{ 
                      'bg-orange-50': !notification.read
                    }"
                    @click="readNotification(notification.id)"
                  >
                    <div class="w-10 h-10 rounded-full flex items-center justify-center" :class="`bg-${getNotificationColor(notification.type)}-100`">
                      <component :is="getNotificationIcon(notification.type)" class="w-5 h-5" :class="`text-${getNotificationColor(notification.type)}-500`" />
                    </div>
                    <div class="flex-1">
                      <p class="text-gray-800">{{ notification.message }}</p>
                      <p class="text-xs text-gray-500 mt-1">{{ formatDate(notification.date) }}</p>
                    </div>
                    <div v-if="!notification.read" class="w-2 h-2 rounded-full bg-orange-500"></div>
                  </div>
                </template>
              </div>
            </div>
          </div>

          <!-- Menu Utilisateur - Style Leboncoin -->
          <Menu as="div" class="relative">
            <MenuButton 
              class="flex items-center gap-3 rounded-full transition-colors"
            >
              <img
                :src="userStore.user?.avatar || '/default-avatar.png'"
                alt="Avatar"
                class="w-10 h-10 rounded-full object-cover border-2 border-white"
              />
              <div class="flex flex-col items-start -mt-0.5 mr-1 hidden md:flex">
                <span class="text-sm font-medium text-gray-700">{{ userStore.user?.name || 'Bonjour' }}</span>
                <span class="text-xs text-gray-500">Mon compte</span>
              </div>
              <ChevronDownIcon 
                class="w-4 h-4 text-gray-400 transition-transform duration-300"
              />
            </MenuButton>

            <!-- Dropdown Utilisateur - Style Leboncoin -->
            <MenuItems
              class="absolute right-0 mt-2 w-72 bg-white rounded-xl shadow-lg border border-gray-100 overflow-hidden z-50"
            >
              <div class="p-5 border-b border-gray-100 bg-orange-50">
                <div class="flex items-center gap-3">
                  <img
                    :src="userStore.user?.avatar || '/default-avatar.png'"
                    alt="Avatar"
                    class="w-14 h-14 rounded-full object-cover border-2 border-white"
                  />
                  <div>
                    <p class="font-medium text-gray-800">{{ userStore.user?.name }}</p>
                    <p class="text-sm text-gray-500 truncate">{{ userStore.user?.email }}</p>
                  </div>
                </div>
              </div>
              
              <div class="py-2">
                <MenuItem v-slot="{ active }">
                  <NuxtLink 
                    to="/profile/rentals"
                    :class="[
                      'block px-4 py-2 text-sm',
                      active ? 'bg-gray-50 text-gray-900' : 'text-gray-700'
                    ]"
                  >
                    Mes locations
                  </NuxtLink>
                </MenuItem>
                <MenuItem v-slot="{ active }">
                  <NuxtLink 
                    to="/profile/items"
                    :class="[
                      'block px-4 py-2 text-sm',
                      active ? 'bg-gray-50 text-gray-900' : 'text-gray-700'
                    ]"
                  >
                    Mes objets
                  </NuxtLink>
                </MenuItem>
                <MenuItem v-slot="{ active }">
                  <NuxtLink 
                    to="/favorites"
                    :class="[
                      'block px-4 py-2 text-sm',
                      active ? 'bg-gray-50 text-gray-900' : 'text-gray-700'
                    ]"
                  >
                    Favoris
                  </NuxtLink>
                </MenuItem>
                <div class="border-t border-gray-100" />
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
                    @click="handleLogout"
                    :class="[
                      'block w-full text-left px-4 py-2 text-sm',
                      active ? 'bg-gray-50 text-gray-900' : 'text-gray-700'
                    ]"
                  >
                    Déconnexion
                  </button>
                </MenuItem>
              </div>
            </MenuItems>
          </Menu>
        </div>
      </div>
    </div>
    
    <!-- Mobile Navigation - Style Leboncoin -->
    <div class="block lg:hidden border-t border-gray-100">
      <div class="flex justify-between px-2">
        <NuxtLink
          v-for="item in mobileMenuItems"
          :key="item.path"
          :to="item.path"
          class="flex flex-col items-center py-2 px-3 text-sm font-medium"
          :class="[
            isCurrentRoute(item.path)
              ? 'text-orange-500'
              : 'text-gray-500'
          ]"
        >
          <component :is="item.icon" class="w-6 h-6 mb-1" />
          <span>{{ item.name }}</span>
          <span 
            v-if="item.badge" 
            class="absolute top-1 right-1 flex h-4 w-4 items-center justify-center rounded-full bg-orange-500 text-xs text-white"
          >
            {{ item.badge }}
          </span>
        </NuxtLink>
      </div>
    </div>
  </nav>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { 
  BellIcon, 
  ChevronDownIcon,
  UserIcon,
  Cog6ToothIcon as SettingsIcon,
  HeartIcon,
  ArrowRightOnRectangleIcon,
  PlusIcon,
  ShoppingBagIcon,
  HomeIcon,
  CalendarIcon,
  ChatBubbleLeftIcon
} from '@heroicons/vue/24/outline'
import { useRoute } from 'vue-router'
import { useUserStore } from '~/stores/user'
import { Menu, MenuButton, MenuItems, MenuItem } from '@headlessui/vue'

const userStore = useUserStore()
const route = useRoute()

const isNotificationsOpen = ref(false)

// Menu items with icons
const menuItems = [
  { 
    name: 'Explorer', 
    path: '/user/items', 
    icon: HomeIcon
  },
  { 
    name: 'Mes objets', 
    path: '/user/my-items', 
    icon: ShoppingBagIcon
  },
  { 
    name: 'Locations', 
    path: '/user/rentals', 
    icon: CalendarIcon
  },
  { 
    name: 'Messages', 
    path: '/user/messages', 
    icon: ChatBubbleLeftIcon,
    badge: 3
  }
]

// Mobile menu items
const mobileMenuItems = [
  { 
    name: 'Explorer', 
    path: '/user/items', 
    icon: HomeIcon
  },
  { 
    name: 'Publier', 
    path: '/user/items/new', 
    icon: PlusIcon
  },
  { 
    name: 'Messages', 
    path: '/user/messages', 
    icon: ChatBubbleLeftIcon,
    badge: 3
  },
  { 
    name: 'Compte', 
    path: '/user/profile', 
    icon: UserIcon
  }
]

// Sample notifications
const notifications = ref([
  {
    id: 1,
    type: 'rental',
    message: 'Nouvelle demande de location pour votre perceuse',
    date: new Date(),
    read: false
  },
  {
    id: 2,
    type: 'message',
    message: 'Nouveau message de Jean D.',
    date: new Date(Date.now() - 3600000),
    read: true
  }
])

// Utility functions
const isCurrentRoute = (path: string) => route.path === path

const formatDate = (date: Date) => {
  return new Intl.RelativeTimeFormat('fr', { numeric: 'auto' })
    .format(-Math.round((Date.now() - date.getTime()) / 3600000), 'hour')
}

const getNotificationIcon = (type: string) => {
  const icons = {
    rental: CalendarIcon,
    message: ChatBubbleLeftIcon,
    default: BellIcon
  }
  return icons[type as keyof typeof icons] || icons.default
}

const getNotificationColor = (type: string) => {
  const colors = {
    rental: 'orange',
    message: 'blue',
    default: 'gray'
  }
  return colors[type as keyof typeof colors] || colors.default
}

// Event handlers
const toggleNotifications = () => {
  isNotificationsOpen.value = !isNotificationsOpen.value
}

const closeNotifications = () => {
  isNotificationsOpen.value = false
}

const markAllAsRead = () => {
  notifications.value = notifications.value.map(n => ({ ...n, read: true }))
}

const readNotification = (id: number) => {
  const notification = notifications.value.find(n => n.id === id)
  if (notification) notification.read = true
}

const handleLogout = async () => {
  await userStore.logout()
  navigateTo('/login')
}
</script>

<style scoped>
.scrollbar-hide {
  -ms-overflow-style: none;
  scrollbar-width: none;
}

.scrollbar-hide::-webkit-scrollbar {
  display: none;
}
</style>