<template>
  <div class="min-h-screen bg-white">
    <!-- Header -->
    <header class="sticky top-0 z-10 bg-white/80 backdrop-blur-sm border-b border-gray-100">
      <div class="max-w-4xl- mx-auto px-4 py-3 flex items-center justify-between">
        <h1 class="text-xl font-bold">Mes demandes</h1>
        <NuxtLink 
          to="/requests/new" 
          class="inline-flex items-center px-4 py-2 rounded-full text-sm font-medium text-white bg-black hover:bg-gray-800 transition-colors"
        >
          <svg class="w-4 h-4 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
          </svg>
          Nouvelle demande
        </NuxtLink>
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
        <p class="text-gray-500">Chargement de vos demandes...</p>
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
          @click="fetchRequests" 
          class="mt-3 text-sm font-medium text-red-600 hover:text-red-500"
        >
          Réessayer
        </button>
      </div>

      <!-- Empty state -->
      <div v-else-if="requests.length === 0" class="text-center py-12">
        <svg class="mx-auto h-12 w-12 text-gray-300" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
        </svg>
        <h3 class="mt-2 text-lg font-medium text-gray-900">Aucune demande</h3>
        <p class="mt-1 text-gray-500">Vous n'avez pas encore créé de demande.</p>
        <div class="mt-6">
          <NuxtLink 
            to="/requests/new" 
            class="inline-flex items-center px-4 py-2 rounded-full text-sm font-medium text-white bg-black hover:bg-gray-800 transition-colors"
          >
            <svg class="w-4 h-4 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
            </svg>
            Créer une demande
          </NuxtLink>
        </div>
      </div>

      <!-- Request list -->
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
                v-if="getFilteredRequests(tab.value).length > 0"
                class="ml-1 text-xs rounded-full bg-gray-100 px-2 py-0.5"
              >
                {{ getFilteredRequests(tab.value).length }}
              </span>
            </button>
          </nav>
        </div>

        <!-- Request cards -->
        <div v-if="getFilteredRequests(activeTab).length === 0" class="text-center py-8">
          <p class="text-gray-500">Aucune demande {{ getTabLabel(activeTab).toLowerCase() }}</p>
        </div>
        
        <div v-else class="space-y-4">
          <NuxtLink
            v-for="request in getFilteredRequests(activeTab)"
            :key="request.id"
            :to="`/requests/${request.id}`"
            class="block bg-white border border-gray-200 rounded-lg p-4 hover:shadow-sm transition-shadow"
          >
            <div class="flex justify-between items-start">
              <div>
                <div class="flex items-center space-x-2 mb-1">
                  <span 
                    class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium"
                    :class="getStatusClass(request.status)"
                  >
                    {{ getStatusLabel(request.status) }}
                  </span>
                  <span 
                    v-if="request.category" 
                    class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-800"
                  >
                    {{ request.category.name }}
                  </span>
                </div>
                <h3 class="text-lg font-medium text-gray-900 line-clamp-1">{{ request.title }}</h3>
                <p class="mt-1 text-sm text-gray-500 line-clamp-2">{{ request.description }}</p>
              </div>
              
              <div class="text-right flex-shrink-0">
                <div v-if="request.budget" class="text-base font-bold text-gray-900">
                  {{ formatPrice(request.budget) }}
                </div>
                <div v-if="request.deadline" class="text-xs text-gray-500 mt-1">
                  {{ formatDate(request.deadline) }}
                </div>
              </div>
            </div>
            
            <div class="mt-3 flex items-center justify-between text-sm">
              <div class="text-gray-500">
                {{ formatRelativeDate(request.created_at) }}
              </div>
              <div v-if="getProposalCount(request)" class="flex items-center text-primary-600">
                <svg class="w-4 h-4 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                </svg>
                {{ getProposalCount(request) }} proposition{{ getProposalCount(request) > 1 ? 's' : '' }}
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
const requests = ref([]);
const isLoading = ref(true);
const error = ref(null);
const activeTab = ref('all');

// Tabs
const tabs = [
  { label: 'Toutes', value: 'all' },
  { label: 'Ouvertes', value: 'open' },
  { label: 'En cours', value: 'in_progress' },
  { label: 'Terminées', value: 'completed' }
];

// Récupérer les demandes de l'utilisateur
const fetchRequests = async () => {
  if (!user.value) return;
  
  isLoading.value = true;
  error.value = null;
  
  try {
    const { data, error: requestError } = await supabase
      .from('requests')
      .select(`
        *,
        category:category_id (*),
        proposals(count)
      `)
      .eq('client_id', user.value.id)
      .order('created_at', { ascending: false });
    
    if (requestError) throw requestError;
    
    requests.value = data || [];
  } catch (err) {
    console.error('Error fetching requests:', err);
    error.value = "Une erreur est survenue lors du chargement de vos demandes";
  } finally {
    isLoading.value = false;
  }
};

// Filtrer les demandes selon l'onglet actif
const getFilteredRequests = (tab) => {
  if (tab === 'all') return requests.value;
  return requests.value.filter(request => request.status === tab);
};

// Obtenir le libellé de l'onglet
const getTabLabel = (tabValue) => {
  const tab = tabs.find(t => t.value === tabValue);
  return tab ? tab.label : '';
};

// Obtenir le nombre de propositions
const getProposalCount = (request) => {
  return request.proposals?.[0]?.count || 0;
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
    month: 'long'
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
    case 'open':
      return 'bg-green-100 text-green-800';
    case 'in_progress':
      return 'bg-blue-100 text-blue-800';
    case 'completed':
      return 'bg-purple-100 text-purple-800';
    case 'cancelled':
      return 'bg-red-100 text-red-800';
    default:
      return 'bg-gray-100 text-gray-800';
  }
};

// Obtenir le libellé pour le statut
const getStatusLabel = (status) => {
  switch (status) {
    case 'open':
      return 'Ouverte';
    case 'in_progress':
      return 'En cours';
    case 'completed':
      return 'Terminée';
    case 'cancelled':
      return 'Annulée';
    default:
      return 'Inconnue';
  }
};

// Cycle de vie
onMounted(() => {
  fetchRequests();
});

definePageMeta({
  layout: 'account'
})
</script>

<style scoped>
.line-clamp-1 {
  display: -webkit-box;
  -webkit-line-clamp: 1;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.line-clamp-2 {
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
</style> 