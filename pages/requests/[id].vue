<template>
  <div class="min-h-screen bg-white">
    <!-- Header fixe avec fond blanc -->
    <header class="sticky top-0 z-10 bg-white/95 backdrop-blur border-b border-gray-100">
      <div class="max-w-3xl mx-auto px-4 py-3 flex items-center justify-between">
        <div class="flex items-center gap-3">
          <NuxtLink 
            to="/requests" 
            class="p-2 -ml-2 rounded-full hover:bg-gray-50 transition-colors"
          >
            <UIcon name="i-heroicons-arrow-left" class="w-5 h-5 text-gray-700" />
          </NuxtLink>
          <h1 class="text-xl font-bold text-gray-900">Mission</h1>
        </div>
        
        <!-- Actions rapides -->
        <div class="flex items-center gap-2">
          <UButton
            v-if="canMakeProposal"
            color="black"
            class="rounded-full"
            @click="showApplyModal = true"
          >
            Proposer
          </UButton>
          
          <UDropdown
            v-if="isOwner"
            :items="ownerActions"
            :popper="{ placement: 'bottom-end' }"
          >
            <UButton
              color="white"
              variant="ghost"
              icon="i-heroicons-ellipsis-horizontal"
              class="rounded-full hover:bg-gray-50"
            />
          </UDropdown>
        </div>
      </div>
    </header>

    <!-- Contenu principal -->
    <main class="max-w-3xl mx-auto px-4 pb-20">
      <!-- État de chargement -->
      <div v-if="isLoading" class="py-20 text-center">
        <UIcon name="i-heroicons-arrow-path" class="w-8 h-8 mx-auto animate-spin text-gray-400" />
      </div>

      <template v-else>
        <!-- En-tête de la mission -->
        <div class="py-6">
          <div class="flex items-center gap-3 mb-4">
            <UAvatar
              :src="mission.client?.avatar_url"
              :alt="mission.client?.first_name"
              size="md"
            />
            <div>
              <div class="font-medium text-gray-900">
                {{ mission.client?.first_name }} {{ mission.client?.last_name }}
              </div>
              <div class="text-sm text-gray-500">
                {{ formatDate(mission.created_at) }}
              </div>
            </div>
          </div>

          <h2 class="text-2xl font-bold text-gray-900 mb-3">
            {{ mission.title }}
          </h2>

          <p class="text-gray-600 text-lg mb-4 whitespace-pre-wrap">
            {{ mission.description }}
          </p>

          <!-- Métadonnées -->
          <div class="flex flex-wrap gap-3 mb-6">
            <UBadge
              :color="getStatusColor(mission.status)"
              :label="getStatusLabel(mission.status)"
              variant="subtle"
              class="rounded-full text-sm"
            />
            <span class="inline-flex items-center px-3 py-1 rounded-full text-sm bg-gray-100 text-gray-700">
              {{ formatPrice(mission.budget) }}
            </span>
            <span class="inline-flex items-center px-3 py-1 rounded-full text-sm bg-gray-100 text-gray-700">
              <UIcon name="i-heroicons-calendar" class="w-4 h-4 mr-1" />
              {{ formatDate(mission.deadline) }}
            </span>
          </div>

          <!-- Actions et engagement -->
          <div class="flex items-center justify-between py-4 border-t border-b border-gray-100">
            <div class="flex items-center -ml-3">
              <button 
                @click="scrollToProposals"
                class="flex items-center gap-2 px-4 py-2 hover:bg-gray-50 rounded-full transition-colors"
              >
                <span class="font-bold text-gray-900">{{ proposalCount }}</span>
                <span class="text-gray-500">Propositions</span>
              </button>

              <button class="flex items-center gap-2 px-4 py-2 hover:bg-gray-50 rounded-full transition-colors">
                <span class="font-bold text-gray-900">{{ mission.views || 0 }}</span>
                <span class="text-gray-500">Vues</span>
              </button>
            </div>

            <button 
              v-if="!isOwner"
              @click="showReportModal = true"
              class="flex items-center gap-1 px-4 py-2 text-red-500 hover:bg-red-50 rounded-full transition-colors"
            >
              <UIcon name="i-heroicons-flag" class="w-5 h-5" />
              <span>Signaler</span>
            </button>
          </div>
        </div>

        <!-- Liste des propositions -->
        <div class="space-y-4">
          <h3 class="text-xl font-bold text-gray-900 flex items-center gap-2">
            Propositions
            <UBadge
              :label="proposalCount.toString()"
              variant="subtle"
              class="rounded-full"
            />
          </h3>

          <div 
            v-for="proposal in proposals" 
            :key="proposal.id"
            class="bg-white border border-gray-200 rounded-2xl p-4 hover:border-gray-300 transition-colors"
          >
            <!-- Expert info -->
            <div class="flex items-center justify-between mb-3">
              <div class="flex items-center gap-3">
                <UAvatar
                  :src="proposal.expert?.avatar_url"
                  :alt="proposal.expert?.first_name"
                  size="sm"
                />
                <div>
                  <div class="font-medium text-gray-900">
                    {{ proposal.expert?.first_name }} {{ proposal.expert?.last_name }}
                  </div>
                  <div class="text-sm text-gray-500">
                    {{ formatDate(proposal.created_at) }}
                  </div>
                </div>
              </div>
              <UBadge
                :color="getProposalStatusColor(proposal.status)"
                :label="getProposalStatusLabel(proposal.status)"
                variant="subtle"
                class="rounded-full"
              />
            </div>

            <!-- Détails -->
            <div class="grid grid-cols-2 gap-4 mb-3">
              <div>
                <div class="text-sm text-gray-500">Prix proposé</div>
                <div class="font-bold text-gray-900">
                  {{ formatPrice(proposal.price) }}
                </div>
              </div>
              <div>
                <div class="text-sm text-gray-500">Durée estimée</div>
                <div class="font-bold text-gray-900">
                  {{ proposal.duration }} {{ getDurationLabel(proposal.duration_unit) }}
                </div>
              </div>
            </div>

            <!-- Message -->
            <p class="text-gray-600 mb-4">{{ proposal.message }}</p>

            <!-- Actions (pour le client) -->
            <div 
              v-if="isOwner && proposal.status === 'proposal'"
              class="flex gap-2 pt-3 border-t border-gray-100"
            >
              <UButton
                color="black"
                block
                @click="acceptProposal(proposal.id)"
              >
                Accepter
              </UButton>
              <UButton
                color="white"
                variant="outline"
                block
                @click="rejectProposal(proposal.id)"
              >
                Refuser
              </UButton>
            </div>
          </div>
        </div>
      </template>
    </main>

    <!-- Bouton d'action flottant pour mobile -->
    <div 
      v-if="canMakeProposal"
      class="fixed bottom-6 right-6 md:hidden"
    >
      <UButton
        color="black"
        size="xl"
        class="rounded-full shadow-lg"
        @click="showApplyModal = true"
      >
        <UIcon name="i-heroicons-paper-airplane" class="w-6 h-6" />
      </UButton>
    </div>

    <!-- Modal de signalement mise à jour -->
    <TransitionRoot appear :show="showReportModal" as="template">
      <Dialog as="div" class="relative z-50" @close="showReportModal = false">
        <!-- Overlay -->
        <TransitionChild
          as="template"
          enter="duration-300 ease-out"
          enter-from="opacity-0"
          enter-to="opacity-100"
          leave="duration-200 ease-in"
          leave-from="opacity-100"
          leave-to="opacity-0"
        >
          <div class="fixed inset-0 bg-black/30 backdrop-blur-sm" />
        </TransitionChild>

        <!-- Modal -->
        <div class="fixed inset-0 overflow-y-auto">
          <div class="flex min-h-full items-center justify-center p-4">
            <TransitionChild
              as="template"
              enter="duration-300 ease-out"
              enter-from="opacity-0 scale-95"
              enter-to="opacity-100 scale-100"
              leave="duration-200 ease-in"
              leave-from="opacity-100 scale-100"
              leave-to="opacity-0 scale-95"
            >
              <DialogPanel class="w-full max-w-lg transform overflow-hidden rounded-2xl bg-white p-6 shadow-xl transition-all">
                <!-- En-tête -->
                <div class="flex items-center gap-4 mb-6">
                  <div class="p-3 bg-red-50 rounded-full">
                    <UIcon name="i-heroicons-exclamation-triangle" class="w-6 h-6 text-red-500" />
                  </div>
                  <div>
                    <DialogTitle as="h3" class="text-lg font-semibold text-gray-900">
                      Signaler un problème
                    </DialogTitle>
                    <p class="text-sm text-gray-500">
                      Aidez-nous à maintenir un environnement sûr et professionnel
                    </p>
                  </div>
                </div>

                <!-- Formulaire -->
                <div class="space-y-6">
                  <!-- Raisons -->
                  <fieldset>
                    <legend class="text-sm font-medium text-gray-700 mb-3">
                      Pour quelle raison signalez-vous cette mission ?
                    </legend>
                    <div class="space-y-2">
                      <label 
                        v-for="reason in reportReasons"
                        :key="reason.value"
                        class="flex items-center p-4 border rounded-xl cursor-pointer transition-colors"
                        :class="[
                          selectedReason === reason.value 
                            ? 'border-red-500 bg-red-50' 
                            : 'border-gray-200 hover:bg-gray-50'
                        ]"
                      >
                        <input
                          type="radio"
                          :value="reason.value"
                          v-model="selectedReason"
                          name="report-reason"
                          class="sr-only"
                        />
                        <div class="flex-1">
                          <div class="font-medium text-gray-900">
                            {{ reason.label }}
                          </div>
                        </div>
                        <div 
                          class="w-5 h-5 rounded-full border-2 flex items-center justify-center"
                          :class="[
                            selectedReason === reason.value 
                              ? 'border-red-500 bg-red-500' 
                              : 'border-gray-300'
                          ]"
                        >
                          <UIcon
                            v-if="selectedReason === reason.value"
                            name="i-heroicons-check"
                            class="w-3 h-3 text-white"
                          />
                        </div>
                      </label>
                    </div>
                  </fieldset>

                  <!-- Description -->
                  <div>
                    <FloatingLabelInput
                      v-model="reportDescription"
                      type="textarea"
                      label="Description détaillée (optionnelle)"
                      placeholder="Donnez-nous plus de détails sur le problème..."
                      :rows="4"
                      class="w-full"
                    />
                  </div>
                </div>

                <!-- Actions -->
                <div class="mt-8 flex justify-end gap-3">
                  <button
                    type="button"
                    class="px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50 rounded-full transition-colors"
                    @click="showReportModal = false"
                  >
                    Annuler
                  </button>
                  <button
                    type="button"
                    class="px-4 py-2 text-sm font-medium text-white bg-red-500 rounded-full hover:bg-red-600 disabled:opacity-50 disabled:cursor-not-allowed transition-colors flex items-center gap-2"
                    :disabled="!selectedReason || isSubmitting"
                    @click="handleReport"
                  >
                    <UIcon
                      v-if="isSubmitting"
                      name="i-heroicons-arrow-path"
                      class="w-4 h-4 animate-spin"
                    />
                    <span>{{ isSubmitting ? 'Envoi en cours...' : 'Envoyer le signalement' }}</span>
                  </button>
                </div>
              </DialogPanel>
            </TransitionChild>
          </div>
        </div>
      </Dialog>
    </TransitionRoot>

    <!-- Modal Faire une proposition style Apple -->
    <UModal v-model="showApplyModal" :ui="{ width: 'max-w-xl' }">
      <div class="p-6 sm:p-8">
        <div class="text-center mb-8">
          <div class="bg-blue-50 dark:bg-blue-900/20 w-16 h-16 rounded-2xl flex items-center justify-center mx-auto mb-4">
            <UIcon name="i-heroicons-paper-airplane" class="h-8 w-8 text-blue-500" />
          </div>
          <h3 class="text-xl font-bold text-gray-900 dark:text-white">
            Faire une proposition
          </h3>
          <p class="text-sm text-gray-500 dark:text-gray-400 mt-2">
            Proposez vos services pour cette mission
          </p>
        </div>

        <div class="space-y-6">
          <!-- Prix -->
          <div class="text-center">
            <label class="block text-sm font-medium text-gray-500 dark:text-gray-400 mb-2">
              Prix proposé
            </label>
            <div class="relative inline-block group">
              <div class="relative flex items-center">
                <input
                  v-model.number="proposalForm.price"
                  type="text"
                  inputmode="numeric"
                  pattern="[0-9]*"
                  class="absolute inset-0 w-full text-6xl font-bold text-center bg-transparent focus:outline-none text-gray-900 dark:text-white tracking-tight opacity-0 group-hover:opacity-100 focus:opacity-100 transition-opacity"
                  @focus="$event.target.select()"
                  @blur="validatePrice"
                  @keydown.up.prevent="proposalForm.price += 10"
                  @keydown.down.prevent="proposalForm.price = Math.max(0, proposalForm.price - 10)"
                  @keydown.shift.up.prevent="proposalForm.price += 100"
                  @keydown.shift.down.prevent="proposalForm.price = Math.max(0, proposalForm.price - 100)"
                  @input="handlePriceInput"
                />
                <span 
                  class="text-6xl font-bold text-gray-900 dark:text-white tracking-tight group-hover:opacity-0 transition-opacity"
                >
                  {{ formatPrice(proposalForm.price) }}
                </span>
              </div>
              
              <div class="absolute -right-16 top-1/2 -translate-y-1/2 flex flex-col gap-2">
                <button
                  class="rounded-full h-10 w-10 flex items-center justify-center border border-gray-200 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-800 transition-colors"
                  @click="proposalForm.price += 10"
                >
                  <PlusIcon class="h-5 w-5 text-gray-500" />
                </button>
                <button
                  class="rounded-full h-10 w-10 flex items-center justify-center border border-gray-200 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-800 transition-colors"
                  @click="proposalForm.price = Math.max(0, proposalForm.price - 10)"
                >
                  <MinusIcon class="h-5 w-5 text-gray-500" />
                </button>
              </div>
            </div>
          </div>

          <!-- Délai estimé -->
          <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-200 mb-2">
              Délai estimé
            </label>
            <div class="flex items-center gap-4">
              <div class="relative flex-1">
                <input
                  v-model="estimatedDays"
                  type="number"
                  min="1"
                  class="w-full pl-4 pr-16 py-3 text-lg font-semibold rounded-2xl border-gray-200 dark:border-gray-700 bg-white dark:bg-gray-900 text-gray-900 dark:text-white focus:ring-2 focus:ring-blue-500 dark:focus:ring-blue-400 focus:border-transparent"
                >
                <div class="absolute inset-y-0 right-0 pr-4 flex items-center pointer-events-none">
                  <span class="text-gray-500 dark:text-gray-400">jours</span>
                </div>
              </div>
              <div class="flex flex-col gap-2">
                <UButton
                  color="gray"
                  variant="soft"
                  icon="i-heroicons-plus-small"
                  class="rounded-xl h-10 w-10 !p-0"
                  @click="estimatedDays++"
                />
                <UButton
                  color="gray"
                  variant="soft"
                  icon="i-heroicons-minus-small"
                  class="rounded-xl h-10 w-10 !p-0"
                  @click="estimatedDays = Math.max(1, estimatedDays - 1)"
                />
              </div>
            </div>
          </div>

          <!-- Message -->
          <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-200 mb-2">
              Message
            </label>
            <textarea
              v-model="proposalMessage"
              rows="4"
              class="w-full px-4 py-3 text-base rounded-2xl border-gray-200 dark:border-gray-700 bg-white dark:bg-gray-900 text-gray-900 dark:text-white focus:ring-2 focus:ring-blue-500 dark:focus:ring-blue-400 focus:border-transparent"
              placeholder="Décrivez votre approche et votre expérience..."
            ></textarea>
          </div>

          <!-- Actions -->
          <div class="flex flex-col gap-3 mt-8">
            <UButton
              color="blue"
              label="Envoyer ma proposition"
              :loading="isSubmitting"
              :disabled="!isValid"
              class="w-full rounded-2xl h-12 text-base font-semibold"
              @click="submitProposal"
            />
            <UButton
              color="gray"
              variant="soft"
              label="Annuler"
              class="w-full rounded-2xl h-12 text-base"
              @click="showApplyModal = false"
            />
          </div>
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
  MessageSquare, Send, Edit, Check, X, Star as StarIcon, Inbox as InboxIcon, Star, PlusIcon, MinusIcon 
} from 'lucide-vue-next'
import { Dialog, DialogPanel, DialogTitle, TransitionRoot, TransitionChild } from '@headlessui/vue'
import { useCustomToast } from '~/composables/useCustomToast'
const route = useRoute()
const router = useRouter()
const supabase = useSupabaseClient()
const user = useSupabaseUser()
const { showToast } = useCustomToast()
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

