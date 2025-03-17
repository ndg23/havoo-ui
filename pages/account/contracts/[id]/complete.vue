<template>
  <div class="max-w-3xl mx-auto">
    <AccountHeader 
      title="Finaliser le contrat" 
      subtitle="Complétez le processus et évaluez votre expérience" 
    />

    <!-- Chargement -->
    <div v-if="isLoading" class="bg-white dark:bg-gray-800 rounded-xl p-8 shadow-sm text-center">
      <div class="inline-block h-8 w-8 animate-spin rounded-full border-4 border-solid border-primary-500 border-r-transparent"></div>
      <p class="mt-3 text-gray-600 dark:text-gray-400">Chargement des informations du contrat...</p>
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

    <!-- Si le contrat est déjà terminé -->
    <div v-else-if="contract?.status === 'completed'" class="bg-white dark:bg-gray-800 rounded-xl p-8 border border-gray-200 dark:border-gray-700 shadow-sm">
      <div class="text-center mb-6">
        <div class="inline-flex items-center justify-center h-16 w-16 rounded-full bg-green-100 dark:bg-green-900/30 text-green-600 dark:text-green-400">
          <CheckCircle class="h-8 w-8" />
        </div>
      </div>
      <h2 class="text-2xl font-bold text-center text-gray-900 dark:text-white mb-2">Ce contrat est déjà finalisé</h2>
      <p class="text-center text-gray-600 dark:text-gray-400 mb-6">
        Le contrat a été complété le {{ formatDate(contract.completed_at) }}.
      </p>
      
      <div class="border-t border-gray-200 dark:border-gray-700 py-4 mb-4">
        <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-3">Évaluation laissée</h3>
        
        <div class="flex items-center mb-2">
          <div class="flex">
            <StarIcon 
              v-for="i in 5" 
              :key="i"
              :class="[
                'h-5 w-5', 
                i <= (review?.rating || 0) 
                  ? 'text-yellow-500 fill-current' 
                  : 'text-gray-300 dark:text-gray-600'
              ]"
            />
          </div>
          <span class="ml-2 text-sm text-gray-600 dark:text-gray-400">
            {{ review?.rating || 0 }}/5
          </span>
        </div>
        
        <div v-if="review?.comment" class="bg-gray-50 dark:bg-gray-700/50 p-4 rounded-lg">
          <p class="text-gray-700 dark:text-gray-300">{{ review.comment }}</p>
        </div>
      </div>
      
      <div class="text-center">
        <NuxtLink 
          to="/account/contracts"
          class="px-5 py-2 bg-primary-600 hover:bg-primary-700 text-white text-sm font-medium rounded-full shadow-sm inline-flex items-center transition-colors"
        >
          <ChevronLeft class="h-4 w-4 mr-1.5" />
          Retour à mes contrats
        </NuxtLink>
      </div>
    </div>

    <!-- Formulaire de finalisation et évaluation -->
    <div v-else class="space-y-6">
      <!-- Récapitulatif du contrat -->
      <div class="bg-white dark:bg-gray-800 rounded-xl p-6 border border-gray-200 dark:border-gray-700 shadow-sm">
        <div class="flex items-center justify-between mb-4">
          <div>
            <h2 class="text-xl font-bold text-gray-900 dark:text-white">{{ contract?.title || 'Contrat' }}</h2>
            <div class="flex items-center mt-1 text-sm text-gray-600 dark:text-gray-400">
              <CalendarIcon class="h-4 w-4 mr-1.5" />
              <span>Créé le {{ formatDate(contract?.created_at) }}</span>
            </div>
          </div>
          <div class="px-3 py-1 rounded-full text-sm font-medium bg-amber-100 text-amber-800 dark:bg-amber-900/30 dark:text-amber-400">
            {{ contract?.status === 'in_progress' ? 'En cours' : 'À finaliser' }}
          </div>
        </div>
        
        <div class="flex items-center mb-4 pb-4 border-b border-gray-200 dark:border-gray-700">
          <div class="w-10 h-10 rounded-full bg-primary-100 dark:bg-primary-900/30 flex items-center justify-center">
            <UserIcon class="h-5 w-5 text-primary-600 dark:text-primary-400" />
          </div>
          <div class="ml-3">
            <p class="text-sm font-medium text-gray-900 dark:text-white">
              {{ isClient ? 'Expert' : 'Client' }}
            </p>
            <p class="text-sm text-gray-600 dark:text-gray-400">
              {{ isClient ? contract?.expert_name : contract?.client_name }}
            </p>
          </div>
        </div>
        
        <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-2 text-sm">
          <div>
            <span class="text-gray-600 dark:text-gray-400">Montant:</span>
            <span class="font-medium text-gray-900 dark:text-white ml-1">{{ contract?.amount || 0 }}FCFA</span>
          </div>
          <div>
            <span class="text-gray-600 dark:text-gray-400">Service:</span>
            <span class="font-medium text-gray-900 dark:text-white ml-1">{{ contract?.service_name }}</span>
          </div>
        </div>
      </div>
      
      <!-- Formulaire d'évaluation -->
      <form @submit.prevent="submitReview" class="bg-white dark:bg-gray-800 rounded-xl p-6 border border-gray-200 dark:border-gray-700 shadow-sm">
        <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-4">Évaluer la prestation</h3>
        
        <div v-if="formError" class="mb-4 p-3 bg-red-100 dark:bg-red-900/30 text-red-700 dark:text-red-400 rounded-lg text-sm">
          {{ formError }}
        </div>
        
        <!-- Confirmation de fin de contrat -->
        <div class="mb-6">
          <div class="flex items-start mb-2">
            <div class="flex items-center h-5">
              <input 
                id="confirmation"
                v-model="formData.confirmation"
                type="checkbox"
                class="focus:ring-primary-500 h-4 w-4 text-primary-600 border-gray-300 rounded"
              />
            </div>
            <label for="confirmation" class="ml-2 text-sm text-gray-700 dark:text-gray-300">
              Je confirme que cette mission est terminée et j'accepte de finaliser ce contrat
            </label>
          </div>
          <p class="text-xs text-gray-500 dark:text-gray-400">
            La finalisation du contrat débloquera le paiement et clôturera officiellement la mission.
          </p>
        </div>
        
        <!-- Notation par étoiles -->
        <div class="mb-6">
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
            Votre évaluation
          </label>
          <div class="flex items-center">
            <button 
              v-for="star in 5" 
              :key="star"
              type="button"
              @click="formData.rating = star"
              class="focus:outline-none p-1 -ml-1 first:ml-0"
            >
              <StarIcon 
                class="h-8 w-8 transition-colors" 
                :class="star <= formData.rating ? 'text-yellow-500 fill-current' : 'text-gray-300 dark:text-gray-600'"
              />
            </button>
            <span class="ml-2 text-sm text-gray-600 dark:text-gray-400">
              {{ formData.rating }}/5
            </span>
          </div>
        </div>
        
        <!-- Commentaire -->
        <div class="mb-6">
          <label for="comment" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
            Commentaire (facultatif)
          </label>
          <textarea
            id="comment"
            v-model="formData.comment"
            rows="4"
            placeholder="Partagez votre expérience..."
            class="w-full px-4 py-2.5 rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
          ></textarea>
        </div>
        
        <!-- Qualité du travail (pour le client uniquement) -->
        <div v-if="isClient" class="mb-6">
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
            Qualité du travail fourni
          </label>
          <div class="space-y-2">
            <div class="flex items-center">
              <input 
                id="quality_excellent"
                v-model="formData.workQuality"
                type="radio"
                value="excellent"
                class="focus:ring-primary-500 h-4 w-4 text-primary-600 border-gray-300"
              />
              <label for="quality_excellent" class="ml-2 text-sm text-gray-700 dark:text-gray-300">
                Excellent - Dépasse mes attentes
              </label>
            </div>
            <div class="flex items-center">
              <input 
                id="quality_good"
                v-model="formData.workQuality"
                type="radio"
                value="good"
                class="focus:ring-primary-500 h-4 w-4 text-primary-600 border-gray-300"
              />
              <label for="quality_good" class="ml-2 text-sm text-gray-700 dark:text-gray-300">
                Bon - Correspond à mes attentes
              </label>
            </div>
            <div class="flex items-center">
              <input 
                id="quality_satisfactory"
                v-model="formData.workQuality"
                type="radio"
                value="satisfactory"
                class="focus:ring-primary-500 h-4 w-4 text-primary-600 border-gray-300"
              />
              <label for="quality_satisfactory" class="ml-2 text-sm text-gray-700 dark:text-gray-300">
                Satisfaisant - Quelques points à améliorer
              </label>
            </div>
            <div class="flex items-center">
              <input 
                id="quality_poor"
                v-model="formData.workQuality"
                type="radio"
                value="poor"
                class="focus:ring-primary-500 h-4 w-4 text-primary-600 border-gray-300"
              />
              <label for="quality_poor" class="ml-2 text-sm text-gray-700 dark:text-gray-300">
                Insuffisant - Ne répond pas à mes attentes
              </label>
            </div>
          </div>
        </div>
        
        <!-- Recommandation -->
        <div class="mb-6">
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
            Recommanderiez-vous {{ isClient ? 'cet expert' : 'ce client' }} ?
          </label>
          <div class="flex space-x-4">
            <div class="flex items-center">
              <input 
                id="recommend_yes"
                v-model="formData.recommend"
                type="radio"
                value="yes"
                class="focus:ring-primary-500 h-4 w-4 text-primary-600 border-gray-300"
              />
              <label for="recommend_yes" class="ml-2 text-sm text-gray-700 dark:text-gray-300">
                Oui
              </label>
            </div>
            <div class="flex items-center">
              <input 
                id="recommend_maybe"
                v-model="formData.recommend"
                type="radio"
                value="maybe"
                class="focus:ring-primary-500 h-4 w-4 text-primary-600 border-gray-300"
              />
              <label for="recommend_maybe" class="ml-2 text-sm text-gray-700 dark:text-gray-300">
                Peut-être
              </label>
            </div>
            <div class="flex items-center">
              <input 
                id="recommend_no"
                v-model="formData.recommend"
                type="radio"
                value="no"
                class="focus:ring-primary-500 h-4 w-4 text-primary-600 border-gray-300"
              />
              <label for="recommend_no" class="ml-2 text-sm text-gray-700 dark:text-gray-300">
                Non
              </label>
            </div>
          </div>
        </div>
        
        <!-- Boutons d'action -->
        <div class="flex justify-end gap-3">
          <NuxtLink 
            to="/account/contracts"
            class="px-5 py-2.5 bg-white dark:bg-gray-700 text-gray-700 dark:text-gray-300 text-sm font-medium rounded-lg border border-gray-300 dark:border-gray-600 hover:bg-gray-50 dark:hover:bg-gray-600 transition-colors"
          >
            Annuler
          </NuxtLink>
          <button 
            type="submit"
            :disabled="isSubmitting"
            class="px-5 py-2.5 bg-primary-600 hover:bg-primary-700 text-white text-sm font-medium rounded-lg shadow-sm disabled:opacity-70 disabled:cursor-not-allowed transition-colors flex items-center"
          >
            <Loader2 v-if="isSubmitting" class="animate-spin h-4 w-4 mr-2" />
            <span>Finaliser et évaluer</span>
          </button>
        </div>
      </form>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { 
  ChevronLeft, 
  CheckCircle, 
  Star as StarIcon, 
  Calendar as CalendarIcon,
  User as UserIcon,
  Loader2
} from 'lucide-vue-next'
import AccountHeader from '~/components/account/AccountHeader.vue'

