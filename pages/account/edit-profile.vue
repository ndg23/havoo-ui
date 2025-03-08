<template>
  <div class="max-w-4xl mx-auto px-4 py-8">
    <!-- En-tête de la page -->
    <div class="mb-8">
      <h1 class="text-2xl font-bold text-gray-900 dark:text-white">Modifier mon profil</h1>
      <p class="text-gray-600 dark:text-gray-400 mt-1">Mettez à jour vos informations personnelles et vos préférences</p>
    </div>
    
    <!-- Alerte de statut -->
    <ErrorAlert 
      v-if="statusMessage.show"
      :type="statusMessage.type"
      :message="statusMessage.message"
      dismissible
      @dismiss="statusMessage.show = false"
      class="mb-6"
    />
    
    <!-- Section chargement -->
    <div v-if="isLoading" class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 p-16 animate-pulse shadow-sm">
      <div class="flex flex-col items-center justify-center">
        <div class="h-10 w-10 border-4 border-primary-500 border-t-transparent rounded-full animate-spin"></div>
        <p class="mt-4 text-gray-600 dark:text-gray-400 font-medium">Chargement de vos informations...</p>
      </div>
    </div>
    
    <form v-else @submit.prevent="updateProfile" class="space-y-8">
      <!-- Photo de profil -->
      <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 overflow-hidden shadow-sm">
        <div class="px-6 py-4 border-b border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-700">
          <h2 class="text-lg font-medium text-gray-900 dark:text-white flex items-center">
            <Image class="h-5 w-5 mr-2 text-primary-600 dark:text-primary-400" />
            Photo de profil
          </h2>
        </div>
        
        <div class="p-6">
          <div class="flex flex-col md:flex-row items-center gap-6">
            <div class="relative">
              <img 
                :src="avatarPreview || form.profileImage || '/img/default-avatar.png'" 
                alt="Photo de profil"
                class="w-28 h-28 rounded-full object-cover border-2 border-white dark:border-gray-700 shadow-sm"
              />
              <button 
                type="button"
                @click="$refs.fileInput.click()"
                class="absolute bottom-0 right-0 w-9 h-9 rounded-full bg-primary-600 flex items-center justify-center border-2 border-white dark:border-gray-800 shadow-md hover:bg-primary-700 transition-colors"
              >
                <Camera class="w-5 h-5 text-white" />
              </button>
            </div>
            
            <div>
              <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-2">Photo de profil</h3>
              <p class="text-sm text-gray-600 dark:text-gray-400 mb-3">
                Une photo claire de votre visage aidera les clients à vous reconnaître. <br>
                Formats acceptés: JPG, PNG, GIF (max 2MB)
              </p>
              
              <div class="flex flex-wrap gap-3">
                <button 
                  type="button"
                  @click="$refs.fileInput.click()"
                  class="px-4 py-2 bg-white dark:bg-gray-700 border border-gray-300 dark:border-gray-600 text-gray-700 dark:text-gray-300 text-sm font-medium rounded-full hover:bg-gray-50 dark:hover:bg-gray-600 transition-colors flex items-center"
                >
                  <Upload class="h-4 w-4 mr-1.5" />
                  Télécharger
                </button>
                
                <button 
                  v-if="avatarFile || avatarPreview"
                  type="button"
                  @click="removeAvatar"
                  class="px-4 py-2 bg-white dark:bg-gray-700 border border-gray-300 dark:border-gray-600 text-red-600 dark:text-red-400 text-sm font-medium rounded-full hover:bg-gray-50 dark:hover:bg-gray-600 transition-colors flex items-center"
                >
                  <Trash2 class="h-4 w-4 mr-1.5" />
                  Supprimer
                </button>
              </div>
              
              <input 
                ref="fileInput" 
                type="file" 
                accept="image/*" 
                class="hidden" 
                @change="handleFileUpload" 
              />
            </div>
          </div>
        </div>
      </div>
      
      <!-- Informations personnelles -->
      <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 overflow-hidden shadow-sm">
        <div class="px-6 py-4 border-b border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-700">
          <h2 class="text-lg font-medium text-gray-900 dark:text-white flex items-center">
            <User class="h-5 w-5 mr-2 text-primary-600 dark:text-primary-400" />
            Informations personnelles
          </h2>
        </div>
        
        <div class="p-6">
          <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <!-- Prénom -->
            <div>
              <label for="firstName" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">Prénom</label>
              <input
                v-model="form.firstName"
                type="text"
                id="firstName"
                class="w-full px-4 py-2.5 rounded-full border border-gray-300 dark:border-gray-600 focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
                placeholder="Prénom"
              />
            </div>
            
            <!-- Nom -->
            <div>
              <label for="lastName" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">Nom</label>
              <input
                v-model="form.lastName"
                type="text"
                id="lastName"
                class="w-full px-4 py-2.5 rounded-full border border-gray-300 dark:border-gray-600 focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
                placeholder="Nom"
              />
            </div>
            
            <!-- Email -->
            <div>
              <label for="email" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">Email</label>
              <input
                v-model="form.email"
                type="email"
                id="email"
                disabled
                class="w-full px-4 py-2.5 rounded-full border border-gray-300 dark:border-gray-600 bg-gray-100 dark:bg-gray-600 text-gray-500 dark:text-gray-400 cursor-not-allowed"
                placeholder="email@exemple.com"
              />
              <p class="mt-1 text-xs text-gray-500 dark:text-gray-400">L'email ne peut pas être modifié</p>
            </div>
            
            <!-- Date de naissance -->
            <div>
              <label for="birthdate" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">Date de naissance</label>
              <input
                v-model="form.birthdate"
                type="date"
                id="birthdate"
                class="w-full px-4 py-2.5 rounded-full border border-gray-300 dark:border-gray-600 focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
              />
            </div>
            
            <!-- Genre -->
            <div>
              <label for="gender" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">Genre</label>
              <select
                v-model="form.gender"
                id="gender"
                class="w-full px-4 py-2.5 rounded-full border border-gray-300 dark:border-gray-600 focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white appearance-none bg-no-repeat"
              >
                <option value="male">Homme</option>
                <option value="female">Femme</option>
                <option value="other">Autre</option>
                <option value="prefer_not_to_say">Préfère ne pas préciser</option>
              </select>
            </div>
            
            <!-- Téléphone -->
            <div>
              <label for="phone" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">Téléphone</label>
              <input
                v-model="form.phone"
                type="tel"
                id="phone"
                class="w-full px-4 py-2.5 rounded-full border border-gray-300 dark:border-gray-600 focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
                placeholder="+221 xx xxx xx xx"
              />
            </div>
          </div>
        </div>
      </div>
      
      <!-- Coordonnées -->
      <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 overflow-hidden shadow-sm">
        <div class="px-6 py-4 border-b border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-700">
          <h2 class="text-lg font-medium text-gray-900 dark:text-white flex items-center">
            <MapPin class="h-5 w-5 mr-2 text-primary-600 dark:text-primary-400" />
            Coordonnées
          </h2>
        </div>
        
        <div class="p-6">
          <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <!-- Adresse -->
            <div class="md:col-span-2">
              <label for="address" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">Adresse</label>
              <input
                v-model="form.address"
                type="text"
                id="address"
                class="w-full px-4 py-2.5 rounded-full border border-gray-300 dark:border-gray-600 focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
                placeholder="Adresse"
              />
            </div>
            
            <!-- Ville -->
            <div>
              <label for="city" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">Ville</label>
              <input
                v-model="form.city"
                type="text"
                id="city"
                class="w-full px-4 py-2.5 rounded-full border border-gray-300 dark:border-gray-600 focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
                placeholder="Ville"
              />
            </div>
            
            <!-- Pays -->
            <div>
              <label for="country" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">Pays</label>
              <input
                v-model="form.country"
                type="text"
                id="country"
                class="w-full px-4 py-2.5 rounded-full border border-gray-300 dark:border-gray-600 focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
                placeholder="Pays"
              />
            </div>
            
            <!-- Site web -->
            <div class="md:col-span-2">
              <label for="website" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">Site web</label>
              <input
                v-model="form.website"
                type="url"
                id="website"
                class="w-full px-4 py-2.5 rounded-full border border-gray-300 dark:border-gray-600 focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
                placeholder="https://exemple.com"
              />
            </div>
          </div>
        </div>
      </div>
      
      <!-- Biographie -->
      <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 overflow-hidden shadow-sm">
        <div class="px-6 py-4 border-b border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-700">
          <h2 class="text-lg font-medium text-gray-900 dark:text-white flex items-center">
            <FileText class="h-5 w-5 mr-2 text-primary-600 dark:text-primary-400" />
            Biographie
          </h2>
        </div>
        
        <div class="p-6">
          <label for="bio" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">Parlez-nous de vous</label>
          <textarea
            v-model="form.bio"
            id="bio"
            rows="5"
            class="w-full px-4 py-3 rounded-xl border border-gray-300 dark:border-gray-600 focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
            placeholder="Partagez quelques informations sur vous, votre parcours, vos intérêts..."
          ></textarea>
          <p class="mt-2 text-sm text-gray-500 dark:text-gray-400">
            Votre biographie permettra aux autres utilisateurs de mieux vous connaître
          </p>
        </div>
      </div>
      
      <!-- Informations professionnelles (pour les experts) -->
      <div v-if="isExpert" class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 overflow-hidden shadow-sm">
        <div class="px-6 py-4 border-b border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-700">
          <h2 class="text-lg font-medium text-gray-900 dark:text-white flex items-center">
            <Briefcase class="h-5 w-5 mr-2 text-primary-600 dark:text-primary-400" />
            Informations professionnelles
          </h2>
        </div>
        
        <div class="p-6">
          <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <!-- Tarif horaire -->
            <div>
              <label for="hourlyRate" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">
                Tarif horaire (€/h)
              </label>
              <div class="relative">
                <input
                  v-model="form.hourlyRate"
                  type="number"
                  min="0"
                  step="0.01"
                  id="hourlyRate"
                  class="w-full px-4 py-2.5 border border-gray-300 dark:border-gray-600 rounded-full shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
                />
                <div class="absolute inset-y-0 right-4 flex items-center pointer-events-none">
                  <span class="text-gray-500 dark:text-gray-400">€</span>
                </div>
              </div>
              <p class="mt-1 text-xs text-gray-500 dark:text-gray-400">
                Votre tarif horaire indicatif pour les clients.
              </p>
            </div>
            
            <!-- Statut de disponibilité -->
            <div>
              <label for="availabilityStatus" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">
                Statut de disponibilité
              </label>
              <select
                v-model="form.availabilityStatus"
                id="availabilityStatus"
                class="w-full px-4 py-2.5 border border-gray-300 dark:border-gray-600 rounded-full shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white appearance-none bg-no-repeat"
              >
                <option value="available">Disponible maintenant</option>
                <option value="limited">Disponibilité limitée</option>
                <option value="busy">Occupé(e)</option>
                <option value="unavailable">Non disponible</option>
              </select>
              <p class="mt-1 text-xs text-gray-500 dark:text-gray-400">
                Indiquez votre disponibilité actuelle aux clients potentiels.
              </p>
            </div>
          </div>
          
          <!-- Compétences -->
          <div class="mt-6">
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">
              Compétences
            </label>
            
            <div class="flex flex-wrap gap-2 mb-3">
              <div 
                v-for="(skill, index) in form.skills" 
                :key="index"
                class="bg-primary-100 dark:bg-primary-900/30 text-primary-800 dark:text-primary-300 px-3 py-1.5 rounded-full text-sm font-medium flex items-center"
              >
                {{ skill }}
                <button 
                  @click="removeSkill(index)" 
                  type="button"
                  class="ml-1.5 text-primary-600 dark:text-primary-400 hover:text-primary-800 dark:hover:text-primary-200"
                >
                  <X class="h-3.5 w-3.5" />
                </button>
              </div>
            </div>
            
            <div class="flex">
              <input
                v-model="newSkill"
                type="text"
                placeholder="Ajouter une compétence..."
                class="flex-grow px-4 py-2.5 border border-gray-300 dark:border-gray-600 rounded-l-full shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
                @keyup.enter="addSkill"
              />
              <button 
                @click="addSkill"
                type="button"
                class="px-4 py-2.5 bg-primary-600 hover:bg-primary-700 text-white rounded-r-full transition-colors"
              >
                <Plus class="h-5 w-5" />
              </button>
            </div>
            
            <p class="mt-1 text-xs text-gray-500 dark:text-gray-400">
              Ajoutez vos compétences professionnelles pour vous démarquer (ex: Développement Web, Design UX, etc.)
            </p>
          </div>
        </div>
      </div>
      
      <!-- Section de disponibilité détaillée -->
      <div v-if="isExpert" class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 overflow-hidden shadow-sm">
        <div class="px-6 py-4 border-b border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-700">
          <h2 class="text-lg font-medium text-gray-900 dark:text-white flex items-center">
            <Calendar class="h-5 w-5 mr-2 text-primary-600 dark:text-primary-400" />
            Planning et disponibilité
          </h2>
        </div>
        
        <div class="p-6">
          <div class="grid grid-cols-1 md:grid-cols-7 gap-2">
            <div v-for="(day, index) in days" :key="day" class="border border-gray-200 dark:border-gray-700 rounded-lg overflow-hidden">
              <div class="bg-gray-50 dark:bg-gray-700 px-3 py-2 border-b border-gray-200 dark:border-gray-700 text-center">
                <span class="text-sm font-medium text-gray-700 dark:text-gray-300">{{ day }}</span>
              </div>
              
              <div class="p-3">
                <label :for="`available-${index}`" class="relative inline-flex items-center cursor-pointer mb-3">
                  <input 
                    v-model="form.availableDays[index]" 
                    type="checkbox" 
                    :id="`available-${index}`" 
                    class="sr-only peer"
                  >
                  <div class="switch-toggle"></div>
                  <span class="ml-2 text-sm font-medium text-gray-700 dark:text-gray-300">
                    {{ form.availableDays[index] ? 'Disponible' : 'Indisponible' }}
                  </span>
                </label>
                
                <div v-if="form.availableDays[index]" class="space-y-2">
                  <div>
                    <label :for="`start-${index}`" class="block text-xs text-gray-700 dark:text-gray-300 mb-1">Début</label>
                    <select 
                      v-model="form.availableHours[index].start" 
                      :id="`start-${index}`"
                      class="w-full px-2 py-1.5 text-sm border border-gray-300 dark:border-gray-600 rounded-md shadow-sm dark:bg-gray-700 dark:text-white"
                    >
                      <option v-for="hour in hours" :key="`start-${hour}`" :value="hour">{{ hour }}</option>
                    </select>
                  </div>
                  
                  <div>
                    <label :for="`end-${index}`" class="block text-xs text-gray-700 dark:text-gray-300 mb-1">Fin</label>
                    <select 
                      v-model="form.availableHours[index].end" 
                      :id="`end-${index}`"
                      class="w-full px-2 py-1.5 text-sm border border-gray-300 dark:border-gray-600 rounded-md shadow-sm dark:bg-gray-700 dark:text-white"
                    >
                      <option v-for="hour in hours" :key="`end-${hour}`" :value="hour">{{ hour }}</option>
                    </select>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Préférences -->
      <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 overflow-hidden shadow-sm">
        <div class="px-6 py-4 border-b border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-700">
          <h2 class="text-lg font-medium text-gray-900 dark:text-white flex items-center">
            <Bell class="h-5 w-5 mr-2 text-primary-600 dark:text-primary-400" />
            Préférences de notification
          </h2>
        </div>
        
        <div class="p-6">
          <div class="space-y-4">
            <div class="flex items-center justify-between">
              <div>
                <h3 class="text-gray-900 dark:text-white font-medium">Notifications par email</h3>
                <p class="text-sm text-gray-600 dark:text-gray-400">Recevez des mises à jour par email</p>
              </div>
              <label class="switch">
                <input type="checkbox" v-model="form.emailNotifications">
                <span class="slider round"></span>
              </label>
            </div>
            
            <div class="flex items-center justify-between">
              <div>
                <h3 class="text-gray-900 dark:text-white font-medium">Notifications push</h3>
                <p class="text-sm text-gray-600 dark:text-gray-400">Recevez des notifications sur votre appareil</p>
              </div>
              <label class="switch">
                <input type="checkbox" v-model="form.pushNotifications">
                <span class="slider round"></span>
              </label>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Boutons d'action -->
      <div class="flex flex-wrap items-center justify-end gap-3 mt-8">
        <NuxtLink 
          to="/account" 
          class="px-6 py-2.5 border border-gray-300 dark:border-gray-600 rounded-full text-gray-700 dark:text-gray-300 font-medium hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors"
        >
          Annuler
        </NuxtLink>
        
        <button 
          type="button" 
          @click="resetForm"
          class="px-6 py-2.5 border border-gray-300 dark:border-gray-600 rounded-full text-gray-700 dark:text-gray-300 font-medium hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors"
        >
          Réinitialiser
        </button>
        
        <button 
          type="submit"
          class="px-6 py-2.5 bg-primary-600 hover:bg-primary-700 rounded-full text-white font-medium transition-colors flex items-center"
          :disabled="isSaving"
        >
          <span v-if="isSaving" class="mr-2 h-4 w-4 border-2 border-white border-t-transparent rounded-full animate-spin"></span>
          {{ isSaving ? 'Enregistrement...' : 'Enregistrer les modifications' }}
        </button>
      </div>
    </form>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted, computed } from 'vue'
