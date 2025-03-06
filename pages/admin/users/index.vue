<template>
  <div>
    <!-- En-tête de page avec stats -->
    <PageHeader 
      title="Gestion des utilisateurs" 
      subtitle="Gérez les comptes utilisateurs, experts et administrateurs"
    >
      <!-- Statistiques -->
      <template #stats>
        <StatCard 
          title="Total utilisateurs" 
          :value="users.length" 
          :icon="Users" 
          color="blue" 
        />
        
        <StatCard 
          title="Clients" 
          :value="users.filter(u => u.role === 'user').length" 
          :icon="User" 
          color="green" 
        />
        
        <StatCard 
          title="Experts" 
          :value="users.filter(u => u.role === 'expert').length" 
          :icon="Wrench" 
          color="indigo" 
        />
        
        <StatCard 
          title="Administrateurs" 
          :value="users.filter(u => u.role === 'admin').length" 
          :icon="Shield" 
          color="purple" 
        />
      </template>
      
      <!-- Filtres de recherche -->
      <template #filters>
      <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <!-- Recherche -->
        <div class="relative flex-1 max-w-md">
          <Search class="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 h-4 w-4" />
          <input
            v-model="search"
            type="text"
            placeholder="Rechercher un utilisateur..."
              class="w-full pl-10 pr-4 py-2.5 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-transparent transition-colors text-sm"
          />
        </div>
        
        <!-- Filtres et actions -->
        <div class="flex items-center gap-3">
          <!-- Filtre rôle -->
          <div class="relative">
            <select
              v-model="roleFilter"
                class="appearance-none pl-4 pr-8 py-2.5 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-transparent transition-colors text-sm bg-white"
            >
              <option value="">Tous les rôles</option>
              <option value="user">Utilisateurs</option>
              <option value="expert">Experts</option>
              <option value="admin">Administrateurs</option>
            </select>
            <ChevronDown class="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400 h-4 w-4 pointer-events-none" />
          </div>
          
          <!-- Bouton ajouter -->
          <button 
            @click="openUserModal"
              class="px-4 py-2.5 bg-primary-600 text-white text-sm font-medium rounded-lg hover:bg-primary-700 transition-colors flex items-center whitespace-nowrap"
          >
            <Plus class="h-4 w-4 mr-1.5" />
            Ajouter
          </button>
        </div>
      </div>
      </template>
    </PageHeader>
    
    <!-- Tableau des utilisateurs -->
    <div class="bg-white border border-gray-200 rounded-xl overflow-hidden shadow-sm">
      <div class="overflow-x-auto">
        <table class="w-full">
          <thead class="bg-gray-50 border-b border-gray-200">
            <tr>
              <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Utilisateur
              </th>
              <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Email
              </th>
              <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Rôle
              </th>
              <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Inscrit le
              </th>
              <th class="px-6 py-4 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">
                Actions
              </th>
            </tr>
          </thead>
          <tbody class="divide-y divide-gray-200">
            <!-- Chargement -->
            <tr v-if="loading">
              <td colspan="5" class="px-6 py-8">
                <div class="flex justify-center">
                  <Loader2 class="h-8 w-8 text-gray-400 animate-spin" />
                </div>
              </td>
            </tr>
            
            <!-- Aucun résultat -->
            <tr v-else-if="filteredUsers.length === 0">
              <td colspan="5" class="px-6 py-8 text-center">
                <UserX class="h-12 w-12 text-gray-300 mx-auto mb-3" />
                <p class="text-gray-500 font-medium">
                  {{ search || roleFilter ? 'Aucun utilisateur ne correspond à votre recherche' : 'Aucun utilisateur inscrit' }}
                </p>
                <button 
                  v-if="!search && !roleFilter"
                  @click="openUserModal"
                  class="mt-4 px-4 py-2 bg-black text-white text-sm font-medium rounded-lg hover:bg-gray-800 transition-colors"
                >
                  Ajouter un utilisateur
                </button>
              </td>
            </tr>
            
            <!-- Données des utilisateurs -->
            <tr 
              v-else
              v-for="user in filteredUsers" 
              :key="user.id"
              class="hover:bg-gray-50 transition-colors"
            >
              <!-- Informations utilisateur -->
              <td class="px-6 py-4 whitespace-nowrap">
                <div class="flex items-center">
                  <div class="h-10 w-10 rounded-full bg-gray-100 flex-shrink-0 overflow-hidden">
                    <img 
                      v-if="user.avatar_url"
                      :src="user.avatar_url"
                      class="h-full w-full object-cover"
                      alt="Avatar"
                    />
                    <div v-else class="h-full w-full flex items-center justify-center">
                      <User class="h-5 w-5 text-gray-400" />
                    </div>
                  </div>
                  <div class="ml-3">
                    <div class="font-medium text-gray-900">
                      {{ user.first_name }} {{ user.last_name }}
                    </div>
                    <div class="text-xs text-gray-500">ID: {{ truncateId(user.id) }}</div>
                  </div>
                </div>
              </td>
              
              <!-- Email -->
              <td class="px-6 py-4 whitespace-nowrap text-gray-700">
                {{ user.email }}
              </td>
              
              <!-- Rôle -->
              <td class="px-6 py-4 whitespace-nowrap">
                <span 
                  class="px-2.5 py-1 text-xs font-medium rounded-full"
                  :class="getRoleClass(user.role)"
                >
                  {{ getRoleText(user.role) }}
                </span>
              </td>
              
              <!-- Date d'inscription -->
              <td class="px-6 py-4 whitespace-nowrap text-gray-700">
                {{ formatDate(user.created_at) }}
              </td>
              
              <!-- Actions -->
              <td class="px-6 py-4 whitespace-nowrap text-right">
                <div class="flex items-center justify-end space-x-3">
                  <button 
                    @click="viewUser(user)"
                    class="text-gray-500 hover:text-gray-700 transition-colors"
                    title="Voir le profil"
                  >
                    <Eye class="h-5 w-5" />
                  </button>
                  <button 
                    @click="editUser(user)"
                    class="text-gray-500 hover:text-blue-600 transition-colors"
                    title="Modifier"
                  >
                    <Edit class="h-5 w-5" />
                  </button>
                  <button 
                    @click="confirmDelete(user)"
                    class="text-gray-500 hover:text-red-600 transition-colors"
                    title="Supprimer"
                  >
                    <Trash2 class="h-5 w-5" />
                  </button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      
      <!-- Pagination -->
      <div v-if="!loading && totalPages > 1" class="px-6 py-4 bg-white border-t border-gray-200 flex items-center justify-between">
        <div class="hidden sm:block">
          <p class="text-sm text-gray-500">
            Affichage de <span class="font-medium">{{ filteredUsers.length }}</span> utilisateurs sur <span class="font-medium">{{ users.length }}</span>
          </p>
        </div>
        <div class="flex-1 flex justify-center sm:justify-end">
          <nav class="relative z-0 inline-flex rounded-md shadow-sm -space-x-px" aria-label="Pagination">
            <button
              @click="currentPage--"
              :disabled="currentPage === 1"
              class="relative inline-flex items-center px-2 py-2 rounded-l-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
            >
              <span class="sr-only">Précédent</span>
              <ChevronLeft class="h-5 w-5" />
            </button>
            <button
              v-for="page in totalPages"
              :key="page"
              @click="currentPage = page"
              :class="[
                'relative inline-flex items-center px-4 py-2 border text-sm font-medium',
                currentPage === page
                  ? 'z-10 bg-blue-50 border-blue-500 text-blue-600'
                  : 'bg-white border-gray-300 text-gray-500 hover:bg-gray-50'
              ]"
            >
              {{ page }}
            </button>
            <button
              @click="currentPage++"
              :disabled="currentPage === totalPages"
              class="relative inline-flex items-center px-2 py-2 rounded-r-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
            >
              <span class="sr-only">Suivant</span>
              <ChevronRight class="h-5 w-5" />
            </button>
          </nav>
        </div>
      </div>
    </div>
    
    <!-- Modal Utilisateur -->
    <Teleport to="body">
      <div v-if="showUserModal" class="fixed inset-0 z-50 overflow-y-auto" aria-labelledby="modal-title" role="dialog" aria-modal="true">
        <div class="flex items-end justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">
          <!-- Fond du modal -->
          <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity" aria-hidden="true" @click="showUserModal = false"></div>
          
          <!-- Centrage du modal -->
          <span class="hidden sm:inline-block sm:align-middle sm:h-screen" aria-hidden="true">&#8203;</span>
          
          <!-- Contenu du modal -->
          <div class="inline-block align-bottom bg-white rounded-xl text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-lg sm:w-full">
            <div class="bg-white px-4 pt-5 pb-4 sm:p-6 sm:pb-4">
              <div class="flex justify-between items-center mb-4">
                <h3 class="text-lg leading-6 font-medium text-gray-900" id="modal-title">
                  {{ editMode ? 'Modifier l\'utilisateur' : 'Ajouter un utilisateur' }}
                </h3>
                <button @click="showUserModal = false" class="text-gray-400 hover:text-gray-500">
                  <X class="h-5 w-5" />
                </button>
              </div>
              
              <form @submit.prevent="saveUser" class="space-y-4">
                <div class="grid grid-cols-2 gap-4">
                  <div>
                    <label for="first_name" class="block text-sm font-medium text-gray-700">Prénom</label>
                    <input
                      id="first_name"
                      v-model="userForm.first_name"
                      type="text"
                      class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-primary-500 focus:border-primary-500 sm:text-sm"
                      required
                    />
                  </div>
                  <div>
                    <label for="last_name" class="block text-sm font-medium text-gray-700">Nom</label>
                    <input
                      id="last_name"
                      v-model="userForm.last_name"
                      type="text"
                      class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-primary-500 focus:border-primary-500 sm:text-sm"
                      required
                    />
                  </div>
                </div>
                
                <div>
                  <label for="email" class="block text-sm font-medium text-gray-700">Email</label>
                  <input
                    id="email"
                    v-model="userForm.email"
                    type="email"
                    class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-primary-500 focus:border-primary-500 sm:text-sm"
                    required
                  />
                </div>
                
                <div v-if="!editMode">
                  <label for="password" class="block text-sm font-medium text-gray-700">Mot de passe</label>
                  <input
                    id="password"
                    v-model="userForm.password"
                    type="password"
                    class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-primary-500 focus:border-primary-500 sm:text-sm"
                    required
                  />
                </div>
                
                <div>
                  <label for="role" class="block text-sm font-medium text-gray-700">Rôle</label>
                  <select
                    id="role"
                    v-model="userForm.role"
                    class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-primary-500 focus:border-primary-500 sm:text-sm"
                  >
                    <option value="user">Utilisateur</option>
                    <option value="expert">Expert</option>
                    <option value="admin">Administrateur</option>
                  </select>
                </div>
                
                <div class="flex justify-end space-x-3 mt-5">
                  <button
                    type="button"
                    @click="showUserModal = false"
                    class="px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md shadow-sm hover:bg-gray-50 focus:outline-none"
                  >
                    Annuler
                  </button>
                  <button
                    type="submit"
                    class="px-4 py-2 text-sm font-medium text-white bg-primary-600 border border-transparent rounded-md shadow-sm hover:bg-primary-700 focus:outline-none relative"
                    :disabled="saving"
                  >
                    <span v-if="!saving">{{ editMode ? 'Mettre à jour' : 'Ajouter' }}</span>
                    <Loader2 v-else class="h-5 w-5 animate-spin mx-auto" />
                  </button>
                </div>
              </form>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Modal de confirmation de suppression -->
      <div v-if="showDeleteModal" class="fixed inset-0 z-50 overflow-y-auto" aria-labelledby="modal-title" role="dialog" aria-modal="true">
        <div class="flex items-end justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">
          <!-- Fond du modal -->
          <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity" aria-hidden="true" @click="showDeleteModal = false"></div>
          
          <!-- Centrage du modal -->
          <span class="hidden sm:inline-block sm:align-middle sm:h-screen" aria-hidden="true">&#8203;</span>
          
          <!-- Contenu du modal -->
          <div class="inline-block align-bottom bg-white rounded-xl text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-lg sm:w-full">
            <div class="bg-white px-4 pt-5 pb-4 sm:p-6 sm:pb-4">
              <div class="sm:flex sm:items-start">
                <div class="mx-auto flex-shrink-0 flex items-center justify-center h-12 w-12 rounded-full bg-red-100 sm:mx-0 sm:h-10 sm:w-10">
                  <AlertTriangle class="h-6 w-6 text-red-600" />
                </div>
                <div class="mt-3 text-center sm:mt-0 sm:ml-4 sm:text-left">
                  <h3 class="text-lg leading-6 font-medium text-gray-900" id="modal-title">
                    Supprimer l'utilisateur
                  </h3>
                  <div class="mt-2">
                    <p class="text-sm text-gray-500">
                      Êtes-vous sûr de vouloir supprimer cet utilisateur ? Cette action est irréversible et supprimera définitivement l'utilisateur et toutes ses données associées.
                    </p>
                  </div>
                </div>
              </div>
            </div>
            <div class="bg-gray-50 px-4 py-3 sm:px-6 sm:flex sm:flex-row-reverse">
              <button 
                type="button" 
                class="w-full inline-flex justify-center rounded-md border border-transparent shadow-sm px-4 py-2 bg-red-600 text-base font-medium text-white hover:bg-red-700 focus:outline-none sm:ml-3 sm:w-auto sm:text-sm relative"
                @click="deleteUser"
                :disabled="deleting"
              >
                <span v-if="!deleting">Supprimer</span>
                <Loader2 v-else class="h-5 w-5 animate-spin mx-auto" />
              </button>
              <button 
                type="button" 
                class="mt-3 w-full inline-flex justify-center rounded-md border border-gray-300 shadow-sm px-4 py-2 bg-white text-base font-medium text-gray-700 hover:bg-gray-50 focus:outline-none sm:mt-0 sm:ml-3 sm:w-auto sm:text-sm"
                @click="showDeleteModal = false"
              >
                Annuler
              </button>
            </div>
          </div>
        </div>
      </div>
    </Teleport>
  </div>
