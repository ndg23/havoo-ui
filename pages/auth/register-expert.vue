<template>
  <div class="min-h-screen bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
    <div class="max-w-[480px] mx-auto">
      <!-- Header -->
      <div class="text-center mb-8">
        <h1 class="text-3xl font-bold text-gray-900">
          Devenir Expert
        </h1>
        <p class="mt-2 text-gray-600">
          Rejoignez notre communauté de professionnels
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
                <label class="absolute left-4 top-4 text-gray-500 text-sm transition-all duration-200 
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
                <label class="absolute left-4 top-4 text-gray-500 text-sm transition-all duration-200 
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
            <div class="space-y-4">
              <!-- Téléphone -->
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">
                  Numéro de téléphone
                </label>
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
                    <label class="absolute left-4 top-4 text-gray-500 text-sm transition-all duration-200 
                      -translate-y-3 scale-85 peer-placeholder-shown:translate-y-0 
                      peer-placeholder-shown:scale-100 peer-focus:-translate-y-3 
                      peer-focus:scale-85 pointer-events-none"
                    >
                      Numéro de téléphone
                    </label>
                  </div>
                </div>
              </div>

              <!-- Adresse -->
              <div class="space-y-4">
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">
                    Adresse
                  </label>
                  <input
                    v-model="form.address.street"
                    type="text"
                    required
                    placeholder="Numéro et nom de rue"
                    class="w-full px-4 py-3 rounded-xl border-gray-200 focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
                  />
                </div>

                <div>
                  <input
                    v-model="form.address.complement"
                    type="text"
                    placeholder="Complément d'adresse (optionnel)"
                    class="w-full px-4 py-3 rounded-xl border-gray-200 focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
                  />
                </div>

                <div class="grid grid-cols-2 gap-4">
                  <div>
                    <input
                      v-model="form.address.postalCode"
                      type="text"
                      required
                      placeholder="Code postal"
                      class="w-full px-4 py-3 rounded-xl border-gray-200 focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
                    />
                  </div>
                  <div>
                    <input
                      v-model="form.address.city"
                      type="text"
                      required
                      placeholder="Ville"
                      class="w-full px-4 py-3 rounded-xl border-gray-200 focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
                    />
                  </div>
                </div>

                <div>
                  <select
                    v-model="form.address.country"
                    required
                    class="w-full px-4 py-3 rounded-xl border-gray-200 focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
                  >
                    <option value="">Sélectionnez un pays</option>
                    <option value="FR">France</option>
                    <option value="BE">Belgique</option>
                    <option value="CH">Suisse</option>
                    <option value="LU">Luxembourg</option>
                  </select>
                </div>
              </div>
            </div>
          </div>

          <!-- Date de naissance -->
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">
              Date de naissance
            </label>
            <input
              v-model="form.birthDate"
              type="date"
              required
              class="w-full px-4 py-3 rounded-xl border-gray-200 focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
            />
          </div>

          <!-- Documents d'identité -->
          <div>
            <h2 class="text-lg font-medium text-gray-900 mb-4">
              Documents d'identité
            </h2>
            
            <!-- CNI Upload -->
            <div class="mb-4">
              <label class="block text-sm font-medium text-gray-700 mb-1">
                Carte d'identité (recto/verso)
              </label>
              <div class="mt-1 flex justify-center px-6 pt-5 pb-6 border-2 border-gray-300 border-dashed rounded-xl">
                <div class="space-y-1 text-center">
                  <DocumentIcon class="mx-auto h-12 w-12 text-gray-400" />
                  <div class="flex text-sm text-gray-600">
                    <label class="relative cursor-pointer bg-white rounded-md font-medium text-primary-600 hover:text-primary-500">
                      <span>Télécharger un fichier</span>
                      <input 
                        type="file" 
                        class="sr-only" 
                        accept="image/*,.pdf"
                        @change="handleCNIUpload"
                        required
                      />
                    </label>
                  </div>
                  <p class="text-xs text-gray-500">
                    PNG, JPG ou PDF jusqu'à 10MB
                  </p>
                </div>
              </div>
              <div v-if="form.cniFile" class="mt-2 text-sm text-gray-600">
                Fichier sélectionné: {{ form.cniFile.name }}
              </div>
            </div>
          </div>

          <!-- Langues parlées -->
          <div>
            <h2 class="text-lg font-medium text-gray-900 mb-4">
              Langues parlées
            </h2>
            <div class="space-y-3">
              <div v-for="(language, index) in form.languages" :key="index" class="flex gap-4">
                <select
                  v-model="language.name"
                  class="flex-1 px-4 py-3 rounded-xl border-gray-200 focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
                >
                  <option value="">Sélectionnez une langue</option>
                  <option v-for="lang in availableLanguages" :key="lang.code" :value="lang.code">
                    {{ lang.name }}
                  </option>
                </select>
                <select
                  v-model="language.level"
                  class="w-40 px-4 py-3 rounded-xl border-gray-200 focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
                >
                  <option value="">Niveau</option>
                  <option value="native">Langue maternelle</option>
                  <option value="fluent">Courant</option>
                  <option value="intermediate">Intermédiaire</option>
                  <option value="basic">Basique</option>
                </select>
                <button 
                  type="button"
                  @click="removeLanguage(index)"
                  class="p-3 text-gray-400 hover:text-red-500"
                >
                  <XMarkIcon class="w-5 h-5" />
                </button>
              </div>
              <button 
                type="button"
                @click="addLanguage"
                class="text-sm text-primary-600 hover:text-primary-700 font-medium"
              >
                + Ajouter une langue
              </button>
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
              <label class="absolute left-4 top-4 text-gray-500 text-sm transition-all duration-200 
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
              <label class="absolute left-4 top-4 text-gray-500 text-sm transition-all duration-200 
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

          <button
            type="submit"
            class="w-full py-3 bg-primary-500 text-white font-medium rounded-xl hover:bg-primary-600 transition-colors"
          >
            Créer mon compte
          </button>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { 
  EyeIcon, 
  EyeSlashIcon,
  DocumentIcon,
  XMarkIcon
} from '@heroicons/vue/24/outline'

