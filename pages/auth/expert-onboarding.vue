<template>
  <div class="min-h-screen bg-white flex flex-col">
    <!-- Barre de progression subtile -->
    <div class="fixed top-0 left-0 right-0 h-1 bg-gray-100">
      <div 
        class="h-full bg-primary-500 transition-all duration-500 ease-out"
        :style="{ width: `${(currentStep / totalSteps) * 100}%` }"
      ></div>
    </div>
      
    <div class="flex-1 flex flex-col items-center pt-16 p-6">
      <div class="w-full max-w-md">
        <!-- Étape -->
        <div class="mb-14 flex justify-end">
          <div class="text-gray-400 text-sm font-medium">
            Étape {{ currentStep }} sur {{ totalSteps }}
          </div>
        </div>

        <!-- Titre et contenu de l'étape actuelle -->
        <transition 
          name="slide-fade" 
          mode="out-in"
        >
          <div :key="currentStep">
            <!-- Étape 1: Prénom -->
            <div v-if="currentStep === 1" class="space-y-12">
              <h1 class="text-3xl font-semibold text-gray-900">
                Comment vous appelez-vous ?
              </h1>
              <div class="space-y-6">
                <div>
                  <input
                    v-model="form.firstName"
                    type="text"
                    placeholder="Votre prénom"
                    class="w-full p-4 text-xl border-b-2 border-gray-200 focus:border-primary-500 focus:outline-none transition-colors"
                    autofocus
                  />
                  <p class="mt-2 text-sm text-gray-500">
                    <InformationCircle class="inline-block h-4 w-4 mr-1 text-gray-400" />
                    Votre prénom sera visible par les clients potentiels
                  </p>
                </div>
              </div>
            </div>
            
            <!-- Étape 2: Nom -->
            <div v-if="currentStep === 2" class="space-y-12">
              <h1 class="text-3xl font-semibold text-gray-900">
                Et votre nom de famille ?
              </h1>
              <div class="space-y-6">
                <div>
                  <input
                    v-model="form.lastName"
                    type="text"
                    placeholder="Votre nom"
                    class="w-full p-4 text-xl border-b-2 border-gray-200 focus:border-primary-500 focus:outline-none transition-colors"
                    autofocus
                  />
                  <p class="mt-2 text-sm text-gray-500">
                    <InformationCircle class="inline-block h-4 w-4 mr-1 text-gray-400" />
                    Utilisé pour la facturation et votre profil professionnel
                  </p>
                </div>
              </div>
            </div>

            <!-- Étape 3: Localisation -->
            <div v-if="currentStep === 3" class="space-y-12">
              <h1 class="text-3xl font-semibold text-gray-900">
                Où êtes-vous situé ?
              </h1>
              <div class="space-y-6">
                <div>
                  <input
                    v-model="form.city"
                    type="text"
                    placeholder="Votre ville"
                    class="w-full p-4 text-xl border-b-2 border-gray-200 focus:border-primary-500 focus:outline-none transition-colors"
                    autofocus
                  />
                  <p class="mt-2 text-sm text-gray-500">
                    <MapPin class="inline-block h-4 w-4 mr-1 text-gray-400" />
                    Nous utilisons cette information pour vous connecter avec des clients proches
                  </p>
                </div>
                
                <div>
                  <select
                    v-model="form.country"
                    class="w-full p-4 text-xl border-b-2 border-gray-200 focus:border-primary-500 focus:outline-none transition-colors appearance-none bg-transparent"
                  >
                    <option value="" disabled selected>Sélectionnez votre pays</option>
                    <option value="FR">France</option>
                    <option value="BE">Belgique</option>
                    <option value="CH">Suisse</option>
                    <option value="CA">Canada</option>
                    <option value="LU">Luxembourg</option>
                  </select>
                </div>
              </div>
            </div>
            
            <!-- Étape 4: Téléphone -->
            <div v-if="currentStep === 4" class="space-y-12">
              <h1 class="text-3xl font-semibold text-gray-900">
                Quel est votre numéro de téléphone ?
              </h1>
              <div class="space-y-6">
                <div>
                  <input
                    v-model="form.phone"
                    type="tel"
                    placeholder="Votre numéro"
                    class="w-full p-4 text-xl border-b-2 border-gray-200 focus:border-primary-500 focus:outline-none transition-colors"
                    autofocus
                  />
                  <p class="mt-2 text-sm text-gray-500">
                    <Shield class="inline-block h-4 w-4 mr-1 text-gray-400" />
                    Visible uniquement par vos clients confirmés
                  </p>
                </div>
              </div>
            </div>

            <!-- Étape 5: Bio professionnelle -->
            <div v-if="currentStep === 5" class="space-y-12">
              <h1 class="text-3xl font-semibold text-gray-900">
                Parlez-nous de votre expertise
              </h1>
              <div class="space-y-6">
                <div>
                  <textarea 
                    v-model="form.bio"
                    rows="5"
                    placeholder="Décrivez votre parcours et vos compétences..."
                    class="w-full p-4 text-lg border-2 border-gray-200 rounded-xl focus:border-primary-500 focus:outline-none transition-colors"
                    autofocus
                  ></textarea>
                  <div class="flex justify-between mt-2">
                    <p class="text-sm text-gray-500">
                      <UsersRound class="inline-block h-4 w-4 mr-1 text-gray-400" />
                      Cette description sera visible sur votre profil public
                    </p>
                    <span class="text-xs text-gray-400">
                      {{ form.bio.length }}/300
                    </span>
                  </div>
                </div>
              </div>
            </div>

            <!-- Étape 6: Expérience -->
            <div v-if="currentStep === 6" class="space-y-12">
              <h1 class="text-3xl font-semibold text-gray-900">
                Quelle est votre expérience ?
              </h1>
              <div class="space-y-6">
                <div class="grid grid-cols-1 gap-3">
                  <button
                    v-for="option in experienceOptions"
                    :key="option.value"
                    type="button"
                    @click="form.experience = option.value"
                    :class="[
                      'p-4 text-left rounded-xl border-2 transition-all flex flex-col',
                      form.experience === option.value
                        ? 'border-primary-500 bg-primary-50 text-primary-700'
                        : 'border-gray-200 hover:border-gray-300'
                    ]"
                  >
                    <span class="font-medium">{{ option.label }}</span>
                    <span class="text-sm mt-1 text-gray-500">{{ option.description }}</span>
                  </button>
                </div>
                <p class="text-sm text-gray-500 mt-2">
                  <Award class="inline-block h-4 w-4 mr-1 text-gray-400" />
                  Cette information aide les clients à mieux comprendre votre profil
                </p>
              </div>
            </div>

            <!-- Étape 7: Tarif horaire -->
            <div v-if="currentStep === 7" class="space-y-12">
              <h1 class="text-3xl font-semibold text-gray-900">
                Quel est votre tarif horaire ?
              </h1>
              <div class="space-y-6">
                <div>
                  <div class="relative">
                    <div class="absolute inset-y-0 left-0 flex items-center pl-4">
                      <span class="text-gray-600 text-xl">FCFA</span>
                    </div>
                    <input
                      v-model="form.hourlyRate"
                      type="number"
                      min="0"
                      step="1"
                      placeholder="50"
                      class="w-full p-4 pl-10 text-xl border-b-2 border-gray-200 focus:border-primary-500 focus:outline-none transition-colors"
                      autofocus
                    />
                  </div>
                  <p class="mt-2 text-sm text-gray-500">
                    <TrendingUp class="inline-block h-4 w-4 mr-1 text-gray-400" />
                    Prix suggéré: 35FCFA - 80FCFA selon votre expérience et votre secteur
                  </p>
                </div>
              </div>
            </div>

            <!-- Étape 8: Photo de profil -->
            <div v-if="currentStep === 8" class="space-y-12">
              <h1 class="text-3xl font-semibold text-gray-900">
                Ajoutez une photo de profil
              </h1>
              <div class="space-y-8 flex flex-col items-center">
                <div class="relative">
                  <div 
                    class="h-32 w-32 rounded-full overflow-hidden bg-gray-100 flex items-center justify-center border-2 border-gray-200 relative"
                  >
                    <img 
                      v-if="avatarPreview" 
                      :src="avatarPreview" 
                      alt="Avatar preview" 
                      class="h-full w-full object-cover"
                    />
                    <User v-else class="h-16 w-16 text-gray-400" />
                    
                    <div 
                      v-if="isUploading"
                      class="absolute inset-0 bg-black bg-opacity-40 flex items-center justify-center"
                    >
                      <Loader2 class="h-10 w-10 text-white animate-spin" />
                    </div>
                  </div>
                  <button 
                    type="button"
                    @click="$refs.fileInput.click()"
                    class="absolute -right-1 bottom-0 h-10 w-10 rounded-full bg-primary-500 flex items-center justify-center border-2 border-white shadow-sm"
                  >
                    <Camera class="h-5 w-5 text-white" />
                  </button>
                </div>
                
                <input 
                  ref="fileInput"
                  type="file"
                  accept="image/*"
                  class="hidden"
                  @change="handleAvatarUpload"
                />
                
                <p class="text-center text-sm text-gray-500">
                  Une photo professionnelle augmente <br>vos chances de trouver des clients
                </p>
                
                <button 
                  v-if="!avatarPreview"
                  type="button"
                  @click="$refs.fileInput.click()"
                  class="px-5 py-2.5 text-primary-600 font-medium rounded-full border-2 border-primary-200 hover:bg-primary-50 transition-colors"
                >
                  Choisir une photo
                </button>
              </div>
            </div>

            <!-- Étape 9: Disponibilités -->
            <div v-if="currentStep === 9" class="space-y-12">
              <h1 class="text-3xl font-semibold text-gray-900">
                Quelles sont vos disponibilités ?
              </h1>
              <div class="space-y-8">
                <div>
                  <div class="font-medium text-gray-700 mb-3">Jours disponibles</div>
                  <div class="grid grid-cols-3 sm:grid-cols-4 gap-2">
                    <button 
                      v-for="day in availableDays" 
                      :key="day.value"
                      type="button"
                      @click="toggleDay(day.value)"
                      :class="[
                        'p-3 rounded-xl border-2 transition-all text-center',
                        form.availableDays.includes(day.value)
                          ? 'border-primary-500 bg-primary-50 text-primary-700'
                          : 'border-gray-200 text-gray-600 hover:border-gray-300'
                      ]"
                    >
                      {{ day.label }}
                    </button>
                  </div>
                  <p class="mt-3 text-sm text-gray-500">
                    <Calendar class="inline-block h-4 w-4 mr-1 text-gray-400" />
                    Vous pourrez ajuster vos disponibilités à tout moment
                  </p>
                </div>
                
                <div class="grid grid-cols-2 gap-4">
                  <div>
                    <div class="font-medium text-gray-700 mb-2">De</div>
                    <select
                      v-model="form.startHour"
                      class="w-full p-3 border-2 border-gray-200 rounded-xl focus:border-primary-500 transition-colors"
                    >
                      <option v-for="hour in hourOptions" :key="hour.value" :value="hour.value">
                        {{ hour.label }}
                      </option>
                    </select>
                  </div>
                  <div>
                    <div class="font-medium text-gray-700 mb-2">À</div>
                    <select
                      v-model="form.endHour"
                      class="w-full p-3 border-2 border-gray-200 rounded-xl focus:border-primary-500 transition-colors"
                    >
                      <option v-for="hour in hourOptions" :key="hour.value" :value="hour.value">
                        {{ hour.label }}
                      </option>
                    </select>
                  </div>
                </div>
              </div>
            </div>

            <!-- Étape 10: Vérification d'identité -->
            <div v-if="currentStep === 10" class="space-y-12">
              <h1 class="text-3xl font-semibold text-gray-900">
                Vérifiez votre identité
              </h1>
              <div class="space-y-8">
                <p class="text-gray-600">
                  Pour garantir la sécurité de notre communauté, nous avons besoin de vérifier votre identité.
                </p>
                
                <div class="p-4 border-2 border-gray-200 rounded-xl">
                  <div class="flex items-start">
                    <div class="mt-1 mr-3">
                      <FileText class="h-6 w-6 text-primary-500" />
                    </div>
                    <div>
                      <h3 class="font-medium text-gray-900">Pièce d'identité</h3>
                      <p class="text-sm text-gray-500 mb-3">
                        Passeport, carte d'identité ou permis de conduire
                      </p>
                      
                      <div class="flex items-center">
                        <input 
                          ref="idFileInput"
                          type="file"
                          accept="image/*,.pdf"
                          class="hidden"
                          @change="handleIdUpload"
                        />
                        
                        <button
                          type="button"
                          @click="$refs.idFileInput.click()"
                          class="px-4 py-2 text-sm border border-gray-300 rounded-lg hover:bg-gray-50 transition-colors flex items-center"
                        >
                          <Upload class="h-4 w-4 mr-1" />
                          {{ form.idDocument ? 'Changer le fichier' : 'Choisir un fichier' }}
                        </button>
                        
                        <span v-if="form.idDocument" class="ml-3 text-sm text-gray-600">
                          {{ form.idDocument.name }}
                        </span>
                      </div>
                    </div>
                  </div>
                </div>
                
                <div class="bg-amber-50 p-4 rounded-xl text-amber-800 text-sm">
                  <div class="flex">
                    <ShieldCheck class="h-5 w-5 text-amber-600 mr-2 flex-shrink-0" />
                    <p>
                      Vos documents sont stockés de manière sécurisée et ne sont accessibles qu'à notre équipe de vérification.
                    </p>
                  </div>
                </div>
              </div>
            </div>

            <!-- Étape 11: CGU -->
            <div v-if="currentStep === 11" class="space-y-12">
              <h1 class="text-3xl font-semibold text-gray-900">
                Dernière étape
              </h1>
              <div class="space-y-6">
                <div class="p-4 bg-gray-50 rounded-xl">
                  <h3 class="font-medium text-gray-900 mb-2">Résumé de votre profil</h3>
                  <div class="space-y-2 text-sm text-gray-600">
                    <p><span class="font-medium">Nom:</span> {{ form.firstName }} {{ form.lastName }}</p>
                    <p><span class="font-medium">Localisation:</span> {{ form.city }}, {{ getCountryName(form.country) }}</p>
                    <p><span class="font-medium">Expérience:</span> {{ getExperienceLabel(form.experience) }}</p>
                    <p><span class="font-medium">Tarif horaire:</span> {{ form.hourlyRate }}FCFA</p>
                  </div>
                </div>
                
                <div class="flex items-start">
                  <div class="flex items-center h-5">
                    <input
                      id="terms"
                      v-model="form.acceptTerms"
                      type="checkbox"
                      required
                      class="h-4 w-4 text-primary-600 focus:ring-primary-500 border-gray-300 rounded"
                    />
                  </div>
                  <div class="ml-3 text-sm">
                    <label for="terms" class="text-gray-600">
                      J'accepte les <NuxtLink to="/terms" class="text-primary-600 hover:text-primary-700 font-medium">Conditions d'utilisation</NuxtLink> et la <NuxtLink to="/privacy" class="text-primary-600 hover:text-primary-700 font-medium">Politique de confidentialité</NuxtLink>
                    </label>
                  </div>
                </div>
                
                <div class="flex items-start">
                  <div class="flex items-center h-5">
                    <input
                      id="marketing"
                      v-model="form.acceptMarketing"
                      type="checkbox"
                      class="h-4 w-4 text-primary-600 focus:ring-primary-500 border-gray-300 rounded"
                    />
                  </div>
                  <div class="ml-3 text-sm">
                    <label for="marketing" class="text-gray-600">
                      J'accepte de recevoir des communications marketing (facultatif)
                    </label>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </transition>

        <!-- Boutons de navigation -->
        <div class="mt-14 space-y-4">
          <button
            v-if="currentStep < totalSteps"
            @click="nextStep"
            class="w-full py-4 bg-primary-600 text-white font-medium rounded-full
              hover:bg-primary-700 disabled:opacity-50 disabled:cursor-not-allowed
              transition-colors shadow-md"
          >
            Continuer
          </button>
          
          <button
            v-else
            @click="handleSubmit"
            :disabled="loading || !form.acceptTerms"
            class="w-full py-4 bg-primary-600 text-white font-medium rounded-full
              hover:bg-primary-700 disabled:opacity-50 disabled:cursor-not-allowed
              transition-colors shadow-md flex items-center justify-center"
          >
            <Loader2 v-if="loading" class="animate-spin -ml-1 mr-2 h-5 w-5" />
            {{ loading ? 'Création en cours...' : 'Créer mon profil expert' }}
          </button>
          
          <button
            v-if="currentStep > 1"
            @click="currentStep--"
            type="button"
            class="w-full py-3 text-gray-600 font-medium hover:text-gray-900 transition-colors"
          >
            Retour
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useSupabaseClient } from '#imports'
import { 
  Camera, User, Loader2, Upload, FileText, ShieldCheck, 
  Calendar, MapPin, UsersRound, Award, TrendingUp, Shield,
  InformationCircle
} from 'lucide-vue-next'

