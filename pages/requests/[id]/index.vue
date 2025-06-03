<template>
  <div class="min-h-screen bg-white dark:bg-black">
    <section class="max-w-3xl mx-auto px-4 py-12">
      <!-- État de chargement -->
      <div v-if="isLoading" class="flex justify-center items-center py-12">
        <UIcon name="i-heroicons-arrow-path" class="w-8 h-8 animate-spin text-gray-400" />
      </div>

      <!-- État d'erreur -->
      <div v-else-if="!mission" class="text-center py-12">
        <p class="text-gray-500">Mission non trouvée</p>
        <NuxtLink 
          to="/missions" 
          class="mt-4 inline-flex items-center text-primary-600 hover:text-primary-700"
        >
          <UIcon name="i-heroicons-arrow-left" class="w-5 h-5 mr-2" />
          Retour aux missions
        </NuxtLink>
      </div>

      <!-- Contenu de la mission -->
      <template v-else>
        <!-- En-tête avec informations essentielles -->
        <div class="mb-8">
          <!-- Retour et statut -->
          <div class="flex items-center justify-between mb-6">
            <NuxtLink 
              to="/missions" 
              class="flex items-center text-gray-600 hover:text-gray-900"
            >
              <UIcon name="i-heroicons-arrow-left" class="w-5 h-5 mr-2" />
              Retour aux missions
            </NuxtLink>
            
            <UBadge
              :color="getStatusColor(mission.status)"
              :label="getStatusLabel(mission.status)"
              class="rounded-full"
            />
          </div>

          <!-- Titre et infos demandeur -->
          <div class="flex items-start gap-4">
            <UAvatar 
              :src="mission.client?.avatar_url"
              :alt="mission.client?.first_name"
              size="lg"
            />
            <div class="flex-1">
              <h1 class="text-2xl font-bold text-gray-900 dark:text-white mb-2">
                {{ mission.title }}
              </h1>
              <div class="flex items-center gap-4 text-gray-600">
                <div class="flex items-center">
                  <UIcon name="i-heroicons-user" class="w-4 h-4 mr-1" />
                  <span>{{ mission.client?.first_name }}</span>
                </div>
                <div class="flex items-center">
                  <UIcon name="i-heroicons-currency-euro" class="w-4 h-4 mr-1" />
                  <span>{{ formatPrice(mission.budget) }}</span>
                </div>
                <div class="flex items-center">
                  <UIcon name="i-heroicons-calendar" class="w-4 h-4 mr-1" />
                  <span>{{ formatDate(mission.deadline) }}</span>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Contenu principal -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
          <!-- Colonne principale -->
          <div class="md:col-span-2 space-y-6">
            <!-- Description -->
            <div class="bg-white dark:bg-gray-900 rounded-xl p-6 shadow-sm border border-gray-100">
              <h2 class="text-lg font-semibold mb-4">Description</h2>
              <p class="text-gray-600 dark:text-gray-400 whitespace-pre-line">
                {{ mission.description }}
              </p>
            </div>

            <!-- Détails -->
            <div class="bg-white dark:bg-gray-900 rounded-xl p-6 shadow-sm border border-gray-100">
              <h2 class="text-lg font-semibold mb-4">Détails</h2>
              <div class="space-y-4">
                <div class="flex items-center gap-3">
                  <UIcon name="i-heroicons-briefcase" class="w-5 h-5 text-gray-400" />
                  <div>
                    <p class="font-medium">Type de travail</p>
                    <p class="text-sm text-gray-500">
                      {{ mission.work_type === 'remote' ? 'À distance' : 'Sur place' }}
                    </p>
                  </div>
                </div>
                <div class="flex items-center gap-3">
                  <UIcon name="i-heroicons-academic-cap" class="w-5 h-5 text-gray-400" />
                  <div>
                    <p class="font-medium">Profession</p>
                    <p class="text-sm text-gray-500">{{ mission.profession?.name }}</p>
                  </div>
                </div>
              </div>
            </div>

            <!-- Liste des propositions -->
            <div v-if="deals.length > 0" class="space-y-4">
              <h2 class="text-lg font-semibold">Propositions ({{ deals.length }})</h2>
              <div class="space-y-4">
                <div 
                  v-for="deal in deals" 
                  :key="deal.id"
                  class="bg-white dark:bg-gray-900 rounded-xl p-6 shadow-sm border border-gray-100"
                >
                  <!-- En-tête de la proposition -->
                  <div class="flex items-center justify-between mb-4">
                    <div class="flex items-center gap-3">
                      <UAvatar
                        :src="deal.expert?.avatar_url"
                        :alt="deal.expert?.first_name"
                        size="md"
                      />
                      <div>
                        <p class="font-medium text-gray-900 dark:text-white">
                          {{ deal.expert?.first_name }} {{ deal.expert?.last_name }}
                        </p>
                        <p class="text-sm text-gray-500">
                          {{ formatDate(deal.created_at) }}
                        </p>
                      </div>
                    </div>
                    
                    <UBadge
                      :color="getDealStatusColor(deal.status)"
                      :label="getDealStatusLabel(deal.status)"
                      class="rounded-full"
                    />
                  </div>

                  <!-- Détails de la proposition -->
                  <div class="space-y-4">
                    <!-- Message -->
                    <div class="text-gray-600 dark:text-gray-400">
                      {{ deal.message }}
                    </div>

                    <!-- Informations -->
                    <div class="flex flex-wrap gap-4 pt-4 border-t border-gray-100 dark:border-gray-800">
                      <div>
                        <p class="text-sm text-gray-500">Prix proposé</p>
                        <p class="font-medium text-gray-900 dark:text-white">
                          {{ formatPrice(deal.price) }}
                        </p>
                      </div>
                      
                      <div>
                        <p class="text-sm text-gray-500">Durée estimée</p>
                        <p class="font-medium text-gray-900 dark:text-white">
                          {{ deal.duration }} {{ getDurationLabel(deal.duration_unit) }}
                        </p>
                      </div>
                    </div>

                    <!-- Actions -->
                    <div v-if="isOwner && deal.status === 'proposal'" class="flex justify-end gap-2 pt-4">
                      <UButton
                        color="gray"
                        variant="soft"
                        @click="rejectDeal(deal.id)"
                        :loading="isActionLoading"
                      >
                        Refuser
                      </UButton>
                      <UButton
                        color="primary"
                        @click="acceptDeal(deal.id)"
                        :loading="isActionLoading"
                      >
                        Accepter
                      </UButton>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Sidebar -->
          <div>
            <div class="bg-white dark:bg-gray-900 rounded-xl p-6 shadow-sm border border-gray-100 sticky top-6">
              <UButton
                v-if="canMakeProposal"
                block
                color="primary"
                size="lg"
                @click="showProposalModal = true"
              >
                Faire une proposition
              </UButton>

              <div v-else class="text-sm text-gray-500 text-center">
                Cette mission n'est plus disponible
              </div>
            </div>
          </div>
        </div>
      </template>
    </section>

    <!-- Modal de proposition -->
    <TransitionRoot appear :show="showProposalModal" as="template">
      <Dialog as="div" class="relative z-50" @close="showProposalModal = false">
        <!-- Overlay avec effet de flou -->
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
                <div class="flex items-start gap-4 mb-6">
                  <div class="p-3 bg-primary-50 rounded-full shrink-0">
                    <UIcon name="i-heroicons-paper-airplane" class="w-6 h-6 text-primary-500" />
                  </div>
                  <div class="space-y-1">
                    <DialogTitle as="h3" class="text-lg font-semibold text-gray-900 line-clamp-2">
                      {{ mission?.title }}
                    </DialogTitle>
                    <div class="flex items-center gap-2 text-sm text-gray-500">
                      <UIcon name="i-heroicons-clock" class="w-4 h-4" />
                      <span>Date limite : {{ formatDate(mission?.deadline) }}</span>
                    </div>
                    <div class="flex items-center gap-2 text-sm text-emerald-600">
                      <UIcon name="i-heroicons-banknotes" class="w-4 h-4" />
                      <span>Budget : {{ formatPrice(mission?.budget) }}</span>
                    </div>
                  </div>
                </div>

                <!-- Formulaire -->
                <form @submit.prevent="submitProposal" class="space-y-6">
                  <!-- Prix -->
                  <FloatingLabelInput
                    v-model="proposalForm.price"
                    type="number"
                    label="Prix proposé"
                    placeholder="Ex: 500000"
                    min="0"
                    step="1"
                    required
                  />

                  <!-- Délai -->
                  <FloatingLabelInput
                    v-model="proposalForm.duration"
                    type="number"
                    label="Délai de livraison"
                    placeholder="Ex: 1"
                    min="1"
                    required
                  />

                  <!-- Unité de délai -->
                  <div class="flex justify-center gap-2">
                    <button
                      v-for="unit in ['days', 'weeks', 'months']"
                      :key="unit"
                      type="button"
                      class="px-4 py-2 rounded-full text-sm font-medium transition-colors"
                      :class="proposalForm.duration_unit === unit 
                        ? 'bg-primary-600 text-white dark:bg-primary-500' 
                        : 'bg-gray-100 text-gray-600 hover:bg-primary-50 dark:bg-gray-800 dark:text-gray-300 dark:hover:bg-primary-900/30'"
                      @click="proposalForm.duration_unit = unit"
                    >
                      {{ getDurationLabel(unit) }}
                    </button>
                  </div>

                  <!-- Message -->
                  <FloatingLabelInput
                    v-model="proposalForm.message"
                    type="textarea"
                    label="Message"
                    placeholder="Décrivez votre proposition..."
                    :rows="4"
                    required
                  />

                  <!-- Actions -->
                  <div class="flex justify-end gap-3 pt-6">
                    <button
                      type="button"
                      class="px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50 rounded-full transition-colors"
                      @click="showProposalModal = false"
                    >
                      Annuler
                    </button>
                    <button
                      type="submit"
                      class="px-4 py-2 text-sm font-medium text-white bg-primary-500 rounded-full hover:bg-primary-600 disabled:opacity-50 disabled:cursor-not-allowed transition-colors flex items-center gap-2"
                      :disabled="!isValid || isSubmitting"
                    >
                      <UIcon
                        v-if="isSubmitting"
                        name="i-heroicons-arrow-path"
                        class="w-4 h-4 animate-spin"
                      />
                      <span>{{ isSubmitting ? 'Envoi en cours...' : 'Envoyer ma proposition' }}</span>
                    </button>
                  </div>
                </form>
              </DialogPanel>
            </TransitionChild>
          </div>
        </div>
      </Dialog>
    </TransitionRoot>

    <!-- Modal de contact (après acceptation) -->
    <TransitionRoot appear :show="showContactModal" as="template">
      <Dialog as="div" class="relative z-50" @close="showContactModal = false">
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
                <div class="flex items-start gap-4 mb-6">
                  <div class="p-3 bg-green-50 rounded-full shrink-0">
                    <UIcon name="i-heroicons-check" class="w-6 h-6 text-green-500" />
                  </div>
                  <div>
                    <DialogTitle as="h3" class="text-lg font-semibold text-gray-900">
                      Accord conclu !
                    </DialogTitle>
                    <p class="mt-1 text-sm text-gray-500">
                      Voici les coordonnées pour vous contacter directement
                    </p>
                  </div>
                </div>

                <!-- Détails de l'accord -->
                <div class="space-y-6">
                  <!-- Informations de la mission -->
                  <div class="bg-gray-50 rounded-xl p-4">
                    <h4 class="font-medium text-gray-900">Détails de la mission</h4>
                    <div class="mt-2 space-y-2 text-sm text-gray-600">
                      <p>{{ mission.title }}</p>
                      <p>Prix convenu : {{ formatPrice(selectedDeal.price) }}</p>
                      <p>Délai : {{ selectedDeal.duration }} {{ getDurationLabel(selectedDeal.duration_unit) }}</p>
                    </div>
                  </div>

                  <!-- Coordonnées de contact -->
                  <div class="border-t border-gray-200 pt-6">
                    <h4 class="font-medium text-gray-900 mb-4">Coordonnées de contact</h4>
                    <div class="space-y-4">
                      <div class="flex items-center gap-3">
                        <UIcon name="i-heroicons-phone" class="w-5 h-5 text-gray-400" />
                        <div>
                          <p class="font-medium">Téléphone</p>
                          <p class="text-sm text-gray-500">{{ otherParty.phone }}</p>
                        </div>
                      </div>
                      <div class="flex items-center gap-3">
                        <UIcon name="i-heroicons-envelope" class="w-5 h-5 text-gray-400" />
                        <div>
                          <p class="font-medium">Email</p>
                          <p class="text-sm text-gray-500">{{ otherParty.email }}</p>
                        </div>
                      </div>
                    </div>
                  </div>

                  <!-- Actions -->
                  <div class="flex justify-end gap-3 pt-6">
                    <UButton
                      color="gray"
                      variant="soft"
                      @click="showContactModal = false"
                    >
                      Fermer
                    </UButton>
                    <UButton
                      color="primary"
                      @click="markAsInProgress(selectedDeal.id)"
                    >
                      J'ai pris contact
                    </UButton>
                  </div>
                </div>
              </DialogPanel>
            </TransitionChild>
          </div>
        </div>
      </Dialog>
    </TransitionRoot>

    <!-- Modal d'évaluation -->
    <TransitionRoot appear :show="showRatingModal" as="template">
      <Dialog as="div" class="relative z-50" @close="showRatingModal = false">
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
                <div class="space-y-6">
                  <h3 class="text-lg font-semibold">
                    Comment s'est passée votre expérience ?
                  </h3>

                  <!-- Système de notation -->
                  <div class="flex justify-center gap-2">
                    <button
                      v-for="star in 5"
                      :key="star"
                      @click="ratingForm.rating = star"
                      class="p-1"
                    >
                      <UIcon
                        :name="star <= ratingForm.rating ? 'i-heroicons-star-solid' : 'i-heroicons-star'"
                        class="w-8 h-8"
                        :class="star <= ratingForm.rating ? 'text-yellow-400' : 'text-gray-300'"
                      />
                    </button>
                  </div>

                  <!-- Commentaire -->
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">
                      Commentaire (optionnel)
                    </label>
                    <textarea
                      v-model="ratingForm.comment"
                      rows="4"
                      class="w-full rounded-lg"
                      placeholder="Partagez votre expérience..."
                    ></textarea>
                  </div>

                  <!-- Actions -->
                  <div class="flex justify-end gap-3">
                    <UButton
                      color="gray"
                      variant="soft"
                      @click="showRatingModal = false"
                    >
                      Plus tard
                    </UButton>
                    <UButton
                      color="primary"
                      @click="submitRating"
                      :disabled="!ratingForm.rating"
                    >
                      Envoyer mon évaluation
                    </UButton>
                  </div>
                </div>
              </DialogPanel>
            </TransitionChild>
          </div>
        </div>
      </Dialog>
    </TransitionRoot>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useRoute, useRouter } from '#app'
