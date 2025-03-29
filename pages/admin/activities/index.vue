<template>
  <div class="space-y-6 p-4 sm:p-6 lg:p-8">
    <!-- Header -->
    <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
      <div>
        <h1 class="text-2xl font-bold text-gray-900 dark:text-white">Journal d'activités</h1>
        <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
          Suivi en temps réel des événements et actions sur la plateforme
        </p>
      </div>
      
      <div class="flex items-center gap-3">
        <UButton
          icon="i-heroicons-funnel"
          color="gray"
          variant="ghost"
          class="h-10 w-10 rounded-full"
          @click="showFilters = !showFilters"
        />
        <UButton
          icon="i-heroicons-arrow-down-tray"
          label="Exporter"
          class="rounded-full"
          @click="exportActivities"
        />
      </div>
    </div>

    <!-- Filtres -->
    <UCard v-if="showFilters">
      <div class="grid gap-6 sm:grid-cols-2 lg:grid-cols-4">
        <!-- Type d'activité -->
        <USelect
          v-model="filters.type"
          :options="activityTypes"
          option-attribute="label"
          value-attribute="value"
          placeholder="Tous les types"
          class="w-full"
          icon="i-heroicons-tag"
          clearable
        />

        <!-- Période -->
        <USelect
          v-model="filters.period"
          :options="periodOptions"
          option-attribute="label"
          value-attribute="value"
          placeholder="Sélectionner une période"
          class="w-full"
          icon="i-heroicons-calendar"
        />

        <!-- Dates personnalisées -->
        <template v-if="filters.period === 'custom'">
          <UInput
            v-model="filters.startDate"
            type="date"
            icon="i-heroicons-calendar-days"
            class="w-full"
          />
          <UInput
            v-model="filters.endDate"
            type="date"
            icon="i-heroicons-calendar-days"
            class="w-full"
          />
        </template>

        <!-- Recherche -->
        <UInput
          v-model="filters.search"
          icon="i-heroicons-magnifying-glass"
          placeholder="Rechercher..."
          class="w-full"
          clearable
        />
      </div>

      <div class="flex justify-end gap-3 mt-6">
        <UButton
          color="gray"
          variant="ghost"
          label="Réinitialiser"
          icon="i-heroicons-arrow-path"
          class="rounded-full"
          @click="resetFilters"
        />
        <UButton
          color="primary"
          label="Appliquer"
          icon="i-heroicons-check"
          class="rounded-full"
          @click="loadActivities"
        />
      </div>
    </UCard>

    <!-- Table -->
    <UCard>
      <UTable
        :rows="activities || []"
        :columns="columns"
        :loading="isLoading"
        :sort="sort"
        @update:sort="updateSort"
        :search-value="filters.search"
        @update:search-value="filters.search = $event"
      >
        <!-- Loading state -->
        <template #loading>
          <div class="flex items-center justify-center p-4">
            <UIcon name="i-heroicons-arrow-path" class="h-6 w-6 animate-spin" />
          </div>
        </template>

        <!-- Empty state -->
        <template #empty>
          <div class="flex flex-col items-center justify-center py-6 px-4 text-center">
            <UIcon name="i-heroicons-inbox" class="h-12 w-12 text-gray-400 dark:text-gray-500 mb-3" />
            <p class="text-gray-500 dark:text-gray-400">Aucune activité trouvée</p>
          </div>
        </template>

        <!-- Custom cell templates -->
        <template #type-data="{ row }">
          <div class="flex items-center gap-2">
            <UAvatar
              :icon="getActivityTypeIcon(row.type)"
              size="sm"
              :class="getActivityTypeClass(row.type)"
            />
            <span>{{ formatActivityType(row.type) }}</span>
          </div>
        </template>

        <template #user-data="{ row }">
          <div v-if="row.user" class="flex items-center gap-2">
            <UAvatar
              :src="row.user.avatar_url"
              :alt="row.user.name"
              :text="getInitials(row.user.name)"
              size="sm"
            />
            <div>
              <div class="font-medium text-gray-900 dark:text-white">
                {{ row.user.name }}
              </div>
              <div class="text-xs text-gray-500 dark:text-gray-400">
                {{ row.user.email }}
              </div>
            </div>
          </div>
          <span v-else class="text-gray-400">-</span>
        </template>

        <template #description-data="{ row }">
          <div class="max-w-md">
            <div class="font-medium text-gray-900 dark:text-white">
              {{ row.title }}
            </div>
            <div class="text-sm text-gray-500 dark:text-gray-400">
              {{ row.description }}
            </div>
          </div>
        </template>

        <template #date-data="{ row }">
          <div class="whitespace-nowrap">
            {{ formatDate(row.created_at) }}
          </div>
        </template>

        <template #actions-data="{ row }">
          <UButton
            color="gray"
            variant="ghost"
            icon="i-heroicons-eye"
            class="h-8 w-8 rounded-full"
            @click="viewActivityDetails(row)"
          />
        </template>
      </UTable>

      <!-- Pagination -->
      <div class="mt-4 flex items-center justify-between px-4 py-3 border-t border-gray-200 dark:border-gray-800">
        <UPagination
          v-model="pagination.page"
          :total="pagination.total"
          :per-page="pagination.perPage"
          class="flex-1 flex justify-center sm:justify-end"
        />
      </div>
    </UCard>

    <!-- Modal de détails -->
    <UModal v-model="showDetailsModal" :ui="{ width: 'sm:max-w-2xl' }">
      <UCard>
        <template #header>
          <div class="flex items-center gap-4">
            <UAvatar
              :icon="selectedActivity ? getActivityTypeIcon(selectedActivity.type) : 'i-heroicons-information-circle'"
              size="lg"
              :class="selectedActivity ? getActivityTypeClass(selectedActivity.type) : ''"
            />
            <div>
              <h3 class="text-lg font-semibold">
                {{ selectedActivity?.title || 'Détails de l\'activité' }}
              </h3>
              <p class="text-sm text-gray-500 dark:text-gray-400">
                {{ formatDate(selectedActivity?.created_at) }}
              </p>
            </div>
          </div>
        </template>

        <div v-if="selectedActivity" class="space-y-6">
          <div class="prose dark:prose-invert max-w-none">
            <p>{{ selectedActivity.description }}</p>
          </div>

          <div class="grid grid-cols-2 gap-4">
            <div>
              <div class="text-sm font-medium text-gray-500 dark:text-gray-400">Type</div>
              <div class="mt-1">{{ formatActivityType(selectedActivity.type) }}</div>
            </div>
            <div v-if="selectedActivity.user">
              <div class="text-sm font-medium text-gray-500 dark:text-gray-400">Utilisateur</div>
              <div class="mt-1 flex items-center gap-2">
                <UAvatar
                  :src="selectedActivity.user.avatar_url"
                  :alt="selectedActivity.user.name"
                  :text="getInitials(selectedActivity.user.name)"
                  size="sm"
                />
                <span>{{ selectedActivity.user.name }}</span>
              </div>
            </div>
          </div>

          <div v-if="selectedActivity.metadata">
            <div class="text-sm font-medium text-gray-500 dark:text-gray-400 mb-2">Métadonnées</div>
            <pre class="bg-gray-50 dark:bg-gray-800 p-4 rounded-lg overflow-auto text-xs">{{ JSON.stringify(selectedActivity.metadata, null, 2) }}</pre>
          </div>
        </div>

        <template #footer>
          <div class="flex justify-end">
            <UButton
              color="gray"
              variant="ghost"
              label="Fermer"
              @click="showDetailsModal = false"
            />
          </div>
        </template>
      </UCard>
    </UModal>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted, watch } from 'vue'
