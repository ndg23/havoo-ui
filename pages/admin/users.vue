<template>
  <div class="min-h-screen bg-gray-50 dark:bg-gray-900">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 py-8">
      <!-- En-tête de la page -->
      <div class="mb-8 flex flex-col sm:flex-row sm:items-center sm:justify-between">
        <div>
          <h1 class="text-2xl font-bold text-gray-900 dark:text-white">Gestion des utilisateurs</h1>
          <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
            {{ totalUsers }} utilisateurs enregistrés
          </p>
        </div>
        
        <button 
          @click="openCreateModal" 
          class="mt-4 sm:mt-0 inline-flex items-center px-4 py-2 bg-primary-600 hover:bg-primary-700 rounded-lg text-white font-medium transition-colors shadow-sm"
        >
          <UserPlus class="h-4 w-4 mr-2" />
          Ajouter un utilisateur
        </button>
      </div>
      
      <!-- Filtres et recherche -->
      <div class="bg-white dark:bg-gray-800 rounded-xl shadow-sm mb-6 p-4">
        <div class="flex flex-col sm:flex-row gap-4">
          <!-- Barre de recherche -->
          <div class="relative flex-grow">
            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
              <Search class="h-5 w-5 text-gray-400 dark:text-gray-500" />
            </div>
            <input
              v-model="search"
              type="text"
              placeholder="Rechercher un utilisateur..."
              class="block w-full pl-10 pr-3 py-2 border border-gray-200 dark:border-gray-700 rounded-lg bg-gray-50 dark:bg-gray-700 text-gray-900 dark:text-gray-100 focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
            />
          </div>
          
          <!-- Filtres de rôle -->
          <div class="flex items-center space-x-2">
            <span class="text-sm text-gray-500 dark:text-gray-400 whitespace-nowrap">Rôle:</span>
            <select 
              v-model="roleFilter"
              class="form-select rounded-lg border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-700 text-gray-900 dark:text-gray-100 focus:ring-primary-500 focus:border-primary-500"
            >
              <option value="all">Tous</option>
              <option value="admin">Administrateur</option>
              <option value="expert">Expert</option>
              <option value="client">Client</option>
            </select>
          </div>
          
          <!-- Filtre de statut -->
          <div class="flex items-center space-x-2">
            <span class="text-sm text-gray-500 dark:text-gray-400 whitespace-nowrap">Statut:</span>
            <select 
              v-model="statusFilter"
              class="form-select rounded-lg border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-700 text-gray-900 dark:text-gray-100 focus:ring-primary-500 focus:border-primary-500"
            >
              <option value="all">Tous</option>
              <option value="active">Actif</option>
              <option value="inactive">Inactif</option>
              <option value="pending">En attente</option>
            </select>
          </div>
        </div>
      </div>
      
      <!-- Tableau des utilisateurs -->
      <div class="bg-white dark:bg-gray-800 rounded-xl shadow-sm overflow-hidden">
        <!-- État de chargement -->
        <div v-if="loading" class="p-8 flex justify-center">
          <Loader2 class="h-8 w-8 text-primary-500 animate-spin" />
        </div>
        
        <!-- Message si aucun utilisateur -->
        <div v-else-if="filteredUsers.length === 0" class="p-8 text-center">
          <UserX class="h-12 w-12 mx-auto text-gray-400 dark:text-gray-500 mb-3" />
          <h3 class="text-lg font-medium text-gray-900 dark:text-white">Aucun utilisateur trouvé</h3>
          <p class="mt-1 text-gray-500 dark:text-gray-400">
            Modifiez vos critères de recherche ou ajoutez un nouvel utilisateur.
          </p>
        </div>
        
        <!-- Tableau des utilisateurs -->
        <table v-else class="min-w-full divide-y divide-gray-200 dark:divide-gray-700">
          <thead class="bg-gray-50 dark:bg-gray-750">
            <tr>
              <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                Utilisateur
              </th>
              <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                Email
              </th>
              <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                Rôle
              </th>
              <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                Statut
              </th>
              <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                Date d'inscription
              </th>
              <th scope="col" class="px-6 py-3 text-right text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
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
              <!-- Informations utilisateur -->
              <td class="px-6 py-4 whitespace-nowrap">
                <div class="flex items-center">
                  <div class="h-10 w-10 flex-shrink-0">
                    <img 
                      :src="user.avatar_url || '/images/default-avatar.png'" 
                      :alt="`${user.first_name} ${user.last_name}`"
                      class="h-10 w-10 rounded-full object-cover"
                    />
                  </div>
                  <div class="ml-4">
                    <div class="text-sm font-medium text-gray-900 dark:text-white">
                      {{ user.first_name }} {{ user.last_name }}
                    </div>
                    <div class="text-sm text-gray-500 dark:text-gray-400">
                      ID: {{ user.id.substring(0, 8) }}...
                    </div>
                  </div>
                </div>
              </td>
              
              <!-- Email -->
              <td class="px-6 py-4 whitespace-nowrap">
                <div class="text-sm text-gray-900 dark:text-white">{{ user.email }}</div>
              </td>
              
              <!-- Rôle -->
              <td class="px-6 py-4 whitespace-nowrap">
                <span 
                  class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full"
                  :class="{
                    'bg-purple-100 text-purple-800 dark:bg-purple-800/20 dark:text-purple-300': user.role === 'admin',
                    'bg-blue-100 text-blue-800 dark:bg-blue-800/20 dark:text-blue-300': user.role === 'expert',
                    'bg-gray-100 text-gray-800 dark:bg-gray-700 dark:text-gray-300': user.role === 'client'
                  }"
                >
                  {{ formatRole(user.role) }}
                </span>
              </td>
              
              <!-- Statut -->
              <td class="px-6 py-4 whitespace-nowrap">
                <div class="flex items-center">
                  <div
                    class="h-2.5 w-2.5 rounded-full mr-2"
                    :class="{
                      'bg-green-500': user.status === 'active',
                      'bg-yellow-500': user.status === 'pending',
                      'bg-gray-400': user.status === 'inactive'
                    }"
                  ></div>
                  <span 
                    class="text-sm"
                    :class="{
                      'text-green-700 dark:text-green-400': user.status === 'active',
                      'text-yellow-700 dark:text-yellow-400': user.status === 'pending',
                      'text-gray-700 dark:text-gray-400': user.status === 'inactive'
                    }"
                  >
                    {{ formatStatus(user.status) }}
                  </span>
                </div>
              </td>
              
              <!-- Date d'inscription -->
              <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 dark:text-gray-400">
                {{ formatDate(user.created_at) }}
              </td>
              
              <!-- Actions -->
              <td class="px-6 py-4 whitespace-nowrap text-right text-sm">
                <div class="flex justify-end items-center space-x-2">
                  <button 
                    @click="viewUser(user)" 
                    class="p-1 text-gray-500 dark:text-gray-400 hover:text-gray-700 dark:hover:text-gray-300 transition-colors"
                    title="Voir le profil"
                  >
                    <Eye class="h-5 w-5" />
                  </button>
                  
                  <button 
                    @click="editUser(user)" 
                    class="p-1 text-blue-500 hover:text-blue-700 transition-colors"
                    title="Modifier"
                  >
                    <Edit class="h-5 w-5" />
                  </button>
                  
                  <button 
                    v-if="user.status === 'active'"
                    @click="updateUserStatus(user, 'inactive')" 
                    class="p-1 text-yellow-500 hover:text-yellow-700 transition-colors"
                    title="Désactiver"
                  >
                    <Ban class="h-5 w-5" />
                  </button>
                  
                  <button 
                    v-else
                    @click="updateUserStatus(user, 'active')" 
                    class="p-1 text-green-500 hover:text-green-700 transition-colors"
                    title="Activer"
                  >
                    <UserCheck class="h-5 w-5" />
                  </button>
                  
                  <button 
                    @click="confirmDeleteUser(user)" 
                    class="p-1 text-red-500 hover:text-red-700 transition-colors"
                    title="Supprimer"
                  >
                    <Trash2 class="h-5 w-5" />
                  </button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
        
        <!-- Pagination -->
        <div class="px-6 py-4 flex items-center justify-between border-t border-gray-200 dark:border-gray-700">
          <div class="flex-1 flex justify-between sm:hidden">
            <button
              @click="currentPage > 1 ? currentPage-- : null"
              :disabled="currentPage === 1"
              class="relative inline-flex items-center px-4 py-2 border border-gray-300 dark:border-gray-600 text-sm font-medium rounded-md text-gray-700 dark:text-gray-200 bg-white dark:bg-gray-700 hover:bg-gray-50 dark:hover:bg-gray-600"
              :class="{ 'opacity-50 cursor-not-allowed': currentPage === 1 }"
            >
              Précédent
            </button>
            <button
              @click="currentPage < totalPages ? currentPage++ : null"
              :disabled="currentPage === totalPages"
              class="ml-3 relative inline-flex items-center px-4 py-2 border border-gray-300 dark:border-gray-600 text-sm font-medium rounded-md text-gray-700 dark:text-gray-200 bg-white dark:bg-gray-700 hover:bg-gray-50 dark:hover:bg-gray-600"
              :class="{ 'opacity-50 cursor-not-allowed': currentPage === totalPages }"
            >
              Suivant
            </button>
          </div>
          <div class="hidden sm:flex-1 sm:flex sm:items-center sm:justify-between">
            <div>
              <p class="text-sm text-gray-700 dark:text-gray-300">
                Affichage de
                <span class="font-medium">{{ (currentPage - 1) * perPage + 1 }}</span>
                à
                <span class="font-medium">{{ Math.min(currentPage * perPage, filteredUsers.length) }}</span>
                sur
                <span class="font-medium">{{ filteredUsers.length }}</span>
                résultats
              </p>
            </div>
            <div>
              <nav class="relative z-0 inline-flex rounded-md shadow-sm -space-x-px" aria-label="Pagination">
                <button
                  @click="currentPage = 1"
                  :disabled="currentPage === 1"
                  class="relative inline-flex items-center px-2 py-2 rounded-l-md border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-700 text-sm font-medium text-gray-500 dark:text-gray-400 hover:bg-gray-50 dark:hover:bg-gray-600"
                >
                  <span class="sr-only">Première page</span>
                  <ChevronsLeft class="h-5 w-5" />
                </button>
                <button
                  @click="currentPage > 1 ? currentPage-- : null"
                  :disabled="currentPage === 1"
                  class="relative inline-flex items-center px-2 py-2 border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-700 text-sm font-medium text-gray-500 dark:text-gray-400 hover:bg-gray-50 dark:hover:bg-gray-600"
                >
                  <span class="sr-only">Précédent</span>
                  <ChevronLeft class="h-5 w-5" />
                </button>
                
                <span
                  v-for="page in paginationItems"
                  :key="page"
                >
                  <button
                    v-if="page !== '...'"
                    @click="currentPage = page"
                    :class="[
                      'relative inline-flex items-center px-4 py-2 border text-sm font-medium',
                      currentPage === page
                        ? 'z-10 bg-primary-50 dark:bg-primary-900/20 border-primary-500 dark:border-primary-500 text-primary-600 dark:text-primary-400'
                        : 'bg-white dark:bg-gray-700 border-gray-300 dark:border-gray-600 text-gray-500 dark:text-gray-400 hover:bg-gray-50 dark:hover:bg-gray-600'
                    ]"
                  >
                    {{ page }}
                  </button>
                  <span
                    v-else
                    class="relative inline-flex items-center px-4 py-2 border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-700 text-sm font-medium text-gray-700 dark:text-gray-300"
                  >
                    ...
                  </span>
                </span>
                
                <button
                  @click="currentPage < totalPages ? currentPage++ : null"
                  :disabled="currentPage === totalPages"
                  class="relative inline-flex items-center px-2 py-2 border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-700 text-sm font-medium text-gray-500 dark:text-gray-400 hover:bg-gray-50 dark:hover:bg-gray-600"
                >
                  <span class="sr-only">Suivant</span>
                  <ChevronRight class="h-5 w-5" />
                </button>
                <button
                  @click="currentPage = totalPages"
                  :disabled="currentPage === totalPages"
                  class="relative inline-flex items-center px-2 py-2 rounded-r-md border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-700 text-sm font-medium text-gray-500 dark:text-gray-400 hover:bg-gray-50 dark:hover:bg-gray-600"
                >
                  <span class="sr-only">Dernière page</span>
                  <ChevronsRight class="h-5 w-5" />
                </button>
              </nav>
            </div>
          </div>
        </div>
      </div>
    </div>
    
    <!-- Modal de confirmation de suppression -->
    <Teleport to="body">
      <div v-if="showDeleteModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
        <div class="bg-white dark:bg-gray-800 rounded-xl p-6 max-w-md w-full shadow-xl">
          <div class="flex items-center text-red-600 dark:text-red-500 mb-4">
            <AlertTriangle class="h-6 w-6 mr-2" />
            <h3 class="text-lg font-bold">Confirmer la suppression</h3>
          </div>
          <p class="text-gray-600 dark:text-gray-300 mb-6">
            Êtes-vous sûr de vouloir supprimer définitivement l'utilisateur <span class="font-medium text-gray-900 dark:text-white">{{ userToDelete?.first_name }} {{ userToDelete?.last_name }}</span> ?
            <br>
            Cette action ne peut pas être annulée.
          </p>
          <div class="flex justify-end space-x-3">
            <button 
              @click="showDeleteModal = false"
              class="px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700"
            >
              Annuler
            </button>
            <button 
              @click="deleteUser"
              class="px-4 py-2 bg-red-600 hover:bg-red-700 rounded-lg text-white flex items-center"
              :disabled="isDeleting"
            >
              <Loader2 v-if="isDeleting" class="h-4 w-4 mr-2 animate-spin" />
              {{ isDeleting ? 'Suppression...' : 'Supprimer' }}
            </button>
          </div>
        </div>
      </div>
    </Teleport>
  </div>
