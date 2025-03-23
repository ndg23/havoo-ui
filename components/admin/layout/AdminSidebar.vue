<template>
  <aside class="w-64 bg-gray-800 min-h-screen">
    <div class="px-4 py-6">
      <h2 class="text-lg font-semibold text-white">Admin Dashboard</h2>
    </div>
    <nav class="mt-6">
      <div class="px-4 space-y-2">
        <NuxtLink
          v-for="item in menuItems"
          :key="item.path"
          :to="item.path"
          class="flex items-center px-4 py-2 text-gray-300 hover:bg-gray-700 rounded-lg"
          :class="{ 'bg-gray-700': isCurrentPath(item.path) }"
        >
          <component :is="item.icon" class="w-5 h-5 mr-3" />
          {{ item.name }}
        </NuxtLink>
      </div>
    </nav>
  </aside>
</template>

<script setup lang="ts">
const menuItems = [
  { name: 'Dashboard', path: '/admin', icon: 'HomeIcon' },
  { name: 'Utilisateurs', path: '/admin/users', icon: 'UsersIcon' },
  { name: 'Objets', path: '/admin/items', icon: 'CubeIcon' },
  { name: 'Activités', path: '/admin/activities', icon: 'ActivityIcon' },
  { name: 'Paramètres', path: '/admin/settings', icon: 'CogIcon' }
]

const route = useRoute()

const isCurrentPath = (path: string) => {
  return route.path === path
}
</script> 