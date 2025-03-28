<template>
  <div class="min-h-screen bg-white">
    <!-- Twitter-inspired sticky header with lighter design -->
    <header class="sticky top-0 z-10 bg-white border-b border-gray-100 px-4 py-3 mb-5">
      <div class="max-w-7xl mx-auto flex items-center justify-between">
        <div>
          <h1 class="text-xl font-bold text-gray-900">Tableau de bord</h1>
          <p class="text-gray-600 text-sm">Vue d'ensemble de la plateforme Havoo</p>
        </div>
        <div class="flex items-center gap-3">
          <button 
            @click="loadDashboardData" 
            class="p-2.5 bg-white hover:bg-gray-50 text-gray-700 border border-gray-200 font-medium rounded-full transition-colors flex items-center gap-2"
          >
            <RefreshIcon class="h-4 w-4" />
            <span>Actualiser</span>
          </button>
          
          <button class="p-2.5 bg-primary-600 hover:bg-primary-700 text-white font-medium rounded-full transition-colors flex items-center gap-2">
            <PlusIcon class="h-4 w-4" />
            <span>Nouvelle action</span>
          </button>
        </div>
      </div>
    </header>

    <main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
      <!-- Enhanced loading state with Twitter spinner -->
      <div v-if="isLoading" class="flex flex-col items-center justify-center py-24">
        <div class="animate-spin h-10 w-10 mb-5 text-primary-500">
          <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="#E1E8ED" stroke-width="4"></circle>
            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
          </svg>
        </div>
        <p class="text-gray-500 font-medium">Chargement du tableau de bord...</p>
      </div>

      <div v-else class="space-y-8">
        <!-- Key metrics in Twitter-style cards -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
          <div v-for="stat in summaryStats" :key="stat.name" class="bg-white dark:bg-gray-800 rounded-xl p-6 shadow-sm">
            <div class="flex items-center justify-between">
              <h3 class="text-gray-500 dark:text-gray-400 text-sm font-medium">{{ stat.name }}</h3>
              <v-icon :name="stat.icon" class="h-5 w-5 text-blue-500" />
            </div>
            <div class="mt-2 flex items-baseline">
              <p class="text-2xl font-semibold">{{ stat.value }}</p>
              <p class="ml-2 text-sm text-gray-500 dark:text-gray-400">{{ stat.label }}</p>
            </div>
            <div v-if="stat.subStats" class="mt-1 flex items-center text-sm">
              <span v-for="(subStat, index) in stat.subStats" :key="index">
                <span class="text-gray-600 dark:text-gray-300">{{ subStat }}</span>
                <span v-if="index < stat.subStats.length - 1" class="mx-1.5 text-gray-500 dark:text-gray-400">•</span>
              </span>
            </div>
          </div>
        </div>
        
        <!-- Latest missions with Twitter timeline aesthetic -->
        <div class="bg-white dark:bg-gray-800 rounded-xl shadow-sm">
          <div class="p-6 border-b border-gray-100 dark:border-gray-700">
            <h3 class="font-semibold">Dernières missions</h3>
          </div>
          
          <div class="divide-y divide-gray-100 dark:divide-gray-700">
            <div v-if="latestRequests.length === 0" class="py-12 text-center">
              <div class="mx-auto h-16 w-16 text-gray-300 bg-gray-50 rounded-full flex items-center justify-center">
                <MessageSquareIcon class="h-8 w-8" />
              </div>
              <h3 class="mt-4 text-base font-medium text-gray-900">Aucune demande</h3>
              <p class="mt-1 text-sm text-gray-500">Les demandes récentes apparaîtront ici</p>
            </div>
            
            <div 
              v-else
              v-for="mission in latestRequests" 
              :key="mission.id"
              class="p-4"
            >
              <div class="flex items-center justify-between">
                <div class="flex items-center min-w-0">
                  <div class="flex-1 min-w-0">
                    <p class="font-medium text-gray-900 dark:text-gray-100">{{ mission.service }}</p>
                    <p class="text-sm text-gray-500">
                      {{ mission.client.name }} • {{ mission.date }}
                    </p>
                  </div>
                </div>
                <span :class="getStatusClass(mission.status)" class="ml-4 px-2.5 py-0.5 rounded-full text-xs font-medium">
                  {{ getStatusLabel(mission.status) }}
                </span>
              </div>
            </div>
          </div>
        </div>
        
        <!-- Recent activities with Twitter timeline style -->
        <div class="bg-white dark:bg-gray-800 rounded-xl shadow-sm mb-8">
          <div class="p-6 border-b border-gray-100 dark:border-gray-700">
            <h3 class="font-semibold">Activités récentes</h3>
          </div>
          
          <div v-if="!recentActivities.length" class="p-12 text-center">
            <div class="inline-flex h-12 w-12 items-center justify-center rounded-full bg-gray-100 dark:bg-gray-800">
              <v-icon name="ri-notification-4-line" class="h-6 w-6 text-gray-600 dark:text-gray-400" />
            </div>
            <h3 class="mt-4 text-base font-medium text-gray-900 dark:text-gray-100">Aucune activité</h3>
            <p class="mt-1 text-sm text-gray-500">Les activités récentes apparaîtront ici</p>
          </div>
          
          <div v-else class="divide-y divide-gray-100 dark:divide-gray-700">
            <div v-for="activity in recentActivities" :key="activity.id" class="p-4 hover:bg-gray-50 dark:hover:bg-gray-800">
              <div class="flex gap-4">
                <div class="h-10 w-10 rounded-full flex items-center justify-center" :class="getActivityColorClass(activity.type)">
                  <v-icon :name="getActivityIcon(activity.type)" class="h-5 w-5 text-white" />
                </div>
                <div class="flex-1 min-w-0">
                  <p class="font-medium text-gray-900 dark:text-gray-100">{{ activity.title }}</p>
                  <div class="flex items-center mt-1 text-sm text-gray-500">
                    <span>{{ activity.time }}</span>
                    <span v-if="activity.user" class="flex items-center mx-1.5">•</span>
                    <span v-if="activity.user" class="font-medium text-gray-700 dark:text-gray-300">
                      {{ activity.user.name }}
                    </span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        
        <!-- Twitter-style footer -->
        <div class="mt-6 pt-5 border-t border-gray-100">
          <div class="flex flex-col sm:flex-row items-center justify-between text-sm text-gray-500">
            <div>
              <span>Havoo - Version 1.0.0</span>
            </div>
            <div class="mt-3 sm:mt-0">
              <span>© {{ new Date().getFullYear() }} Havoo</span>
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
    
    // Attendre toutes les promesses
    await Promise.all([statsPromise, activitiesPromise, missionsPromise])
    
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

// Récupérer la classe de couleur pour un type d'activité
const getActivityColorClass = (type) => {
  switch (type) {
    case 'new_user': return 'bg-green-500'
    case 'new_mission': return 'bg-blue-500'
    case 'service_completed': return 'bg-purple-500'
    case 'payment': return 'bg-amber-500'
    case 'service_created': return 'bg-indigo-500'
    case 'user_verified': return 'bg-teal-500'
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

// Initialisation
onMounted(() => {
  loadDashboardData()
})

// Configuration de la page
definePageMeta({
  layout: 'admin'
})
</script>