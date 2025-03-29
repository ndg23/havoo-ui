<template>
    <div class="space-y-6 p-4 sm:p-6 lg:p-8">
      <!-- Loading state -->
      <template v-if="isLoading">
        <div class="flex items-center justify-center py-12">
          <UIcon name="i-heroicons-arrow-path" class="h-8 w-8 animate-spin" />
        </div>
      </template>
  
      <template v-else-if="mission">
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
                {{ mission.title }}
              </h1>
              <p class="text-sm text-gray-500 dark:text-gray-400">
                Mission #{{ mission.id.split('-')[0] }}
              </p>
            </div>
          </div>
  
          <div class="flex items-center gap-3">
            <UButton
              icon="i-heroicons-pencil-square"
              label="Modifier"
              class="rounded-full"
              @click="editMode = true"
            />
          </div>
        </div>
  
        <!-- Contenu de la mission -->
        <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
          <!-- Colonne principale -->
          <div class="lg:col-span-2 space-y-6">
            <!-- Détails de la mission -->
            <UCard>
              <template #header>
                <h2 class="text-lg font-semibold">Détails de la mission</h2>
              </template>
              
              <div class="space-y-4">
                <!-- Status -->
                <div class="flex items-center gap-2">
                  <UBadge
                    :color="getStatusColor(mission.status)"
                    :label="formatStatus(mission.status)"
                    variant="subtle"
                    class="rounded-full"
                  />
                </div>
  
                <!-- Description -->
                <p class="text-gray-700 dark:text-gray-300 whitespace-pre-line">
                  {{ mission.description }}
                </p>
  
                <!-- Dates -->
                <div class="grid grid-cols-2 gap-4">
                  <div>
                    <div class="text-sm font-medium text-gray-500">Date de début</div>
                    <div class="mt-1">{{ formatDate(mission.start_date) }}</div>
                  </div>
                  <div>
                    <div class="text-sm font-medium text-gray-500">Date de fin</div>
                    <div class="mt-1">{{ formatDate(mission.end_date) }}</div>
                  </div>
                </div>
              </div>
            </UCard>
          </div>
  
          <!-- Sidebar -->
          <div class="space-y-6">
            <!-- Informations client -->
            <UCard>
              <template #header>
                <h2 class="text-lg font-semibold">Client</h2>
              </template>
              
              <div class="space-y-4">
                <div class="flex items-center gap-3">
                  <UAvatar
                    :src="mission.client?.avatar_url"
                    :alt="mission.client?.first_name"
                    size="lg"
                  />
                  <div>
                    <div class="font-medium">
                      {{ mission.client?.first_name }} {{ mission.client?.last_name }}
                    </div>
                    <div class="text-sm text-gray-500">
                      {{ mission.client?.email }}
                    </div>
                  </div>
                </div>
              </div>
            </UCard>
          </div>
        </div>
      </template>
    </div>
  </template>
  
  <script setup>
  import { ref, onMounted } from 'vue'
  import { useRoute, useRouter } from 'vue-router'
  import { useSupabaseClient } from '#imports'
  import { format } from 'date-fns'
  import { fr } from 'date-fns/locale'
  
  const route = useRoute()
  const router = useRouter()
  const supabase = useSupabaseClient()
  
  // État
  const mission = ref(null)
  const isLoading = ref(true)
  const editMode = ref(false)
  
  // Chargement des données
  const loadMission = async () => {
    isLoading.value = true
    try {
      const { data, error } = await supabase
        .from('missions')
        .select(`
          *,
          client:profiles(*)
        `)
        .eq('id', route.params.id)
        .single()
  
      if (error) throw error
      mission.value = data
    } catch (error) {
      console.error('Error loading mission:', error)
    } finally {
      isLoading.value = false
    }
  }
  
  // Helpers
  const formatDate = (date) => {
    if (!date) return ''
    return format(new Date(date), 'dd MMMM yyyy', { locale: fr })
  }
  
  const getStatusColor = (status) => {
    const colors = {
      pending: 'yellow',
      in_progress: 'blue',
      completed: 'green',
      cancelled: 'red'
    }
    return colors[status] || 'gray'
  }
  
  const formatStatus = (status) => {
    const labels = {
      pending: 'En attente',
      in_progress: 'En cours',
      completed: 'Terminée',
      cancelled: 'Annulée'
    }
    return labels[status] || status
  }
  
  // Initialisation
  onMounted(() => {
    loadMission()
  })
  
  definePageMeta({
    layout: 'account'
  })
  </script>