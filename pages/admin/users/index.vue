<template>
    <div class="p-6 max-w-7xl mx-auto">
      <!-- Header with actions -->
      <div class="flex items-center justify-between mb-6">
        <h1 class="text-2xl font-semibold text-gray-900 dark:text-white">Utilisateurs</h1>
        
        <div class="flex space-x-3">
          <button 
            @click="exportUsers"
            class="px-3 py-2 flex items-center text-sm font-medium rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-700 dark:text-gray-200 hover:bg-gray-50 dark:hover:bg-gray-700"
          >
            <Download class="h-4 w-4 mr-2" />
            Exporter
          </button>
          
          <button 
            @click="openUserModal()"
            class="px-3 py-2 flex items-center text-sm font-medium rounded-lg bg-primary-600 text-white hover:bg-primary-700"
          >
            <UserPlus class="h-4 w-4 mr-2" />
            Ajouter un utilisateur
          </button>
        </div>
      </div>
      
      <!-- Filtres et recherche -->
      <div class="bg-white dark:bg-gray-800 rounded-xl shadow-sm mb-6 overflow-hidden">
        <div class="p-5 border-b dark:border-gray-700">
          <h2 class="text-lg font-medium text-gray-900 dark:text-white">Filtres</h2>
        </div>
        
        <div class="p-5 grid grid-cols-1 md:grid-cols-3 gap-4">
          <!-- Recherche -->
            <div>
            <label for="search" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Recherche</label>
            <div class="relative">
              <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                <Search class="h-4 w-4 text-gray-400" />
              </div>
              <input
                id="search"
                v-model="search"
                type="text"
                placeholder="Nom, email..."
                class="block w-full pl-10 pr-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
              />
          </div>
        </div>
        
          <!-- Filtre par rôle -->
            <div>
            <label for="role-filter" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Rôle</label>
            <select
              id="role-filter"
              v-model="roleFilter"
              class="block w-full py-2 pl-3 pr-10 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
            >
              <option value="">Tous les rôles</option>
              <option value="admin">Administrateur</option>
              <option value="expert">Expert</option>
              <option value="client">Client</option>
            </select>
        </div>
        
          <!-- Filtre par statut -->
            <div>
            <label for="status-filter" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Statut</label>
            <select
              id="status-filter"
              v-model="statusFilter"
              class="block w-full py-2 pl-3 pr-10 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
            >
              <option value="">Tous les statuts</option>
              <option value="active">Actif</option>
              <option value="pending">En attente</option>
              <option value="blocked">Bloqué</option>
            </select>
          </div>
        </div>
      </div>
      
      <!-- État de chargement -->
      <div v-if="loading" class="flex justify-center py-20">
        <Loader2 class="h-10 w-10 text-primary-500 animate-spin" />
      </div>
      
      <!-- Table des utilisateurs -->
      <div v-else-if="filteredUsers.length > 0" class="bg-white dark:bg-gray-800 rounded-xl shadow-sm overflow-hidden">
        <!-- Table header -->
        <div class="flex items-center justify-between p-4 border-b dark:border-gray-700">
          <div class="flex items-center">
            <input
              type="checkbox"
              :checked="selectAll"
              @change="toggleSelectAll"
              class="h-4 w-4 text-primary-600 border-gray-300 rounded focus:ring-primary-500"
            />
            <span class="ml-2 text-sm text-gray-700 dark:text-gray-300">
              {{ selectedUsers.length === 0 
                ? 'Sélectionnez des utilisateurs' 
                : `${selectedUsers.length} utilisateur${selectedUsers.length > 1 ? 's' : ''} sélectionné${selectedUsers.length > 1 ? 's' : ''}` 
              }}
            </span>
          </div>
          
          <div v-if="selectedUsers.length > 0" class="flex space-x-2">
            <button 
              @click="bulkActivate"
              class="px-3 py-1.5 text-xs font-medium rounded-lg bg-green-600 text-white hover:bg-green-700"
            >
              Activer
            </button>
            <button 
              @click="bulkVerify"
              class="px-3 py-1.5 text-xs font-medium rounded-lg bg-blue-600 text-white hover:bg-blue-700"
            >
              Vérifier
            </button>
            <button 
              @click="confirmBulkDelete"
              class="px-3 py-1.5 text-xs font-medium rounded-lg bg-red-600 text-white hover:bg-red-700"
            >
              Supprimer
            </button>
        </div>
      </div>
      
        <!-- Table body -->
        <div class="overflow-x-auto">
          <table class="min-w-full divide-y divide-gray-200 dark:divide-gray-700">
            <thead class="bg-gray-50 dark:bg-gray-700">
              <tr>
                <th scope="col" class="pl-4 pr-2 py-3 w-12">
                  <!-- Already have the checkbox above -->
                </th>
                <th scope="col" class="px-4 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                  Utilisateur
                </th>
                <th scope="col" class="px-4 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                  Rôle
                </th>
                <th scope="col" class="px-4 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                  Statut
                </th>
                <th scope="col" class="px-4 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                  Date d'inscription
                </th>
                <th scope="col" class="px-4 py-3 text-center text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                  Actions
                </th>
              </tr>
            </thead>
            <tbody class="bg-white dark:bg-gray-800 divide-y divide-gray-200 dark:divide-gray-700">
              <tr 
                v-for="user in paginatedUsers" 
                :key="user.id"
                class="hover:bg-gray-50 dark:hover:bg-gray-750 transition-colors"
              >
                <td class="pl-4 pr-2 py-4 whitespace-nowrap">
                  <input
                    type="checkbox"
                    :checked="selectedUsers.includes(user.id)"
                    @change="toggleUserSelection(user.id)"
                    class="h-4 w-4 text-primary-600 border-gray-300 rounded focus:ring-primary-500"
                  />
                </td>
                <td class="px-4 py-4 whitespace-nowrap">
          <div class="flex items-center">
                    <NuxtLink :to="`/admin/users/${user.id}`" class="flex items-center group">
                      <div class="h-10 w-10 rounded-full bg-gray-200 dark:bg-gray-700 overflow-hidden mr-3 flex-shrink-0">
              <img 
                          v-if="user.avatar_url" 
                          :src="user.avatar_url" 
                        alt="Avatar"
                        class="h-full w-full object-cover"
                      />
                        <User v-else class="h-5 w-5 text-gray-400 m-2.5" />
                    </div>
                      <div>
                        <div class="font-medium text-gray-900 dark:text-white group-hover:text-primary-600 dark:group-hover:text-primary-400 transition-colors">
                          {{ user.first_name }} {{ user.last_name }}
                    </div>
                        <div class="text-sm text-gray-500 dark:text-gray-400">{{ user.email }}</div>
                  </div>
                    </NuxtLink>
                  </div>
                </td>
                <td class="px-4 py-4 whitespace-nowrap">
                <span 
              class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium"
                    :class="{
                      'bg-blue-100 text-blue-800 dark:bg-blue-900 dark:text-blue-200': user.role === 'admin',
                      'bg-purple-100 text-purple-800 dark:bg-purple-900 dark:text-purple-200': user.role === 'expert',
                      'bg-gray-100 text-gray-800 dark:bg-gray-900 dark:text-gray-200': user.role === 'client'
                    }"
                  >
                    {{ formatRole(user.role) }}
                </span>
                </td>
                <td class="px-4 py-4 whitespace-nowrap">
                <span 
            class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium"
                    :class="{
                      'bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-200': user.status === 'active',
                      'bg-yellow-100 text-yellow-800 dark:bg-yellow-900 dark:text-yellow-200': user.status === 'pending',
                      'bg-red-100 text-red-800 dark:bg-red-900 dark:text-red-200': user.status === 'blocked'
                    }"
                  >
                    <div class="h-1.5 w-1.5 rounded-full mr-1.5"
                      :class="{
                        'bg-green-500': user.status === 'active',
                        'bg-yellow-500': user.status === 'pending',
                        'bg-red-500': user.status === 'blocked'
                      }"
                    ></div>
                    {{ formatStatus(user.status) }}
                </span>
                </td>
                <td class="px-4 py-4 whitespace-nowrap text-sm text-gray-500 dark:text-gray-400">
                  {{ formatDate(user.created_at) }}
                </td>
                <td class="px-4 py-4 whitespace-nowrap text-sm text-center">
                  <div class="flex justify-center space-x-1">
                    <NuxtLink 
                      :to="`/admin/users/${user.id}`"
                      class="p-1.5 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-700 text-gray-500 dark:text-gray-400 hover:text-gray-700 dark:hover:text-gray-300"
                      title="Voir les détails"
          >
            <Eye class="h-4 w-4" />
                    </NuxtLink>
                    
                  <button 
                      @click="editUser(user)"
                      class="p-1.5 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-700 text-gray-500 dark:text-gray-400 hover:text-gray-700 dark:hover:text-gray-300"
                    title="Modifier"
                  >
            <Edit class="h-4 w-4" />
                  </button>
                    
                    <button 
                      v-if="user.status !== 'active'"
                      @click="activateUser(user)"
                      class="p-1.5 rounded-lg hover:bg-green-100 dark:hover:bg-green-900 text-gray-500 dark:text-gray-400 hover:text-green-700 dark:hover:text-green-300"
                      title="Activer"
                    >
                      <CheckCircle class="h-4 w-4" />
                    </button>
                    
                    <button 
                      v-if="user.role === 'expert' && !user.is_verified"
                      @click="verifyUser(user.id, true)"
                      class="p-1.5 rounded-lg hover:bg-blue-100 dark:hover:bg-blue-900 text-gray-500 dark:text-gray-400 hover:text-blue-700 dark:hover:text-blue-300"
                      title="Vérifier"
                    >
                      <BadgeCheck class="h-4 w-4" />
                    </button>
                    
                    <button 
                      v-if="user.status !== 'blocked'"
                      @click="blockUser(user)"
                      class="p-1.5 rounded-lg hover:bg-red-100 dark:hover:bg-red-900 text-gray-500 dark:text-gray-400 hover:text-red-700 dark:hover:text-red-300"
                      title="Bloquer"
                    >
                      <Ban class="h-4 w-4" />
                    </button>
                    
                    <button 
                      @click="confirmDelete(user)"
                      class="p-1.5 rounded-lg hover:bg-red-100 dark:hover:bg-red-900 text-gray-500 dark:text-gray-400 hover:text-red-700 dark:hover:text-red-300"
                      title="Supprimer"
                    >
                      <Trash class="h-4 w-4" />
                    </button>
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
        
        <!-- Pagination -->
        <div class="px-4 py-3 flex items-center justify-between border-t dark:border-gray-700 sm:px-6">
          <div class="hidden sm:flex-1 sm:flex sm:items-center sm:justify-between">
            <div>
              <p class="text-sm text-gray-700 dark:text-gray-300">
                Affichage de <span class="font-medium">{{ (currentPage - 1) * itemsPerPage + 1 }}</span> à <span class="font-medium">{{ Math.min(currentPage * itemsPerPage, filteredUsers.length) }}</span> sur <span class="font-medium">{{ filteredUsers.length }}</span> utilisateurs
              </p>
            </div>
            <div>
              <nav class="relative z-0 inline-flex rounded-md shadow-sm -space-x-px" aria-label="Pagination">
                <button
                  @click="currentPage = 1"
                  :disabled="currentPage === 1"
                  class="relative inline-flex items-center px-2 py-2 rounded-l-md border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-sm font-medium text-gray-500 dark:text-gray-400 hover:bg-gray-50 dark:hover:bg-gray-700 disabled:opacity-50 disabled:cursor-not-allowed"
                >
                  <span class="sr-only">Première</span>
                  <ChevronsLeft class="h-4 w-4" />
                </button>
                <button
                  @click="currentPage--"
                  :disabled="currentPage === 1"
                  class="relative inline-flex items-center px-2 py-2 border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-sm font-medium text-gray-500 dark:text-gray-400 hover:bg-gray-50 dark:hover:bg-gray-700 disabled:opacity-50 disabled:cursor-not-allowed"
                >
                  <span class="sr-only">Précédent</span>
                  <ChevronLeft class="h-4 w-4" />
                </button>
                
                <!-- Pages -->
                <button
                  v-for="page in paginationButtons"
                  :key="page"
                  @click="page !== '...' && (currentPage = page)"
                  :disabled="page === '...'"
                  :class="[
                    'relative inline-flex items-center px-4 py-2 border border-gray-300 dark:border-gray-600 text-sm font-medium',
                    page === currentPage
                      ? 'z-10 bg-primary-50 dark:bg-primary-900 border-primary-500 dark:border-primary-600 text-primary-600 dark:text-primary-400'
                      : 'bg-white dark:bg-gray-800 text-gray-500 dark:text-gray-400 hover:bg-gray-50 dark:hover:bg-gray-700',
                    page === '...' ? 'cursor-default' : ''
                  ]"
                >
                  {{ page }}
                </button>
                
                <button
                  @click="currentPage++"
                  :disabled="currentPage === totalPages"
                  class="relative inline-flex items-center px-2 py-2 border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-sm font-medium text-gray-500 dark:text-gray-400 hover:bg-gray-50 dark:hover:bg-gray-700 disabled:opacity-50 disabled:cursor-not-allowed"
                >
                  <span class="sr-only">Suivant</span>
                  <ChevronRight class="h-4 w-4" />
                </button>
                <button
                  @click="currentPage = totalPages"
                  :disabled="currentPage === totalPages"
                  class="relative inline-flex items-center px-2 py-2 rounded-r-md border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-sm font-medium text-gray-500 dark:text-gray-400 hover:bg-gray-50 dark:hover:bg-gray-700 disabled:opacity-50 disabled:cursor-not-allowed"
                >
                  <span class="sr-only">Dernière</span>
                  <ChevronsRight class="h-4 w-4" />
                </button>
              </nav>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Aucun résultat -->
      <div v-else class="bg-white dark:bg-gray-800 rounded-xl shadow-sm overflow-hidden p-8 text-center">
        <SearchX class="h-12 w-12 text-gray-400 mx-auto mb-4" />
        <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-2">Aucun utilisateur trouvé</h3>
        <p class="text-sm text-gray-500 dark:text-gray-400 max-w-md mx-auto">
          Aucun utilisateur ne correspond à vos critères de recherche. Essayez de modifier vos filtres.
        </p>
        <button 
          @click="resetFilters"
          class="mt-4 px-4 py-2 text-sm font-medium rounded-lg bg-primary-600 text-white hover:bg-primary-700"
        >
          Réinitialiser les filtres
        </button>
      </div>
      
      <!-- Modals -->
      <UserModal 
        :show="showUserModal"
        :user="userToEdit"
        :edit-mode="editMode"
        @close="showUserModal = false"
        @save="saveUser"
      />
      
      <ConfirmModal
        :show="showDeleteModal"
        title="Supprimer l'utilisateur"
        @close="showDeleteModal = false"
        @confirm="deleteUser"
      >
        <template #icon>
          <Trash class="h-5 w-5 text-red-500 mr-2" />
        </template>
        
        <p class="text-gray-700 dark:text-gray-300">
          Êtes-vous sûr de vouloir supprimer cet utilisateur ? Cette action est irréversible et supprimera toutes les données associées.
        </p>
        
        <div v-if="userToDelete" class="mt-4 p-4 bg-gray-50 dark:bg-gray-800 rounded-lg">
          <div class="flex items-center">
            <div class="h-10 w-10 rounded-full bg-gray-200 dark:bg-gray-700 overflow-hidden mr-3">
              <img 
                v-if="userToDelete.avatar_url" 
                :src="userToDelete.avatar_url" 
                alt="Avatar"
                class="h-full w-full object-cover"
              />
              <User v-else class="h-full w-full text-gray-400" />
            </div>
            <div>
              <div class="font-medium text-gray-900 dark:text-white">
                {{ userToDelete.first_name }} {{ userToDelete.last_name }}
              </div>
              <div class="text-sm text-gray-500 dark:text-gray-400">{{ userToDelete.email }}</div>
            </div>
          </div>
        </div>
      </ConfirmModal>
    </div>
  </template>
  
  <script setup>
  import { ref, computed, watch, onMounted } from 'vue'
  import { useRouter } from 'vue-router'
  import {
    Search, ChevronLeft, ChevronRight, ChevronsLeft, ChevronsRight, Trash, Edit, Download, 
    User, UserPlus, CheckCircle, BadgeCheck, Eye, Ban, SearchX, Loader2
  } from 'lucide-vue-next'
  import UserModal from '@/components/admin/UserModal.vue'
  import ConfirmModal from '@/components/admin/ConfirmModal.vue'
  import { useSupabaseClient } from '#imports'
  
  // États
  const router = useRouter()
  const client = useSupabaseClient()
  const users = ref([])
  const loading = ref(true)
  const search = ref('')
  const roleFilter = ref('')
  const statusFilter = ref('')
  const currentPage = ref(1)
  const itemsPerPage = ref(10)
  const showUserModal = ref(false)
  const showDeleteModal = ref(false)
  const editMode = ref(false)
  const userToEdit = ref(null)
  const userToDelete = ref(null)
  const selectedUsers = ref([])
  const selectAll = ref(false)
  
  // Filtrage des utilisateurs
  const filteredUsers = computed(() => {
    let filtered = [...users.value]
    
    // Filtre par recherche
    if (search.value) {
      const query = search.value.toLowerCase()
      filtered = filtered.filter(user => 
        (user.first_name && user.first_name.toLowerCase().includes(query)) ||
        (user.last_name && user.last_name.toLowerCase().includes(query)) ||
        user.email.toLowerCase().includes(query)
      )
    }
    
    // Filtre par rôle
    if (roleFilter.value) {
      filtered = filtered.filter(user => user.role === roleFilter.value)
    }
    
    // Filtre par statut
    if (statusFilter.value) {
      filtered = filtered.filter(user => user.status === statusFilter.value)
    }
    
    return filtered
  })
  
  // Pagination
  const totalPages = computed(() => 
    Math.ceil(filteredUsers.value.length / itemsPerPage.value)
  )
  
  const paginatedUsers = computed(() => {
    const start = (currentPage.value - 1) * itemsPerPage.value
    const end = start + itemsPerPage.value
    return filteredUsers.value.slice(start, end)
  })
  
  // Boutons de pagination
  const paginationButtons = computed(() => {
    const buttons = []
    const MAX_VISIBLE = 5
    
    if (totalPages.value <= MAX_VISIBLE) {
      // Afficher toutes les pages
      for (let i = 1; i <= totalPages.value; i++) {
        buttons.push(i)
      }
    } else {
      // Afficher un sous-ensemble de pages avec '...'
      buttons.push(1)
      
      if (currentPage.value < 3) {
        buttons.push(2, 3, '...', totalPages.value)
      } else if (currentPage.value > totalPages.value - 2) {
        buttons.push('...', totalPages.value - 2, totalPages.value - 1, totalPages.value)
      } else {
        buttons.push('...', currentPage.value, '...', totalPages.value)
      }
    }
    
    return buttons
  })
  
  // Gestion des utilisateurs
  const openUserModal = (user = null) => {
    if (user) {
      userToEdit.value = { ...user }
      editMode.value = true
    } else {
      userToEdit.value = {
        first_name: '',
        last_name: '',
        email: '',
        password: '',
        role: 'client'
      }
      editMode.value = false
    }
    showUserModal.value = true
  }
  
  // Formater le rôle
  const formatRole = (role) => {
    switch (role) {
      case 'admin':
        return 'Administrateur'
      case 'expert':
        return 'Expert'
      case 'client':
        return 'Client'
      default:
        return role
    }
  }
  
  // Formater le statut
  const formatStatus = (status) => {
    switch (status) {
      case 'active':
        return 'Actif'
      case 'pending':
        return 'En attente'
      case 'blocked':
        return 'Bloqué'
      default:
        return status
    }
  }
  
  // Formater la date
  const formatDate = (dateString) => {
    if (!dateString) return '—'
    const date = new Date(dateString)
    return date.toLocaleDateString('fr-FR', {
      year: 'numeric',
      month: 'short',
      day: 'numeric'
    })
  }
  
  // Réinitialiser les filtres
  const resetFilters = () => {
    search.value = ''
    roleFilter.value = ''
    statusFilter.value = ''
    currentPage.value = 1
  }
  
  // Sélection des utilisateurs
  const toggleUserSelection = (userId) => {
    const index = selectedUsers.value.indexOf(userId)
    if (index === -1) {
      selectedUsers.value.push(userId)
    } else {
      selectedUsers.value.splice(index, 1)
  }
  
    // Mettre à jour l'état de sélection totale
    selectAll.value = selectedUsers.value.length === paginatedUsers.value.length
  }
  
  const toggleSelectAll = () => {
    selectAll.value = !selectAll.value
    if (selectAll.value) {
      selectedUsers.value = paginatedUsers.value.map(user => user.id)
    } else {
      selectedUsers.value = []
    }
  }
  
  // Actions sur les utilisateurs
  const confirmDelete = (user) => {
    userToDelete.value = user
    showDeleteModal.value = true
  }
  
  const deleteUser = async () => {
    try {
      // Logique de suppression
      console.log('Supprimer', userToDelete.value)
      // Rafraîchir la liste
      await fetchUsers()
      showDeleteModal.value = false
    } catch (error) {
      console.error('Erreur lors de la suppression:', error)
    }
  }
  
  const editUser = (user) => {
    openUserModal(user)
  }
  
  const saveUser = async (userData) => {
    try {
      // Logique d'enregistrement
      console.log('Enregistrer', userData)
      // Rafraîchir la liste
      await fetchUsers()
      showUserModal.value = false
    } catch (error) {
      console.error('Erreur lors de l\'enregistrement:', error)
    }
  }
  
  const verifyUser = async (userId, verified = true) => {
    try {
      const { error } = await client
        .from('profiles')
        .update({
          verification_status: verified ? 'verified' : 'rejected',
          verified_at: verified ? new Date().toISOString() : null
        })
        .eq('id', userId)

      if (error) throw error

      // Mettre à jour l'état local sans rechargement complet
      users.value = users.value.map(user => {
        if (user.id === userId) {
          return {
            ...user,
            verification_status: verified ? 'verified' : 'rejected',
            verified_at: verified ? new Date().toISOString() : null
          }
        }
        return user
      })
    } catch (error) {
      console.error('Erreur lors de la vérification:', error)
    }
  }
  
  const blockUser = async (user) => {
    try {
      // Logique de blocage
      console.log('Bloquer', user)
      // Rafraîchir la liste
      await fetchUsers()
    } catch (error) {
      console.error('Erreur lors du blocage:', error)
    }
  }
  
  const activateUser = async (user) => {
    try {
      // Logique d'activation
      console.log('Activer', user)
      // Rafraîchir la liste
      await fetchUsers()
    } catch (error) {
      console.error('Erreur lors de l\'activation:', error)
    }
  }
  
  // Actions en masse
  const bulkVerify = async () => {
    try {
      // Logique de vérification en masse
      console.log('Vérifier', selectedUsers.value)
      // Rafraîchir la liste
      await fetchUsers()
    } catch (error) {
      console.error('Erreur lors de la vérification en masse:', error)
    }
  }
  
  const bulkActivate = async () => {
    try {
      // Logique d'activation en masse
      console.log('Activer', selectedUsers.value)
      // Rafraîchir la liste
      await fetchUsers()
    } catch (error) {
      console.error('Erreur lors de l\'activation en masse:', error)
    }
  }
  
  const confirmBulkDelete = async () => {
    try {
      // Logique de suppression en masse
      console.log('Supprimer', selectedUsers.value)
      // Rafraîchir la liste
      await fetchUsers()
    } catch (error) {
      console.error('Erreur lors de la suppression en masse:', error)
    }
  }
  
  const exportUsers = () => {
    // Logique d'exportation
    console.log('Exporter les utilisateurs')
  }
  
  // Chargement des données
  const fetchUsers = async () => {
    try {
      loading.value = true
      
      // Récupérer les utilisateurs depuis la base de données
      const { data, error } = await client
        .from('profiles')
        .select('*')
        .order('created_at', { ascending: false })
      
      if (error) throw error
      users.value = data || []
    } catch (error) {
      console.error('Erreur lors du chargement des utilisateurs:', error)
    } finally {
      loading.value = false
  }
}

// Réinitialiser la pagination quand les filtres changent
  watch([search, roleFilter, statusFilter], () => {
  currentPage.value = 1
})

// Charger les utilisateurs au montage du composant
onMounted(fetchUsers)

definePageMeta({
    layout: 'admin'
})
</script> 