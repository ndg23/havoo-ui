<template>
  <div class="min-h-screen bg-white">
    <!-- Header -->
    <header class="sticky top-0 z-10 bg-white/80 backdrop-blur-sm border-b border-gray-100">
      <div class="max-w-2xl- mx-auto px-4 py-3 flex items-center justify-between">
        <h1 class="text-xl font-bold">Mes propositions</h1>
      </div>
    </header>

    <!-- Main content -->
    <main class="max-w-4xl- mx-auto px-4 py-6">
      <!-- Loading state -->
      <div v-if="isLoading" class="flex flex-col items-center justify-center py-12">
        <svg class="animate-spin h-8 w-8 text-gray-400 mb-4" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
          <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
          <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
        </svg>
        <p class="text-gray-500">Chargement de vos propositions...</p>
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
          @click="fetchProposals" 
          class="mt-3 text-sm font-medium text-red-600 hover:text-red-500"
        >
          Réessayer
        </button>
      </div>

      <!-- Not an expert -->
      <div v-else-if="!isExpert" class="text-center py-12">
        <svg class="mx-auto h-12 w-12 text-gray-300" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
      </svg>
        <h3 class="mt-2 text-lg font-medium text-gray-900">Devenez expert</h3>
        <p class="mt-1 text-gray-500">Vous devez être un expert pour faire des propositions.</p>
        <div class="mt-6">
          <NuxtLink 
            to="/account/" 
            class="inline-flex items-center px-4 py-2 rounded-full text-sm font-medium text-white bg-black hover:bg-gray-800 transition-colors"
          >
            Devenir expert
      </NuxtLink>
        </div>
        </div>
        
      <!-- Empty state -->
      <div v-else-if="proposals.length === 0" class="text-center py-12">
        <svg class="mx-auto h-12 w-12 text-gray-300" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M20 13V6a2 2 0 00-2-2H6a2 2 0 00-2 2v7m16 0v5a2 2 0 01-2 2H6a2 2 0 01-2-2v-5m16 0h-2.586a1 1 0 00-.707.293l-2.414 2.414a1 1 0 01-.707.293h-3.172a1 1 0 01-.707-.293l-2.414-2.414A1 1 0 006.586 13H4" />
        </svg>
        <h3 class="mt-2 text-lg font-medium text-gray-900">Aucune proposition</h3>
        <p class="mt-1 text-gray-500">Vous n'avez pas encore fait de propositions.</p>
        <div class="mt-6">
          <NuxtLink 
            to="/requests" 
            class="inline-flex items-center px-4 py-2 rounded-full text-sm font-medium text-white bg-black hover:bg-gray-800 transition-colors"
          >
            <svg class="w-4 h-4 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
            </svg>
            Explorer les demandes
          </NuxtLink>
        </div>
      </div>

      <!-- Proposal list -->
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
                v-if="getFilteredProposals(tab.value).length > 0"
                class="ml-1 text-xs rounded-full bg-gray-100 px-2 py-0.5"
              >
                {{ getFilteredProposals(tab.value).length }}
              </span>
            </button>
          </nav>
    </div>

        <!-- Proposal cards -->
        <div v-if="getFilteredProposals(activeTab).length === 0" class="text-center py-8">
          <p class="text-gray-500">Aucune proposition {{ getTabLabel(activeTab).toLowerCase() }}</p>
          </div>
          
        <div v-else class="space-y-4">
          <div
            v-for="proposal in getFilteredProposals(activeTab)"
            :key="proposal.id"
            class="bg-white border border-gray-200 rounded-lg overflow-hidden hover:shadow-sm transition-shadow"
          >
            <div class="p-4">
              <div class="flex justify-between items-start">
              <div>
                  <div class="flex items-center space-x-2 mb-1">
                    <span 
                      class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium"
                      :class="getStatusClass(proposal.status)"
                    >
                      {{ getStatusLabel(proposal.status) }}
                    </span>
                    <span 
                      v-if="proposal.request?.category" 
                      class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-800"
                    >
                      {{ proposal.request.category.name }}
                    </span>
                  </div>
                  <h3 class="text-lg font-medium text-gray-900 line-clamp-1">
                    {{ proposal.request?.title || 'Demande sans titre' }}
                  </h3>
                  <p class="mt-1 text-sm text-gray-500 line-clamp-2">{{ proposal.message }}</p>
              </div>
              
                <div class="text-right flex-shrink-0">
                  <div class="text-base font-bold text-gray-900">
                    {{ formatPrice(proposal.price) }}
                  </div>
                  <div class="text-xs text-gray-500 mt-1">
                    {{ proposal.duration }} jour{{ proposal.duration > 1 ? 's' : '' }}
                  </div>
              </div>
              </div>
              
              <div class="mt-4 flex items-center justify-between">
                <NuxtLink 
                  :to="`/requests/${proposal.request_id}`"
                  class="inline-flex items-center px-3 py-1.5 border border-gray-300 rounded-md text-xs font-medium text-gray-700 bg-white hover:bg-gray-50 transition-colors"
                >
                  <svg class="w-3.5 h-3.5 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                    </svg>
                  Voir la demande
                </NuxtLink>
                <div class="text-xs text-gray-500">
                  {{ formatRelativeDate(proposal.created_at) }}
                </div>
              </div>
            </div>
          </div>
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
const proposals = ref([]);
const profile = ref(null);
const isLoading = ref(true);
const error = ref(null);
const activeTab = ref('all');

