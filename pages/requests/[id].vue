<template>
  <div class="min-h-screen bg-white dark:bg-gray-900">
    <!-- Header: More minimal, with subtle backdrop blur -->
    <header class="sticky top-0 z-10 bg-white/80 dark:bg-gray-900/80 backdrop-blur-md">
      <div class="max-w-2xl mx-auto px-6 py-4 flex items-center">
        <NuxtLink 
          to="/requests" 
          class="p-2 -ml-2 rounded-full text-gray-500 dark:text-gray-400 hover:text-gray-900 dark:hover:text-white transition-colors"
        >
          <ArrowLeft class="w-5 h-5" />
        </NuxtLink>
        <h1 class="ml-4 text-xl font-medium text-gray-900 dark:text-white">
          Détail de la mission
        </h1>
      </div>
    </header>

    <!-- Main content -->
    <main class="max-w-2xl mx-auto px-6 py-8">
      <!-- Loading state -->
      <div v-if="isLoading" class="flex flex-col items-center justify-center py-12">
        <Loader2 class="h-8 w-8 text-gray-300 animate-spin" />
      </div>

      <!-- Error state -->
      <div 
        v-else-if="error" 
        class="p-4 rounded-2xl bg-red-50 dark:bg-red-900/10 text-red-600 dark:text-red-400"
      >
        <div class="flex items-center gap-3">
          <AlertCircle class="h-5 w-5" />
          <p>{{ error }}</p>
        </div>
      </div>

      <!-- Mission details -->
      <div v-else class="space-y-8">
        <!-- Mission header -->
        <div class="space-y-4">
          <div class="flex items-start justify-between gap-4">
            <h2 class="text-2xl font-medium text-gray-900 dark:text-white">
              {{ mission.title }}
            </h2>
            <div class="text-right">
              <div class="text-lg font-medium text-primary-600 dark:text-primary-400">
                {{ formatPrice(mission.budget) }}
              </div>
              <div v-if="mission.deadline" class="text-sm text-gray-500 dark:text-gray-400">
                Deadline: {{ formatDate(mission.deadline) }}
              </div>
            </div>
          </div>

          <div class="flex flex-wrap gap-3">
            <span class="inline-flex items-center px-3 py-1 rounded-full text-sm
                       bg-gray-100 dark:bg-gray-800 
                       text-gray-600 dark:text-gray-300">
              <Calendar class="h-4 w-4 mr-1.5" />
              {{ formatDate(mission.created_at) }}
            </span>
            <span class="inline-flex items-center px-3 py-1 rounded-full text-sm
                       bg-gray-100 dark:bg-gray-800 
                       text-gray-600 dark:text-gray-300">
              <Tag class="h-4 w-4 mr-1.5" />
              {{ mission.category?.name || 'Non catégorisé' }}
            </span>
            <span 
              class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium"
              :class="statusClasses"
            >
              {{ statusLabel }}
            </span>
          </div>
        </div>

        <!-- Client info -->
        <div class="flex items-center p-4 rounded-2xl bg-gray-50 dark:bg-gray-800/50">
          <div class="flex-shrink-0">
            <img 
              v-if="mission.client?.avatar_url" 
              :src="mission.client.avatar_url" 
              alt="Client" 
              class="h-12 w-12 rounded-full object-cover"
            />
            <div 
              v-else 
              class="h-12 w-12 rounded-full bg-primary-100 dark:bg-primary-900/20 
                     flex items-center justify-center 
                     text-primary-600 dark:text-primary-400 text-lg font-medium"
            >
              {{ getInitials(mission.client?.first_name, mission.client?.last_name) }}
            </div>
          </div>
          <div class="ml-4">
            <p class="text-base font-medium text-gray-900 dark:text-white">
              {{ mission.client?.first_name }} {{ mission.client?.last_name }}
            </p>
            <p class="text-sm text-gray-500 dark:text-gray-400">Client</p>
          </div>
        </div>

        <!-- Description -->
        <div class="space-y-3">
          <h3 class="text-lg font-medium text-gray-900 dark:text-white">Description</h3>
          <div class="prose prose-gray dark:prose-invert max-w-none">
            {{ mission.description }}
          </div>
        </div>

        <!-- Action buttons -->
        <div class="flex items-center justify-between pt-6">
          <div class="flex gap-3">
            <button 
              @click="toggleLike"
              class="inline-flex items-center px-4 py-2 rounded-full text-sm
                     bg-gray-100 dark:bg-gray-800 
                     text-gray-700 dark:text-gray-300
                     hover:bg-gray-200 dark:hover:bg-gray-700
                     transition-colors"
            >
              <Heart 
                :class="[
                  'h-4 w-4 mr-1.5',
                  isLiked ? 'text-red-500 fill-current' : ''
                ]" 
              />
              {{ likeCount }}
            </button>
            
            <button 
              @click="scrollToProposals"
              class="inline-flex items-center px-4 py-2 rounded-full text-sm
                     bg-gray-100 dark:bg-gray-800 
                     text-gray-700 dark:text-gray-300
                     hover:bg-gray-200 dark:hover:bg-gray-700
                     transition-colors"
            >
              <MessageSquare class="h-4 w-4 mr-1.5" />
              {{ proposalCount }} Propositions
            </button>
          </div>
          
          <div>
            <NuxtLink 
              v-if="canMakeProposal"
              :to="`/proposals/new?id=${mission.id}`"
              class="inline-flex items-center px-6 py-2.5 rounded-full text-sm font-medium
                     bg-gray-900 dark:bg-white
                     text-white dark:text-gray-900
                     hover:bg-gray-800 dark:hover:bg-gray-100
                     transition-colors"
            >
              <Send class="h-4 w-4 mr-1.5" />
              Faire une proposition
            </NuxtLink>
            
            <button 
              v-else-if="isOwner"
              @click="editRequest"
              class="inline-flex items-center px-4 py-2 rounded-full text-sm
                     bg-gray-100 dark:bg-gray-800 
                     text-gray-700 dark:text-gray-300
                     hover:bg-gray-200 dark:hover:bg-gray-700
                     transition-colors"
            >
              <Edit class="h-4 w-4 mr-1.5" />
              Modifier
            </button>
          </div>
        </div>

        <!-- Proposals section -->
        <div class="mt-12 space-y-6">
          <h2 class="text-lg font-medium text-gray-900 dark:text-white flex items-center gap-2">
            <MessageSquare class="h-5 w-5" />
            Propositions ({{ proposals.length }})
          </h2>

          <!-- Proposals list -->
          <div class="space-y-4">
            <div 
              v-for="proposal in proposals" 
              :key="proposal.id"
              class="p-4 rounded-2xl bg-gray-50 dark:bg-gray-800/50 space-y-4"
            >
              <!-- Expert info -->
              <div class="flex items-center justify-between">
                <div class="flex items-center gap-3">
                  <div 
                    v-if="proposal.expert?.avatar_url"
                    class="h-10 w-10 rounded-full bg-cover bg-center"
                    :style="{ backgroundImage: `url(${proposal.expert.avatar_url})` }"
                  ></div>
                  <div 
                    v-else
                    class="h-10 w-10 rounded-full bg-primary-100 dark:bg-primary-900/20 
                           flex items-center justify-center 
                           text-primary-600 dark:text-primary-400 font-medium"
                  >
                    {{ getInitials(proposal.expert?.first_name, proposal.expert?.last_name) }}
                  </div>
                  <div>
                    <div class="flex items-center gap-2">
                      <p class="font-medium text-gray-900 dark:text-white">
                        {{ proposal.expert?.first_name }} {{ proposal.expert?.last_name }}
                      </p>
                      <span 
                        class="px-2 py-0.5 rounded-full text-xs font-medium"
                        :class="getProposalStatusClasses(proposal.status)"
                      >
                        {{ getProposalStatusLabel(proposal.status) }}
                      </span>
                    </div>
                    <p class="text-sm text-gray-500 dark:text-gray-400">
                      {{ formatDate(proposal.created_at) }}
                    </p>
                  </div>
                </div>
              </div>

              <!-- Proposal details -->
              <div class="grid grid-cols-2 gap-4">
                <div class="p-3 rounded-xl bg-white dark:bg-gray-800">
                  <div class="text-sm text-gray-500 dark:text-gray-400">Prix proposé</div>
                  <div class="font-medium text-gray-900 dark:text-white">
                    {{ formatPrice(proposal.price) }}
                  </div>
                </div>
                <div class="p-3 rounded-xl bg-white dark:bg-gray-800">
                  <div class="text-sm text-gray-500 dark:text-gray-400">Durée estimée</div>
                  <div class="font-medium text-gray-900 dark:text-white">
                    {{ proposal.duration }} jour{{ proposal.duration > 1 ? 's' : '' }}
                  </div>
                </div>
              </div>

              <!-- Message -->
              <p class="text-gray-600 dark:text-gray-300">
                {{ proposal.message }}
              </p>

              <!-- Actions -->
              <div 
                v-if="isOwner && proposal.status === 'pending'"
                class="flex gap-3 pt-4 border-t border-gray-200 dark:border-gray-700"
              >
                <button
                  @click="acceptProposal(proposal.id)"
                  class="flex-1 px-4 py-2 rounded-xl text-sm font-medium
                         bg-gray-900 dark:bg-white
                         text-white dark:text-gray-900
                         hover:bg-gray-800 dark:hover:bg-gray-100
                         transition-colors"
                >
                  <Check class="h-4 w-4 mr-1.5" />
                  Accepter
                </button>
                <button
                  @click="rejectProposal(proposal.id)"
                  class="flex-1 px-4 py-2 rounded-xl text-sm font-medium
                         bg-gray-100 dark:bg-gray-800
                         text-gray-700 dark:text-gray-300
                         hover:bg-gray-200 dark:hover:bg-gray-700
                         transition-colors"
                >
                  <X class="h-4 w-4 mr-1.5" />
                  Refuser
                </button>
              </div>
            </div>

            <!-- Empty state -->
            <div 
              v-if="proposals.length === 0"
              class="py-12 text-center text-gray-500 dark:text-gray-400"
            >
              <InboxIcon class="h-12 w-12 mx-auto mb-3" />
              <p>Aucune proposition reçue pour le moment</p>
            </div>
          </div>
        </div>

        <!-- Ajouter avant la fin de la section principale -->
        <div class="mt-4 border-t border-gray-100 dark:border-gray-800 pt-4">
          <button
            @click="showReportModal = true"
            class="w-full inline-flex items-center justify-center px-4 py-3 rounded-xl 
                   bg-gray-50 hover:bg-gray-100 dark:bg-gray-800 dark:hover:bg-gray-700
                   text-red-600 dark:text-red-400 font-medium transition-all"
          >
            <UIcon name="i-heroicons-flag" class="h-5 w-5 mr-2" />
            Signaler cette mission
          </button>
        </div>
      </div>
    </main>

    <!-- Modal de signalement mise à jour -->
    <UModal v-model="showReportModal">
      <div class="bg-white dark:bg-gray-800 rounded-2xl p-6 max-w-lg w-full">
        <!-- En-tête de la modal -->
        <div class="text-center mb-6">
          <div 
            class="mx-auto w-12 h-12 rounded-full flex items-center justify-center mb-4"
            :class="{
              'bg-red-50 dark:bg-red-900/20': !reportStatus.success,
              'bg-green-50 dark:bg-green-900/20': reportStatus.success
            }"
          >
            <UIcon 
              :name="reportStatus.success ? 'i-heroicons-check-circle' : 'i-heroicons-flag'" 
              class="h-6 w-6"
              :class="{
                'text-red-600': !reportStatus.success,
                'text-green-600': reportStatus.success
              }"
            />
          </div>
          <h3 class="text-lg font-semibold text-gray-900 dark:text-white">
            {{ reportStatus.success ? reportStatus.message : 'Signaler cette mission' }}
          </h3>
          <p 
            v-if="reportStatus.details" 
            class="mt-2 text-sm"
            :class="{
              'text-gray-600 dark:text-gray-400': !reportStatus.success,
              'text-green-600 dark:text-green-400': reportStatus.success
            }"
          >
            {{ reportStatus.details }}
          </p>
        </div>

        <!-- Formulaire (caché si succès) -->
        <form 
          v-if="!reportStatus.success"
          @submit.prevent="handleReport" 
          class="space-y-4"
        >
          <!-- Raisons du signalement -->
          <div class="space-y-2">
            <label 
              v-for="reason in reportReasons" 
              :key="reason.value"
              class="flex items-center p-3 rounded-xl border border-gray-200 dark:border-gray-700
                     cursor-pointer hover:bg-gray-50 dark:hover:bg-gray-700/50 transition-colors"
            >
              <input
                type="radio"
                name="reportReason"
                :value="reason.value"
                v-model="selectedReason"
                class="w-4 h-4 text-primary-600 border-gray-300 focus:ring-primary-500"
              />
              <span class="ml-3 text-gray-900 dark:text-white">{{ reason.label }}</span>
            </label>
          </div>

          <!-- Description -->
          <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
              Description détaillée (optionnelle)
            </label>
            <textarea
              v-model="reportDescription"
              rows="3"
              class="w-full px-4 py-3 rounded-xl border border-gray-200 dark:border-gray-700
                     bg-white dark:bg-gray-800 text-gray-900 dark:text-white
                     focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
              placeholder="Décrivez le problème..."
            ></textarea>
          </div>

          <!-- Boutons d'action avec états de chargement -->
          <div class="flex gap-3 mt-6">
            <button
              type="button"
              @click="showReportModal = false"
              :disabled="isSubmitting"
              class="flex-1 px-4 py-3 rounded-xl border border-gray-200 dark:border-gray-700
                     text-gray-700 dark:text-gray-300 font-medium
                     hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors
                     disabled:opacity-50 disabled:cursor-not-allowed"
            >
              Annuler
            </button>
            <button
              type="submit"
              :disabled="!selectedReason || isSubmitting"
              class="flex-1 px-4 py-3 rounded-xl bg-red-600 hover:bg-red-700
                     text-white font-medium transition-colors 
                     disabled:opacity-50 disabled:cursor-not-allowed
                     focus:outline-none focus:ring-2 focus:ring-red-500 focus:ring-offset-2"
            >
              <span v-if="isSubmitting" class="flex items-center justify-center">
                <UIcon name="i-heroicons-arrow-path" class="h-5 w-5 animate-spin mr-2" />
                Envoi...
              </span>
              <span v-else>Signaler</span>
            </button>
          </div>
        </form>

        <!-- Message de succès (affiché uniquement en cas de succès) -->
        <div 
          v-else
          class="text-center text-green-600 dark:text-green-400 animate-fade-in"
        >
          <p class="text-sm mt-2">
            Merci pour votre signalement. Notre équipe va l'examiner rapidement.
          </p>
        </div>
      </div>
    </UModal>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
