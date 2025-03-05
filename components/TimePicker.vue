<template>
  <div class="space-y-6">
    <h3 class="text-lg font-medium text-gray-900">À quelle heure préférez-vous ?</h3>
    
    <!-- Périodes de la journée -->
    <div class="grid grid-cols-4 gap-3">
      <button
        v-for="period in timePeriods"
        :key="period.id"
        type="button"
        @click="selectPeriod(period.id)"
        class="relative flex flex-col items-center p-4 rounded-xl border-2 transition-all duration-300"
        :class="selectedPeriod === period.id 
          ? 'border-primary-600 bg-primary-50' 
          : 'border-gray-200 hover:border-gray-300'"
      >
        <!-- Icône -->
        <div 
          class="w-10 h-10 rounded-full flex items-center justify-center mb-2"
          :class="selectedPeriod === period.id ? 'bg-primary-100' : 'bg-gray-100'"
        >
          <component 
            :is="period.icon" 
            class="w-5 h-5"
            :class="selectedPeriod === period.id ? 'text-primary-600' : 'text-gray-600'" 
          />
        </div>
        
        <!-- Label -->
        <span 
          class="text-sm font-medium text-center"
          :class="selectedPeriod === period.id ? 'text-primary-700' : 'text-gray-900'"
        >
          {{ period.label }}
        </span>
        
        <!-- Check icon -->
        <div 
          v-if="selectedPeriod === period.id"
          class="absolute top-2 right-2 w-5 h-5 rounded-full bg-primary-600 flex items-center justify-center"
        >
          <Check class="w-3 h-3 text-white" />
        </div>
      </button>
    </div>
    
    <!-- Heures spécifiques -->
    <div v-if="selectedPeriod !== 'flexible'" class="mt-6">
      <h4 class="font-medium text-gray-900 mb-3">Choisissez une heure précise</h4>
      
      <div class="grid grid-cols-4 gap-2">
        <button
          v-for="time in filteredTimes"
          :key="time"
          type="button"
          @click="selectTime(time)"
          class="py-2 px-3 rounded-lg border text-sm font-medium transition-colors"
          :class="modelValue === time 
            ? 'border-primary-600 bg-primary-50 text-primary-700' 
            : 'border-gray-200 hover:border-gray-300 text-gray-700'"
        >
          {{ formatTime(time) }}
        </button>
      </div>
    </div>
    
    <!-- Option personnalisée -->
    <div class="mt-6 p-4 bg-gray-50 rounded-xl">
      <div class="flex items-center gap-3">
        <div class="w-10 h-10 rounded-full bg-gray-200 flex items-center justify-center">
          <Clock class="w-5 h-5 text-gray-600" />
        </div>
        <div class="flex-1">
          <h4 class="font-medium text-gray-900">Horaire personnalisé</h4>
          <p class="text-sm text-gray-500">Spécifiez une heure précise qui vous convient</p>
        </div>
        <button 
          class="px-3 py-1.5 text-sm font-medium text-primary-600 border border-primary-600 rounded-full hover:bg-primary-50"
          @click="useCustomTime = !useCustomTime"
        >
          {{ useCustomTime ? 'Fermer' : 'Préciser' }}
        </button>
      </div>
      
      <div v-if="useCustomTime" class="mt-4">
        <input 
          type="time"
          v-model="customTime"
          class="w-full rounded-lg border-gray-200 focus:border-primary-500 focus:ring-primary-500"
        />
      </div>
    </div>
    
    <!-- Heure sélectionnée -->
    <div v-if="modelValue" class="mt-6 p-4 bg-primary-50 rounded-xl">
      <div class="flex items-center gap-3">
        <div class="w-10 h-10 rounded-full bg-primary-100 flex items-center justify-center">
          <Clock class="w-5 h-5 text-primary-600" />
        </div>
        <div>
          <div class="text-sm text-primary-600">Heure sélectionnée</div>
          <div class="font-medium text-primary-800">
            {{ modelValue === 'Flexible' ? 'Horaire flexible' : formatTime(modelValue) }}
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, watch } from 'vue'
import { Clock, Sun, Sunset, Moon, Zap, Check } from 'lucide-vue-next'

const props = defineProps<{
  modelValue: string
}>()

const emit = defineEmits<{
  'update:modelValue': [value: string]
}>()

// État
const selectedPeriod = ref('morning')
const useCustomTime = ref(false)
const customTime = ref('12:00')

// Périodes de la journée
const timePeriods = [
  { id: 'morning', label: 'Matin', icon: Sun, range: ['07:00', '12:00'] },
  { id: 'afternoon', label: 'Après-midi', icon: Sunset, range: ['12:00', '18:00'] },
  { id: 'evening', label: 'Soir', icon: Moon, range: ['18:00', '22:00'] },
  { id: 'flexible', label: 'Flexible', icon: Zap }
]

// Heures disponibles par période
const timesByPeriod = {
  morning: ['07:00', '08:00', '09:00', '10:00', '11:00'],
  afternoon: ['12:00', '13:00', '14:00', '15:00', '16:00', '17:00'],
  evening: ['18:00', '19:00', '20:00', '21:00', '22:00']
}

// Heures filtrées selon la période sélectionnée
const filteredTimes = computed(() => {
  if (selectedPeriod.value === 'flexible') return []
  return timesByPeriod[selectedPeriod.value as keyof typeof timesByPeriod]
})

// Sélectionner une période
const selectPeriod = (periodId: string) => {
  selectedPeriod.value = periodId
  
  if (periodId === 'flexible') {
    emit('update:modelValue', 'Flexible')
  } else {
    // Sélectionner l'heure du milieu de la période
    const times = timesByPeriod[periodId as keyof typeof timesByPeriod]
    const middleIndex = Math.floor(times.length / 2)
    emit('update:modelValue', times[middleIndex])
  }
}

// Sélectionner une heure spécifique
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

// Formater l'heure pour l'affichage
const formatTime = (time: string) => {
  if (time === 'Flexible') return 'Flexible'
  
  const [hours, minutes] = time.split(':')
  return `${hours}h${minutes !== '00' ? minutes : ''}`
}
</script> 