const client = useSupabaseClient()
const router = useRouter()
const fileInput = ref<HTMLInputElement | null>(null)
const idFileInput = ref<HTMLInputElement | null>(null)

// États
const currentStep = ref(1)
const totalSteps = 11
const loading = ref(false)
const isUploading = ref(false)
const avatarPreview = ref<string | null>(null)

// Formulaire complet
const form = ref({
  // Informations personnelles
  firstName: '',
  lastName: '',
  city: '',
  country: '',
  phone: '',
  
  // Informations professionnelles
  bio: '',
  experience: '',
  hourlyRate: '',
  
  // Disponibilités
  availableDays: [],
  startHour: '09:00',
  endHour: '18:00',
  responseTime: 'within_day',
  
  // Documents
  avatarFile: null,
  idDocument: null,
  
  // Conditions
  acceptTerms: false,
  acceptMarketing: false
})

// Options pour l'expérience
const experienceOptions = [
  { 
    value: 'beginner', 
    label: 'Débutant', 
    description: 'Moins de 2 ans d\'expérience' 
  },
  { 
    value: 'intermediate', 
    label: 'Intermédiaire', 
    description: '2-5 ans d\'expérience' 
  },
  { 
    value: 'expert', 
    label: 'Expert', 
    description: '5-10 ans d\'expérience' 
  },
  { 
    value: 'master', 
    label: 'Maître', 
    description: 'Plus de 10 ans d\'expérience' 
  }
]

