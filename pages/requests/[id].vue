<template>
  <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
    <!-- Back link -->
    <div class="mb-6">
      <NuxtLink 
        to="/requests" 
        class="inline-flex items-center px-3 py-1.5 text-sm rounded-full text-gray-700 dark:text-gray-300 bg-gray-100 hover:bg-gray-200 dark:bg-gray-700 dark:hover:bg-gray-600 transition-colors"
      >
        <ArrowLeft class="h-3.5 w-3.5 mr-1" />
        Retour aux demandes
      </NuxtLink>
    </div>

    <!-- Loading state -->
    <div v-if="isLoading" class="flex justify-center py-12">
      <div class="inline-flex items-center px-4 py-2 rounded-lg text-sm font-medium text-primary-700 dark:text-primary-400 bg-primary-50 dark:bg-primary-900/20">
        <RefreshCcw class="h-5 w-5 mr-2 animate-spin" />
        Chargement des détails...
      </div>
    </div>

    <!-- Request not found -->
    <div 
      v-else-if="!request" 
      class="bg-white dark:bg-gray-800 rounded-xl border border-gray-100 dark:border-gray-700 p-8 text-center"
    >
      <div class="mx-auto h-16 w-16 flex items-center justify-center rounded-full bg-gray-100 dark:bg-gray-700 mb-4">
        <FileX class="h-8 w-8 text-gray-400" />
      </div>
      <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-1">Demande introuvable</h3>
      <p class="text-gray-500 dark:text-gray-400 mb-4">Cette demande n'existe pas ou a été supprimée.</p>
      <NuxtLink 
        to="/requests" 
        class="inline-flex items-center justify-center px-4 py-2 rounded-lg bg-primary-500 hover:bg-primary-600 text-white transition-colors"
      >
        Voir toutes les demandes
      </NuxtLink>
    </div>

    <!-- Request details -->
    <div v-else>
      <!-- Request header -->
      <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-100 dark:border-gray-700 overflow-hidden mb-6">
        <div class="p-6">
          <!-- Status and date -->
          <div class="flex flex-wrap items-center gap-3 mb-3">
            <div 
              class="px-3 py-1 text-xs font-medium rounded-full"
              :class="{
                'bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-400': request.status === 'open',
                'bg-blue-100 text-blue-800 dark:bg-blue-900/30 dark:text-blue-400': request.status === 'in-progress',
                'bg-gray-100 text-gray-800 dark:bg-gray-700 dark:text-gray-300': request.status === 'closed'
              }"
            >
              {{ formatStatus(request.status) }}
            </div>
            
            <div class="flex items-center text-sm text-gray-600 dark:text-gray-400">
              <Clock class="h-4 w-4 mr-1" />
              <span>Publiée {{ formatDate(request.created_at) }}</span>
            </div>
          </div>
          
          <!-- Title -->
          <h1 class="text-2xl font-bold text-gray-900 dark:text-white mb-4">
            {{ request.title }}
          </h1>
          
          <!-- Budget and deadline -->
          <div class="flex flex-wrap items-center gap-4 mb-6">
            <div class="flex items-center">
              <div class="bg-primary-50 dark:bg-primary-900/30 text-primary-600 dark:text-primary-400 px-4 py-2 rounded-xl text-lg font-bold">
                {{ formatBudget(request.budget) }}
              </div>
            </div>
            
            <div class="flex items-center text-gray-700 dark:text-gray-300">
              <Calendar class="h-5 w-5 mr-2 text-gray-400" />
              <span>Deadline: <span class="font-medium">{{ formatDeadline(request.deadline) }}</span></span>
            </div>
          </div>
          
          <!-- Description -->
          <div class="mb-6">
            <h2 class="text-lg font-semibold text-gray-900 dark:text-white mb-2">Description</h2>
            <div class="prose dark:prose-invert max-w-none text-gray-700 dark:text-gray-300">
              <p>{{ request.description }}</p>
            </div>
          </div>
          
          <!-- Skills required -->
          <div>
            <h2 class="text-lg font-semibold text-gray-900 dark:text-white mb-2">Compétences requises</h2>
            <div class="flex flex-wrap gap-2">
              <span 
                v-for="skill in request.skills_required" 
                :key="skill"
                class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-primary-50 text-primary-700 dark:bg-primary-900/30 dark:text-primary-400"
              >
                {{ skill }}
              </span>
            </div>
          </div>
          
          <!-- Client info -->
          <div class="mt-6 pt-6 border-t border-gray-100 dark:border-gray-700">
            <div class="flex items-center">
              <div class="h-10 w-10 rounded-full overflow-hidden bg-gray-200 dark:bg-gray-700 mr-3">
                <img 
                  v-if="clientProfile?.avatar_url" 
                  :src="clientProfile.avatar_url" 
                  alt="Avatar"
                  class="h-full w-full object-cover"
                />
                <div v-else class="h-full w-full flex items-center justify-center text-gray-500 dark:text-gray-400 font-medium">
                  {{ getInitials(clientProfile?.first_name, clientProfile?.last_name) }}
                </div>
              </div>
              <div>
                <div class="font-medium text-gray-900 dark:text-white">
                  {{ clientProfile?.first_name }} {{ clientProfile?.last_name }}
                </div>
                <div class="text-sm text-gray-500 dark:text-gray-400">Client</div>
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Proposals section (visible for client or if user has already proposed) -->
      <div 
        v-if="isClientRequest || hasProposed" 
        class="bg-white dark:bg-gray-800 rounded-xl border border-gray-100 dark:border-gray-700 overflow-hidden mb-6"
      >
        <div class="border-b border-gray-100 dark:border-gray-700 px-6 py-4">
          <h2 class="text-lg font-semibold text-gray-900 dark:text-white">
            Propositions
            <span class="ml-2 text-sm font-normal text-gray-500 dark:text-gray-400">({{ proposals.length }})</span>
          </h2>
        </div>
        
        <div class="divide-y divide-gray-100 dark:divide-gray-700">
          <!-- Empty state if no proposals -->
          <div v-if="proposals.length === 0" class="p-6 text-center">
            <div class="mx-auto h-12 w-12 flex items-center justify-center rounded-full bg-gray-100 dark:bg-gray-700 mb-3">
              <InboxIcon class="h-6 w-6 text-gray-400" />
            </div>
            <h3 class="text-base font-medium text-gray-900 dark:text-white mb-1">Aucune proposition</h3>
            <p class="text-sm text-gray-500 dark:text-gray-400">
              {{ isClientRequest ? "Vous n'avez pas encore reçu de propositions pour cette demande." : "Votre proposition est la seule pour l'instant." }}
            </p>
          </div>
          
          <!-- List of proposals -->
          <div v-else v-for="proposal in proposals" :key="proposal.id" class="p-6">
            <div class="flex items-start justify-between">
              <!-- Expert info -->
              <div class="flex items-start">
                <div class="h-10 w-10 rounded-full overflow-hidden bg-gray-200 dark:bg-gray-700 mr-3">
                  <img 
                    v-if="proposal.expert?.avatar_url" 
                    :src="proposal.expert.avatar_url" 
                    alt="Avatar"
                    class="h-full w-full object-cover"
                  />
                  <div v-else class="h-full w-full flex items-center justify-center text-gray-500 dark:text-gray-400 font-medium">
                    {{ getInitials(proposal.expert?.first_name, proposal.expert?.last_name) }}
                  </div>
                </div>
                <div>
                  <div class="font-medium text-gray-900 dark:text-white">
                    {{ proposal.expert?.first_name }} {{ proposal.expert?.last_name }}
                  </div>
                  <div class="text-sm text-gray-500 dark:text-gray-400 flex items-center mt-0.5">
                    <Star class="h-3.5 w-3.5 text-yellow-400 mr-1" fill="currentColor" />
                    <span>{{ proposal.expert?.rating || "Nouveau" }}</span>
                    <span class="mx-1.5">•</span>
                    <span>{{ proposal.expert?.completed_projects || 0 }} projet{{ proposal.expert?.completed_projects !== 1 ? 's' : '' }} complété{{ proposal.expert?.completed_projects !== 1 ? 's' : '' }}</span>
                  </div>
                </div>
              </div>
              
              <!-- Proposal price and duration -->
              <div class="text-right">
                <div class="text-lg font-bold text-primary-600 dark:text-primary-400">
                  {{ formatBudget(proposal.price) }}
                </div>
                <div class="text-sm text-gray-500 dark:text-gray-400">
                  {{ proposal.duration }} jour{{ proposal.duration !== 1 ? 's' : '' }}
                </div>
              </div>
            </div>
            
            <!-- Proposal message -->
            <div class="mt-4 bg-gray-50 dark:bg-gray-800/70 rounded-lg p-4 text-gray-700 dark:text-gray-300">
              <p>{{ proposal.message }}</p>
            </div>
            
            <!-- Proposal status -->
            <div class="mt-4 flex items-center justify-between">
              <div 
                class="px-3 py-1 text-xs font-medium rounded-full"
                :class="{
                  'bg-yellow-100 text-yellow-800 dark:bg-yellow-900/30 dark:text-yellow-400': proposal.status === 'pending',
                  'bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-400': proposal.status === 'accepted',
                  'bg-red-100 text-red-800 dark:bg-red-900/30 dark:text-red-400': proposal.status === 'rejected'
                }"
              >
                {{ formatProposalStatus(proposal.status) }}
              </div>
              
              <!-- Accept/reject buttons (visible only for client) -->
              <div v-if="isClientRequest && proposal.status === 'pending'" class="flex gap-2">
                <button
                  @click="rejectProposal(proposal.id)"
                  class="px-3 py-1 text-sm rounded-lg border border-gray-300 dark:border-gray-600 text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors"
                >
                  Refuser
                </button>
                <button
                  @click="acceptProposal(proposal.id)"
                  class="px-3 py-1 text-sm rounded-lg bg-primary-500 hover:bg-primary-600 text-white transition-colors"
                >
                  Accepter
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Proposal form (visible for experts if request is open and they haven't proposed yet) -->
      <div 
        v-if="userProfile?.is_expert && request.status === 'open' && !hasProposed" 
        class="bg-white dark:bg-gray-800 rounded-xl border border-gray-100 dark:border-gray-700 overflow-hidden"
      >
        <div class="border-b border-gray-100 dark:border-gray-700 px-6 py-4">
          <h2 class="text-lg font-semibold text-gray-900 dark:text-white">Faire une proposition</h2>
        </div>
        
        <div class="p-6">
          <form @submit.prevent="submitProposal" class="space-y-4">
            <div class="flex flex-col md:flex-row gap-4">
              <div class="w-full md:w-1/2">
                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                  Votre prix <span class="text-red-500">*</span>
                </label>
                <div class="flex">
                  <span class="inline-flex items-center px-3 border border-r-0 border-gray-300 dark:border-gray-600 bg-gray-50 dark:bg-gray-700 text-gray-500 dark:text-gray-400 rounded-l-lg">
                    €
                  </span>
                  <input 
                    v-model="proposalForm.price" 
                    type="number" 
                    min="0" 
                    step="0.01"
                    required
                    class="w-full border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-white rounded-r-lg px-4 py-2.5 focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
                  />
                </div>
              </div>
              
              <div class="w-full md:w-1/2">
                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                  Durée estimée (jours) <span class="text-red-500">*</span>
                </label>
                <input 
                  v-model="proposalForm.duration" 
                  type="number" 
                  min="1" 
                  required
                  class="w-full border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-white rounded-lg px-4 py-2.5 focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
                />
              </div>
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                Message <span class="text-red-500">*</span>
              </label>
              <textarea 
                v-model="proposalForm.message" 
                rows="5" 
                required
                class="w-full border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-white rounded-lg px-4 py-2.5 focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
                placeholder="Présentez-vous, expliquez votre approche, et pourquoi vous êtes le meilleur expert pour cette mission..."
              ></textarea>
              <p class="mt-1 text-xs text-gray-500 dark:text-gray-400">
                Un message complet et personnalisé augmente considérablement vos chances d'être sélectionné.
              </p>
            </div>

            <div class="pt-2">
              <button
                type="submit"
                class="w-full bg-primary-500 hover:bg-primary-600 text-white py-2.5 px-4 rounded-lg transition-colors"
                :disabled="isSubmitting"
              >
                <div v-if="isSubmitting" class="flex items-center justify-center">
                  <RefreshCcw class="h-4 w-4 animate-spin mr-2" />
                  Envoi en cours...
                </div>
                <span v-else>Envoyer ma proposition</span>
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useSupabaseClient, useSupabaseUser, useRoute, useRouter } from '#imports'
import { ArrowLeft, RefreshCcw, Clock, Calendar, Star, FileX, InboxIcon, X, CheckCircle } from 'lucide-vue-next'

