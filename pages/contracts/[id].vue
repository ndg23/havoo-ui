<template>
  <div class="max-w-3xl mx-auto px-4 pt-5 pb-16">
    <!-- Header avec actions -->
    <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between mb-6">
      <div>
        <div class="flex items-center gap-2">
          <button 
            @click="router.back()" 
            class="p-2 -ml-2 hover:bg-gray-100 dark:hover:bg-gray-800 rounded-full"
          >
            <ArrowLeft class="h-5 w-5 text-gray-600 dark:text-gray-400" />
          </button>
          <h1 class="text-2xl font-bold text-gray-900 dark:text-white">Détails du contrat</h1>
          <div :class="['px-2.5 py-0.5 rounded-full text-xs font-medium', getStatusClass(contract.status)]">
            {{ contract.status }}
          </div>
        </div>
        <p class="text-gray-600 dark:text-gray-400 mt-1">
          Contrat #{{ contract.id.substring(0, 8) }}
        </p>
      </div>
      
      <!-- Actions selon le statut -->
      <div class="mt-4 sm:mt-0 flex gap-2">
        <button 
          v-if="contract.status === 'En cours' && canMarkComplete"
          @click="showCompletionModal = true"
          class="px-4 py-2 bg-green-600 hover:bg-green-700 text-white rounded-full text-sm font-medium"
        >
          Marquer comme terminé
        </button>
        
        <button 
          v-if="contract.status === 'En cours'"
          @click="navigateToMessages"
          class="px-4 py-2 bg-primary-600 hover:bg-primary-700 text-white rounded-full text-sm font-medium"
        >
          Contacter
        </button>
      </div>
    </div>
    
    <!-- Résumé du contrat -->
    <div class="bg-white dark:bg-gray-800 rounded-xl p-5 border border-gray-200 dark:border-gray-700 shadow-sm mb-6">
      <h2 class="text-xl font-bold text-gray-900 dark:text-white mb-4">
        {{ contract.title }}
      </h2>
      
      <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
        <div>
          <p class="text-sm text-gray-500 dark:text-gray-400">Client</p>
          <div class="flex items-center mt-1">
            <img 
              :src="contract.client.avatar_url || '/img/default-avatar.png'" 
              alt="Client" 
              class="w-8 h-8 rounded-full mr-2 object-cover"
            />
            <span class="font-medium text-gray-900 dark:text-white">
              {{ contract.client.first_name }} {{ contract.client.last_name }}
            </span>
          </div>
        </div>
        
        <div>
          <p class="text-sm text-gray-500 dark:text-gray-400">Expert</p>
          <div class="flex items-center mt-1">
            <img 
              :src="contract.expert.avatar_url || '/img/default-avatar.png'" 
              alt="Expert" 
              class="w-8 h-8 rounded-full mr-2 object-cover"
            />
            <div>
              <span class="font-medium text-gray-900 dark:text-white flex items-center">
                {{ contract.expert.first_name }} {{ contract.expert.last_name }}
                <div v-if="contract.expert.is_verified" class="ml-1 text-blue-500">
                  <CheckCircle class="h-4 w-4" />
                </div>
              </span>
              <span class="text-sm text-primary-600 dark:text-primary-400">
                {{ contract.expert.specialty }}
              </span>
            </div>
          </div>
        </div>
        
        <div>
          <p class="text-sm text-gray-500 dark:text-gray-400">Montant</p>
          <p class="text-lg font-bold text-primary-600 dark:text-primary-400 mt-1">
            {{ formatPrice(contract.amount) }} FCFA
          </p>
        </div>
        
        <div>
          <p class="text-sm text-gray-500 dark:text-gray-400">Période</p>
          <p class="text-gray-900 dark:text-white mt-1">
            {{ formatDate(contract.start_date) }} - {{ formatDate(contract.due_date) }}
          </p>
        </div>
      </div>
      
      <div v-if="contract.description" class="mt-4 border-t border-gray-100 dark:border-gray-700 pt-4">
        <p class="text-sm text-gray-500 dark:text-gray-400 mb-2">Description</p>
        <p class="text-gray-800 dark:text-gray-200 whitespace-pre-line">
          {{ contract.description }}
        </p>
      </div>
    </div>
    
    <!-- Livrables -->
    <div class="bg-white dark:bg-gray-800 rounded-xl p-5 border border-gray-200 dark:border-gray-700 shadow-sm mb-6">
      <h2 class="text-lg font-semibold text-gray-900 dark:text-white mb-4">
        Livrables
      </h2>
      
      <div v-if="contract.deliverables && contract.deliverables.length > 0" class="space-y-4">
        <div 
          v-for="(deliverable, index) in contract.deliverables" 
          :key="index"
          class="flex items-start p-3 bg-gray-50 dark:bg-gray-700 rounded-lg"
        >
          <div class="flex-1">
            <div class="flex items-center">
              <h4 class="font-medium text-gray-900 dark:text-white">{{ deliverable.title }}</h4>
              <div v-if="deliverable.is_approved" class="ml-2 bg-green-100 dark:bg-green-900/30 text-green-600 dark:text-green-400 text-xs px-2 py-0.5 rounded-full font-medium">
                Approuvé
              </div>
            </div>
            <p v-if="deliverable.description" class="text-sm text-gray-600 dark:text-gray-300 mt-1">
              {{ deliverable.description }}
            </p>
            <p v-if="deliverable.delivered_at" class="text-xs text-gray-500 dark:text-gray-400 mt-2">
              Livré le {{ formatDate(deliverable.delivered_at) }}
            </p>
          </div>
          
          <a 
            v-if="deliverable.file_url" 
            :href="deliverable.file_url" 
            target="_blank"
            class="px-3 py-1.5 bg-gray-200 dark:bg-gray-600 text-gray-700 dark:text-gray-300 text-sm rounded-lg hover:bg-gray-300 dark:hover:bg-gray-500 transition-colors"
          >
            Télécharger
          </a>
          
          <button 
            v-if="isClient && deliverable.delivered_at && !deliverable.is_approved && contract.status === 'En cours'"
            @click="approveDeliverable(deliverable.id)"
            class="px-3 py-1.5 bg-green-600 hover:bg-green-700 text-white text-sm rounded-lg"
          >
            Approuver
          </button>
        </div>
      </div>
      
      <div v-else class="text-center py-8">
        <Package class="mx-auto h-12 w-12 text-gray-400 dark:text-gray-600 mb-3" />
        <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-2">Aucun livrable</h3>
        <p class="text-gray-600 dark:text-gray-400 max-w-sm mx-auto">
          Les livrables seront ajoutés par l'expert au fur et à mesure de l'avancement du projet.
        </p>
      </div>
    </div>
    
    <!-- Paiements -->
    <div class="bg-white dark:bg-gray-800 rounded-xl p-5 border border-gray-200 dark:border-gray-700 shadow-sm mb-6">
      <h2 class="text-lg font-semibold text-gray-900 dark:text-white mb-4">
        Échéancier de paiement
      </h2>
      
      <div v-if="contract.milestones && contract.milestones.length > 0" class="space-y-4">
        <div 
          v-for="(milestone, index) in contract.milestones" 
          :key="index"
          class="flex justify-between p-3 bg-gray-50 dark:bg-gray-700 rounded-lg"
        >
          <div>
            <div class="flex items-center">
              <h4 class="font-medium text-gray-900 dark:text-white">{{ milestone.title }}</h4>
              <div v-if="milestone.is_paid" class="ml-2 bg-green-100 dark:bg-green-900/30 text-green-600 dark:text-green-400 text-xs px-2 py-0.5 rounded-full font-medium">
                Payé
              </div>
              <div v-else-if="isPastDue(milestone.due_date)" class="ml-2 bg-red-100 dark:bg-red-900/30 text-red-600 dark:text-red-400 text-xs px-2 py-0.5 rounded-full font-medium">
                En retard
              </div>
              <div v-else class="ml-2 bg-amber-100 dark:bg-amber-900/30 text-amber-600 dark:text-amber-400 text-xs px-2 py-0.5 rounded-full font-medium">
                En attente
              </div>
            </div>
            <p v-if="milestone.due_date" class="text-xs text-gray-500 dark:text-gray-400 mt-1">
              Échéance: {{ formatDate(milestone.due_date) }}
            </p>
          </div>
          
          <div class="flex items-center">
            <span class="font-bold text-gray-900 dark:text-white">
              {{ formatPrice(milestone.amount) }} FCFA
            </span>
            <button 
              v-if="isClient && !milestone.is_paid && contract.status === 'En cours'"
              @click="processMilestonePayment(milestone.id)"
              class="ml-3 px-3 py-1.5 bg-primary-600 hover:bg-primary-700 text-white text-sm rounded-lg"
            >
              Payer
            </button>
          </div>
        </div>
      </div>
      
      <div v-else class="text-center py-8">
        <DollarSign class="mx-auto h-12 w-12 text-gray-400 dark:text-gray-600 mb-3" />
        <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-2">Paiement unique</h3>
        <p class="text-gray-600 dark:text-gray-400 max-w-sm mx-auto">
          Ce contrat prévoit un paiement unique à la fin de la prestation.
        </p>
      </div>
    </div>
    
    <!-- Évaluation -->
    <div class="bg-white dark:bg-gray-800 rounded-xl p-5 border border-gray-200 dark:border-gray-700 shadow-sm mb-6">
      <h2 class="text-lg font-semibold text-gray-900 dark:text-white mb-4">
        Évaluation
      </h2>
      
      <!-- Laisser une évaluation -->
      <div v-if="canReview" class="mb-6 border-b border-gray-200 dark:border-gray-700 pb-6">
        <h3 class="text-base font-medium text-gray-900 dark:text-white mb-4">
          Évaluez cette {{ isClient ? 'prestation' : 'collaboration' }}
        </h3>
        
        <div class="space-y-4">
          <div>
            <p class="mb-2 text-sm text-gray-700 dark:text-gray-300">Note</p>
            <div class="flex gap-1">
              <button 
                v-for="star in 5" 
                :key="star"
                @click="reviewData.rating = star"
                class="text-2xl focus:outline-none"
              >
                <Star 
                  :fill="star <= reviewData.rating ? 'currentColor' : 'none'" 
                  :class="star <= reviewData.rating ? 'text-yellow-400' : 'text-gray-300 dark:text-gray-600'" 
                  class="h-8 w-8"
                />
              </button>
            </div>
          </div>
          
          <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
              Commentaire
            </label>
            <textarea 
              v-model="reviewData.comment" 
              rows="4"
              placeholder="Partagez votre expérience..."
              class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
            ></textarea>
          </div>
          
          <button 
            @click="submitReview"
            :disabled="isSubmittingReview || reviewData.rating === 0"
            class="px-4 py-2 bg-primary-600 hover:bg-primary-700 disabled:bg-gray-300 dark:disabled:bg-gray-700 disabled:cursor-not-allowed text-white rounded-lg text-sm font-medium flex items-center"
          >
            <span v-if="isSubmittingReview" class="h-4 w-4 border-2 border-gray-200 border-t-white rounded-full animate-spin mr-2"></span>
            Publier l'évaluation
          </button>
        </div>
      </div>
      
      <!-- Afficher les évaluations existantes -->
      <div v-if="contract.reviews && contract.reviews.length > 0">
        <div 
          v-for="(review, index) in contract.reviews" 
          :key="index"
          class="py-4"
          :class="{ 'border-t border-gray-200 dark:border-gray-700': index > 0 }"
        >
          <div class="flex items-start">
            <img 
              :src="review.user.avatar_url || '/img/default-avatar.png'" 
              alt="Avatar" 
              class="w-10 h-10 rounded-full mr-3 object-cover"
            />
            
            <div class="flex-1">
              <div class="flex items-baseline justify-between">
                <h4 class="font-medium text-gray-900 dark:text-white">
                  {{ review.user.first_name }} {{ review.user.last_name }}
                </h4>
                <span class="text-sm text-gray-500 dark:text-gray-400">
                  {{ formatDate(review.created_at) }}
                </span>
              </div>
              
              <div class="flex items-center mt-1 mb-2">
                <div class="flex">
                  <Star v-for="star in 5" :key="star" 
                    :fill="star <= review.rating ? 'currentColor' : 'none'"
                    :class="star <= review.rating ? 'text-yellow-400' : 'text-gray-300 dark:text-gray-600'"
                    class="h-4 w-4"
                  />
                </div>
                <span class="ml-2 text-sm text-gray-700 dark:text-gray-300">
                  {{ review.rating }}/5
                </span>
              </div>
              
              <p class="text-gray-700 dark:text-gray-300 whitespace-pre-line">
                {{ review.comment }}
              </p>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Aucune évaluation -->
      <div v-else-if="!canReview" class="text-center py-8">
        <Star class="mx-auto h-12 w-12 text-gray-400 dark:text-gray-600 mb-3" />
        <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-2">Aucune évaluation</h3>
        <p class="text-gray-600 dark:text-gray-400 max-w-sm mx-auto">
          {{ contract.status === 'Terminé' ? 
            'Ce contrat est terminé mais n\'a pas encore reçu d\'évaluation.' : 
            'Les évaluations seront disponibles une fois le contrat terminé.' }}
        </p>
      </div>
    </div>
    
    <!-- Modal de confirmation pour marquer comme terminé -->
    <div v-if="showCompletionModal" class="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
      <div class="bg-white dark:bg-gray-800 rounded-xl p-6 max-w-md w-full">
        <h3 class="text-lg font-bold text-gray-900 dark:text-white mb-2">
          Confirmer la fin du contrat
        </h3>
        <p class="text-gray-600 dark:text-gray-400 mb-6">
          Êtes-vous sûr de vouloir marquer ce contrat comme terminé ? Cette action ne peut pas être annulée.
        </p>
        <div class="flex gap-3 justify-end">
          <button 
            @click="showCompletionModal = false"
            class="px-4 py-2 border border-gray-300 dark:border-gray-600 text-gray-700 dark:text-gray-300 rounded-lg hover:bg-gray-50 dark:hover:bg-gray-700"
          >
            Annuler
          </button>
          <button 
            @click="completeContract"
            :disabled="isCompletingContract"
            class="px-4 py-2 bg-primary-600 hover:bg-primary-700 text-white rounded-lg flex items-center"
          >
            <span v-if="isCompletingContract" class="h-4 w-4 border-2 border-gray-200 border-t-white rounded-full animate-spin mr-2"></span>
            Confirmer
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { 
  ArrowLeft, 
  CheckCircle, 
  Star, 
  Package, 
  DollarSign 
} from 'lucide-vue-next'

