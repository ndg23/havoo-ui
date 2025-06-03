<template>
  <div class="min-h-screen bg-white dark:bg-black">
    <!-- En-tête style Twitter 2022 -->
    <header class="sticky top-0 z-10 bg-white/90 dark:bg-black/90 backdrop-blur-md border-b border-gray-100 dark:border-gray-800">
      <div class="max-w-5xl mx-auto">
        <div class="px-4 sm:px-6 lg:px-8 py-3 flex items-center justify-between">
          <div class="flex items-center gap-3">
            <UButton
              icon="i-heroicons-arrow-left"
              color="white"
              variant="ghost"
              class="rounded-full h-10 w-10 !p-0"
              to="/requests"
            />
            <h1 class="text-xl font-bold text-black dark:text-white">
              Détails de la mission
            </h1>
          </div>
          
          <div class="flex items-center gap-3">
            <UButton
              v-if="canEdit"
              icon="i-heroicons-pencil-square"
              color="white"
              variant="ghost"
              class="rounded-full h-10 w-10 !p-0"
              @click="showEditModal = true"
            />
            <UButton
              icon="i-heroicons-flag"
              color="white"
              variant="ghost"
              class="rounded-full h-10 w-10 !p-0"
              @click="showReportModal = true"
            />
          </div>
        </div>
      </div>
    </header>

    <main class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
      <!-- Loading state -->
      <div v-if="isLoading" class="flex justify-center py-12">
        <ULoadingSpinner />
      </div>

      <template v-else-if="mission">
        <!-- Statut et informations principales -->
        <div class="bg-white dark:bg-gray-900 rounded-xl border border-gray-200 dark:border-gray-800 overflow-hidden mb-6">
          <div class="px-5 py-4 border-b border-gray-100 dark:border-gray-800 flex items-center justify-between">
            <h2 class="text-lg font-bold text-black dark:text-white">
              Informations générales
            </h2>
            <UBadge
              :label="getStatusLabel(mission.status)"
              :color="getStatusColor(mission.status)"
              variant="subtle"
              :ui="{ rounded: 'rounded-full' }"
            />
          </div>

          <div class="p-5 space-y-4">
            <div>
              <h3 class="text-base font-bold text-black dark:text-white mb-1">
                {{ mission.title }}
              </h3>
              <p class="text-sm text-gray-500 dark:text-gray-400">
                Créée le {{ formatDate(mission.created_at) }}
              </p>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <p class="text-xs font-medium text-gray-500 dark:text-gray-400 mb-1">
                  Catégorie
                </p>
                <p class="text-sm font-medium text-black dark:text-white">
                  {{ mission.category || 'Non spécifiée' }}
                </p>
              </div>
              <div>
                <p class="text-xs font-medium text-gray-500 dark:text-gray-400 mb-1">
                  Budget
                </p>
                <p class="text-sm font-medium text-black dark:text-white">
                  {{ formatBudget(mission.budget) }}
                </p>
              </div>
              <div>
                <p class="text-xs font-medium text-gray-500 dark:text-gray-400 mb-1">
                  Délai
                </p>
                <p class="text-sm font-medium text-black dark:text-white">
                  {{ mission.deadline || 'Non spécifié' }}
                </p>
              </div>
              <div>
                <p class="text-xs font-medium text-gray-500 dark:text-gray-400 mb-1">
                  Localisation
                </p>
                <p class="text-sm font-medium text-black dark:text-white">
                  {{ mission.location || 'Non spécifiée' }}
                </p>
              </div>
            </div>
          </div>
        </div>

        <!-- Description de la mission -->
        <div class="bg-white dark:bg-gray-900 rounded-xl border border-gray-200 dark:border-gray-800 overflow-hidden mb-6">
          <div class="px-5 py-4 border-b border-gray-100 dark:border-gray-800">
            <h2 class="text-lg font-bold text-black dark:text-white">
              Description
            </h2>
          </div>

          <div class="p-5">
            <div class="prose prose-sm dark:prose-invert max-w-none">
              <p v-if="mission.description" class="text-sm text-gray-700 dark:text-gray-300 whitespace-pre-line">
                {{ mission.description }}
              </p>
              <p v-else class="text-sm text-gray-500 dark:text-gray-400 italic">
                Aucune description fournie
              </p>
            </div>
          </div>
        </div>

        <!-- Client -->
        <div v-if="mission.client" class="bg-white dark:bg-gray-900 rounded-xl border border-gray-200 dark:border-gray-800 overflow-hidden">
          <div class="px-5 py-4 border-b border-gray-100 dark:border-gray-800">
            <h2 class="text-lg font-bold text-black dark:text-white">
              Client
            </h2>
          </div>

          <div class="p-5">
            <div class="flex items-center gap-4">
              <div 
                v-if="mission.client.avatar_url"
                class="w-12 h-12 rounded-full bg-cover bg-center"
                :style="{ backgroundImage: `url(${mission.client.avatar_url})` }"
              ></div>
              <div 
                v-else
                class="w-12 h-12 rounded-full bg-gray-200 dark:bg-gray-700 flex items-center justify-center"
              >
                <span class="text-sm font-medium text-gray-600 dark:text-gray-300">
                  {{ getInitials(mission.client.first_name, mission.client.last_name) }}
                </span>
              </div>

              <div>
                <p class="text-sm font-bold text-black dark:text-white">
                  {{ mission.client.first_name }} {{ mission.client.last_name }}
                </p>
                <p class="text-xs text-gray-500 dark:text-gray-400">
                  Membre depuis {{ formatDate(mission.client.created_at) }}
                </p>
                <div class="mt-1 flex items-center gap-2">
                  <UButton
                    size="xs"
                    color="gray"
                    variant="soft"
                    icon="i-heroicons-envelope"
                    label="Contacter"
                    class="rounded-full"
                    :to="`/messages?user=${mission.client.id}`"
                  />
                  <UButton
                    size="xs"
                    color="gray"
                    variant="soft"
                    icon="i-heroicons-user"
                    label="Profil"
                    class="rounded-full"
                    :to="`/users/${mission.client.id}`"
                  />
                </div>
              </div>
            </div>
          </div>
        </div>
      </template>

      <!-- Error state -->
      <div v-else class="text-center py-12">
        <UIcon
          name="i-heroicons-exclamation-circle"
          class="h-12 w-12 text-gray-400 mx-auto mb-4"
        />
        <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-2">
          Mission non trouvée
        </h3>
        <p class="text-gray-500 dark:text-gray-400 mb-4">
          Cette mission n'existe pas ou a été supprimée.
        </p>
        <UButton
          to="/requests"
          color="gray"
          variant="soft"
          label="Retour aux missions"
          class="rounded-full"
        />
      </div>
    </main>

    <!-- Modal de signalement -->
    <UModal v-model="showReportModal">
      <div class="p-6">
        <h3 class="text-lg font-bold text-black dark:text-white mb-4">
          Signaler cette mission
        </h3>
        
        <div v-if="!reportStatus.success">
          <p class="text-sm text-gray-500 dark:text-gray-400 mb-4">
            Veuillez indiquer la raison pour laquelle vous souhaitez signaler cette mission.
          </p>
          
          <div class="space-y-4 mb-4">
            <URadio
              v-model="selectedReason"
              value="inappropriate_content"
              label="Contenu inapproprié"
              help="Cette mission contient du contenu offensant ou inapproprié"
            />
            <URadio
              v-model="selectedReason"
              value="suspicious_mission"
              label="Mission suspecte"
              help="Cette mission semble frauduleuse ou trompeuse"
            />
            <URadio
              v-model="selectedReason"
              value="wrong_category"
              label="Mauvaise catégorie"
              help="Cette mission est publiée dans une catégorie incorrecte"
            />
            <URadio
              v-model="selectedReason"
              value="spam"
              label="Spam"
              help="Cette mission est du spam ou de la publicité non sollicitée"
            />
            <URadio
              v-model="selectedReason"
              value="other"
              label="Autre raison"
              help="Veuillez préciser dans la description"
            />
          </div>
          
          <UTextarea
            v-model="reportDescription"
            label="Description (optionnelle)"
            placeholder="Veuillez fournir plus de détails sur votre signalement..."
            class="mb-4"
          />
          
          <div class="flex justify-end gap-3">
            <UButton
              color="gray"
              variant="soft"
              label="Annuler"
              @click="showReportModal = false"
            />
            <UButton
              color="red"
              label="Signaler"
              :loading="isSubmitting"
              :disabled="!selectedReason"
              @click="handleReport"
            />
          </div>
        </div>
        
        <div v-else class="text-center py-4">
          <UIcon
            name="i-heroicons-check-circle"
            class="h-12 w-12 text-green-500 mx-auto mb-4"
          />
          <h4 class="text-lg font-bold text-black dark:text-white mb-2">
            {{ reportStatus.message }}
          </h4>
          <p class="text-sm text-gray-500 dark:text-gray-400">
            {{ reportStatus.details }}
          </p>
        </div>
      </div>
    </UModal>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
