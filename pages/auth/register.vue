<template>
  <div class="min-h-screen py-12 bg-white flex flex-col justify-center px-4 sm:px-6 lg:px-8">
    <div class="sm:mx-auto sm:w-full sm:max-w-md">
      <!-- <img class="mx-auto h-14 w-auto" src="/logo.svg" alt="Logo" /> -->
      <h1 class="mt-8 text-center text-3xl font-bold tracking-tight text-gray-900">
        Créer un compte
      </h1>
      <p class="mt-2 text-center text-gray-600">
        Ou
        <NuxtLink to="/auth/login" class="font-medium text-primary-600 hover:text-primary-500">
          connectez-vous
        </NuxtLink>
        si vous avez déjà un compte
      </p>
    </div>

    <div class="mt-10 sm:mx-auto sm:w-full sm:max-w-md">
      <!-- Message d'erreur -->
      <div v-if="errorMessage" class="mb-6 rounded-lg p-4 bg-red-50 text-sm text-red-800">
        {{ errorMessage }}
      </div>

      <!-- Boutons de connexion sociale -->
      <div class="space-y-3">
        <button
          @click="socialLogin('google')"
          type="button"
          class="flex w-full justify-center items-center gap-3 rounded-full border border-gray-300 bg-white px-6 py-3.5 text-base font-medium text-gray-700 shadow-sm hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-primary-500 focus:ring-offset-2"
        >
          <svg class="h-5 w-5" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
            <path d="M12.48 10.92v3.28h7.84c-.24 1.84-.853 3.187-1.787 4.133-1.147 1.147-2.933 2.4-6.053 2.4-4.827 0-8.6-3.893-8.6-8.72s3.773-8.72 8.6-8.72c2.6 0 4.507 1.027 5.907 2.347l2.307-2.307C18.747 1.44 16.133 0 12.48 0 5.867 0 .307 5.387.307 12s5.56 12 12.173 12c3.573 0 6.267-1.173 8.373-3.36 2.16-2.16 2.84-5.213 2.84-7.667 0-.76-.053-1.467-.173-2.053H12.48z" fill="#4285F4"/>
            <path d="M12.48 10.92v3.28h7.84c-.24 1.84-.853 3.187-1.787 4.133-1.147 1.147-2.933 2.4-6.053 2.4-4.827 0-8.6-3.893-8.6-8.72s3.773-8.72 8.6-8.72c2.6 0 4.507 1.027 5.907 2.347l2.307-2.307C18.747 1.44 16.133 0 12.48 0 5.867 0 .307 5.387.307 12s5.56 12 12.173 12c3.573 0 6.267-1.173 8.373-3.36 2.16-2.16 2.84-5.213 2.84-7.667 0-.76-.053-1.467-.173-2.053H12.48z" fill="#34A853" transform="translate(6 12)"/>
            <path d="M12.48 10.92v3.28h7.84c-.24 1.84-.853 3.187-1.787 4.133-1.147 1.147-2.933 2.4-6.053 2.4-4.827 0-8.6-3.893-8.6-8.72s3.773-8.72 8.6-8.72c2.6 0 4.507 1.027 5.907 2.347l2.307-2.307C18.747 1.44 16.133 0 12.48 0 5.867 0 .307 5.387.307 12s5.56 12 12.173 12c3.573 0 6.267-1.173 8.373-3.36 2.16-2.16 2.84-5.213 2.84-7.667 0-.76-.053-1.467-.173-2.053H12.48z" fill="#FBBC05" transform="translate(0 6)"/>
            <path d="M12.48 10.92v3.28h7.84c-.24 1.84-.853 3.187-1.787 4.133-1.147 1.147-2.933 2.4-6.053 2.4-4.827 0-8.6-3.893-8.6-8.72s3.773-8.72 8.6-8.72c2.6 0 4.507 1.027 5.907 2.347l2.307-2.307C18.747 1.44 16.133 0 12.48 0 5.867 0 .307 5.387.307 12s5.56 12 12.173 12c3.573 0 6.267-1.173 8.373-3.36 2.16-2.16 2.84-5.213 2.84-7.667 0-.76-.053-1.467-.173-2.053H12.48z" fill="#EA4335" transform="translate(0 18)"/>
          </svg>
          Continuer avec Google
        </button>
      </div>

      <div class="relative my-8">
        <div class="absolute inset-0 flex items-center">
          <div class="w-full border-t border-gray-200"></div>
        </div>
        <div class="relative flex justify-center">
          <span class="bg-white px-4 text-sm text-gray-500">ou</span>
        </div>
      </div>

      <!-- Formulaire d'inscription -->
      <form @submit.prevent="registerUser" class="space-y-5">
        <!-- Nom et prénom -->
        <div class="grid grid-cols-2 gap-4">
          <FloatingLabelInput
            id="firstName"
            label="Prénom"
            v-model="formData.firstName"
            required
            autocomplete="given-name"
          />
          
          <FloatingLabelInput
            id="lastName"
            label="Nom"
            v-model="formData.lastName"
            required
            autocomplete="family-name"
          />
        </div>
        
        <!-- Email avec validation -->
        <div class="relative">
          <FloatingLabelInput
            id="email"
            label="Email"
            type="email"
            v-model="formData.email"
            required
            autocomplete="email"
            @blur="checkEmailExists"
            :class="{'border-red-500': emailError}"
          />
          <div v-if="emailChecking" class="absolute right-3 top-1/2 -translate-y-1/2">
            <svg class="animate-spin h-5 w-5 text-gray-400" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
              <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
              <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
            </svg>
          </div>
          <p v-if="emailError" class="mt-1 text-sm text-red-600">{{ emailError }}</p>
        </div>
        
        <!-- Mot de passe -->
        <div class="relative">
          <FloatingLabelInput
            id="password"
            label="Mot de passe"
            :type="showPassword ? 'text' : 'password'"
            v-model="formData.password"
            required
            autocomplete="new-password"
          />
          <button 
            type="button"
            @click="showPassword = !showPassword"
            class="absolute right-4 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-600"
          >
            <svg v-if="showPassword" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
            </svg>
            <svg v-else class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.88 9.88l-3.29-3.29m7.532 7.532l3.29 3.29M3 3l3.59 3.59m0 0A9.953 9.953 0 0112 5c4.478 0 8.268 2.943 9.543 7a10.025 10.025 0 01-4.132 5.411m0 0L21 21" />
            </svg>
          </button>
        </div>
        
        <!-- Type d'utilisateur -->
        <div class="bg-white p-5 rounded-xl border border-gray-100 shadow-sm">
          <!-- <h3 class="text-base font-semibold text-gray-800 mb-3">Vous êtes :</h3> -->
          
          <div class="grid grid-cols-2 gap-5">
            <button 
              type="button"
              class="relative flex flex-col items-center justify-center p-6 rounded-xl transition-all duration-200 overflow-hidden group"
              :class="!formData.isExpert ? 
                'bg-primary-50 ring-2 ring-primary-500 shadow-sm' : 
                'bg-gray-50 hover:bg-gray-100 border border-gray-200'"
              @click="formData.isExpert = false"
            >
              <div class="absolute inset-0 bg-primary-500 opacity-0 transition-opacity duration-300" 
                   :class="!formData.isExpert ? 'opacity-5' : ''"></div>
              
              <input 
                id="user" 
                name="userType" 
                type="radio" 
                v-model="formData.isExpert" 
                :value="false" 
                class="sr-only" 
              />
              
              <svg class="h-8 w-8 mb-3 transition-colors duration-200" 
                   :class="!formData.isExpert ? 'text-primary-600' : 'text-gray-500'" 
                   viewBox="0 0 24 24" fill="none" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" 
                      d="M18 18.72a9.094 9.094 0 003.741-.479 3 3 0 00-4.682-2.72m.94 3.198l.001.031c0 .225-.012.447-.037.666A11.944 11.944 0 0112 21c-2.17 0-4.207-.576-5.963-1.584A6.062 6.062 0 016 18.719m12 0a5.971 5.971 0 00-.941-3.197m0 0A5.995 5.995 0 0012 12.75a5.995 5.995 0 00-5.058 2.772m0 0a3 3 0 00-4.681 2.72 8.986 8.986 0 003.74.477m.94-3.197a5.971 5.971 0 00-.94 3.197M15 6.75a3 3 0 11-6 0 3 3 0 016 0zm6 3a2.25 2.25 0 11-4.5 0 2.25 2.25 0 014.5 0zm-13.5 0a2.25 2.25 0 11-4.5 0 2.25 2.25 0 014.5 0z" />
              </svg>
              
              <span class="font-bold text-base transition-colors duration-200" 
                    :class="!formData.isExpert ? 'text-primary-800' : 'text-gray-700'">
                Client
              </span>
              
              <span class="text-xs mt-1 text-center transition-colors duration-200" 
                    :class="!formData.isExpert ? 'text-primary-600' : 'text-gray-500'">
                Je cherche de l'aide
              </span>
              
              <div v-if="!formData.isExpert" class="absolute top-2 right-2">
                <svg class="h-5 w-5 text-primary-600" viewBox="0 0 20 20" fill="currentColor">
                  <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
                </svg>
              </div>
            </button>
            
            <button 
              type="button"
              class="relative flex flex-col items-center justify-center p-6 rounded-xl transition-all duration-200 overflow-hidden group"
              :class="formData.isExpert ? 
                'bg-primary-50 ring-2 ring-primary-500 shadow-sm' : 
                'bg-gray-50 hover:bg-gray-100 border border-gray-200'"
              @click="formData.isExpert = true"
            >
              <div class="absolute inset-0 bg-primary-500 opacity-0 transition-opacity duration-300" 
                   :class="formData.isExpert ? 'opacity-5' : ''"></div>
              
              <input 
                id="expert" 
                name="userType" 
                type="radio" 
                v-model="formData.isExpert" 
                :value="true" 
                class="sr-only" 
              />
              
              <svg class="h-8 w-8 mb-3 transition-colors duration-200" 
                   :class="formData.isExpert ? 'text-primary-600' : 'text-gray-500'" 
                   viewBox="0 0 24 24" fill="none" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" 
                      d="M20.25 14.15v4.25c0 1.094-.787 2.036-1.872 2.18-2.087.277-4.216.42-6.378.42s-4.291-.143-6.378-.42c-1.085-.144-1.872-1.086-1.872-2.18v-4.25m16.5 0a2.18 2.18 0 00.75-1.661V8.706c0-1.081-.768-2.015-1.837-2.175a48.114 48.114 0 00-3.413-.387m4.5 8.006c-.194.165-.42.295-.673.38A23.978 23.978 0 0112 15.75c-2.648 0-5.195-.429-7.577-1.22a2.016 2.016 0 01-.673-.38m0 0A2.18 2.18 0 013 12.489V8.706c0-1.081.768-2.015 1.837-2.175a48.111 48.111 0 013.413-.387m7.5 0V5.25A2.25 2.25 0 0013.5 3h-3a2.25 2.25 0 00-2.25 2.25v.894m7.5 0a48.667 48.667 0 00-7.5 0M12 12.75h.008v.008H12v-.008z" />
              </svg>
              
              <span class="font-bold text-base transition-colors duration-200" 
                    :class="formData.isExpert ? 'text-primary-800' : 'text-gray-700'">
                Expert
              </span>
              
              <span class="text-xs mt-1 text-center transition-colors duration-200" 
                    :class="formData.isExpert ? 'text-primary-600' : 'text-gray-500'">
                Je propose mes services
              </span>
              
              <div v-if="formData.isExpert" class="absolute top-2 right-2">
                <svg class="h-5 w-5 text-primary-600" viewBox="0 0 20 20" fill="currentColor">
                  <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
                </svg>
              </div>
            </button>
          </div>
        </div>
        
        <!-- Compétences pour les experts -->
        <div v-if="formData.isExpert" class="space-y-3 animate-fade-in">
          <div class="flex items-center justify-between mb-2">
            <!-- <label class="block text-sm font-medium text-gray-700">Vos compétences</label> -->
            <span :class="formData.skills.length >= 5 ? 'text-primary-600 font-medium' : 'text-gray-500'" class="text-xs">
              {{ formData.skills.length }}/5
            </span>
          </div>
          
          <!-- Sélection de compétence avec style Google -->
          <div class="relative">
            <select 
              id="skill" 
              v-model="selectedSkill"
              @change="addSkillAndReset"
              class="input-field w-full border border-gray-300 rounded-lg px-4 py-3.5 appearance-none bg-white transition-all focus:outline-none focus:border-primary-500 focus:ring-2 focus:ring-primary-500 focus:ring-opacity-30 text-base"
              :disabled="formData.skills.length >= 3"
            >
              <option value="" disabled selected>Choisir des compétences</option>
              <option 
                v-for="skill in availableSkills.filter(s => !formData.skills.includes(s))" 
                :key="skill" 
                :value="skill"
              >
                {{ skill }}
              </option>
            </select>
            
            <!-- Icône de flèche personnalisée -->
            <div class="pointer-events-none absolute inset-y-0 right-0 flex items-center px-3 text-gray-500">
              <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
              </svg>
            </div>
          </div>
          
          <!-- Message d'erreur compétences -->
          <p v-if="skillsError" class="mt-1 text-sm text-red-600 flex items-center">
            <svg class="h-4 w-4 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
            </svg>
            {{ skillsError }}
          </p>
          
          <!-- Compétences sélectionnées améliorées -->
          <div v-if="formData.skills.length > 0" class="flex flex-wrap gap-2 mt-3">
            <div 
              v-for="(skill, index) in formData.skills" 
              :key="index"
              class="inline-flex items-center px-4 py-2 rounded-full text-sm font-medium bg-primary-100 text-primary-800 animate-fade-in group"
            >
              {{ skill }}
              <button 
                type="button" 
                @click="removeSkill(index)" 
                class="ml-2 inline-flex items-center justify-center h-5 w-5 rounded-full bg-primary-200 text-primary-600 hover:bg-primary-300 hover:text-primary-800 focus:outline-none transition-all"
                aria-label="Supprimer la compétence"
              >
                <svg class="h-3 w-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                </svg>
              </button>
            </div>
          </div>
          
          <!-- Suggestions et guide -->
          <div v-if="formData.skills.length === 0" class="mt-2">
            <p class="text-xs text-gray-500">Sélectionnez vos domaines d'expertise pour aider les autres utilisateurs.</p>
          </div>
        </div>
        
        <!-- Conditions d'utilisation -->
        <div class="flex items-start mt-6">
          <div class="flex items-center h-5">
            <input
              id="terms"
              name="terms"
              type="checkbox"
              v-model="formData.terms"
              class="h-4 w-4 rounded border-gray-300 text-primary-600 focus:ring-primary-500"
            />
          </div>
          <div class="ml-3 text-sm">
            <label for="terms" class="text-gray-700">
              J'accepte les <a href="/terms" class="text-primary-600 hover:text-primary-500">conditions d'utilisation</a> et la <a href="/privacy" class="text-primary-600 hover:text-primary-500">politique de confidentialité</a>
            </label>
          </div>
        </div>

        <!-- Bouton d'inscription -->
        <div class="mt-6">
          <button
            type="submit"
            :disabled="isLoading"
            class="flex w-full justify-center items-center rounded-full bg-primary-600 px-6 py-3.5 text-base font-semibold text-white shadow-sm hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-primary-500 focus:ring-offset-2 disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
          >
            <span v-if="isLoading" class="inline-block h-4 w-4 animate-spin rounded-full border-2 border-solid border-current border-t-transparent mr-2"></span>
            Créer un compte
          </button>
        </div>
      </form>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { useRouter } from '#imports'