import { useSupabaseClient, useSupabaseUser } from '#imports'
import { format } from 'date-fns'
import { fr } from 'date-fns/locale'
import { Dialog, DialogPanel, DialogTitle, TransitionRoot, TransitionChild } from '@headlessui/vue'

const route = useRoute()
const router = useRouter()
const supabase = useSupabaseClient()
const user = useSupabaseUser()

// États
const mission = ref(null)
const deals = ref([])
const isLoading = ref(true)
const showProposalModal = ref(false) 
const isSubmitting = ref(false)
const isActionLoading = ref(false)
const showContactModal = ref(false)
const showRatingModal = ref(false)

// Formulaire pour une nouvelle proposition
const proposalForm = ref({
  price: null,
  duration: 1,
  duration_unit: 'days',
  message: ''
})

// États pour les modaux et formulaires
const selectedDeal = ref(null)
const otherParty = computed(() => {
  if (!selectedDeal.value) return null
  return isOwner.value ? selectedDeal.value.expert : mission.value.client
})

const ratingForm = ref({
  rating: 0,
  comment: ''
})

// Computed
const canMakeProposal = computed(() => {
  if (!mission.value || !user.value) return false
  return (
    mission.value.status === 'open' && 
    mission.value.client_id !== user.value.id &&
    !deals.value.some(d => d.expert_id === user.value.id)
  )
})

