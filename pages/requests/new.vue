<template>
  <div class="max-w-3xl mx-auto px-4 py-12">
    <div class="bg-white rounded-2xl shadow-sm border border-gray-200 p-8">
      <h1 class="text-2xl font-bold text-gray-900 mb-8">Publier une demande</h1>
      
      <!-- Stepper -->
      <div class="mb-12">
        <Steps :current-step="currentStep" :steps="steps" />
      </div>

      <!-- Formulaire par étapes -->
      <form @submit.prevent="submitRequest" class="max-w-2xl mx-auto">
        <!-- Étape 1: Sélection du service -->
        <TransitionHeight>
          <div v-if="currentStep === 1">
            <ServiceSelector v-model="form.serviceId" />
          </div>
        </TransitionHeight>

        <!-- Étape 2: Détails -->
        <TransitionHeight>
          <div v-if="currentStep === 2" class="space-y-6">
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">
                Description de votre besoin
              </label>
              <FloatInputTextarea
                id="description"
                label="Description de votre besoin"
                :model-value="form.description"
                @update:model-value="form.description = $event"
                placeholder="Décrivez en détail ce dont vous avez besoin..."
                rows="4"
              />
            </div>
            
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">
                Localisation
              </label>
              <FloatInput
                id="location"
                label="Localisation"
                :model-value="form.location"
                @update:model-value="form.location = $event"
                placeholder="Votre adresse"
                :icon="MapPin"
              />
            </div>
          </div>
        </TransitionHeight>

        <!-- Étape 3: Disponibilités -->
        <TransitionHeight>
          <div v-if="currentStep === 3" class="space-y-8">
            <DatePicker v-model="form.dates" />
            <TimePicker v-model="form.time" />
          </div>
        </TransitionHeight>

        <!-- Étape 4: Confirmation -->
        <TransitionHeight>
          <div v-if="currentStep === 4">
            <RequestSummary :form="form" />
          </div>
        </TransitionHeight>

        <!-- Navigation -->
        <div class="flex justify-between mt-12">
          <button 
            v-if="currentStep > 1"
            @click="previousStep"
            type="button"
            class="flex items-center gap-2 px-6 py-2.5 text-gray-600 hover:text-gray-900 transition-colors"
          >
            <ArrowLeft class="w-4 h-4" />
            <span>Précédent</span>
          </button>
          <div v-else class="w-24"></div>
          
          <button 
            v-if="currentStep < steps.length"
            @click="nextStep"
            type="button"
            class="flex items-center gap-2 px-6 py-2.5 bg-primary-600 text-white rounded-full hover:bg-primary-700 transition-colors"
          >
            <span>Continuer</span>
            <ArrowRight class="w-4 h-4" />
          </button>
          <button 
            v-else
            type="submit"
            class="flex items-center gap-2 px-6 py-2.5 bg-primary-600 text-white rounded-full hover:bg-primary-700 transition-colors"
          >
            <span>Publier la demande</span>
            <ArrowRight class="w-4 h-4" />
          </button>
        </div>
      </form>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { MapPin, ArrowLeft, ArrowRight } from 'lucide-vue-next'
import Steps from '~/components/Steps.vue'
import ServiceSelector from '~/components/ServiceSelector.vue'
import FloatInput from '~/components/shared/FloatingInput.vue'
import FloatInputTextarea from '~/components/shared/FloatingTextarea.vue'

// import DatePicker from '~/components/DatePicker.vue'
// import TimePicker from '~/components/TimePicker.vue'
// import RequestSummary from '~/components/RequestSummary.vue'

// Constantes
const steps = [
  'Type de service',
  'Détails',
  'Disponibilités',
  'Confirmation'
]

// Types et état
interface RequestForm {
  serviceId: string
  description: string
  location: string
  dates: string[]
  time: string
}

const currentStep = ref(1)
const form = ref<RequestForm>({
  serviceId: '',
  description: '',
  location: '',
  dates: [],
  time: ''
})

// Navigation
const nextStep = () => {
  if (validateCurrentStep()) {
    currentStep.value++
  }
}

const previousStep = () => {
  currentStep.value--
}

// Validation
const validateCurrentStep = () => {
  switch (currentStep.value) {
    case 1:
      return !!form.value.serviceId
    case 2:
      return !!form.value.description && !!form.value.location
    default:
      return true
  }
}

// Soumission
const submitRequest = async () => {
  try {
    await $fetch('/api/requests', {
      method: 'POST',
      body: form.value
    })
    navigateTo('/requests')
  } catch (error) {
    console.error(error)
  }
}
</script> 