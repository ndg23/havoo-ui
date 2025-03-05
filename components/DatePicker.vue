<template>
  <div class="space-y-6">
    <h3 class="text-lg font-medium text-gray-900">Quand avez-vous besoin de ce service ?</h3>
    
    <!-- Options rapides -->
    <div class="grid grid-cols-2 gap-3">
      <button
        v-for="option in quickOptions"
        :key="option.value"
        @click="selectQuickOption(option.value)"
        class="relative flex flex-col items-center justify-center p-4 rounded-xl border-2 transition-all duration-300 aspect-square"
        :class="isSelected(option.value) 
          ? 'border-primary-600 bg-primary-50' 
          : 'border-gray-200 hover:border-gray-300'"
      >
        <!-- Icône -->
        <div 
          class="w-12 h-12 rounded-full flex items-center justify-center mb-3"
          :class="isSelected(option.value) ? 'bg-primary-100' : 'bg-gray-100'"
        >
          <component 
            :is="option.icon" 
            class="w-6 h-6"
            :class="isSelected(option.value) ? 'text-primary-600' : 'text-gray-600'" 
          />
        </div>
        
        <!-- Label -->
        <span 
          class="font-medium text-center"
          :class="isSelected(option.value) ? 'text-primary-700' : 'text-gray-900'"
        >
          {{ option.label }}
        </span>
        
        <!-- Check icon -->
        <div 
          v-if="isSelected(option.value)"
          class="absolute top-3 right-3 w-5 h-5 rounded-full bg-primary-600 flex items-center justify-center"
        >
          <Check class="w-3 h-3 text-white" />
        </div>
      </button>
    </div>
    
    <!-- Calendrier -->
    <div class="mt-8">
      <div class="flex items-center justify-between mb-4">
        <h4 class="font-medium text-gray-900">Sélectionner une date spécifique</h4>
        <div class="flex gap-1">
          <button 
            @click="previousMonth"
            class="p-1.5 rounded-full hover:bg-gray-100"
          >
            <ChevronLeft class="w-5 h-5 text-gray-600" />
          </button>
          <button 
            @click="nextMonth"
            class="p-1.5 rounded-full hover:bg-gray-100"
          >
            <ChevronRight class="w-5 h-5 text-gray-600" />
          </button>
        </div>
      </div>
      
      <!-- Mois et année -->
      <div class="text-center mb-4">
        <h3 class="text-lg font-medium text-gray-900">
          {{ currentMonthName }} {{ currentYear }}
        </h3>
      </div>
      
      <!-- Jours de la semaine -->
      <div class="grid grid-cols-7 mb-2">
        <div 
          v-for="day in ['L', 'M', 'M', 'J', 'V', 'S', 'D']" 
          :key="day"
          class="text-center text-xs font-medium text-gray-500 py-1"
        >
          {{ day }}
        </div>
      </div>
      
      <!-- Jours du mois -->
      <div class="grid grid-cols-7 gap-1">
        <button
          v-for="date in calendarDates"
          :key="date.value"
          type="button"
          @click="toggleDate(date.value)"
          :disabled="date.disabled"
          class="aspect-square rounded-lg flex items-center justify-center text-sm transition-colors relative"
          :class="[
            date.disabled 
              ? 'text-gray-300 cursor-not-allowed' 
              : date.isToday
                ? 'border border-primary-300'
                : '',
            isSelected(date.value)
              ? 'bg-primary-600 text-white'
              : date.disabled 
                ? ''
                : 'hover:bg-gray-100 text-gray-700'
          ]"
        >
          <span>{{ date.day }}</span>
          
          <!-- Indicateur aujourd'hui -->
          <div 
            v-if="date.isToday && !isSelected(date.value)" 
            class="absolute bottom-1 left-1/2 -translate-x-1/2 w-1 h-1 rounded-full bg-primary-600"
          ></div>
        </button>
      </div>
    </div>
    
    <!-- Dates sélectionnées -->
    <div v-if="modelValue.length > 0 && !modelValue.includes('this_week') && !modelValue.includes('next_week')" class="mt-6">
      <h4 class="font-medium text-gray-900 mb-2">Dates sélectionnées</h4>
      <div class="flex flex-wrap gap-2">
        <div 
          v-for="date in modelValue" 
          :key="date"
          class="px-3 py-1.5 bg-primary-50 text-primary-700 rounded-full text-sm flex items-center gap-1.5"
        >
          <Calendar class="w-4 h-4" />
          {{ formatDate(date) }}
          <button 
            @click="removeDate(date)"
            class="w-5 h-5 rounded-full hover:bg-primary-100 flex items-center justify-center"
          >
            <X class="w-3 h-3 text-primary-700" />
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { Calendar, Check, X, ChevronLeft, ChevronRight, Clock, Zap } from 'lucide-vue-next'

