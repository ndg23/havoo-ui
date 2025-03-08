<template>
  <div class="space-y-10 p-8 md:p-12 bg-gray-50 dark:bg-gray-900 min-h-screen">
    <!-- Header Section - More spacious, Apple-style typography -->
    <div class="flex flex-col md:flex-row justify-between items-start md:items-center gap-6 mb-8">
      <div>
        <h1 class="text-3xl font-medium text-gray-900 dark:text-white tracking-tight">Dashboard</h1>
        <p class="text-gray-500 dark:text-gray-400 mt-2 text-lg">Vue d'ensemble de votre plateforme</p>
      </div>
      
      <div class="flex items-center gap-4">
        <button class="bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-xl px-5 py-2.5 flex items-center gap-3 text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-750 transition-colors">
          <Download class="h-5 w-5" />
          <span>Exporter</span>
        </button>
        
        <button class="bg-primary-600 hover:bg-primary-700 text-white rounded-xl px-5 py-2.5 flex items-center gap-3 transition-colors">
          <PlusCircle class="h-5 w-5" />
          <span>Nouvelle action</span>
        </button>
      </div>
    </div>
    
    <!-- Cartes de statistiques - Apple-inspired clean design with more space -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
      <div 
        v-for="(stat, index) in stats" 
        :key="index"
        class="bg-white dark:bg-gray-800 shadow-sm rounded-3xl p-8 transition-transform duration-300 hover:-translate-y-1 border border-gray-100 dark:border-gray-700"
      >
        <div class="flex items-center justify-between">
          <span class="text-gray-500 dark:text-gray-400 text-base font-medium">{{ stat.name }}</span>
          <div :class="getIconBgClass(index)" class="h-14 w-14 rounded-2xl flex items-center justify-center shadow-md">
            <component :is="stat.icon" class="h-7 w-7 text-white" />
          </div>
        </div>
        
        <div class="mt-6">
          <div v-if="loading" class="animate-pulse h-10 bg-gray-200 dark:bg-gray-700 rounded w-24"></div>
          <div v-else class="text-4xl font-medium text-gray-900 dark:text-white">{{ stat.value }}</div>
        </div>
        
        <div class="flex items-center mt-4">
          <span 
            v-if="stat.change >= 0" 
            class="flex items-center text-green-600 dark:text-green-500 font-medium"
          >
            <TrendingUp class="h-4 w-4 mr-1" />
            +{{ stat.change }}%
          </span>
          <span 
            v-else 
            class="flex items-center text-red-600 dark:text-red-500 font-medium"
          >
            <TrendingDown class="h-4 w-4 mr-1" />
            {{ stat.change }}%
          </span>
          <span class="text-sm text-gray-500 dark:text-gray-400 ml-2">vs. dernier mois</span>
        </div>
      </div>
    </div>
    
    <!-- Graphique des statistiques - More minimal, Apple-style chart -->
    <div class="bg-white dark:bg-gray-800 shadow-sm rounded-3xl overflow-hidden border border-gray-100 dark:border-gray-700">
      <div class="px-8 py-6 border-b border-gray-100 dark:border-gray-700 flex justify-between items-center">
        <h2 class="font-medium text-xl text-gray-900 dark:text-white">Aperçu des activités</h2>
        
        <div class="flex items-center gap-4">
          <div class="flex items-center bg-gray-100 dark:bg-gray-700 rounded-xl p-1.5">
            <button 
              v-for="(period, idx) in ['Jour', 'Semaine', 'Mois', 'Année']" 
              :key="idx"
              class="px-4 py-1.5 text-sm rounded-lg transition-colors"
              :class="selectedPeriod === idx ? 'bg-white dark:bg-gray-600 text-primary-600 dark:text-primary-400 shadow-sm' : 'text-gray-500 dark:text-gray-400'"
              @click="selectedPeriod = idx"
            >
              {{ period }}
            </button>
          </div>
          
          <button class="p-2 text-gray-400 hover:text-gray-500 dark:text-gray-500 dark:hover:text-gray-400 rounded-full hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors">
            <MoreHorizontal class="h-5 w-5" />
          </button>
        </div>
      </div>
      
      <div class="p-8">
        <div v-if="loading" class="animate-pulse">
          <div class="h-72 bg-gray-200 dark:bg-gray-700 rounded-xl"></div>
        </div>
        <div v-else class="h-72 w-full relative">
          <!-- SVG du graphique inspiré par le style Apple -->
          <svg width="100%" height="100%" viewBox="0 0 800 300">
            <!-- Lignes de grille plus subtiles -->
            <line x1="0" y1="250" x2="800" y2="250" stroke="#E5E7EB" stroke-width="1" stroke-opacity="0.5" />
            <line x1="0" y1="200" x2="800" y2="200" stroke="#E5E7EB" stroke-width="1" stroke-opacity="0.5" />
            <line x1="0" y1="150" x2="800" y2="150" stroke="#E5E7EB" stroke-width="1" stroke-opacity="0.5" />
            <line x1="0" y1="100" x2="800" y2="100" stroke="#E5E7EB" stroke-width="1" stroke-opacity="0.5" />
            <line x1="0" y1="50" x2="800" y2="50" stroke="#E5E7EB" stroke-width="1" stroke-opacity="0.5" />
            
            <!-- Courbe principale - style Apple, plus fine et élégante -->
            <path d="M0,200 C100,180 200,100 300,120 C400,140 500,80 600,60 C700,40 800,100 800,100" 
                  fill="none" 
                  stroke="#4F46E5" 
                  stroke-width="2.5" 
                  stroke-linecap="round" />
                  
            <!-- Aire sous la courbe - plus subtile -->
            <path d="M0,200 C100,180 200,100 300,120 C400,140 500,80 600,60 C700,40 800,100 800,100 L800,250 L0,250 Z" 
                  fill="url(#gradient1)" 
                  opacity="0.1" />
                  
            <!-- Points sur la courbe - style Apple -->
            <circle cx="300" cy="120" r="5" fill="#4F46E5" />
            <circle cx="300" cy="120" r="8" fill="#4F46E5" fill-opacity="0.2" />
            <circle cx="600" cy="60" r="5" fill="#4F46E5" />
            <circle cx="600" cy="60" r="8" fill="#4F46E5" fill-opacity="0.2" />
            
            <!-- Définitions des dégradés -->
            <defs>
              <linearGradient id="gradient1" x1="0%" y1="0%" x2="0%" y2="100%">
                <stop offset="0%" stop-color="#4F46E5" stop-opacity="0.7" />
                <stop offset="100%" stop-color="#4F46E5" stop-opacity="0.05" />
              </linearGradient>
            </defs>
          </svg>
          
          <!-- Légende du graphique - Apple-style spacing -->
          <div class="flex justify-between mt-6">
            <div v-for="month in ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Juin']" :key="month" class="text-sm text-gray-500 dark:text-gray-400">
              {{ month }}
            </div>
          </div>
        </div>
      </div>
    </div>
    
    <!-- Tableaux et listes - Apple-style spacing and design -->
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
      <!-- Demandes récentes -->
      <div class="lg:col-span-2 bg-white dark:bg-gray-800 shadow-sm rounded-3xl overflow-hidden border border-gray-100 dark:border-gray-700">
        <div class="px-8 py-6 border-b border-gray-100 dark:border-gray-700 flex justify-between items-center">
          <h2 class="font-medium text-xl text-gray-900 dark:text-white flex items-center">
            <FileText class="h-6 w-6 mr-3 text-primary-600 dark:text-primary-400" />
            Demandes récentes
          </h2>
          
          <NuxtLink 
            to="/admin/requests" 
            class="text-sm text-primary-600 hover:text-primary-700 dark:text-primary-400 dark:hover:text-primary-300 font-medium flex items-center"
          >
            Voir tout
            <ChevronRight class="h-4 w-4 ml-1" />
          </NuxtLink>
        </div>
        
        <div class="p-8">
          <div v-if="loading" class="space-y-6">
            <div v-for="i in 5" :key="i" class="animate-pulse flex items-center">
              <div class="h-14 w-14 bg-gray-200 dark:bg-gray-700 rounded-xl"></div>
              <div class="h-14 flex-1 ml-6 bg-gray-200 dark:bg-gray-700 rounded-xl"></div>
            </div>
          </div>
          
          <div v-else-if="recentRequests.length" class="divide-y divide-gray-100 dark:divide-gray-700">
            <div 
              v-for="request in recentRequests" 
              :key="request.id"
              class="py-5 flex items-center justify-between hover:bg-gray-50 dark:hover:bg-gray-750 -mx-8 px-8 transition-colors"
            >
              <div class="flex items-center">
                <div class="h-14 w-14 rounded-xl flex items-center justify-center"
                     :class="getRequestIconBg(request.status)">
                  <component :is="getRequestIcon(request.status)" class="h-7 w-7 text-white" />
                </div>
                
                <div class="ml-6">
                  <div class="font-medium text-gray-900 dark:text-white">{{ truncateText(request.title, 40) }}</div>
                  <div class="text-sm text-gray-500 dark:text-gray-400 flex items-center mt-1.5">
                    <Clock class="h-4 w-4 mr-1.5" />
                    {{ formatDate(request.created_at) }}
                  </div>
                </div>
              </div>
              
              <div class="flex items-center">
                <span 
                  class="px-4 py-1.5 text-xs font-medium rounded-full"
                  :class="getStatusClass(request.status)"
                >
                  {{ getStatusText(request.status) }}
                </span>
                
                <div class="flex ml-6">
                  <NuxtLink 
                    :to="`/admin/requests/${request.id}`"
                    class="p-2 text-gray-400 hover:text-gray-700 dark:text-gray-500 dark:hover:text-gray-300 rounded-full hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors"
                  >
                    <ExternalLink class="h-4 w-4" />
                  </NuxtLink>
                  
                  <button class="p-2 text-gray-400 hover:text-gray-700 dark:text-gray-500 dark:hover:text-gray-300 rounded-full hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors">
                    <MoreVertical class="h-4 w-4" />
                  </button>
                </div>
              </div>
            </div>
          </div>
          
          <div v-else class="py-12 text-center">
            <div class="bg-gray-100 dark:bg-gray-700 h-24 w-24 rounded-full flex items-center justify-center mx-auto mb-6">
              <FileX class="h-12 w-12 text-gray-400 dark:text-gray-500" />
            </div>
            <p class="text-gray-500 dark:text-gray-400 font-medium text-lg">Aucune demande récente</p>
            <p class="text-sm text-gray-400 dark:text-gray-500 mt-2">Les nouvelles demandes apparaîtront ici</p>
          </div>
        </div>
      </div>
      
      <!-- Utilisateurs récemment inscrits -->
      <div class="bg-white dark:bg-gray-800 shadow-sm rounded-3xl overflow-hidden border border-gray-100 dark:border-gray-700">
        <div class="px-8 py-6 border-b border-gray-100 dark:border-gray-700 flex justify-between items-center">
          <h2 class="font-medium text-xl text-gray-900 dark:text-white flex items-center">
            <Users class="h-6 w-6 mr-3 text-primary-600 dark:text-primary-400" />
            Nouveaux utilisateurs
          </h2>
          
          <NuxtLink 
            to="/admin/users" 
            class="text-sm text-primary-600 hover:text-primary-700 dark:text-primary-400 dark:hover:text-primary-300 font-medium flex items-center"
          >
            Voir tout
            <ChevronRight class="h-4 w-4 ml-1" />
          </NuxtLink>
        </div>
        
        <div class="p-8">
          <div v-if="loading" class="space-y-6">
            <div v-for="i in 5" :key="i" class="animate-pulse flex items-center">
              <div class="h-14 w-14 bg-gray-200 dark:bg-gray-700 rounded-full"></div>
              <div class="h-14 flex-1 ml-6 bg-gray-200 dark:bg-gray-700 rounded-xl"></div>
            </div>
          </div>
          
          <div v-else-if="recentUsers.length" class="divide-y divide-gray-100 dark:divide-gray-700">
            <div 
              v-for="user in recentUsers" 
              :key="user.id"
              class="py-5 flex items-center hover:bg-gray-50 dark:hover:bg-gray-750 -mx-8 px-8 transition-colors"
            >
              <div class="h-14 w-14 rounded-full bg-gradient-to-br from-blue-400 to-primary-600 mr-6 flex-shrink-0 p-0.5">
                <div class="h-full w-full bg-white dark:bg-gray-800 rounded-full p-0.5">
                  <img 
                    v-if="user.profile_image_url"
                    :src="user.profile_image_url"
                    class="h-full w-full object-cover rounded-full"
                    alt="Avatar"
                  />
                  <div v-else class="h-full w-full flex items-center justify-center bg-gray-100 dark:bg-gray-700 rounded-full">
                    <User class="h-6 w-6 text-gray-400 dark:text-gray-500" />
                  </div>
                </div>
              </div>
              
              <div class="flex-1 min-w-0">
                <div class="font-medium text-gray-900 dark:text-white truncate text-base">
                  {{ user.first_name }} {{ user.last_name }}
                </div>
                <div class="text-sm text-gray-500 dark:text-gray-400 truncate mt-1">
                  {{ user.email }}
                </div>
              </div>
              
              <div class="flex">
                <NuxtLink 
                  :to="`/admin/users/${user.id}`"
                  class="p-2 text-gray-400 hover:text-gray-700 dark:text-gray-500 dark:hover:text-gray-300 rounded-full hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors"
                >
                  <ExternalLink class="h-4 w-4" />
                </NuxtLink>
                
                <button class="p-2 text-gray-400 hover:text-gray-700 dark:text-gray-500 dark:hover:text-gray-300 rounded-full hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors">
                  <MoreVertical class="h-4 w-4" />
                </button>
              </div>
            </div>
          </div>
          
          <div v-else class="py-12 text-center">
            <div class="bg-gray-100 dark:bg-gray-700 h-24 w-24 rounded-full flex items-center justify-center mx-auto mb-6">
              <UserX class="h-12 w-12 text-gray-400 dark:text-gray-500" />
            </div>
            <p class="text-gray-500 dark:text-gray-400 font-medium text-lg">Aucun utilisateur récent</p>
            <p class="text-sm text-gray-400 dark:text-gray-500 mt-2">Les nouveaux utilisateurs apparaîtront ici</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { 
  Users, FileText, Tag, Activity, Clock, 
  ExternalLink, User, DollarSign, TrendingUp,
  TrendingDown, MoreHorizontal, ChevronRight,
  Download, PlusCircle, MoreVertical, FileX,
  UserX, CircleCheck, ClockIcon, XCircle, AlertTriangle
} from 'lucide-vue-next'
import { ref, onMounted } from 'vue'

