<!-- pages/index.vue -->
<template>
  <div class="max-w-4xl mx-auto px-4 py-4 md:py-8">
    <!-- En-tête -->
    <div class="bg-white dark:bg-gray-800 rounded-xl shadow-sm overflow-hidden mb-4 md:mb-8">
      <div class="p-4 md:p-6">
        <!-- Version mobile du header -->
        <div class="md:hidden mb-4">
          <div class="flex items-center justify-between">
            <h1 class="text-xl font-bold text-gray-900 dark:text-white">Mon profil</h1>
            <NuxtLink 
              to="/account/edit-profile"
              class="inline-flex items-center px-3 py-1.5 bg-gray-100 hover:bg-gray-200 dark:bg-gray-700 dark:hover:bg-gray-600 rounded-full text-sm text-gray-700 dark:text-white font-medium transition-all"
            >
              <v-icon name="bi-pencil" class="mr-1" scale="0.9" />
              Modifier
            </NuxtLink>
          </div>
        </div>

        <div class="flex flex-col md:flex-row items-start md:items-center gap-4 md:gap-6">
          <!-- Avatar et statut -->
          <div class="relative mx-auto md:mx-0">
            <div class="w-24 h-24 md:w-32 md:h-32 rounded-full ring-4 ring-gray-100 dark:ring-gray-700 overflow-hidden">
              <img 
                v-if="profile?.avatar_url" 
                :src="profile.avatar_url" 
                :alt="profile?.first_name"
                class="w-full h-full object-cover"
              />
              <div 
                v-else 
                class="w-full h-full bg-gradient-to-br from-gray-100 to-gray-200 dark:from-gray-700 dark:to-gray-600 flex items-center justify-center text-3xl font-bold text-gray-400 dark:text-gray-300"
              >
                {{ getInitials(profile?.first_name, profile?.last_name) }}
              </div>
            </div>
            <div 
              class="absolute -bottom-1 -right-1 w-6 h-6 md:w-8 md:h-8 rounded-full ring-4 ring-white dark:ring-gray-800 flex items-center justify-center"
              :class="{
                'bg-green-500': profile?.availability_status === 'available',
                'bg-yellow-500': profile?.availability_status === 'busy',
                'bg-red-500': profile?.availability_status === 'unavailable'
              }"
            >
              <v-icon :name="availabilityIcon" class="text-white" scale="1.2" />
            </div>
          </div>

          <!-- Informations utilisateur -->
          <div class="flex-1 w-full">
            <!-- Header desktop -->
            <div class="hidden md:flex items-center justify-between mb-4">
              <h1 class="text-2xl font-bold text-gray-900 dark:text-white">
                {{ profile?.first_name }} {{ profile?.last_name }}
              </h1>
              <NuxtLink 
                to="/account/edit-profile"
                class="inline-flex items-center px-4 py-2 bg-gray-100 hover:bg-gray-200 dark:bg-gray-700 dark:hover:bg-gray-600 rounded-full text-gray-700 dark:text-white font-medium transition-all"
              >
                <v-icon name="bi-pencil" class="mr-2" />
                Modifier
              </NuxtLink>
            </div>

            <!-- Nom (mobile) -->
            <h2 class="md:hidden text-center text-xl font-bold text-gray-900 dark:text-white mb-2">
              {{ profile?.first_name }} {{ profile?.last_name }}
            </h2>

            <!-- Badges et statut -->
            <div class="flex flex-wrap items-center justify-center md:justify-start gap-2 mb-4">
              <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-primary-100 text-primary-800 dark:bg-primary-900/30 dark:text-primary-400">
                {{ profile?.role === 'expert' ? 'Expert' : 'Client' }}
              </span>
              <span v-if="profile?.is_verified" class="inline-flex items-center text-primary-600 dark:text-primary-400">
                <v-icon name="bi-patch-check-fill" scale="1.2" class="mr-1" />
                Vérifié
              </span>
              <span v-if="profession?.name" class="text-gray-600 dark:text-gray-300">
                {{ profession.name }}
              </span>
            </div>

            <!-- Barre de progression -->
            <div class="mb-4">
              <div class="flex items-center justify-between mb-2">
                <span class="text-sm font-medium text-gray-700 dark:text-gray-300">
                  Profil complété
                </span>
                <span class="text-sm font-medium text-primary-600 dark:text-primary-400">
                  {{ completionPercentage }}%
                </span>
              </div>
              <div class="w-full bg-gray-200 dark:bg-gray-700 rounded-full h-2">
                <div 
                  class="bg-primary-600 h-2 rounded-full transition-all duration-500"
                  :style="{ width: `${completionPercentage}%` }"
                />
              </div>
            </div>

            <!-- Liste des éléments manquants (collapsible sur mobile) -->
            <div v-if="missingItems.length > 0" class="mt-3">
              <button 
                @click="showMissingItems = !showMissingItems"
                class="md:hidden w-full flex items-center justify-between text-sm text-gray-600 dark:text-gray-400 p-2 rounded-lg bg-gray-50 dark:bg-gray-700/50"
              >
                <span>{{ missingItems.length }} éléments à compléter</span>
                <v-icon 
                  :name="showMissingItems ? 'bi-chevron-up' : 'bi-chevron-down'"
                  scale="0.9"
                />
              </button>
              
              <div 
                :class="[
                  'md:block space-y-1 mt-2',
                  showMissingItems ? 'block' : 'hidden'
                ]"
              >
                <div 
                  v-for="item in missingItems" 
                  :key="item.field"
                  class="flex items-center text-sm text-gray-600 dark:text-gray-400"
                >
                  <v-icon name="bi-x" class="text-red-500 mr-2" />
                  {{ item.label }}
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Stats et dernières missions -->
    <div class="grid gap-4 md:gap-8 mb-4 md:mb-8">
      <!-- Stats -->
      <div class="bg-white dark:bg-gray-800 rounded-xl shadow-sm p-4 md:p-6">
        <h2 class="text-lg font-semibold text-gray-900 dark:text-white mb-4">Vue d'ensemble</h2>
        <div class="grid grid-cols-2 md:grid-cols-3 gap-3 md:gap-4">
          <div class="p-4 rounded-xl bg-gray-50 dark:bg-gray-700/50">
            <div class="text-2xl font-bold text-gray-900 dark:text-white">
              {{ activeContracts }}
            </div>
            <div class="text-sm text-gray-500 dark:text-gray-400">
              Contrats actifs
            </div>
          </div>
          <div v-if="profile?.role === 'expert'" class="p-4 rounded-xl bg-gray-50 dark:bg-gray-700/50">
            <div class="text-2xl font-bold text-gray-900 dark:text-white">
              {{ profile?.hourly_rate || 0 }}€
            </div>
            <div class="text-sm text-gray-500 dark:text-gray-400">
              Tarif horaire
            </div>
          </div>
          <div v-if="profile?.role === 'expert'" class="p-4 rounded-xl bg-gray-50 dark:bg-gray-700/50">
            <div class="text-2xl font-bold text-gray-900 dark:text-white">
              {{ skillsCount }}
            </div>
            <div class="text-sm text-gray-500 dark:text-gray-400">
              Compétences
            </div>
          </div>
        </div>
      </div>

      <!-- Dernières missions -->
      <div class="bg-white dark:bg-gray-800 rounded-xl shadow-sm p-4 md:p-6">
        <div class="flex items-center justify-between mb-4">
          <h2 class="text-lg font-semibold text-gray-900 dark:text-white">Dernières missions</h2>
          <NuxtLink 
            to="/account/missions"
            class="text-sm text-primary-600 dark:text-primary-400 hover:underline"
          >
            Voir tout
          </NuxtLink>
        </div>
        
        <div v-if="recentMissions.length > 0" class="space-y-3 md:space-y-4">
          <div 
            v-for="mission in recentMissions" 
            :key="mission.id"
            class="p-4 rounded-xl bg-gray-50 dark:bg-gray-700/50 flex items-center justify-between"
          >
            <div>
              <h3 class="font-medium text-gray-900 dark:text-white">
                {{ mission.title }}
              </h3>
              <p class="text-sm text-gray-500 dark:text-gray-400">
                {{ formatDate(mission.created_at) }}
              </p>
            </div>
            <span 
              class="px-2.5 py-0.5 rounded-full text-xs font-medium"
              :class="getMissionStatusClass(mission.status)"
            >
              {{ getMissionStatusLabel(mission.status) }}
            </span>
          </div>
        </div>
        <div 
          v-else 
          class="text-center py-6 md:py-8 text-gray-500 dark:text-gray-400"
        >
          Aucune mission récente
        </div>
      </div>
    </div>

    <!-- Sections d'informations -->
    <div class="grid gap-8">
      <!-- Informations personnelles -->
      <div class="bg-white dark:bg-gray-800 rounded-2xl shadow-sm overflow-hidden">
        <div class="p-6">
          <h2 class="text-xl font-semibold text-gray-900 dark:text-white mb-6 flex items-center">
            <v-icon name="bi-person" class="mr-2" />
            Informations personnelles
          </h2>
          <dl class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div class="p-4 rounded-xl bg-gray-50 dark:bg-gray-700/50">
              <dt class="text-sm font-medium text-gray-500 dark:text-gray-400">Email</dt>
              <dd class="mt-1 text-gray-900 dark:text-white font-medium">{{ profile?.email }}</dd>
            </div>
            <div class="p-4 rounded-xl bg-gray-50 dark:bg-gray-700/50">
              <dt class="text-sm font-medium text-gray-500 dark:text-gray-400">Téléphone</dt>
              <dd class="mt-1 text-gray-900 dark:text-white font-medium">{{ profile?.phone || '—' }}</dd>
            </div>
            <div class="p-4 rounded-xl bg-gray-50 dark:bg-gray-700/50">
              <dt class="text-sm font-medium text-gray-500 dark:text-gray-400">Date de naissance</dt>
              <dd class="mt-1 text-gray-900 dark:text-white font-medium">{{ formatDate(profile?.birthdate) }}</dd>
            </div>
            <div class="p-4 rounded-xl bg-gray-50 dark:bg-gray-700/50">
              <dt class="text-sm font-medium text-gray-500 dark:text-gray-400">Localisation</dt>
              <dd class="mt-1 text-gray-900 dark:text-white font-medium">
                {{ [profile?.city, profile?.country].filter(Boolean).join(', ') || '—' }}
              </dd>
            </div>
          </dl>
        </div>
      </div>

      <!-- Section Expert (conditionnelle) -->
      <div v-if="profile?.role === 'expert'" class="bg-white dark:bg-gray-800 rounded-2xl shadow-sm overflow-hidden">
        <div class="p-6">
          <h2 class="text-xl font-semibold text-gray-900 dark:text-white mb-6 flex items-center">
            <v-icon name="bi-briefcase" class="mr-2" />
            Profil professionnel
          </h2>
          <dl class="space-y-6">
            <div class="p-4 rounded-xl bg-gray-50 dark:bg-gray-700/50">
              <dt class="text-sm font-medium text-gray-500 dark:text-gray-400">Bio</dt>
              <dd class="mt-2 text-gray-900 dark:text-white">{{ profile?.bio || '—' }}</dd>
            </div>
            <div class="p-4 rounded-xl bg-gray-50 dark:bg-gray-700/50">
              <dt class="text-sm font-medium text-gray-500 dark:text-gray-400">Compétences</dt>
              <dd class="mt-3">
                <div class="flex flex-wrap gap-2">
                  <span 
                    v-for="skill in skills" 
                    :key="skill.id"
                    class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-primary-100 text-primary-800 dark:bg-primary-900/30 dark:text-primary-400"
                  >
                    {{ skill.name }}
                  </span>
                </div>
              </dd>
            </div>
          </dl>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useSupabaseClient, useSupabaseUser } from '#imports'

