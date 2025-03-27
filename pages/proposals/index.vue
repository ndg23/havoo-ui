<template>
  <div class="max-w-3xl mx-auto">
    <!-- Header with sticky nav -->
    <div class="sticky top-0 z-30 bg-white dark:bg-gray-900 backdrop-blur bg-opacity-80 dark:bg-opacity-80 border-b border-gray-200 dark:border-gray-800">
      <div class="px-4 py-3 flex justify-between items-center">
        <h1 class="text-xl font-bold">Mes propositions</h1>
        
        <!-- Filter tabs -->
        <div class="flex rounded-full bg-gray-100 dark:bg-gray-800 p-0.5">
          <button 
            v-for="tab in tabs" 
            :key="tab.value"
            @click="activeTab = tab.value"
            class="px-3 py-1.5 text-sm font-medium rounded-full transition-colors"
            :class="activeTab === tab.value ? 'bg-white dark:bg-gray-700 shadow-sm' : 'text-gray-500 dark:text-gray-400 hover:text-gray-700 dark:hover:text-gray-300'"
          >
            {{ tab.label }}
            <span 
              v-if="getFilteredProposals(tab.value).length > 0"
              class="ml-1 text-xs rounded-full bg-gray-200 dark:bg-gray-600 px-1.5 py-0.5"
            >
              {{ getFilteredProposals(tab.value).length }}
            </span>
          </button>
        </div>
      </div>
      
      <!-- Search bar -->
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
            placeholder="Rechercher une proposition..." 
            class="block w-full bg-gray-100 dark:bg-gray-800 border-none rounded-full pl-10 pr-4 py-2 text-gray-900 dark:text-gray-100 focus:ring-2 focus:ring-primary-500"
          />
        </div>
      </div>
    </div>

    <!-- Loading state -->
    <div v-if="isLoading" class="flex justify-center items-center py-12">
      <div class="animate-spin rounded-full h-10 w-10 border-b-2 border-primary-600"></div>
    </div>

    <!-- Error state -->
    <div v-else-if="error" class="bg-red-50 dark:bg-red-900/20 p-4 rounded-lg text-red-700 dark:text-red-400 mx-4 my-6">
      <div class="flex">
        <svg class="h-5 w-5 text-red-400 mr-3" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
        </svg>
        <p>{{ error }}</p>
      </div>
      <button 
        @click="fetchProposals" 
        class="mt-3 text-sm font-medium text-red-600 dark:text-red-400 hover:text-red-500"
      >
        Réessayer
      </button>
    </div>

    <!-- Not an expert warning -->
    <div v-else-if="!isExpert" class="text-center py-12 mx-4">
      <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M18.364 18.364A9 9 0 005.636 5.636m12.728 12.728A9 9 0 015.636 5.636m12.728 12.728L5.636 5.636" />
      </svg>
      <h3 class="mt-2 text-lg font-medium text-gray-900 dark:text-white">Accès non autorisé</h3>
      <p class="mt-1 text-gray-500 dark:text-gray-400">Vous devez être un expert pour faire des propositions.</p>
    </div>

    <!-- Empty state -->
    <div v-else-if="filteredProposals.length === 0" class="text-center py-12 mx-4">
      <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10" />
      </svg>
      <h3 class="mt-2 text-lg font-medium text-gray-900 dark:text-white">Aucune proposition</h3>
      <p class="mt-1 text-gray-500 dark:text-gray-400">
        Vous n'avez pas encore fait de propositions.
      </p>
      <div class="mt-6">
        <NuxtLink 
          to="/requests" 
          class="inline-flex items-center px-4 py-2 border border-transparent rounded-full shadow-sm text-sm font-medium text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 transition-colors"
        >
          <svg class="mr-2 -ml-1 h-4 w-4" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
          </svg>
          Explorer les demandes
        </NuxtLink>
      </div>
    </div>
    
    <!-- No results for search -->
    <div v-else-if="getFilteredProposals(activeTab).length === 0" class="text-center py-12 mx-4">
      <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
      </svg>
      <h3 class="mt-2 text-lg font-medium text-gray-900 dark:text-white">Aucun résultat</h3>
      <p class="mt-1 text-gray-500 dark:text-gray-400">
        Aucune proposition {{ getTabLabel(activeTab).toLowerCase() }} ne correspond à votre recherche.
      </p>
    </div>

    <!-- Proposals list -->
    <div v-else class="divide-y divide-gray-200 dark:divide-gray-800 mx-4">
      <div 
        v-for="proposal in getFilteredProposals(activeTab)"
        :key="proposal.id"
        class="py-4 animate-fade-in"
      >
        <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-100 dark:border-gray-700 overflow-hidden shadow-sm hover:shadow-md transition-shadow">
          <div class="p-4">
            <!-- Request info -->
            <div class="flex items-start justify-between mb-3">
              <div>
                <h3 class="font-medium text-gray-900 dark:text-white">
                  {{ proposal.mission?.title || 'Demande sans titre' }}
                </h3>
                <div class="flex flex-wrap items-center gap-2 mt-1">
                  <span 
                    class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium"
                    :class="getStatusClass(proposal.status)"
                  >
                    {{ getStatusLabel(proposal.status) }}
                  </span>
                  <span 
                    v-if="proposal.mission?.category"
                    class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gray-100 dark:bg-gray-700 text-gray-800 dark:text-gray-200"
                  >
                    {{ proposal.mission.category.name }}
                  </span>
                </div>
              </div>
              <div class="text-right">
                <div class="text-lg font-bold text-primary-600 dark:text-primary-400">
                  {{ formatPrice(proposal.price) }}
                </div>
                <div class="text-sm text-gray-500 dark:text-gray-400">
                  {{ proposal.duration }} jour{{ proposal.duration > 1 ? 's' : '' }}
                </div>
              </div>
            </div>
            
            <!-- Proposal message -->
            <p class="mt-2 text-sm text-gray-600 dark:text-gray-300 line-clamp-2">{{ proposal.message }}</p>
            
            <!-- Client info and actions -->
            <div class="mt-4 flex items-center justify-between">
              <div class="flex items-center">
                <div class="flex-shrink-0">
                  <img 
                    v-if="proposal.mission?.client?.avatar_url" 
                    :src="proposal.mission.client.avatar_url" 
                    alt="Client" 
                    class="h-8 w-8 rounded-full"
                  />
                  <div 
                    v-else 
                    class="h-8 w-8 rounded-full bg-gray-200 dark:bg-gray-700 flex items-center justify-center text-gray-600 dark:text-gray-300 text-sm font-medium"
                  >
                    {{ getInitials(proposal.mission?.client?.first_name, proposal.mission?.client?.last_name) }}
                  </div>
                </div>
                <div class="ml-2">
                  <p class="text-xs font-medium text-gray-900 dark:text-white">
                    {{ proposal.mission?.client?.first_name }} {{ proposal.mission?.client?.last_name }}
                  </p>
                  <p class="text-xs text-gray-500 dark:text-gray-400">
                    {{ formatRelativeDate(proposal.created_at) }}
                  </p>
                </div>
              </div>
              
              <NuxtLink 
                :to="`/requests/${proposal.mission_id}`"
                class="inline-flex items-center text-xs font-medium text-primary-600 dark:text-primary-400 hover:text-primary-700 dark:hover:text-primary-300 transition-colors"
              >
                Voir la demande
                <svg class="ml-1 w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14 5l7 7m0 0l-7 7m7-7H3" />
                </svg>
              </NuxtLink>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue';
