<template>
  <div>
    <PageHeader 
      title="Journal d'activités"
      subtitle="Suivi en temps réel des événements et actions sur la plateforme"
    >
      <template #actions>
        <button 
          @click="exportActivities" 
          class="inline-flex items-center px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md shadow-sm hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500"
        >
          <Download class="h-4 w-4 mr-2" />
          Exporter
        </button>
      </template>
    </PageHeader>
    
    <div class="mt-6 space-y-6">
      <!-- Filtres avancés -->
      <div class="p-6 bg-white dark:bg-gray-800 rounded-lg shadow border border-gray-100 dark:border-gray-700">
        <h2 class="text-lg font-medium text-gray-900 dark:text-white mb-4">Filtres</h2>
        
        <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
          <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Type d'activité</label>
            <select 
              v-model="filters.type"
              class="w-full rounded-md border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-700 text-gray-700 dark:text-gray-200 shadow-sm"
            >
              <option value="">Tous les types</option>
              <option value="new_user">Nouveaux utilisateurs</option>
              <option value="new_mission">Nouvelles demandes</option>
              <option value="service_completed">Services terminés</option>
              <option value="payment">Paiements</option>
              <option value="service_created">Services créés</option>
              <option value="user_verified">Utilisateurs vérifiés</option>
              <option value="admin_action">Actions admin</option>
            </select>
          </div>
          
          <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Période</label>
            <select 
              v-model="filters.period"
              class="w-full rounded-md border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-700 text-gray-700 dark:text-gray-200 shadow-sm"
            >
              <option value="today">Aujourd'hui</option>
              <option value="yesterday">Hier</option>
              <option value="week">7 derniers jours</option>
              <option value="month">30 derniers jours</option>
              <option value="custom">Période personnalisée</option>
            </select>
          </div>
          
          <div v-if="filters.period === 'custom'" class="md:col-span-2 grid grid-cols-2 gap-4">
            <div>
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Date de début</label>
              <input 
                type="date" 
                v-model="filters.startDate"
                class="w-full rounded-md border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-700 text-gray-700 dark:text-gray-200 shadow-sm"
              />
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Date de fin</label>
              <input 
                type="date" 
                v-model="filters.endDate"
                class="w-full rounded-md border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-700 text-gray-700 dark:text-gray-200 shadow-sm"
              />
            </div>
          </div>
          
          <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Recherche</label>
            <div class="relative">
              <span class="absolute inset-y-0 left-0 flex items-center pl-3">
                <Search class="h-5 w-5 text-gray-500 dark:text-gray-400" />
              </span>
              <input 
                type="text" 
                v-model="filters.search"
                placeholder="Rechercher par mots-clés..."
                class="w-full pl-10 pr-4 py-2 rounded-md border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-700 text-gray-700 dark:text-gray-200 shadow-sm"
              />
            </div>
          </div>
        </div>
        
        <div class="mt-4 flex justify-end">
          <button 
            @click="resetFilters"
            class="px-4 py-2 mr-2 text-sm font-medium text-gray-700 dark:text-gray-300 bg-white dark:bg-gray-800 border border-gray-300 dark:border-gray-600 rounded-md shadow-sm hover:bg-gray-50 dark:hover:bg-gray-700"
          >
            Réinitialiser
          </button>
          <button 
            @click="loadActivities"
            class="px-4 py-2 text-sm font-medium text-white bg-primary-600 hover:bg-primary-700 rounded-md shadow-sm"
          >
            Appliquer
          </button>
        </div>
      </div>
      
      <!-- Tableau d'activités -->
      <ActivityTable 
        :activities="activities"
        :is-loading="isLoading"
        :current-page="pagination.page"
        :total-pages="pagination.totalPages"
        :total-items="pagination.total"
        :items-per-page="pagination.perPage"
        title="Journal d'activités"
        @page-change="handlePageChange"
        @view-details="viewActivityDetails"
      />
    </div>
    
    <!-- Modal de détails d'activité -->
    <teleport to="body">
      <div v-if="showDetailsModal" class="fixed inset-0 z-50 overflow-y-auto">
        <div class="flex items-center justify-center min-h-screen px-4 pt-4 pb-20 text-center sm:block sm:p-0">
          <div class="fixed inset-0 transition-opacity" @click="showDetailsModal = false">
            <div class="absolute inset-0 bg-gray-500 dark:bg-gray-900 opacity-75"></div>
          </div>
          
          <span class="hidden sm:inline-block sm:align-middle sm:h-screen">&#8203;</span>
          
          <div class="inline-block align-bottom bg-white dark:bg-gray-800 rounded-lg text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-lg sm:w-full">
            <div class="bg-white dark:bg-gray-800 px-4 pt-5 pb-4 sm:p-6 sm:pb-4">
              <div class="sm:flex sm:items-start">
                <div 
                  class="mx-auto flex-shrink-0 flex items-center justify-center h-12 w-12 rounded-full sm:mx-0 sm:h-10 sm:w-10"
                  :class="selectedActivity ? getActivityTypeClass(selectedActivity.type) : 'bg-gray-500'"
                >
                  <component 
                    :is="selectedActivity ? getActivityTypeIcon(selectedActivity.type) : AlertCircle" 
                    class="h-6 w-6 text-white" 
                  />
                </div>
                
                <div class="mt-3 text-center sm:mt-0 sm:ml-4 sm:text-left">
                  <h3 class="text-lg leading-6 font-medium text-gray-900 dark:text-white">
                    {{ selectedActivity ? selectedActivity.title : 'Détails de l\'activité' }}
                  </h3>
                  <div class="mt-2">
                    <p class="text-sm text-gray-500 dark:text-gray-400">
                      {{ selectedActivity ? selectedActivity.description : '' }}
                    </p>
                    
                    <div v-if="selectedActivity" class="mt-4">
                      <div class="grid grid-cols-2 gap-4 text-sm">
                        <div>
                          <p class="text-gray-500 dark:text-gray-400">Type:</p>
                          <p class="font-medium text-gray-900 dark:text-white">{{ formatActivityType(selectedActivity.type) }}</p>
                        </div>
                        <div>
                          <p class="text-gray-500 dark:text-gray-400">Date:</p>
                          <p class="font-medium text-gray-900 dark:text-white">{{ formatDetailDate(selectedActivity.created_at) }}</p>
                        </div>
                        <div v-if="selectedActivity.user">
                          <p class="text-gray-500 dark:text-gray-400">Utilisateur:</p>
                          <p class="font-medium text-gray-900 dark:text-white">{{ selectedActivity.user.name }}</p>
                        </div>
                        <div v-if="selectedActivity.related_type">
                          <p class="text-gray-500 dark:text-gray-400">Objet lié:</p>
                          <p class="font-medium text-gray-900 dark:text-white">{{ formatRelatedType(selectedActivity.related_type) }}</p>
                        </div>
                      </div>
                      
                      <div v-if="selectedActivity.metadata && Object.keys(selectedActivity.metadata).length > 0" class="mt-4">
                        <p class="text-gray-500 dark:text-gray-400 mb-2">Métadonnées:</p>
                        <pre class="text-xs bg-gray-50 dark:bg-gray-900 p-3 rounded overflow-auto max-h-40">{{ JSON.stringify(selectedActivity.metadata, null, 2) }}</pre>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div class="bg-gray-50 dark:bg-gray-700 px-4 py-3 sm:px-6 sm:flex sm:flex-row-reverse">
              <button 
                @click="showDetailsModal = false"
                class="mt-3 w-full inline-flex justify-center rounded-md border border-gray-300 dark:border-gray-600 shadow-sm px-4 py-2 bg-white dark:bg-gray-800 text-base font-medium text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700 sm:mt-0 sm:ml-3 sm:w-auto sm:text-sm"
              >
                Fermer
              </button>
            </div>
          </div>
        </div>
      </div>
    </teleport>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted } from 'vue'
