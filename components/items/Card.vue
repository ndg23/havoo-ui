<template>
  <div class="bg-white rounded-xl -shadow-sm overflow-hidden">
    <!-- Image principale -->
    <div class="relative aspect-[4/3]">
      <img 
        :src="item.images[0]" 
        :alt="item.title"
        class="w-full h-full object-cover"
      />
      <div 
        class="absolute top-2 right-2 px-2 py-1 rounded-full text-xs font-medium"
        :class="statusClasses[item.availability.status]"
      >
        {{ statusLabels[item.availability.status] }}
      </div>
    </div>

    <!-- Informations -->
    <div class="p-4">
      <h3 class="font-medium text-gray-900">{{ item.title }}</h3>
      
      <div class="mt-2 flex items-center justify-between">
        <p class="text-lg font-semibold text-gray-900">
          {{ formatPrice(item.price.daily) }}FCFA <span class="text-sm text-gray-500">/jour</span>
        </p>
        <div class="flex items-center text-sm text-gray-500">
          <StarIcon class="w-4 h-4 text-yellow-400" />
          {{ item.stats.rating }}
          <span class="mx-1">•</span>
          {{ item.stats.rentals }} locations
        </div>
      </div>

      <div class="mt-4 flex items-center gap-2">
        <button
          @click="$emit('edit', item.id)"
          class="flex-1 px-3 py-2 text-sm font-medium text-gray-700 bg-gray-100 
                 rounded-lg hover:bg-gray-200"
        >
          Modifier
        </button>
        <button
          @click="$emit('delete', item.id)"
          class="px-3 py-2 text-sm font-medium text-red-600 hover:bg-red-50 rounded-lg"
        >
          Supprimer
        </button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { StarIcon } from '@heroicons/vue/24/solid'
import type { Item } from '~/types'

const props = defineProps<{
  item: Item
}>()

defineEmits<{
  (e: 'edit', id: string): void
  (e: 'delete', id: string): void
}>()

const statusLabels = {
  available: 'Disponible',
  rented: 'Loué',
  maintenance: 'En maintenance',
  unavailable: 'Indisponible'
}

const statusClasses = {
  available: 'bg-green-100 text-green-800',
  rented: 'bg-blue-100 text-blue-800',
  maintenance: 'bg-yellow-100 text-yellow-800',
  unavailable: 'bg-gray-100 text-gray-800'
}

const formatPrice = (price: number) => {
  return new Intl.NumberFormat('fr-FR').format(price)
}
</script> 