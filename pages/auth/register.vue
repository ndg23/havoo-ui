<template>
  <div class="max-w-md mx-auto px-4 pt-5 pb-16">
    <!-- En-tête avec logo -->
    <div class="mb-7 text-center">
  
      <h1 class="text-2xl font-bold text-gray-900 dark:text-white">Rejoignez la communauté</h1>
      <p class="text-gray-600 dark:text-gray-400 mt-1">
        Créez votre compte en quelques secondes
      </p>
    </div>

    <!-- Formulaire principal -->
    <form @submit.prevent="register" class="space-y-5">
      <!-- Carte pour les informations personnelles -->
      <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 p-5 transition-shadow hover:shadow-sm">
        <div class="space-y-4">
          <!-- Prénom et nom sur la même ligne -->
          <div class="grid grid-cols-2 gap-4">
            <div>
              <label for="firstName" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">
                Prénom
              </label>
              <input 
                id="firstName"
                v-model="form.firstName"
                type="text"
                placeholder="Votre prénom"
                class="w-full px-4 py-2.5 rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
                :class="{ 'border-red-500 dark:border-red-500': errors.firstName }"
                required
              />
              <p v-if="errors.firstName" class="text-red-600 dark:text-red-400 text-xs mt-1">{{ errors.firstName }}</p>
            </div>
            <div>
              <label for="lastName" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">
                Nom
              </label>
              <input 
                id="lastName"
                v-model="form.lastName"
                type="text"
                placeholder="Votre nom"
                class="w-full px-4 py-2.5 rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
                :class="{ 'border-red-500 dark:border-red-500': errors.lastName }"
                required
              />
              <p v-if="errors.lastName" class="text-red-600 dark:text-red-400 text-xs mt-1">{{ errors.lastName }}</p>
            </div>
          </div>

          <!-- Email -->
          <div>
            <label for="email" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">
              Adresse e-mail
            </label>
            <input 
              id="email"
              v-model="form.email"
              type="email"
              placeholder="votre@email.com"
              class="w-full px-4 py-2.5 rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
              :class="{ 'border-red-500 dark:border-red-500': errors.email }"
              required
            />
            <p v-if="errors.email" class="text-red-600 dark:text-red-400 text-xs mt-1">{{ errors.email }}</p>
          </div>

          <!-- Téléphone -->
          <div>
            <label for="phone" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">
              Téléphone
            </label>
            <input 
              id="phone"
              v-model="form.phone"
              type="tel"
              placeholder="06 12 34 56 78"
              class="w-full px-4 py-2.5 rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
              :class="{ 'border-red-500 dark:border-red-500': errors.phone }"
            />
            <p v-if="errors.phone" class="text-red-600 dark:text-red-400 text-xs mt-1">{{ errors.phone }}</p>
          </div>
        </div>
      </div>

      <!-- Carte pour les informations de compte -->
      <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 p-5 transition-shadow hover:shadow-sm">
        <div class="space-y-4">
          <!-- Mot de passe -->
          <div>
            <label for="password" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">
              Mot de passe
            </label>
            <div class="relative">
              <input 
                id="password"
                v-model="form.password"
                :type="showPassword ? 'text' : 'password'"
                placeholder="8 caractères minimum"
                class="w-full px-4 py-2.5 rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500 pr-10"
                :class="{ 'border-red-500 dark:border-red-500': errors.password }"
                @input="checkPasswordStrength"
                required
              />
              <button 
                type="button" 
                @click="showPassword = !showPassword"
                class="absolute inset-y-0 right-0 pr-3 flex items-center"
              >
                <Eye v-if="showPassword" class="h-5 w-5 text-gray-400" />
                <EyeOff v-else class="h-5 w-5 text-gray-400" />
              </button>
            </div>
            <p v-if="errors.password" class="text-red-600 dark:text-red-400 text-xs mt-1">{{ errors.password }}</p>
            
            <!-- Indicateur de force du mot de passe -->
            <div v-if="form.password.length > 0" class="mt-2">
              <div class="h-1.5 bg-gray-200 dark:bg-gray-700 rounded-full overflow-hidden">
                <div 
                  class="h-full transition-all duration-300"
                  :class="{
                    'bg-red-500': passwordStrength === 'weak',
                    'bg-amber-500': passwordStrength === 'medium',
                    'bg-green-500': passwordStrength === 'strong'
                  }"
                  :style="{ width: `${passwordStrengthPercent}%` }"
                ></div>
              </div>
              <p class="text-xs mt-1" :class="{
                'text-red-600 dark:text-red-400': passwordStrength === 'weak',
                'text-amber-600 dark:text-amber-400': passwordStrength === 'medium',
                'text-green-600 dark:text-green-400': passwordStrength === 'strong'
              }">
                {{ passwordStrengthText }}
              </p>
            </div>
          </div>

          <!-- Confirmation du mot de passe -->
          <div>
            <label for="passwordConfirm" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">
              Confirmez le mot de passe
            </label>
            <input 
              id="passwordConfirm"
              v-model="form.passwordConfirm"
              type="password"
              placeholder="Saisissez à nouveau votre mot de passe"
              class="w-full px-4 py-2.5 rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
              :class="{ 'border-red-500 dark:border-red-500': errors.passwordConfirm }"
              required
            />
            <p v-if="errors.passwordConfirm" class="text-red-600 dark:text-red-400 text-xs mt-1">{{ errors.passwordConfirm }}</p>
          </div>
        </div>
      </div>

      <!-- Type de compte -->
      <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 p-5 transition-shadow hover:shadow-sm">
        <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-3">
          Je m'inscris en tant que
        </label>
        <div class="grid grid-cols-2 gap-4">
          <button 
            type="button"
            @click="form.isExpert = false"
            class="relative p-4 border rounded-xl flex flex-col items-center transition-all"
            :class="!form.isExpert 
              ? 'border-primary-500 bg-primary-50 dark:bg-primary-900/20' 
              : 'border-gray-200 dark:border-gray-700 hover:border-gray-300 dark:hover:border-gray-600'"
          >
            <div class="absolute top-2 right-2" v-if="!form.isExpert">
              <CheckCircle class="h-5 w-5 text-primary-600 dark:text-primary-400" />
            </div>
            <User class="h-8 w-8 text-gray-600 dark:text-gray-400 mb-3" />
            <span class="font-medium text-gray-900 dark:text-white">Client</span>
            <span class="text-xs text-gray-500 dark:text-gray-400 mt-1">Je cherche des experts</span>
          </button>
          
          <button 
            type="button"
            @click="form.isExpert = true"
            class="relative p-4 border rounded-xl flex flex-col items-center transition-all"
            :class="form.isExpert 
              ? 'border-primary-500 bg-primary-50 dark:bg-primary-900/20' 
              : 'border-gray-200 dark:border-gray-700 hover:border-gray-300 dark:hover:border-gray-600'"
          >
            <div class="absolute top-2 right-2" v-if="form.isExpert">
              <CheckCircle class="h-5 w-5 text-primary-600 dark:text-primary-400" />
            </div>
            <Briefcase class="h-8 w-8 text-gray-600 dark:text-gray-400 mb-3" />
            <span class="font-medium text-gray-900 dark:text-white">Expert</span>
            <span class="text-xs text-gray-500 dark:text-gray-400 mt-1">Je propose mes services</span>
          </button>
        </div>
      </div>

      <!-- Conditions générales -->
      <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 p-5 transition-shadow hover:shadow-sm">
        <div class="flex items-start">
          <div class="flex items-center h-5">
            <input
              id="terms"
              v-model="form.acceptTerms"
              type="checkbox"
              class="w-4 h-4 text-primary-600 bg-gray-100 border-gray-300 rounded focus:ring-primary-500 dark:focus:ring-primary-600 dark:ring-offset-gray-800 dark:bg-gray-700 dark:border-gray-600"
              :class="{ 'border-red-500 dark:border-red-500': errors.acceptTerms }"
              required
            />
          </div>
          <label for="terms" class="ml-2 text-sm text-gray-600 dark:text-gray-400">
            J'accepte les <NuxtLink to="/terms" class="text-primary-600 dark:text-primary-400 hover:underline">conditions générales</NuxtLink> et la <NuxtLink to="/privacy" class="text-primary-600 dark:text-primary-400 hover:underline">politique de confidentialité</NuxtLink>
          </label>
        </div>
        <p v-if="errors.acceptTerms" class="text-red-600 dark:text-red-400 text-xs mt-1">{{ errors.acceptTerms }}</p>
      </div>

      <!-- Bouton d'inscription -->
      <button 
        type="submit" 
        class="w-full py-3 px-4 bg-primary-600 hover:bg-primary-700 text-white font-semibold rounded-full shadow-sm hover:shadow transition-all flex justify-center items-center"
        :disabled="isSubmitting"
      >
        <Loader2 v-if="isSubmitting" class="animate-spin h-5 w-5 mr-2" />
        <span>{{ isSubmitting ? 'Création en cours...' : 'Créer mon compte' }}</span>
      </button>

      <!-- Connexion alternative -->
      <div class="relative py-2">
        <div class="absolute inset-0 flex items-center">
          <div class="w-full border-t border-gray-300 dark:border-gray-700"></div>
        </div>
        <div class="relative flex justify-center">
          <span class="px-2 bg-gray-50 dark:bg-gray-900 text-sm text-gray-500 dark:text-gray-400">ou</span>
        </div>
      </div>

      <!-- Connexions sociales -->
      <div class="grid grid-cols-2 gap-3">
        <button
          type="button"
          @click="loginWithGoogle"
          class="flex justify-center items-center py-2.5 px-4 bg-white dark:bg-gray-800 hover:bg-gray-50 dark:hover:bg-gray-700 text-gray-700 dark:text-gray-300 font-medium rounded-lg border border-gray-300 dark:border-gray-700 shadow-sm transition-colors"
        >
          <!-- <img src="/img/google-logo.svg" alt="Google" class="h-5 w-5 mr-2" /> -->
          Google
        </button>
        <button
          type="button"
          @click="loginWithFacebook" 
          class="flex justify-center items-center py-2.5 px-4 bg-[#1877F2] hover:bg-[#0c64d8] text-white font-medium rounded-lg shadow-sm transition-colors"
        >
          <!-- <img src="/img/facebook-logo.svg" alt="Facebook" class="h-5 w-5 mr-2" /> -->
          Facebook
        </button>
      </div>

      <!-- Lien vers la connexion -->
      <div class="text-center text-sm mt-4">
        <p class="text-gray-600 dark:text-gray-400">
          Déjà membre ?
          <NuxtLink to="/auth/login" class="text-primary-600 dark:text-primary-400 font-medium hover:underline">
            Connectez-vous
          </NuxtLink>
        </p>
      </div>
    </form>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useRouter } from 'vue-router'