import { useRouter } from 'vue-router'
import { useSupabaseClient, useSupabaseUser } from '#imports'
import { 
  User, 
  MapPin, 
  Camera, 
  FileText, 
  Bell, 
  Image, 
  Upload, 
  Trash2, 
  Briefcase, 
  X, 
  Plus 
} from 'lucide-vue-next'

// État
const user = useSupabaseUser()
const router = useRouter()
const supabase = useSupabaseClient()

const isLoading = ref(true)
const isSaving = ref(false)
const fileInput = ref(null)
const avatarFile = ref(null)
const avatarPreview = ref(null)
const initialForm = ref({})
const statusMessage = ref({
  show: false,
  type: 'info',
  message: ''
})

// Nouvelles variables à ajouter au script
const isExpert = ref(false)
const newSkill = ref('')
const days = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim']
const hours = [
  '08:00', '08:30', '09:00', '09:30', '10:00', '10:30', '11:00', '11:30',
  '12:00', '12:30', '13:00', '13:30', '14:00', '14:30', '15:00', '15:30',
  '16:00', '16:30', '17:00', '17:30', '18:00', '18:30', '19:00', '19:30', '20:00'
]

// Données du formulaire
const form = ref({
  firstName: '',
  lastName: '',
  email: '',
  phone: '',
  birthdate: '',
  gender: 'male',
  address: '',
  city: '',
  country: '',
  bio: '',
  profileImage: '',
  emailNotifications: true,
  pushNotifications: true,
  website: '',
  hourlyRate: '',
  availabilityStatus: 'available',
  skills: [],
  availableDays: [true, true, true, true, true, false, false],
  availableHours: [
    { start: '09:00', end: '18:00' },
    { start: '09:00', end: '18:00' },
    { start: '09:00', end: '18:00' },
    { start: '09:00', end: '18:00' },
    { start: '09:00', end: '18:00' },
    { start: '10:00', end: '15:00' },
    { start: '10:00', end: '15:00' }
  ]
})

