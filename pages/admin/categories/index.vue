<template>
  <div class="space-y-6 max-w-7xl mx-auto">
    <!-- En-tête avec style Twitter -->
    <div class="px-4 py-6">
      <h1 class="text-2xl font-bold text-gray-900 dark:text-white">Catégories de services</h1>
      <p class="text-gray-600 dark:text-gray-400 mt-1">Gérez les catégories disponibles sur la plateforme</p>
    </div>
    
    <!-- Notifications -->
    <div 
      v-if="notification.show" 
      class="mx-4 p-4 rounded-xl flex items-start gap-3"
      :class="[
        notification.type === 'success' ? 'bg-green-50 text-green-800 dark:bg-green-900/20 dark:text-green-400' : 
        notification.type === 'error' ? 'bg-red-50 text-red-800 dark:bg-red-900/20 dark:text-red-400' : 
        'bg-blue-50 text-blue-800 dark:bg-blue-900/20 dark:text-blue-400'
      ]"
    >
      <component 
        :is="notification.type === 'success' ? 'CheckCircle' : notification.type === 'error' ? 'AlertTriangle' : 'Info'" 
        class="h-5 w-5 mt-0.5 flex-shrink-0" 
      />
      <div>
        <h3 class="font-medium">{{ notification.title }}</h3>
        <p class="text-sm opacity-80 mt-0.5">{{ notification.message }}</p>
      </div>
      <button 
        @click="notification.show = false" 
        class="ml-auto p-1.5 rounded-full hover:bg-black/5 dark:hover:bg-white/5"
      >
        <X class="h-4 w-4" />
      </button>
    </div>
    
    <!-- Statistiques rapides -->
    <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
      <div 
        v-for="stat in stats" 
        :key="stat.label"
        class="bg-white dark:bg-gray-800 p-6 rounded-xl border border-gray-100 dark:border-gray-700"
      >
        <div class="flex items-center justify-between">
          <div>
            <p class="text-sm text-gray-500 dark:text-gray-400">{{ stat.label }}</p>
            <p class="text-2xl font-bold text-gray-900 dark:text-white mt-1">{{ stat.value }}</p>
          </div>
          <div 
            class="h-12 w-12 rounded-full flex items-center justify-center"
            :class="stat.colorClass"
          >
            <component :is="stat.icon" class="h-6 w-6 text-white" />
          </div>
        </div>
      </div>
    </div>
    
    <!-- Filtres et actions -->
    <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-100 dark:border-gray-700 p-5">
      <div class="flex flex-wrap gap-4 items-center justify-between">
        <div class="relative">
          <Search class="absolute left-3 top-2.5 h-5 w-5 text-gray-400" />
          <input 
            v-model="search"
            type="text"
            placeholder="Rechercher une catégorie..."
            class="pl-10 pr-4 py-2 border border-gray-200 dark:border-gray-600 rounded-full focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white w-60"
          />
        </div>
        
        <!-- Actions -->
        <div class="flex items-center gap-2">
          <button 
            @click="refreshData"
            class="flex items-center p-2.5 text-gray-700 dark:text-gray-300 bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-600 rounded-full hover:bg-gray-50 dark:hover:bg-gray-700"
            title="Rafraîchir"
          >
            <RefreshCw class="h-5 w-5" />
          </button>
          <button 
            @click="openCreateModal"
            class="flex items-center gap-2 px-4 py-2 bg-primary-600 hover:bg-primary-700 text-white rounded-full font-medium shadow-sm transition-colors"
          >
            <PlusCircle class="h-5 w-5" />
            <span>Nouvelle catégorie</span>
          </button>
        </div>
      </div>
    </div>
    
    <!-- Liste des catégories -->
    <div v-if="isLoading" class="flex justify-center p-12">
      <div class="inline-block h-8 w-8 animate-spin rounded-full border-4 border-solid border-primary-500 border-r-transparent"></div>
    </div>
    
    <div v-else-if="filteredCategories.length === 0" class="bg-white dark:bg-gray-800 rounded-xl p-8 text-center border border-gray-100 dark:border-gray-700">
      <div class="inline-flex items-center justify-center h-16 w-16 rounded-full bg-gray-100 dark:bg-gray-700 mb-4">
        <Layers class="h-8 w-8 text-gray-500 dark:text-gray-400" />
      </div>
      <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-2">Aucune catégorie trouvée</h3>
      <p class="text-gray-600 dark:text-gray-400 mb-4">
        Commencez par créer une nouvelle catégorie.
      </p>
      <button 
        @click="openCreateModal"
        class="px-4 py-2 bg-primary-600 hover:bg-primary-700 text-white text-sm font-medium rounded-full shadow-sm flex items-center gap-2 mx-auto"
      >
        <PlusCircle class="h-4 w-4" />
        <span>Nouvelle catégorie</span>
      </button>
    </div>
    
    <div v-else class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
      <div 
        v-for="category in filteredCategories" 
        :key="category.id"
        class="bg-white dark:bg-gray-800 rounded-xl border border-gray-100 dark:border-gray-700 overflow-hidden hover:shadow-md transition-all duration-200"
      >
        <!-- En-tête de carte avec couleur -->
        <div 
          class="h-4 w-full"
          :style="{ backgroundColor: category.color || '#6366f1' }"
        ></div>
        
        <div class="p-5">
          <div class="flex items-start justify-between mb-4">
            <div class="flex items-center">
              <div 
                class="h-12 w-12 rounded-full flex items-center justify-center mr-3"
                :style="{ backgroundColor: category.color || '#6366f1' }"
              >
                <component :is="getCategoryIcon(category.icon)" class="h-6 w-6 text-white" />
              </div>
              <div>
                <h3 class="text-xl font-bold text-gray-900 dark:text-white">
                  {{ category.name }}
                </h3>
                <p class="text-gray-600 dark:text-gray-400 text-sm">
                  {{ category.services_count || 0 }} services
                </p>
              </div>
            </div>
            
            <!-- Statut -->
            <span 
              class="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-medium"
              :class="category.is_active ? 'bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-400' : 'bg-gray-100 text-gray-800 dark:bg-gray-700 dark:text-gray-400'"
            >
              {{ category.is_active ? 'Active' : 'Inactive' }}
            </span>
          </div>
          
          <!-- Description -->
          <p class="text-gray-600 dark:text-gray-400 line-clamp-2 mb-4 min-h-[40px]">
            {{ category.description || 'Aucune description fournie.' }}
          </p>
          
          <!-- Actions -->
          <div class="flex items-center justify-between mt-4 pt-4 border-t border-gray-100 dark:border-gray-700">
            <button 
              @click="openEditModal(category)"
              class="inline-flex items-center text-sm text-primary-600 dark:text-primary-400 hover:text-primary-700 dark:hover:text-primary-300"
            >
              <Edit class="h-4 w-4 mr-1" />
              Modifier
            </button>
            
            <div class="flex gap-1">
              <button 
                @click="toggleCategoryStatus(category)"
                class="p-1.5 text-gray-500 dark:text-gray-400 hover:text-gray-700 dark:hover:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700 rounded-full"
                :title="category.is_active ? 'Désactiver' : 'Activer'"
              >
                <component :is="category.is_active ? 'EyeOff' : 'Eye'" class="h-5 w-5" />
              </button>
              <button 
                @click="confirmDeleteCategory(category)"
                class="p-1.5 text-red-500 dark:text-red-400 hover:text-red-700 dark:hover:text-red-300 hover:bg-red-50 dark:hover:bg-red-900/20 rounded-full"
                title="Supprimer"
              >
                <Trash2 class="h-5 w-5" />
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
    
    <!-- Pagination -->
    <div v-if="totalPages > 1" class="flex justify-center mt-6">
      <div class="inline-flex rounded-md shadow-sm">
        <button
          @click="currentPage > 1 ? currentPage-- : null"
          :disabled="currentPage === 1"
          class="px-4 py-2 text-sm font-medium border border-gray-300 dark:border-gray-600 rounded-l-lg bg-white dark:bg-gray-800 disabled:opacity-50"
          :class="currentPage === 1 ? 'text-gray-400 dark:text-gray-600' : 'text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700'"
        >
          <ChevronLeft class="h-5 w-5" />
        </button>
        <button
          v-for="page in visiblePages"
          :key="page"
          @click="page !== '...' ? currentPage = page : null"
          :disabled="page === '...'"
          class="px-4 py-2 text-sm font-medium border border-gray-300 dark:border-gray-600 border-l-0 bg-white dark:bg-gray-800"
          :class="[
            page === '...' ? 'text-gray-400 dark:text-gray-600' : 
            page === currentPage ? 'text-primary-600 dark:text-primary-400 bg-primary-50 dark:bg-primary-900/20 border-primary-200 dark:border-primary-900' : 
            'text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700'
          ]"
        >
          {{ page }}
        </button>
        <button
          @click="currentPage < totalPages ? currentPage++ : null"
          :disabled="currentPage === totalPages"
          class="px-4 py-2 text-sm font-medium border border-gray-300 dark:border-gray-600 border-l-0 rounded-r-lg bg-white dark:bg-gray-800 disabled:opacity-50"
          :class="currentPage === totalPages ? 'text-gray-400 dark:text-gray-600' : 'text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700'"
        >
          <ChevronRight class="h-5 w-5" />
        </button>
      </div>
    </div>
  </div>
  
  <!-- Teleport pour le modal de création/édition -->
  <Teleport to="body">
    <!-- Overlay -->
    <div 
      v-if="showFormModal"
      class="fixed inset-0 bg-black/50 dark:bg-black/70 z-40 flex items-center justify-center p-4 overflow-y-auto"
      @click="showFormModal = false"
    >
      <!-- Modal -->
      <div 
        class="bg-white dark:bg-gray-800 rounded-xl shadow-xl max-w-lg w-full max-h-[90vh] overflow-y-auto"
        @click.stop
      >
        <div class="flex items-center justify-between p-5 border-b border-gray-200 dark:border-gray-700">
          <div class="flex items-center">
            <component :is="isEditing ? 'Edit3' : 'PlusCircle'" class="h-5 w-5 text-primary-600 dark:text-primary-400 mr-2" />
            <h3 class="text-lg font-bold text-gray-900 dark:text-white">
              {{ isEditing ? 'Modifier la catégorie' : 'Nouvelle catégorie' }}
            </h3>
          </div>
          <button 
            @click="showFormModal = false"
            class="p-1.5 text-gray-500 dark:text-gray-400 hover:text-gray-700 dark:hover:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700 rounded-full"
          >
            <X class="h-5 w-5" />
          </button>
        </div>
        
        <form @submit.prevent="saveCategory" class="p-5 space-y-5">
          <!-- Nom -->
          <div>
            <label for="name" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
              Nom *
            </label>
            <input 
              id="name" 
              v-model="form.name" 
              type="text" 
              required
              class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
              placeholder="Ex: Plomberie"
            />
          </div>
          
          <!-- Description -->
          <div>
            <label for="description" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
              Description
            </label>
            <textarea 
              id="description" 
              v-model="form.description" 
              rows="3"
              class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
              placeholder="Décrivez brièvement cette catégorie de services"
            ></textarea>
          </div>
          
          <!-- Icône et Couleur -->
          <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
            <div>
              <label for="icon" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                Icône
              </label>
              <select 
                id="icon" 
                v-model="form.icon"
                class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
              >
                <option value="home">Maison</option>
                <option value="tool">Outil</option>
                <option value="paint">Peinture</option>
                <option value="garden">Jardinage</option>
                <option value="cleaning">Nettoyage</option>
                <option value="teaching">Enseignement</option>
                <option value="computer">Informatique</option>
                <option value="car">Automobile</option>
                <option value="grid">Autre</option>
              </select>
            </div>
            
            <div>
              <label for="color" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                Couleur
              </label>
              <input 
                id="color" 
                v-model="form.color" 
                type="color"
                class="w-full h-10 px-2 py-1 border border-gray-300 dark:border-gray-600 rounded-lg"
              />
            </div>
          </div>
          
          <!-- Statut -->
          <div class="flex items-center">
            <Switch
              v-model="form.is_active"
              :class="form.is_active ? 'bg-primary-600' : 'bg-gray-200 dark:bg-gray-700'"
              class="relative inline-flex h-6 w-11 items-center rounded-full transition-colors focus:outline-none focus:ring-2 focus:ring-primary-500 focus:ring-offset-2"
            >
              <span
                :class="form.is_active ? 'translate-x-6' : 'translate-x-1'"
                class="inline-block h-4 w-4 transform rounded-full bg-white transition-transform"
              />
            </Switch>
            <span class="ml-3 text-sm font-medium text-gray-700 dark:text-gray-300">
              {{ form.is_active ? 'Catégorie active' : 'Catégorie inactive' }}
            </span>
          </div>
          
          <!-- Actions -->
          <div class="flex justify-end gap-3 pt-4 border-t border-gray-200 dark:border-gray-700">
            <button 
              type="button"
              @click="showFormModal = false"
              class="px-4 py-2 text-sm font-medium text-gray-700 dark:text-gray-300 bg-white dark:bg-gray-800 border border-gray-300 dark:border-gray-600 rounded-full hover:bg-gray-50 dark:hover:bg-gray-700"
            >
              Annuler
            </button>
            <button 
              type="submit"
              class="px-4 py-2 text-sm font-medium text-white bg-primary-600 rounded-full hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500"
              :disabled="isSaving"
            >
              <span v-if="isSaving" class="flex items-center">
                <svg class="animate-spin -ml-1 mr-2 h-4 w-4 text-white" fill="none" viewBox="0 0 24 24">
                  <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                  <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                </svg>
                Enregistrement...
              </span>
              <span v-else>
                {{ isEditing ? 'Mettre à jour' : 'Créer' }}
              </span>
            </button>
          </div>
        </form>
      </div>
    </div>
  </Teleport>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { useSupabaseClient } from '#imports'