</template>

<script setup>
import { ref, computed, watch, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useSupabaseClient } from '#imports'
import { 
  Search, Loader2, ChevronLeft, ChevronRight, ChevronsLeft, ChevronsRight,
  UserPlus, UserX, UserCheck, Trash2, Eye, Edit, Ban, AlertTriangle
} from 'lucide-vue-next'

const router = useRouter()
const supabase = useSupabaseClient()

// État des données
const users = ref([])
const loading = ref(true)
const search = ref('')
const roleFilter = ref('all')
const statusFilter = ref('all')
const currentPage = ref(1)
const perPage = ref(10)
const showDeleteModal = ref(false)
const userToDelete = ref(null)
const isDeleting = ref(false)

// Calcul du nombre total d'utilisateurs
const totalUsers = computed(() => users.value.length)

// Filtrage des utilisateurs
const filteredUsers = computed(() => {
  let result = [...users.value]
  
  // Filtre de recherche
  if (search.value) {
    const searchLower = search.value.toLowerCase()
    result = result.filter(user => 
      (user.first_name && user.first_name.toLowerCase().includes(searchLower)) ||
      (user.last_name && user.last_name.toLowerCase().includes(searchLower)) ||
      (user.email && user.email.toLowerCase().includes(searchLower))
    )
  }
  
  // Filtre de rôle
  if (roleFilter.value !== 'all') {
    result = result.filter(user => user.role === roleFilter.value)
  }
  
  // Filtre de statut
  if (statusFilter.value !== 'all') {
    result = result.filter(user => user.status === statusFilter.value)
  }
  
  return result
})