// Computed
const isExpert = computed(() => {
  return profile.value?.is_expert || false;
});

// Tabs
const tabs = [
  { label: 'Toutes', value: 'all' },
  { label: 'En attente', value: 'pending' },
  { label: 'Acceptées', value: 'accepted' },
  { label: 'Refusées', value: 'rejected' }
];

// Récupérer le profil de l'utilisateur
const fetchProfile = async () => {
  if (!user.value) return;
  
  try {
    const { data, error: profileError } = await supabase
      .from('profiles')
      .select('*')
      .eq('id', user.value.id)
      .single();
    
    if (profileError) throw profileError;
    
    profile.value = data;
  } catch (err) {
    console.error('Error fetching profile:', err);
  }
};

// Récupérer les propositions de l'expert
const fetchProposals = async () => {
  if (!user.value) return;
  
  isLoading.value = true;
  error.value = null;
  
  try {
    const { data, error: proposalError } = await supabase
      .from('deals')
      .select(`
        *,
        request:request_id (
          *,
          category:category_id (*)
        )
      `)
      .eq('expert_id', user.value.id)
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

// Filtrer les propositions selon l'onglet actif
const getFilteredProposals = (tab) => {
  if (tab === 'all') return proposals.value;
  return proposals.value.filter(proposal => proposal.status === tab);
};

// Obtenir le libellé de l'onglet
const getTabLabel = (tabValue) => {
  const tab = tabs.find(t => t.value === tabValue);
  return tab ? tab.label : '';
};

// Formater le prix
const formatPrice = (price) => {
  return new Intl.NumberFormat('fr-FR', {
    style: 'currency',
    currency: 'EUR'
  }).format(price);
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
    const options = { day: 'numeric', month: 'long' };
    return new Intl.DateTimeFormat('fr-FR', options).format(date);
  }
};

// Obtenir la classe CSS pour le statut
const getStatusClass = (status) => {
  switch (status) {
    case 'pending':
      return 'bg-yellow-100 text-yellow-800';
    case 'accepted':
      return 'bg-green-100 text-green-800';
    case 'rejected':
      return 'bg-red-100 text-red-800';
    default:
      return 'bg-gray-100 text-gray-800';
  }
};

// Obtenir le libellé pour le statut
const getStatusLabel = (status) => {
  switch (status) {
    case 'pending':
      return 'En attente';
    case 'accepted':
      return 'Acceptée';
    case 'rejected':
      return 'Refusée';
    default:
      return 'Statut inconnu';
  }
};

// Cycle de vie
onMounted(async () => {
  await fetchProfile();
  await fetchProposals();
});

definePageMeta({
  middleware: ['auth'],
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