// États pour la proposition
const showApplyModal = ref(false)
const proposedAmount = ref(0)
const estimatedDays = ref(1)
const proposalMessage = ref('')

// Système de notification amélioré
// const toast = use()

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
  { value: 'inappropriate', label: 'Contenu inapproprié' },
  { value: 'spam', label: 'Spam ou publicité' },
  { value: 'scam', label: 'Arnaque potentielle' },
  { value: 'duplicate', label: 'Mission en double' },
  { value: 'other', label: 'Autre raison' }
]

// Validation
const isValid = computed(() => {
  return proposedAmount.value > 0 && 
         estimatedDays.value >= 1 && 
         proposalMessage.value.length > 0
})

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

// const fetchLikes = async () => {
//   try {
//     // Récupérer le nombre total de likes pour cette demande
//     const { data: countData, error: countError } = await supabase
//       .rpc('get_mission_likes_count', { mission_id: parseInt(route.params.id) })
    
//     if (countError) throw countError
//     likeCount.value = countData || 0
    
//     // Vérifier si l'utilisateur actuel a liké cette demande
//     if (user.value) {
//       const { data: hasLiked, error: likeError } = await supabase
//         .rpc('has_user_liked_mission', { 
//           mission_id: parseInt(route.params.id),
//           user_id: user.value.id
//         })
      