const supabase = useSupabaseClient()
const user = useSupabaseUser()
const route = useRoute()
const router = useRouter()

// State variables
const requestId = computed(() => route.params.id)
const isLoading = ref(true)
const request = ref(null)
const clientProfile = ref(null)
const userProfile = ref(null)
const proposals = ref([])
const hasProposed = ref(false)
const isSubmitting = ref(false)
const proposalForm = ref({
  price: 0,
  duration: 7,
  message: '',
  price_type: 'fixed'
})

// Check if current user is the client who created the request
const isClientRequest = computed(() => 
  user.value && request.value && user.value.id === request.value.client_id
)

// Fetch request details
const fetchRequest = async () => {
  isLoading.value = true
  
  try {
    const { data, error } = await supabase
      .from('requests')
      .select('*')
      .eq('id', requestId.value)
      .single()
    
    if (error) throw error
    
    request.value = data
    
    // Set default proposal price
    proposalForm.value.price = data.budget || 0
    
    // Fetch client profile
    await fetchClientProfile()
    
    // Fetch proposals if user is the client or check if user has proposed
    if (user.value) {
      if (user.value.id === data.client_id) {
        await fetchProposals()
      } else if (userProfile.value?.is_expert) {
        await checkUserProposal()
      }
    }
  } catch (error) {
    console.error('Error fetching request:', error)
    request.value = null
  } finally {
    isLoading.value = false
  }
}

