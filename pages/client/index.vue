<template>
  <div class="p-6 space-y-8">
    <!-- En-tête avec action rapide -->
    <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
      <div>
        <h1 class="text-2xl font-semibold text-gray-900 dark:text-white">
          Bonjour {{ user?.first_name }} 👋
        </h1>
        <p class="mt-1 text-gray-600 dark:text-gray-400">
          Que souhaitez-vous faire aujourd'hui ?
        </p>
      </div>

      <UButton
        to="/client/missions/new"
        color="primary"
        size="lg"
        class="w-full md:w-auto"
      >
        <template #leading>
          <UIcon name="i-heroicons-plus" />
        </template>
        Publier une mission
      </UButton>
    </div>

    <!-- Actions rapides -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
      <UCard class="bg-gradient-to-br from-primary-500 to-primary-600">
        <div class="flex items-center gap-4">
          <div class="flex-shrink-0 p-3 bg-white/10 rounded-xl">
            <UIcon name="i-heroicons-briefcase" class="w-8 h-8 text-white" />
          </div>
          <div class="text-white">
            <p class="text-lg font-medium">{{ stats.activeMissions }}</p>
            <p class="text-sm text-white/80">Missions en cours</p>
          </div>
        </div>
      </UCard>

      <UCard class="bg-gradient-to-br from-amber-500 to-amber-600">
        <div class="flex items-center gap-4">
          <div class="flex-shrink-0 p-3 bg-white/10 rounded-xl">
            <UIcon name="i-heroicons-document-text" class="w-8 h-8 text-white" />
          </div>
          <div class="text-white">
            <p class="text-lg font-medium">{{ stats.proposals }}</p>
            <p class="text-sm text-white/80">Propositions reçues</p>
          </div>
        </div>
      </UCard>

      <UCard class="bg-gradient-to-br from-green-500 to-green-600">
        <div class="flex items-center gap-4">
          <div class="flex-shrink-0 p-3 bg-white/10 rounded-xl">
            <UIcon name="i-heroicons-banknotes" class="w-8 h-8 text-white" />
          </div>
          <div class="text-white">
            <p class="text-lg font-medium">45 000 FCFA</p>
            <p class="text-sm text-white/80">Solde Wave</p>
          </div>
        </div>
      </UCard>
    </div>

    <!-- Missions et experts -->
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
      <!-- Missions récentes -->
      <UCard>
        <template #header>
          <div class="flex items-center justify-between">
            <h2 class="text-lg font-medium text-gray-900 dark:text-white">Missions récentes</h2>
            <UButton 
              to="/client/missions" 
              color="gray" 
              variant="ghost" 
              icon="i-heroicons-arrow-right"
            >
              Voir tout
            </UButton>
          </div>
        </template>

        <div class="divide-y divide-gray-100 dark:divide-gray-800">
          <div v-for="mission in recentMissions" :key="mission.id" class="py-4">
            <div class="flex items-center justify-between">
              <div class="min-w-0">
                <h3 class="text-sm font-medium text-gray-900 dark:text-white truncate">
                  {{ mission.title }}
                </h3>
                <div class="flex items-center gap-2 mt-1">
                  <UIcon 
                    :name="getStatusIcon(mission.status)" 
                    class="w-4 h-4"
                    :class="getStatusIconColor(mission.status)"
                  />
                  <p class="text-sm text-gray-600 dark:text-gray-400">
                    {{ formatMissionStatus(mission.status) }}
                  </p>
                </div>
              </div>
              <div class="text-right">
                <p class="text-sm font-medium text-gray-900 dark:text-white">
                  {{ mission.proposals }} proposition{{ mission.proposals > 1 ? 's' : '' }}
                </p>
                <p class="text-xs text-gray-500 dark:text-gray-400">
                  {{ formatDate(mission.created_at) }}
                </p>
              </div>
            </div>
          </div>
        </div>
      </UCard>

      <!-- Experts recommandés -->
      <UCard>
        <template #header>
          <div class="flex items-center justify-between">
            <h2 class="text-lg font-medium text-gray-900 dark:text-white">Experts recommandés</h2>
            <UButton 
              to="/client/experts" 
              color="gray" 
              variant="ghost" 
              icon="i-heroicons-arrow-right"
            >
              Voir tout
            </UButton>
          </div>
        </template>

        <div class="divide-y divide-gray-100 dark:divide-gray-800">
          <div v-for="expert in recommendedExperts" :key="expert.id" class="py-4">
            <div class="flex items-center gap-4">
              <UAvatar
                :src="expert.avatar"
                :alt="expert.name"
                size="lg"
              />
              <div class="min-w-0 flex-1">
                <h3 class="text-sm font-medium text-gray-900 dark:text-white">
                  {{ expert.name }}
                </h3>
                <p class="text-sm text-gray-600 dark:text-gray-400 mt-0.5">
                  {{ expert.profession }}
                </p>
                <div class="flex items-center gap-2 mt-1">
                  <div class="flex items-center">
                    <UIcon name="i-heroicons-star" class="w-4 h-4 text-amber-400" />
                    <span class="text-sm text-gray-600 dark:text-gray-400 ml-1">{{ expert.rating }}</span>
                  </div>
                  <span class="text-gray-300 dark:text-gray-600">•</span>
                  <span class="text-sm text-gray-600 dark:text-gray-400">{{ expert.jobs_completed }} missions</span>
                </div>
              </div>
              <UButton
                color="primary"
                variant="ghost"
                icon="i-heroicons-chat-bubble-left-right"
                :to="`/client/messages/${expert.id}`"
              />
            </div>
          </div>
        </div>
      </UCard>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { format } from 'date-fns'