// Options de jours disponibles
const availableDays = [
  { value: 'monday', label: 'Lundi' },
  { value: 'tuesday', label: 'Mardi' },
  { value: 'wednesday', label: 'Mercredi' },
  { value: 'thursday', label: 'Jeudi' },
  { value: 'friday', label: 'Vendredi' },
  { value: 'saturday', label: 'Samedi' },
  { value: 'sunday', label: 'Dimanche' }
]

// Options d'heures
const hourOptions = Array.from({ length: 24 * 4 }, (_, i) => {
  const hour = Math.floor(i / 4)
  const minute = (i % 4) * 15
  const value = `${hour.toString().padStart(2, '0')}:${minute.toString().padStart(2, '0')}`
  
  // Formatter pour l'affichage
  const hour12 = hour % 12 || 12
  const ampm = hour < 12 ? 'AM' : 'PM'
  const label = `${hour12}:${minute.toString().padStart(2, '0')} ${ampm}`
  
  return { value, label }
})

// Ajouter un jour à la sélection
const toggleDay = (day) => {
  const index = form.value.availableDays.indexOf(day)
  if (index === -1) {
    form.value.availableDays.push(day)
  } else {
    form.value.availableDays.splice(index, 1)
  }
}

// Déterminer si l'utilisateur peut passer à l'étape suivante
const canProceed = computed(() => {
  switch (currentStep.value) {
    case 1: return !!form.value.firstName.trim()
    case 2: return !!form.value.lastName.trim()
    case 3: return !!form.value.city.trim() && !!form.value.country
    case 4: return !!form.value.phone && form.value.phone.length >= 8
    case 5: return !!form.value.bio.trim() && form.value.bio.length >= 10
    case 6: return !!form.value.experience
    case 7: return !!form.value.hourlyRate && parseFloat(form.value.hourlyRate) > 0
    case 8: return true // Photo facultative
    case 9: return form.value.availableDays.length > 0
    case 10: return true // Document d'identité facultatif à ce stade
    case 11: return form.value.acceptTerms
    default: return true
  }
})

