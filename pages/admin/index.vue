<template>
  <div class="space-y-8 max-w-7xl mx-auto">
    <!-- En-tête avec statistiques globales -->
    <div class="p-8 bg-gradient-to-br from-primary-600 to-primary-800 rounded-2xl shadow-lg text-white">
      <h1 class="text-3xl font-bold mb-6 flex items-center">
        <ActivityIcon class="h-8 w-8 mr-3" />
        Vue d'ensemble
      </h1>
      
      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-8">
        <div 
          v-for="stat in summaryStats" 
          :key="stat.name"
          class="bg-white/10 backdrop-blur-sm rounded-xl p-6 hover:bg-white/15 transition-all"
        >
          <div class="flex items-center justify-between">
            <div>
              <p class="text-white/80 text-sm font-medium mb-1">{{ stat.name }}</p>
              <h3 class="text-3xl font-bold">{{ stat.value }}</h3>
              <div 
                class="flex items-center mt-2 text-sm"
                :class="stat.trend > 0 ? 'text-green-300' : stat.trend < 0 ? 'text-red-300' : 'text-gray-300'"
              >
                <component 
                  :is="stat.trend > 0 ? 'TrendingUpIcon' : stat.trend < 0 ? 'TrendingDownIcon' : 'MinusIcon'" 
                  class="h-4 w-4 mr-1"
                />
                <span>{{ Math.abs(stat.trend) }}% vs mois dernier</span>
              </div>
            </div>
            <div class="h-12 w-12 rounded-full bg-white/20 flex items-center justify-center">
              <component :is="stat.icon" class="h-6 w-6 text-white" />
            </div>
          </div>
        </div>
      </div>
    </div>
    
    <!-- Section Principale avec Graphique et Activité -->
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
      <!-- Graphique Activité -->
      <div class="lg:col-span-2 bg-white dark:bg-gray-800 rounded-2xl shadow-sm p-6 border border-gray-100 dark:border-gray-700">
        <div class="flex justify-between items-center mb-6">
          <h2 class="text-xl font-bold text-gray-900 dark:text-white">Tendance des demandes</h2>
          <div class="flex space-x-2">
            <button 
              v-for="period in ['7j', '30j', '90j']" 
              :key="period"
              :class="[
                'px-3 py-1 text-sm font-medium rounded-full',
                activePeriod === period 
                  ? 'bg-primary-100 text-primary-700 dark:bg-primary-900 dark:text-primary-300' 
                  : 'text-gray-500 hover:bg-gray-100 dark:hover:bg-gray-700'
              ]"
              @click="activePeriod = period"
            >
              {{ period }}
            </button>
          </div>
        </div>
        
        <div class="h-72 relative">
          <!-- Emplacement du graphique -->
          <LineChart 
            :chartData="chartData" 
            :options="chartOptions"
          />
        </div>
      </div>
      
      <!-- Activité Récente -->
      <div class="bg-white dark:bg-gray-800 rounded-2xl shadow-sm p-6 border border-gray-100 dark:border-gray-700">
        <div class="flex justify-between items-center mb-4">
          <h2 class="text-xl font-bold text-gray-900 dark:text-white">Activité récente</h2>
          <button class="text-primary-600 dark:text-primary-400 text-sm font-medium hover:underline">
            Voir tout
          </button>
        </div>
        
        <div class="space-y-5">
          <div 
            v-for="(activity, index) in recentActivities" 
            :key="index"
            class="flex items-start space-x-4 pb-4"
            :class="index < recentActivities.length - 1 ? 'border-b border-gray-100 dark:border-gray-700' : ''"
          >
            <div 
              class="h-10 w-10 rounded-full flex items-center justify-center flex-shrink-0"
              :class="getActivityColorClass(activity.type)"
            >
              <component :is="getActivityIcon(activity.type)" class="h-5 w-5 text-white" />
            </div>
            
            <div class="flex-1 min-w-0">
              <div class="flex justify-between items-start">
                <p class="text-sm font-medium text-gray-900 dark:text-white truncate">
                  {{ activity.title }}
                </p>
                <span class="text-xs text-gray-500 dark:text-gray-400 ml-2 whitespace-nowrap">
                  {{ activity.time }}
                </span>
              </div>
              <p class="text-sm text-gray-600 dark:text-gray-400 mt-1">{{ activity.description }}</p>
              
              <div v-if="activity.user" class="flex items-center mt-2">
                <div class="h-5 w-5 rounded-full overflow-hidden bg-gray-100 dark:bg-gray-700">
                  <img 
                    v-if="activity.user.avatar" 
                    :src="activity.user.avatar" 
                    alt="User avatar" 
                    class="h-full w-full object-cover"
                  />
                  <User v-else class="h-full w-full p-1 text-gray-400" />
                </div>
                <span class="ml-1.5 text-xs font-medium text-gray-700 dark:text-gray-300">
                  {{ activity.user.name }}
                </span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    
    <!-- Section Inférieure -->
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
      <!-- Demandes récentes -->
      <div class="lg:col-span-2 bg-white dark:bg-gray-800 rounded-2xl shadow-sm p-6 border border-gray-100 dark:border-gray-700">
        <div class="flex justify-between items-center mb-6">
          <h2 class="text-xl font-bold text-gray-900 dark:text-white">Dernières demandes</h2>
          <NuxtLink 
            to="/admin/requests" 
            class="text-primary-600 dark:text-primary-400 text-sm font-medium hover:underline"
          >
            Voir toutes
          </NuxtLink>
        </div>
        
        <div class="overflow-hidden">
          <table class="min-w-full divide-y divide-gray-200 dark:divide-gray-700">
            <thead>
              <tr>
                <th scope="col" class="px-4 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                  Client
                </th>
                <th scope="col" class="px-4 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                  Service
                </th>
                <th scope="col" class="px-4 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                  Date
                </th>
                <th scope="col" class="px-4 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                  Statut
                </th>
                <th scope="col" class="relative px-4 py-3">
                  <span class="sr-only">Actions</span>
                </th>
              </tr>
            </thead>
            <tbody class="divide-y divide-gray-200 dark:divide-gray-700">
              <tr 
                v-for="request in latestRequests" 
                :key="request.id"
                class="hover:bg-gray-50 dark:hover:bg-gray-750 transition-colors"
              >
                <td class="px-4 py-4 whitespace-nowrap">
                  <div class="flex items-center">
                    <div class="h-8 w-8 rounded-full overflow-hidden bg-gray-100 dark:bg-gray-700">
                      <img 
                        v-if="request.client.avatar" 
                        :src="request.client.avatar" 
                        alt="Client avatar" 
                        class="h-full w-full object-cover"
                      />
                      <User v-else class="h-full w-full p-1.5 text-gray-400" />
                    </div>
                    <div class="ml-3">
                      <p class="text-sm font-medium text-gray-900 dark:text-white">
                        {{ request.client.name }}
                      </p>
                    </div>
                  </div>
                </td>
                <td class="px-4 py-4 whitespace-nowrap">
                  <p class="text-sm text-gray-900 dark:text-white">{{ request.service }}</p>
                </td>
                <td class="px-4 py-4 whitespace-nowrap">
                  <p class="text-sm text-gray-500 dark:text-gray-400">{{ request.date }}</p>
                </td>
                <td class="px-4 py-4 whitespace-nowrap">
                  <span 
                    class="px-2.5 py-1 text-xs font-medium rounded-full"
                    :class="getStatusClass(request.status)"
                  >
                    {{ getStatusLabel(request.status) }}
                  </span>
                </td>
                <td class="px-4 py-4 whitespace-nowrap text-right text-sm">
                  <NuxtLink 
                    :to="`/admin/requests/${request.id}`" 
                    class="text-primary-600 dark:text-primary-400 font-medium hover:underline"
                  >
                    Détails
                  </NuxtLink>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
      
      <!-- Tâches et rappels -->
      <div class="bg-white dark:bg-gray-800 rounded-2xl shadow-sm p-6 border border-gray-100 dark:border-gray-700">
        <div class="flex justify-between items-center mb-6">
          <h2 class="text-xl font-bold text-gray-900 dark:text-white">À faire</h2>
          <button class="text-primary-600 dark:text-primary-400 text-sm font-medium hover:underline">
            <PlusIcon class="h-4 w-4 inline-block" />
            Ajouter
          </button>
        </div>
        
        <div class="space-y-3">
          <div 
            v-for="(task, index) in tasks" 
            :key="index"
            class="flex items-start space-x-3 p-3 rounded-lg"
            :class="task.completed ? 'bg-gray-50 dark:bg-gray-700/50' : 'bg-white dark:bg-gray-800'"
          >
            <input 
              :id="`task-${index}`"
              type="checkbox" 
              v-model="task.completed" 
              class="h-5 w-5 rounded text-primary-600 focus:ring-primary-500 mt-0.5"
            />
            <div class="flex-1">
              <label 
                :for="`task-${index}`" 
                class="block text-sm font-medium cursor-pointer"
                :class="task.completed ? 'text-gray-500 dark:text-gray-400 line-through' : 'text-gray-800 dark:text-white'"
              >
                {{ task.title }}
              </label>
              <p v-if="task.dueDate" class="text-xs text-gray-500 dark:text-gray-400 mt-1">
                Échéance: {{ task.dueDate }}
              </p>
            </div>
            
            <div v-if="task.priority" class="flex-shrink-0">
              <span 
                class="inline-flex items-center px-2 py-0.5 rounded-full text-xs font-medium"
                :class="{
                  'bg-red-100 text-red-800 dark:bg-red-900/30 dark:text-red-400': task.priority === 'high',
                  'bg-yellow-100 text-yellow-800 dark:bg-yellow-900/30 dark:text-yellow-400': task.priority === 'medium',
                  'bg-blue-100 text-blue-800 dark:bg-blue-900/30 dark:text-blue-400': task.priority === 'low'
                }"
              >
                {{ 
                  task.priority === 'high' ? 'Urgent' : 
                  task.priority === 'medium' ? 'Normal' : 'Faible' 
                }}
              </span>
            </div>
          </div>
        </div>
        
        <div v-if="tasks.filter(t => t.completed).length > 0" class="mt-4 text-right">
          <button class="text-sm text-gray-500 dark:text-gray-400 hover:text-gray-700 dark:hover:text-gray-300">
            Effacer les tâches terminées
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useSupabaseClient } from '#imports'
import { 
  Activity as ActivityIcon, 
  Users,
  User,
  TrendingUp as TrendingUpIcon,
  TrendingDown as TrendingDownIcon,
  Minus as MinusIcon,
  Package, 
  Calendar, 
  DollarSign,
  UserPlus,
  MessageSquare,
  ShoppingBag,
  AlertTriangle,
  CheckCircle,
  Plus as PlusIcon,
  Bell
} from 'lucide-vue-next'