const router = useRouter()
const route = useRoute()

const contractId = route.params.id
const contract = ref({
  id: 'uuid-123456789',
  title: 'Développement d\'une application mobile',
  description: 'Création d\'une application mobile pour iOS et Android avec les fonctionnalités suivantes: authentification, profil utilisateur, messagerie et notifications push.',
  amount: 1250000,
  start_date: '2023-06-15',
  due_date: '2023-07-30',
  status: 'En cours', // En attente, En cours, Terminé, Annulé
  client: {
    first_name: 'Marie',
    last_name: 'Dubois',
    avatar_url: '/img/avatar-client.jpg'
  },
  expert: {
    first_name: 'Thomas',
    last_name: 'Martin',
    specialty: 'Développeur Mobile',
    is_verified: true,
    avatar_url: '/img/avatar-expert.jpg'
  },
  deliverables: [
    {
      id: 'deliv-1',
      title: 'Maquettes UI/UX',
      description: 'Fichiers Figma avec toutes les maquettes pour iOS et Android',
      delivered_at: '2023-06-25',
      is_approved: true,
      file_url: '#'
    },
    {
      id: 'deliv-2',
      title: 'Version bêta',
      description: 'Premier prototype fonctionnel pour test',
      delivered_at: '2023-07-10',
      is_approved: false,
      file_url: '#'
    }
  ],
  milestones: [
    {
      id: 'mile-1',
      title: 'Acompte initial',
      amount: 500000,
      due_date: '2023-06-15',
      is_paid: true
    },
    {
      id: 'mile-2',
      title: 'Livraison des maquettes',
      amount: 375000,
      due_date: '2023-06-25',
      is_paid: true
    },
    {
      id: 'mile-3',
      title: 'Solde final',
      amount: 375000,
      due_date: '2023-07-30',
      is_paid: false
    }
  ],
  reviews: []
})

