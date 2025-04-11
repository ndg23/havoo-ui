<template>
  <div>
    <!-- En-tête de la page -->
    <div class="mb-8">
      <h1 class="text-2xl font-bold">Gestion des propositions</h1>
      <p class="mt-1 text-gray-500 dark:text-gray-400">
        Suivez toutes les propositions faites par les experts
      </p>
    </div>

    <!-- Filtres et actions -->
    <div class="mb-6 flex flex-col sm:flex-row gap-4 items-start sm:items-center justify-between">
      <!-- Filtres -->
      <div class="flex flex-wrap gap-3">
        <USelectMenu
          v-model="filters.status"
          :options="statusOptions"
          placeholder="Statut"
          class="w-40"
        />
        <UInput
          v-model="filters.search"
          icon="i-heroicons-magnifying-glass"
          placeholder="Rechercher un expert..."
          class="w-full sm:w-64"
        />
      </div>

      <!-- Actions -->
      <div class="flex gap-2">
        <UButton
          icon="i-heroicons-arrow-path"
          :loading="isLoading"
          @click="refreshData"
          variant="ghost"
        >
          Actualiser
        </UButton>
        <UButton
          icon="i-heroicons-funnel"
          :variant="hasFilters ? 'soft' : 'ghost'"
          @click="resetFilters"
        >
          Filtres {{ filtersCount }}
        </UButton>
      </div>
    </div>

    <!-- Table des propositions -->
    <UCard>
      <UTable
        :rows="deals"
        :columns="columns"
        :loading="isLoading"
        :empty-state="{ icon: 'i-heroicons-inbox-stack', text: 'Aucune proposition trouvée' }"
      >
        <!-- Expert column -->
        <template #expert-data="{ row }">
          <div class="flex items-center gap-2">
            <UAvatar
              :src="row.expert?.avatar_url"
              :alt="row.expert?.name"
              size="sm"
            />
            <div class="flex flex-col">
              <span class="font-medium">{{ row.expert?.name }}</span>
              <span class="text-xs text-gray-500">{{ row.expert?.profession }}</span>
            </div>
          </div>
        </template>

        <!-- Mission column -->
        <template #mission-data="{ row }">
          <div class="flex flex-col">
            <span class="font-medium">{{ row.mission?.title }}</span>
            <span class="text-xs text-gray-500">{{ row.mission?.client?.name }}</span>
          </div>
        </template>

        <!-- Price column -->
        <template #price-data="{ row }">
          <span class="font-medium">{{ formatPrice(row.price) }}</span>
        </template>

        <!-- Status column -->
        <template #status-data="{ row }">
          <UBadge :color="getStatusColor(row.status)" size="sm">
            {{ getStatusLabel(row.status) }}
          </UBadge>
        </template>

        <!-- Date column -->
        <template #created_at-data="{ row }">
          {{ formatDate(row.created_at) }}
        </template>

        <!-- Actions column -->
        <template #actions-data="{ row }">
          <UDropdown :items="getActionItems(row)" :ui="dropdownUI">
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
import { ref, computed, onMounted } from 'vue'
import { useSupabaseClient } from '#imports'
import { format } from 'date-fns'
import { fr } from 'date-fns/locale'

const supabase = useSupabaseClient()

// États
const deals = ref([])
const isLoading = ref(true)
const currentPage = ref(1)
const itemsPerPage = 10
const totalItems = ref(0)
const filters = ref({
  status: null,
  search: ''
})

// Options de statut
const statusOptions = [
  { label: 'Tous les statuts', value: null },
  { label: 'Proposition', value: 'proposal' },
  { label: 'Acceptée', value: 'accepted' },
  { label: 'Refusée', value: 'rejected' },
  { label: 'Annulée', value: 'cancelled' }
]