</template>

<script setup>
import { 
  Search, ChevronDown, Plus, User, Loader2, Users, 
  ChevronLeft, ChevronRight, Edit, Eye, Trash2, X, AlertTriangle, Wrench, Shield, PageHeader, StatCard
} from 'lucide-vue-next'
import { ref, computed, watch } from 'vue'

const client = useSupabaseClient()
const loading = ref(true)
const users = ref([])
const search = ref('')
const roleFilter = ref('')
const currentPage = ref(1)
const itemsPerPage = 10
const showUserModal = ref(false)
const showDeleteModal = ref(false)
const editMode = ref(false)
const userToDelete = ref(null)
const saving = ref(false)
const deleting = ref(false)

// Formulaire utilisateur
const userForm = ref({
  id: '',
  first_name: '',
  last_name: '',
  email: '',
  password: '',
  role: 'user'
})

// Filtrage des utilisateurs
const filteredUsers = computed(() => {
  let filtered = [...users.value]
  
  // Filtrer par recherche
  if (search.value) {
    const searchLower = search.value.toLowerCase()
    filtered = filtered.filter(user => 
      `${user.first_name} ${user.last_name}`.toLowerCase().includes(searchLower) ||
      user.email.toLowerCase().includes(searchLower)
    )
  }
  
  // Filtrer par rôle
  if (roleFilter.value) {
    filtered = filtered.filter(user => user.role === roleFilter.value)
  }
  
  // Pagination
  const startIndex = (currentPage.value - 1) * itemsPerPage
  return filtered.slice(startIndex, startIndex + itemsPerPage)
})