import { format, parseISO, subDays, startOfDay, endOfDay } from 'date-fns'
import { fr } from 'date-fns/locale'
import { useActivityService } from '~/services/activityService'
import { 
  Search, 
  Download, 
  AlertCircle, 
  UserPlus, 
  MessageSquare, 
  CheckCircle, 
  DollarSign, 
  Package, 
  Shield, 
  Settings 
} from 'lucide-vue-next'
import PageHeader from '~/components/admin/PageHeader.vue'
import ActivityTable from '~/components/admin/ActivityTable.vue'

// Service d'activités
const activityService = useActivityService()

// État
const activities = ref([])
const isLoading = ref(false)
const showDetailsModal = ref(false)
const selectedActivity = ref(null)

// Pagination
const pagination = reactive({
  page: 1,
  perPage: 10,
  total: 0,
  totalPages: 1
})

// Filtres
const filters = reactive({
  type: '',
  period: 'week',
  search: '',
  startDate: format(subDays(new Date(), 7), 'yyyy-MM-dd'),
  endDate: format(new Date(), 'yyyy-MM-dd')
})

// Charger les activités
const loadActivities = async () => {
  try {
    isLoading.value = true
    
    // Calcul de l'offset pour la pagination
    const offset = (pagination.page - 1) * pagination.perPage
    
    // Préparer les dates si une période est sélectionnée
    let dateFilter = null
    if (filters.period !== 'custom') {
      const endDate = new Date()
      let startDate = new Date()
      
      switch (filters.period) {
        case 'today':
          startDate = startOfDay(endDate)
          break
        case 'yesterday':
          startDate = startOfDay(subDays(endDate, 1))
          endDate = endOfDay(subDays(endDate, 1))
          break
        case 'week':
          startDate = subDays(endDate, 7)
          break
        case 'month':
          startDate = subDays(endDate, 30)
          break
      }
      
      dateFilter = {
        start: startDate.toISOString(),
        end: endDate.toISOString()
      }
    } else if (filters.startDate && filters.endDate) {
      // Utiliser les dates personnalisées
      const startDate = new Date(filters.startDate)
      const endDate = new Date(filters.endDate)
      endDate.setHours(23, 59, 59, 999) // Fin de journée
      
      dateFilter = {
        start: startDate.toISOString(),
        end: endDate.toISOString()
      }
    }
    
    // Pour l'instant, on charge toutes les activités (à remplacer par une requête filtrée)
    // Dans une vraie implémentation, tous ces filtres seraient passés au backend
    let data = await activityService.getRecentActivities(100, 0, filters.type || null)
    
    // Filtrage côté client (à remplacer par une requête filtrée)
    if (dateFilter) {
      data = data.filter(activity => {
        const activityDate = new Date(activity.created_at)
        return activityDate >= new Date(dateFilter.start) && activityDate <= new Date(dateFilter.end)
      })
    }
    
    if (filters.search) {
      const search = filters.search.toLowerCase()
      data = data.filter(activity => 
        activity.title.toLowerCase().includes(search) || 
        activity.description.toLowerCase().includes(search) ||
        (activity.user && activity.user.name.toLowerCase().includes(search))
      )
    }
    
    // Mise à jour des données
    pagination.total = data.length
    pagination.totalPages = Math.ceil(data.length / pagination.perPage)
    
    // Paginer les résultats
    activities.value = data.slice(offset, offset + pagination.perPage)
    
  } catch (error) {
    console.error('Erreur lors du chargement des activités:', error)
  } finally {
    isLoading.value = false
  }
}

