<template>
  <div class="w-full">
    <!-- En-tête avec nav collante style Twitter -->
    <div class="sticky top-14 z-20 bg-white/90 dark:bg-gray-900/90 backdrop-blur-sm border-b border-gray-200 dark:border-gray-700">
      <div class="max-w-3xl mx-auto">
        <!-- Titre et filtres -->
        <div class="px-4 py-3 flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3">
          <h1 class="text-xl font-bold text-gray-900 dark:text-white">Mes contrats</h1>
          
          <!-- Onglets de filtrage style Twitter -->
          <div class="inline-flex p-0.5 rounded-full bg-gray-100 dark:bg-gray-800 shadow-inner">
            <button 
              v-for="tab in tabs" 
              :key="tab.value"
              @click="activeTab = tab.value"
              class="relative px-3 py-1.5 text-sm font-medium rounded-full transition-colors"
              :class="[
                activeTab === tab.value 
                  ? 'bg-white dark:bg-gray-700 text-gray-900 dark:text-white shadow-sm' 
                  : 'text-gray-600 dark:text-gray-400 hover:text-gray-900 dark:hover:text-gray-300'
              ]"
            >
              {{ tab.label }}
              <span 
                v-if="getFilteredContracts(tab.value).length > 0"
                class="absolute -top-1 -right-1 flex items-center justify-center min-w-[18px] h-[18px] text-[10px] font-bold rounded-full bg-primary-500 text-white"
              >
                {{ getFilteredContracts(tab.value).length }}
              </span>
            </button>
          </div>
        </div>
        
        <!-- Barre de recherche style Twitter -->
        <div class="px-4 pb-3">
          <div class="relative">
            <div class="absolute inset-y-0 left-3 flex items-center pointer-events-none">
              <svg class="h-5 w-5 text-gray-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                <path fill-rule="evenodd" d="M8 4a4 4 0 100 8 4 4 0 000-8zM2 8a6 6 0 1110.89 3.476l4.817 4.817a1 1 0 01-1.414 1.414l-4.816-4.816A6 6 0 012 8z" clip-rule="evenodd" />
              </svg>
            </div>
            <input 
              v-model="searchQuery" 
              type="text" 
              placeholder="Rechercher un contrat..." 
              class="block w-full bg-gray-100 dark:bg-gray-800 border-none rounded-full pl-10 pr-4 py-2 text-gray-900 dark:text-gray-100 focus:ring-2 focus:ring-primary-500 transition-all"
            />
          </div>
        </div>
      </div>
    </div>

    <div class="max-w-3xl mx-auto">
      <!-- État de chargement avec animation fluide -->
      <div v-if="isLoading" class="flex justify-center items-center py-12">
        <div class="animate-spin rounded-full h-10 w-10 border-b-2 border-primary-600"></div>
      </div>

      <!-- État d'erreur avec design Twitter -->
      <div v-else-if="error" class="mx-4 my-6 bg-red-50 dark:bg-red-900/20 p-5 rounded-2xl border border-red-100 dark:border-red-800/30">
        <div class="flex items-start">
          <div class="flex-shrink-0">
            <svg class="h-5 w-5 text-red-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
          </div>
          <div class="ml-3 flex-1">
            <h3 class="text-sm font-medium text-red-800 dark:text-red-300">Une erreur est survenue</h3>
            <p class="mt-1 text-sm text-red-700 dark:text-red-400">{{ error }}</p>
            <div class="mt-3">
              <button 
                @click="fetchContracts" 
                class="inline-flex items-center px-3 py-1.5 border border-transparent text-xs font-medium rounded-full shadow-sm text-white bg-red-600 hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500 transition-colors"
              >
                Réessayer
              </button>
            </div>
          </div>
        </div>
      </div>

      <!-- État vide avec illustration et design Twitter -->
      <div v-else-if="contracts.length === 0" class="text-center py-12 mx-4">
        <div class="mx-auto w-24 h-24 bg-gray-100 dark:bg-gray-800 rounded-full flex items-center justify-center">
          <svg class="h-12 w-12 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
          </svg>
        </div>
        <h3 class="mt-4 text-lg font-medium text-gray-900 dark:text-white">Aucun contrat</h3>
        <p class="mt-2 text-gray-500 dark:text-gray-400 max-w-md mx-auto">
          Vous n'avez pas encore de contrats actifs. Explorez les demandes pour commencer votre premier projet.
        </p>
        <div class="mt-6">
          <NuxtLink 
            to="/requests" 
            class="inline-flex items-center px-4 py-2 border border-transparent rounded-full shadow-sm text-sm font-medium text-white bg-primary-600 hover:bg-primary-700 focus:outline-none transition-colors"
          >
            <svg class="mr-2 -ml-1 h-4 w-4" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
            </svg>
            Explorer les demandes
          </NuxtLink>
        </div>
      </div>
      
      <!-- Aucun résultat pour la recherche/le filtre -->
      <div v-else-if="getFilteredContracts(activeTab).length === 0" class="text-center py-12 mx-4">
        <div class="mx-auto w-24 h-24 bg-gray-100 dark:bg-gray-800 rounded-full flex items-center justify-center">
          <svg class="h-12 w-12 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
          </svg>
        </div>
        <h3 class="mt-4 text-lg font-medium text-gray-900 dark:text-white">Aucun résultat</h3>
        <p class="mt-2 text-gray-500 dark:text-gray-400 max-w-md mx-auto">
          Aucun contrat {{ getTabLabel(activeTab).toLowerCase() }} ne correspond à votre recherche.
        </p>
      </div>

      <!-- Liste des contrats avec design Twitter -->
      <div v-else class="divide-y divide-gray-200 dark:divide-gray-700 mx-4 my-6">
        <div 
          v-for="(contract, index) in getFilteredContracts(activeTab)" 
          :key="contract.contract_id"
          class="py-4 animate-fadeIn"
          :style="{ animationDelay: `${index * 0.05}s` }"
        >
          <ContractCard 
            :contract="contract"
            :is-client="isClient(contract)"
            :current-user-id="userId"
            @complete="completeContract"
            @contact="contactUser"
            class="hover:-translate-y-1 transition-transform duration-200"
          />
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue';
import { useSupabaseClient, useSupabaseUser, useRouter } from '#imports';
import ContractCard from '~/components/ContractCard.vue';

