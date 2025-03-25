<template>
  <div class="max-w-3xl mx-auto">
    <!-- En-tête -->
    <div class="mb-8 px-4">
      <NuxtLink 
        :to="`/account/contracts/${contractId}`"
        class="inline-flex items-center text-sm text-gray-500 dark:text-gray-400 hover:text-gray-700 dark:hover:text-gray-300 mb-4"
      >
        <svg class="h-5 w-5 mr-1" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18" />
        </svg>
        Retour au contrat
      </NuxtLink>
      <h1 class="text-2xl font-bold text-gray-900 dark:text-white">Évaluer {{ isClient ? 'l\'expert' : 'le client' }}</h1>
      <p class="text-gray-500 dark:text-gray-400 mt-2">
        Veuillez évaluer votre expérience avec {{ otherPartyName || isClient ? 'cet expert' : 'ce client' }} pour le contrat "{{ contract?.job_title || 'Chargement...' }}".
      </p>
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
        @click="fetchData" 
        class="mt-3 text-sm font-medium text-red-600 dark:text-red-400 hover:text-red-500"
      >
        Réessayer
      </button>
    </div>

    <!-- Already rated message -->
    <div v-else-if="alreadyRated" class="bg-green-50 dark:bg-green-900/20 p-6 rounded-lg text-green-700 dark:text-green-400 mx-4 my-6 text-center">
      <svg class="h-12 w-12 text-green-400 mx-auto mb-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
      </svg>
      <h3 class="text-lg font-medium">Évaluation déjà soumise</h3>
      <p class="mt-1">
        Vous avez déjà évalué {{ isClient ? 'cet expert' : 'ce client' }} pour ce contrat. Merci pour votre retour !
      </p>
      <NuxtLink 
        :to="`/account/contracts/${contractId}`"
        class="mt-4 inline-flex items-center px-4 py-2 border border-transparent rounded-full shadow-sm text-sm font-medium text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 transition-colors"
      >
        Retourner au contrat
      </NuxtLink>
    </div>

    <!-- Simplified Rating form -->
    <form v-else @submit.prevent="submitRating" class="bg-white dark:bg-gray-800 shadow rounded-lg mx-4">
      <div class="p-6">
        <div class="space-y-6">
          <!-- Stars -->
          <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
              Note globale <span class="text-red-500">*</span>
            </label>
            <div class="flex items-center space-x-1">
              <button 
                v-for="i in 5" 
                :key="i" 
                type="button"
                @click="rating = i"
                class="focus:outline-none transition-colors"
              >
                <svg 
                  class="h-8 w-8" 
                  :class="i <= rating ? 'text-yellow-400' : 'text-gray-300 dark:text-gray-600'"
                  xmlns="http://www.w3.org/2000/svg" 
                  viewBox="0 0 20 20" 
                  fill="currentColor"
                >
                  <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
                </svg>
              </button>
              <span class="ml-2 text-sm text-gray-500 dark:text-gray-400">
                {{ ratingText }}
              </span>
            </div>
            <p v-if="submitting && !rating" class="mt-1 text-sm text-red-600 dark:text-red-400">
              Veuillez sélectionner une note
            </p>
          </div>

          <!-- Comment -->
          <div>
            <label for="comment" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
              Commentaire <span class="text-red-500">*</span>
            </label>
            <textarea 
              id="comment" 
              v-model="comment" 
              rows="4" 
              placeholder="Partagez votre expérience..."
              class="block w-full rounded-lg border-gray-300 dark:border-gray-700 shadow-sm bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-primary-500 focus:border-primary-500 sm:text-sm"
            ></textarea>
            <p v-if="submitting && !comment" class="mt-1 text-sm text-red-600 dark:text-red-400">
              Veuillez laisser un commentaire
            </p>
            <p class="mt-1 text-xs text-gray-500 dark:text-gray-400">
              Minimum 10 caractères
            </p>
          </div>
        </div>
      </div>
      
      <!-- Form actions -->
      <div class="bg-gray-50 dark:bg-gray-900/50 px-6 py-4 flex justify-end space-x-3 rounded-b-lg">
        <NuxtLink 
          :to="`/account/contracts/${contractId}`"
          class="px-4 py-2 border border-gray-300 dark:border-gray-700 rounded-full shadow-sm text-sm font-medium text-gray-700 dark:text-gray-300 bg-white dark:bg-gray-800 hover:bg-gray-50 dark:hover:bg-gray-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 transition-colors"
        >
          Annuler
        </NuxtLink>
        <button 
          type="submit" 
          :disabled="submitting"
          class="inline-flex items-center px-4 py-2 border border-transparent rounded-full shadow-sm text-sm font-medium text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
        >
          <svg v-if="submitting" class="animate-spin -ml-1 mr-2 h-4 w-4 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
          </svg>
          Soumettre l'évaluation
        </button>
      </div>
    </form>
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

