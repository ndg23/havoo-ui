<template>
  <div class="min-h-screen bg-white dark:bg-gray-900">
    <!-- Header avec style Apple -->
    <header class="sticky top-0 z-10 bg-white/80 dark:bg-gray-900/80 backdrop-blur-md border-b border-gray-100/50 dark:border-gray-800/50">
      <div class="max-w-2xl mx-auto px-6 py-4">
        <div class="flex items-center justify-between">
          <div class="flex items-center gap-4">
            <h1 class="text-2xl font-medium text-gray-900 dark:text-white">
              Missions
            </h1>
            <span class="text-sm font-medium text-gray-500 dark:text-gray-400">
              {{ filteredMissions.length }} disponibles
            </span>
          </div>
          
          <NuxtLink
            to="/requests/new"
            class="inline-flex items-center px-5 py-2.5 rounded-full 
                   bg-gray-900 dark:bg-white
                   text-white dark:text-gray-900
                   hover:bg-gray-800 dark:hover:bg-gray-100
                   transition-all duration-200 font-medium text-sm"
          >
            <Plus class="h-4 w-4 mr-2" />
            Publier
          </NuxtLink>
        </div>
      </div>
    </header>

    <main class="max-w-2xl mx-auto px-6 py-6">
      <!-- Barre de recherche -->
      <div class="mb-6">
        <div class="relative">
          <input
            v-model="searchQuery"
            type="text"
            placeholder="Rechercher une mission..."
            class="w-full pl-12 pr-4 py-3.5 rounded-2xl
                   bg-gray-50 dark:bg-gray-800
                   border border-gray-200 dark:border-gray-700
                   focus:ring-2 focus:ring-primary-500 focus:border-transparent
                   text-gray-900 dark:text-white placeholder-gray-500 dark:placeholder-gray-400"
          />
          <Search class="absolute left-4 top-1/2 -translate-y-1/2 h-5 w-5 text-gray-400" />
        </div>
      </div>

      <!-- Filtres rapides -->
      <div class="flex gap-2 overflow-x-auto pb-4 scrollbar-hide">
        <button
          v-for="filter in quickFilters"
          :key="filter.value"
          @click="activeFilter = filter.value"
          class="flex items-center px-4 py-2 rounded-full text-sm font-medium whitespace-nowrap transition-all"
          :class="[
            activeFilter === filter.value
              ? 'bg-gray-900 dark:bg-white text-white dark:text-gray-900'
              : 'bg-gray-100 dark:bg-gray-800 text-gray-700 dark:text-gray-300 hover:bg-gray-200 dark:hover:bg-gray-700'
          ]"
        >
          <component :is="filter.icon" class="h-4 w-4 mr-2" />
          {{ filter.label }}
        </button>
      </div>

      <!-- Liste des missions -->
      <div class="space-y-4">
        <!-- Loading state -->
        <div v-if="isLoading" class="flex justify-center py-12">
          <div class="animate-spin rounded-full h-8 w-8 border-b-2 border-primary-500"></div>
        </div>

        <!-- Liste des missions -->
        <template v-else>
          <div v-if="filteredMissions.length > 0" class="space-y-4">
            <div 
              v-for="mission in filteredMissions" 
              :key="mission.id"
              class="bg-white dark:bg-gray-800 rounded-2xl p-6 shadow-sm hover:shadow-md transition-all duration-200 border border-gray-100 dark:border-gray-700"
            >
              <!-- En-tête de la mission -->
              <div class="flex justify-between items-start mb-4">
                <div>
                  <h3 class="text-lg font-semibold text-gray-900 dark:text-white mb-1">
                    {{ mission.title }}
                  </h3>
                  <div class="flex items-center gap-3 text-sm text-gray-500 dark:text-gray-400">
                    <span>{{ formatTimeAgo(mission.created_at) }}</span>
                    <span>•</span>
                    <span>{{ formatPrice(mission.budget) }}</span>
                    <span v-if="mission.location">•</span>
                    <span v-if="mission.location">{{ mission.location }}</span>
                  </div>
                </div>
                
                <!-- Badge statut -->
                <span 
                  class="px-3 py-1 rounded-full text-sm font-medium"
                  :class="getMissionStatusClass(mission.status)"
                >
                  {{ getMissionStatusLabel(mission.status) }}
                </span>
              </div>

              <!-- Description -->
              <p class="text-gray-600 dark:text-gray-300 mb-4 line-clamp-2">
                {{ mission.description }}
              </p>

              <!-- Footer avec actions -->
              <div class="flex items-center justify-between mt-4 pt-4 border-t border-gray-100 dark:border-gray-700">
                <!-- Info client -->
                <div class="flex items-center gap-2">
                  <div class="h-8 w-8 rounded-full bg-gray-100 dark:bg-gray-700 flex items-center justify-center">
                    <span class="text-sm font-medium text-gray-600 dark:text-gray-300">
                      {{ mission.client?.first_name?.[0] }}{{ mission.client?.last_name?.[0] }}
                    </span>
                  </div>
                  <span class="text-sm text-gray-600 dark:text-gray-300">
                    {{ mission.client?.first_name }} {{ mission.client?.last_name }}
                  </span>
                </div>

                <!-- Bouton d'action -->
                <div>
                  <NuxtLink
                    v-if="!canMakeProposal(mission)"
                    :to="`/requests/${mission.id}`"
                    class="inline-flex items-center px-4 py-2 rounded-full bg-gray-100 dark:bg-gray-700 text-gray-700 dark:text-gray-300 hover:bg-gray-200 dark:hover:bg-gray-600 transition-colors text-sm font-medium"
                  >
                    Voir les détails
                  </NuxtLink>
                  <button
                    v-else
                    @click="openProposalModal(mission)"
                    class="inline-flex items-center px-4 py-2 rounded-full bg-primary-500 hover:bg-primary-600 text-white transition-colors text-sm font-medium"
                  >
                    Faire une proposition
                  </button>
                </div>
              </div>
            </div>
          </div>

          <!-- État vide -->
          <div 
            v-else
            class="text-center py-12"
          >
            <InboxIcon class="mx-auto h-12 w-12 text-gray-400 dark:text-gray-600 mb-4" />
            <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-2">
              Aucune mission trouvée
            </h3>
            <p class="text-gray-500 dark:text-gray-400">
              Essayez de modifier vos filtres ou revenez plus tard
            </p>
          </div>
        </template>
      </div>
    </main>

    <!-- Modal de proposition -->
    <UModal v-model="isProposalModalOpen">
      <div class="p-6">
        <h2 class="text-xl font-semibold mb-4">
          Faire une proposition
        </h2>
        <form @submit.prevent="submitProposal" class="space-y-4">
          <div>
            <label class="block text-sm font-medium mb-1">Prix proposé</label>
            <input
              v-model="proposalForm.price"
              type="number"
              class="w-full px-4 py-2 rounded-xl border border-gray-200 dark:border-gray-700"
              required
            />
          </div>
          <div>
            <label class="block text-sm font-medium mb-1">Durée (en jours)</label>
            <input
              v-model="proposalForm.duration"
              type="number"
              class="w-full px-4 py-2 rounded-xl border border-gray-200 dark:border-gray-700"
              required
            />
          </div>
          <div>
            <label class="block text-sm font-medium mb-1">Message</label>
            <textarea
              v-model="proposalForm.message"
              rows="4"
              class="w-full px-4 py-2 rounded-xl border border-gray-200 dark:border-gray-700"
              required
            ></textarea>
          </div>
          <div class="flex justify-end gap-3 mt-6">
            <button
              type="button"
              @click="closeProposalModal"
              class="px-4 py-2 rounded-xl border border-gray-200 dark:border-gray-700"
            >
              Annuler
            </button>
            <button
              type="submit"
              :disabled="isSubmitting"
              class="px-4 py-2 rounded-xl bg-primary-500 text-white"
            >
              {{ isSubmitting ? 'Envoi...' : 'Envoyer' }}
            </button>
          </div>
        </form>
      </div>
    </UModal>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { Dialog, DialogPanel, TransitionRoot, TransitionChild } from '@headlessui/vue'