// Vérifier si l'utilisateur est connecté
const checkUser = computed(() => {
  if (!user.value) {
    router.push('/auth/login')
    return false
  }
  return true
})

// Récupérer les données du profil
const fetchProfile = async () => {
  if (!checkUser.value) return
  
  try {
    const { data, error } = await supabase
      .from('profiles')
      .select('*')
      .eq('id', user.value.id)
      .single()
    
    if (error) throw error
    
    form.value = {
      firstName: data.first_name || '',
      lastName: data.last_name || '',
      email: user.value.email || '',
      phone: data.phone || '',
      birthdate: data.birthdate || '',
      gender: data.gender || 'male',
      address: data.address || '',
      city: data.city || '',
      country: data.country || '',
      bio: data.bio || '',
      profileImage: data.avatar_url || '',
      emailNotifications: data.email_notifications ?? true,
      pushNotifications: data.push_notifications ?? true,
      website: data.website || '',
      hourlyRate: data.hourly_rate || '',
      availabilityStatus: data.availability_status || 'available',
      skills: data.skills || [],
      availableDays: data.available_days || [true, true, true, true, true, false, false],
      availableHours: data.available_hours || [
        { start: '09:00', end: '18:00' },
        { start: '09:00', end: '18:00' },
        { start: '09:00', end: '18:00' },
        { start: '09:00', end: '18:00' },
        { start: '09:00', end: '18:00' },
        { start: '10:00', end: '15:00' },
        { start: '10:00', end: '15:00' }
      ]
    }
    
    // Sauvegarder les valeurs initiales pour la réinitialisation
    initialForm.value = { ...form.value }
    
    // Après avoir récupéré les données du profil
    isExpert.value = data.is_expert || data.role === 'expert'
    
  } catch (error) {
    console.error('Erreur lors du chargement du profil:', error)
    showStatusMessage('error', 'Erreur lors du chargement de votre profil')
  } finally {
    isLoading.value = false
  }
}

