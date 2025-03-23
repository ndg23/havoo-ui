<template>
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
    <!-- Header with minimalist design -->
    <div class="flex justify-between items-center mb-10">
      <div>
        <h1 class="text-2xl font-bold text-gray-900">Tableau de bord</h1>
        <p class="text-gray-600 mt-1">Vue d'ensemble de la plateforme Havoo</p>
      </div>
      <div class="flex items-center gap-3">
        <button class="px-4 py-2.5 bg-white hover:bg-gray-50 text-gray-700 border border-gray-300 font-medium rounded-full transition-colors flex items-center gap-2 shadow-sm">
          <RefreshIcon class="h-4 w-4" />
          <span>Actualiser</span>
        </button>
        
        <button class="px-5 py-2.5 bg-black hover:bg-gray-800 text-white font-medium rounded-full transition-colors flex items-center gap-2 shadow-sm">
          <PlusIcon class="h-4 w-4" />
          <span>Nouvelle action</span>
        </button>
      </div>
    </div>
    
    <!-- Key metrics in impactful cards -->
    <div class="grid grid-cols-2 lg:grid-cols-4 gap-6 mb-10">
      <div 
        v-for="stat in summaryStats" 
        :key="stat.name"
        class="bg-white rounded-2xl p-6 hover:shadow-md transition-all border border-gray-100"
      >
        <div class="flex justify-between items-start">
          <div>
            <p class="text-sm font-medium text-gray-500 mb-1">{{ stat.name }}</p>
            <h3 class="text-3xl font-bold text-gray-900">{{ stat.value }}</h3>
            
            <div class="flex items-center mt-4 text-sm">
              <div v-if="stat.trend > 0" class="flex items-center text-green-600">
                <TrendingUpIcon class="h-4 w-4 mr-1" />
                <span>+{{ stat.trend }}%</span>
              </div>
              <div v-else-if="stat.trend < 0" class="flex items-center text-red-600">
                <TrendingDownIcon class="h-4 w-4 mr-1" />
                <span>{{ stat.trend }}%</span>
              </div>
              <div v-else class="flex items-center text-gray-500">
                <MinusIcon class="h-4 w-4 mr-1" />
                <span>0%</span>
              </div>
              <span class="text-xs text-gray-500 ml-1">ce mois</span>
            </div>
          </div>
          
          <div class="h-12 w-12 rounded-full bg-gray-100 flex items-center justify-center">
            <component :is="stat.icon" class="h-6 w-6 text-gray-700" />
          </div>
        </div>
      </div>
    </div>
    
    <!-- Performance indicators -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-10">
      <div class="bg-white rounded-2xl p-6 border border-gray-100">
        <div class="flex justify-between items-start mb-3">
          <div>
            <h3 class="text-lg font-semibold text-gray-900">Taux de conversion</h3>
          </div>
          <div class="h-10 w-10 rounded-full bg-blue-100 flex items-center justify-center">
            <TrendingUpIcon class="h-5 w-5 text-blue-600" />
          </div>
        </div>
        
        <div class="flex items-end space-x-2">
          <span class="text-3xl font-bold">{{ conversionRate }}%</span>
        </div>
      </div>
      
      <div class="bg-white rounded-2xl p-6 border border-gray-100">
        <div class="flex justify-between items-start mb-3">
          <div>
            <h3 class="text-lg font-semibold text-gray-900">Taux d'engagement</h3>
          </div>
          <div class="h-10 w-10 rounded-full bg-purple-100 flex items-center justify-center">
            <HeartIcon class="h-5 w-5 text-purple-600" />
          </div>
        </div>
        
        <div class="flex items-end space-x-2">
          <span class="text-3xl font-bold">{{ engagementRate }}%</span>
        </div>
      </div>
      
      <div class="bg-white rounded-2xl p-6 border border-gray-100">
        <div class="flex justify-between items-start mb-3">
          <div>
            <h3 class="text-lg font-semibold text-gray-900">Taux de complétion</h3>
          </div>
          <div class="h-10 w-10 rounded-full bg-green-100 flex items-center justify-center">
            <CheckSquareIcon class="h-5 w-5 text-green-600" />
          </div>
        </div>
        
        <div class="flex items-end space-x-2">
          <span class="text-3xl font-bold">{{ completionRate }}%</span>
        </div>
      </div>
    </div>
    
    <!-- New Grid layout for most recent info and status -->
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 mb-10">
      <!-- Latest requests in first two columns -->
      <div class="bg-white rounded-2xl border border-gray-100 overflow-hidden lg:col-span-3">
        <div class="px-6 py-4 border-b border-gray-100">
          <div class="flex justify-between items-center">
            <h2 class="font-semibold text-lg text-gray-900">Dernières demandes</h2>
            <NuxtLink 
              to="/admin/requests" 
              class="text-black hover:text-gray-700 text-sm font-medium flex items-center gap-1"
            >
              Voir tout
              <ChevronRightIcon class="h-4 w-4" />
            </NuxtLink>
          </div>
        </div>
        
        <div>
          <div 
            v-for="request in latestRequests" 
            :key="request.id"
            class="border-b border-gray-100 last:border-b-0 hover:bg-gray-50 transition-colors"
          >
            <div class="p-6">
              <div class="flex items-start gap-4">
                <div class="h-12 w-12 rounded-full overflow-hidden bg-gray-100">
                  <img 
                    v-if="request.client.avatar" 
                    :src="request.client.avatar" 
                    alt="Client avatar" 
                    class="h-full w-full object-cover"
                  />
                  <User v-else class="h-full w-full p-2 text-gray-400" />
                </div>
                
                <div class="flex-1 min-w-0">
                  <div class="flex items-center justify-between mb-2">
                    <div>
                      <div class="flex items-center mb-1">
                        <p class="font-medium text-gray-900">{{ request.client.name }}</p>
                        <span class="mx-2 text-gray-300">•</span>
                        <span class="text-sm text-gray-500">{{ request.date }}</span>
                      </div>
                      <p class="text-gray-900 font-medium">{{ request.service }}</p>
                    </div>
                    
                    <span 
                      class="text-xs font-medium px-3 py-1 rounded-full"
                      :class="getStatusClass(request.status)"
                    >
                      {{ getStatusLabel(request.status) }}
                    </span>
                  </div>
                  
                  <div class="flex items-center mt-3 gap-3">
                    <NuxtLink 
                      :to="`/admin/requests/${request.id}`" 
                      class="flex items-center text-gray-700 hover:text-black transition-colors"
                    >
                      <EyeIcon class="h-4 w-4 mr-1.5" />
                      <span class="text-sm">Détails</span>
                    </NuxtLink>
                    
                    <button class="flex items-center text-gray-700 hover:text-black transition-colors">
                      <MessageSquareIcon class="h-4 w-4 mr-1.5" />
                      <span class="text-sm">Message</span>
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    
    <!-- Recent activities -->
    <div class="bg-white rounded-2xl border border-gray-100 overflow-hidden">
      <div class="px-6 py-4 border-b border-gray-100">
        <div class="flex justify-between items-center">
          <h2 class="font-semibold text-lg text-gray-900">Activités récentes</h2>
          <NuxtLink 
            to="/admin/activities" 
            class="text-black hover:text-gray-700 text-sm font-medium flex items-center gap-1"
          >
            Voir tout
            <ChevronRightIcon class="h-4 w-4" />
          </NuxtLink>
        </div>
      </div>
      
      <div class="divide-y divide-gray-100">
        <div 
          v-for="(activity, index) in recentActivities" 
          :key="index"
          class="px-6 py-4 hover:bg-gray-50 transition-colors"
        >
          <div class="flex gap-4">
            <div 
              class="h-10 w-10 rounded-full flex items-center justify-center flex-shrink-0"
              :class="getActivityColorClass(activity.type)"
            >
              <component :is="getActivityIcon(activity.type)" class="h-5 w-5 text-white" />
            </div>
            
            <div class="flex-1 min-w-0">
              <p class="font-medium text-gray-900">
                {{ activity.title }}
              </p>
              <div class="flex items-center mt-1 text-sm text-gray-500">
                <span>{{ activity.time }}</span>
                <span v-if="activity.user" class="flex items-center mx-1.5">•</span>
                <span v-if="activity.user" class="font-medium text-gray-700">
                  {{ activity.user.name }}
                </span>
              </div>
            </div>
            
            <!-- Action dropdown, if needed -->
            <div v-if="activity.type !== 'admin_action'" class="flex items-center">
              <button class="p-1.5 rounded-full hover:bg-gray-200">
                <MoreHorizontalIcon class="h-4 w-4 text-gray-500" />
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
    
    <!-- Footer with app version and status -->
    <div class="mt-8 pt-6 border-t border-gray-200">
      <div class="flex flex-col sm:flex-row items-center justify-between text-sm text-gray-500">
        <div>
          <span>Havoo - Version 1.0.0</span>
        </div>
        <div class="mt-4 sm:mt-0">
          <span>© {{ new Date().getFullYear() }} Havoo</span>
        </div>
      </div>
    </div>
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
  LogIn as LogInIcon
} from 'lucide-vue-next'

