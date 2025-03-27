<template>
    <div class="min-h-[60vh] bg-white dark:bg-gray-900 flex flex-col justify-center px-4 sm:px-6 lg:px-8">
      <div class="sm:mx-auto sm:w-full sm:max-w-md">
        <!-- Logo ou icône (optionnel) -->
      
        
        <h1 class="text-center text-3xl mt-8 font-bold tracking-tight text-gray-900 dark:text-white">
          {{ currentStep === 1 ? 'Créer votre compte' : 'Complétez votre profil' }}
        </h1>
        
        <!-- Indicateur d'étape -->
        <div class="flex justify-center my-2 space-x-2">
          <div 
            class="w-2.5 h-2.5 rounded-full transition-colors"
            :class="currentStep >= 1 ? 'bg-primary-600 dark:bg-primary-400' : 'bg-gray-300 dark:bg-gray-700'"
          ></div>
          <div 
            class="w-2.5 h-2.5 rounded-full transition-colors"
            :class="currentStep >= 2 ? 'bg-primary-600 dark:bg-primary-400' : 'bg-gray-300 dark:bg-gray-700'"
          ></div>
        </div>
      </div>
  
      <div class="mt-4 sm:mx-auto sm:w-full sm:max-w-md">
        <!-- Message d'erreur -->
        <div v-if="errorMessage" class="mb-6 bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800/40 text-red-600 dark:text-red-400 rounded-lg p-3 text-sm">
          {{ errorMessage }}
        </div>
        
        <!-- Étape 1: Informations de base -->
        <div v-if="currentStep === 1" class="animate-fade-in">
          <!-- Boutons sociaux -->
          <div class="space-y-3">
            <button
              @click="socialSignup('google')"
              type="button"
              class="flex w-full justify-center items-center gap-3 rounded-full border border-gray-300 dark:border-gray-700 bg-white dark:bg-gray-800 px-6 py-3.5 text-base font-medium text-gray-700 dark:text-gray-300 -shadow-sm hover:bg-gray-50 dark:hover:bg-gray-700 focus:outline-none focus:ring-2 focus:ring-primary-500 focus:ring-offset-2 transition-colors"
            >
              <svg class="w-5 h-5" viewBox="0 0 24 24" fill="currentColor">
                <path d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z" fill="#4285F4"/>
                <path d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z" fill="#34A853"/>
                <path d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z" fill="#FBBC05"/>
                <path d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z" fill="#EA4335"/>
              </svg>
              Continuer avec Google
            </button>
          </div>
  
          <div class="relative my-6">
            <div class="absolute inset-0 flex items-center">
              <div class="w-full border-t border-gray-200 dark:border-gray-700"></div>
            </div>
            <div class="relative flex justify-center">
              <span class="bg-white dark:bg-gray-900 px-4 text-sm text-gray-500 dark:text-gray-400">ou</span>
            </div>
          </div>
  
          <!-- Formulaire étape 1 -->
          <form @submit.prevent="goToStep2" class="space-y-5">
            <FloatingLabelInput
              id="email"
              v-model="form.email"
              label="Email"
  
              placeholder="Email"
              type="email"
              required
            />
            
            <div class="relative">
              <FloatingLabelInput
                id="password"
                v-model="form.password"
                label="Mot de passe"
  
                placeholder="Mot de passe"
                :type="showPassword ? 'text' : 'password'"
                required
              />
              <button 
                type="button" 
                @click="showPassword = !showPassword" 
                class="absolute inset-y-0 right-0 pr-3 flex items-center text-gray-400 dark:text-gray-500 hover:text-gray-500 dark:hover:text-gray-400"
              >
                <svg v-if="showPassword" xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.88 9.88l-3.29-3.29m7.532 7.532l3.29 3.29M3 3l3.59 3.59m0 0A9.953 9.953 0 0112 5c4.478 0 8.268 2.943 9.543 7a10.025 10.025 0 01-4.132 5.411m0 0L21 21" />
                </svg>
                <svg v-else xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                </svg>
              </button>
            </div>
            
            <div class="text-sm">
              <p class="text-gray-500 dark:text-gray-400">
                En vous inscrivant, vous acceptez nos 
                <NuxtLink to="/terms" class="font-medium text-primary-600 dark:text-primary-400 hover:text-primary-500">
                  conditions d'utilisation
                </NuxtLink>
                et notre
                <NuxtLink to="/privacy" class="font-medium text-primary-600 dark:text-primary-400 hover:text-primary-500">
                  politique de confidentialité
                </NuxtLink>.
              </p>
            </div>
            
            <div>
              <button 
                type="submit" 
                class="w-full flex justify-center py-3 px-4 border border-transparent rounded-full text-base font-medium text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 transition-colors"
                :disabled="isLoading"
              >
                <span v-if="isLoading" class="flex items-center">
                  <svg class="animate-spin -ml-1 mr-2 h-4 w-4 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                    <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                    <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                  </svg>
                  Chargement...
                </span>
                <span v-else>Continuer</span>
              </button>
            </div>
          </form>
        </div>
        
        <!-- Étape 2: Informations complémentaires -->
        <div v-else-if="currentStep === 2" class="animate-fade-in">
          <form @submit.prevent="handleSignup" class="space-y-5">
            <div class="grid grid-cols-2 gap-4">
              <FloatingLabelInput
                id="firstName"
                v-model="form.firstName"
                placeholder="Prénom"
                label="Prénom"
  
                required
              />
              
              <FloatingLabelInput
                id="lastName"
                v-model="form.lastName"
                placeholder="Nom"
                label="Nom"
  
                required
              />
            </div>
            
            <FloatingLabelInput
              id="phone"
              v-model="form.phone"
              placeholder="Téléphone"
              label="Téléphone"
  
              type="tel"
            />
            
            <!-- Type de compte -->
            <div class="space-y-3">
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300">
                Je suis un :
              </label>
              <div class="grid grid-cols-2 gap-4">
                <button 
                  type="button"
                  @click="form.role = 'client'"
                  class="p-4 border rounded-xl text-center transition-colors"
                  :class="form.role === 'client' 
                    ? 'bg-primary-50 dark:bg-primary-900/20 border-primary-200 dark:border-primary-800/40 text-primary-700 dark:text-primary-300' 
                    : 'border-gray-200 dark:border-gray-700 text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-800'"
                >
                  <div class="flex flex-col items-center">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 mb-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                    </svg>
                    <span class="font-medium">Client</span>
                    <span class="text-xs mt-1 text-gray-500 dark:text-gray-400">Je cherche des experts</span>
                  </div>
                </button>
                
                <button 
                  type="button"
                  @click="form.role = 'expert'"
                  class="p-4 border rounded-xl text-center transition-colors"
                  :class="form.role === 'expert' 
                    ? 'bg-primary-50 dark:bg-primary-900/20 border-primary-200 dark:border-primary-800/40 text-primary-700 dark:text-primary-300' 
                    : 'border-gray-200 dark:border-gray-700 text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-800'"
                >
                  <div class="flex flex-col items-center">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 mb-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                    </svg>
                    <span class="font-medium">Expert</span>
                    <span class="text-xs mt-1 text-gray-500 dark:text-gray-400">Je propose mes services</span>
                  </div>
                </button>
              </div>
            </div>
            
            <div class="flex items-center space-x-4">
              <button 
                type="button" 
                @click="currentStep = 1"
                class="flex-1 py-3 px-4 border border-gray-300 dark:border-gray-700 rounded-full text-base font-medium text-gray-700 dark:text-gray-300 bg-white dark:bg-gray-800 hover:bg-gray-50 dark:hover:bg-gray-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-gray-500 transition-colors"
              >
                Retour
              </button>
              
              <button 
                type="submit" 
                class="flex-1 py-3 px-4 border border-transparent rounded-full text-base font-medium text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 transition-colors"
                :disabled="isLoading"
              >
                <span v-if="isLoading" class="flex items-center justify-center">
                  <svg class="animate-spin -ml-1 mr-2 h-4 w-4 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                    <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                    <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                  </svg>
                  Chargement...
                </span>
                <span v-else>Terminer</span>
              </button>
            </div>
          </form>
        </div>
        
        <!-- Lien vers connexion -->
        <div class="mt-6 text-center">
          <p class="text-sm text-gray-600 dark:text-gray-400">
            Vous avez déjà un compte ? 
            <NuxtLink to="/auth/login" class="font-medium text-primary-600 dark:text-primary-400 hover:text-primary-500">
              Se connecter
            </NuxtLink>
          </p>
        </div>
      </div>
    </div>
  </template>
  
  <script setup>
  import { ref, reactive, onMounted, onUnmounted } from 'vue';
  import { useRouter, useRoute } from 'vue-router';
  import { useSupabaseClient } from '#imports';
  import FloatingLabelInput from '~/components/ui/FloatingLabelInput.vue';
  // Services
  const router = useRouter();
  const supabase = useSupabaseClient();
  const route = useRoute();
  
  // État global
  const state = reactive({
    isLoading: false,
    currentStep: 1,
    error: null,
    networkStatus: true
  });
  
  // Gestionnaire d'erreurs global
  const handleError = (error, context = '') => {
    console.error(`Erreur ${context}:`, error);
    
    // Messages d'erreur génériques pour la sécurité
    const genericErrors = {
      'auth/user-not-found': 'Identifiants invalides',
      'auth/wrong-password': 'Identifiants invalides',
      'auth/email-already-in-use': 'Cet email n\'est pas disponible',
      default: 'Une erreur est survenue. Veuillez réessayer.'
    };
  
    state.error = genericErrors[error.code] || genericErrors.default;
    state.isLoading = false;
  };
  
  // Réinitialisation des erreurs entre les étapes
  const resetErrors = () => {
    state.error = null;
    Object.keys(validationErrors).forEach(key => {
      validationErrors[key] = '';
    });
  };
  
  // Gestionnaire de perte de connexion
  onMounted(() => {
    window.addEventListener('online', () => state.networkStatus = true);
    window.addEventListener('offline', () => state.networkStatus = false);
  });
  
  onUnmounted(() => {
    window.removeEventListener('online', () => state.networkStatus = true);
    window.removeEventListener('offline', () => state.networkStatus = false);
  });
  
  // État du formulaire avec valeurs par défaut
  const form = reactive({
    email: '',
    password: '',
    firstName: '',
    lastName: '',
    phone: '',
    role: 'client'
  });
  
  // Ajout de la détection de l'étape dans l'URL et de la session
  const currentStep = ref(parseInt(route.query.step) || 1);
  const isOAuthUser = ref(false);
  
  // Initialisation du formulaire avec les données de session si disponibles
  onMounted(async () => {
    try {
      const { data: { session } } = await supabase.auth.getSession();
      
      if (session?.user) {
        isOAuthUser.value = true;
        form.email = session.user.email;
        
        // Pré-remplir avec les métadonnées disponibles
        if (session.user.user_metadata) {
          form.firstName = session.user.user_metadata.first_name || '';
          form.lastName = session.user.user_metadata.last_name || '';
        }
        
        // Si on arrive du callback OAuth, aller directement à l'étape 2
        if (route.query.step === '2') {
          currentStep.value = 2;
        }
      }
    } catch (error) {
      console.error('Erreur lors de la récupération de la session:', error);
    }
  });
  
  // État de l'interface
  const isLoading = ref(false);
  const showPassword = ref(false);
  const errorMessage = ref('');
  
  // Vérification de l'email et gestion des cas existants
  const validateEmail = async () => {
    try {
      // 1. Vérifier si l'email existe dans profiles
      const { data: profile, error: profileError } = await supabase
        .from('profiles')
        .select('id')
        .eq('email', form.email.toLowerCase())
        .single();
  
      // Si un profil existe déjà
      if (!profileError && profile) {
        errorMessage.value = 'Cet email est déjà utilisé. Redirection vers la connexion...';
        setTimeout(() => {
          router.push(`/auth/login?email=${encodeURIComponent(form.email)}`);
        }, 2000);
        return false;
      }
  
      // 2. Tenter de se connecter avec les identifiants fournis
      const { data: signInData, error: signInError } = await supabase.auth.signInWithPassword({
        email: form.email,
        password: form.password
      });
  
      // Si la connexion réussit mais qu'il n'y a pas de profil
      if (!signInError && signInData.user) {
        // L'utilisateur existe dans auth mais pas de profil
        // On peut directement passer à l'étape 2 pour créer son profil
        currentStep.value = 2;
        return true;
      }
  
      // Si erreur de connexion, vérifier si l'utilisateur existe
      if (signInError) {
        // Vérifier si l'email existe dans auth sans créer d'utilisateur
        const { data: userExists, error: checkError } = await supabase.auth.signInWithOtp({
          email: form.email,
          options: {
            shouldCreateUser: false
          }
        });
  
        // Si l'utilisateur existe mais mauvais mot de passe
        if (!checkError) {
          const result = await useDialog({
            title: 'Compte existant',
            message: 'Un compte existe déjà avec cet email. Que souhaitez-vous faire ?',
            options: [
              { value: 'login', label: 'Me connecter', primary: true },
              { value: 'reset', label: 'Réinitialiser mon mot de passe' },
              { value: 'new', label: 'Utiliser un autre email' }
            ]
          });
  
          switch (result) {
            case 'login':
              router.push(`/auth/login?email=${encodeURIComponent(form.email)}`);
              return false;
            case 'reset':
              router.push(`/auth/reset-password?email=${encodeURIComponent(form.email)}`);
              return false;
            case 'new':
              form.email = '';
              form.password = '';
              return false;
          }
        }
      }
  
      // Si l'email n'existe pas du tout, on peut créer un nouveau compte
      return true;
  
    } catch (error) {
      console.error('Erreur lors de la vérification de l\'email:', error);
      errorMessage.value = 'Une erreur est survenue lors de la vérification de l\'email';
      return false;
    }
  };
  
  // Validation du mot de passe
  const validatePassword = () => {
    if (!form.password) {
      errorMessage.value = 'Le mot de passe est requis';
      return false;
    } else if (form.password.length < 6) {
      errorMessage.value = 'Le mot de passe doit contenir au moins 6 caractères';
      return false;
    }
    return true;
  };
  
  // Modification de goToStep2 pour gérer les utilisateurs OAuth
  const goToStep2 = async () => {
    errorMessage.value = '';
    
    // Pour les utilisateurs OAuth, passer directement à l'étape 2
    if (isOAuthUser.value) {
      currentStep.value = 2;
      return;
    }
    
    // Validation des champs pour les nouveaux utilisateurs
    if (!validatePassword()) {
      return;
    }
    
    isLoading.value = true;
    
    try {
      const canProceed = await validateEmail();
      if (!canProceed) {
        isLoading.value = false;
        return;
      }
      currentStep.value = 2;
    } catch (error) {
      console.error('Erreur:', error);
      errorMessage.value = 'Une erreur est survenue. Veuillez réessayer.';
    } finally {
      isLoading.value = false;
    }
  };
  
  // Utilitaire pour la gestion des URLs
  const buildRedirectUrl = (baseUrl, params = {}) => {
    const url = new URL(baseUrl, window.location.origin);
    Object.entries(params).forEach(([key, value]) => {
      url.searchParams.append(key, value);
    });
    return url.toString();
  };
  
  // Inscription avec un fournisseur social
  const socialSignup = async (provider) => {
    try {
      state.isLoading = true;
      
      const redirectUrl = buildRedirectUrl('/auth/callback', {
        signup: 'true',
        next: encodeURIComponent(window.location.pathname)
      });
  
      const { error } = await supabase.auth.signInWithOAuth({
        provider,
        options: {
          redirectTo: redirectUrl
        }
      });
      
      if (error) throw error;
    } catch (error) {
      handleError(error, 'social-signup');
    }
  };
  
  // Modification de handleSignup pour gérer les deux cas
  const handleSignup = async () => {
    try {
      isLoading.value = true;
      errorMessage.value = '';
  
      let user;
      let avatarUrl;
  
      // Si c'est une connexion Google
      const { data: { session } } = await supabase.auth.getSession();
      if (session?.provider === 'google') {
        user = session.user;
        avatarUrl = user.user_metadata.avatar_url || user.user_metadata.picture;
      } else {
        // Création normale du compte
        const { data: authData, error: signUpError } = await supabase.auth.signUp({
          email: form.email,
          password: form.password,
          options: {
            data: {
              first_name: form.firstName,
              last_name: form.lastName
            }
          }
        });
  
        if (signUpError) throw signUpError;
        user = authData.user;
      }
  
      // Créer le profil avec la photo si disponible
      const { error: profileError } = await supabase
        .from('profiles')
        .insert({
          id: user.id,
          first_name: form.firstName,
          last_name: form.lastName,
          email: form.email,
          phone: form.phone,
          role: form.role,
          is_expert: form.role === 'expert',
          avatar_url: avatarUrl || '/icons/avatar.svg'
        });
  
      if (profileError) throw profileError;
  
      // Gérer la redirection selon le rôle
      if (form.role === 'expert') {
        const { error: verificationError } = await supabase
          .rpc('create_verification_for_user', {
            user_id: user.id
          });
  
        if (verificationError) throw verificationError;
        router.push('/auth/expert-onboarding');
      } else {
        router.push('/auth/confirm-email?email=' + encodeURIComponent(form.email));
      }
  
    } catch (error) {
      console.error('Erreur lors de l\'inscription:', error);
      errorMessage.value = error.message;
    } finally {
      isLoading.value = false;
    }
  };
  
  // Composant de dialogue personnalisé (composition function)
  const useDialog = (options) => {
    return new Promise((resolve) => {
      const dialog = createApp({
        setup() {
          const isOpen = ref(true);
          const close = (value) => {
            isOpen.value = false;
            setTimeout(() => {
              dialog.unmount();
              resolve(value);
            }, 300);
          };
  
          return () => h(Dialog, {
            ...options,
            isOpen: isOpen.value,
            onClose: () => close(null)
          });
        }
      });
  
      const container = document.createElement('div');
      document.body.appendChild(container);
      dialog.mount(container);
    });
  };
  
  
  </script>
  <style scoped>
  /* Animation de transition entre les étapes */
  @keyframes fadeIn {
    from { opacity: 0; transform: translateY(10px); }
    to { opacity: 1; transform: translateY(0); }
  }
  
  .animate-fade-in {
    animation: fadeIn 0.3s ease-out forwards;
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
  </style>
  