const client = useSupabaseClient()
const loading = ref(true)
const selectedPeriod = ref(2) // Mois par défaut

const stats = ref([
  { name: 'Utilisateurs', value: 0, change: 0, icon: Users },
  { name: 'Demandes actives', value: 0, change: 0, icon: FileText },
  { name: 'Experts', value: 0, change: 0, icon: Activity },
  { name: 'Catégories', value: 0, change: 0, icon: Tag },
])
const recentRequests = ref([])
const recentUsers = ref([])

// Obtenir la classe de couleur de bordure pour les cartes de statistiques
const getBorderClass = (index) => {
  const colors = [
    'border-blue-500',
    'border-green-500',
    'border-purple-500',
    'border-orange-500'
  ]
  return colors[index % colors.length]
}

// Obtenir la classe de fond pour les icônes
const getIconBgClass = (index) => {
  const colors = [
    'bg-gradient-to-br from-blue-400 to-blue-600',
    'bg-gradient-to-br from-green-400 to-green-600',
    'bg-gradient-to-br from-purple-400 to-purple-600',
    'bg-gradient-to-br from-orange-400 to-orange-600'
  ]
  return colors[index % colors.length]
}

// Obtenir l'icône pour les types de demandes
const getRequestIcon = (status) => {
  switch (status) {
    case 'active': return Activity
    case 'pending': return ClockIcon
    case 'completed': return CircleCheck
    case 'cancelled': return XCircle
    default: return AlertTriangle
  }
}