// import { useSupabaseClient, useSupabaseUser } from '#supabase/client'
import { OhVueIcon as VIcon, addIcons } from 'oh-vue-icons'
import { 
  BiSearch,
  BiGrid,
  BiClockHistory,
  BiCurrencyDollar,
  BiLightning,
  BiCodeSlash,
  BiPalette,
  BiPencil,
  BiCamera,
  BiGraphUp,
  BiTranslate,
  BiPeople,
  BiPersonWorkspace,
  BiBrush,
  BiCameraVideo,
  BiBriefcase,
  BiGeoAlt,
  BiEye,
  BiArrowRight,
  BiPlusLg,
  BiInbox
} from 'oh-vue-icons/icons'
import { 
  Search, Plus, Briefcase, Clock, Filter,
  CheckCircle, XCircle, InboxIcon
} from 'lucide-vue-next'

// Mise à jour des icônes
addIcons(
  BiSearch,
  BiGrid,
  BiClockHistory,
  BiCurrencyDollar,
  BiLightning,
  BiCodeSlash,
  BiPalette,
  BiPencil,
  BiCamera,
  BiGraphUp,
  BiTranslate,
  BiPeople,
  BiPersonWorkspace,
  BiBrush,
  BiCameraVideo,
  BiBriefcase,
  BiGeoAlt,
  BiEye,
  BiArrowRight,
  BiPlusLg,
  BiInbox
)

