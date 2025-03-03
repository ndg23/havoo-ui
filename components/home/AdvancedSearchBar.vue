<template>
  <div class="w-full max-w-6xl mx-auto">
    <form @submit.prevent="handleSearch">
      <!-- Main Search Box -->
      <div class="bg-white rounded-3xl  overflow-hidden border border-gray-200">
        <!-- Search Header -->
        <div class="flex items-center gap-6 px-6 py-4 bg-gray-50 border-b border-gray-200">
          <button 
            type="button"
            class="flex items-center gap-2 px-4 py-2 rounded-full text-sm font-medium"
            :class="searchType === 'location' ? 'bg-blue-100 text-blue-700' : 'hover:bg-gray-100'"
            @click="searchType = 'location'"
          >
            <MapPinIcon class="w-5 h-5" />
            Par lieu
          </button>
          <button 
            type="button"
            class="flex items-center gap-2 px-4 py-2 rounded-full text-sm font-medium"
            :class="searchType === 'category' ? 'bg-blue-100 text-blue-700' : 'hover:bg-gray-100'"
            @click="searchType = 'category'"
          >
            <TagIcon class="w-5 h-5" />
            Par catégorie
          </button>
        </div>

        <!-- Main Search Grid -->
        <div class="grid grid-cols-1 md:grid-cols-12 divide-y md:divide-y-0 md:divide-x divide-gray-200">
          <!-- What -->
          <div class="md:col-span-5 relative group">
            <div class="p-6">
              <label class="block text-xs font-semibold text-gray-700 mb-1">
                Que cherchez-vous ?
              </label>
              <div class="relative">
                <input
                  v-model="searchParams.query"
                  type="text"
                  placeholder="Perceuse, tente, appareil..."
                  class="w-full pl-11 pr-4 py-2.5 text-lg font-medium border-0 focus:ring-0 bg-transparent placeholder-gray-400"
                />
                <SearchIcon class="w-5 h-5 text-blue-600 absolute left-2 top-1/2 -translate-y-1/2" />
              </div>
            </div>
          </div>

          <!-- Where -->
          <div class="md:col-span-4 relative group">
            <div class="p-6">
              <label class="block text-xs font-semibold text-gray-700 mb-1">
                Où ?
              </label>
              <div class="relative">
                <input
                  v-model="searchParams.location"
                  type="text"
                  placeholder="Saisissez une ville"
                  class="w-full pl-11 pr-4 py-2.5 text-lg font-medium border-0 focus:ring-0 bg-transparent placeholder-gray-400"
                />
                <MapPinIcon class="w-5 h-5 text-blue-600 absolute left-2 top-1/2 -translate-y-1/2" />
              </div>
            </div>
          </div>

          <!-- When -->
          <div class="md:col-span-3 relative group">
            <div class="p-6">
              <label class="block text-xs font-semibold text-gray-700 mb-1">
                Quand ?
              </label>
              <div class="relative">
                <input
                  v-model="searchParams.dates"
                  type="text"
                  placeholder="Choisir les dates"
                  class="w-full pl-11 pr-4 py-2.5 text-lg font-medium border-0 focus:ring-0 bg-transparent placeholder-gray-400"
                />
                <CalendarIcon class="w-5 h-5 text-blue-600 absolute left-2 top-1/2 -translate-y-1/2" />
              </div>
            </div>
          </div>
        </div>

        <!-- Advanced Filters -->
        <div class="bg-gray-50 px-6 py-4 flex flex-wrap items-center gap-6 border-t border-gray-200">
          <!-- Price Range -->
          <div class="relative">
            <select 
              v-model="searchParams.maxPrice"
              class="appearance-none pl-11 pr-8 py-2 rounded-full text-sm font-medium border border-gray-300 
                     hover:border-blue-500 focus:border-blue-500 focus:ring-1 focus:ring-blue-500 bg-white"
            >
              <option value="">Prix max/jour</option>
              <option value="10">Jusqu'à 10€</option>
              <option value="25">Jusqu'à 25€</option>
              <option value="50">Jusqu'à 50€</option>
              <option value="100">Jusqu'à 100€</option>
            </select>
            <AdjustmentsHorizontalIcon class="w-5 h-5 text-gray-400 absolute left-3 top-1/2 -translate-y-1/2" />
            <ChevronDownIcon class="w-4 h-4 text-gray-400 absolute right-3 top-1/2 -translate-y-1/2" />
          </div>

          <!-- Category Filter -->
          <div class="relative">
            <select 
              v-model="searchParams.category"
              class="appearance-none pl-11 pr-8 py-2 rounded-full text-sm font-medium border border-gray-300 
                     hover:border-blue-500 focus:border-blue-500 focus:ring-1 focus:ring-blue-500 bg-white"
            >
              <option value="">Toutes catégories</option>
              <option v-for="cat in categories" :key="cat.id" :value="cat.id">
                {{ cat.name }}
              </option>
            </select>
            <TagIcon class="w-5 h-5 text-gray-400 absolute left-3 top-1/2 -translate-y-1/2" />
            <ChevronDownIcon class="w-4 h-4 text-gray-400 absolute right-3 top-1/2 -translate-y-1/2" />
          </div>

          <!-- Search Button -->
          <button
            type="submit"
            class="ml-auto bg-blue-600 hover:bg-blue-700 text-white font-medium 
                   rounded-full px-8 py-2 transition-colors duration-200"
          >
            Rechercher
          </button>
        </div>
      </div>
    </form>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { 
  MagnifyingGlassIcon as SearchIcon,
  MapPinIcon,
  CalendarIcon,
  AdjustmentsHorizontalIcon,
  TagIcon,
  ChevronDownIcon
} from '@heroicons/vue/24/outline'

const searchType = ref('location')
const searchParams = ref({
  query: '',
  location: '',
  dates: '',
  maxPrice: '',
  category: '',
  sortBy: 'relevance'
})

const categories = [
  { id: 'tools', name: 'Bricolage' },
  { id: 'sport', name: 'Sport' },
  { id: 'camping', name: 'Camping' },
  { id: 'cooking', name: 'Cuisine' },
  { id: 'electronics', name: 'Électronique' },
  { id: 'garden', name: 'Jardin' }
]

const emit = defineEmits(['search'])

const handleSearch = () => {
  emit('search', searchParams.value)
}
</script>