<template>
  <div class="w-full">
    <!-- En-tête avec nav collante style Twitter -->
    <div class="sticky top-14 z-20 bg-white/90 dark:bg-gray-900/90 backdrop-blur-sm border-b border-gray-200 dark:border-gray-700">
      <div class="max-w-3xl mx-auto">
        <!-- Titre et filtres -->
        <div class="px-4 py-3 flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3">
          <h1 class="text-xl font-bold text-gray-900 dark:text-white">Mes missions</h1>
          
          <!-- Onglets de filtrage style Twitter -->
          <div class="inline-flex p-0.5 rounded-full bg-gray-100 dark:bg-gray-800 shadow-inner">
            <button 
              v-for="tab in tabs" 
              :key="tab.value"
              @click="activeTab = tab.value"
              class="relative px-3 py-1.5 text-sm font-medium rounded-full transition-colors"
              :class="[
                activeTab === tab.value 
                  ? 'bg-white dark:bg-gray-700 text-gray-900 dark:text-white shadow-sm' 
                  : 'text-gray-600 dark:text-gray-400 hover:text-gray-900 dark:hover:text-gray-300'
              ]"
            >
              {{ tab.label }}
              <span 
                v-if="getFilteredMissions(tab.value).length > 0"
                class="absolute -top-1 -right-1 flex items-center justify-center min-w-[18px] h-[18px] text-[10px] font-bold rounded-full bg-primary-500 text-white"
              >
                {{ getFilteredMissions(tab.value).length }}
              </span>
            </button>
          </div>
        </div>
        
        <!-- Barre de recherche style Twitter -->
        <div class="px-4 pb-3">
          <div class="relative">
            <div class="absolute inset-y-0 left-3 flex items-center pointer-events-none">
              <VIcon name="bi-search-heart" class="h-5 w-5 text-gray-400" />
            </div>
            <input 
              v-model="searchQuery" 
              type="text" 
              placeholder="Rechercher une mission..." 
              class="block w-full bg-gray-100 dark:bg-gray-800 border-none rounded-full pl-10 pr-4 py-2 text-gray-900 dark:text-gray-100 focus:ring-2 focus:ring-primary-500 transition-all"
            />
          </div>
        </div>
      </div>
    </div>

    <div class="max-w-3xl mx-auto">
      <!-- État de chargement avec animation fluide -->
      <div v-if="isLoading" class="flex justify-center items-center py-12">
        <div class="animate-spin rounded-full h-10 w-10 border-b-2 border-[#FF5F40]"></div>
      </div>

      <!-- État d'erreur avec design Twitter -->
      <div v-else-if="error" class="mx-4 my-6 bg-red-50 dark:bg-red-900/20 p-5 rounded-2xl border border-red-100 dark:border-red-800/30">
        <div class="flex items-start">
          <div class="flex-shrink-0">
            <VIcon name="bi-exclamation-circle-fill" class="h-5 w-5 text-red-400" />
          </div>
          <div class="ml-3 flex-1">
            <h3 class="text-sm font-medium text-red-800 dark:text-red-300">Une erreur est survenue</h3>
            <p class="mt-1 text-sm text-red-700 dark:text-red-400">{{ error }}</p>
            <div class="mt-3">
              <button 
                @click="fetchMissions" 
                class="inline-flex items-center px-3 py-1.5 border border-transparent text-xs font-medium rounded-full shadow-sm text-white bg-red-600 hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500 transition-colors"
              >
                Réessayer
              </button>
            </div>
          </div>
        </div>
      </div>

      <!-- État vide avec illustration et design Twitter -->
      <div v-else-if="missions.length === 0" class="text-center py-12 mx-4">
        <div class="mx-auto w-24 h-24 bg-gray-100 dark:bg-gray-800 rounded-full flex items-center justify-center">
          <VIcon name="bi-briefcase-fill" class="h-12 w-12 text-gray-400" />
        </div>
        <h3 class="mt-4 text-lg font-medium text-gray-900 dark:text-white">Aucune mission</h3>
        <p class="mt-2 text-gray-500 dark:text-gray-400 max-w-md mx-auto">
          Vous n'avez pas encore de missions. Créez votre première mission pour commencer.
        </p>
      </div>
      
      <!-- Aucun résultat pour la recherche/le filtre -->
      <div v-else-if="getFilteredMissions(activeTab).length === 0" class="text-center py-12 mx-4">
        <div class="mx-auto w-24 h-24 bg-gray-100 dark:bg-gray-800 rounded-full flex items-center justify-center">
          <VIcon name="bi-search-heart" class="h-12 w-12 text-gray-400" />
        </div>
        <h3 class="mt-4 text-lg font-medium text-gray-900 dark:text-white">Aucun résultat</h3>
        <p class="mt-2 text-gray-500 dark:text-gray-400 max-w-md mx-auto">
          Aucune mission {{ getTabLabel(activeTab).toLowerCase() }} ne correspond à votre recherche.
        </p>
      </div>

      <!-- Liste des missions avec design Twitter -->
      <div v-else class="divide-y divide-gray-200 dark:divide-gray-700 mx-4 my-6">
        <div 
          v-for="(mission, index) in getFilteredMissions(activeTab)" 
          :key="mission.id"
          class="py-4 animate-fadeIn"
          :style="{ animationDelay: `${index * 0.05}s` }"
        >
          <div class="relative p-4 -m-4 hover:bg-gray-50 dark:hover:bg-gray-800/50 rounded-xl transition-colors group">
            <!-- Mission Content -->
            <NuxtLink 
              :to="`/account/missions/${mission.id}`"
              class="block pr-12"
            >
              <div class="flex items-start justify-between gap-4">
                <div class="min-w-0 flex-1">
                  <h3 class="text-base font-semibold text-gray-900 dark:text-white truncate">
                    {{ mission.title }}
                  </h3>
                  <div class="mt-1 flex flex-wrap items-center gap-x-4 gap-y-2 text-sm">
                    <div class="text-gray-500 dark:text-gray-400 truncate max-w-md">
                      {{ mission.description }}
                    </div>
                    <div class="flex items-center text-gray-500 dark:text-gray-400">
                      <VIcon name="bi-clock-fill" class="w-4 h-4 mr-1" />
                      {{ formatDate(mission.created_at) }}
                    </div>
                    <div v-if="mission.budget" class="flex items-center text-gray-500 dark:text-gray-400">
                      <VIcon name="bi-cash-stack" class="w-4 h-4 mr-1" />
                      {{ formatPrice(mission.budget) }}
                    </div>
                  </div>
                </div>

                <!-- Badge de statut -->
                <div 
                  class="rounded-full px-2.5 py-0.5 text-xs font-medium whitespace-nowrap"
                  :class="{
                    'bg-yellow-50 text-yellow-800 dark:bg-yellow-900/20 dark:text-yellow-300': mission.status === 'open',
                    'bg-blue-50 text-blue-800 dark:bg-blue-900/20 dark:text-blue-300': mission.status === 'in_progress',
                    'bg-green-50 text-green-800 dark:bg-green-900/20 dark:text-green-300': mission.status === 'completed',
                    'bg-red-50 text-red-800 dark:bg-red-900/20 dark:text-red-300': mission.status === 'cancelled'
                  }"
                >
                  {{ formatStatus(mission.status) }}
                </div>
              </div>
            </NuxtLink>

            <!-- Delete Button -->
            <button 
              v-if="mission.status !== 'completed'"
              @click="confirmDelete(mission)"
              class="absolute right-4 top-1/2 -translate-y-1/2 p-2 rounded-full opacity-0 group-hover:opacity-100 transition-opacity hover:bg-red-50 dark:hover:bg-red-900/20"
              title="Supprimer la mission"
            >
              <VIcon 
                name="bi-trash-fill" 
                class="w-4 h-4 text-[#FF5F40] dark:text-[#FF5F40]" 
              />
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div 
      v-if="showDeleteModal"
      class="fixed inset-0 bg-gray-500/75 dark:bg-gray-900/75 flex items-center justify-center p-4 z-50"
    >
      <div class="bg-white dark:bg-gray-800 rounded-2xl p-6 max-w-md w-full">
        <h3 class="text-lg font-semibold text-gray-900 dark:text-white mb-2">
          Supprimer la mission
        </h3>
        <p class="text-gray-600 dark:text-gray-400 mb-6">
          Êtes-vous sûr de vouloir supprimer cette mission ? Cette action est irréversible.
        </p>
        <div class="flex justify-end gap-3">
          <button
            @click="showDeleteModal = false"
            class="px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50 dark:text-gray-300 dark:hover:bg-gray-700 rounded-full transition-colors"
          >
            Annuler
          </button>
          <button
            @click="deleteMission"
            class="px-4 py-2 text-sm font-medium text-white bg-red-600 hover:bg-red-700 rounded-full transition-colors"
            :disabled="isDeleting"
          >
            {{ isDeleting ? 'Suppression...' : 'Supprimer' }}
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { useSupabaseClient, useSupabaseUser } from '#imports'
import { OhVueIcon as VIcon, addIcons } from 'oh-vue-icons'
import { 
  BiTrashFill,
  BiClockFill,
  BiCashStack,
  BiSearchHeart,
  BiBriefcaseFill,
  BiExclamationCircleFill
} from 'oh-vue-icons/icons'

