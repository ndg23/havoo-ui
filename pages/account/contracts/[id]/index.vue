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
            
            <h2 class="text-xl font-bold text-gray-900 dark:text-white">{{ contract.title }}</h2>
            
            <div class="flex items-center mt-2 text-sm text-gray-600 dark:text-gray-400">
              <CalendarIcon class="h-4 w-4 mr-1.5" />
              <span>Créé le {{ formatDate(contract.created_at) }}</span>
            </div>
          </div>
          
          <!-- Actions principales -->
          <div class="flex flex-wrap gap-2">
            <NuxtLink 
              v-if="contract.status === 'in_progress'"
              :to="`/account/contracts/${contractId}/complete`"
              class="px-4 py-2 bg-primary-600 hover:bg-primary-700 text-white text-sm font-medium rounded-md shadow-sm transition-colors whitespace-nowrap"
            >
              <CheckIcon class="h-4 w-4 inline-block mr-1.5" />
              Finaliser
            </NuxtLink>
            
            <button 
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
                {{ isClient ? contract.expert_name : contract.client_name }}
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
                {{ contract.service_name }}
              </p>
              
              <div class="mt-1 flex items-center text-sm text-gray-600 dark:text-gray-400">
                <CurrencyIcon class="h-4 w-4 mr-1.5" />
                <span class="font-medium">{{ contract.amount }}FCFA</span>
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
        <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-4">Évaluation</h3>
        
        <div v-if="review" class="bg-gray-50 dark:bg-gray-700/50 p-4 rounded-lg">
          <div class="flex items-center mb-2">
            <div class="flex">
              <StarIcon 
                v-for="i in 5" 
                :key="i"
                :class="[
                  'h-5 w-5', 
                  i <= review.rating 
                    ? 'text-yellow-500 fill-current' 
                    : 'text-gray-300 dark:text-gray-600'
                ]"
              />
            </div>
            <span class="ml-2 text-sm text-gray-600 dark:text-gray-400">
              {{ review.rating }}/5
            </span>
            
            <span v-if="review.recommend" class="ml-4 text-xs font-medium text-green-600 dark:text-green-400">
              <CheckIcon class="h-3.5 w-3.5 inline-block mr-1" />
              Recommandé
            </span>
          </div>
          
          <p v-if="review.comment" class="text-gray-700 dark:text-gray-300">
            {{ review.comment }}
          </p>
          <p v-else class="text-gray-500 dark:text-gray-400 italic">
            Aucun commentaire laissé.
          </p>
        </div>
        
        <div v-else class="text-center p-4 border border-dashed border-gray-300 dark:border-gray-600 rounded-lg">
          <p class="text-gray-500 dark:text-gray-400">
            Aucune évaluation n'a été laissée pour ce contrat.
          </p>
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
  CheckCircle
} from 'lucide-vue-next'
import AccountHeader from '~/components/account/AccountHeader.vue'

const supabase = useSupabaseClient()
const user = useSupabaseUser()
const route = useRoute()
const contractId = route.params.id

// États
const isLoading = ref(true)
const error = ref(null)
const contract = ref(null)
const review = ref(null)

// Propriétés calculées
const isClient = computed(() => {
  if (!contract.value || !user.value) return false
  return contract.value.client_id === user.value.id
})

// Charger les données du contrat
const fetchContract = async () => {
  isLoading.value = true
  error.value = null
  
  try {
    const { data, error: contractError } = await supabase
      .from('contracts')
      .select(`
        *,
        services (
          title,
          id
        ),
        client:client_id (
          first_name,
          last_name
        ),
        expert:expert_id (
          first_name,
          last_name
        )
      `)
      .eq('id', contractId)
      .single()
    
    if (contractError) throw contractError
    
    if (!data) {
      throw new Error('Contrat non trouvé')
    }
    
    // Vérifier que l'utilisateur est autorisé à voir ce contrat
    if (data.client_id !== user.value.id && data.expert_id !== user.value.id) {
      throw new Error('Vous n\'êtes pas autorisé à accéder à ce contrat')
    }
    
    // Préparer les données du contrat
    contract.value = {
      ...data,
      client_name: `${data.client.first_name} ${data.client.last_name}`,
      expert_name: `${data.expert.first_name} ${data.expert.last_name}`,
      service_name: data.services?.title || 'Service non spécifié',
      title: data.title || data.services?.title || 'Contrat'
    }
    
    // Charger l'évaluation si le contrat est terminé
    if (data.status === 'completed') {
      await fetchReview()
    }
    
  } catch (err) {
    console.error('Erreur lors du chargement du contrat:', err)
    error.value = err.message || 'Impossible de charger le contrat'
  } finally {
    isLoading.value = false
  }
}

// Charger l'évaluation
const fetchReview = async () => {
  try {
    const { data, error: reviewError } = await supabase
      .from('reviews')
      .select('*')
      .eq('contract_id', contractId)
      .eq('reviewer_id', user.value.id)
      .single()
    
    if (reviewError && !reviewError.message.includes('No rows found')) {
      throw reviewError
    }
    
    review.value = data
  } catch (err) {
    console.error('Erreur lors du chargement de l\'évaluation:', err)
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

// Formater le statut d'un contrat
const formatStatus = (status) => {
  switch (status) {
    case 'pending':
      return 'En attente'
    case 'in_progress':
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
    case 'in_progress':
      return 'bg-blue-100 text-blue-800 dark:bg-blue-900/30 dark:text-blue-400'
    case 'completed':
      return 'bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-400'
    case 'cancelled':
      return 'bg-red-100 text-red-800 dark:bg-red-900/30 dark:text-red-400'
    default:
      return 'bg-gray-100 text-gray-800 dark:bg-gray-700 dark:text-gray-400'
  }
}

// Initialisation
onMounted(() => {
  fetchContract()
})

definePageMeta({
  layout: 'account'
})
</script> 