// Gérer l'upload de l'avatar
const handleAvatarUpload = (event) => {
  const input = event.target
  if (!input.files || input.files.length === 0) return
  
  const file = input.files[0]
  form.value.avatarFile = file
  
  // Prévisualisation
  const reader = new FileReader()
  reader.onload = (e) => {
    avatarPreview.value = e.target.result as string
  }
  reader.readAsDataURL(file)
}

// Gérer l'upload de la pièce d'identité
const handleIdUpload = (event) => {
  const input = event.target
  if (!input.files || input.files.length === 0) return
  
  const file = input.files[0]
  form.value.idDocument = file
}

// Navigation entre les étapes
const nextStep = () => {
  if (currentStep.value < totalSteps && canProceed.value) {
    currentStep.value++
    window.scrollTo(0, 0) // Remonter en haut pour la nouvelle étape
  }
}

// Obtenir le nom du pays à partir du code
const getCountryName = (code) => {
  const countries = {
    'FR': 'France',
    'BE': 'Belgique',
    'CH': 'Suisse',
    'CA': 'Canada',
    'LU': 'Luxembourg'
  }
  return countries[code] || code
}

// Obtenir le libellé d'expérience à partir de la valeur
const getExperienceLabel = (value) => {
  const option = experienceOptions.find(opt => opt.value === value)
  return option ? option.label : value
}

