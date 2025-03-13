<template>
  <div class="max-w-3xl mx-auto px-4 pt-5 pb-16">
    <!-- En-tête -->
    <div class="mb-6">
      <h1 class="text-2xl font-bold text-gray-900 dark:text-white">Paramètres</h1>
      <p class="text-gray-600 dark:text-gray-400 mt-1">
        Gérez les paramètres de votre compte et vos préférences
      </p>
    </div>

    <!-- Onglets de navigation -->
    <div class="mb-6 border-b border-gray-200 dark:border-gray-700">
      <div class="flex overflow-x-auto no-scrollbar">
        <button 
          v-for="tab in tabs" 
          :key="tab.id"
          @click="activeTab = tab.id"
          class="px-4 py-2 font-medium text-sm whitespace-nowrap border-b-2 transition-colors"
          :class="activeTab === tab.id ? 
            'border-primary-500 text-primary-600 dark:text-primary-400' : 
            'border-transparent text-gray-500 dark:text-gray-400 hover:text-gray-700 dark:hover:text-gray-300'"
        >
          {{ tab.name }}
        </button>
      </div>
    </div>

    <!-- Contenu des onglets -->
    <div class="space-y-6">
      <!-- Onglet Compte -->
      <div v-if="activeTab === 'account'" class="space-y-6">
        <!-- Section Email -->
        <div class="bg-white dark:bg-gray-800 rounded-xl p-5 border border-gray-200 dark:border-gray-700 shadow-sm">
          <h2 class="text-lg font-semibold text-gray-900 dark:text-white mb-4">
            Email
          </h2>
          
          <div class="space-y-4">
            <div>
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Adresse email</label>
              <div class="flex items-center">
                <input 
                  type="email" 
                  v-model="userData.email" 
                  disabled
                  class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-gray-100 dark:bg-gray-800 text-gray-900 dark:text-white cursor-not-allowed"
                />
                <div class="ml-2 bg-green-100 dark:bg-green-900/30 text-green-600 dark:text-green-400 text-xs px-2 py-0.5 rounded-full font-medium">
                  Vérifié
                </div>
              </div>
              <p class="mt-1 text-xs text-gray-500 dark:text-gray-400">
                Pour changer votre email, veuillez contacter le support
              </p>
            </div>
          </div>
        </div>
        
        <!-- Section Mot de passe -->
        <div class="bg-white dark:bg-gray-800 rounded-xl p-5 border border-gray-200 dark:border-gray-700 shadow-sm">
          <h2 class="text-lg font-semibold text-gray-900 dark:text-white mb-4">
            Mot de passe
          </h2>
          
          <div class="space-y-4">
            <div>
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Mot de passe actuel</label>
              <div class="relative">
                <input 
                  :type="showCurrentPassword ? 'text' : 'password'" 
                  v-model="passwordData.current"
                  class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
                />
                <button 
                  type="button" 
                  @click="showCurrentPassword = !showCurrentPassword"
                  class="absolute inset-y-0 right-0 pr-3 flex items-center"
                >
                  <Eye v-if="showCurrentPassword" class="h-5 w-5 text-gray-400" />
                  <EyeOff v-else class="h-5 w-5 text-gray-400" />
                </button>
              </div>
            </div>
            
            <div>
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Nouveau mot de passe</label>
              <div class="relative">
                <input 
                  :type="showNewPassword ? 'text' : 'password'" 
                  v-model="passwordData.new"
                  class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
                />
                <button 
                  type="button" 
                  @click="showNewPassword = !showNewPassword"
                  class="absolute inset-y-0 right-0 pr-3 flex items-center"
                >
                  <Eye v-if="showNewPassword" class="h-5 w-5 text-gray-400" />
                  <EyeOff v-else class="h-5 w-5 text-gray-400" />
                </button>
              </div>
              <p class="mt-1 text-xs text-gray-500 dark:text-gray-400">
                8 caractères minimum, incluant au moins un chiffre et une lettre majuscule
              </p>
            </div>
            
            <div>
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Confirmer le nouveau mot de passe</label>
              <div class="relative">
                <input 
                  :type="showConfirmPassword ? 'text' : 'password'" 
                  v-model="passwordData.confirm"
                  class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
                />
                <button 
                  type="button" 
                  @click="showConfirmPassword = !showConfirmPassword"
                  class="absolute inset-y-0 right-0 pr-3 flex items-center"
                >
                  <Eye v-if="showConfirmPassword" class="h-5 w-5 text-gray-400" />
                  <EyeOff v-else class="h-5 w-5 text-gray-400" />
                </button>
              </div>
            </div>
            
            <div class="pt-2">
              <button 
                @click="updatePassword"
                :disabled="isUpdatingPassword || !passwordData.current || !passwordData.new || !passwordData.confirm || passwordData.new !== passwordData.confirm"
                class="px-4 py-2 bg-primary-600 hover:bg-primary-700 disabled:bg-gray-300 dark:disabled:bg-gray-700 disabled:cursor-not-allowed text-white rounded-lg text-sm font-medium flex items-center"
              >
                <span v-if="isUpdatingPassword" class="h-4 w-4 border-2 border-gray-200 border-t-white rounded-full animate-spin mr-2"></span>
                Mettre à jour le mot de passe
              </button>
            </div>
          </div>
        </div>
        
        <!-- Section Téléphone -->
        <div class="bg-white dark:bg-gray-800 rounded-xl p-5 border border-gray-200 dark:border-gray-700 shadow-sm">
          <h2 class="text-lg font-semibold text-gray-900 dark:text-white mb-4">
            Téléphone
          </h2>
          
          <div class="space-y-4">
            <div>
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Numéro de téléphone</label>
              <input 
                type="tel" 
                v-model="userData.phone" 
                class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
              />
              <p class="mt-1 text-xs text-gray-500 dark:text-gray-400">
                Ce numéro sera utilisé pour les communications importantes et les notifications
              </p>
            </div>
            
            <div class="pt-2">
              <button 
                @click="updatePhone"
                :disabled="isUpdatingPhone"
                class="px-4 py-2 bg-primary-600 hover:bg-primary-700 disabled:bg-gray-300 dark:disabled:bg-gray-700 disabled:cursor-not-allowed text-white rounded-lg text-sm font-medium flex items-center"
              >
                <span v-if="isUpdatingPhone" class="h-4 w-4 border-2 border-gray-200 border-t-white rounded-full animate-spin mr-2"></span>
                Mettre à jour le téléphone
              </button>
            </div>
          </div>
        </div>
        
        <!-- Section suppression de compte -->
        <div class="bg-white dark:bg-gray-800 rounded-xl p-5 border border-red-200 dark:border-red-800/30 shadow-sm">
          <h2 class="text-lg font-semibold text-red-600 dark:text-red-400 mb-4">
            Supprimer mon compte
          </h2>
          
          <p class="text-sm text-gray-700 dark:text-gray-300 mb-4">
            Attention : la suppression de votre compte est définitive et entraînera la perte de toutes vos données et informations. Cette action ne peut pas être annulée.
          </p>
          
          <button 
            @click="showDeleteConfirmation = true"
            class="px-4 py-2 bg-red-100 dark:bg-red-900/30 text-red-600 dark:text-red-400 hover:bg-red-200 dark:hover:bg-red-900/50 rounded-lg text-sm font-medium"
          >
            Demander la suppression de mon compte
          </button>
        </div>
      </div>
      
      <!-- Onglet Notifications -->
      <div v-if="activeTab === 'notifications'" class="space-y-6">
        <div class="bg-white dark:bg-gray-800 rounded-xl p-5 border border-gray-200 dark:border-gray-700 shadow-sm">
          <h2 class="text-lg font-semibold text-gray-900 dark:text-white mb-4">
            Préférences de notifications
          </h2>
          
          <div class="space-y-5">
            <div class="flex items-center justify-between">
              <div>
                <h3 class="text-sm font-medium text-gray-900 dark:text-white">Notifications par email</h3>
                <p class="text-xs text-gray-500 dark:text-gray-400 mt-1">
                  Recevez des emails pour les activités importantes
                </p>
              </div>
              <Switch v-model="notificationPrefs.email" />
            </div>
            
            <div class="flex items-center justify-between">
              <div>
                <h3 class="text-sm font-medium text-gray-900 dark:text-white">Notifications par SMS</h3>
                <p class="text-xs text-gray-500 dark:text-gray-400 mt-1">
                  Recevez des SMS pour les alertes urgentes
                </p>
              </div>
              <Switch v-model="notificationPrefs.sms" />
            </div>
            
            <div class="flex items-center justify-between">
              <div>
                <h3 class="text-sm font-medium text-gray-900 dark:text-white">Notifications push</h3>
                <p class="text-xs text-gray-500 dark:text-gray-400 mt-1">
                  Recevez des notifications sur votre navigateur
                </p>
              </div>
              <Switch v-model="notificationPrefs.push" />
            </div>
            
            <div class="pt-3 border-t border-gray-200 dark:border-gray-700">
              <h3 class="text-sm font-medium text-gray-900 dark:text-white mb-3">Types de notifications</h3>
              
              <div class="space-y-3">
                <div class="flex items-center">
                  <input 
                    type="checkbox" 
                    id="notif-messages" 
                    v-model="notificationPrefs.messages"
                    class="h-4 w-4 rounded border-gray-300 text-primary-600 focus:ring-primary-500"
                  />
                  <label for="notif-messages" class="ml-2 text-sm text-gray-700 dark:text-gray-300">
                    Nouveaux messages
                  </label>
                </div>
                
                <div class="flex items-center">
                  <input 
                    type="checkbox" 
                    id="notif-proposals" 
                    v-model="notificationPrefs.proposals"
                    class="h-4 w-4 rounded border-gray-300 text-primary-600 focus:ring-primary-500"
                  />
                  <label for="notif-proposals" class="ml-2 text-sm text-gray-700 dark:text-gray-300">
                    Nouvelles propositions
                  </label>
                </div>
                
                <div class="flex items-center">
                  <input 
                    type="checkbox" 
                    id="notif-contracts" 
                    v-model="notificationPrefs.contracts"
                    class="h-4 w-4 rounded border-gray-300 text-primary-600 focus:ring-primary-500"
                  />
                  <label for="notif-contracts" class="ml-2 text-sm text-gray-700 dark:text-gray-300">
                    Contrats et paiements
                  </label>
                </div>
                
                <div class="flex items-center">
                  <input 
                    type="checkbox" 
                    id="notif-updates" 
                    v-model="notificationPrefs.updates"
                    class="h-4 w-4 rounded border-gray-300 text-primary-600 focus:ring-primary-500"
                  />
                  <label for="notif-updates" class="ml-2 text-sm text-gray-700 dark:text-gray-300">
                    Mises à jour de l'application
                  </label>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Onglet Langue & Région -->
      <div v-if="activeTab === 'language'" class="space-y-6">
        <div class="bg-white dark:bg-gray-800 rounded-xl p-5 border border-gray-200 dark:border-gray-700 shadow-sm">
          <h2 class="text-lg font-semibold text-gray-900 dark:text-white mb-4">
            Langue & Région
          </h2>
          
          <div class="space-y-5">
            <div class="flex items-center justify-between">
              <div>
                <h3 class="text-sm font-medium text-gray-900 dark:text-white">Langue</h3>
                <p class="text-xs text-gray-500 dark:text-gray-400 mt-1">
                  Sélectionnez la langue de votre choix
                </p>
              </div>
              <select v-model="userPrefs.locale" class="w-24 px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white">
                <option value="en">English</option>
                <option value="fr">Français</option>
                <option value="es">Español</option>
                <option value="de">Deutsch</option>
                <option value="it">Italiano</option>
              </select>
            </div>
            
            <div class="flex items-center justify-between">
              <div>
                <h3 class="text-sm font-medium text-gray-900 dark:text-white">Région</h3>
                <p class="text-xs text-gray-500 dark:text-gray-400 mt-1">
                  Sélectionnez la région de votre choix
                </p>
              </div>
              <select v-model="userPrefs.region" class="w-24 px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white">
                <option value="US">États-Unis</option>
                <option value="CA">Canada</option>
                <option value="FR">France</option>
                <option value="DE">Allemagne</option>
                <option value="IT">Italie</option>
              </select>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { Eye, EyeOff, Monitor, Sun, Moon } from 'lucide-vue'
