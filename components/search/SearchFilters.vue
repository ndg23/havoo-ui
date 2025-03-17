<template>
  <div class="bg-white rounded-xl border border-gray-200 divide-y divide-gray-100">
    <!-- Prix -->
    <div class="p-6">
      <h3 class="font-medium text-gray-900 mb-4">Prix par jour</h3>
      <div class="space-y-3">
        <label v-for="range in priceRanges" :key="range.value" class="flex items-center gap-3">
          <input 
            type="radio" 
            v-model="filters.priceRange" 
            :value="range.value"
            class="text-orange-500 focus:ring-orange-500"
          >
          <span class="text-sm text-gray-600">{{ range.label }}</span>
        </label>
      </div>
    </div>

    <!-- Catégories -->
    <div class="p-6">
      <h3 class="font-medium text-gray-900 mb-4">Catégories</h3>
      <div class="space-y-3">
        <label 
          v-for="category in categories" 
          :key="category.id" 
          class="flex items-center gap-3"
        >
          <input 
            type="checkbox" 
            v-model="filters.categories" 
            :value="category.id"
            class="text-orange-500 focus:ring-orange-500 rounded"
          >
          <span class="text-sm text-gray-600">{{ category.name }}</span>
        </label>
      </div>
    </div>

    <!-- État -->
    <div class="p-6">
      <h3 class="font-medium text-gray-900 mb-4">État</h3>
      <div class="space-y-3">
        <label v-for="condition in conditions" :key="condition.value" class="flex items-center gap-3">
          <input 
            type="checkbox" 
            v-model="filters.conditions" 
            :value="condition.value"
            class="text-orange-500 focus:ring-orange-500 rounded"
          >
          <span class="text-sm text-gray-600">{{ condition.label }}</span>
        </label>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
interface Filters {
  priceRange: string
  categories: string[]
  conditions: string[]
}

const props = defineProps<{
  modelValue: Filters
}>()

const emit = defineEmits<{
  (e: 'update:modelValue', value: Filters): void
}>()

const filters = computed({
  get: () => props.modelValue,
  set: (value) => emit('update:modelValue', value)
})

const priceRanges = [
  { value: '0-25', label: 'Moins de 25FCFA' },
  { value: '25-50', label: '25FCFA - 50FCFA' },
  { value: '50+', label: 'Plus de 50FCFA' }
]

const categories = [
  { id: 'tools', name: 'Bricolage' },
  { id: 'garden', name: 'Jardin' },
  { id: 'sport', name: 'Sport' },
  { id: 'party', name: 'Fête' },
  { id: 'tech', name: 'High-Tech' }
]

const conditions = [
  { value: 'new', label: 'Neuf' },
  { value: 'like_new', label: 'Comme neuf' },
  { value: 'good', label: 'Bon état' }
]
</script> 