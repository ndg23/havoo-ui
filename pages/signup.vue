<template>
    <div class="min-h-screen bg-white flex">
      <!-- Panneau latéral visuel - présent uniquement sur grands écrans -->
      
      
      <!-- Formulaire d'inscription -->
      <div class="w-full lg:w-1/2 flex mx-auto flex-col justify-center p-6 sm:p-12">
        <div class="sm:mx-auto sm:w-full sm:max-w-md">
          <!-- Logo mobile uniquement -->
          <div class="flex justify-center lg:hidden mb-6">
            <div class="w-12 h-12 rounded-full bg-primary-100 flex items-center justify-center">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-primary-600" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M12 2L2 7l10 5 10-5-10-5z"></path>
                <path d="M2 17l10 5 10-5"></path>
                <path d="M2 12l10 5 10-5"></path>
              </svg>
            </div>
          </div>
          
          <h2 class="text-2xl font-bold text-gray-900">Créer un compte</h2>
          <p class="mt-2 text-sm text-gray-600">
            Remplissez les informations ci-dessous
          </p>
        </div>
  
        <div class="mt-8 sm:mx-auto sm:w-full sm:max-w-md">
          <form @submit.prevent="handleSignup" class="space-y-5">
            <!-- Email input -->
            <div>
              <input 
                id="email" 
                v-model="email" 
                type="email" 
                required 
                class="block w-full px-4 py-3 border border-gray-300 rounded-full placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                placeholder="Email"
              />
            </div>
            
            <!-- Nom et prénom côte à côte -->
            <div class="grid grid-cols-2 gap-3">
              <div>
                <input 
                  id="firstName" 
                  v-model="firstName" 
                  type="text" 
                  required 
                  class="block w-full px-4 py-3 border border-gray-300 rounded-full placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                  placeholder="Prénom"
                />
              </div>
              <div>
                <input 
                  id="lastName" 
                  v-model="lastName" 
                  type="text" 
                  required 
                  class="block w-full px-4 py-3 border border-gray-300 rounded-full placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                  placeholder="Nom"
                />
              </div>
            </div>
            
            <!-- Mot de passe -->
            <div>
              <input 
                id="password" 
                v-model="password" 
                type="password" 
                required 
                class="block w-full px-4 py-3 border border-gray-300 rounded-full placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                placeholder="Mot de passe (8 caractères min)"
              />
              <div v-if="password" class="mt-2">
                <div class="flex items-center space-x-1">
                  <div class="h-1 flex-1 rounded-full" :class="passwordStrength >= 1 ? 'bg-red-500' : 'bg-gray-200'"></div>
                  <div class="h-1 flex-1 rounded-full" :class="passwordStrength >= 2 ? 'bg-yellow-500' : 'bg-gray-200'"></div>
                  <div class="h-1 flex-1 rounded-full" :class="passwordStrength >= 3 ? 'bg-green-500' : 'bg-gray-200'"></div>
                </div>
                <p class="text-xs mt-1 text-gray-500">
                  {{ passwordStrengthText }}
                </p>
              </div>
            </div>
            
            <!-- Type de compte - style Twitter radio pills -->
            <div>
              <p class="text-sm font-medium text-gray-700 mb-2">Type de compte</p>
              <div class="flex bg-gray-100 rounded-full p-1 w-full">
                <label class="relative flex-1 flex items-center justify-center cursor-pointer"
                  :class="accountType === 'client' ? 'bg-white rounded-full shadow-sm text-primary-700' : 'text-gray-500'"
                >
                  <input 
                    type="radio" 
                    name="accountType" 
                    value="client" 
                    v-model="accountType" 
                    class="sr-only"
                  />
                  <span class="py-2 px-4 text-sm font-medium w-full text-center">Client</span>
                </label>
                <label class="relative flex-1 flex items-center justify-center cursor-pointer"
                  :class="accountType === 'expert' ? 'bg-white rounded-full shadow-sm text-primary-700' : 'text-gray-500'"
                >
                  <input 
                    type="radio" 
                    name="accountType" 
                    value="expert" 
                    v-model="accountType" 
                    class="sr-only"
                  />
                  <span class="py-2 px-4 text-sm font-medium w-full text-center">Expert</span>
                </label>
              </div>
            </div>
            
            <!-- Localisation (optionnel) -->
            <div>
              <input 
                id="location" 
                v-model="location" 
                type="text" 
                class="block w-full px-4 py-3 border border-gray-300 rounded-full placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                placeholder="Localisation (optionnel)"
              />
            </div>
            
            <!-- Conditions d'utilisation -->
            <div class="flex items-start">
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
            
            <!-- Bouton d'inscription large style Twitter -->
            <div>
              <button 
                type="submit" 
                class="w-full flex justify-center py-3 px-4 border border-transparent rounded-full text-base font-medium text-white bg-black hover:bg-gray-800 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-black transition-colors"
                :disabled="isLoading || !isFormValid"
              >
                <span v-if="isLoading" class="flex items-center">
                  <svg class="animate-spin -ml-1 mr-2 h-4 w-4 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                    <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                    <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                  </svg>
                  Création en cours...
                </span>
                <span v-else>Créer mon compte</span>
              </button>
            </div>
          </form>
  
          <!-- Séparateur -->
          <div class="mt-6">
            <div class="relative">
              <div class="absolute inset-0 flex items-center">
                <div class="w-full border-t border-gray-200"></div>
              </div>
              <div class="relative flex justify-center text-sm">
                <span class="px-2 bg-white text-gray-500">
                  ou
                </span>
              </div>
            </div>
          </div>
  
          <!-- Bouton social avec style Twitter -->
          <div class="mt-6">
            <button
              type="button"
              @click="handleGoogleSignup"
              class="w-full inline-flex justify-center py-3 px-4 border border-gray-300 rounded-full shadow-sm bg-white text-sm font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 transition-colors"
            >
              <svg class="w-5 h-5 mr-2" viewBox="0 0 24 24" fill="currentColor">
                <path d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z" fill="#4285F4"/>
                <path d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z" fill="#34A853"/>
                <path d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z" fill="#FBBC05"/>
                <path d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z" fill="#EA4335"/>
              </svg>
              Continuer avec Google
            </button>
          </div>
          
          <!-- Lien vers connexion -->
          <div class="mt-6 text-center">
            <p class="text-sm text-gray-600">
              Vous avez déjà un compte ? 
              <NuxtLink to="/login" class="font-medium text-primary-600 hover:underline">
                Se connecter
              </NuxtLink>
            </p>
          </div>
        </div>
      </div>
    </div>
  </template>
  
  <script setup>
  import { ref, computed } from 'vue';
  
  // État du formulaire
  const email = ref('');
  const firstName = ref('');
  const lastName = ref('');
  const password = ref('');
  const accountType = ref('client');
  const location = ref('');
  const acceptTerms = ref(false);
  const isLoading = ref(false);
  
  // Validation du mot de passe
  const passwordStrength = computed(() => {
    if (!password.value) return 0;
    
    let strength = 0;
    
    // Longueur minimale
    if (password.value.length >= 8) strength += 1;
    
    // Complexité (lettres, chiffres, caractères spéciaux)
    if (/[A-Z]/.test(password.value) && /[a-z]/.test(password.value)) strength += 1;
    if (/[0-9]/.test(password.value) && /[^A-Za-z0-9]/.test(password.value)) strength += 1;
    
    return strength;
  });
  
  const passwordStrengthText = computed(() => {
    if (!password.value) return '';
    if (passwordStrength.value === 0) return 'Mot de passe trop court';
    if (passwordStrength.value === 1) return 'Mot de passe faible';
    if (passwordStrength.value === 2) return 'Mot de passe moyen';
    return 'Mot de passe fort';
  });
  
  // Validation du formulaire
  const isFormValid = computed(() => {
    return (
      email.value && 
      firstName.value && 
      lastName.value && 
      password.value && 
      password.value.length >= 8 && 
      acceptTerms.value
    );
  });
  
  // Gestion de l'inscription
  const handleSignup = async () => {
    if (!isFormValid.value) {
      return;
    }
    
    isLoading.value = true;
    
    try {
      // Sauvegarde de l'email pour la page de confirmation
      localStorage.setItem('signupEmail', email.value);
      localStorage.setItem('accountType', accountType.value);
      
      // Construction du nom complet à partir du prénom et du nom
      const fullName = `${firstName.value} ${lastName.value}`;
      
      // Simulation d'une requête d'inscription
      await new Promise(resolve => setTimeout(resolve, 1500));
      
      // Ici, vous implémenteriez l'appel API pour créer le compte
      // const response = await createUser({
      //   email: email.value,
      //   firstName: firstName.value,
      //   lastName: lastName.value,
      //   password: password.value,
      //   isExpert: accountType.value === 'expert',
      //   location: location.value || null
      // });
      
      // Redirection vers la page de confirmation ou de complétion de profil
      navigateTo('/signup/confirm');
    } catch (error) {
      console.error('Erreur lors de l\'inscription:', error);
      // Gérer l'erreur (afficher un message, etc.)
    } finally {
      isLoading.value = false;
    }
  };
  
  // Gestion de l'inscription avec Google
  const handleGoogleSignup = async () => {
    try {
      isLoading.value = true;
      
      // Ici, vous implémenteriez l'authentification via Google
      // const response = await signInWithGoogle();
      
      // Simulation d'une authentification Google réussie
      await new Promise(resolve => setTimeout(resolve, 1500));
      
      // Stockage temporaire des informations de l'utilisateur Google
      // Dans une implémentation réelle, ces données viendraient de la réponse de l'API Google
      const googleUserData = {
        email: 'utilisateur@gmail.com',
        firstName: 'Prénom',
        lastName: 'Nom',
        avatar: 'https://example.com/avatar.jpg'
      };
      
      // Stockage des données de l'utilisateur Google dans le localStorage
      localStorage.setItem('googleUserData', JSON.stringify(googleUserData));
      
      // Redirection vers la page de sélection de rôle
      navigateTo('/signup/select-role');
    } catch (error) {
      console.error('Erreur lors de l\'inscription avec Google:', error);
      // Gérer l'erreur (afficher un message, etc.)
    } finally {
      isLoading.value = false;
    }
  };
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