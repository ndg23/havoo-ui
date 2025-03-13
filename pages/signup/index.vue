<template>
    <div class="min-h-screen flex flex-col bg-white dark:bg-black">
      <!-- Éléments visuels d'arrière-plan (visibles uniquement sur desktop) -->
      <div class="fixed inset-0 z-0 hidden lg:block">
        <div class="absolute inset-0 bg-gradient-to-br from-primary-500/10 to-primary-700/20 dark:from-primary-900/20 dark:to-primary-800/10 z-0"></div>
        <div class="absolute left-0 top-0 w-1/2 h-1/2 bg-primary-50 dark:bg-primary-950 rounded-br-[120px] opacity-30 dark:opacity-20 z-0"></div>
        <div class="absolute right-0 bottom-0 w-1/2 h-1/2 bg-primary-50 dark:bg-primary-950 rounded-tl-[120px] opacity-30 dark:opacity-20 z-0"></div>
      </div>
      
      <!-- Contenu principal -->
      <div class="relative z-10 flex-1 flex flex-col justify-center px-6 py-12 lg:px-8 max-w-md mx-auto w-full">
        <!-- Bouton de retour (visible uniquement sur étapes > 1) -->
        <div v-if="currentStep > 0" class="absolute top-8 left-6">
          <button 
            @click="goToPreviousStep"
            class="p-2 -m-2 rounded-full hover:bg-gray-100 dark:hover:bg-gray-800 transition-colors inline-flex items-center text-gray-500 dark:text-gray-400"
          >
            <ArrowLeft class="h-5 w-5" />
            <span class="ml-1 text-sm font-medium">Retour</span>
          </button>
        </div>
        
        <!-- Logo -->
        <div class="mb-8">
          <Logo class="h-14 w-auto mx-auto" />
        </div>
        
        <!-- Titre et description -->
        <h1 class="text-4xl font-bold tracking-tight text-center text-gray-900 dark:text-white mb-2">
          {{ currentStep === 0 ? 'Créer un compte' : steps[currentStep].name }}
        </h1>
        <p class="text-center text-gray-600 dark:text-gray-400 mb-8">
          {{ currentStep === 0 ? 'Rejoignez notre communauté en quelques étapes' : `Étape ${currentStep + 1} sur ${steps.length}` }}
        </p>
        
        <!-- Indicateur d'étape -->
        <div class="mb-10">
          <div class="flex items-center justify-between">
            <div 
              v-for="(step, index) in steps" 
              :key="index" 
              class="flex flex-col items-center"
              :class="{'cursor-pointer': currentStep > index}"
              @click="currentStep > index ? currentStep = index : null"
            >
              <div 
                class="w-9 h-9 rounded-full flex items-center justify-center text-sm font-medium mb-1.5 transition-all duration-300"
                :class="[
                  currentStep > index 
                    ? 'bg-primary-600 text-white shadow-lg shadow-primary-600/30' 
                    : currentStep === index 
                      ? 'bg-primary-100 dark:bg-primary-900/30 text-primary-600 dark:text-primary-400 border-2 border-primary-600 dark:border-primary-500' 
                      : 'bg-gray-100 dark:bg-gray-800 text-gray-500 dark:text-gray-400'
                ]"
              >
                <Check v-if="currentStep > index" class="h-4 w-4" />
                <span v-else>{{ index + 1 }}</span>
              </div>
              <div class="text-xs text-gray-500 dark:text-gray-400">{{ step.name }}</div>
            </div>
            
            <!-- Connecteurs entre les étapes -->
            <div 
              v-for="index in steps.length - 1" 
              :key="`connector-${index}`" 
              class="flex-1 h-1 mx-2 transition-all duration-300"
              :class="[
                currentStep > index 
                  ? 'bg-primary-600 dark:bg-primary-500' 
                  : 'bg-gray-200 dark:bg-gray-700'
              ]"
            ></div>
          </div>
        </div>
        
        <!-- Notification d'erreur générale -->
        <div 
          v-if="hasStepError" 
          class="mb-6 p-4 bg-red-50 dark:bg-red-900/20 border-l-4 border-red-500 text-sm text-red-700 dark:text-red-400 animate-slideIn"
        >
          Veuillez corriger les erreurs ci-dessous avant de continuer
        </div>
        
        <!-- Étape 1: Informations de base -->
        <div v-if="currentStep === 0" class="space-y-5 animate-fadeIn">
          <!-- Type de compte -->
          <div class="space-y-2">
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300">Type de compte</label>
            <div class="grid grid-cols-2 gap-3">
              <button
                type="button"
                @click="userData.accountType = 'client'"
                class="flex flex-col items-center justify-center p-4 border rounded-xl transition-all duration-200"
                :class="userData.accountType === 'client' 
                  ? 'border-primary-600 bg-primary-50 dark:bg-primary-900/30 shadow-md' 
                  : 'border-gray-300 dark:border-gray-700 hover:border-primary-400 dark:hover:border-primary-600'"
              >
                <User class="h-6 w-6 mb-2 text-primary-600 dark:text-primary-400" />
                <span class="text-sm font-medium">Client</span>
                <span class="text-xs text-gray-500 dark:text-gray-400 mt-1">Je cherche un expert</span>
              </button>
              <button
                type="button"
                @click="userData.accountType = 'expert'"
                class="flex flex-col items-center justify-center p-4 border rounded-xl transition-all duration-200"
                :class="userData.accountType === 'expert' 
                  ? 'border-primary-600 bg-primary-50 dark:bg-primary-900/30 shadow-md' 
                  : 'border-gray-300 dark:border-gray-700 hover:border-primary-400 dark:hover:border-primary-600'"
              >
                <Briefcase class="h-6 w-6 mb-2 text-primary-600 dark:text-primary-400" />
                <span class="text-sm font-medium">Expert</span>
                <span class="text-xs text-gray-500 dark:text-gray-400 mt-1">J'offre mes services</span>
              </button>
            </div>
          </div>
          
          <!-- Email -->
          <div class="space-y-2">
            <label for="email" class="block text-sm font-medium text-gray-700 dark:text-gray-300">
              Adresse email
            </label>
            <input
              id="email"
              v-model="userData.email"
              type="email"
              autocomplete="email"
              required
              class="w-full px-4 py-3 border rounded-xl bg-white dark:bg-gray-800 text-gray-900 dark:text-white transition-all duration-200"
              :class="errors.email 
                ? 'border-red-500 dark:border-red-500 focus:ring-red-500 focus:border-red-500' 
                : 'border-gray-300 dark:border-gray-700 focus:ring-primary-500 focus:border-primary-500'"
            />
            <p v-if="errors.email" class="mt-1 text-sm text-red-600 dark:text-red-500">
              {{ errors.email }}
            </p>
          </div>
          
          <!-- Mot de passe -->
          <div class="space-y-2">
            <label for="password" class="block text-sm font-medium text-gray-700 dark:text-gray-300">
              Mot de passe
            </label>
            <div class="relative">
              <input
                id="password"
                v-model="userData.password"
                :type="showPassword ? 'text' : 'password'"
                autocomplete="new-password"
                required
                class="w-full px-4 py-3 border rounded-xl bg-white dark:bg-gray-800 text-gray-900 dark:text-white transition-all duration-200"
                :class="errors.password 
                  ? 'border-red-500 dark:border-red-500 focus:ring-red-500 focus:border-red-500' 
                  : 'border-gray-300 dark:border-gray-700 focus:ring-primary-500 focus:border-primary-500'"
              />
              <button
                type="button"
                @click="showPassword = !showPassword"
                class="absolute inset-y-0 right-0 pr-4 flex items-center text-gray-400 hover:text-gray-600 dark:hover:text-gray-300"
              >
                <Eye v-if="showPassword" class="h-5 w-5" />
                <EyeOff v-else class="h-5 w-5" />
              </button>
            </div>
            <p v-if="errors.password" class="mt-1 text-sm text-red-600 dark:text-red-500">
              {{ errors.password }}
            </p>
            <div v-else class="mt-1 flex items-center gap-2 text-xs">
              <div 
                class="h-1 flex-1 rounded-full" 
                :class="passwordStrength >= 1 ? 'bg-red-500' : 'bg-gray-200 dark:bg-gray-700'"
              ></div>
              <div 
                class="h-1 flex-1 rounded-full" 
                :class="passwordStrength >= 2 ? 'bg-yellow-500' : 'bg-gray-200 dark:bg-gray-700'"
              ></div>
              <div 
                class="h-1 flex-1 rounded-full" 
                :class="passwordStrength >= 3 ? 'bg-green-500' : 'bg-gray-200 dark:bg-gray-700'"
              ></div>
              <div class="text-gray-500 dark:text-gray-400">{{ passwordStrengthText }}</div>
            </div>
          </div>
        </div>
        
        <!-- Étape 2: Informations personnelles -->
        <div v-if="currentStep === 1" class="space-y-5 animate-fadeIn">
          <!-- Prénom -->
          <div class="space-y-2">
            <label for="firstName" class="block text-sm font-medium text-gray-700 dark:text-gray-300">
              Prénom
            </label>
            <input
              id="firstName"
              v-model="userData.firstName"
              type="text"
              required
              class="w-full px-4 py-3 border rounded-xl bg-white dark:bg-gray-800 text-gray-900 dark:text-white transition-all duration-200"
              :class="errors.firstName 
                ? 'border-red-500 dark:border-red-500 focus:ring-red-500 focus:border-red-500' 
                : 'border-gray-300 dark:border-gray-700 focus:ring-primary-500 focus:border-primary-500'"
            />
            <p v-if="errors.firstName" class="mt-1 text-sm text-red-600 dark:text-red-500">
              {{ errors.firstName }}
            </p>
          </div>
          
          <!-- Nom -->
          <div class="space-y-2">
            <label for="lastName" class="block text-sm font-medium text-gray-700 dark:text-gray-300">
              Nom
            </label>
            <input
              id="lastName"
              v-model="userData.lastName"
              type="text"
              required
              class="w-full px-4 py-3 border rounded-xl bg-white dark:bg-gray-800 text-gray-900 dark:text-white transition-all duration-200"
              :class="errors.lastName 
                ? 'border-red-500 dark:border-red-500 focus:ring-red-500 focus:border-red-500' 
                : 'border-gray-300 dark:border-gray-700 focus:ring-primary-500 focus:border-primary-500'"
            />
            <p v-if="errors.lastName" class="mt-1 text-sm text-red-600 dark:text-red-500">
              {{ errors.lastName }}
            </p>
          </div>
          
          <!-- Téléphone -->
          <div class="space-y-2">
            <label for="phone" class="block text-sm font-medium text-gray-700 dark:text-gray-300">
              Téléphone
            </label>
            <input
              id="phone"
              v-model="userData.phone"
              type="tel"
              class="w-full px-4 py-3 border rounded-xl bg-white dark:bg-gray-800 text-gray-900 dark:text-white transition-all duration-200"
              :class="errors.phone 
                ? 'border-red-500 dark:border-red-500 focus:ring-red-500 focus:border-red-500' 
                : 'border-gray-300 dark:border-gray-700 focus:ring-primary-500 focus:border-primary-500'"
            />
            <p v-if="errors.phone" class="mt-1 text-sm text-red-600 dark:text-red-500">
              {{ errors.phone }}
            </p>
          </div>
          
          <!-- Pays -->
          <div class="space-y-2">
            <label for="country" class="block text-sm font-medium text-gray-700 dark:text-gray-300">
              Pays
            </label>
            <select
              id="country"
              v-model="userData.country"
              class="w-full px-4 py-3 border rounded-xl bg-white dark:bg-gray-800 text-gray-900 dark:text-white transition-all duration-200"
              :class="errors.country 
                ? 'border-red-500 dark:border-red-500 focus:ring-red-500 focus:border-red-500' 
                : 'border-gray-300 dark:border-gray-700 focus:ring-primary-500 focus:border-primary-500'"
            >
              <option value="" disabled selected>Sélectionnez un pays</option>
              <option value="CI">Côte d'Ivoire</option>
              <option value="SN">Sénégal</option>
              <option value="CM">Cameroun</option>
              <option value="BJ">Bénin</option>
              <option value="BF">Burkina Faso</option>
              <option value="ML">Mali</option>
              <option value="TG">Togo</option>
              <option value="NE">Niger</option>
            </select>
            <p v-if="errors.country" class="mt-1 text-sm text-red-600 dark:text-red-500">
              {{ errors.country }}
            </p>
          </div>
        </div>
        
        <!-- Étape 3: Profil professionnel (pour les experts uniquement) -->
        <div v-if="currentStep === 2 && userData.accountType === 'expert'" class="space-y-5 animate-fadeIn">
          <!-- Spécialité -->
          <div class="space-y-2">
            <label for="specialty" class="block text-sm font-medium text-gray-700 dark:text-gray-300">
              Titre professionnel
            </label>
            <input
              id="specialty"
              v-model="userData.specialty"
              type="text"
              placeholder="Ex: Développeur Web Full Stack"
              class="w-full px-4 py-3 border rounded-xl bg-white dark:bg-gray-800 text-gray-900 dark:text-white transition-all duration-200"
              :class="errors.specialty 
                ? 'border-red-500 dark:border-red-500 focus:ring-red-500 focus:border-red-500' 
                : 'border-gray-300 dark:border-gray-700 focus:ring-primary-500 focus:border-primary-500'"
            />
            <p v-if="errors.specialty" class="mt-1 text-sm text-red-600 dark:text-red-500">
              {{ errors.specialty }}
            </p>
          </div>
          
          <!-- Années d'expérience -->
          <div class="space-y-2">
            <label for="experience" class="block text-sm font-medium text-gray-700 dark:text-gray-300">
              Années d'expérience
            </label>
            <select
              id="experience"
              v-model="userData.experience"
              class="w-full px-4 py-3 border rounded-xl bg-white dark:bg-gray-800 text-gray-900 dark:text-white transition-all duration-200"
              :class="errors.experience 
                ? 'border-red-500 dark:border-red-500 focus:ring-red-500 focus:border-red-500' 
                : 'border-gray-300 dark:border-gray-700 focus:ring-primary-500 focus:border-primary-500'"
            >
              <option value="" disabled selected>Sélectionnez une option</option>
              <option value="1">Moins de 1 an</option>
              <option value="2">1-2 ans</option>
              <option value="3">3-5 ans</option>
              <option value="5">5-10 ans</option>
              <option value="10">Plus de 10 ans</option>
            </select>
            <p v-if="errors.experience" class="mt-1 text-sm text-red-600 dark:text-red-500">
              {{ errors.experience }}
            </p>
          </div>
          
          <!-- Catégories -->
          <div class="space-y-2">
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300">
              Catégories de service <span class="text-gray-500 dark:text-gray-400">(max 3)</span>
            </label>
            <div class="grid grid-cols-2 gap-2">
              <button
                v-for="category in categories"
                :key="category.id"
                type="button"
                @click="toggleCategory(category.id)"
                class="flex items-center p-3 border rounded-xl text-sm text-left transition-all duration-200"
                :class="userData.categories.includes(category.id) 
                  ? 'border-primary-600 bg-primary-50 dark:bg-primary-900/30 shadow-md' 
                  : 'border-gray-300 dark:border-gray-700 hover:border-primary-400 dark:hover:border-primary-600'"
              >
                <div class="w-8 h-8 flex items-center justify-center rounded-lg bg-primary-100 dark:bg-primary-900/50 mr-2 text-primary-600 dark:text-primary-400">
                  <component :is="category.icon" class="h-4 w-4" />
                </div>
                <span>{{ category.name }}</span>
              </button>
            </div>
            <p v-if="errors.categories" class="mt-1 text-sm text-red-600 dark:text-red-500">
              {{ errors.categories }}
            </p>
          </div>
          
          <!-- Bio -->
          <div class="space-y-2">
            <label for="bio" class="block text-sm font-medium text-gray-700 dark:text-gray-300">
              Bio professionnelle
            </label>
            <textarea
              id="bio"
              v-model="userData.bio"
              rows="3"
              placeholder="Décrivez votre expérience et vos compétences..."
              class="w-full px-4 py-3 border rounded-xl bg-white dark:bg-gray-800 text-gray-900 dark:text-white transition-all duration-200"
              :class="errors.bio 
                ? 'border-red-500 dark:border-red-500 focus:ring-red-500 focus:border-red-500' 
                : 'border-gray-300 dark:border-gray-700 focus:ring-primary-500 focus:border-primary-500'"
            ></textarea>
            <p v-if="errors.bio" class="mt-1 text-sm text-red-600 dark:text-red-500">
              {{ errors.bio }}
            </p>
          </div>
        </div>
        
        <!-- Étape 3 pour les clients / Étape 4 pour les experts: Résumé -->
        <div v-if="(currentStep === 2 && userData.accountType === 'client') || currentStep === 3" class="space-y-6 animate-fadeIn">
          <div class="p-5 border border-gray-200 dark:border-gray-700 rounded-xl bg-gray-50 dark:bg-gray-800/50">
            <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-4">Récapitulatif</h3>
            
            <div class="space-y-4">
              <div class="flex justify-between items-center border-b border-gray-200 dark:border-gray-700 pb-2">
                <span class="text-sm text-gray-500 dark:text-gray-400">Type de compte</span>
                <span class="text-sm font-medium text-gray-900 dark:text-white">
                  {{ userData.accountType === 'client' ? 'Client' : 'Expert' }}
                </span>
              </div>
              
              <div class="flex justify-between items-center border-b border-gray-200 dark:border-gray-700 pb-2">
                <span class="text-sm text-gray-500 dark:text-gray-400">Email</span>
                <span class="text-sm font-medium text-gray-900 dark:text-white">{{ userData.email }}</span>
              </div>
              
              <div class="flex justify-between items-center border-b border-gray-200 dark:border-gray-700 pb-2">
                <span class="text-sm text-gray-500 dark:text-gray-400">Nom complet</span>
                <span class="text-sm font-medium text-gray-900 dark:text-white">
                  {{ userData.firstName }} {{ userData.lastName }}
                </span>
              </div>
              
              <div v-if="userData.phone" class="flex justify-between items-center border-b border-gray-200 dark:border-gray-700 pb-2">
                <span class="text-sm text-gray-500 dark:text-gray-400">Téléphone</span>
                <span class="text-sm font-medium text-gray-900 dark:text-white">{{ userData.phone }}</span>
              </div>
              
              <div class="flex justify-between items-center border-b border-gray-200 dark:border-gray-700 pb-2">
                <span class="text-sm text-gray-500 dark:text-gray-400">Pays</span>
                <span class="text-sm font-medium text-gray-900 dark:text-white">
                  {{ getCountryName(userData.country) }}
                </span>
              </div>
              
              <div v-if="userData.accountType === 'expert' && userData.specialty" class="flex justify-between items-center border-b border-gray-200 dark:border-gray-700 pb-2">
                <span class="text-sm text-gray-500 dark:text-gray-400">Spécialité</span>
                <span class="text-sm font-medium text-gray-900 dark:text-white">{{ userData.specialty }}</span>
              </div>
              
              <div v-if="userData.accountType === 'expert' && userData.experience" class="flex justify-between items-center border-b border-gray-200 dark:border-gray-700 pb-2">
                <span class="text-sm text-gray-500 dark:text-gray-400">Expérience</span>
                <span class="text-sm font-medium text-gray-900 dark:text-white">
                  {{ getExperienceText(userData.experience) }}
                </span>
              </div>
              
              <div v-if="userData.accountType === 'expert' && userData.categories.length > 0" class="border-b border-gray-200 dark:border-gray-700 pb-2">
                <span class="text-sm text-gray-500 dark:text-gray-400 block mb-2">Catégories</span>
                <div class="flex flex-wrap gap-2">
                  <span 
                    v-for="catId in userData.categories" 
                    :key="catId"
                    class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-primary-100 text-primary-800 dark:bg-primary-900/50 dark:text-primary-300"
                  >
                    {{ getCategoryName(catId) }}
                  </span>
                </div>
              </div>
            </div>
          </div>
          
          <!-- Conditions d'utilisation -->
          <div class="flex items-start">
            <div class="flex items-center h-5">
              <input
                id="terms"
                v-model="userData.acceptTerms"
                type="checkbox"
                class="h-4 w-4 text-primary-600 focus:ring-primary-500 border-gray-300 rounded"
              />
            </div>
            <div class="ml-3 text-sm">
              <label for="terms" class="text-gray-700 dark:text-gray-300">
                J'accepte les <a href="#" class="text-primary-600 hover:text-primary-500 dark:text-primary-400">conditions d'utilisation</a> et la <a href="#" class="text-primary-600 hover:text-primary-500 dark:text-primary-400">politique de confidentialité</a>
              </label>
              <p v-if="errors.acceptTerms" class="mt-1 text-sm text-red-600 dark:text-red-500">
                {{ errors.acceptTerms }}
              </p>
            </div>
          </div>
        </div>
        
        <!-- Boutons de navigation -->
        <div class="mt-8 flex justify-between gap-4">
          <button
            v-if="currentStep > 0"
            type="button"
            @click="goToPreviousStep"
            class="flex-1 py-3 px-4 border border-gray-300 dark:border-gray-700 rounded-xl shadow-sm text-base font-medium text-gray-700 dark:text-gray-200 bg-white dark:bg-gray-900 hover:bg-gray-50 dark:hover:bg-gray-800 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 transition-all duration-200"
          >
            Précédent
          </button>
          
          <button
            v-if="!isLastStep"
            type="button"
            @click="goToNextStep"
            class="flex-1 py-3 px-4 border border-transparent rounded-xl shadow-sm text-base font-medium text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 transition-all duration-200 transform hover:scale-[1.02]"
          >
            Suivant
          </button>
          
          <button
            v-else
            type="button"
            @click="submitSignup"
            :disabled="isSubmitting"
            class="flex-1 py-3 px-4 border border-transparent rounded-xl shadow-sm text-base font-medium text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 disabled:bg-primary-400 transition-all duration-200 transform hover:scale-[1.02]"
          >
            <div v-if="isSubmitting" class="flex items-center justify-center">
              <div class="h-4 w-4 border-2 border-white/30 border-t-white rounded-full animate-spin mr-1.5"></div>
              Création en cours...
            </div>
            <span v-else>Créer mon compte</span>
          </button>
        </div>
        
        <!-- Lien vers la connexion -->
        <div class="mt-6 text-center text-sm">
          <p class="text-gray-600 dark:text-gray-400">
            Déjà un compte ?
            <NuxtLink to="/login" class="font-medium text-primary-600 hover:text-primary-500 dark:text-primary-400">
              Se connecter
            </NuxtLink>
          </p>
        </div>
      </div>
    </div>
  </template>
  
  <script setup>
  import { ref, computed } from 'vue'
  import { useRouter } from 'vue-router'
  import { Check, Eye, EyeOff, User, Briefcase, Code, Palette, FileText, TrendingUp, Film, Briefcase as BriefcaseIcon, ArrowLeft } from 'lucide-vue-next'
  
  const router = useRouter()
  
  // Configuration des étapes
  const steps = [
    { name: 'Compte' },
    { name: 'Informations' },
    { name: 'Profession' },
    { name: 'Résumé' }
  ]
  
  // Catégories disponibles
  const categories = [
    { id: 1, name: 'Développement Web', icon: Code },
    { id: 2, name: 'Design Graphique', icon: Palette },
    { id: 3, name: 'Rédaction', icon: FileText },
    { id: 4, name: 'Marketing Digital', icon: TrendingUp },
    { id: 5, name: 'Audio & Vidéo', icon: Film },
    { id: 6, name: 'Business', icon: BriefcaseIcon }
  ]
  
  // Données de l'utilisateur
  const userData = ref({
    accountType: 'client',
    email: '',
    password: '',
    firstName: '',
    lastName: '',
    phone: '',
    country: '',
    specialty: '',
    experience: '',
    categories: [],
    bio: '',
    acceptTerms: false
  })
  
  // États du formulaire
  const currentStep = ref(0)
  const errors = ref({})
  const isSubmitting = ref(false)
  const showPassword = ref(false)
  
  // Calcul des valeurs dérivées
  const isLastStep = computed(() => {
    return userData.value.accountType === 'client' 
      ? currentStep.value === 2 
      : currentStep.value === 3
  })
  
  const hasStepError = computed(() => {
    return Object.keys(errors.value).length > 0
  })
  
  const passwordStrength = computed(() => {
    const password = userData.value.password
    if (!password) return 0
    
    let score = 0
    
    // Longueur minimale
    if (password.length >= 8) score++
    
    // Complexité
    if (/[A-Z]/.test(password) && /[a-z]/.test(password)) score++
    if (/[0-9]/.test(password)) score++
    if (/[^A-Za-z0-9]/.test(password)) score++
    
    return Math.min(3, score)
  })
  
  const passwordStrengthText = computed(() => {
    switch (passwordStrength.value) {
      case 0: return 'Trop court'
      case 1: return 'Faible'
      case 2: return 'Moyen'
      case 3: return 'Fort'
      default: return ''
    }
  })
  
  // Méthodes
  const validateCurrentStep = () => {
    errors.value = {}
    
    if (currentStep.value === 0) {
      // Validation étape 1
      if (!userData.value.email) {
        errors.value.email = 'L\'email est requis'
      } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(userData.value.email)) {
        errors.value.email = 'Format d\'email invalide'
      }
      
      if (!userData.value.password) {
        errors.value.password = 'Le mot de passe est requis'
      } else if (userData.value.password.length < 8) {
        errors.value.password = 'Le mot de passe doit contenir au moins 8 caractères'
      }
    } 
    else if (currentStep.value === 1) {
      // Validation étape 2
      if (!userData.value.firstName) {
        errors.value.firstName = 'Le prénom est requis'
      }
      
      if (!userData.value.lastName) {
        errors.value.lastName = 'Le nom est requis'
      }
      
      if (userData.value.phone && !/^[+\d\s-()]{8,20}$/.test(userData.value.phone)) {
        errors.value.phone = 'Format de téléphone invalide'
      }
      
      if (!userData.value.country) {
        errors.value.country = 'Le pays est requis'
      }
    } 
    else if (currentStep.value === 2 && userData.value.accountType === 'expert') {
      // Validation étape 3 (experts uniquement)
      if (!userData.value.specialty) {
        errors.value.specialty = 'Le titre professionnel est requis'
      }
      
      if (!userData.value.experience) {
        errors.value.experience = 'L\'expérience est requise'
      }
      
      if (userData.value.categories.length === 0) {
        errors.value.categories = 'Sélectionnez au moins une catégorie'
      } else if (userData.value.categories.length > 3) {
        errors.value.categories = 'Maximum 3 catégories autorisées'
      }
      
      if (!userData.value.bio || userData.value.bio.length < 10) {
        errors.value.bio = 'La bio doit contenir au moins 10 caractères'
      }
    }
    else if (isLastStep.value) {
      // Validation étape résumé
      if (!userData.value.acceptTerms) {
        errors.value.acceptTerms = 'Vous devez accepter les conditions d\'utilisation'
      }
    }
    
    return Object.keys(errors.value).length === 0
  }
  
  const goToNextStep = () => {
    if (validateCurrentStep()) {
      if (userData.value.accountType === 'client' && currentStep.value === 1) {
        // Pour les clients, on saute l'étape 3 (profil professionnel)
        currentStep.value = 2
      } else {
        currentStep.value++
      }
    }
  }
  
  const goToPreviousStep = () => {
    if (userData.value.accountType === 'client' && currentStep.value === 2) {
      // Pour les clients, on saute l'étape 3 (profil professionnel)
      currentStep.value = 1
    } else {
      currentStep.value--
    }
  }
  
  const toggleCategory = (categoryId) => {
    const index = userData.value.categories.indexOf(categoryId)
    if (index === -1) {
      if (userData.value.categories.length < 3) {
        userData.value.categories.push(categoryId)
      }
    } else {
      userData.value.categories.splice(index, 1)
    }
  }
  
  const getCategoryName = (categoryId) => {
    const category = categories.find(c => c.id === categoryId)
    return category ? category.name : ''
  }
  
  const getExperienceText = (years) => {
    const experienceMap = {
      '1': 'Moins de 1 an',
      '2': '1-2 ans',
      '3': '3-5 ans',
      '5': '5-10 ans',
      '10': 'Plus de 10 ans'
    }
    return experienceMap[years] || years
  }
  
  const getCountryName = (countryCode) => {
    const countryMap = {
      'CI': 'Côte d\'Ivoire',
      'SN': 'Sénégal',
      'CM': 'Cameroun',
    }
    return countryMap[countryCode] || countryCode
  }

