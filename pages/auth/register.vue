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
        <!-- Alerte d'erreur -->
        <transition name="fade">
          <div v-if="error" class="mb-6 p-4 bg-red-50 border-l-4 border-red-500 rounded-md">
            <div class="flex">
              <div class="flex-shrink-0">
                <AlertCircle class="h-5 w-5 text-red-500" />
              </div>
              <div class="ml-3">
                <p class="text-sm text-red-700">
                  {{ error }}
                </p>
              </div>
              <div class="ml-auto pl-3">
                <div class="-mx-1.5 -my-1.5">
                  <button 
                    @click="error = null" 
                    class="inline-flex bg-red-50 rounded-md p-1.5 text-red-500 hover:bg-red-100 focus:outline-none"
                  >
                    <span class="sr-only">Fermer</span>
                    <XCircle class="h-5 w-5" />
                  </button>
                </div>
              </div>
            </div>
          </div>
        </transition>

        <!-- Étape -->
        <div class="mb-8 flex justify-end">
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
            <!-- Étape 1: Choix du type de profil -->
            <div v-if="currentStep === 1" class="space-y-8">
              <h1 class="text-3xl font-semibold text-gray-900">
                Bienvenue ! Comment souhaitez-vous utiliser notre plateforme ?
              </h1>
              
              <div class="grid grid-cols-1 gap-4">
                <button 
                  @click="selectProfileType('client')"
                  class="p-6 border-2 rounded-xl text-left transition-all"
                  :class="form.profileType === 'client' 
                    ? 'border-primary-500 bg-primary-50' 
                    : 'border-gray-200 hover:border-gray-300'"
                >
                  <div class="flex items-start">
                    <div class="bg-primary-100 rounded-full p-3 mr-4">
                      <User class="h-6 w-6 text-primary-600" />
                    </div>
                    <div>
                      <h3 class="font-medium text-xl mb-1">Je cherche un service</h3>
                      <p class="text-gray-500">Créez un compte client pour trouver des experts qualifiés pour vos besoins.</p>
                    </div>
                  </div>
                </button>
                
                <button 
                  @click="selectProfileType('expert')"
                  class="p-6 border-2 rounded-xl text-left transition-all"
                  :class="form.profileType === 'expert' 
                    ? 'border-primary-500 bg-primary-50' 
                    : 'border-gray-200 hover:border-gray-300'"
                >
                  <div class="flex items-start">
                    <div class="bg-primary-100 rounded-full p-3 mr-4">
                      <Briefcase class="h-6 w-6 text-primary-600" />
                    </div>
                    <div>
                      <h3 class="font-medium text-xl mb-1">Je propose mes services</h3>
                      <p class="text-gray-500">Créez un profil expert pour proposer vos compétences et trouver des clients.</p>
                    </div>
                  </div>
                </button>
              </div>
            </div>
            
            <!-- Étape 2: Identité -->
            <div v-if="currentStep === 2" class="space-y-8">
              <h1 class="text-3xl font-semibold text-gray-900">
                Qui êtes-vous ?
              </h1>
              
              <div class="space-y-4">
                <div>
                  <label for="firstName" class="block text-sm font-medium text-gray-700 mb-1">
                    Prénom <span class="text-red-500">*</span>
                  </label>
                  <input
                    id="firstName"
                    v-model="form.firstName"
                    type="text"
                    placeholder="Votre prénom"
                    class="w-full p-4 border-2 border-gray-200 rounded-xl focus:border-primary-500 focus:outline-none transition-colors"
                    autofocus
                  />
                </div>
                
                <div>
                  <label for="lastName" class="block text-sm font-medium text-gray-700 mb-1">
                    Nom <span class="text-red-500">*</span>
                  </label>
                  <input
                    id="lastName"
                    v-model="form.lastName"
                    type="text"
                    placeholder="Votre nom"
                    class="w-full p-4 border-2 border-gray-200 rounded-xl focus:border-primary-500 focus:outline-none transition-colors"
                  />
                </div>
              </div>
            </div>

            <!-- Étape 3: Email et mot de passe -->
            <div v-if="currentStep === 3" class="space-y-8">
              <h1 class="text-3xl font-semibold text-gray-900">
                Créez vos identifiants
              </h1>
              
              <div class="space-y-4">
                <div>
                  <label for="email" class="block text-sm font-medium text-gray-700 mb-1">
                    Email <span class="text-red-500">*</span>
                  </label>
                  <input
                    id="email"
                    v-model="form.email"
                    type="email"
                    placeholder="votre.email@exemple.com"
                    class="w-full p-4 border-2 border-gray-200 rounded-xl focus:border-primary-500 focus:outline-none transition-colors"
                  />
                </div>
                
                <div>
                  <label for="password" class="block text-sm font-medium text-gray-700 mb-1">
                    Mot de passe <span class="text-red-500">*</span>
                  </label>
                  <div class="relative">
                    <input
                      id="password"
                      v-model="form.password"
                      :type="showPassword ? 'text' : 'password'"
                      placeholder="8 caractères minimum"
                      class="w-full p-4 border-2 border-gray-200 rounded-xl focus:border-primary-500 focus:outline-none transition-colors"
                    />
                    <button 
                      type="button"
                      @click="showPassword = !showPassword"
                      class="absolute right-4 top-1/2 transform -translate-y-1/2 text-gray-500"
                    >
                      <Eye v-if="!showPassword" class="h-5 w-5" />
                      <EyeOff v-else class="h-5 w-5" />
                    </button>
                  </div>
                  <div class="mt-1">
                    <div class="h-1 bg-gray-200 rounded-full overflow-hidden">
                      <div 
                        class="h-full transition-all duration-300"
                        :class="passwordStrengthClass"
                        :style="{ width: `${passwordStrength}%` }"
                      ></div>
                    </div>
                    <p class="mt-1 text-xs text-gray-500">
                      {{ passwordFeedback }}
                    </p>
                  </div>
                </div>
              </div>
            </div>

            <!-- Étape 4: Bio et Niveau d'expérience (experts) -->
            <div v-if="currentStep === 4 && form.profileType === 'expert'" class="space-y-8">
              <h1 class="text-3xl font-semibold text-gray-900">
                Parlez-nous de votre expertise
              </h1>
              
              <div class="space-y-6">
                <div>
                  <label for="bio" class="block text-sm font-medium text-gray-700 mb-1">
                    Brève description professionnelle <span class="text-red-500">*</span>
                  </label>
                  <textarea 
                    id="bio"
                    v-model="form.bio"
                    rows="3"
                    placeholder="Décrivez votre activité et vos compétences en quelques phrases..."
                    class="w-full p-4 border-2 border-gray-200 rounded-xl focus:border-primary-500 focus:outline-none transition-colors"
                  ></textarea>
                </div>
                
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-3">
                    Votre niveau d'expérience <span class="text-red-500">*</span>
                  </label>
                  <div class="grid grid-cols-2 gap-3">
                    <button
                      v-for="option in experienceOptions"
                      :key="option.value"
                      type="button"
                      @click="form.experience = option.value"
                      :class="[
                        'p-4 text-left rounded-xl border-2 transition-all',
                        form.experience === option.value
                          ? 'border-primary-500 bg-primary-50'
                          : 'border-gray-200 hover:border-gray-300'
                      ]"
                    >
                      <span class="font-medium">{{ option.label }}</span>
                    </button>
                  </div>
                </div>
              </div>
            </div>

            <!-- Étape 5: Tarifs (experts) -->
            <div v-if="currentStep === 5 && form.profileType === 'expert'" class="space-y-8">
              <h1 class="text-3xl font-semibold text-gray-900">
                Quel est votre tarif horaire ?
              </h1>
              
              <div class="space-y-6">
                <div>
                  <label for="hourlyRate" class="block text-sm font-medium text-gray-700 mb-1">
                    Tarif horaire (€/h) <span class="text-red-500">*</span>
                  </label>
                  <div class="relative">
                    <input
                      id="hourlyRate"
                      v-model="form.hourlyRate"
                      type="number"
                      min="1"
                      placeholder="50"
                      class="w-full p-4 pl-10 border-2 border-gray-200 rounded-xl focus:border-primary-500 focus:outline-none transition-colors"
                    />
                    <span class="absolute left-3 top-1/2 -translate-y-1/2 text-gray-500 font-medium">€</span>
                  </div>
                  <p class="mt-2 text-sm text-gray-500">
                    <InformationCircle class="inline-block h-4 w-4 mr-1 text-gray-400" />
                    Vous pourrez définir des tarifs différents par service ultérieurement
                  </p>
                </div>
              </div>
            </div>
            
            <!-- Étape 6: Compétences (experts) - avec scroll et recherche -->
            <div v-if="currentStep === 6 && form.profileType === 'expert'" class="space-y-8">
              <h1 class="text-3xl font-semibold text-gray-900">
                Quelles sont vos compétences ?
              </h1>
              
              <div class="space-y-6">
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-3">
                    Sélectionnez vos principales compétences (3 minimum)
                  </label>
                  
                  <!-- Barre de recherche -->
                  <div class="relative mb-3">
                    <input
                      v-model="skillSearch"
                      type="text"
                      placeholder="Rechercher une compétence..."
                      class="w-full p-3 pl-10 border border-gray-300 rounded-lg text-sm"
                    />
                    <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                      <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                      </svg>
                    </div>
                  </div>
                  
                  <!-- Zone scrollable pour les skills -->
                  <div class="max-h-60 overflow-y-auto p-3 border border-gray-200 rounded-lg bg-gray-50">
                    <div class="flex flex-wrap gap-2">
                      <button
                        v-for="skill in filteredSkills"
                        :key="skill.id"
                        type="button"
                        @click="toggleSkill(skill.id)"
                        :class="[
                          'px-3 py-2 text-sm rounded-full transition-all',
                          form.skills.includes(skill.id)
                            ? 'bg-primary-100 text-primary-800 border-2 border-primary-300'
                            : 'bg-white text-gray-700 border border-gray-200 hover:border-gray-300'
                        ]"
                      >
                        {{ skill.name }}
                      </button>
                    </div>
                    
                    <!-- Message si aucun résultat -->
                    <p v-if="filteredSkills.length === 0" class="text-center py-4 text-gray-500">
                      Aucune compétence trouvée. Essayez un autre terme.
                    </p>
                  </div>
                  
                  <!-- Compétences sélectionnées -->
                  <div v-if="form.skills.length > 0" class="mt-3">
                    <p class="text-sm font-medium text-gray-700 mb-2">Sélectionnées ({{ form.skills.length }}):</p>
                    <div class="flex flex-wrap gap-1">
                      <span
                        v-for="skillId in form.skills"
                        :key="skillId"
                        class="px-2 py-1 bg-primary-50 text-primary-800 text-xs rounded-full flex items-center"
                      >
                        {{ getSkillName(skillId) }}
                        <button @click="toggleSkill(skillId)" class="ml-1 text-primary-600 hover:text-primary-800">
                          ×
                        </button>
                      </span>
                    </div>
                  </div>
                  
                  <p v-if="form.skills.length < 3" class="mt-2 text-sm text-amber-600">
                    <AlertTriangle class="inline-block h-4 w-4 mr-1" />
                    Veuillez sélectionner au moins 3 compétences
                  </p>
                </div>
              </div>
            </div>
            
            <!-- Étape 7: Services (experts) - avec scroll et recherche -->
            <div v-if="currentStep === 7 && form.profileType === 'expert'" class="space-y-8">
              <h1 class="text-3xl font-semibold text-gray-900">
                Quels services proposez-vous ?
              </h1>
              
              <div class="space-y-6">
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-3">
                    Sélectionnez les services que vous offrez
                  </label>
                  
                  <!-- Barre de recherche -->
                  <div class="relative mb-3">
                    <input
                      v-model="serviceSearch"
                      type="text"
                      placeholder="Rechercher un service..."
                      class="w-full p-3 pl-10 border border-gray-300 rounded-lg text-sm"
                    />
                    <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                      <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                      </svg>
                    </div>
                  </div>
                  
                  <!-- Zone scrollable pour les services -->
                  <div class="max-h-80 overflow-y-auto rounded-lg border border-gray-200">
                    <div class="space-y-2 p-2">
                      <div 
                        v-for="service in filteredServices"
                        :key="service.id"
                        @click="toggleService(service.id)"
                        class="p-4 border rounded-xl cursor-pointer transition-all"
                        :class="form.services.includes(service.id) 
                          ? 'border-primary-500 bg-primary-50' 
                          : 'border-gray-200 hover:border-gray-300 bg-white'"
                      >
                        <div class="flex items-start">
                          <div class="flex-shrink-0 mt-0.5">
                            <div class="h-5 w-5 border-2 rounded-full flex items-center justify-center"
                              :class="form.services.includes(service.id) ? 'border-primary-500 bg-primary-500' : 'border-gray-300'"
                            >
                              <CheckIcon v-if="form.services.includes(service.id)" class="h-3 w-3 text-white" />
                            </div>
                          </div>
                          <div class="ml-3">
                            <span class="font-medium">{{ service.name }}</span>
                            <p class="text-sm text-gray-500 mt-1">{{ service.description }}</p>
                          </div>
                        </div>
                      </div>
                      
                      <!-- Message si aucun résultat -->
                      <p v-if="filteredServices.length === 0" class="text-center py-4 text-gray-500">
                        Aucun service trouvé. Essayez un autre terme.
                      </p>
                    </div>
                  </div>
                  
                  <p v-if="form.services.length === 0" class="mt-2 text-sm text-amber-600">
                    <AlertTriangle class="inline-block h-4 w-4 mr-1" />
                    Veuillez sélectionner au moins un service
                  </p>
                </div>
              </div>
            </div>

            <!-- Étape 4: Conditions d'utilisation (ou bio pour experts) -->
            <div v-if="currentStep === 4 && form.profileType === 'client'" class="space-y-8">
              <h1 class="text-3xl font-semibold text-gray-900">
                Une dernière étape...
              </h1>
              
              <div class="space-y-6">
                <!-- Case à cocher révisée -->
                <div class="p-4 bg-gray-50 rounded-xl">
                  <label class="flex items-start w-full text-left cursor-pointer">
                    <input
                      type="checkbox"
                      v-model="form.acceptTerms"
                      class="sr-only"
                    />
                    <div class="flex-shrink-0 mt-0.5">
                      <div class="h-5 w-5 border-2 rounded flex items-center justify-center"
                        :class="form.acceptTerms ? 'bg-primary-500 border-primary-500' : 'border-gray-300'"
                      >
                        <CheckIcon v-if="form.acceptTerms" class="h-3 w-3 text-white" />
                      </div>
                    </div>
                    <div class="ml-3">
                      <span class="text-sm text-gray-700">
                        J'accepte les <a href="/terms" class="text-primary-600 hover:underline">conditions d'utilisation</a> et la <a href="/privacy" class="text-primary-600 hover:underline">politique de confidentialité</a>.
                      </span>
                    </div>
                  </label>
                </div>
              </div>
            </div>

            <!-- Étape finale: Conditions et validation -->
            <div v-if="isLastStep" class="space-y-8">
              <h1 class="text-3xl font-semibold text-gray-900">
                Dernière étape
              </h1>
              
              <!-- Résumé du profil expert -->
              <div v-if="form.profileType === 'expert'" class="space-y-4">
                <div class="bg-primary-50 p-4 rounded-xl">
                  <h3 class="font-medium mb-2">Résumé de votre profil expert</h3>
                  <ul class="space-y-1 text-sm">
                    <li><span class="font-medium">Nom:</span> {{ form.firstName }} {{ form.lastName }}</li>
                    <li><span class="font-medium">Expérience:</span> {{ getExperienceLabel(form.experience) }}</li>
                    <li><span class="font-medium">Tarif horaire:</span> {{ form.hourlyRate }}€/h</li>
                    <li><span class="font-medium">Compétences:</span> {{ getSelectedSkillsNames().join(', ') }}</li>
                    <li><span class="font-medium">Services:</span> {{ getSelectedServicesNames().join(', ') }}</li>
                  </ul>
                </div>
              </div>
              
              <!-- Case à cocher des conditions -->
              <div class="space-y-4">
                <div class="p-4 bg-gray-50 rounded-xl">
                  <button 
                    type="button"
                    @click="toggleTerms" 
                    class="flex items-start w-full text-left"
                  >
                    <div class="flex-shrink-0 mt-0.5">
                      <div class="h-5 w-5 border-2 rounded flex items-center justify-center"
                        :class="form.acceptTerms ? 'bg-primary-500 border-primary-500' : 'border-gray-300'"
                      >
                        <CheckIcon v-if="form.acceptTerms" class="h-3 w-3 text-white" />
                      </div>
                    </div>
                    <div class="ml-3">
                      <span class="text-sm text-gray-700">
                        J'accepte les <a href="/terms" class="text-primary-600 hover:underline">conditions d'utilisation</a> et la <a href="/privacy" class="text-primary-600 hover:underline">politique de confidentialité</a>.
                      </span>
                    </div>
                  </button>
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
            :disabled="!canProceed"
            class="w-full py-4 bg-gradient-to-r from-primary-500 to-primary-600 text-white font-semibold rounded-full
              hover:shadow-lg disabled:opacity-50 disabled:cursor-not-allowed
              transition-all shadow-md flex items-center justify-center group"
          >
            <span>Continuer</span>
            <ArrowRight class="h-5 w-5 ml-2 transform group-hover:translate-x-1 transition-transform" />
          </button>
          
          <button
            v-else
            @click="submitRegistration"
            :disabled="loading || !canSubmit"
            class="w-full py-4 bg-gradient-to-r from-primary-500 to-primary-600 text-white font-semibold rounded-full
              hover:shadow-lg disabled:opacity-50 disabled:cursor-not-allowed
              transition-all shadow-md flex items-center justify-center group"
          >
            <Loader2 v-if="loading" class="animate-spin -ml-1 mr-2 h-5 w-5" />
            <span v-else>{{ form.profileType === 'client' ? 'Créer mon compte' : 'Commencer' }}</span>
            <ArrowRight v-if="!loading" class="h-5 w-5 ml-2 transform group-hover:translate-x-1 transition-transform" />
          </button>
          
          <button
            v-if="currentStep > 1"
            @click="currentStep--"
            type="button"
            class="w-full py-3.5 text-gray-600 hover:text-gray-900 transition-colors flex items-center justify-center font-medium group"
          >
            <ArrowLeft class="h-4 w-4 mr-2 transform group-hover:-translate-x-1 transition-transform" />
            <span>Retour</span>
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
  User, Briefcase, Eye, EyeOff, Loader2, CheckIcon,
  AlertTriangle, AlertCircle, XCircle, ArrowRight, ArrowLeft
} from 'lucide-vue-next'

