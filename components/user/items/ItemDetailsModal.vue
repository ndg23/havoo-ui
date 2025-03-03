<template>
  <TransitionRoot appear :show="isOpen" as="template">
    <Dialog as="div" class="relative z-50" @close="close">
      <TransitionChild
        enter="ease-out duration-300"
        enter-from="opacity-0"
        enter-to="opacity-100"
        leave="ease-in duration-200"
        leave-from="opacity-100"
        leave-to="opacity-0"
      >
        <div class="fixed inset-0 bg-black/30 backdrop-blur-sm" />
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
            <DialogPanel class="w-full max-w-3xl bg-white rounded-2xl overflow-hidden">
              <div class="relative aspect-video">
                <img 
                  :src="item.image" 
                  :alt="item.name"
                  class="w-full h-full object-cover"
                />
                <button 
                  @click="close"
                  class="absolute top-4 right-4 p-2 rounded-full bg-white/80 backdrop-blur-sm hover:bg-white transition-colors"
                >
                  <XMarkIcon class="w-5 h-5" />
                </button>
              </div>

              <div class="p-6">
                <div class="flex items-start justify-between mb-6">
                  <div>
                    <h3 class="text-2xl font-bold text-gray-900">{{ item.name }}</h3>
                    <p class="text-gray-500">{{ item.description }}</p>
                  </div>
                  <div class="text-right">
                    <div class="text-2xl font-bold text-blue-600">{{ formatPrice(item.price) }}</div>
                    <div class="text-sm text-gray-500">par jour</div>
                  </div>
                </div>

                <!-- Formulaire de location -->
                <form @submit.prevent="handleSubmit" class="space-y-6">
                  <div class="grid grid-cols-2 gap-4">
                    <div>
                      <label class="block text-sm font-medium text-gray-700 mb-2">
                        Date de début
                      </label>
                      <input
                        v-model="rental.startDate"
                        type="date"
                        :min="today"
                        required
                        class="w-full px-4 py-2 rounded-lg border border-gray-200 focus:border-blue-500 focus:ring-2 focus:ring-blue-500/20"
                      />
                    </div>
                    <div>
                      <label class="block text-sm font-medium text-gray-700 mb-2">
                        Date de fin
                      </label>
                      <input
                        v-model="rental.endDate"
                        type="date"
                        :min="rental.startDate || today"
                        required
                        class="w-full px-4 py-2 rounded-lg border border-gray-200 focus:border-blue-500 focus:ring-2 focus:ring-blue-500/20"
                      />
                    </div>
                  </div>

                  <!-- Résumé -->
                  <div v-if="rental.startDate && rental.endDate" class="bg-gray-50 rounded-xl p-4">
                    <h4 class="font-medium mb-3">Résumé de la location</h4>
                    <div class="space-y-2 text-sm">
                      <div class="flex justify-between">
                        <span>Durée</span>
                        <span>{{ rentalDuration }} jours</span>
                      </div>
                      <div class="flex justify-between">
                        <span>Prix par jour</span>
                        <span>{{ formatPrice(item.price) }}</span>
                      </div>
                      <div class="flex justify-between font-medium pt-2 border-t">
                        <span>Total</span>
                        <span>{{ formatPrice(totalPrice) }}</span>
                      </div>
                    </div>
                  </div>

                  <div class="flex gap-4">
                    <SharedUiButton
                      type="submit"
                      class="flex-1"
                      :disabled="!isValid"
                    >
                      Réserver maintenant
                    </SharedUiButton>
                    <SharedUiButton
                      type="button"
                      variant="secondary"
                      @click="close"
                    >
                      Annuler
                    </SharedUiButton>
                  </div>
                </form>
              </div>
            </DialogPanel>
          </TransitionChild>
        </div>
      </div>
    </Dialog>
  </TransitionRoot>
</template>

<script setup lang="ts">
import { XMarkIcon } from '@heroicons/vue/24/outline'
import type { Item } from '~/stores/user'

const props = defineProps<{
  isOpen: boolean
  item: Item
}>()

const emit = defineEmits<{
  close: []
  submit: [rental: { startDate: Date; endDate: Date }]
}>()

// État du formulaire
const rental = ref({
  startDate: '',
  endDate: ''
})

// Computed
const today = computed(() => {
  const date = new Date()
  return date.toISOString().split('T')[0]
})

const rentalDuration = computed(() => {
  if (!rental.value.startDate || !rental.value.endDate) return 0
  const start = new Date(rental.value.startDate)
  const end = new Date(rental.value.endDate)
  return Math.ceil((end.getTime() - start.getTime()) / (1000 * 60 * 60 * 24))
})

const totalPrice = computed(() => {
  return props.item.price * rentalDuration.value
})

const isValid = computed(() => {
  return rental.value.startDate && 
         rental.value.endDate && 
         new Date(rental.value.endDate) > new Date(rental.value.startDate)
})

// Méthodes
const close = () => {
  emit('close')
  rental.value = { startDate: '', endDate: '' }
}

const handleSubmit = () => {
  emit('submit', {
    startDate: new Date(rental.value.startDate),
    endDate: new Date(rental.value.endDate)
  })
  close()
}

const formatPrice = (price: number) => {
  return new Intl.NumberFormat('fr-FR', {
    style: 'currency',
    currency: 'EUR'
  }).format(price)
}
</script> 