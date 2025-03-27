<template>
    <TransitionRoot appear :show="isOpen" as="template">
      <Dialog as="div" @close="close" class="relative z-50">
        <TransitionChild
          enter="ease-out duration-300"
          enter-from="opacity-0"
          enter-to="opacity-100"
          leave="ease-in duration-200"
          leave-from="opacity-100"
          leave-to="opacity-0"
        >
          <div class="fixed inset-0 bg-black bg-opacity-25" />
        </TransitionChild>
  
        <div class="fixed inset-0 overflow-y-auto">
          <div class="flex min-h-full items-center justify-center p-4">
            <TransitionChild
              enter="ease-out duration-300"
              enter-from="opacity-0 scale-95"
              enter-to="opacity-100 scale-100"
              leave="ease-in duration-200"
              leave-from="opacity-100 scale-100"
              leave-to="opacity-0 scale-95"
            >
              <DialogPanel class="w-full max-w-md transform overflow-hidden rounded-2xl bg-white dark:bg-gray-800 p-6 text-left align-middle shadow-xl transition-all">
                <DialogTitle class="text-lg font-medium leading-6 text-gray-900 dark:text-white">
                  {{ title }}
                </DialogTitle>
                <div class="mt-2">
                  <p class="text-sm text-gray-500 dark:text-gray-400">
                    {{ message }}
                  </p>
                </div>
  
                <div class="mt-4 flex gap-3">
                  <button
                    v-for="option in options"
                    :key="option.value"
                    @click="select(option.value)"
                    class="inline-flex justify-center rounded-md border px-4 py-2 text-sm font-medium focus:outline-none focus-visible:ring-2 focus-visible:ring-offset-2"
                    :class="option.primary ? 'bg-primary-600 text-white hover:bg-primary-500' : 'border-gray-300 text-gray-700 hover:bg-gray-50'"
                  >
                    {{ option.label }}
                  </button>
                </div>
              </DialogPanel>
            </TransitionChild>
          </div>
        </div>
      </Dialog>
    </TransitionRoot>
  </template>
  
  <script setup>
  import { ref } from 'vue';
  import {
    Dialog,
    DialogPanel,
    DialogTitle,
    TransitionRoot,
    TransitionChild,
  } from '@headlessui/vue';
  
  const props = defineProps({
    title: String,
    message: String,
    options: Array
  });
  
  const emit = defineEmits(['select']);
  
  const isOpen = ref(true);
  
  const select = (value) => {
    isOpen.value = false;
    emit('select', value);
  };
  
  const close = () => {
    isOpen.value = false;
    emit('select', null);
  };
  </script>