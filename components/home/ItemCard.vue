<template>
    <div 
      class="group bg-white rounded-xl overflow-hidden -shadow-sm hover:-shadow-xl 
             transition-all duration-300 relative flex flex-col"
    >
      <!-- Price Badge -->
      <div 
        class="absolute top-4 right-4 z-10 bg-white rounded-lg -shadow-lg px-3 py-2
               flex flex-col items-center"
      >
        <span class="text-lg font-bold text-blue-600">{{ item.price }}FCFA</span>
        <span class="text-xs text-gray-500">/jour</span>
        
        <!-- Price Indicator -->
        <div v-if="isPriceCompetitive" class="mt-1 flex items-center gap-1">
          <ArrowTrendingDownIcon class="w-4 h-4 text-green-500" />
          <span class="text-xs font-medium text-green-600">-15%</span>
        </div>
      </div>
  
      <!-- Image Container -->
      <div class="relative aspect-[4/3] overflow-hidden">
        <img 
          :src="item.image" 
          :alt="item.name"
          class="w-full h-full object-cover transition-transform duration-500 
                 group-hover:scale-110"
        />
        <div class="absolute inset-0 bg-gradient-to-t from-black/60 via-transparent 
                    opacity-0 group-hover:opacity-100 transition-opacity">
          <!-- Quick Action Buttons -->
          <div class="absolute bottom-4 left-4 right-4 flex justify-center gap-2
                      translate-y-full group-hover:translate-y-0 transition-transform">
            <button
              @click="$emit('view', item)"
              class="flex-1 bg-white/90 backdrop-blur-sm rounded-lg px-4 py-2
                     text-sm font-medium text-gray-900 hover:bg-white 
                     flex items-center justify-center gap-2"
            >
              <EyeIcon class="w-4 h-4" />
              Voir détails
            </button>
            <button
              @click="$emit('rent', item)"
              class="flex-1 bg-blue-600/90 backdrop-blur-sm rounded-lg px-4 py-2
                     text-sm font-medium text-white hover:bg-blue-600 
                     flex items-center justify-center gap-2"
            >
              <CalendarIcon class="w-4 h-4" />
              Louer
            </button>
          </div>
        </div>
      </div>
  
      <!-- Content -->
      <div class="p-6 flex-1 flex flex-col">
        <div class="mb-3">
          <div class="flex items-start justify-between gap-4">
            <h3 class="font-semibold text-gray-900 group-hover:text-blue-600 
                       transition-colors">
              {{ item.name }}
            </h3>
          </div>
          <p class="text-sm text-gray-600 line-clamp-2 mt-1">
            {{ item.description }}
          </p>
        </div>
  
        <div class="mt-auto pt-4 border-t flex items-center justify-between">
          <!-- Category & Rating -->
          <div class="flex items-center gap-4">
            <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full 
                        text-xs font-medium bg-gray-100 text-gray-800">
              {{ item.category }}
            </span>
            <div class="flex items-center gap-1">
              <StarIcon class="w-4 h-4 text-yellow-400" />
              <span class="text-sm font-medium text-gray-600">4.8</span>
            </div>
          </div>
  
          <!-- Distance -->
          <div class="flex items-center gap-1 text-sm text-gray-500">
            <MapPinIcon class="w-4 h-4" />
            <span>2.5 km</span>
          </div>
        </div>
      </div>
    </div>
  </template>
  
  <script setup lang="ts">
  import { 
    EyeIcon, 
    CalendarIcon,
    StarIcon,
    MapPinIcon,
    ArrowTrendingDownIcon
  } from '@heroicons/vue/24/outline'
  
  const props = defineProps<{
    item: {
      id: number
      name: string
      description: string
      price: number
      image: string
      category: string
    }
  }>()
  
  // Compute if price is competitive (example logic)
  const isPriceCompetitive = computed(() => {
    return props.item.price < 30
  })
  </script>