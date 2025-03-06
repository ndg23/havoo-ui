<template>
  <div class="space-y-8">
    <!-- Cartes de statistiques -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
      <div 
        v-for="(stat, index) in stats" 
        :key="index"
        class="bg-white border border-gray-200 rounded-xl p-5 flex flex-col"
      >
        <div class="flex items-center justify-between">
          <span class="text-gray-500 text-sm">{{ stat.name }}</span>
          <div class="h-8 w-8 bg-primary-50 rounded-md flex items-center justify-center">
            <component :is="stat.icon" class="h-5 w-5 text-primary-600" />
          </div>
        </div>
        <div class="mt-3">
          <div v-if="loading" class="animate-pulse h-8 bg-gray-200 rounded w-16"></div>
          <div v-else class="text-2xl font-bold text-gray-900">{{ stat.value }}</div>
        </div>
        <div class="text-sm text-gray-500 mt-1">
          <span v-if="stat.change >= 0" class="text-green-600">+{{ stat.change }}%</span>
          <span v-else class="text-red-600">{{ stat.change }}%</span>
          ce mois-ci
        </div>
      </div>
    </div>
    
    <!-- Graphiques et tableaux -->
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
      <!-- Demandes récentes -->
      <div class="lg:col-span-2 bg-white border border-gray-200 rounded-xl overflow-hidden">
        <div class="px-5 py-4 border-b border-gray-200 flex justify-between items-center">
          <h2 class="font-bold text-gray-900">Demandes récentes</h2>
          <NuxtLink 
            to="/admin/requests" 
            class="text-sm text-primary-600 hover:text-primary-700 font-medium"
          >
            Voir tout
          </NuxtLink>
        </div>
        
        <div class="p-5">
          <div v-if="loading" class="space-y-4">
            <div v-for="i in 5" :key="i" class="animate-pulse flex items-center">
              <div class="h-10 w-40 bg-gray-200 rounded"></div>
              <div class="h-10 flex-1 ml-4 bg-gray-200 rounded"></div>
            </div>
          </div>
          
          <div v-else-if="recentRequests.length" class="divide-y divide-gray-100 -mt-3">
            <div 
              v-for="request in recentRequests" 
              :key="request.id"
              class="py-3 flex items-center justify-between"
            >
              <div>
                <div class="font-medium text-gray-900">{{ truncateText(request.title, 40) }}</div>
                <div class="text-sm text-gray-500 mt-1 flex items-center">
                  <Clock class="h-3.5 w-3.5 mr-1" />
                  {{ formatDate(request.created_at) }}
                </div>
              </div>
              
              <div class="flex items-center">
                <span 
                  class="px-2.5 py-1 text-xs font-medium rounded-full"
                  :class="getStatusClass(request.status)"
                >
                  {{ getStatusText(request.status) }}
                </span>
                <NuxtLink 
                  :to="`/admin/requests/${request.id}`"
                  class="ml-3 p-1.5 text-gray-500 hover:text-gray-700 rounded-md transition-colors"
                >
                  <ExternalLink class="h-4 w-4" />
                </NuxtLink>
              </div>
            </div>
          </div>
          
          <div v-else class="py-10 text-center">
            <FileText class="h-10 w-10 text-gray-300 mx-auto mb-3" />
            <p class="text-gray-500">Aucune demande récente</p>
          </div>
        </div>
      </div>
      
      <!-- Utilisateurs récemment inscrits -->
      <div class="bg-white border border-gray-200 rounded-xl overflow-hidden">
        <div class="px-5 py-4 border-b border-gray-200 flex justify-between items-center">
          <h2 class="font-bold text-gray-900">Nouveaux utilisateurs</h2>
          <NuxtLink 
            to="/admin/users" 
            class="text-sm text-primary-600 hover:text-primary-700 font-medium"
          >
            Voir tout
          </NuxtLink>
        </div>
        
        <div class="p-5">
          <div v-if="loading" class="space-y-4">
            <div v-for="i in 5" :key="i" class="animate-pulse flex items-center">
              <div class="h-10 w-10 bg-gray-200 rounded-full"></div>
              <div class="h-10 flex-1 ml-3 bg-gray-200 rounded"></div>
            </div>
          </div>
          
          <div v-else-if="recentUsers.length" class="divide-y divide-gray-100 -mt-3">
            <div 
              v-for="user in recentUsers" 
              :key="user.id"
              class="py-3 flex items-center"
            >
              <div class="h-10 w-10 rounded-full bg-gray-100 mr-3 flex-shrink-0">
                <img 
                  v-if="user.profile_image_url"
                  :src="user.profile_image_url"
                  class="h-full w-full object-cover rounded-full"
                  alt="Avatar"
                />
                <div v-else class="h-full w-full flex items-center justify-center">
                  <User class="h-5 w-5 text-gray-400" />
                </div>
              </div>
              
              <div class="flex-1 min-w-0">
                <div class="font-medium text-gray-900 truncate">
                  {{ user.first_name }} {{ user.last_name }}
                </div>
                <div class="text-sm text-gray-500 truncate">
                  {{ user.email }}
                </div>
              </div>
              
              <NuxtLink 
                :to="`/admin/users/${user.id}`"
                class="ml-2 p-1.5 text-gray-500 hover:text-gray-700 rounded-md transition-colors"
              >
                <ExternalLink class="h-4 w-4" />
              </NuxtLink>
            </div>
          </div>
          
          <div v-else class="py-10 text-center">
            <Users class="h-10 w-10 text-gray-300 mx-auto mb-3" />
            <p class="text-gray-500">Aucun utilisateur récent</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { 
  Users, FileText, Tag, Activity, Clock, 
  ExternalLink, User, DollarSign
} from 'lucide-vue-next'
import { ref, onMounted } from 'vue'

const client = useSupabaseClient()
const loading = ref(true)
const stats = ref([
  { name: 'Utilisateurs', value: 0, change: 0, icon: Users },
  { name: 'Demandes actives', value: 0, change: 0, icon: FileText },
  { name: 'Experts', value: 0, change: 0, icon: Activity },
  { name: 'Catégories', value: 0, change: 0, icon: Tag },
])
const recentRequests = ref([])
const recentUsers = ref([])

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
    case 'active': return 'bg-green-100 text-green-800'
    case 'pending': return 'bg-yellow-100 text-yellow-800'
    case 'completed': return 'bg-blue-100 text-blue-800'
    case 'cancelled': return 'bg-gray-100 text-gray-800'
    default: return 'bg-gray-100 text-gray-800'
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
  middleware: ['admin-auth']
})
</script> 