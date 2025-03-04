<template>
  <div class="min-h-screen bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
    <div class="max-w-3xl mx-auto">
      <!-- Progress Bar -->
      <div class="mb-8">
        <div class="flex items-center justify-between mb-2">
          <span class="text-sm font-medium text-gray-600">Progression</span>
          <span class="text-sm font-medium text-primary-600">Étape {{ currentStep }}/4</span>
        </div>
        <div class="h-2 bg-gray-200 rounded-full">
          <div 
            class="h-full bg-primary-500 rounded-full transition-all duration-500"
            :style="{ width: `${(currentStep / 4) * 100}%` }"
          ></div>
        </div>
      </div>

      <!-- Header -->
      <div class="text-center mb-12">
        <h1 class="text-4xl font-bold text-gray-900 mb-4">
          {{ stepTitles[currentStep - 1] }}
        </h1>
        <p class="text-xl text-gray-600">
          {{ stepDescriptions[currentStep - 1] }}
        </p>
      </div>

      <!-- Multi-step Form -->
      <div class="space-y-8">
        <!-- Step 1: Service Selection -->
        <div v-show="currentStep === 1" class="transition-all duration-300">
          <!-- Services Grid -->
          <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-200 mb-8">
            <h2 class="text-lg font-medium text-gray-900 mb-6">1. Sélectionnez un service</h2>

            <!-- Recherche -->
            <div class="relative mb-6">
              <MagnifyingGlassIcon class="w-5 h-5 text-gray-400 absolute left-3 top-1/2 -translate-y-1/2" />
              <input 
                v-model="searchQuery"
                type="text"
                placeholder="Rechercher un service..."
                class="w-full pl-10 pr-4 py-2 rounded-xl border border-gray-200 focus:border-primary-500 focus:ring-2 focus:ring-primary-500/20"
              />
            </div>

            <!-- Catégories -->
            <div class="space-y-8">
              <div v-for="category in filteredCategories" :key="category.id" class="space-y-4">
                <h3 class="font-medium text-gray-700 flex items-center gap-2">
                  <component :is="category.icon" class="w-5 h-5 text-primary-500" />
                  {{ category.name }}
                </h3>

                <div class="grid sm:grid-cols-2 md:grid-cols-3 gap-3">
                  <button
                    v-for="service in category.services"
                    :key="service.id"
                    @click="selectService(service)"
                    class="flex items-center gap-3 p-3 rounded-xl border-2 transition-all duration-200"
                    :class="form.serviceType === service.id 
                      ? 'border-primary-500 bg-primary-50 text-primary-700' 
                      : 'border-gray-200 hover:border-gray-300 text-gray-600 hover:bg-gray-50'"
                  >
                    <span class="text-2xl">{{ service.icon }}</span>
                    <div class="text-left">
                      <div class="font-medium">{{ service.name }}</div>
                      <div class="text-xs text-gray-500">{{ service.price }}</div>
                    </div>
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Step 2: Description & Date -->
        <div 
          v-show="currentStep === 2" 
          class="transition-all duration-300"
        >
          <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-200 space-y-8">
            <!-- Description -->
            <div class="space-y-4">
              <h3 class="font-medium text-gray-900">Description de votre besoin</h3>
              <textarea
                v-model="form.description"
                rows="4"
                required
                class="w-full px-4 py-3 rounded-xl border border-gray-200 focus:ring-primary-500 focus:border-primary-500"
                placeholder="Décrivez votre besoin en détail..."
              ></textarea>
            </div>

            <!-- Date & Time -->
            <div class="grid sm:grid-cols-2 gap-4">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Date souhaitée</label>
                <input
                  v-model="form.date"
                  type="date"
                  required
                  min="{{ new Date().toISOString().split('T')[0] }}"
                  class="w-full px-4 py-3 rounded-xl border border-gray-200 focus:ring-primary-500 focus:border-primary-500"
                />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Heure souhaitée</label>
                <select
                  v-model="form.time"
                  required
                  class="w-full px-4 py-3 rounded-xl border border-gray-200 focus:ring-primary-500 focus:border-primary-500"
                >
                  <option value="">Sélectionnez une heure</option>
                  <option v-for="hour in availableHours" :key="hour" :value="hour">
                    {{ hour }}
                  </option>
                </select>
              </div>
            </div>
          </div>
        </div>

        <!-- Step 3: Duration & Location -->
        <div 
          v-show="currentStep === 3" 
          class="transition-all duration-300"
        >
          <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-200 space-y-8">
            <!-- Duration -->
            <div class="space-y-4">
              <h3 class="font-medium text-gray-900 mb-4">
                4. Durée estimée
              </h3>
              <div class="grid sm:grid-cols-2 gap-4">
                <div class="relative">
                  <select
                    v-model="form.duration"
                    required
                    class="peer w-full px-4 py-4 pt-6 rounded-xl border border-gray-200 focus:ring-primary-500 focus:border-primary-500 placeholder-transparent transition-all duration-200"
                  >
                    <option value="">Sélectionnez une durée</option>
                    <option value="1">1 heure</option>
                    <option value="2">2 heures</option>
                    <option value="3">3 heures</option>
                    <option value="4">4 heures</option>
                    <option value="5">5 heures</option>
                    <option value="full">Journée complète</option>
                    <option value="unknown">Je ne sais pas</option>
                  </select>
                  <label class="absolute left-4 top-4 text-gray-500 text-sm transition-all duration-200 
                    -translate-y-3 scale-85 peer-placeholder-shown:translate-y-0 
                    peer-placeholder-shown:scale-100 peer-focus:-translate-y-3 
                    peer-focus:scale-85 pointer-events-none"
                  >
                    Durée estimée
                  </label>
                </div>
                <div class="relative">
                  <select
                    v-model="form.frequency"
                    class="peer w-full px-4 py-4 pt-6 rounded-xl border border-gray-200 focus:ring-primary-500 focus:border-primary-500 placeholder-transparent transition-all duration-200"
                  >
                    <option value="">Sélectionnez une fréquence</option>
                    <option value="once">Une seule fois</option>
                    <option value="weekly">Hebdomadaire</option>
                    <option value="biweekly">Bi-mensuel</option>
                    <option value="monthly">Mensuel</option>
                  </select>
                  <label class="absolute left-4 top-4 text-gray-500 text-sm transition-all duration-200 
                    -translate-y-3 scale-85 peer-placeholder-shown:translate-y-0 
                    peer-placeholder-shown:scale-100 peer-focus:-translate-y-3 
                    peer-focus:scale-85 pointer-events-none"
                  >
                    Fréquence (optionnel)
                  </label>
                </div>
              </div>
            </div>

            <!-- Location -->
            <div class="space-y-4">
              <h3 class="font-medium text-gray-900 mb-4">
                5. Où se situe votre demande ?
              </h3>
              <div class="relative">
                <input
                  v-model="form.location"
                  type="text"
                  required
                  class="peer w-full pl-12 pr-4 py-4 pt-6 rounded-xl border border-gray-200 focus:ring-primary-500 focus:border-primary-500 placeholder-transparent transition-all duration-200"
                  placeholder="Adresse"
                />
                <label class="absolute left-12 top-4 text-gray-500 text-sm transition-all duration-200 
                  -translate-y-3 scale-85 peer-placeholder-shown:translate-y-0 
                  peer-placeholder-shown:scale-100 peer-focus:-translate-y-3 
                  peer-focus:scale-85 pointer-events-none"
                >
                  Adresse complète
                </label>
                <MapPinIcon class="w-6 h-6 text-gray-400 absolute left-4 top-1/2 -translate-y-1/2" />
              </div>
            </div>
          </div>
        </div>

        <!-- Step 4: Budget & Confirmation -->
        <div 
          v-show="currentStep === 4" 
          class="transition-all duration-300"
        >
          <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-200 space-y-8">
            <!-- Budget -->
            <div class="space-y-4">
              <h3 class="font-medium text-gray-900 mb-4">
                6. Votre budget (optionnel)
              </h3>
              <div class="relative">
                <input
                  v-model="form.budget"
                  type="number"
                  min="0"
                  class="peer w-full pl-16 pr-4 py-4 pt-6 rounded-xl border border-gray-200 focus:ring-primary-500 focus:border-primary-500 placeholder-transparent transition-all duration-200"
                  placeholder="Budget"
                />
                <label class="absolute left-16 top-4 text-gray-500 text-sm transition-all duration-200 
                  -translate-y-3 scale-85 peer-placeholder-shown:translate-y-0 
                  peer-placeholder-shown:scale-100 peer-focus:-translate-y-3 
                  peer-focus:scale-85 pointer-events-none"
                >
                  Votre budget
                </label>
                <span class="absolute left-4 top-1/2 -translate-y-1/2 text-gray-500">
                  FCFA
                </span>
              </div>
            </div>

            <!-- Récapitulatif -->
            <div class="border-t border-gray-200 pt-6">
              <h3 class="font-medium text-gray-900 mb-4">Récapitulatif</h3>
              <!-- ... affichage du récapitulatif ... -->
            </div>
          </div>
        </div>

        <!-- Navigation Buttons -->
        <div class="flex justify-between gap-4 mt-8">
          <button
            v-if="currentStep > 1"
            @click="previousStep"
            class="px-6 py-3 text-gray-700 bg-gray-100 rounded-xl hover:bg-gray-200 transition-colors"
          >
            Retour
          </button>
          <button
            v-if="currentStep < 4"
            @click="nextStep"
            class="flex-1 px-6 py-3 bg-primary-500 text-white rounded-xl hover:bg-primary-600 transition-colors"
            :disabled="!canProceed"
          >
            Continuer
          </button>
          <button
            v-else
            @click="submitForm"
            class="flex-1 px-6 py-3 bg-primary-500 text-white rounded-xl hover:bg-primary-600 transition-colors"
          >
            Valider la demande
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { MapPinIcon, MagnifyingGlassIcon } from '@heroicons/vue/24/outline'
import { HomeIcon, WrenchIcon, UserGroupIcon } from '@heroicons/vue/24/solid'

