<template>
  <div class="min-h-screen bg-white">
    <!-- Header avec retour -->
    <header class="sticky top-0 z-10 bg-white/80 backdrop-blur-sm border-b border-gray-100">
      <div class="max-w-2xl mx-auto px-4 py-3 flex items-center justify-between">
        <div class="flex items-center">
          <button 
            @click="$router.back()" 
            class="p-2 -ml-2 rounded-full hover:bg-gray-100 transition-colors"
          >
            <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M15 19l-7-7 7-7" />
            </svg>
          </button>
          <h1 class="ml-6 text-xl font-bold truncate">{{ request?.title || 'Détail de la demande' }}</h1>
        </div>
        
        <!-- Actions -->
        <div v-if="request && isOwner" class="flex items-center">
          <button 
            class="p-2 rounded-full hover:bg-gray-100 transition-colors text-gray-500"
            @click="showActionsMenu = !showActionsMenu"
          >
            <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 5v.01M12 12v.01M12 19v.01M12 6a1 1 0 110-2 1 1 0 010 2zm0 7a1 1 0 110-2 1 1 0 010 2zm0 7a1 1 0 110-2 1 1 0 010 2z" />
            </svg>
          </button>
          
          <!-- Menu d'actions -->
          <div 
            v-if="showActionsMenu" 
            class="absolute right-4 top-12 bg-white shadow-lg rounded-lg py-1 w-48 border border-gray-200 z-20"
          >
            <button 
              @click="editRequest" 
              class="w-full text-left px-4 py-2 hover:bg-gray-50 flex items-center text-gray-700"
            >
              <svg class="w-4 h-4 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
              </svg>
              Modifier
            </button>
            <button 
              @click="deleteRequest" 
              class="w-full text-left px-4 py-2 hover:bg-gray-50 flex items-center text-red-600"
            >
              <svg class="w-4 h-4 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
              </svg>
              Supprimer
            </button>
          </div>
        </div>
      </div>
    </header>

    <!-- Contenu principal -->
    <main class="max-w-2xl mx-auto px-4 py-6">
      <!-- Chargement -->
      <div v-if="isLoading" class="flex flex-col items-center justify-center py-12">
        <svg class="animate-spin h-8 w-8 text-gray-400 mb-4" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
          <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
          <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
        </svg>
        <p class="text-gray-500">Chargement de la demande...</p>
      </div>

      <!-- Erreur -->
      <div v-else-if="error" class="bg-red-50 p-4 rounded-lg text-red-700 my-6">
        <div class="flex">
          <svg class="h-5 w-5 text-red-400 mr-3" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
          </svg>
          <p>{{ error }}</p>
        </div>
        <button 
          @click="fetchRequest" 
          class="mt-3 text-sm font-medium text-red-600 hover:text-red-500"
        >
          Réessayer
        </button>
      </div>

      <!-- Contenu de la demande -->
      <div v-else-if="request" class="space-y-6">
        <!-- En-tête avec statut -->
        <div class="flex items-start justify-between">
          <div>
            <div class="flex items-center space-x-2">
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
            <h2 class="text-2xl font-bold mt-2">{{ request.title }}</h2>
            <p class="text-gray-500 text-sm mt-1">
              Publié {{ formatDate(request.created_at) }} par {{ request.client?.first_name || 'Utilisateur' }}
            </p>
          </div>
          
          <!-- Prix et date limite -->
          <div class="text-right">
            <div v-if="request.budget" class="text-xl font-bold text-gray-900">
              {{ formatPrice(request.budget) }}
            </div>
            <div v-if="request.deadline" class="text-sm text-gray-500 mt-1">
              Deadline: {{ formatDate(request.deadline) }}
            </div>
          </div>
        </div>
        
        <!-- Description -->
        <div class="bg-gray-50 rounded-lg p-4 mt-4">
          <h3 class="text-lg font-medium text-gray-900 mb-2">Description</h3>
          <div class="prose prose-sm max-w-none text-gray-700">
            {{ request.description }}
          </div>
        </div>
        
        <!-- Pièces jointes -->
        <div v-if="attachments.length > 0" class="mt-6">
          <h3 class="text-lg font-medium text-gray-900 mb-3">Pièces jointes</h3>
          <div class="grid grid-cols-2 gap-3">
            <a 
              v-for="attachment in attachments" 
              :key="attachment.id"
              :href="attachment.url"
              target="_blank"
              class="flex items-center p-3 border border-gray-200 rounded-lg hover:bg-gray-50 transition-colors"
            >
              <svg class="h-5 w-5 text-gray-400 mr-2 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.172 7l-6.586 6.586a2 2 0 102.828 2.828l6.414-6.586a4 4 0 00-5.656-5.656l-6.415 6.585a6 6 0 108.486 8.486L20.5 13" />
              </svg>
              <span class="text-sm truncate">{{ attachment.name }}</span>
            </a>
          </div>
        </div>
        
        <!-- Bouton de contact/proposition -->
        <div v-if="!isOwner" class="mt-8">
          <button
            @click="contactClient"
            class="w-full py-3 px-4 flex justify-center items-center rounded-full text-white bg-black hover:bg-gray-800 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-gray-800 text-base font-medium transition-colors"
          >
            Proposer mes services
          </button>
        </div>
      </div>
    </main>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { useSupabaseClient, useSupabaseUser } from '#imports';

