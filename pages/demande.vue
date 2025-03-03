<template>
  <div class="min-h-screen bg-gradient-to-br from-gray-50 to-gray-100 py-12">
    <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
      <!-- Header -->
      <div class="text-center mb-12">
        <h1 class="text-3xl font-bold text-gray-900">
          Publier une demande de service
        </h1>
        <p class="mt-2 text-gray-600">
          Trouvez le professionnel idéal pour votre besoin
        </p>
      </div>

      <!-- Main Form Card -->
      <div class="bg-white rounded-2xl -shadow-sm border border-gray-200">
        <!-- Progress Steps -->
        <div class="border-b border-gray-200">
          <div class="px-6 py-4">
            <div class="flex items-center justify-between">
              <div v-for="(step, index) in steps" :key="step.id" class="flex items-center">
                <div class="flex items-center gap-3">
                  <div class="w-8 h-8 rounded-full flex items-center justify-center text-sm font-medium transition-colors"
                    :class="currentStep >= index + 1 ? 'bg-indigo-600 text-white' : 'bg-gray-100 text-gray-400'"
                  >
                    {{ index + 1 }}
                  </div>
                  <span class="text-sm font-medium hidden sm:block"
                    :class="currentStep >= index + 1 ? 'text-gray-900' : 'text-gray-400'"
                  >
                    {{ step.title }}
                  </span>
                </div>
                <div v-if="index < steps.length - 1" 
                  class="flex-1 h-px bg-gray-200 mx-6 hidden sm:block"
                  :class="{'bg-indigo-600': currentStep > index + 1}"
                />
              </div>
            </div>
          </div>
        </div>

        <!-- Form Content -->
        <div class="p-8">
          <!-- Service Selection -->
          <div v-if="currentStep === 1" class="space-y-6">
            <h2 class="text-lg font-medium text-gray-900">
              Quel service recherchez-vous ?
            </h2>
            <div class="grid sm:grid-cols-2 gap-4">
              <button
                v-for="service in services"
                :key="service.id"
                @click="selectService(service)"
                class="group relative p-6 text-left border-2 rounded-xl transition-all focus:outline-none"
                :class="[
                  form.serviceId === service.id 
                    ? 'border-indigo-600 bg-indigo-50' 
                    : 'border-gray-200 hover:border-indigo-300'
                ]"
              >
                <div class="flex items-center gap-4">
                  <span class="text-3xl">{{ service.icon }}</span>
                  <div>
                    <span class="block font-medium text-gray-900">{{ service.name }}</span>
                    <span class="text-sm text-gray-500">À partir de {{ service.price }}€/h</span>
                  </div>
                </div>
              </button>
            </div>
          </div>

          <!-- Date & Description -->
          <div v-if="currentStep === 2" class="space-y-6">
            <div class="relative">
              <input
                v-model="form.desiredDate"
                type="date"
                required
                class="peer w-full h-14 px-4 pt-2 rounded-xl border-2 border-gray-200 placeholder-transparent focus:border-indigo-500 focus:ring-0 focus:outline-none transition-colors"
                placeholder=" "
                :min="minDate"
              />
              <label class="absolute left-4 top-4 text-gray-500 text-sm transition-all duration-200 
                -translate-y-3 scale-85 peer-placeholder-shown:translate-y-0 
                peer-placeholder-shown:scale-100 peer-focus:-translate-y-3 
                peer-focus:scale-85"
              >
                Date souhaitée
              </label>
            </div>

            <div class="relative">
              <textarea
                v-model="form.description"
                rows="4"
                required
                class="peer w-full px-4 pt-6 rounded-xl border-2 border-gray-200 placeholder-transparent focus:border-indigo-500 focus:ring-0 focus:outline-none transition-colors"
                placeholder=" "
              ></textarea>
              <label class="absolute left-4 top-4 text-gray-500 text-sm transition-all duration-200 
                -translate-y-3 scale-85 peer-placeholder-shown:translate-y-0 
                peer-placeholder-shown:scale-100 peer-focus:-translate-y-3 
                peer-focus:scale-85"
              >
                Description de votre besoin
              </label>
            </div>
          </div>

          <!-- Address -->
          <div v-if="currentStep === 3" class="space-y-6">
            <div class="relative">
              <input
                v-model="form.address"
                type="text"
                required
                class="peer w-full h-14 px-4 pt-2 rounded-xl border-2 border-gray-200 placeholder-transparent focus:border-indigo-500 focus:ring-0 focus:outline-none transition-colors"
                placeholder=" "
              />
              <label class="absolute left-4 top-4 text-gray-500 text-sm transition-all duration-200 
                -translate-y-3 scale-85 peer-placeholder-shown:translate-y-0 
                peer-placeholder-shown:scale-100 peer-focus:-translate-y-3 
                peer-focus:scale-85"
              >
                Adresse
              </label>
            </div>

            <div class="grid grid-cols-2 gap-4">
              <div class="relative">
                <input
                  v-model="form.zipCode"
                  type="text"
                  required
                  maxlength="5"
                  pattern="[0-9]*"
                  class="peer w-full h-14 px-4 pt-2 rounded-xl border-2 border-gray-200 placeholder-transparent focus:border-indigo-500 focus:ring-0 focus:outline-none transition-colors"
                  placeholder=" "
                />
                <label class="absolute left-4 top-4 text-gray-500 text-sm transition-all duration-200 
                  -translate-y-3 scale-85 peer-placeholder-shown:translate-y-0 
                  peer-placeholder-shown:scale-100 peer-focus:-translate-y-3 
                  peer-focus:scale-85"
                >
                  Code postal
                </label>
              </div>

              <div class="relative">
                <input
                  v-model="form.city"
                  type="text"
                  required
                  class="peer w-full h-14 px-4 pt-2 rounded-xl border-2 border-gray-200 placeholder-transparent focus:border-indigo-500 focus:ring-0 focus:outline-none transition-colors"
                  placeholder=" "
                />
                <label class="absolute left-4 top-4 text-gray-500 text-sm transition-all duration-200 
                  -translate-y-3 scale-85 peer-placeholder-shown:translate-y-0 
                  peer-placeholder-shown:scale-100 peer-focus:-translate-y-3 
                  peer-focus:scale-85"
                >
                  Ville
                </label>
              </div>
            </div>
          </div>
        </div>

        <!-- Navigation -->
        <div class="px-8 py-4 bg-gray-50 border-t border-gray-200 flex justify-between items-center">
          <button
            v-if="currentStep > 1"
            @click="currentStep--"
            class="text-gray-600 hover:text-gray-900 font-medium flex items-center gap-2"
          >
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"/>
            </svg>
            Retour
          </button>
          <div v-else class="w-20"></div>

          <button
            v-if="currentStep < steps.length"
            @click="nextStep"
            class="inline-flex items-center px-6 py-3 text-sm font-medium rounded-xl text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
            :class="{'opacity-50 cursor-not-allowed': !canProgress}"
            :disabled="!canProgress"
          >
            Continuer
          </button>
          <button
            v-else
            @click="submitForm"
            class="inline-flex items-center px-6 py-3 text-sm font-medium rounded-xl text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
            :class="{'opacity-50 cursor-not-allowed': loading}"
            :disabled="loading"
          >
            <span v-if="loading">Publication en cours...</span>
            <span v-else>Publier la demande</span>
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'

