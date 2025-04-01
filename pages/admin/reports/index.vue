<template>
  <div class="space-y-6 p-4 sm:p-6 lg:p-8">
    <!-- Header -->
    <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
      <div>
        <h1 class="text-2xl font-bold text-gray-900 dark:text-white">Signalements</h1>
        <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
          Gestion des signalements d'utilisateurs et de missions
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
        <USelect
          v-model="filters.status"
          :options="statusOptions"
          option-attribute="label"
          value-attribute="value"
          class="w-40"
        />
      </div>
    </div>

    <!-- Filtres -->
    <UCard v-if="showFilters">
      <div class="grid gap-6 sm:grid-cols-2 lg:grid-cols-4">
        <!-- Type de signalement -->
        <USelect
          v-model="filters.type"
          :options="reportTypes"
          option-attribute="label"
          value-attribute="value"
          placeholder="Tous les types"
          class="w-full"
          icon="i-heroicons-flag"
          clearable
        />

        <!-- Raison -->
        <USelect
          v-model="filters.reason"
          :options="reasonOptions"
          option-attribute="label"
          value-attribute="value"
          placeholder="Toutes les raisons"
          class="w-full"
          icon="i-heroicons-exclamation-triangle"
          clearable
        />

        <!-- Dates -->
        <UInput
          v-model="filters.startDate"
          type="date"
          icon="i-heroicons-calendar"
          class="w-full"
        />
        <UInput
          v-model="filters.endDate"
          type="date"
          icon="i-heroicons-calendar"
          class="w-full"
        />
      </div>

      <div class="flex justify-end gap-3 mt-6">
        <UButton
          color="gray"
          variant="ghost"
          label="Réinitialiser"
          icon="i-heroicons-arrow-path"
          @click="resetFilters"
        />
        <UButton
          color="primary"
          label="Appliquer"
          icon="i-heroicons-check"
          @click="loadReports"
        />
      </div>
    </UCard>

    <!-- Table -->
    <UCard>
      <UTable
        :rows="reports"
        :columns="columns"
        :loading="isLoading"
        :sort="sort"
        @update:sort="updateSort"
      >
        <!-- Status -->
        <template #status-data="{ row }">
          <UBadge
            :color="getStatusColor(row.status)"
            :label="formatStatus(row.status)"
            variant="subtle"
            size="sm"
          />
        </template>

        <!-- Type -->
        <template #type-data="{ row }">
          <div class="flex items-center gap-2">
            <UIcon
              :name="row.report_type === 'user' ? 'i-heroicons-user' : 'i-heroicons-briefcase'"
              class="h-4 w-4"
            />
            {{ row.report_type === 'user' ? 'Utilisateur' : 'Mission' }}
          </div>
        </template>

        <!-- Reported Item -->
        <template #reported-item-data="{ row }">
          <div class="flex items-center gap-2">
            <UAvatar
              v-if="row.report_type === 'user'"
              :src="row.reported_user?.avatar_url"
              :alt="row.reported_user?.first_name"
              :text="getInitials(row.reported_user?.first_name, row.reported_user?.last_name)"
              size="sm"
            />
            <div>
              <div class="font-medium text-gray-900 dark:text-white">
                {{ getReportedItemTitle(row) }}
              </div>
              <div class="text-xs text-gray-500">
                {{ getReportedItemSubtitle(row) }}
              </div>
            </div>
          </div>
        </template>

        <!-- Reporter -->
        <template #reporter-data="{ row }">
          <div class="flex items-center gap-2">
            <UAvatar
              :src="row.reporter?.avatar_url"
              :alt="row.reporter?.first_name"
              :text="getInitials(row.reporter?.first_name, row.reporter?.last_name)"
              size="sm"
            />
            <div>
              <div class="font-medium text-gray-900 dark:text-white">
                {{ `${row.reporter?.first_name} ${row.reporter?.last_name}` }}
              </div>
              <div class="text-xs text-gray-500">
                {{ formatDate(row.created_at) }}
              </div>
            </div>
          </div>
        </template>

        <!-- Reason -->
        <template #reason-data="{ row }">
          <div class="max-w-md">
            <div class="font-medium text-gray-900 dark:text-white">
              {{ formatReason(row.reason) }}
            </div>
            <div v-if="row.description" class="text-sm text-gray-500 truncate">
              {{ row.description }}
            </div>
          </div>
        </template>

        <!-- Actions -->
        <template #actions-data="{ row }">
          <div class="flex items-center gap-2">
            <UButton
              v-if="row.status === 'pending'"
              color="primary"
              variant="ghost"
              icon="i-heroicons-eye"
              class="h-8 w-8"
              @click="viewReport(row)"
            />
            <UButton
              v-if="row.status === 'pending'"
              color="green"
              variant="ghost"
              icon="i-heroicons-check"
              class="h-8 w-8"
              @click="resolveReport(row)"
            />
            <UButton
              v-if="row.status === 'pending'"
              color="red"
              variant="ghost"
              icon="i-heroicons-x-mark"
              class="h-8 w-8"
              @click="dismissReport(row)"
            />
          </div>
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
    <UModal v-model="showReportModal">
      <UCard>
        <template #header>
          <div class="flex items-center gap-2">
            <UIcon name="i-heroicons-flag" class="h-5 w-5" />
            <h3 class="text-lg font-semibold">Détails du signalement</h3>
          </div>
        </template>

        <div v-if="selectedReport" class="space-y-6">
          <!-- Contenu détaillé du signalement -->
          <div class="space-y-4">
            <div>
              <div class="text-sm font-medium text-gray-500">Type</div>
              <div class="mt-1">{{ selectedReport.report_type === 'user' ? 'Utilisateur' : 'Mission' }}</div>
            </div>

            <div>
              <div class="text-sm font-medium text-gray-500">Raison</div>
              <div class="mt-1">{{ formatReason(selectedReport.reason) }}</div>
            </div>

            <div>
              <div class="text-sm font-medium text-gray-500">Description</div>
              <div class="mt-1">{{ selectedReport.description || 'Aucune description fournie' }}</div>
            </div>

            <div>
              <div class="text-sm font-medium text-gray-500">Notes administrateur</div>
              <textarea
                v-model="adminNotes"
                rows="3"
                class="mt-1 w-full rounded-lg border border-gray-300 dark:border-gray-700 p-2"
                placeholder="Ajouter des notes..."
              ></textarea>
            </div>
          </div>
        </div>

        <template #footer>
          <div class="flex justify-end gap-3">
            <UButton
              color="gray"
              variant="ghost"
              label="Fermer"
              @click="showReportModal = false"
            />
            <UButton
              color="green"
              label="Résoudre"
              icon="i-heroicons-check"
              @click="resolveReport(selectedReport)"
            />
            <UButton
              color="red"
              label="Rejeter"
              icon="i-heroicons-x-mark"
              @click="dismissReport(selectedReport)"
            />
          </div>
        </template>
      </UCard>
    </UModal>
  </div>
