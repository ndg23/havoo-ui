<template>
  <div class="max-w-3xl mx-auto px-4 py-8">
    <!-- Header avec informations actuelles -->
   
    
    <!-- En-tête de la page -->
    <div class="mb-8">
      <h1 class="text-2xl font-bold text-gray-900 dark:text-white">Modifier mon profil</h1>
      <p class="text-gray-600 dark:text-gray-400 mt-1">Personnalisez vos informations pour vous présenter</p>
    </div>
    
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
                :src="form.avatar_url || '/assets/icons/avatar.svg'"
                :alt="`Photo de profil de ${form.first_name || 'utilisateur'}`"
                @error="handleImageError"
                class="h-32 w-32 rounded-full object-cover border border-gray-200 dark:border-gray-700"
              />
              
              <!-- Overlay pour le changement de photo -->
              <div class="absolute inset-0 flex items-center justify-center">
                <input
                  type="file"
                  ref="avatarInput"
                  accept="image/*"
                  class="hidden"
                  @change="handleAvatarChange"
                />
                
                <button
                  type="button"
                  @click="$refs.avatarInput?.click()"
                  class="absolute bottom-0 right-0 bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-full p-2 shadow-sm hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors"
                >
                  <CameraIcon class="w-5 h-5 text-gray-600 dark:text-gray-400" />
                </button>
              </div>

              <!-- Loading overlay -->
              <div 
                v-if="isUploadingAvatar"
                class="absolute inset-0 bg-black bg-opacity-50 rounded-full flex items-center justify-center"
              >
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
                  @click="$refs.avatarInput?.click()"
                  class="px-4 py-2 bg-white dark:bg-gray-700 border border-gray-200 dark:border-gray-700 text-gray-700 dark:text-gray-300 text-sm font-medium rounded-full hover:bg-gray-50 dark:hover:bg-gray-600 transition-colors flex items-center"
                >
                  <UploadIcon class="h-4 w-4 mr-1.5" />
                  Télécharger
                </button>
                
                <button 
                  v-if="form.avatar_url"
                  type="button"
                  @click="removeAvatar"
                  class="px-4 py-2 bg-white dark:bg-gray-700 border border-gray-200 dark:border-gray-700 text-red-600 dark:text-red-400 text-sm font-medium rounded-full hover:bg-gray-50 dark:hover:bg-gray-600 transition-colors flex items-center"
                >
                  <TrashIcon class="h-4 w-4 mr-1.5" />
                  Supprimer
                </button>
              </div>
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
                form.availability_status === 'available' 
                  ? 'text-green-600 dark:text-green-400'
                  : 'text-gray-500 dark:text-gray-400'
              ]">
                {{ form.availability_status === 'available' ? 'Disponible' : 'Indisponible' }}
              </span>
              
              <button 
                type="button"
                role="switch"
                :aria-checked="form.availability_status === 'available'"
                @click="toggleAvailabilityStatus"
                class="relative inline-flex h-8 w-14 flex-shrink-0 cursor-pointer rounded-full border-2 border-transparent transition-colors duration-200 ease-in-out focus:outline-none focus:ring-2 focus:ring-primary-600 focus:ring-offset-2"
                :class="[
                  form.availability_status === 'available' 
                    ? 'bg-green-500 dark:bg-green-600' 
                    : 'bg-gray-200 dark:bg-gray-600'
                ]"
              >
                <span 
                  aria-hidden="true"
                  class="pointer-events-none relative inline-block h-7 w-7 transform rounded-full bg-white shadow ring-0 transition duration-200 ease-in-out"
                  :class="[
                    form.availability_status === 'available' 
                      ? 'translate-x-6' 
                      : 'translate-x-0'
                  ]"
                >
                  <span
                    class="absolute inset-0 flex h-full w-full items-center justify-center transition-opacity"
                    :class="[
                      form.availability_status === 'available' 
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
                      form.availability_status === 'available' 
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
      
      <!-- Ajouter après les informations personnelles -->
      <div class="bg-white dark:bg-gray-800 rounded-xl shadow-sm">
        <div class="p-6">
          <div class="flex items-center justify-between">
            <div>
              <h3 class="text-lg font-medium text-gray-900 dark:text-white">Type de compte</h3>
              <p class="text-sm text-gray-600 dark:text-gray-400 mt-1">
                Choisissez si vous souhaitez proposer ou rechercher des services
              </p>
            </div>
            
            <button 
              type="button"
              role="switch"
              :aria-checked="isExpert"
              @click="toggleRole"
              class="relative inline-flex h-8 w-14 flex-shrink-0 cursor-pointer rounded-full border-2 border-transparent transition-colors duration-200 ease-in-out focus:outline-none focus:ring-2 focus:ring-primary-600 focus:ring-offset-2"
              :class="[isExpert ? 'bg-primary-600' : 'bg-gray-200 dark:bg-gray-600']"
            >
              <span class="sr-only">Mode prestataire</span>
              <span 
                class="pointer-events-none relative inline-block h-7 w-7 transform rounded-full bg-white shadow ring-0 transition duration-200 ease-in-out"
                :class="[isExpert ? 'translate-x-6' : 'translate-x-0']"
              />
            </button>
          </div>
          
          <div class="mt-4 text-sm">
            <p class="text-gray-600 dark:text-gray-400">
              Vous êtes actuellement en tant que : 
              <span class="font-medium" :class="isExpert ? 'text-primary-600' : 'text-gray-900 dark:text-white'">
                {{ isExpert ? 'Prestataire' : 'Client' }}
              </span>
            </p>
          </div>
        </div>
      </div>
      
      <!-- Section profession avec dropdown amélioré -->
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
          </div>

          <!-- Dropdown de sélection -->
          <div class="relative profession-dropdown">
            <button
              type="button"
              @click.stop="showProfessionDropdown = !showProfessionDropdown"
              class="w-full flex items-center justify-between p-4 border border-gray-200 dark:border-gray-700 rounded-xl bg-white dark:bg-gray-800 hover:bg-gray-50 dark:hover:bg-gray-700/50 transition-colors"
            >
              <div class="flex items-center gap-3">
                <div class="w-10 h-10 flex items-center justify-center rounded-lg bg-primary-50 dark:bg-primary-900/20">
                  <BriefcaseIcon class="w-5 h-5 text-primary-600 dark:text-primary-400" />
                </div>
                <div class="text-left">
                  <span class="block text-sm font-medium text-gray-900 dark:text-white">
                    {{ form.profession_id ? (professions.find(p => p.id === form.profession_id)?.name || 'Choisir une profession') : 'Choisir une profession' }}
                  </span>
                  <span class="block text-xs text-gray-500 dark:text-gray-400">
                    {{ form.profession_id ? 'Profession sélectionnée' : 'Cliquez pour sélectionner' }}
                  </span>
                </div>
              </div>
              <ChevronDownIcon 
                class="w-5 h-5 text-gray-400 transition-transform duration-200"
                :class="{ 'rotate-180': showProfessionDropdown }"
              />
            </button>

            <!-- Liste des professions -->
            <Transition
              enter-active-class="transition duration-200 ease-out"
              enter-from-class="transform scale-95 opacity-0"
              enter-to-class="transform scale-100 opacity-100"
              leave-active-class="transition duration-150 ease-in"
              leave-from-class="transform scale-100 opacity-100"
              leave-to-class="transform scale-95 opacity-0"
            >
              <div 
                v-if="showProfessionDropdown"
                v-click-outside="closeProfessionDropdown"
                class="absolute z-50 w-full mt-2 bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 shadow-lg"
              >
                <!-- Barre de recherche -->
                <div class="p-3 border-b border-gray-200 dark:border-gray-700">
                  <div class="relative">
                    <MagnifyingGlassIcon class="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" />
                    <input
                      v-model="professionSearch"
                      type="text"
                      placeholder="Rechercher une profession..."
                      class="w-full pl-10 pr-4 py-2 bg-gray-50 dark:bg-gray-700/50 border-0 rounded-lg text-sm focus:ring-2 focus:ring-primary-500"
                    />
                  </div>
                </div>

                <!-- Liste des résultats -->
                <div class="max-h-[300px] overflow-y-auto custom-scrollbar">
                  <div v-if="filteredProfessions.length" class="py-2">
                    <button
                      v-for="profession in filteredProfessions"
                :key="profession.id" 
                      @click="selectProfession(profession)"
                      class="w-full flex items-center gap-3 px-4 py-3 hover:bg-gray-50 dark:hover:bg-gray-700/50 transition-colors"
                      :class="{ 'bg-primary-50 dark:bg-primary-900/20': form.profession_id === profession.id }"
                    >
                      <div class="w-10 h-10 flex items-center justify-center rounded-lg"
                        :class="form.profession_id === profession.id ? 'bg-primary-100 dark:bg-primary-900/30' : 'bg-gray-100 dark:bg-gray-800'"
                      >
                        <BriefcaseIcon 
                          class="w-5 h-5"
                          :class="form.profession_id === profession.id ? 'text-primary-600 dark:text-primary-400' : 'text-gray-500 dark:text-gray-400'"
                        />
                      </div>
                      <div class="flex-1 text-left">
                        <span class="block font-medium text-gray-900 dark:text-white">
                {{ profession.name }}
                        </span>
                        <span v-if="profession.description" class="block text-sm text-gray-500 dark:text-gray-400">
                          {{ profession.description }}
                        </span>
                      </div>
                      <CheckIcon 
                        v-if="form.profession_id === profession.id"
                        class="w-5 h-5 text-primary-600 dark:text-primary-400 flex-shrink-0"
                      />
                    </button>
                  </div>
                  
                  <!-- État vide -->
                  <div v-else class="p-4 text-center">
                    <div class="w-12 h-12 mx-auto mb-3 rounded-full bg-gray-100 dark:bg-gray-800 flex items-center justify-center">
                      <MagnifyingGlassIcon class="w-6 h-6 text-gray-400" />
                    </div>
                    <p class="text-sm text-gray-500 dark:text-gray-400">
                      Aucune profession trouvée pour "{{ professionSearch }}"
                    </p>
                  </div>
                </div>
              </div>
            </Transition>
          </div>

          <!-- Tarif horaire -->
          <div class="mt-6">
            <FloatingLabelInput
              v-model="form.hourly_rate"
              label="Tarif horaire"
              type="number"
              :min="0"
              class="w-full md:w-1/2"
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
          @click="updateProfile"
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
import { ref, computed, watch, onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
import { useSupabaseClient, useSupabaseUser } from '#imports'
import { 
  CameraIcon,
  TrashIcon,
  BriefcaseIcon,
  ChevronDownIcon,
  CheckIcon,
  MagnifyingGlassIcon,
} from '@heroicons/vue/24/outline'
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
  CheckCircleIcon
} from '@heroicons/vue/24/outline'
import { useCustomToast } from '~/composables/useCustomToast'

