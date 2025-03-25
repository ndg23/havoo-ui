<template>
  <div class="max-w-3xl mx-auto">
    <AccountHeader 
      title="Détails du contrat" 
      subtitle="Informations et suivi de votre contrat" 
    />
    
    <!-- Chargement -->
    <div v-if="isLoading" class="bg-white dark:bg-gray-800 rounded-xl p-8 shadow-sm text-center">
      <div class="inline-block h-8 w-8 animate-spin rounded-full border-4 border-solid border-primary-500 border-r-transparent"></div>
      <p class="mt-3 text-gray-600 dark:text-gray-400">Chargement des informations...</p>
    </div>
    
    <!-- Erreur -->
    <div v-else-if="error" class="bg-white dark:bg-gray-800 rounded-xl p-8 border-l-4 border-red-500 shadow-sm">
      <h3 class="text-lg font-medium text-red-700 dark:text-red-400 mb-2">Une erreur est survenue</h3>
      <p class="text-gray-600 dark:text-gray-400">{{ error }}</p>
      <NuxtLink 
        to="/account/contracts"
        class="mt-4 inline-flex items-center text-sm font-medium text-primary-600 dark:text-primary-400 hover:underline"
      >
        <ChevronLeft class="h-4 w-4 mr-1" />
        Retour à mes contrats
      </NuxtLink>
    </div>
    
    <!-- Détails du contrat -->
    <div v-else class="space-y-6">
      <!-- En-tête et statut -->
      <div class="bg-white dark:bg-gray-800 rounded-xl p-6 border border-gray-200 dark:border-gray-700 shadow-sm">
        <div class="flex flex-col sm:flex-row sm:justify-between sm:items-start gap-4 mb-4">
          <div>
            <div class="flex flex-wrap gap-2 mb-2">
              <span 
                class="px-3 py-1 rounded-full text-xs font-medium"
                :class="getStatusClass(contract.status)"
              >
                {{ formatStatus(contract.status) }}
              </span>
              <span class="px-3 py-1 rounded-full text-xs font-medium bg-primary-100 text-primary-800 dark:bg-primary-900/30 dark:text-primary-400">
                Contrat #{{ contractId.substring(0, 8) }}
              </span>
            </div>
            
            <h2 class="text-xl font-bold text-gray-900 dark:text-white">{{ contract.job_title }}</h2>
            
            <div class="flex items-center mt-2 text-sm text-gray-600 dark:text-gray-400">
              <CalendarIcon class="h-4 w-4 mr-1.5" />
              <span>Créé le {{ formatDate(contract.start_date) }}</span>
            </div>
          </div>
          
          <!-- Actions principales -->
          <div class="flex flex-wrap gap-2">
            <button 
              v-if="contract.status === 'active' && isClient"
              @click="completeContract"
              class="px-4 py-2 bg-primary-600 hover:bg-primary-700 text-white text-sm font-medium rounded-md shadow-sm transition-colors whitespace-nowrap"
            >
              <CheckIcon class="h-4 w-4 inline-block mr-1.5" />
              Marquer comme terminé
            </button>
            
            <button 
              @click="contactOtherParty"
              class="px-4 py-2 bg-white dark:bg-gray-700 text-gray-700 dark:text-gray-300 text-sm font-medium rounded-md border border-gray-300 dark:border-gray-600 hover:bg-gray-50 dark:hover:bg-gray-600 transition-colors whitespace-nowrap"
            >
              <MessageSquare class="h-4 w-4 inline-block mr-1.5" />
              Message
            </button>
          </div>
        </div>
        
        <!-- Informations de base -->
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mt-6">
          <!-- Info expert/client -->
          <div class="flex items-start space-x-4">
            <div class="w-12 h-12 rounded-full bg-primary-100 dark:bg-primary-900/30 flex items-center justify-center">
              <UserIcon class="h-6 w-6 text-primary-600 dark:text-primary-400" />
            </div>
            <div>
              <h3 class="text-sm font-medium text-gray-900 dark:text-white">
                {{ isClient ? 'Expert' : 'Client' }}
              </h3>
              <p class="text-sm font-bold text-gray-900 dark:text-white">
                {{ otherPartyName }}
              </p>
              
              <button class="mt-2 text-xs text-primary-600 dark:text-primary-400 font-medium hover:underline">
                Voir le profil
              </button>
            </div>
          </div>
          
          <!-- Info service -->
          <div class="flex items-start space-x-4">
            <div class="w-12 h-12 rounded-full bg-primary-100 dark:bg-primary-900/30 flex items-center justify-center">
              <Briefcase class="h-6 w-6 text-primary-600 dark:text-primary-400" />
            </div>
            <div>
              <h3 class="text-sm font-medium text-gray-900 dark:text-white">
                Service
              </h3>
              <p class="text-sm font-bold text-gray-900 dark:text-white">
                {{ contract.job_title }}
              </p>
              
              <div class="mt-1 flex items-center text-sm text-gray-600 dark:text-gray-400">
                <CurrencyIcon class="h-4 w-4 mr-1.5" />
                <span class="font-medium">{{ formatPrice(contract.agreed_price) }}</span>
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Description et détails -->
      <div class="bg-white dark:bg-gray-800 rounded-xl p-6 border border-gray-200 dark:border-gray-700 shadow-sm">
        <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-4">Détails du contrat</h3>
        
        <div class="prose dark:prose-invert prose-sm max-w-none">
          <p>{{ contract.description || 'Aucune description disponible pour ce contrat.' }}</p>
        </div>
        
        <div class="mt-6 grid grid-cols-1 md:grid-cols-2 gap-4 text-sm">
          <div>
            <span class="text-gray-600 dark:text-gray-400">Date de début:</span>
            <span class="font-medium text-gray-900 dark:text-white ml-1">{{ formatDate(contract.start_date) }}</span>
          </div>
          <div>
            <span class="text-gray-600 dark:text-gray-400">Date de fin prévue:</span>
            <span class="font-medium text-gray-900 dark:text-white ml-1">{{ formatDate(contract.end_date) }}</span>
          </div>
          <div v-if="contract.completed_at">
            <span class="text-gray-600 dark:text-gray-400">Date de finalisation:</span>
            <span class="font-medium text-gray-900 dark:text-white ml-1">{{ formatDate(contract.completed_at) }}</span>
          </div>
        </div>
      </div>
      
      <!-- Section des évaluations -->
      <div v-if="contract.status === 'completed'" class="bg-white dark:bg-gray-800 rounded-xl p-6 border border-gray-200 dark:border-gray-700 shadow-sm">
        <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-4">Évaluations</h3>
        
        <div v-if="ratingStatusMessage" class="mb-6 p-4 rounded-lg" :class="ratingStatusBgClass">
          <div class="flex items-center">
            <InformationCircleIcon class="h-5 w-5 mr-2" :class="ratingStatusIconClass" />
            <p class="text-sm" :class="ratingStatusTextClass">{{ ratingStatusMessage }}</p>
          </div>
        </div>
        
        <!-- Évaluation laissée par l'utilisateur -->
        <div class="mb-6">
          <h4 class="text-md font-medium text-gray-800 dark:text-gray-200 mb-3">Votre évaluation</h4>
          
          <div v-if="hasRated" class="bg-gray-50 dark:bg-gray-700/50 p-4 rounded-lg">
            <div class="flex items-center mb-2">
              <div class="flex">
                <StarIcon 
                  v-for="i in 5" 
                  :key="i"
                  :class="[
                    'h-5 w-5', 
                    i <= userRating 
                      ? 'text-yellow-400 fill-current' 
                      : 'text-gray-300 dark:text-gray-600'
                  ]"
                />
              </div>
              <span class="ml-2 text-sm text-gray-600 dark:text-gray-400">
                {{ userRating }}/5
              </span>
            </div>
            
            <p v-if="userReview" class="text-gray-700 dark:text-gray-300 mt-3">
              {{ userReview }}
            </p>
            <p v-else class="text-gray-500 dark:text-gray-400 italic mt-3">
              Aucun commentaire laissé.
            </p>
          </div>
          
          <div v-else class="text-center p-4 border border-dashed border-gray-300 dark:border-gray-600 rounded-lg">
            <p class="text-gray-500 dark:text-gray-400 mb-3">
              Vous n'avez pas encore évalué {{ isClient ? 'cet expert' : 'ce client' }}.
            </p>
            <NuxtLink 
              :to="`/account/contracts/${contractId}/rate`"
              class="inline-flex items-center px-3 py-1.5 border border-transparent rounded-full shadow-sm text-xs font-medium text-white bg-primary-600 hover:bg-primary-700"
            >
              <StarIcon class="h-3.5 w-3.5 mr-1" />
              Laisser une évaluation
            </NuxtLink>
          </div>
        </div>
        
        <!-- Évaluation laissée par l'autre partie -->
        <div>
          <h4 class="text-md font-medium text-gray-800 dark:text-gray-200 mb-3">
            Évaluation de {{ isClient ? 'l\'expert' : 'du client' }}
          </h4>
          
          <div v-if="otherHasRated" class="bg-gray-50 dark:bg-gray-700/50 p-4 rounded-lg">
            <div class="flex items-center mb-2">
              <div class="flex">
                <StarIcon 
                  v-for="i in 5" 
                  :key="i"
                  :class="[
                    'h-5 w-5', 
                    i <= otherRating 
                      ? 'text-yellow-400 fill-current' 
                      : 'text-gray-300 dark:text-gray-600'
                  ]"
                />
              </div>
              <span class="ml-2 text-sm text-gray-600 dark:text-gray-400">
                {{ otherRating }}/5
              </span>
            </div>
            
            <p v-if="otherReview" class="text-gray-700 dark:text-gray-300 mt-3">
              {{ otherReview }}
            </p>
            <p v-else class="text-gray-500 dark:text-gray-400 italic mt-3">
              Aucun commentaire laissé.
            </p>
          </div>
          
          <div v-else class="text-center p-4 border border-dashed border-gray-300 dark:border-gray-600 rounded-lg">
            <p class="text-gray-500 dark:text-gray-400">
              {{ isClient ? 'L\'expert' : 'Le client' }} n'a pas encore laissé d'évaluation.
            </p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { 
  UserIcon, 
  CalendarIcon, 
  MessageSquare, 
  CheckIcon, 
  Briefcase, 
  CurrencyIcon, 
  ChevronLeft,
  StarIcon,
  CheckCircle} from 'lucide-vue-next'
