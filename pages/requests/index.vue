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
              class="bg-white dark:bg-gray-800 rounded-2xl p-6 border border-gray-100 dark:border-gray-700 cursor-pointer group transition-all duration-200
                hover:border-primary-500 dark:hover:border-primary-400"
            >
              <div @click="router.push(`/requests/${mission.id}`)">
                <!-- En-tête de la mission -->
                <div class="flex justify-between items-start mb-4">
                  <div>
                    <h3 class="text-lg font-semibold text-gray-900 dark:text-white mb-1 group-hover:text-primary-600 dark:group-hover:text-primary-400 transition-colors">
                      {{ mission.title }}
                    </h3>
                    <div class="flex items-center gap-3 text-sm text-gray-500 dark:text-gray-400">
                      <span class="flex items-center gap-1 text-emerald-600 dark:text-emerald-400 font-medium">
                        <UIcon name="i-heroicons-banknotes" class="w-4 h-4" />
                        {{ formatPrice(mission.budget) }}
                      </span>
                      <span class="text-gray-300 dark:text-gray-600">•</span>
                      <span class="flex items-center gap-1 font-medium">
                        <UIcon name="i-heroicons-clock" 
                          class="w-4 h-4"
                          :class="getDeadlineColor(mission.deadline)"
                        />
                        {{ formatDeadline(mission.deadline) }}
                      </span>
                      <span class="text-gray-300 dark:text-gray-600">•</span>
                      <span class="text-blue-600 dark:text-blue-400 font-medium">
                        {{ formatTimeAgo(mission.created_at) }}
                      </span>
                      <span v-if="mission.location" class="text-gray-300 dark:text-gray-600">•</span>
                      <span v-if="mission.location" class="flex items-center gap-1 text-purple-600 dark:text-purple-400 font-medium">
                        <UIcon name="i-heroicons-map-pin" class="w-4 h-4" />
                        {{ mission.location }}
                      </span>
                    </div>
                  </div>
                  
                  <!-- Badge statut -->
                  <div
                    class="flex items-center gap-1.5 px-3 py-1.5 text-sm font-medium whitespace-nowrap"
                    :class="`text-${getMissionStatusColor(mission.status)}-600 dark:text-${getMissionStatusColor(mission.status)}-400`"
                  >
                    <UIcon 
                      :name="getMissionStatusIcon(mission.status)" 
                      class="w-4 h-4" 
                    />
                    {{ getMissionStatusLabel(mission.status) }}
                  </div>
                </div>

                <!-- Description et actions -->
                <div class="space-y-4">
                  <p class="text-gray-600 dark:text-gray-300 line-clamp-2">
                    {{ mission.description }}
                  </p>

                  <!-- Client info -->
                  <div class="flex items-center justify-between pt-4 border-t border-gray-100 dark:border-gray-700">
                    <!-- Info client -->
                    <div class="flex items-center gap-3">
                      <UAvatar
                        :src="mission.client?.avatar_url"
                        :alt="`${mission.client?.first_name} ${mission.client?.last_name}`"
                        size="sm"
                      />
                      <div class="text-sm">
                        <div class="font-medium text-gray-900 dark:text-white flex items-center gap-2">
                          {{ mission.client?.first_name }} {{ mission.client?.last_name }}
                          <span class="text-gray-500 dark:text-gray-400 font-normal">
                            @{{ mission.client?.username || mission.client?.email?.split('@')[0] }}
                          </span>
                        </div>
                        <div class="text-gray-500 dark:text-gray-400 flex items-center gap-2">
                          <span class="flex items-center gap-1">
                            <UIcon name="i-heroicons-star" class="w-4 h-4 text-yellow-400" />
                            {{ mission.client?.rating || '0' }}
                          </span>
                          <span>•</span>
                          <span>{{ mission.client?.missions_count || '0' }} missions</span>
                          <span v-if="mission.client?.city">•</span>
                          <span v-if="mission.client?.city" class="flex items-center gap-1">
                            <UIcon name="i-heroicons-map-pin" class="w-4 h-4" />
                            {{ mission.client?.city }}
                          </span>
                        </div>
                      </div>
                    </div>
                    
                    <!-- Proposal count with Twitter 2023 style -->
                    <div class="flex items-center gap-2">
                      <div class="flex items-center gap-1.5 px-3 py-1.5 rounded-full bg-blue-50 dark:bg-blue-900/20 text-blue-600 dark:text-blue-400 font-medium text-sm">
                        <UIcon name="i-heroicons-chat-bubble-left-right" class="w-4 h-4" />
                        <span>{{ mission.deals.length || 0 }}</span>
                        <span class="text-blue-500/70 dark:text-blue-400/70">propositions</span>
                      </div>
                    </div>
                  </div>
                </div>
              </div>

              <!-- Bouton de proposition (isolé du conteneur parent) -->
              <div class="mt-4 flex justify-end">
                <UButton
                  v-if="mission.status === 'open' && canMakeProposal(mission)"
                  color="primary"
                  variant="soft"
                  icon="i-heroicons-paper-airplane"
                  class="rounded-full"
                  @click="openProposalModal(mission)"
                >
                  Faire une proposition
                </UButton>
                <UBadge
                  v-else-if="mission.status === 'open' && hasProposal(mission)"
                  color="gray"
                  variant="subtle"
                  class="rounded-full"
                >
                  Proposition envoyée
                </UBadge>
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

    <!-- Modal Faire une proposition -->
    <UModal v-model="showApplyModal">
      <!-- Header personnalisé -->
      <template #header>
        <div class="space-y-1 px-4 py-3 border-b border-gray-100 dark:border-gray-800 bg-gradient-to-r from-primary-500 to-primary-600 dark:from-primary-600 dark:to-primary-700">
          <h2 class="text-2xl font-bold text-white mb-1">
            Proposer une affaire
          </h2>
          <div class="text-sm text-primary-100 font-medium">
             pour
          </div>
          <div class="text-lg font-semibold text-white line-clamp-1">
            {{ selectedMission?.title }}
          </div>
          <div class="text-sm text-primary-100">
            Budget initial : {{ formatPrice(selectedMission?.budget) }}
          </div>
        </div>
      </template>

      <div class="space-y-8 p-4">
        <!-- Prix -->
        <div class="text-center">
          <label class="block text-sm font-medium text-gray-500 dark:text-gray-400 mb-2">
            Prix proposé
          </label>
          <div class="relative inline-block">
            <input
              v-model="price"
              type="number"
              class="text-6xl font-bold text-center bg-transparent focus:outline-none text-primary-600 dark:text-primary-400 tracking-tight w-full"
              min="0"
              step="1"
              @focus="$event.target.select()"
              @input="handlePriceInput"
            />
          </div>
        </div>

        <!-- Délai -->
        <div class="text-center">
          <label class="block text-sm font-medium text-gray-500 dark:text-gray-400 mb-2">
            Délai de livraison
          </label>
          <div class="relative inline-block">
            <span class="text-6xl font-bold text-primary-600 dark:text-primary-400 tracking-tight">
              {{ delay }}
            </span>
            <span class="ml-2 text-2xl font-medium text-gray-500 dark:text-gray-400">
              {{ delayUnit === 'days' ? 'jours' : delayUnit === 'weeks' ? 'sem.' : 'mois' }}
            </span>
            <div class="absolute -right-16 top-1/2 -translate-y-1/2 flex flex-col gap-2">
              <button
                class="rounded-full h-10 w-10 flex items-center justify-center border border-gray-200 dark:border-gray-700 hover:bg-primary-50 dark:hover:bg-primary-900/30 transition-colors"
                @click="delay++"
              >
                <PlusIcon class="h-5 w-5 text-primary-500" />
              </button>
              <button
                class="rounded-full h-10 w-10 flex items-center justify-center border border-gray-200 dark:border-gray-700 hover:bg-primary-50 dark:hover:bg-primary-900/30 transition-colors"
                @click="delay > 1 ? delay-- : null"
              >
                <MinusIcon class="h-5 w-5 text-primary-500" />
              </button>
            </div>
          </div>
          <div class="flex justify-center gap-2 mt-4">
            <button
              v-for="unit in ['days', 'weeks', 'months']"
              :key="unit"
              class="px-4 py-2 rounded-full text-sm font-medium transition-colors"
              :class="delayUnit === unit 
                ? 'bg-primary-600 text-white dark:bg-primary-500' 
                : 'bg-gray-100 text-gray-600 hover:bg-primary-50 dark:bg-gray-800 dark:text-gray-300 dark:hover:bg-primary-900/30'"
              @click="delayUnit = unit"
            >
              {{ unit === 'days' ? 'Jours' : unit === 'weeks' ? 'Semaines' : 'Mois' }}
            </button>
          </div>
        </div>

        <!-- Message -->
        <div>
          <label class="block text-sm font-medium text-gray-500 dark:text-gray-400 mb-2">
            Message
          </label>
          <textarea
            v-model="message"
            rows="4"
            placeholder="Décrivez votre proposition..."
            class="w-full rounded-2xl resize-none border border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-800/50 p-4 text-gray-900 dark:text-white placeholder-gray-500 dark:placeholder-gray-400 focus:ring-2 focus:ring-primary-500 focus:border-transparent"
          />
          <div class="mt-1 flex justify-end">
            <span class="text-xs text-gray-500 dark:text-gray-400">
              {{ message.length }}/500
            </span>
          </div>
        </div>
      </div>

      <template #footer>
        <button
          class="px-6 py-3 rounded-full text-sm font-medium text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200"
          @click="showApplyModal = false"
        >
          Annuler
        </button>
        <button
          class="px-6 py-3 rounded-full text-sm font-medium bg-primary-600 text-white hover:bg-primary-700 dark:bg-primary-500 dark:hover:bg-primary-600 disabled:opacity-50 disabled:cursor-not-allowed"
          :disabled="!isValid || isSubmitting"
          @click="submitProposal"
        >
          <span v-if="isSubmitting" class="flex items-center">
            <svg class="animate-spin -ml-1 mr-2 h-4 w-4" fill="none" viewBox="0 0 24 24">
              <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4" />
              <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z" />
            </svg>
            Envoi en cours...
          </span>
          <span v-else>
            Envoyer ma proposition
          </span>
        </button>
      </template>
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
  CheckCircle, XCircle, InboxIcon, PlusIcon, MinusIcon
} from 'lucide-vue-next'
import { useCustomToast } from '@/composables/useCustomToast'
import { useRouter } from 'vue-router'

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