const form = ref({
  serviceType: '',
  description: '',
  date: '',
  time: '',
  duration: '',
  frequency: '',
  location: '',
  budget: ''
})

const searchQuery = ref('')

const availableHours = [
  '08:00',
  '09:00',
  '10:00',
  '11:00',
  '12:00',
  '13:00',
  '14:00',
  '15:00',
  '16:00',
  '17:00',
  '18:00'
]

const categories = [
  {
    id: 'maison',
    name: 'Maison',
    icon: HomeIcon,
    services: [
      { id: 'menage', name: 'Ménage', icon: '🧹', price: 'Dès 500 FCFA/h' },
      { id: 'repassage', name: 'Repassage', icon: '👕', price: 'Dès 400 FCFA/h' },
      { id: 'cuisine', name: 'Cuisine', icon: '🍳', price: 'Dès 600 FCFA/h' },
      { id: 'courses', name: 'Courses', icon: '🛒', price: 'Dès 500 FCFA/h' }
    ]
  },
  {
    id: 'exterieur',
    name: 'Extérieur',
    icon: WrenchIcon,
    services: [
      { id: 'jardinage', name: 'Jardinage', icon: '🌱', price: 'Dès 1000 FCFA/h' },
      { id: 'piscine', name: 'Entretien piscine', icon: '🏊‍♂️', price: 'Dès 1500 FCFA/h' },
      { id: 'terrasse', name: 'Nettoyage terrasse', icon: '🏡', price: 'Dès 800 FCFA/h' }
    ]
  },
  {
    id: 'bricolage',
    name: 'Bricolage',
    icon: WrenchIcon,
    services: [
      { id: 'plomberie', name: 'Plomberie', icon: '🔧', price: 'Dès 2000 FCFA/h' },
      { id: 'electricite', name: 'Électricité', icon: '⚡', price: 'Dès 2000 FCFA/h' },
      { id: 'peinture', name: 'Peinture', icon: '🎨', price: 'Dès 1500 FCFA/h' },
      { id: 'montage', name: 'Montage meubles', icon: '🪑', price: 'Dès 1000 FCFA/h' }
    ]
  },
  {
    id: 'personnes',
    name: 'Aide aux personnes',
    icon: UserGroupIcon,
    services: [
      { id: 'garde', name: "Garde d'enfants", icon: '👶', price: 'Dès 800 FCFA/h' },
      { id: 'senior', name: 'Aide aux seniors', icon: '👴', price: 'Dès 900 FCFA/h' },
      { id: 'animaux', name: 'Garde animaux', icon: '🐕', price: 'Dès 500 FCFA/h' }
    ]
  }
]