//       if (likeError) throw likeError
//       isLiked.value = hasLiked || false
//     }
//   } catch (err) {
//     console.error('Error fetching likes:', err)
//   }
// }


const scrollToProposals = () => {
  document.getElementById('proposals').scrollIntoView({ behavior: 'smooth' })
}

const editRequest = () => {
  router.push(`/requests/edit/${mission.value.id}`)
}

const submitProposal = async () => {
  if (!isValid.value) return

  try {
    isSubmitting.value = true
    // ... logique de soumission ...
    
    showToast.success(
     'Proposition envoyée',
     'Votre proposition a été envoyée avec succès',
 
    )

    showApplyModal.value = false
    
    // Reset form
    proposedAmount.value = 0
    estimatedDays.value = 1
    proposalMessage.value = ''

  } catch (error) {
    console.error('Erreur lors de l\'envoi de la proposition:', error)
    showToast.error('Erreur',
     'Impossible d\'envoyer votre proposition',
    )
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
    
    showToast.success('Proposition acceptée',
      'La proposition a été acceptée avec succès',
    )
  } catch (err) {
    console.error('Error accepting proposal:', err)
    showToast.error('Erreur',
     'Une erreur est survenue lors de l\'acceptation de la proposition',
    )
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
    
    showToast.success('Proposition refusée',
     'La proposition a été refusée avec succès',
    )
  } catch (err) {
    console.error('Error rejecting proposal:', err)
    showToast.error('Erreur',
     'Une erreur est survenue lors du refus de la proposition',
    )
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

// const getProposalStatusLabel = (status) => {
//   const labels = {
//     'pending': 'En attente',
//     'active': 'Acceptée',
//     'rejected': 'Refusée'
//   }
//   return labels[status] || 'Inconnu'
// }

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
    showToast.success('Évaluation envoyée',
     'Votre évaluation a été envoyée avec succès',
    )
    
    // Rafraîchir les données de la mission
    await fetchRequest()
  } catch (err) {
    console.error('Error submitting rating:', err)
    showToast.error('Erreur',
     'Une erreur est survenue lors de l\'envoi de l\'évaluation',
    )
  } finally {
    isSubmittingRating.value = false
  }
}