const isValid = computed(() => {
  return proposalForm.value.price > 0 && 
         proposalForm.value.duration > 0 && 
         proposalForm.value.message.trim().length > 0
})

// Computed supplémentaire
const isOwner = computed(() => {
  return mission.value?.client_id === user.value?.id
})

// Chargement des données
const loadMission = async () => {
  try {
    const { data: missionData, error: missionError } = await supabase
      .from('missions')
      .select(`
        *,
        client:profiles!client_id(*),
        profession:professions(*)
      `)
      .eq('id', route.params.id)
      .single()

    if (missionError) throw missionError
    mission.value = missionData

    // Charger les propositions associées
    const { data: dealsData, error: dealsError } = await supabase
      .from('deals')
      .select(`
        *,
        expert:profiles!expert_id(*)
      `)
      .eq('mission_id', route.params.id)
      .order('created_at', { desc: true })

    if (dealsError) throw dealsError
    deals.value = dealsData

  } catch (error) {
    console.error('Error loading mission:', error)
    showError('Impossible de charger la mission')
  } finally {
    isLoading.value = false
  }
}

// Soumission d'une proposition
const submitProposal = async () => {
  if (!isValid.value) return

  try {
    isSubmitting.value = true

    const { error } = await supabase
      .from('deals')
      .insert({
        mission_id: mission.value.id,
        expert_id: user.value.id,
        client_id: mission.value.client_id,
        price: proposalForm.value.price,
        duration: proposalForm.value.duration,
        duration_unit: proposalForm.value.duration_unit,
        message: proposalForm.value.message,
        status: 'proposal'
      })

    if (error) throw error

    showProposalModal.value = false
    proposalForm.value = {
      price: null,
      duration: 1,
      duration_unit: 'days', 
      message: ''
    }

    // Recharger les propositions
    await loadMission()
    
    showSuccess('Votre proposition a été envoyée avec succès')

  } catch (error) {
    console.error('Error submitting proposal:', error)
    showError('Une erreur est survenue lors de l\'envoi de votre proposition')
  } finally {
    isSubmitting.value = false
  }
}