const filteredCategories = computed(() => {
  if (!searchQuery.value) return categories
  
  return categories.map(category => ({
    ...category,
    services: category.services.filter(service => 
      service.name.toLowerCase().includes(searchQuery.value.toLowerCase())
    )
  })).filter(category => category.services.length > 0)
})

const currentStep = ref(1)

const stepTitles = [
  'Quel service recherchez-vous ?',
  'Décrivez votre besoin',
  'Précisez les détails',
  'Finalisez votre demande'
]

const stepDescriptions = [
  'Choisissez le service qui correspond à votre besoin',
  'Donnez-nous plus de détails sur votre demande',
  'Ajoutez les informations importantes',
  'Vérifiez et confirmez votre demande'
]

const canProceed = computed(() => {
  switch (currentStep.value) {
    case 1:
      return form.value.serviceType
    case 2:
      return form.value.description && form.value.date && form.value.time
    case 3:
      return form.value.duration && form.value.location
    default:
      return true
  }
})

const nextStep = () => {
  if (currentStep.value < 4 && canProceed.value) {
    currentStep.value++
    scrollToTop()
  }
}

const previousStep = () => {
  if (currentStep.value > 1) {
    currentStep.value--
    scrollToTop()
  }
}

const scrollToTop = () => {
  window.scrollTo({ top: 0, behavior: 'smooth' })
}

const submitForm = async () => {
  try {
    // Votre logique de soumission
    console.log('Form submitted:', form.value)
  } catch (error) {
    console.error('Error:', error)
  }
}

const selectService = (service) => {
  form.value.serviceType = service.id
  // Animation smooth scroll vers la description
  setTimeout(() => {
    document.querySelector('textarea').scrollIntoView({ 
      behavior: 'smooth',
      block: 'center'
    })
  }, 300)
}

definePageMeta({
  layout: 'default'
})
</script> 