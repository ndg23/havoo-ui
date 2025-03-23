<template>
  <div class="space-y-6 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
    <!-- En-tête avec style moderne -->
    <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
      <div>
        <h1 class="text-3xl font-bold text-gray-900 dark:text-white tracking-tight">Catégories</h1>
        <p class="text-gray-600 dark:text-gray-400 mt-1">Gérez les catégories de services</p>
      </div>
      
      <!-- Actions principales -->
      <div class="flex items-center gap-3">
        <button 
          @click="openAddModal"
          class="btn-primary flex items-center gap-2"
        >
          <Plus class="h-4 w-4" />
          <span>Ajouter</span>
        </button>
        <button 
          @click="refreshData"
          class="btn-outline flex items-center gap-2"
        >
          <RefreshCw class="h-4 w-4" />
          <span>Actualiser</span>
        </button>
      </div>
    </div>
    
    <!-- Notifications avec animation -->
    <Transition
      enter-active-class="transform transition duration-300 ease-out"
      enter-from-class="translate-y-2 opacity-0"
      enter-to-class="translate-y-0 opacity-100"
      leave-active-class="transform transition duration-200 ease-in"
      leave-from-class="translate-y-0 opacity-100"
      leave-to-class="translate-y-2 opacity-0"
    >
      <div 
        v-if="notification?.show" 
        class="p-4 rounded-2xl flex items-start gap-3 shadow-sm"
        :class="[
          notification.type === 'success' ? 'bg-green-50 text-green-800 dark:bg-green-900/30 dark:text-green-400 border border-green-200 dark:border-green-800/30' : 
          notification.type === 'error' ? 'bg-red-50 text-red-800 dark:bg-red-900/30 dark:text-red-400 border border-red-200 dark:border-red-800/30' : 
          'bg-blue-50 text-blue-800 dark:bg-blue-900/30 dark:text-blue-400 border border-blue-200 dark:border-blue-800/30'
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
    </Transition>
    
    <!-- Recherche -->
    <div class="bg-white dark:bg-gray-800 rounded-2xl border border-gray-100 dark:border-gray-700 p-5 shadow-sm">
      <div class="flex flex-col md:flex-row md:items-center gap-4">
        <div class="relative flex-grow max-w-md">
          <Search class="absolute left-4 top-3.5 h-5 w-5 text-gray-400" />
          <input 
            v-model="search"
            type="text"
            placeholder="Rechercher une catégorie..."
            class="pl-12 pr-4 py-3 border border-gray-200 dark:border-gray-600 rounded-xl w-full focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
          />
        </div>
        
        <div class="flex flex-wrap gap-3 items-center">
          <!-- Filtre de statut -->
          <select 
            v-model="statusFilter"
            class="px-4 py-3 border border-gray-200 dark:border-gray-600 rounded-xl focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white appearance-none bg-none"
          >
            <option value="all">Tous les statuts</option>
            <option value="active">Actives</option>
            <option value="inactive">Inactives</option>
          </select>
          
          <!-- Réinitialiser -->
          <button 
            @click="resetFilters"
            class="flex items-center gap-2 px-4 py-3 text-gray-700 dark:text-gray-300 bg-gray-100 dark:bg-gray-700 rounded-xl hover:bg-gray-200 dark:hover:bg-gray-600 transition-colors"
          >
            <RefreshCw class="h-4 w-4" />
            <span>Réinitialiser</span>
          </button>
        </div>
      </div>
    </div>
    
    <!-- État de chargement avec animation -->
    <div v-if="isLoading" class="flex justify-center p-12">
      <div class="inline-block h-10 w-10 animate-spin rounded-full border-4 border-solid border-primary-500 border-r-transparent"></div>
    </div>
    
    <!-- État vide avec illustration -->
    <div v-else-if="filteredCategories && filteredCategories.length === 0" class="bg-white dark:bg-gray-800 rounded-2xl p-12 text-center border border-gray-100 dark:border-gray-700 shadow-sm">
      <div class="inline-flex items-center justify-center h-20 w-20 rounded-full bg-gray-100 dark:bg-gray-700 mb-6">
        <Folder class="h-10 w-10 text-gray-500 dark:text-gray-400" />
      </div>
      <h3 class="text-xl font-bold text-gray-900 dark:text-white mb-2">Aucune catégorie trouvée</h3>
      <p class="text-gray-600 dark:text-gray-400 mb-6 max-w-md mx-auto">
        Essayez de modifier vos filtres ou d'ajouter une nouvelle catégorie.
      </p>
      <div class="flex flex-wrap justify-center gap-4">
        <button 
          @click="resetFilters"
          class="px-6 py-3 bg-gray-100 hover:bg-gray-200 dark:bg-gray-700 dark:hover:bg-gray-600 text-gray-700 dark:text-gray-300 font-medium rounded-xl transition-colors"
        >
          Réinitialiser les filtres
        </button>
        <button 
          @click="openAddModal"
          class="px-6 py-3 bg-primary-600 hover:bg-primary-700 text-white font-medium rounded-xl shadow-sm transition-colors"
        >
          Ajouter une catégorie
        </button>
      </div>
    </div>
    
    <!-- Tableau des catégories avec UTable -->
    <div v-else>
      <UTable
        :columns="columns"
        :rows="paginatedCategories"
        :loading="isLoading"
        class="bg-white dark:bg-gray-800 rounded-2xl border border-gray-100 dark:border-gray-700 overflow-hidden shadow-sm"
      >
        <!-- Colonne Catégorie -->
        <template #category-data="{ row }">
          <div class="flex items-center gap-3">
            <div 
              class="h-12 w-12 rounded-xl flex items-center justify-center"
              :class="getCategoryColorClass(row.id)"
            >
              <component :is="getCategoryIcon(row.icon)" class="h-6 w-6 text-white" />
            </div>
            <div>
              <p class="text-sm font-medium text-gray-900 dark:text-white">{{ row.name }}</p>
              <p class="text-xs text-gray-500 dark:text-gray-400">{{ row.description || 'Aucune description' }}</p>
            </div>
          </div>
        </template>
        
        <!-- Colonne Statut -->
        <template #status-data="{ row }">
          <span 
            class="inline-flex items-center px-3 py-1.5 rounded-full text-xs font-medium"
            :class="row.is_active ? 'bg-green-50 text-green-800 dark:bg-green-900/30 dark:text-green-400' : 'bg-red-50 text-red-800 dark:bg-red-900/30 dark:text-red-400'"
          >
            <span class="w-2 h-2 rounded-full mr-2" :class="row.is_active ? 'bg-green-500' : 'bg-red-500'"></span>
            {{ row.is_active ? 'Active' : 'Inactive' }}
          </span>
        </template>
        
        <!-- Colonne Services -->
        <template #services-count-data="{ row }">
          <div class="text-sm text-gray-600 dark:text-gray-400">
            {{ row.services_count || 0 }} service(s)
          </div>
        </template>
        
        <!-- Colonne Date de création -->
        <template #created-at-data="{ row }">
          <div class="text-sm text-gray-600 dark:text-gray-400">
            {{ formatDate(row.created_at) }}
          </div>
        </template>
        
        <!-- Colonne Actions -->
        <template #actions-data="{ row }">
          <div class="flex justify-end gap-2">
            <button 
              @click="editCategory(row)"
              class="p-2 text-gray-500 dark:text-gray-400 hover:text-primary-600 dark:hover:text-primary-400 hover:bg-primary-50 dark:hover:bg-primary-900/20 rounded-lg transition-colors"
              title="Modifier"
            >
              <Edit class="h-5 w-5" />
            </button>
            <button 
              @click="toggleCategoryStatus(row)"
              class="p-2 text-gray-500 dark:text-gray-400 hover:text-amber-600 dark:hover:text-amber-400 hover:bg-amber-50 dark:hover:bg-amber-900/20 rounded-lg transition-colors"
              :title="row.is_active ? 'Désactiver' : 'Activer'"
            >
              <component :is="row.is_active ? 'EyeOff' : 'Eye'" class="h-5 w-5" />
            </button>
            <button 
              @click="deleteCategory(row)"
              class="p-2 text-gray-500 dark:text-gray-400 hover:text-red-600 dark:hover:text-red-400 hover:bg-red-50 dark:hover:bg-red-900/20 rounded-lg transition-colors"
              title="Supprimer"
            >
              <Trash2 class="h-5 w-5" />
            </button>
          </div>
        </template>
      </UTable>
      
      <!-- Pagination -->
      <div class="flex justify-between items-center mt-6">
        <div class="text-sm text-gray-600 dark:text-gray-400">
          Affichage de {{ paginatedCategories.length }} sur {{ filteredCategories.length }} catégories
        </div>
        <div class="flex items-center gap-2">
          <button 
            @click="currentPage > 1 ? currentPage-- : null"
            :disabled="currentPage === 1"
            class="p-2 rounded-lg border border-gray-200 dark:border-gray-700 text-gray-600 dark:text-gray-400 disabled:opacity-50"
          >
            <ChevronLeft class="h-5 w-5" />
          </button>
          <span class="text-sm text-gray-600 dark:text-gray-400">
            Page {{ currentPage }} sur {{ totalPages }}
          </span>
          <button 
            @click="currentPage < totalPages ? currentPage++ : null"
            :disabled="currentPage === totalPages"
            class="p-2 rounded-lg border border-gray-200 dark:border-gray-700 text-gray-600 dark:text-gray-400 disabled:opacity-50"
          >
            <ChevronRight class="h-5 w-5" />
          </button>
        </div>
      </div>
    </div>
    
    <!-- Modal d'ajout/modification de catégorie -->
    <UModal v-model="showCategoryModal">
      <div class="p-6">
        <h2 class="text-xl font-bold text-gray-900 dark:text-white mb-4">
          {{ editMode ? 'Modifier la catégorie' : 'Ajouter une catégorie' }}
        </h2>
        
        <form @submit.prevent="saveCategory" class="space-y-4">
          <!-- Nom -->
          <div>
            <label for="name" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Nom</label>
            <input 
              id="name"
              v-model="categoryForm.name"
              type="text"
              required
              class="w-full px-4 py-3 border border-gray-200 dark:border-gray-600 rounded-xl focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
              placeholder="Nom de la catégorie"
            />
          </div>
          
          <!-- Description -->
          <div>
            <label for="description" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Description</label>
            <textarea 
              id="description"
              v-model="categoryForm.description"
              rows="3"
              class="w-full px-4 py-3 border border-gray-200 dark:border-gray-600 rounded-xl focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
              placeholder="Description de la catégorie"
            ></textarea>
          </div>
          
          <!-- Icône -->
          <div>
            <label for="icon" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Icône</label>
            <select 
              id="icon"
              v-model="categoryForm.icon"
              class="w-full px-4 py-3 border border-gray-200 dark:border-gray-600 rounded-xl focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
            >
              <option value="Briefcase">Briefcase</option>
              <option value="Code">Code</option>
              <option value="PenTool">PenTool</option>
              <option value="Image">Image</option>
              <option value="FileText">FileText</option>
              <option value="MessageSquare">MessageSquare</option>
              <option value="ShoppingBag">ShoppingBag</option>
              <option value="Globe">Globe</option>
              <option value="Database">Database</option>
              <option value="Smartphone">Smartphone</option>
            </select>
          </div>
          
          <!-- Statut -->
          <div class="flex items-center">
            <input 
              id="is_active"
              v-model="categoryForm.is_active"
              type="checkbox"
              class="h-5 w-5 text-primary-600 focus:ring-primary-500 border-gray-300 rounded"
            />
            <label for="is_active" class="ml-2 block text-sm text-gray-700 dark:text-gray-300">
              Catégorie active
            </label>
          </div>
          
          <!-- Actions -->
          <div class="flex justify-end gap-3 pt-4">
            <button 
              type="button"
              @click="showCategoryModal = false"
              class="px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-xl text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700"
            >
              Annuler
            </button>
            <button 
              type="submit"
              class="px-4 py-2 bg-primary-600 hover:bg-primary-700 text-white rounded-xl"
              :disabled="isSaving"
            >
              <span v-if="isSaving" class="flex items-center gap-2">
                <Loader2 class="h-4 w-4 animate-spin" />
                Enregistrement...
              </span>
              <span v-else>
                {{ editMode ? 'Mettre à jour' : 'Ajouter' }}
              </span>
            </button>
          </div>
        </form>
      </div>
    </UModal>
    
    <!-- Modal de confirmation de suppression -->
    <UModal v-model="showDeleteModal">
      <div class="p-6">
        <h2 class="text-xl font-bold text-gray-900 dark:text-white mb-4">
          Confirmer la suppression
        </h2>
        
        <p class="text-gray-600 dark:text-gray-400 mb-6">
          Êtes-vous sûr de vouloir supprimer la catégorie <span class="font-medium text-gray-900 dark:text-white">{{ selectedCategory?.name }}</span> ?
          <br><br>
          Cette action est irréversible et supprimera également tous les services associés à cette catégorie.
        </p>
        
        <div class="flex justify-end gap-3">
          <button 
            @click="showDeleteModal = false"
            class="px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-xl text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700"
          >
            Annuler
          </button>
          <button 
            @click="confirmDeleteCategory"
            class="px-4 py-2 bg-red-600 hover:bg-red-700 text-white rounded-xl"
            :disabled="isDeleting"
          >
            <span v-if="isDeleting" class="flex items-center gap-2">
              <Loader2 class="h-4 w-4 animate-spin" />
              Suppression...
            </span>
            <span v-else class="flex items-center gap-2">
              <Trash2 class="h-4 w-4" />
              Supprimer
            </span>
          </button>
        </div>
      </div>
    </UModal>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue';
