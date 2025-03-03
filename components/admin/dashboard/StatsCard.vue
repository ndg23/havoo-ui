<template>
  <div class="bg-white rounded-lg shadow p-6">
    <div class="flex items-center">
      <div class="p-3 rounded-full" :class="bgColor">
        <component :is="icon" class="w-6 h-6 text-white" />
      </div>
      <div class="ml-4">
        <h3 class="text-lg font-semibold text-gray-600">{{ title }}</h3>
        <p class="text-2xl font-bold">{{ value }}</p>
      </div>
    </div>
    <div class="mt-4">
      <p class="text-sm text-gray-600">
        {{ description }}
      </p>
    </div>
  </div>
</template>

<script setup lang="ts">
interface Props {
  title: string
  value: string | number
  description: string
  bgColor: string
  icon: any // Vous pouvez utiliser une bibliothèque d'icônes comme @heroicons/vue
}

defineProps<Props>()
</script> 