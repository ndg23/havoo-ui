<template>
  <div class="max-w-4xl mx-auto px-4 pt-5 pb-16">
    <!-- Ajout du header avec bouton de retour au profil -->
    <AccountHeader 
      title="Mes propositions" 
      subtitle="Gérez les demandes auxquelles vous avez répondu" 
    />

    <!-- En-tête de la page -->
    <div class="mb-7 bg-white dark:bg-gray-800 rounded-xl p-5 border-l-4 border-primary-500 shadow-sm">
      <h1 class="text-2xl font-bold text-gray-900 dark:text-white flex items-center">
        <SendIcon class="h-6 w-6 mr-3 text-primary-600 dark:text-primary-400" />
        Mes propositions
      </h1>
      <p class="text-gray-600 dark:text-gray-400 mt-1">
        Suivez l'état de vos propositions envoyées aux clients
      </p>
    </div>

    <!-- Redirection si non expert -->
    <div v-if="!isExpert" class="bg-white dark:bg-gray-800 rounded-xl p-8 text-center border border-gray-200 dark:border-gray-700 mb-7">
      <div class="mb-4 flex justify-center">
        <div class="bg-amber-100 dark:bg-amber-900/30 p-4 rounded-full">
          <AlertTriangle class="h-8 w-8 text-amber-600 dark:text-amber-400" />
        </div>
      </div>
      <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-2">Mode Expert nécessaire</h3>
      <p class="text-gray-600 dark:text-gray-400 mb-6 max-w-md mx-auto">
        Cette section est réservée aux experts. Activez le mode expert dans votre profil pour proposer vos services.
      </p>
      <NuxtLink to="/account" class="px-5 py-2.5 bg-primary-600 hover:bg-primary-700 text-white text-sm font-medium rounded-full shadow-sm">
        Retour au profil
      </NuxtLink>
    </div>

    <template v-else>
      <!-- Stats et aperçu rapide -->
      <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mb-7">
        <div class="bg-white dark:bg-gray-800 rounded-xl p-4 border border-gray-200 dark:border-gray-700 text-center">
          <div class="text-2xl font-bold text-gray-900 dark:text-gray-100">{{ stats.total }}</div>
          <div class="text-xs font-medium text-gray-600 dark:text-gray-400">Total propositions</div>
        </div>
        <div class="bg-white dark:bg-gray-800 rounded-xl p-4 border border-gray-200 dark:border-gray-700 text-center">
          <div class="text-2xl font-bold text-green-600 dark:text-green-400">{{ stats.accepted }}</div>
          <div class="text-xs font-medium text-gray-600 dark:text-gray-400">Acceptées</div>
        </div>
        <div class="bg-white dark:bg-gray-800 rounded-xl p-4 border border-gray-200 dark:border-gray-700 text-center">
          <div class="text-2xl font-bold text-blue-600 dark:text-blue-400">{{ stats.pending }}</div>
          <div class="text-xs font-medium text-gray-600 dark:text-gray-400">En attente</div>
        </div>
        <div class="bg-white dark:bg-gray-800 rounded-xl p-4 border border-gray-200 dark:border-gray-700 text-center">
          <div class="text-2xl font-bold text-amber-600 dark:text-amber-400">{{ stats.conversion }}%</div>
          <div class="text-xs font-medium text-gray-600 dark:text-gray-400">Taux de conversion</div>
        </div>
      </div>

      <!-- Filtres et recherche -->
      <div class="mb-7 flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div class="flex items-center gap-2 flex-wrap">
          <button 
            @click="activeFilter = 'all'"
            class="px-4 py-2 rounded-full text-sm font-medium transition-all"
            :class="activeFilter === 'all' ? 'bg-primary-100 text-primary-800 dark:bg-primary-900/30 dark:text-primary-400' : 'bg-gray-100 text-gray-800 dark:bg-gray-800 dark:text-gray-400 hover:bg-gray-200'"
          >
            Toutes
          </button>
          <button 
            @click="activeFilter = 'pending'"
            class="px-4 py-2 rounded-full text-sm font-medium transition-all"
            :class="activeFilter === 'pending' ? 'bg-primary-100 text-primary-800 dark:bg-primary-900/30 dark:text-primary-400' : 'bg-gray-100 text-gray-800 dark:bg-gray-800 dark:text-gray-400 hover:bg-gray-200'"
          >
            En attente
          </button>
          <button 
            @click="activeFilter = 'accepted'"
            class="px-4 py-2 rounded-full text-sm font-medium transition-all"
            :class="activeFilter === 'accepted' ? 'bg-primary-100 text-primary-800 dark:bg-primary-900/30 dark:text-primary-400' : 'bg-gray-100 text-gray-800 dark:bg-gray-800 dark:text-gray-400 hover:bg-gray-200'"
          >
            Acceptées
          </button>
          <button 
            @click="activeFilter = 'declined'"
            class="px-4 py-2 rounded-full text-sm font-medium transition-all"
            :class="activeFilter === 'declined' ? 'bg-primary-100 text-primary-800 dark:bg-primary-900/30 dark:text-primary-400' : 'bg-gray-100 text-gray-800 dark:bg-gray-800 dark:text-gray-400 hover:bg-gray-200'"
          >
            Refusées
          </button>
        </div>

        <div class="relative">
          <Search class="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-gray-400" />
          <input 
            type="text" 
            placeholder="Rechercher dans mes propositions..."
            v-model="searchQuery"
            class="pl-10 pr-4 py-2 w-full sm:w-64 rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-800 dark:text-gray-200 focus:ring-2 focus:ring-primary-500 focus:border-primary-500 dark:focus:ring-primary-600 dark:focus:border-primary-600"
          />
        </div>
      </div>

      <!-- Chargement -->
      <div v-if="isLoading" class="bg-white dark:bg-gray-800 rounded-xl p-12 flex flex-col items-center">
        <div class="h-10 w-10 border-4 border-primary-500 border-t-transparent rounded-full animate-spin"></div>
        <p class="mt-4 text-gray-600 dark:text-gray-400">Chargement de vos propositions...</p>
      </div>

      <!-- Aucune proposition -->
      <div v-else-if="filteredProposals.length === 0" class="bg-white dark:bg-gray-800 rounded-xl p-8 text-center border border-gray-200 dark:border-gray-700">
        <div class="mb-4 flex justify-center">
          <div class="bg-gray-100 dark:bg-gray-700 p-4 rounded-full">
            <ClipboardIcon class="h-8 w-8 text-gray-500 dark:text-gray-400" />
          </div>
        </div>
        <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-2">Aucune proposition trouvée</h3>
        <p class="text-gray-600 dark:text-gray-400 mb-6">
          {{ activeFilter === 'all' 
            ? "Vous n'avez pas encore envoyé de proposition. Parcourez les demandes disponibles pour démarrer." 
            : activeFilter === 'pending' 
            ? "Vous n'avez aucune proposition en attente actuellement."
            : activeFilter === 'accepted'
            ? "Aucune de vos propositions n'a encore été acceptée."
            : "Aucune de vos propositions n'a été refusée."
          }}
        </p>
        <NuxtLink to="/requests" class="px-5 py-2.5 bg-primary-600 hover:bg-primary-700 text-white text-sm font-medium rounded-full shadow-sm inline-flex items-center">
          <SearchIcon class="h-4 w-4 mr-2" />
          Explorer les demandes
        </NuxtLink>
      </div>

      <!-- Liste des propositions -->
      <div v-else class="space-y-4">
        <div v-for="proposal in filteredProposals" :key="proposal.id" 
          class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 overflow-hidden hover:shadow-md transition-shadow duration-200">
          
          <!-- Informations principales -->
          <div class="p-5">
            <div class="flex justify-between items-start mb-3">
              <div>
                <h3 class="text-lg font-medium text-gray-900 dark:text-white">{{ proposal.request_title }}</h3>
                <div class="flex flex-wrap gap-2 mt-1">
                  <span 
                    class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium"
                    :class="getStatusClass(proposal.status)"
                  >
                    {{ getStatusLabel(proposal.status) }}
                  </span>
                  <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-800 dark:bg-gray-700 dark:text-gray-300">
                    {{ proposal.category }}
                  </span>
                  <span v-if="proposal.is_urgent" class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800 dark:bg-red-900/30 dark:text-red-400">
                    Urgent
                  </span>
                </div>
              </div>
              <div class="text-right">
                <div class="text-lg font-semibold text-gray-900 dark:text-white">{{ proposal.amount }}€</div>
                <div class="text-xs text-gray-500 dark:text-gray-400">
                  Proposé le {{ formatDate(proposal.created_at) }}
                </div>
              </div>
            </div>
            
            <!-- Aperçu du message -->
            <div class="text-sm text-gray-600 dark:text-gray-400 mb-4 line-clamp-2">
              {{ proposal.message }}
            </div>
            
            <!-- Délai et client -->
            <div class="flex flex-wrap justify-between items-center text-sm">
              <div class="flex items-center text-gray-600 dark:text-gray-400">
                <CalendarIcon class="h-4 w-4 mr-1.5" />
                <span>Délai: <span class="font-medium">{{ proposal.estimated_days }} jours</span></span>
              </div>
              <div class="flex items-center text-gray-600 dark:text-gray-400">
                <UserIcon class="h-4 w-4 mr-1.5" />
                <span>Client: <span class="font-medium">{{ proposal.client_name }}</span></span>
              </div>
            </div>
          </div>
          
          <!-- Actions -->
          <div class="border-t border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-800 px-5 py-3 flex justify-between items-center">
            <div>
              <NuxtLink 
                :to="`/requests/${proposal.request_id}`"
                class="text-sm text-primary-600 dark:text-primary-400 hover:text-primary-700 dark:hover:text-primary-300 font-medium"
              >
                Voir la demande
              </NuxtLink>
            </div>
            
            <div class="flex gap-2">
              <button 
                v-if="proposal.status === 'pending'"
                @click="showEditProposalModal(proposal)"
                class="px-3 py-1.5 bg-white dark:bg-gray-700 text-gray-700 dark:text-gray-300 text-sm font-medium rounded-md border border-gray-300 dark:border-gray-600 hover:bg-gray-50 dark:hover:bg-gray-600 transition-colors"
              >
                Modifier
              </button>
              
              <button 
                v-if="proposal.status === 'accepted'"
                class="px-3 py-1.5 bg-primary-600 hover:bg-primary-700 text-white text-sm font-medium rounded-md transition-colors"
              >
                <MessageCircle class="h-4 w-4 inline-block mr-1" />
                Contacter
              </button>
              
              <button 
                v-if="proposal.status === 'pending'"
                @click="confirmCancelProposal(proposal.id)"
                class="px-3 py-1.5 bg-white dark:bg-gray-700 text-red-600 dark:text-red-400 text-sm font-medium rounded-md border border-gray-300 dark:border-gray-600 hover:bg-gray-50 dark:hover:bg-gray-600 transition-colors"
              >
                Annuler
              </button>
            </div>
          </div>
        </div>
      </div>
    </template>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { SendIcon, AlertTriangle, Search, ClipboardIcon, CalendarIcon, UserIcon, MessageCircle, SearchIcon } from 'lucide-vue-next'
