<template>
  <div class="space-y-6">
    <!-- En-tête de page avec stats -->
    <PageHeader 
      title="Gestion des catégories" 
      subtitle="Organisez les services par catégories"
    >
      <!-- Statistiques -->
      <template #stats>
        <StatCard 
          title="Total catégories" 
          :value="categories.length" 
          :icon="Tag" 
          color="amber" 
        />
        
        <StatCard 
          title="Services associés" 
          :value="servicesCount" 
          :icon="Package" 
          color="emerald" 
        />
        
        <StatCard 
          title="Catégories actives" 
          :value="categories.filter(c => c.active !== false).length" 
          :icon="CheckCircle" 
          color="green" 
        />
        
        <StatCard 
          title="Demandes associées" 
          :value="requestsCount" 
          :icon="FileText" 
          color="blue" 
        />
      </template>
      
      <!-- Actions -->
      <template #actions>
        <button 
          @click="openCategoryModal"
          class="px-4 py-2.5 bg-primary-600 text-white text-sm font-medium rounded-lg hover:bg-primary-700 transition-colors flex items-center whitespace-nowrap"
        >
          <Plus class="h-4 w-4 mr-1.5" />
          Ajouter une catégorie
        </button>
      </template>
    </PageHeader>
    
    <!-- Contenu - Catégories -->
    <div class="space-y-6">
      <div v-if="loading" class="flex justify-center py-12">
        <Loader2 class="h-8 w-8 text-gray-400 animate-spin" />
      </div>
      
      <div v-else-if="categories.length === 0" class="bg-white border border-gray-200 rounded-xl p-12 text-center">
        <Tag class="h-10 w-10 mx-auto text-gray-300 mb-3" />
        <p class="text-gray-500">Aucune catégorie n'a été créée</p>
        <button 
          @click="openCategoryModal()"
          class="mt-4 px-4 py-2 bg-primary-600 text-white text-sm font-medium rounded-lg hover:bg-primary-700 transition-colors"
        >
          Ajouter une catégorie
        </button>
      </div>
      
      <div v-else class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-4">
        <div 
          v-for="category in categories" 
          :key="category.id"
          class="bg-white border border-gray-200 rounded-xl overflow-hidden hover:shadow-md transition-shadow"
        >
          <div class="p-5">
            <div class="flex items-center justify-between mb-4">
              <div class="flex items-center">
                <div class="h-10 w-10 rounded-full bg-primary-50 flex items-center justify-center text-primary-600">
                  <component :is="getCategoryIcon(category.icon)" class="h-6 w-6" />
                </div>
                <h3 class="ml-3 font-semibold text-gray-900">{{ category.name }}</h3>
              </div>
              
              <div class="flex items-center">
                <button 
                  @click="editCategory(category)"
                  class="text-gray-500 hover:text-primary-600 transition-colors p-1"
                >
                  <Edit class="h-5 w-5" />
                </button>
                <button 
                  @click="confirmDeleteCategory(category)"
                  class="text-gray-500 hover:text-red-600 transition-colors p-1"
                >
                  <Trash2 class="h-5 w-5" />
                </button>
              </div>
            </div>
            
            <p v-if="category.description" class="text-sm text-gray-500 line-clamp-2">
              {{ category.description }}
            </p>
            
            <div class="mt-4 pt-4 border-t border-gray-100">
              <div class="flex items-center justify-between">
                <span class="text-sm text-gray-500">
                  {{ getCategoryServicesCount(category.id) }} services
                </span>
                <NuxtLink 
                  :to="`/admin/services?category=${category.id}`"
                  class="text-sm text-primary-600 hover:text-primary-700 font-medium flex items-center"
                >
                  Voir les services
                  <ChevronRight class="h-4 w-4 ml-1" />
                </NuxtLink>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    
    <!-- Modal d'ajout/modification de catégorie -->
    <Teleport to="body">
      <div 
        v-if="showCategoryModal" 
        class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 px-4"
        @click.self="showCategoryModal = false"
      >
        <div class="bg-white rounded-xl p-6 w-full max-w-md">
          <div class="flex justify-between items-center mb-4">
            <h3 class="text-lg font-semibold text-gray-900">
              {{ editMode ? 'Modifier la catégorie' : 'Ajouter une catégorie' }}
            </h3>
            <button @click="showCategoryModal = false" class="text-gray-500 hover:text-gray-700">
              <X class="h-5 w-5" />
            </button>
          </div>
          
          <form @submit.prevent="saveCategory" class="space-y-4">
            <div>
              <label for="categoryName" class="block text-sm font-medium text-gray-700 mb-1">Nom</label>
              <input
                id="categoryName"
                v-model="categoryForm.name"
                type="text"
                class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-600 focus:border-transparent"
                required
              />
            </div>
            
            <div>
              <label for="categoryIcon" class="block text-sm font-medium text-gray-700 mb-1">Icône</label>
              <select
                id="categoryIcon"
                v-model="categoryForm.icon"
                class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-600 focus:border-transparent"
              >
                <option v-for="icon in availableIcons" :key="icon.value" :value="icon.value">
                  {{ icon.label }}
                </option>
              </select>
            </div>
            
            <div>
              <label for="categoryDescription" class="block text-sm font-medium text-gray-700 mb-1">Description</label>
              <textarea
                id="categoryDescription"
                v-model="categoryForm.description"
                rows="3"
                class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-600 focus:border-transparent"
              ></textarea>
            </div>
            
            <div class="flex justify-end pt-2">
              <button
                type="button"
                @click="showCategoryModal = false"
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
            Êtes-vous sûr de vouloir supprimer la catégorie 
            <span class="font-semibold">{{ categoryToDelete?.name }}</span> ?
            <br><br>
            Cette action supprimera également tous les services associés à cette catégorie.
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
              @click="deleteCategory"
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
import { ref, computed, onMounted } from 'vue'
import { 
  Plus, Loader2, Tag, Edit, Trash2, Save, X,
  ChevronRight, Home, Leaf, Tool, Baby, BookOpen, Laptop, Package, CheckCircle, FileText
} from 'lucide-vue-next'
import { PageHeader, StatCard } from '~/components/admin'

