<template>
  <div class="min-h-screen bg-gray-50">
    <div class="max-w-3xl mx-auto px-4 py-16">
      <!-- Progress Bar -->
      <div class="mb-12">
        <div class="flex items-center justify-between mb-2">
          <span class="text-sm font-medium text-primary-600">Étape 2/2</span>
          <span class="text-sm text-gray-500">Finalisation</span>
        </div>
        <div class="h-2 bg-gray-200 rounded-full">
          <div class="h-2 bg-primary-500 rounded-full w-full"></div>
        </div>
      </div>

      <!-- Form Card -->
      <div class="bg-white rounded-2xl -shadow-xl p-8">
        <h1 class="text-2xl font-bold text-gray-900 mb-2">Finalisez votre demande</h1>
        <p class="text-gray-500 mb-8">Remplissez ces informations pour recevoir des devis personnalisés</p>

        <form @submit.prevent="submitForm" class="space-y-6">
          <!-- Service Details -->
          <div class="bg-primary-50 rounded-xl p-4 flex items-center">
            <div class="w-12 h-12 bg-primary-100 rounded-xl flex items-center justify-center flex-shrink-0">
              <span class="text-2xl">{{ serviceIcons[form.serviceType] }}</span>
            </div>
            <div class="ml-4">
              <p class="text-sm text-gray-500">Service sélectionné</p>
              <p class="font-medium text-gray-900">{{ serviceNames[form.serviceType] }}</p>
            </div>
            <NuxtLink to="/" class="ml-auto text-primary-600 hover:text-primary-700">
              Modifier
            </NuxtLink>
          </div>

          <!-- Description -->
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2">
              Description de votre besoin *
            </label>
            <textarea 
              v-model="form.description"
              rows="4"
              class="w-full px-4 py-3 rounded-xl border-gray-200 focus:ring-2 focus:ring-primary-500 focus:border-primary-500 resize-none"
              placeholder="Décrivez votre besoin en détail..."
              required
            ></textarea>
          </div>

          <!-- Address -->
          <div class="grid grid-cols-2 gap-4">
            <div class="col-span-2">
              <label class="block text-sm font-medium text-gray-700 mb-2">
                Adresse *
              </label>
              <input 
                v-model="form.address"
                type="text"
                class="w-full h-12 px-4 rounded-xl border-gray-200 focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
                placeholder="Numéro et nom de rue"
                required
              />
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">
                Code postal *
              </label>
              <input 
                v-model="form.zipCode"
                type="text"
                class="w-full h-12 px-4 rounded-xl border-gray-200 focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
                pattern="[0-9]*"
                maxlength="5"
                placeholder="75001"
                required
              />
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">
                Ville *
              </label>
              <input 
                v-model="form.city"
                type="text"
                class="w-full h-12 px-4 rounded-xl border-gray-200 focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
                placeholder="Paris"
                required
              />
            </div>
          </div>

          <!-- Contact Info -->
          <div class="grid grid-cols-2 gap-4">
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">
                Prénom *
              </label>
              <input 
                v-model="form.firstName"
                type="text"
                class="w-full h-12 px-4 rounded-xl border-gray-200 focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
                required
              />
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">
                Nom *
              </label>
              <input 
                v-model="form.lastName"
                type="text"
                class="w-full h-12 px-4 rounded-xl border-gray-200 focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
                required
              />
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">
                Email *
              </label>
              <input 
                v-model="form.email"
                type="email"
                class="w-full h-12 px-4 rounded-xl border-gray-200 focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
                required
              />
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">
                Téléphone *
              </label>
              <input 
                v-model="form.phone"
                type="tel"
                class="w-full h-12 px-4 rounded-xl border-gray-200 focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
                required
              />
            </div>
          </div>

          <!-- Submit Button -->
          <button 
            type="submit"
            class="w-full h-14 bg-primary-500 text-white text-lg font-medium rounded-xl hover:bg-primary-600 transition-colors flex items-center justify-center gap-2"
          >
            Envoyer ma demande
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
            </svg>
          </button>
        </form>

        <!-- Trust Message -->
        <p class="text-sm text-gray-500 text-center mt-6">
          En soumettant ce formulaire, vous acceptez nos 
          <a href="#" class="text-primary-600 hover:text-primary-700">conditions d'utilisation</a>
          et notre 
          <a href="#" class="text-primary-600 hover:text-primary-700">politique de confidentialité</a>
        </p>
      </div>
    </div>
  </div>
</template>

<script setup>
const form = ref({
  serviceType: 'menage', // À récupérer de la page précédente
  description: '',
  address: '',
  zipCode: '',
  city: '',
  firstName: '',
  lastName: '',
  email: '',
  phone: ''
})

const serviceIcons = {
  menage: '🧹',
  jardinage: '🌱',
  bricolage: '🔨',
  garde: '👶'
}

const serviceNames = {
  menage: 'Ménage à domicile',
  jardinage: 'Jardinage',
  bricolage: 'Bricolage',
  garde: 'Garde d\'enfants'
}

const submitForm = async () => {
  try {
    // Envoyer les données au backend
    console.log('Form submitted:', form.value)
    
    // Rediriger vers la page de confirmation
    navigateTo('/demande/confirmation')
  } catch (error) {
    console.error('Error submitting form:', error)
  }
}
</script> 