import AccountHeader from '~/components/account/AccountHeader.vue'

const supabase = useSupabaseClient()
const user = useSupabaseUser()
const isExpert = ref(true)
const isLoading = ref(true)
const proposals = ref([])
const activeFilter = ref('all')
const searchQuery = ref('')

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
    const { data, error } = await supabase
      .from('proposals')
      .select('*')
      .eq('expert_id', user.value.id)
      .order('created_at', { ascending: false })
    
    if (error) throw error
    
    proposals.value = data || []
  } catch (error) {
    console.error('Erreur lors de la récupération des propositions:', error)
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
      
    } catch (error) {
      console.error('Erreur lors de l\'annulation de la proposition:', error)
      alert('Une erreur est survenue lors de l\'annulation de la proposition')
    }
  }
}

// Surveiller les changements du filtre actif ou de la requête de recherche
watch([activeFilter, searchQuery], () => {
  // Le calcul est fait automatiquement via le computed
})

// Initialisation
onMounted(() => {
  fetchProposals()
})

definePageMeta({
  layout: 'default'
})
</script>

<style scoped>
/* Animation des composants */
.rounded-xl {
  animation: fadeIn 0.4s ease;
  animation-fill-mode: both;
}

.space-y-4 > div {
  animation: fadeIn 0.4s ease;
  animation-fill-mode: both;
}

.space-y-4 > div:nth-child(1) { animation-delay: 0.05s; }
.space-y-4 > div:nth-child(2) { animation-delay: 0.1s; }
.space-y-4 > div:nth-child(3) { animation-delay: 0.15s; }
.space-y-4 > div:nth-child(4) { animation-delay: 0.2s; }
.space-y-4 > div:nth-child(5) { animation-delay: 0.25s; }

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(8px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* Style limitant le nombre de lignes (line-clamp) */
.line-clamp-2 {
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
</style> 