// Gestion du fichier avatar
const handleFileUpload = (event) => {
  const file = event.target.files[0]
  if (!file) return
  
  // Valider le type de fichier
  const allowedTypes = ['image/jpeg', 'image/png', 'image/gif']
  if (!allowedTypes.includes(file.type)) {
    showStatusMessage('error', 'Type de fichier non pris en charge. Utilisez JPG, PNG ou GIF')
    return
  }
  
  // Valider la taille du fichier (max 2MB)
  if (file.size > 2 * 1024 * 1024) {
    showStatusMessage('error', 'La taille du fichier ne doit pas dépasser 2MB')
    return
  }
  
  avatarFile.value = file
  
  // Créer un aperçu de l'image
  const reader = new FileReader()
  reader.onload = (e) => {
    avatarPreview.value = e.target.result
  }
  reader.readAsDataURL(file)
  
  // Réinitialiser l'input file pour permettre de réuploader le même fichier
  if (fileInput.value) {
    fileInput.value.value = ''
  }
}

// Supprimer l'avatar
const removeAvatar = () => {
  avatarFile.value = null
  avatarPreview.value = null
  form.value.profileImage = ''
  
  if (fileInput.value) {
    fileInput.value.value = ''
  }
}

// Télécharger l'avatar si un nouveau fichier est sélectionné
const uploadAvatar = async () => {
  if (!avatarFile.value) return form.value.profileImage
  
  try {
    // Créer un nom de fichier unique
    const fileExt = avatarFile.value.name.split('.').pop()
    const fileName = `${user.value.id}-${Date.now()}.${fileExt}`
    const filePath = `avatars/${fileName}`
    
    // Télécharger le fichier
    const { error: uploadError } = await supabase
      .storage
      .from('avatars')
      .upload(filePath, avatarFile.value)
    
    if (uploadError) throw uploadError
    
    // Obtenir l'URL publique
    const { data } = supabase
      .storage
      .from('avatars')
      .getPublicUrl(filePath)
    
    return data.publicUrl
  } catch (error) {
    console.error('Erreur lors du téléchargement de l\'avatar:', error)
    showStatusMessage('error', 'Erreur lors du téléchargement de l\'avatar')
    return form.value.profileImage
  }
}

