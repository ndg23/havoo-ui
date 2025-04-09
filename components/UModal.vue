<template>
  <TransitionRoot appear :show="modelValue" as="template">
    <Dialog as="div" class="relative z-50" @close="$emit('update:modelValue', false)">
      <!-- Fond sombre avec flou -->
      <TransitionChild
        as="template"
        enter="ease-out duration-300"
        enter-from="opacity-0"
        enter-to="opacity-100"
        leave="ease-in duration-200"
        leave-from="opacity-100"
        leave-to="opacity-0"
      >
        <div class="fixed inset-0 bg-black/30 backdrop-blur-sm" />
      </TransitionChild>

      <!-- Modal -->
      <div class="fixed inset-0 overflow-y-auto">
        <div class="flex min-h-full items-center justify-center p-4 text-center">
          <TransitionChild
            as="template"
            enter="ease-out duration-300"
            enter-from="opacity-0 scale-95"
            enter-to="opacity-100 scale-100"
            leave="ease-in duration-200"
            leave-from="opacity-100 scale-100"
            leave-to="opacity-0 scale-95"
          >
            <DialogPanel 
              class="w-full max-w-md transform overflow-hidden rounded-2xl bg-white dark:bg-gray-900 text-left align-middle shadow-xl transition-all"
            >
              <!-- En-tête -->
              <div class="relative border-b border-gray-100 dark:border-gray-800">
                <DialogTitle 
                  as="h3" 
                  class="text-lg font-semibold text-gray-900 dark:text-white p-4 pr-12"
                >
                  <slot name="header">
                    {{ title }}
                  </slot>
                </DialogTitle>
                
                <!-- Bouton fermer -->
                <button
                  class="absolute right-4 top-4 rounded-full p-1 text-gray-400 hover:text-gray-500 focus:outline-none focus:ring-2 focus:ring-primary-500"
                  @click="$emit('update:modelValue', false)"
                >
                  <span class="sr-only">Fermer</span>
                  <XMarkIcon class="h-5 w-5" aria-hidden="true" />
                </button>
              </div>

              <!-- Corps -->
              <div class="p-6">
                <slot />
              </div>

              <!-- Actions -->
              <div 
                v-if="$slots.footer"
                class="bg-gray-50 dark:bg-gray-800/50 px-4 py-4 sm:px-6 flex justify-end gap-3"
              >
                <slot name="footer" />
              </div>
            </DialogPanel>
          </TransitionChild>
        </div>
      </div>
    </Dialog>
  </TransitionRoot>
</template>

<script setup>
import { Dialog, DialogPanel, DialogTitle, TransitionRoot, TransitionChild } from '@headlessui/vue'
import { XMarkIcon } from '@heroicons/vue/24/outline'

defineProps({
  modelValue: {
    type: Boolean,
    required: true
  },
  title: {
    type: String,
    default: ''
  }
})

defineEmits(['update:modelValue'])
</script>

<style scoped>
/* Animation de rebond subtile */
.bounce-enter-active {
  animation: bounce-in 0.5s;
}
.bounce-leave-active {
  animation: bounce-in 0.5s reverse;
}
@keyframes bounce-in {
  0% {
    transform: scale(0.95);
  }
  50% {
    transform: scale(1.02);
  }
  100% {
    transform: scale(1);
  }
}

/* Effet de flou progressif */
.backdrop-blur-enter-active,
.backdrop-blur-leave-active {
  transition: backdrop-filter 0.3s ease;
}
.backdrop-blur-enter-from,
.backdrop-blur-leave-to {
  backdrop-filter: blur(0);
}
.backdrop-blur-enter-to,
.backdrop-blur-leave-from {
  backdrop-filter: blur(4px);
}
</style> 