const { showToast } = useCustomToast()

const router = useRouter()

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
  if (!date) return '-'
  return new Date(date).toLocaleDateString('fr-FR', {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  })
}

const formatPrice = (value) => {
  return new Intl.NumberFormat('fr-FR', {
    style: 'currency',
    currency: 'XOF',
    minimumFractionDigits: 0,
    maximumFractionDigits: 0
  }).format(value)
}

const formatDeliveryTime = (days) => {
  if (!days) return 'Non spécifié'
  return days === 1 ? '1 jour' : `${days} jours`
}

// États pour la modal de proposition
const showApplyModal = ref(false)
const price = ref(0)
const delay = ref(1)
const delayUnit = ref('days')
const message = ref('')
const isSubmitting = ref(false)

// Ajout de la référence à la mission sélectionnée
const selectedMission = ref(null)

// Fonction pour ouvrir le modal de proposition
const openProposalModal = (mission) => {
  selectedMission.value = mission
  price.value = mission.budget // Initialiser avec le budget de la mission
  showApplyModal.value = true
}

// Simplification de la gestion du prix
const handlePriceInput = (event) => {
  let value = parseInt(event.target.value)
  
  // Juste s'assurer que c'est un nombre valide
  if (isNaN(value)) {
    value = 0
  }
  
  price.value = value
}

