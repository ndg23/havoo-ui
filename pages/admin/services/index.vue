<template>
  <div class="space-y-6 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
    <!-- En-tête avec style moderne -->
    <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
      <div>
        <h1 class="text-3xl font-bold text-gray-900 dark:text-white tracking-tight">Services</h1>
        <p class="text-gray-600 dark:text-gray-400 mt-1">Gérez les services proposés sur la plateforme</p>
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
    
    <!-- Filtres avec design épuré -->
    <div class="bg-white dark:bg-gray-800 rounded-2xl border border-gray-100 dark:border-gray-700 p-5 shadow-sm">
      <div class="flex flex-col md:flex-row md:items-center gap-4">
        <!-- Recherche -->
        <div class="relative flex-grow max-w-md">
          <Search class="absolute left-4 top-3.5 h-5 w-5 text-gray-400" />
          <input 
            v-model="search"
            type="text"
            placeholder="Rechercher un service..."
            class="pl-12 pr-4 py-3 border border-gray-200 dark:border-gray-600 rounded-xl w-full focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
          />
        </div>
        
        <div class="flex flex-wrap gap-3 items-center">
          <!-- Filtre de catégorie -->
          <select 
            v-model="categoryFilter"
            class="px-4 py-3 border border-gray-200 dark:border-gray-600 rounded-xl focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white appearance-none bg-none"
          >
            <option value="all">Toutes les catégories</option>
            <option v-for="category in professions" :key="category.id" :value="category.id">
              {{ category.name }}
            </option>
          </select>
          
          <!-- Filtre de statut -->
          <select 
            v-model="statusFilter"
            class="px-4 py-3 border border-gray-200 dark:border-gray-600 rounded-xl focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white appearance-none"
          >
            <option value="all">Tous les statuts</option>
            <option value="active">Actifs</option>
            <option value="inactive">Inactifs</option>
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
    <div v-else-if="filteredServices && filteredServices.length === 0" class="bg-white dark:bg-gray-800 rounded-2xl p-12 text-center border border-gray-100 dark:border-gray-700 shadow-sm">
      <div class="inline-flex items-center justify-center h-20 w-20 rounded-full bg-gray-100 dark:bg-gray-700 mb-6">
        <Briefcase class="h-10 w-10 text-gray-500 dark:text-gray-400" />
      </div>
      <h3 class="text-xl font-bold text-gray-900 dark:text-white mb-2">Aucun service trouvé</h3>
      <p class="text-gray-600 dark:text-gray-400 mb-6 max-w-md mx-auto">
        Essayez de modifier vos filtres ou d'ajouter un nouveau service.
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
          Ajouter un service
        </button>
      </div>
    </div>
    
    <!-- Tableau des services avec UTable -->
    <div v-else>
      <!-- Version tableau pour écrans moyens et grands -->
      <div class="hidden md:block">
        <UTable
          :columns="columns"
          :rows="paginatedServices"
          :loading="isLoading"
          class="bg-white dark:bg-gray-800 rounded-2xl border border-gray-100 dark:border-gray-700 overflow-hidden shadow-sm"
        >
          <!-- Colonne Service -->
          <template #service-data="{ row }">
            <div class="flex items-center gap-3">
              <div 
                class="h-12 w-12 rounded-xl flex items-center justify-center"
                :class="getCategoryColorClass(row.profession_id)"
              >
                <component :is="getCategoryIcon(row.category?.icon)" class="h-6 w-6 text-white" />
              </div>
              <div>
                <p class="text-sm font-medium text-gray-900 dark:text-white">{{ row.name }}</p>
                <p class="text-xs text-gray-500 dark:text-gray-400">{{ row.description || 'Aucune description' }}</p>
              </div>
            </div>
          </template>
          
          <!-- Colonne Catégorie -->
          <template #category-data="{ row }">
            <div class="text-sm text-gray-600 dark:text-gray-400">
              {{ row.category?.name || 'Non catégorisé' }}
            </div>
          </template>
          
          <!-- Colonne Prix -->
          <template #price-data="{ row }">
            <div class="text-sm text-gray-600 dark:text-gray-400">
              {{ formatPrice(row.price) }}
            </div>
          </template>
          
          <!-- Colonne Statut -->
          <template #status-data="{ row }">
            <span 
              class="inline-flex items-center px-3 py-1.5 rounded-full text-xs font-medium"
              :class="row.is_active ? 'bg-green-50 text-green-800 dark:bg-green-900/30 dark:text-green-400' : 'bg-red-50 text-red-800 dark:bg-red-900/30 dark:text-red-400'"
            >
              <span class="w-2 h-2 rounded-full mr-2" :class="row.is_active ? 'bg-green-500' : 'bg-red-500'"></span>
              {{ row.is_active ? 'Actif' : 'Inactif' }}
            </span>
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
                @click="editService(row)"
                class="p-2 text-gray-500 dark:text-gray-400 hover:text-primary-600 dark:hover:text-primary-400 hover:bg-primary-50 dark:hover:bg-primary-900/20 rounded-lg transition-colors"
                title="Modifier"
              >
                <Edit class="h-5 w-5" />
              </button>
              <button 
                @click="toggleServiceStatus(row)"
                class="p-2 text-gray-500 dark:text-gray-400 hover:text-amber-600 dark:hover:text-amber-400 hover:bg-amber-50 dark:hover:bg-amber-900/20 rounded-lg transition-colors"
                :title="row.is_active ? 'Désactiver' : 'Activer'"
              >
                <component :is="row.is_active ? 'EyeOff' : 'Eye'" class="h-5 w-5" />
              </button>
              <button 
                @click="deleteService(row)"
                class="p-2 text-gray-500 dark:text-gray-400 hover:text-red-600 dark:hover:text-red-400 hover:bg-red-50 dark:hover:bg-red-900/20 rounded-lg transition-colors"
                title="Supprimer"
              >
                <Trash2 class="h-5 w-5" />
              </button>
            </div>
          </template>
        </UTable>
      </div>
      
      <!-- Vue responsive pour petits écrans (mobile) -->
      <div class="block md:hidden space-y-4">
        <div 
          v-for="row in paginatedServices" 
          :key="row.id" 
          class="bg-white dark:bg-gray-800 rounded-2xl border border-gray-100 dark:border-gray-700 shadow-sm overflow-hidden"
        >
          <!-- En-tête avec service et icône -->
          <div class="p-4 border-b border-gray-100 dark:border-gray-700">
            <div class="flex items-center gap-3">
              <div 
                class="h-14 w-14 rounded-xl flex items-center justify-center"
                :class="getCategoryColorClass(row.profession_id)"
              >
                <component :is="getCategoryIcon(row.category?.icon)" class="h-7 w-7 text-white" />
              </div>
              <div>
                <p class="text-base font-medium text-gray-900 dark:text-white">{{ row.name }}</p>
                <p class="text-sm text-gray-500 dark:text-gray-400 mt-1">{{ row.description || 'Aucune description' }}</p>
              </div>
            </div>
          </div>
          
          <!-- Informations principales -->
          <div class="p-4">
            <div class="grid grid-cols-2 gap-4">
              <div>
                <p class="text-xs text-gray-500 dark:text-gray-400 mb-1">Catégorie</p>
                <p class="text-sm font-medium text-gray-700 dark:text-gray-300">{{ row.category?.name || 'Non catégorisé' }}</p>
              </div>
              
              <div>
                <p class="text-xs text-gray-500 dark:text-gray-400 mb-1">Prix</p>
                <p class="text-sm font-medium text-gray-700 dark:text-gray-300">{{ formatPrice(row.price) }}</p>
              </div>
              
              <div>
                <p class="text-xs text-gray-500 dark:text-gray-400 mb-1">Statut</p>
                <span 
                  class="inline-flex items-center px-3 py-1.5 rounded-full text-xs font-medium"
                  :class="row.is_active ? 'bg-green-50 text-green-800 dark:bg-green-900/30 dark:text-green-400' : 'bg-red-50 text-red-800 dark:bg-red-900/30 dark:text-red-400'"
                >
                  <span class="w-2 h-2 rounded-full mr-2" :class="row.is_active ? 'bg-green-500' : 'bg-red-500'"></span>
                  {{ row.is_active ? 'Actif' : 'Inactif' }}
                </span>
              </div>
              
              <div>
                <p class="text-xs text-gray-500 dark:text-gray-400 mb-1">Date de création</p>
                <p class="text-sm text-gray-700 dark:text-gray-300">{{ formatDate(row.created_at) }}</p>
              </div>
            </div>
          </div>
          
          <!-- Actions -->
          <div class="px-4 py-3 bg-gray-50 dark:bg-gray-700/50 border-t border-gray-100 dark:border-gray-700 flex justify-end gap-2">
            <button 
              @click="editService(row)"
              class="px-3 py-1.5 flex items-center gap-1.5 text-sm text-gray-700 dark:text-gray-300 hover:text-primary-600 dark:hover:text-primary-400 hover:bg-primary-50 dark:hover:bg-primary-900/20 rounded-lg transition-colors"
            >
              <Edit class="h-4 w-4" />
              <span>Modifier</span>
            </button>
            <button 
              @click="toggleServiceStatus(row)"
              class="px-3 py-1.5 flex items-center gap-1.5 text-sm text-gray-700 dark:text-gray-300 hover:text-amber-600 dark:hover:text-amber-400 hover:bg-amber-50 dark:hover:bg-amber-900/20 rounded-lg transition-colors"
            >
              <component :is="row.is_active ? 'EyeOff' : 'Eye'" class="h-4 w-4" />
              <span>{{ row.is_active ? 'Désactiver' : 'Activer' }}</span>
            </button>
            <button 
              @click="deleteService(row)"
              class="px-3 py-1.5 flex items-center gap-1.5 text-sm text-gray-700 dark:text-gray-300 hover:text-red-600 dark:hover:text-red-400 hover:bg-red-50 dark:hover:bg-red-900/20 rounded-lg transition-colors"
            >
              <Trash2 class="h-4 w-4" />
              <span>Supprimer</span>
            </button>
          </div>
        </div>
      </div>
      
      <!-- Pagination responsive -->
      <div class="flex flex-col sm:flex-row sm:justify-between sm:items-center gap-4 mt-6">
        <div class="text-sm text-gray-600 dark:text-gray-400 order-2 sm:order-1 text-center sm:text-left">
          Affichage de {{ paginatedServices.length }} sur {{ filteredServices.length }} services
        </div>
        <div class="flex items-center justify-center gap-2 bg-white dark:bg-gray-800 rounded-xl border border-gray-100 dark:border-gray-700 p-1 shadow-sm order-1 sm:order-2">
          <button 
            @click="currentPage--"
            :disabled="currentPage === 1"
            class="p-2 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-700 text-gray-600 dark:text-gray-400 disabled:opacity-50 disabled:hover:bg-transparent dark:disabled:hover:bg-transparent transition-colors"
          >
            <ChevronLeft class="h-5 w-5" />
          </button>
          <span class="px-2 text-sm text-gray-600 dark:text-gray-400">
            Page {{ currentPage }} sur {{ totalPages }}
          </span>
          <button 
            @click="currentPage++"
            :disabled="currentPage === totalPages"
            class="p-2 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-700 text-gray-600 dark:text-gray-400 disabled:opacity-50 disabled:hover:bg-transparent dark:disabled:hover:bg-transparent transition-colors"
          >
            <ChevronRight class="h-5 w-5" />
          </button>
        </div>
      </div>
    </div>
    
    <!-- Modal d'ajout/modification de service -->
    <UModal v-model="showServiceModal">
      <div class="p-6">
        <h2 class="text-xl font-bold text-gray-900 dark:text-white mb-6">
          {{ editMode ? 'Modifier le service' : 'Ajouter un service' }}
        </h2>
        
        <div class="space-y-4">
          <!-- Nom -->
          <div>
            <label for="service-name" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Nom</label>
            <input 
              id="service-name"
              v-model="serviceForm.name"
              type="text"
              class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-xl focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
              placeholder="Nom du service"
            />
          </div>
          
          <!-- Description -->
          <div>
            <label for="service-description" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Description</label>
            <textarea 
              id="service-description"
              v-model="serviceForm.description"
              rows="3"
              class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-xl focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
              placeholder="Description du service"
            ></textarea>
          </div>
          
          <!-- Catégorie -->
          <div>
            <label for="service-category" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Catégorie</label>
            <select 
              id="service-category"
              v-model="serviceForm.profession_id"
              class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-xl focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
            >
              <option value="">Sélectionner une catégorie</option>
              <option v-for="category in professions" :key="category.id" :value="category.id">
                {{ category.name }}
              </option>
            </select>
          </div>
          
          <!-- Prix -->
          <div>
            <label for="service-price" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Prix (FCFA)</label>
            <input 
              id="service-price"
              v-model="serviceForm.price"
              type="number"
              min="0"
              class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-xl focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
              placeholder="Prix du service"
            />
          </div>
          
          <!-- Durée estimée -->
          <div>
            <label for="service-duration" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Durée estimée (jours)</label>
            <input 
              id="service-duration"
              v-model="serviceForm.estimated_duration"
              type="number"
              min="1"
              class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-xl focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
              placeholder="Durée estimée en jours"
            />
          </div>
          
          <!-- Statut -->
          <div class="flex items-center">
            <input 
              id="service-active"
              v-model="serviceForm.is_active"
              type="checkbox"
              class="h-4 w-4 text-primary-600 focus:ring-primary-500 border-gray-300 rounded"
            />
            <label for="service-active" class="ml-2 block text-sm text-gray-700 dark:text-gray-300">
              Service actif
            </label>
          </div>
        </div>
        
        <div class="flex justify-end gap-3 mt-6">
          <button 
            @click="showServiceModal = false"
            class="px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-xl text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700"
          >
            Annuler
          </button>
          <button 
            @click="saveService"
            class="px-4 py-2 bg-primary-600 hover:bg-primary-700 text-white rounded-xl"
            :disabled="isSaving"
          >
            <div v-if="isSaving" class="flex items-center gap-2">
              <div class="animate-spin h-4 w-4 border-2 border-white border-r-transparent rounded-full"></div>
              <span>Enregistrement...</span>
            </div>
            <span v-else>{{ editMode ? 'Mettre à jour' : 'Ajouter' }}</span>
          </button>
        </div>
      </div>
    </UModal>
    
    <!-- Modal de confirmation de suppression -->
    <UModal v-model="showDeleteModal">
      <div class="p-6">
        <h2 class="text-xl font-bold text-gray-900 dark:text-white mb-4">Confirmer la suppression</h2>
        <p class="text-gray-600 dark:text-gray-400 mb-6">
          Êtes-vous sûr de vouloir supprimer le service "{{ selectedService?.name }}" ? Cette action est irréversible.
        </p>
        
        <div class="flex justify-end gap-3">
          <button 
            @click="showDeleteModal = false"
            class="px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-xl text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700"
          >
            Annuler
          </button>
          <button 
            @click="confirmDeleteService"
            class="px-4 py-2 bg-red-600 hover:bg-red-700 text-white rounded-xl"
            :disabled="isDeleting"
          >
            <div v-if="isDeleting" class="flex items-center gap-2">
              <div class="animate-spin h-4 w-4 border-2 border-white border-r-transparent rounded-full"></div>
              <span>Suppression...</span>
            </div>
            <span v-else>Supprimer</span>
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
  Info, Briefcase, ChevronLeft, ChevronRight, Eye, EyeOff, Code, 
  PenTool, Image, FileText, MessageSquare, ShoppingBag, Globe, Database, 
  Smartphone 
} from 'lucide-vue-next';
import { useSupabaseClient } from '#imports';