import { Switch } from '@headlessui/vue'

const tabs = ref([
  { id: 'account', name: 'Compte' },
  { id: 'notifications', name: 'Notifications' },
  { id: 'language', name: 'Langue & Région' }
])

const themes = ref([
  { id: 'system', name: 'Système', icon: Monitor },
  { id: 'light', name: 'Clair', icon: Sun },
  { id: 'dark', name: 'Sombre', icon: Moon }
])

// État des notifications de succès
const showPasswordSuccess = ref(false)
const showPhoneSuccess = ref(false)
const showNotificationSuccess = ref(false)
const showPreferencesSuccess = ref(false)

// Méthodes
const updatePassword = async () => {
  if (passwordData.value.new !== passwordData.value.confirm) {
    alert('Les mots de passe ne correspondent pas')
    return
  }
  
  isUpdatingPassword.value = true
  
  try {
    // Dans un environnement réel, nous mettrions à jour le mot de passe avec Supabase Auth
    /*
    const { error } = await supabase.auth.updateUser({ 
      password: passwordData.value.new 
    })
    
    if (error) throw error
    */
    
    // Simuler une mise à jour réussie
    await new Promise(resolve => setTimeout(resolve, 1000))
    
    // Réinitialiser les champs de mot de passe
    passwordData.value = {
      current: '',
      new: '',
      confirm: ''
    }
    
    showPasswordSuccess.value = true
    setTimeout(() => {
      showPasswordSuccess.value = false
    }, 3000)
  } catch (error) {
    console.error('Erreur lors de la mise à jour du mot de passe:', error)
    alert('Erreur lors de la mise à jour du mot de passe')
  } finally {
    isUpdatingPassword.value = false
  }
}