addIcons(
  BiTrashFill,
  BiClockFill,
  BiCashStack,
  BiSearchHeart,
  BiBriefcaseFill,
  BiExclamationCircleFill
)

const supabase = useSupabaseClient()
const user = useSupabaseUser()

// État
const missions = ref([])
const isLoading = ref(true)
const error = ref(null)
const activeTab = ref('all')
const searchQuery = ref('')

// Tabs
const tabs = [
  { label: 'Toutes', value: 'all' },
  { label: 'En cours', value: 'in_progress' },
  { label: 'Terminées', value: 'completed' }
]

// Filtrer les missions selon la recherche
const filteredMissions = computed(() => {
  if (!searchQuery.value) return missions.value
  
  const search = searchQuery.value.toLowerCase()
  return missions.value.filter(mission => {
    return (
      mission.title.toLowerCase().includes(search) ||
      mission.description.toLowerCase().includes(search)
    )
  })
})

// Obtenir les missions filtrées par statut et recherche
const getFilteredMissions = (tabValue) => {
  let filtered = filteredMissions.value
  
  if (tabValue !== 'all') {
    filtered = filtered.filter(mission => mission.status === tabValue)
  }
  
  return filtered
}

// Obtenir le libellé de l'onglet actif
const getTabLabel = (tabValue) => {
  const tab = tabs.find(t => t.value === tabValue)
  return tab ? tab.label : ''
}