// import { useSupabaseClient, useSupabaseUser } from '#supabase/client'
import { 
  ArrowLeft, Loader2, AlertCircle, Calendar, Tag, Heart, 
  MessageSquare, Send, Edit, Check, X, Star as StarIcon, Inbox as InboxIcon, Star 
} from 'lucide-vue-next'
import { Dialog, DialogPanel, DialogTitle, TransitionRoot, TransitionChild } from '@headlessui/vue'

const route = useRoute()
const router = useRouter()
const supabase = useSupabaseClient()
const user = useSupabaseUser()

// État
const isLoading = ref(true)
const error = ref(null)
const mission = ref({})
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

const fetchLikes = async () => {
  try {
    // Récupérer le nombre total de likes pour cette demande
    const { data: countData, error: countError } = await supabase
      .rpc('get_mission_likes_count', { mission_id: parseInt(route.params.id) })
    
    if (countError) throw countError
    likeCount.value = countData || 0
    
    // Vérifier si l'utilisateur actuel a liké cette demande
    if (user.value) {
      const { data: hasLiked, error: likeError } = await supabase
        .rpc('has_user_liked_mission', { 
          mission_id: parseInt(route.params.id),
          user_id: user.value.id
        })
      
      if (likeError) throw likeError
      isLiked.value = hasLiked || false
    }
  } catch (err) {
    console.error('Error fetching likes:', err)
  }
}