// Mettre à jour le profil
const updateProfile = async () => {
  isSaving.value = true
  
  try {
    // Validation des champs requis
    if (!form.value.firstName || !form.value.lastName) {
      showStatusMessage('error', 'Le prénom et le nom sont requis')
      isSaving.value = false
      return
    }
    
    // Télécharger l'avatar si nécessaire
    const avatarUrl = await uploadAvatar()
    
    // Préparer les données
    const updates = {
      first_name: form.value.firstName,
      last_name: form.value.lastName,
      phone: form.value.phone,
      birthdate: form.value.birthdate,
      gender: form.value.gender,
      address: form.value.address,
      city: form.value.city,
      country: form.value.country,
      bio: form.value.bio,
      avatar_url: avatarUrl,
      email_notifications: form.value.emailNotifications,
      push_notifications: form.value.pushNotifications,
      website: form.value.website,
      hourly_rate: form.value.hourlyRate,
      availability_status: form.value.availabilityStatus,
      skills: form.value.skills,
      available_days: form.value.availableDays,
      available_hours: form.value.availableHours,
      updated_at: new Date().toISOString()
    }
    
    // Mettre à jour le profil
    const { error } = await supabase
      .from('profiles')
      .update(updates)
      .eq('id', user.value.id)
    
    if (error) throw error
    
    // Mettre à jour les valeurs initiales
    initialForm.value = { ...form.value }
    
    // Réinitialiser l'état du téléchargement
    avatarFile.value = null
    avatarPreview.value = null
    
    showStatusMessage('success', 'Profil mis à jour avec succès')
    
    // Rediriger vers la page de profil
    setTimeout(() => {
      router.push('/account')
    }, 1000)
    
  } catch (error) {
    console.error('Erreur lors de la mise à jour du profil:', error)
    showStatusMessage('error', 'Erreur lors de la mise à jour de votre profil')
  } finally {
    isSaving.value = false
  }
}