const client = useSupabaseClient()
const loading = ref(false)

const steps = [
  {
    id: 1,
    title: 'Service',
    description: 'Sélectionnez le type de service dont vous avez besoin'
  },
  {
    id: 2,
    title: 'Détails',
    description: 'Indiquez la date et les détails de votre demande'
  },
  {
    id: 3,
    title: 'Contact',
    description: 'Renseignez l\'adresse d\'intervention'
  }
]

const trustBadges = [
  { 
    title: 'Experts vérifiés',
    icon: 'M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z'
  },
  { 
    title: 'Devis gratuit',
    icon: 'M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 003-3V8a3 3 0 00-3-3H6a3 3 0 00-3 3v8a3 3 0 003 3z'
  },
  { 
    title: 'Service client 7j/7',
    icon: 'M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z'
  }
]

const currentStep = ref(1)
const form = ref({
  serviceId: null,
  desiredDate: '',
  description: '',
  address: '',
  zipCode: '',
  city: ''
})

const services = ref([
  { id: 'menage', name: 'Ménage', icon: '🧹' },
  { id: 'jardinage', name: 'Jardinage', icon: '🌱' },
  { id: 'bricolage', name: 'Bricolage', icon: '🔨' },
  { id: 'garde', name: 'Garde d\'enfants', icon: '👶' }
])

const minDate = computed(() => {
  const today = new Date()
  return today.toISOString().split('T')[0]
})

const formatDate = (dateString) => {
  return new Date(dateString).toLocaleDateString('fr-FR', {
    weekday: 'long',
    day: 'numeric',
    month: 'long'
  })
}

const selectService = (service) => {
  form.value.serviceId = service.id
  nextStep()
}

const nextStep = () => {
  if (validateCurrentStep()) {
    currentStep.value++
  }
}

const validateCurrentStep = () => {
  switch (currentStep.value) {
    case 1:
      return form.value.serviceId
    case 2:
      return form.value.desiredDate
    case 3:
      return form.value.address && form.value.zipCode && form.value.city
    default:
      return true
  }
}

const submitForm = async () => {
  try {
    loading.value = true
    const { error } = await client
      .from('service_requests')
      .insert([
        {
          service_id: form.value.serviceId,
          description: form.value.description,
          address: form.value.address,
          zip_code: form.value.zipCode,
          city: form.value.city,
          desired_date: form.value.desiredDate
        }
      ])
      .select()

    if (error) {
      throw error
    }

    await navigateTo('/demande/confirmation')
  } catch (error) {
    console.error('Error submitting form:', error)
  } finally {
    loading.value = false
  }
}

const canProgress = computed(() => {
  switch (currentStep.value) {
    case 1:
      return form.value.serviceId
    case 2:
      return form.value.desiredDate && form.value.description
    case 3:
      return form.value.address && form.value.zipCode && form.value.city
    default:
      return true
  }
})
</script>

<style scoped>
/* Style pour l'input date */
input[type="date"]::-webkit-calendar-picker-indicator {
  background: transparent;
  bottom: 0;
  color: transparent;
  cursor: pointer;
  height: auto;
  left: 0;
  position: absolute;
  right: 0;
  top: 0;
  width: auto;
}

/* Ajustement pour l'input date sur Firefox */
input[type="date"] {
  -webkit-appearance: none;
  appearance: none;
}
</style> 