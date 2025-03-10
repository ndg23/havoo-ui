<template>
  <div class="text-center">
    <div class="mb-8 flex justify-center">
      <div class="h-20 w-20 rounded-full bg-primary-50 flex items-center justify-center">
        <Mail class="h-10 w-10 text-primary-500" />
      </div>
    </div>
    
    <h2 class="text-2xl font-bold text-gray-900 mb-4">Vérifiez votre email</h2>
    <p class="text-gray-600 mb-6">
      Nous avons envoyé un lien de confirmation à <strong>{{ email }}</strong>.<br>
      Veuillez cliquer sur ce lien pour continuer votre inscription.
    </p>
    
    <div class="bg-gray-50 rounded-xl p-4 mb-8">
      <div class="flex">
        <InfoIcon class="h-5 w-5 text-primary-500 mt-0.5 mr-3 flex-shrink-0" />
        <p class="text-sm text-gray-600 text-left">
          Si vous ne trouvez pas notre email, vérifiez votre dossier de spam ou
          <button 
            @click="resendEmail" 
            class="text-primary-600 font-medium hover:text-primary-700"
            :disabled="resending"
          >
            demandez un nouvel envoi
            <Loader2 v-if="resending" class="inline-block animate-spin ml-1 h-3.5 w-3.5" />
          </button>.
        </p>
      </div>
    </div>
    
    <div class="space-y-4">
      <button
        @click="goBack"
        class="w-full bg-white border border-gray-200 hover:bg-gray-50 text-gray-700 rounded-full py-3 px-4 flex items-center justify-center font-medium transition-colors"
      >
        <ArrowLeft class="h-5 w-5 mr-2" />
        Retour à l'inscription
      </button>
      
      <button
        @click="goToLogin"
        class="w-full bg-primary-500 hover:bg-primary-600 text-white rounded-full py-3 px-4 flex items-center justify-center font-medium transition-colors"
      >
        J'ai vérifié mon email
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useSupabaseClient } from '#imports'
import { Mail, InfoIcon, ArrowLeft, Loader2 } from 'lucide-vue-next'

const client = useSupabaseClient()
const router = useRouter()

const email = ref('')
const resending = ref(false)

// Au chargement, récupérer l'email de la session locale
onMounted(() => {
  // Essayer de récupérer l'email de la dernière tentative de connexion
  const lastEmail = localStorage.getItem('lastSignUpEmail')
  if (lastEmail) {
    email.value = lastEmail
  }
})

// Renvoyer un email de confirmation
const resendEmail = async () => {
  if (!email.value || resending.value) return
  
  resending.value = true
  
  try {
    const { error } = await client.auth.resend({
      type: 'signup',
      email: email.value
    })
    
    if (error) throw error
    
    // Afficher un message de succès
    alert('Un nouvel email de confirmation a été envoyé.')
  } catch (error) {
    console.error('Erreur lors du renvoi d\'email:', error)
    alert(`Erreur: ${error.message}`)
  } finally {
    resending.value = false
  }
}

// Retour à la page d'inscription
const goBack = () => {
  router.push('/auth/register-expert')
}

// Aller à la page de connexion
const goToLogin = () => {
  router.push('/login')
}

// Configuration de la page
definePageMeta({
  layout: 'auth'
})
</script> 