<template>
  <div class="min-h-screen bg-gray-100 dark:bg-gray-900">
    <!-- Header fixe -->
    <header class="sticky top-0 z-10 bg-white dark:bg-gray-800 shadow-sm">
      <div class="max-w-2xl mx-auto px-4 py-3">
        <div class="flex items-center justify-between">
          <div class="flex items-center gap-3">
            <div class="flex items-center gap-2">
              <v-icon name="bi-people" scale="1.2" class="text-primary-500" />
              <h1 class="text-xl font-bold text-gray-900 dark:text-white">Experts</h1>
            </div>
            <!-- Compteur d'experts -->
            <span class="text-sm text-gray-500 dark:text-gray-400">
              {{ filteredExperts.length }} disponibles
            </span>
          </div>
          <NuxtLink
            to="/experts/become"
            class="inline-flex items-center px-4 py-2 rounded-full bg-primary-600 hover:bg-primary-700 text-white font-medium transition-all shadow-sm hover:shadow"
          >
            <v-icon name="bi-plus-lg" class="mr-2" />
            Devenir expert
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
              placeholder="Rechercher un expert..."
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

          <!-- Note minimale -->
          <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
              Note minimale
            </label>
            <div class="flex items-center gap-4">
              <button
                v-for="rating in [4, 4.5, 4.8]"
                :key="rating"
                @click="filters.minRating = rating"
                class="flex items-center gap-1 px-3 py-1.5 rounded-full text-sm transition-all"
                :class="[
                  filters.minRating === rating
                    ? 'bg-primary-50 dark:bg-primary-900/20 text-primary-600 dark:text-primary-400'
                    : 'bg-gray-100 dark:bg-gray-700 text-gray-600 dark:text-gray-400 hover:bg-gray-200 dark:hover:bg-gray-600'
                ]"
              >
                <v-icon name="bi-star-fill" class="text-yellow-400" />
                <span>{{ rating }}+</span>
              </button>
            </div>
          </div>

          <!-- Temps de réponse -->
          <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
              Temps de réponse
            </label>
            <select
              v-model="filters.responseTime"
              class="w-full px-3 py-2 rounded-lg border border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-900"
            >
              <option value="">Tous les délais</option>
              <option value="1h">Moins d'1 heure</option>
              <option value="2h">Moins de 2 heures</option>
              <option value="4h">Moins de 4 heures</option>
              <option value="24h">Moins de 24 heures</option>
            </select>
          </div>

          <!-- Disponibilité -->
          <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
              Disponibilité
            </label>
            <div class="flex items-center gap-3">
              <label class="inline-flex items-center">
                <input
                  v-model="filters.availability"
                  type="radio"
                  value="all"
                  class="text-primary-600"
                />
                <span class="ml-2 text-sm text-gray-600 dark:text-gray-400">Tous</span>
              </label>
              <label class="inline-flex items-center">
                <input
                  v-model="filters.availability"
                  type="radio"
                  value="available"
                  class="text-primary-600"
                />
                <span class="ml-2 text-sm text-gray-600 dark:text-gray-400">Disponible</span>
              </label>
              <label class="inline-flex items-center">
                <input
                  v-model="filters.availability"
                  type="radio"
                  value="busy"
                  class="text-primary-600"
                />
                <span class="ml-2 text-sm text-gray-600 dark:text-gray-400">Occupé</span>
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

      <!-- Liste des experts -->
      <div v-if="isLoading" class="space-y-4">
        <div v-for="i in 3" :key="i" class="bg-white dark:bg-gray-800 rounded-xl p-4 animate-pulse shadow-sm">
          <div class="flex items-center gap-4 mb-4">
            <div class="w-12 h-12 bg-gray-200 dark:bg-gray-700 rounded-full"></div>
            <div class="flex-1">
              <div class="h-4 bg-gray-200 dark:bg-gray-700 rounded-full w-1/3 mb-2"></div>
              <div class="h-3 bg-gray-200 dark:bg-gray-700 rounded-full w-1/4"></div>
            </div>
          </div>
          <div class="h-4 bg-gray-200 dark:bg-gray-700 rounded-full w-3/4"></div>
        </div>
      </div>
      
      <div v-else class="space-y-4">
        <article 
          v-for="expert in filteredExperts" 
          :key="expert.id"
          class="bg-white dark:bg-gray-800 rounded-xl shadow-sm overflow-hidden transition-all hover:shadow-md"
        >
          <!-- En-tête avec photo et infos principales -->
          <div class="p-4">
            <div class="flex items-start gap-4 mb-4">
              <!-- Avatar ou initiales -->
              <div 
                v-if="expert.avatar_url"
                class="w-12 h-12 rounded-full bg-cover bg-center"
                :style="{ backgroundImage: `url(${expert.avatar_url})` }"
              ></div>
              <div 
                v-else
                class="w-12 h-12 rounded-full bg-primary-50 dark:bg-primary-900/20 flex items-center justify-center text-primary-600 dark:text-primary-400 font-medium text-lg"
              >
                {{ getInitials(expert.first_name, expert.last_name) }}
              </div>

              <!-- Infos principales -->
              <div class="flex-1">
                <div class="flex items-center justify-between mb-1">
                  <div>
                    <h2 class="text-lg font-semibold text-gray-900 dark:text-white">
                      {{ expert.first_name }} {{ expert.last_name }}
                    </h2>
                    <!-- Profession si disponible -->
                    <div v-if="expert.profession?.name" class="text-sm text-gray-600 dark:text-gray-400 mt-0.5">
                      {{ expert.profession.name }}
                    </div>
                  </div>
                  <!-- Badge vérifié si applicable -->
                  <div v-if="expert.is_verified" class="flex items-center gap-1 text-primary-600">
                    <v-icon name="bi-patch-check-fill" />
                    <span class="text-sm">Vérifié</span>
                  </div>
                </div>
                
                <!-- Localisation si disponible -->
                <div v-if="getLocation(expert)" class="flex items-center gap-2 text-sm text-gray-500 dark:text-gray-400 mt-1">
                  <v-icon name="bi-geo-alt" />
                  <span>{{ getLocation(expert) }}</span>
                </div>
              </div>
            </div>

            <!-- Bio -->
            <p v-if="expert.bio" class="text-gray-600 dark:text-gray-300 mb-4 line-clamp-2">
              {{ expert.bio }}
            </p>
            <p v-else class="text-gray-400 dark:text-gray-500 mb-4 italic">
              Aucune biographie disponible
            </p>

            <!-- Stats et badges -->
            <div class="flex flex-wrap items-center gap-4 text-sm">
              <!-- Badge de disponibilité -->
              <div 
                class="flex items-center gap-2 px-3 py-1 rounded-full"
                :class="{
                  'bg-green-50 dark:bg-green-900/20 text-green-600 dark:text-green-400': expert.availability_status === 'available',
                  'bg-red-50 dark:bg-red-900/20 text-red-600 dark:text-red-400': expert.availability_status === 'busy'
                }"
              >
                <v-icon :name="expert.availability_status === 'available' ? 'bi-circle-fill' : 'bi-dash-circle-fill'" />
                <span>{{ expert.availability_status === 'available' ? 'Disponible' : 'Occupé' }}</span>
              </div>
              <!-- Pourcentage de complétion du profil -->
              <div class="flex items-center gap-2 text-gray-500 dark:text-gray-400">
                <v-icon name="bi-person-check" />
                <span>Profil complété à {{ expert.profile_completion_percentage }}%</span>
              </div>
            </div>
          </div>

          <!-- Actions -->
          <div class="px-4 py-3 bg-gray-50 dark:bg-gray-800/50 border-t border-gray-100 dark:border-gray-700">
            <div class="flex items-center justify-between">
              <span class="text-sm text-gray-500 dark:text-gray-400">
                Membre depuis {{ formatDate(expert.created_at) }}
              </span>
              <NuxtLink
                :to="`/experts/${expert.id}`"
                class="inline-flex items-center px-4 py-2 rounded-full bg-primary-600 hover:bg-primary-700 text-white font-medium transition-all"
              >
                <v-icon name="bi-arrow-right" class="mr-2" />
                Voir profil
              </NuxtLink>
            </div>
          </div>
        </article>

        <!-- État vide -->
        <div 
          v-if="!isLoading && filteredExperts.length === 0"
          class="text-center py-12 bg-white dark:bg-gray-800 rounded-xl shadow-sm"
        >
          <div class="w-16 h-16 mx-auto mb-4 rounded-full bg-gray-100 dark:bg-gray-700 flex items-center justify-center">
            <v-icon name="bi-people" scale="1.5" class="text-gray-400" />
          </div>
          <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-1">
            Aucun expert trouvé
          </h3>
          <p class="text-gray-500 dark:text-gray-400">
            Modifiez vos filtres ou revenez plus tard
          </p>
        </div>
      </div>
    </main>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