// Utilitaires
const formatPrice = (price) => {
  return new Intl.NumberFormat('fr-FR', {
    style: 'currency', 
    currency: 'EUR'
  }).format(price || 0)
}

const formatDate = (date) => {
  if (!date) return ''
  return format(new Date(date), 'dd MMMM yyyy', { locale: fr })
}

const getStatusLabel = (status) => {
  const labels = {
    'open': 'Ouvert',
    'assigned': 'Assigné', 
    'in_progress': 'En cours',
    'completed': 'Terminé',
    'cancelled': 'Annulé'
  }
  return labels[status] || status
}

const getStatusColor = (status) => {
  const colors = {
    'open': 'success',
    'assigned': 'primary', 
    'in_progress': 'warning',
    'completed': 'gray',
    'cancelled': 'danger'
  }
  return colors[status] || 'gray'
}

const getDurationLabel = (unit) => {
  const labels = {
    'days': 'jours',
    'weeks': 'semaines',
    'hours': 'heures',
    'minutes': 'minutes'
  }
  return labels[unit] || unit
}

// Méthodes supplémentaires
const getDealStatusLabel = (status) => {
  const labels = {
    'proposal': 'En attente',
    'accepted': 'Accepté',
    'in_progress': 'En cours',
    'completed': 'Terminé',
    'cancelled': 'Annulé',
    'contact_shared': 'Contact partagé',
    'meeting_scheduled': 'RDV fixé'
  }
  return labels[status] || status
}

