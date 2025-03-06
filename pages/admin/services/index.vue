<template>
  <div class="p-6 max-w-7xl mx-auto">
    <!-- Header with actions -->
    <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center mb-8 gap-4">
      <div>
        <h1 class="text-3xl font-extrabold text-gray-900 dark:text-white tracking-tight">Services</h1>
        <p class="mt-1 text-gray-500 dark:text-gray-400">
          Gérez les services proposés sur la plateforme
        </p>
      </div>
      
      <div class="flex gap-3">
        <button 
          @click="openImportModal"
          class="flex items-center px-4 py-2.5 border border-gray-300 dark:border-gray-700 rounded-full text-sm font-medium text-gray-700 dark:text-gray-200 hover:bg-gray-50 dark:hover:bg-gray-800 transition-colors"
        >
          <Upload class="mr-2 h-4 w-4" />
          Importer
        </button>
        
        <button 
          @click="openServiceModal"
          class="flex items-center px-4 py-2.5 bg-blue-500 text-white rounded-full text-sm font-medium hover:bg-blue-600 transition-colors"
        >
          <PlusCircle class="mr-2 h-4 w-4" />
          Nouveau service
        </button>
      </div>
    </div>
    
    <!-- Stats cards -->
    <div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-4 gap-4 mb-8">
      <div class="bg-white dark:bg-gray-800 rounded-2xl p-6 border border-gray-100 dark:border-gray-700 shadow-sm">
        <div class="flex justify-between items-start">
          <div>
            <p class="text-sm font-medium text-gray-500 dark:text-gray-400">Total services</p>
            <div class="mt-2 text-3xl font-bold text-gray-900 dark:text-white">{{ services.length }}</div>
            <div class="mt-2 text-xs text-green-500 flex items-center">
              <TrendingUp class="h-3 w-3 mr-1" />
              <span>+5 ce mois</span>
            </div>
          </div>
          <div class="p-2.5 rounded-full bg-indigo-50 dark:bg-indigo-900/30">
            <Briefcase class="h-5 w-5 text-indigo-500" />
          </div>
        </div>
      </div>
      
      <div class="bg-white dark:bg-gray-800 rounded-2xl p-6 border border-gray-100 dark:border-gray-700 shadow-sm">
        <div class="flex justify-between items-start">
          <div>
            <p class="text-sm font-medium text-gray-500 dark:text-gray-400">Catégories</p>
            <div class="mt-2 text-3xl font-bold text-gray-900 dark:text-white">
              {{ getUniqueCategoriesCount() }}
            </div>
            <div class="mt-2 text-xs text-blue-500 flex items-center">
              <FolderTree class="h-3 w-3 mr-1" />
              <span>Classification</span>
            </div>
          </div>
          <div class="p-2.5 rounded-full bg-blue-50 dark:bg-blue-900/30">
            <FolderTree class="h-5 w-5 text-blue-500" />
          </div>
        </div>
      </div>
      
      <div class="bg-white dark:bg-gray-800 rounded-2xl p-6 border border-gray-100 dark:border-gray-700 shadow-sm">
        <div class="flex justify-between items-start">
          <div>
            <p class="text-sm font-medium text-gray-500 dark:text-gray-400">Services actifs</p>
            <div class="mt-2 text-3xl font-bold text-gray-900 dark:text-white">
              {{ services.filter(s => s.active).length }}
            </div>
            <div class="mt-2 text-xs text-green-500 flex items-center">
              <CheckCircle class="h-3 w-3 mr-1" />
              <span>{{ Math.round((services.filter(s => s.active).length / services.length) * 100) }}% du total</span>
            </div>
          </div>
          <div class="p-2.5 rounded-full bg-green-50 dark:bg-green-900/30">
            <CheckCircle class="h-5 w-5 text-green-500" />
          </div>
        </div>
      </div>
      
      <div class="bg-white dark:bg-gray-800 rounded-2xl p-6 border border-gray-100 dark:border-gray-700 shadow-sm">
        <div class="flex justify-between items-start">
          <div>
            <p class="text-sm font-medium text-gray-500 dark:text-gray-400">Prix moyen</p>
            <div class="mt-2 text-3xl font-bold text-gray-900 dark:text-white">
              {{ getAveragePrice() }}€
            </div>
            <div class="mt-2 text-xs text-amber-500 flex items-center">
              <TrendingDown class="h-3 w-3 mr-1" />
              <span>-2% ce trimestre</span>
            </div>
          </div>
          <div class="p-2.5 rounded-full bg-amber-50 dark:bg-amber-900/30">
            <DollarSign class="h-5 w-5 text-amber-500" />
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
            placeholder="Rechercher un service..."
            class="pl-10 pr-4 py-3 w-full border-0 bg-gray-50 dark:bg-gray-900 rounded-full text-sm text-gray-900 dark:text-white focus:ring-2 focus:ring-blue-500 transition-all"
          />
        </div>
        
        <div class="flex flex-wrap gap-3 w-full sm:w-auto">
          <!-- Category filter -->
          <div class="relative min-w-[180px]">
            <select
              v-model="categoryFilter"
              class="appearance-none pl-4 pr-10 py-3 w-full border-0 bg-gray-50 dark:bg-gray-900 rounded-full text-sm text-gray-900 dark:text-white focus:ring-2 focus:ring-blue-500 transition-all"
            >
              <option value="">Toutes les catégories</option>
              <option v-for="category in categories" :key="category.id" :value="category.id">
                {{ category.name }}
              </option>
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
            </select>
            <ChevronDown class="absolute right-4 top-1/2 transform -translate-y-1/2 h-4 w-4 text-gray-400 pointer-events-none" />
          </div>
          
          <!-- Price filter -->
          <button 
            @click="showPriceFilter = !showPriceFilter"
            class="flex items-center px-4 py-3 border-0 bg-gray-50 dark:bg-gray-900 rounded-full text-sm text-gray-700 dark:text-gray-200 hover:bg-gray-100 dark:hover:bg-gray-800 transition-colors focus:ring-2 focus:ring-blue-500"
          >
            <DollarSign class="mr-2 h-4 w-4" />
            <span>Prix</span>
            <ChevronDown class="ml-2 h-3 w-3" :class="showPriceFilter ? 'rotate-180' : ''" />
          </button>
        </div>
      </div>
      
      <!-- Price filter panel -->
      <div v-if="showPriceFilter" class="mt-4 p-4 bg-gray-50 dark:bg-gray-900 rounded-xl">
        <div class="flex flex-col sm:flex-row gap-4 items-center">
          <div class="w-full sm:w-auto">
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
              Prix minimum
            </label>
            <input
              v-model="minPrice"
              type="number"
              min="0"
              class="px-4 py-2 w-full sm:w-32 border border-gray-300 dark:border-gray-700 rounded-full text-sm bg-white dark:bg-gray-800"
            />
          </div>
          
          <div class="w-full sm:w-auto">
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
              Prix maximum
            </label>
            <input
              v-model="maxPrice"
              type="number"
              min="0"
              class="px-4 py-2 w-full sm:w-32 border border-gray-300 dark:border-gray-700 rounded-full text-sm bg-white dark:bg-gray-800"
            />
          </div>
          
          <div class="flex gap-2 mt-auto">
            <button
              @click="applyPriceFilter"
              class="px-4 py-2 bg-blue-500 text-white rounded-full text-sm font-medium hover:bg-blue-600 transition-colors"
            >
              Appliquer
            </button>
            
            <button
              @click="resetPriceFilter"
              class="px-4 py-2 border border-gray-300 dark:border-gray-700 text-gray-700 dark:text-gray-200 rounded-full text-sm font-medium hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors"
            >
              Réinitialiser
            </button>
          </div>
        </div>
      </div>
    </div>
    
    <!-- Table des services -->
    <Table
      :items="paginatedServices"
      :columns="columns"
      :loading="loading"
      :selectable="true"
      v-model:selectedItems="selectedServices"
      :row-actions="rowActions"
      :bulk-actions="bulkActions"
      :pagination="true"
      v-model:currentPage="currentPage"
      :perPage="perPage"
      :totalItems="filteredServices.length"
      entity-label="service"
      empty-message="Aucun service trouvé"
      empty-description="Essayez de modifier vos filtres ou ajoutez de nouveaux services."
      :empty-icon="Package"
      @action="handleTableAction"
      @sort="handleSort"
    >
      <!-- Templates pour les cellules personnalisées -->
      <template #cell-service="{ item }">
        <div class="flex items-center">
          <div class="flex-shrink-0 h-10 w-10 bg-gray-100 dark:bg-gray-700 rounded-lg flex items-center justify-center text-lg">
            {{ item.icon || '🔧' }}
          </div>
          <div class="ml-4">
            <div class="text-sm font-medium text-gray-900 dark:text-white">
              {{ item.name }}
            </div>
            <div class="text-xs text-gray-500 dark:text-gray-400">
              {{ getCategoryName(item.category_id) }}
            </div>
          </div>
        </div>
      </template>
      
      <template #cell-price="{ item }">
        <div class="font-medium">
          {{ formatPrice(item.price) }}
        </div>
      </template>
      
      <template #cell-duration="{ item }">
        <div class="flex items-center">
          <Clock class="h-4 w-4 text-gray-400 mr-1.5" />
          {{ formatDuration(item.duration) }}
        </div>
      </template>
      
      <template #cell-active="{ item }">
        <span 
          class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium"
          :class="item.active 
            ? 'bg-green-100 text-green-800 dark:bg-green-900/40 dark:text-green-400' 
            : 'bg-gray-100 text-gray-800 dark:bg-gray-700 dark:text-gray-300'"
        >
          {{ item.active ? 'Actif' : 'Inactif' }}
        </span>
      </template>
      
      <template #cell-updated_at="{ value }">
        <span class="text-sm text-gray-500 dark:text-gray-400">
          {{ formatDate(value) }}
        </span>
      </template>
      
      <!-- Actions personnalisées à droite de chaque ligne -->
      <template #rowActions="{ item }">
        <button 
          @click="viewService(item)"
          class="p-1.5 rounded-full hover:bg-gray-100 dark:hover:bg-gray-700 text-gray-500 dark:text-gray-400"
          title="Voir"
        >
          <Eye class="h-4 w-4" />
        </button>
        <button 
          @click="editService(item)"
          class="p-1.5 rounded-full hover:bg-gray-100 dark:hover:bg-gray-700 text-gray-500 dark:text-gray-400"
          title="Modifier"
        >
          <Edit class="h-4 w-4" />
        </button>
      </template>
    </Table>
    
    <!-- Modal de service -->
    <ServiceModal 
      v-if="showServiceModal"
      :show="showServiceModal"
      :mode="editMode ? 'edit' : 'add'"
      :service="serviceToEdit"
      :categories="categories"
      @close="showServiceModal = false"
      @save="saveService"
    />
    
    <!-- Modal de confirmation de suppression -->
    <ConfirmModal
      v-if="showDeleteModal"
      :show="showDeleteModal"
      title="Supprimer le service"
      :message="`Êtes-vous sûr de vouloir supprimer le service '${serviceToDelete?.name}' ? Cette action est irréversible.`"
      confirmText="Supprimer"
      cancelText="Annuler"
      :loading="deleting"
      @close="showDeleteModal = false"
      @confirm="deleteService"
    />
  </div>
