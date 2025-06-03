<template>
  <div class="min-h-screen bg-gray-50 dark:bg-gray-900">
    <!-- Header compact et moderne -->
    <div class="sticky top-0 z-20 bg-white/95 dark:bg-gray-900/95 backdrop-blur-lg border-b border-gray-200 dark:border-gray-700 shadow-sm">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 py-4">
        <div class="flex flex-col gap-4">
          <!-- Titre et compteur -->
          <div class="flex items-center justify-between">
            <div>
              <h1 class="text-2xl font-bold text-gray-900 dark:text-white">Experts</h1>
              <p class="text-sm text-gray-500 dark:text-gray-400">
                {{ filteredExperts.length }} expert{{ filteredExperts.length > 1 ? 's' : '' }} disponible{{ filteredExperts.length > 1 ? 's' : '' }}
              </p>
            </div>
            <!-- Vue toggle -->
            <div class="flex bg-gray-100 dark:bg-gray-800 rounded-lg p-1">
              <button 
                @click="viewMode = 'list'"
                class="p-2 rounded-md transition-all"
                :class="viewMode === 'list' ? 'bg-white dark:bg-gray-700 shadow-sm text-blue-600' : 'text-gray-500'"
              >
                <UIcon name="i-heroicons-bars-3" class="w-5 h-5" />
              </button>
              <button 
                @click="viewMode = 'grid'"
                class="p-2 rounded-md transition-all"
                :class="viewMode === 'grid' ? 'bg-white dark:bg-gray-700 shadow-sm text-blue-600' : 'text-gray-500'"
              >
                <UIcon name="i-heroicons-squares-2x2" class="w-5 h-5" />
              </button>
            </div>
          </div>

          <!-- Filtres en ligne -->
          <div class="flex flex-col sm:flex-row gap-3">
            <!-- Recherche avec style moderne -->
            <div class="relative flex-1 max-w-md">
              <UIcon name="i-heroicons-magnifying-glass" class="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" />
              <input
                v-model="search"
                type="text"
                placeholder="Rechercher par nom, profession..."
                class="w-full pl-10 pr-4 py-2.5 bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 dark:focus:ring-blue-400 focus:border-transparent"
              />
            </div>

            <!-- Filtres rapides -->
            <div class="flex gap-2 overflow-x-auto">
              <button 
                v-for="tab in tabs" 
                :key="tab.value"
                @click="filter = tab.value"
                class="px-4 py-2 text-sm font-medium rounded-lg whitespace-nowrap transition-all"
                :class="filter === tab.value 
                  ? 'bg-blue-600 text-white shadow-sm' 
                  : 'bg-white dark:bg-gray-800 text-gray-600 dark:text-gray-300 border border-gray-200 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-700'"
              >
                {{ tab.label }}
              </button>
            </div>
          </div>

          <!-- Pills de professions -->
          <div class="flex gap-2 overflow-x-auto pb-1 -mx-1 px-1 scrollbar-hide">
            <button 
              @click="professionFilter = null"
              class="px-3 py-1.5 text-xs rounded-full whitespace-nowrap transition-all border"
              :class="!professionFilter 
                ? 'bg-gray-900 dark:bg-white text-white dark:text-gray-900 border-gray-900 dark:border-white' 
                : 'bg-white dark:bg-gray-800 text-gray-600 dark:text-gray-300 border-gray-200 dark:border-gray-700 hover:border-gray-300 dark:hover:border-gray-600'"
            >
              Toutes les professions
            </button>
            <button 
              v-for="profession in professions"
              :key="profession.id"
              @click="professionFilter = profession.id"
              class="px-3 py-1.5 text-xs rounded-full whitespace-nowrap transition-all border"
              :class="professionFilter === profession.id 
                ? 'bg-gray-900 dark:bg-white text-white dark:text-gray-900 border-gray-900 dark:border-white' 
                : 'bg-white dark:bg-gray-800 text-gray-600 dark:text-gray-300 border-gray-200 dark:border-gray-700 hover:border-gray-300 dark:hover:border-gray-600'"
            >
              {{ profession.name }}
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Contenu principal -->
    <div class="max-w-5xl bg-white dark:bg-gray-900 mx-auto px-4 sm:px-6 py-6">
      <!-- Vue Liste (style Leboncoin amélioré) -->
      <div v-if="viewMode === 'list'" class="space-y-4 divide-y divide-gray-200 dark:divide-gray-700">
        <TransitionGroup name="list" tag="div">
          <article 
            v-for="expert in filteredExperts" 
            :key="expert.id"
            class="group bg-white dark:bg-gray-800 transition-all duration-300 cursor-pointer overflow-hidden"
            @click="navigateToExpert(expert.id)"
          >
            <div class="flex">
              <!-- Image principale -->
              <div class="w-72 h-48 bg-gray-100 dark:bg-gray-800 flex-shrink-0 relative overflow-hidden flex items-center justify-center">
                <img
                  :src="expert.avatar_url || defaultAvatar"
                  :alt="expert.first_name"
                  class="w-32 h-32 object-contain rounded-full ring-2 ring-white dark:ring-gray-700 shadow-lg"
                />
                
                <!-- Badges -->
                <div class="absolute top-3 left-3 flex flex-col gap-2">
                  <span 
                    v-if="expert.is_available"
                    class="bg-green-500 text-white px-2 py-1 rounded-md text-xs font-semibold shadow-lg"
                  >
                    DISPONIBLE
                  </span>
                  <span 
                    v-if="expert.is_verified"
                    class="bg-blue-600 text-white px-2 py-1 rounded-md text-xs font-semibold shadow-lg flex items-center gap-1"
                  >
                    <UIcon name="i-heroicons-check-badge" class="w-3 h-3" />
                    VÉRIFIÉ
                  </span>
                </div>

                <!-- Prix en overlay -->
                <div class="absolute bottom-3 right-3">
                  <div class="bg-white/95 dark:bg-gray-900/95 backdrop-blur-sm rounded-lg px-3 py-2">
                    <div class="text-lg font-bold text-gray-900 dark:text-white">
                      {{ formatPrice(expert.hourly_rate) }}
                    </div>
                    <div class="text-xs text-gray-500 dark:text-gray-400 text-center">par heure</div>
                  </div>
                </div>
              </div>

              <!-- Contenu -->
              <div class="flex-1 p-6 flex flex-col justify-between min-h-48">
                <!-- Header -->
                <div>
                  <div class="flex items-start justify-between mb-3">
                    <div>
                      <h3 class="text-xl font-bold text-gray-900 dark:text-white group-hover:text-blue-600 dark:group-hover:text-blue-400 transition-colors">
                        {{ expert.first_name }} {{ expert.last_name }}
                      </h3>
                      <p class="text-blue-600 dark:text-blue-400 font-medium text-sm mt-1">
                        {{ expert.profession?.name }}
                      </p>
                    </div>
                    
                    <!-- Note -->
                    <div v-if="expert.rating" class="flex items-center gap-1 bg-yellow-50 dark:bg-yellow-900/20 px-2 py-1 rounded-lg">
                      <UIcon name="i-heroicons-star" class="w-4 h-4 text-yellow-500" />
                      <span class="text-sm font-semibold text-yellow-700 dark:text-yellow-400">{{ expert.rating }}</span>
                    </div>
                  </div>

                  <!-- Description -->
                  <p class="text-gray-600 dark:text-gray-300 text-sm line-clamp-2 mb-4 leading-relaxed">
                    {{ expert.bio || 'Aucune description disponible.' }}
                  </p>
                </div>

                <!-- Footer avec stats -->
                <div class="flex items-center justify-between pt-4 border-t border-gray-100 dark:border-gray-700">
                  <div class="flex items-center gap-4 text-xs text-gray-500 dark:text-gray-400">
                    <span class="flex items-center gap-1">
                      <UIcon name="i-heroicons-briefcase" class="w-4 h-4" />
                      {{ expert.completed_missions_count || 0 }} missions
                    </span>
                    <span class="flex items-center gap-1">
                      <UIcon name="i-heroicons-map-pin" class="w-4 h-4" />
                      {{ expert.location || 'France' }}
                    </span>
                    <span class="flex items-center gap-1">
                      <UIcon name="i-heroicons-clock" class="w-4 h-4" />
                      {{ formatTimeAgo(expert.last_seen_at) || 'Récemment' }}
                    </span>
                  </div>

                  <!-- CTA Button -->
                  <button 
                    class="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg text-sm font-medium transition-colors shadow-sm"
                    @click.stop="contactExpert(expert)"
                  >
                    Contacter
                  </button>
                </div>
              </div>
            </div>
          </article>
        </TransitionGroup>
      </div>

      <!-- Vue Grille -->
      <div v-else class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        <TransitionGroup name="grid" tag="div" class="contents">
          <article 
            v-for="expert in filteredExperts" 
            :key="expert.id"
            class="group bg-white dark:bg-gray-800 rounded-xl shadow-sm hover:shadow-xl border border-gray-200 dark:border-gray-700 transition-all duration-300 cursor-pointer overflow-hidden"
            @click="navigateToExpert(expert.id)"
          >
            <!-- Image avec ratio fixe -->
            <div class="aspect-[4/3] relative overflow-hidden">
              <img
                :src="expert.avatar_url || defaultAvatar"
                :alt="expert.first_name"
                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-700"
              />
              
              <!-- Badges -->
              <div class="absolute top-3 left-3 flex flex-col gap-1">
                <span 
                  v-if="expert.is_available"
                  class="bg-green-500 text-white px-2 py-1 rounded text-xs font-semibold"
                >
                  DISPONIBLE
                </span>
                <span 
                  v-if="expert.is_verified"
                  class="bg-blue-600 text-white px-2 py-1 rounded text-xs font-semibold"
                >
                  VÉRIFIÉ
                </span>
              </div>

              <!-- Prix -->
              <div class="absolute bottom-3 right-3">
                <div class="bg-white/95 backdrop-blur-sm rounded-lg px-2 py-1">
                  <div class="text-sm font-bold text-gray-900">{{ formatPrice(expert.hourly_rate) }}/h</div>
                </div>
              </div>
            </div>

            <!-- Contenu -->
            <div class="p-4">
              <div class="flex items-start justify-between mb-2">
                <div class="flex-1">
                  <h3 class="font-bold text-gray-900 dark:text-white text-lg group-hover:text-blue-600 transition-colors">
                    {{ expert.first_name }} {{ expert.last_name }}
                  </h3>
                  <p class="text-blue-600 dark:text-blue-400 text-sm font-medium">{{ expert.profession?.name }}</p>
                </div>
                
                <div v-if="expert.rating" class="flex items-center gap-1">
                  <UIcon name="i-heroicons-star" class="w-4 h-4 text-yellow-500" />
                  <span class="text-sm font-semibold">{{ expert.rating }}</span>
                </div>
              </div>

              <p class="text-gray-600 dark:text-gray-300 text-sm line-clamp-2 mb-3">
                {{ expert.bio || 'Aucune description disponible.' }}
              </p>

              <!-- Stats -->
              <div class="flex items-center justify-between text-xs text-gray-500 dark:text-gray-400 mb-3">
                <span>{{ expert.completed_missions_count || 0 }} missions</span>
                <span>{{ expert.location || 'France' }}</span>
              </div>

              <!-- CTA -->
              <button 
                class="w-full bg-blue-600 hover:bg-blue-700 text-white py-2 rounded-lg text-sm font-medium transition-colors"
                @click.stop="contactExpert(expert)"
              >
                Contacter
              </button>
            </div>
          </article>
        </TransitionGroup>
      </div>

      <!-- États vides -->
      <div v-if="isLoading" class="flex justify-center items-center py-20">
        <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
      </div>

      <div v-if="!isLoading && filteredExperts.length === 0" class="text-center py-20">
        <div class="w-24 h-24 mx-auto mb-6 rounded-full bg-gray-100 dark:bg-gray-800 flex items-center justify-center">
          <UIcon name="i-heroicons-user-group" class="w-12 h-12 text-gray-400" />
        </div>
        <h3 class="text-xl font-semibold mb-2 text-gray-900 dark:text-white">Aucun expert trouvé</h3>
        <p class="text-gray-500 dark:text-gray-400 mb-6">Essayez de modifier vos critères de recherche</p>
        <button 
          @click="resetFilters"
          class="bg-blue-600 hover:bg-blue-700 text-white px-6 py-2 rounded-lg font-medium transition-colors"
        >
          Réinitialiser les filtres
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useSupabaseClient, useSupabaseUser } from '#imports'
import { useDefaultAvatar } from '~/composables/useDefaultAvatar'
import { useRouter } from 'vue-router'
import { format } from 'date-fns'
import { fr } from 'date-fns/locale'