const toggleLike = async () => {
  if (!user.value) {
    // Rediriger vers la page de connexion si l'utilisateur n'est pas connecté
    router.push('/login')
    return
  }
  
  try {
    if (isLiked.value) {
      // Supprimer le like
      const { error } = await supabase
        .from('mission_likes')
        .delete()
        .eq('mission_id', parseInt(route.params.id))
        .eq('user_id', user.value.id)
      
      if (error) throw error
      
      likeCount.value--
      isLiked.value = false
    } else {
      // Ajouter un like
      const { error } = await supabase
        .from('mission_likes')
        .insert({
          mission_id: parseInt(route.params.id),
          user_id: user.value.id
        })
    
    if (error) throw error
    
      likeCount.value++
      isLiked.value = true
    }
  } catch (err) {
    console.error('Error toggling like:', err)
    // Restaurer l'état précédent en cas d'erreur
    isLiked.value = !isLiked.value
    likeCount.value += isLiked.value ? 1 : -1
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

// Gestion du signalement avec feedback amélioré
const handleReport = async () => {
  if (!selectedReason.value) return

  try {
    isSubmitting.value = true
    
    // Envoi du signalement
    const { data, error } = await supabase
      .from('reports')
      .insert({
        report_type: 'mission',
        reported_mission_id: route.params.id,
        reason: selectedReason.value,
        description: reportDescription.value,
        status: 'pending'
      })
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

    // Fermeture différée de la modal pour montrer le succès
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
      fetchLikes()
    ])
  } catch (err) {
    console.error('Error during initialization:', err)
  } finally {
    isLoading.value = false
  }
})

definePageMeta({
  middleware: ['auth'],
  layout: 'account'
})
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