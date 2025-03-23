<template>
  <div class="space-y-6 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
    <!-- En-tête avec style moderne -->
    <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
      <div>
        <h1 class="text-3xl font-bold text-gray-900 dark:text-white tracking-tight">Vérifications d'identité</h1>
        <p class="text-gray-600 dark:text-gray-400 mt-1">Gérez les demandes de vérification des experts</p>
      </div>
      
      <!-- Actions principales -->
      <div class="flex items-center gap-3">
        <button 
          @click="exportData"
          class="btn-outline flex items-center gap-2"
        >
          <Download class="h-4 w-4" />
          <span>Exporter</span>
        </button>
        <button 
          @click="refreshData"
          class="btn-primary flex items-center gap-2"
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
    
    <!-- Statistiques avec cartes modernes -->
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-5">
      <div 
        v-for="stat in stats" 
        :key="stat.label"
        class="bg-white dark:bg-gray-800 p-6 rounded-2xl border border-gray-100 dark:border-gray-700 shadow-sm hover:shadow-md transition-shadow duration-200"
      >
        <div class="flex items-center justify-between">
          <div>
            <p class="text-sm font-medium text-gray-500 dark:text-gray-400">{{ stat.label }}</p>
            <p class="text-3xl font-bold text-gray-900 dark:text-white mt-1">{{ stat.value }}</p>
          </div>
          <div 
            class="h-14 w-14 rounded-2xl flex items-center justify-center"
            :class="stat.colorClass"
          >
            <component :is="stat.icon" class="h-7 w-7 text-white" />
          </div>
        </div>
      </div>
    </div>
    
    <!-- Filtres avec design épuré -->
    <div class="bg-white dark:bg-gray-800 rounded-2xl border border-gray-100 dark:border-gray-700 p-5 shadow-sm">
      <div class="flex flex-col md:flex-row md:items-center gap-4">
        <!-- Recherche -->
        <div class="relative flex-grow max-w-md">
          <Search class="absolute left-4 top-3.5 h-5 w-5 text-gray-400" />
          <input 
            v-model="search"
            type="text"
            placeholder="Rechercher un expert..."
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
            <option value="pending">En attente</option>
            <option value="approved">Approuvées</option>
            <option value="rejected">Rejetées</option>
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
    <div v-else-if="filteredVerifications && filteredVerifications.length === 0" class="bg-white dark:bg-gray-800 rounded-2xl p-12 text-center border border-gray-100 dark:border-gray-700 shadow-sm">
      <div class="inline-flex items-center justify-center h-20 w-20 rounded-full bg-gray-100 dark:bg-gray-700 mb-6">
        <FileCheck class="h-10 w-10 text-gray-500 dark:text-gray-400" />
      </div>
      <h3 class="text-xl font-bold text-gray-900 dark:text-white mb-2">Aucune vérification trouvée</h3>
      <p class="text-gray-600 dark:text-gray-400 mb-6 max-w-md mx-auto">
        Essayez de modifier vos filtres ou d'attendre que des experts soumettent des documents de vérification.
      </p>
      <div class="flex flex-wrap justify-center gap-4">
        <button 
          @click="resetFilters"
          class="px-6 py-3 bg-gray-100 hover:bg-gray-200 dark:bg-gray-700 dark:hover:bg-gray-600 text-gray-700 dark:text-gray-300 font-medium rounded-xl transition-colors"
        >
          Réinitialiser les filtres
        </button>
      </div>
    </div>
    
    <!-- Tableau des vérifications avec UTable -->
    <div v-else>
      <UTable
        :columns="columns"
        :rows="paginatedVerifications"
        :loading="isLoading"
        class="bg-white dark:bg-gray-800 rounded-2xl border border-gray-100 dark:border-gray-700 overflow-hidden shadow-sm"
      >
        <!-- Colonne Expert -->
        <template #expert-data="{ row }">
          <div class="flex items-center gap-3">
            <div class="h-10 w-10 rounded-full bg-gray-200 dark:bg-gray-700 flex items-center justify-center overflow-hidden">
              <img v-if="row.expert?.avatar_url" :src="row.expert.avatar_url" alt="Avatar" class="h-full w-full object-cover" />
              <User v-else class="h-4 w-4 text-gray-500 dark:text-gray-400" />
            </div>
            <div>
              <p class="text-sm font-medium text-gray-900 dark:text-white">
                {{ row.expert ? `${row.expert.first_name} ${row.expert.last_name}` : 'Expert inconnu' }}
              </p>
              <p class="text-xs text-gray-500 dark:text-gray-400">{{ row.expert?.email || '-' }}</p>
            </div>
          </div>
        </template>
        
        <!-- Colonne Documents -->
        <template #documents-data="{ row }">
          <div class="flex flex-col gap-1">
            <div v-if="row.id_document_url" class="flex items-center gap-2">
              <FileText class="h-4 w-4 text-gray-500" />
              <a 
                :href="row.id_document_url" 
                target="_blank" 
                class="text-sm text-primary-600 hover:text-primary-700 dark:text-primary-400 dark:hover:text-primary-300"
              >
                Pièce d'identité
              </a>
            </div>
            <div v-if="row.professional_document_url" class="flex items-center gap-2">
              <FileText class="h-4 w-4 text-gray-500" />
              <a 
                :href="row.professional_document_url" 
                target="_blank" 
                class="text-sm text-primary-600 hover:text-primary-700 dark:text-primary-400 dark:hover:text-primary-300"
              >
                Document professionnel
              </a>
            </div>
            <div v-if="row.selfie_url" class="flex items-center gap-2">
              <Image class="h-4 w-4 text-gray-500" />
              <a 
                :href="row.selfie_url" 
                target="_blank" 
                class="text-sm text-primary-600 hover:text-primary-700 dark:text-primary-400 dark:hover:text-primary-300"
              >
                Selfie
              </a>
            </div>
          </div>
        </template>
        
        <!-- Colonne Statut -->
        <template #status-data="{ row }">
          <span 
            class="inline-flex items-center px-3 py-1.5 rounded-full text-xs font-medium"
            :class="getStatusClass(row.status)"
          >
            <span class="w-2 h-2 rounded-full mr-2" :class="getStatusDotClass(row.status)"></span>
            {{ formatStatus(row.status) }}
          </span>
        </template>
        
        <!-- Colonne Date de soumission -->
        <template #submitted-at-data="{ row }">
          <div class="text-sm text-gray-600 dark:text-gray-400">
            {{ formatDate(row.created_at) }}
          </div>
        </template>
        
        <!-- Colonne Actions -->
        <template #actions-data="{ row }">
          <div class="flex justify-end gap-2">
            <button 
              v-if="row.status === 'pending'"
              @click="approveVerification(row)"
              class="p-2 text-gray-500 dark:text-gray-400 hover:text-green-600 dark:hover:text-green-400 hover:bg-green-50 dark:hover:bg-green-900/20 rounded-lg transition-colors"
              title="Approuver"
            >
              <CheckCircle class="h-5 w-5" />
            </button>
            <button 
              v-if="row.status === 'pending'"
              @click="rejectVerification(row)"
              class="p-2 text-gray-500 dark:text-gray-400 hover:text-red-600 dark:hover:text-red-400 hover:bg-red-50 dark:hover:bg-red-900/20 rounded-lg transition-colors"
              title="Rejeter"
            >
              <XCircle class="h-5 w-5" />
            </button>
            <button 
              @click="viewVerification(row)"
              class="p-2 text-gray-500 dark:text-gray-400 hover:text-primary-600 dark:hover:text-primary-400 hover:bg-primary-50 dark:hover:bg-primary-900/20 rounded-lg transition-colors"
              title="Voir les détails"
            >
              <Eye class="h-5 w-5" />
            </button>
          </div>
        </template>
      </UTable>
      
      <!-- Pagination -->
      <div class="flex justify-center mt-6">
        <nav class="flex items-center gap-1">
          <button 
            @click="currentPage > 1 ? currentPage-- : null"
            :disabled="currentPage <= 1"
            class="p-2 rounded-lg text-gray-500 dark:text-gray-400 hover:bg-gray-100 dark:hover:bg-gray-700 disabled:opacity-50 disabled:cursor-not-allowed"
          >
            <ChevronLeft class="h-5 w-5" />
          </button>
          
          <div v-for="page in totalPages" :key="page" class="hidden md:block">
            <button 
              v-if="page === currentPage || page === 1 || page === totalPages || (page >= currentPage - 1 && page <= currentPage + 1)"
              @click="currentPage = page"
              class="h-10 w-10 rounded-lg flex items-center justify-center transition-colors"
              :class="page === currentPage ? 'bg-primary-500 text-white' : 'text-gray-500 dark:text-gray-400 hover:bg-gray-100 dark:hover:bg-gray-700'"
            >
              {{ page }}
            </button>
            <span 
              v-else-if="page === currentPage - 2 || page === currentPage + 2"
              class="h-10 w-10 flex items-center justify-center text-gray-500 dark:text-gray-400"
            >
              ...
            </span>
          </div>
          
          <div class="md:hidden">
            <span class="px-3 py-2 text-gray-500 dark:text-gray-400">
              {{ currentPage }} / {{ totalPages }}
            </span>
          </div>
          
          <button 
            @click="currentPage < totalPages ? currentPage++ : null"
            :disabled="currentPage >= totalPages"
            class="p-2 rounded-lg text-gray-500 dark:text-gray-400 hover:bg-gray-100 dark:hover:bg-gray-700 disabled:opacity-50 disabled:cursor-not-allowed"
          >
            <ChevronRight class="h-5 w-5" />
          </button>
        </nav>
      </div>
    </div>
    
    <!-- Modal d'approbation -->
    <UModal v-model="showApproveModal">
      <div class="p-6 space-y-4">
        <h3 class="text-xl font-bold text-gray-900 dark:text-white">Approuver la vérification</h3>
        <p class="text-gray-600 dark:text-gray-400">
          Êtes-vous sûr de vouloir approuver cette vérification d'identité ? L'expert sera marqué comme vérifié et pourra accéder à toutes les fonctionnalités.
        </p>
        <div class="flex justify-end gap-3 mt-6">
          <button 
            @click="showApproveModal = false"
            class="px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-xl text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700"
          >
            Annuler
          </button>
          <button 
            @click="confirmApproveVerification"
            class="px-4 py-2 bg-green-600 hover:bg-green-700 text-white rounded-xl"
            :disabled="isProcessing"
          >
            <span v-if="isProcessing" class="flex items-center gap-2">
              <span class="h-4 w-4 border-2 border-white border-t-transparent rounded-full animate-spin"></span>
              Traitement...
            </span>
            <span v-else>Confirmer l'approbation</span>
          </button>
        </div>
      </div>
    </UModal>
    
    <!-- Modal de rejet -->
    <UModal v-model="showRejectModal">
      <div class="p-6 space-y-4">
        <h3 class="text-xl font-bold text-gray-900 dark:text-white">Rejeter la vérification</h3>
        <p class="text-gray-600 dark:text-gray-400">
          Veuillez indiquer la raison du rejet de cette vérification d'identité. Cette information sera communiquée à l'expert.
        </p>
        <div class="mt-4">
          <label for="rejection-reason" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
            Raison du rejet
          </label>
          <textarea 
            id="rejection-reason"
            v-model="rejectionReason"
            rows="4"
            class="w-full px-4 py-3 border border-gray-200 dark:border-gray-600 rounded-xl focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
            placeholder="Veuillez expliquer pourquoi cette vérification est rejetée..."
          ></textarea>
        </div>
        <div class="flex justify-end gap-3 mt-6">
          <button 
            @click="showRejectModal = false"
            class="px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-xl text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700"
          >
            Annuler
          </button>
          <button 
            @click="confirmRejectVerification"
            class="px-4 py-2 bg-red-600 hover:bg-red-700 text-white rounded-xl"
            :disabled="isProcessing || !rejectionReason"
          >
            <span v-if="isProcessing" class="flex items-center gap-2">
              <span class="h-4 w-4 border-2 border-white border-t-transparent rounded-full animate-spin"></span>
              Traitement...
            </span>
            <span v-else>Confirmer le rejet</span>
          </button>
        </div>
      </div>
    </UModal>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue';