import { useSupabaseClient } from '#imports'
import FloatingLabelInput from '~/components/ui/FloatingLabelInput.vue'

// Données du formulaire
const formData = ref({
  firstName: '',
  lastName: '',
  email: '',
  password: '',
  isExpert: false,
  skills: [],
  terms: false
})

// Variables d'état
const availableSkills = ref([])
const isLoading = ref(false)
const emailChecking = ref(false)
const errorMessage = ref('')
const skillsError = ref('')
const emailError = ref('')
const showPassword = ref(false)
const selectedSkill = ref('')

// Services
const router = useRouter()
const supabase = useSupabaseClient()

// Chargement des compétences disponibles depuis Supabase
onMounted(async () => {
  try {
    const { data, error } = await supabase
      .from('skills')
      .select('name')
      .order('name')
    
    if (error) throw error
    
    if (data) {
      availableSkills.value = data.map(skill => skill.name)
    }
  } catch (error) {
    console.error('Erreur lors du chargement des compétences:', error)
    // Fallback avec une liste de compétences par défaut
    availableSkills.value = [
      'Développement web', 
      'Design', 
      'Marketing', 
      'Finance', 
      'Droit', 
      'Ressources humaines',
      'Communication',
      'Gestion de projet',
      'SEO',
      'Rédaction'
    ]
  }
})