const supabase = useSupabaseClient();
const user = useSupabaseUser();
const router = useRouter();

// État
const contracts = ref([]);
const isLoading = ref(true);
const error = ref(null);
const activeTab = ref('all');
const searchQuery = ref('');
const userId = computed(() => user.value?.id);

// Tabs
const tabs = [
  { label: 'Tous', value: 'all' },
  { label: 'En cours', value: 'active' },
  { label: 'Terminés', value: 'completed' },
  { label: 'Annulés', value: 'cancelled' }
];

// Filtrer les contrats selon la recherche
const filteredContracts = computed(() => {
  if (!searchQuery.value) return contracts.value;
  
  const search = searchQuery.value.toLowerCase();
  return contracts.value.filter(contract => {
    return (
      (contract.job_title && contract.job_title.toLowerCase().includes(search)) ||
      (contract.client_name && contract.client_name.toLowerCase().includes(search)) ||
      (contract.worker_name && contract.worker_name.toLowerCase().includes(search))
    );
  });
});

// Obtenir les contrats filtrés par statut et recherche
const getFilteredContracts = (tabValue) => {
  let filtered = filteredContracts.value;
  
  if (tabValue !== 'all') {
    filtered = filtered.filter(contract => contract.status === tabValue);
  }
  
  return filtered;
};

// Obtenir le libellé de l'onglet actif
const getTabLabel = (tabValue) => {
  const tab = tabs.find(t => t.value === tabValue);
  return tab ? tab.label : '';
};