// Types
interface Profile {
  first_name: string;
  last_name: string;
  email: string;
  phone: string;
  birthdate: string;
  gender: string;
  location: string;
  city: string;
  country: string;
  bio: string;
  avatar_url?: string;
  availability_status: 'available' | 'unavailable';
  role: 'client' | 'expert';
  profession_id?: number;
  hourly_rate?: number;
  updated_at?: string;
}

interface Profession {
  id: number;
  name: string;
  description?: string;
}

// État global
const user = useSupabaseUser()
const router = useRouter()
const supabase = useSupabaseClient()

// États du formulaire
const form = ref<Profile>({
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
  availability_status: 'available',
  role: 'client'
})

// États UI
const isLoading = ref(true)
const isSaving = ref(false)
const isUploadingAvatar = ref(false)
const isExpert = computed(() => form.value.role === 'expert')

// Refs pour les inputs
const avatarInput = ref<HTMLInputElement | null>(null)

// États des professions et compétences
const professions = ref<Profession[]>([])
const selectedProfession = ref<Profession | null>(null)
const professionSearch = ref('')

// Dans la partie script, ajouter/modifier ces états
const showProfessionDropdown = ref(false)

// Ajouter cette directive pour gérer les clics à l'extérieur
const vClickOutside = {
  mounted(el: HTMLElementWithClickOutside, binding: { value: () => void }) {
    el._clickOutside = (event: Event) => {
      if (!(el === event.target || el.contains(event.target as Node))) {
        binding.value()
      }
    }
    document.addEventListener('click', el._clickOutside)
  },
  unmounted(el: HTMLElementWithClickOutside) {
    if (el._clickOutside) {
      document.removeEventListener('click', el._clickOutside)
    }
  }
}