// Gestion du signalement avec feedback amélioré
const handleReport = async () => {
  if (!selectedReason.value) return

  try {
    isSubmitting.value = true
    
    const reportData = {
      report_type: 'mission',
      reported_mission_id: route.params.id,
      reason: selectedReason.value,
      description: reportDescription.value || null, // Description optionnelle
      status: 'pending',
      reporter_id: user.value?.id // Ajouter l'ID du reporter
    }
    
    const { data, error } = await supabase
      .from('reports')
      .insert(reportData)
      .select('id')
      .single()

    if (error) {
      if (error.code === '23505') {
        throw new Error('Vous avez déjà signalé cette mission')
      }
      throw error
    }

    showReportModal.value = false
    showToast.success(
      'Signalement envoyé',
      `Référence: #${data.id.slice(0, 8)}. Nous examinerons votre signalement dans les plus brefs délais.`
    )

    // Réinitialiser le formulaire
    selectedReason.value = ''
    reportDescription.value = ''

  } catch (error) {
    console.error('Erreur lors du signalement:', error)
    showToast.error(
      'Erreur',
      error.message || 'Impossible d\'envoyer le signalement. Veuillez réessayer.'
    )
  } finally {
    isSubmitting.value = false
  }
}

const handlePriceInput = (event) => {
  const value = event.target.value.replace(/[^0-9]/g, '')
  proposalForm.price = value ? parseInt(value) : 0
}

