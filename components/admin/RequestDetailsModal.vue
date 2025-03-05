<template>
  <Modal @close="$emit('close')">
    <template #title>
      Détails de la demande #{{ request.id }}
    </template>
    
    <template #content>
      <div class="space-y-6">
        <!-- Service Info -->
        <div class="flex items-start gap-4">
          <div class="w-12 h-12 rounded-xl bg-primary-50 flex items-center justify-center text-2xl">
            {{ request.service_icon }}
          </div>
          <div>
            <h3 class="font-medium text-gray-900">{{ request.service }}</h3>
            <div class="mt-1 flex items-center gap-2 text-sm text-gray-500">
              <CalendarIcon class="w-4 h-4" />
              {{ formatDate(request.date_needed) }} à {{ request.time_needed }}
            </div>
            <div class="mt-1 flex items-center gap-2 text-sm text-gray-500">
              <MapPinIcon class="w-4 h-4" />
              {{ request.location }}
            </div>
          </div>
        </div>

        <!-- Client Info -->
        <div class="border-t border-gray-200 pt-4">
          <h4 class="text-sm font-medium text-gray-700 mb-3">Client</h4>
          <div class="flex items-center gap-3">
            <img 
              :src="request.client.avatar_url || `https://ui-avatars.com/api/?name=${request.client.name}`"
              class="w-10 h-10 rounded-full"
            />
            <div>
              <div class="font-medium text-gray-900">{{ request.client.name }}</div>
              <div class="text-sm text-gray-500">{{ request.client.email }}</div>
            </div>
          </div>
        </div>

        <!-- Détails -->
        <div class="border-t border-gray-200 pt-4">
          <h4 class="text-sm font-medium text-gray-700 mb-3">Détails</h4>
          <div class="grid grid-cols-2 gap-4">
            <div>
              <p class="text-sm text-gray-500">Budget</p>
              <p class="font-medium text-gray-900">{{ request.budget }} FCFA</p>
            </div>
            <div>
              <p class="text-sm text-gray-500">Durée estimée</p>
              <p class="font-medium text-gray-900">{{ request.duration }}h</p>
            </div>
            <div>
              <p class="text-sm text-gray-500">Statut</p>
              <span 
                class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium mt-1"
                :class="{
                  'bg-yellow-100 text-yellow-800': request.status === 'pending',
                  'bg-blue-100 text-blue-800': request.status === 'accepted',
                  'bg-purple-100 text-purple-800': request.status === 'in_progress',
                  'bg-green-100 text-green-800': request.status === 'completed',
                  'bg-red-100 text-red-800': request.status === 'cancelled'
                }"
              >
                {{ request.status }}
              </span>
            </div>
          </div>
        </div>

        <!-- Description -->
        <div class="border-t border-gray-200 pt-4">
          <h4 class="text-sm font-medium text-gray-700 mb-3">Description</h4>
          <p class="text-gray-600">{{ request.description }}</p>
        </div>
      </div>
    </template>
  </Modal>
</template>

<script setup>
import { CalendarIcon, MapPinIcon } from '@heroicons/vue/24/outline'
import Modal from '~/components/shared/Modal.vue'

const props = defineProps({
  request: {
    type: Object,
    required: true
  }
})

defineEmits(['close'])

const formatDate = (date) => {
  return new Date(date).toLocaleDateString('fr-FR', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  })
}
</script> 