const client = useSupabaseClient()
const router = useRouter()

// États du formulaire
const currentStep = ref(1)
const showPassword = ref(false)
const loading = ref(false)
const error = ref(null)

// Formulaire enrichi
const form = ref({
  profileType: '', // 'client' ou 'expert'
  firstName: '',
  lastName: '',
  email: '',
  password: '',
  bio: '',
  experience: '',
  hourlyRate: '',
  skills: [],
  services: [],
  acceptTerms: false
})

// Données pour les sélections
const availableSkills = ref([])
const availableServices = ref([])

// Options d'expérience
const experienceOptions = [
  { value: 'beginner', label: 'Débutant' },
  { value: 'intermediate', label: 'Intermédiaire' },
  { value: 'advanced', label: 'Confirmé' },
  { value: 'expert', label: 'Expert' }
]

// Calculer le nombre d'étapes en fonction du type de profil
const totalSteps = computed(() => {
  return form.value.profileType === 'expert' ? 8 : 4
})

// Vérifier si on est à la dernière étape
const isLastStep = computed(() => {
  return currentStep.value === totalSteps.value
})

// Vérifier si l'utilisateur peut passer à l'étape suivante
const canProceed = computed(() => {
  switch (currentStep.value) {
    case 1: return !!form.value.profileType
    case 2: return !!form.value.firstName && !!form.value.lastName
    case 3: return !!form.value.email && isValidEmail(form.value.email) && 
                 !!form.value.password && form.value.password.length >= 8
    case 4:
      if (form.value.profileType === 'expert') {
        return !!form.value.bio && form.value.bio.length >= 10 && !!form.value.experience
      }
      return true
    case 5: return !!form.value.hourlyRate && parseFloat(form.value.hourlyRate) > 0
    case 6: return form.value.skills.length >= 3
    case 7: return form.value.services.length > 0
    default: return true
  }
})

