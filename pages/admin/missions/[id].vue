<template>
  <div class="space-y-6 p-4 sm:p-6 lg:p-8">
    <!-- Debug info -->

    <!-- Header avec actions -->
    <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
      <div class="flex items-center gap-3">
        <UButton
          icon="i-heroicons-arrow-left"
          color="gray"
          variant="ghost"
          class="h-10 w-10 rounded-full"
          @click="$router.back()"
        />
        <div>
          <h1 class="text-2xl font-bold text-gray-900 dark:text-white">
            {{ mission?.title || 'Chargement...' }}
          </h1>
          <p class="text-sm text-gray-500 dark:text-gray-400">
            Référence: {{ mission?.reference || '...' }}
          </p>
        </div>
      </div>

      <div class="flex items-center gap-3" v-if="mission">
        <UDropdown
          :items="actionItems"
          :popper="{ placement: 'bottom-end' }"
        >
          <UButton
            color="gray"
            variant="ghost"
            icon="i-heroicons-ellipsis-horizontal"
            class="h-10 w-10 rounded-full"
          />
        </UDropdown>
        <UButton
          icon="i-heroicons-pencil-square"
          label="Modifier"
          class="rounded-full"
          @click="openEditModal"
        />
      </div>
    </div>

    <!-- Loading state -->
    <template v-if="isLoading">
      <div class="flex items-center justify-center py-12">
        <UIcon name="i-heroicons-arrow-path" class="h-8 w-8 animate-spin" />
      </div>
    </template>

    <template v-else-if="mission">
      <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <!-- Colonne principale -->
        <div class="lg:col-span-2 space-y-6">
          <!-- Informations principales -->
          <UCard>
            <template #header>
              <div class="flex items-center justify-between">
                <h2 class="text-lg font-semibold">Informations principales</h2>
                <UBadge
                  :color="getStatusColor(mission.status)"
                  :label="formatStatus(mission.status)"
                  variant="subtle"
                  size="md"
                  class="rounded-full"
                >
                  <template #prefix>
                    <div class="h-2 w-2 rounded-full" :class="getStatusDotColor(mission.status)" />
                  </template>
                </UBadge>
              </div>
            </template>

            <div class="space-y-6">
              <!-- Description -->
              <div>
                <h3 class="text-sm font-medium text-gray-500 dark:text-gray-400 mb-2">Description</h3>
                <p class="text-gray-900 dark:text-white whitespace-pre-line">{{ mission.description }}</p>
              </div>

              <!-- Budget et Deadline -->
              <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div>
                  <h3 class="text-sm font-medium text-gray-500 dark:text-gray-400 mb-2">Budget</h3>
                  <p class="text-2xl font-bold text-gray-900 dark:text-white">
                    {{ formatPrice(mission.budget) }}
                  </p>
                </div>
                <div>
                  <h3 class="text-sm font-medium text-gray-500 dark:text-gray-400 mb-2">Date limite</h3>
                  <p class="text-2xl font-bold text-gray-900 dark:text-white">
                    {{ formatDeadline(mission.deadline) }}
                  </p>
                </div>
              </div>

              <!-- Dates -->
              <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div>
                  <h3 class="text-sm font-medium text-gray-500 dark:text-gray-400 mb-2">Date de création</h3>
                  <p class="text-gray-900 dark:text-white">{{ formatDate(mission.created_at) }}</p>
                </div>
                <div>
                  <h3 class="text-sm font-medium text-gray-500 dark:text-gray-400 mb-2">Dernière modification</h3>
                  <p class="text-gray-900 dark:text-white">{{ formatDate(mission.updated_at) }}</p>
                </div>
              </div>
            </div>
          </UCard>

          <!-- Timeline -->
          <UCard>
            <template #header>
              <h2 class="text-lg font-semibold">Historique</h2>
            </template>

            <div class="space-y-6">
              <div v-for="event in timeline" :key="event.id" class="flex gap-4">
                <div class="flex-none">
                  <div class="h-10 w-10 rounded-full bg-gray-100 dark:bg-gray-800 flex items-center justify-center">
                    <UIcon :name="event.icon" class="h-5 w-5" />
                  </div>
                </div>
                <div class="flex-1 pt-1">
                  <p class="text-gray-900 dark:text-white font-medium">
                    {{ event.title }}
                  </p>
                  <p class="text-sm text-gray-500 dark:text-gray-400">
                    {{ formatDate(event.date) }}
                  </p>
                </div>
              </div>
            </div>
          </UCard>
        </div>

        <!-- Colonne latérale -->
        <div class="space-y-6">
          <!-- Client -->
          <UCard>
            <template #header>
              <h2 class="text-lg font-semibold">Client</h2>
            </template>

            <div class="flex items-center gap-4">
              <UAvatar
                :src="mission.client?.avatar_url"
                :alt="getClientName"
                :text="getInitials(getClientName)"
                size="lg"
              />
              <div>
                <h3 class="font-medium text-gray-900 dark:text-white">
                  {{ getClientName }}
                </h3>
                <p class="text-sm text-gray-500 dark:text-gray-400">
                  {{ mission.client?.email }}
                </p>
                <p class="text-sm text-gray-500 dark:text-gray-400">
                  {{ mission.client?.phone }}
                </p>
              </div>
            </div>
          </UCard>

          <!-- Actions rapides -->
          <UCard>
            <template #header>
              <h2 class="text-lg font-semibold">Actions rapides</h2>
            </template>

            <div class="space-y-3">
              <UButton
                v-if="canUpdateStatus(mission.status)"
                :icon="getNextStatusIcon(mission.status)"
                :label="getNextStatusLabel(mission.status)"
                class="w-full rounded-full"
                @click="updateStatus(mission)"
              />
              <UButton
                :icon="mission.is_active ? 'i-heroicons-archive-box' : 'i-heroicons-arrow-uturn-left'"
                :label="mission.is_active ? 'Archiver' : 'Restaurer'"
                color="gray"
                class="w-full rounded-full"
                @click="toggleArchive(mission)"
              />
            </div>
          </UCard>
        </div>
      </div>
    </template>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useSupabaseClient } from '#imports'