// Soumission de la proposition
const submitProposal = async () => {
  if (!isValid.value) return

  try {
    isSubmitting.value = true
    
    // Calculer les dates de début et de fin
    const startDate = new Date()
    const endDate = new Date(startDate)
    
    // Calculer la date de fin en fonction de l'unité de durée
    if (delayUnit.value === 'days') {
      endDate.setDate(endDate.getDate() + delay.value)
    } else if (delayUnit.value === 'weeks') {
      endDate.setDate(endDate.getDate() + (delay.value * 7))
    } else if (delayUnit.value === 'months') {
      endDate.setMonth(endDate.getMonth() + delay.value)
    }

    // Créer la proposition
    const { data, error } = await supabase
      .from('deals')
      .insert({
        mission_id: selectedMission.value.id,
        expert_id: user.value.id,
        client_id: selectedMission.value.client_id,
        price: price.value,
        duration: delay.value,
        duration_unit: delayUnit.value,
        message: message.value,
        status: 'proposal'
      })

    if (error) throw error

    showToast.success(
      'Proposition envoyée',
      'Votre proposition a été envoyée avec succès'
    )

    showApplyModal.value = false
    resetForm()

  } catch (error) {
    console.error('Erreur lors de l\'envoi de la proposition:', error)
    showToast.error(
      'Erreur',
      'Impossible d\'envoyer votre proposition'
    )
  } finally {
    isSubmitting.value = false
  }
}