import { useSupabaseClient } from '#imports'
import { 
  Briefcase,
  User,
  Eye,
  EyeOff,
  CheckCircle,
  Loader2
} from 'lucide-vue-next'

const router = useRouter()
const supabase = useSupabaseClient()

// États du formulaire
const isSubmitting = ref(false)
const showPassword = ref(false)
const passwordStrength = ref('')
const passwordStrengthPercent = ref(0)

const form = ref({
  firstName: '',
  lastName: '',
  email: '',
  phone: '',
  password: '',
  passwordConfirm: '',
  isExpert: false,
  acceptTerms: false
})

const errors = ref({})

// Texte pour la force du mot de passe
const passwordStrengthText = computed(() => {
  switch(passwordStrength.value) {
    case 'weak':
      return 'Mot de passe faible'
    case 'medium':
      return 'Mot de passe moyen'
    case 'strong':
      return 'Mot de passe fort'
    default:
      return ''
  }
})

// Vérification de la force du mot de passe
const checkPasswordStrength = () => {
  const password = form.value.password
  
  if (password.length === 0) {
    passwordStrength.value = ''
    passwordStrengthPercent.value = 0
    return
  }
  
  let strength = 0
  
  // Ajouter des points selon la complexité
  if (password.length >= 8) strength += 1
  if (password.length >= 12) strength += 1
  if (/[A-Z]/.test(password)) strength += 1
  if (/[0-9]/.test(password)) strength += 1
  if (/[^A-Za-z0-9]/.test(password)) strength += 1
  
  // Déterminer la force en fonction du score
  if (strength <= 2) {
    passwordStrength.value = 'weak'
    passwordStrengthPercent.value = 33
  } else if (strength <= 4) {
    passwordStrength.value = 'medium'
    passwordStrengthPercent.value = 66
  } else {
    passwordStrength.value = 'strong'
    passwordStrengthPercent.value = 100
  }
}

