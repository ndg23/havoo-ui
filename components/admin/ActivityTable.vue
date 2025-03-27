<template>
  <div class="bg-white dark:bg-gray-800 rounded-lg shadow">
    <!-- En-tête du tableau -->
    <div class="flex justify-between items-center p-4 border-b border-gray-200 dark:border-gray-700">
      <h2 class="text-lg font-semibold text-gray-800 dark:text-white">{{ title }}</h2>
      
      <div class="flex space-x-2">
        <!-- Sélection du type d'activité -->
        <select 
          v-if="showFilters"
          v-model="selectedType" 
          class="text-sm rounded-md border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-700 text-gray-700 dark:text-gray-200 px-3 py-1.5 pr-8"
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
        
        <!-- Recherche -->
        <div v-if="showSearch" class="relative">
          <span class="absolute inset-y-0 left-0 flex items-center pl-2">
            <Search class="h-4 w-4 text-gray-500 dark:text-gray-400" />
          </span>
          <input 
            v-model="searchQuery" 
            type="text" 
            placeholder="Rechercher..." 
            class="pl-8 pr-3 py-1.5 text-sm rounded-md border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-700 text-gray-700 dark:text-gray-200 focus:ring-primary-500 focus:border-primary-500"
          />
        </div>
      </div>
    </div>
    
    <!-- Corps du tableau -->
    <div class="overflow-x-auto">
      <table class="min-w-full divide-y divide-gray-200 dark:divide-gray-700">
        <thead class="bg-gray-50 dark:bg-gray-700">
          <tr>
            <th scope="col" class="px-4 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
              Type
            </th>
            <th scope="col" class="px-4 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
              Détails
            </th>
            <th scope="col" class="px-4 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
              Utilisateur
            </th>
            <th scope="col" class="px-4 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
              Date
            </th>
            <th v-if="showActions" scope="col" class="relative px-4 py-3">
              <span class="sr-only">Actions</span>
            </th>
          </tr>
        </thead>
        <tbody class="bg-white dark:bg-gray-800 divide-y divide-gray-200 dark:divide-gray-700">
          <tr v-if="isLoading">
            <td colspan="5" class="px-4 py-4 text-center text-gray-500 dark:text-gray-400">
              <div class="flex justify-center items-center">
                <Loader2 class="h-5 w-5 text-primary-500 animate-spin mr-2" />
                Chargement...
              </div>
            </td>
          </tr>
          
          <tr v-else-if="filteredActivities.length === 0">
            <td colspan="5" class="px-4 py-8 text-center text-gray-500 dark:text-gray-400">
              <AlertCircle class="h-8 w-8 mx-auto mb-2 text-gray-400 dark:text-gray-600" />
              <p>Aucune activité trouvée.</p>
            </td>
          </tr>
          
          <tr 
            v-for="activity in filteredActivities" 
            :key="activity.id"
            class="hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors"
          >
            <!-- Type -->
            <td class="px-4 py-4 whitespace-nowrap">
              <div 
                class="h-9 w-9 rounded-full flex items-center justify-center"
                :class="getActivityTypeClass(activity.type)"
              >
                <component :is="getActivityTypeIcon(activity.type)" class="h-5 w-5 text-white" />
              </div>
            </td>
            
            <!-- Détails -->
            <td class="px-4 py-4">
              <div class="max-w-md">
                <p class="text-sm font-medium text-gray-900 dark:text-white">
                  {{ activity.title }}
                </p>
                <p class="text-sm text-gray-500 dark:text-gray-400 mt-1">
                  {{ activity.description }}
                </p>
              </div>
            </td>
            
            <!-- Utilisateur -->
            <td class="px-4 py-4 whitespace-nowrap">
              <div class="flex items-center">
                <div v-if="activity.user" class="h-8 w-8 rounded-full overflow-hidden bg-gray-100 dark:bg-gray-700 mr-3">
                  <img 
                    v-if="activity.user.avatar" 
                    :src="activity.user.avatar" 
                    alt="User avatar" 
                    class="h-full w-full object-cover"
                  />
                  <User v-else class="h-full w-full p-1.5 text-gray-400" />
                </div>
                <div>
                  <p v-if="activity.user" class="text-sm font-medium text-gray-900 dark:text-white">
                    {{ activity.user.name }}
                  </p>
                  <p v-else class="text-sm text-gray-500 dark:text-gray-400 italic">
                    Système
                  </p>
                </div>
              </div>
            </td>
            
            <!-- Date -->
            <td class="px-4 py-4 whitespace-nowrap text-sm text-gray-500 dark:text-gray-400">
              {{ formatDate(activity.created_at) }}
            </td>
            
            <!-- Actions -->
            <td v-if="showActions" class="px-4 py-4 whitespace-nowrap text-right text-sm">
              <div class="flex justify-end items-center space-x-2">
                <button 
                  v-if="allowDetails"
                  @click="$emit('view-details', activity)"
                  class="text-primary-600 dark:text-primary-400 hover:underline"
                >
                  Détails
                </button>
                <button 
                  v-if="allowDelete"
                  @click="$emit('delete', activity)"
                  class="text-red-600 dark:text-red-400 hover:underline"
                >
                  Supprimer
                </button>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    
    <!-- Pagination -->
    <div v-if="totalPages > 1" class="flex justify-between items-center px-4 py-3 border-t border-gray-200 dark:border-gray-700">
      <div>
        <p class="text-sm text-gray-700 dark:text-gray-300">
          Affichage de <span class="font-medium">{{ startItem }}</span> à <span class="font-medium">{{ endItem }}</span> sur <span class="font-medium">{{ totalItems }}</span> résultats
        </p>
      </div>
      <div class="flex space-x-1">
        <button 
          @click="currentPage > 1 && $emit('page-change', currentPage - 1)"
          :disabled="currentPage === 1"
          class="px-3 py-1 text-sm rounded-md"
          :class="currentPage === 1 ? 'text-gray-400 cursor-not-allowed' : 'text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700'"
        >
          Précédent
        </button>
        <button 
          @click="currentPage < totalPages && $emit('page-change', currentPage + 1)"
          :disabled="currentPage === totalPages"
          class="px-3 py-1 text-sm rounded-md"
          :class="currentPage === totalPages ? 'text-gray-400 cursor-not-allowed' : 'text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700'"
        >
          Suivant
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, watch } from 'vue'
import { formatDistance, subDays, format, parseISO } from 'date-fns'
import { fr } from 'date-fns/locale'
import { 
  Search, 
  User, 
  Loader2, 
  AlertCircle,
  UserPlus,
  MessageSquare,
  CheckCircle,
  DollarSign,
  Package,
  Shield,
  Settings
} from 'lucide-vue-next'

