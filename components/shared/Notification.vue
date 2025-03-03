<template>
  <TransitionRoot
    appear
    :show="notifications.length > 0"
    as="template"
  >
    <div class="fixed top-4 right-4 z-50">
      <TransitionGroup
        enter="transform ease-out duration-300 transition"
        enter-from="translate-y-2 opacity-0"
        enter-to="translate-y-0 opacity-100"
        leave="transition ease-in duration-100"
        leave-from="opacity-100"
        leave-to="opacity-0"
      >
        <div
          v-for="notification in notifications"
          :key="notification.id"
          class="max-w-sm w-full bg-white shadow-lg rounded-lg pointer-events-auto ring-1 mb-4"
          :class="[
            notification.type === 'success' ? 'ring-green-500' : 'ring-red-500'
          ]"
        >
          <div class="p-4">
            <div class="flex items-start">
              <div class="flex-shrink-0">
                <CheckCircleIcon
                  v-if="notification.type === 'success'"
                  class="h-6 w-6 text-green-500"
                />
                <XCircleIcon
                  v-else
                  class="h-6 w-6 text-red-500"
                />
              </div>
              <div class="ml-3 w-0 flex-1">
                <p class="text-sm font-medium text-gray-900">
                  {{ notification.title }}
                </p>
                <p class="mt-1 text-sm text-gray-500">
                  {{ notification.message }}
                </p>
              </div>
              <div class="ml-4 flex-shrink-0 flex">
                <button
                  class="rounded-md inline-flex text-gray-400 hover:text-gray-500"
                  @click="removeNotification(notification.id)"
                >
                  <XMarkIcon class="h-5 w-5" />
                </button>
              </div>
            </div>
          </div>
        </div>
      </TransitionGroup>
    </div>
  </TransitionRoot>
</template>

<script setup lang="ts">
import { TransitionRoot, TransitionGroup } from '@headlessui/vue'
import { CheckCircleIcon, XCircleIcon, XMarkIcon } from '@heroicons/vue/24/outline'
import { useNotificationStore } from '~/stores/notification'

const notificationStore = useNotificationStore()
const notifications = computed(() => notificationStore.notifications)

const removeNotification = (id: string) => {
  notificationStore.remove(id)
}
</script> 