const supabase = useSupabaseClient();
const router = useRouter();

// État des données
const services = ref([]);
const professions = ref([]);
const isLoading = ref(true);
const search = ref('');
const categoryFilter = ref('all');
const statusFilter = ref('all');
const currentPage = ref(1);
const itemsPerPage = ref(10);
const showServiceModal = ref(false);
const showDeleteModal = ref(false);
const editMode = ref(false);
const selectedService = ref(null);
const isSaving = ref(false);
const isDeleting = ref(false);

// Notification avec initialisation correcte
const notification = ref({
  show: false,
  type: 'info',
  title: '',
  message: ''
});

// Formulaire de service
const serviceForm = ref({
  name: '',
  description: '',
  profession_id: '',
  price: 0,
  estimated_duration: 1,
  is_active: true
});

// Colonnes pour UTable
const columns = [
  {
    key: 'service',
    label: 'Service',
    sortable: true
  },
  {
    key: 'category',
    label: 'Catégorie',
    sortable: true
  },
  {
    key: 'price',
    label: 'Prix',
    sortable: true
  },
  {
    key: 'status',
    label: 'Statut',
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
const filteredServices = computed(() => {
  if (!services.value) return [];
  
  let result = [...services.value];
  
  // Filtre de recherche
  if (search.value) {
    const searchLower = search.value.toLowerCase();
    result = result.filter(service => 
      service.name.toLowerCase().includes(searchLower) || 
      (service.description && service.description.toLowerCase().includes(searchLower))
    );
  }
  
  // Filtre de catégorie
  if (categoryFilter.value !== 'all') {
    result = result.filter(service => service.profession_id === categoryFilter.value);
  }
  
  // Filtre de statut
  if (statusFilter.value !== 'all') {
    const isActive = statusFilter.value === 'active';
    result = result.filter(service => service.is_active === isActive);
  }
  
  return result;
});

// Pagination
const totalPages = computed(() => {
  return Math.ceil(filteredServices.value.length / itemsPerPage.value);
});

const paginatedServices = computed(() => {
  const startIndex = (currentPage.value - 1) * itemsPerPage.value;
  const endIndex = startIndex + itemsPerPage.value;
  return filteredServices.value.slice(startIndex, endIndex);
});

// Charger les données
const loadData = async () => {
  isLoading.value = true;
  
  try {
    // Charger les services
    const { data: servicesData, error: servicesError } = await supabase
      .from('services')
      .select(`
        *,
        category:professions(*)
      `)
      .order('title');
    
    if (servicesError) throw servicesError;
    
    services.value = servicesData || [];
    
    // Charger les catégories
    const { data: professionsData, error: professionsError } = await supabase
      .from('professions')
      .select('*')
      .order('name');
    
    if (professionsError) throw professionsError;
    
    professions.value = professionsData || [];
    
  } catch (error) {
    console.error('Erreur lors du chargement des données:', error);
    showNotification('error', 'Erreur', 'Impossible de charger les services');
  } finally {
    isLoading.value = false;
  }
};

// Réinitialiser les filtres
const resetFilters = () => {
  search.value = '';
  categoryFilter.value = 'all';
  statusFilter.value = 'all';
  currentPage.value = 1;
};

// Ouvrir la modal d'ajout
const openAddModal = () => {
  editMode.value = false;
  serviceForm.value = {
    name: '',
    description: '',
    profession_id: '',
    price: 0,
    estimated_duration: 1,
    is_active: true
  };
  showServiceModal.value = true;
};

// Modifier un service
const editService = (service) => {
  editMode.value = true;
  selectedService.value = service;
  serviceForm.value = {
    name: service.name,
    description: service.description || '',
    profession_id: service.profession_id || '',
    price: service.price || 0,
    estimated_duration: service.estimated_duration || 1,
    is_active: service.is_active
  };
  showServiceModal.value = true;
};

// Enregistrer un service
const saveService = async () => {
  // Validation basique
  if (!serviceForm.value.name) {
    showNotification('error', 'Erreur', 'Le nom du service est requis');
    return;
  }
  
  if (!serviceForm.value.profession_id) {
    showNotification('error', 'Erreur', 'La catégorie est requise');
    return;
  }
  
  isSaving.value = true;
  
  try {
    if (editMode.value) {
      // Mettre à jour un service existant
      const { error } = await supabase
        .from('services')
        .update({
          name: serviceForm.value.name,
          description: serviceForm.value.description,
          profession_id: serviceForm.value.profession_id,
          price: serviceForm.value.price,
          estimated_duration: serviceForm.value.estimated_duration,
          is_active: serviceForm.value.is_active,
          updated_at: new Date().toISOString()
        })
        .eq('id', selectedService.value.id);
      
      if (error) throw error;
      
      showNotification('success', 'Service mis à jour', 'Le service a été mis à jour avec succès');
    } else {
      // Créer un nouveau service
      const { error } = await supabase
        .from('services')
        .insert({
          name: serviceForm.value.name,
          description: serviceForm.value.description,
          profession_id: serviceForm.value.profession_id,
          price: serviceForm.value.price,
          estimated_duration: serviceForm.value.estimated_duration,
          is_active: serviceForm.value.is_active
        });
      
      if (error) throw error;
      
      showNotification('success', 'Service ajouté', 'Le service a été ajouté avec succès');
    }
    
    // Fermer la modal et rafraîchir les données
    showServiceModal.value = false;
    await loadData();
    
  } catch (error) {
    console.error('Erreur lors de l\'enregistrement du service:', error);
    showNotification('error', 'Erreur', 'Impossible d\'enregistrer le service');
  } finally {
    isSaving.value = false;
  }
};

// Changer le statut d'un service
const toggleServiceStatus = async (service) => {
  const newStatus = !service.is_active;
  const action = newStatus ? 'activer' : 'désactiver';
  
  if (!confirm(`Êtes-vous sûr de vouloir ${action} ce service ?`)) {
    return;
  }
  
  try {
    const { error } = await supabase
      .from('services')
      .update({ 
        is_active: newStatus,
        updated_at: new Date().toISOString()
      })
      .eq('id', service.id);
    
    if (error) throw error;
    
    // Mettre à jour le service localement
    service.is_active = newStatus;
    
    showNotification(
      'success', 
      'Statut modifié', 
      `Le service a été ${newStatus ? 'activé' : 'désactivé'} avec succès`
    );
    
  } catch (error) {
    console.error('Erreur lors de la modification du statut:', error);
    showNotification(
      'error', 
      'Erreur', 
      `Impossible de ${action} le service`
    );
  }
};

// Supprimer un service
const deleteService = (service) => {
  selectedService.value = service;
  showDeleteModal.value = true;
};

// Confirmer la suppression
const confirmDeleteService = async () => {
  isDeleting.value = true;
  
  try {
    const { error } = await supabase
      .from('services')
      .delete()
      .eq('id', selectedService.value.id);
    
    if (error) throw error;
    
    showDeleteModal.value = false;
    showNotification('success', 'Service supprimé', 'Le service a été supprimé avec succès');
    
    // Rafraîchir les données
    await loadData();
    
  } catch (error) {
    console.error('Erreur lors de la suppression du service:', error);
    showNotification('error', 'Erreur', 'Impossible de supprimer le service');
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

// Formater le prix
const formatPrice = (price) => {
  if (price === null || price === undefined) return '-';
  return new Intl.NumberFormat('fr-FR', {
    style: 'currency',
    currency: 'XOF',
    minimumFractionDigits: 0
  }).format(price);
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
watch([search, categoryFilter, statusFilter], () => {
  currentPage.value = 1;
});

definePageMeta({
  layout: 'admin'
});
</script>