import { format, parseISO, subDays, startOfDay, endOfDay } from 'date-fns'
import { fr } from 'date-fns/locale'
import { useActivityService } from '~/services/activityService'
import { useSupabaseClient } from '#imports'
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
const supabase = useSupabaseClient()

// État
const activities = ref([])
const isLoading = ref(true)
const showFilters = ref(false)
const showDetailsModal = ref(false)
const selectedActivity = ref(null)
const sort = ref({ column: 'created_at', direction: 'desc' })

// Pagination
const pagination = reactive({
  page: 1,
  perPage: 10,
  total: 0
})

// Filtres
const filters = reactive({
  type: '',
  period: 'week',
  search: '',
  startDate: '',
  endDate: ''
})

// Options pour les filtres
const activityTypes = [
  { label: 'Nouveaux utilisateurs', value: 'new_user' },
  { label: 'Nouvelles missions', value: 'new_mission' },
  { label: 'Services terminés', value: 'service_completed' },
  { label: 'Paiements', value: 'payment' },
  { label: 'Services créés', value: 'service_created' },
  { label: 'Utilisateurs vérifiés', value: 'user_verified' },
  { label: 'Actions admin', value: 'admin_action' }
]

const periodOptions = [
  { label: 'Aujourd\'hui', value: 'today' },
  { label: 'Hier', value: 'yesterday' },
  { label: '7 derniers jours', value: 'week' },
  { label: '30 derniers jours', value: 'month' },
  { label: 'Période personnalisée', value: 'custom' }
]

