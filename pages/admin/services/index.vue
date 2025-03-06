<template>
  <div class="space-y-6">
    <!-- En-tête de page avec stats -->
    <PageHeader 
      title="Gestion des services" 
      subtitle="Gérez les services proposés sur la plateforme"
    >
      <!-- Statistiques -->
      <template #stats>
        <StatCard 
          title="Total services" 
          :value="services.length" 
          :icon="Package" 
          color="emerald" 
        />
        
        <StatCard 
          title="Catégories" 
          :value="categories.length" 
          :icon="Tag" 
          color="amber" 
        />
        
        <StatCard 
          title="Services actifs" 
          :value="services.filter(s => s.active !== false).length" 
          :icon="Activity" 
          color="blue" 
        />
        
        <StatCard 
          title="Experts" 
          :value="expertCount" 
          :icon="Users" 
          color="indigo" 
        />
      </template>
      
      <!-- Filtres de recherche -->
      <template #filters>
        <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
          <!-- Recherche -->
          <div class="relative flex-1 max-w-md">
            <Search class="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 h-4 w-4" />
            <input
              v-model="serviceSearch"
              type="text"
              placeholder="Rechercher un service..."
              class="w-full pl-10 pr-4 py-2.5 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-transparent transition-colors text-sm"
            />
          </div>
          
          <!-- Filtres et actions -->
          <div class="flex items-center gap-3">
            <!-- Filtre catégorie -->
            <div class="relative">
              <select
                v-model="categoryFilter"
                class="appearance-none pl-4 pr-8 py-2.5 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-transparent transition-colors text-sm bg-white"
              >
                <option value="">Toutes les catégories</option>
                <option v-for="category in categories" :key="category.id" :value="category.id">
                  {{ category.name }}
                </option>
              </select>
              <ChevronDown class="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400 h-4 w-4 pointer-events-none" />
            </div>
            
            <!-- Bouton ajouter -->
            <button 
              @click="openServiceModal"
              class="px-4 py-2.5 bg-primary-600 text-white text-sm font-medium rounded-lg hover:bg-primary-700 transition-colors flex items-center whitespace-nowrap"
            >
              <Plus class="h-4 w-4 mr-1.5" />
              Ajouter
            </button>
          </div>
        </div>
      </template>
    </PageHeader>
    
    <!-- Filtrage -->
    <div class="flex flex-col sm:flex-row sm:items-center gap-4">
      <!-- Recherche -->
      <div class="relative flex-1">
        <Search class="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 h-4 w-4" />
        <input
          v-model="serviceSearch"
          type="text"
          placeholder="Rechercher un service..."
          class="w-full pl-10 pr-4 py-2.5 border border-gray-200 rounded-lg focus:outline-none focus:border-primary-600 transition-colors text-sm"
        />
      </div>
      
      <!-- Filtre par catégorie -->
      <div class="relative min-w-[200px]">
        <select
          v-model="categoryFilter"
          class="appearance-none w-full pl-4 pr-8 py-2.5 border border-gray-200 rounded-lg focus:outline-none focus:border-primary-600 transition-colors text-sm bg-white"
        >
          <option value="">Toutes les catégories</option>
          <option v-for="category in categories" :key="category.id" :value="category.id">
            {{ category.name }}
          </option>
        </select>
        <ChevronDown class="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400 h-4 w-4 pointer-events-none" />
      </div>
    </div>
    
    <!-- Contenu - Services -->
    <div class="space-y-6">
      <div v-if="loading" class="flex justify-center py-12">
        <Loader2 class="h-8 w-8 text-gray-400 animate-spin" />
      </div>
      
      <div v-else-if="filteredServices.length === 0" class="bg-white border border-gray-200 rounded-xl p-12 text-center">
        <Package class="h-10 w-10 mx-auto text-gray-300 mb-3" />
        <p class="text-gray-500">
          {{ serviceSearch || categoryFilter ? 'Aucun service ne correspond à votre recherche' : 'Aucun service n\'a été créé' }}
        </p>
        <button 
          v-if="!serviceSearch && !categoryFilter"
          @click="openServiceModal()"
          class="mt-4 px-4 py-2 bg-primary-600 text-white text-sm font-medium rounded-lg hover:bg-primary-700 transition-colors"
        >
          Ajouter un service
        </button>
      </div>
      
      <div v-else class="bg-white border border-gray-200 rounded-xl overflow-hidden">
        <table class="w-full">
          <thead class="bg-gray-50 border-b border-gray-200">
            <tr>
              <th class="px-4 py-3.5 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Service
              </th>
              <th class="px-4 py-3.5 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Catégorie
              </th>
              <th class="px-4 py-3.5 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Description
              </th>
              <th class="px-4 py-3.5 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">
                Actions
              </th>
            </tr>
          </thead>
          <tbody class="divide-y divide-gray-200">
            <tr 
              v-for="service in filteredServices" 
              :key="service.id"
              class="hover:bg-gray-50"
            >
              <td class="px-4 py-4">
                <div class="flex items-center">
                  <div class="h-10 w-10 flex-shrink-0 bg-primary-50 rounded-full flex items-center justify-center text-primary-600">
                    <span v-if="service.icon" class="text-lg">{{ service.icon }}</span>
                    <Package v-else class="h-5 w-5" />
                  </div>
                  <div class="ml-3">
                    <div class="font-medium text-gray-900">{{ service.name }}</div>
                  </div>
                </div>
              </td>
              <td class="px-4 py-4">
                {{ getCategoryName(service.category_id) }}
              </td>
              <td class="px-4 py-4">
                <div class="text-sm text-gray-600 line-clamp-2">
                  {{ service.description || 'Aucune description' }}
                </div>
              </td>
              <td class="px-4 py-4 whitespace-nowrap text-right">
                <div class="flex items-center justify-end space-x-2">
                  <button 
                    @click="editService(service)"
                    class="text-gray-500 hover:text-primary-600 transition-colors p-1"
                  >
                    <Edit class="h-5 w-5" />
                  </button>
                  <button 
                    @click="confirmDeleteService(service)"
                    class="text-gray-500 hover:text-red-600 transition-colors p-1"
                  >
                    <Trash2 class="h-5 w-5" />
                  </button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
    
    <!-- Modal d'ajout/modification de service -->
    <Teleport to="body">
      <div 
        v-if="showServiceModal" 
        class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 px-4"
        @click.self="showServiceModal = false"
      >
        <div class="bg-white rounded-xl p-6 w-full max-w-md">
          <div class="flex justify-between items-center mb-4">
            <h3 class="text-lg font-semibold text-gray-900">
              {{ editMode ? 'Modifier le service' : 'Ajouter un service' }}
            </h3>
            <button @click="showServiceModal = false" class="text-gray-500 hover:text-gray-700">
              <X class="h-5 w-5" />
            </button>
          </div>
          
          <form @submit.prevent="saveService" class="space-y-4">
            <div>
              <label for="serviceName" class="block text-sm font-medium text-gray-700 mb-1">Nom</label>
              <input
                id="serviceName"
                v-model="serviceForm.name"
                type="text"
                class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-600 focus:border-transparent"
                required
              />
            </div>
            
            <div>
              <label for="serviceCategory" class="block text-sm font-medium text-gray-700 mb-1">Catégorie</label>
              <select
                id="serviceCategory"
                v-model="serviceForm.category_id"
                class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-600 focus:border-transparent"
                required
              >
                <option value="" disabled>Sélectionner une catégorie</option>
                <option v-for="category in categories" :key="category.id" :value="category.id">
                  {{ category.name }}
                </option>
              </select>
            </div>
            
            <div>
              <label for="serviceIcon" class="block text-sm font-medium text-gray-700 mb-1">Icône (emoji)</label>
              <input
                id="serviceIcon"
                v-model="serviceForm.icon"
                type="text"
                class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-600 focus:border-transparent"
                placeholder="🔧"
              />
            </div>
            
            <div>
              <label for="serviceDescription" class="block text-sm font-medium text-gray-700 mb-1">Description</label>
              <textarea
                id="serviceDescription"
                v-model="serviceForm.description"
                rows="3"
                class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-600 focus:border-transparent"
              ></textarea>
            </div>
            
            <div class="flex justify-end pt-2">
              <button
                type="button"
                @click="showServiceModal = false"
                class="px-4 py-2 text-sm font-medium text-gray-700 hover:text-gray-500 mr-2"
              >
                Annuler
              </button>
              <button
                type="submit"
                class="px-4 py-2 bg-primary-600 text-white text-sm font-medium rounded-lg hover:bg-primary-700 transition-colors flex items-center"
                :disabled="saving"
              >
                <Loader2 v-if="saving" class="h-4 w-4 mr-1.5 animate-spin" />
                <Save v-else class="h-4 w-4 mr-1.5" />
                {{ editMode ? 'Mettre à jour' : 'Ajouter' }}
              </button>
            </div>
          </form>
        </div>
      </div>
    </Teleport>
    
    <!-- Modal de confirmation de suppression -->
    <Teleport to="body">
      <div 
        v-if="showDeleteModal" 
        class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 px-4"
        @click.self="showDeleteModal = false"
      >
        <div class="bg-white rounded-xl p-6 w-full max-w-md">
          <div class="flex justify-between items-center mb-4">
            <h3 class="text-lg font-semibold text-gray-900">Confirmer la suppression</h3>
            <button @click="showDeleteModal = false" class="text-gray-500 hover:text-gray-700">
              <X class="h-5 w-5" />
            </button>
          </div>
          
          <p class="text-gray-600 mb-4">
            Êtes-vous sûr de vouloir supprimer le service 
            <span class="font-semibold">{{ serviceToDelete?.name }}</span> ?
            <br><br>
            Cette action est irréversible et pourrait affecter les demandes de service existantes.
          </p>
          
          <div class="flex justify-end pt-2">
            <button
              type="button"
              @click="showDeleteModal = false"
              class="px-4 py-2 text-sm font-medium text-gray-700 hover:text-gray-500 mr-2"
            >
              Annuler
            </button>
            <button
              type="button"
              @click="deleteService"
              class="px-4 py-2 bg-red-600 text-white text-sm font-medium rounded-lg hover:bg-red-700 transition-colors flex items-center"
              :disabled="deleting"
            >
              <Loader2 v-if="deleting" class="h-4 w-4 mr-1.5 animate-spin" />
              <Trash2 v-else class="h-4 w-4 mr-1.5" />
              Supprimer
            </button>
          </div>
        </div>
      </div>
    </Teleport>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { 
  Plus, Loader2, Search, Package, Edit, Trash2, 
  Save, X, ChevronDown, Tag, Activity, Users
} from 'lucide-vue-next'
import { PageHeader, StatCard } from '~/components/admin'