const props = defineProps({
  // Titre du tableau
  title: {
    type: String,
    default: 'Activités récentes'
  },
  // Données des activités
  activities: {
    type: Array,
    required: true
  },
  // État de chargement
  isLoading: {
    type: Boolean,
    default: false
  },
  // Afficher les filtres
  showFilters: {
    type: Boolean,
    default: true
  },
  // Afficher la recherche
  showSearch: {
    type: Boolean,
    default: true
  },
  // Afficher les actions
  showActions: {
    type: Boolean,
    default: true
  },
  // Autoriser la vue détaillée
  allowDetails: {
    type: Boolean,
    default: true
  },
  // Autoriser la suppression
  allowDelete: {
    type: Boolean,
    default: false
  },
  // Pagination
  currentPage: {
    type: Number,
    default: 1
  },
  totalPages: {
    type: Number,
    default: 1
  },
  totalItems: {
    type: Number,
    default: 0
  },
  itemsPerPage: {
    type: Number,
    default: 10
  }
})

const emit = defineEmits(['view-details', 'delete', 'page-change', 'type-change', 'search'])

// État local
const selectedType = ref('')
const searchQuery = ref('')

// Calculer les éléments affichés (pour la pagination)
const startItem = computed(() => (props.currentPage - 1) * props.itemsPerPage + 1)
const endItem = computed(() => Math.min(props.currentPage * props.itemsPerPage, props.totalItems))

// Filtrer les activités
const filteredActivities = computed(() => {
  let result = props.activities

  // Filtre par type
  if (selectedType.value) {
    result = result.filter(activity => activity.type === selectedType.value)
  }

  // Filtre par recherche
  if (searchQuery.value) {
    const search = searchQuery.value.toLowerCase()
    result = result.filter(activity => 
      activity.title.toLowerCase().includes(search) || 
      activity.description.toLowerCase().includes(search) ||
      (activity.user && activity.user.name.toLowerCase().includes(search))
    )
  }

  return result
})

// Retourner l'icône correspondant au type d'activité
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

// Retourner la classe CSS correspondant au type d'activité
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

// Formater la date d'une activité
const formatDate = (dateString) => {
  try {
    const date = parseISO(dateString)
    
    // Pour les dates de moins de 24h, afficher "il y a x heures/minutes"
    const now = new Date()
    const diff = now.getTime() - date.getTime()
    
    if (diff < 24 * 60 * 60 * 1000) {
      return formatDistance(date, now, { addSuffix: true, locale: fr })
    }
    
    // Pour les dates de l'année en cours, afficher le jour et le mois
    if (date.getFullYear() === now.getFullYear()) {
      return format(date, 'dd MMMM à HH:mm', { locale: fr })
    }
    
    // Pour les autres dates, afficher le jour, le mois et l'année
    return format(date, 'dd MMMM yyyy', { locale: fr })
  } catch (error) {
    console.error('Erreur de formatage de date:', error)
    return dateString
  }
}

// Observer les changements de filtre
watch(selectedType, (newValue) => {
  emit('type-change', newValue)
})

// Observer les changements de recherche
watch(searchQuery, (newValue) => {
  emit('search', newValue)
})
</script> 