import AccountHeader from '~/components/account/AccountHeader.vue'

const supabase = useSupabaseClient()
const user = useSupabaseUser()
const route = useRoute()
const router = useRouter()
const contractId = route.params.id

// États
const isLoading = ref(true)
const error = ref(null)
const contract = ref(null)
const contractRating = ref(null)
const successMessage = ref(route.query.rated === 'success' ? 'Votre évaluation a été soumise avec succès.' : null)

// Propriétés calculées
const isClient = computed(() => {
  if (!contract.value || !user.value) return false;
  return contract.value.client_id === user.value.id;
});

const otherPartyName = computed(() => {
  if (!contract.value) return '';
  return isClient.value ? contract.value.worker_name : contract.value.client_name;
});

const ratingStatusMessage = computed(() => {
  if (!contract.value || contract.value.status !== 'completed') return null;
  
  if (contract.value.ratings_complete) {
    return 'Les évaluations ont été finalisées';
  }
  
  if (contract.value.client_has_rated && contract.value.expert_has_rated) {
    return 'Les deux parties ont évalué ce contrat';
  }
  
  if (isClient.value) {
    if (contract.value.client_has_rated) {
      return 'Vous avez évalué ce contrat. En attente de l\'évaluation de l\'expert.';
    } else {
      return contract.value.expert_has_rated 
        ? 'L\'expert a évalué ce contrat. Votre évaluation est en attente.' 
        : 'Aucune évaluation n\'a été laissée pour ce contrat.';
    }
  } else {
    if (contract.value.expert_has_rated) {
      return 'Vous avez évalué ce contrat. En attente de l\'évaluation du client.';
    } else {
      return contract.value.client_has_rated 
        ? 'Le client a évalué ce contrat. Votre évaluation est en attente.' 
        : 'Aucune évaluation n\'a été laissée pour ce contrat.';
    }
  }
});