const route = useRoute()
const router = useRouter()
const contractId = computed(() => route.params.id)
const supabase = useSupabaseClient()
const user = useSupabaseUser()

// États
const isLoading = ref(true)
const isSubmitting = ref(false)
const error = ref(null)
const contract = ref(null)
const review = ref(null)

// Données du formulaire
const formData = ref({
  rating: 0,
  comment: '',
  confirmation: false,
  workQuality: 'good',
  recommend: 'yes'
})
const formError = ref(null)

// Est-ce que l'utilisateur actuel est le client
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
      .eq('id', contractId.value)
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
      .eq('contract_id', contractId.value)
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

// Soumettre l'évaluation et finaliser le contrat
const submitReview = async () => {
  formError.value = null
  
  // Validation
  if (!formData.value.confirmation) {
    formError.value = 'Veuillez confirmer la finalisation du contrat'
    return
  }
  
  if (formData.value.rating === 0) {
    formError.value = 'Veuillez attribuer une note'
    return
  }
  
  isSubmitting.value = true
  
  try {
    // 1. Mettre à jour le statut du contrat
    const { error: contractError } = await supabase
      .from('contracts')
      .update({
        status: 'completed',
        completed_at: new Date().toISOString()
      })
      .eq('id', contractId.value)
    
    if (contractError) throw contractError
    
    // 2. Créer l'évaluation
    const reviewData = {
      contract_id: contractId.value,
      reviewer_id: user.value.id,
      reviewed_id: isClient.value ? contract.value.expert_id : contract.value.client_id,
      rating: formData.value.rating,
      comment: formData.value.comment,
      recommend: formData.value.recommend,
      work_quality: isClient.value ? formData.value.workQuality : null
    }
    
    const { error: reviewError } = await supabase
      .from('reviews')
      .insert(reviewData)
    
    if (reviewError) throw reviewError
    
    // 3. Mettre à jour la note moyenne de l'expert si l'utilisateur est un client
    if (isClient.value) {
      // Cette partie peut être gérée par un trigger côté serveur dans Supabase
      // ou nous pouvons l'implémenter ici si nécessaire
    }
    
    // Redirection vers la page des contrats avec message de succès
    router.push({
      path: '/account/contracts',
      query: { 
        success: 'completed',
        contract: contractId.value
      }
    })
    
  } catch (err) {
    console.error('Erreur lors de la finalisation du contrat:', err)
    formError.value = err.message || 'Une erreur est survenue lors de la finalisation du contrat'
  } finally {
    isSubmitting.value = false
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

// Initialisation
onMounted(() => {
  fetchContract()
})

definePageMeta({
  layout: 'account'
})
</script>

<style scoped>
/* Animation du survol des étoiles */
.star-hover:hover {
  transform: scale(1.1);
  transition: transform 0.2s ease;
}
</style> 