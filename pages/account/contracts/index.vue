<template>
  <div class="min-h-screen bg-white">
    <!-- Header -->
    <header class="sticky top-0 z-10 bg-white/80 backdrop-blur-sm border-b border-gray-100">
      <div class="max-w-2xl mx-auto px-4 py-3 flex items-center justify-between">
        <h1 class="text-xl font-bold">Mes contrats</h1>
      </div>
    </header>

    <!-- Main content -->
    <main class="max-w-2xl- mx-auto px-4 py-6">
      <!-- Loading state -->
      <div v-if="isLoading" class="flex flex-col items-center justify-center py-12">
        <svg class="animate-spin h-8 w-8 text-gray-400 mb-4" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
      </svg>
        <p class="text-gray-500">Chargement de vos contrats...</p>
    </div>

      <!-- Error state -->
      <div v-else-if="error" class="bg-red-50 p-4 rounded-lg text-red-700 my-6">
        <div class="flex">
          <svg class="h-5 w-5 text-red-400 mr-3" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
          </svg>
          <p>{{ error }}</p>
        </div>
        <button 
          @click="fetchContracts" 
          class="mt-3 text-sm font-medium text-red-600 hover:text-red-500"
        >
          Réessayer
        </button>
      </div>

      <!-- Empty state -->
      <div v-else-if="contracts.length === 0" class="text-center py-12">
        <svg class="mx-auto h-12 w-12 text-gray-300" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
        </svg>
        <h3 class="mt-2 text-lg font-medium text-gray-900">Aucun contrat</h3>
        <p class="mt-1 text-gray-500">Vous n'avez pas encore de contrats actifs.</p>
        <div class="mt-6">
      <NuxtLink 
            to="/requests" 
            class="inline-flex items-center px-4 py-2 rounded-full text-sm font-medium text-white bg-black hover:bg-gray-800 transition-colors"
      >
            Explorer les demandes
      </NuxtLink>
    </div>
      </div>

      <!-- Contract list -->
      <div v-else class="space-y-4">
        <!-- Tabs -->
        <div class="border-b border-gray-200">
          <nav class="-mb-px flex space-x-6">
            <button 
              v-for="tab in tabs" 
              :key="tab.value"
              @click="activeTab = tab.value"
              class="py-2 px-1 text-sm font-medium border-b-2 transition-colors"
              :class="activeTab === tab.value 
                ? 'border-black text-black' 
                : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300'"
            >
              {{ tab.label }}
              <span 
                v-if="getFilteredContracts(tab.value).length > 0"
                class="ml-1 text-xs rounded-full bg-gray-100 px-2 py-0.5"
              >
                {{ getFilteredContracts(tab.value).length }}
              </span>
            </button>
          </nav>
        </div>

        <!-- Contract cards -->
        <div v-if="getFilteredContracts(activeTab).length === 0" class="text-center py-8">
          <p class="text-gray-500">Aucun contrat {{ getTabLabel(activeTab).toLowerCase() }}</p>
        </div>
        
        <div v-else class="space-y-4">
          <NuxtLink
            v-for="contract in getFilteredContracts(activeTab)"
        :key="contract.id"
            :to="`/account/contracts/${contract.id}`"
            class="block bg-white border border-gray-200 rounded-lg p-4 hover:shadow-sm transition-shadow"
      >
          <div class="flex justify-between items-start">
            <div>
                <div class="flex items-center space-x-2 mb-1">
                <span 
                    class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium"
                  :class="getStatusClass(contract.status)"
                >
                    {{ getStatusLabel(contract.status) }}
                  </span>
                </div>
                <h3 class="text-lg font-medium text-gray-900 line-clamp-1">{{ contract.title }}</h3>
                <p class="mt-1 text-sm text-gray-500">
                  {{ isUserClient(contract) ? 'Expert: ' : 'Client: ' }}
                  <span class="font-medium">
                    {{ isUserClient(contract) ? getExpertName(contract) : getClientName(contract) }}
                </span>
                </p>
              </div>
              
              <div class="text-right flex-shrink-0">
                <div class="text-base font-bold text-gray-900">
                  {{ formatPrice(contract.price) }}
            </div>
              <div class="text-xs text-gray-500 mt-1">
                  {{ formatDate(contract.created_at) }}
                </div>
            </div>
          </div>
          
            <div class="mt-3 flex items-center justify-between text-sm">
              <div class="text-gray-500">
                {{ formatRelativeDate(contract.created_at) }}
            </div>
              <div class="flex items-center text-primary-600">
                <svg class="w-4 h-4 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z" />
                </svg>
                Voir les détails
            </div>
            </div>
          </NuxtLink>
        </div>
      </div>
    </main>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useSupabaseClient, useSupabaseUser } from '#imports';

