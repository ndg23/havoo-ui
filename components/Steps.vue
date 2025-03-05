<template>
  <div class="relative">
    <div class="flex justify-between">
      <div 
        v-for="(step, index) in steps" 
        :key="index"
        class="flex flex-col items-center relative z-10"
      >
        <!-- Numéro de l'étape -->
        <div 
          class="w-10 h-10 rounded-full flex items-center justify-center font-medium transition-colors"
          :class="[
            currentStep > index 
              ? 'bg-primary-600 text-white' 
              : currentStep === index + 1
                ? 'bg-primary-100 text-primary-600'
                : 'bg-gray-100 text-gray-400'
          ]"
        >
          {{ index + 1 }}
        </div>
        <!-- Nom de l'étape -->
        <span 
          class="mt-2 text-sm transition-colors"
          :class="currentStep === index + 1 ? 'text-primary-600 font-medium' : 'text-gray-500'"
        >
          {{ step }}
        </span>
      </div>
    </div>
    <!-- Ligne de progression -->
    <div class="absolute top-5 left-0 right-0 h-[2px] bg-gray-200 -z-10">
      <div 
        class="h-full bg-primary-600 transition-all duration-300"
        :style="{ width: `${((currentStep - 1) / (steps.length - 1)) * 100}%` }"
      />
    </div>
  </div>
</template>

<script setup lang="ts">
defineProps<{
  currentStep: number
  steps: string[]
}>()
</script> 