const supabase = useSupabaseClient()

// États
const isLoading = ref(true)
const summaryStats = ref([])
const recentActivities = ref([])
const latestRequests = ref([])

// KPI
const conversionRate = ref(67)
const engagementRate = ref(78)
const completionRate = ref(45)

// Chargement des données depuis Supabase
const loadDashboardData = async () => {
  try {
    isLoading.value = true
    
    // 1. Chargement des statistiques
    const statsPromise = fetchSummaryStats()
    
    // 2. Chargement des activités récentes
    const activitiesPromise = fetchRecentActivities()
    
    // 3. Chargement des dernières demandes
    const requestsPromise = fetchLatestRequests()
    
    // Attendre toutes les promesses
    await Promise.all([statsPromise, activitiesPromise, requestsPromise])
    
  } catch (error) {
    console.error('Erreur lors du chargement des données du dashboard:', error)
  } finally {
    isLoading.value = false
  }
}

// Fonction pour récupérer les statistiques de résumé depuis Supabase
const fetchSummaryStats = async () => {
  try {
    // Pour les utilisateurs: Compter tous les profils
    const { count: usersCount, error: usersError } = await supabase
      .from('profiles')
      .select('*', { count: 'exact', head: true })
    
    if (usersError) throw usersError
    
    // Pour les services: Compter tous les services
    const { count: servicesCount, error: servicesError } = await supabase
      .from('services')
      .select('*', { count: 'exact', head: true })
    
    if (servicesError) throw servicesError
    
    // Pour les demandes: Compter toutes les demandes
    const { count: requestsCount, error: requestsError } = await supabase
      .from('requests')
      .select('*', { count: 'exact', head: true })
    
    if (requestsError) throw requestsError
    
    // Pour les experts vérifiés
    const { count: verifiedExpertsCount, error: verifiedError } = await supabase
      .from('profiles')
      .select('*', { count: 'exact', head: true })
      .eq('is_expert', true)
    
    if (verifiedError) throw verifiedError
    
    // Statistiques avec tendances
    summaryStats.value = [
      { name: 'Utilisateurs', value: usersCount, trend: 12, icon: UserPlusIcon },
      { name: 'Experts', value: verifiedExpertsCount, trend: 8, icon: ShieldCheckIcon },
      { name: 'Services', value: servicesCount, trend: 15, icon: BriefcaseIcon },
      { name: 'Demandes', value: requestsCount, trend: 5, icon: MessageSquareIcon }
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
      .select(`
        id,
        created_at,
        type,
        title,
        description,
        user_id,
        profiles:user_id(first_name, last_name, avatar_url)
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
      .from('requests')
      .select(`
        id,
        created_at,
        title,
        status,
        client_id,
        profiles:client_id(first_name, last_name, avatar_url),
      `)
      .order('created_at', { ascending: false })
      .limit(5)
    
    if (error) throw error
    
    latestRequests.value = data.map(request => ({
      id: request.id,
      service: request.title || 'Service inconnu',
      date: formatDate(request.created_at),
      status: request.status,
      client: {
        name: request.profiles ? `${request.profiles.first_name} ${request.profiles.last_name}` : 'Utilisateur inconnu',
        avatar: request.profiles?.avatar_url
      }
    }))
    
  } catch (error) {
    console.error('Erreur lors de la récupération des dernières demandes:', error)
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
    case 'new_request': return 'bg-blue-500'
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
    case 'new_request': return MessageSquareIcon
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