</template>

<script setup>
import { useDateFormat } from '@vueuse/core'
import { fr } from 'date-fns/locale'

const supabase = useSupabaseClient()
const { format } = useDateFormat()

// États
const reports = ref([])
const isLoading = ref(true)
const showFilters = ref(false)
const showReportModal = ref(false)
const selectedReport = ref(null)
const adminNotes = ref('')

// Pagination
const pagination = ref({
  page: 1,
  perPage: 10,
  total: 0
})

// Filtres
const filters = ref({
  status: 'pending',
  type: '',
  reason: '',
  startDate: '',
  endDate: ''
})

// Options
const statusOptions = [
  { label: 'En attente', value: 'pending' },
  { label: 'En cours', value: 'investigating' },
  { label: 'Résolus', value: 'resolved' },
  { label: 'Rejetés', value: 'dismissed' }
]

const reportTypes = [
  { label: 'Utilisateurs', value: 'user' },
  { label: 'Missions', value: 'mission' }
]

const reasonOptions = [
  { label: 'Faux profil', value: 'fake_profile' },
  { label: 'Comportement inapproprié', value: 'inappropriate_behavior' },
  { label: 'Tentative d\'arnaque', value: 'scam' },
  { label: 'Contenu inapproprié', value: 'inappropriate_content' },
  { label: 'Mission suspecte', value: 'suspicious_mission' },
  { label: 'Mauvaise catégorie', value: 'wrong_category' },
  { label: 'Spam', value: 'spam' },
  { label: 'Autre', value: 'other' }
]

// Colonnes
const columns = [
  {
    key: 'status',
    label: 'Statut',
    sortable: true
  },
  {
    key: 'type',
    label: 'Type',
    sortable: true
  },
  {
    key: 'reported-item',
    label: 'Élément signalé',
    sortable: false
  },
  {
    key: 'reporter',
    label: 'Signalé par',
    sortable: false
  },
  {
    key: 'reason',
    label: 'Raison',
    sortable: true
  },
  {
    key: 'actions',
    label: '',
    sortable: false
  }
]

// Tri
const sort = ref({
  column: 'created_at',
  direction: 'desc'
})

