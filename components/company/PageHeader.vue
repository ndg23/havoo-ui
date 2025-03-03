<template>
  <div class="border-b border-gray-100 -mx-4 px-4 mb-4">
    <div class="py-3">
      <h1 class="text-xl font-bold text-gray-900">{{ title }}</h1>
      <p v-if="description" class="mt-1 text-sm text-gray-500">
        {{ description }}
      </p>
    </div>
  </div>
</template>

<script setup lang="ts">
defineProps<{
  title: string
  description?: string
}>()
</script> 