const supabase = useSupabaseClient()
const activePeriod = ref('7j')
const isLoading = ref(true)
const error = ref(null)

// Statistiques globales
const summaryStats = ref([
  {
    name: 'Utilisateurs',
    value: '2,581',
    trend: 12,
    icon: Users
  },
  {
    name: 'Demandes',
    value: '1,247',
    trend: 24,
    icon: MessageSquare
  },
  {
    name: 'Services',
    value: '358',
    trend: 6,
    icon: Package
  },
  {
    name: 'Revenus',
    value: '598K',
    trend: -3,
    icon: DollarSign
  }
])

// Options du graphique
const chartData = ref({
  labels: ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Juin', 'Juil', 'Août', 'Sept', 'Oct', 'Nov', 'Déc'],
  datasets: [
    {
      label: 'Demandes',
      data: [65, 78, 90, 110, 125, 180, 210, 220, 250, 268, 280, 320],
      borderColor: 'rgb(99, 102, 241)',
      backgroundColor: 'rgba(99, 102, 241, 0.2)',
      tension: 0.4,
      fill: true
    },
    {
      label: 'Services',
      data: [28, 42, 53, 69, 98, 127, 154, 178, 190, 220, 235, 245],
      borderColor: 'rgb(34, 197, 94)',
      backgroundColor: 'rgba(34, 197, 94, 0.2)',
      tension: 0.4,
      fill: true
    }
  ]
})

