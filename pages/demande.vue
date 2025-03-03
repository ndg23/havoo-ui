<template>
  <div class="min-h-screen bg-gray-100">
    <div class="max-w-4xl mx-auto px-4 py-16">
      <!-- Header -->
      <div class="mb-8 text-center">
        <h1 class="text-3xl font-bold text-gray-900">Publier une demande de service</h1>
        <p class="mt-2 text-gray-600">Trouvez le professionnel idéal pour votre besoin</p>
      </div>

      <!-- Main Form Card -->
      <div class="bg-white rounded-2xl 
       border border-gray-200">
        <!-- Progress Steps -->
        <div class="border-b border-gray-200">
          <div class="max-w-3xl mx-auto px-6 py-4">
            <div class="flex items-center justify-between">
              <div 
                v-for="(step, index) in steps" 
                :key="step.id"
                class="flex items-center"
              >
                <div class="flex items-center">
                  <div 
                    class="w-8 h-8 rounded-full flex items-center justify-center text-sm font-medium"
                    :class="currentStep >= index + 1 ? 'bg-blue-600 text-white' : 'bg-gray-100 text-gray-400'"
                  >
                    {{ index + 1 }}
                  </div>
                  <span 
                    class="ml-3 text-sm font-medium hidden sm:block"
                    :class="currentStep >= index + 1 ? 'text-gray-900' : 'text-gray-400'"
                  >
                    {{ step.title }}
                  </span>
                </div>
                <div 
                  v-if="index < steps.length - 1" 
                  class="flex-1 h-px bg-gray-200 mx-4 hidden sm:block"
                  :class="{'bg-blue-600': currentStep > index + 1}"
                />
              </div>
            </div>
          </div>
        </div>

        <!-- Form Content -->
        <div class="p-6">
          <!-- Service Selection -->
          <div v-if="currentStep === 1" class="space-y-8">
            <div class="grid sm:grid-cols-2 gap-4">
              <button
                v-for="service in services"
                :key="service.id"
                @click="selectService(service)"
                class="relative p-6 text-left transition-all  focus:outline-none group"
                :class="[
                  form.serviceId === service.id 
                    ? 'bg-blue-50 border-blue-600' 
                    : 'bg-white border-gray-200 hover:border-blue-600',
                  'border-2 rounded-xl'
                ]"
              >
                <div class="flex items-center gap-4">
                  <span class="text-3xl">{{ service.icon }}</span>
                  <div>
                    <span class="block font-semibold text-gray-900">{{ service.name }}</span>
                    <span class="text-sm text-gray-500">À partir de 20€/h</span>
                  </div>
                </div>
                <div 
                  class="absolute inset-0 border-2 border-blue-600 rounded-xl opacity-0 group-hover:opacity-100 transition-opacity"
                  :class="{'opacity-100': form.serviceId === service.id}"
                />
              </button>
            </div>
          </div>

          <!-- Date Selection -->
          <div v-if="currentStep === 2" class="space-y-8 max-w-2xl mx-auto">
            <div class="space-y-6">
              <label class="block">
                <span class="text-base font-medium text-gray-900 block mb-2">
                  Quand souhaitez-vous le service ?
                </span>
                <div class="relative">
                  <input 
                    type="date"
                    v-model="form.desiredDate"
                    class="w-full h-14 px-4 rounded-xl border-2 border-gray-200 focus:border-blue-600 focus:ring-0"
                    :min="minDate"
                  />
                </div>
              </label>

              <label class="block">
                <span class="text-base font-medium text-gray-900 block mb-2">
                  Décrivez votre besoin en détail
                </span>
                <textarea
                  v-model="form.description"
                  rows="4"
                  class="w-full px-4 py-3 rounded-xl border-2 border-gray-200 focus:border-blue-600 focus:ring-0"
                  placeholder="Ex: Je recherche une personne pour..."
                ></textarea>
              </label>
            </div>
          </div>

          <!-- Contact Info -->
          <div v-if="currentStep === 3" class="space-y-8 max-w-2xl mx-auto">
            <div class="space-y-6">
              <label class="block">
                <span class="text-base font-medium text-gray-900 block mb-2">Adresse</span>
                <input 
                  v-model="form.address"
                  type="text"
                  class="w-full h-14 px-4 rounded-xl border-2 border-gray-200 focus:border-blue-600 focus:ring-0"
                  placeholder="Numéro et nom de rue"
                />
              </label>

              <div class="grid grid-cols-2 gap-4">
                <label class="block">
                  <span class="text-base font-medium text-gray-900 block mb-2">Code postal</span>
                  <input 
                    v-model="form.zipCode"
                    type="text"
                    maxlength="5"
                    class="w-full h-14 px-4 rounded-xl border-2 border-gray-200 focus:border-blue-600 focus:ring-0"
                    placeholder="75001"
                  />
                </label>

                <label class="block">
                  <span class="text-base font-medium text-gray-900 block mb-2">Ville</span>
                  <input 
                    v-model="form.city"
                    type="text"
                    class="w-full h-14 px-4 rounded-xl border-2 border-gray-200 focus:border-blue-600 focus:ring-0"
                    placeholder="Paris"
                  />
                </label>
              </div>
            </div>
          </div>
        </div>

        <!-- Navigation -->
        <div class="px-6 py-4 bg-gray-50 border-t border-gray-200 rounded-b-2xl">
          <div class="flex justify-between items-center">
            <button
              v-if="currentStep > 1"
              @click="currentStep--"
              class="text-gray-600 hover:text-gray-900 font-medium flex items-center"
            >
              <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"/>
              </svg>
              Retour
            </button>

            <button
              v-if="currentStep < steps.length"
              @click="nextStep"
              class="ml-auto bg-blue-600 text-white px-8 py-3 rounded-xl hover:bg-blue-700 font-medium"
              :class="{'opacity-50 cursor-not-allowed': loading}"
              :disabled="loading"
            >
              Continuer
            </button>

            <button
              v-else
              @click="submitForm"
              class="ml-auto bg-blue-600 text-white px-8 py-3 rounded-xl hover:bg-blue-700 font-medium flex items-center"
              :class="{'opacity-50 cursor-not-allowed': loading}"
              :disabled="loading"
            >
              <span v-if="loading">Publication en cours...</span>
              <span v-else>Publier la demande</span>
            </button>
          </div>
        </div>
      </div>

      <!-- Trust Badges -->
      <div class="mt-8 grid grid-cols-3 gap-6">
        <div v-for="badge in trustBadges" :key="badge.title" 
          class="flex items-center gap-3"
        >
          <div class="w-10 h-10 rounded-full bg-blue-50 flex items-center justify-center text-blue-600">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path :d="badge.icon" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"/>
            </svg>
          </div>
          <p class="text-sm font-medium text-gray-600">{{ badge.title }}</p>
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