import { useSupabaseClient } from '#imports';

const supabase = useSupabaseClient();
const user = useSupabaseUser();

// State
const isLoading = ref(true);
const error = ref(null);
const proposals = ref([]);
const activeTab = ref('all');
const searchQuery = ref('');

// Constants and computed properties
const tabs = [
  { label: 'Toutes', value: 'all' },
  { label: 'En attente', value: 'pending' },
  { label: 'Acceptées', value: 'accepted' },
  { label: 'Refusées', value: 'rejected' }
];

const isExpert = computed(() => {
  return user.value?.is_expert === true;
});

const filteredProposals = computed(() => {
  if (!searchQuery.value) return proposals.value;
  
  const search = searchQuery.value.toLowerCase();
  return proposals.value.filter(proposal => {
    return (
      (proposal.mission?.title && proposal.mission.title.toLowerCase().includes(search)) ||
      (proposal.message && proposal.message.toLowerCase().includes(search)) ||
      (proposal.mission?.category?.name && proposal.mission.category.name.toLowerCase().includes(search)) ||
      (proposal.mission?.client?.first_name && proposal.mission.client.first_name.toLowerCase().includes(search)) ||
      (proposal.mission?.client?.last_name && proposal.mission.client.last_name.toLowerCase().includes(search))
    );
  });
});