// Réinitialisation du formulaire
const resetForm = () => {
  price.value = 0
  delay.value = 1
  delayUnit.value = 'days'
  message.value = ''
}

// Vérifier si l'utilisateur peut faire une proposition
const canMakeProposal = (mission) => {
  if (!user.value || !mission) return false
  
  // Vérifier si l'utilisateur est le client de la mission
  if (user.value.id === mission.client_id) return false
  
  // Vérifier si l'utilisateur a déjà fait une proposition
  if (hasProposal(mission)) return false
  
  return mission.status === 'open'
}

// Vérifier si l'utilisateur a déjà fait une proposition
const hasProposal = (mission) => {
  if (!user.value || !mission.deals) return false
  
  return mission.deals.some(deal => 
    deal.expert_id === user.value.id && 
    ['proposal', 'accepted', 'in_progress'].includes(deal.status)
  )
}

// Fonctions utilitaires pour les statuts
const getMissionStatusClass = (status) => {
  const classes = {
    pending: 'bg-yellow-50 text-yellow-700 dark:bg-yellow-900/30 dark:text-yellow-400',
    in_progress: 'bg-blue-50 text-blue-700 dark:bg-blue-900/30 dark:text-blue-400',
    completed: 'bg-green-50 text-green-700 dark:bg-green-900/30 dark:text-green-400',
    cancelled: 'bg-red-50 text-red-700 dark:bg-red-900/30 dark:text-red-400',
  }
  return classes[status] || 'bg-gray-50 text-gray-700 dark:bg-gray-900/30 dark:text-gray-400'
}

const getMissionStatusLabel = (status) => {
  const labels = {
    proposal: 'Proposition envoyée',
    open: 'En attente',
    in_progress: 'En cours',
    completed: 'Terminée',
    cancelled: 'Annulée',
    assigned: 'Assignée',
    want: 'Je veux'
  }
  return labels[status] || status
}

const getMissionStatusIcon = (status) => {
  const icons = {
    proposal: 'i-heroicons-paper-airplane',
    open: 'i-heroicons-clock',
    in_progress: 'i-heroicons-play',
    completed: 'i-heroicons-check-circle',
    cancelled: 'i-heroicons-x-circle',
    assigned: 'i-heroicons-user-plus',
    want: 'i-heroicons-heart'
  }
  return icons[status] || 'i-heroicons-question-mark-circle'
}

// Validation
const isValid = computed(() => {
  return price.value > 0 && delay.value > 0 && message.value.length > 0
})

// Fonction pour formater la deadline
const formatDeadline = (deadline) => {
  if (!deadline) return 'Pas de deadline'
  
  const deadlineDate = new Date(deadline)
  const now = new Date()
  const diffTime = deadlineDate - now
  const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24))
  
  if (diffDays < 0) return 'Expirée'
  if (diffDays === 0) return "Aujourd'hui"
  if (diffDays === 1) return 'Demain'
  if (diffDays <= 7) return `${diffDays} jours`
  if (diffDays <= 30) return `${Math.floor(diffDays / 7)} semaines`
  if (diffDays <= 365) return `${Math.floor(diffDays / 30)} mois`
  return `${Math.floor(diffDays / 365)} ans`
}

// Fonction pour obtenir la couleur selon la deadline
const getDeadlineColor = (deadline) => {
  if (!deadline) return 'text-gray-400 dark:text-gray-500'
  
  const diffDays = Math.ceil((new Date(deadline) - new Date()) / (1000 * 60 * 60 * 24))
  
  if (diffDays < 0) return 'text-red-500 dark:text-red-400'
  if (diffDays <= 3) return 'text-amber-500 dark:text-amber-400'
  if (diffDays <= 7) return 'text-orange-500 dark:text-orange-400'
  return 'text-teal-500 dark:text-teal-400'
}

// Fonction pour obtenir la couleur du statut
const getMissionStatusColor = (status) => {
  const colors = {
    'open': 'emerald',
    'in_progress': 'blue',
    'completed': 'purple',
    'cancelled': 'rose',
    'pending': 'amber',
    'proposal': 'indigo',
    'assigned': 'cyan',
    'want': 'pink'
  }
  return colors[status] || 'gray'
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

/* Effet de hover amélioré */
.hover\:shadow-md {
  transition: all 0.2s ease-in-out;
}

.hover\:shadow-md:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1);
}
</style>