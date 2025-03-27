<template>
  <div class="max-w-7xl mx-auto px-4 py-8">
    <!-- En-tête de la page -->
    <div class="flex justify-between items-center mb-8">
      <div>
        <h1 class="text-2xl font-bold text-gray-900 dark:text-white">Gestion des catégories</h1>
        <p class="text-gray-600 dark:text-gray-400 mt-1">Créez et gérez les catégories de services et demandes</p>
      </div>
      
      <button 
        @click="openAddModal"
        class="flex items-center px-6 py-2.5 bg-primary-600 hover:bg-primary-700 text-white text-sm font-medium rounded-full transition-colors shadow-sm"
      >
        <Plus class="h-4 w-4 mr-1.5" />
        Ajouter une catégorie
      </button>
    </div>
    
    <!-- Alerte de statut -->
    <div 
      v-if="statusMessage.show"
      :class="[
        'p-4 mb-6 rounded-xl border flex items-start',
        statusMessage.type === 'success' ? 'bg-green-50 border-green-200 text-green-800 dark:bg-green-900/30 dark:border-green-800 dark:text-green-300' : '',
        statusMessage.type === 'error' ? 'bg-red-50 border-red-200 text-red-800 dark:bg-red-900/30 dark:border-red-800 dark:text-red-300' : '',
        statusMessage.type === 'info' ? 'bg-blue-50 border-blue-200 text-blue-800 dark:bg-blue-900/30 dark:border-blue-800 dark:text-blue-300' : '',
        statusMessage.type === 'warning' ? 'bg-yellow-50 border-yellow-200 text-yellow-800 dark:bg-yellow-900/30 dark:border-yellow-800 dark:text-yellow-300' : ''
      ]"
    >
      <div class="flex-shrink-0 mr-3">
        <CheckCircle v-if="statusMessage.type === 'success'" class="h-5 w-5" />
        <XCircle v-if="statusMessage.type === 'error'" class="h-5 w-5" />
        <AlertCircle v-if="statusMessage.type === 'warning'" class="h-5 w-5" />
        <Info v-if="statusMessage.type === 'info'" class="h-5 w-5" />
      </div>
      <div class="flex-1">
        <p class="text-sm font-medium">{{ statusMessage.message }}</p>
      </div>
      <button 
        @click="statusMessage.show = false"
        class="p-1 ml-3 rounded-full hover:bg-black/10 dark:hover:bg-white/10 transition-colors"
      >
        <X class="h-4 w-4" />
      </button>
    </div>
    
    <!-- Filtres et recherche -->
    <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 p-6 mb-8 shadow-sm">
      <div class="flex flex-wrap gap-4 items-end">
        <div class="flex-1 min-w-[250px]">
          <label for="search" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">Rechercher</label>
          <div class="relative">
            <input
              v-model="search"
              type="text"
              id="search"
              placeholder="Rechercher une catégorie..."
              class="w-full px-4 py-2.5 border border-gray-300 dark:border-gray-600 rounded-full shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white pl-10"
            />
            <Search class="absolute left-3 top-3 h-4 w-4 text-gray-400" />
          </div>
        </div>
        
        <div class="w-52">
          <label for="status" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">Statut</label>
          <select
            v-model="statusFilter"
            id="status"
            class="w-full px-4 py-2.5 border border-gray-300 dark:border-gray-600 rounded-full shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white appearance-none bg-no-repeat"
          >
            <option value="all">Tous les statuts</option>
            <option value="active">Actives</option>
            <option value="inactive">Inactives</option>
          </select>
        </div>
        
        <div class="w-52">
          <label for="sort" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">Trier par</label>
          <select
            v-model="sortOption"
            id="sort"
            class="w-full px-4 py-2.5 border border-gray-300 dark:border-gray-600 rounded-full shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white appearance-none bg-no-repeat"
          >
            <option value="name">Nom (A-Z)</option>
            <option value="name_desc">Nom (Z-A)</option>
            <option value="recent">Plus récentes</option>
            <option value="oldest">Plus anciennes</option>
            <option value="popular">Les plus populaires</option>
          </select>
        </div>
      </div>
    </div>
    
    <!-- Section de chargement -->
    <div v-if="isLoading" class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 p-16 animate-pulse shadow-sm">
      <div class="flex flex-col items-center justify-center">
        <div class="h-10 w-10 border-4 border-primary-500 border-t-transparent rounded-full animate-spin"></div>
        <p class="mt-4 text-gray-600 dark:text-gray-400 font-medium">Chargement des catégories...</p>
      </div>
    </div>
    
    <!-- Message si aucun résultat -->
    <div v-else-if="filteredCategories.length === 0" class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 p-16 text-center shadow-sm">
      <div class="flex flex-col items-center justify-center">
        <FolderX class="h-12 w-12 text-gray-400 mb-3" />
        <h3 class="text-lg font-medium text-gray-900 dark:text-gray-100 mb-1">Aucune catégorie trouvée</h3>
        <p class="text-gray-600 dark:text-gray-400">
          {{ search ? `Aucun résultat pour "${search}"` : 'Aucune catégorie disponible avec ces filtres' }}
        </p>
        <button 
          @click="resetFilters"
          class="mt-4 px-4 py-2 bg-gray-100 dark:bg-gray-700 text-gray-700 dark:text-gray-300 rounded-full text-sm font-medium hover:bg-gray-200 dark:hover:bg-gray-600 transition-colors"
        >
          Réinitialiser les filtres
        </button>
      </div>
    </div>
    
    <!-- Liste des catégories -->
    <div v-else class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      <div 
        v-for="category in paginatedCategories" 
        :key="category.id"
        class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 overflow-hidden shadow-sm hover:shadow-md transition-shadow"
      >
        <!-- En-tête de la carte -->
        <div class="p-6 border-b border-gray-200 dark:border-gray-700">
          <div class="flex justify-between items-start">
            <div class="flex items-center">
              <!-- Icône colorée selon category.color -->
              <div 
                :class="[
                  'h-10 w-10 rounded-full flex items-center justify-center',
                  `bg-${category.color || 'primary'}-100 dark:bg-${category.color || 'primary'}-900/30`,
                  `text-${category.color || 'primary'}-600 dark:text-${category.color || 'primary'}-400`
                ]"
              >
                <TagIcon class="h-5 w-5" />
              </div>
              <div class="ml-4">
                <h3 class="font-medium text-lg text-gray-900 dark:text-white">{{ category.name }}</h3>
                <div class="flex items-center mt-1">
                  <span 
                    :class="[
                      'inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium',
                      category.is_active !== false ? 'bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-300' : 'bg-gray-100 text-gray-800 dark:bg-gray-700 dark:text-gray-300'
                    ]"
                  >
                    {{ category.is_active !== false ? 'Active' : 'Inactive' }}
                  </span>
                  <span class="mx-2 text-gray-300 dark:text-gray-600">•</span>
                  <span class="text-sm text-gray-500 dark:text-gray-400">
                    {{ formatDate(category.created_at) }}
                  </span>
                </div>
              </div>
            </div>
            
            <!-- Menu d'actions -->
            <div class="flex space-x-1">
              <button 
                @click="openEditModal(category)"
                class="p-1.5 text-gray-500 dark:text-gray-400 hover:text-gray-700 dark:hover:text-gray-200 rounded-full hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors"
                title="Modifier"
              >
                <Pencil class="h-4 w-4" />
              </button>
              <button 
                @click="openDeleteModal(category)"
                class="p-1.5 text-red-500 dark:text-red-400 hover:text-red-700 dark:hover:text-red-300 rounded-full hover:bg-red-50 dark:hover:bg-red-900/20 transition-colors"
                title="Supprimer"
              >
                <Trash2 class="h-4 w-4" />
              </button>
            </div>
          </div>
        </div>
        
        <!-- Description -->
        <div class="px-6 py-4">
          <p class="text-sm text-gray-600 dark:text-gray-400">
            {{ category.description || 'Aucune description disponible' }}
          </p>
        </div>
        
        <!-- Statistiques -->
        <div class="px-6 py-4 bg-gray-50 dark:bg-gray-750 border-t border-gray-200 dark:border-gray-700">
          <div class="flex justify-between">
            <div>
              <div class="text-sm font-medium text-gray-500 dark:text-gray-400">Services</div>
              <div class="mt-1 text-xl font-bold text-gray-900 dark:text-white">{{ category.services_count || 0 }}</div>
            </div>
            <div>
              <div class="text-sm font-medium text-gray-500 dark:text-gray-400">Demandes</div>
              <div class="mt-1 text-xl font-bold text-gray-900 dark:text-white">{{ category.missions_count || 0 }}</div>
            </div>
          </div>
        </div>
      </div>
    </div>
    
    <!-- Pagination -->
    <div v-if="!isLoading && totalPages > 1" class="mt-8 flex justify-center">
      <div class="inline-flex rounded-md shadow-sm">
        <button
          @click="goToPage(currentPage - 1)"
          :disabled="currentPage === 1"
          class="px-4 py-2 text-sm font-medium text-gray-700 dark:text-gray-300 bg-white dark:bg-gray-800 border border-gray-300 dark:border-gray-600 rounded-l-lg hover:bg-gray-50 dark:hover:bg-gray-700 disabled:opacity-50 disabled:cursor-not-allowed"
        >
          Précédent
        </button>
        
        <button
          v-for="page in totalPages"
          :key="page"
          @click="goToPage(page)"
          :class="[
            'px-4 py-2 text-sm font-medium bg-white dark:bg-gray-800 border border-gray-300 dark:border-gray-600 border-l-0',
            currentPage === page ? 'text-primary-600 dark:text-primary-400 border-primary-500 dark:border-primary-400 z-10' : 'text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700'
          ]"
        >
          {{ page }}
        </button>
        
        <button
          @click="goToPage(currentPage + 1)"
          :disabled="currentPage === totalPages"
          class="px-4 py-2 text-sm font-medium text-gray-700 dark:text-gray-300 bg-white dark:bg-gray-800 border border-gray-300 dark:border-gray-600 border-l-0 rounded-r-lg hover:bg-gray-50 dark:hover:bg-gray-700 disabled:opacity-50 disabled:cursor-not-allowed"
        >
          Suivant
        </button>
      </div>
    </div>
    
    <!-- Modal d'ajout/modification de catégorie -->
    <Teleport to="body">
      <Transition name="modal">
        <div v-if="showCategoryModal" class="fixed inset-0 z-50 overflow-y-auto" role="dialog">
          <div class="flex min-h-screen items-center justify-center p-4">
            <!-- Overlay -->
            <div class="fixed inset-0 bg-black/50 backdrop-blur-sm transition-opacity" @click="closeCategoryModal"></div>
            
            <!-- Modal -->
            <div class="relative w-full max-w-lg rounded-xl bg-white dark:bg-gray-800 shadow-xl transition-all p-6">
              <div class="mb-5">
                <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
                  {{ editMode ? 'Modifier la catégorie' : 'Ajouter une nouvelle catégorie' }}
                </h3>
                <p class="mt-1 text-sm text-gray-600 dark:text-gray-400">
                  {{ editMode ? 'Modifiez les informations de cette catégorie' : 'Remplissez les champs pour créer une nouvelle catégorie' }}
                </p>
              </div>
              
              <form @submit.prevent="saveCategory">
                <!-- Nom de la catégorie -->
                <div class="mb-4">
                  <label for="name" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Nom</label>
                  <input
                    id="name"
                    v-model="formData.name"
                    type="text"
                    class="w-full px-4 py-2.5 border border-gray-300 dark:border-gray-600 rounded-lg shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
                    placeholder="Nom de la catégorie"
                    required
                  />
                </div>
                
                <!-- Description -->
                <div class="mb-4">
                  <label for="description" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Description</label>
                  <textarea
                    id="description"
                    v-model="formData.description"
                    rows="3"
                    class="w-full px-4 py-2.5 border border-gray-300 dark:border-gray-600 rounded-lg shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
                    placeholder="Description de la catégorie"
                  ></textarea>
                </div>
                
                <!-- Statut -->
                <div class="mb-4">
                  <div class="flex items-center">
                    <input
                      id="is_active"
                      v-model="formData.is_active"
                      type="checkbox"
                      class="h-4 w-4 rounded border-gray-300 text-primary-600 focus:ring-primary-500 dark:border-gray-600 dark:focus:ring-primary-400 dark:bg-gray-700"
                    />
                    <label for="is_active" class="ml-2 block text-sm text-gray-700 dark:text-gray-300">
                      Catégorie active
                    </label>
                  </div>
                </div>
                
                <!-- Couleur -->
                <div class="mb-6">
                  <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Couleur</label>
                  <div class="color-selector">
                    <button
                      v-for="color in ['primary', 'red', 'green', 'blue', 'yellow', 'purple', 'pink', 'indigo']"
                      :key="color"
                      type="button"
                      @click="formData.color = color"
                      :class="[
                        'color-option',
                        `bg-${color}-500`,
                        formData.color === color ? 'selected' : ''
                      ]"
                    ></button>
                  </div>
                </div>
                
                <!-- Boutons d'actions -->
                <div class="flex justify-end space-x-3 mt-6">
                  <button
                    type="button"
                    @click="closeCategoryModal"
                    class="px-4 py-2 text-sm font-medium text-gray-700 dark:text-gray-300 bg-white dark:bg-gray-700 border border-gray-300 dark:border-gray-600 rounded-lg hover:bg-gray-50 dark:hover:bg-gray-600 transition-colors"
                  >
                    Annuler
                  </button>
                  <button
                    type="submit"
                    class="px-4 py-2 text-sm font-medium text-white bg-primary-600 hover:bg-primary-700 rounded-lg shadow-sm transition-colors disabled:opacity-70 disabled:cursor-not-allowed"
                    :disabled="isSaving"
                  >
                    <div v-if="isSaving" class="flex items-center">
                      <div class="h-4 w-4 border-2 border-white border-t-transparent rounded-full animate-spin mr-2"></div>
                      {{ editMode ? 'Mise à jour...' : 'Création...' }}
                    </div>
                    <span v-else>{{ editMode ? 'Mettre à jour' : 'Créer' }}</span>
                  </button>
                </div>
              </form>
            </div>
          </div>
        </div>
      </Transition>
    </Teleport>
    
    <!-- Modal de confirmation de suppression -->
    <Teleport to="body">
      <Transition name="modal">
        <div v-if="showDeleteModal" class="fixed inset-0 z-50 overflow-y-auto" role="dialog">
          <div class="flex min-h-screen items-center justify-center p-4">
            <!-- Overlay -->
            <div class="fixed inset-0 bg-black/50 backdrop-blur-sm transition-opacity" @click="closeDeleteModal"></div>
            
            <!-- Modal -->
            <div class="relative w-full max-w-md rounded-xl bg-white dark:bg-gray-800 shadow-xl transition-all p-6">
              <div class="text-center">
                <div class="mx-auto flex h-12 w-12 items-center justify-center rounded-full bg-red-100 dark:bg-red-900/30">
                  <Trash2 class="h-6 w-6 text-red-600 dark:text-red-400" />
                </div>
                <h3 class="mt-3 text-lg font-medium text-gray-900 dark:text-white">
                  Supprimer la catégorie
                </h3>
                <p class="mt-2 text-sm text-gray-600 dark:text-gray-400">
                  Êtes-vous sûr de vouloir supprimer la catégorie "{{ deleteTarget?.name }}" ? Cette action ne peut pas être annulée.
                </p>
                
                <div class="mt-4">
                  <div class="bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800 rounded-lg p-4 text-sm text-red-600 dark:text-red-400">
                    <p>
                      <strong>Attention :</strong> La suppression de cette catégorie pourrait affecter les services et demandes associés.
                    </p>
                  </div>
                </div>
              </div>
              
              <div class="mt-6 flex justify-center space-x-3">
                <button
                  type="button"
                  @click="closeDeleteModal"
                  class="px-4 py-2 text-sm font-medium text-gray-700 dark:text-gray-300 bg-white dark:bg-gray-700 border border-gray-300 dark:border-gray-600 rounded-lg hover:bg-gray-50 dark:hover:bg-gray-600 transition-colors"
                >
                  Annuler
                </button>
                <button
                  type="button"
                  @click="deleteCategory"
                  class="px-4 py-2 text-sm font-medium text-white bg-red-600 hover:bg-red-700 rounded-lg shadow-sm transition-colors disabled:opacity-70 disabled:cursor-not-allowed"
                  :disabled="isDeleting"
                >
                  <div v-if="isDeleting" class="flex items-center">
                    <div class="h-4 w-4 border-2 border-white border-t-transparent rounded-full animate-spin mr-2"></div>
                    Suppression...
                  </div>
                  <span v-else>Supprimer</span>
                </button>
              </div>
            </div>
          </div>
        </div>
      </Transition>
    </Teleport>
  </div>