import { 
  Layers, PlusCircle, Search, X, RefreshCw, Edit, Trash2, Eye, EyeOff, CheckCircle, AlertTriangle, Info,
  ChevronLeft, ChevronRight, Edit3, Download, Home, Tool, Paintbrush as Paint, Scissors as Garden, 
  ShowerHead as Cleaning, BookOpen as Teaching, Monitor as Computer, Car, LayoutGrid as Grid,
  Switch
} from 'lucide-vue-next'

// État
const supabase = useSupabaseClient()
const categories = ref([])
const isLoading = ref(true)
const error = ref(null)
const search = ref('')
const currentPage = ref(1)
const itemsPerPage = ref(9)
const showFormModal = ref(false)
const isEditing = ref(false)
const isSaving = ref(false)
const editingId = ref(null)
const notification = ref({ show: false, type: '', title: '', message: '' })

// Formulaire
const form = ref({
  name: '',
  description: '',
  icon: 'grid',
  color: '#6366f1',
  is_active: true
})

// Statistiques
const stats = ref([
  { 
    label: 'Catégories', 
    value: '0', 
    icon: Layers, 
    colorClass: 'bg-primary-500 dark:bg-primary-600' 
  },
  { 
    label: 'Catégories actives', 
    value: '0', 
    icon: CheckCircle, 
    colorClass: 'bg-green-500 dark:bg-green-600' 
  },
  { 
    label: 'Services liés', 
    value: '0', 
    icon: Grid, 
    colorClass: 'bg-amber-500 dark:bg-amber-600' 
  }
])

