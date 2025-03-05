<template>
  <div class="space-y-8">
    <!-- Stats Overview -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
      <div 
        v-for="stat in stats" 
        :key="stat.name"
        class="bg-white p-6 rounded-xl border border-gray-200"
      >
        <div class="flex items-center gap-4">
          <div class="shrink-0 w-12 h-12 rounded-full bg-primary-50 flex items-center justify-center">
            <component :is="stat.icon" class="w-6 h-6 text-primary-600" />
          </div>
          <div>
            <p class="text-sm font-medium text-gray-600">{{ stat.name }}</p>
            <p class="text-2xl font-bold text-gray-900">{{ stat.value }}</p>
          </div>
        </div>
      </div>
    </div>

    <!-- Recent Activity -->
    <div class="bg-white rounded-xl border border-gray-200 overflow-hidden">
      <div class="border-b border-gray-200 p-6">
        <h2 class="text-lg font-medium text-gray-900">Activité récente</h2>
      </div>
      <div class="divide-y divide-gray-200">
        <div 
          v-for="activity in recentActivity" 
          :key="activity.id"
          class="p-6 flex items-start gap-4"
        >
          <div class="shrink-0 w-8 h-8 rounded-full bg-gray-100 flex items-center justify-center">
            <component :is="activity.icon" class="w-4 h-4 text-gray-600" />
          </div>
          <div>
            <p class="text-sm text-gray-900">{{ activity.description }}</p>
            <p class="text-xs text-gray-500 mt-1">{{ activity.time }}</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import {
  UsersIcon,
  WrenchScrewdriverIcon,
  ClipboardDocumentListIcon,
  CurrencyDollarIcon,
  UserPlusIcon,
  CheckCircleIcon,
  BriefcaseIcon
} from '@heroicons/vue/24/outline'

// Statistiques simulées
const stats = [
  { name: 'Utilisateurs', value: '1,234', icon: UsersIcon },
  { name: 'Experts actifs', value: '89', icon: WrenchScrewdriverIcon },
  { name: 'Demandes en cours', value: '45', icon: ClipboardDocumentListIcon },
  { name: 'Revenus du mois', value: '2.1M FCFA', icon: CurrencyDollarIcon }
]

// Activité récente simulée
const recentActivity = [
  {
    id: 1,
    icon: UserPlusIcon,
    description: 'Nouveau client inscrit : Marie Dupont',
    time: 'Il y a 5 minutes'
  },
  {
    id: 2,
    icon: CheckCircleIcon,
    description: 'Demande #123 complétée avec succès',
    time: 'Il y a 15 minutes'
  },
  {
    id: 3,
    icon: BriefcaseIcon,
    description: 'Nouvelle demande de service créée #124',
    time: 'Il y a 30 minutes'
  }
]

definePageMeta({
  layout: 'admin'
})
</script> 