// import { useToast } from '@/composables/useToast'
// import { useSupabase } from '@/composables/useSupabase'
import { 
  ArrowLeft, Loader2, AlertCircle, Calendar, Tag, Heart, 
  MessageSquare, Send, Edit, Check, X, Star as StarIcon, Inbox as InboxIcon, Star 
} from 'lucide-vue-next'
import { Dialog, DialogPanel, DialogTitle, TransitionRoot, TransitionChild } from '@headlessui/vue'

const route = useRoute()
const router = useRouter()
const  supabase  = useSupabaseClient()
// const toast = useToast()

// État
const isLoading = ref(true)
const error = ref(null)
const mission = ref(null)
const proposals = ref([])
const isLiked = ref(false)
const likeCount = ref(0)
const showProposalForm = ref(false)
const isSubmitting = ref(false)
const proposalForm = ref({
  price: '',
  duration: 1,
  message: ''
})

// États pour la notation
const isRatingModalOpen = ref(false)
const isSubmittingRating = ref(false)
const ratingForm = ref({
  overall_rating: 0,
  communication_rating: 0,
  specific_rating: 0,
  would_recommend: null,
  comment: ''
})

// États pour le signalement
const showReportModal = ref(false)
const showEditModal = ref(false)
const selectedReason = ref('')
const reportDescription = ref('')

