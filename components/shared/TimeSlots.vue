<template>
  <div class="space-y-4">
    <label class="block text-sm font-medium text-gray-700">Créneaux horaires</label>
    <div class="space-y-3">
      <div 
        v-for="(slot, index) in modelValue" 
        :key="index"
        class="flex items-center gap-4"
      >
        <input
          type="time"
          v-model="slot.start"
          class="rounded-lg border-gray-200"
          @change="updateSlots"
        />
        <span>-</span>
        <input
          type="time"
          v-model="slot.end"
          class="rounded-lg border-gray-200"
          @change="updateSlots"
        />
        <button 
          @click="removeSlot(index)"
          class="text-gray-400 hover:text-red-500"
        >
          <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
          </svg>
        </button>
      </div>
      <button 
        @click="addSlot"
        class="inline-flex items-center text-sm text-orange-500 hover:text-orange-600"
      >
        <svg class="w-5 h-5 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
        </svg>
        Ajouter un créneau
      </button>
    </div>
    <p v-if="error" class="mt-1 text-sm text-red-500">{{ error }}</p>
  </div>
</template>

<script setup lang="ts">
interface TimeSlot {
  start: string
  end: string
}

const props = defineProps<{
  modelValue: TimeSlot[]
  error?: string
}>()

const emit = defineEmits<{
  (e: 'update:modelValue', value: TimeSlot[]): void
}>()

const addSlot = () => {
  emit('update:modelValue', [...props.modelValue, { start: '', end: '' }])
}

const removeSlot = (index: number) => {
  const newSlots = [...props.modelValue]
  newSlots.splice(index, 1)
  emit('update:modelValue', newSlots)
}

const updateSlots = () => {
  emit('update:modelValue', [...props.modelValue])
}
</script> 