import { format } from 'date-fns'
import { fr } from 'date-fns/locale'

const route = useRoute()
const supabase = useSupabaseClient()

// États
const mission = ref(null)
const isLoading = ref(true)

// Helper functions
const formatDate = (date) => {
  if (!date) return ''
  return format(new Date(date), 'dd MMM yyyy', { locale: fr })
}

const formatPrice = (price) => {
  return new Intl.NumberFormat('fr-FR', {
    style: 'currency',
    currency: 'EUR'
  }).format(price || 0)
}

const getInitials = (name) => {
  if (!name) return ''
  return name
    .split(' ')
    .map(word => word[0])
    .join('')
    .toUpperCase()
}

const getStatusColor = (status) => {
  if (!status) return 'gray'
  const statusUpper = status.toUpperCase()
  const colors = {
    DRAFT: 'gray',
    PENDING: 'yellow',
    IN_PROGRESS: 'blue',
    COMPLETED: 'green',
    CANCELLED: 'red'
  }
  return colors[statusUpper] || 'gray'
}

const getStatusDotColor = (status) => {
  if (!status) return 'bg-gray-500'
  const statusUpper = status.toUpperCase()
  const colors = {
    DRAFT: 'bg-gray-500',
    PENDING: 'bg-yellow-500',
    IN_PROGRESS: 'bg-blue-500',
    COMPLETED: 'bg-green-500',
    CANCELLED: 'bg-red-500'
  }
  return colors[statusUpper] || 'bg-gray-500'
}