// Nombre total de pages
const totalPages = computed(() => {
  let filtered = [...users.value]
  
  if (search.value) {
    const searchLower = search.value.toLowerCase()
    filtered = filtered.filter(user => 
      `${user.first_name} ${user.last_name}`.toLowerCase().includes(searchLower) ||
      user.email.toLowerCase().includes(searchLower)
    )
  }
  
  if (roleFilter.value) {
    filtered = filtered.filter(user => user.role === roleFilter.value)
  }
  
  return Math.max(1, Math.ceil(filtered.length / itemsPerPage))
})

// Formatage de date
const formatDate = (dateString) => {
  if (!dateString) return ''
  const date = new Date(dateString)
  return date.toLocaleDateString('fr-FR', {
    day: 'numeric',
    month: 'short',
    year: 'numeric'
  })
}

// Tronquer l'ID
const truncateId = (id) => {
  if (!id) return ''
  return id.length > 8 ? `${id.substring(0, 8)}...` : id
}

// Ajoutez ces fonctions pour gérer les rôles
const getRoleText = (role) => {
  switch(role) {
    case 'admin': return 'Administrateur';
    case 'expert': return 'Expert';
    case 'user': return 'Utilisateur';
    default: return role || 'Non défini';
  }
}

const getRoleClass = (role) => {
  switch(role) {
    case 'admin': return 'bg-purple-100 text-purple-800';
    case 'expert': return 'bg-blue-100 text-blue-800';
    case 'user': return 'bg-gray-100 text-gray-800';
    default: return 'bg-gray-100 text-gray-800';
  }
}