// Obtenir la couleur de fond pour les icônes de demandes
const getRequestIconBg = (status) => {
  switch (status) {
    case 'active': return 'bg-green-600'
    case 'pending': return 'bg-yellow-500'
    case 'completed': return 'bg-blue-600'
    case 'cancelled': return 'bg-gray-500'
    default: return 'bg-gray-400'
  }
}

// Charger les données
const fetchDashboardData = async () => {
  try {
    loading.value = true
    
    // Récupérer les statistiques
    const [
      { count: userCount }, 
      { count: requestCount }, 
      { count: expertCount },
      { count: categoryCount }
    ] = await Promise.all([
      client.from('profiles').select('*', { count: 'exact', head: true }),
      client.from('requests').select('*', { count: 'exact', head: true }).eq('status', 'active'),
      client.from('profiles').select('*', { count: 'exact', head: true }).eq('role', 'expert'),
      client.from('service_categories').select('*', { count: 'exact', head: true })
    ])
    
    // Mettre à jour les statistiques (avec des variations fictives pour la démo)
    stats.value[0].value = userCount
    stats.value[0].change = 12.5
    stats.value[1].value = requestCount
    stats.value[1].change = 8.3
    stats.value[2].value = expertCount
    stats.value[2].change = 5.7
    stats.value[3].value = categoryCount
    stats.value[3].change = -2.1
    
    // Récupérer les demandes récentes
    const { data: requests } = await client
      .from('requests')
      .select('*')
      .order('created_at', { ascending: false })
      .limit(5)
    
    recentRequests.value = requests || []
    
    // Récupérer les utilisateurs récents
    const { data: users } = await client
      .from('profiles')
      .select('*')
      .order('created_at', { ascending: false })
      .limit(5)
    
    recentUsers.value = users || []
  } catch (error) {
    console.error('Erreur lors du chargement des données :', error)
  } finally {
    loading.value = false
  }
}

