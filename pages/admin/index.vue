<template>
  <div class="min-h-screen bg-white dark:bg-black">
    <!-- En-tête style Twitter 2022 -->
    <header class="sticky top-0 z-10 bg-white/90 dark:bg-black/90 backdrop-blur-md border-b border-gray-100 dark:border-gray-800">
      <div class="max-w-7xl mx-auto">
        <div class="px-4 sm:px-6 lg:px-8 py-3 flex items-center justify-between">
          <div>
            <h1 class="text-xl font-extrabold text-black dark:text-white">
              Tableau de bord
            </h1>
          </div>
          
          <div class="flex items-center gap-3">
            <UButton
              icon="i-heroicons-arrow-path"
              color="white"
              variant="ghost"
              class="rounded-full h-10 w-10 !p-0"
              :loading="isLoading"
              @click="loadDashboardData"
            />
            <UButton
              color="black"
              variant="solid"
              label="Nouvelle action"
              icon="i-heroicons-plus"
              class="rounded-full font-bold"
              :ui="{ rounded: 'rounded-full' }"
            />
          </div>
        </div>
      </div>
    </header>

    <main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
      <!-- Stats Cards style Twitter 2022 -->
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 mb-6">
        <div 
          v-for="stat in summaryStats" 
          :key="stat.name"
          class="bg-white dark:bg-gray-900 rounded-xl p-5 border border-gray-200 dark:border-gray-800 hover:border-blue-300 dark:hover:border-blue-700 transition-colors"
        >
          <div class="flex items-center justify-between mb-3">
            <span class="text-sm font-bold text-gray-800 dark:text-gray-200">
              {{ stat.name }}
            </span>
            <UIcon
              :name="stat.icon"
              class="h-5 w-5 text-blue-500"
            />
          </div>
          
          <div class="flex items-baseline">
            <span class="text-3xl font-extrabold text-black dark:text-white">
              {{ stat.value }}
            </span>
            <span class="ml-2 text-sm font-medium text-gray-500 dark:text-gray-400">
              {{ stat.label }}
            </span>
          </div>
          
          <div class="mt-3 flex flex-wrap gap-2">
            <span
              v-for="subStat in stat.subStats"
              :key="subStat"
              class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gray-100 dark:bg-gray-800 text-gray-800 dark:text-gray-200"
            >
              {{ subStat }}
            </span>
          </div>
        </div>
      </div>

      <!-- Sections principales style Twitter 2022 -->
      <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <!-- Dernières missions -->
        <div class="bg-white dark:bg-gray-900 rounded-xl border border-gray-200 dark:border-gray-800 overflow-hidden">
          <div class="px-5 py-4 border-b border-gray-100 dark:border-gray-800 flex items-center justify-between">
            <h2 class="text-lg font-bold text-black dark:text-white">
              Dernières missions
            </h2>
            <UButton
              color="gray"
              variant="ghost"
              icon="i-heroicons-ellipsis-horizontal"
              class="rounded-full h-8 w-8 !p-0"
            />
          </div>

          <div>
            <div 
              v-for="mission in latestRequests" 
              :key="mission.id"
              class="px-5 py-3 border-b border-gray-100 dark:border-gray-800 last:border-0 hover:bg-gray-50 dark:hover:bg-gray-800/50 transition-colors"
            >
              <div class="flex items-center justify-between">
                <div class="min-w-0">
                  <p class="text-sm font-bold text-black dark:text-white truncate">
                    {{ mission.service }}
                  </p>
                  <p class="text-sm text-gray-500 dark:text-gray-400 mt-0.5">
                    {{ mission.client.name }} • {{ mission.date }}
                  </p>
                </div>
                <UBadge
                  :label="getStatusLabel(mission.status)"
                  :color="getStatusColor(mission.status)"
                  class="ml-4"
                  variant="subtle"
                  :ui="{ rounded: 'rounded-full' }"
                />
              </div>
            </div>
          </div>
        </div>

        <!-- Activités récentes -->
        <div class="bg-white dark:bg-gray-900 rounded-xl border border-gray-200 dark:border-gray-800 overflow-hidden">
          <div class="px-5 py-4 border-b border-gray-100 dark:border-gray-800 flex items-center justify-between">
            <h2 class="text-lg font-bold text-black dark:text-white">
              Activités récentes
            </h2>
            <UButton
              color="gray"
              variant="ghost"
              icon="i-heroicons-ellipsis-horizontal"
              class="rounded-full h-8 w-8 !p-0"
            />
          </div>

          <div>
            <div 
              v-for="activity in recentActivities" 
              :key="activity.id"
              class="px-5 py-3 border-b border-gray-100 dark:border-gray-800 last:border-0 hover:bg-gray-50 dark:hover:bg-gray-800/50 transition-colors"
            >
              <div class="flex items-start gap-3">
                <div 
                  class="flex-shrink-0 w-8 h-8 rounded-full flex items-center justify-center"
                  :class="getActivityColorClass(activity.type)"
                >
                  <UIcon
                    :name="getActivityIcon(activity.type)"
                    class="h-4 w-4 text-white"
                  />
                </div>
                
                <div class="flex-1 min-w-0">
                  <p class="text-sm font-bold text-black dark:text-white">
                    {{ activity.title }}
                  </p>
                  <p class="text-sm text-gray-500 dark:text-gray-400 mt-0.5">
                    {{ activity.time }}
                    <span v-if="activity.user" class="font-medium">
                      • {{ activity.user.name }}
                    </span>
                  </p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Section Derniers utilisateurs style Twitter 2022 -->
      <div class="mt-6">
        <div class="flex items-center justify-between mb-4">
          <h2 class="text-lg font-bold text-black dark:text-white">
            Derniers utilisateurs
          </h2>
          <UButton
            color="gray"
            variant="ghost"
            label="Voir tous"
            icon="i-heroicons-arrow-right"
            to="/admin/users"
            class="rounded-full text-sm"
          />
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          <div 
            v-for="user in latestUsers" 
            :key="user.id"
            class="bg-white dark:bg-gray-900 rounded-xl p-4 border border-gray-200 dark:border-gray-800 hover:border-blue-300 dark:hover:border-blue-700 transition-colors group"
          >
            <div class="flex items-start gap-3">
              <!-- Avatar avec badge de rôle -->
              <div class="relative">
                <div 
                  v-if="user.avatar_url"
                  class="w-10 h-10 rounded-full bg-cover bg-center"
                  :style="{ backgroundImage: `url(${user.avatar_url})` }"
                ></div>
                <div 
                  v-else
                  class="w-10 h-10 rounded-full bg-gray-200 dark:bg-gray-700 flex items-center justify-center"
                >
                  <span class="text-sm font-medium text-gray-600 dark:text-gray-300">
                    {{ getInitials(user.first_name, user.last_name) }}
                  </span>
                </div>
                <div 
                  class="absolute -bottom-1 -right-1 rounded-full px-1.5 py-0.5 text-xs font-medium"
                  :class="getRoleClass(user.role)"
                >
                  {{ getRoleLabel(user.role) }}
                </div>
              </div>

              <!-- Informations utilisateur -->
              <div class="flex-1 min-w-0">
                <div class="flex items-center justify-between">
                  <p class="text-sm font-bold text-black dark:text-white truncate">
                    {{ user.first_name }} {{ user.last_name }}
                  </p>
                  <UButton
                    color="gray"
                    variant="ghost"
                    icon="i-heroicons-chevron-right"
                    :to="`/admin/users/${user.id}`"
                    class="opacity-0 group-hover:opacity-100 transition-opacity -mr-2 h-7 w-7 !p-0 rounded-full"
                  />
                </div>
                <p class="text-xs text-gray-500 dark:text-gray-400 truncate">
                  {{ user.email }}
                </p>
                <div class="mt-1.5 flex items-center gap-2">
                  <span class="text-xs text-gray-500 dark:text-gray-400">
                    {{ formatDate(user.created_at) }}
                  </span>
                  <div 
                    v-if="user.is_verified"
                    class="flex items-center text-xs text-blue-500 dark:text-blue-400"
                  >
                    <UIcon name="i-heroicons-check-badge" class="h-3 w-3 mr-0.5" />
                    Vérifié
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </main>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { format, parseISO } from 'date-fns'
import { fr } from 'date-fns/locale'
import { useSupabaseClient } from '#imports'
import { 
  User, 
  TrendingUp as TrendingUpIcon, 
  TrendingDown as TrendingDownIcon, 
  Minus as MinusIcon, 
  UserPlus as UserPlusIcon,
  CreditCard as CreditCardIcon,
  CheckSquare as CheckSquareIcon,
  Briefcase as BriefcaseIcon,
  AlertCircle as AlertCircleIcon,
  MessageSquare as MessageSquareIcon,
  Eye as EyeIcon,
  ShieldCheck as ShieldCheckIcon,
  Heart as HeartIcon,
  Plus as PlusIcon,
  ChevronRight as ChevronRightIcon,
  RefreshCw as RefreshIcon,
  MoreHorizontal as MoreHorizontalIcon,
  Settings as SettingsIcon,
  LogIn as LogInIcon,
  Activity
} from 'lucide-vue-next'

