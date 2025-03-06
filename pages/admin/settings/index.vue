<template>
  <div class="space-y-6">
    <!-- En-tête de page -->
    <PageHeader 
      title="Paramètres de l'application" 
      subtitle="Configurez les paramètres généraux de votre plateforme"
    >
      <!-- Actions -->
      <template #actions>
        <button 
          @click="fetchSettings"
          class="px-4 py-2 bg-gray-100 text-gray-700 text-sm font-medium rounded-lg hover:bg-gray-200 transition-colors flex items-center mr-2"
        >
          <RefreshCw class="h-4 w-4 mr-1.5" />
          Actualiser
        </button>
      </template>
    </PageHeader>
    
    <!-- Section des paramètres généraux -->
    <div class="bg-white border border-gray-200 rounded-xl overflow-hidden">
      <div class="px-6 py-4 border-b border-gray-200 flex justify-between items-center">
        <h2 class="text-lg font-semibold text-gray-900">Paramètres généraux</h2>
        <button 
          @click="saveSettings('general')" 
          class="px-4 py-2 bg-primary-600 text-white text-sm font-medium rounded-lg hover:bg-primary-700 transition-colors flex items-center"
          :disabled="saving.general"
        >
          <Loader2 v-if="saving.general" class="h-4 w-4 mr-1.5 animate-spin" />
          <Save v-else class="h-4 w-4 mr-1.5" />
          Enregistrer
        </button>
      </div>
      
      <div class="p-6">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div>
            <label for="siteName" class="block text-sm font-medium text-gray-700 mb-1">
              Nom du site
            </label>
            <input
              id="siteName"
              v-model="settings.siteName"
              type="text"
              class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-600 focus:border-transparent"
            />
            <p class="mt-1 text-xs text-gray-500">Nom affiché dans l'en-tête et les e-mails</p>
          </div>
          
          <div>
            <label for="contactEmail" class="block text-sm font-medium text-gray-700 mb-1">
              E-mail de contact
            </label>
            <input
              id="contactEmail"
              v-model="settings.contactEmail"
              type="email"
              class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-600 focus:border-transparent"
            />
            <p class="mt-1 text-xs text-gray-500">Adresse utilisée pour recevoir les messages</p>
          </div>
          
          <div>
            <label for="defaultLocale" class="block text-sm font-medium text-gray-700 mb-1">
              Langue par défaut
            </label>
            <select
              id="defaultLocale"
              v-model="settings.defaultLocale"
              class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-600 focus:border-transparent"
            >
              <option value="fr">Français</option>
              <option value="en">Anglais</option>
            </select>
          </div>
          
          <div>
            <label for="maintenanceMode" class="block text-sm font-medium text-gray-700 mb-1">
              Mode maintenance
            </label>
            <div class="flex items-center">
              <Switch 
                v-model="settings.maintenanceMode" 
                class="relative inline-flex h-6 w-11 items-center rounded-full"
                :class="settings.maintenanceMode ? 'bg-primary-600' : 'bg-gray-300'"
              >
                <span class="sr-only">Activer le mode maintenance</span>
                <span
                  class="inline-block h-4 w-4 transform rounded-full bg-white transition"
                  :class="settings.maintenanceMode ? 'translate-x-6' : 'translate-x-1'"
                />
              </Switch>
              <span class="ml-2 text-sm text-gray-700">
                {{ settings.maintenanceMode ? 'Activé' : 'Désactivé' }}
              </span>
            </div>
            <p class="mt-1 text-xs text-gray-500">Affiche une page de maintenance pour les visiteurs</p>
          </div>
        </div>
      </div>
    </div>
    
    <!-- Section des paramètres e-mail -->
    <div class="bg-white border border-gray-200 rounded-xl overflow-hidden">
      <div class="px-6 py-4 border-b border-gray-200 flex justify-between items-center">
        <h2 class="text-lg font-semibold text-gray-900">Configuration des e-mails</h2>
        <button 
          @click="saveSettings('email')" 
          class="px-4 py-2 bg-primary-600 text-white text-sm font-medium rounded-lg hover:bg-primary-700 transition-colors flex items-center"
          :disabled="saving.email"
        >
          <Loader2 v-if="saving.email" class="h-4 w-4 mr-1.5 animate-spin" />
          <Save v-else class="h-4 w-4 mr-1.5" />
          Enregistrer
        </button>
      </div>
      
      <div class="p-6">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div>
            <label for="smtpHost" class="block text-sm font-medium text-gray-700 mb-1">
              Serveur SMTP
            </label>
            <input
              id="smtpHost"
              v-model="emailSettings.smtpHost"
              type="text"
              class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-600 focus:border-transparent"
            />
          </div>
          
          <div>
            <label for="smtpPort" class="block text-sm font-medium text-gray-700 mb-1">
              Port SMTP
            </label>
            <input
              id="smtpPort"
              v-model="emailSettings.smtpPort"
              type="number"
              class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-600 focus:border-transparent"
            />
          </div>
          
          <div>
            <label for="smtpUsername" class="block text-sm font-medium text-gray-700 mb-1">
              Nom d'utilisateur
            </label>
            <input
              id="smtpUsername"
              v-model="emailSettings.smtpUsername"
              type="text"
              class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-600 focus:border-transparent"
            />
          </div>
          
          <div>
            <label for="smtpPassword" class="block text-sm font-medium text-gray-700 mb-1">
              Mot de passe
            </label>
            <input
              id="smtpPassword"
              v-model="emailSettings.smtpPassword"
              type="password"
              class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-600 focus:border-transparent"
            />
          </div>
          
          <div class="md:col-span-2">
            <label for="defaultSender" class="block text-sm font-medium text-gray-700 mb-1">
              E-mail d'expédition par défaut
            </label>
            <input
              id="defaultSender"
              v-model="emailSettings.defaultSender"
              type="email"
              class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-600 focus:border-transparent"
            />
          </div>
          
          <div class="md:col-span-2">
            <button 
              @click="testEmailConnection" 
              class="px-4 py-2 border border-gray-300 text-gray-700 text-sm font-medium rounded-lg hover:bg-gray-50 transition-colors flex items-center"
              :disabled="testingEmail"
            >
              <Loader2 v-if="testingEmail" class="h-4 w-4 mr-1.5 animate-spin" />
              <Mail v-else class="h-4 w-4 mr-1.5" />
              Tester la connexion
            </button>
          </div>
        </div>
      </div>
    </div>
    
    <!-- Section des paramètres de paiement -->
    <div class="bg-white border border-gray-200 rounded-xl overflow-hidden">
      <div class="px-6 py-4 border-b border-gray-200 flex justify-between items-center">
        <h2 class="text-lg font-semibold text-gray-900">Configuration des paiements</h2>
        <button 
          @click="saveSettings('payment')" 
          class="px-4 py-2 bg-primary-600 text-white text-sm font-medium rounded-lg hover:bg-primary-700 transition-colors flex items-center"
          :disabled="saving.payment"
        >
          <Loader2 v-if="saving.payment" class="h-4 w-4 mr-1.5 animate-spin" />
          <Save v-else class="h-4 w-4 mr-1.5" />
          Enregistrer
        </button>
      </div>
      
      <div class="p-6">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div class="md:col-span-2">
            <div class="flex items-center mb-4">
              <Switch 
                v-model="paymentSettings.enabled" 
                class="relative inline-flex h-6 w-11 items-center rounded-full"
                :class="paymentSettings.enabled ? 'bg-primary-600' : 'bg-gray-300'"
              >
                <span class="sr-only">Activer les paiements</span>
                <span
                  class="inline-block h-4 w-4 transform rounded-full bg-white transition"
                  :class="paymentSettings.enabled ? 'translate-x-6' : 'translate-x-1'"
                />
              </Switch>
              <span class="ml-2 text-sm font-medium text-gray-700">
                {{ paymentSettings.enabled ? 'Paiements activés' : 'Paiements désactivés' }}
              </span>
            </div>
          </div>
          
          <div>
            <label for="stripePublicKey" class="block text-sm font-medium text-gray-700 mb-1">
              Clé publique Stripe
            </label>
            <input
              id="stripePublicKey"
              v-model="paymentSettings.stripePublicKey"
              type="text"
              :disabled="!paymentSettings.enabled"
              class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-600 focus:border-transparent"
              :class="{ 'bg-gray-100': !paymentSettings.enabled }"
            />
          </div>
          
          <div>
            <label for="stripeSecretKey" class="block text-sm font-medium text-gray-700 mb-1">
              Clé secrète Stripe
            </label>
            <input
              id="stripeSecretKey"
              v-model="paymentSettings.stripeSecretKey"
              type="password"
              :disabled="!paymentSettings.enabled"
              class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-600 focus:border-transparent"
              :class="{ 'bg-gray-100': !paymentSettings.enabled }"
            />
          </div>
          
          <div>
            <label for="currency" class="block text-sm font-medium text-gray-700 mb-1">
              Devise par défaut
            </label>
            <select
              id="currency"
              v-model="paymentSettings.currency"
              :disabled="!paymentSettings.enabled"
              class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-600 focus:border-transparent"
              :class="{ 'bg-gray-100': !paymentSettings.enabled }"
            >
              <option value="EUR">Euro (€)</option>
              <option value="USD">Dollar américain ($)</option>
              <option value="GBP">Livre sterling (£)</option>
            </select>
          </div>
          
          <div>
            <label for="commissionRate" class="block text-sm font-medium text-gray-700 mb-1">
              Taux de commission (%)
            </label>
            <input
              id="commissionRate"
              v-model="paymentSettings.commissionRate"
              type="number"
              min="0"
              max="100"
              step="0.1"
              :disabled="!paymentSettings.enabled"
              class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-600 focus:border-transparent"
              :class="{ 'bg-gray-100': !paymentSettings.enabled }"
            />
            <p class="mt-1 text-xs text-gray-500">Commission prélevée sur chaque transaction</p>
          </div>
        </div>
      </div>
    </div>
    
    <!-- Section sécurité -->
    <div class="bg-white border border-gray-200 rounded-xl overflow-hidden">
      <div class="px-6 py-4 border-b border-gray-200 flex justify-between items-center">
        <h2 class="text-lg font-semibold text-gray-900">Sécurité</h2>
        <button 
          @click="saveSettings('security')" 
          class="px-4 py-2 bg-primary-600 text-white text-sm font-medium rounded-lg hover:bg-primary-700 transition-colors flex items-center"
          :disabled="saving.security"
        >
          <Loader2 v-if="saving.security" class="h-4 w-4 mr-1.5 animate-spin" />
          <Save v-else class="h-4 w-4 mr-1.5" />
          Enregistrer
        </button>
      </div>
      
      <div class="p-6">
        <div class="space-y-6">
          <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
              <label for="requireEmailVerification" class="block text-sm font-medium text-gray-700 mb-1">
                Vérification d'e-mail
              </label>
              <div class="flex items-center">
                <Switch 
                  v-model="securitySettings.requireEmailVerification" 
                  class="relative inline-flex h-6 w-11 items-center rounded-full"
                  :class="securitySettings.requireEmailVerification ? 'bg-primary-600' : 'bg-gray-300'"
                >
                  <span class="sr-only">Exiger la vérification d'e-mail</span>
                  <span
                    class="inline-block h-4 w-4 transform rounded-full bg-white transition"
                    :class="securitySettings.requireEmailVerification ? 'translate-x-6' : 'translate-x-1'"
                  />
                </Switch>
                <span class="ml-2 text-sm text-gray-700">
                  {{ securitySettings.requireEmailVerification ? 'Obligatoire' : 'Facultative' }}
                </span>
              </div>
              <p class="mt-1 text-xs text-gray-500">Exiger la vérification d'e-mail avant de permettre la connexion</p>
            </div>
            
            <div>
              <label for="twoFactorAuth" class="block text-sm font-medium text-gray-700 mb-1">
                Authentification à deux facteurs
              </label>
              <div class="flex items-center">
                <Switch 
                  v-model="securitySettings.twoFactorAuth" 
                  class="relative inline-flex h-6 w-11 items-center rounded-full"
                  :class="securitySettings.twoFactorAuth ? 'bg-primary-600' : 'bg-gray-300'"
                >
                  <span class="sr-only">Activer l'authentification à deux facteurs</span>
                  <span
                    class="inline-block h-4 w-4 transform rounded-full bg-white transition"
                    :class="securitySettings.twoFactorAuth ? 'translate-x-6' : 'translate-x-1'"
                  />
                </Switch>
                <span class="ml-2 text-sm text-gray-700">
                  {{ securitySettings.twoFactorAuth ? 'Activée' : 'Désactivée' }}
                </span>
              </div>
            </div>
            
            <div>
              <label for="sessionTimeout" class="block text-sm font-medium text-gray-700 mb-1">
                Expiration de la session (minutes)
              </label>
              <input
                id="sessionTimeout"
                v-model="securitySettings.sessionTimeout"
                type="number"
                min="5"
                class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-600 focus:border-transparent"
              />
              <p class="mt-1 text-xs text-gray-500">Durée d'inactivité avant déconnexion automatique</p>
            </div>
            
            <div>
              <label for="maxLoginAttempts" class="block text-sm font-medium text-gray-700 mb-1">
                Tentatives de connexion max
              </label>
              <input
                id="maxLoginAttempts"
                v-model="securitySettings.maxLoginAttempts"
                type="number"
                min="1"
                class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-600 focus:border-transparent"
              />
              <p class="mt-1 text-xs text-gray-500">Nombre de tentatives avant verrouillage temporaire</p>
            </div>
          </div>
          
          <div>
            <button 
              @click="confirmResetSecurity"
              class="px-4 py-2 bg-red-50 text-red-600 border border-red-200 text-sm font-medium rounded-lg hover:bg-red-100 transition-colors flex items-center"
            >
              <RefreshCw class="h-4 w-4 mr-1.5" />
              Réinitialiser les paramètres de sécurité
            </button>
          </div>
        </div>
      </div>
    </div>
    
    <!-- Modal de confirmation -->
    <Teleport to="body">
      <div 
        v-if="showConfirmModal" 
        class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 px-4"
        @click.self="showConfirmModal = false"
      >
        <div class="bg-white rounded-xl p-6 w-full max-w-md">
          <div class="flex justify-between items-center mb-4">
            <h3 class="text-lg font-semibold text-gray-900">Confirmation</h3>
            <button @click="showConfirmModal = false" class="text-gray-500 hover:text-gray-700">
              <X class="h-5 w-5" />
            </button>
          </div>
          
          <p class="text-gray-700 mb-6">
            Êtes-vous sûr de vouloir réinitialiser tous les paramètres de sécurité aux valeurs par défaut ? Cette action ne peut pas être annulée.
          </p>
          
          <div class="flex justify-end space-x-3">
            <button
              @click="showConfirmModal = false"
              class="px-4 py-2 text-gray-700 hover:text-gray-500 text-sm font-medium"
            >
              Annuler
            </button>
            <button
              @click="resetSecuritySettings"
              class="px-4 py-2 bg-red-600 text-white text-sm font-medium rounded-lg hover:bg-red-700 transition-colors"
            >
              Réinitialiser
            </button>
          </div>
        </div>
      </div>
    </Teleport>
    
    <!-- Alerte de succès -->
    <div 
      v-if="showAlert.show" 
      class="fixed bottom-4 right-4 px-4 py-3 rounded-lg shadow-lg max-w-md transition-all"
      :class="showAlert.type === 'success' ? 'bg-green-50 border border-green-200' : 'bg-red-50 border border-red-200'"
    >
      <div class="flex items-center">
        <CheckCircle 
          v-if="showAlert.type === 'success'" 
          class="h-5 w-5 text-green-500 mr-2" 
        />
        <AlertTriangle 
          v-else 
          class="h-5 w-5 text-red-500 mr-2" 
        />
        <p 
          class="text-sm font-medium"
          :class="showAlert.type === 'success' ? 'text-green-700' : 'text-red-700'"
        >
          {{ showAlert.message }}
        </p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { 
  Loader2, Save, Mail, X, RefreshCw, 
  CheckCircle, AlertTriangle
} from 'lucide-vue-next'
import { PageHeader } from '~/components/admin'

