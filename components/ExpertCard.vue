<template>
  <div 
    class="bg-white rounded-2xl border border-gray-200 p-6 h-full"
    :class="{ 'shadow-lg': swipeable }"
    v-touch:swipe.left="swipeable ? $emit('swipe-left') : null"
    v-touch:swipe.right="swipeable ? $emit('swipe-right', expert.id) : null"
  >
    <div class="flex items-start gap-4">
      <img :src="expert.avatar" class="w-16 h-16 rounded-xl object-cover" />
      <div>
        <h3 class="font-medium text-gray-900">{{ expert.name }}</h3>
        <p class="text-sm text-gray-500">{{ expert.services.join(', ') }}</p>
        <div class="flex items-center gap-1 mt-1">
          <StarIcon class="w-4 h-4 text-yellow-400" />
          <span class="text-sm font-medium">{{ expert.rating }}/5</span>
          <span class="text-sm text-gray-500">({{ expert.reviewsCount }})</span>
        </div>
      </div>
    </div>

    <div class="mt-4 space-y-2">
      <p class="text-sm text-gray-600">{{ expert.description }}</p>
      <div class="flex flex-wrap gap-2">
        <span 
          v-for="tag in expert.tags" 
          :key="tag"
          class="text-xs px-2 py-1 bg-gray-100 rounded-full"
        >
          {{ tag }}
        </span>
      </div>
    </div>

    <div v-if="!swipeable" class="mt-6 flex gap-3">
      <button 
        @click="$emit('contact', expert.id)"
        class="flex-1 py-2 bg-primary-500 text-white rounded-xl hover:bg-primary-600"
      >
        Contacter
      </button>
      <button 
        @click="$emit('view-profile', expert.id)"
        class="px-4 py-2 border border-gray-200 rounded-xl hover:bg-gray-50"
      >
        Profil
      </button>
    </div>
  </div>
</template>

<script setup>
import { StarIcon } from '@heroicons/vue/24/solid'

defineProps({
  expert: {
    type: Object,
    required: true
  },
  swipeable: {
    type: Boolean,
    default: false
  }
})

defineEmits(['contact', 'view-profile', 'swipe-left', 'swipe-right'])
</script> 