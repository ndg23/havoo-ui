<template>
  <nav class="bg-white shadow">
    <div class="px-4 h-16 flex justify-between items-center">
      <!-- Titre de la page -->
      <h1 class="text-xl font-semibold text-gray-800">
        {{ currentPageTitle }}
      </h1>

      <!-- Menu utilisateur -->
      <div class="flex items-center space-x-4">
        <div class="relative">
          <button
            @click="showUserMenu = !showUserMenu"
            class="flex items-center space-x-2 text-gray-700 hover:text-gray-900"
          >
            <img
              :src="userStore.user?.avatar || '/default-avatar.png'"
              alt="Avatar"
              class="w-8 h-8 rounded-full"
            />
            <span>{{ userStore.user?.name }}</span>
            <ChevronDownIcon class="w-4 h-4" />
          </button>

          <!-- Menu déroulant -->
          <div
            v-if="showUserMenu"
            class="absolute right-0 mt-2 w-48 bg-white rounded-lg shadow-lg py-1"
          >
            <NuxtLink
              to="/admin/profile"
              class="block px-4 py-2 text-gray-700 hover:bg-gray-100"
            >
              Profil
            </NuxtLink>
            <button
              @click="handleLogout"
              class="block w-full text-left px-4 py-2 text-gray-700 hover:bg-gray-100"
            >
              Déconnexion
            </button>
          </div>
        </div>
      </div>
    </div>
  </nav>
</template>

<script setup lang="ts">
const userStore = useUserStore()
const route = useRoute()
const showUserMenu = ref(false)

// Titre de la page selon la route
const currentPageTitle = computed(() => {
  switch (route.path) {
    case '/admin': return 'Tableau de bord'
    case '/admin/users': return 'Gestion des utilisateurs'
    case '/admin/items': return 'Gestion des objets'
    case '/admin/settings': return 'Paramètres'
    default: return 'Administration'
  }
})

const handleLogout = async () => {
  await userStore.logout()
  navigateTo('/login')
}

// Fermer le menu au clic à l'extérieur
onClickOutside(showUserMenu, () => {
  showUserMenu.value = false
})
</script> 