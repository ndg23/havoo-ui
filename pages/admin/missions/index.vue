<template>
    <div class="space-y-6 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      <!-- Header -->
      <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
        <div>
          <h1 class="text-3xl font-bold text-gray-900 dark:text-white tracking-tight">Missions</h1>
          <p class="text-gray-600 dark:text-gray-400 mt-1">Gérez les missions de la plateforme</p>
        </div>
        
        <div class="flex items-center gap-3">
          <UButton 
            icon="i-heroicons-arrow-path" 
            color="gray" 
            variant="ghost" 
            :loading="isLoading"
            @click="loadData"
          >
            Actualiser
          </UButton>
          <UButton 
            icon="i-heroicons-plus" 
            @click="openModal()"
          >
            Ajouter
          </UButton>
        </div>
      </div>
  
      <!-- Filters -->
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
          placeholder="Rechercher..."
          class="w-full sm:w-64"
        />
      </div>
  
      <!-- Table -->
      <UCard>
        <UTable
          :rows="paginatedMissions"
          :columns="columns"
          :loading="isLoading"
        >
          <!-- Mission cell -->
          <template #mission-data="{ row }">
            <div class="flex items-center gap-3">
              <div class="h-10 w-10 rounded-lg bg-primary-100 dark:bg-primary-900/30 flex items-center justify-center text-primary-700 dark:text-primary-400">
                <UIcon :name="row.icon || 'i-heroicons-briefcase'" class="h-5 w-5" />
              </div>
              <div>
                <p class="text-sm font-medium text-gray-900 dark:text-white">
                  {{ row.title }}
                </p>
                <p class="text-xs text-gray-500 dark:text-gray-400">
                  {{ row.reference }}
                </p>
              </div>
            </div>
          </template>
  
          <!-- Client cell -->
          <template #client-data="{ row }">
            <div class="flex items-center gap-2">
              <UAvatar
                :src="row.client?.avatar_url"
                :text="getInitials(row.client?.company_name || '')"
                size="sm"
              />
              <span class="text-sm text-gray-900 dark:text-white">
                {{ row.client?.company_name }}
              </span>
            </div>
          </template>
  
          <!-- Budget cell -->
          <template #budget-data="{ row }">
            <span class="text-sm font-medium">
              {{ formatPrice(row.budget) }}
            </span>
          </template>
  
          <!-- Status cell -->
          <template #status-data="{ row }">
            <UBadge
              :color="getStatusColor(row.status)"
              variant="subtle"
              size="sm"
            >
              <div class="flex items-center gap-1">
                <div 
                  class="w-1.5 h-1.5 rounded-full"
                  :class="getStatusDotColor(row.status)"
                />
                {{ formatStatus(row.status) }}
              </div>
            </UBadge>
          </template>
  
          <!-- Actions cell -->
          <template #actions-data="{ row }">
            <UDropdown
              :items="[
                [
                  {
                    label: 'Voir les détails',
                    icon: 'i-heroicons-eye',
                    click: () => navigateToMission(row.id)
                  },
                  {
                    label: 'Modifier',
                    icon: 'i-heroicons-pencil-square',
                    click: () => openModal(row)
                  }
                ],
                [
                  {
                    label: getNextStatusLabel(row.status),
                    icon: getNextStatusIcon(row.status),
                    click: () => updateStatus(row),
                    disabled: !canUpdateStatus(row.status)
                  }
                ],
                [
                  {
                    label: row.is_active ? 'Archiver' : 'Désarchiver',
                    icon: row.is_active ? 'i-heroicons-archive-box' : 'i-heroicons-archive-box-arrow-down',
                    click: () => toggleArchive(row)
                  }
                ]
              ]"
            >
              <UButton
                color="gray"
                variant="ghost"
                icon="i-heroicons-ellipsis-horizontal"
              />
            </UDropdown>
          </template>
        </UTable>
  
        <!-- Pagination -->
        <div class="mt-4 flex items-center justify-between">
          <p class="text-sm text-gray-700">
            Affichage de
            <span class="font-medium">{{ startIndex + 1 }}</span>
            à
            <span class="font-medium">{{ endIndex }}</span>
            sur
            <span class="font-medium">{{ totalItems }}</span>
            résultats
          </p>
          <UPagination
            v-model="currentPage"
            :total="totalPages"
            :ui="{ rounded: 'rounded-full' }"
          />
        </div>
      </UCard>
    </div>
  
    <!-- Modal -->
    <TransitionRoot appear :show="showModal" as="template">
      <Dialog as="div" @close="showModal = false" class="relative z-50">
        <TransitionChild
          enter="duration-300 ease-out"
          enter-from="opacity-0"
          enter-to="opacity-100"
          leave="duration-200 ease-in"
          leave-from="opacity-100"
          leave-to="opacity-0"
        >
          <div class="fixed inset-0 bg-black/30" />
        </TransitionChild>
  
        <div class="fixed inset-0 overflow-y-auto">
          <div class="flex min-h-full items-center justify-center p-4">
            <TransitionChild
              enter="duration-300 ease-out"
              enter-from="opacity-0 scale-95"
              enter-to="opacity-100 scale-100"
              leave="duration-200 ease-in"
              leave-from="opacity-100 scale-100"
              leave-to="opacity-0 scale-95"
            >
              <DialogPanel class="w-full max-w-2xl transform overflow-hidden rounded-3xl bg-white p-8 border border-gray-100 shadow-xl transition-all">
                <DialogTitle as="h3" class="text-xl font-semibold text-gray-900">
                  {{ editMode ? 'Modifier la mission' : 'Ajouter une mission' }}
                </DialogTitle>
  
                <form @submit.prevent="saveMission" class="mt-8">
                  <div class="space-y-8">
                    <!-- Titre -->
                    <div>
                      <label class="block text-base font-semibold text-gray-900 mb-2">
                        Titre
                      </label>
                      <input
                        v-model="form.title"
                        type="text"
                        required
                        class="block w-full px-4 py-3.5 text-gray-900 border border-gray-200 rounded-2xl 
                          focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors text-lg"
                        placeholder="ex: Développement d'une application mobile"
                      />
                      <p class="mt-2 text-sm text-gray-500">
                        Le titre de la mission
                      </p>
                    </div>
  
                    <!-- Description -->
                    <div>
                      <label class="block text-base font-semibold text-gray-900 mb-2">
                        Description
                      </label>
                      <textarea
                        v-model="form.description"
                        rows="4"
                        class="block w-full px-4 py-3.5 text-gray-900 border border-gray-200 rounded-2xl 
                          focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors text-lg"
                        placeholder="Description détaillée de la mission..."
                      />
                      <p class="mt-2 text-sm text-gray-500">
                        Une description détaillée de la mission
                      </p>
                    </div>
  
                    <!-- Client -->
                    <div>
                      <label class="block text-base font-semibold text-gray-900 mb-2">
                        Client
                      </label>
                      <select
                        v-model="form.client_id"
                        required
                        class="block w-full px-4 py-3.5 text-gray-900 border border-gray-200 rounded-2xl 
                          focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors text-lg"
                      >
                        <option value="">Sélectionnez un client</option>
                        <option v-for="client in clients" :key="client.id" :value="client.id">
                          {{ client.company_name }}
                        </option>
                      </select>
                      <p class="mt-2 text-sm text-gray-500">
                        Le client associé à cette mission
                      </p>
                    </div>
  
                    <!-- Budget -->
                    <div>
                      <label class="block text-base font-semibold text-gray-900 mb-2">
                        Budget
                      </label>
                      <div class="relative">
                        <input
                          v-model="form.budget"
                          type="number"
                          min="0"
                          step="100"
                          required
                          class="block w-full px-4 py-3.5 pl-12 text-gray-900 border border-gray-200 rounded-2xl 
                            focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors text-lg"
                        />
                        <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                          <span class="text-gray-500">€</span>
                        </div>
                      </div>
                      <p class="mt-2 text-sm text-gray-500">
                        Le budget alloué à la mission
                      </p>
                    </div>
  
                    <!-- Statut -->
                    <div>
                      <label class="block text-base font-semibold text-gray-900 mb-2">
                        Statut
                      </label>
                      <select
                        v-model="form.status"
                        required
                        class="block w-full px-4 py-3.5 text-gray-900 border border-gray-200 rounded-2xl 
                          focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors text-lg"
                      >
                        <option v-for="status in statuses" :key="status.value" :value="status.value">
                          {{ status.label }}
                        </option>
                      </select>
                      <p class="mt-2 text-sm text-gray-500">
                        Le statut actuel de la mission
                      </p>
                    </div>
                  </div>
  
                  <div class="mt-8 flex justify-end space-x-4">
                    <button
                      type="button"
                      class="px-6 py-4 text-base font-semibold text-gray-700 hover:bg-gray-50 
                        rounded-2xl focus:outline-none focus:ring-2 focus:ring-gray-200 transition-all"
                      @click="showModal = false"
                    >
                      Annuler
                    </button>
                    <button
                      type="submit"
                      class="px-6 py-4 bg-blue-600 text-white rounded-2xl font-semibold
                        hover:bg-blue-700 focus:ring-4 focus:ring-blue-500/50 transition-all
                        disabled:opacity-50 disabled:hover:bg-blue-600 flex items-center justify-center gap-2 text-base"
                      :disabled="isSaving"
                    >
                      <Icon 
                        v-if="isSaving"
                        name="i-heroicons-arrow-path" 
                        class="w-5 h-5 animate-spin"
                      />
                      <Icon 
                        v-else
                        name="i-heroicons-briefcase" 
                        class="w-5 h-5"
                      />
                      {{ isSaving ? 'Enregistrement en cours...' : (editMode ? 'Enregistrer les modifications' : 'Ajouter la mission') }}
                    </button>
                  </div>
                </form>
              </DialogPanel>
            </TransitionChild>
          </div>
        </div>
      </Dialog>
    </TransitionRoot>
  </template>
  
  <script setup>
  import { ref, computed, onMounted } from 'vue'
  import { useSupabaseClient } from '#imports'
  import { format } from 'date-fns'
  import { fr } from 'date-fns/locale'
  import { Dialog, DialogPanel, DialogTitle, TransitionRoot, TransitionChild } from '@headlessui/vue'
  
  const supabase = useSupabaseClient()
  
  // États
  const missions = ref([])
  const clients = ref([])
  const isLoading = ref(true)
  const isSaving = ref(false)
  const showModal = ref(false)
  const editMode = ref(false)
  const currentPage = ref(1)
  const itemsPerPage = ref(10)
  const filters = ref({
    status: null,
    search: ''
  })
  
  // Form state
  const form = ref({
    title: '',
    description: '',
    client_id: '',
    budget: 0,
    status: 'DRAFT'
  })
  
  // Options et configurations
  const statusOptions = [
    { label: 'Tous les statuts', value: null },
    { label: 'Brouillon', value: 'DRAFT' },
    { label: 'En attente', value: 'PENDING' },
    { label: 'En cours', value: 'IN_PROGRESS' },
    { label: 'Terminée', value: 'COMPLETED' },
    { label: 'Annulée', value: 'CANCELLED' }
  ]
  
  const statuses = statusOptions.filter(s => s.value !== null)
  
  const columns = [
    {
      key: 'mission',
      label: 'Mission'
    },
    {
      key: 'client',
      label: 'Client'
    },
    {
      key: 'budget',
      label: 'Budget'
    },
    {
      key: 'status',
      label: 'Statut'
    },
    {
      key: 'actions',
      label: ''
    }
  ]
  
  // Computed
  const totalItems = computed(() => missions.value.length)
  const totalPages = computed(() => Math.ceil(totalItems.value / itemsPerPage.value))
  const startIndex = computed(() => (currentPage.value - 1) * itemsPerPage.value)
  const endIndex = computed(() => Math.min(startIndex.value + itemsPerPage.value, totalItems.value))
  
  const paginatedMissions = computed(() => {
    return missions.value.slice(startIndex.value, endIndex.value)
  })
  
  // ... suite du script setup ...