// Catégories disponibles (à charger depuis l'API ou à définir ici)

// Définir le type de compte
const setAccountType = (type) => {
  userData.accountType = type
}

// Gestion des intérêts (pour clients)
const toggleInterest = (categoryId) => {
  const index = userData.interests.indexOf(categoryId)
  if (index === -1) {
    userData.interests.push(categoryId)
  } else {
    userData.interests.splice(index, 1)
  }
}



// Soumission finale
const submitSignup = async () => {
  if (!validateCurrentStep()) return
  
  isSubmitting.value = true
  
  try {
    // Dans un environnement réel, envoyer les données à Supabase
    /*
    // 1. Créer l'utilisateur avec Auth
    const { user, error: authError } = await supabase.auth.signUp({
      email: userData.email,
      password: userData.password
    })
    
    if (authError) throw authError
    
    // 2. Créer le profil utilisateur
    const { error: profileError } = await supabase
      .from('profiles')
      .insert({
        id: user.id,
        first_name: userData.firstName,
        last_name: userData.lastName,
        email: userData.email,
        phone: userData.phone,
        country: userData.country,
        is_expert: userData.accountType === 'expert',
        specialty: userData.accountType === 'expert' ? userData.specialty : null,
        bio: userData.accountType === 'expert' ? userData.bio : null,
        years_of_experience: userData.accountType === 'expert' ? userData.experience : null,
        created_at: new Date()
      })
    
    if (profileError) throw profileError
    
    // 3. Si expert, ajouter les catégories
    if (userData.accountType === 'expert' && userData.categories.length > 0) {
      const categoryData = userData.categories.map(categoryId => ({
        user_id: user.id,
        category_id: categoryId
      }))
      
      const { error: categoryError } = await supabase
        .from('user_categories')
        .insert(categoryData)
      
      if (categoryError) throw categoryError
    }
    */
    
    // Simuler un délai
    await new Promise(resolve => setTimeout(resolve, 1500))
    
    // Rediriger vers la page appropriée
    router.push(userData.accountType === 'expert' ? '/profile/services' : '/requests/new')
  } catch (error) {
    console.error('Erreur lors de l\'inscription:', error)
    alert('Une erreur est survenue lors de l\'inscription. Veuillez réessayer.')
  } finally {
    isSubmitting.value = false
  }
}

// Initialisation
</script>

<style scoped>
.animate-fadeIn {
  animation: fadeIn 0.3s ease-out;
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(4px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
</style> 