import { useRouter } from 'vue-router';
import { 
  Download, Search, RefreshCw, X, CheckCircle, AlertTriangle, 
  Info, FileCheck, ChevronLeft, ChevronRight, Eye, User,
  FileText, Image, ThumbsUp, ThumbsDown, Clock
} from 'lucide-vue-next';
import { useSupabaseClient } from '#imports';

const supabase = useSupabaseClient();
const router = useRouter();

// État des données
const verifications = ref([]);
const isLoading = ref(true);
const search = ref('');
const statusFilter = ref('all');
const currentPage = ref(1);
const itemsPerPage = ref(10);
const showApproveModal = ref(false);
const showRejectModal = ref(false);
const showDocumentModal = ref(false);
const selectedVerification = ref(null);
const selectedDocument = ref(null);
const rejectionReason = ref('');
const isProcessing = ref(false);

// Notification avec initialisation correcte
const notification = ref({
  show: false,
  type: 'info',
  title: '',
  message: ''
});

// Statistiques
const stats = ref([
  {
    label: 'Total',
    value: 0,
    icon: FileCheck,
    colorClass: 'bg-blue-500'
  },
  {
    label: 'En attente',
    value: 0,
    icon: Clock,
    colorClass: 'bg-amber-500'
  },
  {
    label: 'Approuvées',
    value: 0,
    icon: ThumbsUp,
    colorClass: 'bg-green-500'
  },
  {
    label: 'Rejetées',
    value: 0,
    icon: ThumbsDown,
    colorClass: 'bg-red-500'
  }
]);