import { useRouter } from 'vue-router';
import { debounce } from 'lodash';
import { 
  Plus, Search, Edit, Trash2, RefreshCw, X, CheckCircle, AlertTriangle, 
  Info, Folder, ChevronLeft, ChevronRight, Eye, EyeOff, Briefcase, Code, 
  PenTool, Image, FileText, MessageSquare, ShoppingBag, Globe, Database, 
  Smartphone 
} from 'lucide-vue-next';
import { useSupabaseClient } from '#imports';

const supabase = useSupabaseClient();
const router = useRouter();

// État des données
const categories = ref([]);
const isLoading = ref(true);
const search = ref('');
const statusFilter = ref('all');
const currentPage = ref(1);
const itemsPerPage = ref(10);
const showCategoryModal = ref(false);
const showDeleteModal = ref(false);
const editMode = ref(false);
const selectedCategory = ref(null);
const isSaving = ref(false);
const isDeleting = ref(false);

// Notification avec initialisation correcte
const notification = ref({
  show: false,
  type: 'info',
  title: '',
  message: ''
});

// Formulaire de catégorie
const categoryForm = ref({
  name: '',
  description: '',
  icon: 'Briefcase',
  is_active: true
});

// Colonnes pour UTable
const columns = [
  {
    key: 'category',
    label: 'Catégorie',
    sortable: true
  },
  {
    key: 'status',
    label: 'Statut',
    sortable: true
  },
  {
    key: 'services_count',
    label: 'Services',
    sortable: true
  },
  {
    key: 'created_at',
    label: 'Date de création',
    sortable: true
  },
  {
    key: 'actions',
    label: 'Actions',
    sortable: false
  }
];