// import { useSupabaseClient } from '#supabase/client'
import { OhVueIcon as VIcon, addIcons } from 'oh-vue-icons'
import { 
  BiSearch,
  BiGrid,
  BiStar,
  BiStarFill,
  BiLightning,
  BiClock,
  BiPeople,
  BiPerson,
  BiPlus,
  BiBriefcase,
  BiCodeSlash,
  BiPencil,
  BiCamera,
  BiGraphUp,
  BiTranslate,
  BiPalette,
  BiPersonWorkspace,
  BiBrush,
  BiCameraVideo,
  BiChevronUp,
  BiChevronDown,
  BiPatchCheckFill,
  BiCircleFill,
  BiDashCircleFill,
  BiPersonCheck,
  BiGeoAlt
} from 'oh-vue-icons/icons'

// Mise à jour des icônes
addIcons(
  BiSearch,
  BiGrid,
  BiStar,
  BiStarFill,
  BiLightning,
  BiClock,
  BiPeople,
  BiPerson,
  BiPlus,
  BiBriefcase,
  BiCodeSlash,
  BiPencil,
  BiCamera,
  BiGraphUp,
  BiTranslate,
  BiPalette,
  BiPersonWorkspace,
  BiBrush,
  BiCameraVideo,
  BiChevronUp,
  BiChevronDown,
  BiPatchCheckFill,
  BiCircleFill,
  BiDashCircleFill,
  BiPersonCheck,
  BiGeoAlt
)