</template>

<script setup>
import Table from '@/components/ui/Table.vue'
import ServiceModal from '@/components/admin/ServiceModal.vue'
import ConfirmModal from '@/components/admin/ConfirmModal.vue'
import { ref, computed, watch, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { createClient } from '@supabase/supabase-js'
import {
  Search, PlusCircle, Upload, TrendingUp, TrendingDown, Briefcase, FolderTree,
  CheckCircle, DollarSign, Eye, Edit, Trash2, Clock, ChevronDown, Package,
  PackagePlus, CheckSquare, XSquare
} from 'lucide-vue-next'

// Initialisation
const router = useRouter()
const client = createClient(process.env.SUPABASE_URL, process.env.SUPABASE_KEY)

// État des données
const services = ref([])
const categories = ref([])
const loading = ref(false)
const selectedServices = ref([])

// État des filtres
const search = ref('')
const categoryFilter = ref('')
const statusFilter = ref('')
const showPriceFilter = ref(false)
const minPrice = ref(0)
const maxPrice = ref(1000)
const tempMinPrice = ref(0)
const tempMaxPrice = ref(1000)

// État de la pagination
const currentPage = ref(1)
const perPage = ref(10)

// État des modals
const showServiceModal = ref(false)
const showDeleteModal = ref(false)
const editMode = ref(false)
const serviceToEdit = ref(null)
const serviceToDelete = ref(null)
const deleting = ref(false)
const saving = ref(false)

// Définition des colonnes pour la table
const columns = [
  {
    key: 'service',
    label: 'Service',
    sortable: false
  },
  {
    key: 'price',
    label: 'Prix',
    sortable: true
  },
  {
    key: 'duration',
    label: 'Durée',
    sortable: true
  },
  {
    key: 'active',
    label: 'Statut',
    sortable: true
  },
  {
    key: 'updated_at',
    label: 'Mise à jour',
    sortable: true
  }
]

// Actions pour les lignes
const rowActions = [
  {
    key: 'toggleActive',
    label: item => item.active ? XSquare : CheckSquare,
    icon: item => item.active ? XSquare : CheckSquare,
    handler: toggleServiceActive
  },
  {
    key: 'edit',
    label: 'Modifier',
    icon: Edit,
    handler: editService
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
    label: 'Activer',
    icon: CheckSquare,
    handler: bulkActivate
  },
  {
    label: 'Désactiver',
    icon: XSquare,
    handler: bulkDeactivate
  },
  {
    label: 'Supprimer',
    icon: Trash2,
    danger: true,
    handler: confirmBulkDelete
  }
]

// Services filtrés et paginés
const filteredServices = computed(() => {
  let result = [...services.value]
  
  // Appliquer la recherche
  if (search.value) {
    const searchTerm = search.value.toLowerCase()
    result = result.filter(service => 
      service.name?.toLowerCase().includes(searchTerm) ||
      service.description?.toLowerCase().includes(searchTerm) ||
      getCategoryName(service.category_id).toLowerCase().includes(searchTerm)
    )
  }
  
  // Filtrer par catégorie
  if (categoryFilter.value) {
    result = result.filter(service => service.category_id === categoryFilter.value)
  }
  
  // Filtrer par statut
  if (statusFilter.value === 'active') {
    result = result.filter(service => service.active)
  } else if (statusFilter.value === 'inactive') {
    result = result.filter(service => !service.active)
  }
  
  // Filtrer par prix
  if (minPrice.value) {
    result = result.filter(service => service.price >= minPrice.value)
  }
  
  if (maxPrice.value) {
    result = result.filter(service => service.price <= maxPrice.value)
  }
  
  return result
})

const paginatedServices = computed(() => {
  const start = (currentPage.value - 1) * perPage.value
  const end = start + perPage.value
  return filteredServices.value.slice(start, end)
})

// Fonctions utilitaires
function formatDate(dateString) {
  if (!dateString) return '-'
  const date = new Date(dateString)
  return date.toLocaleDateString('fr-FR', {
    day: 'numeric',
    month: 'short',
    year: 'numeric'
  })
}

function formatPrice(price) {
  return new Intl.NumberFormat('fr-FR', {
    style: 'currency',
    currency: 'EUR',
    minimumFractionDigits: 0
  }).format(price)
}

function formatDuration(minutes) {
  if (!minutes) return '-'
  if (minutes < 60) {
    return `${minutes} min`
  } else {
    const hours = Math.floor(minutes / 60)
    const remainingMinutes = minutes % 60
    if (remainingMinutes === 0) {
      return `${hours}h`
    } else {
      return `${hours}h${remainingMinutes.toString().padStart(2, '0')}`
    }
  }
}

function getCategoryName(categoryId) {
  const category = categories.value.find(c => c.id === categoryId)
  return category ? category.name : 'Non catégorisé'
}

function getUniqueCategoriesCount() {
  const uniqueCategories = new Set(services.value.map(s => s.category_id))
  return uniqueCategories.size
}

function getAveragePrice() {
  if (services.value.length === 0) return 0
  const total = services.value.reduce((sum, service) => sum + service.price, 0)
  return Math.round(total / services.value.length)
}

// Gestion des actions
function handleTableAction({ action, item }) {
  console.log(`Action: ${action} on item:`, item)
}

function handleSort({ key, order }) {
  console.log(`Sort by ${key} in ${order} order`)
}

// Actions du tableau
function openServiceModal() {
  editMode.value = false
  serviceToEdit.value = {
    name: '',
    description: '',
    category_id: '',
    price: 0,
    duration: 60,
    active: true,
    icon: '🔧'
  }
  showServiceModal.value = true
}

function editService(service) {
  editMode.value = true
  serviceToEdit.value = { ...service }
  showServiceModal.value = true
}

function viewService(service) {
  router.push(`/admin/services/${service.id}`)
}

function confirmDelete(service) {
  serviceToDelete.value = service
  showDeleteModal.value = true
}

function toggleServiceActive(service) {
  const updatedService = { ...service, active: !service.active }
  saveService(updatedService)
}

function applyPriceFilter() {
  minPrice.value = tempMinPrice.value
  maxPrice.value = tempMaxPrice.value
  showPriceFilter.value = false
}

function resetPriceFilter() {
  minPrice.value = 0
  maxPrice.value = 1000
  tempMinPrice.value = 0
  tempMaxPrice.value = 1000
  showPriceFilter.value = false
}

function bulkActivate(selectedItems) {
  // Activer tous les services sélectionnés
  const promises = selectedItems.map(service => {
    if (!service.active) {
      return client
        .from('services')
        .update({ active: true })
        .eq('id', service.id)
    }
    return Promise.resolve()
  })
  
  Promise.all(promises)
    .then(() => fetchServices())
    .catch(error => console.error('Erreur lors de l\'activation des services:', error))
}

function bulkDeactivate(selectedItems) {
  // Désactiver tous les services sélectionnés
  const promises = selectedItems.map(service => {
    if (service.active) {
      return client
        .from('services')
        .update({ active: false })
        .eq('id', service.id)
    }
    return Promise.resolve()
  })
  
  Promise.all(promises)
    .then(() => fetchServices())
    .catch(error => console.error('Erreur lors de la désactivation des services:', error))
}

function confirmBulkDelete(selectedItems) {
  if (confirm(`Êtes-vous sûr de vouloir supprimer ${selectedItems.length} services ?`)) {
    const promises = selectedItems.map(service => {
      return client
        .from('services')
        .delete()
        .eq('id', service.id)
    })
    
    Promise.all(promises)
      .then(() => {
        selectedServices.value = []
        fetchServices()
      })
      .catch(error => console.error('Erreur lors de la suppression des services:', error))
  }
}

function openImportModal() {
  // Logic to open import modal
  alert('Importer des services')
}

// Opérations sur les données
async function fetchServices() {
  try {
    loading.value = true
    
    // Récupérer les catégories
    const { data: categoriesData, error: categoriesError } = await client
      .from('categories')
      .select('*')
    
    if (categoriesError) throw categoriesError
    categories.value = categoriesData || []
    
    // Récupérer les services
    const { data: servicesData, error: servicesError } = await client
      .from('services')
      .select('*')
      .order('updated_at', { ascending: false })
    
    if (servicesError) throw servicesError
    services.value = servicesData || []
  } catch (error) {
    console.error('Erreur lors du chargement des services:', error)
  } finally {
    loading.value = false
  }
}

async function saveService(serviceData) {
  try {
    saving.value = true
    
    if (editMode.value) {
      // Mise à jour d'un service existant
      const { error } = await client
        .from('services')
        .update({
          name: serviceData.name,
          description: serviceData.description,
          category_id: serviceData.category_id,
          price: serviceData.price,
          duration: serviceData.duration,
          active: serviceData.active,
          icon: serviceData.icon,
          updated_at: new Date().toISOString()
        })
        .eq('id', serviceData.id)
      
      if (error) throw error
    } else {
      // Création d'un nouveau service
      const { error } = await client
        .from('services')
        .insert({
          name: serviceData.name,
          description: serviceData.description,
          category_id: serviceData.category_id,
          price: serviceData.price,
          duration: serviceData.duration,
          active: serviceData.active,
          icon: serviceData.icon,
          created_at: new Date().toISOString(),
          updated_at: new Date().toISOString()
        })
      
      if (error) throw error
    }
    
    // Recharger les services et fermer le modal
    await fetchServices()
    showServiceModal.value = false
  } catch (error) {
    console.error('Erreur lors de l\'enregistrement du service:', error)
    alert('Erreur lors de l\'enregistrement du service: ' + error.message)
  } finally {
    saving.value = false
  }
}

async function deleteService() {
  if (!serviceToDelete.value) return
  
  try {
    deleting.value = true
    
    const { error } = await client
      .from('services')
      .delete()
      .eq('id', serviceToDelete.value.id)
    
    if (error) throw error
    
    // Recharger les services et fermer le modal
    await fetchServices()
    showDeleteModal.value = false
    serviceToDelete.value = null
  } catch (error) {
    console.error('Erreur lors de la suppression du service:', error)
    alert('Erreur lors de la suppression du service: ' + error.message)
  } finally {
    deleting.value = false
  }
}

// Réinitialiser la pagination quand les filtres changent
watch([search, categoryFilter, statusFilter, minPrice, maxPrice], () => {
  currentPage.value = 1
})

// Charger les services au montage du composant
onMounted(fetchServices)

// Définir le layout admin
definePageMeta({
  layout: 'admin',
})
</script> 