const supabase = useSupabaseClient()
const user = useSupabaseUser()

// État
const profile = ref(null)
const profession = ref(null)
const skills = ref([])
const activeContracts = ref(0)

// État pour les missions récentes
const recentMissions = ref([])

// Liste des éléments requis pour compléter le profil
const requiredItems = [
  { field: 'phone', label: 'Numéro de téléphone' },
  { field: 'birthdate', label: 'Date de naissance' },
  { field: 'city', label: 'Ville' },
  { field: 'country', label: 'Pays' },
  { field: 'bio', label: 'Bio', expertOnly: true },
  { field: 'profession_id', label: 'Profession', expertOnly: true },
  { field: 'hourly_rate', label: 'Tarif horaire', expertOnly: true },
]

// Computed
const completionPercentage = computed(() => profile.value?.profile_completion_percentage || 0)
const skillsCount = computed(() => skills.value.length)

// Computed pour l'icône de disponibilité
const availabilityIcon = computed(() => {
  switch (profile.value?.availability_status) {
    case 'available':
      return 'bi-check-lg'
    case 'busy':
      return 'bi-clock'
    case 'unavailable':
      return 'bi-x-lg'
    default:
      return 'bi-dash-lg'
  }
})

// Computed pour les éléments manquants
const missingItems = computed(() => {
  if (!profile.value) return []
  
  return requiredItems.filter(item => {
    if (item.expertOnly && profile.value.role !== 'expert') return false
    return !profile.value[item.field]
  })
})

