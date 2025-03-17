<template>
  <div class="max-w-4xl mx-auto px-4 py-6">
    <div class="flex justify-between items-center mb-5">
      <h1 class="text-xl font-bold">Mes Propositions</h1>
      <NuxtLink 
        to="/requests" 
        class="px-4 py-2 bg-primary-600 text-white rounded-full text-sm font-medium inline-flex items-center"
      >
        <SearchIcon class="h-4 w-4 mr-1.5" />
        Explorer
      </NuxtLink>
    </div>

    <!-- Stats cards -->
    <div class="grid grid-cols-2 md:grid-cols-4 gap-3 mb-6">
      <div class="border border-gray-200 dark:border-gray-700 rounded-xl p-3">
        <div class="text-sm text-gray-500 dark:text-gray-400">Total</div>
        <div class="text-xl font-semibold mt-1">{{ stats.total }}</div>
      </div>
      <div class="border border-gray-200 dark:border-gray-700 rounded-xl p-3">
        <div class="text-sm text-gray-500 dark:text-gray-400">En attente</div>
        <div class="text-xl font-semibold mt-1">{{ stats.pending }}</div>
      </div>
      <div class="border border-gray-200 dark:border-gray-700 rounded-xl p-3">
        <div class="text-sm text-gray-500 dark:text-gray-400">Acceptées</div>
        <div class="text-xl font-semibold mt-1">{{ stats.accepted }}</div>
      </div>
      <div class="border border-gray-200 dark:border-gray-700 rounded-xl p-3">
        <div class="text-sm text-gray-500 dark:text-gray-400">Taux de conversion</div>
        <div class="text-xl font-semibold mt-1">{{ stats.conversion }}%</div>
      </div>
    </div>

    <!-- Filters and search -->
    <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-3 mb-5">
      <div class="flex items-center gap-2 flex-wrap">
        <button 
          @click="activeFilter = 'all'"
          class="px-3 py-1.5 rounded-full text-sm transition-colors"
          :class="activeFilter === 'all' ? 'bg-primary-100 text-primary-800 dark:bg-primary-900/30 dark:text-primary-400' : 'bg-gray-100 text-gray-800 dark:bg-gray-800 dark:text-gray-400'"
        >
          Toutes
        </button>
        <button 
          @click="activeFilter = 'pending'"
          class="px-3 py-1.5 rounded-full text-sm transition-colors"
          :class="activeFilter === 'pending' ? 'bg-primary-100 text-primary-800 dark:bg-primary-900/30 dark:text-primary-400' : 'bg-gray-100 text-gray-800 dark:bg-gray-800 dark:text-gray-400'"
        >
          En attente
        </button>
        <button 
          @click="activeFilter = 'accepted'"
          class="px-3 py-1.5 rounded-full text-sm transition-colors"
          :class="activeFilter === 'accepted' ? 'bg-primary-100 text-primary-800 dark:bg-primary-900/30 dark:text-primary-400' : 'bg-gray-100 text-gray-800 dark:bg-gray-800 dark:text-gray-400'"
        >
          Acceptées
        </button>
        <button 
          @click="activeFilter = 'declined'"
          class="px-3 py-1.5 rounded-full text-sm transition-colors"
          :class="activeFilter === 'declined' ? 'bg-primary-100 text-primary-800 dark:bg-primary-900/30 dark:text-primary-400' : 'bg-gray-100 text-gray-800 dark:bg-gray-800 dark:text-gray-400'"
        >
          Refusées
        </button>
      </div>

      <div class="relative">
        <Search class="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-gray-400" />
        <input 
          type="text" 
          placeholder="Rechercher..."
          v-model="searchQuery"
          class="pl-9 pr-3 py-2 w-full sm:w-60 rounded-full border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800"
        />
      </div>
    </div>

    <!-- Loading state -->
    <div v-if="isLoading" class="py-10 flex justify-center">
      <svg class="animate-spin h-6 w-6 text-primary-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
      </svg>
    </div>

    <!-- Empty state -->
    <div v-else-if="filteredProposals.length === 0" class="border border-gray-200 dark:border-gray-700 rounded-xl p-5 text-center">
      <div class="inline-flex items-center justify-center p-3 bg-gray-100 dark:bg-gray-800 rounded-full mb-3">
        <ClipboardIcon class="h-5 w-5 text-gray-500" />
      </div>
      <h3 class="text-lg font-medium mb-1">Aucune proposition trouvée</h3>
      <p class="text-gray-500 text-sm mb-4">
        {{ activeFilter === 'all' 
          ? "Vous n'avez pas encore envoyé de proposition." 
          : activeFilter === 'pending' 
          ? "Vous n'avez aucune proposition en attente."
          : activeFilter === 'accepted'
          ? "Aucune proposition acceptée pour le moment."
          : "Aucune proposition refusée."
        }}
      </p>
      <NuxtLink to="/requests" class="px-4 py-2 bg-primary-600 text-white rounded-full text-sm font-medium inline-flex items-center">
        <SearchIcon class="h-4 w-4 mr-1.5" />
        Explorer les demandes
      </NuxtLink>
    </div>

    <!-- Proposals list -->
    <div v-else class="space-y-3">
      <div 
        v-for="proposal in filteredProposals" 
        :key="proposal.id" 
        class="border border-gray-200 dark:border-gray-700 rounded-xl overflow-hidden"
      >
        <!-- Main content -->
        <div class="p-4">
          <div class="flex justify-between">
            <div>
              <h3 class="font-medium">{{ proposal.request_title }}</h3>
              <div class="flex flex-wrap gap-1.5 mt-1.5">
                <span 
                  class="inline-flex items-center px-2 py-0.5 rounded-full text-xs font-medium"
                  :class="getStatusClass(proposal.status)"
                >
                  {{ getStatusLabel(proposal.status) }}
                </span>
                <span class="inline-flex items-center px-2 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-800 dark:bg-gray-800 dark:text-gray-300">
                  {{ proposal.category }}
                </span>
                <span v-if="proposal.is_urgent" class="inline-flex items-center px-2 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800 dark:bg-red-900/30 dark:text-red-400">
                  Urgent
                </span>
              </div>
            </div>
            <div class="text-right">
              <div class="font-semibold">{{ proposal.formatted_price }}</div>
              <div class="text-xs text-gray-500 mt-1">
                {{ formatDate(proposal.created_at) }}
              </div>
            </div>
          </div>
          
          <!-- Message preview -->
          <div class="text-sm text-gray-600 dark:text-gray-400 mt-3 line-clamp-2">
            {{ proposal.message }}
          </div>
          
          <!-- Details -->
          <div class="flex flex-wrap justify-between items-center text-sm mt-3 text-gray-600 dark:text-gray-400">
            <div class="flex items-center">
              <CalendarIcon class="h-4 w-4 mr-1" />
              <span>{{ proposal.estimated_days }} jours</span>
            </div>
            <div class="flex items-center">
              <UserIcon class="h-4 w-4 mr-1" />
              <span>{{ proposal.client_name }}</span>
            </div>
          </div>
        </div>
        
        <!-- Actions -->
        <div class="bg-gray-50 dark:bg-gray-800/50 px-4 py-3 flex justify-between items-center border-t border-gray-200 dark:border-gray-700">
          <NuxtLink 
            :to="`/requests/${proposal.request_id}`"
            class="text-sm text-primary-600 dark:text-primary-400 hover:underline"
          >
            Voir la demande
          </NuxtLink>
          
          <div class="flex gap-2">
            <button 
              v-if="proposal.status === 'pending'"
              @click="showEditProposalModal(proposal)"
              class="px-3 py-1.5 text-sm rounded-full border border-gray-300 dark:border-gray-600 hover:bg-gray-100 dark:hover:bg-gray-700"
            >
              Modifier
            </button>
            
            <button 
              v-if="proposal.status === 'accepted'"
              class="px-3 py-1.5 bg-primary-600 text-white text-sm rounded-full inline-flex items-center"
            >
              <MessageCircle class="h-4 w-4 mr-1" />
              Contacter
            </button>
            
            <button 
              v-if="proposal.status === 'pending'"
              @click="confirmCancelProposal(proposal.id)"
              class="px-3 py-1.5 text-sm text-red-600 dark:text-red-400 rounded-full border border-gray-300 dark:border-gray-600 hover:bg-gray-100 dark:hover:bg-gray-700"
            >
              Annuler
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Edit Proposal Modal (simplified Twitter-style) -->
    <Teleport to="body">
      <div v-if="showEditModal" class="fixed inset-0 z-50 overflow-y-auto bg-black bg-opacity-50 flex items-center justify-center" @click.self="closeEditModal">
        <div class="bg-white dark:bg-gray-800 rounded-2xl max-w-lg w-full mx-4">
          <!-- Modal header -->
          <div class="flex justify-between items-center px-5 py-4 border-b border-gray-200 dark:border-gray-700">
            <h3 class="text-lg font-medium">Modifier la proposition</h3>
            <button @click="closeEditModal" class="text-gray-400 hover:text-gray-600 dark:hover:text-gray-300">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
              </svg>
            </button>
          </div>
          
          <!-- Modal content -->
          <div class="p-5">
            <form @submit.prevent="updateProposal" class="space-y-4">
              <div>
                <input
                  v-model.number="editForm.price"
                  type="number"
                  min="0"
                  step="1000"
                  placeholder="Prix (XAF)"
                  required
                  class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg dark:bg-gray-700 dark:text-white"
                />
              </div>
              
              <div>
                <input
                  v-model.number="editForm.estimated_days"
                  type="number"
                  min="1"
                  max="365"
                  placeholder="Délai de livraison (jours)"
                  required
                  class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg dark:bg-gray-700 dark:text-white"
                />
              </div>
              
              <div>
                <textarea
                  v-model="editForm.message"
                  rows="5"
                  placeholder="Votre message au client"
                  required
                  class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg dark:bg-gray-700 dark:text-white"
                ></textarea>
              </div>
              
              <div class="flex justify-end">
                <button
                  type="submit"
                  class="px-4 py-2 bg-primary-600 text-white rounded-full text-sm font-medium"
                  :disabled="isSubmitting"
                >
                  <span v-if="isSubmitting" class="flex items-center">
                    <svg class="animate-spin -ml-1 mr-2 h-4 w-4 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                      <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                      <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                    </svg>
                    Enregistrement...
                  </span>
                  <span v-else>Mettre à jour</span>
                </button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </Teleport>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { Search, ClipboardIcon, CalendarIcon, UserIcon, MessageCircle, SearchIcon } from 'lucide-vue-next'