// Pagination
const totalPages = computed(() => Math.max(1, Math.ceil(filteredUsers.value.length / perPage.value)))

const paginatedUsers = computed(() => {
  const start = (currentPage.value - 1) * perPage.value
  const end = start + perPage.value
  return filteredUsers.value.slice(start, end)
})

// Calcul des éléments de pagination
const paginationItems = computed(() => {
  if (totalPages.value <= 7) {
    return Array.from({ length: totalPages.value }, (_, i) => i + 1)
  }
  
  if (currentPage.value <= 3) {
    return [1, 2, 3, 4, 5, '...', totalPages.value]
  }
  
  if (currentPage.value >= totalPages.value - 2) {
    return [1, '...', totalPages.value - 4, totalPages.value - 3, totalPages.value - 2, totalPages.value - 1, totalPages.value]
  }
  
  return [1, '...', currentPage.value - 1, currentPage.value, currentPage.value + 1, '...', totalPages.value]
})

// Formateurs
const formatDate = (dateString) => {
  if (!dateString) return 'N/A'
  
  const date = new Date(dateString)
  return new Intl.DateTimeFormat('fr-FR', { 
    day: 'numeric',
    month: 'short', 
    year: 'numeric'
  }).format(date)
}

const formatRole = (role) => {
  switch (role) {
    case 'admin': return 'Administrateur'
    case 'expert': return 'Expert'
    case 'client': return 'Client'
    default: return role || 'N/A'
  }
}