// Fetch client profile
const fetchClientProfile = async () => {
  if (!request.value?.client_id) return
  
  try {
    const { data, error } = await supabase
      .from('profiles')
      .select('*')
      .eq('id', request.value.client_id)
      .single()
    
    if (error) throw error
    
    clientProfile.value = data
  } catch (error) {
    console.error('Error fetching client profile:', error)
  }
}

// Fetch user profile
const fetchUserProfile = async () => {
  if (!user.value) return
  
  try {
    const { data, error } = await supabase
      .from('profiles')
      .select('*')
      .eq('id', user.value.id)
      .single()
    
    if (error) throw error
    
    userProfile.value = data
  } catch (error) {
    console.error('Error fetching user profile:', error)
  }
}

// Fetch proposals (for client)
const fetchProposals = async () => {
  if (!request.value?.id) return
  
  try {
    const { data, error } = await supabase
      .from('proposals')
      .select(`
        *,
        expert:expert_id(
          id,
          first_name,
          last_name,
          avatar_url,
          rating,
          completed_projects
        )
      `)
      .eq('request_id', request.value.id)
      .order('created_at', { ascending: false })
    
    if (error) throw error
    
    proposals.value = data
  } catch (error) {
    console.error('Error fetching proposals:', error)
  }
}

// Check if user has already proposed
const checkUserProposal = async () => {
  if (!user.value || !request.value?.id) return
  
  try {
    const { data, error } = await supabase
      .from('proposals')
      .select('*')
      .eq('request_id', request.value.id)
      .eq('expert_id', user.value.id)
      .maybeSingle()
    
    if (error) throw error
    
    if (data) {
      hasProposed.value = true
      proposals.value = [data]
    }
  } catch (error) {
    console.error('Error checking user proposal:', error)
  }
}