// États locaux
const isClient = ref(true) // À remplacer par la vérification réelle
const reviewData = ref({
  rating: 0,
  comment: ''
})
const isSubmittingReview = ref(false)
const showCompletionModal = ref(false)
const isCompletingContract = ref(false)

// Computed properties
const canReview = computed(() => {
  const userHasReviewed = contract.value.reviews?.some(r => 
    (isClient.value && r.user.id === contract.value.client.id) ||
    (!isClient.value && r.user.id === contract.value.expert.id)
  )
  return contract.value.status === 'Terminé' && !userHasReviewed
})

const canMarkComplete = computed(() => {
  // Le client peut marquer comme terminé si tous les livrables sont approuvés
  if (isClient.value) {
    return contract.value.deliverables?.every(d => d.is_approved)
  }
  // L'expert peut marquer comme terminé si tous les paiements sont effectués
  return !isClient.value && contract.value.milestones?.every(m => m.is_paid)
})

// Méthodes
const fetchContract = async () => {
  try {
    // Dans un environnement réel, nous chargerions le contrat depuis Supabase
    /*
    const { data, error } = await supabase
      .from('contracts')
      .select(`
        *,
        client:client_id(id, first_name, last_name, avatar_url),
        expert:expert_id(id, first_name, last_name, specialty, is_verified, avatar_url),
        deliverables(*),
        milestones(*),
        reviews(*, user:user_id(id, first_name, last_name, avatar_url))
      `)
      .eq('id', contractId)
      .single()
    
    if (error) throw error
    contract.value = data
    */
    
    // Simuler un délai de chargement
    await new Promise(resolve => setTimeout(resolve, 500))
  } catch (error) {
    console.error('Erreur lors du chargement du contrat:', error)
  }
}