const showPassword = ref(false)

const form = ref({
  firstName: '',
  lastName: '',
  email: '',
  password: '',
  birthDate: '',
  phonePrefix: '+33',
  phone: '',
  address: {
    street: '',
    complement: '',
    postalCode: '',
    city: '',
    country: ''
  },
  cniFile: null,
  languages: [{ name: '', level: '' }]
})

const availableLanguages = [
  { code: 'fr', name: 'Français' },
  { code: 'en', name: 'Anglais' },
  { code: 'es', name: 'Espagnol' },
  { code: 'de', name: 'Allemand' },
  { code: 'it', name: 'Italien' },
  { code: 'pt', name: 'Portugais' },
  { code: 'ar', name: 'Arabe' },
  { code: 'zh', name: 'Chinois' }
]

const addLanguage = () => {
  form.value.languages.push({ name: '', level: '' })
}

const removeLanguage = (index) => {
  form.value.languages.splice(index, 1)
}

const handleCNIUpload = (event) => {
  const file = event.target.files[0]
  if (file) {
    // Vérification de la taille (10MB max)
    if (file.size > 10 * 1024 * 1024) {
      alert('Le fichier est trop volumineux. Maximum 10MB.')
      event.target.value = ''
      return
    }
    form.value.cniFile = file
  }
}

// Validation du numéro de téléphone
const validatePhone = (phone) => {
  // Supprime les espaces et vérifie le format
  const cleanPhone = phone.replace(/\s/g, '')
  return /^[0-9]{9,10}$/.test(cleanPhone)
}

// Validation du code postal
const validatePostalCode = (postalCode) => {
  return /^[0-9]{5}$/.test(postalCode)
}

const handleSubmit = async () => {
  try {
    // Validation du téléphone
    if (!validatePhone(form.value.phone)) {
      alert('Veuillez entrer un numéro de téléphone valide')
      return
    }

    // Validation du code postal
    if (!validatePostalCode(form.value.address.postalCode)) {
      alert('Veuillez entrer un code postal valide')
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