// Colonnes pour UTable
const columns = [
  {
    key: 'expert',
    label: 'Expert',
    sortable: true
  },
  {
    key: 'documents',
    label: 'Documents',
    sortable: false
  },
  {
    key: 'status',
    label: 'Statut',
    sortable: true
  },
  {
    key: 'created_at',
    label: 'Date de soumission',
    sortable: true
  },
  {
    key: 'actions',
    label: 'Actions',
    sortable: false
  }
];

// Computed properties
const filteredVerifications = computed(() => {
  if (!verifications.value) return [];
  
  let result = [...verifications.value];
  
  // Filtre de recherche
  if (search.value) {
    const searchLower = search.value.toLowerCase();
    result = result.filter(verification => 
      verification.expert?.first_name?.toLowerCase().includes(searchLower) || 
      verification.expert?.last_name?.toLowerCase().includes(searchLower) ||
      verification.expert?.email?.toLowerCase().includes(searchLower)
    );
  }
  
  // Filtre de statut
  if (statusFilter.value !== 'all') {
    result = result.filter(verification => verification.status === statusFilter.value);
  }
  
  return result;
});

// Pagination
const totalPages = computed(() => {
  return Math.ceil(filteredVerifications.value.length / itemsPerPage.value);
});

const paginatedVerifications = computed(() => {
  const startIndex = (currentPage.value - 1) * itemsPerPage.value;
  const endIndex = startIndex + itemsPerPage.value;
  return filteredVerifications.value.slice(startIndex, endIndex);
});

