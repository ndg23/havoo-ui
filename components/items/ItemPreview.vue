<template>
  <div class="bg-white rounded-xl border">
    <div class="p-6">
      <h2 class="text-lg font-semibold text-gray-900 mb-6 flex items-center">
        <EyeIcon class="w-5 h-5 text-orange-500 mr-2" />
        Aperçu
      </h2>

      <!-- Image preview -->
      <div class="relative aspect-video rounded-xl overflow-hidden bg-gray-100 mb-4">
        <div v-if="images.length" class="relative w-full h-full">
          <!-- Main image -->
          <img 
            :src="currentImageUrl"
            class="w-full h-full object-cover"
            alt=""
          />
          
          <!-- Image counter -->
          <div class="absolute bottom-3 right-3 bg-black/50 text-white text-xs px-2 py-1 rounded-full">
            {{ currentImageIndex + 1 }}/{{ images.length }}
          </div>

          <!-- Navigation buttons -->
          <button
            v-if="images.length > 1"
            class="absolute left-2 top-1/2 -translate-y-1/2 bg-black/50 hover:bg-black/70 text-white rounded-full p-1 transition-colors"
            @click="previousImage"
          >
            <ChevronLeftIcon class="w-5 h-5" />
          </button>
          <button
            v-if="images.length > 1"
            class="absolute right-2 top-1/2 -translate-y-1/2 bg-black/50 hover:bg-black/70 text-white rounded-full p-1 transition-colors"
            @click="nextImage"
          >
            <ChevronRightIcon class="w-5 h-5" />
          </button>
        </div>
        <div 
          v-else 
          class="w-full h-full flex items-center justify-center"
        >
          <ImageIcon class="w-12 h-12 text-gray-300" />
        </div>
      </div>

      <!-- Thumbnails -->
      <div v-if="images.length > 1" class="flex gap-2 mb-6">
        <button
          v-for="(image, index) in images"
          :key="index"
          class="w-16 h-16 rounded-lg overflow-hidden relative"
          :class="{ 'ring-2 ring-orange-500': currentImageIndex === index }"
          @click="currentImageIndex = index"
        >
          <img 
            :src="getImageUrl(image)"
            class="w-full h-full object-cover"
            alt=""
          />
        </button>
      </div>

      <!-- Item details -->
      <div class="space-y-4">
        <div>
          <h3 class="font-medium text-gray-900">{{ name || 'Nom de l\'objet' }}</h3>
          <p class="text-sm text-gray-500 line-clamp-2">{{ description || 'Description de l\'objet' }}</p>
        </div>

        <div class="flex items-center justify-between">
          <div class="flex items-center gap-4">
            <span class="text-2xl font-bold text-orange-500">{{ price }}FCFA</span>
            <span class="text-sm text-gray-500">par jour</span>
          </div>
          <div class="text-sm text-gray-500">
            Caution : {{ deposit }}FCFA
          </div>
        </div>

        <div class="flex items-center gap-2 text-sm text-gray-500">
          <ClockIcon class="w-4 h-4" />
          <span>Location minimum : {{ minDuration }} jour{{ minDuration > 1 ? 's' : '' }}</span>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { 
  EyeIcon, 
  ChevronLeftIcon, 
  ChevronRightIcon,
  ImageIcon,
  ClockIcon 
} from '@heroicons/vue/24/outline'

const props = defineProps<{
  name?: string
  description?: string
  price?: number
  deposit?: number
  minDuration?: number
  images: (File | { url: string })[]
}>()

const currentImageIndex = ref(0)

const currentImageUrl = computed(() => {
  return getImageUrl(props.images[currentImageIndex.value])
})

const getImageUrl = (image: File | { url: string }) => {
  if (image instanceof File) {
    return URL.createObjectURL(image)
  }
  return image.url
}

const nextImage = () => {
  currentImageIndex.value = (currentImageIndex.value + 1) % props.images.length
}

const previousImage = () => {
  currentImageIndex.value = currentImageIndex.value === 0 
    ? props.images.length - 1 
    : currentImageIndex.value - 1
}
</script> 