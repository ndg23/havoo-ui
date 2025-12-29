<template>
  <div class="min-h-screen bg-white dark:bg-gray-900">
    <!-- Header compact et moderne -->
    <div class="sticky top-0 z-20 bg-white/95 dark:bg-gray-900/95 backdrop-blur-lg border-b border-gray-200 dark:border-gray-700 shadow-sm">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 py-4">
        <div class="flex flex-col gap-4">
          <!-- Titre et compteur -->
          <div class="flex items-center justify-between">
            <div>
              <h1 class="text-2xl font-bold text-gray-900 dark:text-white">Demandes</h1>
              <p class="text-sm text-gray-500 dark:text-gray-400">
                {{ filteredRequests.length }} demande{{ filteredRequests.length > 1 ? 's' : '' }} disponible{{ filteredRequests.length > 1 ? 's' : '' }}
              </p>
            </div>
            <!-- Vue toggle -->
            <div class="flex bg-gray-100 dark:bg-gray-800 rounded-lg p-1">
              <button 
                @click="viewMode = 'list'"
                class="p-2 rounded-md transition-all"
                :class="viewMode === 'list' ? 'bg-white dark:bg-gray-700 shadow-sm text-green-600' : 'text-gray-500'"
              >
                <UIcon name="i-heroicons-bars-3" class="w-5 h-5" />
              </button>
              <button 
                @click="viewMode = 'grid'"
                class="p-2 rounded-md transition-all"
                :class="viewMode === 'grid' ? 'bg-white dark:bg-gray-700 shadow-sm text-green-600' : 'text-gray-500'"
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
                placeholder="Rechercher par titre, description..."
                class="w-full pl-10 pr-4 py-2.5 bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-green-500 dark:focus:ring-green-400 focus:border-transparent"
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
                  ? 'bg-green-600 text-white shadow-sm' 
                  : 'bg-white dark:bg-gray-800 text-gray-600 dark:text-gray-300 border border-gray-200 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-700'"
              >
                {{ tab.label }}
              </button>
            </div>
          </div>

          <!-- Pills de catégories -->
          <div class="flex gap-2 overflow-x-auto pb-1 -mx-1 px-1 scrollbar-hide">
            <button 
              @click="categoryFilter = null"
              class="px-3 py-1.5 text-xs rounded-full whitespace-nowrap transition-all border"
              :class="!categoryFilter 
                ? 'bg-gray-900 dark:bg-white text-white dark:text-gray-900 border-gray-900 dark:border-white' 
                : 'bg-white dark:bg-gray-800 text-gray-600 dark:text-gray-300 border-gray-200 dark:border-gray-700 hover:border-gray-300 dark:hover:border-gray-600'"
            >
              Toutes les catégories
            </button>
            <button 
              v-for="category in categories"
              :key="category.id"
              @click="categoryFilter = category.id"
              class="px-3 py-1.5 text-xs rounded-full whitespace-nowrap transition-all border"
              :class="categoryFilter === category.id 
                ? 'bg-gray-900 dark:bg-white text-white dark:text-gray-900 border-gray-900 dark:border-white' 
                : 'bg-white dark:bg-gray-800 text-gray-600 dark:text-gray-300 border-gray-200 dark:border-gray-700 hover:border-gray-300 dark:hover:border-gray-600'"
            >
              {{ category.name }}
            </button>
          </div>
        </div>
      </div>
    </div>
      <!-- :src="request.client?.avatar_url || defaultAvatar"
      :alt="request.client?.first_name" -->
    <!-- Contenu principal -->
    <div class="max-w-5xl bg-white dark:bg-gray-900 mx-auto px-4 sm:px-6 py-6">
      <!-- Vue Liste (style Leboncoin amélioré) -->
      <div v-if="viewMode === 'list'" class="space-y-4">
        <TransitionGroup name="list" tag="div" class="divide-y divide-gray-200 dark:divide-gray-700">
          <article 
            v-for="request in filteredRequests" 
            :key="request.id"
            class="group hover:bg-gray-50 dark:hover:bg-gray-700/50 transition-all duration-200 cursor-pointer"
            @click="navigateToRequest(request.id)"
          >
            <div class="px-6 py-4">
              <div class="flex">
                <!-- Image/Icon container style LeBonCoin -->
                <div class="w-56 h-40 bg-gray-100 dark:bg-gray-800 flex-shrink-0 relative overflow-hidden rounded-lg shadow-sm">
                  <div class="w-full h-full flex items-center justify-center">
                    <div 
                      class="w-20 h-20 rounded-full flex items-center justify-center"
                      :class="getCategoryColorClass(request.profession_id)"
                    >
                      <component 
                        :is="getCategoryIcon(request.profession_id)" 
                        class="w-10 h-10 text-white"
                      />
                    </div>
                  </div>

                  <!-- Badge Urgent -->
                  <div 
                    v-if="request.is_urgent"
                    class="absolute top-2 right-2 bg-red-500 text-white text-xs font-bold px-2 py-1 rounded shadow-sm flex items-center gap-1"
                  >
                    <span class="w-1.5 h-1.5 bg-white rounded-full"></span>
                    URGENT
                  </div>

                  <!-- Type de travail -->
                  <div 
                    class="absolute bottom-2 right-2 bg-black/60 backdrop-blur-sm text-white text-xs px-1.5 py-0.5 rounded-md flex items-center gap-1"
                  >
                    <UIcon :name="request.work_type === 'remote' ? 'i-heroicons-globe-alt' : 'i-heroicons-map-pin'" class="w-3 h-3" />
                    {{ getWorkTypeLabel(request.work_type) }}
                  </div>
                </div>

                <!-- Contenu style LeBonCoin -->
                <div class="flex-1 pl-6">
                  <div class="flex items-start justify-between">
                    <!-- Info principale -->
                    <div class="flex-1 min-w-0">
                      <!-- Status et date -->
                      <div class="flex items-center gap-2 mb-1.5">
                        <span class="text-sm font-medium text-gray-500 dark:text-gray-400">
                          {{ formatTimeAgo(request.created_at) }}
                        </span>
                        <span 
                          class="text-xs font-medium px-2 py-0.5 rounded-full"
                          :class="getStatusColor(request.status)"
                        >
                          {{ getStatusLabel(request.status) }}
                        </span>
                      </div>
                      
                      <!-- Titre de la demande -->
                      <h3 class="text-lg font-bold text-gray-900 dark:text-white group-hover:text-green-600 transition-colors">
                        {{ request.title }}
                      </h3>
                      
                      <!-- Budget -->
                      <div class="mt-2 flex items-baseline gap-2">
                        <span class="text-2xl font-bold text-gray-900 dark:text-white">
                          {{ formatPrice(request.budget) }}
                        </span>
                        <span class="text-sm font-medium text-gray-500">budget</span>
                      </div>

                      <!-- Détails clés -->
                      <div class="mt-3 flex items-center gap-6 text-sm text-gray-600 dark:text-gray-300">
                        <span class="flex items-center gap-1.5">
                          <UIcon name="i-heroicons-academic-cap" class="w-4 h-4 text-gray-400" />
                          {{ request.profession?.name }}
                        </span>
                        <span class="flex items-center gap-1.5">
                          <UIcon name="i-heroicons-user" class="w-4 h-4 text-gray-400" />
                          {{ request.client?.first_name }}
                        </span>
                        <span class="flex items-center gap-1.5">
                          <UIcon name="i-heroicons-map-pin" class="w-4 h-4 text-gray-400" />
                          {{ request.location || 'À distance' }}
                        </span>
                      </div>

                      <!-- Description courte -->
                      <p class="mt-3 text-sm text-gray-600 dark:text-gray-400 line-clamp-2">
                        {{ request.description || 'Aucune description disponible.' }}
                      </p>
                    </div>

                    <!-- Propositions count -->
                    <div class="flex flex-col items-end gap-2 ml-4">
                      <div class="flex items-center gap-1 bg-orange-50 dark:bg-orange-900/20 px-2 py-1 rounded-lg">
                        <UIcon name="i-heroicons-user-group" class="w-4 h-4 text-orange-500" />
                        <span class="text-sm font-semibold text-orange-700 dark:text-orange-400">
                          {{ request.proposals_count || 0 }}
                        </span>
                      </div>
                      
                      <!-- CTA Button -->
                      <button 
                        v-if="canMakeProposal(request)"
                        class="bg-green-600 hover:bg-green-700 text-white px-4 py-2 rounded-lg text-sm font-medium transition-colors shadow-sm"
                        @click.stop="makeProposal(request)"
                      >
                        Proposer
                      </button>
                    </div>
                  </div>

                  <!-- Deadline si présente -->
                  <div 
                    v-if="request.deadline"
                    class="mt-3 inline-flex items-center gap-1.5 text-xs font-medium px-2 py-1 rounded-full"
                    :class="isUrgent(request.deadline) ? 'bg-red-50 text-red-700 dark:bg-red-900/30 dark:text-red-400' : 'bg-gray-50 text-gray-700 dark:bg-gray-800 dark:text-gray-300'"
                  >
                    <UIcon name="i-heroicons-clock" class="w-3 h-3" />
                    Deadline: {{ formatDate(request.deadline) }}
                  </div>
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
            v-for="request in filteredRequests" 
            :key="request.id"
            class="group bg-white dark:bg-gray-800 rounded-xl shadow-sm hover:shadow-xl border border-gray-200 dark:border-gray-700 transition-all duration-300 cursor-pointer overflow-hidden"
            @click="navigateToRequest(request.id)"
          >
            <!-- Image avec ratio fixe -->
            <div class="aspect-[4/3] relative overflow-hidden">
              <img
                :src="request.client?.avatar_url || defaultAvatar"
                :alt="request.client?.first_name"
                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-700"
              />
              
              <!-- Badges -->
              <div class="absolute top-3 left-3 flex flex-col gap-1">
                <span 
                  class="px-2 py-1 rounded text-xs font-semibold"
                  :class="getStatusColor(request.status)"
                >
                  {{ getStatusLabel(request.status) }}
                </span>
                <span 
                  v-if="request.is_urgent"
                  class="bg-red-500 text-white px-2 py-1 rounded text-xs font-semibold"
                >
                  URGENT
                </span>
              </div>

              <!-- Budget -->
              <div class="absolute bottom-3 right-3">
                <div class="bg-white/95 backdrop-blur-sm rounded-lg px-2 py-1">
                  <div class="text-sm font-bold text-gray-900">{{ formatPrice(request.budget) }}</div>
                </div>
              </div>

              <!-- Propositions count -->
              <div class="absolute top-3 right-3">
                <div class="bg-orange-500 text-white rounded-full w-6 h-6 flex items-center justify-center text-xs font-bold">
                  {{ request.proposals_count || 0 }}
                </div>
              </div>
            </div>

            <!-- Contenu -->
            <div class="p-4">
              <div class="flex items-start justify-between mb-2">
                <div class="flex-1">
                  <h3 class="font-bold text-gray-900 dark:text-white text-lg group-hover:text-green-600 transition-colors line-clamp-1">
                    {{ request.title }}
                  </h3>
                  <p class="text-green-600 dark:text-green-400 text-sm font-medium">{{ request.profession?.name }}</p>
                </div>
              </div>

              <p class="text-gray-600 dark:text-gray-300 text-sm line-clamp-2 mb-3">
                {{ request.description || 'Aucune description disponible.' }}
              </p>

              <!-- Stats compactes -->
              <div class="flex items-center justify-between text-xs text-gray-500 dark:text-gray-400 mb-3">
                <span>{{ formatTimeAgo(request.created_at) }}</span>
                <span>{{ getWorkTypeLabel(request.work_type) }}</span>
              </div>

              <!-- CTA -->
              <button 
                v-if="canMakeProposal(request)"
                class="w-full bg-green-600 hover:bg-green-700 text-white py-2 rounded-lg text-sm font-medium transition-colors"
                @click.stop="makeProposal(request)"
              >
                Proposer mes services
              </button>
              <div 
                v-else
                class="w-full text-center py-2 text-xs text-gray-400"
              >
                {{ getActionLabel(request) }}
              </div>
            </div>
          </article>
        </TransitionGroup>
      </div>

      <!-- États vides -->
      <div v-if="isLoading" class="flex justify-center items-center py-20">
        <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-green-600"></div>
      </div>

      <div v-if="!isLoading && filteredRequests.length === 0" class="text-center py-20">
        <div class="w-24 h-24 mx-auto mb-6 rounded-full bg-gray-100 dark:bg-gray-800 flex items-center justify-center">
          <UIcon name="i-heroicons-inbox" class="w-12 h-12 text-gray-400" />
        </div>
        <h3 class="text-xl font-semibold mb-2 text-gray-900 dark:text-white">Aucune demande trouvée</h3>
        <p class="text-gray-500 dark:text-gray-400 mb-6">Essayez de modifier vos critères de recherche</p>
        <button 
          @click="resetFilters"
          class="bg-green-600 hover:bg-green-700 text-white px-6 py-2 rounded-lg font-medium transition-colors"
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
const categoryFilter = ref(null)
const search = ref('')
const requests = ref([])
const categories = ref([])
const isLoading = ref(true)