const props = defineProps<{
  modelValue: string[]
}>()

const emit = defineEmits<{
  'update:modelValue': [value: string[]]
}>()

// État du calendrier
const currentMonth = ref(new Date().getMonth())
const currentYear = ref(new Date().getFullYear())

// Options rapides avec icônes
const quickOptions = [
  { 
    label: "Aujourd'hui", 
    value: new Date().toISOString().split('T')[0],
    icon: Calendar
  },
  { 
    label: "Demain", 
    value: new Date(Date.now() + 86400000).toISOString().split('T')[0],
    icon: Clock
  },
  { 
    label: "Cette semaine", 
    value: "this_week",
    icon: Zap
  },
  { 
    label: "Semaine prochaine", 
    value: "next_week",
    icon: Calendar
  }
]

// Nom du mois courant
const currentMonthName = computed(() => {
  const date = new Date(currentYear.value, currentMonth.value, 1)
  return date.toLocaleDateString('fr-FR', { month: 'long' })
})

// Navigation dans le calendrier
const previousMonth = () => {
  if (currentMonth.value === 0) {
    currentMonth.value = 11
    currentYear.value--
  } else {
    currentMonth.value--
  }
}

const nextMonth = () => {
  if (currentMonth.value === 11) {
    currentMonth.value = 0
    currentYear.value++
  } else {
    currentMonth.value++
  }
}

// Générer les dates du calendrier
const calendarDates = computed(() => {
  const dates = []
  const today = new Date()
  today.setHours(0, 0, 0, 0)
  
  const firstDay = new Date(currentYear.value, currentMonth.value, 1)
  const lastDay = new Date(currentYear.value, currentMonth.value + 1, 0)
  
  // Jours du mois précédent pour compléter la première semaine
  const dayOfWeek = firstDay.getDay() || 7 // 1-7 (lundi-dimanche)
  for (let i = 1; i < dayOfWeek; i++) {
    const date = new Date(firstDay)
    date.setDate(firstDay.getDate() - (dayOfWeek - i))
    dates.push({
      day: date.getDate(),
      value: date.toISOString().split('T')[0],
      disabled: true,
      isToday: false
    })
  }
  
  // Jours du mois courant
  for (let i = 1; i <= lastDay.getDate(); i++) {
    const date = new Date(currentYear.value, currentMonth.value, i)
    const isBeforeToday = date < today
    
    dates.push({
      day: i,
      value: date.toISOString().split('T')[0],
      disabled: isBeforeToday,
      isToday: date.toDateString() === today.toDateString()
    })
  }
  
  // Jours du mois suivant pour compléter la dernière semaine
  const remainingDays = 7 - (dates.length % 7 || 7)
  if (remainingDays < 7) {
    for (let i = 1; i <= remainingDays; i++) {
      const date = new Date(lastDay)
      date.setDate(lastDay.getDate() + i)
      dates.push({
        day: date.getDate(),
        value: date.toISOString().split('T')[0],
        disabled: true,
        isToday: false
      })
    }
  }
  
  return dates
})

// Vérifier si une date est sélectionnée
const isSelected = (date: string) => {
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