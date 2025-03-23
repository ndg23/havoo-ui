<template>
  <div class="space-y-6 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
    <!-- En-tête avec style moderne -->
    <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
      <div>
        <h1 class="text-3xl font-bold text-gray-900 dark:text-white tracking-tight">Propositions</h1>
        <p class="text-gray-600 dark:text-gray-400 mt-1">Gérez les propositions des experts</p>
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
            placeholder="Rechercher une proposition..."
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
            <option value="accepted">Acceptées</option>
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
    <div v-else-if="filteredProposals && filteredProposals.length === 0" class="bg-white dark:bg-gray-800 rounded-2xl p-12 text-center border border-gray-100 dark:border-gray-700 shadow-sm">
      <div class="inline-flex items-center justify-center h-20 w-20 rounded-full bg-gray-100 dark:bg-gray-700 mb-6">
        <FileText class="h-10 w-10 text-gray-500 dark:text-gray-400" />
      </div>
      <h3 class="text-xl font-bold text-gray-900 dark:text-white mb-2">Aucune proposition trouvée</h3>
      <p class="text-gray-600 dark:text-gray-400 mb-6 max-w-md mx-auto">
        Essayez de modifier vos filtres ou d'attendre que des experts soumettent des propositions.
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
    
    <!-- Tableau des propositions avec UTable -->
    <div v-else>
      <UTable
        :columns="columns"
        :rows="paginatedProposals"
        :loading="isLoading"
        class="bg-white dark:bg-gray-800 rounded-2xl border border-gray-100 dark:border-gray-700 overflow-hidden shadow-sm"
      >
        <!-- Colonne Proposition -->
        <template #proposal-data="{ row }">
          <div class="flex items-center gap-3">
            <div 
              class="h-12 w-12 rounded-xl flex items-center justify-center"
              :class="getStatusColorClass(row.status)"
            >
              <component :is="getStatusIcon(row.status)" class="h-6 w-6 text-white" />
            </div>
            <div>
              <p class="text-sm font-medium text-gray-900 dark:text-white">{{ row.request?.title || 'Demande inconnue' }}</p>
              <p class="text-xs text-gray-500 dark:text-gray-400">{{ row.description || 'Aucune description' }}</p>
            </div>
          </div>
        </template>
        
        <!-- Colonne Expert -->
        <template #expert-data="{ row }">
          <div class="flex items-center gap-3">
            <div class="h-8 w-8 rounded-full bg-gray-200 dark:bg-gray-700 flex items-center justify-center overflow-hidden">
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
        
        <!-- Colonne Client -->
        <template #client-data="{ row }">
          <div class="flex items-center gap-3">
            <div class="h-8 w-8 rounded-full bg-gray-200 dark:bg-gray-700 flex items-center justify-center overflow-hidden">
              <img v-if="row.request?.client?.avatar_url" :src="row.request.client.avatar_url" alt="Avatar" class="h-full w-full object-cover" />
              <User v-else class="h-4 w-4 text-gray-500 dark:text-gray-400" />
            </div>
            <div>
              <p class="text-sm font-medium text-gray-900 dark:text-white">
                {{ row.request?.client ? `${row.request.client.first_name} ${row.request.client.last_name}` : 'Client inconnu' }}
              </p>
              <p class="text-xs text-gray-500 dark:text-gray-400">{{ row.request?.client?.email || '-' }}</p>
            </div>
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
            :class="getStatusClass(row.status)"
          >
            <span class="w-2 h-2 rounded-full mr-2" :class="getStatusDotClass(row.status)"></span>
            {{ formatStatus(row.status) }}
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
              @click="viewProposal(row)"
              class="p-2 text-gray-500 dark:text-gray-400 hover:text-primary-600 dark:hover:text-primary-400 hover:bg-primary-50 dark:hover:bg-primary-900/20 rounded-lg transition-colors"
              title="Voir les détails"
            >
              <Eye class="h-5 w-5" />
            </button>
            <button 
              v-if="row.status === 'pending'"
              @click="approveProposal(row)"
              class="p-2 text-gray-500 dark:text-gray-400 hover:text-green-600 dark:hover:text-green-400 hover:bg-green-50 dark:hover:bg-green-900/20 rounded-lg transition-colors"
              title="Approuver"
            >
              <CheckCircle class="h-5 w-5" />
            </button>
            <button 
              v-if="row.status === 'pending'"
              @click="rejectProposal(row)"
              class="p-2 text-gray-500 dark:text-gray-400 hover:text-red-600 dark:hover:text-red-400 hover:bg-red-50 dark:hover:bg-red-900/20 rounded-lg transition-colors"
              title="Rejeter"
            >
              <X class="h-5 w-5" />
            </button>
          </div>
        </template>
      </UTable>
      
      <!-- Pagination -->
      <div class="flex justify-between items-center mt-6">
        <div class="text-sm text-gray-600 dark:text-gray-400">
          Affichage de {{ paginatedProposals.length }} sur {{ filteredProposals.length }} propositions
        </div>
        <div class="flex items-center gap-2">
          <button 
            @click="currentPage--"
            :disabled="currentPage === 1"
            class="p-2 rounded-lg border border-gray-200 dark:border-gray-700 text-gray-600 dark:text-gray-400 disabled:opacity-50"
          >
            <ChevronLeft class="h-5 w-5" />
          </button>
          <span class="text-sm text-gray-600 dark:text-gray-400">
            Page {{ currentPage }} sur {{ totalPages }}
          </span>
          <button 
            @click="currentPage++"
            :disabled="currentPage === totalPages || totalPages === 0"
            class="p-2 rounded-lg border border-gray-200 dark:border-gray-700 text-gray-600 dark:text-gray-400 disabled:opacity-50"
          >
            <ChevronRight class="h-5 w-5" />
          </button>
        </div>
      </div>
    </div>
    
    <!-- Modal de confirmation pour approuver une proposition -->
    <UModal v-model="showApproveModal">
      <div class="p-6 space-y-6">
        <h3 class="text-xl font-bold text-gray-900 dark:text-white">Approuver la proposition</h3>
        <p class="text-gray-600 dark:text-gray-400">
          Êtes-vous sûr de vouloir approuver cette proposition ? Cette action attribuera la demande à l'expert et notifiera le client.
        </p>
        <div class="flex justify-end gap-3">
          <button 
            @click="showApproveModal = false"
            class="px-4 py-2 bg-gray-100 hover:bg-gray-200 dark:bg-gray-700 dark:hover:bg-gray-600 text-gray-700 dark:text-gray-300 font-medium rounded-xl transition-colors"
          >
            Annuler
          </button>
          <button 
            @click="confirmApproveProposal"
            class="px-4 py-2 bg-green-600 hover:bg-green-700 text-white font-medium rounded-xl shadow-sm transition-colors"
            :disabled="isProcessing"
          >
            <div v-if="isProcessing" class="flex items-center gap-2">
              <div class="h-4 w-4 border-2 border-white border-t-transparent rounded-full animate-spin"></div>
              <span>Traitement...</span>
            </div>
            <span v-else>Confirmer</span>
          </button>
        </div>
      </div>
    </UModal>
    
    <!-- Modal de confirmation pour rejeter une proposition -->
    <UModal v-model="showRejectModal">
      <div class="p-6 space-y-6">
        <h3 class="text-xl font-bold text-gray-900 dark:text-white">Rejeter la proposition</h3>
        <p class="text-gray-600 dark:text-gray-400">
          Êtes-vous sûr de vouloir rejeter cette proposition ? L'expert sera notifié du rejet.
        </p>
        <div class="flex justify-end gap-3">
          <button 
            @click="showRejectModal = false"
            class="px-4 py-2 bg-gray-100 hover:bg-gray-200 dark:bg-gray-700 dark:hover:bg-gray-600 text-gray-700 dark:text-gray-300 font-medium rounded-xl transition-colors"
          >
            Annuler
          </button>
          <button 
            @click="confirmRejectProposal"
            class="px-4 py-2 bg-red-600 hover:bg-red-700 text-white font-medium rounded-xl shadow-sm transition-colors"
            :disabled="isProcessing"
          >
            <div v-if="isProcessing" class="flex items-center gap-2">
              <div class="h-4 w-4 border-2 border-white border-t-transparent rounded-full animate-spin"></div>
              <span>Traitement...</span>
            </div>
            <span v-else>Confirmer</span>
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
  Download, Search, RefreshCw, X, CheckCircle, AlertTriangle, 
  Info, FileText, ChevronLeft, ChevronRight, Eye, User,
  Clock, ThumbsUp, ThumbsDown, XCircle
} from 'lucide-vue-next';
import { useSupabaseClient } from '#imports';

