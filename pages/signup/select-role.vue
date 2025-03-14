<template>
  <div class="min-h-screen bg-white flex flex-col justify-center py-12 px-4 sm:px-6 lg:px-8">
    <div class="max-w-md mx-auto w-full">
      <div class="bg-white py-8 px-6 shadow-sm border border-gray-100 rounded-2xl">
        <!-- En-tête avec avatar et informations de l'utilisateur -->
        <div class="flex items-center mb-6">
          <div class="flex-shrink-0">
            <img v-if="userData.avatar" :src="userData.avatar" alt="Avatar" class="h-12 w-12 rounded-full" />
            <div v-else class="h-12 w-12 rounded-full bg-primary-100 flex items-center justify-center">
              <span class="text-primary-600 font-medium text-lg">{{ userInitials }}</span>
            </div>
          </div>
          <div class="ml-4">
            <h2 class="text-lg font-medium text-gray-900">
              Bienvenue, {{ userData.firstName }}
            </h2>
            <p class="text-sm text-gray-500">
              {{ userData.email }}
            </p>
          </div>
        </div>
        
        <!-- Titre et description -->
        <h3 class="text-xl font-bold text-gray-900 mb-2">
          Choisissez votre type de compte
        </h3>
        <p class="text-gray-600 mb-6">
          Pour finaliser votre inscription, veuillez sélectionner le type de compte que vous souhaitez créer.
        </p>
        
        <!-- Sélection du type de compte -->
        <div class="space-y-4 mb-6">
          <div 
            @click="selectAccountType('client')" 
            class="border rounded-xl p-4 cursor-pointer transition-all"
            :class="accountType === 'client' ? 'border-primary-500 bg-primary-50' : 'border-gray-200 hover:border-gray-300'"
          >
            <div class="flex items-start">
              <div class="flex-shrink-0">
                <div class="h-10 w-10 rounded-full bg-primary-100 flex items-center justify-center">
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-primary-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                  </svg>
                </div>
              </div>
              <div class="ml-3">
                <h4 class="text-base font-medium text-gray-900">Client</h4>
                <p class="mt-1 text-sm text-gray-500">
                  Je souhaite publier des demandes et trouver des experts pour m'aider.
                </p>
              </div>
              <div class="ml-auto">
                <div class="h-5 w-5 rounded-full border-2 flex items-center justify-center"
                  :class="accountType === 'client' ? 'border-primary-500' : 'border-gray-300'"
                >
                  <div v-if="accountType === 'client'" class="h-3 w-3 rounded-full bg-primary-500"></div>
                </div>
              </div>
            </div>
          </div>
          
          <div 
            @click="selectAccountType('expert')" 
            class="border rounded-xl p-4 cursor-pointer transition-all"
            :class="accountType === 'expert' ? 'border-primary-500 bg-primary-50' : 'border-gray-200 hover:border-gray-300'"
          >
            <div class="flex items-start">
              <div class="flex-shrink-0">
                <div class="h-10 w-10 rounded-full bg-primary-100 flex items-center justify-center">
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-primary-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                  </svg>
                </div>
              </div>
              <div class="ml-3">
                <h4 class="text-base font-medium text-gray-900">Expert</h4>
                <p class="mt-1 text-sm text-gray-500">
                  Je souhaite proposer mes services et répondre à des demandes.
                </p>
              </div>
              <div class="ml-auto">
                <div class="h-5 w-5 rounded-full border-2 flex items-center justify-center"
                  :class="accountType === 'expert' ? 'border-primary-500' : 'border-gray-300'"
                >
                  <div v-if="accountType === 'expert'" class="h-3 w-3 rounded-full bg-primary-500"></div>
                </div>
              </div>
            </div>
          </div>
        </div>
        
        <!-- Localisation (optionnel) -->
        <div class="mb-6">
          <label for="location" class="block text-sm font-medium text-gray-700 mb-1">
            Localisation (optionnel)
          </label>
          <input 
            id="location" 
            v-model="location" 
            type="text" 
            class="block w-full px-4 py-3 border border-gray-300 rounded-full placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-transparent"
            placeholder="Ville, Pays"
          />
        </div>
        
        <!-- Conditions d'utilisation -->
        <div class="flex items-start mb-6">
          <div class="flex items-center h-5">
            <input 
              id="terms" 
              v-model="acceptTerms" 
              type="checkbox" 
              required 
              class="h-4 w-4 text-primary-600 focus:ring-primary-500 border-gray-300 rounded"
            />
          </div>
          <div class="ml-3 text-sm">
            <label for="terms" class="text-gray-700">
              J'accepte les <a href="#" class="text-primary-600 font-medium hover:underline">conditions d'utilisation</a> et la <a href="#" class="text-primary-600 font-medium hover:underline">politique de confidentialité</a>
            </label>
          </div>
        </div>
        
        <!-- Bouton de confirmation -->
        <div>
          <button 
            @click="completeSignup" 
            class="w-full flex justify-center py-3 px-4 border border-transparent rounded-full text-base font-medium text-white bg-black hover:bg-gray-800 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-black transition-colors"
            :disabled="isLoading || !isFormValid"
          >
            <span v-if="isLoading" class="flex items-center">
              <svg class="animate-spin -ml-1 mr-2 h-4 w-4 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
              </svg>
              Finalisation en cours...
            </span>
            <span v-else>Finaliser mon inscription</span>
          </button>
        </div>
        
        <!-- Lien pour utiliser un autre compte -->
        <div class="mt-6 text-center">
          <button 
            @click="useAnotherAccount" 
            class="text-sm font-medium text-primary-600 hover:underline"
          >
            Utiliser un autre compte
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';