</template>

<script setup>
import { ref, computed, watch, onMounted } from 'vue'
import { 
  Search, 
  Plus, 
  Pencil, 
  Trash2, 
  FolderX,
  CheckCircle,
  XCircle,
  AlertCircle,
  Info,
  X,
  TagIcon
} from 'lucide-vue-next'

// État
const professions = ref([])
const isLoading = ref(true)
const isSaving = ref(false)
const isDeleting = ref(false)
const search = ref('')
const statusFilter = ref('all')
const sortOption = ref('name')
const currentPage = ref(1)
const perPage = ref(6)
const showCategoryModal = ref(false)
const showDeleteModal = ref(false)
const editMode = ref(false)
const deleteTarget = ref(null)
const statusMessage = ref({
  show: false,
  type: 'info',
  message: ''
})

// Données du formulaire
const initialFormData = {
  name: '',
  icon: 'TagIcon',
  description: '',
  is_active: true,
  color: 'primary'
}
const formData = ref({ ...initialFormData })

// Composables
const supabase = useSupabaseClient()

// Filtrer les catégories
const filteredCategories = computed(() => {
  let filtered = [...professions.value]
  
  // Filtre par recherche
  if (search.value) {
    const searchLower = search.value.toLowerCase()
    filtered = filtered.filter(category => 
      category.name.toLowerCase().includes(searchLower) || 
      (category.description && category.description.toLowerCase().includes(searchLower))
    )
  }
  
  // Filtre par statut
  if (statusFilter.value !== 'all') {
    filtered = filtered.filter(category => {
      if (statusFilter.value === 'active') return category.is_active !== false
      if (statusFilter.value === 'inactive') return category.is_active === false
      return true
    })
  }
  
  // Tri
  switch (sortOption.value) {
    case 'name':
      filtered.sort((a, b) => a.name.localeCompare(b.name))
      break
    case 'name_desc':
      filtered.sort((a, b) => b.name.localeCompare(a.name))
      break
    case 'recent':
      filtered.sort((a, b) => new Date(b.created_at || 0) - new Date(a.created_at || 0))
      break
    case 'oldest':
      filtered.sort((a, b) => new Date(a.created_at || 0) - new Date(b.created_at || 0))
      break
    case 'popular':
      filtered.sort((a, b) => (b.services_count + b.missions_count) - (a.services_count + a.missions_count))
      break
  }
  
  return filtered
})