const supabase = useSupabaseClient();
const router = useRouter();

// État des données
const proposals = ref([]);
const isLoading = ref(true);
const search = ref('');
const statusFilter = ref('all');
const currentPage = ref(1);
const itemsPerPage = ref(10);
const showApproveModal = ref(false);
const showRejectModal = ref(false);
const selectedProposal = ref(null);
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
    label: 'Total propositions',
    value: 0,
    icon: FileText,
    colorClass: 'bg-primary-500'
  },
  {
    label: 'En attente',
    value: 0,
    icon: Clock,
    colorClass: 'bg-blue-500'
  },
  {
    label: 'Acceptées',
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
    key: 'proposal',
    label: 'Proposition',
    sortable: true
  },
  {
    key: 'expert',
    label: 'Expert',
    sortable: true
  },
  {
    key: 'client',
    label: 'Client',
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
const filteredProposals = computed(() => {
  if (!proposals.value) return [];
  
  let result = [...proposals.value];
  
  // Filtre de recherche
  if (search.value) {
    const searchLower = search.value.toLowerCase();
    result = result.filter(proposal => 
      (proposal.description && proposal.description.toLowerCase().includes(searchLower)) ||
      (proposal.request?.title && proposal.request.title.toLowerCase().includes(searchLower)) ||
      (proposal.expert?.first_name && proposal.expert.first_name.toLowerCase().includes(searchLower)) ||
      (proposal.expert?.last_name && proposal.expert.last_name.toLowerCase().includes(searchLower)) ||
      (proposal.request?.client?.first_name && proposal.request.client.first_name.toLowerCase().includes(searchLower)) ||
      (proposal.request?.client?.last_name && proposal.request.client.last_name.toLowerCase().includes(searchLower))
    );
  }
  
  // Filtre de statut
  if (statusFilter.value !== 'all') {
    result = result.filter(proposal => proposal.status === statusFilter.value);
  }
  
  return result;
});

// Pagination
const totalPages = computed(() => {
  return Math.ceil(filteredProposals.value.length / itemsPerPage.value);
});

const paginatedProposals = computed(() => {
  const startIndex = (currentPage.value - 1) * itemsPerPage.value;
  const endIndex = startIndex + itemsPerPage.value;
  return filteredProposals.value.slice(startIndex, endIndex);
});

// Charger les données
const loadData = async () => {
  isLoading.value = true;
  
  try {
    // Charger les propositions
    const { data: proposalsData, error: proposalsError } = await supabase
      .from('proposals')
      .select(`
        *,
        expert:profiles!expert_id(*),
        request:requests!request_id(
          *,
          client:profiles!client_id(*)
        )
      `)
      .order('created_at', { ascending: false });
    
    if (proposalsError) throw proposalsError;
    
    proposals.value = proposalsData || [];
    
    // Mettre à jour les statistiques
    updateStats();
    
  } catch (error) {
    console.error('Erreur lors du chargement des données:', error);
    showNotification('error', 'Erreur', 'Impossible de charger les propositions');
  } finally {
    isLoading.value = false;
  }
};

// Mettre à jour les statistiques
const updateStats = () => {
  if (!proposals.value) return;
  
  stats.value[0].value = proposals.value.length;
  stats.value[1].value = proposals.value.filter(p => p.status === 'pending').length;
  stats.value[2].value = proposals.value.filter(p => p.status === 'accepted').length;
  stats.value[3].value = proposals.value.filter(p => p.status === 'rejected').length;
};

// Réinitialiser les filtres
const resetFilters = () => {
  search.value = '';
  statusFilter.value = 'all';
  currentPage.value = 1;
};

// Voir les détails d'une proposition
const viewProposal = (proposal) => {
  router.push(`/admin/proposals/${proposal.id}`);
};

// Approuver une proposition
const approveProposal = (proposal) => {
  selectedProposal.value = proposal;
  showApproveModal.value = true;
};

// Confirmer l'approbation d'une proposition
const confirmApproveProposal = async () => {
  if (!selectedProposal.value) return;
  
  isProcessing.value = true;
  
  try {
    // 1. Mettre à jour le statut de la proposition
    const { error: proposalError } = await supabase
      .from('proposals')
      .update({ 
        status: 'accepted',
        updated_at: new Date().toISOString()
      })
      .eq('id', selectedProposal.value.id);
    
    if (proposalError) throw proposalError;
    
    // 2. Mettre à jour le statut de la demande et assigner l'expert
    const { error: requestError } = await supabase
      .from('requests')
      .update({ 
        status: 'assigned',
        expert_id: selectedProposal.value.expert_id,
        updated_at: new Date().toISOString()
      })
      .eq('id', selectedProposal.value.request_id);
    
    if (requestError) throw requestError;
    
    // 3. Rejeter toutes les autres propositions pour cette demande
    const { error: rejectError } = await supabase
      .from('proposals')
      .update({ 
        status: 'rejected',
        updated_at: new Date().toISOString()
      })
      .eq('request_id', selectedProposal.value.request_id)
      .neq('id', selectedProposal.value.id);
    
    if (rejectError) throw rejectError;
    
    // 4. Ajouter une entrée dans l'historique de la demande
    const { error: historyError } = await supabase
      .from('request_history')
      .insert({
        request_id: selectedProposal.value.request_id,
        action: 'proposal_accepted',
        details: {
          proposal_id: selectedProposal.value.id,
          expert_id: selectedProposal.value.expert_id,
          price: selectedProposal.value.price
        },
        user_id: (await supabase.auth.getUser()).data.user?.id
      });
    
    if (historyError) throw historyError;
    
    // Fermer la modal et afficher une notification
    showApproveModal.value = false;
    showNotification('success', 'Proposition approuvée', 'La proposition a été approuvée et la demande a été assignée à l\'expert');
    
    // Rafraîchir les données
    await loadData();
    
  } catch (error) {
    console.error('Erreur lors de l\'approbation de la proposition:', error);
    showNotification('error', 'Erreur', 'Impossible d\'approuver la proposition');
  } finally {
    isProcessing.value = false;
  }
};

// Rejeter une proposition
const rejectProposal = (proposal) => {
  selectedProposal.value = proposal;
  showRejectModal.value = true;
};

// Confirmer le rejet d'une proposition
const confirmRejectProposal = async () => {
  if (!selectedProposal.value) return;
  
  isProcessing.value = true;
  
  try {
    // 1. Mettre à jour le statut de la proposition
    const { error: proposalError } = await supabase
      .from('proposals')
      .update({ 
        status: 'rejected',
        updated_at: new Date().toISOString()
      })
      .eq('id', selectedProposal.value.id);
    
    if (proposalError) throw proposalError;
    
    // 2. Ajouter une entrée dans l'historique de la demande
    const { error: historyError } = await supabase
      .from('request_history')
      .insert({
        request_id: selectedProposal.value.request_id,
        action: 'proposal_rejected',
        details: {
          proposal_id: selectedProposal.value.id,
          expert_id: selectedProposal.value.expert_id
        },
        user_id: (await supabase.auth.getUser()).data.user?.id
      });
    
    if (historyError) throw historyError;
    
    // Fermer la modal et afficher une notification
    showRejectModal.value = false;
    showNotification('success', 'Proposition rejetée', 'La proposition a été rejetée avec succès');
    
    // Rafraîchir les données
    await loadData();
    
  } catch (error) {
    console.error('Erreur lors du rejet de la proposition:', error);
    showNotification('error', 'Erreur', 'Impossible de rejeter la proposition');
  } finally {
    isProcessing.value = false;
  }
};

// Formater le statut
const formatStatus = (status) => {
  const statusMap = {
    pending: "En attente",
    accepted: "Acceptée",
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

// Formater le prix
const formatPrice = (price) => {
  if (price === null || price === undefined) return '-';
  return new Intl.NumberFormat('fr-FR', {
    style: 'currency',
    currency: 'XOF',
    minimumFractionDigits: 0
  }).format(price);
};

// Obtenir la classe de style pour le statut
const getStatusClass = (status) => {
  const statusClasses = {
    pending: "bg-blue-50 text-blue-800 dark:bg-blue-900/30 dark:text-blue-400",
    accepted: "bg-green-50 text-green-800 dark:bg-green-900/30 dark:text-green-400",
    rejected: "bg-red-50 text-red-800 dark:bg-red-900/30 dark:text-red-400"
  };
  return statusClasses[status] || "bg-gray-50 text-gray-800 dark:bg-gray-900/30 dark:text-gray-400";
};

// Obtenir la classe de style pour le point de statut
const getStatusDotClass = (status) => {
  const dotClasses = {
    pending: "bg-blue-500",
    accepted: "bg-green-500",
    rejected: "bg-red-500"
  };
  return dotClasses[status] || "bg-gray-500";
};

// Obtenir la classe de couleur pour le statut
const getStatusColorClass = (status) => {
  const colorClasses = {
    pending: "bg-blue-500",
    accepted: "bg-green-500",
    rejected: "bg-red-500"
  };
  return colorClasses[status] || "bg-gray-500";
};

// Obtenir l'icône pour le statut
const getStatusIcon = (status) => {
  const statusIcons = {
    pending: Clock,
    accepted: CheckCircle,
    rejected: XCircle
  };
  return statusIcons[status] || Info;
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
    if (!proposals.value || proposals.value.length === 0) {
      showNotification('info', 'Information', 'Aucune donnée à exporter');
      return;
    }
    
    // Transformer les données pour l'export
    const exportData = proposals.value.map(proposal => ({
      ID: proposal.id,
      Demande: proposal.request?.title || 'Non défini',
      Expert: proposal.expert ? `${proposal.expert.first_name} ${proposal.expert.last_name}` : 'Non défini',
      Client: proposal.request?.client ? `${proposal.request.client.first_name} ${proposal.request.client.last_name}` : 'Non défini',
      Prix: formatPrice(proposal.price),
      Statut: formatStatus(proposal.status),
      Description: proposal.description || 'Aucune description',
      'Date de création': formatDate(proposal.created_at),
      'Dernière mise à jour': formatDate(proposal.updated_at)
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
    link.setAttribute('download', `propositions_${new Date().toISOString().split('T')[0]}.csv`);
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

definePageMeta({
  layout: 'admin'
});
</script>  