const client = useSupabaseClient()

// États
const loading = ref(true)
const categories = ref([])
const services = ref([])
const showCategoryModal = ref(false)
const showDeleteModal = ref(false)
const editMode = ref(false)
const categoryToDelete = ref(null)
const saving = ref(false)
const deleting = ref(false)

// Formulaire catégorie
const categoryForm = ref({
  id: '',
  name: '',
  icon: 'Home',
  description: ''
})

// Liste des icônes disponibles
const availableIcons = [
  { value: 'Home', label: 'Maison' },
  { value: 'Leaf', label: 'Feuille' },
  { value: 'Tool', label: 'Outil' },
  { value: 'Baby', label: 'Enfant' },
  { value: 'BookOpen', label: 'Livre' },
  { value: 'Laptop', label: 'Ordinateur' },
  { value: 'Package', label: 'Colis' },
  { value: 'Briefcase', label: 'Mallette' },
  { value: 'Heart', label: 'Cœur' },
  { value: 'Music', label: 'Musique' },
  { value: 'Camera', label: 'Appareil photo' },
  { value: 'Car', label: 'Voiture' }
]

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
    
    // Récupérer les services pour compter ceux associés à chaque catégorie
    const { data: servicesData, error: servicesError } = await client
      .from('services')
      .select('*')
    
    if (servicesError) throw servicesError
    services.value = servicesData || []
    
  } catch (error) {
    console.error('Erreur lors du chargement des données:', error)
  } finally {
    loading.value = false
  }
}

// Obtenir l'icône d'une catégorie
const getCategoryIcon = (iconName) => {
  const iconMap = {
    'Home': Home,
    'Leaf': Leaf,
    'Tool': Tool,
    'Baby': Baby,
    'BookOpen': BookOpen,
    'Laptop': Laptop,
    'Package': Package
    // Ajouter d'autres icônes selon besoin
  }
  
  return iconMap[iconName] || Home
}

// Compter les services associés à une catégorie
const getCategoryServicesCount = (categoryId) => {
  return services.value.filter(service => service.category_id === categoryId).length
}

// Ouvrir le modal d'ajout de catégorie
const openCategoryModal = () => {
  editMode.value = false
  categoryForm.value = {
    id: '',
    name: '',
    icon: 'Home',
    description: ''
  }
  showCategoryModal.value = true
}

// Modifier une catégorie
const editCategory = (category) => {
  editMode.value = true
  categoryForm.value = {
    id: category.id,
    name: category.name,
    icon: category.icon || 'Home',
    description: category.description || ''
  }
  showCategoryModal.value = true
}

// Confirmer la suppression d'une catégorie
const confirmDeleteCategory = (category) => {
  categoryToDelete.value = category
  showDeleteModal.value = true
}

// Enregistrer une catégorie (créer ou mettre à jour)
const saveCategory = async () => {
  try {
    saving.value = true
    
    if (editMode.value) {
      // Mise à jour de la catégorie existante
      const { error } = await client
        .from('service_categories')
        .update({
          name: categoryForm.value.name,
          icon: categoryForm.value.icon,
          description: categoryForm.value.description
        })
        .eq('id', categoryForm.value.id)
      
      if (error) throw error
    } else {
      // Création d'une nouvelle catégorie
      const { error } = await client
        .from('service_categories')
        .insert({
          name: categoryForm.value.name,
          icon: categoryForm.value.icon,
          description: categoryForm.value.description
        })
      
      if (error) throw error
    }
    
    // Recharger les données et fermer le modal
    await fetchData()
    showCategoryModal.value = false
  } catch (error) {
    console.error('Erreur lors de l\'enregistrement de la catégorie:', error)
    alert('Erreur lors de l\'enregistrement de la catégorie: ' + error.message)
  } finally {
    saving.value = false
  }
}

// Supprimer une catégorie
const deleteCategory = async () => {
  if (!categoryToDelete.value) return
  
  try {
    deleting.value = true
    
    // Supprimer les services associés à cette catégorie
    const { error: servicesError } = await client
      .from('services')
      .delete()
      .eq('category_id', categoryToDelete.value.id)
    
    if (servicesError) throw servicesError
    
    // Supprimer la catégorie
    const { error } = await client
      .from('service_categories')
      .delete()
      .eq('id', categoryToDelete.value.id)
    
    if (error) throw error
    
    // Recharger les données et fermer le modal
    await fetchData()
    showDeleteModal.value = false
    categoryToDelete.value = null
  } catch (error) {
    console.error('Erreur lors de la suppression de la catégorie:', error)
    alert('Erreur lors de la suppression de la catégorie: ' + error.message)
  } finally {
    deleting.value = false
  }
}

// Charger les données au montage du composant
onMounted(fetchData)

// Définir le layout admin
definePageMeta({
  layout: 'admin',
  middleware: ['admin-auth']
})
</script> 