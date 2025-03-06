<template>
    <div class="p-6 max-w-7xl mx-auto">
      <!-- Header with actions -->
      <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center mb-8 gap-4">
        <div>
          <h1 class="text-3xl font-extrabold text-gray-900 dark:text-white tracking-tight">Utilisateurs</h1>
          <p class="mt-1 text-gray-500 dark:text-gray-400">
            Gérez l'ensemble des utilisateurs de la plateforme
          </p>
        </div>
        
        <div class="flex gap-3">
          <button 
            @click="openExportModal"
            class="flex items-center px-4 py-2.5 border border-gray-300 dark:border-gray-700 rounded-full text-sm font-medium text-gray-700 dark:text-gray-200 hover:bg-gray-50 dark:hover:bg-gray-800 transition-colors"
          >
            <Download class="mr-2 h-4 w-4" />
            Exporter
          </button>
          
          <button 
            @click="openUserModal"
            class="flex items-center px-4 py-2.5 bg-blue-500 text-white rounded-full text-sm font-medium hover:bg-blue-600 transition-colors"
          >
            <UserPlus class="mr-2 h-4 w-4" />
            Nouvel utilisateur
          </button>
        </div>
      </div>
      
      <!-- Stats cards -->
      <div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-4 gap-4 mb-8">
        <div class="bg-white dark:bg-gray-800 rounded-2xl p-6 border border-gray-100 dark:border-gray-700 shadow-sm">
          <div class="flex justify-between items-start">
            <div>
              <p class="text-sm font-medium text-gray-500 dark:text-gray-400">Total utilisateurs</p>
              <div class="mt-2 text-3xl font-bold text-gray-900 dark:text-white">{{ users.length }}</div>
              <div class="mt-2 text-xs text-green-500 flex items-center">
                <TrendingUp class="h-3 w-3 mr-1" />
                <span>+12% ce mois</span>
              </div>
            </div>
            <div class="p-2.5 rounded-full bg-blue-50 dark:bg-blue-900/30">
              <Users class="h-5 w-5 text-blue-500" />
            </div>
          </div>
        </div>
        
        <div class="bg-white dark:bg-gray-800 rounded-2xl p-6 border border-gray-100 dark:border-gray-700 shadow-sm">
          <div class="flex justify-between items-start">
            <div>
              <p class="text-sm font-medium text-gray-500 dark:text-gray-400">Experts vérifiés</p>
              <div class="mt-2 text-3xl font-bold text-gray-900 dark:text-white">
                {{ users.filter(u => u.role === 'expert' && u.is_verified).length }}
              </div>
              <div class="mt-2 text-xs text-green-500 flex items-center">
                <TrendingUp class="h-3 w-3 mr-1" />
                <span>+8% ce mois</span>
              </div>
            </div>
            <div class="p-2.5 rounded-full bg-green-50 dark:bg-green-900/30">
              <BadgeCheck class="h-5 w-5 text-green-500" />
            </div>
          </div>
        </div>
        
        <div class="bg-white dark:bg-gray-800 rounded-2xl p-6 border border-gray-100 dark:border-gray-700 shadow-sm">
          <div class="flex justify-between items-start">
            <div>
              <p class="text-sm font-medium text-gray-500 dark:text-gray-400">Nouveaux utilisateurs</p>
              <div class="mt-2 text-3xl font-bold text-gray-900 dark:text-white">
                {{ getNewUsersCount() }}
              </div>
              <div class="mt-2 text-xs text-green-500 flex items-center">
                <TrendingUp class="h-3 w-3 mr-1" />
                <span>Derniers 30 jours</span>
              </div>
            </div>
            <div class="p-2.5 rounded-full bg-purple-50 dark:bg-purple-900/30">
              <UserPlus class="h-5 w-5 text-purple-500" />
            </div>
          </div>
        </div>
        
        <div class="bg-white dark:bg-gray-800 rounded-2xl p-6 border border-gray-100 dark:border-gray-700 shadow-sm">
          <div class="flex justify-between items-start">
            <div>
              <p class="text-sm font-medium text-gray-500 dark:text-gray-400">Connexions aujourd'hui</p>
              <div class="mt-2 text-3xl font-bold text-gray-900 dark:text-white">
                {{ getTodayLoginCount() }}
              </div>
              <div class="mt-2 text-xs text-amber-500 flex items-center">
                <Activity class="h-3 w-3 mr-1" />
                <span>Activité du jour</span>
              </div>
            </div>
            <div class="p-2.5 rounded-full bg-amber-50 dark:bg-amber-900/30">
              <LogIn class="h-5 w-5 text-amber-500" />
            </div>
          </div>
        </div>
      </div>
      
      <!-- Search and filters -->
      <div class="bg-white dark:bg-gray-800 rounded-2xl p-5 mb-6 border border-gray-100 dark:border-gray-700 shadow-sm">
        <div class="flex flex-col sm:flex-row gap-4 items-center justify-between">
          <div class="w-full max-w-md relative">
            <Search class="absolute left-3.5 top-1/2 transform -translate-y-1/2 h-4 w-4 text-gray-400" />
            <input
              v-model="search"
              type="text"
              placeholder="Rechercher par nom, email..."
              class="pl-10 pr-4 py-3 w-full border-0 bg-gray-50 dark:bg-gray-900 rounded-full text-sm text-gray-900 dark:text-white focus:ring-2 focus:ring-blue-500 transition-all"
            />
          </div>
          
          <div class="flex flex-wrap gap-3 w-full sm:w-auto">
            <!-- Role filter -->
            <div class="relative min-w-[160px]">
              <select
                v-model="roleFilter"
                class="appearance-none pl-4 pr-10 py-3 w-full border-0 bg-gray-50 dark:bg-gray-900 rounded-full text-sm text-gray-900 dark:text-white focus:ring-2 focus:ring-blue-500 transition-all"
              >
                <option value="">Tous les rôles</option>
                <option value="user">Utilisateurs</option>
                <option value="expert">Experts</option>
                <option value="admin">Administrateurs</option>
              </select>
              <ChevronDown class="absolute right-4 top-1/2 transform -translate-y-1/2 h-4 w-4 text-gray-400 pointer-events-none" />
            </div>
            
            <!-- Status filter -->
            <div class="relative min-w-[160px]">
              <select
                v-model="statusFilter"
                class="appearance-none pl-4 pr-10 py-3 w-full border-0 bg-gray-50 dark:bg-gray-900 rounded-full text-sm text-gray-900 dark:text-white focus:ring-2 focus:ring-blue-500 transition-all"
              >
                <option value="">Tous les statuts</option>
                <option value="active">Actifs</option>
                <option value="inactive">Inactifs</option>
                <option value="blocked">Bloqués</option>
              </select>
              <ChevronDown class="absolute right-4 top-1/2 transform -translate-y-1/2 h-4 w-4 text-gray-400 pointer-events-none" />
            </div>
            
            <!-- Date filter button -->
            <button 
              @click="showDateFilter = !showDateFilter"
              class="flex items-center px-4 py-3 border-0 bg-gray-50 dark:bg-gray-900 rounded-full text-sm text-gray-700 dark:text-gray-200 hover:bg-gray-100 dark:hover:bg-gray-800 transition-colors focus:ring-2 focus:ring-blue-500"
            >
              <Calendar class="mr-2 h-4 w-4" />
              <span>Date</span>
              <ChevronDown class="ml-2 h-3 w-3" :class="showDateFilter ? 'rotate-180' : ''" />
            </button>
          </div>
        </div>
      </div>
      
      <!-- Table des utilisateurs -->
      <Table
        :items="paginatedUsers"
        :columns="columns"
        :loading="loading"
        :selectable="true"
        v-model:selectedItems="selectedUsers"
        :row-actions="rowActions"
        :bulk-actions="bulkActions"
        :pagination="true"
        v-model:currentPage="currentPage"
        :perPage="perPage"
        :totalItems="filteredUsers.length"
        entity-label="utilisateur"
        empty-message="Aucun utilisateur trouvé"
        empty-description="Essayez de modifier vos filtres ou ajoutez de nouveaux utilisateurs."
        :empty-icon="UsersX"
        @action="handleTableAction"
        @sort="handleSort"
      >
        <!-- Templates pour les cellules personnalisées -->
        <template #cell-avatar="{ item }">
          <div class="flex items-center">
            <div class="h-10 w-10 rounded-full bg-gray-200 dark:bg-gray-700 overflow-hidden flex-shrink-0">
              <img 
                v-if="item.avatar_url" 
                :src="item.avatar_url" 
                        alt="Avatar"
                        class="h-full w-full object-cover"
                @error="handleImageError"
                      />
              <User v-else class="h-full w-full p-2 text-gray-400" />
                    </div>
            <div class="ml-3">
              <div class="text-sm font-medium text-gray-900 dark:text-white">
                {{ item.first_name }} {{ item.last_name }}
                    </div>
              <div class="text-xs text-gray-500 dark:text-gray-400">
                {{ item.email }}
                  </div>
                    </div>
                  </div>
        </template>
              
        <template #cell-role="{ item }">
          <div class="flex items-center space-x-1">
                <span 
              class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium"
              :class="getRoleBadgeClass(item.role)"
                >
              {{ getRoleLabel(item.role) }}
                </span>
            <BadgeCheck 
              v-if="item.is_verified" 
              class="h-4 w-4 text-blue-500" 
              fill="currentColor"
            />
              </div>
        </template>
              
        <template #cell-status="{ item }">
                <span 
            class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium"
            :class="getStatusBadgeClass(item.status)"
          >
            {{ getStatusLabel(item.status) }}
                </span>
        </template>
        
        <template #cell-created_at="{ value }">
          <span class="text-sm text-gray-500 dark:text-gray-400">
            {{ formatDate(value) }}
          </span>
        </template>
        
        <!-- Actions personnalisées à droite de chaque ligne -->
        <template #rowActions="{ item }">
                  <button 
            @click="viewUser(item)"
            class="p-1.5 rounded-full hover:bg-gray-100 dark:hover:bg-gray-700 text-gray-500 dark:text-gray-400"
            title="Voir"
          >
            <Eye class="h-4 w-4" />
                  </button>
                  <button 
            @click="editUser(item)"
            class="p-1.5 rounded-full hover:bg-gray-100 dark:hover:bg-gray-700 text-gray-500 dark:text-gray-400"
                    title="Modifier"
                  >
            <Edit class="h-4 w-4" />
                  </button>
        </template>
      </Table>
      
      <!-- Modals -->
      <UserModal 
        v-if="showUserModal"
        :show="showUserModal"
        :mode="editMode ? 'edit' : 'add'"
        :user="userToEdit"
        @close="showUserModal = false"
        @save="saveUser"
      />
      
      <!-- Delete confirmation modal -->
      <ConfirmModal
        :show="showDeleteModal"
        title="Supprimer l'utilisateur"
        @close="showDeleteModal = false"
        @confirm="deleteUser"
      >
        <template #icon>
          <AlertCircle class="h-5 w-5 text-red-500 mr-2" />
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
              <UserCircle v-else class="h-full w-full text-gray-400" />
            </div>
            <div>
              <div class="font-medium text-gray-900 dark:text-white">
                {{ userToDelete.first_name }} {{ userToDelete.last_name }}
              </div>
              <div class="text-sm text-gray-500 dark:text-gray-400">{{ userToDelete.email }}</div>
            </div>
          </div>
        </div>
        
        <template #footer>
          <div class="flex justify-end gap-3">
            <button 
              @click="showDeleteModal = false"
              class="px-4 py-2 border border-gray-300 dark:border-gray-700 rounded-lg text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-800"
            >
              Annuler
            </button>
            <button 
              @click="deleteUser"
              class="px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700"
              :class="{ 'opacity-75 cursor-not-allowed': deleting }"
              :disabled="deleting"
            >
              <span v-if="deleting" class="flex items-center">
                <span class="inline-block animate-spin rounded-full h-4 w-4 border-2 border-white border-t-transparent mr-2"></span>
                Suppression...
              </span>
              <span v-else>Supprimer</span>
            </button>
          </div>
        </template>
      </ConfirmModal>
      
      <!-- Modal de vérification avant activation -->
      <ConfirmModal
        :show="showVerifyBeforeActivateModal"
        title="Vérification requise"
        @close="showVerifyBeforeActivateModal = false"
        @confirm="verifyAndActivate"
      >
        <template #icon>
          <BadgeCheck class="h-5 w-5 text-blue-500 mr-2" />
        </template>
        
        <p class="text-gray-700 dark:text-gray-300">
          Cet utilisateur est un expert qui doit être vérifié avant d'être activé. Souhaitez-vous vérifier et activer cet expert ?
        </p>
        
        <div v-if="userToActivate" class="mt-4 p-4 bg-gray-50 dark:bg-gray-800 rounded-lg">
          <div class="flex items-center">
            <div class="h-10 w-10 rounded-full bg-gray-200 dark:bg-gray-700 overflow-hidden mr-3">
              <img 
                v-if="userToActivate.avatar_url" 
                :src="userToActivate.avatar_url" 
                alt="Avatar"
                class="h-full w-full object-cover"
              />
              <UserCircle v-else class="h-full w-full text-gray-400" />
            </div>
            <div>
              <div class="font-medium text-gray-900 dark:text-white">
                {{ userToActivate.first_name }} {{ userToActivate.last_name }}
              </div>
              <div class="text-sm text-gray-500 dark:text-gray-400">{{ userToActivate.email }}</div>
            </div>
          </div>
        </div>
        
        <template #footer>
          <div class="flex justify-end gap-3">
            <button 
              @click="showVerifyBeforeActivateModal = false"
              class="px-4 py-2 border border-gray-300 dark:border-gray-700 rounded-lg text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-800"
            >
              Annuler
            </button>
            <button 
              @click="verifyAndActivate"
              class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700"
            >
              Vérifier et Activer
            </button>
          </div>
        </template>
      </ConfirmModal>
    </div>
  </template>
  
  <script setup>
  import { ref, computed, watch, onMounted, nextTick } from 'vue'
  import { useRouter } from 'vue-router'
  import {
    UserCircle, Search, ChevronLeft, ChevronRight, Edit, Trash2, MoreHorizontal,
    Users, User, Shield, Wrench, ArrowUp, Minus, Download, UserPlus, Calendar, TrendingUp,
    Eye, BadgeCheck, Activity, LogIn, CheckCircle, Ban, UserX, AlertCircle, ChevronUp, ChevronDown,
    ChevronUpDown, MoreVertical, Loader2, SearchX, UsersX
  } from 'lucide-vue-next'
  import UserModal from '@/components/admin/UserModal.vue'
  import ConfirmModal from '@/components/admin/ConfirmModal.vue'
  import Table from '@/components/ui/Table.vue'
  
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
  const saving = ref(false)
  const deleting = ref(false)
  const showDateFilter = ref(false)
  const showActionsFor = ref(null)
  const selectedUsers = ref([])
  const selectAll = ref(false)
  const showVerifyBeforeActivateModal = ref(false)
  const userToActivate = ref(null)
  
  // Définition des colonnes pour la table
  const columns = [
    {
      key: 'avatar',
      label: 'Utilisateur',
      sortable: false
    },
    {
      key: 'role',
      label: 'Rôle',
      sortable: true
    },
    {
      key: 'status',
      label: 'Statut',
      sortable: true
    },
    {
      key: 'created_at',
      label: 'Inscription',
      sortable: true
    }
  ]
  
  // Actions pour les lignes
  const rowActions = [
    {
      key: 'verify',
      label: 'Vérifier',
      icon: BadgeCheck,
      handler: verifyUser,
      show: (user) => user.role === 'expert' && !user.is_verified
    },
    {
      key: 'block',
      label: 'Bloquer',
      icon: Ban,
      handler: blockUser,
      show: (user) => user.status !== 'blocked'
    },
    {
      key: 'activate',
      label: 'Activer',
      icon: CheckCircle,
      handler: activateUser,
      show: (user) => user.status !== 'active'
    },
    {
      key: 'delete',
      label: 'Supprimer',
      icon: Trash2,
      danger: true,
      handler: confirmDelete
    }
  ]
  
  // Actions groupées
  const bulkActions = [
    {
      label: 'Vérifier',
      icon: BadgeCheck,
      handler: bulkVerify
    },
    {
      label: 'Activer',
      icon: CheckCircle,
      handler: bulkActivate
    },
    {
      label: 'Supprimer',
      icon: Trash2,
      danger: true,
      handler: confirmBulkDelete
    }
  ]
  
  // Filtrage des utilisateurs
  const filteredUsers = computed(() => {
    let result = [...users.value]
    
    // Filtre par recherche
    if (search.value) {
      const query = search.value.toLowerCase()
      result = result.filter(user => 
        (user.first_name?.toLowerCase().includes(query) || 
         user.last_name?.toLowerCase().includes(query) || 
         user.email?.toLowerCase().includes(query))
      )
    }
    
    // Filtre par rôle
    if (roleFilter.value) {
      result = result.filter(user => user.role === roleFilter.value)
    }
    
    // Filtre par statut
    if (statusFilter.value) {
      result = result.filter(user => user.status === statusFilter.value)
    }
    
    return result
  })
  
  // Pagination
  const totalPages = computed(() => 
    Math.max(1, Math.ceil(filteredUsers.value.length / itemsPerPage.value))
  )
  
  const startIndex = computed(() => 
    (currentPage.value - 1) * itemsPerPage.value
  )
  
  const endIndex = computed(() => 
    startIndex.value + itemsPerPage.value
  )
  
  const paginatedUsers = computed(() => 
    filteredUsers.value.slice(startIndex.value, endIndex.value)
  )
  
  const displayedPages = computed(() => {
    const pages = []
    const maxVisible = 5
    
    if (totalPages.value <= maxVisible) {
      for (let i = 1; i <= totalPages.value; i++) {
        pages.push(i)
      }
    } else {
      pages.push(1)
      
      const leftSide = Math.max(2, currentPage.value - 1)
      const rightSide = Math.min(totalPages.value - 1, currentPage.value + 1)
      
      if (leftSide > 2) pages.push('...')
      
      for (let i = leftSide; i <= rightSide; i++) {
        pages.push(i)
      }
      
      if (rightSide < totalPages.value - 1) pages.push('...')
      
      pages.push(totalPages.value)
    }
    
    return pages
  })
  
  // Navigation dans la pagination
  const nextPage = () => {
    if (currentPage.value < totalPages.value) {
      currentPage.value++
    }
  }
  
  const prevPage = () => {
    if (currentPage.value > 1) {
      currentPage.value--
    }
  }
  
  const goToPage = (page) => {
    currentPage.value = page
  }
  
  // Formatage des dates
  const formatDate = (dateString) => {
    if (!dateString) return '-'
    const date = new Date(dateString)
    return date.toLocaleDateString('fr-FR', {
      day: 'numeric',
      month: 'short',
      year: 'numeric'
    })
  }
  
  // Fonctions utilitaires pour les badges
  const getRoleBadgeClass = (role) => {
    switch(role) {
      case 'admin': return 'bg-purple-100 text-purple-800 dark:bg-purple-900/30 dark:text-purple-300'
      case 'expert': return 'bg-blue-100 text-blue-800 dark:bg-blue-900/30 dark:text-blue-300'
      default: return 'bg-gray-100 text-gray-800 dark:bg-gray-800 dark:text-gray-300'
    }
  }
  
  const getStatusBadgeClass = (status) => {
    switch(status) {
      case 'active': return 'bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-300'
      case 'blocked': return 'bg-red-100 text-red-800 dark:bg-red-900/30 dark:text-red-300'
      case 'inactive': return 'bg-yellow-100 text-yellow-800 dark:bg-yellow-900/30 dark:text-yellow-300'
      default: return 'bg-gray-100 text-gray-800 dark:bg-gray-800 dark:text-gray-300'
    }
  }
  
  const getRoleLabel = (role) => {
    switch(role) {
      case 'admin': return 'Admin'
      case 'expert': return 'Expert'
      default: return 'Utilisateur'
    }
  }
  
  const getStatusLabel = (status) => {
    switch(status) {
      case 'active': return 'Actif'
      case 'blocked': return 'Bloqué'
      case 'inactive': return 'Inactif'
      default: return 'Inconnu'
    }
  }
  
  // Statistics functions
  const getNewUsersCount = () => {
    const thirtyDaysAgo = new Date()
    thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30)
    
    return users.value.filter(user => {
      const createdAt = new Date(user.created_at)
      return createdAt >= thirtyDaysAgo
    }).length
  }
  
  const getTodayLoginCount = () => {
    // This would normally come from analytics data
    return Math.floor(Math.random() * 30) + 5
  }
  
  // Selection functions
  const toggleUserSelection = (user) => {
    const index = selectedUsers.value.findIndex(u => u.id === user.id)
    if (index >= 0) {
      selectedUsers.value.splice(index, 1)
      selectAll.value = false
    } else {
      selectedUsers.value.push(user)
      selectAll.value = selectedUsers.value.length === paginatedUsers.value.length
    }
  }
  
  const isSelected = (user) => {
    return selectedUsers.value.some(u => u.id === user.id)
  }
  
  const toggleSelectAll = () => {
    selectAll.value = !selectAll.value
    
    if (selectAll.value) {
      selectedUsers.value = [...paginatedUsers.value]
    } else {
      selectedUsers.value = []
    }
  }
  
  // Bulk actions
  const bulkVerify = () => {
    // Logic to verify multiple users
    alert(`Vérification de ${selectedUsers.value.length} utilisateurs`)
  }
  
  const bulkActivate = () => {
    // Logic to activate multiple users
    alert(`Activation de ${selectedUsers.value.length} utilisateurs`)
  }
  
  const confirmBulkDelete = () => {
    // Logic to show confirmation for bulk delete
    alert(`Confirmation de suppression de ${selectedUsers.value.length} utilisateurs`)
  }
  
  // More actions dropdown
  const toggleMoreActions = (user) => {
    if (showActionsFor.value === user.id) {
      showActionsFor.value = null
    } else {
      showActionsFor.value = user.id
    }
  }
  
  // Close dropdown when clicking outside
  const handleOutsideClick = (event) => {
    if (showActionsFor.value !== null) {
      showActionsFor.value = null
    }
  }
  
  // Filter management
  const clearFilters = () => {
    search.value = ''
    roleFilter.value = ''
    statusFilter.value = ''
  }
  
  // Modals
  const openUserModal = () => {
    editMode.value = false
    userToEdit.value = null
    showUserModal.value = true
  }
  
  const editUser = (user) => {
    editMode.value = true
    userToEdit.value = { ...user }
    showUserModal.value = true
  }
  
  const viewUser = (user) => {
    router.push(`/admin/users/${user.id}`)
  }
  
  const confirmDelete = (user) => {
    userToDelete.value = user
    showDeleteModal.value = true
    showActionsFor.value = null
  }
  
  const blockUser = (user) => {
    // Logic to block user
    alert(`Bloquer l'utilisateur ${user.first_name}`)
    showActionsFor.value = null
  }
  
  const activateUser = (user) => {
    // Si c'est un expert non vérifié, afficher le modal de confirmation
    if (user.role === 'expert' && !user.is_verified) {
      userToActivate.value = user;
      showVerifyBeforeActivateModal.value = true;
    } else {
      // Sinon, activer directement
      performActivation(user);
    }
    
    showActionsFor.value = null;
  }
  
  // Nouvelle fonction pour effectuer l'activation
  const performActivation = async (user) => {
    try {
      const { error } = await client
        .from('profiles')
        .update({ 
          status: 'active',
          updated_at: new Date().toISOString() 
        })
        .eq('id', user.id);
        
      if (error) throw error;
      
      // Rafraîchir la liste des utilisateurs
      await fetchUsers();
      
    } catch (error) {
      console.error('Erreur lors de l\'activation de l\'utilisateur:', error);
      alert('Erreur lors de l\'activation: ' + error.message);
    }
  }
  
  // Nouvelle fonction pour vérifier et activer
  const verifyAndActivate = async () => {
    if (!userToActivate.value) return;
    
    try {
      // Vérifier l'expert
      await verifyUser(userToActivate.value);
      
      // Puis l'activer
      await performActivation(userToActivate.value);
      
      // Fermer le modal
      showVerifyBeforeActivateModal.value = false;
      userToActivate.value = null;
      
    } catch (error) {
      console.error('Erreur lors de la vérification et activation:', error);
      alert('Erreur: ' + error.message);
    }
  }
  
  const verifyUser = async (user) => {
    try {
      const { error } = await client
        .from('profiles')
        .update({ is_verified: true, verification_status: 'verified', verified_at: new Date().toISOString() })
        .eq('id', user.id)
        
      if (error) throw error
      
      // Refresh user list
      await fetchUsers()
    } catch (error) {
      console.error('Error verifying user:', error)
    }
  }
  
  const openExportModal = () => {
    // Logic to open export modal
    alert('Exporter les utilisateurs')
  }
  
  // Data operations
  const fetchUsers = async () => {
    try {
      loading.value = true
      
      // Fetch users from API
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

// Enregistrer un utilisateur (créer ou mettre à jour)
const saveUser = async () => {
  try {
    saving.value = true
    
    if (editMode.value) {
      // Mise à jour d'un utilisateur existant
      const { error: profileError } = await client
        .from('profiles')
        .update({
            first_name: userToEdit.value.first_name,
            last_name: userToEdit.value.last_name,
            email: userToEdit.value.email,
            role: userToEdit.value.role,
          updated_at: new Date().toISOString()
        })
          .eq('id', userToEdit.value.id)
      
      if (profileError) throw profileError
      
    } else {
      // Création d'un nouvel utilisateur
      const { data: authData, error: authError } = await client.auth.admin.createUser({
          email: userToEdit.value.email,
          password: userToEdit.value.password,
        email_confirm: true
      })
      
      if (authError) throw authError
      
      // Créer le profil associé avec le rôle
      const { error: profileError } = await client
        .from('profiles')
        .upsert({
          id: authData.user.id,
            first_name: userToEdit.value.first_name,
            last_name: userToEdit.value.last_name,
            email: userToEdit.value.email,
            role: userToEdit.value.role,
          created_at: new Date().toISOString()
        })
      
      if (profileError) throw profileError
    }
    
    // Recharger les utilisateurs et fermer le modal
    await fetchUsers()
    showUserModal.value = false
  } catch (error) {
    console.error('Erreur lors de l\'enregistrement de l\'utilisateur:', error)
    alert('Erreur lors de l\'enregistrement de l\'utilisateur: ' + error.message)
  } finally {
    saving.value = false
  }
}

// Supprimer un utilisateur
const deleteUser = async () => {
  if (!userToDelete.value) return
  
  try {
    deleting.value = true
    
    // Supprimer l'utilisateur de la base de données
    const { error: profileError } = await client
      .from('profiles')
      .delete()
      .eq('id', userToDelete.value.id)
    
    if (profileError) throw profileError
    
    // Supprimer l'utilisateur dans Auth
    const { error: authError } = await client.auth.admin.deleteUser(userToDelete.value.id)
    
    if (authError) throw authError
    
    // Recharger les utilisateurs et fermer le modal
    await fetchUsers()
    showDeleteModal.value = false
    userToDelete.value = null
  } catch (error) {
    console.error('Erreur lors de la suppression de l\'utilisateur:', error)
    alert('Erreur lors de la suppression de l\'utilisateur: ' + error.message)
  } finally {
    deleting.value = false
  }
}

// Réinitialiser la pagination quand les filtres changent
watch([search, roleFilter], () => {
  currentPage.value = 1
})

// Charger les utilisateurs au montage du composant
onMounted(fetchUsers)

// Définir le layout admin
definePageMeta({
  layout: 'admin',
})
</script> 