<template>
  <div class="min-h-screen bg-gray-100 dark:bg-gray-900">
    <!-- Header fixe -->
    <header class="sticky top-0 z-10 bg-white dark:bg-gray-800 shadow-sm">
      <div class="max-w-2xl mx-auto px-4 py-3">
        <div class="flex items-center justify-between">
          <div class="flex items-center gap-3">
            <div class="flex items-center gap-2">
              <v-icon name="bi-briefcase" scale="1.2" class="text-primary-500" />
              <h1 class="text-xl font-bold text-gray-900 dark:text-white">Missions</h1>
            </div>
            <!-- Compteur de missions -->
            <span class="text-sm text-gray-500 dark:text-gray-400">
              {{ filteredMissions.length }} disponibles
            </span>
          </div>
          <NuxtLink
            to="/requests/new"
            class="inline-flex items-center px-4 py-2 rounded-full bg-primary-600 hover:bg-primary-700 text-white font-medium transition-all shadow-sm hover:shadow"
          >
            <v-icon name="bi-plus-lg" class="mr-2" />
            Publier une mission
          </NuxtLink>
        </div>
      </div>
    </header>

    <main class="max-w-2xl mx-auto px-4 py-6 space-y-4">
      <!-- Barre de recherche avec filtres avancés -->
      <div class="bg-white dark:bg-gray-800 rounded-xl shadow-sm">
        <!-- Recherche -->
        <div class="p-4">
          <div class="relative">
            <input
              v-model="searchQuery"
              type="text"
              placeholder="Rechercher une mission..."
              class="w-full pl-12 pr-4 py-3 rounded-xl border border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-900 focus:ring-2 focus:ring-primary-500 focus:border-transparent"
            />
            <v-icon
              name="bi-search"
              class="absolute left-4 top-1/2 -translate-y-1/2 text-gray-400 text-lg"
            />
          </div>
        </div>

        <!-- Filtres rapides -->
        <div class="px-4 pb-4 flex items-center gap-3 overflow-x-auto">
          <button
            v-for="filter in quickFilters"
            :key="filter.value"
            @click="activeFilter = filter.value"
            class="inline-flex items-center px-4 py-2 rounded-full text-sm font-medium whitespace-nowrap transition-all"
            :class="[
              activeFilter === filter.value
                ? 'bg-primary-600 text-white shadow-sm'
                : 'bg-gray-100 dark:bg-gray-700 text-gray-700 dark:text-gray-300 hover:bg-gray-200 dark:hover:bg-gray-600'
            ]"
          >
            <v-icon :name="filter.icon" class="mr-2" />
            {{ filter.label }}
          </button>
        </div>

        <!-- Filtres avancés -->
        <div 
          v-show="showAdvancedFilters"
          class="px-4 py-3 border-t border-gray-100 dark:border-gray-700 space-y-4"
        >
          <!-- Budget -->
          <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
              Budget
            </label>
            <div class="flex items-center gap-4">
              <div class="flex-1">
                <input
                  v-model="filters.minBudget"
                  type="number"
                  placeholder="Min"
                  class="w-full px-3 py-2 rounded-lg border border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-900"
                />
              </div>
              <span class="text-gray-500">-</span>
              <div class="flex-1">
                <input
                  v-model="filters.maxBudget"
                  type="number"
                  placeholder="Max"
                  class="w-full px-3 py-2 rounded-lg border border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-900"
                />
              </div>
            </div>
          </div>

          <!-- Professions -->
          <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
              Professions
            </label>
            <div class="flex flex-wrap gap-2">
              <button
                v-for="profession in professions"
                :key="profession.id"
                @click="toggleProfession(profession.id)"
                class="inline-flex items-center px-3 py-1.5 rounded-full text-sm transition-all"
                :class="[
                  filters.professions.includes(profession.id)
                    ? 'bg-primary-50 dark:bg-primary-900/20 text-primary-600 dark:text-primary-400'
                    : 'bg-gray-100 dark:bg-gray-700 text-gray-600 dark:text-gray-400 hover:bg-gray-200 dark:hover:bg-gray-600'
                ]"
              >
                <v-icon :name="getProfessionIcon(profession.name)" class="mr-1.5" />
                {{ profession.name }}
              </button>
            </div>
          </div>

          <!-- Délai de livraison -->
          <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
              Délai de livraison
            </label>
            <select
              v-model="filters.deliveryTime"
              class="w-full px-3 py-2 rounded-lg border border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-900"
            >
              <option value="">Tous les délais</option>
              <option value="1">1 jour ou moins</option>
              <option value="3">3 jours ou moins</option>
              <option value="7">1 semaine ou moins</option>
              <option value="14">2 semaines ou moins</option>
              <option value="30">1 mois ou moins</option>
            </select>
          </div>

          <!-- Localisation -->
          <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
              Localisation
            </label>
            <div class="flex items-center gap-3">
              <label class="inline-flex items-center">
                <input
                  v-model="filters.location"
                  type="radio"
                  value="all"
                  class="text-primary-600"
                />
                <span class="ml-2 text-sm text-gray-600 dark:text-gray-400">Toutes</span>
              </label>
              <label class="inline-flex items-center">
                <input
                  v-model="filters.location"
                  type="radio"
                  value="remote"
                  class="text-primary-600"
                />
                <span class="ml-2 text-sm text-gray-600 dark:text-gray-400">À distance</span>
              </label>
              <label class="inline-flex items-center">
                <input
                  v-model="filters.location"
                  type="radio"
                  value="onsite"
                  class="text-primary-600"
                />
                <span class="ml-2 text-sm text-gray-600 dark:text-gray-400">Sur place</span>
              </label>
            </div>
          </div>
        </div>

        <!-- Toggle filtres avancés -->
        <button
          @click="showAdvancedFilters = !showAdvancedFilters"
          class="w-full px-4 py-2 text-sm text-gray-600 dark:text-gray-400 hover:bg-gray-50 dark:hover:bg-gray-700/50 border-t border-gray-100 dark:border-gray-700 transition-colors flex items-center justify-center gap-2"
        >
          <span>{{ showAdvancedFilters ? 'Masquer les filtres' : 'Plus de filtres' }}</span>
          <v-icon
            :name="showAdvancedFilters ? 'bi-chevron-up' : 'bi-chevron-down'"
            scale="0.9"
          />
        </button>
      </div>

      <!-- Liste des missions -->
      <div v-if="isLoading" class="space-y-4">
        <div v-for="i in 3" :key="i" class="bg-white dark:bg-gray-800 rounded-xl p-4 animate-pulse shadow-sm">
          <div class="h-4 bg-gray-200 dark:bg-gray-700 rounded-full w-3/4 mb-4"></div>
          <div class="h-4 bg-gray-200 dark:bg-gray-700 rounded-full w-1/2"></div>
        </div>
      </div>
      
      <div v-else class="space-y-4">
        <div 
          v-for="mission in filteredMissions" 
          :key="mission.id"
          class="bg-white dark:bg-gray-800 rounded-xl shadow-sm overflow-hidden"
        >
          <!-- En-tête avec infos principales -->
          <div class="p-4">
            <div class="flex justify-between items-start gap-4">
              <div class="flex-1 min-w-0">
                <h3 class="text-lg font-semibold text-gray-900 dark:text-white mb-1">
                  {{ mission.title }}
                </h3>
                <div class="flex items-center gap-3 text-sm text-gray-500 dark:text-gray-400">
                  <div class="flex items-center gap-1">
                    <v-icon name="bi-calendar" />
                    <span>{{ formatDate(mission.created_at) }}</span>
                  </div>
                  <div v-if="mission.profession?.name" class="flex items-center gap-1">
                    <v-icon name="bi-briefcase" />
                    <span>{{ mission.profession.name }}</span>
                  </div>
                </div>
              </div>
              <!-- Badge de statut -->
              <span 
                class="px-2.5 py-1 rounded-full text-xs font-medium"
                :class="getMissionStatusClass(mission.status)"
              >
                {{ getMissionStatusLabel(mission.status) }}
              </span>
            </div>

            <!-- Description -->
            <p class="mt-3 text-gray-600 dark:text-gray-300 line-clamp-2">
              {{ mission.description }}
            </p>

            <!-- Budget et deadline -->
            <div class="mt-4 flex flex-wrap gap-3">
              <div class="flex items-center gap-2 text-sm">
                <div class="px-2.5 py-1 rounded-full bg-primary-50 dark:bg-primary-900/20 text-primary-600 dark:text-primary-400 font-medium">
                  {{ formatPrice(mission.budget) }}
                </div>
              </div>
              <div v-if="mission.deadline" class="flex items-center gap-2 text-sm text-gray-500">
                <v-icon name="bi-clock" />
                <span>Date limite: {{ formatDate(mission.deadline) }}</span>
              </div>
            </div>
          </div>

          <!-- Actions -->
          <div class="px-4 py-3 bg-gray-50 dark:bg-gray-700/50 border-t border-gray-100 dark:border-gray-700">
            <div class="flex items-center justify-between gap-4">
              <NuxtLink
                :to="`/requests/${mission.id}`"
                class="text-sm text-gray-600 dark:text-gray-300 hover:text-primary-600 dark:hover:text-primary-400"
              >
                Voir les détails
              </NuxtLink>
              
              <!-- Bouton de proposition -->
              <button
                v-if="canMakeProposal(mission)"
                @click="openProposalModal(mission)"
                class="inline-flex items-center px-4 py-2 rounded-lg bg-primary-600 hover:bg-primary-700 text-white text-sm font-medium transition-all"
              >
                <v-icon name="bi-send" class="mr-2" />
                Faire une proposition
              </button>
              <span 
                v-else-if="hasProposal(mission)"
                class="text-sm text-gray-500 dark:text-gray-400"
              >
                Proposition déjà envoyée
              </span>
            </div>
          </div>
        </div>

        <!-- État vide -->
        <div 
          v-if="!isLoading && filteredMissions.length === 0"
          class="text-center py-12 bg-white dark:bg-gray-800 rounded-xl shadow-sm"
        >
          <div class="w-16 h-16 mx-auto mb-4 rounded-full bg-gray-100 dark:bg-gray-700 flex items-center justify-center">
            <v-icon name="bi-inbox" scale="1.5" class="text-gray-400" />
          </div>
          <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-1">
            Aucune mission trouvée
          </h3>
          <p class="text-gray-500 dark:text-gray-400">
            Modifiez vos filtres ou revenez plus tard
          </p>
        </div>
      </div>
    </main>

    <!-- Modal de proposition -->
    <TransitionRoot appear :show="isProposalModalOpen" as="template">
      <Dialog as="div" @close="closeProposalModal" class="relative z-50">
        <TransitionChild
          enter="duration-300 ease-out"
          enter-from="opacity-0"
          enter-to="opacity-100"
          leave="duration-200 ease-in"
          leave-from="opacity-100"
          leave-to="opacity-0"
        >
          <div class="fixed inset-0 bg-black/25 dark:bg-black/40" />
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
              <DialogPanel class="w-full max-w-md bg-white dark:bg-gray-800 rounded-xl shadow-xl overflow-hidden">
                <div class="p-6">
                  <h3 class="text-lg font-semibold text-gray-900 dark:text-white mb-4">
                    Faire une proposition
                  </h3>

                  <form @submit.prevent="submitProposal" class="space-y-4">
                    <!-- Prix proposé -->
                    <div>
                      <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                        Prix proposé
                      </label>
                      <div class="relative">
                        <input
                          v-model="proposalForm.price"
                          type="number"
                          min="0"
                          step="1"
                          required
                          class="w-full pl-4 pr-12 py-2 rounded-lg border border-gray-200 dark:border-gray-700 bg-white dark:bg-gray-900"
                        />
                        <span class="absolute right-4 top-1/2 -translate-y-1/2 text-gray-500">
                          €
                        </span>
                      </div>
                    </div>

                    <!-- Durée estimée -->
                    <div>
                      <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                        Durée estimée (jours)
                      </label>
                      <input
                        v-model="proposalForm.duration"
                        type="number"
                        min="1"
                        required
                        class="w-full px-4 py-2 rounded-lg border border-gray-200 dark:border-gray-700 bg-white dark:bg-gray-900"
                      />
                    </div>

                    <!-- Message -->
                    <div>
                      <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                        Message
                      </label>
                      <textarea
                        v-model="proposalForm.message"
                        rows="4"
                        required
                        class="w-full px-4 py-2 rounded-lg border border-gray-200 dark:border-gray-700 bg-white dark:bg-gray-900"
                        placeholder="Décrivez votre approche..."
                      ></textarea>
                    </div>

                    <!-- Actions -->
                    <div class="flex items-center justify-end gap-3 mt-6">
                      <button
                        type="button"
                        @click="closeProposalModal"
                        class="px-4 py-2 rounded-lg border border-gray-200 dark:border-gray-700 text-gray-700 dark:text-gray-300"
                      >
                        Annuler
                      </button>
                      <button
                        type="submit"
                        :disabled="isSubmitting"
                        class="px-4 py-2 rounded-lg bg-primary-600 hover:bg-primary-700 text-white font-medium disabled:opacity-50"
                      >
                        <span v-if="isSubmitting">Envoi en cours...</span>
                        <span v-else>Envoyer la proposition</span>
                      </button>
                    </div>
                  </form>
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
  try {
    isLoading.value = true
    const { data, error } = await supabase
      .from('missions')
      .select(`
        *,
        profession:professions (
          id,
          name
        )
      `)
      .order('created_at', { ascending: false })

    if (error) throw error
    missions.value = data || []
  } catch (error) {
    console.error('Error fetching missions:', error)
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

// Computed pour filtrer les missions
const filteredMissions = computed(() => {
  let filtered = missions.value

  // Filtre de recherche
  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase()
    filtered = filtered.filter(mission => 
      mission.title?.toLowerCase().includes(query) ||
      mission.description?.toLowerCase().includes(query)
    )
  }

  // Filtres avancés
  if (filters.value.minBudget) {
    filtered = filtered.filter(m => m.budget >= Number(filters.value.minBudget))
  }
  if (filters.value.maxBudget) {
    filtered = filtered.filter(m => m.budget <= Number(filters.value.maxBudget))
  }
  if (filters.value.professions.length > 0) {
    filtered = filtered.filter(m => filters.value.professions.includes(m.profession?.id))
  }
  if (filters.value.deliveryTime) {
    filtered = filtered.filter(m => m.delivery_time <= Number(filters.value.deliveryTime))
  }
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

// État pour la modal et le formulaire
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
  // TODO: Implémenter la vérification des propositions existantes
  return false
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
    // TODO: Afficher une notification de succès
  } catch (error) {
    console.error('Erreur lors de l\'envoi de la proposition:', error)
    // TODO: Afficher une notification d'erreur
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
/* Animations et styles */
.line-clamp-2 {
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

@keyframes pulse {
  0%, 100% { opacity: 1; }
  50% { opacity: .5; }
}

.animate-pulse {
  animation: pulse 2s cubic-bezier(0.4, 0, 0.6, 1) infinite;
}

/* Scrollbar personnalisée */
.overflow-x-auto {
  scrollbar-width: thin;
  scrollbar-color: rgba(156, 163, 175, 0.5) transparent;
}

.overflow-x-auto::-webkit-scrollbar {
  height: 6px;
}

.overflow-x-auto::-webkit-scrollbar-track {
  background: transparent;
}

.overflow-x-auto::-webkit-scrollbar-thumb {
  background-color: rgba(156, 163, 175, 0.5);
  border-radius: 20px;
}

/* Hover effects */
.hover\:shadow-md {
  transition: all 0.2s ease;
}

.hover\:shadow-md:hover {
  transform: translateY(-1px);
}
</style>