const supabase = useSupabaseClient()
const user = useSupabaseUser()
const toast = useToast()

const isLoading = ref(true)
const proposals = ref([])
const activeFilter = ref('all')
const searchQuery = ref('')

// Edit modal
const showEditModal = ref(false)
const editingProposal = ref(null)
const isSubmitting = ref(false)
const editForm = ref({
  price: 0,
  estimated_days: 1,
  message: ''
})

// Statistiques
const stats = computed(() => {
  const total = proposals.value.length
  const accepted = proposals.value.filter(p => p.status === 'accepted').length
  const pending = proposals.value.filter(p => p.status === 'pending').length
  
  return {
    total,
    accepted,
    pending,
    declined: total - accepted - pending,
    conversion: total > 0 ? Math.round((accepted / total) * 100) : 0
  }
})

// Filtrage des propositions
const filteredProposals = computed(() => {
  return proposals.value.filter(proposal => {
    // Filtre par statut
    const statusMatch = 
      activeFilter.value === 'all' || 
      (activeFilter.value === 'pending' && proposal.status === 'pending') ||
      (activeFilter.value === 'accepted' && proposal.status === 'accepted') ||
      (activeFilter.value === 'declined' && proposal.status === 'declined')
    
    // Filtre par recherche
    const searchMatch = 
      searchQuery.value === '' || 
      proposal.request_title.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
      proposal.message.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
      proposal.client_name.toLowerCase().includes(searchQuery.value.toLowerCase())
    
    return statusMatch && searchMatch
  })
})