// État du formulaire
const userData = ref({
  email: '',
  firstName: '',
  lastName: '',
  avatar: ''
});
const accountType = ref('client');
const location = ref('');
const acceptTerms = ref(false);
const isLoading = ref(false);

// Récupération des initiales de l'utilisateur
const userInitials = computed(() => {
  if (!userData.value.firstName || !userData.value.lastName) return '';
  return `${userData.value.firstName.charAt(0)}${userData.value.lastName.charAt(0)}`;
});

// Validation du formulaire
const isFormValid = computed(() => {
  return accountType.value && acceptTerms.value;
});

// Sélection du type de compte
const selectAccountType = (type) => {
  accountType.value = type;
};

// Finalisation de l'inscription
const completeSignup = async () => {
  if (!isFormValid.value) {
    return;
  }
  
  isLoading.value = true;
  
  try {
    // Sauvegarde des informations pour la page de confirmation
    localStorage.setItem('signupEmail', userData.value.email);
    localStorage.setItem('accountType', accountType.value);
    
    // Simulation d'une requête d'inscription
    await new Promise(resolve => setTimeout(resolve, 1500));
    
    // Ici, vous implémenteriez l'appel API pour créer le compte
    // const response = await createUserWithGoogle({
    //   email: userData.value.email,
    //   firstName: userData.value.firstName,
    //   lastName: userData.value.lastName,
    //   isExpert: accountType.value === 'expert',
    //   location: location.value || null,
    //   googleId: userData.value.googleId // Si disponible dans la réponse de Google
    // });
    
    // Redirection vers la page de confirmation
    navigateTo('/signup/confirm');
  } catch (error) {
    console.error('Erreur lors de la finalisation de l\'inscription:', error);
    // Gérer l'erreur (afficher un message, etc.)
  } finally {
    isLoading.value = false;
  }
};

// Utiliser un autre compte
const useAnotherAccount = () => {
  // Supprimer les données temporaires
  localStorage.removeItem('googleUserData');
  
  // Rediriger vers la page d'inscription
  navigateTo('/signup');
};

// Initialisation des données utilisateur
onMounted(() => {
  // Récupération des données de l'utilisateur Google depuis le localStorage
  const storedUserData = localStorage.getItem('googleUserData');
  
  if (storedUserData) {
    userData.value = JSON.parse(storedUserData);
  } else {
    // Si aucune donnée n'est trouvée, rediriger vers la page d'inscription
    navigateTo('/signup');
  }
});
</script>

<style scoped>
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
</style> 