// Submit a proposal
const submitProposal = async () => {
  if (!user.value || !request.value) return
  
  isSubmitting.value = true
  
  try {
    const { data, error } = await supabase
      .from('proposals')
      .insert({
        request_id: request.value.id,
        expert_id: user.value.id,
        price: proposalForm.value.price,
        price_type: proposalForm.value.price_type,
        duration: proposalForm.value.duration,
        message: proposalForm.value.message,
        status: 'pending'
      })
      .select()
      .single()
    
    if (error) throw error
    
    hasProposed.value = true
    proposals.value = [data]
    
    alert('Votre proposition a été envoyée avec succès!')
  } catch (error) {
    console.error('Error submitting proposal:', error)
    alert('Une erreur est survenue lors de l\'envoi de votre proposition.')
  } finally {
    isSubmitting.value = false
  }
}

// Accept a proposal
const acceptProposal = async (proposalId) => {
  if (!confirm('Êtes-vous sûr de vouloir accepter cette proposition? Un contrat sera créé automatiquement.')) return
  
  try {
    const { error } = await supabase
      .from('proposals')
      .update({ status: 'accepted' })
      .eq('id', proposalId)
    
    if (error) throw error
    
    // Update local state
    proposals.value = proposals.value.map(p => {
      if (p.id === proposalId) {
        return { ...p, status: 'accepted' }
      } else {
        return { ...p, status: 'rejected' }
      }
    })
    
    // Update request status
    request.value.status = 'assigned'
    
    alert('Proposition acceptée! Un contrat a été créé.')
    
    // Redirect to contracts page (this would be added once you have that page)
    // router.push('/account/contracts')
  } catch (error) {
    console.error('Error accepting proposal:', error)
    alert('Une erreur est survenue.')
  }
}

