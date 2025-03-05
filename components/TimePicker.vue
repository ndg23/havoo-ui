<template>
  <div class="space-y-4">
    <label class="block text-sm font-medium text-gray-700">
      À quelle heure préférez-vous ?
    </label>
    
    <!-- Options d'horaires -->
    <div class="grid grid-cols-3 sm:grid-cols-4 gap-3">
      <button
        v-for="time in timeOptions"
        :key="time"
        type="button"
        @click="selectTime(time)"
        class="px-4 py-2 rounded-lg border-2 text-sm font-medium transition-colors"
        :class="modelValue === time 
          ? 'border-primary-600 bg-primary-50 text-primary-700' 
          : 'border-gray-200 hover:border-gray-300 text-gray-700'"
      >
        {{ time }}
      </button>
    </div>
    
    <!-- Option personnalisée -->
    <div class="mt-4">
      <div class="flex items-center gap-2">
        <input 
          type="checkbox" 
          id="custom-time"
          v-model="useCustomTime"
          class="rounded text-primary-600 focus:ring-primary-500"
        />
        <label for="custom-time" class="text-sm text-gray-700">
          Horaire personnalisé
        </label>
      </div>
      
      <div v-if="useCustomTime" class="mt-3">
        <input 
          type="time"
          v-model="customTime"
          class="w-full rounded-lg border-gray-200 focus:border-primary-500 focus:ring-primary-500"
        />
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'

const props = defineProps<{
  modelValue: string
}>()

const emit = defineEmits<{
  'update:modelValue': [value: string]
}>()

// Options d'horaires prédéfinies
const timeOptions = [
  '08:00', '10:00', '12:00', 
  '14:00', '16:00', '18:00',
  '20:00', 'Flexible'
]

// Gestion de l'horaire personnalisé
const useCustomTime = ref(false)
const customTime = ref('12:00')

// Sélectionner un horaire
const selectTime = (time: string) => {
  useCustomTime.value = false
  emit('update:modelValue', time)
}

// Observer les changements d'horaire personnalisé
watch(customTime, (newValue) => {
  if (useCustomTime.value) {
    emit('update:modelValue', newValue)
  }
})

// Observer l'activation/désactivation de l'horaire personnalisé
watch(useCustomTime, (newValue) => {
  if (newValue) {
    emit('update:modelValue', customTime.value)
  } else if (props.modelValue === customTime.value) {
    // Si on désactive l'horaire personnalisé, sélectionner une option par défaut
    emit('update:modelValue', '14:00')
  }
})
</script> 