// Vérification de l'email
const checkEmailExists = async () => {
  if (!formData.value.email || emailChecking.value) return
  
  // Format d'email valide
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
  if (!emailRegex.test(formData.value.email)) {
    emailError.value = 'Veuillez entrer une adresse email valide'
    return
  }
  
  emailChecking.value = true
  emailError.value = ''
  
  try {
    const { data, error } = await supabase.auth.signInWithOtp({
      email: formData.value.email,
      options: { shouldCreateUser: false }
    })
    
    if (error && !error.message.includes('User not found')) {
      emailError.value = "Erreur lors de la vérification de l'email"
    } else if (!error) {
      emailError.value = 'Cette adresse email est déjà utilisée'
    }
  } catch (error) {
    console.error('Erreur lors de la vérification de l\'email:', error)
  } finally {
    emailChecking.value = false
  }
}

// Méthodes
const addSkillAndReset = () => {
  if (selectedSkill.value && !formData.value.skills.includes(selectedSkill.value) && formData.value.skills.length < 5) {
    formData.value.skills.push(selectedSkill.value)
    selectedSkill.value = '' // Reset selection
    skillsError.value = ''
  }
}

const removeSkill = (index) => {
  formData.value.skills.splice(index, 1)
}

const registerUser = async () => {
  // Réinitialiser les erreurs
  errorMessage.value = ''
  skillsError.value = ''
  
  // Vérification des conditions
  if (!formData.value.terms) {
    errorMessage.value = 'Vous devez accepter les conditions d\'utilisation'
    return
  }
  
  // Vérification des compétences pour les experts
  if (formData.value.isExpert && formData.value.skills.length === 0) {
    skillsError.value = 'Veuillez ajouter au moins une compétence'
    return
  }
  
  // Vérification de l'email une dernière fois
  if (emailError.value) {
    errorMessage.value = emailError.value
    return
  }
  
  isLoading.value = true
  
  try {
    // Créer l'utilisateur
    const { data: authData, error } = await supabase.auth.signUp({
      email: formData.value.email,
      password: formData.value.password,
      options: {
        data: {
          first_name: formData.value.firstName,
          last_name: formData.value.lastName,
          is_expert: formData.value.isExpert
        }
      }
    })
    
    if (error) throw error
    
    if (authData.user) {
      // Créer le profil dans la base de données
      const { error: profileError } = await supabase
        .from('profiles')
        .insert({
          id: authData.user.id,
          first_name: formData.value.firstName,
          last_name: formData.value.lastName,
          email: formData.value.email,
          is_expert: formData.value.isExpert,
          skills: formData.value.skills
        })
        
      if (profileError) throw profileError
      
      // Rediriger vers login après succès
      router.push({
        path: '/auth/login',
        query: { message: 'Compte créé avec succès! Vérifiez votre email pour confirmer votre inscription.' }
      })
    }
  } catch (error) {
    console.error('Erreur d\'inscription:', error)
    errorMessage.value = error.message || 'Une erreur est survenue lors de l\'inscription'
  } finally {
    isLoading.value = false
  }
}

const socialLogin = async (provider) => {
  try {
    const { error } = await supabase.auth.signInWithOAuth({
      provider,
      options: {
        redirectTo: `${window.location.origin}/auth/callback`
      }
    })
    
    if (error) throw error
  } catch (error) {
    console.error(`Erreur de connexion avec ${provider}:`, error)
    errorMessage.value = `Erreur de connexion avec ${provider}`
  }
}
</script>

<style scoped>
.animate-fade-in {
  animation: fadeIn 0.2s ease-out;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(4px); }
  to { opacity: 1; transform: translateY(0); }
}
</style>