const route = useRoute();
const router = useRouter();
const supabase = useSupabaseClient();
const user = useSupabaseUser();

// État
const request = ref(null);
const attachments = ref([]);
const isLoading = ref(true);
const error = ref(null);
const showActionsMenu = ref(false);

// Vérifier si l'utilisateur est le propriétaire de la demande
const isOwner = computed(() => {
  if (!user.value || !request.value) return false;
  return user.value.id === request.value.client_id;
});

// Récupérer la demande
const fetchRequest = async () => {
  isLoading.value = true;
  error.value = null;
  
  try {
    const { data, error: requestError } = await supabase
      .from('requests')
      .select(`
        *,
        category:category_id (*),
        client:client_id (id, first_name, last_name, email)
      `)
      .eq('id', route.params.id)
      .single();
    
    if (requestError) throw requestError;
    
    if (!data) {
      error.value = "Cette demande n'existe pas ou a été supprimée";
      return;
    }
    
    request.value = data;
    
    // Récupérer les pièces jointes
    await fetchAttachments();
    
  } catch (err) {
    console.error('Error fetching request:', err);
    error.value = "Une erreur est survenue lors du chargement de la demande";
  } finally {
    isLoading.value = false;
  }
};

// Récupérer les pièces jointes
const fetchAttachments = async () => {
  try {
    const { data, error: storageError } = await supabase.storage
      .from('attachments')
      .list(`requests/${route.params.id}`);
    
    if (storageError) throw storageError;
    
    if (data && data.length > 0) {
      attachments.value = await Promise.all(data.map(async (file) => {
        const { data: url } = await supabase.storage
          .from('attachments')
          .getPublicUrl(`requests/${route.params.id}/${file.name}`);
        
        return {
          id: file.id,
          name: file.name,
          url: url.publicUrl,
          size: file.metadata?.size,
          type: file.metadata?.mimetype
        };
      }));
    }
  } catch (err) {
    console.error('Error fetching attachments:', err);
  }
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

// Actions
const editRequest = () => {
  router.push(`/requests/edit/${route.params.id}`);
  showActionsMenu.value = false;
};

const deleteRequest = async () => {
  if (!confirm('Êtes-vous sûr de vouloir supprimer cette demande ?')) return;
  
  try {
    const { error: deleteError } = await supabase
      .from('requests')
      .delete()
      .eq('id', route.params.id);
    
    if (deleteError) throw deleteError;
    
    router.push('/requests');
  } catch (err) {
    console.error('Error deleting request:', err);
    alert("Une erreur est survenue lors de la suppression de la demande");
  }
  
  showActionsMenu.value = false;
};

const contactClient = () => {
  // Implémenter la logique pour contacter le client
  router.push(`/messages/new?request=${route.params.id}`);
};

// Fermer le menu d'actions en cliquant ailleurs
const handleClickOutside = (event) => {
  if (showActionsMenu.value && !event.target.closest('.actions-menu')) {
    showActionsMenu.value = false;
  }
};

// Cycle de vie
onMounted(() => {
  fetchRequest();
  document.addEventListener('click', handleClickOutside);
});

onBeforeUnmount(() => {
  document.removeEventListener('click', handleClickOutside);
});
</script> 