// Récupérer les missions
const fetchMissions = async () => {
  if (!user.value) return
  
  isLoading.value = true
  error.value = null
  
  try {
    const { data, error: missionsError } = await supabase
      .from('missions')
      .select(`
        *,
        deal:deals(*)
      `)
      .eq('client_id', user.value.id)
      .order('created_at', { ascending: false })
    
    if (missionsError) throw missionsError
    
    missions.value = data || []
  } catch (err) {
    console.error('Error fetching missions:', err)
    error.value = "Une erreur est survenue lors du chargement de vos missions"
  } finally {
    isLoading.value = false
  }
}

// Utilitaires
const formatDate = (date) => {
  return new Date(date).toLocaleDateString('fr-FR', {
    day: 'numeric',
    month: 'short'
  })
}

const formatPrice = (amount) => {
  return new Intl.NumberFormat('fr-FR', {
    style: 'currency',
    currency: 'EUR'
  }).format(amount)
}

const formatStatus = (status) => {
  const statusMap = {
    open: 'En attente',
    in_progress: 'En cours',
    completed: 'Terminée',
    cancelled: 'Annulée'
  }
  return statusMap[status] || status
}

// Initialisation
onMounted(async () => {
  if (user.value) {
    await fetchMissions()
  }
})

// Surveiller les changements de recherche
watch(searchQuery, () => {
  // Pas besoin de recharger, on filtre juste les données existantes
})

// Add new refs for delete functionality
const showDeleteModal = ref(false)
const isDeleting = ref(false)
const missionToDelete = ref(null)

// Add new methods for delete functionality
const confirmDelete = (mission) => {
  missionToDelete.value = mission
  showDeleteModal.value = true
}

const deleteMission = async () => {
  if (!missionToDelete.value) return
  
  isDeleting.value = true
  
  try {
    const { error } = await supabase
      .from('missions')
      .delete()
      .eq('id', missionToDelete.value.id)
      .eq('client_id', user.value.id) // Security check
    
    if (error) throw error
    
    // Remove from local state
    missions.value = missions.value.filter(m => m.id !== missionToDelete.value.id)
    
    showDeleteModal.value = false
    missionToDelete.value = null
    
  } catch (err) {
    console.error('Error deleting mission:', err)
    alert('Une erreur est survenue lors de la suppression de la mission')
  } finally {
    isDeleting.value = false
  }
}

definePageMeta({
  layout: 'account'
})
</script>

<style scoped>
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

.animate-fadeIn {
  animation-name: fadeIn;
  animation-duration: 0.3s;
  animation-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
  animation-fill-mode: both;
}

.group:hover .opacity-0 {
  opacity: 1;
}

.v-icon {
  display: inline-block;
  vertical-align: middle;
  transition: transform 0.2s ease;
}

.v-icon:hover {
  transform: scale(1.1);
}

.flex items-center .v-icon {
  flex-shrink: 0;
}
</style> 