const supabase = useSupabaseClient()
const { defaultAvatar } = useDefaultAvatar()
const router = useRouter()
const user = useSupabaseUser()

// États
const viewMode = ref('list') // 'list' ou 'grid'
const filter = ref('all')
const professionFilter = ref(null)
const search = ref('')
const experts = ref([])
const professions = ref([])
const isLoading = ref(true)

// Tabs
const tabs = [
  { label: 'Tous', value: 'all' },
  { label: 'Vérifiés', value: 'verified' },
  { label: 'Disponibles', value: 'available' }
]

// Charger les données
const fetchData = async () => {
  try {
    isLoading.value = true
    const [expertsData, professionsData] = await Promise.all([
      supabase
        .from('profiles')
        .select('*, profession:professions(*)')
        .eq('is_expert', true)
        .order('created_at', { ascending: false }),
      supabase
        .from('professions')
        .select('*')
        .eq('is_active', true)
        .order('name')
    ])

    experts.value = expertsData.data || []
    professions.value = professionsData.data || []
  } catch (error) {
    console.error('Error fetching data:', error)
  } finally {
    isLoading.value = false
  }
}

// Filtrage amélioré
const filteredExperts = computed(() => {
  let filtered = experts.value

  // Filtre par statut
  if (filter.value === 'verified') {
    filtered = filtered.filter(expert => expert.is_verified)
  } else if (filter.value === 'available') {
    filtered = filtered.filter(expert => expert.is_available)
  }

  // Filtre par profession
  if (professionFilter.value) {
    filtered = filtered.filter(expert => expert.profession_id === professionFilter.value)
  }

  // Recherche textuelle
  if (search.value.trim()) {
    const searchTerm = search.value.toLowerCase().trim()
    filtered = filtered.filter(expert => 
      `${expert.first_name} ${expert.last_name}`.toLowerCase().includes(searchTerm) ||
      expert.profession?.name?.toLowerCase().includes(searchTerm) ||
      expert.bio?.toLowerCase().includes(searchTerm)
    )
  }

  return filtered
})

