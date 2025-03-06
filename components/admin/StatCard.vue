<template>
  <div class="bg-white rounded-xl border border-gray-200 p-5 shadow-sm hover:shadow-md transition-shadow">
    <div class="flex items-center">
      <div 
        class="h-12 w-12 rounded-full flex items-center justify-center"
        :class="[`bg-${color}-50`]"
      >
        <component :is="icon" class="h-6 w-6" :class="[`text-${color}-600`]" />
      </div>
      <div class="ml-4">
        <p class="text-sm font-medium text-gray-500">{{ title }}</p>
        <p class="mt-1 text-2xl font-semibold text-gray-900">{{ value }}</p>
      </div>
    </div>
  </div>
</template>

<script setup>
defineProps({
  title: {
    type: String,
    required: true
  },
  value: {
    type: [String, Number],
    required: true
  },
  icon: {
    type: Object,
    required: true
  },
  color: {
    type: String,
    default: 'blue',
    validator: (value) => ['blue', 'green', 'red', 'yellow', 'purple', 'indigo', 'pink', 'amber'].includes(value)
  }
})
</script> 