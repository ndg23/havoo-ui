<template>
  <div class="space-y-6">
    <!-- Header avec recherche -->
    <div class="flex items-center justify-between">
      <div class="relative w-96">
        <MagnifyingGlassIcon class="w-5 h-5 text-gray-400 absolute left-3 top-1/2 -translate-y-1/2" />
        <input 
          v-model="searchQuery"
          type="text"
          placeholder="Rechercher un utilisateur..."
          class="w-full pl-10 pr-4 py-2 rounded-xl border border-gray-200 focus:ring-primary-500 focus:border-primary-500"
        />
      </div>
      <div class="flex items-center gap-3">
        <select 
          v-model="roleFilter"
          class="px-4 py-2 rounded-xl border border-gray-200 focus:ring-primary-500 focus:border-primary-500"
        >
          <option value="">Tous les rôles</option>
          <option value="client">Clients</option>
          <option value="expert">Experts</option>
        </select>
      </div>
    </div>

    <!-- Table des utilisateurs -->
    <div class="bg-white rounded-xl border border-gray-200 overflow-hidden">
      <div class="overflow-x-auto">
        <table class="w-full">
          <thead class="bg-gray-50 border-b border-gray-200">
            <tr>
              <th class="px-6 py-4 text-left text-sm font-medium text-gray-500">Utilisateur</th>
              <th class="px-6 py-4 text-left text-sm font-medium text-gray-500">Rôle</th>
              <th class="px-6 py-4 text-left text-sm font-medium text-gray-500">Ville</th>
              <th class="px-6 py-4 text-left text-sm font-medium text-gray-500">Date d'inscription</th>
              <th class="px-6 py-4 text-left text-sm font-medium text-gray-500">Statut</th>
              <th class="px-6 py-4 text-right text-sm font-medium text-gray-500">Actions</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-gray-200">
            <tr v-for="user in filteredUsers" :key="user.id" class="hover:bg-gray-50">
              <td class="px-6 py-4 whitespace-nowrap">
                <div class="flex items-center gap-3">
                  <img 
                    :src="user.avatar_url || `https://ui-avatars.com/api/?name=${user.first_name}+${user.last_name}`"
                    class="w-8 h-8 rounded-full"
                  />
                  <div>
                    <div class="font-medium text-gray-900">
                      {{ user.first_name }} {{ user.last_name }}
                    </div>
                    <div class="text-sm text-gray-500">{{ user.email }}</div>
                  </div>
                </div>
              </td>
              <td class="px-6 py-4 whitespace-nowrap">
                <span 
                  class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium"
                  :class="{
                    'bg-blue-100 text-blue-800': user.role === 'client',
                    'bg-purple-100 text-purple-800': user.role === 'expert',
                    'bg-gray-100 text-gray-800': user.role === 'admin'
                  }"
                >
                  {{ user.role }}
                </span>
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                {{ user.city || '-' }}
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                {{ formatDate(user.created_at) }}
              </td>
              <td class="px-6 py-4 whitespace-nowrap">
                <span 
                  class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium"
                  :class="{
                    'bg-green-100 text-green-800': user.status === 'active',
                    'bg-yellow-100 text-yellow-800': user.status === 'pending',
                    'bg-red-100 text-red-800': user.status === 'suspended'
                  }"
                >
                  {{ user.status }}
                </span>
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-right text-sm">
                <Menu as="div" class="relative inline-block text-left">
                  <MenuButton class="p-2 rounded-lg hover:bg-gray-50">
                    <EllipsisVerticalIcon class="w-5 h-5 text-gray-400" />
                  </MenuButton>
                  <MenuItems class="absolute right-0 mt-2 w-48 bg-white rounded-lg shadow-lg py-1 border border-gray-200">
                    <MenuItem v-slot="{ active }">
                      <button
                        class="flex w-full items-center px-4 py-2 text-sm text-gray-700 hover:bg-gray-50"
                        @click="viewUser(user)"
                      >
                        <EyeIcon class="w-4 h-4 mr-3" />
                        Voir le profil
                      </button>
                    </MenuItem>
                    <MenuItem v-slot="{ active }">
                      <button
                        class="flex w-full items-center px-4 py-2 text-sm text-gray-700 hover:bg-gray-50"
                        @click="editUser(user)"
                      >
                        <PencilIcon class="w-4 h-4 mr-3" />
                        Modifier
                      </button>
                    </MenuItem>
                    <MenuItem v-slot="{ active }">
                      <button
                        class="flex w-full items-center px-4 py-2 text-sm text-red-600 hover:bg-red-50"
                        @click="confirmDelete(user)"
                      >
                        <TrashIcon class="w-4 h-4 mr-3" />
                        Supprimer
                      </button>
                    </MenuItem>
                  </MenuItems>
                </Menu>
              </td>
            </tr>
          </tbody>
        </table>
      </div>

      <!-- Pagination -->
      <div class="flex items-center justify-between px-6 py-4 border-t border-gray-200">
        <div class="text-sm text-gray-500">
          Affichage de {{ startIndex + 1 }}-{{ endIndex }} sur {{ totalUsers }} utilisateurs
        </div>
        <div class="flex items-center gap-2">
          <button
            class="px-3 py-1 rounded-lg border border-gray-200 text-sm font-medium text-gray-600 hover:bg-gray-50 disabled:opacity-50"
            :disabled="currentPage === 1"
            @click="currentPage--"
          >
            Précédent
          </button>
          <button
            class="px-3 py-1 rounded-lg border border-gray-200 text-sm font-medium text-gray-600 hover:bg-gray-50 disabled:opacity-50"
            :disabled="endIndex >= totalUsers"
            @click="currentPage++"
          >
            Suivant
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { Menu, MenuButton, MenuItems, MenuItem } from '@headlessui/vue'
import { 
  MagnifyingGlassIcon,
  EllipsisVerticalIcon,
  EyeIcon,
  PencilIcon,
  TrashIcon
} from '@heroicons/vue/24/outline'

// État
const searchQuery = ref('')
const roleFilter = ref('')
const currentPage = ref(1)
const perPage = 10

// Données simulées (à remplacer par l'appel API)
const users = ref([
  {
    id: 1,
    first_name: 'John',
    last_name: 'Doe',
    email: 'john@example.com',
    role: 'client',
    city: 'Cotonou',
    status: 'active',
    created_at: '2024-01-15T10:00:00Z'
  },
  // ... autres utilisateurs
])

// Filtrage et pagination
const filteredUsers = computed(() => {
  let filtered = users.value

  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase()
    filtered = filtered.filter(user => 
      user.first_name.toLowerCase().includes(query) ||
      user.last_name.toLowerCase().includes(query) ||
      user.email.toLowerCase().includes(query)
    )
  }

  if (roleFilter.value) {
    filtered = filtered.filter(user => user.role === roleFilter.value)
  }

  return filtered
})

const totalUsers = computed(() => filteredUsers.value.length)
const startIndex = computed(() => (currentPage.value - 1) * perPage)
const endIndex = computed(() => Math.min(startIndex.value + perPage, totalUsers.value))

// Formatage de date
const formatDate = (date) => {
  return new Date(date).toLocaleDateString('fr-FR', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  })
}

// Actions
const viewUser = (user) => {
  // Implémenter la vue détaillée
  console.log('View user:', user)
}

const editUser = (user) => {
  // Implémenter l'édition
  console.log('Edit user:', user)
}

const confirmDelete = (user) => {
  // Implémenter la suppression avec confirmation
  console.log('Delete user:', user)
}

definePageMeta({
  layout: 'admin'
})
</script> 