// Charger les données
const loadData = async () => {
  isLoading.value = true;
  
  try {
    const { data, error } = await supabase
      .from('identity_verifications')
      .select(`
        *,
        expert:expert_id(id, first_name, last_name, email, avatar_url)
      `)
      .order('created_at', { ascending: false });
    
    if (error) throw error;
    
    verifications.value = data || [];
    
    // Mettre à jour les statistiques
    updateStats();
    
  } catch (error) {
    console.error('Erreur lors du chargement des données:', error);
    showNotification('error', 'Erreur', 'Impossible de charger les vérifications');
  } finally {
    isLoading.value = false;
  }
};

// Mettre à jour les statistiques
const updateStats = () => {
  if (!verifications.value) return;
  
  stats.value[0].value = verifications.value.length;
  stats.value[1].value = verifications.value.filter(v => v.status === 'pending').length;
  stats.value[2].value = verifications.value.filter(v => v.status === 'approved').length;
  stats.value[3].value = verifications.value.filter(v => v.status === 'rejected').length;
};

// Réinitialiser les filtres
const resetFilters = () => {
  search.value = '';
  statusFilter.value = 'all';
  currentPage.value = 1;
};

// Voir les détails d'une vérification
const viewVerification = (verification) => {
  router.push(`/admin/verifications/${verification.id}`);
};