// Colonnes de la table
const columns = [
  {
    key: 'type',
    label: 'Type',
    sortable: true
  },
  {
    key: 'title',
    label: 'Titre',
    sortable: true
  },
  {
    key: 'description',
    label: 'Description',
    sortable: false
  },
  {
    key: 'user',
    label: 'Utilisateur',
    sortable: false
  },
  {
    key: 'created_at',
    label: 'Date',
    sortable: true
  },
  {
    key: 'actions',
    label: '',
    sortable: false
  }
]

// Chargement des données
const loadActivities = async () => {
  isLoading.value = true
  try {
    let query = supabase
      .from('activities')
      .select(`
        *,
        user:profiles(*)
      `, { count: 'exact' })
      .order(sort.value.column, { ascending: sort.value.direction === 'asc' })
      .range(
        (pagination.page - 1) * pagination.perPage,
        pagination.page * pagination.perPage - 1
      )

    // Appliquer les filtres
    if (filters.type) {
      query = query.eq('type', filters.type)
    }

    if (filters.search) {
      query = query.or(`title.ilike.%${filters.search}%,description.ilike.%${filters.search}%`)
    }

    const { data, error, count } = await query

    if (error) throw error

    activities.value = data?.map(activity => ({
      ...activity,
      user: activity.user || null
    })) || []
    
    pagination.total = count || 0
  } catch (error) {
    console.error('Error loading activities:', error)
    activities.value = []
    pagination.total = 0
  } finally {
    isLoading.value = false
  }
}

// Helpers
const formatDate = (date) => {
  if (!date) return ''
  try {
    return format(new Date(date), 'dd MMM yyyy HH:mm', { locale: fr })
  } catch (error) {
    console.error('Error formatting date:', error)
    return date
  }
}

const getActivityTypeIcon = (type) => {
  if (!type) return 'i-heroicons-bell'
  const icons = {
    new_user: 'i-heroicons-user-plus',
    new_mission: 'i-heroicons-briefcase',
    service_completed: 'i-heroicons-check-circle',
    payment: 'i-heroicons-currency-euro',
    service_created: 'i-heroicons-plus-circle',
    user_verified: 'i-heroicons-shield-check',
    admin_action: 'i-heroicons-cog'
  }
  return icons[type] || 'i-heroicons-bell'
}

const getActivityTypeClass = (type) => {
  if (!type) return 'bg-gray-100 text-gray-600 dark:bg-gray-800 dark:text-gray-400'
  const classes = {
    new_user: 'bg-blue-100 text-blue-600 dark:bg-blue-900/50 dark:text-blue-400',
    new_mission: 'bg-green-100 text-green-600 dark:bg-green-900/50 dark:text-green-400',
    service_completed: 'bg-purple-100 text-purple-600 dark:bg-purple-900/50 dark:text-purple-400',
    payment: 'bg-yellow-100 text-yellow-600 dark:bg-yellow-900/50 dark:text-yellow-400',
    service_created: 'bg-indigo-100 text-indigo-600 dark:bg-indigo-900/50 dark:text-indigo-400',
    user_verified: 'bg-teal-100 text-teal-600 dark:bg-teal-900/50 dark:text-teal-400',
    admin_action: 'bg-gray-100 text-gray-600 dark:bg-gray-900/50 dark:text-gray-400'
  }
  return classes[type] || 'bg-gray-100 text-gray-600 dark:bg-gray-800 dark:text-gray-400'
}

const formatActivityType = (type) => {
  if (!type) return ''
  const labels = {
    new_user: 'Nouvel utilisateur',
    new_mission: 'Nouvelle mission',
    service_completed: 'Service terminé',
    payment: 'Paiement',
    service_created: 'Service créé',
    user_verified: 'Utilisateur vérifié',
    admin_action: 'Action admin'
  }
  return labels[type] || type
}

const getInitials = (name) => {
  if (!name) return ''
  return name
    .split(' ')
    .map(word => word[0])
    .join('')
    .toUpperCase()
}

// Actions
const updateSort = (newSort) => {
  sort.value = newSort
  loadActivities()
}

const viewActivityDetails = (activity) => {
  selectedActivity.value = activity
  showDetailsModal.value = true
}

const resetFilters = () => {
  Object.assign(filters, {
    type: '',
    period: 'week',
    search: '',
    startDate: '',
    endDate: ''
  })
  loadActivities()
}

const exportActivities = () => {
  // Implémenter l'export
  console.log('Export activities')
}

// Watch pagination changes
watch(() => pagination.page, () => {
  loadActivities()
})

// Initial load
onMounted(() => {
  loadActivities()
})

definePageMeta({
  layout: 'admin'
})
</script> 