const chartOptions = ref({
  responsive: true,
  maintainAspectRatio: false,
  scales: {
    y: {
      beginAtZero: true,
      grid: {
        display: true,
        color: 'rgba(156, 163, 175, 0.1)'
      }
    },
    x: {
      grid: {
        display: false
      }
    }
  },
  plugins: {
    legend: {
      position: 'top',
      labels: {
        usePointStyle: true,
        boxWidth: 6
      }
    }
  }
})

// Activités récentes
const recentActivities = ref([
  {
    type: 'new_user',
    title: 'Nouvel utilisateur inscrit',
    description: 'Un nouvel utilisateur a rejoint la plateforme',
    time: 'il y a 10 minutes',
    user: { name: 'Amadou Diallo', avatar: null }
  },
  {
    type: 'new_request',
    title: 'Nouvelle demande créée',
    description: 'Développement d\'une application mobile',
    time: 'il y a 45 minutes',
    user: { name: 'Fatou Ndiaye', avatar: null }
  },
  {
    type: 'service_completed',
    title: 'Service terminé',
    description: 'Conception de logo d\'entreprise',
    time: 'il y a 2 heures',
    user: { name: 'Ibrahim Touré', avatar: null }
  },
  {
    type: 'payment',
    title: 'Paiement reçu',
    description: '45,000 XOF pour service de traduction',
    time: 'il y a 3 heures',
    user: { name: 'Mariam Sow', avatar: null }
  }
])