// Soumission finale du formulaire
const handleSubmit = async () => {
  if (!canProceed.value) return
  
  try {
    loading.value = true
    const { data: { user }, error: userError } = await client.auth.getUser()
    
    if (userError) throw userError
    if (!user) throw new Error('Utilisateur non connecté')

    // 1. Mettre à jour le profil avec les nouvelles informations
    const { error: profileError } = await client
      .from('profiles')
      .update({
        first_name: form.value.firstName,
        last_name: form.value.lastName,
        city: form.value.city,
        country: form.value.country,
        phone: form.value.phone,
        bio: form.value.bio,
        is_expert: true,
        updated_at: new Date().toISOString()
      })
      .eq('id', user.id)

    if (profileError) throw profileError

    // 2. Mettre à jour ou créer l'entrée expert
    const expertData = {
      id: user.id,
      bio: form.value.bio,
      hourly_rate: parseFloat(form.value.hourlyRate || 0),
      experience_level: form.value.experience,
      available_days: form.value.availableDays,
      available_hours_start: form.value.startHour,
      available_hours_end: form.value.endHour,
      response_time: form.value.responseTime,
      availability_status: 'available',
      verification_status: 'pending_review',
      created_at: new Date().toISOString(),
      updated_at: new Date().toISOString()
    }
    
    const { error: expertError } = await client
      .from('experts')
      .upsert(expertData)

    if (expertError) throw expertError

    // 3. Télécharger l'avatar si présent
    if (form.value.avatarFile) {
      const fileExt = form.value.avatarFile.name.split('.').pop()
      const filePath = `avatars/${user.id}-${Date.now()}.${fileExt}`
      
      const { error: uploadError } = await client.storage
        .from('profiles')
        .upload(filePath, form.value.avatarFile)
        
      if (uploadError) throw uploadError
      
      // Mettre à jour l'URL de l'avatar dans le profil
      const { data: { publicUrl } } = client.storage
        .from('profiles')
        .getPublicUrl(filePath)
        
      await client
        .from('profiles')
        .update({ avatar_url: publicUrl })
        .eq('id', user.id)
    }
    
    // 4. Télécharger la pièce d'identité
    if (form.value.idDocument) {
      const fileExt = form.value.idDocument.name.split('.').pop()
      const filePath = `id_documents/${user.id}-${Date.now()}.${fileExt}`
      
      await client.storage
        .from('verification')
        .upload(filePath, form.value.idDocument)
      
      // Enregistrer la référence au document
      await client
        .from('expert_verification')
        .insert({
          expert_id: user.id,
          document_type: 'id_card',
          document_path: filePath,
          status: 'pending',
          submitted_at: new Date().toISOString()
        })
    }

    // Rediriger vers le tableau de bord expert avec un message de bienvenue
    router.push('/expert/dashboard?welcome=true')
  } catch (error) {
    console.error('Erreur finalisation profil expert:', error)
    alert('Une erreur est survenue lors de la finalisation de votre profil. Veuillez réessayer.')
  } finally {
    loading.value = false
  }
}

// Configuration de la page
definePageMeta({
  layout: 'auth'
})
</script>

<style scoped>
.slide-fade-enter-active,
.slide-fade-leave-active {
  transition: all 0.3s ease;
}
.slide-fade-enter-from {
  transform: translateX(20px);
  opacity: 0;
}
.slide-fade-leave-to {
  transform: translateX(-20px);
  opacity: 0;
}
</style> 