const updatePhone = async () => {
  isUpdatingPhone.value = true
  
  try {
    // Dans un environnement réel, nous mettrions à jour le téléphone dans Supabase
    /*
    const { error } = await supabase
      .from('profiles')
      .update({ phone: userData.value.phone })
      .eq('id', user.value.id)
    
    if (error) throw error
    */
    
    // Simuler une mise à jour réussie
    await new Promise(resolve => setTimeout(resolve, 1000))
    
    showPhoneSuccess.value = true
    setTimeout(() => {
      showPhoneSuccess.value = false
    }, 3000)
  } catch (error) {
    console.error('Erreur lors de la mise à jour du téléphone:', error)
    alert('Erreur lors de la mise à jour du téléphone')
  } finally {
    isUpdatingPhone.value = false
  }
}

const saveNotificationPreferences = async () => {
  isSavingNotifications.value = true
  
  try {
    // Dans un environnement réel, nous sauvegarderions les préférences dans Supabase
    /*
    const { error } = await supabase
      .from('notification_preferences')
      .upsert({
        user_id: user.value.id,
        ...notificationPrefs.value
      })
    
    if (error) throw error
    */
    
    // Simuler une mise à jour réussie
    await new Promise(resolve => setTimeout(resolve, 1000))
    
    showNotificationSuccess.value = true
    setTimeout(() => {
      showNotificationSuccess.value = false
    }, 3000)
  } catch (error) {
    console.error('Erreur lors de la sauvegarde des préférences de notification:', error)
    alert('Erreur lors de la sauvegarde des préférences')
  } finally {
    isSavingNotifications.value = false
  }
}