// Chargement des données
const loadReports = async () => {
  isLoading.value = true
  try {
    let query = supabase
      .from('reports')
      .select(`
        *,
        reported_user:reported_user_id(id, first_name, last_name, avatar_url),
        reported_mission:reported_mission_id(*),
        reporter:reporter_id(id, first_name, last_name, avatar_url)
      `, { count: 'exact' })
      .eq('status', filters.value.status)
      .order(sort.value.column, { ascending: sort.value.direction === 'asc' })
      .range(
        (pagination.value.page - 1) * pagination.value.perPage,
        pagination.value.page * pagination.value.perPage - 1
      )

    // Appliquer les filtres
    if (filters.value.type) {
      query = query.eq('report_type', filters.value.type)
    }
    if (filters.value.reason) {
      query = query.eq('reason', filters.value.reason)
    }
    if (filters.value.startDate) {
      query = query.gte('created_at', filters.value.startDate)
    }
    if (filters.value.endDate) {
      query = query.lte('created_at', filters.value.endDate)
    }

    const { data, error, count } = await query

    if (error) throw error

    reports.value = data || []
    pagination.value.total = count || 0
  } catch (error) {
    console.error('Error loading reports:', error)
    const toast = useToast()
    toast.add({
      title: 'Erreur',
      description: 'Impossible de charger les signalements',
      color: 'red'
    })
  } finally {
    isLoading.value = false
  }
}

// Actions
const viewReport = (report) => {
  selectedReport.value = report
  adminNotes.value = report.admin_notes || ''
  showReportModal.value = true
}

const resolveReport = async (report) => {
  try {
    const { error } = await supabase
      .from('reports')
      .update({
        status: 'resolved',
        admin_notes: adminNotes.value,
        resolved_at: new Date().toISOString()
      })
      .eq('id', report.id)

    if (error) throw error

    showReportModal.value = false
    loadReports()

    const toast = useToast()
    toast.add({
      title: 'Succès',
      description: 'Le signalement a été résolu',
      color: 'green'
    })
  } catch (error) {
    console.error('Error resolving report:', error)
    const toast = useToast()
    toast.add({
      title: 'Erreur',
      description: 'Impossible de résoudre le signalement',
      color: 'red'
    })
  }
}

const dismissReport = async (report) => {
  try {
    const { error } = await supabase
      .from('reports')
      .update({
        status: 'dismissed',
        admin_notes: adminNotes.value,
        resolved_at: new Date().toISOString()
      })
      .eq('id', report.id)

    if (error) throw error

    showReportModal.value = false
    loadReports()

    const toast = useToast()
    toast.add({
      title: 'Succès',
      description: 'Le signalement a été rejeté',
      color: 'green'
    })
  } catch (error) {
    console.error('Error dismissing report:', error)
    const toast = useToast()
    toast.add({
      title: 'Erreur',
      description: 'Impossible de rejeter le signalement',
      color: 'red'
    })
  }
}

// Helpers
const getStatusColor = (status) => {
  const colors = {
    pending: 'yellow',
    investigating: 'blue',
    resolved: 'green',
    dismissed: 'gray'
  }
  return colors[status] || 'gray'
}

const formatStatus = (status) => {
  const labels = {
    pending: 'En attente',
    investigating: 'En cours',
    resolved: 'Résolu',
    dismissed: 'Rejeté'
  }
  return labels[status] || status
}

const formatReason = (reason) => {
  const found = reasonOptions.find(option => option.value === reason)
  return found ? found.label : reason
}

const getReportedItemTitle = (report) => {
  if (report.report_type === 'user') {
    return `${report.reported_user?.first_name} ${report.reported_user?.last_name}`
  }
  return report.reported_mission?.title || 'Mission'
}

const getReportedItemSubtitle = (report) => {
  if (report.report_type === 'user') {
    return 'Utilisateur'
  }
  return `Mission #${report.reported_mission?.id.slice(0, 8)}`
}

const getInitials = (firstName = '', lastName = '') => {
  return `${firstName.charAt(0)}${lastName.charAt(0)}`.toUpperCase()
}

const formatDate = (date) => {
  if (!date) return ''
  try {
    return format(new Date(date), 'dd MMM yyyy HH:mm', { locale: fr })
  } catch (error) {
    console.error('Error formatting date:', error)
    return date
  }
}

const resetFilters = () => {
  filters.value = {
    status: 'pending',
    type: '',
    reason: '',
    startDate: '',
    endDate: ''
  }
  loadReports()
}

// Watchers
watch(() => pagination.value.page, loadReports)
watch(() => filters.value.status, loadReports)

// Initial load
onMounted(() => {
  loadReports()
})

definePageMeta({
  layout: 'admin'
})
</script>