// Filtrage
const filteredCategories = computed(() => {
  let filtered = [...categories.value]
  
  // Filtre de recherche
  if (search.value) {
    const searchLower = search.value.toLowerCase()
    filtered = filtered.filter(cat => 
      cat.name.toLowerCase().includes(searchLower) || 
      (cat.description && cat.description.toLowerCase().includes(searchLower))
    )
  }
  
  return filtered
})

// Pagination
const totalPages = computed(() => Math.ceil(filteredCategories.value.length / itemsPerPage.value))

const paginatedCategories = computed(() => {
  const start = (currentPage.value - 1) * itemsPerPage.value
  const end = start + itemsPerPage.value
  return filteredCategories.value.slice(start, end)
})

// Pages visibles
const visiblePages = computed(() => {
  const totalPageCount = totalPages.value
  if (totalPageCount <= 7) {
    return Array.from({ length: totalPageCount }, (_, i) => i + 1)
  }
  
  if (currentPage.value <= 3) {
    return [1, 2, 3, 4, 5, '...', totalPageCount]
  } else if (currentPage.value >= totalPageCount - 2) {
    return [1, '...', totalPageCount - 4, totalPageCount - 3, totalPageCount - 2, totalPageCount - 1, totalPageCount]
  } else {
    return [1, '...', currentPage.value - 1, currentPage.value, currentPage.value + 1, '...', totalPageCount]
  }
})