// Ajouter cette fonction pour gérer la fermeture du dropdown
const closeProfessionDropdown = () => {
  showProfessionDropdown.value = false
}

// Modifier la fonction selectProfession
const selectProfession = async (profession: Profession) => {
  try {
    form.value.profession_id = profession.id
    showProfessionDropdown.value = false
    
    const { error } = await supabase
      .from('profiles')
      .update({
        profession_id: profession.id,
        updated_at: new Date().toISOString()
      })
      .eq('id', user.value?.id)
    
    if (error) throw error
    showToast.success('Profession mise à jour')
  } catch (error) {
    console.error('Erreur:', error)
    showToast.error('Erreur lors de la mise à jour de la profession')
  }
}

// Charger les professions au montage
onMounted(async () => {
  if (!user.value) {
    router.push('/auth/login')
    return
  }

  try {
    const { data: profile, error: profileError } = await supabase
      .from('profiles')
      .select('*')
      .eq('id', user.value.id)
      .single()

    if (profileError) throw profileError

    if (profile) {
      form.value = {
        ...form.value,
        ...profile,
        email: user.value.email || ''
      }

      // Charger les professions seulement si l'utilisateur est expert
      if (profile.role === 'expert') {
        const { data: professionsData, error: professionsError } = await supabase
    .from('professions')
    .select('*')
    .order('name')

        if (professionsError) throw professionsError
        professions.value = professionsData || []
      }
    }
  } catch (error) {
    console.error('Erreur:', error)
    showToast.error('Erreur lors du chargement du profil')
  } finally {
    isLoading.value = false
  }
})

