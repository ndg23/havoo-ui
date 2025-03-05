<template>
    <div class="max-w-3xl mx-auto px-4 py-12">
      <div class="bg-white rounded-2xl shadow-sm border border-gray-200 p-8">
        <!-- En-tête -->
        <div class="flex items-center justify-between mb-8">
          <h1 class="text-2xl font-bold text-gray-900">Sécurité du compte</h1>
          <NuxtLink 
            to="/account" 
            class="text-sm text-gray-600 hover:text-gray-900 flex items-center gap-1"
          >
            <ArrowLeft class="w-4 h-4" />
            <span>Retour au profil</span>
          </NuxtLink>
        </div>
        
        <!-- Changement de mot de passe -->
        <div class="space-y-6 mb-10">
          <h2 class="text-lg font-medium text-gray-900">Changer le mot de passe</h2>
          
          <form @submit.prevent="changePassword" class="space-y-4">
            <FloatingInput
              id="current-password"
              label="Mot de passe actuel"
              type="password"
              :model-value="passwordForm.currentPassword"
              @update:model-value="passwordForm.currentPassword = $event"
              placeholder="Votre mot de passe actuel"
              :icon="Lock"
            />
            
            <FloatingInput
              id="new-password"
              label="Nouveau mot de passe"
              type="password"
              :model-value="passwordForm.newPassword"
              @update:model-value="passwordForm.newPassword = $event"
              placeholder="Votre nouveau mot de passe"
              :icon="KeyRound"
            />
            
            <FloatingInput
              id="confirm-password"
              label="Confirmer le mot de passe"
              type="password"
              :model-value="passwordForm.confirmPassword"
              @update:model-value="passwordForm.confirmPassword = $event"
              placeholder="Confirmez votre nouveau mot de passe"
              :icon="KeyRound"
            />
            
            <!-- Indicateur de force du mot de passe -->
            <div v-if="passwordForm.newPassword" class="space-y-2">
              <div class="flex items-center justify-between">
                <span class="text-sm text-gray-600">Force du mot de passe</span>
                <span class="text-sm font-medium" :class="passwordStrengthColor">
                  {{ passwordStrength }}
                </span>
              </div>
              <div class="w-full h-2 bg-gray-200 rounded-full overflow-hidden">
                <div 
                  class="h-full transition-all duration-300"
                  :class="passwordStrengthBarColor"
                  :style="{ width: `${passwordStrengthPercentage}%` }"
                ></div>
              </div>
              <ul class="text-xs text-gray-500 space-y-1 mt-2">
                <li class="flex items-center gap-1">
                  <Check 
                    class="w-3.5 h-3.5" 
                    :class="hasMinLength ? 'text-green-500' : 'text-gray-400'" 
                  />
                  <span>Au moins 8 caractères</span>
                </li>
                <li class="flex items-center gap-1">
                  <Check 
                    class="w-3.5 h-3.5" 
                    :class="hasUppercase ? 'text-green-500' : 'text-gray-400'" 
                  />
                  <span>Au moins une majuscule</span>
                </li>
                <li class="flex items-center gap-1">
                  <Check 
                    class="w-3.5 h-3.5" 
                    :class="hasNumber ? 'text-green-500' : 'text-gray-400'" 
                  />
                  <span>Au moins un chiffre</span>
                </li>
                <li class="flex items-center gap-1">
                  <Check 
                    class="w-3.5 h-3.5" 
                    :class="hasSpecialChar ? 'text-green-500' : 'text-gray-400'" 
                  />
                  <span>Au moins un caractère spécial</span>
                </li>
              </ul>
            </div>
            
            <div class="pt-2">
              <button 
                type="submit"
                class="px-6 py-2.5 bg-primary-600 text-white rounded-xl hover:bg-primary-700 transition-colors disabled:bg-gray-300 disabled:cursor-not-allowed"
                :disabled="!isPasswordFormValid"
              >
                Mettre à jour le mot de passe
              </button>
            </div>
          </form>
        </div>
        
        <!-- Authentification à deux facteurs -->
        <div class="pt-8 border-t border-gray-200 space-y-6">
          <div class="flex items-center justify-between">
            <div>
              <h2 class="text-lg font-medium text-gray-900">Authentification à deux facteurs</h2>
              <p class="text-sm text-gray-500 mt-1">
                Ajoutez une couche de sécurité supplémentaire à votre compte
              </p>
            </div>
            <label class="relative inline-flex items-center cursor-pointer">
              <input 
                type="checkbox" 
                v-model="twoFactorEnabled" 
                class="sr-only peer"
                @change="toggleTwoFactor"
              >
              <div class="w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-primary-300 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-primary-600"></div>
            </label>
          </div>
          
          <div v-if="twoFactorEnabled" class="bg-gray-50 rounded-xl p-5 space-y-4">
            <div class="flex items-start gap-4">
              <div class="bg-white p-3 rounded-lg border border-gray-200">
                <img src="https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=otpauth://totp/Example:user@example.com?secret=JBSWY3DPEHPK3PXP&issuer=Example" alt="QR Code" class="w-32 h-32" />
              </div>
              <div>
                <h3 class="font-medium text-gray-900">Scannez ce code QR</h3>
                <p class="text-sm text-gray-600 mt-1">
                  Utilisez une application d'authentification comme Google Authenticator, Authy ou Microsoft Authenticator pour scanner ce code QR.
                </p>
                <button class="mt-3 text-sm text-primary-600 font-medium flex items-center gap-1">
                  <Download class="w-4 h-4" />
                  <span>Télécharger le code QR</span>
                </button>
              </div>
            </div>
            
            <div class="pt-4 border-t border-gray-200">
              <h3 class="font-medium text-gray-900 mb-3">Vérifiez la configuration</h3>
              <div class="flex gap-3">
                <FloatingInput
                  id="verification-code"
                  label="Code de vérification"
                  :model-value="verificationCode"
                  @update:model-value="verificationCode = $event"
                  placeholder="Entrez le code à 6 chiffres"
                  class="flex-1"
                />
                <button 
                  @click="verifyTwoFactor"
                  class="px-6 py-2.5 bg-primary-600 text-white rounded-xl hover:bg-primary-700 transition-colors"
                >
                  Vérifier
                </button>
              </div>
            </div>
          </div>
          
          <div v-else class="bg-gray-50 rounded-xl p-5">
            <div class="flex items-start gap-4">
              <div class="w-12 h-12 rounded-full bg-gray-200 flex items-center justify-center">
                <ShieldCheck class="w-6 h-6 text-gray-500" />
              </div>
              <div>
                <h3 class="font-medium text-gray-900">Protégez votre compte</h3>
                <p class="text-sm text-gray-600 mt-1">
                  L'authentification à deux facteurs ajoute une couche de sécurité supplémentaire à votre compte en exigeant plus qu'un simple mot de passe pour vous connecter.
                </p>
                <button 
                  @click="twoFactorEnabled = true"
                  class="mt-3 text-sm text-primary-600 font-medium"
                >
                  En savoir plus
                </button>
              </div>
            </div>
          </div>
        </div>
        
        <!-- Sessions actives -->
        <div class="pt-8 mt-8 border-t border-gray-200 space-y-6">
          <h2 class="text-lg font-medium text-gray-900">Sessions actives</h2>
          <p class="text-sm text-gray-500">
            Voici les appareils actuellement connectés à votre compte. Si vous ne reconnaissez pas une session, déconnectez-la immédiatement et changez votre mot de passe.
          </p>
          
          <div class="space-y-4">
            <div 
              v-for="(session, index) in activeSessions" 
              :key="index"
              class="bg-white border border-gray-200 rounded-xl p-4 flex items-center justify-between"
              :class="{ 'border-primary-200 bg-primary-50': session.current }"
            >
              <div class="flex items-center gap-4">
                <div class="w-10 h-10 rounded-full bg-gray-100 flex items-center justify-center">
                  <component 
                    :is="getDeviceIcon(session.device)" 
                    class="w-5 h-5 text-gray-500"
                  />
                </div>
                <div>
                  <div class="flex items-center gap-2">
                    <span class="font-medium text-gray-900">{{ session.device }}</span>
                    <span v-if="session.current" class="px-2 py-0.5 bg-primary-100 text-primary-800 text-xs rounded-full">
                      Actuel
                    </span>
                  </div>
                  <div class="text-sm text-gray-500 mt-0.5">
                    {{ session.browser }} • {{ session.location }} • {{ session.ip }}
                  </div>
                  <div class="text-xs text-gray-400 mt-0.5">
                    Dernière activité : {{ session.lastActive }}
                  </div>
                </div>
              </div>
              
              <button 
                v-if="!session.current"
                @click="logoutSession(index)"
                class="px-3 py-1.5 border border-gray-200 rounded-lg text-sm text-gray-700 hover:bg-gray-50 transition-colors"
              >
                Déconnecter
              </button>
            </div>
          </div>
        </div>
        
        <!-- Suppression du compte -->
        <div class="pt-8 mt-8 border-t border-gray-200">
          <h2 class="text-lg font-medium text-red-600">Supprimer le compte</h2>
          <p class="text-sm text-gray-600 mt-1 mb-4">
            Une fois que vous supprimez votre compte, toutes vos données seront définitivement effacées. Cette action est irréversible.
          </p>
          <button 
            @click="showDeleteConfirmation = true"
            class="px-6 py-2.5 border border-red-300 text-red-600 rounded-xl hover:bg-red-50 transition-colors"
          >
            Supprimer mon compte
          </button>
          
          <!-- Modal de confirmation -->
          <Dialog :open="showDeleteConfirmation" @close="showDeleteConfirmation = false" class="relative z-50">
            <div class="fixed inset-0 bg-black/30" aria-hidden="true" />
            
            <div class="fixed inset-0 flex items-center justify-center p-4">
              <DialogPanel class="w-full max-w-md bg-white rounded-2xl p-6">
                <DialogTitle class="text-xl font-bold text-gray-900">
                  Supprimer votre compte ?
                </DialogTitle>
                
                <div class="mt-4 text-gray-600">
                  <p>Cette action est irréversible et entraînera :</p>
                  <ul class="list-disc list-inside mt-2 space-y-1">
                    <li>La suppression de toutes vos données personnelles</li>
                    <li>La suppression de toutes vos demandes de services</li>
                    <li>La perte d'accès à tous vos messages et historique</li>
                  </ul>
                  
                  <div class="mt-4">
                    <label class="flex items-start gap-2">
                      <input 
                        type="checkbox" 
                        v-model="deleteConfirmed"
                        class="mt-1 text-primary-600 focus:ring-primary-500 rounded"
                      />
                      <span class="text-sm">
                        Je comprends que cette action est irréversible et je souhaite supprimer définitivement mon compte.
                      </span>
                    </label>
                  </div>
                </div>
                
                <div class="mt-6 flex gap-3">
                  <button
                    @click="showDeleteConfirmation = false"
                    class="flex-1 px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50"
                  >
                    Annuler
                  </button>
                  <button
                    @click="deleteAccount"
                    class="flex-1 px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 disabled:bg-gray-300 disabled:cursor-not-allowed"
                    :disabled="!deleteConfirmed"
                  >
                    Supprimer définitivement
                  </button>
                </div>
              </DialogPanel>
            </div>
          </Dialog>
        </div>
      </div>
    </div>
  </template>
  
  <script setup lang="ts">
  import { ref, computed } from 'vue'
  import { Dialog, DialogPanel, DialogTitle } from '@headlessui/vue'
  import { 
    ArrowLeft, Lock, KeyRound, Check, ShieldCheck, Download,
    Smartphone, Laptop, Monitor, Tablet, LogOut
  } from 'lucide-vue-next'
  import FloatingInput from '~/components/shared/FloatingInput.vue'
  
  // Formulaire de changement de mot de passe
  const passwordForm = ref({
    currentPassword: '',
    newPassword: '',
    confirmPassword: ''
  })
  
  // Validation du mot de passe
  const hasMinLength = computed(() => passwordForm.value.newPassword.length >= 8)
  const hasUppercase = computed(() => /[A-Z]/.test(passwordForm.value.newPassword))
  const hasNumber = computed(() => /[0-9]/.test(passwordForm.value.newPassword))
  const hasSpecialChar = computed(() => /[^A-Za-z0-9]/.test(passwordForm.value.newPassword))
  
  const passwordStrengthScore = computed(() => {
    if (!passwordForm.value.newPassword) return 0
    
    let score = 0
    if (hasMinLength.value) score += 25
    if (hasUppercase.value) score += 25
    if (hasNumber.value) score += 25
    if (hasSpecialChar.value) score += 25
    
    return score
  })
  
  const passwordStrength = computed(() => {
    const score = passwordStrengthScore.value
    if (score === 0) return ''
    if (score < 50) return 'Faible'
    if (score < 75) return 'Moyen'
    if (score < 100) return 'Fort'
    return 'Très fort'
  })
  
  const passwordStrengthColor = computed(() => {
    const score = passwordStrengthScore.value
    if (score === 0) return ''
    if (score < 50) return 'text-red-600'
    if (score < 75) return 'text-yellow-600'
    if (score < 100) return 'text-green-600'
    return 'text-green-600'
  })
  
  const passwordStrengthBarColor = computed(() => {
    const score = passwordStrengthScore.value
    if (score === 0) return ''
    if (score < 50) return 'bg-red-500'
    if (score < 75) return 'bg-yellow-500'
    if (score < 100) return 'bg-green-500'
    return 'bg-green-500'
  })
  
  const passwordStrengthPercentage = computed(() => passwordStrengthScore.value)
  
  const isPasswordFormValid = computed(() => {
    return (
      passwordForm.value.currentPassword &&
      passwordForm.value.newPassword &&
      passwordForm.value.confirmPassword &&
      passwordForm.value.newPassword === passwordForm.value.confirmPassword &&
      passwordStrengthScore.value >= 75
    )
  })
  
  // Authentification à deux facteurs
  const twoFactorEnabled = ref(false)
  const verificationCode = ref('')
  
  // Sessions actives
  const activeSessions = ref([
    {
      device: 'iPhone 13',
      browser: 'Safari',
      location: 'Cotonou, Bénin',
      ip: '192.168.1.1',
      lastActive: 'Actuellement',
      current: true
    },
    {
      device: 'MacBook Pro',
      browser: 'Chrome',
      location: 'Cotonou, Bénin',
      ip: '192.168.1.2',
      lastActive: 'Il y a 2 heures',
      current: false
    },
    {
      device: 'iPad Air',
      browser: 'Safari',
      location: 'Abidjan, Côte d\'Ivoire',
      ip: '192.168.1.3',
      lastActive: 'Il y a 3 jours',
      current: false
    }
  ])
  
  // Suppression du compte
  const showDeleteConfirmation = ref(false)
  const deleteConfirmed = ref(false)
  
  // Méthodes
  const changePassword = async () => {
    try {
      // Simuler l'envoi des données
      console.log('Changement de mot de passe:', passwordForm.value)
      
      // Réinitialiser le formulaire
      passwordForm.value = {
        currentPassword: '',
        newPassword: '',
        confirmPassword: ''
      }
      
      // Afficher un message de succès
      alert('Mot de passe mis à jour avec succès')
    } catch (error) {
      console.error('Erreur lors du changement de mot de passe:', error)
    }
  }
  
  const toggleTwoFactor = () => {
    if (!twoFactorEnabled.value) {
      // Si on désactive, réinitialiser le code de vérification
      verificationCode.value = ''
    }
  }
  
  const verifyTwoFactor = async () => {
    try {
      // Simuler la vérification
      console.log('Vérification du code:', verificationCode.value)
      
      // Afficher un message de succès
      alert('Authentification à deux facteurs activée avec succès')
      
      // Réinitialiser le code
      verificationCode.value = ''
    } catch (error) {
      console.error('Erreur lors de la vérification:', error)
    }
  }
  
  const logoutSession = (index: number) => {
    try {
      // Simuler la déconnexion
      console.log('Déconnexion de la session:', activeSessions.value[index])
      
      // Supprimer la session
      activeSessions.value.splice(index, 1)
      
      // Afficher un message de succès
      alert('Session déconnectée avec succès')
    } catch (error) {
      console.error('Erreur lors de la déconnexion:', error)
    }
  }
  
  const deleteAccount = async () => {
    try {
      // Simuler la suppression
      console.log('Suppression du compte')
      
      // Fermer la modal
      showDeleteConfirmation.value = false
      
      // Rediriger vers la page d'accueil
      navigateTo('/')
    } catch (error) {
      console.error('Erreur lors de la suppression du compte:', error)
    }
  }
  
  // Helpers
  const getDeviceIcon = (device: string) => {
    if (device.includes('iPhone') || device.includes('Android')) return Smartphone
    if (device.includes('iPad')) return Tablet
    if (device.includes('MacBook') || device.includes('Windows')) return Laptop
    return Monitor
  }
</script>