const supabase = useSupabaseClient()

// États
const isLoading = ref(true)
const summaryStats = ref([
  { 
    name: 'Utilisateurs', 
    value: 0, 
    label: 'inscrits',
    icon: 'ri-user3-fill',
    subStats: ['0 experts', '0 clients']
  },
  { 
    name: 'Missions', 
    value: 0, 
    label: 'au total',
    icon: 'ri-file-text-fill',
    subStats: ['0 en cours', '0 terminées']
  },
  { 
    name: 'Propositions', 
    value: 0, 
    label: 'au total',
    icon: 'ri-handshake-fill',
    subStats: ['0 actives', '0 en attente']
  },
  { 
    name: 'Catalogue', 
    value: 0, 
    label: 'professions',
    icon: 'ri-stack-fill',
    subStats: ['0 compétences']
  }
])
const recentActivities = ref([])
const latestRequests = ref([])
const latestUsers = ref([])

// Chargement des données depuis Supabase
const loadDashboardData = async () => {
  try {
    isLoading.value = true
    
    // 1. Chargement des statistiques
    const statsPromise = fetchSummaryStats()
    
    // 2. Chargement des activités récentes
    const activitiesPromise = fetchRecentActivities()
    
    // 3. Chargement des dernières demandes
    const missionsPromise = fetchLatestRequests()
    
    // 4. Chargement des derniers utilisateurs
    const usersPromise = fetchLatestUsers()
    
    // Attendre toutes les promesses
    await Promise.all([statsPromise, activitiesPromise, missionsPromise, usersPromise])
    
  } catch (error) {
    console.error('Erreur lors du chargement des données du dashboard:', error)
  } finally {
    isLoading.value = false
  }
}