// Pagination
const totalPages = computed(() => Math.ceil(filteredCategories.value.length / perPage.value))
const paginatedCategories = computed(() => {
  const start = (currentPage.value - 1) * perPage.value
  const end = start + perPage.value
  return filteredCategories.value.slice(start, end)
})

// Récupérer toutes les catégories - Version corrigée
const fetchCategories = async () => {
  isLoading.value = true
  
  try {
    // Version simplifiée qui ne tente pas de joindre les tables services et missions
    const { data, error } = await supabase
      .from('service_professions')
      .select('*')
    
    if (error) throw error
    
    // Transformation des données
    professions.value = data || []
    
    // Si vous avez besoin des comptages, récupérez-les séparément
    if (professions.value.length > 0) {
      await fetchRelatedCounts()
    }
  } catch (error) {
    console.error('Erreur lors de la récupération des catégories:', error)
    showStatusMessage('error', 'Erreur lors de la récupération des catégories: ' + error.message)
  } finally {
    isLoading.value = false
  }
}

// Fonction pour récupérer les comptages séparément
const fetchRelatedCounts = async () => {
  try {
    // Récupérer les comptages des services
    // Note: adapté pour utiliser la table correcte selon l'erreur
    const { data: serviceData, error: serviceError } = await supabase
      .from('services') // Utilise le nom suggéré dans l'erreur
      .select('profession_id, count')
      .eq('is_active', true)
      .groupBy('profession_id')
    
    if (serviceError) throw serviceError
    
    // Récupérer les comptages des demandes
    const { data: missionData, error: missionError } = await supabase
      .from('missions')
      .select('profession_id, count')
      .eq('is_active', true)
      .groupBy('profession_id')
    
    if (missionError) throw missionError
    
    // Mettre à jour les comptages dans les catégories
    professions.value = professions.value.map(category => {
      const serviceCount = serviceData?.find(s => s.profession_id === category.id)?.count || 0
      const missionCount = missionData?.find(r => r.profession_id === category.id)?.count || 0
      
      return {
        ...category,
        services_count: parseInt(serviceCount),
        missions_count: parseInt(missionCount)
      }
    })
  } catch (error) {
    console.error('Erreur lors de la récupération des comptages:', error)
  }
}