const formatStatus = (status) => {
  if (!status) return ''
  const statusUpper = status.toUpperCase()
  const labels = {
    DRAFT: 'Brouillon',
    PENDING: 'En attente',
    IN_PROGRESS: 'En cours',
    COMPLETED: 'Terminée',
    CANCELLED: 'Annulée'
  }
  return labels[statusUpper] || status
}

const getNextStatusLabel = (status) => {
  if (!status) return null
  const statusUpper = status.toUpperCase()
  const nextStatus = {
    DRAFT: 'Publier',
    PENDING: 'Démarrer',
    IN_PROGRESS: 'Terminer',
    COMPLETED: 'Archiver',
    CANCELLED: null
  }
  return nextStatus[statusUpper] || null
}

const getNextStatusIcon = (status) => {
  if (!status) return null
  const statusUpper = status.toUpperCase()
  const icons = {
    DRAFT: 'i-heroicons-paper-airplane',
    PENDING: 'i-heroicons-play',
    IN_PROGRESS: 'i-heroicons-check',
    COMPLETED: 'i-heroicons-archive-box',
    CANCELLED: null
  }
  return icons[statusUpper] || null
}

const canUpdateStatus = (status) => {
  if (!status) return false
  const statusUpper = status.toUpperCase()
  return ['DRAFT', 'PENDING', 'IN_PROGRESS', 'COMPLETED'].includes(statusUpper)
}

// Ajoutons une fonction pour formater le nom complet du client
const getClientName = computed(() => {
  if (!mission.value?.client) return ''
  const { first_name, last_name } = mission.value.client
  return `${first_name} ${last_name}`.trim()
})

// Et une fonction pour formater la date de deadline
const formatDeadline = (date) => {
  if (!date) return 'Non définie'
  return format(new Date(date), 'dd MMM yyyy', { locale: fr })
}

// Actions
const actionItems = computed(() => {
  if (!mission.value) return []
  
  return [
    [
      {
        label: 'Modifier',
        icon: 'i-heroicons-pencil-square',
        click: () => openEditModal()
      },
      {
        label: 'Dupliquer',
        icon: 'i-heroicons-document-duplicate',
        click: () => duplicateMission()
      }
    ],
    [
      {
        label: mission.value.is_active ? 'Archiver' : 'Restaurer',
        icon: mission.value.is_active ? 'i-heroicons-archive-box' : 'i-heroicons-arrow-uturn-left',
        click: () => toggleArchive(mission.value)
      }
    ]
  ]
})

// Chargement des données
const loadMission = async () => {
  isLoading.value = true
  try {
    console.log('Loading mission with ID:', route.params.id)
    const { data, error } = await supabase
      .from('missions')
      .select(`
        *,
        client:profiles(*)
      `)
      .eq('id', route.params.id)
      .single()

    if (error) {
      console.error('Supabase error:', error)
      throw error
    }
    
    console.log('Loaded mission:', data)
    mission.value = data
  } catch (error) {
    console.error('Error loading mission:', error)
  } finally {
    isLoading.value = false
  }
}

// Placeholder functions
const openEditModal = () => {
  console.log('Edit modal opened')
}

const duplicateMission = () => {
  console.log('Duplicate mission')
}

const toggleArchive = (mission) => {
  console.log('Toggle archive', mission)
}

// Timeline
const timeline = computed(() => {
  if (!mission.value) return []
  
  return [
    {
      id: 1,
      title: 'Mission créée',
      date: mission.value.created_at,
      icon: 'i-heroicons-plus'
    },
    {
      id: 2,
      title: `Statut : ${formatStatus(mission.value.status)}`,
      date: mission.value.updated_at,
      icon: 'i-heroicons-arrow-path'
    },
    {
      id: 3,
      title: `Date limite : ${formatDeadline(mission.value.deadline)}`,
      date: mission.value.deadline,
      icon: 'i-heroicons-calendar'
    }
  ]
})

// Initialisation
onMounted(() => {
  console.log('Component mounted')
  loadMission()
})

definePageMeta({
  layout: 'admin'
})
</script>