// Méthodes
const fetchCategories = async () => {
  isLoading.value = true
  
  try {
    // Récupérer les catégories
    const { data, error: fetchError } = await supabase
      .from('services_categories')
      .select('*')
    
    if (fetchError) throw fetchError
    
    categories.value = data || []
    
    // Récupérer le nombre de services par catégorie
    const { data: servicesData, error: servicesError } = await supabase
      .from('services')
      .select('category_id, count')
      .group('category_id')
    
    if (servicesError) throw servicesError
    
    // Ajouter le comptage des services à chaque catégorie
    if (servicesData) {
      categories.value = categories.value.map(cat => {
        const serviceCount = servicesData.find(s => s.category_id === cat.id)
        return {
          ...cat,
          services_count: serviceCount ? parseInt(serviceCount.count) : 0
        }
      })
    }
    
    // Mettre à jour les statistiques
    updateStats()
  } catch (err) {
    console.error('Erreur lors du chargement des catégories:', err)
    error.value = err.message
    showNotification('error', 'Erreur', 'Impossible de charger les catégories')
  } finally {
    isLoading.value = false
  }
}

// Mettre à jour les statistiques
const updateStats = () => {
  stats.value[0].value = categories.value.length.toString()
  stats.value[1].value = categories.value.filter(c => c.is_active).length.toString()
  
  const totalServices = categories.value.reduce((sum, cat) => sum + (cat.services_count || 0), 0)
  stats.value[2].value = totalServices.toString()
}