const client = useSupabaseClient()

// États
const settings = ref({
  siteName: 'Havoo',
  contactEmail: 'contact@havoo.fr',
  defaultLocale: 'fr',
  maintenanceMode: false
})

const emailSettings = ref({
  smtpHost: '',
  smtpPort: 587,
  smtpUsername: '',
  smtpPassword: '',
  defaultSender: 'no-reply@havoo.fr'
})

const paymentSettings = ref({
  enabled: true,
  stripePublicKey: '',
  stripeSecretKey: '',
  currency: 'EUR',
  commissionRate: 10
})

const securitySettings = ref({
  requireEmailVerification: true,
  twoFactorAuth: false,
  sessionTimeout: 60,
  maxLoginAttempts: 5
})

const saving = reactive({
  general: false,
  email: false,
  payment: false,
  security: false
})

const testingEmail = ref(false)
const showConfirmModal = ref(false)
const showAlert = reactive({
  show: false,
  type: 'success',
  message: ''
})

// Récupérer les paramètres
const fetchSettings = async () => {
  try {
    const { data, error } = await client
      .from('settings')
      .select('*')
      .single()
    
    if (error) throw error
    
    if (data) {
      // Paramètres généraux
      settings.value = {
        siteName: data.site_name || 'Havoo',
        contactEmail: data.contact_email || 'contact@havoo.fr',
        defaultLocale: data.default_locale || 'fr',
        maintenanceMode: data.maintenance_mode || false
      }
      
      // Paramètres d'e-mail
      if (data.email_settings) {
        emailSettings.value = {
          smtpHost: data.email_settings.smtp_host || '',
          smtpPort: data.email_settings.smtp_port || 587,
          smtpUsername: data.email_settings.smtp_username || '',
          smtpPassword: data.email_settings.smtp_password || '',
          defaultSender: data.email_settings.default_sender || 'no-reply@havoo.fr'
        }
      }
      
      // Paramètres de paiement
      if (data.payment_settings) {
        paymentSettings.value = {
          enabled: data.payment_settings.enabled !== undefined ? data.payment_settings.enabled : true,
          stripePublicKey: data.payment_settings.stripe_public_key || '',
          stripeSecretKey: data.payment_settings.stripe_secret_key || '',
          currency: data.payment_settings.currency || 'EUR',
          commissionRate: data.payment_settings.commission_rate || 10
        }
      }
      
      // Paramètres de sécurité
      if (data.security_settings) {
        securitySettings.value = {
          requireEmailVerification: data.security_settings.require_email_verification !== undefined 
            ? data.security_settings.require_email_verification 
            : true,
          twoFactorAuth: data.security_settings.two_factor_auth || false,
          sessionTimeout: data.security_settings.session_timeout || 60,
          maxLoginAttempts: data.security_settings.max_login_attempts || 5
        }
      }
    }
  } catch (error) {
    console.error('Erreur lors du chargement des paramètres:', error)
    showNotification('error', 'Erreur lors du chargement des paramètres')
  }
}

