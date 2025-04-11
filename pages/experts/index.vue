<template>
  <div class="min-h-screen font-sans bg-white dark:bg-gray-900">
    <!-- Header avec style Apple -->
    <header class="sticky top-0 z-10 bg-white/80 dark:bg-gray-900/80 backdrop-blur-md border-b border-gray-100/50 dark:border-gray-800/50">
      <div class="max-w-2xl mx-auto px-6 py-4">
        <div class="flex items-center justify-between">
          <div class="flex items-center gap-4">
            <h1 class="text-2xl font-sans font-bold text-gray-900 dark:text-white">
              Nos experts
            </h1>
            <span class="text-sm font-mono text-gray-500 dark:text-gray-400">
              {{ filteredExperts.length }} disponibles
            </span>
          </div>
        </div>

        <!-- Barre de recherche -->
        <div class="mt-4">
          <div class="relative">
            <input
              v-model="searchQuery"
              type="text"
              placeholder="Rechercher un expert..."
              class="w-full pl-10 pr-4 py-2.5 rounded-xl bg-gray-50 dark:bg-gray-800 
                     border border-gray-200 dark:border-gray-700
                     focus:ring-2 focus:ring-primary-500 focus:border-primary-500
                     text-gray-900 dark:text-white placeholder-gray-500 dark:placeholder-gray-400"
            />
            <UIcon 
              name="i-heroicons-magnifying-glass" 
              class="absolute left-3 top-1/2 -translate-y-1/2 h-5 w-5 text-gray-400"
            />
          </div>
        </div>
      </div>
    </header>

    <main class="max-w-2xl mx-auto px-6 py-6">
      <!-- Filtres rapides -->
      <div class="flex overflow-x-auto gap-2 pb-4 scrollbar-hide">
        <button
          v-for="filter in quickFilters"
          :key="filter.value"
          @click="activeFilter = filter.value"
          class="flex items-center px-4 py-2 rounded-full whitespace-nowrap transition-all"
          :class="[
            activeFilter === filter.value
              ? 'bg-gray-900 dark:bg-white text-white dark:text-gray-900'
              : 'bg-gray-100 dark:bg-gray-800 text-gray-600 dark:text-gray-400 hover:bg-gray-200 dark:hover:bg-gray-700'
          ]"
        >
          <UIcon :name="filter.icon" class="h-4 w-4 mr-2" />
          {{ filter.label }}
        </button>
      </div>

      <!-- Liste des experts -->
      <div class="space-y-6 mt-6">
        <template v-if="!isLoading && filteredExperts.length > 0">
          <article 
            v-for="expert in filteredExperts" 
            :key="expert.id"
            class="bg-white dark:bg-gray-800 rounded-2xl p-6 mb-4 shadow-sm- -hover:shadow-md transition-all duration-200 border border-gray-100 dark:border-gray-700"
          >
            <!-- En-tête avec photo et infos principales -->
            <div class="flex items-start gap-4 mb-4">
              <div class="relative">
                <div 
                  v-if="!!expert.avatar_url"
                  class="w-16 h-16 rounded-full bg-cover bg-center ring-2- -ring-white dark:ring-gray-800 shadow-md-"
                  :style="{ backgroundImage: `url(${expert.avatar_url})` }"
                ></div>
                <div 
                  v-else
                  class="w-16 h-16 rounded-full bg-gray-100 dark:bg-gray-700 ring-2 ring-white dark:ring-gray-800 shadow-md- flex items-center justify-center p-3"
                >
                  <img 
                    :src="expert.avatar_url || defaultAvatar"
                    :alt="`Photo de profil de ${expert.first_name}`"
                    class="w-full h-full object-contain"
                  />
                </div>
                <div 
                  v-if="expert.availability_status=='available'"
                  class="absolute bottom-0 right-0 w-4 h-4 bg-green-400 rounded-full border-2 border-white dark:border-gray-800"
                ></div>
              </div>

              <div class="flex-1 min-w-0">
                <div class="flex items-start justify-between">
                  <div>
                    <h2 class="text-lg font-bold font-sans text-gray-900 dark:text-white">
                      {{ expert.first_name }} {{ expert.last_name }}
                    </h2>
                    <div class="flex items-center gap-2 mt-1">
                      <span class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-xs font-medium
                                   bg-blue-50 dark:bg-blue-900/20 text-blue-600 dark:text-blue-400"
                      >
                        <UIcon name="i-heroicons-briefcase" class="w-3.5 h-3.5" />
                        {{ expert.profession?.name || 'Non renseigné' }}
                      </span>
                    </div>
                    <p class="text-sm text-gray-500 dark:text-gray-400 flex items-center gap-2">
                      <UIcon name="i-heroicons-map-pin" class="h-4 w-4" />
                      {{ expert.location || 'Non renseigné' }}
                    </p>
                  </div>
                  <div v-if="expert.is_verified" class="flex items-center gap-1 px-2 py-1 rounded-full bg-blue-50 dark:bg-blue-900/20">
                    <UIcon name="i-heroicons-check-badge" class="h-4 w-4 text-blue-500" />
                    <span class="text-xs font-medium text-blue-500">Vérifié</span>
                  </div>
                </div>

                <!-- Compétences -->
                <div class="mt-3 flex flex-wrap gap-2">
                  <span 
                    v-for="skill in expert.skills" 
                    :key="skill"
                    class="px-2 py-1 rounded-full text-xs font-medium bg-gray-100 dark:bg-gray-700 text-gray-600 dark:text-gray-300"
                  >
                    {{ skill }}
                  </span>
                </div>
              </div>
            </div>

            <!-- Bio -->
            <p class="text-gray-600 dark:text-gray-300 text-sm line-clamp-2 mb-4">
              {{ expert.bio }}
            </p>

            <!-- Footer avec stats - Modifié pour gérer les valeurs undefined -->
            <div class="flex items-center justify-between pt-4 border-t border-gray-100 dark:border-gray-700">
              <div class="flex items-center gap-4">
                <div class="flex items-center gap-1">
                  <UIcon name="i-heroicons-star" class="h-4 w-4 text-yellow-400" />
                  <span class="text-sm font-medium">
                    {{ expert.rating.toFixed(1) }}
                  </span>
                  <span class="text-sm text-gray-500 dark:text-gray-400">
                    ({{ expert.completed_missions }})
                  </span>
                </div>
                <div class="flex items-center gap-1 text-gray-500 dark:text-gray-400">
                  <UIcon name="i-heroicons-briefcase" class="h-4 w-4" />
                  <span class="text-sm font-mono">
                    {{ expert.completed_missions || 0 }} missions
                  </span>
                </div>
              </div>

              <NuxtLink
                :to="`/experts/${expert.id}`"
                class="inline-flex items-center px-4 py-2 rounded-full bg-gray-900 dark:bg-white text-white dark:text-gray-900 text-sm font-medium hover:opacity-90 transition-opacity"
              >
                Voir profil
                <UIcon name="i-heroicons-arrow-right" class="h-4 w-4 ml-2" />
              </NuxtLink>
            </div>
          </article>
        </template>

        <!-- Loading state -->
        <template v-else-if="isLoading">
          <div class="space-y-4">
            <div v-for="i in 3" :key="i" class="animate-pulse">
              <div class="bg-white dark:bg-gray-800 rounded-2xl p-6">
                <div class="flex items-center gap-4 mb-4">
                  <div class="w-16 h-16 bg-gray-200 dark:bg-gray-700 rounded-full"></div>
                  <div class="flex-1">
                    <div class="h-4 bg-gray-200 dark:bg-gray-700 rounded w-1/3 mb-2"></div>
                    <div class="h-3 bg-gray-200 dark:bg-gray-700 rounded w-1/4"></div>
                  </div>
                </div>
                <div class="h-4 bg-gray-200 dark:bg-gray-700 rounded w-3/4"></div>
              </div>
            </div>
          </div>
        </template>

        <!-- État vide -->
        <template v-else>
          <div class="text-center py-12 bg-white dark:bg-gray-800 rounded-2xl">
            <UIcon 
              name="i-heroicons-users" 
              class="mx-auto h-12 w-12 text-gray-400 dark:text-gray-600"
            />
            <h3 class="mt-4 text-lg font-medium text-gray-900 dark:text-white">
              Aucun expert trouvé
            </h3>
            <p class="mt-2 text-gray-500 dark:text-gray-400">
              Essayez de modifier vos filtres ou revenez plus tard
            </p>
          </div>
        </template>
      </div>
    </main>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useSupabaseClient } from '#imports'