// Fonction pour récupérer les statistiques de résumé depuis Supabase
const fetchSummaryStats = async () => {
  try {
    const [
      usersStats,
      missionsStats,
      dealsStats,
      catalogStats
    ] = await Promise.all([
      fetchUsersStats(),
      fetchMissionsStats(),
      fetchDealsStats(),
      fetchCatalogStats()
    ])

    // Mise à jour des statistiques
    summaryStats.value = [
      {
        name: 'Utilisateurs',
        value: usersStats.total,
        label: 'inscrits',
        icon: 'ri-user3-fill',
        subStats: [`${usersStats.experts} experts`, `${usersStats.clients} clients`]
      },
      {
        name: 'Missions',
        value: missionsStats.total,
        label: 'au total',
        icon: 'ri-file-text-fill',
        subStats: [`${missionsStats.active} en cours`, `${missionsStats.completed} terminées`]
      },
      {
        name: 'Propositions',
        value: dealsStats.total,
        label: 'au total',
        icon: 'gi-handshake',
        subStats: [`${dealsStats.active} actives`, `${dealsStats.pending} en attente`]
      },
      {
        name: 'Catalogue',
        value: catalogStats.professions,
        label: 'professions',
        icon: 'ri-stack-fill',
        subStats: [`${catalogStats.skills} compétences`]
      }
    ]
  } catch (error) {
    console.error('Erreur lors de la récupération des statistiques:', error)
  }
}