const supabase = useSupabaseClient()
const user = useSupabaseUser()

// États
const missions = ref([])
const isLoading = ref(true)
const searchQuery = ref('')
const activeFilter = ref('all')

// Nouveaux états pour les filtres
const showAdvancedFilters = ref(false)
const filters = ref({
  minBudget: '',
  maxBudget: '',
  professions: [],
  deliveryTime: '',
  location: 'all'
})

// Filtres rapides
const quickFilters = [
  { label: 'Toutes', value: 'all', icon: 'bi-grid' },
  { label: 'Plus récentes', value: 'recent', icon: 'bi-clock-history' },
  { label: 'Budget élevé', value: 'high-budget', icon: 'bi-currency-dollar' },
  { label: 'Urgentes', value: 'urgent', icon: 'bi-lightning' }
]

// Mapping des icônes par profession
const professionIcons = {
  'Développeur': 'bi-code-slash',
  'Designer': 'bi-palette',
  'Rédacteur': 'bi-pencil',
  'Photographe': 'bi-camera',
  'Marketeur': 'bi-graph-up',
  'Traducteur': 'bi-translate',
  'Community Manager': 'bi-people',
  'Consultant': 'bi-person-workspace',
  'Graphiste': 'bi-brush',
  'Monteur vidéo': 'bi-camera-video',
  'default': 'bi-briefcase'
}

// Liste des professions (à charger depuis l'API)
const professions = ref([
  { id: 1, name: 'Développeur' },
  { id: 2, name: 'Designer' },
  { id: 3, name: 'Rédacteur' },
  // ... autres professions
])

// Toggle profession dans les filtres
const toggleProfession = (id) => {
  const index = filters.value.professions.indexOf(id)
  if (index === -1) {
    filters.value.professions.push(id)
  } else {
    filters.value.professions.splice(index, 1)
  }
}

// Fetch des missions avec les professions
const fetchMissions = async () => {
  isLoading.value = true
  try {
    const { data, error } = await supabase
      .from('missions')
      .select(`
        *,
        client:profiles!missions_client_id_fkey(
          id,
          first_name,
          last_name,
          avatar_url
        ),
        deals(
          id,
          expert_id,
          status
        )
      `)
      .order('created_at', { ascending: false })

    if (error) throw error
    missions.value = data
  } catch (error) {
    console.error('Erreur lors de la récupération des missions:', error)
  } finally {
    isLoading.value = false
  }
}

// Helper pour obtenir l'icône d'une profession
const getProfessionIcon = (professionName) => {
  // Recherche exacte
  if (professionIcons[professionName]) {
    return professionIcons[professionName]
  }

  // Recherche par mot-clé
  const normalizedName = professionName?.toLowerCase() || ''
  if (normalizedName.includes('develop')) return 'bi-code-slash'
  if (normalizedName.includes('design')) return 'bi-palette'
  if (normalizedName.includes('photo')) return 'bi-camera'
  if (normalizedName.includes('video')) return 'bi-camera-video'
  if (normalizedName.includes('market')) return 'bi-graph-up'
  if (normalizedName.includes('rédac')) return 'bi-pencil'
  if (normalizedName.includes('traduc')) return 'bi-translate'
  if (normalizedName.includes('community')) return 'bi-people'
  if (normalizedName.includes('consult')) return 'bi-person-workspace'
  if (normalizedName.includes('graph')) return 'bi-brush'

  return professionIcons.default
}

// Filtrage des missions
const filteredMissions = computed(() => {
  let filtered = [...missions.value]

  // Filtre par recherche
  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase()
    filtered = filtered.filter(m => 
      m.title.toLowerCase().includes(query) ||
      m.description.toLowerCase().includes(query)
    )
  }

  // Filtre par catégorie
  if (filters.value.category !== 'all') {
    filtered = filtered.filter(m => m.category === filters.value.category)
  }

  // Filtre par localisation
  if (filters.value.location !== 'all') {
    filtered = filtered.filter(m => {
      if (filters.value.location === 'remote') return !m.location
      return m.location // onsite
    })
  }

  // Filtres rapides
  switch (activeFilter.value) {
    case 'recent':
      filtered = [...filtered].sort((a, b) => 
        new Date(b.created_at) - new Date(a.created_at)
      )
      break
    case 'high-budget':
      filtered = [...filtered].sort((a, b) => b.budget - a.budget)
      break
    case 'urgent':
      filtered = filtered.filter(mission => {
        const deadline = new Date(mission.deadline)
        const now = new Date()
        const diffDays = Math.ceil((deadline - now) / (1000 * 60 * 60 * 24))
        return diffDays <= 7
      })
      break
  }

  return filtered
})