// Ajout de l'état pour le toggle des éléments manquants sur mobile
const showMissingItems = ref(false)

// Fonctions utilitaires
const getInitials = (firstName, lastName) => {
  return `${firstName?.[0] || ''}${lastName?.[0] || ''}`.toUpperCase()
}

const formatDate = (date) => {
  if (!date) return '—'
  return new Date(date).toLocaleDateString()
}

// Charger les données
onMounted(async () => {
  if (user.value) {
    await Promise.all([
      fetchProfile(),
      fetchActiveContracts(),
      fetchRecentMissions()
    ])
  }
})

// Charger le profil et les données associées
const fetchProfile = async () => {
  try {
    const { data } = await supabase
      .from('profiles')
      .select(`
        *,
        profession:professions(*),
        user_skills(
          skill:skills(*)
        )
      `)
      .eq('id', user.value.id)
      .single()

    if (data) {
      profile.value = data
      profession.value = data.profession
      skills.value = data.user_skills.map(us => us.skill)
    }
  } catch (error) {
    console.error('Error fetching profile:', error)
  }
}

// Charger le nombre de contrats actifs
const fetchActiveContracts = async () => {
  try {
    const { count } = await supabase
      .from('deals')
      .select('*', { count: 'exact', head: true })
      .eq(profile.value?.role === 'expert' ? 'expert_id' : 'client_id', user.value.id)
      .eq('status', 'active')

    activeContracts.value = count || 0
  } catch (error) {
    console.error('Error fetching active contracts:', error)
  }
}

// Charger les dernières missions
const fetchRecentMissions = async () => {
  try {
    const { data } = await supabase
      .from('missions')
      .select('*')
      .eq(profile.value?.role === 'expert' ? 'expert_id' : 'client_id', user.value.id)
      .order('created_at', { ascending: false })
      .limit(2)

    recentMissions.value = data || []
  } catch (error) {
    console.error('Error fetching recent missions:', error)
  }
}

// Helpers pour le statut des missions
const getMissionStatusClass = (status) => {
  const classes = {
    pending: 'bg-yellow-100 text-yellow-800 dark:bg-yellow-900/30 dark:text-yellow-400',
    active: 'bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-400',
    completed: 'bg-blue-100 text-blue-800 dark:bg-blue-900/30 dark:text-blue-400',
    cancelled: 'bg-red-100 text-red-800 dark:bg-red-900/30 dark:text-red-400'
  }
  return classes[status] || ''
}

const getMissionStatusLabel = (status) => {
  const labels = {
    pending: 'En attente',
    active: 'En cours',
    completed: 'Terminée',
    cancelled: 'Annulée'
  }
  return labels[status] || status
}
definePageMeta({
  middleware: 'auth',
  layout:'account'
})
</script>