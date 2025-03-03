<template>
  <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
    <div v-for="item in items" :key="item.id">
      <UserItemsItemCard 
        :item="item" 
        @rent="$emit('rent', item)"
        @view="$emit('view', item)"
      />
    </div>
  </div>
</template>

<script setup lang="ts">
import type { Item } from '~/stores/user'

defineProps<{
  items: Item[]
}>()

defineEmits<{
  rent: [item: Item]
  view: [item: Item]
}>()
</script> 