// Obtenir l'icône de la catégorie
const getCategoryIcon = (iconName) => {
  switch (iconName) {
    case 'home': return Home
    case 'tool': return Tool
    case 'paint': return Paint
    case 'garden': return Garden
    case 'cleaning': return Cleaning
    case 'teaching': return Teaching
    case 'computer': return Computer
    case 'car': return Car
    default: return Grid
  }
}

// Ouvrir le modal de création
const openCreateModal = () => {
  isEditing.value = false
  editingId.value = null
  form.value = {
    name: '',
    description: '',
    icon: 'grid',
    color: '#6366f1',
    is_active: true
  }
  showFormModal.value = true
}

// Ouvrir le modal d'édition
const openEditModal = (category) => {
  isEditing.value = true
  editingId.value = category.id
  form.value = {
    name: category.name,
    description: category.description || '',
    icon: category.icon || 'grid',
    color: category.color || '#6366f1',
    is_active: category.is_active
  }
  showFormModal.value = true
}

// Enregistrer la catégorie
const saveCategory = async () => {
  if (!form.value.name.trim()) return
  
  isSaving.value = true
  
  try {
    if (isEditing.value) {
      // Mise à jour d'une catégorie existante
      const { error } = await supabase
        .from('services_categories')
        .update({
          name: form.value.name.trim(),
          description: form.value.description.trim(),
          icon: form.value.icon,
          color: form.value.color,
          is_active: form.value.is_active,
          updated_at: new Date()
        })
        .eq('id', editingId.value)
      
      if (error) throw error
      
      showNotification('success', 'Catégorie mise à jour', 'La catégorie a été modifiée avec succès')
    } else {
      // Création d'une nouvelle catégorie
      const { error } = await supabase
        .from('services_categories')
        .insert({
          name: form.value.name.trim(),
          description: form.value.description.trim(),
          icon: form.value.icon,
          color: form.value.color,
          is_active: form.value.is_active,
          created_at: new Date(),
          updated_at: new Date()
        })
      
      if (error) throw error
      
      showNotification('success', 'Catégorie créée', 'La nouvelle catégorie a été créée avec succès')
    }
    
    // Rafraîchir les données
    await fetchCategories()
    showFormModal.value = false
  } catch (err) {
    console.error('Erreur lors de l\'enregistrement de la catégorie:', err)
    showNotification('error', 'Erreur', `Impossible de ${isEditing.value ? 'modifier' : 'créer'} la catégorie`)
  } finally {
    isSaving.value = false
  }
}