const client = useSupabaseClient()
const route = useRoute()

// États
const loading = ref(true)
const categories = ref([])
const services = ref([])
const serviceSearch = ref('')
const categoryFilter = ref('')
const showServiceModal = ref(false)
const showDeleteModal = ref(false)
const editMode = ref(false)
const serviceToDelete = ref(null)
const saving = ref(false)
const deleting = ref(false)

// Formulaire service
const serviceForm = ref({
  id: '',
  name: '',
  category_id: '',
  icon: '',
  description: ''
})

// Services filtrés
const filteredServices = computed(() => {
  let filtered = [...services.value]
  
  // Filtrer par recherche
  if (serviceSearch.value) {
    const searchLower = serviceSearch.value.toLowerCase()
    filtered = filtered.filter(service => 
      service.name.toLowerCase().includes(searchLower) ||
      (service.description && service.description.toLowerCase().includes(searchLower))
    )
  }
  
  // Filtrer par catégorie
  if (categoryFilter.value) {
    filtered = filtered.filter(service => service.category_id === categoryFilter.value)
  }
  
  return filtered
})

// Récupérer les données
const fetchData = async () => {
  try {
    loading.value = true
    
    // Récupérer les catégories
    const { data: categoriesData, error: categoriesError } = await client
      .from('service_categories')
      .select('*')
      .order('name')
    
    if (categoriesError) throw categoriesError
    categories.value = categoriesData || []
    
    // Récupérer les services
    const { data: servicesData, error: servicesError } = await client
      .from('services')
      .select('*')
      .order('name')
    
    if (servicesError) throw servicesError
    services.value = servicesData || []
    
  } catch (error) {
    console.error('Erreur lors du chargement des données:', error)
  } finally {
    loading.value = false
  }
}