// Fonction pour récupérer les activités récentes depuis Supabase
const fetchRecentActivities = async () => {
  try {
    const { data, error } = await supabase
      .from('activities')
      .select(`*
      `)
      .order('created_at', { ascending: false })
      .limit(5)
    
    if (error) throw error
    
    recentActivities.value = data.map(activity => ({
      title: activity.title,
      description: activity.description,
      type: activity.type,
      time: formatTimeAgo(activity.created_at),
      user: activity.profiles ? {
        name: `${activity.profiles.first_name} ${activity.profiles.last_name}`,
        avatar: activity.profiles.avatar_url
      } : null
    }))
    
  } catch (error) {
    console.error('Erreur lors de la récupération des activités récentes:', error)
  }
}

// Fonction pour récupérer les dernières demandes depuis Supabase
const fetchLatestRequests = async () => {
  try {
    const { data, error } = await supabase
      .from('missions')
      .select(`*
      `)
      .order('created_at', { ascending: false })
      .limit(5)
    
    if (error) throw error
    
    latestRequests.value = data.map(mission => ({
      id: mission.id,
      service: mission.title || 'Service inconnu',
      date: formatDate(mission.created_at),
      status: mission.status,
      client: {
        name: mission.profiles ? `${mission.profiles.first_name} ${mission.profiles.last_name}` : 'Utilisateur inconnu',
        avatar: mission.profiles?.avatar_url
      }
    }))
    
  } catch (error) {
    console.error('Erreur lors de la récupération des dernières demandes:', error)
  }
}

// Fonction pour charger les derniers utilisateurs
const fetchLatestUsers = async () => {
  try {
    const { data, error } = await supabase
      .from('profiles')
      .select('*')
      .order('created_at', { ascending: false })
      .limit(6)

    if (error) throw error
    latestUsers.value = data

  } catch (error) {
    console.error('Erreur lors du chargement des utilisateurs:', error)
  }
}

// Fonctions de récupération des statistiques
const fetchUsersStats = async () => {
  const { data: totalUsers } = await supabase
    .from('profiles')
    .select('role', { count: 'exact' })

  const { data: experts } = await supabase
    .from('profiles')
    .select('id', { count: 'exact' })
    .eq('role', 'expert')

  const { data: clients } = await supabase
    .from('profiles')
    .select('id', { count: 'exact' })
    .eq('role', 'client')

  return {
    total: totalUsers?.length || 0,
    experts: experts?.length || 0,
    clients: clients?.length || 0
  }
}

const fetchMissionsStats = async () => {
  const { data: totalMissions } = await supabase
    .from('missions')
    .select('status', { count: 'exact' })

  const { data: activeMissions } = await supabase
    .from('missions')
    .select('id', { count: 'exact' })
    .eq('status', 'open')

  const { data: completedMissions } = await supabase
    .from('missions')
    .select('id', { count: 'exact' })
    .eq('status', 'completed')

  return {
    total: totalMissions?.length || 0,
    active: activeMissions?.length || 0,
    completed: completedMissions?.length || 0
  }
}

const fetchDealsStats = async () => {
  const { data: totalDeals } = await supabase
    .from('deals')
    .select('status', { count: 'exact' })

  const { data: activeDeals } = await supabase
    .from('deals')
    .select('id', { count: 'exact' })
    .eq('status', 'active')

  const { data: pendingDeals } = await supabase
    .from('deals')
    .select('id', { count: 'exact' })
    .eq('status', 'proposal')

  return {
    total: totalDeals?.length || 0,
    active: activeDeals?.length || 0,
    pending: pendingDeals?.length || 0
  }
}

