<template>
  <div class="flex-1">
    <TransitionGroup
      :class="[
        viewMode === 'grid' 
          ? 'grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6'
          : 'space-y-4'
      ]"
      name="items"
      appear
    >
      <ItemCard
        v-for="item in items"
        :key="item.id"
        :item="item"
        :view-mode="viewMode"
        class="bg-white rounded-2xl p-4 border border-gray-100 hover:border-orange-100 transition-colors"
        @view="$emit('view', item)"
        @rent="$emit('rent', item)"
      />
    </TransitionGroup>

    <!-- État vide -->
    <div 
      v-if="items.length === 0"
      class="text-center py-12"
    >
      <div class="w-16 h-16 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-4">
        <MagnifyingGlassIcon class="w-8 h-8 text-gray-400" />
      </div>
      <h3 class="text-lg font-medium text-gray-900 mb-2">
        Aucun résultat trouvé
      </h3>
      <p class="text-gray-500">
        Essayez de modifier vos filtres ou votre recherche
      </p>
    </div>
  </div>
</template>

<script setup lang="ts">
import { MagnifyingGlassIcon } from '@heroicons/vue/24/outline'
import ItemCard from '~/components/home/ItemCard.vue'

interface Item {
  id: string
  name: string
  description: string
  price: number
  image: string
  category: string
  condition: string
  available: boolean
  owner: {
    id: string
    name: string
    avatar: string
  }
}

defineProps<{
  items: Item[]
  viewMode: 'grid' | 'list'
}>()

defineEmits<{
  (e: 'view', item: Item): void
  (e: 'rent', item: Item): void
}>()
</script>

<style scoped>
.items-move,
.items-enter-active,
.items-leave-active {
  transition: all 0.3s ease;
}

.items-enter-from,
.items-leave-to {
  opacity: 0;
  transform: translateY(30px);
}

.items-leave-active {
  position: absolute;
}
</style> 