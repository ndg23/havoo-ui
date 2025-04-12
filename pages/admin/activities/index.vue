<template>
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
    <!-- En-tête -->
    <div class="mb-8">
      <h1 class="text-2xl font-bold text-gray-900 dark:text-white">Journal d'activités</h1>
      <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
        Suivi des actions effectuées sur la plateforme
      </p>
    </div>

    <!-- Filtres et actions -->
    <div class="mb-6 flex flex-col sm:flex-row gap-4 items-start sm:items-center justify-between">
      <!-- Filtres -->
      <div class="flex flex-wrap gap-3">
        <USelectMenu
          v-model="filters.actionType"
          :options="actionTypes"
          placeholder="Type d'action"
          class="w-40"
        />
        <USelectMenu
          v-model="filters.entityType"
          :options="entityTypes"
          placeholder="Type d'entité"
          class="w-40"
        />
        <UInput
          v-model="filters.search"
          icon="i-heroicons-magnifying-glass"
          placeholder="Rechercher un utilisateur..."
          class="w-64"
        />
      </div>

      <!-- Actions -->
      <div class="flex gap-2">
        <UButton
          icon="i-heroicons-arrow-path"
          :loading="isLoading"
          @click="fetchActivities"
          variant="ghost"
        >
          Actualiser
        </UButton>
      </div>
    </div>

    <!-- Table des activités -->
    <UCard>
      <UTable
        :rows="activities"
        :columns="columns"
        :loading="isLoading"
        :empty-state="{ icon: 'i-heroicons-inbox-stack', text: 'Aucune activité trouvée' }"
      >
        <!-- Utilisateur -->
        <template #user-data="{ row }">
          <div class="flex items-center gap-3">
            <UAvatar
              :src="row.user?.avatar_url"
              :alt="row.user?.first_name"
              size="sm"
            />
            <div class="flex flex-col">
              <span class="font-medium">
                {{ row.user?.first_name }} {{ row.user?.last_name }}
              </span>
              <span class="text-xs text-gray-500">{{ row.user?.email }}</span>
            </div>
          </div>
        </template>

        <!-- Action -->
        <template #action-data="{ row }">
          <div class="flex items-center gap-2">
            <div class="w-8 h-8 rounded-full flex items-center justify-center"
              :class="getActionColor(row.action_type)"
            >
              <UIcon :name="getActionIcon(row.action_type)" class="w-4 h-4 text-white" />
            </div>
            <span>{{ getActionDescription(row) }}</span>
          </div>
        </template>

        <!-- Entité -->
        <template #entity-data="{ row }">
          <UBadge
            :color="getEntityColor(row.entity_type)"
            class="rounded-full"
          >
            {{ formatEntityType(row.entity_type) }}
          </UBadge>
        </template>

        <!-- Statut -->
        <template #status-data="{ row }">
          <UBadge
            v-if="row.details?.status"
            variant="subtle"
            class="rounded-full"
          >
            {{ formatStatus(row.details.status) }}
          </UBadge>
        </template>

        <!-- Date -->
        <template #date-data="{ row }">
          {{ formatDate(row.created_at) }}
        </template>

        <!-- Actions -->
        <template #actions-data="{ row }">
          <UDropdown :items="getActionItems(row)">
            <UButton
              color="gray"
              variant="ghost"
              icon="i-heroicons-ellipsis-horizontal"
              class="h-8 w-8 p-0"
            />
          </UDropdown>
        </template>
      </UTable>

      <!-- Pagination -->
      <div class="mt-4 flex items-center justify-between">
        <p class="text-sm text-gray-500 dark:text-gray-400">
          {{ paginationText }}
        </p>
        <UPagination
          v-model="currentPage"
          :total="totalPages"
          :ui="{ rounded: 'rounded-full' }"
        />
      </div>
    </UCard>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useSupabaseClient } from '#imports'
import { format } from 'date-fns'
import { fr } from 'date-fns/locale'

const supabase = useSupabaseClient()

// États
const activities = ref([])
const isLoading = ref(true)
const currentPage = ref(1)
const itemsPerPage = 10
const totalItems = ref(0)

const filters = ref({
  actionType: null,
  entityType: null,
  search: ''
})

// Options de filtres
const actionTypes = [
  { label: 'Toutes les actions', value: null },
  { label: 'Création', value: 'create' },
  { label: 'Modification', value: 'update' },
  { label: 'Suppression', value: 'delete' }
]