// Système de notification amélioré
const toast = useToast()

// États de feedback
const reportStatus = ref({
  success: false,
  message: '',
  details: ''
})

// Computed
const proposalCount = computed(() => proposals.value.length)

const statusClasses = computed(() => {
  const classes = {
    'open': 'bg-green-100 text-green-800',
    'assigned': 'bg-blue-100 text-blue-800',
    'completed': 'bg-gray-100 text-gray-800',
    'cancelled': 'bg-red-100 text-red-800'
  }
  return classes[mission.value.status] || 'bg-gray-100 text-gray-800'
})

const statusLabel = computed(() => {
  const labels = {
    'open': 'Ouvert',
    'assigned': 'Assigné',
    'completed': 'Terminé',
    'cancelled': 'Annulé'
  }
  return labels[mission.value.status] || 'Inconnu'
})

const isOwner = computed(() => {
  return user.value?.id === mission.value.client_id
})

const canMakeProposal = computed(() => {
  if (!user.value || isOwner.value || mission.value.status !== 'open') {
    return false
  }

// Vérifier si l'utilisateur est un expert
  return user.value.is_expert
})

// Computed properties pour la notation
const isClient = computed(() => user.value?.id === mission.value?.client_id)
const canRate = computed(() => {
  if (!mission.value || !user.value) return false
  const isParticipant = user.value.id === mission.value.client_id || 
                       user.value.id === mission.value.expert_id
  return mission.value.status === 'completed' && isParticipant
})

