<template>
  <transition
    enter-active-class="transform ease-out duration-200"
    enter-from-class="opacity-0 -translate-y-1"
    enter-to-class="opacity-100 translate-y-0"
    leave-active-class="transition ease-in duration-150"
    leave-from-class="opacity-100"
    leave-to-class="opacity-0"
  >
    <div v-if="message" 
      class="bg-white rounded-xl shadow-sm border-l-4 border-red-500 overflow-hidden mb-6"
    >
      <div class="p-4 flex items-center gap-3">
        <!-- Simple icon -->
        <div class="flex-shrink-0">
          <XCircle class="h-5 w-5 text-red-500" />
        </div>

        <!-- Message -->
        <div class="flex-1 min-w-0">
          <p class="text-sm text-gray-700">
            {{ message }}
          </p>
        </div>

        <!-- Subtle close button -->
        <button
          type="button"
          @click="$emit('dismiss')"
          class="flex-shrink-0 text-gray-400 hover:text-gray-500 
            transition-colors p-1 rounded-full"
        >
          <span class="sr-only">Fermer</span>
          <X class="h-4 w-4" />
        </button>
      </div>
    </div>
  </transition>
</template>

<script setup>
import { XCircle, X } from 'lucide-vue-next'

defineProps({
  message: {
    type: String,
    default: ''
  }
})

defineEmits(['dismiss'])
</script> 