// Approuver une vérification
const approveVerification = (verification) => {
  selectedVerification.value = verification;
  showApproveModal.value = true;
};

// Confirmer l'approbation d'une vérification
const confirmApproveVerification = async () => {
  if (!selectedVerification.value) return;
  
  isProcessing.value = true;
  
  try {
    // 1. Mettre à jour le statut de la vérification
    const { error: verificationError } = await supabase
      .from('identity_verifications')
      .update({ 
        status: 'approved',
        updated_at: new Date().toISOString()
      })
      .eq('id', selectedVerification.value.id);
    
    if (verificationError) throw verificationError;
    
    // 2. Mettre à jour le statut de l'expert
    const { error: expertError } = await supabase
      .from('profiles')
      .update({ 
        is_verified: true,
        updated_at: new Date().toISOString()
      })
      .eq('id', selectedVerification.value.expert_id);
    
    if (expertError) throw expertError;
    
    // Fermer la modal et afficher une notification
    showApproveModal.value = false;
    showNotification('success', 'Vérification approuvée', 'La vérification a été approuvée et l\'expert est maintenant certifié');
    
    // Rafraîchir les données
    await loadData();
    
  } catch (error) {
    console.error('Erreur lors de l\'approbation de la vérification:', error);
    showNotification('error', 'Erreur', 'Impossible d\'approuver la vérification');
  } finally {
    isProcessing.value = false;
  }
};

// Rejeter une vérification
const rejectVerification = (verification) => {
  selectedVerification.value = verification;
  rejectionReason.value = '';
  showRejectModal.value = true;
};

// Confirmer le rejet d'une vérification
const confirmRejectVerification = async () => {
  if (!selectedVerification.value || !rejectionReason.value) return;
  
  isProcessing.value = true;
  
  try {
    // Mettre à jour le statut de la vérification
    const { error } = await supabase
      .from('identity_verifications')
      .update({ 
        status: 'rejected',
        rejection_reason: rejectionReason.value,
        updated_at: new Date().toISOString()
      })
      .eq('id', selectedVerification.value.id);
    
    if (error) throw error;
    
    // Fermer la modal et afficher une notification
    showRejectModal.value = false;
    showNotification('success', 'Vérification rejetée', 'La vérification a été rejetée avec succès');
    
    // Rafraîchir les données
    await loadData();
    
  } catch (error) {
    console.error('Erreur lors du rejet de la vérification:', error);
    showNotification('error', 'Erreur', 'Impossible de rejeter la vérification');
  } finally {
    isProcessing.value = false;
  }
};