const formatDate = (date) => {
  return format(new Date(date), 'dd MMM yyyy', { locale: fr })
}

const formatPrice = (price) => {
  return new Intl.NumberFormat('fr-FR', {
    style: 'currency',
    currency: 'EUR'
  }).format(price || 0)
}

const getInitials = (name) => {
  return name
    .split(' ')
    .map(word => word[0])
    .join('')
    .toUpperCase()
}

const getStatusColor = (status) => {
  const colors = {
    DRAFT: 'gray',
    PENDING: 'yellow',
    IN_PROGRESS: 'blue',
    COMPLETED: 'green',
    CANCELLED: 'red'
  }
  return colors[status] || 'gray'
}

const getStatusDotColor = (status) => {
  const colors = {
    DRAFT: 'bg-gray-500',
    PENDING: 'bg-yellow-500',
    IN_PROGRESS: 'bg-blue-500',
    COMPLETED: 'bg-green-500',
    CANCELLED: 'bg-red-500'
  }
  return colors[status] || 'bg-gray-500'
}

const formatStatus = (status) => {
  const labels = {
    DRAFT: 'Brouillon',
    PENDING: 'En attente',
    IN_PROGRESS: 'En cours',
    COMPLETED: 'Terminée',
    CANCELLED: 'Annulée'
  }
  return labels[status] || status
}