// Computed properties
const filteredCategories = computed(() => {
  if (!categories.value) return [];
  
  let result = [...categories.value];
  
  // Filtre de recherche
  if (search.value) {
    const searchLower = search.value.toLowerCase();
    result = result.filter(category => 
      category.name.toLowerCase().includes(searchLower) || 
      (category.description && category.description.toLowerCase().includes(searchLower))
    );
  }
  
  // Filtre de statut
  if (statusFilter.value !== 'all') {
    const isActive = statusFilter.value === 'active';
    result = result.filter(category => category.is_active === isActive);
  }
  
  return result;
});

// Pagination
const totalPages = computed(() => {
  return Math.ceil(filteredCategories.value.length / itemsPerPage.value);
});

const paginatedCategories = computed(() => {
  const startIndex = (currentPage.value - 1) * itemsPerPage.value;
  const endIndex = startIndex + itemsPerPage.value;
  return filteredCategories.value.slice(startIndex, endIndex);
});

// Charger les données
const loadData = async () => {
  isLoading.value = true;
  
  try {
    const { data, error } = await supabase
      .from('categories')
      .select(`
        *,
        services_count:services(count)
      `)
      .order('name');
    
    if (error) throw error;
    
    // Transformer les données pour l'affichage
    categories.value = data.map(category => ({
      ...category,
      services_count: category.services_count[0]?.count || 0
    }));
    
  } catch (error) {
    console.error('Erreur lors du chargement des catégories:', error);
    showNotification('error', 'Erreur', 'Impossible de charger les catégories');
  } finally {
    isLoading.value = false;
  }
};

