<template>
  <div class="bg-white rounded-lg shadow p-6">
    <h2 class="text-xl font-semibold mb-6">Réserver {{ item.name }}</h2>
    
    <form @submit.prevent="handleSubmit" class="space-y-6">
      <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <SharedUiInput
          v-model="form.startDate"
          type="date"
          label="Date de début"
          :min="minDate"
          required
        />
        
        <SharedUiInput
          v-model="form.endDate"
          type="date"
          label="Date de fin"
          :min="form.startDate || minDate"
          required
        />
      </div>

      <div class="border-t border-gray-200 pt-4">
        <div class="flex justify-between items-center mb-4">
          <span class="text-gray-600">Prix par jour</span>
          <span class="font-semibold">{{ formatCurrency(item.price) }}</span>
        </div>
        
        <div class="flex justify-between items-center mb-4">
          <span class="text-gray-600">Nombre de jours</span>
          <span class="font-semibold">{{ numberOfDays }}</span>
        </div>
        
        <div class="flex justify-between items-center text-lg font-bold">
          <span>Total</span>
          <span>{{ formatCurrency(totalPrice) }}</span>
        </div>
      </div>

      <div class="flex justify-end space-x-4">
        <SharedUiButton
          variant="secondary"
          @click="$emit('cancel')"
        >
          Annuler
        </SharedUiButton>
        
        <SharedUiButton
          type="submit"
          :disabled="!isValid"
        >
          Réserver
        </SharedUiButton>
      </div>
    </form>
  </div>
</template>

<script setup lang="ts">
import type { Item } from '~/stores/user'

const props = defineProps<{
  item: Item
}>()

const emit = defineEmits<{
  submit: [rental: { startDate: string; endDate: string }]
  cancel: []
}>()

const form = ref({
  startDate: '',
  endDate: ''
})

const minDate = computed(() => {
  const today = new Date()
  return today.toISOString().split('T')[0]
})

const numberOfDays = computed(() => {
  if (!form.value.startDate || !form.value.endDate) return 0
  const start = new Date(form.value.startDate)
  const end = new Date(form.value.endDate)
  return Math.ceil((end.getTime() - start.getTime()) / (1000 * 60 * 60 * 24))
})

const totalPrice = computed(() => {
  return props.item.price * numberOfDays.value
})

const isValid = computed(() => {
  return form.value.startDate && 
         form.value.endDate && 
         new Date(form.value.endDate) > new Date(form.value.startDate)
})

const formatCurrency = (value: number) => {
  return new Intl.NumberFormat('fr-FR', {
    style: 'currency',
    currency: 'EUR'
  }).format(value)
}

const handleSubmit = () => {
  if (isValid.value) {
    emit('submit', {
      startDate: form.value.startDate,
      endDate: form.value.endDate
    })
  }
}
</script> 