const getNextStatusLabel = (status) => {
  const nextStatus = {
    DRAFT: 'Publier',
    PENDING: 'Démarrer',
    IN_PROGRESS: 'Terminer',
    COMPLETED: 'Archiver',
    CANCELLED: null
  }
  return nextStatus[status] || null
}

const getNextStatusIcon = (status) => {
  const icons = {
    DRAFT: 'i-heroicons-paper-airplane',
    PENDING: 'i-heroicons-play',
    IN_PROGRESS: 'i-heroicons-check',
    COMPLETED: 'i-heroicons-archive-box',
    CANCELLED: null
  }
  return icons[status] || null
}

const canUpdateStatus = (status) => {
  return ['DRAFT', 'PENDING', 'IN_PROGRESS', 'COMPLETED'].includes(status)
}

// Actions
const openModal = (mission = null) => {
  if (mission) {
    form.value = { ...mission }
    editMode.value = true
  } else {
    form.value = {
      title: '',
      description: '',
      client_id: '',
      budget: 0,
      status: 'DRAFT'
    }
    editMode.value = false
  }
  showModal.value = true
}

const loadData = async () => {
  isLoading.value = true
  try {
    // Charger les missions
    const { data: missionsData, error: missionsError } = await supabase
      .from('missions')
      .select(`
        *
      `)
      .order('created_at', { ascending: false })

    if (missionsError) throw missionsError
    missions.value = missionsData || []

    // Charger les clients
    const { data: clientsData, error: clientsError } = await supabase
      .from('profiles')
      .select('id, company_name, avatar_url')
      .order('company_name')

    if (clientsError) throw clientsError
    clients.value = clientsData || []

  } catch (error) {
    console.error('Erreur lors du chargement des données:', error)
  } finally {
    isLoading.value = false
  }
}

