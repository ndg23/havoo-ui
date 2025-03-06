<template>
  <div class="min-h-screen bg-white flex flex-col">
    <!-- Barre de progression subtile -->
    <div class="fixed top-0 left-0 right-0 h-1 bg-gray-100">
      <div 
        class="h-full bg-blue-600 transition-all duration-500 ease-out"
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
            <!-- Étape 1: Email -->
            <div v-if="currentStep === 1" class="space-y-12">
              <h1 class="text-3xl font-semibold text-gray-900">
                Quelle est votre adresse email ?
              </h1>
              <div class="space-y-6">
                <input
                  v-model="form.email"
                  type="email"
                  placeholder="votre@email.com"
                  class="w-full p-4 text-xl border-b-2 border-gray-200 focus:border-blue-500 focus:outline-none transition-colors"
                  autofocus
                />
              </div>
            </div>
            
            <!-- Étape 2: Prénom -->
            <div v-if="currentStep === 2" class="space-y-12">
              <h1 class="text-3xl font-semibold text-gray-900">
                Comment vous appelez-vous ?
              </h1>
              <div class="space-y-6">
                <input
                  v-model="form.firstName"
                  type="text"
                  placeholder="Votre prénom"
                  class="w-full p-4 text-xl border-b-2 border-gray-200 focus:border-blue-500 focus:outline-none transition-colors"
                  autofocus
                />
              </div>
            </div>
            
            <!-- Étape 3: Nom -->
            <div v-if="currentStep === 3" class="space-y-12">
              <h1 class="text-3xl font-semibold text-gray-900">
                Et votre nom de famille ?
              </h1>
              <div class="space-y-6">
                <input
                  v-model="form.lastName"
                  type="text"
                  placeholder="Votre nom"
                  class="w-full p-4 text-xl border-b-2 border-gray-200 focus:border-blue-500 focus:outline-none transition-colors"
                  autofocus
                />
              </div>
            </div>
            
            <!-- Étape 4: Mot de passe -->
            <div v-if="currentStep === 4" class="space-y-12">
              <h1 class="text-3xl font-semibold text-gray-900">
                Créez votre mot de passe
              </h1>
              <div class="space-y-2">
                <div class="relative">
                  <input
                    v-model="form.password"
                    :type="showPassword ? 'text' : 'password'"
                    placeholder="Votre mot de passe"
                    class="w-full p-4 text-xl border-b-2 border-gray-200 focus:border-blue-500 focus:outline-none transition-colors"
                    autofocus
                  />
                  <button 
                    type="button"
                    @click="showPassword = !showPassword"
                    class="absolute right-2 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-600"
                  >
                    <Eye v-if="!showPassword" class="h-5 w-5" />
                    <EyeOff v-else class="h-5 w-5" />
                  </button>
                </div>
                <p class="text-sm text-gray-500">Minimum 8 caractères, avec au moins une majuscule et un chiffre</p>
              </div>
            </div>
            
            <!-- Étape 5: Conditions -->
            <div v-if="currentStep === 5" class="space-y-12">
              <h1 class="text-3xl font-semibold text-gray-900">
                Dernière étape
              </h1>
              <div class="space-y-6">
                <div class="flex items-start gap-3">
                  <input
                    v-model="form.acceptTerms"
                    id="terms"
                    type="checkbox"
                    class="mt-1 h-5 w-5 rounded text-blue-600 focus:ring-blue-500"
                  />
                  <label for="terms" class="text-gray-700">
                    J'accepte les <a href="#" class="text-blue-600 hover:underline">conditions d'utilisation</a> 
                    et je certifie que les informations fournies sont exactes.
                  </label>
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
            class="w-full py-4 bg-blue-600 text-white font-medium rounded-full
              hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed
              transition-colors shadow-md"
          >
            Continuer
          </button>
          
          <button
            v-else
            @click="handleSubmit"
            :disabled="loading || !form.acceptTerms"
            class="w-full py-4 bg-blue-600 text-white font-medium rounded-full
              hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed
              transition-colors shadow-md flex items-center justify-center"
          >
            <Loader2 v-if="loading" class="animate-spin -ml-1 mr-2 h-5 w-5" />
            {{ loading ? 'Inscription en cours...' : 'Créer mon compte' }}
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
        
        <!-- Lien vers login -->
        <div class="mt-8 text-center">
          <p class="text-gray-600">
            Déjà inscrit ?
            <NuxtLink to="/auth/login" class="text-blue-600 hover:underline font-medium">
              Se connecter
            </NuxtLink>
          </p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { Eye, EyeOff, Loader2 } from 'lucide-vue-next'

const client = useSupabaseClient()
const router = useRouter()

const currentStep = ref(1)
const totalSteps = 5
const loading = ref(false)
const showPassword = ref(false)

interface RegisterForm {
  email: string
  firstName: string
  lastName: string
  password: string
  acceptTerms: boolean
}

const form = ref<RegisterForm>({
  email: '',
  firstName: '',
  lastName: '',
  password: '',
  acceptTerms: false
})

// Déterminer si l'utilisateur peut passer à l'étape suivante
const canProceed = computed(() => {
  switch (currentStep.value) {
    case 1: return !!form.value.email.trim() && /\S+@\S+\.\S+/.test(form.value.email)
    case 2: return !!form.value.firstName.trim()
    case 3: return !!form.value.lastName.trim()
    case 4: return !!form.value.password && form.value.password.length >= 8
    case 5: return form.value.acceptTerms
    default: return true
  }
})

const nextStep = () => {
  if (currentStep.value < totalSteps) {
    currentStep.value++
  }
}

const handleSubmit = async () => {
  try {
    loading.value = true
    
    // 1. Inscription avec email et mot de passe
    const { data: { user }, error: signUpError } = await client.auth.signUp({
      email: form.value.email,
      password: form.value.password
    })
    
    if (signUpError) throw signUpError
    if (!user) throw new Error('Échec de création du compte')

    // 2. Créer le profil utilisateur
    const { error: profileError } = await client
      .from('profiles')
      .insert({
        id: user.id,
        first_name: form.value.firstName,
        last_name: form.value.lastName,
        email: form.value.email,
        is_expert: false,
        created_at: new Date().toISOString(),
        updated_at: new Date().toISOString()
      })

    if (profileError) throw profileError

    // 3. Rediriger vers la page de confirmation
    router.push('/auth/check-email')
  } catch (error) {
    console.error('Erreur inscription:', error)
    // Afficher une notification d'erreur
  } finally {
    loading.value = false
  }
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
</style> 