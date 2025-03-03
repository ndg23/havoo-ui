<template>
  <div class="bg-white rounded-lg shadow p-4">
    <img :src="item.image" :alt="item.name" class="w-full h-48 object-cover rounded-lg mb-4">
    <h3 class="text-lg font-semibold mb-2">{{ item.name }}</h3>
    <p class="text-gray-600 mb-4">{{ item.description }}</p>
    <div class="flex justify-between items-center">
      <span class="text-lg font-bold">{{ item.price }}€/jour</span>
      <button 
        @click="$emit('rent', item)"
        class="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700"
      >
        Louer
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
import type { Item } from '~/stores/user'

defineProps<{
  item: Item
}>()

defineEmits<{
  view: [item: Item]
  rent: [item: Item]
}>()
</script> 