// Changer le statut d'une catégorie
const toggleCategoryStatus = async (category) => {
  try {
    const { error } = await supabase
      .from('services_categories')
      .update({ 
        is_active: !category.is_active,
        updated_at: new Date()
      })
      .eq('id', category.id)
    
    if (error) throw error
    
    // Mettre à jour localement
    const index = categories.value.findIndex(c => c.id === category.id)
    if (index !== -1) {
      categories.value[index].is_active = !category.is_active
    }
    
    // Mettre à jour les statistiques
    updateStats()
    
    showNotification(
      'success', 
      category.is_active ? 'Catégorie désactivée' : 'Catégorie activée', 
      `La catégorie a été ${category.is_active ? 'désactivée' : 'activée'} avec succès`
    )
  } catch (err) {
    console.error('Erreur lors du changement de statut:', err)
    showNotification('error', 'Erreur', 'Impossible de modifier le statut de la catégorie')
  }
}

// Confirmation de suppression d'une catégorie
const confirmDeleteCategory = (category) => {
  if (confirm(`Êtes-vous sûr de vouloir supprimer la catégorie "${category.name}" ? Cette action est irréversible.`)) {
    deleteCategory(category.id)
  }
}

// Supprimer une catégorie
const deleteCategory = async (categoryId) => {
  try {
    const { error } = await supabase
      .from('services_categories')
      .delete()
      .eq('id', categoryId)
    
    if (error) throw error
    
    // Rafraîchir les données
    await fetchCategories()
    
    showNotification('success', 'Catégorie supprimée', 'La catégorie a été supprimée avec succès')
  } catch (err) {
    console.error('Erreur lors de la suppression:', err)
    showNotification('error', 'Erreur', 'Impossible de supprimer la catégorie. Elle est peut-être liée à des services existants.')
  }
}

// Afficher une notification
const showNotification = (type, title, message = '') => {
  notification.value = {
    show: true,
    type,
    title,
    message
  }
  
  // Masquer la notification après 5 secondes
  setTimeout(() => {
    notification.value.show = false
  }, 5000)
}

// Rafraîchir les données
const refreshData = async () => {
  await fetchCategories()
  showNotification('success', 'Données actualisées', 'La liste des catégories a été mise à jour')
}

// Réinitialiser la pagination quand les filtres changent
watch(search, () => {
  currentPage.value = 1
})

// Initialisation
onMounted(() => {
  fetchCategories()
})

definePageMeta({
  layout: 'admin'
})
</script> 