const saveMission = async () => {
  isSaving.value = true
  try {
    const { error } = editMode.value
      ? await supabase
          .from('missions')
          .update(form.value)
          .eq('id', form.value.id)
      : await supabase
          .from('missions')
          .insert([form.value])

    if (error) throw error
    
    showModal.value = false
    loadData()
  } catch (error) {
    console.error('Erreur lors de l\'enregistrement:', error)
  } finally {
    isSaving.value = false
  }
}

const updateStatus = async (mission) => {
  const nextStatus = {
    DRAFT: 'PENDING',
    PENDING: 'IN_PROGRESS',
    IN_PROGRESS: 'COMPLETED',
    COMPLETED: 'ARCHIVED'
  }[mission.status]

  if (!nextStatus) return

  try {
    const { error } = await supabase
      .from('missions')
      .update({ status: nextStatus })
      .eq('id', mission.id)

    if (error) throw error
    loadData()
  } catch (error) {
    console.error('Erreur lors de la mise à jour du statut:', error)
  }
}

const toggleArchive = async (mission) => {
  try {
    const { error } = await supabase
      .from('missions')
      .update({ is_active: !mission.is_active })
      .eq('id', mission.id)

    if (error) throw error
    loadData()
  } catch (error) {
    console.error('Erreur lors de l\'archivage:', error)
  }
}

const navigateToMission = (id) => {
  navigateTo(`/admin/missions/${id}`)
}

// Watchers
watch([currentPage, filters], () => {
  loadData()
}, { deep: true })

// Initialisation
onMounted(() => {
  loadData()
})

definePageMeta({
  layout: 'admin'
})
</script>