// Ouvrir le modal d'ajout
const openAddModal = () => {
  editMode.value = false
  formData.value = { ...initialFormData }
  showCategoryModal.value = true
}

// Ouvrir le modal d'édition
const openEditModal = (category) => {
  editMode.value = true
  formData.value = { 
    id: category.id,
    name: category.name,
    icon: category.icon || 'TagIcon',
    description: category.description || '',
    is_active: category.is_active !== false,
    color: category.color || 'primary'
  }
  showCategoryModal.value = true
}

// Ouvrir le modal de suppression
const openDeleteModal = (category) => {
  deleteTarget.value = category
  showDeleteModal.value = true
}

// Fermer le modal de catégorie
const closeCategoryModal = () => {
  showCategoryModal.value = false
  setTimeout(() => {
    formData.value = { ...initialFormData }
    editMode.value = false
  }, 300)
}

// Fermer le modal de suppression
const closeDeleteModal = () => {
  showDeleteModal.value = false
  setTimeout(() => {
    deleteTarget.value = null
  }, 300)
}

// Sauvegarder une catégorie (ajout ou modification)
const saveCategory = async () => {
  isSaving.value = true
  
  try {
    const categoryData = {
      name: formData.value.name,
      icon: formData.value.icon,
      description: formData.value.description,
      is_active: formData.value.is_active,
      color: formData.value.color
    }
    
    if (editMode.value) {
      // Mise à jour d'une catégorie existante
      const { error } = await supabase
        .from('professions')
        .update({
          ...categoryData,
          updated_at: new Date().toISOString()
        })
        .eq('id', formData.value.id)
      
      if (error) throw error
      
      showStatusMessage('success', 'Catégorie mise à jour avec succès')
    } else {
      // Ajout d'une nouvelle catégorie
      const { error } = await supabase
        .from('professions')
        .insert([{
          ...categoryData,
          created_at: new Date().toISOString(),
          updated_at: new Date().toISOString()
        }])
      
      if (error) throw error
      
      showStatusMessage('success', 'Catégorie ajoutée avec succès')
    }
    
    // Rafraîchir la liste et fermer le modal
    await fetchCategories()
    closeCategoryModal()
  } catch (error) {
    console.error('Erreur lors de la sauvegarde de la catégorie:', error)
    showStatusMessage('error', 'Erreur lors de la sauvegarde de la catégorie')
  } finally {
    isSaving.value = false
  }
}