// Récupérer les propositions
const fetchProposals = async () => {
  isLoading.value = true
  
  try {
    let query = supabase
      .from('proposals')
      .select(`
        *,
        request:request_id(
          id, 
          title, 
          description,
          client:client_id(first_name, last_name, avatar_url)
        )
      `)
    
    // L'expert ne voit que ses propres propositions
    query = query.eq('expert_id', user.value.id)
    
    // Trier par date
    query = query.order('created_at', { ascending: false })
    
    const { data, error } = await query
    
    if (error) throw error
    
    proposals.value = data.map(proposal => ({
      ...proposal,
      request_title: proposal.request.title,
      client_name: `${proposal.request.client.first_name} ${proposal.request.client.last_name}`,
      client_avatar: proposal.request.client.avatar_url,
      formatted_price: new Intl.NumberFormat('fr-FR', { style: 'currency', currency: 'EUR' }).format(proposal.price)
    }))
  } catch (error) {
    console.error('Erreur lors de la récupération des propositions:', error)
    toast.error('Erreur lors du chargement des propositions')
  } finally {
    isLoading.value = false
  }
}

// Formater la date
const formatDate = (dateString) => {
  const date = new Date(dateString)
  return new Intl.DateTimeFormat('fr-FR', {
    day: 'numeric',
    month: 'long',
    year: 'numeric'
  }).format(date)
}

