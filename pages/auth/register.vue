<template>
  <div class="min-h-screen bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
    <div class="max-w-[480px] mx-auto">
      <!-- Header -->
      <div class="text-center mb-8">
        <h1 class="text-3xl font-bold text-gray-900">
          Créer un compte
        </h1>
        <p class="mt-2 text-gray-600">
          Rejoignez DomiServices pour trouver vos experts
        </p>
      </div>

      <!-- Form Card -->
      <div class="bg-white rounded-2xl -shadow-sm border border-gray-200 p-8">
        <form @submit.prevent="handleSubmit" class="space-y-6">
          <!-- Informations personnelles -->
          <div>
            <h2 class="text-lg font-medium text-gray-900 mb-4">
              Informations personnelles
            </h2>
            <div class="grid grid-cols-2 gap-4">
              <div class="relative">
                <input
                  v-model="form.firstName"
                  type="text"
                  required
                  class="peer w-full px-4 py-4 pt-6 rounded-xl border border-gray-200 focus:ring-primary-500 focus:border-primary-500 placeholder-transparent transition-all duration-200"
                  placeholder="Prénom"
                />
                <label 
                  class="absolute left-4 top-4 text-gray-500 text-sm transition-all duration-200 
                    -translate-y-3 scale-85 peer-placeholder-shown:translate-y-0 
                    peer-placeholder-shown:scale-100 peer-focus:-translate-y-3 
                    peer-focus:scale-85 pointer-events-none"
                >
                  Prénom
                </label>
              </div>
              <div class="relative">
                <input
                  v-model="form.lastName"
                  type="text"
                  required
                  class="peer w-full px-4 py-4 pt-6 rounded-xl border border-gray-200 focus:ring-primary-500 focus:border-primary-500 placeholder-transparent transition-all duration-200"
                  placeholder="Nom"
                />
                <label 
                  class="absolute left-4 top-4 text-gray-500 text-sm transition-all duration-200 
                    -translate-y-3 scale-85 peer-placeholder-shown:translate-y-0 
                    peer-placeholder-shown:scale-100 peer-focus:-translate-y-3 
                    peer-focus:scale-85 pointer-events-none"
                >
                  Nom
                </label>
              </div>
            </div>
          </div>

          <!-- Contact -->
          <div>
            <h2 class="text-lg font-medium text-gray-900 mb-4">
              Contact
            </h2>
            <!-- Téléphone -->
            <div class="relative">
              <div class="flex gap-3">
                <select
                  v-model="form.phonePrefix"
                  class="w-24 px-3 py-4 rounded-xl border border-gray-200 focus:ring-primary-500 focus:border-primary-500"
                >
                  <option value="+33">🇫🇷 +33</option>
                  <option value="+32">🇧🇪 +32</option>
                  <option value="+41">🇨🇭 +41</option>
                  <option value="+352">🇱🇺 +352</option>
                </select>
                <div class="relative flex-1">
                  <input
                    v-model="form.phone"
                    type="tel"
                    required
                    class="peer w-full px-4 py-4 pt-6 rounded-xl border border-gray-200 focus:ring-primary-500 focus:border-primary-500 placeholder-transparent transition-all duration-200"
                    placeholder="Téléphone"
                  />
                  <label 
                    class="absolute left-4 top-4 text-gray-500 text-sm transition-all duration-200 
                      -translate-y-3 scale-85 peer-placeholder-shown:translate-y-0 
                      peer-placeholder-shown:scale-100 peer-focus:-translate-y-3 
                      peer-focus:scale-85 pointer-events-none"
                  >
                    Numéro de téléphone
                  </label>
                </div>
              </div>
            </div>
          </div>

          <!-- Email & Password -->
          <div class="space-y-4">
            <div class="relative">
              <input
                v-model="form.email"
                type="email"
                required
                class="peer w-full px-4 py-4 pt-6 rounded-xl border border-gray-200 focus:ring-primary-500 focus:border-primary-500 placeholder-transparent transition-all duration-200"
                placeholder="Email"
              />
              <label 
                class="absolute left-4 top-4 text-gray-500 text-sm transition-all duration-200 
                  -translate-y-3 scale-85 peer-placeholder-shown:translate-y-0 
                  peer-placeholder-shown:scale-100 peer-focus:-translate-y-3 
                  peer-focus:scale-85 pointer-events-none"
              >
                Adresse email
              </label>
            </div>

            <div class="relative">
              <input
                v-model="form.password"
                :type="showPassword ? 'text' : 'password'"
                required
                class="peer w-full px-4 py-4 pt-6 rounded-xl border border-gray-200 focus:ring-primary-500 focus:border-primary-500 placeholder-transparent transition-all duration-200"
                placeholder="Password"
              />
              <label 
                class="absolute left-4 top-4 text-gray-500 text-sm transition-all duration-200 
                  -translate-y-3 scale-85 peer-placeholder-shown:translate-y-0 
                  peer-placeholder-shown:scale-100 peer-focus:-translate-y-3 
                  peer-focus:scale-85 pointer-events-none"
              >
                Mot de passe
              </label>
              <button 
                type="button"
                @click="showPassword = !showPassword"
                class="absolute right-4 top-1/2 -translate-y-1/2 text-gray-500 hover:text-gray-700"
              >
                <EyeIcon v-if="showPassword" class="w-5 h-5" />
                <EyeSlashIcon v-else class="w-5 h-5" />
              </button>
            </div>
          </div>

          <!-- Terms -->
          <div class="flex items-start">
            <div class="flex items-center h-5">
              <input
                v-model="form.acceptTerms"
                type="checkbox"
                required
                class="w-4 h-4 rounded border-gray-300 text-primary-500 focus:ring-primary-500"
              />
            </div>
            <div class="ml-3">
              <label class="text-sm text-gray-600">
                J'accepte les 
                <NuxtLink to="/legal/terms" class="text-primary-600 hover:text-primary-700">
                  conditions d'utilisation
                </NuxtLink>
                et la 
                <NuxtLink to="/legal/privacy" class="text-primary-600 hover:text-primary-700">
                  politique de confidentialité
                </NuxtLink>
              </label>
            </div>
          </div>

          <button
            type="submit"
            class="w-full py-3 bg-primary-500 text-white font-medium rounded-xl hover:bg-primary-600 transition-colors"
          >
            Créer mon compte
          </button>

          <p class="text-center text-sm text-gray-600">
            Déjà inscrit ?
            <NuxtLink to="/auth/login" class="text-primary-600 hover:text-primary-700 font-medium">
              Se connecter
            </NuxtLink>
          </p>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { EyeIcon, EyeSlashIcon } from '@heroicons/vue/24/outline'

const showPassword = ref(false)

const form = ref({
  firstName: '',
  lastName: '',
  email: '',
  password: '',
  phonePrefix: '+33',
  phone: '',
  acceptTerms: false
})

// Validation du numéro de téléphone
const validatePhone = (phone) => {
  const cleanPhone = phone.replace(/\s/g, '')
  return /^[0-9]{9,10}$/.test(cleanPhone)
}

const handleSubmit = async () => {
  try {
    // Validation du téléphone
    if (!validatePhone(form.value.phone)) {
      alert('Veuillez entrer un numéro de téléphone valide')
      return
    }

    // Formatage du numéro de téléphone complet
    const fullPhone = `${form.value.phonePrefix}${form.value.phone.replace(/\s/g, '')}`
    
    // Création de l'objet à envoyer
    const formData = {
      ...form.value,
      phone: fullPhone
    }

    console.log('Form submitted:', formData)
    // Logique d'inscription...
    
  } catch (error) {
    console.error('Error:', error)
  }
}

definePageMeta({
  layout: 'auth'
})
</script> 