// Supprimer une catégorie
const deleteCategory = async () => {
  if (!deleteTarget.value) return
  
  isDeleting.value = true
  
  try {
    const { error } = await supabase
      .from('professions')
      .delete()
      .eq('id', deleteTarget.value.id)
    
    if (error) throw error
    
    // Mise à jour de la liste locale
    professions.value = professions.value.filter(c => c.id !== deleteTarget.value.id)
    
    showStatusMessage('success', 'Catégorie supprimée avec succès')
    showDeleteModal.value = false
    deleteTarget.value = null
  } catch (error) {
    console.error('Erreur lors de la suppression de la catégorie:', error)
    showStatusMessage('error', 'Erreur lors de la suppression de la catégorie')
  } finally {
    isDeleting.value = false
  }
}

// Afficher un message de statut
const showStatusMessage = (type, message, duration = 5000) => {
  statusMessage.value = {
    show: true,
    type,
    message
  }
  
  setTimeout(() => {
    statusMessage.value.show = false
  }, duration)
}

// Formater la date
const formatDate = (dateString) => {
  if (!dateString) return '-'
  
  return new Date(dateString).toLocaleDateString('fr-FR', {
    day: 'numeric',
    month: 'long',
    year: 'numeric'
  })
}

// Pagination
const goToPage = (page) => {
  currentPage.value = page
}