// Formater le statut
const formatStatus = (status) => {
  const statusMap = {
    pending: "En attente",
    approved: "Approuvée",
    rejected: "Rejetée"
  };
  return statusMap[status] || "Non défini";
};

// Formater la date
const formatDate = (dateString) => {
  if (!dateString) return '-';
  const date = new Date(dateString);
  return new Intl.DateTimeFormat('fr-FR', {
    day: '2-digit',
    month: '2-digit',
    year: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  }).format(date);
};

// Obtenir la classe de style pour le statut
const getStatusClass = (status) => {
  const statusClasses = {
    pending: "bg-amber-50 text-amber-800 dark:bg-amber-900/30 dark:text-amber-400",
    approved: "bg-green-50 text-green-800 dark:bg-green-900/30 dark:text-green-400",
    rejected: "bg-red-50 text-red-800 dark:bg-red-900/30 dark:text-red-400"
  };
  return statusClasses[status] || "bg-gray-50 text-gray-800 dark:bg-gray-900/30 dark:text-gray-400";
};

// Obtenir la classe de style pour le point de statut
const getStatusDotClass = (status) => {
  const dotClasses = {
    pending: "bg-amber-500",
    approved: "bg-green-500",
    rejected: "bg-red-500"
  };
  return dotClasses[status] || "bg-gray-500";
};

// Obtenir la classe de couleur pour le statut
const getStatusColorClass = (status) => {
  const colorClasses = {
    pending: "bg-amber-500",
    approved: "bg-green-500",
    rejected: "bg-red-500"
  };
  return colorClasses[status] || "bg-gray-500";
};

// Obtenir l'icône pour le statut
const getStatusIcon = (status) => {
  const statusIcons = {
    pending: Clock,
    approved: CheckCircle,
    rejected: AlertTriangle
  };
  return statusIcons[status] || Info;
};

// Vérifier si le fichier est une image
const isImage = (fileType) => {
  if (!fileType) return false;
  return ['jpg', 'jpeg', 'png', 'gif', 'webp'].includes(fileType.toLowerCase());
};

// Ouvrir le modal de prévisualisation
const openDocumentModal = (document) => {
  selectedDocument.value = document;
  showDocumentModal.value = true;
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

// Exporter les données
const exportData = async () => {
  try {
    if (!verifications.value || verifications.value.length === 0) {
      showNotification('info', 'Information', 'Aucune donnée à exporter');
      return;
    }
    
    // Transformer les données pour l'export
    const exportData = verifications.value.map(verification => ({
      ID: verification.id,
      Expert: verification.expert ? `${verification.expert.first_name} ${verification.expert.last_name}` : 'Non défini',
      Email: verification.expert?.email || '-',
      Statut: formatStatus(verification.status),
      'Raison du rejet': verification.rejection_reason || '-',
      'Date de soumission': formatDate(verification.created_at),
      'Dernière mise à jour': formatDate(verification.updated_at)
    }));
    
    // Convertir en CSV
    const headers = Object.keys(exportData[0]).join(',');
    const rows = exportData.map(row => Object.values(row).map(value => `"${value}"`).join(','));
    const csv = [headers, ...rows].join('\n');
    
    // Créer un blob et télécharger
    const blob = new Blob([csv], { type: 'text/csv;charset=utf-8;' });
    const url = URL.createObjectURL(blob);
    const link = document.createElement('a');
    link.setAttribute('href', url);
    link.setAttribute('download', `verifications_${new Date().toISOString().split('T')[0]}.csv`);
    link.style.visibility = 'hidden';
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    
    showNotification('success', 'Export réussi', 'Les données ont été exportées avec succès');
    
  } catch (error) {
    console.error('Erreur lors de l\'export:', error);
    showNotification('error', 'Erreur', 'Impossible d\'exporter les données');
  }
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