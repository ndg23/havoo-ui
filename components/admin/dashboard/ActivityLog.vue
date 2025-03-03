<template>
  <div class="space-y-4">
    <div v-for="activity in activities" :key="activity.id" class="flex items-start space-x-4">
      <!-- Icône selon le type d'activité -->
      <div :class="[
        'p-2 rounded-full',
        activityTypeStyles[activity.type]?.bg || 'bg-gray-100'
      ]">
        <component 
          :is="activityTypeStyles[activity.type]?.icon" 
          class="w-5 h-5"
          :class="activityTypeStyles[activity.type]?.iconColor"
        />
      </div>

      <div class="flex-1">
        <p class="text-sm text-gray-600">
          {{ activity.description }}
        </p>
        <span class="text-xs text-gray-500">
          {{ formatDate(activity.date) }}
        </span>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
interface Activity {
  id: number
  type: 'rental' | 'user' | 'item' | 'payment'
  description: string
  date: Date
}

const props = defineProps<{
  activities: Activity[]
}>()

// Styles et icônes selon le type d'activité
const activityTypeStyles = {
  rental: {
    bg: 'bg-blue-100',
    icon: 'CalendarIcon',
    iconColor: 'text-blue-600'
  },
  user: {
    bg: 'bg-green-100',
    icon: 'UserIcon',
    iconColor: 'text-green-600'
  },
  item: {
    bg: 'bg-purple-100',
    icon: 'CubeIcon',
    iconColor: 'text-purple-600'
  },
  payment: {
    bg: 'bg-yellow-100',
    icon: 'CurrencyEuroIcon',
    iconColor: 'text-yellow-600'
  }
}

const formatDate = (date: Date) => {
  return new Intl.DateTimeFormat('fr-FR', {
    dateStyle: 'medium',
    timeStyle: 'short'
  }).format(new Date(date))
}
</script> 