// Réinitialiser les filtres
const resetFilters = () => {
  search.value = ''
  statusFilter.value = 'all'
  sortOption.value = 'name'
  currentPage.value = 1
}

// Réinitialiser la page quand les filtres changent
watch([search, statusFilter, sortOption], () => {
  currentPage.value = 1
})

// Initialisation
onMounted(() => {
  fetchCategories()
})
</script>

<style scoped>
/* Style pour les sélecteurs avec flèche dropdown */
select {
  background-position: right 1rem center;
  background-repeat: no-repeat;
  background-size: 1em;
  background-image: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/></svg>');
}

/* Animation pour le modal */
.modal-enter-active,
.modal-leave-active {
  transition: opacity 0.25s ease, transform 0.25s ease;
}

.modal-enter-from,
.modal-leave-to {
  opacity: 0;
  transform: scale(0.95);
}

/* Style pour la sélection d'icône */
.icon-selector {
  display: grid;
  grid-template-columns: repeat(6, 1fr);
  gap: 0.5rem;
}

.icon-option {
  aspect-ratio: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 0.5rem;
  cursor: pointer;
  transition: all 0.2s ease;
}

.icon-option:hover {
  background-color: rgba(79, 70, 229, 0.1);
}

.icon-option.selected {
  background-color: rgba(79, 70, 229, 0.2);
  border: 2px solid #4f46e5;
}

.dark .icon-option:hover {
  background-color: rgba(99, 102, 241, 0.2);
}

.dark .icon-option.selected {
  background-color: rgba(99, 102, 241, 0.3);
  border: 2px solid #6366f1;
}

/* Style pour la palette de couleurs */
.color-selector {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
}

.color-option {
  width: 2rem;
  height: 2rem;
  border-radius: 9999px;
  cursor: pointer;
  transition: transform 0.2s ease;
  position: relative;
}

.color-option:hover {
  transform: scale(1.1);
}

.color-option.selected::after {
  content: '';
  position: absolute;
  inset: -3px;
  border-radius: 9999px;
  border: 2px solid currentColor;
}
</style> 