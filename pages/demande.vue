<template>
  <div class="min-h-screen bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
    <div class="max-w-3xl mx-auto">
      <!-- Header -->
      <div class="text-center mb-12">
        <h1 class="text-4xl font-bold text-gray-900 mb-4">
          Décrivez votre besoin
        </h1>
        <p class="text-xl text-gray-600">
          Trouvez l'expert idéal en quelques clics
        </p>
      </div>

      <!-- Form Card -->
      <div class="bg-white rounded-3xl shadow-sm border border-gray-200 p-8">
        <form @submit.prevent="handleSubmit" class="space-y-12">
          <!-- Service Type Section -->
          <section>
            <h2 class="text-lg font-medium text-gray-900 mb-4">
              1. Quel service recherchez-vous ?
            </h2>
            <div class="grid sm:grid-cols-2 lg:grid-cols-4 gap-4">
              <button
                v-for="(service, index) in services"
                :key="service.id"
                type="button"
                @click="selectService(service.id)"
                class="relative p-6 rounded-2xl border-2 transition-all duration-300 text-center group"
                :class="[
                  form.serviceType === service.id 
                    ? 'border-primary-500 bg-primary-50 scale-105' 
                    : 'border-gray-200 hover:border-primary-300'
                ]"
              >
                <div 
                  class="text-4xl mb-3 transform transition-transform duration-300"
                  :class="form.serviceType === service.id ? 'scale-110' : ''"
                >
                  {{ service.icon }}
                </div>
                <div class="font-medium" :class="[
                  form.serviceType === service.id 
                    ? 'text-primary-900' 
                    : 'text-gray-900'
                ]">
                  {{ service.name }}
                </div>
                <div class="text-sm mt-1" :class="[
                  form.serviceType === service.id 
                    ? 'text-primary-600' 
                    : 'text-gray-500'
                ]">
                  {{ service.price }}
                </div>
                <div 
                  class="absolute inset-0 border-2 border-primary-500 rounded-2xl opacity-0 transition-all duration-300"
                  :class="{ 'opacity-100': form.serviceType === service.id }"
                ></div>
              </button>
            </div>
          </section>

          <!-- Description Section -->
          <section>
            <h2 class="text-lg font-medium text-gray-900 mb-4">
              2. Décrivez votre besoin
            </h2>
            <div class="relative">
              <textarea
                v-model="form.description"
                rows="4"
                required
                class="peer w-full px-4 py-4 pt-6 rounded-xl border border-gray-200 focus:ring-primary-500 focus:border-primary-500 resize-none placeholder-transparent transition-all duration-200"
                placeholder="Description"
              ></textarea>
              <label class="absolute left-4 top-4 text-gray-500 text-sm transition-all duration-200 
                -translate-y-3 scale-85 peer-placeholder-shown:translate-y-0 
                peer-placeholder-shown:scale-100 peer-focus:-translate-y-3 
                peer-focus:scale-85 pointer-events-none"
              >
                Décrivez votre besoin en détail
              </label>
            </div>
          </section>

          <!-- Date & Time Section -->
          <section>
            <h2 class="text-lg font-medium text-gray-900 mb-4">
              3. Quand souhaitez-vous réaliser ce service ?
            </h2>
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
          </section>

          <!-- Duration Section -->
          <section>
            <h2 class="text-lg font-medium text-gray-900 mb-4">
              4. Durée estimée
            </h2>
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
          </section>

          <!-- Location Section -->
          <section>
            <h2 class="text-lg font-medium text-gray-900 mb-4">
              5. Où se situe votre demande ?
            </h2>
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
          </section>

          <!-- Budget Section -->
          <section>
            <h2 class="text-lg font-medium text-gray-900 mb-4">
              6. Votre budget (optionnel)
            </h2>
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
          </section>

          <!-- Submit Button -->
          <button
            type="submit"
            class="w-full py-4 bg-primary-500 text-white text-lg font-medium rounded-xl hover:bg-primary-600 transition-colors shadow-lg shadow-primary-500/25 hover:shadow-xl hover:shadow-primary-500/30"
          >
            Trouver un expert
          </button>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { MapPinIcon } from '@heroicons/vue/24/outline'

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

const services = [
  { id: 'menage', name: 'Ménage', icon: '🧹', price: 'Dès 500 FCFA' },
  { id: 'jardinage', name: 'Jardinage', icon: '🌱', price: 'Dès 1000 FCFA' },
  { id: 'bricolage', name: 'Bricolage', icon: '🔨', price: 'Dès 1500 FCFA' },
  { id: 'garde', name: "Garde d'enfants", icon: '👶', price: 'Dès 800 FCFA' }
]

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

const handleSubmit = async () => {
  try {
    // Logique de soumission
    console.log('Form submitted:', form.value)
  } catch (error) {
    console.error('Error:', error)
  }
}

const selectService = (serviceId) => {
  form.value.serviceType = serviceId
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