// Raisons de signalement spécifiques aux missions
const reportReasons = [
  { value: 'inappropriate_content', label: 'Contenu inapproprié' },
  { value: 'suspicious_mission', label: 'Mission suspecte' },
  { value: 'wrong_category', label: 'Mauvaise catégorie' },
  { value: 'spam', label: 'Spam' },
  { value: 'other', label: 'Autre raison' }
]

// Méthodes
const fetchRequest = async () => {
  try {
    const { data, error: fetchError } = await supabase
      .from('missions')
      .select(`
        *,      
        client:client_id(*),
        category:profession_id(*)
      `)
      .eq('id', route.params.id)
      .single()
    
    if (fetchError) throw fetchError
    
    mission.value = data
  } catch (err) {
    console.error('Error fetching mission:', err)
    error.value = "Impossible de charger cette demande"
  }
}

const fetchProposals = async () => {
  try {
    const { data, error: fetchError } = await supabase
      .from('deals')
      .select(`
        *
      `)
      .eq('mission_id', route.params.id)
      .order('created_at', { ascending: false })
    
    if (fetchError) throw fetchError
    
    // Calculer la note moyenne pour chaque expert
    proposals.value = data.map(proposal => {
      if (proposal.expert && proposal.expert.rating) {
        const ratings = proposal.expert.rating.map(r => r.rating)
        const sum = ratings.reduce((a, b) => a + b, 0)
        proposal.expert.rating = ratings.length > 0 ? sum / ratings.length : 0
        proposal.expert.review_count = ratings.length
      }
      return proposal
    })
  } catch (err) {
    console.error('Error fetching proposals:', err)
  }
}

const scrollToProposals = () => {
  document.getElementById('proposals').scrollIntoView({ behavior: 'smooth' })
}

const editRequest = () => {
  router.push(`/requests/edit/${mission.value.id}`)
}

const submitProposal = async () => {
  if (!user.value) {
    router.push('/login')
    return
  }
  
  isSubmitting.value = true
  
  try {
    const { error: submitError } = await supabase
      .from('deals')
      .insert({
        mission_id: mission.value.id,
        expert_id: user.value.id,
        price: proposalForm.value.price,
        duration: proposalForm.value.duration,
        message: proposalForm.value.message,
        status: 'proposal'
      })
    
    if (submitError) throw submitError
    
    // Réinitialiser le formulaire et fermer la modal
    proposalForm.value = { price: '', duration: 1, message: '' }
    showProposalForm.value = false
    
    // Rafraîchir les propositions
    await fetchProposals()
  } catch (err) {
    console.error('Error submitting proposal:', err)
    alert('Une erreur est survenue lors de l\'envoi de votre proposition')
  } finally {
    isSubmitting.value = false
  }
}

const acceptProposal = async (proposalId) => {
  if (!confirm('Êtes-vous sûr de vouloir accepter cette proposition ?')) return
  
  try {
    // Mettre à jour le statut de la proposition
    const { error: dealError } = await supabase
      .from('deals')
      .update({ status: 'active' })
      .eq('id', proposalId)
    
    if (dealError) throw dealError
    
    // Mettre à jour le statut de la mission
    const { error: missionError } = await supabase
      .from('missions')
      .update({ status: 'assigned' })
      .eq('id', mission.value.id)
    
    if (missionError) throw missionError
    
    // Refuser automatiquement les autres propositions
    const { error: otherDealsError } = await supabase
      .from('deals')
      .update({ status: 'rejected' })
      .eq('mission_id', mission.value.id)
      .neq('id', proposalId)
      .eq('status', 'pending')

    if (otherDealsError) throw otherDealsError
    
    // Rafraîchir les données
    await Promise.all([fetchRequest(), fetchProposals()])
    
    alert('Proposition acceptée avec succès')
  } catch (err) {
    console.error('Error accepting proposal:', err)
    alert('Une erreur est survenue lors de l\'acceptation de la proposition')
  }
}