const getDealStatusColor = (status) => {
  const colors = {
    'proposal': 'gray',
    'accepted': 'success',
    'rejected': 'danger'
  }
  return colors[status] || 'gray'
}

// Action d'acceptation d'une proposition
const acceptDeal = async (dealId) => {
  if (!confirm('Êtes-vous sûr d\'accepter cette proposition ?')) return
  
  try {
    isActionLoading.value = true
    
    // Mise à jour du deal
    const { error: dealError } = await supabase
      .from('deals')
      .update({ 
        status: 'accepted',
        accepted_at: new Date().toISOString()
      })
      .eq('id', dealId)

    if (dealError) throw dealError

    // Mise à jour de la mission
    const { error: missionError } = await supabase
      .from('missions')
      .update({ 
        status: 'assigned',
        assigned_deal_id: dealId 
      })
      .eq('id', mission.value.id)

    if (missionError) throw missionError

    // Afficher les coordonnées
    selectedDeal.value = deals.value.find(d => d.id === dealId)
    showContactModal.value = true
    await loadMission()
    
  } catch (error) {
    console.error('Error accepting deal:', error)
    showError('Une erreur est survenue')
  } finally {
    isActionLoading.value = false
  }
}

// Marquer comme terminé
const markAsCompleted = async (dealId) => {
  try {
    isActionLoading.value = true
    
    const { error } = await supabase
      .from('deals')
      .update({ 
        status: 'completed',
        completed_at: new Date().toISOString()
      })
      .eq('id', dealId)

    if (error) throw error

    showRatingModal.value = true
    await loadMission()
    
  } catch (error) {
    console.error('Error completing deal:', error)
    showError('Une erreur est survenue')
  } finally {
    isActionLoading.value = false
  }
}

// Soumettre une évaluation
const submitRating = async (dealId, rating, comment) => {
  try {
    isActionLoading.value = true
    
    const { error } = await supabase
      .from('deal_ratings')
      .insert({
        deal_id: dealId,
        user_id: user.value.id,
        rating,
        comment
      })

    if (error) throw error
    
    showRatingModal.value = false
    await loadMission()
    
  } catch (error) {
    console.error('Error submitting rating:', error)
    showError('Une erreur est survenue')
  } finally {
    isActionLoading.value = false
  }
}

// Méthode pour marquer comme en cours
const markAsInProgress = async (dealId) => {
  try {
    isActionLoading.value = true
    
    const { error } = await supabase
      .from('deals')
      .update({ 
        status: 'in_progress',
        contact_established_at: new Date().toISOString()
      })
      .eq('id', dealId)

    if (error) throw error
    
    showContactModal.value = false
    await loadMission()
    
  } catch (error) {
    console.error('Error updating deal status:', error)
    showError('Une erreur est survenue')
  } finally {
    isActionLoading.value = false
  }
}

// Initialisation
onMounted(() => {
  loadMission()
})

definePageMeta({
  layout: 'default',
})
</script>