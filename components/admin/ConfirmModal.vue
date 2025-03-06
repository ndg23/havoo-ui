<template>
    <div v-if="show" class="fixed inset-0 z-50 overflow-y-auto">
      <!-- Backdrop -->
      <div class="fixed inset-0 bg-black bg-opacity-50 transition-opacity" @click="close"></div>
      
      <!-- Modal -->
      <div class="flex items-center justify-center min-h-screen p-4">
        <div 
          class="relative w-full max-w-md bg-white dark:bg-gray-800 rounded-2xl shadow-xl border border-gray-100 dark:border-gray-700 overflow-hidden transform transition-all"
          @click.stop
        >
          <!-- Header -->
          <div class="px-6 pt-6 pb-4">
            <div class="flex items-center">
              <slot name="icon"></slot>
              <h3 class="text-xl font-bold text-gray-900 dark:text-white">
                {{ title }}
              </h3>
            </div>
            
            <!-- Close button -->
            <button 
              @click="close"
              class="absolute top-4 right-4 text-gray-400 hover:text-gray-500 focus:outline-none p-2 rounded-full hover:bg-gray-100 dark:hover:bg-gray-700"
            >
              <X class="h-5 w-5" />
            </button>
            
            <!-- Content -->
            <div class="mt-4 text-sm text-gray-600 dark:text-gray-300">
              <slot></slot>
            </div>
          </div>
          
          <!-- Footer -->
          <div class="px-6 py-4 bg-gray-50 dark:bg-gray-750 rounded-b-2xl">
            <slot name="footer">
              <div class="flex justify-end gap-3">
                <button 
                  @click="close"
                  class="px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-opacity-30 transition-colors"
                >
                  Annuler
                </button>
                <button 
                  @click="confirm"
                  class="px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-red-500 focus:ring-opacity-30 transition-colors"
                >
                  Confirmer
                </button>
              </div>
            </slot>
          </div>
        </div>
      </div>
    </div>
  </template>
  
  <script setup>
  import { X } from 'lucide-vue-next';
  
  defineProps({
    show: {
      type: Boolean,
      default: false
    },
    title: {
      type: String,
      default: 'Confirmation'
    }
  });
  
  const emit = defineEmits(['close', 'confirm']);
  
  const close = () => {
    emit('close');
  };
  
  const confirm = () => {
    emit('confirm');
  };
  </script>