// Tabs
const tabs = [
  { label: 'Toutes', value: 'all' },
  { label: 'Nouvelles', value: 'open' },
  { label: 'En cours', value: 'in_progress' },
  { label: 'Urgentes', value: 'urgent' }
]

// Charger les données
const fetchData = async () => {
  try {
    isLoading.value = true
    const [requestsData, categoriesData] = await Promise.all([
      supabase
        .from('missions')
        .select(`
          *,
          client:profiles(*),
          profession:professions(*),
          proposals:deals(count)
        `)
        .order('created_at', { ascending: false }),
      supabase
        .from('professions')
        .select('*')
        .eq('is_active', true)
        .order('name')
    ])

    requests.value = requestsData.data || []
    categories.value = categoriesData.data || []
  } catch (error) {
    console.error('Error fetching data:', error)
  } finally {
    isLoading.value = false
  }
}

// Filtrage amélioré
const filteredRequests = computed(() => {
  let filtered = requests.value

  // Filtre par statut
  if (filter.value === 'open') {
    filtered = filtered.filter(request => request.status === 'open')
  } else if (filter.value === 'in_progress') {
    filtered = filtered.filter(request => request.status === 'in_progress')
  } else if (filter.value === 'urgent') {
    filtered = filtered.filter(request => request.is_urgent)
  }

  // Filtre par catégorie
  if (categoryFilter.value) {
    filtered = filtered.filter(request => request.profession_id === categoryFilter.value)
  }

  // Recherche textuelle
  if (search.value.trim()) {
    const searchTerm = search.value.toLowerCase().trim()
    filtered = filtered.filter(request => 
      request.title?.toLowerCase().includes(searchTerm) ||
      request.description?.toLowerCase().includes(searchTerm) ||
      request.profession?.name?.toLowerCase().includes(searchTerm)
    )
  }

  return filtered
})