const entityTypes = [
  { label: 'Toutes les entités', value: null },
  { label: 'Proposition', value: 'deal' },
  { label: 'Mission', value: 'mission' },
  { label: 'Utilisateur', value: 'user' }
]

// Colonnes de la table
const columns = [
  {
    key: 'user',
    label: 'Utilisateur',
    sortable: true
  },
  {
    key: 'action',
    label: 'Action',
    sortable: true
  },
  {
    key: 'entity',
    label: 'Entité',
    sortable: true
  },
  {
    key: 'status',
    label: 'Statut',
    sortable: true
  },
  {
    key: 'date',
    label: 'Date',
    sortable: true
  },
  {
    key: 'actions',
    label: '',
    sortable: false
  }
]

// Actions du menu contextuel
const getActionItems = (activity) => [
  [
    {
      label: 'Voir les détails',
      icon: 'i-heroicons-eye',
      click: () => viewDetails(activity)
    }
  ],
  [
    {
      label: 'Supprimer',
      icon: 'i-heroicons-trash',
      click: () => deleteActivity(activity.id),
      class: 'text-red-500'
    }
  ]
]

// Helpers
const getActionColor = (type) => {
  const colors = {
    create: 'bg-green-500',
    update: 'bg-blue-500',
    delete: 'bg-red-500'
  }
  return colors[type] || 'bg-gray-500'
}

const getActionIcon = (type) => {
  const icons = {
    create: 'i-heroicons-plus',
    update: 'i-heroicons-pencil',
    delete: 'i-heroicons-trash'
  }
  return icons[type] || 'i-heroicons-question-mark-circle'
}

const getEntityColor = (type) => {
  const colors = {
    deal: 'blue',
    mission: 'purple',
    user: 'orange'
  }
  return colors[type] || 'gray'
}

const formatEntityType = (type) => {
  const labels = {
    deal: 'Proposition',
    mission: 'Mission',
    user: 'Utilisateur'
  }
  return labels[type] || type
}

const formatStatus = (status) => {
  const labels = {
    active: 'Actif',
    pending: 'En attente',
    completed: 'Terminé',
    cancelled: 'Annulé'
  }
  return labels[status] || status
}

const getActionDescription = (activity) => {
  const actionLabels = {
    create: 'a créé',
    update: 'a modifié',
    delete: 'a supprimé'
  }
  const entityLabels = {
    deal: 'une proposition',
    mission: 'une mission',
    user: 'un utilisateur'
  }
  
  return `${actionLabels[activity.action_type] || 'a effectué une action sur'} ${entityLabels[activity.entity_type] || 'une entité'}`
}

const formatDate = (date) => {
  return format(new Date(date), 'dd MMM yyyy à HH:mm', { locale: fr })
}

// Pagination
const totalPages = computed(() => Math.ceil(totalItems.value / itemsPerPage))
const paginationText = computed(() => {
  const start = (currentPage.value - 1) * itemsPerPage + 1
  const end = Math.min(start + itemsPerPage - 1, totalItems.value)
  return `${start}-${end} sur ${totalItems.value} activités`
})

// Chargement des données
const fetchActivities = async () => {
  try {
    isLoading.value = true
    
    let query = supabase
      .from('activities')
      .select(`
        *,
        user:profiles(*)
      `, { count: 'exact' })

    // Appliquer les filtres
    if (filters.value.actionType) {
      query = query.eq('action_type', filters.value.actionType)
    }
    if (filters.value.entityType) {
      query = query.eq('entity_type', filters.value.entityType)
    }
    if (filters.value.search) {
      query = query.or(`user.first_name.ilike.%${filters.value.search}%,user.last_name.ilike.%${filters.value.search}%`)
    }

    // Pagination
    const from = (currentPage.value - 1) * itemsPerPage
    const to = from + itemsPerPage - 1
    
    const { data, count, error } = await query
      .range(from, to)
      .order('created_at', { ascending: false })

    if (error) throw error

    activities.value = data
    totalItems.value = count || 0
  } catch (error) {
    console.error('Erreur:', error)
  } finally {
    isLoading.value = false
  }
}

// Watch pour les changements de filtres et pagination
watch([currentPage, filters], () => {
  fetchActivities()
}, { deep: true })

// Initialisation
onMounted(() => {
  fetchActivities()
})

definePageMeta({
  layout: 'admin'
})
</script> 