// Obtenir la classe CSS pour le statut
const getStatusClass = (status) => {
  switch (status) {
    case 'pending':
      return 'bg-blue-100 text-blue-800 dark:bg-blue-900/30 dark:text-blue-400'
    case 'accepted':
      return 'bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-400'
    case 'declined':
      return 'bg-red-100 text-red-800 dark:bg-red-900/30 dark:text-red-400'
    default:
      return 'bg-gray-100 text-gray-800 dark:bg-gray-700 dark:text-gray-300'
  }
}

// Obtenir le libellé du statut
const getStatusLabel = (status) => {
  switch (status) {
    case 'pending':
      return 'En attente'
    case 'accepted':
      return 'Acceptée'
    case 'declined':
      return 'Refusée'
    default:
      return status
  }
}

// Annuler une proposition
const confirmCancelProposal = async (proposalId) => {
  if (confirm('Êtes-vous sûr de vouloir annuler cette proposition ? Cette action est irréversible.')) {
    try {
      const { error } = await supabase
        .from('proposals')
        .delete()
        .eq('id', proposalId)
      
      if (error) throw error
      
      // Mettre à jour la liste
      proposals.value = proposals.value.filter(p => p.id !== proposalId)
      
      toast.success('Proposition annulée avec succès')
    } catch (error) {
      console.error('Erreur lors de l\'annulation de la proposition:', error)
      toast.error('Une erreur est survenue')
    }
  }
}

// Ouvrir le modal d'édition
const showEditProposalModal = (proposal) => {
  editingProposal.value = proposal
  editForm.value = {
    price: proposal.price,
    estimated_days: proposal.estimated_days,
    message: proposal.message
  }
  showEditModal.value = true
}

// Fermer le modal d'édition
const closeEditModal = () => {
  showEditModal.value = false
  editingProposal.value = null
}

// Mettre à jour une proposition
const updateProposal = async () => {
  if (!editingProposal.value) return
  
  isSubmitting.value = true
  
  try {
    const { error } = await supabase
      .from('proposals')
      .update({
        price: editForm.value.price,
        estimated_days: editForm.value.estimated_days,
        message: editForm.value.message
      })
      .eq('id', editingProposal.value.id)
    
    if (error) throw error
    
    // Mettre à jour la liste locale
    const index = proposals.value.findIndex(p => p.id === editingProposal.value.id)
    if (index !== -1) {
      proposals.value[index] = {
        ...proposals.value[index],
        price: editForm.value.price,
        estimated_days: editForm.value.estimated_days,
        message: editForm.value.message,
        formatted_price: new Intl.NumberFormat('fr-FR', { style: 'currency', currency: 'EUR' }).format(editForm.value.price)
      }
    }
    
    toast.success('Proposition mise à jour avec succès')
    closeEditModal()
  } catch (error) {
    console.error('Erreur lors de la mise à jour de la proposition:', error)
    toast.error('Une erreur est survenue')
  } finally {
    isSubmitting.value = false
  }
}

// Initialisation
onMounted(() => {
  fetchProposals()
})

function resetForm() {
  editForm.price = 0
  editForm.estimated_days = 1
  editForm.message = ''
}
definePageMeta({
  middleware: ['auth'],
  layout: 'account'
})
</script>

<style scoped>
.line-clamp-2 {
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
</style> 