const resetForm = () => {
  // Réinitialiser le formulaire avec les valeurs initiales
  form.value = { ...initialForm.value }
  
  // Réinitialiser l'avatar
  avatarFile.value = null
  avatarPreview.value = null
  if (fileInput.value) {
    fileInput.value.value = ''
  }
}

const showStatusMessage = (type, message, duration = 5000) => {
  statusMessage.value = {
    show: true,
    type,
    message
  }
  
  setTimeout(() => {
    statusMessage.value.show = false
  }, duration)
}

// Nouvelles méthodes pour gérer les compétences
const addSkill = () => {
  if (!newSkill.value.trim()) return
  
  // Vérifier si la compétence existe déjà
  if (!form.value.skills.includes(newSkill.value.trim())) {
    form.value.skills.push(newSkill.value.trim())
  }
  
  newSkill.value = ''
}

const removeSkill = (index) => {
  form.value.skills.splice(index, 1)
}

// Initialisation
onMounted(() => {
  fetchProfile()
})

// Vous pouvez ajouter ce bloc en haut de chaque fichier
definePageMeta({
  layout: 'account'
})
</script>

<style scoped>
.switch {
  position: relative;
  display: inline-block;
  width: 44px;
  height: 24px;
}

.switch input {
  opacity: 0;
  width: 0;
  height: 0;
}