const validatePrice = () => {
  proposalForm.price = Math.max(0, parseInt(proposalForm.price) || 0)
}

// Initialisation
onMounted(async () => {
  try {
    await Promise.all([
      fetchRequest(),
      fetchProposals(),
      // fetchLikes()
    ])
  } catch (err) {
    console.error('Error during initialization:', err)
    showToast.error('Erreur',
     'Une erreur est survenue lors de l\'initialisation',
    )
  } finally {
    isLoading.value = false
  }
})

definePageMeta({
  layout: 'default'
})

// Dans la partie script, ajouter ces fonctions helpers
const getStatusColor = (status) => {
  const colors = {
    open: 'green',
    in_progress: 'blue',
    completed: 'gray',
    cancelled: 'red',
    proposal: 'yellow'
  }
  return colors[status] || 'gray'
}

const getStatusLabel = (status) => {
  const labels = {
    open: 'Ouverte',
    in_progress: 'En cours',
    completed: 'Terminée',
    cancelled: 'Annulée',
    proposal: 'En attente'
  }
  return labels[status] || status
}

const getProposalStatusColor = (status) => {
  const colors = {
    proposal: 'yellow',
    accepted: 'green',
    rejected: 'red',
    cancelled: 'gray'
  }
  return colors[status] || 'gray'
}