const fetchCatalogStats = async () => {
  const { data: professions } = await supabase
    .from('professions')
    .select('id', { count: 'exact' })

  const { data: skills } = await supabase
    .from('skills')
    .select('id', { count: 'exact' })

  return {
    professions: professions?.length || 0,
    skills: skills?.length || 0
  }
}

// Formater la date
const formatDate = (dateString) => {
  try {
    const date = parseISO(dateString)
    return format(date, 'dd MMM yyyy', { locale: fr })
  } catch (error) {
    return dateString
  }
}

// Formater le temps écoulé
const formatTimeAgo = (dateString) => {
  try {
    const date = parseISO(dateString)
    return format(date, 'dd MMM HH:mm', { locale: fr })
  } catch (error) {
    return dateString
  }
}

// Mise à jour des couleurs d'activité pour le style Twitter 2022
const getActivityColorClass = (type) => {
  switch (type) {
    case 'new_user': return 'bg-blue-500'
    case 'new_mission': return 'bg-green-500'
    case 'service_completed': return 'bg-purple-500'
    case 'payment': return 'bg-yellow-500'
    case 'service_created': return 'bg-pink-500'
    case 'user_verified': return 'bg-blue-400'
    case 'admin_action': return 'bg-gray-500'
    case 'settings_updated': return 'bg-orange-500'
    case 'login': return 'bg-blue-600'
    default: return 'bg-gray-400'
  }
}

// Récupérer l'icône pour un type d'activité
const getActivityIcon = (type) => {
  switch (type) {
    case 'new_user': return UserPlusIcon
    case 'new_mission': return MessageSquareIcon
    case 'service_completed': return CheckSquareIcon
    case 'payment': return CreditCardIcon
    case 'service_created': return BriefcaseIcon
    case 'user_verified': return ShieldCheckIcon
    case 'admin_action': return AlertCircleIcon
    case 'settings_updated': return SettingsIcon
    case 'login': return LogInIcon
    default: return AlertCircleIcon
  }
}

// Récupérer la classe CSS pour un statut de demande
const getStatusClass = (status) => {
  switch (status) {
    case 'pending': return 'bg-yellow-100 text-yellow-800'
    case 'in_progress': return 'bg-blue-100 text-blue-800'
    case 'completed': return 'bg-green-100 text-green-800'
    case 'cancelled': return 'bg-red-100 text-red-800'
    default: return 'bg-gray-100 text-gray-800'
  }
}

// Récupérer le libellé pour un statut de demande
const getStatusLabel = (status) => {
  switch (status) {
    case 'pending': return 'En attente'
    case 'in_progress': return 'En cours'
    case 'completed': return 'Terminé'
    case 'cancelled': return 'Annulé'
    default: return status
  }
}

// Nouvelles fonctions helper pour les statuts
const getStatusColor = (status) => {
  switch (status) {
    case 'pending': return 'yellow'
    case 'in_progress': return 'blue'
    case 'completed': return 'green'
    case 'cancelled': return 'red'
    default: return 'gray'
  }
}

// Helpers pour les utilisateurs
const getInitials = (firstName = '', lastName = '') => {
  return `${firstName.charAt(0)}${lastName.charAt(0)}`.toUpperCase()
}

const getRoleClass = (role) => {
  const classes = {
    expert: 'bg-purple-100 text-purple-800 dark:bg-purple-900/30 dark:text-purple-300',
    client: 'bg-blue-100 text-blue-800 dark:bg-blue-900/30 dark:text-blue-300',
    admin: 'bg-red-100 text-red-800 dark:bg-red-900/30 dark:text-red-300'
  }
  return classes[role] || 'bg-gray-100 text-gray-800 dark:bg-gray-900/30 dark:text-gray-300'
}

const getRoleLabel = (role) => {
  const labels = {
    expert: 'Expert',
    client: 'Client',
    admin: 'Admin'
  }
  return labels[role] || role
}

// Initialisation
onMounted(() => {
  loadDashboardData()
})

// Configuration de la page
definePageMeta({
  layout: 'admin'
})
</script>