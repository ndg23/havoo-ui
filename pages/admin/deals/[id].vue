<template>
  <div class="max-w-5xl mx-auto px-4 py-6">
    <!-- En-tête avec navigation -->
    <div class="flex items-center gap-2 mb-8 text-sm">
      <NuxtLink 
        to="/admin/deals"
        class="text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-300"
      >
        Propositions
      </NuxtLink>
      <UIcon name="i-heroicons-chevron-right" class="w-4 h-4 text-gray-400" />
      <span class="text-gray-900 dark:text-white font-medium">Détails</span>
    </div>

    <UCard v-if="deal">
      <!-- En-tête avec statut -->
      <div class="flex items-start justify-between mb-6">
        <div>
          <div class="flex items-center gap-3 mb-2">
            <UBadge :color="getStatusColor(deal.status)" size="lg">
              {{ getStatusLabel(deal.status) }}
            </UBadge>
            <span class="text-sm text-gray-500">
              {{ formatDate(deal.created_at) }}
            </span>
          </div>
          <h1 class="text-2xl font-bold">
            Proposition pour "{{ deal.mission?.title }}"
          </h1>
        </div>
        
        <!-- Actions rapides -->
        <div class="flex items-center gap-2">
          <UButton
            v-if="deal.status === 'proposal'"
            color="green"
            @click="updateStatus('accepted')"
            :loading="isUpdating"
            icon="i-heroicons-check"
          >
            Accepter
          </UButton>
          <UButton
            v-if="deal.status === 'proposal'"
            color="red"
            variant="soft"
            @click="updateStatus('rejected')"
            :loading="isUpdating"
            icon="i-heroicons-x-mark"
          >
            Refuser
          </UButton>
          <UDropdown :items="getActionItems">
            <UButton
              color="gray"
              variant="ghost"
              icon="i-heroicons-ellipsis-horizontal"
            />
          </UDropdown>
        </div>
      </div>

      <!-- Grille d'informations -->
      <div class="grid grid-cols-1 md:grid-cols-2 gap-8 mb-8">
        <!-- Expert -->
        <div class="space-y-4">
          <h2 class="font-medium text-gray-500 dark:text-gray-400">Expert</h2>
          <div class="flex items-center gap-4">
            <UAvatar
              :src="deal.expert?.avatar_url"
              :alt="deal.expert?.name"
              size="lg"
            />
            <div>
              <div class="font-medium">{{ deal.expert?.name }}</div>
              <div class="text-sm text-gray-500">{{ deal.expert?.profession }}</div>
              <NuxtLink 
                :to="`/admin/experts/${deal.expert_id}`"
                class="text-sm text-primary-600 hover:text-primary-700 dark:text-primary-400 dark:hover:text-primary-300"
              >
                Voir le profil
              </NuxtLink>
            </div>
          </div>
        </div>

        <!-- Client -->
        <div class="space-y-4">
          <h2 class="font-medium text-gray-500 dark:text-gray-400">Client</h2>
          <div class="flex items-center gap-4">
            <UAvatar
              :src="deal.mission?.client?.avatar_url"
              :alt="deal.mission?.client?.name"
              size="lg"
            />
            <div>
              <div class="font-medium">{{ deal.mission?.client?.name }}</div>
              <NuxtLink 
                :to="`/admin/missions/${deal.mission_id}`"
                class="text-sm text-primary-600 hover:text-primary-700 dark:text-primary-400 dark:hover:text-primary-300"
              >
                Voir la mission
              </NuxtLink>
            </div>
          </div>
        </div>
      </div>

      <!-- Détails de la proposition -->
      <div class="space-y-6">
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
          <div class="bg-gray-50 dark:bg-gray-800/50 p-4 rounded-xl">
            <div class="text-sm text-gray-500 dark:text-gray-400 mb-1">Prix proposé</div>
            <div class="text-xl font-semibold">{{ formatPrice(deal.price) }}</div>
          </div>
          
          <div class="bg-gray-50 dark:bg-gray-800/50 p-4 rounded-xl">
            <div class="text-sm text-gray-500 dark:text-gray-400 mb-1">Durée estimée</div>
            <div class="text-xl font-semibold">
              {{ deal.duration }} {{ getDurationLabel(deal.duration_unit) }}
            </div>
          </div>

          <div class="bg-gray-50 dark:bg-gray-800/50 p-4 rounded-xl">
            <div class="text-sm text-gray-500 dark:text-gray-400 mb-1">Date de proposition</div>
            <div class="text-xl font-semibold">{{ formatDate(deal.created_at) }}</div>
          </div>
        </div>

        <!-- Message de l'expert -->
        <div class="bg-gray-50 dark:bg-gray-800/50 p-6 rounded-xl">
          <h3 class="font-medium text-gray-900 dark:text-white mb-3">Message de l'expert</h3>
          <p class="text-gray-600 dark:text-gray-300 whitespace-pre-wrap">{{ deal.message }}</p>
        </div>
      </div>

      <!-- Ajouter après la section "Message de l'expert" -->
      <div class="space-y-6 mt-8">
        <!-- Timeline des événements -->
        <div class="bg-white dark:bg-gray-800 rounded-xl overflow-hidden">
          <div class="px-6 py-4 border-b border-gray-100 dark:border-gray-700">
            <h3 class="font-medium text-gray-900 dark:text-white">Historique</h3>
          </div>
          <div class="p-6">
            <div class="space-y-6">
              <div v-for="event in dealEvents" :key="event.id" class="flex gap-4">
                <div class="flex-none">
                  <div class="w-8 h-8 rounded-full bg-primary-50 dark:bg-primary-900/20 flex items-center justify-center">
                    <UIcon :name="event.icon" class="w-4 h-4 text-primary-500" />
                  </div>
                </div>
                <div>
                  <p class="text-sm text-gray-900 dark:text-white">{{ event.description }}</p>
                  <p class="text-xs text-gray-500 mt-1">{{ formatDate(event.created_at) }}</p>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Notes administratives -->
        <div class="bg-white dark:bg-gray-800 rounded-xl overflow-hidden">
          <div class="px-6 py-4 border-b border-gray-100 dark:border-gray-700">
            <h3 class="font-medium text-gray-900 dark:text-white">Notes administratives</h3>
          </div>
          <div class="p-6">
            <!-- Liste des notes -->
            <div class="space-y-4 mb-6">
              <div v-for="note in adminNotes" :key="note.id" 
                class="bg-gray-50 dark:bg-gray-800/50 rounded-lg p-4">
                <div class="flex items-start justify-between">
                  <div class="flex items-center gap-3">
                    <UAvatar :src="note.admin?.avatar_url" size="sm" />
                    <div>
                      <p class="text-sm font-medium">{{ note.admin?.name }}</p>
                      <p class="text-xs text-gray-500">{{ formatDate(note.created_at) }}</p>
                    </div>
                  </div>
                  <UButton
                    v-if="note.admin_id === currentUser?.id"
                    color="gray"
                    variant="ghost"
                    icon="i-heroicons-trash"
                    size="xs"
                    @click="deleteNote(note.id)"
                  />
                </div>
                <p class="mt-2 text-sm text-gray-600 dark:text-gray-300">{{ note.content }}</p>
              </div>
            </div>

            <!-- Formulaire d'ajout de note -->
            <form @submit.prevent="addNote" class="space-y-4">
              <UTextarea
                v-model="newNote"
                placeholder="Ajouter une note..."
                :rows="3"
              />
              <div class="flex justify-end">
                <UButton
                  type="submit"
                  :loading="isAddingNote"
                  :disabled="!newNote.trim()"
                >
                  Ajouter une note
                </UButton>
              </div>
            </form>
          </div>
        </div>

        <!-- Statistiques -->
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div class="bg-white dark:bg-gray-800 rounded-xl overflow-hidden">
            <div class="px-6 py-4 border-b border-gray-100 dark:border-gray-700">
              <h3 class="font-medium text-gray-900 dark:text-white">Expert</h3>
            </div>
            <div class="p-6">
              <dl class="grid grid-cols-2 gap-4">
                <div>
                  <dt class="text-sm text-gray-500">Propositions totales</dt>
                  <dd class="text-2xl font-semibold">{{ expertStats.totalProposals }}</dd>
                </div>
                <div>
                  <dt class="text-sm text-gray-500">Taux d'acceptation</dt>
                  <dd class="text-2xl font-semibold">{{ expertStats.acceptanceRate }}%</dd>
                </div>
                <div>
                  <dt class="text-sm text-gray-500">Note moyenne</dt>
                  <dd class="text-2xl font-semibold">{{ expertStats.averageRating }}/5</dd>
                </div>
                <div>
                  <dt class="text-sm text-gray-500">Missions complétées</dt>
                  <dd class="text-2xl font-semibold">{{ expertStats.completedMissions }}</dd>
                </div>
              </dl>
            </div>
          </div>

          <div class="bg-white dark:bg-gray-800 rounded-xl overflow-hidden">
            <div class="px-6 py-4 border-b border-gray-100 dark:border-gray-700">
              <h3 class="font-medium text-gray-900 dark:text-white">Mission</h3>
            </div>
            <div class="p-6">
              <dl class="grid grid-cols-2 gap-4">
                <div>
                  <dt class="text-sm text-gray-500">Propositions reçues</dt>
                  <dd class="text-2xl font-semibold">{{ missionStats.totalProposals }}</dd>
                </div>
                <div>
                  <dt class="text-sm text-gray-500">Budget moyen</dt>
                  <dd class="text-2xl font-semibold">{{ formatPrice(missionStats.averagePrice) }}</dd>
                </div>
                <div>
                  <dt class="text-sm text-gray-500">Durée moyenne</dt>
                  <dd class="text-2xl font-semibold">{{ missionStats.averageDuration }} jours</dd>
                </div>
                <div>
                  <dt class="text-sm text-gray-500">Vues</dt>
                  <dd class="text-2xl font-semibold">{{ missionStats.views }}</dd>
                </div>
              </dl>
            </div>
          </div>
        </div>
      </div>
    </UCard>

    <!-- État de chargement -->
    <div v-else-if="isLoading" class="flex justify-center py-12">
      <ULoadingIcon />
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useSupabaseClient } from '#imports'
import { format } from 'date-fns'
import { fr } from 'date-fns/locale'
import { useCustomToast } from '~/composables/useCustomToast'