const supabase = useSupabaseClient();
const user = useSupabaseUser();

// État
const contracts = ref([]);
const isLoading = ref(true);
const error = ref(null);
const activeTab = ref('all');

// Tabs
const tabs = [
  { label: 'Tous', value: 'all' },
  { label: 'Actifs', value: 'active' },
  { label: 'Terminés', value: 'completed' },
  { label: 'Annulés', value: 'cancelled' }
];

// Récupérer les contrats de l'utilisateur
const fetchContracts = async () => {
  if (!user.value) return;
  
  isLoading.value = true;
  error.value = null;
  
  try {
    const { data, error: contractError } = await supabase
      .from('contracts')
      .select(`
        *,
        client:client_id (id, first_name, last_name),
        expert:expert_id (id, first_name, last_name),
        request:request_id (*)
      `)
      .or(`client_id.eq.${user.value.id},expert_id.eq.${user.value.id}`)
      .order('created_at', { ascending: false });
    
    if (contractError) throw contractError;
    
    contracts.value = data || [];
  } catch (err) {
    console.error('Error fetching contracts:', err);
    error.value = "Une erreur est survenue lors du chargement de vos contrats";
  } finally {
    isLoading.value = false;
  }
};

// Filtrer les contrats selon l'onglet actif
const getFilteredContracts = (tab) => {
  if (tab === 'all') return contracts.value;
  if (tab === 'active') return contracts.value.filter(contract => contract.status === 'active');
  if (tab === 'completed') return contracts.value.filter(contract => contract.status === 'completed');
  if (tab === 'cancelled') return contracts.value.filter(contract => contract.status === 'cancelled');
  return contracts.value;
};

// Obtenir le libellé de l'onglet
const getTabLabel = (tabValue) => {
  const tab = tabs.find(t => t.value === tabValue);
  return tab ? tab.label : '';
};

// Vérifier si l'utilisateur est le client
const isUserClient = (contract) => {
  return user.value?.id === contract.client_id;
};

// Obtenir le nom de l'expert
const getExpertName = (contract) => {
  if (!contract.expert) return 'Expert inconnu';
  return `${contract.expert.first_name} ${contract.expert.last_name || ''}`.trim();
};

// Obtenir le nom du client
const getClientName = (contract) => {
  if (!contract.client) return 'Client inconnu';
  return `${contract.client.first_name} ${contract.client.last_name || ''}`.trim();
};

// Formater le prix
const formatPrice = (price) => {
  return new Intl.NumberFormat('fr-FR', {
    style: 'currency',
    currency: 'EUR'
  }).format(price);
};

// Formater la date
const formatDate = (dateString) => {
  if (!dateString) return '';
  
  const date = new Date(dateString);
  return new Intl.DateTimeFormat('fr-FR', {
    day: 'numeric',
    month: 'long',
    year: 'numeric'
  }).format(date);
};

// Formater la date relative
const formatRelativeDate = (dateString) => {
  if (!dateString) return '';
  
  const date = new Date(dateString);
  const now = new Date();
  const diffTime = Math.abs(now - date);
  const diffDays = Math.floor(diffTime / (1000 * 60 * 60 * 24));
  
  if (diffDays === 0) {
    return "Aujourd'hui";
  } else if (diffDays === 1) {
    return "Hier";
  } else if (diffDays < 7) {
    return `Il y a ${diffDays} jours`;
  } else {
    return formatDate(dateString);
  }
};

// Obtenir la classe CSS pour le statut
const getStatusClass = (status) => {
  switch (status) {
    case 'active':
      return 'bg-blue-100 text-blue-800';
    case 'completed':
      return 'bg-green-100 text-green-800';
    case 'cancelled':
      return 'bg-red-100 text-red-800';
    default:
      return 'bg-gray-100 text-gray-800';
  }
};

// Obtenir le libellé pour le statut
const getStatusLabel = (status) => {
  switch (status) {
    case 'active':
      return 'En cours';
    case 'completed':
      return 'Terminé';
    case 'cancelled':
      return 'Annulé';
    default:
      return 'Statut inconnu';
  }
};

// Initialisation
onMounted(() => {
  fetchContracts()
})

definePageMeta({
  middleware: ['auth'],
  layout: 'account'
})
</script> 