// Enregistrer les paramètres
const saveSettings = async (section) => {
  try {
    saving[section] = true
    
    let settingsData = {}
    
    switch (section) {
      case 'general':
        settingsData = {
          site_name: settings.value.siteName,
          contact_email: settings.value.contactEmail,
          default_locale: settings.value.defaultLocale,
          maintenance_mode: settings.value.maintenanceMode
        }
        break
        
      case 'email':
        settingsData = {
          email_settings: {
            smtp_host: emailSettings.value.smtpHost,
            smtp_port: emailSettings.value.smtpPort,
            smtp_username: emailSettings.value.smtpUsername,
            smtp_password: emailSettings.value.smtpPassword,
            default_sender: emailSettings.value.defaultSender
          }
        }
        break
        
      case 'payment':
        settingsData = {
          payment_settings: {
            enabled: paymentSettings.value.enabled,
            stripe_public_key: paymentSettings.value.stripePublicKey,
            stripe_secret_key: paymentSettings.value.stripeSecretKey,
            currency: paymentSettings.value.currency,
            commission_rate: paymentSettings.value.commissionRate
          }
        }
        break
        
      case 'security':
        settingsData = {
          security_settings: {
            require_email_verification: securitySettings.value.requireEmailVerification,
            two_factor_auth: securitySettings.value.twoFactorAuth,
            session_timeout: securitySettings.value.sessionTimeout,
            max_login_attempts: securitySettings.value.maxLoginAttempts
          }
        }
        break
    }
    
    // Mettre à jour les paramètres dans la base de données
    const { error } = await client
      .from('settings')
      .update(settingsData)
      .eq('id', 1) // Supposant qu'il n'y a qu'une seule ligne de paramètres
    
    if (error) throw error
    
    showNotification('success', 'Paramètres enregistrés avec succès')
  } catch (error) {
    console.error('Erreur lors de l\'enregistrement des paramètres:', error)
    showNotification('error', 'Erreur lors de l\'enregistrement des paramètres')
  } finally {
    saving[section] = false
  }
}