// Formatage des données
const formatTimeAgo = (date) => {
  if (!date) return ''
  const now = new Date()
  const past = new Date(date)
  const diffTime = Math.abs(now - past)
  const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24))

  if (diffDays === 0) return "Aujourd'hui"
  if (diffDays === 1) return "Hier"
  if (diffDays < 7) return `Il y a ${diffDays} jours`
  if (diffDays < 30) return `Il y a ${Math.floor(diffDays / 7)} semaine${Math.floor(diffDays / 7) > 1 ? 's' : ''}`
  return `Il y a ${Math.floor(diffDays / 30)} mois`
}

const formatDate = (date) => {
  if (!date) return ''
  return new Date(date).toLocaleDateString('fr-FR', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  })
}

const formatPrice = (price) => {
  if (!price) return 'Prix à définir'
  return new Intl.NumberFormat('fr-FR', {
    style: 'currency',
    currency: 'XOF',
    maximumFractionDigits: 0
  }).format(price)
}

const formatDeliveryTime = (days) => {
  if (!days) return 'Non spécifié'
  return days === 1 ? '1 jour' : `${days} jours`
}

// État pour la modal et le formulaire de proposition
const isProposalModalOpen = ref(false)
const selectedMission = ref(null)
const isSubmitting = ref(false)
const proposalForm = ref({
  price: '',
  duration: '',
  message: ''
})

// Vérifier si l'utilisateur peut faire une proposition
const canMakeProposal = (mission) => {
  if (!user.value || !mission) return false
  return (
    mission.status === 'open' && 
    !hasProposal(mission) && 
    user.value.id !== mission.client_id
  )
}

// Vérifier si l'utilisateur a déjà fait une proposition
const hasProposal = (mission) => {
  return mission.deals?.some(deal => 
    deal.expert_id === user.value?.id && 
    ['proposal', 'accepted', 'in_progress'].includes(deal.status)
  )
}

// Ouvrir la modal de proposition
const openProposalModal = (mission) => {
  selectedMission.value = mission
  proposalForm.value = {
    price: mission.budget || '',
    duration: '',
    message: ''
  }
  isProposalModalOpen.value = true
}

// Fermer la modal
const closeProposalModal = () => {
  isProposalModalOpen.value = false
  selectedMission.value = null
  proposalForm.value = {
    price: '',
    duration: '',
    message: ''
  }
}

// Soumettre la proposition
const submitProposal = async () => {
  if (!selectedMission.value || !user.value) return

  isSubmitting.value = true
  try {
    const { data, error } = await supabase
      .from('deals')
      .insert({
        mission_id: selectedMission.value.id,
        expert_id: user.value.id,
        client_id: selectedMission.value.client_id,
        price: proposalForm.value.price,
        duration: proposalForm.value.duration,
        message: proposalForm.value.message,
        status: 'proposal'
      })

    if (error) throw error

    // Succès
    closeProposalModal()
    const toast = useToast()
    toast.add({
      title: 'Proposition envoyée',
      description: 'Votre proposition a été envoyée avec succès',
      color: 'green'
    })
    
    // Rafraîchir les missions pour mettre à jour l'état
    await fetchMissions()
  } catch (error) {
    console.error('Erreur lors de l\'envoi de la proposition:', error)
    const toast = useToast()
    toast.add({
      title: 'Erreur',
      description: 'Impossible d\'envoyer votre proposition',
      color: 'red'
    })
  } finally {
    isSubmitting.value = false
  }
}

// Fonction pour obtenir la classe CSS du statut
const getMissionStatusClass = (status) => {
  switch (status) {
    case 'open':
      return 'bg-green-50 dark:bg-green-900/20 text-green-600'
    case 'assigned':
      return 'bg-blue-50 dark:bg-blue-900/20 text-blue-600'
    case 'completed':
      return 'bg-gray-50 dark:bg-gray-900/20 text-gray-600'
    case 'cancelled':
      return 'bg-red-50 dark:bg-red-900/20 text-red-600'
    default:
      return 'bg-gray-50 dark:bg-gray-900/20 text-gray-600'
  }
}

// Fonction pour obtenir le libellé du statut
const getMissionStatusLabel = (status) => {
  switch (status) {
    case 'open':
      return 'Ouverte'
    case 'assigned':
      return 'En cours'
    case 'completed':
      return 'Terminée'
    case 'cancelled':
      return 'Annulée'
    default:
      return status
  }
}

// Lifecycle
onMounted(() => {
  fetchMissions()
})
</script>

<style scoped>
/* Masquer la scrollbar tout en gardant le défilement */
.scrollbar-hide {
  -ms-overflow-style: none;
  scrollbar-width: none;
}
.scrollbar-hide::-webkit-scrollbar {
  display: none;
}

/* Animation d'entrée des cartes */
@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.mission-card {
  animation: fadeInUp 0.3s ease-out;
}
</style>