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
        <div id="proposals" class="bg-white border border-gray-200 rounded-xl overflow-hidden shadow-sm">
          <div class="px-6 py-4 border-b border-gray-200 bg-gray-50">
            <h3 class="text-lg font-medium text-gray-900">Propositions ({{ proposalCount }})</h3>
          </div>
          
          <div v-if="proposals.length === 0" class="p-6 text-center">
            <div class="mx-auto h-12 w-12 text-gray-400">
              <InboxIcon class="h-12 w-12" />
            </div>
            <h3 class="mt-2 text-sm font-medium text-gray-900">Aucune proposition</h3>
            <p class="mt-1 text-sm text-gray-500">
              Soyez le premier à faire une proposition pour cette demande.
            </p>
          </div>
          
          <div v-else class="divide-y divide-gray-200">
            <div 
              v-for="proposal in proposals" 
              :key="proposal.id"
              class="p-6 hover:bg-gray-50 transition-colors"
            >
            <div class="flex items-start justify-between">
                <div class="flex items-center">
                  <div class="flex-shrink-0">
                  <img 
                    v-if="proposal.expert?.avatar_url" 
                    :src="proposal.expert.avatar_url" 
                      alt="Expert" 
                      class="h-10 w-10 rounded-full"
                  />
                    <div 
                      v-else 
                      class="h-10 w-10 rounded-full bg-primary-100 flex items-center justify-center text-primary-700 font-medium"
                    >
                    {{ getInitials(proposal.expert?.first_name, proposal.expert?.last_name) }}
                    </div>
                  </div>
                  <div class="ml-3">
                    <p class="text-sm font-medium text-gray-900">
                      {{ proposal.expert?.first_name }} {{ proposal.expert?.last_name }}
                    </p>
                    <div class="flex items-center mt-1">
                      <div class="flex items-center">
                        <StarIcon v-for="i in 5" :key="i" class="h-3.5 w-3.5" :class="i <= (proposal.expert?.rating || 0) ? 'text-yellow-400 fill-current' : 'text-gray-300'" />
                      </div>
                      <span class="ml-1 text-xs text-gray-500">
                        ({{ proposal.expert?.review_count || 0 }} avis)
                      </span>
                    </div>
                  </div>
                </div>
                <div class="text-right">
                  <div class="text-lg font-bold text-primary-600">
                    {{ formatPrice(proposal.price) }}
                  </div>
                  <div class="text-sm text-gray-500 mt-1">
                    {{ proposal.duration }} jours
                  </div>
                </div>
              </div>
              
              <div class="mt-4 text-sm text-gray-700">
                {{ proposal.message }}
              </div>
              
              <div class="mt-4 flex justify-between items-center">
                <span class="text-xs text-gray-500">
                  {{ formatDate(proposal.created_at) }}
                </span>
                
                <div v-if="isOwner && mission.status === 'open'" class="flex space-x-2">
                  <button 
                    @click="acceptProposal(proposal.id)"
                    class="inline-flex items-center px-3 py-1.5 border border-transparent rounded-full text-xs font-medium text-white bg-green-600 hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500"
                  >
                    <Check class="h-3.5 w-3.5 mr-1" />
                    Accepter
                  </button>
                  
                <button
                  @click="rejectProposal(proposal.id)"
                    class="inline-flex items-center px-3 py-1.5 border border-gray-300 rounded-full text-xs font-medium text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500"
                >
                    <X class="h-3.5 w-3.5 mr-1" />
                  Refuser
                </button>
              </div>
                
                <div v-else-if="proposal.status !== 'pending'" class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium" :class="getProposalStatusClasses(proposal.status)">
                  {{ getProposalStatusLabel(proposal.status) }}
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
      </div>
    </main>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
// import { useSupabaseClient } from '#imports'
import { 
  ArrowLeft, Loader2, AlertCircle, Calendar, Tag, Heart, 
  MessageSquare, Send, Edit, Check, X, Star as StarIcon, Inbox as InboxIcon 
} from 'lucide-vue-next'

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
  try {
    // Mettre à jour le statut de la proposition
    const { error: proposalError } = await supabase
      .from('deals')
      .update({ status: 'active' })
      .eq('id', proposalId)
    
    if (proposalError) throw proposalError
    
    // Mettre à jour le statut de la demande
    const { error: missionError } = await supabase
      .from('missions')
      .update({ status: 'assigned' })
      .eq('id', mission.value.id)
    
    if (missionError) throw missionError
    
    // Récupérer le contrat créé pour redirection
    const { data: contractData, error: contractError } = await supabase
      .from('job_contracts')
      .select('id')
      .eq('deal_id', proposalId)
      .single()
    
    if (contractError) throw contractError
    
    // Rafraîchir les données
    await Promise.all([fetchRequest(), fetchProposals()])
    
    // Afficher une notification de succès
    alert('Proposition acceptée. Un contrat a été créé.')
    
    // Optionnel: Rediriger vers la page du contrat
    // router.push(`/account/contracts/${contractData.id}`)
  } catch (err) {
    console.error('Error accepting proposal:', err)
    alert('Une erreur est survenue lors de l\'acceptation de la proposition')
  }
}

const rejectProposal = async (proposalId) => {
  try {
    const { error } = await supabase
      .from('deals')
      .update({ status: 'rejected' })
      .eq('id', proposalId)
    
    if (error) throw error
    
    // Rafraîchir les propositions
    await fetchProposals()
  } catch (err) {
    console.error('Error rejecting proposal:', err)
    alert('Une erreur est survenue')
  }
}

const getProposalStatusClasses = (status) => {
  const classes = {
    'pending': 'bg-yellow-100 text-yellow-800',
    'accepted': 'bg-green-100 text-green-800',
    'rejected': 'bg-red-100 text-red-800'
  }
  return classes[status] || 'bg-gray-100 text-gray-800'
}

const getProposalStatusLabel = (status) => {
  const labels = {
    'pending': 'En attente',
    'accepted': 'Acceptée',
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