import { useDefaultAvatar } from '~/composables/useDefaultAvatar'
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
const { defaultAvatar } = useDefaultAvatar()

const searchQuery = ref('')
const isLoading = ref(true)
const experts = ref([])
const activeFilter = ref('all')

// Filtres rapides
const quickFilters = [
  { label: 'Tous', value: 'all', icon: 'i-heroicons-users' },
  { label: 'Mieux notés', value: 'top-rated', icon: 'i-heroicons-star' },
  { label: 'Plus actifs', value: 'most-active', icon: 'i-heroicons-bolt' },
  { label: 'Récents', value: 'recent', icon: 'i-heroicons-clock' },
  { label: 'Vérifiés', value: 'verified', icon: 'i-heroicons-check-badge' }
]

// Récupération des experts avec leurs notations
const fetchExperts = async () => {
  try {
    isLoading.value = true
    const { data, error } = await supabase
      .from('profiles')
      .select(`
        *,
        profession:professions(*),
        deals!deals_expert_id_fkey (
          expert_rating,
          status
        )
      `)
      .eq('role', 'expert')

    if (error) throw error
    
    // Traiter les données pour calculer les moyennes
    experts.value = (data || []).map(expert => {
      // Filtrer les deals complétés avec notation
      const completedDeals = expert.deals?.filter(deal => 
        deal.status === 'completed' && deal.expert_rating !== null
      ) || []

      // Calculer la moyenne des notations
      const totalRating = completedDeals.reduce((sum, deal) => 
        sum + (deal.expert_rating || 0), 0
      )
      
      const averageRating = completedDeals.length > 0 
        ? totalRating / completedDeals.length 
        : 0

      return {
        ...expert,
        rating: averageRating,
        completed_missions: completedDeals.length,
        skills: expert.skills || [],
        location: expert.location || 'À distance',
        bio: expert.bio || 'Aucune description disponible'
      }
    })
    
    console.log('Experts chargés:', experts.value.length)
  } catch (error) {
    console.error('Erreur lors de la récupération des experts:', error)
    experts.value = []
  } finally {
    isLoading.value = false
  }
}

// Filtrage des experts modifié pour prendre en compte les nouvelles notations
const filteredExperts = computed(() => {
  let filtered = [...experts.value]

  // Filtre par recherche
  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase()
    filtered = filtered.filter(expert => 
      expert.first_name.toLowerCase().includes(query) ||
      expert.last_name.toLowerCase().includes(query) ||
      expert.bio?.toLowerCase().includes(query) ||
      expert.skills?.some(skill => skill.toLowerCase().includes(query))
    )
  }

  // Filtres rapides
  switch (activeFilter.value) {
    case 'top-rated':
      filtered = filtered.sort((a, b) => b.rating - a.rating)
      break
    case 'most-active':
      filtered = filtered.sort((a, b) => b.completed_missions - a.completed_missions)
      break
    case 'recent':
      filtered = filtered.sort((a, b) => new Date(b.created_at) - new Date(a.created_at))
      break
    case 'verified':
      filtered = filtered.filter(expert => expert.is_verified)
      break
  }

  return filtered
})

// Initialisation modifiée
onMounted(async () => {
  console.log('Composant monté, début du chargement')
  await fetchExperts()
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
</style>