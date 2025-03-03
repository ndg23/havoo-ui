<template>
  <BaseModal :is-open="isOpen" :title="rental ? 'Modifier la location' : 'Nouvelle location'" @close="close">
    <form @submit.prevent="handleSubmit" class="space-y-6">
      <!-- Informations de l'objet -->
      <div>
        <h4 class="text-sm font-medium text-gray-700 mb-4">Informations de l'objet</h4>
        <div class="grid grid-cols-2 gap-4">
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Objet</label>
            <select v-model="form.itemId" class="w-full px-3 py-2 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-orange-500/20 focus:border-orange-500">
              <option value="">Sélectionner un objet</option>
              <option v-for="item in items" :key="item.id" :value="item.id">
                {{ item.name }}
              </option>
            </select>
          </div>
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Prix par jour</label>
            <input 
              type="number" 
              v-model="form.pricePerDay"
              class="w-full px-3 py-2 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-orange-500/20 focus:border-orange-500"
            >
          </div>
        </div>
      </div>

      <!-- Informations du locataire -->
      <div>
        <h4 class="text-sm font-medium text-gray-700 mb-4">Informations du locataire</h4>
        <div class="grid grid-cols-2 gap-4">
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Locataire</label>
            <select v-model="form.renterId" class="w-full px-3 py-2 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-orange-500/20 focus:border-orange-500">
              <option value="">Sélectionner un locataire</option>
              <option v-for="renter in renters" :key="renter.id" :value="renter.id">
                {{ renter.name }}
              </option>
            </select>
          </div>
        </div>
      </div>

      <!-- Période de location -->
      <div>
        <h4 class="text-sm font-medium text-gray-700 mb-4">Période de location</h4>
        <div class="grid grid-cols-2 gap-4">
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Date de début</label>
            <input 
              type="date" 
              v-model="form.startDate"
              class="w-full px-3 py-2 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-orange-500/20 focus:border-orange-500"
            >
          </div>
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Date de fin</label>
            <input 
              type="date" 
              v-model="form.endDate"
              class="w-full px-3 py-2 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-orange-500/20 focus:border-orange-500"
            >
          </div>
        </div>
      </div>

      <!-- Statut -->
      <div>
        <label class="block text-sm font-medium text-gray-700 mb-1">Statut</label>
        <select v-model="form.status" class="w-full px-3 py-2 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-orange-500/20 focus:border-orange-500">
          <option value="pending">En attente</option>
          <option value="active">En cours</option>
          <option value="completed">Terminée</option>
          <option value="cancelled">Annulée</option>
        </select>
      </div>

      <!-- Actions -->
      <div class="flex justify-end gap-3 pt-4">
        <button 
          type="button"
          @click="close"
          class="px-4 py-2 text-gray-700 bg-gray-100 rounded-lg hover:bg-gray-200"
        >
          Annuler
        </button>
        <button 
          type="submit"
          class="px-4 py-2 bg-orange-500 text-white rounded-lg hover:bg-orange-600"
        >
          {{ rental ? 'Modifier' : 'Créer' }}
        </button>
      </div>
    </form>
  </BaseModal>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'
import BaseModal from '../BaseModal.vue'

const props = defineProps<{
  isOpen: boolean
  rental?: any
}>()

const emit = defineEmits<{
  (e: 'close'): void
  (e: 'submit', data: any): void
}>()

const form = ref({
  itemId: '',
  renterId: '',
  pricePerDay: 0,
  startDate: '',
  endDate: '',
  status: 'pending'
})

// Sample data
const items = [
  { id: '1', name: 'Perceuse Bosch Professional' },
  { id: '2', name: 'Tondeuse à gazon' }
]

const renters = [
  { id: '1', name: 'Sophie Martin' },
  { id: '2', name: 'Pierre Dubois' }
]

watch(() => props.rental, (newRental) => {
  if (newRental) {
    form.value = { ...newRental }
  } else {
    form.value = {
      itemId: '',
      renterId: '',
      pricePerDay: 0,
      startDate: '',
      endDate: '',
      status: 'pending'
    }
  }
}, { immediate: true })

const handleSubmit = () => {
  emit('submit', form.value)
  close()
}

const close = () => {
  emit('close')
}
</script> 