// Dernières demandes
const latestRequests = ref([
  {
    id: '1',
    client: { name: 'Moussa Camara', avatar: null },
    service: 'Développement de site web',
    date: '10/05/2023',
    status: 'pending'
  },
  {
    id: '2',
    client: { name: 'Aissatou Diop', avatar: null },
    service: 'Design d\'application',
    date: '09/05/2023',
    status: 'active'
  },
  {
    id: '3',
    client: { name: 'Omar Sy', avatar: null },
    service: 'Traduction de documents',
    date: '08/05/2023',
    status: 'completed'
  },
  {
    id: '4',
    client: { name: 'Fatoumata Bah', avatar: null },
    service: 'Montage vidéo',
    date: '07/05/2023',
    status: 'cancelled'
  }
])

// Tâches à faire
const tasks = ref([
  {
    title: 'Modérer les nouveaux services',
    dueDate: 'Aujourd\'hui',
    priority: 'high',
    completed: false
  },
  {
    title: 'Valider le paiement en attente pour Omar',
    dueDate: 'Aujourd\'hui',
    priority: 'medium',
    completed: false
  },
  {
    title: 'Répondre aux demandes de support',
    dueDate: 'Demain',
    priority: 'high',
    completed: false
  },
  {
    title: 'Mettre à jour les conditions d\'utilisation',
    dueDate: '12 Mai',
    priority: 'low',
    completed: true
  }
])

// Helpers
const getActivityIcon = (type) => {
  switch (type) {
    case 'new_user': return UserPlus
    case 'new_request': return MessageSquare
    case 'service_completed': return CheckCircle
    case 'payment': return DollarSign
    default: return Bell
  }
}

const getActivityColorClass = (type) => {
  switch (type) {
    case 'new_user': return 'bg-green-500'
    case 'new_request': return 'bg-blue-500'
    case 'service_completed': return 'bg-purple-500' 
    case 'payment': return 'bg-amber-500'
    default: return 'bg-gray-500'
  }
}

const getStatusClass = (status) => {
  switch (status) {
    case 'active': return 'bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-400'
    case 'pending': return 'bg-yellow-100 text-yellow-800 dark:bg-yellow-900/30 dark:text-yellow-400'
    case 'completed': return 'bg-blue-100 text-blue-800 dark:bg-blue-900/30 dark:text-blue-400'
    case 'cancelled': return 'bg-red-100 text-red-800 dark:bg-red-900/30 dark:text-red-400'
    default: return 'bg-gray-100 text-gray-800 dark:bg-gray-700 dark:text-gray-400'
  }
}

const getStatusLabel = (status) => {
  switch (status) {
    case 'active': return 'Active'
    case 'pending': return 'En attente'
    case 'completed': return 'Terminée'
    case 'cancelled': return 'Annulée'
    default: return status
  }
}

// Initialisation
onMounted(async () => {
  try {
    isLoading.value = true
    
    // Charger des données réelles
    // Exemple:
    // const { data: usersData, error: usersError } = await supabase.from('users').select('count')
    // if (usersError) throw usersError
    // summaryStats.value[0].value = usersData[0].count.toLocaleString()
    
    // ...autres chargements...
    
  } catch (err) {
    console.error('Erreur lors du chargement des données:', err)
    error.value = err.message
  } finally {
    isLoading.value = false
  }
})

definePageMeta({
  layout: 'admin'
})
</script>

<style>
/* Ajouter un rappel d'importer vue-chartjs et Chart.js dans le projet */
</style>