// Actions
const navigateToExpert = (id) => {
  router.push(`/experts/${id}`)
}

const contactExpert = (expert) => {
  // Logique de contact
  console.log('Contact expert:', expert.id)
}

const resetFilters = () => {
  filter.value = 'all'
  professionFilter.value = null
  search.value = ''
}

// Fonctions utilitaires
const formatPrice = (price) => {
  if (!price) return 'Sur devis'
  return new Intl.NumberFormat('fr-FR', {
    style: 'currency',
    currency: 'EUR',
    minimumFractionDigits: 0,
    maximumFractionDigits: 0
  }).format(price)
}

const formatTimeAgo = (date) => {
  if (!date) return 'Récemment'
  const now = new Date()
  const past = new Date(date)
  const diffTime = Math.abs(now - past)
  const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24))

  if (diffDays === 0) return "Aujourd'hui"
  if (diffDays === 1) return "Hier"
  if (diffDays < 7) return `Il y a ${diffDays}j`
  if (diffDays < 30) return `Il y a ${Math.floor(diffDays / 7)}sem`
  return `Il y a ${Math.floor(diffDays / 30)}mois`
}

// Initialisation
onMounted(() => {
  fetchData()
})
</script>

<style scoped>
.scrollbar-hide {
  -ms-overflow-style: none;
  scrollbar-width: none;
}
.scrollbar-hide::-webkit-scrollbar {
  display: none;
}

.line-clamp-2 {
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}


</style>