// Récupération de l'ID du contrat depuis l'URL
const contractId = computed(() => route.params.id);

// État
const isLoading = ref(true);
const error = ref(null);
const contract = ref(null);
const rating = ref(0);
const comment = ref('');
const submitting = ref(false);
const alreadyRated = ref(false);
const otherPartyName = ref('');
const dealId = ref(null);

// Computed properties
const isClient = computed(() => {
  if (!contract.value || !user.value) return false;
  return user.value.id === contract.value.client_id;
});

const ratingText = computed(() => {
  const texts = [
    'Non évalué',
    'Très insatisfait',
    'Insatisfait',
    'Neutre',
    'Satisfait',
    'Très satisfait'
  ];
  return texts[rating.value] || texts[0];
});

// Fetch contract data
const fetchData = async () => {
  isLoading.value = true;
  error.value = null;
  
  try {
    // Fetch contract details directly from the deals table
    const { data: contractData, error: contractError } = await supabase
      .from('deals')
      .select(`
        *,
        client:client_id (first_name, last_name),
        expert:expert_id (first_name, last_name),
        request:request_id (title)
      `)
      .eq('id', contractId.value)
      .in('status', ['active', 'completed'])
      .single();
    
    if (contractError) throw contractError;
    if (!contractData) throw new Error('Contrat non trouvé');
    
    // Set contract data
    contract.value = contractData;
    dealId.value = contractData.id;
    
    // Check if user is authorized to rate this contract
    if (user.value.id !== contractData.client_id && user.value.id !== contractData.expert_id) {
      throw new Error('Vous n\'êtes pas autorisé à évaluer ce contrat');
    }
    
    // Set other party name
    otherPartyName.value = isClient.value 
      ? `${contractData.expert.first_name || ''} ${contractData.expert.last_name || ''}`.trim()
      : `${contractData.client.first_name || ''} ${contractData.client.last_name || ''}`.trim();
    
    // Check if contract is completed
    if (contractData.status !== 'completed') {
      throw new Error('Vous ne pouvez évaluer que les contrats terminés');
    }
    
    // Check if user has already rated
    alreadyRated.value = isClient.value ? contractData.client_has_rated : contractData.expert_has_rated;
  } catch (err) {
    console.error('Error fetching contract data:', err);
    error.value = err.message || 'Une erreur est survenue lors du chargement des données';
  } finally {
    isLoading.value = false;
  }
};

// Submit the simplified rating
const submitRating = async () => {
  submitting.value = true;
  
  // Form validation
  if (!rating.value || !comment.value) {
    submitting.value = false;
    return;
  }
  
  if (comment.value.length < 10) {
    alert('Votre commentaire doit comporter au moins 10 caractères.');
    submitting.value = false;
    return;
  }
  
  try {
    // Use the simplified rating function
    const { data, error: ratingError } = await supabase
      .rpc('rate_contract_simple', {
        p_deal_id: dealId.value,
        p_is_client: isClient.value,
        p_rating: rating.value,
        p_comment: comment.value
      });
    
    if (ratingError) throw ratingError;
    
    // Success - redirect back to contract
    router.push({
      path: `/account/contracts/${contractId.value}`,
      query: { rated: 'success' }
    });
  } catch (err) {
    console.error('Error submitting rating:', err);
    alert('Une erreur est survenue lors de l\'envoi de votre évaluation. Veuillez réessayer.');
    submitting.value = false;
  }
};

// Initialize
onMounted(() => {
  if (user.value) {
    fetchData();
  } else {
    error.value = 'Vous devez être connecté pour accéder à cette page';
    isLoading.value = false;
  }
});

definePageMeta({
  middleware: ['auth'],
  layout: 'account'
});
</script> 