const getProposalStatusLabel = (status) => {
  const labels = {
    proposal: 'En attente',
    accepted: 'Acceptée',
    rejected: 'Refusée',
    cancelled: 'Annulée'
  }
  return labels[status] || status
}

const getDurationLabel = (unit) => {
  const labels = {
    days: 'jours',
    weeks: 'semaines',
    months: 'mois'
  }
  return labels[unit] || unit
}

// Ajouter les actions du propriétaire
const ownerActions = computed(() => [
  [
    {
      label: 'Modifier',
      icon: 'i-heroicons-pencil',
      click: () => navigateTo(`/requests/${mission.value.id}/edit`)
    },
    {
      label: mission.value.status === 'open' ? 'Fermer' : 'Réouvrir',
      icon: mission.value.status === 'open' ? 'i-heroicons-lock-closed' : 'i-heroicons-lock-open',
      click: () => toggleMissionStatus()
    }
  ],
  [
    {
      label: 'Supprimer',
      icon: 'i-heroicons-trash',
      click: () => deleteMission(),
      class: 'text-red-500'
    }
  ]
])

// Ajouter la méthode pour basculer le statut
const toggleMissionStatus = async () => {
  try {
    const newStatus = mission.value.status === 'open' ? 'closed' : 'open'
    const { error } = await supabase
      .from('missions')
      .update({ status: newStatus })
      .eq('id', mission.value.id)

    if (error) throw error

    mission.value.status = newStatus
    showToast.success(`Mission ${newStatus === 'open' ? 'réouverte' : 'fermée'}`,
     'La mission a été modifiée avec succès',
    )
  } catch (error) {
    console.error('Error:', error)
    showToast.error('Erreur',
     'Une erreur est survenue lors de la modification de la mission',
    )
  }
}

// Ajouter la méthode pour supprimer
const deleteMission = async () => {
  if (!confirm('Êtes-vous sûr de vouloir supprimer cette mission ?')) return

  try {
    const { error } = await supabase
      .from('missions')
      .delete()
      .eq('id', mission.value.id)

    if (error) throw error

    showToast.success('Mission supprimée',
     'La mission a été supprimée avec succès',
    )
    navigateTo('/requests')
  } catch (error) {
    console.error('Error:', error)
    showToast.error('Erreur',
     'Une erreur est survenue lors de la suppression de la mission',
    )
  }
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