const route = useRoute()
const supabase = useSupabaseClient()
const { showToast } = useCustomToast()

const deal = ref(null)
const isLoading = ref(true)
const isUpdating = ref(false)

// Ajouter ces refs
const dealEvents = ref([])
const adminNotes = ref([])
const newNote = ref('')
const isAddingNote = ref(false)
const currentUser = ref(null)

// Ajouter ces stats
const expertStats = ref({
  totalProposals: 0,
  acceptanceRate: 0,
  averageRating: 0,
  completedMissions: 0
})

const missionStats = ref({
  totalProposals: 0,
  averagePrice: 0,
  averageDuration: 0,
  views: 0
})

// Charger les données
const fetchDeal = async () => {
  try {
    const { data, error } = await supabase
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
            id,
            first_name,
            last_name,
            avatar_url
          )
        )
      `)
      .eq('id', route.params.id)
      .single()

    if (error) throw error

    // Charger la profession
    if (data.expert?.profession_id) {
      const { data: professionData } = await supabase
        .from('professions')
        .select('name')
        .eq('id', data.expert.profession_id)
        .single()

      data.expert.profession = professionData?.name
    }

    deal.value = {
      ...data,
      expert: {
        ...data.expert,
        name: `${data.expert?.first_name || ''} ${data.expert?.last_name || ''}`.trim()
      },
      mission: {
        ...data.mission,
        client: {
          ...data.mission?.client,
          name: `${data.mission?.client?.first_name || ''} ${data.mission?.client?.last_name || ''}`.trim()
        }
      }
    }
  } catch (error) {
    console.error('Erreur:', error)
    showToast.error('Erreur', 'Impossible de charger les détails de la proposition')
  } finally {
    isLoading.value = false
  }
}

// Mettre à jour le statut
const updateStatus = async (status) => {
  try {
    isUpdating.value = true
    const { error } = await supabase
      .from('deals')
      .update({ status })
      .eq('id', route.params.id)

    if (error) throw error

    deal.value.status = status
    showToast.success('Succès', 'Le statut a été mis à jour')
  } catch (error) {
    console.error('Erreur:', error)
    showToast.error('Erreur', 'Impossible de mettre à jour le statut')
  } finally {
    isUpdating.value = false
  }
}

// Actions du menu
const getActionItems = computed(() => [
  [
    {
      label: 'Voir la mission',
      icon: 'i-heroicons-document-text',
      click: () => navigateTo(`/admin/missions/${deal.value.mission_id}`)
    },
    {
      label: 'Voir l\'expert',
      icon: 'i-heroicons-user',
      click: () => navigateTo(`/admin/experts/${deal.value.expert_id}`)
    }
  ],
  [
    {
      label: deal.value?.status === 'cancelled' ? 'Réactiver' : 'Annuler',
      icon: deal.value?.status === 'cancelled' ? 'i-heroicons-arrow-path' : 'i-heroicons-ban',
      click: () => updateStatus(deal.value?.status === 'cancelled' ? 'proposal' : 'cancelled'),
      class: deal.value?.status === 'cancelled' ? 'text-green-600' : 'text-red-600'
    }
  ]
])

// Helpers
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

const getDurationLabel = (unit) => {
  const labels = {
    days: 'jours',
    weeks: 'semaines',
    months: 'mois'
  }
  return labels[unit] || unit
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

// Ajouter ces méthodes
const fetchEvents = async () => {
  const { data } = await supabase
    .from('deal_events')
    .select('*')
    .eq('deal_id', route.params.id)
    .order('created_at', { ascending: false })

  dealEvents.value = data?.map(event => ({
    ...event,
    icon: getEventIcon(event.type)
  })) || []
}

const fetchNotes = async () => {
  const { data } = await supabase
    .from('deal_notes')
    .select(`
      *,
      admin:profiles(
        id,
        first_name,
        last_name,
        avatar_url
      )
    `)
    .eq('deal_id', route.params.id)
    .order('created_at', { ascending: false })

  adminNotes.value = data?.map(note => ({
    ...note,
    admin: {
      ...note.admin,
      name: `${note.admin.first_name} ${note.admin.last_name}`
    }
  })) || []
}

const addNote = async () => {
  if (!newNote.value.trim()) return

  isAddingNote.value = true
  try {
    const { error } = await supabase
      .from('deal_notes')
      .insert({
        deal_id: route.params.id,
        admin_id: currentUser.value.id,
        content: newNote.value.trim()
      })

    if (error) throw error

    newNote.value = ''
    await fetchNotes()
    showToast.success('Note ajoutée avec succès')
  } catch (error) {
    showToast.error('Erreur lors de l\'ajout de la note')
  } finally {
    isAddingNote.value = false
  }
}

const deleteNote = async (noteId) => {
  try {
    const { error } = await supabase
      .from('deal_notes')
      .delete()
      .eq('id', noteId)

    if (error) throw error

    await fetchNotes()
    showToast.success('Note supprimée avec succès')
  } catch (error) {
    showToast.error('Erreur lors de la suppression de la note')
  }
}

const getEventIcon = (type) => {
  const icons = {
    created: 'i-heroicons-plus-circle',
    status_updated: 'i-heroicons-arrow-path',
    accepted: 'i-heroicons-check-circle',
    rejected: 'i-heroicons-x-circle',
    cancelled: 'i-heroicons-ban',
    completed: 'i-heroicons-flag'
  }
  return icons[type] || 'i-heroicons-information-circle'
}

// Modifier onMounted
onMounted(async () => {
  const user = await supabase.auth.getUser()
  currentUser.value = user.data.user
  
  await Promise.all([
    fetchDeal(),
    fetchEvents(),
    fetchNotes()
  ])
})

definePageMeta({
  layout: 'admin'
})
</script> 