const rejectProposal = async (proposalId) => {
  if (!confirm('Êtes-vous sûr de vouloir refuser cette proposition ?')) return
  
  try {
    const { error } = await supabase
      .from('deals')
      .update({ status: 'rejected' })
      .eq('id', proposalId)
    
    if (error) throw error
    
    // Rafraîchir les propositions
    await fetchProposals()
    
    alert('Proposition refusée')
  } catch (err) {
    console.error('Error rejecting proposal:', err)
    alert('Une erreur est survenue')
  }
}

const getProposalStatusClasses = (status) => {
  const classes = {
    'pending': 'bg-yellow-100 text-yellow-800',
    'active': 'bg-green-100 text-green-800',
    'rejected': 'bg-red-100 text-red-800'
  }
  return classes[status] || 'bg-gray-100 text-gray-800'
}

const getProposalStatusLabel = (status) => {
  const labels = {
    'pending': 'En attente',
    'active': 'Acceptée',
    'rejected': 'Refusée'
  }
  return labels[status] || 'Inconnu'
}

const formatDate = (dateString) => {
  if (!dateString) return ''
  const date = new Date(dateString)
  return new Intl.DateTimeFormat('fr-FR', {
    day: 'numeric',
    month: 'short',
    year: 'numeric'
  }).format(date)
}

const formatPrice = (price) => {
  if (!price) return 'Prix non défini'
  return new Intl.NumberFormat('fr-FR', {
    style: 'currency',
    currency: 'XOF',
    maximumFractionDigits: 0
  }).format(price)
}

const getInitials = (firstName, lastName) => {
  if (!firstName && !lastName) return '??'
  return `${firstName ? firstName.charAt(0) : ''}${lastName ? lastName.charAt(0) : ''}`.toUpperCase()
}

// Méthodes pour la notation
const openRatingModal = () => {
  isRatingModalOpen.value = true
}

const closeRatingModal = () => {
  isRatingModalOpen.value = false
  ratingForm.value = {
    overall_rating: 0,
    communication_rating: 0,
    specific_rating: 0,
    would_recommend: null,
    comment: ''
  }
}

const submitRating = async () => {
  if (!mission.value?.contract_id) {
    alert('Impossible de noter : contrat non trouvé')
    return
  }

  isSubmittingRating.value = true

  try {
    const ratingData = {
      client_has_rated: isClient.value,
      overall_rating: ratingForm.value.overall_rating,
      communication_rating: ratingForm.value.communication_rating,
      [isClient.value ? 'quality_rating' : 'reliability_rating']: ratingForm.value.specific_rating,
      would_recommend: ratingForm.value.would_recommend,
      comment: ratingForm.value.comment
    }

    const { error } = await supabase.rpc('submit_contract_rating', {
      p_contract_id: mission.value.contract_id,
      p_rating_data: ratingData
    })

    if (error) throw error

    closeRatingModal()
    alert('Évaluation envoyée avec succès')
    
    // Rafraîchir les données de la mission
    await fetchRequest()
  } catch (err) {
    console.error('Error submitting rating:', err)
    alert('Une erreur est survenue lors de l\'envoi de l\'évaluation')
  } finally {
    isSubmittingRating.value = false
  }
}