import { fr } from 'date-fns/locale'

// Données simulées
const user = ref({
  first_name: 'Amadou',
  last_name: 'Diallo',
  email: 'amadou.diallo@example.com',
  phone: '+221 77 123 45 67'
})

const stats = ref({
  activeMissions: 2,
  proposals: 5,
  completedMissions: 8
})

const recentMissions = ref([
  {
    id: 1,
    title: 'Réparation climatiseur Samsung',
    status: 'in_progress',
    proposals: 3,
    created_at: new Date(Date.now() - 2 * 24 * 60 * 60 * 1000) // 2 jours
  },
  {
    id: 2,
    title: 'Installation électrique cuisine',
    status: 'pending',
    proposals: 1,
    created_at: new Date(Date.now() - 24 * 60 * 60 * 1000) // 1 jour
  },
  {
    id: 3,
    title: 'Peinture salon 25m²',
    status: 'completed',
    proposals: 4,
    created_at: new Date(Date.now() - 5 * 24 * 60 * 60 * 1000) // 5 jours
  }
])

const recommendedExperts = ref([
  {
    id: 1,
    name: 'Mohamed Sy',
    profession: 'Électricien',
    avatar: '',
    rating: 4.8,
    jobs_completed: 124
  },
  {
    id: 2,
    name: 'Fatou Ndiaye',
    profession: 'Architecte d\'intérieur',
    avatar: '',
    rating: 4.9,
    jobs_completed: 89
  },
  {
    id: 3,
    name: 'Omar Fall',
    profession: 'Plombier',
    avatar: '',
    rating: 4.7,
    jobs_completed: 156
  }
])

// Fonctions utilitaires
const getStatusIcon = (status: string) => {
  const icons = {
    pending: 'i-heroicons-clock',
    in_progress: 'i-heroicons-arrow-path',
    completed: 'i-heroicons-check-circle',
    cancelled: 'i-heroicons-x-circle'
  }
  return icons[status as keyof typeof icons] || 'i-heroicons-question-mark-circle'
}

const getStatusIconColor = (status: string) => {
  const colors = {
    pending: 'text-amber-500',
    in_progress: 'text-blue-500',
    completed: 'text-green-500',
    cancelled: 'text-red-500'
  }
  return colors[status as keyof typeof colors] || 'text-gray-500'
}

const formatMissionStatus = (status: string) => {
  const labels = {
    pending: 'En attente',
    in_progress: 'En cours',
    completed: 'Terminée',
    cancelled: 'Annulée'
  }
  return labels[status as keyof typeof labels] || status
}

const formatDate = (date: Date) => {
  return format(date, 'PPp', { locale: fr })
}

definePageMeta({
  layout: 'client'
})
</script> 