// Methods
const fetchProposals = async () => {
  isLoading.value = true;
  error.value = null;
  
  try {
    const { data, error: proposalError } = await supabase
      .from('deals')
      .select(`
        *,
        mission:mission_id (
          *,
          client:client_id (*),
          category:profession_id (*)
        )
      `)
      .eq('expert_id', user.value?.id)
      .order('created_at', { ascending: false });
    
    if (proposalError) throw proposalError;
    
    proposals.value = data || [];
  } catch (err) {
    console.error('Error fetching proposals:', err);
    error.value = "Une erreur est survenue lors du chargement de vos propositions";
  } finally {
    isLoading.value = false;
  }
};

// Filter proposals according to active tab
const getFilteredProposals = (tab) => {
  let filtered = filteredProposals.value;
  if (tab !== 'all') {
    filtered = filtered.filter(proposal => proposal.status === tab);
  }
  return filtered;
};

const getTabLabel = (tab) => {
  const found = tabs.find(t => t.value === tab);
  return found ? found.label : '';
};

const getStatusClass = (status) => {
  const classes = {
    'pending': 'bg-yellow-100 dark:bg-yellow-900/30 text-yellow-800 dark:text-yellow-200',
    'accepted': 'bg-green-100 dark:bg-green-900/30 text-green-800 dark:text-green-200',
    'rejected': 'bg-red-100 dark:bg-red-900/30 text-red-800 dark:text-red-200',
    'completed': 'bg-blue-100 dark:bg-blue-900/30 text-blue-800 dark:text-blue-200'
  };
  return classes[status] || 'bg-gray-100 dark:bg-gray-700 text-gray-800 dark:text-gray-200';
};

const getStatusLabel = (status) => {
  const labels = {
    'pending': 'En attente',
    'accepted': 'Acceptée',
    'rejected': 'Refusée',
    'completed': 'Terminée'
  };
  return labels[status] || 'Inconnu';
};

const formatPrice = (price) => {
  if (!price) return 'Prix non défini';
  return new Intl.NumberFormat('fr-FR', {
    style: 'currency',
    currency: 'XOF',
    maximumFractionDigits: 0
  }).format(price);
};

const formatRelativeDate = (dateString) => {
  if (!dateString) return '';
  
  const date = new Date(dateString);
  const now = new Date();
  const diffTime = Math.abs(now - date);
  const diffDays = Math.floor(diffTime / (1000 * 60 * 60 * 24));
  const diffHours = Math.floor(diffTime / (1000 * 60 * 60));
  const diffMinutes = Math.floor(diffTime / (1000 * 60));
  
  if (diffMinutes < 60) {
    return `il y a ${diffMinutes} minute${diffMinutes > 1 ? 's' : ''}`;
  } else if (diffHours < 24) {
    return `il y a ${diffHours} heure${diffHours > 1 ? 's' : ''}`;
  } else if (diffDays < 30) {
    return `il y a ${diffDays} jour${diffDays > 1 ? 's' : ''}`;
  } else {
    return new Intl.DateTimeFormat('fr-FR', {
      day: 'numeric',
      month: 'short',
      year: 'numeric'
    }).format(date);
  }
};

const getInitials = (firstName, lastName) => {
  if (!firstName && !lastName) return '??';
  return `${firstName ? firstName.charAt(0) : ''}${lastName ? lastName.charAt(0) : ''}`.toUpperCase();
};

// Initialize
onMounted(async () => {
  if (user.value) {
    await fetchProposals();
  } else {
    isLoading.value = false;
  }
});

// Watch for search query changes
watch(searchQuery, () => {
  // No need to refetch, we'll just filter the existing data
});

definePageMeta({
  middleware: ['auth'],
  layout: 'account'
});
</script>

<style scoped>
.line-clamp-2 {
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

/* Animation for card appearing */
.animate-fade-in {
  animation: fadeIn 0.3s ease-out;
}

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

/* Smooth transition effects */
button, a, .transition-colors, .transition-shadow {
  transition: all 0.2s ease;
}
</style> 