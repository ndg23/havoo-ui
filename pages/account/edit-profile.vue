<template>
  <div class="max-w-3xl mx-auto px-4 py-8">
    <!-- Header avec informations actuelles -->
   
    
    <!-- En-tête de la page -->
    <div class="mb-8">
      <h1 class="text-2xl font-bold text-gray-900 dark:text-white">Modifier mon profil</h1>
      <p class="text-gray-600 dark:text-gray-400 mt-1">Personnalisez vos informations pour vous présenter</p>
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
    <div v-if="isLoading" class="bg-white dark:bg-gray-800 rounded-xl p-16 shadow-sm">
      <div class="flex flex-col items-center justify-center">
        <div class="h-10 w-10 border-4 border-primary-500 border-t-transparent rounded-full animate-spin"></div>
        <p class="mt-4 text-gray-600 dark:text-gray-400 font-medium">Chargement de vos informations...</p>
      </div>
    </div>
    
    <form v-else @submit.prevent="updateProfile" class="space-y-6">
      <!-- Photo de profil -->
      <div class="bg-white dark:bg-gray-800 rounded-xl shadow-sm overflow-hidden">
        <div class="p-6">
          <div class="flex flex-col md:flex-row items-center gap-6">
            <div class="relative">
              <img
                :src="form.avatar_url||avatarPreview || '/assets/icons/avatar.svg'"
                :alt="`Photo de profil de ${form.first_name}`"
                class="h-32 w-32 rounded-full object-cover border border-gray-300"
              />
              
              <!-- Overlay pour le changement de photo -->
              <div class="absolute inset-0 flex items-center justify-center">
                <input
                  type="file"
                  ref="fileInput"
                  accept="image/*"
                  class="hidden"
                  @change="handleAvatarChange"
                />
                
                <button
                  type="button"
                  @click="$refs.fileInput.click()"
                  class="absolute bottom-0 right-0 bg-white dark:bg-gray-800 border border-gray-300 rounded-full p-1 shadow-lg- hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors"
                >
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-gray-600 dark:text-gray-300" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1" d="M3 9a2 2 0 012-2h.93a2 2 0 001.664-.89l.812-1.22A2 2 0 0110.07 4h3.86a2 2 0 011.664.89l.812 1.22A2 2 0 0018.07 7H19a2 2 0 012 2v9a2 2 0 01-2 2H5a2 2 0 01-2-2V9z" />
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 13a3 3 0 11-6 0 3 3 0 016 0z" />
                  </svg>
                </button>
              </div>

              <!-- Loading overlay -->
              <div v-if="isUploadingAvatar" class="absolute inset-0 bg-black bg-opacity-50 rounded-full flex items-center justify-center">
                <svg class="animate-spin h-6 w-6 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                  <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                  <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                </svg>
              </div>
            </div>
            
            <div>
              <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-2">Photo de profil</h3>
              <p class="text-sm text-gray-600 dark:text-gray-400 mb-3">
                Une photo claire de votre visage aidera les clients à vous reconnaître
              </p>
              
              <div class="flex flex-wrap gap-3">
                <button 
                  type="button"
                  @click="$refs.fileInput.click()"
                  class="px-4 py-2 bg-white dark:bg-gray-700 border border-gray-200 dark:border-gray-700 text-gray-700 dark:text-gray-300 text-sm font-medium rounded-full hover:bg-gray-50 dark:hover:bg-gray-600 transition-colors flex items-center"
                >
                  <Upload class="h-4 w-4 mr-1.5" />
                  Télécharger
                </button>
                
                <button 
                  v-if="avatarFile || avatarPreview"
                  type="button"
                  @click="removeAvatar"
                  class="px-4 py-2 bg-white dark:bg-gray-700 border border-gray-200 dark:border-gray-700 text-red-600 dark:text-red-400 text-sm font-medium rounded-full hover:bg-gray-50 dark:hover:bg-gray-600 transition-colors flex items-center"
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
      
      <!-- Ajouter après la section photo de profil et avant les informations personnelles -->
      <div v-if="isExpert" class="bg-white dark:bg-gray-800 rounded-xl shadow-sm overflow-hidden">
        <div class="p-6">
          <div class="flex items-center justify-between">
            <div>
              <h3 class="text-lg font-medium text-gray-900 dark:text-white">Statut de disponibilité</h3>
              <p class="text-sm text-gray-600 dark:text-gray-400 mt-1">
                Indiquez aux clients si vous êtes actuellement disponible pour des missions
              </p>
            </div>
            
            <div class="flex items-center gap-3">
              <span class="text-sm font-medium" :class="[
                form.availabilityStatus === 'available' 
                  ? 'text-green-600 dark:text-green-400'
                  : 'text-gray-500 dark:text-gray-400'
              ]">
                {{ form.availabilityStatus === 'available' ? 'Disponible' : 'Indisponible' }}
              </span>
              
              <button 
                type="button"
                role="switch"
                :aria-checked="form.availabilityStatus === 'available'"
                @click="toggleAvailabilityStatus"
                class="relative inline-flex h-8 w-14 flex-shrink-0 cursor-pointer rounded-full border-2 border-transparent transition-colors duration-200 ease-in-out focus:outline-none focus:ring-2 focus:ring-primary-600 focus:ring-offset-2"
                :class="[
                  form.availabilityStatus === 'available' 
                    ? 'bg-green-500 dark:bg-green-600' 
                    : 'bg-gray-200 dark:bg-gray-600'
                ]"
              >
                <span 
                  aria-hidden="true"
                  class="pointer-events-none relative inline-block h-7 w-7 transform rounded-full bg-white shadow ring-0 transition duration-200 ease-in-out"
                  :class="[
                    form.availabilityStatus === 'available' 
                      ? 'translate-x-6' 
                      : 'translate-x-0'
                  ]"
                >
                  <span
                    class="absolute inset-0 flex h-full w-full items-center justify-center transition-opacity"
                    :class="[
                      form.availabilityStatus === 'available' 
                        ? 'opacity-0 duration-100 ease-out' 
                        : 'opacity-100 duration-200 ease-in'
                    ]"
                  >
                    <svg class="h-4 w-4 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 12H4" />
                    </svg>
                  </span>
                  <span
                    class="absolute inset-0 flex h-full w-full items-center justify-center transition-opacity"
                    :class="[
                      form.availabilityStatus === 'available' 
                        ? 'opacity-100 duration-200 ease-in' 
                        : 'opacity-0 duration-100 ease-out'
                    ]"
                  >
                    <svg class="h-4 w-4 text-green-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                    </svg>
                  </span>
                </span>
              </button>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Informations personnelles -->
      <div class="bg-white dark:bg-gray-800 rounded-xl shadow-sm overflow-hidden">
        <div class="p-6">
          <div class="flex flex-col md:flex-row items-center gap-6">
            <!-- Photo de profil (inchangée) -->
            
            <!-- Informations de base -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4 w-full">
              <FloatingLabelInput
                v-model="form.first_name"
                label="Prénom"
                required
              />

              <FloatingLabelInput
                v-model="form.last_name"
                label="Nom"
                required
              />

              <FloatingLabelInput
                v-model="form.email"
                label="Email"
                type="email"
                disabled
              />

              <FloatingLabelInput
                v-model="form.phone"
                label="Téléphone"
                type="tel"
              />

              <FloatingLabelInput
                v-model="form.birthdate"
                label="Date de naissance"
                type="date"
                :max="maxBirthdate"
                :min="minBirthdate"
                required
              >
                <template #hint>
                  <span class="text-sm text-gray-500 dark:text-gray-400">
                    Vous devez avoir 18+ ans
                  </span>
                </template>
              </FloatingLabelInput>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Section profession (uniquement pour les experts) -->
      <div v-if="form.role === 'expert'" class="bg-white dark:bg-gray-800 rounded-xl shadow-sm">
        <div class="p-6">
          <div class="flex items-center justify-between mb-8">
            <div>
              <h2 class="text-xl font-bold text-gray-900 dark:text-white">
                Profession principale
              </h2>
              <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                Cette information sera affichée publiquement sur votre profil
              </p>
            </div>
          </div>

          <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
            <FloatingLabelInput
              v-model="form.profession_id"
              label="Profession"
              :isSelect="true"
            >
              <option value="">Sélectionnez une profession</option>
              <option 
                v-for="profession in professions" 
                :key="profession.id" 
                :value="profession.id"
              >
                {{ profession.name }}
              </option>
            </FloatingLabelInput>

            <FloatingLabelInput
              v-model="form.hourly_rate"
              label="Tarif horaire"
              type="number"
              min="0"
            >
              <template #suffix>€/h</template>
            </FloatingLabelInput>
          </div>
        </div>
      </div>
      
      <!-- Coordonnées -->
      <div class="bg-white dark:bg-gray-800 rounded-xl shadow-sm mt-6">
        <div class="p-6">
          <div class="flex items-center justify-between mb-8">
            <div>
              <h2 class="text-xl font-bold text-gray-900 dark:text-white">
                Coordonnées
              </h2>
              <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                Où peut-on vous trouver ?
              </p>
            </div>
          </div>

          <div class="space-y-6">
            <!-- Adresse -->
            <FloatingLabelInput
              v-model="form.location"
              label="Adresse"
              placeholder="Votre adresse complète"
            >
              <template #prefix>
                <MapPinIcon class="w-5 h-5 text-gray-400" />
              </template>
            </FloatingLabelInput>

            <!-- Ville et Pays -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
              <FloatingLabelInput
                v-model="form.city"
                label="Ville"
                placeholder="Votre ville"
              >
                <template #prefix>
                  <BuildingOfficeIcon class="w-5 h-5 text-gray-400" />
                </template>
              </FloatingLabelInput>

              <FloatingLabelInput
                v-model="form.country"
                label="Pays"
                :isSelect="true"
              >
                <template #prefix>
                  <GlobeAltIcon class="w-5 h-5 text-gray-400" />
                </template>
                <template #default>
                  <option value="">Sélectionnez un pays</option>
                  <option value="FR">France</option>
                  <option value="BE">Belgique</option>
                  <option value="CH">Suisse</option>
                  <option value="CA">Canada</option>
                  <option value="other">Autre</option>
                </template>
              </FloatingLabelInput>
            </div>

           
          </div>
        </div>
      </div>
      
      <!-- Biographie -->
      <div class="bg-white dark:bg-gray-800 rounded-xl shadow-sm">
        <div class="p-6">
          <h2 class="text-lg font-medium text-gray-900 dark:text-white mb-4">Biographie</h2>
          
          <TwitterInput
            id="bio"
            v-model="form.bio"
            placeholder="Parlez-nous de vous"
            type="textarea"
            :rows="5"
            :maxLength="280"
            showCount
          />
          <p class="mt-2 text-sm text-gray-500 dark:text-gray-400">
            Votre biographie permettra aux autres utilisateurs de mieux vous connaître
          </p>
        </div>
      </div>
      
      <!-- Section Profession -->
      <div v-if="isExpert" class="bg-white dark:bg-gray-800 rounded-xl shadow-sm">
        <div class="p-6">
          <div class="flex items-center justify-between mb-8">
            <div>
              <h2 class="text-xl font-bold text-gray-900 dark:text-white">
                Profession principale
              </h2>
              <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                Cette information sera affichée publiquement sur votre profil
              </p>
            </div>
            <span 
              v-if="selectedProfession" 
              class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-primary-50 text-primary-700 dark:bg-primary-900/20 dark:text-primary-400"
            >
              <CheckIcon class="w-4 h-4 mr-1" />
              Sélectionnée
            </span>
          </div>

          <!-- Barre de recherche -->
          <div class="relative mb-6">
            <FloatingLabelInput
              v-model="professionSearch"
              label="Rechercher une profession"
              placeholder="Ex: Développeur, Designer, Marketing..."
              class="w-full"
            >
              <template #prefix>
                <MagnifyingGlassIcon class="w-5 h-5 text-gray-400" />
              </template>
              <template v-if="professionSearch" #suffix>
                <button 
                  @click="professionSearch = ''"
                  class="p-1 hover:bg-gray-100 dark:hover:bg-gray-700 rounded-full"
                >
                  <XMarkIcon class="w-4 h-4 text-gray-400" />
                </button>
              </template>
            </FloatingLabelInput>
          </div>

          <!-- Profession sélectionnée -->
          <div v-if="selectedProfession" class="mb-6">
            <div class="flex items-center justify-between p-5 bg-primary-50/50 dark:bg-primary-900/10 rounded-2xl border border-primary-100 dark:border-primary-800">
              <div class="flex items-center space-x-4">
                <div class="flex-shrink-0 w-14 h-14 flex items-center justify-center rounded-xl bg-primary-100 dark:bg-primary-900/30">
                  <BriefcaseIcon class="w-7 h-7 text-primary-600 dark:text-primary-400" />
                </div>
                <div>
                  <h3 class="text-lg font-semibold text-gray-900 dark:text-white">
                    {{ selectedProfession.name }}
                  </h3>
                  <p class="text-sm text-gray-500 dark:text-gray-400">
                    {{ selectedProfession.description || 'Profession principale' }}
                  </p>
                </div>
              </div>
              <button 
                @click="removeProfession"
                class="p-2 hover:bg-white/50 dark:hover:bg-gray-700/50 rounded-full transition-colors"
              >
                <XMarkIcon class="w-5 h-5 text-gray-500 dark:text-gray-400" />
              </button>
            </div>
          </div>

          <!-- Liste des professions -->
          <div v-show="!selectedProfession" class="relative">
            <div class="max-h-[400px] overflow-y-auto custom-scrollbar">
              <div v-if="filteredProfessions.length" class="divide-y divide-gray-100 dark:divide-gray-700">
                <button
                  v-for="profession in filteredProfessions"
                  :key="profession.id"
                  @click="selectProfession(profession)"
                  class="w-full flex items-center space-x-4 p-4 hover:bg-gray-50 dark:hover:bg-gray-700/50 transition-all duration-200 group"
                >
                  <div class="flex-shrink-0 w-14 h-14 flex items-center justify-center rounded-xl bg-gray-100 dark:bg-gray-800 group-hover:bg-gray-200 dark:group-hover:bg-gray-600 transition-colors">
                    <BriefcaseIcon class="w-7 h-7 text-gray-500 dark:text-gray-400" />
                  </div>
                  <div class="flex-1 text-left min-w-0">
                    <h3 class="font-medium text-gray-900 dark:text-white truncate group-hover:text-primary-600 dark:group-hover:text-primary-400 transition-colors">
                      {{ profession.name }}
                    </h3>
                    <p v-if="profession.description" 
                       class="text-sm text-gray-500 dark:text-gray-400 truncate">
                      {{ profession.description }}
                    </p>
                  </div>
                </button>
              </div>
              
              <!-- État vide avec recherche -->
              <div v-else-if="professionSearch" class="py-12">
                <div class="text-center">
                  <div class="w-16 h-16 mx-auto bg-gray-100 dark:bg-gray-800 rounded-full flex items-center justify-center">
                    <MagnifyingGlassIcon class="w-8 h-8 text-gray-400" />
                  </div>
                  <h3 class="mt-4 text-lg font-medium text-gray-900 dark:text-white">
                    Aucun résultat
                  </h3>
                  <p class="mt-2 text-gray-500 dark:text-gray-400">
                    Aucune profession ne correspond à "{{ professionSearch }}"
                  </p>
                </div>
              </div>
              
              <!-- État initial -->
              <div v-else class="py-12">
                <div class="text-center">
                  <div class="w-16 h-16 mx-auto bg-gray-100 dark:bg-gray-800 rounded-full flex items-center justify-center">
                    <BriefcaseIcon class="w-8 h-8 text-gray-400" />
                  </div>
                  <h3 class="mt-4 text-lg font-medium text-gray-900 dark:text-white">
                    Choisissez votre profession
                  </h3>
                  <p class="mt-2 text-gray-500 dark:text-gray-400 max-w-sm mx-auto">
                    Sélectionnez la profession qui correspond le mieux à votre activité professionnelle
                  </p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Section Compétences -->
      <div class="bg-white dark:bg-gray-800 rounded-xl shadow-sm">
        <div class="p-6">
          <h2 class="text-lg font-medium text-gray-900 dark:text-white mb-4">
            Compétences
          </h2>
          
          <!-- Recherche Compétences -->
          <FloatingLabelInput
            v-model="skillSearch"
            label="Rechercher des compétences"
            class="mb-4"
          >
            <template #prefix>
              <MagnifyingGlassIcon class="w-5 h-5 text-gray-400" />
            </template>
          </FloatingLabelInput>

          <!-- Compétences sélectionnées -->
          <div v-if="selectedSkills.length" class="mb-4">
            <div class="flex flex-wrap gap-2">
              <div
                v-for="skill in selectedSkills"
                :key="skill.id"
                class="inline-flex items-center px-3 py-1 rounded-full bg-primary-50 dark:bg-primary-900/20 border border-primary-200 dark:border-primary-800"
              >
                <span class="text-primary-700 dark:text-primary-300">
                  {{ skill.name }}
                </span>
                <button
                  @click="removeSkill(skill)"
                  class="ml-2 text-primary-600 hover:text-primary-800 dark:text-primary-400 dark:hover:text-primary-200"
                >
                  <XMarkIcon class="w-4 h-4" />
                </button>
              </div>
            </div>
          </div>

          <!-- Liste des compétences -->
          <div class="relative">
            <div class="max-h-96 overflow-y-auto">
              <div v-if="filteredSkills.length" class="space-y-2">
                <button
                  v-for="skill in filteredSkills"
                  :key="skill.id"
                  @click="toggleSkill(skill)"
                  class="w-full flex items-center justify-between p-3 rounded-lg hover:bg-gray-50 dark:hover:bg-gray-700/50 transition-colors"
                >
                  <span class="text-gray-900 dark:text-white">{{ skill.name }}</span>
                  <CheckIcon 
                    v-if="isSkillSelected(skill)"
                    class="w-5 h-5 text-primary-600 dark:text-primary-400" 
                  />
                </button>
              </div>
              <div v-else class="text-center py-8">
                <p class="text-gray-500 dark:text-gray-400">
                  Aucune compétence trouvée
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Boutons d'action -->
      <div class="flex justify-end gap-3 mt-8">
        <NuxtLink 
          to="/account" 
          class="px-6 py-2.5 border border-gray-200 dark:border-gray-700 rounded-full text-gray-700 dark:text-gray-300 font-medium hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors"
        >
          Annuler
        </NuxtLink>
        
        <button 
          type="button" 
          @click="resetForm"
          class="px-6 py-2.5 border border-gray-200 dark:border-gray-700 rounded-full text-gray-700 dark:text-gray-300 font-medium hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors"
        >
          Réinitialiser
        </button>
        
        <button 
          type="submit"
          @click="saveProfile"
          class="inline-flex items-center justify-center px-6 py-2.5 bg-primary-600 hover:bg-primary-700 rounded-full text-white font-medium transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
          :disabled="isSaving"
        >
          <svg 
            v-if="isSaving"
            class="animate-spin -ml-1 mr-2 h-4 w-4 text-white" 
            xmlns="http://www.w3.org/2000/svg" 
            fill="none" 
            viewBox="0 0 24 24"
          >
            <circle 
              class="opacity-25" 
              cx="12" 
              cy="12" 
              r="10" 
              stroke="currentColor" 
              stroke-width="4"
            />
            <path 
              class="opacity-75" 
              fill="currentColor" 
              d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
            />
          </svg>
          {{ isSaving ? 'Enregistrement...' : 'Enregistrer les modifications' }}
        </button>
      </div>
    </form>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted, computed, onBeforeUnmount, watch } from 'vue'
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
  Plus,
  ChevronDown,
  Search,
  XCircle,
  Check,
  ShieldCheckIcon,
  CheckCircleIcon,
  ChevronDownIcon
} from 'lucide-vue-next'
import FloatingLabelInput from '~/components/ui/FloatingLabelInput.vue'
import TwitterInput from '~/components/ui/TwitterInput.vue'
import { useSeoMeta } from '@unhead/vue'
import {
  UserIcon,
  EnvelopeIcon,
  PhoneIcon,
  CalendarIcon,
  MapPinIcon,
  BuildingOfficeIcon,
  GlobeAltIcon,
  XMarkIcon,
  MagnifyingGlassIcon,
  BriefcaseIcon
} from '@heroicons/vue/24/outline'

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
  type: 'success',
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