const supabase = useSupabaseClient()

// États
const experts = ref([])
const isLoading = ref(true)
const searchQuery = ref('')
const activeFilter = ref('all')
const showAdvancedFilters = ref(false)
const filters = ref({
  professions: [],
  minRating: null,
  responseTime: '',
  availability: 'all'
})

// Filtres rapides
const quickFilters = [
  { label: 'Tous', value: 'all', icon: 'bi-grid' },
  { label: 'Disponibles', value: 'available', icon: 'bi-circle-fill' },
  { label: 'Vérifiés', value: 'verified', icon: 'bi-patch-check-fill' },
  { label: 'Profils complets', value: 'complete', icon: 'bi-person-check' }
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

// Fetch des experts
const fetchExperts = async () => {
  try {
    isLoading.value = true
    const { data, error } = await supabase
      .from('profiles')
      .select(`
        *
      `)
      .eq('is_expert', true)
      .order('created_at', { ascending: false })

    if (error) throw error
    experts.value = data || []
  } catch (error) {
    console.error('Error fetching experts:', error)
  } finally {
    isLoading.value = false
  }
}

// Computed pour filtrer les experts
const filteredExperts = computed(() => {
  let filtered = experts.value

  // Recherche
  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase()
    filtered = filtered.filter(expert => 
      expert.first_name?.toLowerCase().includes(query) ||
      expert.last_name?.toLowerCase().includes(query) ||
      expert.bio?.toLowerCase().includes(query) ||
      expert.city?.toLowerCase().includes(query) ||
      expert.country?.toLowerCase().includes(query) ||
      expert.profession?.name?.toLowerCase().includes(query)
    )
  }

  // Filtres rapides
  switch (activeFilter.value) {
    case 'available':
      filtered = filtered.filter(e => e.availability_status === 'available')
      break
    case 'verified':
      filtered = filtered.filter(e => e.is_verified)
      break
    case 'complete':
      filtered = filtered.filter(e => e.profile_completion_percentage >= 80)
      break
  }

  // Filtre de disponibilité
  if (filters.value.availability !== 'all') {
    filtered = filtered.filter(e => e.availability_status === filters.value.availability)
  }

  return filtered
})

// Helpers
const getInitials = (firstName, lastName) => {
  return `${firstName?.charAt(0) || ''}${lastName?.charAt(0) || ''}`.toUpperCase()
}

const getProfessionIcon = (professionName) => {
  return professionIcons[professionName] || professionIcons.default
}

const formatPrice = (price) => {
  if (!price) return 'Prix à définir'
  return new Intl.NumberFormat('fr-FR', {
    style: 'currency',
    currency: 'XOF',
    maximumFractionDigits: 0
  }).format(price)
}

const formatDate = (date) => {
  return new Date(date).toLocaleDateString('fr-FR', {
    month: 'long',
    year: 'numeric'
  })
}

// Helper pour formater la localisation
const getLocation = (expert) => {
  const parts = []
  if (expert.city) parts.push(expert.city)
  if (expert.country) parts.push(expert.country)
  return parts.length > 0 ? parts.join(', ') : null
}

// Lifecycle
onMounted(() => {
  fetchExperts()
})
</script>

<style scoped>
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

/* Ajout de styles pour améliorer l'espacement */
.flex-1 > div:not(:last-child) {
  margin-bottom: 0.5rem;
}
</style>