// Colonnes de la table
const columns = [
  {
    key: 'expert',
    label: 'Expert',
    sortable: true
  },
  {
    key: 'mission',
    label: 'Mission',
    sortable: true
  },
  {
    key: 'price',
    label: 'Prix',
    sortable: true
  },
  {
    key: 'status',
    label: 'Statut',
    sortable: true
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

// Style du dropdown
const dropdownUI = {
  container: 'relative',
  trigger: 'flex',
  width: 'w-48',
  background: 'bg-white dark:bg-gray-800',
  rounded: 'rounded-lg',
  shadow: 'shadow-lg',
  ring: 'ring-1 ring-gray-200 dark:ring-gray-700',
  base: 'relative overflow-hidden',
  item: {
    base: 'group relative flex items-center gap-2 w-full px-4 py-2.5 text-sm transition-colors hover:bg-gray-100 dark:hover:bg-gray-700/50 focus:outline-none focus:bg-gray-100 dark:focus:bg-gray-700/50',
    active: 'bg-gray-100 dark:bg-gray-700/50',
    inactive: '',
    icon: {
      base: 'flex-shrink-0 w-4 h-4 text-gray-500 dark:text-gray-400',
      active: 'text-primary-500 dark:text-primary-400',
    },
    label: 'truncate',
    disabled: 'opacity-50 cursor-not-allowed',
  }
}

// Computed properties
const totalPages = computed(() => Math.ceil(totalItems.value / itemsPerPage))
const paginationText = computed(() => {
  const start = (currentPage.value - 1) * itemsPerPage + 1
  const end = Math.min(start + itemsPerPage - 1, totalItems.value)
  return `${start}-${end} sur ${totalItems.value} propositions`
})
const hasFilters = computed(() => filters.value.status || filters.value.search)
const filtersCount = computed(() => {
  let count = 0
  if (filters.value.status) count++
  if (filters.value.search) count++
  return count ? `(${count})` : ''
})

// Méthodes
const fetchDeals = async () => {
  try {
    isLoading.value = true
    
    let query = supabase
      .from('deals')
      .select(`
        *,
        expert:profiles!deals_expert_id_fkey (
          id,
          first_name,
          last_name,
          avatar_url,
          profession_id
        ),
        mission:missions!deals_mission_id_fkey (
          id,
          title,
          client:profiles!missions_client_id_fkey (
            first_name,
            last_name
          )
        )
      `, { count: 'exact' })

    if (filters.value.status) {
      query = query.eq('status', filters.value.status)
    }
    
    if (filters.value.search) {
      const searchTerm = `%${filters.value.search}%`
      query = query.or(`expert.first_name.ilike.${searchTerm},expert.last_name.ilike.${searchTerm}`)
    }

    const { data, count, error } = await query
      .range((currentPage.value - 1) * itemsPerPage, (currentPage.value * itemsPerPage) - 1)
      .order('created_at', { ascending: false })

    if (error) throw error

    // Faire une deuxième requête pour obtenir les professions
    const professionIds = data?.map(deal => deal.expert?.profession_id).filter(Boolean) || []
    let professions = {}
    
    if (professionIds.length > 0) {
      const { data: professionsData } = await supabase
        .from('professions')
        .select('id, name')
        .in('id', professionIds)

      professions = Object.fromEntries(
        professionsData?.map(p => [p.id, p.name]) || []
      )
    }

    deals.value = data?.map(deal => ({
      ...deal,
      expert: {
        name: `${deal.expert?.first_name || ''} ${deal.expert?.last_name || ''}`.trim(),
        avatar_url: deal.expert?.avatar_url,
        profession: professions[deal.expert?.profession_id] || 'Non renseigné'
      },
      mission: {
        title: deal.mission?.title,
        client: {
          name: `${deal.mission?.client?.first_name || ''} ${deal.mission?.client?.last_name || ''}`.trim()
        }
      }
    })) || []

    totalItems.value = count || 0

  } catch (error) {
    console.error('Erreur:', error)
    deals.value = []
  } finally {
    isLoading.value = false
  }
}

const refreshData = () => {
  fetchDeals()
}

const resetFilters = () => {
  filters.value = {
    status: null,
    search: ''
  }
  currentPage.value = 1
  fetchDeals()
}

const getStatusColor = (status) => {
  const colors = {
    proposal: 'yellow',
    accepted: 'green',
    rejected: 'red',
    cancelled: 'gray'
  }
  return colors[status] || 'gray'
}

const getStatusLabel = (status) => {
  const labels = {
    proposal: 'Proposition',
    accepted: 'Acceptée',
    rejected: 'Refusée',
    cancelled: 'Annulée'
  }
  return labels[status] || status
}

const formatDate = (date) => {
  return format(new Date(date), 'dd MMM yyyy', { locale: fr })
}

const formatPrice = (price) => {
  return new Intl.NumberFormat('fr-FR', {
    style: 'currency',
    currency: 'XOF'
  }).format(price)
}

const getActionItems = (deal) => [
  {
    label: 'Voir les détails',
    icon: 'i-heroicons-eye',
    click: () => navigateToDeal(deal.id),
    class: 'hover:text-blue-500'
  },
  {
    label: 'Voir la mission',
    icon: 'i-heroicons-document-text',
    click: () => navigateToMission(deal.mission_id),
    class: 'hover:text-blue-500'
  },
  {
    label: 'Voir l\'expert',
    icon: 'i-heroicons-user',
    click: () => navigateToExpert(deal.expert_id),
    class: 'hover:text-blue-500'
  },
  {
    type: 'divider'
  },
  {
    label: deal.status === 'cancelled' ? 'Réactiver' : 'Annuler',
    icon: deal.status === 'cancelled' ? 'i-heroicons-arrow-path' : 'i-heroicons-x-circle',
    click: () => toggleDealStatus(deal),
    class: deal.status === 'cancelled' ? 'hover:text-green-500' : 'hover:text-red-500'
  }
]

const navigateToDeal = (id) => {
  navigateTo(`/admin/deals/${id}`)
}

const navigateToMission = (id) => {
  navigateTo(`/admin/missions/${id}`)
}

const navigateToExpert = (id) => {
  navigateTo(`/admin/experts/${id}`)
}

const toggleDealStatus = async (deal) => {
  try {
    const newStatus = deal.status === 'cancelled' ? 'proposal' : 'cancelled'
    const { error } = await supabase
      .from('deals')
      .update({ status: newStatus })
      .eq('id', deal.id)

    if (error) throw error

    refreshData()
  } catch (error) {
    console.error('Erreur lors de la mise à jour du statut:', error)
  }
}

// Watchers
watch([currentPage, filters], () => {
  fetchDeals()
}, { deep: true })

// Initialisation
onMounted(() => {
  fetchDeals()
})

definePageMeta({
  layout: 'admin'
})
</script>