// Validation du payload de signalement
const validateReportPayload = (payload) => {
  const errors = []

  // Vérification des champs requis
  if (!payload.report_type) errors.push('Type de signalement manquant')
  if (!payload.reported_mission_id) errors.push('ID de mission manquant')
  if (!payload.reason) errors.push('Raison du signalement manquante')

  // Validation du type
  if (payload.report_type !== 'mission') {
    errors.push('Type de signalement invalide')
  }

  // Validation de la raison
  const validReasons = [
    'inappropriate_content',
    'suspicious_mission',
    'wrong_category',
    'spam',
    'other'
  ]
  if (!validReasons.includes(payload.reason)) {
    errors.push('Raison invalide')
  }

  return {
    isValid: errors.length === 0,
    errors
  }
}

// Gestion du signalement avec validation
const handleReport = async () => {
  if (!selectedReason.value) return

  try {
    isSubmitting.value = true

    // Construction du payload
    const reportPayload = {
      report_type: 'mission',
      reported_mission_id: route.params.id,
      reason: selectedReason.value,
      description: reportDescription.value,
      status: 'pending'
    }

    // Validation du payload
    const { isValid, errors } = validateReportPayload(reportPayload)
    
    if (!isValid) {
      throw new Error(`Validation échouée: ${errors.join(', ')}`)
    }

    // Envoi du signalement
    const { data, error } = await supabase
      .from('reports')
      .insert(reportPayload)
      .select('id')
      .single()

    if (error) {
      if (error.code === '23505') { // Code d'erreur pour violation d'unicité
        throw new Error('Vous avez déjà signalé cette mission')
      }
      throw error
    }

    // Mise à jour du statut de succès
    reportStatus.value = {
      success: true,
      message: 'Signalement envoyé avec succès',
      details: `Référence: #${data.id.slice(0, 8)}`
    }

    // Notification de succès
    toast.add({
      title: 'Signalement envoyé',
      description: 'Nous examinerons votre signalement dans les plus brefs délais.',
      icon: 'i-heroicons-check-circle',
      color: 'green',
      timeout: 5000
    })

    // Fermeture différée de la modal
    setTimeout(() => {
      showReportModal.value = false
      // Réinitialisation après fermeture
      setTimeout(() => {
        selectedReason.value = ''
        reportDescription.value = ''
        reportStatus.value = { success: false, message: '', details: '' }
      }, 300)
    }, 2000)

  } catch (error) {
    console.error('Erreur lors du signalement:', error)
    
    // Mise à jour du statut d'erreur
    reportStatus.value = {
      success: false,
      message: 'Erreur lors du signalement',
      details: error.message
    }

    // Notification d'erreur
    toast.add({
      title: 'Erreur',
      description: error.message || 'Impossible d\'envoyer le signalement. Veuillez réessayer.',
      icon: 'i-heroicons-exclamation-circle',
      color: 'red',
      timeout: 5000
    })
  } finally {
    isSubmitting.value = false
  }
}

// Initialisation
onMounted(async () => {
  try {
    await Promise.all([
      fetchRequest(),
      fetchProposals(),
    ])
  } catch (err) {
    console.error('Error during initialization:', err)
  } finally {
    isLoading.value = false
  }
})

definePageMeta({
  layout: 'default'
})

// Helpers pour le formatage
const getStatusColor = (status) => {
  switch (status) {
    case 'pending': return 'yellow'
    case 'in_progress': return 'blue'
    case 'completed': return 'green'
    case 'cancelled': return 'red'
    default: return 'gray'
  }
}

const getStatusLabel = (status) => {
  const labels = {
    pending: 'En attente',
    in_progress: 'En cours',
    completed: 'Terminée',
    cancelled: 'Annulée'
  }
  return labels[status] || status
}

const formatBudget = (budget) => {
  if (!budget) return 'Non spécifié'
  return new Intl.NumberFormat('fr-FR', { 
    style: 'currency', 
    currency: 'EUR' 
  }).format(budget)
}
</script>

<style scoped>
.prose {
  max-width: 65ch;
  color: inherit;
}

.animate-fade-in {
  animation: fadeIn 0.3s ease-in-out;
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(-10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
</style> 