const savePreferences = async () => {
  isSavingPreferences.value = true
  
  try {
    // Dans un environnement réel, nous sauvegarderions les préférences dans Supabase
    /*
    const { error } = await supabase
      .from('user_preferences')
      .upsert({
        user_id: user.value.id,
        theme: userPrefs.value.theme,
        locale: userPrefs.value.locale
      })
    
    if (error) throw error
    */
    
    // Simuler une mise à jour réussie
    await new Promise(resolve => setTimeout(resolve, 1000))
    
    showPreferencesSuccess.value = true
    setTimeout(() => {
      showPreferencesSuccess.value = false
    }, 3000)
  } catch (error) {
    console.error('Erreur lors de la sauvegarde des préférences:', error)
    alert('Erreur lors de la sauvegarde des préférences')
  } finally {
    isSavingPreferences.value = false
  }
}

// Initialisation
onMounted(() => {
  // Charger les données
})

definePageMeta({
  layout: 'default'
})
</script>

<style scoped>
.no-scrollbar {
  -ms-overflow-style: none;
  scrollbar-width: none;
}
.no-scrollbar::-webkit-scrollbar {
  display: none;
}

.animated {
  animation-duration: 0.4s;
  animation-fill-mode: both;
}

@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translate3d(0, 10px, 0);
  }
  to {
    opacity: 1;
    transform: translate3d(0, 0, 0);
  }
}

.fadeInUp {
  animation-name: fadeInUp;
}
</style> 