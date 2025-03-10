<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useSupabaseClient } from '#imports'
import { 
  CheckCircle, 
  RefreshCcw, 
  AlertCircle, 
  Loader, 
  Info as InfoIcon 
} from 'lucide-vue-next'

const client = useSupabaseClient()
const router = useRouter()
const route = useRoute()

// États
const status = ref('loading') // loading, success, error
const errorMessage = ref('')
const step = ref(1)
const showHelp = ref(false)

// Étapes du processus d'authentification
const steps = [
  'Vérification de la session...',
  'Validation des identifiants...',
  'Préparation de votre espace...'
]

// Pour simuler un processus progressif
const advanceStep = () => {
  if (step.value < 3) {
    step.value++
  }
}

// Icône en fonction du statut
const statusIcon = computed(() => {
  switch (status.value) {
    case 'success': return CheckCircle
    case 'error': return AlertCircle
    default: return Loader
  }
})

// Titre en fonction du statut
const statusTitle = computed(() => {
  switch (status.value) {
    case 'success': return 'Authentification réussie'
    case 'error': return 'Erreur de connexion'
    default: return 'Authentification en cours'
  }
})

// Message en fonction du statut
const statusMessage = computed(() => {
  switch (status.value) {
    case 'success': 
      return 'Vous êtes maintenant connecté. Redirection vers votre espace...'
    case 'error': 
      return errorMessage.value || 'Un problème est survenu lors de l\'authentification.'
    default: 
      return 'Nous vérifions votre identité. Cela ne prendra qu\'un instant...'
  }
})

// Traiter la redirection après authentification
const handleAuthRedirect = async () => {
  try {
    // Avancer les étapes visuelles
    const stepInterval = setInterval(advanceStep, 800)
    
    // Montrer le message d'aide après un délai
    setTimeout(() => {
      showHelp.value = true
    }, 10000)
    
    // Récupérer le hash de l'URL si présent (pour OAuth)
    const hash = window.location.hash.substring(1)
    const params = new URLSearchParams(hash)
    
    // Si nous avons un paramètre d'erreur, traiter l'erreur
    if (params.get('error')) {
      clearInterval(stepInterval)
      status.value = 'error'
      errorMessage.value = decodeURIComponent(params.get('error_description') || 'Erreur d\'authentification')
      return
    }
    
    // Récupérer la session courante
    const { data: { session } } = await client.auth.getSession()
    
    // Si une session existe, l'authentification est réussie
    if (session) {
      clearInterval(stepInterval)
      status.value = 'success'
      
      // Rediriger après un court délai pour permettre à l'utilisateur de voir le succès
      setTimeout(() => {
        router.push('/account')
      }, 1500)
    } else {
      // Pas de session, vérifier la présence d'un access_token dans l'URL
      const accessToken = params.get('access_token')
      
      if (accessToken) {
        // Échanger le token contre une session
        const { data, error } = await client.auth.exchangeSessionForToken(accessToken, params.get('refresh_token'))
        
        if (error) {
          throw error
        }
        
        // Succès
        clearInterval(stepInterval)
        status.value = 'success'
        
        // Rediriger
        setTimeout(() => {
          router.push('/account')
        }, 1500)
      } else {
        throw new Error('Aucune session ou token trouvé')
      }
    }
  } catch (error) {
    console.error('Erreur de callback:', error)
    status.value = 'error'
    errorMessage.value = error.message || 'Une erreur est survenue lors de l\'authentification'
  }
}

// Réessayer l'authentification
const retryAuth = () => {
  router.push('/login')
}

// Retour à la page de connexion
const goToLogin = () => {
  router.push('/login')
}

// Au montage du composant
onMounted(() => {
  // Démarrer le processus de vérification d'authentification
  handleAuthRedirect()
})

// Définir le layout
definePageMeta({
  layout: 'auth'
})
</script>

<template>
  <div class="w-full flex flex-col items-center justify-center py-10">
    <!-- Conteneur principal avec effet de carte -->
    <div class="w-full max-w-lg bg-white rounded-2xl p-8 border border-gray-100 shadow-sm">
      <!-- Animation de connexion -->
      <div class="flex flex-col items-center mb-8">
        <div class="relative mb-8">
          <!-- Cercle principal -->
          <div class="h-20 w-20 rounded-full bg-primary-50 flex items-center justify-center">
            <!-- Cercle animé autour -->
            <div class="absolute inset-0 border-4 border-primary-500 rounded-full border-t-transparent animate-spin"></div>
            <!-- Icône au centre -->
            <div class="relative z-10 flex items-center justify-center">
              <component :is="statusIcon" class="h-10 w-10 text-primary-500" />
            </div>
          </div>
        </div>
        
        <!-- Texte de statut -->
        <h2 class="text-2xl font-bold text-gray-900 mb-2">{{ statusTitle }}</h2>
        <p class="text-gray-600 text-center max-w-sm">{{ statusMessage }}</p>
      </div>
      
      <!-- Message pour les cas d'erreur ou délais -->
      <div v-if="showHelp" class="bg-gray-50 rounded-xl p-4 mb-6">
        <div class="flex">
          <InfoIcon class="h-5 w-5 text-primary-500 mt-0.5 mr-3 flex-shrink-0" />
          <p class="text-sm text-gray-600">
            L'authentification prend plus de temps que prévu? Vous pouvez 
            <button 
              @click="retryAuth" 
              class="text-primary-600 font-medium hover:text-primary-700"
            >
              réessayer maintenant
            </button> 
            ou contacter notre support.
          </p>
        </div>
      </div>
      
      <!-- Boutons d'action -->
      <div class="flex flex-col gap-3">
        <button
          v-if="status === 'error'"
          @click="retryAuth"
          class="w-full bg-primary-500 hover:bg-primary-600 text-white rounded-full py-3 px-4 flex items-center justify-center font-bold text-lg transition-colors shadow-sm"
        >
          <RefreshCcw class="h-5 w-5 mr-2" />
          Réessayer
        </button>
        
        <button
          v-if="status === 'error'"
          @click="goToLogin"
          class="w-full bg-white border border-gray-200 hover:bg-gray-50 text-gray-700 rounded-full py-3 px-4 flex items-center justify-center font-medium text-lg transition-colors"
        >
          Retour à la connexion
        </button>
      </div>
    </div>
    
    <!-- Indicateur de progression -->
    <div v-if="status === 'loading'" class="mt-10 flex flex-col items-center">
      <div class="flex items-center space-x-2 mb-2">
        <div class="h-2 w-2 rounded-full" :class="step >= 1 ? 'bg-primary-500' : 'bg-gray-200'"></div>
        <div class="h-2 w-2 rounded-full" :class="step >= 2 ? 'bg-primary-500' : 'bg-gray-200'"></div>
        <div class="h-2 w-2 rounded-full" :class="step >= 3 ? 'bg-primary-500' : 'bg-gray-200'"></div>
      </div>
      <p class="text-sm text-gray-500">{{ steps[step - 1] }}</p>
    </div>
  </div>
</template>

<style scoped>
/* Animation pulse pour le cercle principal en état de chargement */
@keyframes pulse {
  0% { transform: scale(1); opacity: 1; }
  50% { transform: scale(1.05); opacity: 0.8; }
  100% { transform: scale(1); opacity: 1; }
}

.animate-pulse-custom {
  animation: pulse 2s cubic-bezier(0.4, 0, 0.6, 1) infinite;
}
</style>