// État pour les compétences
const selectedSkillId = ref('');
const allSkills = ref([]);
const selectedSkills = ref([]);
const skillCategories = ref([]);
const uncategorizedSkills = ref([]);
const showSkillResults = ref(false);

// Ajouter ces refs pour les professions
const selectedProfessionId = ref('');
const selectedProfessions = ref([]);
const allProfessions = ref([]);

// Données du formulaire
const form = ref({
  first_name: '',
  last_name: '',
  email: '',
  phone: '',
  birthdate: '',
  gender: 'male',
  location: '',
  city: '',
  country: '',
  bio: '',
  profileImage: '',
  emailNotifications: true,
  pushNotifications: true,
  website: '',
  hourly_rate: '',
  availability_status: 'available',
  skills: [],
  available_days: [true, true, true, true, true, false, false],
  available_hours: [
    { start: '09:00', end: '18:00' },
    { start: '09:00', end: '18:00' },
    { start: '09:00', end: '18:00' },
    { start: '09:00', end: '18:00' },
    { start: '09:00', end: '18:00' },
    { start: '10:00', end: '15:00' },
    { start: '10:00', end: '15:00' }
  ],
  profession_id: null,
  role: 'client',
  updated_at: null
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
      .select(`
        *,
        profession:professions(*)
      `)      .eq('id', user.value.id)
      .single()
    
    if (error) throw error
    
    form.value = {
      first_name: data.first_name || '',
      last_name: data.last_name || '',
      email: user.value.email || '',
      phone: data.phone || '',
      birthdate: data.birthdate || '',
      gender: data.gender || 'male',
      location: data.location || '',
      city: data.city || '',
      country: data.country || '',
      bio: data.bio || '',
      profileImage: data.avatar_url || '',
      emailNotifications: data.email_notifications ?? true,
      pushNotifications: data.push_notifications ?? true,
      website: data.website || '',
      hourly_rate: data.hourly_rate || '',
      availability_status: data.availability_status || 'available',
      skills: data.skills || [],
      available_days: data.available_days || [true, true, true, true, true, false, false],
      available_hours: data.available_hours || [
        { start: '09:00', end: '18:00' },
        { start: '09:00', end: '18:00' },
        { start: '09:00', end: '18:00' },
        { start: '09:00', end: '18:00' },
        { start: '09:00', end: '18:00' },
        { start: '10:00', end: '15:00' },
        { start: '10:00', end: '15:00' }
      ],
      profession_id: data.profession_id || null,
      role: data.role || 'client',
      updated_at: data.updated_at || null
    }
    
    // Sauvegarder les valeurs initiales pour la réinitialisation
    initialForm.value = { ...form.value }
    
    // Après avoir récupéré les données du profil
    isExpert.value = data.is_expert || data.role === 'expert'
    
    // Définir une date de naissance par défaut si non définie (exactement 18 ans)
    if (!data.birthdate) {
      const defaultDate = new Date()
      defaultDate.setFullYear(defaultDate.getFullYear() - 18)
      form.value.birthdate = defaultDate.toISOString().split('T')[0]
    }
    
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

// Charger toutes les compétences depuis la base de données
const fetchSkills = async () => {
  try {
    // Récupérer les catégories
    const { data: professionsData, error: professionsError } = await supabase
      .from('professions')
      .select('id, name')
      .order('name');
    
    if (professionsError) throw professionsError;
    
    // Récupérer les compétences avec leurs catégories
    const { data: skillsData, error: skillsError } = await supabase
      .from('skills')
      .select('id, name, profession_id')
      .order('name');
    
    if (skillsError) throw skillsError;
    
    // Stocker toutes les compétences
    allSkills.value = skillsData || [];
    
    // Organiser les compétences par catégorie
    skillCategories.value = professionsData.map(category => ({
      ...category,
      skills: skillsData.filter(skill => skill.profession_id === category.id)
    }));
    
    // Compétences sans catégorie
    uncategorizedSkills.value = skillsData.filter(skill => !skill.profession_id);
    
  } catch (err) {
    console.error('Erreur lors du chargement des compétences:', err);
  }
};

// Charger les compétences de l'utilisateur
const fetchUserSkills = async () => {
  try {
    const { data, error } = await supabase
      .from('user_skills')
      .select('skill_id, skills(id, name)')
      .eq('user_id', user.value.id);
    
    if (error) throw error;
    
    selectedSkills.value = data.map(item => item.skills) || [];
  } catch (err) {
    console.error('Erreur lors du chargement des compétences de l\'utilisateur:', err);
  }
};

// Vérifier si une compétence est déjà sélectionnée
const isSkillSelected = (skillId) => {
  return selectedSkills.value.some(skill => skill.id === skillId);
};

// Ajouter la compétence sélectionnée
const addSelectedSkill = () => {
  if (!selectedSkillId.value) return;
  
  const skill = allSkills.value.find(s => s.id === selectedSkillId.value);
  if (skill && !isSkillSelected(skill.id)) {
    selectedSkills.value.push(skill);
    selectedSkillId.value = ''; // Réinitialiser la sélection
  }
};

// Supprimer une compétence
const removeSkill = (skill) => {
  selectedSkills.value = selectedSkills.value.filter(s => s.id !== skill.id);
};

// Sauvegarder les compétences de l'utilisateur
const saveUserSkills = async () => {
  try {
    // Supprimer toutes les compétences existantes
    const { error: deleteError } = await supabase
      .from('user_skills')
      .delete()
      .eq('user_id', user.value.id);
    
    if (deleteError) throw deleteError;
    
    // Ajouter les nouvelles compétences
    if (selectedSkills.value.length > 0) {
      const skillsToInsert = selectedSkills.value.map(skill => ({
        user_id: user.value.id,
        skill_id: skill.id
      }));
      
      const { error: insertError } = await supabase
        .from('user_skills')
        .insert(skillsToInsert);
      
      if (insertError) throw insertError;
    }
  } catch (err) {
    console.error('Erreur lors de la sauvegarde des compétences:', err);
    throw err;
  }
};

// Mettre à jour le profil
const updateProfile = async () => {
  isSaving.value = true
  
  try {
    // Validation des champs requis
    if (!form.value.first_name || !form.value.last_name) {
      showStatusMessage('error', 'Le prénom et le nom sont requis')
      isSaving.value = false
      return
    }
    
    // Vérifier la date de naissance
    if (!validateBirthdate()) {
      showStatusMessage('error', 'Vous devez avoir entre 18 et 100 ans')
      isSaving.value = false
      return
    }
    
    // Télécharger l'avatar si nécessaire
    const avatarUrl = await uploadAvatar()
    
    // Préparer les données
    const updates = {
      first_name: form.value.first_name,
      last_name: form.value.last_name,
      phone: form.value.phone,
      birthdate: form.value.birthdate,
      location: form.value.location,
      city: form.value.city,
      country: form.value.country,
      bio: form.value.bio,
      avatar_url: avatarUrl,
      website: form.value.website,
      availability_status: form.value.availability_status,
      profession_id: form.value.profession_id,
      role: form.value.role,
      updated_at: new Date().toISOString()
    }
    
    // Mettre à jour le profil
    const { error } = await supabase
      .from('profiles')
      .update(updates)
      .eq('id', user.value.id)
    
    if (error) throw error
    
    // Sauvegarder les compétences
    await saveUserSkills()
    
    // Mettre à jour les valeurs initiales
    initialForm.value = { ...form.value }
    
    // Réinitialiser l'état du téléchargement
    avatarFile.value = null
    avatarPreview.value = null
    
    showStatusMessage('success', 'Profil mis à jour avec succès')
    
    // Rediriger vers la page de profil
    // setTimeout(() => {
    //   router.push('/account')
    // }, 1000)
    
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

// Fermer le dropdown des compétences en cliquant ailleurs
const handleClickOutside = (event) => {
  if (showSkillResults.value && !event.target.closest('.skills-dropdown')) {
    showSkillResults.value = false;
  }
};

// Initialisation
onMounted(() => {
  fetchProfile()
  fetchSkills()
  fetchUserSkills()
  document.addEventListener('click', handleClickOutside)
})

// Ajouter à onBeforeUnmount
onBeforeUnmount(() => {
  document.removeEventListener('click', handleClickOutside)
})

// Vous pouvez ajouter ce bloc en haut de chaque fichier
definePageMeta({
  layout: 'account',
  middleware: 'auth'
})

// Compétences populaires (à adapter selon votre domaine)
const popularSkills = computed(() => {
  // Filtrer les compétences déjà sélectionnées
  return [
    { id: 1, name: 'JavaScript' },
    { id: 2, name: 'Design UX/UI' },
    { id: 3, name: 'Marketing Digital' },
    { id: 4, name: 'Rédaction Web' },
    { id: 5, name: 'SEO' },
    { id: 6, name: 'Photographie' },
    { id: 7, name: 'Montage Vidéo' },
    { id: 8, name: 'Traduction' }
  ].filter(skill => {
    // Vérifier si la compétence existe dans allSkills
    const existingSkill = allSkills.value.find(s => s.name === skill.name);
    // Si elle existe, utiliser son ID réel
    if (existingSkill) {
      skill.id = existingSkill.id;
      // Ne pas l'afficher si déjà sélectionnée
      return !isSkillSelected(existingSkill.id);
    }
    return true;
  });
});

// Ajouter une compétence (modifié pour gérer les compétences populaires)
const addSkill = async (skill) => {
  // Si la compétence n'existe pas dans la base de données
  if (!allSkills.value.some(s => s.id === skill.id)) {
    try {
      // Créer la compétence dans la base de données
      const { data, error } = await supabase
        .from('skills')
        .insert({ name: skill.name })
        .select()
        .single();
      
      if (error) throw error;
      
      // Mettre à jour l'ID avec celui de la base de données
      skill = data;
      // Ajouter à la liste des compétences
      allSkills.value.push(skill);
    } catch (err) {
      console.error('Erreur lors de la création de la compétence:', err);
      return;
    }
  }
  
  // Ajouter à la sélection si pas déjà présente
  if (!selectedSkills.value.some(s => s.id === skill.id)) {
    selectedSkills.value.push(skill);
  }
};

// Ajouter cette fonction dans la partie script
const toggleAvailabilityStatus = () => {
  form.value.availability_status = form.value.availability_status === 'available' ? 'unavailable' : 'available';
};

// Professions populaires
const popularProfessions = computed(() => {
  return [
    { id: 1, name: 'Développeur Web' },
    { id: 2, name: 'Designer UX/UI' },
    { id: 3, name: 'Marketing Digital' },
    { id: 4, name: 'Rédacteur Web' },
    { id: 5, name: 'Photographe' },
    { id: 6, name: 'Consultant' }
  ].filter(profession => {
    const existingProfession = allProfessions.value.find(p => p.name === profession.name);
    if (existingProfession) {
      profession.id = existingProfession.id;
      return !isProfessionSelected(existingProfession.id);
    }
    return true;
  });
});

// Professions disponibles (filtrées)
const availableProfessions = computed(() => {
  return allProfessions.value.filter(profession => 
    !selectedProfessions.value.some(selected => selected.id === profession.id)
  );
});

// Vérifier si une profession est déjà sélectionnée
const isProfessionSelected = (professionId) => {
  return selectedProfessions.value.some(profession => profession.id === professionId);
};

// Ajouter une profession sélectionnée
const addSelectedProfession = () => {
  if (!selectedProfessionId.value) return;
  
  const profession = allProfessions.value.find(p => p.id === selectedProfessionId.value);
  if (profession && !isProfessionSelected(profession.id)) {
    selectedProfessions.value.push(profession);
    selectedProfessionId.value = ''; // Réinitialiser la sélection
  }
};

// Ajouter une profession (depuis les suggestions)
const addProfession = (profession) => {
  if (!isProfessionSelected(profession.id)) {
    selectedProfessions.value.push(profession);
  }
};

// Supprimer une profession
const removeProfession = async () => {
  try {
    const { error } = await supabase
      .from('profiles')
      .update({ 
        profession_id: null,
        updated_at: new Date().toISOString()
      })
      .eq('id', user.value.id)

    if (error) throw error
    selectedProfession.value = null
  } catch (error) {
    console.error('Erreur lors de la suppression de la profession:', error)
  }
};

// Charger les professions depuis la base de données
const fetchProfessions = async () => {
  if (form.value.role !== 'expert') return

  const { data } = await supabase
    .from('professions')
    .select('*')
    .eq('is_active', true)
    .order('name')

  professions.value = data || []
}

// Charger les professions de l'utilisateur
const fetchUserProfessions = async () => {
  try {
    const { data, error } = await supabase
      .from('user_professions')
      .select('profession_id, professions(id, name)')
      .eq('user_id', user.value.id);
    
    if (error) throw error;
    
    selectedProfessions.value = data.map(item => item.professions) || [];
  } catch (err) {
    console.error('Erreur lors du chargement des professions de l\'utilisateur:', err);
  }
};

// Sauvegarder les professions de l'utilisateur
const saveUserProfessions = async () => {
  try {
    // Supprimer toutes les professions existantes
    const { error: deleteError } = await supabase
      .from('user_professions')
      .delete()
      .eq('user_id', user.value.id);
    
    if (deleteError) throw deleteError;
    
    // Ajouter les nouvelles professions
    if (selectedProfessions.value.length > 0) {
      const professionsToInsert = selectedProfessions.value.map(profession => ({
        user_id: user.value.id,
        profession_id: profession.id
      }));
      
      const { error: insertError } = await supabase
        .from('user_professions')
        .insert(professionsToInsert);
      
      if (insertError) throw insertError;
    }
  } catch (err) {
    console.error('Erreur lors de la sauvegarde des professions:', err);
    throw err;
  }
};

// SEO Meta Tags
useSeoMeta({
  title: () => 'Modifier mon profil | NomDeVotrePlateforme',
  description: () => 'Modifiez vos informations personnelles, votre profession et vos paramètres de disponibilité sur NomDeVotrePlateforme',
  ogTitle: () => 'Modifier mon profil | NomDeVotrePlateforme',
  ogDescription: () => 'Modifiez vos informations personnelles, votre profession et vos paramètres de disponibilité sur NomDeVotrePlateforme',
  ogImage: () => 'https://keetaf.com/images/og-image.jpg', // Ajoutez votre image OG
  twitterCard: 'summary_large_image',
})

const isUploadingAvatar = ref(false)

const handleImageError = (e) => {
  e.target.src = '/assets/icons/avatar.svg'
}

const handleAvatarChange = async (event) => {
  const file = event.target.files[0]
  if (!file) return

  try {
    isUploadingAvatar.value = true

    // Vérifier le type et la taille du fichier
    if (!file.type.startsWith('image/')) {
      throw new Error('Le fichier doit être une image')
    }

    if (file.size > 5 * 1024 * 1024) { // 5MB max
      throw new Error('L\'image ne doit pas dépasser 5MB')
    }

    // Créer un nom de fichier unique
    const fileExt = file.name.split('.').pop()
    const fileName = `${user.value.id}/${Date.now()}.${fileExt}`

    // Upload du fichier
    const { data, error: uploadError } = await supabase.storage
      .from('avatars')
      .upload(fileName, file, {
        cacheControl: '3600',
        upsert: true
      })

    if (uploadError) {
      console.error('Upload error:', uploadError)
      throw uploadError
    }

    // Obtenir l'URL publique
    const { data: { publicUrl } } = supabase.storage
      .from('avatars')
      .getPublicUrl(fileName)

    // Mettre à jour le profil avec la nouvelle URL
    const { error: updateError } = await supabase
      .from('profiles')
      .update({
        avatar_url: publicUrl,
        updated_at: new Date().toISOString()
      })
      .eq('id', user.value.id)

    if (updateError) throw updateError

    // Mettre à jour le formulaire
    form.value.avatar_url = publicUrl

    showStatusMessage('success', 'Photo de profil mise à jour avec succès')
    
  } catch (error) {
    console.error('Erreur lors de la mise à jour de l\'avatar:', error)
    showStatusMessage('error', 'Erreur lors de la mise à jour de la photo de profil')
  } finally {
    isUploadingAvatar.value = false
    if (fileInput.value) {
      fileInput.value.value = ''
    }
  }
}

const professions = ref([])
const selectedProfession = ref(null)
const skillSearch = ref('')
const professionSearch = ref('')
const page = ref(1)
const perPage = 20

// Charger les données
onMounted(async () => {
  try {
    // Charger les professions
    const { data: professionsData } = await supabase
      .from('professions')
      .select('*')
      .order('name')
    professions.value = professionsData

    // Charger le profil utilisateur
    const { data: profile } = await supabase
      .from('profiles')
      .select(`
        *,
        profession:professions(*)
      `)
      .eq('id', supabase.auth.user().id)
      .single()

    if (profile) {
      selectedProfession.value = profile.profession
      selectedSkills.value = profile.skills
    }
  } catch (error) {
    console.error('Erreur lors du chargement des données:', error)
  }
})

// Pagination et recherche optimisée
const filteredProfessions = computed(() => {
  const search = professionSearch.value.toLowerCase()
  return professions.value
    .filter(p => p.name.toLowerCase().includes(search))
    .slice(0, page.value * perPage)
})

const filteredSkills = computed(() => {
  const search = skillSearch.value.toLowerCase()
  return allSkills.value
    .filter(s => {
      const matchesSearch = s.name.toLowerCase().includes(search)
      const matchesProfession = !selectedProfession.value || s.profession_id === selectedProfession.value.id
      return matchesSearch && matchesProfession
    })
    .slice(0, page.value * perPage)
})

// Intersection Observer pour le scroll infini
onMounted(() => {
  const observer = new IntersectionObserver((entries) => {
    if (entries[0].isIntersecting) {
      page.value++
    }
  })

  const target = document.querySelector('.custom-scrollbar')
  if (target) observer.observe(target)
})

// Gestion des professions
const selectProfession = async (profession) => {
  try {
    const { error } = await supabase
      .from('profiles')
      .update({ profession_id: profession.id })
      .eq('id', user.value.id)

    if (error) throw error
    selectedProfession.value = profession
  } catch (error) {
    console.error('Erreur lors de la mise à jour de la profession:', error)
  }
}

// Gérer les compétences
const toggleSkill = async (skill) => {
  const isSelected = isSkillSelected(skill)
  
  try {
    if (isSelected) {
      await supabase
        .from('user_skills')
        .delete()
        .eq('user_id', supabase.auth.user().id)
        .eq('skill_id', skill.id)
      selectedSkills.value = selectedSkills.value.filter(s => s.id !== skill.id)
    } else {
      await supabase
        .from('user_skills')
        .insert({
          user_id: supabase.auth.user().id,
          skill_id: skill.id
        })
      selectedSkills.value.push(skill)
    }
  } catch (error) {
    console.error('Erreur lors de la mise à jour des compétences:', error)
  }
}

// Computed pour vérifier si le profil est vérifié
const isVerified = computed(() => {
  return form.value.email && form.value.first_name && form.value.last_name
})

// Fonction pour formater la date
const formatDate = (date) => {
  if (!date) return ''
  return new Date(date).toLocaleDateString('fr-FR', {
    day: 'numeric',
    month: 'short',
    year: 'numeric'
  })
}

// Computed pour les dates limites
const maxBirthdate = computed(() => {
  const date = new Date()
  date.setFullYear(date.getFullYear() - 18)
  return date.toISOString().split('T')[0]
})

const minBirthdate = computed(() => {
  const date = new Date()
  date.setFullYear(date.getFullYear() - 100)
  return date.toISOString().split('T')[0]
})

// Validation de la date avant sauvegarde
const validateBirthdate = () => {
  if (!form.value.birthdate) return false
  
  const birthDate = new Date(form.value.birthdate)
  const minDate = new Date(minBirthdate.value)
  const maxDate = new Date(maxBirthdate.value)
  
  return birthDate >= minDate && birthDate <= maxDate
}

// Réinitialiser le message après 5 secondes
watch(() => statusMessage.value.show, (newValue) => {
  if (newValue) {
    setTimeout(() => {
      statusMessage.value.show = false
    }, 5000)
  }
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

/* Ajouter ces styles pour l'animation du point */
.animate-ping {
  animation: ping 1.5s cubic-bezier(0, 0, 0.2, 1) infinite;
}

@keyframes ping {
  75%, 100% {
    transform: translate(-50%, -50%) scale(2);
    opacity: 0;
  }
}

/* Ajouter ces styles pour une animation plus fluide */
.transform {
  transition-property: transform;
}

button[role="switch"] {
  touch-action: pan-y pinch-zoom;
}

button[role="switch"] span {
  will-change: transform;
}

/* Animation pour le switch */
@keyframes switchOn {
  0% { transform: translateX(0); }
  50% { transform: translateX(8px) scale(1.2); }
  100% { transform: translateX(24px); }
}

@keyframes switchOff {
  0% { transform: translateX(24px); }
  50% { transform: translateX(16px) scale(1.2); }
  100% { transform: translateX(0); }
}

/* Appliquer les animations */
.translate-x-6 {
  animation: switchOn 0.2s ease-out forwards;
}

.translate-x-0 {
  animation: switchOff 0.2s ease-out forwards;
}

.animate-spin {
  animation: spin 1s linear infinite;
}

@keyframes spin {
  from {
    transform: rotate(0deg);
  }
  to {
    transform: rotate(360deg);
  }
}

.custom-scrollbar {
  scrollbar-width: thin;
  scrollbar-color: rgba(156, 163, 175, 0.3) transparent;
}

.custom-scrollbar::-webkit-scrollbar {
  width: 4px;
}

.custom-scrollbar::-webkit-scrollbar-track {
  background: transparent;
}

.custom-scrollbar::-webkit-scrollbar-thumb {
  background-color: rgba(156, 163, 175, 0.3);
  border-radius: 2px;
}

.custom-scrollbar::-webkit-scrollbar-thumb:hover {
  background-color: rgba(156, 163, 175, 0.5);
}

/* Style pour cacher la flèche par défaut du select sur WebKit */
select {
  -webkit-appearance: none;
  -moz-appearance: none;
  appearance: none;
}

/* Style pour cacher la flèche par défaut sur Firefox */
select::-ms-expand {
  display: none;
}
</style> 