// Charger les utilisateurs
const fetchUsers = async () => {
  try {
    loading.value = true
    
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

// Ouvrir le modal d'ajout d'utilisateur
const openUserModal = () => {
  editMode.value = false
  userForm.value = {
    id: '',
    first_name: '',
    last_name: '',
    email: '',
    password: '',
    role: 'user'
  }
  showUserModal.value = true
}

// Ouvrir le modal de modification d'utilisateur
const editUser = (user) => {
  editMode.value = true
  userForm.value = {
    id: user.id,
    first_name: user.first_name,
    last_name: user.last_name,
    email: user.email,
    role: user.role || 'user'
  }
  showUserModal.value = true
}

// Voir les détails d'un utilisateur
const viewUser = (user) => {
  // Rediriger vers la page de détails de l'utilisateur
  navigateTo(`/admin/users/${user.id}`)
}

// Confirmer la suppression d'un utilisateur
const confirmDelete = (user) => {
  userToDelete.value = user
  showDeleteModal.value = true
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
          first_name: userForm.value.first_name,
          last_name: userForm.value.last_name,
          email: userForm.value.email,
          role: userForm.value.role,
          updated_at: new Date().toISOString()
        })
        .eq('id', userForm.value.id)
      
      if (profileError) throw profileError
      
    } else {
      // Création d'un nouvel utilisateur
      const { data: authData, error: authError } = await client.auth.admin.createUser({
        email: userForm.value.email,
        password: userForm.value.password,
        email_confirm: true
      })
      
      if (authError) throw authError
      
      // Créer le profil associé avec le rôle
      const { error: profileError } = await client
        .from('profiles')
        .upsert({
          id: authData.user.id,
          first_name: userForm.value.first_name,
          last_name: userForm.value.last_name,
          email: userForm.value.email,
          role: userForm.value.role,
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