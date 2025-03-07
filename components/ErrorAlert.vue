<template>
  <div 
    class="flex items-center p-4 mb-4 text-sm rounded-lg border"
    :class="typeClasses[type]"
    role="alert"
  >
    <svg 
      v-if="type === 'error'" 
      class="shrink-0 inline w-4 h-4 me-3" 
      aria-hidden="true" 
      xmlns="http://www.w3.org/2000/svg" 
      fill="currentColor" 
      viewBox="0 0 20 20"
    >
      <path d="M10 .5a9.5 9.5 0 1 0 9.5 9.5A9.51 9.51 0 0 0 10 .5ZM9.5 4a1.5 1.5 0 1 1 0 3 1.5 1.5 0 0 1 0-3ZM12 15H8a1 1 0 0 1 0-2h1v-3H8a1 1 0 0 1 0-2h2a1 1 0 0 1 1 1v4h1a1 1 0 0 1 0 2Z"/>
    </svg>

    <svg 
      v-else-if="type === 'info'" 
      class="shrink-0 inline w-4 h-4 me-3" 
      aria-hidden="true" 
      xmlns="http://www.w3.org/2000/svg" 
      fill="currentColor" 
      viewBox="0 0 20 20"
    >
      <path d="M10 .5a9.5 9.5 0 1 0 9.5 9.5A9.51 9.51 0 0 0 10 .5ZM9.5 4a1.5 1.5 0 1 1 0 3 1.5 1.5 0 0 1 0-3ZM12 15H8a1 1 0 0 1 0-2h1v-3H8a1 1 0 0 1 0-2h2a1 1 0 0 1 1 1v4h1a1 1 0 0 1 0 2Z"/>
    </svg>

    <svg 
      v-else-if="type === 'warning'" 
      class="shrink-0 inline w-4 h-4 me-3" 
      aria-hidden="true" 
      xmlns="http://www.w3.org/2000/svg" 
      fill="currentColor" 
      viewBox="0 0 20 20"
    >
      <path d="M10 .5a9.5 9.5 0 1 0 9.5 9.5A9.51 9.51 0 0 0 10 .5ZM10 15a1 1 0 1 1 0-2 1 1 0 0 1 0 2Zm1-4a1 1 0 0 1-2 0V6a1 1 0 0 1 2 0v5Z"/>
    </svg>

    <svg 
      v-else-if="type === 'success'" 
      class="shrink-0 inline w-4 h-4 me-3" 
      aria-hidden="true" 
      xmlns="http://www.w3.org/2000/svg" 
      fill="currentColor" 
      viewBox="0 0 20 20"
    >
      <path d="M10 .5a9.5 9.5 0 1 0 9.5 9.5A9.51 9.51 0 0 0 10 .5Zm3.707 8.207-4 4a1 1 0 0 1-1.414 0l-2-2a1 1 0 0 1 1.414-1.414L9 10.586l3.293-3.293a1 1 0 0 1 1.414 1.414Z"/>
    </svg>

    <span class="sr-only">{{ type }}</span>
    <div>
      <span v-if="title" class="font-medium">{{ title }}</span>
      <span v-if="title && message"> - </span>
      {{ message }}
    </div>
    
    <button 
      v-if="dismissible"
      @click="$emit('dismiss')"
      class="ml-auto -mx-1.5 -my-1.5 rounded-lg focus:ring-2 p-1.5 inline-flex items-center justify-center h-8 w-8 hover:bg-gray-100 dark:hover:bg-gray-700"
      :class="dismissClasses[type]"
    >
      <span class="sr-only">Fermer</span>
      <svg class="w-3 h-3" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 14 14">
        <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m1 1 6 6m0 0 6 6M7 7l6-6M7 7l-6 6"/>
      </svg>
    </button>
  </div>
</template>

<script setup>
const props = defineProps({
  type: {
    type: String,
    default: 'error',
    validator: (value) => ['error', 'warning', 'info', 'success'].includes(value)
  },
  message: {
    type: String,
    required: true
  },
  title: {
    type: String,
    default: ''
  },
  dismissible: {
    type: Boolean,
    default: false
  }
})

defineEmits(['dismiss'])

const typeClasses = {
  error: 'text-red-800 border-red-300 bg-red-50 dark:bg-gray-800 dark:text-red-400 dark:border-red-800',
  warning: 'text-yellow-800 border-yellow-300 bg-yellow-50 dark:bg-gray-800 dark:text-yellow-300 dark:border-yellow-800',
  info: 'text-blue-800 border-blue-300 bg-blue-50 dark:bg-gray-800 dark:text-blue-400 dark:border-blue-800',
  success: 'text-green-800 border-green-300 bg-green-50 dark:bg-gray-800 dark:text-green-400 dark:border-green-800'
}

const dismissClasses = {
  error: 'bg-red-50 text-red-500 focus:ring-red-400 dark:bg-gray-800 dark:text-red-400 dark:hover:bg-gray-700',
  warning: 'bg-yellow-50 text-yellow-500 focus:ring-yellow-400 dark:bg-gray-800 dark:text-yellow-300 dark:hover:bg-gray-700',
  info: 'bg-blue-50 text-blue-500 focus:ring-blue-400 dark:bg-gray-800 dark:text-blue-400 dark:hover:bg-gray-700',
  success: 'bg-green-50 text-green-500 focus:ring-green-400 dark:bg-gray-800 dark:text-green-400 dark:hover:bg-gray-700'
}
</script> 