// Formatage de date
const formatDate = (dateString) => {
  if (!dateString) return ''
  const date = new Date(dateString)
  return date.toLocaleDateString('fr-FR', {
    day: 'numeric',
    month: 'short',
    year: 'numeric'
  })
}

// Tronquer le texte
const truncateText = (text, length) => {
  if (!text) return ''
  return text.length > length ? `${text.substring(0, length)}...` : text
}

// Classes et textes pour les statuts des demandes
const getStatusClass = (status) => {
  switch (status) {
    case 'active': return 'bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-300'
    case 'pending': return 'bg-yellow-100 text-yellow-800 dark:bg-yellow-900 dark:text-yellow-300'
    case 'completed': return 'bg-blue-100 text-blue-800 dark:bg-blue-900 dark:text-blue-300'
    case 'cancelled': return 'bg-gray-100 text-gray-800 dark:bg-gray-700 dark:text-gray-300'
    default: return 'bg-gray-100 text-gray-800 dark:bg-gray-700 dark:text-gray-300'
  }
}

const getStatusText = (status) => {
  switch (status) {
    case 'active': return 'Active'
    case 'pending': return 'En attente'
    case 'completed': return 'Terminée'
    case 'cancelled': return 'Annulée'
    default: return status
  }
}

// Charger les données au montage du composant
onMounted(fetchDashboardData)

// Définir le layout admin
definePageMeta({
  layout: 'admin',
})
</script>