// Validation du formulaire
const validateForm = () => {
  const newErrors = {}
  
  // Validation du prénom
  if (!form.value.firstName.trim()) {
    newErrors.firstName = 'Le prénom est requis'
  }
  
  // Validation du nom
  if (!form.value.lastName.trim()) {
    newErrors.lastName = 'Le nom est requis'
  }
  
  // Validation de l'email
  if (!form.value.email.trim()) {
    newErrors.email = 'L\'adresse email est requise'
  } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(form.value.email)) {
    newErrors.email = 'Format d\'email invalide'
  }
  
  // Validation du téléphone (optionnel)
  if (form.value.phone && !/^(\+33|0)[1-9](\d{2}){4}$/.test(form.value.phone.replace(/\s/g, ''))) {
    newErrors.phone = 'Format de téléphone invalide'
  }
  
  // Validation du mot de passe
  if (!form.value.password) {
    newErrors.password = 'Le mot de passe est requis'
  } else if (form.value.password.length < 8) {
    newErrors.password = 'Le mot de passe doit contenir au moins 8 caractères'
  }
  
  // Validation de la confirmation du mot de passe
  if (!form.value.passwordConfirm) {
    newErrors.passwordConfirm = 'Veuillez confirmer votre mot de passe'
  } else if (form.value.password !== form.value.passwordConfirm) {
    newErrors.passwordConfirm = 'Les mots de passe ne correspondent pas'
  }
  
  // Validation des CGU
  if (!form.value.acceptTerms) {
    newErrors.acceptTerms = 'Vous devez accepter les conditions générales'
  }
  
  errors.value = newErrors
  return Object.keys(newErrors).length === 0
}