const formatDate = (dateString) => {
  if (!dateString) return ''
  const date = new Date(dateString)
  return date.toLocaleDateString('fr-FR', { day: 'numeric', month: 'long', year: 'numeric' })
}

const formatPrice = (price) => {
  return price.toString().replace(/\B(?=(\d{3})+(?!\d))/g, " ")
}

const isPastDue = (dateString) => {
  if (!dateString) return false
  const dueDate = new Date(dateString)
  const today = new Date()
  return dueDate < today
}

const getStatusClass = (status) => {
  switch (status) {
    case 'En cours':
      return 'bg-blue-100 text-blue-800 dark:bg-blue-900/30 dark:text-blue-400'
    case 'En attente':
      return 'bg-amber-100 text-amber-800 dark:bg-amber-900/30 dark:text-amber-400'
    case 'Terminé':
      return 'bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-400'
    case 'Annulé':
      return 'bg-red-100 text-red-800 dark:bg-red-900/30 dark:text-red-400'
    default:
      return 'bg-gray-100 text-gray-800 dark:bg-gray-800 dark:text-gray-400'
  }
}

const approveDeliverable = async (deliverableId) => {
  try {
    // Dans un environnement réel, nous mettrions à jour le livrable dans Supabase
    /*
    const { error } = await supabase
      .from('deliverables')
      .update({ 
        is_approved: true,
        approved_at: new Date()
      })
      .eq('id', deliverableId)
    
    if (error) throw error
    */
    
    // Mettre à jour l'état local
    const deliverableIndex = contract.value.deliverables.findIndex(d => d.id === deliverableId)
    if (deliverableIndex !== -1) {
      contract.value.deliverables[deliverableIndex].is_approved = true
    }
    
    // Recharger les données pour rafraîchir les autres informations
    await fetchContract()
  } catch (error) {
    console.error('Erreur lors de l\'approbation du livrable:', error)
  }
}