const formatStatus = (status) => {
  switch (status) {
    case 'active': return 'Actif'
    case 'inactive': return 'Inactif'
    case 'pending': return 'En attente'
    default: return status || 'N/A'
  }
}

// Actions utilisateur
const viewUser = (user) => {
  router.push(`/admin/users/${user.id}`)
}

const editUser = (user) => {
  router.push(`/admin/users/${user.id}/edit`)
}

const confirmDeleteUser = (user) => {
  userToDelete.value = user
  showDeleteModal.value = true
}

const deleteUser = async () => {
  if (!userToDelete.value) return
  
  isDeleting.value = true
  
  try {
    // Supprimer l'utilisateur de la base de données
    const { error } = await supabase
      .from('profiles')
      .delete()
      .eq('id', userToDelete.value.id)
    
    if (error) throw error
    
    // Mettre à jour la liste des utilisateurs
    users.value = users.value.filter(user => user.id !== userToDelete.value.id)
    
    // Fermer le modal
    showDeleteModal.value = false
    userToDelete.value = null
    
    // Notifications
    alert('Utilisateur supprimé avec succès')
  } catch (error) {
    console.error('Erreur lors de la suppression:', error)
    alert(`Erreur: ${error.message}`)
  } finally {
    isDeleting.value = false
  }
}