// Inscription
const register = async () => {
  if (!validateForm()) {
    // Focus sur le premier champ en erreur
    const firstError = document.querySelector('.border-red-500')
    if (firstError) {
      firstError.scrollIntoView({ behavior: 'smooth', block: 'center' })
      firstError.focus()
    }
    return
  }
  
  isSubmitting.value = true
  
  try {
    // Inscription sur Supabase
    const { data, error } = await supabase.auth.signUp({
      email: form.value.email,
      password: form.value.password,
      options: {
        data: {
          first_name: form.value.firstName,
          last_name: form.value.lastName,
          phone: form.value.phone,
          is_expert: form.value.isExpert
        }
      }
    })
    
    if (error) throw error
    
    // Redirection vers la page d'accueil ou de confirmation
    router.push({ 
      path: '/auth/welcome',
      query: { email: form.value.email }
    })
    
  } catch (error) {
    if (error.message.includes('email')) {
      errors.value.email = 'Cette adresse email est déjà utilisée'
    } else {
      alert('Une erreur est survenue lors de l\'inscription. Veuillez réessayer.')
      console.error('Erreur lors de l\'inscription:', error)
    }
  } finally {
    isSubmitting.value = false
  }
}

// Connexion avec Google
const loginWithGoogle = async () => {
  try {
    const { error } = await supabase.auth.signInWithOAuth({
      provider: 'google',
      options: {
        redirectTo: `${window.location.origin}/auth/callback`,
        queryParams: {
          access_type: 'offline',
          prompt: 'consent'
        }
      }
    })
    
    if (error) throw error
  } catch (error) {
    console.error('Erreur de connexion avec Google:', error)
    alert('Erreur lors de la connexion avec Google')
  }
}

// Connexion avec Facebook
const loginWithFacebook = async () => {
  try {
    const { error } = await supabase.auth.signInWithOAuth({
      provider: 'facebook',
      options: {
        redirectTo: `${window.location.origin}/auth/callback`
      }
    })
    
    if (error) throw error
  } catch (error) {
    console.error('Erreur de connexion avec Facebook:', error)
    alert('Erreur lors de la connexion avec Facebook')
  }
}
</script>

<style scoped>
/* Animation des composants */
.space-y-5 > div {
  animation: fadeIn 0.4s ease;
  animation-fill-mode: both;
}

/* Animation séquentielle pour chaque section */
.space-y-5 > div:nth-child(1) { animation-delay: 0.05s; }
.space-y-5 > div:nth-child(2) { animation-delay: 0.1s; }
.space-y-5 > div:nth-child(3) { animation-delay: 0.15s; }
.space-y-5 > div:nth-child(4) { animation-delay: 0.2s; }
.space-y-5 > button { animation-delay: 0.25s; animation: fadeIn 0.4s ease; animation-fill-mode: both; }

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(8px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* Améliorer l'apparence du focus */
input:focus, select:focus, textarea:focus {
  outline: none;
}

/* Styliser le sélecteur de date pour le rendre plus cohérent */
input[type="date"] {
  appearance: none;
}

/* Empêcher le redimensionnement des textarea */
textarea {
  resize: none;
}
</style> 