// Charger les compétences et services lors de l'initialisation
onMounted(async () => {
  // Récupérer les compétences
  const { data: skills } = await client
    .from('skills')
    .select('*')
    .order('name')
  
  if (skills) {
    availableSkills.value = skills
  }
  
  // Récupérer les services
  const { data: services } = await client
    .from('services')
    .select('*')
    .order('name')
  
  if (services) {
    availableServices.value = services
  }
})

// Obtenir le libellé d'expérience
const getExperienceLabel = (value) => {
  const option = experienceOptions.find(opt => opt.value === value)
  return option ? option.label : value
}

// Obtenir les noms des compétences sélectionnées
const getSelectedSkillsNames = () => {
  return form.value.skills.map(id => {
    const skill = availableSkills.value.find(s => s.id === id)
    return skill ? skill.name : ''
  }).filter(Boolean)
}

// Obtenir les noms des services sélectionnés
const getSelectedServicesNames = () => {
  return form.value.services.map(id => {
    const service = availableServices.value.find(s => s.id === id)
    return service ? service.name : ''
  }).filter(Boolean)
}

// Nouvelle méthode pour basculer l'état des conditions d'utilisation
const toggleTerms = () => {
  form.value.acceptTerms = !form.value.acceptTerms
}

// Méthodes pour gérer les compétences et services
const toggleSkill = (skillId) => {
  const index = form.value.skills.indexOf(skillId)
  if (index === -1) {
    form.value.skills.push(skillId)
  } else {
    form.value.skills.splice(index, 1)
  }
}