// Actions
const navigateToRequest = (id) => {
  router.push(`/requests/${id}`)
}

const makeProposal = (request) => {
  // Logique pour faire une proposition
  console.log('Make proposal for request:', request.id)
  router.push(`/requests/${request.id}/propose`)
}

const resetFilters = () => {
  filter.value = 'all'
  categoryFilter.value = null
  search.value = ''
}

// Fonctions utilitaires
const canMakeProposal = (request) => {
  if (!user.value) return false
  return request.status === 'open' && request.client_id !== user.value.id
}

const getActionLabel = (request) => {
  if (!user.value) return 'Connectez-vous'
  if (request.client_id === user.value.id) return 'Votre demande'
  if (request.status !== 'open') return 'Non disponible'
  return 'Déjà proposé'
}

const getStatusLabel = (status) => {
  const labels = {
    'open': 'Nouvelle',
    'in_progress': 'En cours',
    'completed': 'Terminée',
    'cancelled': 'Annulée'
  }
  return labels[status] || status
}

const getStatusColor = (status) => {
  const colors = {
    'open': 'bg-green-100 text-green-700 dark:bg-green-900/30 dark:text-green-400',
    'in_progress': 'bg-blue-100 text-blue-700 dark:bg-blue-900/30 dark:text-blue-400',
    'completed': 'bg-gray-100 text-gray-700 dark:bg-gray-800 dark:text-gray-300',
    'cancelled': 'bg-red-100 text-red-700 dark:bg-red-900/30 dark:text-red-400'
  }
  return colors[status] || colors.open
}