const ratingStatusBgClass = computed(() => {
  if (!contract.value) return '';
  
  if (contract.value.ratings_complete) {
    return 'bg-green-50 dark:bg-green-900/20';
  }
  
  if (contract.value.client_has_rated && contract.value.expert_has_rated) {
    return 'bg-green-50 dark:bg-green-900/20';
  }
  
  if ((isClient.value && contract.value.client_has_rated) || 
      (!isClient.value && contract.value.expert_has_rated)) {
    return 'bg-amber-50 dark:bg-amber-900/20';
  }
  
  if ((isClient.value && contract.value.expert_has_rated) || 
      (!isClient.value && contract.value.client_has_rated)) {
    return 'bg-amber-50 dark:bg-amber-900/20';
  }
  
  return 'bg-gray-50 dark:bg-gray-700/50';
});

const ratingStatusIconClass = computed(() => {
  if (!contract.value) return '';
  
  if (contract.value.ratings_complete || 
      (contract.value.client_has_rated && contract.value.expert_has_rated)) {
    return 'text-green-500 dark:text-green-400';
  }
  
  if ((isClient.value && contract.value.client_has_rated) || 
      (!isClient.value && contract.value.expert_has_rated) ||
      (isClient.value && contract.value.expert_has_rated) || 
      (!isClient.value && contract.value.client_has_rated)) {
    return 'text-amber-500 dark:text-amber-400';
  }
  
  return 'text-gray-500 dark:text-gray-400';
});