const toggleService = (serviceId) => {
  const index = form.value.services.indexOf(serviceId)
  if (index === -1) {
    form.value.services.push(serviceId)
  } else {
    form.value.services.splice(index, 1)
  }
}

// Soumettre l'inscription (mise à jour)
const submitRegistration = async () => {
  if (!form.value.acceptTerms) return
  
  try {
    loading.value = true
    error.value = null
    
    // 1. Créer l'utilisateur dans Supabase Auth (inchangé)
    const { data, error: authError } = await client.auth.signUp({
      email: form.value.email,
      password: form.value.password,
      options: {
        data: {
          role: form.value.profileType,
          first_name: form.value.firstName,
          last_name: form.value.lastName
        }
      }
    })
    
    if (authError) throw authError
    
    // 2. Si inscription réussie, compléter le profil avec les nouvelles informations
    if (data?.user) {
      const userId = data.user.id
      
      // Profil de base (inchangé)
      const profileData = {
        id: userId,
        first_name: form.value.firstName,
        last_name: form.value.lastName,
        email: form.value.email,
        role: form.value.profileType,
        is_expert: form.value.profileType === 'expert',
        created_at: new Date().toISOString(),
        updated_at: new Date().toISOString()
      }
      
      const { error: profileError } = await client
        .from('profiles')
        .insert(profileData)
      
      if (profileError) throw profileError
      
      // Si c'est un expert, créer l'entrée avec les nouvelles informations
      if (form.value.profileType === 'expert') {
        const expertData = {
          id: userId,
          bio: form.value.bio,
          hourly_rate: parseFloat(form.value.hourlyRate || 0),
          experience_level: form.value.experience,
          verification_status: 'pending',
          created_at: new Date().toISOString(),
          updated_at: new Date().toISOString()
        }
        
        const { error: expertError } = await client
          .from('experts')
          .insert(expertData)
        
        if (expertError) throw expertError
        
        // Associer les compétences
        if (form.value.skills.length > 0) {
          const skillsToInsert = form.value.skills.map(skillId => ({
            profile_id: userId,
            skill_id: skillId,
            created_at: new Date().toISOString()
          }))
          
          const { error: skillsError } = await client
            .from('profile_skills')
            .insert(skillsToInsert)
          
          if (skillsError) throw skillsError
        }
        
        // Associer les services
        if (form.value.services.length > 0) {
          const servicesToInsert = form.value.services.map(serviceId => ({
            expert_id: userId,
            service_id: serviceId,
            price_per_hour: parseFloat(form.value.hourlyRate || 0),
            created_at: new Date().toISOString()
          }))
          
          const { error: servicesError } = await client
            .from('expert_services')
            .insert(servicesToInsert)
          
          if (servicesError) throw servicesError
        }
      }
      
      // Stocker le type de profil pour la redirection après vérification
      localStorage.setItem('profileType', form.value.profileType)
      localStorage.setItem('lastSignUpEmail', form.value.email)
      
      // Rediriger vers la page de vérification d'email
      router.push('/auth/verify-email')
    }
  } catch (err) {
    console.error('Erreur d\'inscription:', err)
    error.value = err.message || 'Une erreur est survenue lors de l\'inscription. Veuillez réessayer.'
  } finally {
    loading.value = false
  }
}