// Déterminer si l'utilisateur est le client du contrat
const isClient = (contract) => {
  return contract.client_id === userId.value;
};

// Récupérer les contrats de l'utilisateur
const fetchContracts = async () => {
  if (!user.value) return;
  
  isLoading.value = true;
  error.value = null;
  
  try {
    // Récupérer les contrats directement depuis la table deals (statut active ou completed)
    const { data: dealsData, error: contractError } = await supabase
      .from('deals')
      .select(`
        *,
        client:client_id (first_name, last_name),
        expert:expert_id (first_name, last_name),
        request:request_id (title, description)
      `)
      .or(`client_id.eq.${user.value.id},expert_id.eq.${user.value.id}`)
      .in('status', ['active', 'completed'])
      .order('created_at', { ascending: false });
    
    if (contractError) throw contractError;
    
    // Transformer les données pour correspondre au format attendu par ContractCard
    contracts.value = dealsData?.map(deal => ({
      contract_id: deal.id,
      deal_id: deal.id,
      request_id: deal.request_id,
      client_id: deal.client_id,
      worker_id: deal.expert_id,
      status: deal.status,
      agreed_price: deal.price,
      start_date: deal.created_at,
      end_date: new Date(new Date(deal.created_at).getTime() + deal.duration * 24 * 60 * 60 * 1000),
      completed_at: deal.status === 'completed' ? deal.updated_at : null,
      created_at: deal.created_at,
      client_name: `${deal.client.first_name || ''} ${deal.client.last_name || ''}`.trim(),
      worker_name: `${deal.expert.first_name || ''} ${deal.expert.last_name || ''}`.trim(),
      job_title: deal.request?.title || 'Contrat',
      description: deal.request?.description || '',
      rating_status: getRatingStatus(deal),
      // Informations d'évaluation
      client_rating: deal.client_rating,
      expert_rating: deal.expert_rating,
      client_has_rated: deal.client_has_rated || false,
      expert_has_rated: deal.expert_has_rated || false,
      ratings_complete: deal.ratings_complete || false
    })) || [];
  } catch (err) {
    console.error('Error fetching contracts:', err);
    error.value = 'Impossible de récupérer la liste des contrats. Veuillez réessayer.';
  } finally {
    isLoading.value = false;
  }
};

// Déterminer le statut d'évaluation
const getRatingStatus = (deal) => {
  if (deal.status !== 'completed') {
    return 'Contrat en cours';
  }
  
  if (deal.ratings_complete) {
    return 'Notations complétées';
  }
  
  // Déterminer si l'utilisateur actuel est le client
  const isClientUser = deal.client_id === user.value.id;
  
  if (isClientUser) {
    if (!deal.client_has_rated) {
      return 'En attente de votre évaluation';
    } else if (!deal.expert_has_rated) {
      return 'En attente de l\'évaluation de l\'expert';
    }
  } else {
    if (!deal.expert_has_rated) {
      return 'En attente de votre évaluation';
    } else if (!deal.client_has_rated) {
      return 'En attente de l\'évaluation du client';
    }
  }
  
  return 'Notations en cours';
};

// Marquer un contrat comme terminé
const completeContract = (contractId) => {
  // Rediriger vers la page de finalisation
  router.push(`/account/contracts/${contractId}/complete`);
};

// Contacter l'autre partie
const contactUser = (userId) => {
  // Rediriger vers la messagerie
  router.push(`/messages/${userId}`);
};

// Initialisation
onMounted(async () => {
  if (user.value) {
    await fetchContracts();
  } else {
    isLoading.value = false;
  }
});

// Surveiller les changements de recherche
watch(searchQuery, () => {
  // Pas besoin de recharger, on filtre juste les données existantes
});

definePageMeta({
  middleware: ['auth'],
  layout: 'account'
});
</script>

<style scoped>
/* Animation pour l'apparition des cartes */
@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.animate-fadeIn {
  animation-name: fadeIn;
  animation-duration: 0.3s;
  animation-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
  animation-fill-mode: both;
}
</style> 