// Réinitialiser les filtres
const resetFilters = () => {
  search.value = '';
  statusFilter.value = 'all';
  currentPage.value = 1;
};

// Ouvrir la modal d'ajout
const openAddModal = () => {
  editMode.value = false;
  categoryForm.value = {
    name: '',
    description: '',
    icon: 'Briefcase',
    is_active: true
  };
  showCategoryModal.value = true;
};

// Modifier une catégorie
const editCategory = (category) => {
  editMode.value = true;
  selectedCategory.value = category;
  categoryForm.value = {
    name: category.name,
    description: category.description || '',
    icon: category.icon || 'Briefcase',
    is_active: category.is_active
  };
  showCategoryModal.value = true;
};

// Enregistrer une catégorie
const saveCategory = async () => {
  // Validation basique
  if (!categoryForm.value.name) {
    showNotification('error', 'Erreur', 'Le nom de la catégorie est requis');
    return;
  }
  
  isSaving.value = true;
  
  try {
    if (editMode.value) {
      // Mettre à jour une catégorie existante
      const { error } = await supabase
        .from('categories')
        .update({
          name: categoryForm.value.name,
          description: categoryForm.value.description,
          icon: categoryForm.value.icon,
          is_active: categoryForm.value.is_active,
          updated_at: new Date().toISOString()
        })
        .eq('id', selectedCategory.value.id);
      
      if (error) throw error;
      
      showNotification('success', 'Catégorie mise à jour', 'La catégorie a été mise à jour avec succès');
    } else {
      // Créer une nouvelle catégorie
      const { error } = await supabase
        .from('categories')
        .insert({
          name: categoryForm.value.name,
          description: categoryForm.value.description,
          icon: categoryForm.value.icon,
          is_active: categoryForm.value.is_active
        });
      
      if (error) throw error;
      
      showNotification('success', 'Catégorie ajoutée', 'La catégorie a été ajoutée avec succès');
    }
    
    // Fermer la modal et rafraîchir les données
    showCategoryModal.value = false;
    await loadData();
    
  } catch (error) {
    console.error('Erreur lors de l\'enregistrement de la catégorie:', error);
    showNotification('error', 'Erreur', 'Impossible d\'enregistrer la catégorie');
  } finally {
    isSaving.value = false;
  }
};

