<template>
  <div class="min-h-screen bg-white flex flex-col justify-center py-12 sm:px-6 lg:px-8">
    <div class="sm:mx-auto sm:w-full sm:max-w-md">
      <!-- Logo -->
      <div class="flex justify-center">
        <NuxtLink to="/" class="flex items-center">
          <span class="text-2xl font-bold text-black">ExpertConnect</span>
        </NuxtLink>
      </div>
      
      <h2 class="mt-6 text-center text-3xl font-extrabold text-gray-900">
        Vérifiez votre email
      </h2>
      <p class="mt-2 text-center text-sm text-gray-600">
        Nous avons envoyé un lien de vérification à votre adresse email
      </p>
    </div>

    <div class="mt-8 sm:mx-auto sm:w-full sm:max-w-md">
      <div class="bg-white py-8 px-4 shadow sm:rounded-lg sm:px-10">
        <!-- Loading state -->
        <div v-if="isLoading" class="flex flex-col items-center justify-center py-6">
          <svg class="animate-spin h-8 w-8 text-gray-400 mb-4" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
          </svg>
          <p class="text-gray-500">Vérification en cours...</p>
        </div>

        <!-- Error state -->
        <div v-else-if="error" class="bg-red-50 p-4 rounded-md text-red-700 mb-6">
          <div class="flex">
            <svg class="h-5 w-5 text-red-400 mr-3" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
            <p>{{ error }}</p>
          </div>
        </div>

        <!-- Success state -->
        <div v-else-if="isVerified" class="text-center">
          <div class="mx-auto flex items-center justify-center h-12 w-12 rounded-full bg-green-100 mb-4">
            <svg class="h-6 w-6 text-green-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
            </svg>
          </div>
          <h3 class="text-lg font-medium text-gray-900">Email vérifié avec succès</h3>
          <p class="mt-2 text-sm text-gray-500">
            Votre adresse email a été vérifiée. Vous pouvez maintenant vous connecter à votre compte.
          </p>
          <div class="mt-6">
            <NuxtLink 
              to="/auth/login" 
              class="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-black hover:bg-gray-800 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-black"
            >
              Se connecter
            </NuxtLink>
          </div>
        </div>

        <!-- Verification instructions -->
        <div v-else class="space-y-6">
          <div class="bg-gray-50 p-4 rounded-md">
            <div class="flex">
              <svg class="h-5 w-5 text-blue-400 mr-3" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
              <div>
                <p class="text-sm text-gray-700">
                  Nous avons envoyé un email de vérification à <strong>{{ email }}</strong>
                </p>
                <p class="text-sm text-gray-500 mt-1">
                  Cliquez sur le lien dans l'email pour vérifier votre compte.
                </p>
              </div>
            </div>
          </div>

          <div class="text-sm text-center">
            <p class="text-gray-600 mb-2">Vous n'avez pas reçu l'email ?</p>
            <button 
              @click="resendVerificationEmail" 
              class="font-medium text-black hover:text-gray-800 focus:outline-none"
              :disabled="isResending"
            >
              {{ isResending ? 'Envoi en cours...' : 'Renvoyer l\'email de vérification' }}
            </button>
          </div>

          <div class="pt-4 border-t border-gray-200">
            <NuxtLink 
              to="/auth/login" 
              class="text-sm font-medium text-black hover:text-gray-800 flex items-center justify-center"
            >
              <svg class="w-4 h-4 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18" />
              </svg>
              Retour à la connexion
            </NuxtLink>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { useSupabaseClient } from '#imports';

const supabase = useSupabaseClient();
const route = useRoute();
const router = useRouter();

// État
const isLoading = ref(true);
const isVerified = ref(false);
const isResending = ref(false);
const error = ref(null);
const email = ref('');

// Vérifier le token dans l'URL
const verifyToken = async () => {
  isLoading.value = true;
  error.value = null;
  
  const token = route.query.token;
  const type = route.query.type;
  
  if (!token || type !== 'signup') {
    isLoading.value = false;
    return;
  }
  
  try {
    // Vérifier le token avec Supabase
    const { error: verifyError } = await supabase.auth.verifyOtp({
      token,
      type: 'signup'
    });
    
    if (verifyError) throw verifyError;
    
    isVerified.value = true;
  } catch (err) {
    console.error('Error verifying email:', err);
    error.value = "Le lien de vérification est invalide ou a expiré.";
  } finally {
    isLoading.value = false;
  }
};

// Récupérer l'email depuis le localStorage
const getEmailFromStorage = () => {
  if (process.client) {
    const storedEmail = localStorage.getItem('verificationEmail');
    if (storedEmail) {
      email.value = storedEmail;
    }
  }
};

// Renvoyer l'email de vérification
const resendVerificationEmail = async () => {
  if (!email.value) {
    error.value = "Adresse email inconnue. Veuillez vous réinscrire.";
    return;
  }
  
  isResending.value = true;
  error.value = null;
  
  try {
    const { error: resendError } = await supabase.auth.resend({
      type: 'signup',
      email: email.value
    });
    
    if (resendError) throw resendError;
    
    // Afficher un message de succès temporaire
    error.value = null;
    alert("Un nouvel email de vérification a été envoyé. Veuillez vérifier votre boîte de réception.");
  } catch (err) {
    console.error('Error resending verification email:', err);
    error.value = "Impossible d'envoyer l'email de vérification. Veuillez réessayer.";
  } finally {
    isResending.value = false;
  }
};

// Initialisation
onMounted(() => {
  getEmailFromStorage();
  verifyToken();
});
</script> 