.slider {
  position: absolute;
  cursor: pointer;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: #ccc;
  transition: .3s;
  border-radius: 34px;
}

.slider:before {
  position: absolute;
  content: "";
  height: 18px;
  width: 18px;
  left: 3px;
  bottom: 3px;
  background-color: white;
  transition: .3s;
  border-radius: 50%;
}

input:checked + .slider {
  background-color: #4f46e5;
}

input:focus + .slider {
  box-shadow: 0 0 1px #4f46e5;
}

input:checked + .slider:before {
  transform: translateX(20px);
}

/* Dark mode styles */
.dark input:checked + .slider {
  background-color: #6366f1;
}

.dark input:focus + .slider {
  box-shadow: 0 0 1px #6366f1;
}

/* Ajoutez ces styles pour les interrupteurs de disponibilité */
.switch-toggle {
  width: 36px;
  height: 20px;
  background-color: #ccc;
  border-radius: 34px;
  position: relative;
  transition: .3s;
}

.switch-toggle:before {
  content: "";
  position: absolute;
  height: 16px;
  width: 16px;
  left: 2px;
  bottom: 2px;
  background-color: white;
  border-radius: 50%;
  transition: .3s;
}

input:checked + .switch-toggle {
  background-color: #4f46e5;
}

input:checked + .switch-toggle:before {
  transform: translateX(16px);
}

.dark input:checked + .switch-toggle {
  background-color: #6366f1;
}
</style> 