const ratingStatusTextClass = computed(() => {
  if (!contract.value) return '';
  
  if (contract.value.ratings_complete || 
      (contract.value.client_has_rated && contract.value.expert_has_rated)) {
    return 'text-green-700 dark:text-green-300';
  }
  
  if ((isClient.value && contract.value.client_has_rated) || 
      (!isClient.value && contract.value.expert_has_rated) ||
      (isClient.value && contract.value.expert_has_rated) || 
      (!isClient.value && contract.value.client_has_rated)) {
    return 'text-amber-700 dark:text-amber-300';
  }
  
  return 'text-gray-700 dark:text-gray-300';
});

const hasRated = computed(() => {
  if (!contract.value) return false;
  return isClient.value ? contract.value.client_has_rated : contract.value.expert_has_rated;
});

const otherHasRated = computed(() => {
  if (!contract.value) return false;
  return isClient.value ? contract.value.expert_has_rated : contract.value.client_has_rated;
});

const userRating = computed(() => {
  if (!contract.value || !hasRated.value) return 0;
  return isClient.value ? contract.value.client_rating : contract.value.expert_rating;
});

const userReview = computed(() => {
  if (!contract.value || !hasRated.value) return '';
  return isClient.value ? contract.value.client_review : contract.value.expert_review;
});

const otherRating = computed(() => {
  if (!contract.value || !otherHasRated.value) return 0;
  return isClient.value ? contract.value.expert_rating : contract.value.client_rating;
});

const otherReview = computed(() => {
  if (!contract.value || !otherHasRated.value) return '';
  return isClient.value ? contract.value.expert_review : contract.value.client_review;
});