const getWorkTypeLabel = (type) => {
  return type === 'remote' ? 'À distance' : 'Sur place'
}

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

const formatDate = (date) => {
  if (!date) return 'Non spécifié'
  return format(new Date(date), 'dd MMM yyyy', { locale: fr })
}

const isUrgent = (deadline) => {
  if (!deadline) return false
  const now = new Date()
  const deadlineDate = new Date(deadline)
  const diffDays = Math.ceil((deadlineDate - now) / (1000 * 60 * 60 * 24))
  return diffDays <= 3 && diffDays >= 0
}

// Style helpers
const getCategoryColorClass = (professionId) => {
  const colors = {
    1: 'bg-blue-500',   // Bricolage
    2: 'bg-green-500',  // Jardinage
    3: 'bg-purple-500', // Ménage
    4: 'bg-amber-500',  // Déménagement
    5: 'bg-red-500',    // Rénovation
    6: 'bg-indigo-500', // Informatique
    7: 'bg-pink-500',   // Garde d'enfants
    8: 'bg-teal-500'    // Cours particuliers
  }
  return colors[professionId] || 'bg-gray-500'
}

const getCategoryIcon = (professionId) => {
  const icons = {
    1: 'Wrench',      // Bricolage
    2: 'Paintbrush',  // Jardinage
    3: 'Home',        // Ménage
    4: 'Briefcase',   // Déménagement
    5: 'LayoutGrid',  // Rénovation
    6: 'Monitor',     // Informatique
    7: 'Heart',       // Garde d'enfants
    8: 'GraduationCap' // Cours particuliers
  }
  return icons[professionId] || 'FileText'
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

.line-clamp-1 {
  display: -webkit-box;
  -webkit-line-clamp: 1;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.line-clamp-2 {
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

/* Animations */
.list-enter-active,
.list-leave-active,
.grid-enter-active,
.grid-leave-active {
  transition: all 0.4s cubic-bezier(0.25, 0.8, 0.25, 1);
}

.list-enter-from,
.list-leave-to,
.grid-enter-from,
.grid-leave-to {
  opacity: 0;
  transform: translateY(20px) scale(0.95);
}

.list-move,
.grid-move {
  transition: transform 0.4s cubic-bezier(0.25, 0.8, 0.25, 1);
}

</style>