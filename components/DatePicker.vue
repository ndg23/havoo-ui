<template>
  <div class="space-y-4">
    <label class="block text-sm font-medium text-gray-700">
      Quand avez-vous besoin de ce service ?
    </label>
    
    <!-- Sélection rapide -->
    <div class="grid grid-cols-2 sm:grid-cols-4 gap-3">
      <button
        v-for="option in quickOptions"
        :key="option.value"
        type="button"
        @click="selectQuickOption(option.value)"
        class="px-4 py-2 rounded-lg border-2 text-sm font-medium transition-colors"
        :class="isSelected(option.value) 
          ? 'border-primary-600 bg-primary-50 text-primary-700' 
          : 'border-gray-200 hover:border-gray-300 text-gray-700'"
      >
        {{ option.label }}
      </button>
    </div>
    
    <!-- Calendrier -->
    <div class="mt-6">
      <div class="grid grid-cols-7 gap-1 mb-2">
        <div 
          v-for="day in ['L', 'M', 'M', 'J', 'V', 'S', 'D']" 
          :key="day"
          class="text-center text-xs font-medium text-gray-500 py-1"
        >
          {{ day }}
        </div>
      </div>
      
      <div class="grid grid-cols-7 gap-1">
        <button
          v-for="date in calendarDates"
          :key="date.value"
          type="button"
          @click="toggleDate(date.value)"
          :disabled="date.disabled"
          class="aspect-square rounded-lg flex items-center justify-center text-sm transition-colors"
          :class="[
            date.disabled 
              ? 'text-gray-300 cursor-not-allowed' 
              : isSelected(date.value)
                ? 'bg-primary-600 text-white'
                : 'hover:bg-gray-100 text-gray-700'
          ]"
        >
          {{ new Date(date.value).getDate() }}
        </button>
      </div>
    </div>
    
    <!-- Dates sélectionnées -->
    <div v-if="modelValue.length > 0" class="mt-4 flex flex-wrap gap-2">
      <div 
        v-for="date in modelValue" 
        :key="date"
        class="px-3 py-1 bg-primary-50 text-primary-700 rounded-full text-sm flex items-center gap-1"
      >
        {{ formatDate(date) }}
        <button 
          @click="removeDate(date)"
          class="w-4 h-4 rounded-full bg-primary-200 hover:bg-primary-300 flex items-center justify-center"
        >
          <X class="w-3 h-3 text-primary-700" />
        </button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { X } from 'lucide-vue-next'

const props = defineProps<{
  modelValue: string[]
}>()

const emit = defineEmits<{
  'update:modelValue': [value: string[]]
}>()

// Options rapides
const quickOptions = [
  { label: "Aujourd'hui", value: new Date().toISOString().split('T')[0] },
  { label: "Demain", value: new Date(Date.now() + 86400000).toISOString().split('T')[0] },
  { label: "Cette semaine", value: "this_week" },
  { label: "Semaine prochaine", value: "next_week" }
]

// Générer les dates du calendrier (30 jours à partir d'aujourd'hui)
const calendarDates = computed(() => {
  const dates = []
  const today = new Date()
  today.setHours(0, 0, 0, 0)
  
  // Ajouter des jours vides pour aligner avec le jour de la semaine
  const firstDay = new Date(today)
  const dayOfWeek = firstDay.getDay() || 7 // 1-7 (lundi-dimanche)
  for (let i = 1; i < dayOfWeek; i++) {
    dates.push({ value: '', disabled: true })
  }
  
  // Ajouter 30 jours
  for (let i = 0; i < 30; i++) {
    const date = new Date(today)
    date.setDate(today.getDate() + i)
    dates.push({
      value: date.toISOString().split('T')[0],
      disabled: false
    })
  }
  
  return dates
})

// Vérifier si une date est sélectionnée
const isSelected = (date: string) => {
  if (date === 'this_week' || date === 'next_week') {
    return props.modelValue.includes(date)
  }
  return props.modelValue.includes(date)
}

// Sélectionner une option rapide
const selectQuickOption = (option: string) => {
  if (option === 'this_week' || option === 'next_week') {
    emit('update:modelValue', [option])
    return
  }
  
  // Sinon c'est une date spécifique
  if (props.modelValue.includes(option)) {
    emit('update:modelValue', props.modelValue.filter(d => d !== option))
  } else {
    emit('update:modelValue', [...props.modelValue.filter(d => !d.includes('week')), option])
  }
}

// Ajouter/supprimer une date
const toggleDate = (date: string) => {
  if (!date) return
  
  if (props.modelValue.includes(date)) {
    emit('update:modelValue', props.modelValue.filter(d => d !== date))
  } else {
    emit('update:modelValue', [...props.modelValue.filter(d => !d.includes('week')), date])
  }
}

// Supprimer une date
const removeDate = (date: string) => {
  emit('update:modelValue', props.modelValue.filter(d => d !== date))
}

// Formater une date pour l'affichage
const formatDate = (date: string) => {
  if (date === 'this_week') return 'Cette semaine'
  if (date === 'next_week') return 'Semaine prochaine'
  
  const d = new Date(date)
  return d.toLocaleDateString('fr-FR', { day: 'numeric', month: 'short' })
}
</script> 