// Charger les données du contrat
const fetchContract = async () => {
  isLoading.value = true;
  error.value = null;
  
  try {
    // Récupérer les informations du contrat depuis la table deals
    const { data, error: contractError } = await supabase
      .from('deals')
      .select(`
        *,
        client:client_id (*),
        expert:expert_id (*),
        request:request_id (title, description)
      `)
      .eq('id', contractId)
      .in('status', ['active', 'completed'])
      .single();
    
    if (contractError) throw contractError;
    
    if (!data) {
      throw new Error('Contrat non trouvé');
    }
    
    // Vérifier que l'utilisateur est autorisé à voir ce contrat
    if (data.client_id !== user.value.id && data.expert_id !== user.value.id) {
      throw new Error('Vous n\'êtes pas autorisé à accéder à ce contrat');
    }
    
    // Préparer les données pour l'affichage
    contract.value = {
      contract_id: data.id,
      deal_id: data.id,
      request_id: data.request_id,
      client_id: data.client_id,
      worker_id: data.expert_id,
      status: data.status,
      agreed_price: data.price,
      start_date: data.created_at,
      end_date: new Date(new Date(data.created_at).getTime() + data.duration * 24 * 60 * 60 * 1000),
      completed_at: data.status === 'completed' ? data.updated_at : null,
      created_at: data.created_at,
      client_name: `${data.client.first_name || ''} ${data.client.last_name || ''}`.trim(),
      worker_name: `${data.expert.first_name || ''} ${data.expert.last_name || ''}`.trim(),
      job_title: data.request?.title || 'Contrat',
      description: data.request?.description || '',
      // Informations d'évaluation
      client_rating: data.client_rating,
      expert_rating: data.expert_rating,
      client_review: data.client_review,
      expert_review: data.expert_review,
      client_has_rated: data.client_has_rated || false,
      expert_has_rated: data.expert_has_rated || false,
      ratings_complete: data.ratings_complete || false
    };
    
  } catch (err) {
    console.error('Erreur lors du chargement du contrat:', err);
    error.value = err.message || 'Impossible de charger le contrat';
  } finally {
    isLoading.value = false;
  }
}

// Charger les évaluations
const fetchRatings = async () => {
  try {
    const { data, error: ratingError } = await supabase
      .from('contract_ratings')
      .select('*')
      .eq('contract_id', contractId)
      .single()
    
    if (ratingError && !ratingError.message.includes('No rows found')) {
      throw ratingError
    }
    
    contractRating.value = data
  } catch (err) {
    console.error('Erreur lors du chargement des évaluations:', err)
  }
}

// Formater une date
const formatDate = (dateString) => {
  if (!dateString) return 'Non spécifiée'
  
  const date = new Date(dateString)
  return new Intl.DateTimeFormat('fr-FR', {
    day: 'numeric',
    month: 'long',
    year: 'numeric'
  }).format(date)
}

// Formater un prix
const formatPrice = (price) => {
  if (!price) return 'Prix non défini';
  return new Intl.NumberFormat('fr-FR', {
    style: 'currency',
    currency: 'XOF',
    maximumFractionDigits: 0
  }).format(price);
};

// Formater le statut d'un contrat
const formatStatus = (status) => {
  switch (status) {
    case 'pending':
      return 'En attente'
    case 'active':
      return 'En cours'
    case 'completed':
      return 'Terminé'
    case 'cancelled':
      return 'Annulé'
    default:
      return status
  }
}

// Obtenir la classe CSS pour le statut
const getStatusClass = (status) => {
  switch (status) {
    case 'pending':
      return 'bg-amber-100 text-amber-800 dark:bg-amber-900/30 dark:text-amber-400'
    case 'active':
      return 'bg-blue-100 text-blue-800 dark:bg-blue-900/30 dark:text-blue-400'
    case 'completed':
      return 'bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-400'
    case 'cancelled':
      return 'bg-red-100 text-red-800 dark:bg-red-900/30 dark:text-red-400'
    default:
      return 'bg-gray-100 text-gray-800 dark:bg-gray-700 dark:text-gray-400'
  }
}

// Marquer un contrat comme terminé
const completeContract = async () => {
  try {
    const { error: updateError } = await supabase
      .from('deals')
      .update({ status: 'completed' })
      .eq('id', contractId);
    
    if (updateError) throw updateError;
    
    // Rafraîchir les données
    await fetchContract();
    
    // Afficher un message de succès
    alert('Le contrat a été marqué comme terminé. Vous pouvez maintenant laisser une évaluation.');
  } catch (err) {
    console.error('Error completing contract:', err);
    alert('Une erreur est survenue lors de la mise à jour du contrat');
  }
};

// Contacter l'autre partie
const contactOtherParty = () => {
  if (!contract.value) return;
  
  const otherPartyId = isClient.value 
    ? contract.value.worker_id 
    : contract.value.client_id;
  
  router.push(`/messages/${otherPartyId}`);
};

// Initialisation
onMounted(() => {
  fetchContract()
})

definePageMeta({
  layout: 'account'
})
</script> 