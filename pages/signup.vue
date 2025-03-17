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
          <!-- Status message -->
          <div v-if="statusMessage" 
            class="mb-6 p-3 rounded-full text-sm flex items-center"
            :class="statusType === 'error' ? 'bg-red-50 text-red-700' : 'bg-blue-50 text-blue-700'"
          >
            <span v-if="statusType === 'error'" class="mr-2">
              <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
            </span>
            <span v-else class="mr-2">
              <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
            </span>
            {{ statusMessage }}
          </div>
          
          <form @submit.prevent="handleSignup" class="space-y-5">
            <!-- Email input with floating label -->
            <div class="relative">
              <div class="floating-input-container">
                <input
                  id="email" 
                  v-model="email" 
                  type="email" 
                  required
                  class="floating-input rounded-full"
                  :class="{ 
                    'border-red-500': emailError, 
                    'has-value': email,
                    'border-green-500 pr-10': emailValid && email
                  }"
                  @input="validateEmail"
                />
                <label for="email" class="floating-label">Email</label>
                <div v-if="emailValid && email" class="absolute right-3 top-1/2 -translate-y-1/2 text-green-500">
                  <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                  </svg>
                </div>
              </div>
              <p v-if="emailError" class="mt-1.5 text-sm text-red-600 flex items-center">
                <svg class="h-4 w-4 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
                </svg>
                {{ emailError }}
              </p>
            </div>
            
            <!-- Nom et prénom côte à côte -->
            <div class="grid grid-cols-2 gap-3">
              <div class="relative">
                <div class="floating-input-container">
                  <input
                    id="firstName" 
                    v-model="firstName" 
                    type="text" 
                    required
                    class="floating-input rounded-full"
                    :class="{ 'has-value': firstName }"
                  />
                  <label for="firstName" class="floating-label">Prénom</label>
                </div>
              </div>
              <div class="relative">
                <div class="floating-input-container">
                  <input
                    id="lastName" 
                    v-model="lastName" 
                    type="text" 
                    required
                    class="floating-input rounded-full"
                    :class="{ 'has-value': lastName }"
                  />
                  <label for="lastName" class="floating-label">Nom</label>
                </div>
              </div>
            </div>
            
            <!-- Mot de passe -->
            <div class="relative">
              <div class="floating-input-container">
                <input
                  id="password" 
                  v-model="password" 
                  :type="showPassword ? 'text' : 'password'" 
                  required 
                  class="floating-input rounded-full pr-10"
                  :class="{ 
                    'border-red-500': passwordError, 
                    'has-value': password,
                    'border-green-500': passwordStrength >= 3
                  }"
                />
                <label for="password" class="floating-label">Mot de passe</label>
                <button 
                  type="button"
                  @click="showPassword = !showPassword"
                  class="absolute right-3 top-1/2 -translate-y-1/2 text-gray-500 hover:text-gray-700"
                >
                  <svg v-if="showPassword" class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                  </svg>
                  <svg v-else class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M17.94 17.94A10.07 10.07 0 0112 20c-7 0-11-8-11-8a18.45 18.45 0 015.06-5.94M9.9 4.24A9.12 9.12 0 0112 4c7 0 11 8 11 8a18.5 18.5 0 01-2.16 3.19m-6.72-1.07a3 3 0 11-4.24-4.24" />
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M1 1l22 22" />
                  </svg>
                </button>
              </div>
              <div v-if="password" class="mt-2">
                <div class="flex items-center space-x-1">
                  <div class="h-1 flex-1 rounded-full" :class="passwordStrength >= 1 ? 'bg-red-500' : 'bg-gray-200'"></div>
                  <div class="h-1 flex-1 rounded-full" :class="passwordStrength >= 2 ? 'bg-yellow-500' : 'bg-gray-200'"></div>
                  <div class="h-1 flex-1 rounded-full" :class="passwordStrength >= 3 ? 'bg-green-500' : 'bg-gray-200'"></div>
                </div>
                <p class="text-xs mt-1 text-gray-500">
                  {{ passwordStrengthText }}
                </p>
                <p v-if="passwordError" class="text-xs mt-1 text-red-600">
                  {{ passwordError }}
                </p>
                <!-- Password criteria checklist -->
                <div class="mt-2 text-xs space-y-1">
                  <div class="flex items-center" :class="password.length >= 8 ? 'text-green-500' : 'text-gray-500'">
                    <svg class="w-4 h-4 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" 
                        :d="password.length >= 8 ? 'M5 13l4 4L19 7' : 'M6 18L18 6M6 6l12 12'" />
                    </svg>
                    Minimum 8 caractères
                  </div>
                  <div class="flex items-center" :class="/[A-Z]/.test(password) && /[a-z]/.test(password) ? 'text-green-500' : 'text-gray-500'">
                    <svg class="w-4 h-4 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" 
                        :d="/[A-Z]/.test(password) && /[a-z]/.test(password) ? 'M5 13l4 4L19 7' : 'M6 18L18 6M6 6l12 12'" />
                    </svg>
                    Majuscules et minuscules
                  </div>
                  <div class="flex items-center" :class="/[0-9]/.test(password) ? 'text-green-500' : 'text-gray-500'">
                    <svg class="w-4 h-4 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" 
                        :d="/[0-9]/.test(password) ? 'M5 13l4 4L19 7' : 'M6 18L18 6M6 6l12 12'" />
                    </svg>
                    Au moins un chiffre
                  </div>
                </div>
              </div>
            </div>
            
            <!-- Numéro de téléphone (optionnel) -->
            <div class="relative">
              <div class="floating-input-container">
                <input
                  id="phone" 
                  v-model="phone" 
                  type="tel" 
                  class="floating-input rounded-full"
                  :class="{ 'has-value': phone }"
                />
                <label for="phone" class="floating-label">Téléphone (optionnel)</label>
              </div>
            </div>
            
            <!-- Localisation -->
            <div class="relative">
              <div class="floating-input-container">
                <input
                  id="location" 
                  v-model="location" 
                  type="text" 
                  class="floating-input rounded-full"
                  :class="{ 'has-value': location }"
                />
                <label for="location" class="floating-label">Localisation</label>
              </div>
            </div>
            
            <!-- Type de compte -->
            <div>
              <label class="text-sm font-medium text-gray-700 mb-2 block">Type de compte</label>
              <div class="flex items-center space-x-4 mt-2">
                <button 
                  type="button"
                  @click="accountType = 'client'"
                  class="flex-1 py-2.5 px-3 rounded-full border transition-colors flex items-center justify-center"
                  :class="accountType === 'client' ? 'bg-primary-50 text-primary-700 border-primary-200 font-medium' : 'border-gray-300 text-gray-700 hover:bg-gray-50'"
                >
                  <svg class="w-4 h-4 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                  </svg>
                  Client
                </button>
                <button 
                  type="button"
                  @click="accountType = 'expert'"
                  class="flex-1 py-2.5 px-3 rounded-full border transition-colors flex items-center justify-center"
                  :class="accountType === 'expert' ? 'bg-primary-50 text-primary-700 border-primary-200 font-medium' : 'border-gray-300 text-gray-700 hover:bg-gray-50'"
                >
                  <svg class="w-4 h-4 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                  </svg>
                  Expert
                </button>
              </div>
            </div>
            
            <!-- Compétences (pour les experts) -->
            <div v-if="accountType === 'expert'" class="animate-fade-in">
              <label class="text-sm font-medium text-gray-700 mb-2 block">Vos compétences</label>
              
              <!-- Selected skills -->
              <div v-if="selectedSkills.length > 0" class="flex flex-wrap gap-2 mb-3">
                <div 
                  v-for="skill in selectedSkills" 
                  :key="skill.id"
                  class="bg-primary-50 text-primary-700 rounded-full px-3 py-1 text-sm flex items-center"
                >
                  {{ skill.name }}
                  <button 
                    @click="removeSkill(skill.id)" 
                    class="ml-1.5 text-primary-500 hover:text-primary-700"
                  >
                    <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                    </svg>
                  </button>
                </div>
              </div>
              
              <!-- Skills dropdown -->
              <div class="relative" data-skills-dropdown>
                <div class="floating-input-container">
                  <input
                    id="skillSearch"
                    v-model="skillSearchQuery"
                    type="text"
                    class="floating-input rounded-full pr-10"
                    :class="{ 
                      'has-value': skillSearchQuery,
                      'border-red-500': skillsError
                    }"
                    @focus="showSkillsDropdown = true"
                    @keydown.enter.prevent
                    placeholder="Rechercher des compétences"
                  />
                  <label for="skillSearch" class="floating-label">Rechercher une compétence</label>
                  <button 
                    type="button"
                    @click="showSkillsDropdown = !showSkillsDropdown"
                    class="absolute right-3 top-1/2 -translate-y-1/2 text-gray-500"
                  >
                    <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
                    </svg>
                  </button>
                </div>
                
                <div v-if="showSkillsDropdown" class="absolute z-10 mt-1 w-full bg-white rounded-lg shadow-lg border border-gray-200 max-h-60 overflow-y-auto">
                  <div v-if="filteredSkills.length === 0" class="px-4 py-3 text-sm text-gray-500">
                    Aucune compétence trouvée
                  </div>
                  <div v-else>
                    <div
                      v-for="skill in filteredSkills"
                      :key="skill.id"
                      @click="addSkill(skill)"
                      class="px-4 py-2 hover:bg-gray-50 cursor-pointer text-sm flex items-center justify-between"
                    >
                      <span>{{ skill.name }}</span>
                      <span v-if="isSkillSelected(skill.id)" class="text-primary-600">
                        <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                        </svg>
                      </span>
                    </div>
                  </div>
                </div>
                
                <p v-if="skillsError" class="mt-1.5 text-sm text-red-600">
                  {{ skillsError }}
                </p>
              </div>
            </div>
            
            <!-- Bio (pour les experts) -->
            <div v-if="accountType === 'expert'" class="animate-fade-in">
              <div class="floating-input-container">
                <textarea
                  id="bio"
                  v-model="bio"
                  rows="3"
                  class="w-full p-4 border border-gray-300 rounded-3xl resize-none transition-colors"
                  :class="{ 'has-value': bio }"
                  placeholder="Décrivez votre expérience professionnelle..."
                ></textarea>
                <div class="flex justify-between text-xs text-gray-500 mt-1 px-3">
                  <span>Visible sur votre profil</span>
                  <span>{{ bio.length }}/500</span>
                </div>
              </div>
            </div>
            
            <!-- Bouton de soumission -->
            <div>
              <button
                type="submit"
                class="w-full flex justify-center py-3 px-4 border border-transparent rounded-full shadow-sm text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 font-medium transition-colors"
                :class="{ 'opacity-70 cursor-not-allowed': isLoading }"
                :disabled="isLoading"
              >
                <svg v-if="isLoading" class="animate-spin -ml-1 mr-2 h-4 w-4 text-white" fill="none" viewBox="0 0 24 24">
                  <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                  <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                </svg>
                {{ isLoading ? 'Création du compte...' : 'Créer un compte' }}
              </button>
            </div>
            
            <!-- Séparateur ou -->
            <div class="relative mt-6">
              <div class="absolute inset-0 flex items-center">
                <div class="w-full border-t border-gray-300"></div>
              </div>
              <div class="relative flex justify-center text-sm">
                <span class="px-2 bg-white text-gray-500">Ou</span>
              </div>
            </div>
            
            <!-- Connexion avec Google -->
            <div>
              <button
                type="button"
                @click="handleGoogleSignup"
                class="w-full flex justify-center items-center py-2.5 px-4 border border-gray-300 rounded-full shadow-sm bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 font-medium transition-colors"
              >
                <svg class="h-5 w-5 mr-2" viewBox="0 0 24 24" width="24" height="24">
                  <path fill="#EA4335" d="M5.26620003,9.76452941 C6.19878754,6.93863203 8.85444915,4.90909091 12,4.90909091 C13.6909091,4.90909091 15.2181818,5.50909091 16.4181818,6.49090909 L19.9090909,3 C17.7818182,1.14545455 15.0545455,0 12,0 C7.27006974,0 3.1977497,2.69829785 1.23999023,6.65002441 L5.26620003,9.76452941 Z"/>
                  <path fill="#34A853" d="M16.0407269,18.0125889 C14.9509167,18.7163016 13.5660892,19.0909091 12,19.0909091 C8.86648613,19.0909091 6.21911939,17.076871 5.27698177,14.2678769 L1.23746264,17.3349879 C3.19279051,21.2936293 7.26500293,24 12,24 C14.9328362,24 17.7353462,22.9573905 19.834192,20.9995801 L16.0407269,18.0125889 Z"/>
                  <path fill="#4A90E2" d="M19.834192,20.9995801 C22.0291676,18.9520994 23.4545455,15.903663 23.4545455,12 C23.4545455,11.2909091 23.3454545,10.5272727 23.1818182,9.81818182 L12,9.81818182 L12,14.4545455 L18.4363636,14.4545455 C18.1187732,16.013626 17.2662994,17.2212117 16.0407269,18.0125889 L19.834192,20.9995801 Z"/>
                  <path fill="#FBBC05" d="M5.27698177,14.2678769 C5.03832634,13.556323 4.90909091,12.7937589 4.90909091,12 C4.90909091,11.2182781 5.03443647,10.4668121 5.26620003,9.76452941 L1.23999023,6.65002441 C0.43658717,8.26043162 0,10.0753848 0,12 C0,13.9195484 0.444780743,15.7301709 1.23746264,17.3349879 L5.27698177,14.2678769 Z"/>
                </svg>
                Continuer avec Google
              </button>
            </div>
            
            <!-- Lien vers la connexion -->
            <div class="text-center mt-4">
              <p class="text-sm text-gray-600">
                Vous avez déjà un compte?
                <nuxt-link to="/login" class="text-primary-600 hover:text-primary-500 font-medium">
                  Se connecter
                </nuxt-link>
              </p>
            </div>
          </form>
        </div>
      </div>
    </div>
  </template>
  
  <script setup>
  import { ref, computed, onMounted, onBeforeUnmount } from 'vue';
  import { useRouter } from 'vue-router';
  // import { supabase } from '@/lib/supabaseClient';
  
  const router = useRouter();
  
  // Form data
  const email = ref('');
  const firstName = ref('');
  const lastName = ref('');
  const password = ref('');
  const phone = ref('');
  const location = ref('');
  const bio = ref('');
  const accountType = ref('client');
  const showPassword = ref(false);
  
  // Skills
  const allSkills = ref([]);
  const selectedSkills = ref([]);
  const skillSearchQuery = ref('');
  const showSkillsDropdown = ref(false);
  
  // Form state
  const isLoading = ref(false);
  const emailError = ref('');
  const passwordError = ref('');
  const skillsError = ref('');
  const emailValid = ref(false);
  const statusMessage = ref('');
  const statusType = ref('info');
  const supabase = useSupabaseClient();
  // Password
  const passwordStrength = computed(() => {
    if (!password.value) return 0;
    
    let strength = 0;
    
    // Length
    if (password.value.length >= 8) strength++;
    
    // Complexity
    if (/[A-Z]/.test(password.value) && /[a-z]/.test(password.value)) strength++;
    if (/[0-9]/.test(password.value) || /[^A-Za-z0-9]/.test(password.value)) strength++;
    
    return strength;
  });
  
  const passwordStrengthText = computed(() => {
    if (!password.value) return '';
    
    switch (passwordStrength.value) {
      case 1: return 'Faible';
      case 2: return 'Moyen';
      case 3: return 'Fort';
      default: return 'Trop court';
    }
  });
  
  // Form validation
  const isFormValid = computed(() => {
    // Basic validation
    if (!email.value || !firstName.value || !lastName.value || !password.value) {
      return false;
    }
    
    // Email validation
    if (!emailValid.value) {
      return false;
    }
    
    // Password validation
    if (password.value.length < 8 || passwordStrength.value < 2) {
      return false;
    }
    
    // Expert validation
    if (accountType.value === 'expert' && selectedSkills.value.length === 0) {
      return false;
    }
    
    return true;
  });
  
  // Filtered skills based on search
  const filteredSkills = computed(() => {
    if (!skillSearchQuery.value) return allSkills.value;
    
    const query = skillSearchQuery.value.toLowerCase();
    return allSkills.value.filter(skill => 
      skill.name.toLowerCase().includes(query)
    );
  });
  
  // Fetch skills from database
  const fetchSkills = async () => {
    try {
      const { data, error } = await supabase
        .from('skills')
        .select('id, name, category_id')
        .order('name');
        
      if (error) throw error;
      
      allSkills.value = data || [];
    } catch (error) {
      console.error('Error fetching skills:', error);
    }
  };
  
  // Email validation
  const validateEmail = () => {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    
    if (!email.value) {
      emailError.value = '';
      emailValid.value = false;
      return;
    }
    
    if (!emailRegex.test(email.value)) {
      emailError.value = 'Format d\'email invalide';
      emailValid.value = false;
      return;
    }
    
    // Check if email already exists
    checkEmailExists();
  };
  
  // Check if email already exists in database
  const checkEmailExists = async () => {
    if (!email.value) return;
    
    try {
      const { data, error } = await supabase
        .from('profiles')
        .select('id')
        .eq('email', email.value)
        .maybeSingle();
        
      if (error) throw error;
      
      if (data) {
        emailError.value = 'Cet email est déjà utilisé';
        emailValid.value = false;
      } else {
        emailError.value = '';
        emailValid.value = true;
      }
    } catch (error) {
      console.error('Error checking email:', error);
    }
  };
  
  // Skills management
  const addSkill = (skill) => {
    if (!selectedSkills.value.some(s => s.id === skill.id)) {
      selectedSkills.value.push(skill);
      skillsError.value = '';
    }
  };
  
  const removeSkill = (skillId) => {
    selectedSkills.value = selectedSkills.value.filter(s => s.id !== skillId);
  };
  
  const isSkillSelected = (skillId) => {
    return selectedSkills.value.some(s => s.id === skillId);
  };
  
  // Status message
  const showStatus = (message, type = 'info') => {
    statusMessage.value = message;
    statusType.value = type;
    
    // Hide after 5 seconds
    setTimeout(() => {
      statusMessage.value = '';
    }, 5000);
  };
  
  // Gestion de l'inscription
  const handleSignup = async () => {
    if (!isFormValid.value) {
      // Check specific validation errors
      if (password.value.length < 8) {
        passwordError.value = 'Le mot de passe doit contenir au moins 8 caractères';
      }
      
      if (accountType.value === 'expert' && selectedSkills.value.length === 0) {
        skillsError.value = 'Sélectionnez au moins une compétence';
      }
      
      return;
    }
    
    isLoading.value = true;
    
    try {
      // Register with Supabase auth
      const { data, error } = await supabase.auth.signUp({
        email: email.value,
        password: password.value,
      });
      
      if (error) throw error;
      
      // Create profile in profiles table
      if (data?.user) {
        const { error: profileError } = await supabase
          .from('profiles')
          .insert({
            id: data.user.id,
            first_name: firstName.value,
            last_name: lastName.value,
            email: email.value,
            phone: phone.value || null,
            bio: bio.value || null,
            role: accountType.value,
            is_expert: accountType.value === 'expert'
          });
        
        if (profileError) {
          console.error('Error creating profile:', profileError);
          throw profileError;
        }
        
        // For experts, add skills to user_skills table
        if (accountType.value === 'expert' && selectedSkills.value.length > 0) {
          const skillInserts = selectedSkills.value.map(skill => ({
            user_id: data.user.id,
            skill_id: skill.id
          }));
          
          const { error: skillsError } = await supabase
            .from('user_skills')
            .insert(skillInserts);
            
          if (skillsError) {
            console.error('Error adding skills:', skillsError);
            // We don't throw here to avoid blocking the signup process
          }
        }
      }
      
      // Show success
      showStatus("Compte créé avec succès! Vérifiez votre email pour confirmer.", 'success');
      
      // Redirect to verification page after delay
      setTimeout(() => {
        router.push('/verify-email?email=' + encodeURIComponent(email.value));
      }, 2000);
      
    } catch (error) {
      console.error('Registration error:', error);
      showStatus(error.message || "Erreur lors de l'inscription", 'error');
    } finally {
      isLoading.value = false;
    }
  };
  
  // Google signup
  const handleGoogleSignup = async () => {
    try {
      const { error } = await supabase.auth.signInWithOAuth({
        provider: 'google',
        options: {
          redirectTo: `${window.location.origin}/auth-callback`
        }
      });
      
      if (error) throw error;
    } catch (error) {
      console.error('Google signup error:', error);
      showStatus(error.message || "Erreur lors de l'inscription avec Google", 'error');
    }
  };
  
  // Click outside handler
  const handleClickOutside = (event) => {
    if (showSkillsDropdown.value && !event.target.closest('[data-skills-dropdown]')) {
      showSkillsDropdown.value = false;
    }
  };
  
  // Lifecycle hooks
  onMounted(() => {
    document.addEventListener('click', handleClickOutside);
    
    // Fetch skills when component mounts
    fetchSkills();
  });
  
  onBeforeUnmount(() => {
    document.removeEventListener('click', handleClickOutside);
  });
  </script>
  
  <style scoped>
  /* Facebook-style floating labels inside inputs */
  .floating-input-container {
    position: relative;
  }
  
  .floating-input {
    width: 100%;
    padding: 1.25rem 1.25rem 0.5rem;
    height: 3.5rem;
    border-width: 1px;
    border-color: rgb(209, 213, 219);
    border-radius: 9999px;
    color: rgb(17, 24, 39);
    appearance: none;
    transition: border-color 0.2s ease-in-out, box-shadow 0.2s ease-in-out;
  }
  
  .floating-input:focus {
    outline: none;
    border-color: rgb(79, 70, 229);
    box-shadow: 0 0 0 1px rgb(79, 70, 229);
  }
  
  .floating-label {
    position: absolute;
    top: 50%;
    left: 1.25rem;
    transform: translateY(-50%);
    color: rgb(107, 114, 128);
    pointer-events: none;
    transform-origin: left top;
    transition: all 0.2s ease;
  }
  
  .floating-input:focus + .floating-label,
  .floating-input.has-value + .floating-label {
    top: 0.7rem;
    transform: translateY(0) scale(0.75);
    color: rgb(79, 70, 229);
  }
  
  .animate-fade-in {
    animation: fadeIn 0.2s ease-out;
  }
  
  @keyframes fadeIn {
    from { opacity: 0; transform: translateY(8px); }
    to { opacity: 1; transform: translateY(0); }
  }
  </style>