// Réinitialiser les filtres
const resetFilters = () => {
  filters.type = ''
  filters.period = 'week'
  filters.search = ''
  filters.startDate = format(subDays(new Date(), 7), 'yyyy-MM-dd')
  filters.endDate = format(new Date(), 'yyyy-MM-dd')
}

// Gérer le changement de page
const handlePageChange = (page) => {
  pagination.page = page
  loadActivities()
}

// Afficher les détails d'une activité
const viewActivityDetails = (activity) => {
  selectedActivity.value = activity
  showDetailsModal.value = true
}

// Exporter les activités
const exportActivities = () => {
  try {
    // Créer un CSV avec les activités filtrées
    const csvContent = [
      // En-têtes
      ['Type', 'Titre', 'Description', 'Utilisateur', 'Date', 'Objet lié'].join(','),
      // Données
      ...activities.value.map(activity => [
        formatActivityType(activity.type),
        `"${activity.title.replace(/"/g, '""')}"`,
        `"${activity.description.replace(/"/g, '""')}"`,
        activity.user ? `"${activity.user.name.replace(/"/g, '""')}"` : '',
        formatDetailDate(activity.created_at),
        activity.related_type ? formatRelatedType(activity.related_type) : ''
      ].join(','))
    ].join('\n')
    
    // Créer un blob et un lien de téléchargement
    const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' })
    const url = URL.createObjectURL(blob)
    const link = document.createElement('a')
    link.setAttribute('href', url)
    link.setAttribute('download', `activites_${format(new Date(), 'yyyyMMdd')}.csv`)
    link.style.visibility = 'hidden'
    document.body.appendChild(link)
    link.click()
    document.body.removeChild(link)
  } catch (error) {
    console.error('Erreur lors de l\'exportation des activités:', error)
  }
}

// Formater les types d'activité pour l'affichage
const formatActivityType = (type) => {
  switch (type) {
    case 'new_user': return 'Nouvel utilisateur'
    case 'new_mission': return 'Nouvelle demande'
    case 'service_completed': return 'Service terminé'
    case 'payment': return 'Paiement'
    case 'service_created': return 'Service créé'
    case 'user_verified': return 'Utilisateur vérifié'
    case 'admin_action': return 'Action administrative'
    default: return type
  }
}

// Formater les types d'objets liés pour l'affichage
const formatRelatedType = (type) => {
  switch (type) {
    case 'user': return 'Utilisateur'
    case 'mission': return 'Demande'
    case 'service': return 'Service'
    case 'payment': return 'Paiement'
    default: return type
  }
}

// Formater la date détaillée
const formatDetailDate = (dateString) => {
  try {
    const date = parseISO(dateString)
    return format(date, 'dd MMMM yyyy à HH:mm:ss', { locale: fr })
  } catch (error) {
    console.error('Erreur de formatage de date:', error)
    return dateString
  }
}

// Récupérer l'icône pour un type d'activité
const getActivityTypeIcon = (type) => {
  switch (type) {
    case 'new_user': return UserPlus
    case 'new_mission': return MessageSquare
    case 'service_completed': return CheckCircle
    case 'payment': return DollarSign
    case 'service_created': return Package
    case 'user_verified': return Shield
    case 'admin_action': return Settings
    default: return AlertCircle
  }
}

// Récupérer la classe CSS pour un type d'activité
const getActivityTypeClass = (type) => {
  switch (type) {
    case 'new_user': return 'bg-green-500'
    case 'new_mission': return 'bg-blue-500'
    case 'service_completed': return 'bg-purple-500'
    case 'payment': return 'bg-amber-500'
    case 'service_created': return 'bg-indigo-500'
    case 'user_verified': return 'bg-teal-500'
    case 'admin_action': return 'bg-gray-500'
    default: return 'bg-gray-400'
  }
}

// Initialisation
onMounted(() => {
  loadActivities()
})

// Configuration de la page
definePageMeta({
  layout: 'admin'
})
</script> 