// Fonction de validation d'email
const isValidEmail = (email) => {
  const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
  return re.test(email)
}

// Computed pour vérifier si le formulaire peut être soumis
const canSubmit = computed(() => {
  if (form.value.profileType === 'client') {
    return form.value.acceptTerms
  } else {
    // Condition pour les experts
    return form.value.skills.length >= 3 && 
           form.value.services.length > 0 && 
           !!form.value.hourlyRate
  }
})

// Calcul de la force du mot de passe
const passwordStrength = computed(() => {
  const password = form.value.password
  if (!password) return 0
  
  let strength = 0
  
  // Longueur
  if (password.length >= 8) strength += 25
  
  // Caractères spéciaux
  if (/[!@#$%^&*(),.?":{}|<>]/.test(password)) strength += 25
  
  // Majuscules et minuscules
  if (/[a-z]/.test(password) && /[A-Z]/.test(password)) strength += 25
  
  // Chiffres
  if (/[0-9]/.test(password)) strength += 25
  
  return strength
})

// Classe CSS pour la barre de force du mot de passe
const passwordStrengthClass = computed(() => {
  if (passwordStrength.value < 25) return 'bg-red-500'
  if (passwordStrength.value < 50) return 'bg-orange-500'
  if (passwordStrength.value < 75) return 'bg-yellow-500'
  return 'bg-green-500'
})

// Feedback sur la force du mot de passe
const passwordFeedback = computed(() => {
  if (!form.value.password) return 'Entrez un mot de passe'
  if (passwordStrength.value < 25) return 'Très faible'
  if (passwordStrength.value < 50) return 'Faible'
  if (passwordStrength.value < 75) return 'Moyen'
  if (passwordStrength.value < 100) return 'Fort'
  return 'Très fort'
})

// Sélectionner le type de profil
const selectProfileType = (type) => {
  form.value.profileType = type
}

// Passer à l'étape suivante
const nextStep = () => {
  if (currentStep.value < totalSteps.value && canProceed.value) {
    currentStep.value++
  }
}

// Configuration de la page
definePageMeta({
  layout: 'auth'
})

// Variables pour la recherche
const skillSearch = ref('')
const serviceSearch = ref('')

// Compétences filtrées
const filteredSkills = computed(() => {
  if (!skillSearch.value.trim()) return availableSkills.value
  
  const search = skillSearch.value.toLowerCase()
  return availableSkills.value.filter(skill => 
    skill.name.toLowerCase().includes(search)
  )
})

// Services filtrés
const filteredServices = computed(() => {
  if (!serviceSearch.value.trim()) return availableServices.value
  
  const search = serviceSearch.value.toLowerCase()
  return availableServices.value.filter(service => 
    service.name.toLowerCase().includes(search) || 
    (service.description && service.description.toLowerCase().includes(search))
  )
})

// Obtenir le nom d'une compétence par son ID
const getSkillName = (skillId) => {
  const skill = availableSkills.value.find(s => s.id === skillId)
  return skill ? skill.name : ''
}
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

.fade-enter-active, .fade-leave-active {
  transition: opacity 0.3s, transform 0.3s;
}
.fade-enter-from, .fade-leave-to {
  opacity: 0;
  transform: translateY(-10px);
}
</style> 