// Reject a proposal
const rejectProposal = async (proposalId) => {
  if (!confirm('Êtes-vous sûr de vouloir refuser cette proposition?')) return
  
  try {
    const { error } = await supabase
      .from('proposals')
      .update({ status: 'rejected' })
      .eq('id', proposalId)
    
    if (error) throw error
    
    // Update local state
    proposals.value = proposals.value.map(p => {
      if (p.id === proposalId) {
        return { ...p, status: 'rejected' }
      }
      return p
    })
    
    alert('Proposition refusée.')
  } catch (error) {
    console.error('Error rejecting proposal:', error)
    alert('Une erreur est survenue.')
  }
}

// Helper functions
const formatBudget = (budget) => {
  return new Intl.NumberFormat('fr-FR', { style: 'currency', currency: 'EUR' }).format(budget)
}

const formatDate = (dateString) => {
  const date = new Date(dateString)
  
  // Return relative time if less than 30 days
  const now = new Date()
  const diffInDays = Math.floor((now - date) / (1000 * 60 * 60 * 24))
  
  if (diffInDays < 30) {
    if (diffInDays === 0) {
      return "aujourd'hui"
    } else if (diffInDays === 1) {
      return "hier"
    } else {
      return `il y a ${diffInDays} jours`
    }
  } else {
    return new Intl.DateTimeFormat('fr-FR', { day: 'numeric', month: 'short' }).format(date)
  }
}

const formatDeadline = (dateString) => {
  const date = new Date(dateString)
  return new Intl.DateTimeFormat('fr-FR', { day: 'numeric', month: 'long', year: 'numeric' }).format(date)
}

const formatStatus = (status) => {
  switch (status) {
    case 'open': return 'Ouvert'
    case 'assigned': return 'Attribué'
    case 'completed': return 'Complété'
    case 'cancelled': return 'Annulé'
    default: return status
  }
}

const formatProposalStatus = (status) => {
  switch (status) {
    case 'pending': return 'En attente'
    case 'accepted': return 'Acceptée'
    case 'rejected': return 'Refusée'
    case 'withdrawn': return 'Retirée'
    default: return status
  }
}

const getInitials = (firstName, lastName) => {
  let initials = ''
  if (firstName) initials += firstName.charAt(0)
  if (lastName) initials += lastName.charAt(0)
  return initials || '?'
}

// Initialize
onMounted(() => {
  fetchUserProfile()
  fetchRequest()
})
</script>

<style scoped>
/* Animation for page elements */
@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.bg-white {
  animation: fadeIn 0.4s ease-out forwards;
}

/* Improved focus states */
button:focus, a:focus, input:focus, textarea:focus, select:focus {
  outline: none;
  @apply ring-offset-2;
  @apply ring-2;
  @apply ring-primary-500;
}
</style> 