const updateUserStatus = async (user, newStatus) => {
  try {
    loading.value = true
    
    // Mettre à jour le statut dans la base de données
    const { error } = await supabase
      .from('profiles')
      .update({ status: newStatus })
      .eq('id', user.id)
    
    if (error) throw error
    
    // Mettre à jour localement
    const index = users.value.findIndex(u => u.id === user.id)
    if (index !== -1) {
      users.value[index].status = newStatus
    }
    
    // Notification
    alert(`Statut mis à jour: ${formatStatus(newStatus)}`)
  } catch (error) {
    console.error('Erreur lors de la mise à jour du statut:', error)
    alert(`Erreur: ${error.message}`)
  } finally {
    loading.value = false
  }
}

const openCreateModal = () => {
  router.push('/admin/users/create')
}

// Chargement des utilisateurs
const fetchUsers = async () => {
  try {
    loading.value = true
    
    const { data, error } = await supabase
      .from('profiles')
      .select('*')
      .order('created_at', { ascending: false })
    
    if (error) throw error
    
    users.value = data || []
  } catch (error) {
    console.error('Erreur lors du chargement des utilisateurs:', error)
    alert(`Erreur: ${error.message}`)
  } finally {
    loading.value = false
  }
}

// Initialisation
onMounted(fetchUsers)

// Réinitialiser la pagination quand les filtres changent
watch([search, roleFilter, statusFilter], () => {
  currentPage.value = 1
})

definePageMeta({
  layout: 'admin',
})
</script>

<style scoped>
/* Si besoin de styles spécifiques */
</style> 