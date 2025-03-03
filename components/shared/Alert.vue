<template>
  <div 
    v-if="show"
    :class="[
      'fixed top-4 right-4 left-4 sm:max-w-sm sm:right-4 sm:left-auto p-4 rounded-xl shadow-lg border transition-all duration-300 z-50',
      type === 'error' ? 'bg-red-50 border-red-200 text-red-700' : 'bg-green-50 border-green-200 text-green-700'
    ]"
  >
    <div class="flex items-start gap-3">
      <!-- Icon -->
      <div class="flex-shrink-0" v-if="type === 'error'">
        <svg class="h-5 w-5 text-red-400" viewBox="0 0 24 24" fill="none">
          <path d="M12 9v3.75m9-.75a9 9 0 11-18 0 9 9 0 0118 0zm-9 3.75h.008v.008H12v-.008z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
      </div>
      <div class="flex-shrink-0" v-else>
        <svg class="h-5 w-5 text-green-400" viewBox="0 0 24 24" fill="none">
          <path d="M9 12.75L11.25 15 15 9.75M21 12a9 9 0 11-18 0 9 9 0 0118 0z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
      </div>

      <!-- Content -->
      <div class="flex-1">
        <p class="text-sm font-medium">{{ message }}</p>
      </div>

      <!-- Close button -->
      <button 
        @click="show = false"
        class="flex-shrink-0 ml-4"
      >
        <svg class="h-5 w-5 opacity-50 hover:opacity-100" viewBox="0 0 24 24" fill="none">
          <path d="M6 18L18 6M6 6l12 12" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
const props = defineProps<{
  message: string
  type: 'error' | 'success'
}>()

const show = ref(true)

// Auto-hide after 5 seconds
onMounted(() => {
  setTimeout(() => {
    show.value = false
  }, 5000)
})
</script> 