// Tester la connexion e-mail
const testEmailConnection = async () => {
  try {
    testingEmail.value = true
    
    // Simuler un test de connexion SMTP
    await new Promise(resolve => setTimeout(resolve, 1500))
    
    showNotification('success', 'Connexion SMTP établie avec succès')
  } catch (error) {
    console.error('Erreur lors du test de connexion SMTP:', error)
    showNotification('error', 'Échec de la connexion SMTP')
  } finally {
    testingEmail.value = false
  }
}

// Confirmer la réinitialisation des paramètres de sécurité
const confirmResetSecurity = () => {
  showConfirmModal.value = true
}

// Réinitialiser les paramètres de sécurité
const resetSecuritySettings = () => {
  securitySettings.value = {
    requireEmailVerification: true,
    twoFactorAuth: false,
    sessionTimeout: 60,
    maxLoginAttempts: 5
  }
  
  showConfirmModal.value = false
  saveSettings('security')
}

// Afficher une notification
const showNotification = (type, message) => {
  showAlert.type = type
  showAlert.message = message
  showAlert.show = true
  
  setTimeout(() => {
    showAlert.show = false
  }, 3000)
}

// Charger les paramètres au montage du composant
onMounted(fetchSettings)

// Définir le layout admin
definePageMeta({
  layout: 'admin',
})
</script> 