// Gestion des erreurs d'image
const handleImageError = (e: Event) => {
  const target = e.target as HTMLImageElement
  target.src = '/assets/icons/avatar.svg'
}

// Upload de l'avatar
const handleAvatarChange = async (event: Event) => {
  const target = event.target as HTMLInputElement
  const file = target.files?.[0]
  if (!file) return

  try {
    isUploadingAvatar.value = true

    if (!file.type.startsWith('image/')) {
      throw new Error('Veuillez sélectionner une image')
    }

    if (file.size > 5 * 1024 * 1024) {
      throw new Error('L\'image ne doit pas dépasser 5MB')
    }

    const fileExt = file.name.split('.').pop()
    const fileName = `${user.value?.id}-${Date.now()}.${fileExt}`
    const filePath = `avatars/${fileName}`

    const { error: uploadError } = await supabase.storage
      .from('avatars')
      .upload(filePath, file)

    if (uploadError) throw uploadError

    const { data: { publicUrl } } = supabase.storage
      .from('avatars')
      .getPublicUrl(filePath)

    const { error: updateError } = await supabase
      .from('profiles')
      .update({
        avatar_url: publicUrl,
        updated_at: new Date().toISOString()
      })
      .eq('id', user.value?.id)

    if (updateError) throw updateError

    form.value.avatar_url = publicUrl
    showToast.success('Photo de profil mise à jour')
    
  } catch (error) {
    console.error('Erreur:', error)
    showToast.error('Erreur lors de la mise à jour')
  } finally {
    isUploadingAvatar.value = false
    if (avatarInput.value) {
      avatarInput.value.value = ''
    }
  }
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

// Mise à jour du profil
const updateProfile = async () => {
  if (!user.value) return

  try {
    isSaving.value = true

    const { error } = await supabase
      .from('profiles')
      .update({
        ...form.value,
        updated_at: new Date().toISOString()
      })
      .eq('id', user.value.id)

    if (error) throw error

      showToast.success('Profil mis à jour avec succès')
  } catch (error) {
    console.error('Erreur:', error)
    showToast.error('Erreur lors de la mise à jour du profil')
  } finally {
    isSaving.value = false
  }
}

// SEO
useSeoMeta({
  title: 'Modifier mon profil | Keetaf',
  description: 'Modifiez vos informations personnelles, votre profession et vos paramètres de disponibilité sur Keetaf',
  ogTitle: 'Modifier mon profil | Keetaf',
  ogDescription: 'Modifiez vos informations personnelles, votre profession et vos paramètres de disponibilité sur Keetaf',
  ogImage: 'https://keetaf.com/images/og-image.jpg',
  twitterCard: 'summary_large_image'
})

// Fonction pour changer le rôle
const toggleRole = async () => {
  try {
    form.value.role = form.value.role === 'expert' ? 'client' : 'expert'
    
    const { error } = await supabase
      .from('profiles')
      .update({
        role: form.value.role,
        updated_at: new Date().toISOString()
      })
      .eq('id', user.value?.id)

    if (error) throw error
    showToast.success(`Vous êtes maintenant ${form.value.role === 'expert' ? 'prestataire' : 'client'}`)
  } catch (error) {
    console.error('Erreur:', error)
    showToast.error('Erreur lors du changement de rôle')
  }
}

// Gestion de l'avatar
const removeAvatar = async () => {
  try {
    const { error } = await supabase
      .from('profiles')
      .update({
        avatar_url: null,
        updated_at: new Date().toISOString()
      })
      .eq('id', user.value?.id)

    if (error) throw error
    form.value.avatar_url = undefined
      showToast.success('Photo supprimée')
  } catch (error) {
    console.error('Erreur:', error)
    showToast.error('Erreur lors de la suppression')
  }
}

// Gestion des professions
const removeProfession = async () => {
  try {
    form.value.profession_id = undefined
    const { error } = await supabase
      .from('profiles')
      .update({
        profession_id: null,
        updated_at: new Date().toISOString()
      })
      .eq('id', user.value?.id)

    if (error) throw error
    showToast.success('Profession supprimée')
  } catch (error) {
    console.error('Erreur:', error)
    showToast.error('Erreur lors de la suppression')
  }
}

// Gestion de la disponibilité
const toggleAvailabilityStatus = async () => {
  try {
    form.value.availability_status = 
      form.value.availability_status === 'available' ? 'unavailable' : 'available'
    
    const { error } = await supabase
      .from('profiles')
      .update({
        availability_status: form.value.availability_status,
        updated_at: new Date().toISOString()
      })
      .eq('id', user.value?.id)

    if (error) throw error
    showToast.success(`Statut mis à jour : ${form.value.availability_status === 'available' ? 'Disponible' : 'Indisponible'}`)
  } catch (error) {
    console.error('Erreur:', error)
    showToast.error('Erreur lors de la mise à jour du statut')
  }
}

// Réinitialisation du formulaire
const resetForm = () => {
  form.value = {
    ...form.value,
    first_name: '',
    last_name: '',
    phone: '',
    birthdate: '',
    gender: 'male',
    location: '',
    city: '',
    country: '',
    bio: '',
    availability_status: 'available'
  }
}

// Initialiser useCustomToast
const { showToast } = useCustomToast()

// Ajouter le computed pour filteredProfessions s'il manque
const filteredProfessions = computed(() => {
  const search = professionSearch.value.toLowerCase().trim()
  return professions.value.filter(profession => {
    const matchName = profession.name.toLowerCase().includes(search)
    const matchDescription = profession.description?.toLowerCase().includes(search)
    return matchName || matchDescription
  })
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