const processMilestonePayment = async (milestoneId) => {
  try {
    // Dans un environnement réel, nous mettrions à jour le paiement dans Supabase
    /*
    const { error } = await supabase
      .from('milestones')
      .update({ 
        is_paid: true,
        paid_at: new Date()
      })
      .eq('id', milestoneId)
    
    if (error) throw error
    */
    
    // Mettre à jour l'état local
    const milestoneIndex = contract.value.milestones.findIndex(m => m.id === milestoneId)
    if (milestoneIndex !== -1) {
      contract.value.milestones[milestoneIndex].is_paid = true
    }
    
    // Recharger les données pour rafraîchir les autres informations
    await fetchContract()
  } catch (error) {
    console.error('Erreur lors du traitement du paiement:', error)
  }
}

const submitReview = async () => {
  if (reviewData.value.rating === 0) return
  
  isSubmittingReview.value = true
  
  try {
    // Dans un environnement réel, nous sauvegarderions l'évaluation dans Supabase
    /*
    const { error } = await supabase
      .from('reviews')
      .insert({
        contract_id: contractId,
        user_id: auth.user().id,
        rating: reviewData.value.rating,
        comment: reviewData.value.comment,
        created_at: new Date()
      })
    
    if (error) throw error
    */
    
    // Simuler un délai de traitement
    await new Promise(resolve => setTimeout(resolve, 1000))
    
    // Ajouter l'évaluation au niveau local
    contract.value.reviews.push({
      rating: reviewData.value.rating,
      comment: reviewData.value.comment,
      created_at: new Date().toISOString(),
      user: isClient.value ? contract.value.client : contract.value.expert
    })
    
    // Réinitialiser le formulaire
    reviewData.value = { rating: 0, comment: '' }
  } catch (error) {
    console.error('Erreur lors de la publication de l\'évaluation:', error)
  } finally {
    isSubmittingReview.value = false
  }
}

const completeContract = async () => {
  isCompletingContract.value = true
  
  try {
    // Dans un environnement réel, nous mettrions à jour le contrat dans Supabase
    /*
    const { error } = await supabase
      .from('contracts')
      .update({ 
        status: 'Terminé',
        updated_at: new Date()
      })
      .eq('id', contractId)
    
    if (error) throw error
    */
    
    // Simuler un délai de traitement
    await new Promise(resolve => setTimeout(resolve, 1500))
    
    // Mettre à jour l'état local
    contract.value.status = 'Terminé'
    showCompletionModal.value = false
  } catch (error) {
    console.error('Erreur lors de la finalisation du contrat:', error)
  } finally {
    isCompletingContract.value = false
  }
}

const navigateToMessages = () => {
  router.push(`/messages?contract=${contractId}`)
}

// Initialisation
onMounted(() => {
  fetchContract()
})

definePageMeta({
  layout: 'default'
})
</script>

<style scoped>
/* Style pour l'animation des étoiles */
.text-2xl {
  transition: transform 0.1s ease-in-out;
}
.text-2xl:hover {
  transform: scale(1.1);
}
</style> 