// Obtenir le nom d'une catégorie
const getCategoryName = (categoryId) => {
  const category = categories.value.find(c => c.id === categoryId)
  return category ? category.name : 'Catégorie inconnue'
}

// Ouvrir le modal d'ajout de service
const openServiceModal = () => {
  editMode.value = false
  serviceForm.value = {
    id: '',
    name: '',
    category_id: categoryFilter.value || '',
    icon: '',
    description: ''
  }
  showServiceModal.value = true
}

// Modifier un service
const editService = (service) => {
  editMode.value = true
  serviceForm.value = {
    id: service.id,
    name: service.name,
    category_id: service.category_id,
    icon: service.icon || '',
    description: service.description || ''
  }
  showServiceModal.value = true
}

// Confirmer la suppression d'un service
const confirmDeleteService = (service) => {
  serviceToDelete.value = service
  showDeleteModal.value = true
}

// Enregistrer un service (créer ou mettre à jour)
const saveService = async () => {
  try {
    saving.value = true
    
    if (editMode.value) {
      // Mise à jour du service existant
      const { error } = await client
        .from('services')
        .update({
          name: serviceForm.value.name,
          category_id: serviceForm.value.category_id,
          icon: serviceForm.value.icon,
          description: serviceForm.value.description
        })
        .eq('id', serviceForm.value.id)
      
      if (error) throw error
    } else {
      // Création d'un nouveau service
      const { error } = await client
        .from('services')
        .insert({
          name: serviceForm.value.name,
          category_id: serviceForm.value.category_id,
          icon: serviceForm.value.icon,
          description: serviceForm.value.description
        })
      
      if (error) throw error
    }
    
    // Recharger les données et fermer le modal
    await fetchData()
    showServiceModal.value = false
  } catch (error) {
    console.error('Erreur lors de l\'enregistrement du service:', error)
    alert('Erreur lors de l\'enregistrement du service: ' + error.message)
  } finally {
    saving.value = false
  }
}

// Supprimer un service
const deleteService = async () => {
  if (!serviceToDelete.value) return
  
  try {
    deleting.value = true
    
    const { error } = await client
      .from('services')
      .delete()
      .eq('id', serviceToDelete.value.id)
    
    if (error) throw error
    
    // Recharger les données et fermer le modal
    await fetchData()
    showDeleteModal.value = false
    serviceToDelete.value = null
  } catch (error) {
    console.error('Erreur lors de la suppression du service:', error)
    alert('Erreur lors de la suppression du service: ' + error.message)
  } finally {
    deleting.value = false
  }
}

// Si un categoryId est passé dans l'URL, l'appliquer comme filtre
watch(() => route.query.category, (newCategoryId) => {
  if (newCategoryId) {
    categoryFilter.value = newCategoryId
  }
}, { immediate: true })

// Charger les données au montage du composant
onMounted(fetchData)

// Définir le layout admin
definePageMeta({
  layout: 'admin'
})
</script> 