// Changer le statut d'une catégorie
const toggleCategoryStatus = async (category) => {
  const newStatus = !category.is_active;
  const action = newStatus ? 'activer' : 'désactiver';
  
  if (!confirm(`Êtes-vous sûr de vouloir ${action} cette catégorie ?`)) {
    return;
  }
  
  try {
    const { error } = await supabase
      .from('categories')
      .update({ 
        is_active: newStatus,
        updated_at: new Date().toISOString()
      })
      .eq('id', category.id);
    
    if (error) throw error;
    
    // Mettre à jour la catégorie localement
    category.is_active = newStatus;
    
    showNotification(
      'success', 
      'Statut modifié', 
      `La catégorie a été ${newStatus ? 'activée' : 'désactivée'} avec succès.`
    );
    
  } catch (error) {
    console.error('Erreur lors de la modification du statut:', error);
    showNotification(
      'error', 
      'Erreur', 
      `Impossible de ${action} la catégorie.`
    );
  }
};

// Supprimer une catégorie
const deleteCategory = (category) => {
  selectedCategory.value = category;
  showDeleteModal.value = true;
};

// Confirmer la suppression
const confirmDeleteCategory = async () => {
  isDeleting.value = true;
  
  try {
    // Vérifier si la catégorie contient des services
    if (selectedCategory.value.services_count > 0) {
      showNotification(
        'error',
        'Impossible de supprimer',
        `La catégorie "${selectedCategory.value.name}" contient des services et ne peut pas être supprimée.`
      );
      showDeleteModal.value = false;
      return;
    }
    
    const { error } = await supabase
      .from('categories')
      .delete()
      .eq('id', selectedCategory.value.id);
    
    if (error) throw error;
    
    showDeleteModal.value = false;
    showNotification('success', 'Catégorie supprimée', 'La catégorie a été supprimée avec succès');
    
    // Rafraîchir les données
    await loadData();
    
  } catch (error) {
    console.error('Erreur lors de la suppression de la catégorie:', error);
    showNotification('error', 'Erreur', 'Impossible de supprimer la catégorie');
  } finally {
    isDeleting.value = false;
  }
};

