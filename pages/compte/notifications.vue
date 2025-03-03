<template>
  <div>
    <h1 class="text-2xl font-bold text-gray-900 mb-8">Notifications</h1>

    <!-- Liste des notifications -->
    <div class="space-y-4">
      <div v-for="notification in notifications" :key="notification.id"
        class="bg-white rounded-2xl border border-gray-200 p-6"
        :class="{ 'bg-primary-50': !notification.read }"
      >
        <div class="flex items-start gap-4">
          <div class="flex-shrink-0">
            <div 
              class="w-10 h-10 rounded-xl flex items-center justify-center"
              :class="notificationStyles[notification.type].bg"
            >
              <component 
                :is="notificationIcons[notification.type]" 
                class="w-5 h-5"
                :class="notificationStyles[notification.type].icon"
              />
            </div>
          </div>
          <div class="flex-1 min-w-0">
            <p class="text-sm font-medium text-gray-900">
              {{ notification.title }}
            </p>
            <p class="mt-1 text-sm text-gray-500">
              {{ notification.message }}
            </p>
            <div class="mt-2 text-xs text-gray-400">
              {{ formatDate(notification.created_at) }}
            </div>
          </div>
          <button 
            v-if="!notification.read"
            @click="markAsRead(notification.id)"
            class="text-primary-600 hover:text-primary-700 text-sm font-medium"
          >
            Marquer comme lu
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import {
  CheckCircleIcon,
  BellAlertIcon,
  ExclamationTriangleIcon
} from '@heroicons/vue/24/outline'

definePageMeta({
  layout: 'profile'
})

// Données de test
const notifications = ref([
  {
    id: 1,
    type: 'success',
    title: 'Demande acceptée',
    message: 'Votre demande de ménage a été acceptée par Marie D.',
    created_at: '2024-03-10T10:00:00',
    read: false
  },
  {
    id: 2,
    type: 'info',
    title: 'Nouvelle proposition',
    message: 'Vous avez reçu une nouvelle proposition pour votre demande de jardinage.',
    created_at: '2024-03-09T15:30:00',
    read: true
  }
])

const notificationIcons = {
  success: CheckCircleIcon,
  info: BellAlertIcon,
  warning: ExclamationTriangleIcon
}

const notificationStyles = {
  success: {
    bg: 'bg-green-50',
    icon: 'text-green-500'
  },
  info: {
    bg: 'bg-blue-50',
    icon: 'text-blue-500'
  },
  warning: {
    bg: 'bg-yellow-50',
    icon: 'text-yellow-500'
  }
}

const formatDate = (date) => {
  return new Date(date).toLocaleDateString('fr-FR', {
    day: 'numeric',
    month: 'long',
    year: 'numeric',
    hour: 'numeric',
    minute: 'numeric'
  })
}

const markAsRead = async (id) => {
  // Logique pour marquer comme lu
  const notification = notifications.value.find(n => n.id === id)
  if (notification) {
    notification.read = true
  }
}
</script> 