<template>
  <div class="min-h-screen bg-white">
    <!-- Header -->
    <header class="sticky top-0 z-10 bg-white/90 backdrop-blur-sm border-b border-gray-100">
      <div class="max-w-3xl mx-auto px-4 py-3 flex items-center">
      <NuxtLink 
        to="/requests" 
          class="p-2 -ml-2 rounded-full hover:bg-gray-100 transition-colors"
      >
          <ArrowLeft class="w-5 h-5" />
      </NuxtLink>
        <h1 class="ml-4 text-xl font-bold">Détail de la demande</h1>
    </div>
    </header>

    <!-- Main content -->
    <main class="max-w-3xl mx-auto px-4 py-6">
    <!-- Loading state -->
      <div v-if="isLoading" class="flex flex-col items-center justify-center py-12">
        <Loader2 class="h-8 w-8 text-gray-400 mb-4 animate-spin" />
        <p class="text-gray-500">Chargement de la demande...</p>
    </div>

      <!-- Error state -->
    <div v-else-if="error" class="bg-red-50 p-4 rounded-lg text-red-700 my-6">
      <div class="flex">
          <AlertCircle class="h-5 w-5 text-red-400 mr-3" />
        <p>{{ error }}</p>
      </div>
    </div>

    <!-- Request details -->
      <div v-else class="space-y-6">
        <!-- Request card -->
        <div class="bg-white border border-gray-200 rounded-xl overflow-hidden shadow-sm">
      <!-- Request header -->
        <div class="p-6">
            <div class="flex items-start justify-between">
          <div>
                <h2 class="text-xl font-bold text-gray-900">{{ mission.title }}</h2>
                <div class="flex items-center mt-2 space-x-4">
                  <span class="inline-flex items-center text-sm text-gray-500">
                    <Calendar class="h-4 w-4 mr-1.5" />
                    {{ formatDate(mission.created_at) }}
                  </span>
                  <span class="inline-flex items-center text-sm text-gray-500">
                    <Tag class="h-4 w-4 mr-1.5" />
                    {{ mission.category?.name || 'Non catégorisé' }}
              </span>
              <span 
                class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium"
                    :class="statusClasses"
              >
                    {{ statusLabel }}
              </span>
            </div>
          </div>
          <div class="text-right">
                <div class="text-lg font-bold text-primary-600">
                  {{ formatPrice(mission.budget) }}
                </div>
                <div v-if="mission.deadline" class="text-sm text-gray-500 mt-1">
                  Deadline: {{ formatDate(mission.deadline) }}
          </div>
            </div>
          </div>
          
          <!-- Client info -->
            <div class="flex items-center mt-6 pb-6 border-b border-gray-100">
              <div class="flex-shrink-0">
                <img 
                  v-if="mission.client?.avatar_url" 
                  :src="mission.client.avatar_url" 
                  alt="Client" 
                  class="h-10 w-10 rounded-full"
                />
                <div 
                  v-else 
                  class="h-10 w-10 rounded-full bg-primary-100 flex items-center justify-center text-primary-700 font-medium"
                >
                  {{ getInitials(mission.client?.first_name, mission.client?.last_name) }}
                </div>
        </div>
              <div class="ml-3">
                <p class="text-sm font-medium text-gray-900">
                  {{ mission.client?.first_name }} {{ mission.client?.last_name }}
                </p>
                <p class="text-xs text-gray-500">Client</p>
              </div>
                </div>
            
            <!-- Description -->
            <div class="mt-6">
              <h3 class="text-base font-medium text-gray-900 mb-3">Description</h3>
              <div class="prose prose-sm max-w-none text-gray-700">
                {{ mission.description }}
              </div>
            </div>
          </div>
          
          <!-- Action buttons -->
          <div class="px-6 py-4 bg-gray-50 border-t border-gray-100 flex justify-between items-center">
            <div class="flex space-x-2">
              <button 
                @click="toggleLike"
                class="inline-flex items-center px-3 py-1.5 border border-gray-300 rounded-full text-sm font-medium text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500"
              >
                <Heart v-if="isLiked" class="h-4 w-4 mr-1.5 text-red-500" fill="currentColor" />
                <Heart v-else class="h-4 w-4 mr-1.5" />
                {{ likeCount }}
              </button>
              
              <button 
                @click="scrollToProposals"
                class="inline-flex items-center px-3 py-1.5 border border-gray-300 rounded-full text-sm font-medium text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500"
              >
                <MessageSquare class="h-4 w-4 mr-1.5" />
                {{ proposalCount }} Propositions
              </button>
      </div>
      
            <div>
              <NuxtLink 
                v-if="canMakeProposal"
                :to="`/proposals/new?id=${mission.id}`"
                class="inline-flex items-center px-4 py-2 border border-transparent rounded-full shadow-sm text-sm font-medium text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 transition-colors"
              >
                <Send class="h-4 w-4 mr-1.5" />
                Faire une proposition
              </NuxtLink>
              
              <button 
                v-else-if="isOwner"
                @click="editRequest"
                class="inline-flex items-center px-4 py-2 border border-gray-300 rounded-full text-sm font-medium text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500"
              >
                <Edit class="h-4 w-4 mr-1.5" />
                Modifier
              </button>
            </div>
          </div>
        </div>
        
        <!-- Proposals section -->
        <div class="bg-white dark:bg-gray-800 rounded-xl shadow-sm overflow-hidden">
          <div class="p-6">
            <h2 class="text-lg font-semibold text-gray-900 dark:text-white mb-4 flex items-center gap-2">
              <MessageSquare class="h-5 w-5" />
              Propositions ({{ proposals.length }})
            </h2>

            <!-- Liste des propositions -->
            <div class="space-y-4">
              <div 
                v-for="proposal in proposals" 
                :key="proposal.id"
                class="border dark:border-gray-700 rounded-xl overflow-hidden"
              >
                <!-- En-tête avec infos expert -->
                <div class="p-4 bg-gray-50 dark:bg-gray-700/50">
                  <div class="flex items-center gap-4">
                    <div 
                      v-if="proposal.expert?.avatar_url"
                      class="w-12 h-12 rounded-full bg-cover bg-center"
                      :style="{ backgroundImage: `url(${proposal.expert.avatar_url})` }"
                    ></div>
                    <div 
                      v-else
                      class="w-12 h-12 rounded-full bg-primary-50 dark:bg-primary-900/20 flex items-center justify-center text-primary-600 dark:text-primary-400 font-bold text-xl"
                    >
                      {{ getInitials(proposal.expert?.first_name, proposal.expert?.last_name) }}
                    </div>

                    <div class="flex-1">
                      <div class="flex items-center gap-2">
                        <h3 class="font-medium text-gray-900 dark:text-white">
                          {{ proposal.expert?.first_name }} {{ proposal.expert?.last_name }}
                        </h3>
                        <span 
                          class="px-2 py-0.5 rounded-full text-xs font-medium"
                          :class="getProposalStatusClasses(proposal.status)"
                        >
                          {{ getProposalStatusLabel(proposal.status) }}
                        </span>
                      </div>
                      <p class="text-sm text-gray-500">
                        Proposition faite le {{ formatDate(proposal.created_at) }}
                      </p>
                    </div>
                  </div>
                </div>

                <!-- Détails de la proposition -->
                <div class="p-4">
                  <div class="grid grid-cols-2 gap-4 mb-4">
                    <div class="p-3 bg-gray-50 dark:bg-gray-700/50 rounded-lg">
                      <div class="text-sm text-gray-500 dark:text-gray-400">Prix proposé</div>
                      <div class="font-medium text-gray-900 dark:text-white">
                        {{ formatPrice(proposal.price) }}
                      </div>
                    </div>
                    <div class="p-3 bg-gray-50 dark:bg-gray-700/50 rounded-lg">
                      <div class="text-sm text-gray-500 dark:text-gray-400">Durée estimée</div>
                      <div class="font-medium text-gray-900 dark:text-white">
                        {{ proposal.duration }} jour{{ proposal.duration > 1 ? 's' : '' }}
                      </div>
                    </div>
                  </div>

                  <!-- Message -->
                  <div class="text-gray-600 dark:text-gray-300 mb-4">
                    {{ proposal.message }}
                  </div>

                  <!-- Actions (uniquement pour le client et si la proposition est en attente) -->
                  <div 
                    v-if="isOwner && proposal.status === 'pending'"
                    class="flex items-center gap-3 pt-4 border-t dark:border-gray-700"
                  >
                    <button
                      @click="acceptProposal(proposal.id)"
                      class="flex-1 px-4 py-2 bg-primary-600 hover:bg-primary-700 text-white rounded-lg font-medium transition-colors flex items-center justify-center gap-2"
                    >
                      <Check class="h-4 w-4" />
                      Accepter
                    </button>
                    <button
                      @click="rejectProposal(proposal.id)"
                      class="flex-1 px-4 py-2 bg-white dark:bg-gray-700 border border-gray-200 dark:border-gray-600 text-gray-700 dark:text-gray-300 rounded-lg font-medium hover:bg-gray-50 dark:hover:bg-gray-600 transition-colors flex items-center justify-center gap-2"
                    >
                      <X class="h-4 w-4" />
                      Refuser
                    </button>
                  </div>
                </div>
              </div>

              <!-- État vide -->
              <div 
                v-if="proposals.length === 0"
                class="text-center py-8 text-gray-500 dark:text-gray-400"
              >
                <InboxIcon class="h-12 w-12 mx-auto mb-3" />
                <p>Aucune proposition reçue pour le moment</p>
              </div>
            </div>
          </div>
        </div>
      </div>
      
        <!-- Make proposal form -->
        <div v-if="showProposalForm" class="fixed inset-0 bg-gray-500 bg-opacity-75 flex items-center justify-center z-50">
          <div class="bg-white rounded-lg shadow-xl max-w-md w-full mx-4 overflow-hidden">
            <div class="px-6 py-4 border-b border-gray-200 flex justify-between items-center">
              <h3 class="text-lg font-medium text-gray-900">Faire une proposition</h3>
              <button @click="showProposalForm = false" class="text-gray-400 hover:text-gray-500">
                <X class="h-5 w-5" />
              </button>
        </div>
        
        <div class="p-6">
              <form @submit.prevent="submitProposal">
                <div class="space-y-4">
              <div>
                    <label for="price" class="block text-sm font-medium text-gray-700">Prix proposé</label>
                <div class="mt-1 relative rounded-md shadow-sm">
                  <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                        <span class="text-gray-500 sm:text-sm">FCFA</span>
                  </div>
                  <input 
                    type="number"
                    id="price"
                    v-model="proposalForm.price" 
                        class="focus:ring-primary-500 focus:border-primary-500 block w-full pl-16 pr-12 sm:text-sm border-gray-300 rounded-md" 
                        placeholder="0.00" 
                    min="0" 
                    step="0.01"
                    required
                  />
                </div>
              </div>
              
              <div>
                    <label for="duration" class="block text-sm font-medium text-gray-700">Durée (jours)</label>
                <input 
                  type="number"
                      id="duration" 
                  v-model="proposalForm.duration" 
                      class="focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md" 
                  min="1" 
                  required
                />
            </div>

            <div>
                    <label for="message" class="block text-sm font-medium text-gray-700">Message</label>
              <textarea 
                id="message"
                v-model="proposalForm.message" 
                rows="4"
                      class="focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md" 
                required
              ></textarea>
                  </div>
            </div>

                <div class="mt-6 flex justify-end">
                  <button 
                    type="button" 
                    @click="showProposalForm = false" 
                    class="mr-3 inline-flex justify-center py-2 px-4 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500"
                  >
                    Annuler
                  </button>
              <button
                type="submit"
                    class="inline-flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500"
                :disabled="isSubmitting"
              >
                    <Loader2 v-if="isSubmitting" class="animate-spin h-4 w-4 mr-1.5" />
                    <span>{{ isSubmitting ? 'Envoi en cours...' : 'Envoyer' }}</span>
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
    
    <!-- Ajouter le modal d'évaluation -->
    <TransitionRoot appear :show="isRatingModalOpen" as="template">
      <Dialog as="div" @close="closeRatingModal" class="relative z-50">
        <TransitionChild
          enter="duration-300 ease-out"
          enter-from="opacity-0"
          enter-to="opacity-100"
          leave="duration-200 ease-in"
          leave-from="opacity-100"
          leave-to="opacity-0"
        >
          <div class="fixed inset-0 bg-black/25" />
        </TransitionChild>

        <div class="fixed inset-0 overflow-y-auto">
          <div class="flex min-h-full items-center justify-center p-4">
            <TransitionChild
              enter="duration-300 ease-out"
              enter-from="opacity-0 scale-95"
              enter-to="opacity-100 scale-100"
              leave="duration-200 ease-in"
              leave-from="opacity-100 scale-100"
              leave-to="opacity-0 scale-95"
            >
              <DialogPanel class="w-full max-w-md transform overflow-hidden rounded-2xl bg-white p-6 shadow-xl transition-all">
                <DialogTitle as="h3" class="text-lg font-medium leading-6 text-gray-900 mb-4">
                  Évaluer {{ isClient ? "l'expert" : "le client" }}
                </DialogTitle>

                <form @submit.prevent="submitRating" class="space-y-4">
                  <!-- Note globale -->
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">
                      Note globale
                    </label>
                    <div class="flex items-center gap-1">
                      <button 
                        v-for="i in 5" 
                        :key="i"
                        type="button"
                        @click="ratingForm.overall_rating = i"
                        class="p-1 focus:outline-none"
                      >
                        <Star 
                          :class="[
                            'w-6 h-6',
                            i <= ratingForm.overall_rating ? 'text-yellow-400 fill-current' : 'text-gray-300'
                          ]"
                        />
                      </button>
                    </div>
                  </div>

                  <!-- Note de communication -->
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">
                      Communication
                    </label>
                    <div class="flex items-center gap-1">
                      <button 
                        v-for="i in 5" 
                        :key="i"
                        type="button"
                        @click="ratingForm.communication_rating = i"
                        class="p-1 focus:outline-none"
                      >
                        <Star 
                          :class="[
                            'w-6 h-6',
                            i <= ratingForm.communication_rating ? 'text-yellow-400 fill-current' : 'text-gray-300'
                          ]"
                        />
                      </button>
                    </div>
                  </div>

                  <!-- Note spécifique (qualité ou fiabilité) -->
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">
                      {{ isClient ? 'Qualité du travail' : 'Fiabilité' }}
                    </label>
                    <div class="flex items-center gap-1">
                      <button 
                        v-for="i in 5" 
                        :key="i"
                        type="button"
                        @click="ratingForm.specific_rating = i"
                        class="p-1 focus:outline-none"
                      >
                        <Star 
                          :class="[
                            'w-6 h-6',
                            i <= ratingForm.specific_rating ? 'text-yellow-400 fill-current' : 'text-gray-300'
                          ]"
                        />
                      </button>
                    </div>
                  </div>

                  <!-- Recommandation -->
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">
                      Recommanderiez-vous {{ isClient ? "cet expert" : "ce client" }} ?
                    </label>
                    <div class="flex items-center gap-4">
                      <label class="inline-flex items-center">
                        <input
                          type="radio"
                          v-model="ratingForm.would_recommend"
                          :value="true"
                          class="form-radio text-primary-600"
                        />
                        <span class="ml-2">Oui</span>
                      </label>
                      <label class="inline-flex items-center">
                        <input
                          type="radio"
                          v-model="ratingForm.would_recommend"
                          :value="false"
                          class="form-radio text-primary-600"
                        />
                        <span class="ml-2">Non</span>
                      </label>
                    </div>
                  </div>

                  <!-- Commentaire -->
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">
                      Commentaire
                    </label>
                    <textarea
                      v-model="ratingForm.comment"
                      rows="3"
                      class="block w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500 sm:text-sm"
                      placeholder="Partagez votre expérience..."
                    ></textarea>
                  </div>

                  <!-- Boutons d'action -->
                  <div class="mt-6 flex justify-end gap-3">
                    <button
                      type="button"
                      @click="closeRatingModal"
                      class="px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md hover:bg-gray-50"
                    >
                      Annuler
                    </button>
                    <button
                      type="submit"
                      :disabled="isSubmittingRating"
                      class="inline-flex items-center px-4 py-2 text-sm font-medium text-white bg-primary-600 border border-transparent rounded-md hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500"
                    >
                      <Loader2 v-if="isSubmittingRating" class="w-4 h-4 mr-2 animate-spin" />
                      {{ isSubmittingRating ? 'Envoi...' : 'Envoyer' }}
                    </button>
                  </div>
                </form>
              </DialogPanel>
            </TransitionChild>
          </div>
        </div>
      </Dialog>
    </TransitionRoot>
    
    </main>
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
</style> 