// Obtenir l'icône de la catégorie
const getCategoryIcon = (iconName) => {
  const iconMap = {
    Briefcase,
    Code,
    PenTool,
    Image,
    FileText,
    MessageSquare,
    ShoppingBag,
    Globe,
    Database,
    Smartphone
  };
  
  return iconMap[iconName] || FileText;
};

// Obtenir la classe de couleur pour la catégorie
const getCategoryColorClass = (categoryId) => {
  const colors = [
    'bg-blue-500',
    'bg-green-500',
    'bg-purple-500',
    'bg-amber-500',
    'bg-red-500',
    'bg-indigo-500',
    'bg-pink-500',
    'bg-teal-500'
  ];
  
  // Utiliser l'ID de la catégorie pour choisir une couleur
  const index = categoryId ? parseInt(categoryId) % colors.length : 0;
  return colors[index];
};

// Formater la date
const formatDate = (dateString) => {
  if (!dateString) return '-';
  const date = new Date(dateString);
  return new Intl.DateTimeFormat('fr-FR', {
    day: '2-digit',
    month: '2-digit',
    year: 'numeric'
  }).format(date);
};

// Afficher une notification
const showNotification = (type, title, message) => {
  if (!notification.value) {
    notification.value = {
      show: false,
      type: 'info',
      title: '',
      message: ''
    };
  }
  
  notification.value.show = true;
  notification.value.type = type;
  notification.value.title = title;
  notification.value.message = message;
  
  // Masquer automatiquement après 5 secondes
  setTimeout(() => {
    if (notification.value) {
      notification.value.show = false;
    }
  }, 5000);
};

// Rafraîchir les données
const refreshData = () => {
  loadData();
};

// Charger les données au montage du composant
onMounted(() => {
  loadData();
});

// Réinitialiser la pagination quand les filtres changent
watch([search, statusFilter], () => {
  currentPage.value = 1;
});

definePageMeta({
  layout: 'admin'
});
</script> 