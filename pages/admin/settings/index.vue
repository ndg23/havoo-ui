<template>
  <div class="space-y-6 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
    <!-- Header -->
    <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
      <div>
        <h1 class="text-3xl font-bold text-gray-900 dark:text-white tracking-tight">Paramètres</h1>
        <p class="text-gray-600 dark:text-gray-400 mt-1">Configurez les paramètres de la plateforme</p>
      </div>
      
      <div class="flex items-center gap-3">
        <UButton 
          icon="i-heroicons-arrow-path" 
          color="gray" 
          variant="ghost" 
          @click="resetToDefaults"
        >
          Réinitialiser
        </UButton>
        <UButton 
          icon="i-heroicons-check" 
          @click="saveAllSettings"
          :loading="saving"
        >
          Enregistrer
        </UButton>
      </div>
    </div>

    <!-- Tabs -->
    <div class="border-b border-gray-200">
      <nav class="-mb-px flex space-x-8" aria-label="Tabs">
        <button
          v-for="tab in tabs"
          :key="tab.id"
          @click="activeTab = tab.id"
          :class="[
            activeTab === tab.id
              ? 'border-primary-500 text-primary-600'
              : 'border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700',
            'whitespace-nowrap border-b-2 py-4 px-1 text-sm font-medium flex items-center gap-2'
          ]"
        >
          <component :is="tab.icon" class="h-5 w-5" />
          {{ tab.label }}
        </button>
      </nav>
    </div>

    <!-- Content -->
    <div class="space-y-6">
      <!-- General Settings -->
      <div v-if="activeTab === 'general'" class="space-y-6">
        <UCard>
          <template #header>
            <h2 class="text-lg font-medium text-gray-900">Informations générales</h2>
            <p class="text-sm text-gray-500 mt-1">Paramètres principaux de la plateforme</p>
          </template>

          <div class="space-y-6">
            <!-- App Name -->
            <div>
              <label class="block text-base font-semibold text-gray-900 mb-2">
                Nom de l'application
              </label>
              <input
                v-model="settings.app_name"
                type="text"
                class="block w-full px-4 py-3.5 text-gray-900 border border-gray-200 rounded-2xl 
                  focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors text-lg"
              />
              <p class="mt-2 text-sm text-gray-500">
                Le nom qui apparaît dans le titre et l'interface
              </p>
            </div>

            <!-- App URL -->
            <div>
              <label class="block text-base font-semibold text-gray-900 mb-2">
                URL de l'application
              </label>
              <input
                v-model="settings.app_url"
                type="url"
                class="block w-full px-4 py-3.5 text-gray-900 border border-gray-200 rounded-2xl 
                  focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors text-lg"
              />
              <p class="mt-2 text-sm text-gray-500">
                L'URL principale de votre application
              </p>
            </div>

            <!-- Contact Email -->
            <div>
              <label class="block text-base font-semibold text-gray-900 mb-2">
                Email de contact
              </label>
              <input
                v-model="settings.contact_email"
                type="email"
                class="block w-full px-4 py-3.5 text-gray-900 border border-gray-200 rounded-2xl 
                  focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors text-lg"
              />
              <p class="mt-2 text-sm text-gray-500">
                L'adresse email principale de contact
              </p>
            </div>

            <!-- Maintenance Mode -->
            <div>
              <label class="block text-base font-semibold text-gray-900 mb-2">
                Mode maintenance
              </label>
              <div class="flex items-center bg-gray-50 p-4 rounded-2xl">
                <Switch
                  v-model="settings.maintenance_mode"
                  :class="[settings.maintenance_mode ? 'bg-primary-600' : 'bg-gray-200']"
                  class="relative inline-flex h-7 w-14 flex-shrink-0 cursor-pointer rounded-full border-2 
                    border-transparent transition-colors duration-200 ease-in-out"
                >
                  <span
                    :class="[settings.maintenance_mode ? 'translate-x-7' : 'translate-x-0']"
                    class="pointer-events-none relative inline-block h-6 w-6 transform rounded-full 
                      bg-white shadow ring-0 transition duration-200 ease-in-out"
                  />
                </Switch>
                <span class="ml-3 text-base text-gray-700">
                  {{ settings.maintenance_mode ? 'Mode maintenance activé' : 'Mode maintenance désactivé' }}
                </span>
              </div>
              <p class="mt-2 text-sm text-gray-500">
                Active le mode maintenance sur toute la plateforme
              </p>
            </div>
          </div>
        </UCard>

      </div>

      <!-- Email Settings -->
      <div v-if="activeTab === 'email'" class="space-y-6">
        <UCard>
          <template #header>
            <h2 class="text-lg font-medium text-gray-900">Configuration Email</h2>
            <p class="text-sm text-gray-500 mt-1">Paramètres du serveur SMTP</p>
          </template>

          <div class="space-y-6">
            <!-- SMTP Host -->
            <div>
              <label class="block text-base font-semibold text-gray-900 mb-2">
                Serveur SMTP
              </label>
              <input
                v-model="settings.smtp_host"
                type="text"
                class="block w-full px-4 py-3.5 text-gray-900 border border-gray-200 rounded-2xl 
                  focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors text-lg"
                placeholder="smtp.example.com"
              />
            </div>

            <!-- SMTP Port -->
            <div>
              <label class="block text-base font-semibold text-gray-900 mb-2">
                Port SMTP
              </label>
              <input
                v-model="settings.smtp_port"
                type="number"
                class="block w-full px-4 py-3.5 text-gray-900 border border-gray-200 rounded-2xl 
                  focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors text-lg"
                placeholder="587"
              />
            </div>

            <!-- SMTP Credentials -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div>
                <label class="block text-base font-semibold text-gray-900 mb-2">
                  Utilisateur SMTP
                </label>
                <input
                  v-model="settings.smtp_user"
                  type="text"
                  class="block w-full px-4 py-3.5 text-gray-900 border border-gray-200 rounded-2xl 
                    focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors text-lg"
                />
              </div>
              <div>
                <label class="block text-base font-semibold text-gray-900 mb-2">
                  Mot de passe SMTP
                </label>
                <input
                  v-model="settings.smtp_password"
                  type="password"
                  class="block w-full px-4 py-3.5 text-gray-900 border border-gray-200 rounded-2xl 
                    focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors text-lg"
                />
              </div>
            </div>

            <!-- Test Email Button -->
            <div class="mt-6">
              <UButton
                icon="i-heroicons-paper-airplane"
                @click="sendTestEmail"
                :loading="sending"
              >
                Envoyer un email test
              </UButton>
            </div>
          </div>
        </UCard>
      </div>

      <!-- Legal Settings -->
      <div v-if="activeTab === 'legal'" class="space-y-6">
        <!-- CGU -->
        <UCard>
          <template #header>
            <div class="flex items-center justify-between">
              <div>
                <h2 class="text-lg font-medium text-gray-900">Conditions Générales d'Utilisation</h2>
                <p class="text-sm text-gray-500 mt-1">
                  Dernière mise à jour: {{ formatDate(settings.cgu_last_updated) }}
                </p>
              </div>
              <UButton
                icon="i-heroicons-check"
                @click="updateLegalDocument('cgu')"
                :loading="saving"
              >
                Mettre à jour
              </UButton>
            </div>
          </template>

          <div class="border border-gray-200 rounded-lg overflow-hidden">
            <div class="bg-gray-50 px-4 py-3 border-b border-gray-200 flex items-center">
              <span class="text-sm font-medium text-gray-700">Éditeur de texte enrichi</span>
              <div class="ml-auto flex space-x-2">
                <button class="p-1.5 rounded hover:bg-gray-200" title="Gras">
                  <Bold class="h-4 w-4 text-gray-700" />
                </button>
                <button class="p-1.5 rounded hover:bg-gray-200" title="Italique">
                  <Italic class="h-4 w-4 text-gray-700" />
                </button>
                <button class="p-1.5 rounded hover:bg-gray-200" title="Liste à puces">
                  <List class="h-4 w-4 text-gray-700" />
                </button>
              </div>
            </div>
            <textarea
              v-model="settings.cgu_content"
              rows="10"
              class="w-full px-4 py-3 border-0 focus:ring-0"
              placeholder="Saisissez ici vos CGU..."
            ></textarea>
          </div>
        </UCard>

        <!-- Similar cards for Privacy Policy and Legal Notice -->
      </div>
    </div>
  </div>

  <!-- Notification -->
  <UNotification
    v-model="notification.show"
    :title="notification.title"
    :text="notification.message"
    :type="notification.type"
  />
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { Dialog, DialogPanel, DialogTitle, TransitionRoot, TransitionChild, Switch } from '@headlessui/vue'
import { format } from 'date-fns'
import { fr } from 'date-fns/locale'
import { 
  Settings, Mail, Bell, CreditCard, AlertTriangle, CheckCircle, 
  Info, X, Save, Loader2, ShieldCheck, Phone, Globe, Sliders,
  FileText, Brain, Bold, Italic, List, Eye
} from 'lucide-vue-next'

const client = useSupabaseClient()

// State variables
const activeTab = ref('general')
const settings = ref({
  app_name: 'Havoo',
  app_url: 'https://havoo.fr',
  app_description: 'Plateforme de mise en relation entre clients et experts',
  contact_email: 'contact@havoo.fr',
  contact_phone: '+33 1 23 45 67 89',
  maintenance_mode: false,
  
  // AI Model settings
  ai_default_model: 'gpt-3.5-turbo',
  openai_api_key: '',
  ai_features_enabled: true,
  ai_suggestions_enabled: false,
  
  service_commission: 10,
  expert_validation_days: 3,
  auto_assign_experts: false,
  allow_user_professions: true,
  
  smtp_host: 'smtp.example.com',
  smtp_port: 587,
  smtp_user: 'user@example.com',
  smtp_password: '',
  mail_from_location: 'noreply@havoo.fr',
  enable_email_notifications: true,
  
  currency: 'XOF',
  payment_delay_days: 14,
  enable_payment: true,
  
  // Legal documents
  cgu_content: 'Les conditions générales d\'utilisation de Havoo seront définies ici.',
  cgu_last_updated: null,
  privacy_content: 'La politique de confidentialité de Havoo sera définie ici.',
  privacy_last_updated: null,
  legal_notice_content: 'Les mentions légales de Havoo seront définies ici.',
  legal_notice_last_updated: null
})

const notification = ref({
  show: false,
  type: 'success',
  title: '',
  message: ''
})

const saving = ref(false)
const tabs = [
  { id: 'general', label: 'Général', icon: Settings },
  { id: 'email', label: 'Email', icon: Mail },
  { id: 'legal', label: 'CGU & Mentions', icon: FileText },
]

// Load settings
onMounted(async () => {
  await init()
})

const init = async () => {
  try {
    // Afficher indicateur de chargement
    showNotification('info', 'Chargement', 'Chargement des paramètres en cours...')
    
    // Vérifier la connexion à Supabase
    const isConnected = await checkSupabaseConnection()
    if (!isConnected) {
      throw new Error('Impossible de se connecter à la base de données. Veuillez vérifier votre connexion internet ou réessayer plus tard.')
    }
    
    // Charger les paramètres
    await loadSettings()
    
    // Masquer la notification après chargement réussi
    notification.value.show = false
  } catch (err) {
    console.error('Erreur lors de l\'initialisation:', err)
    showNotification('error', 'Erreur d\'initialisation', err.message || 'Erreur inconnue')
  }
}

// Vérifier la connexion à Supabase
const checkSupabaseConnection = async () => {
  try {
    // On fait une simple requête pour vérifier la connexion
    const { count, error } = await client
      .from('settings')
      .select('*', { count: 'exact', head: true })
    
    if (error) {
      console.error('Erreur de connexion à Supabase:', error)
      return false
    }
    
    return true
  } catch (err) {
    console.error('Erreur lors de la vérification de connexion:', err)
    return false
  }
}

// Handle Supabase errors
const handleSupabaseError = (error, operation) => {
  console.error(`Erreur Supabase (${operation}):`, error)
  
  // Gérer les différents types d'erreurs
  if (error.code === 'PGRST301') {
    return 'Authentification requise. Veuillez vous reconnecter.'
  } else if (error.code === '42501') {
    return 'Vous n\'avez pas les permissions nécessaires pour effectuer cette opération.'
  } else if (error.code === '23505') {
    return 'Un paramètre avec cette clé existe déjà.'
  } else if (error.message) {
    return error.message
  } else {
    return `Erreur lors de l'opération: ${operation}`
  }
}

// Load settings
const loadSettings = async () => {
  try {
    const { data, error } = await client.from('settings').select('*')
    
    if (error) {
      const errorMessage = handleSupabaseError(error, 'chargement des paramètres')
      throw new Error(errorMessage)
    }
    
    if (data && data.length > 0) {
      // Transform the array of settings into an object
      const settingsObject = {}
      data.forEach(item => {
        settingsObject[item.key] = item.value
      })
      
      // Merge with default settings while preserving defaults for missing values
      settings.value = {
        ...settings.value,
        ...settingsObject
      }
      
      console.log('Paramètres chargés avec succès:', settings.value)
    } else {
      // If no settings exist yet, initialize with defaults
      console.log('Aucun paramètre trouvé, initialisation avec les valeurs par défaut')
      await createDefaultSettings()
    }
  } catch (err) {
    showNotification('error', 'Erreur', 'Impossible de charger les paramètres: ' + (err.message || 'Erreur inconnue'))
    throw err
  }
}

// Create default settings in Supabase
const createDefaultSettings = async () => {
  try {
    saving.value = true
    showNotification('info', 'Initialisation', 'Création des paramètres par défaut...')
    
    // Créer un tableau de toutes les valeurs par défaut
    const defaultSettings = Object.entries(settings.value).map(([key, value]) => ({
      key,
      value,
      created_at: new Date().toISOString(),
      updated_at: new Date().toISOString()
    }))
    
    // Insérer tous les paramètres par défaut
    const { error } = await client.from('settings').upsert(defaultSettings)
    
    if (error) {
      const errorMessage = handleSupabaseError(error, 'création des paramètres par défaut')
      throw new Error(errorMessage)
    }
    
    // Log l'activité
    await logActivity('settings_initialized', 'Paramètres système initialisés avec les valeurs par défaut')
    
    console.log('Paramètres par défaut créés avec succès')
    showNotification('success', 'Initialisation terminée', 'Les paramètres par défaut ont été créés avec succès.')
    
    return true
  } catch (err) {
    console.error('Erreur lors de la création des paramètres par défaut:', err)
    showNotification('error', 'Erreur d\'initialisation', 'Impossible de créer les paramètres par défaut: ' + (err.message || 'Erreur inconnue'))
    return false
  } finally {
    saving.value = false
  }
}

// Function to reset settings to default values
const resetToDefaults = async () => {
  try {
    // Confirmation de l'utilisateur
    if (!confirm('Êtes-vous sûr de vouloir réinitialiser tous les paramètres aux valeurs par défaut ? Cette action est irréversible.')) {
      return
    }
    
    saving.value = true
    showNotification('info', 'Réinitialisation', 'Réinitialisation des paramètres en cours...')
    
    // Supprimer tous les paramètres existants
    const { error: deleteError } = await client.from('settings').delete().neq('key', '')
    
    if (deleteError) {
      const errorMessage = handleSupabaseError(deleteError, 'suppression des paramètres existants')
      throw new Error(errorMessage)
    }
    
    // Recréer les paramètres par défaut
    const success = await createDefaultSettings()
    
    if (!success) {
      throw new Error('Échec de la création des paramètres par défaut')
    }
    
    // Log l'activité
    await logActivity('settings_reset', 'Paramètres système réinitialisés aux valeurs par défaut')
    
    showNotification('success', 'Réinitialisation terminée', 'Les paramètres ont été réinitialisés aux valeurs par défaut.')
  } catch (err) {
    console.error('Erreur lors de la réinitialisation des paramètres:', err)
    showNotification('error', 'Erreur de réinitialisation', 'Impossible de réinitialiser les paramètres: ' + (err.message || 'Erreur inconnue'))
  } finally {
    saving.value = false
  }
}

// Save all settings
const saveAllSettings = async () => {
  try {
    saving.value = true
    
    // Validate settings before saving
    const { isValid, errors } = validateSettings()
    
    if (!isValid) {
      // Show error notification with all validation errors
      const errorMessage = `Veuillez corriger les erreurs suivantes :\n${errors.join('\n')}`
      showNotification('error', 'Erreurs de validation', errorMessage)
      return
    }
    
    // Vérifier la connexion à Supabase
    const isConnected = await checkSupabaseConnection()
    if (!isConnected) {
      throw new Error('Impossible de se connecter à la base de données. Veuillez vérifier votre connexion internet ou réessayer plus tard.')
    }
    
    // Transform the settings object into an array of upsert operations
    const settingsToUpsert = Object.entries(settings.value).map(([key, value]) => ({
      key,
      value,
      updated_at: new Date().toISOString()
    }))
    
    // Log the settings being saved
    console.log('Sauvegarde des paramètres:', settingsToUpsert)
    
    // Update or insert settings in database using upsert
    const { error } = await client.from('settings').upsert(
      settingsToUpsert,
      { onConflict: 'key' }
    )
    
    if (error) {
      const errorMessage = handleSupabaseError(error, 'sauvegarde des paramètres')
      throw new Error(errorMessage)
    }
    
    // Log activity
    await logActivity('settings_updated', 'Paramètres système mis à jour')
    
    showNotification('success', 'Paramètres enregistrés', 'Les paramètres ont été mis à jour avec succès.')
  } catch (err) {
    console.error('Erreur lors de la sauvegarde des paramètres:', err.message, err)
    showNotification('error', 'Erreur', 'Impossible de sauvegarder les paramètres: ' + (err.message || 'Erreur inconnue'))
  } finally {
    saving.value = false
  }
}

// Save a single setting
const saveSetting = async (key, value) => {
  try {
    const { error } = await client.from('settings').upsert(
      {
        key,
        value,
        updated_at: new Date().toISOString()
      },
      { onConflict: 'key' }
    )
    
    if (error) {
      const errorMessage = handleSupabaseError(error, `sauvegarde du paramètre ${key}`)
      throw new Error(errorMessage)
    }
    
    showNotification('success', 'Paramètre enregistré', `Le paramètre "${key}" a été mis à jour avec succès.`)
    return true
  } catch (err) {
    console.error(`Erreur lors de la sauvegarde du paramètre ${key}:`, err)
    showNotification('error', 'Erreur', `Impossible de sauvegarder le paramètre "${key}": ` + (err.message || 'Erreur inconnue'))
    return false
  }
}

// Récupérer un paramètre spécifique
const getSetting = async (key, defaultValue = null) => {
  try {
    const { data, error } = await client
      .from('settings')
      .select('value')
      .eq('key', key)
      .single()
    
    if (error) {
      if (error.code === 'PGRST116') { // Code for "No rows found"
        // If setting doesn't exist, create it with default value
        if (defaultValue !== null) {
          await saveSetting(key, defaultValue)
        }
        return defaultValue
      }
      
      const errorMessage = handleSupabaseError(error, `récupération du paramètre ${key}`)
      throw new Error(errorMessage)
    }
    
    return data?.value || defaultValue
  } catch (err) {
    console.error(`Erreur lors de la récupération du paramètre ${key}:`, err)
    return defaultValue
  }
}

// Supprimer un paramètre
const deleteSetting = async (key) => {
  try {
    const { error } = await client
      .from('settings')
      .delete()
      .eq('key', key)
    
    if (error) {
      const errorMessage = handleSupabaseError(error, `suppression du paramètre ${key}`)
      throw new Error(errorMessage)
    }
    
    showNotification('success', 'Paramètre supprimé', `Le paramètre "${key}" a été supprimé avec succès.`)
    return true
  } catch (err) {
    console.error(`Erreur lors de la suppression du paramètre ${key}:`, err)
    showNotification('error', 'Erreur', `Impossible de supprimer le paramètre "${key}": ` + (err.message || 'Erreur inconnue'))
    return false
  }
}

// Log activity
const logActivity = async (type, title) => {
  try {
    const { error } = await client
      .from('activities')
      .insert({
        type,
        title,
        description: 'Modification des paramètres système'
      })
    
    if (error) {
      console.error('Erreur lors de l\'enregistrement de l\'activité:', error)
    }
  } catch (error) {
    console.error('Erreur lors de l\'enregistrement de l\'activité:', error)
  }
}

// Send test email
const sendTestEmail = async () => {
  try {
    showNotification('info', 'Envoi en cours', 'Tentative d\'envoi d\'un email de test...')
    
    // Vérifier les paramètres SMTP
    if (!settings.value.smtp_host || !settings.value.smtp_port || !settings.value.smtp_user) {
      throw new Error('Configuration SMTP incomplète. Veuillez remplir tous les champs SMTP.')
    }
    
    if (!settings.value.mail_from_location || !settings.value.contact_email) {
      throw new Error('Adresses email manquantes. Veuillez définir une adresse d\'expéditeur et de contact.')
    }
    
    // Call your email sending function here
    const { error } = await client.functions.invoke('send-test-email', {
      body: { 
        to: settings.value.contact_email,
        from: settings.value.mail_from_location,
        subject: 'Test email de Havoo',
        smtp: {
          host: settings.value.smtp_host,
          port: settings.value.smtp_port,
          user: settings.value.smtp_user,
          pass: settings.value.smtp_password
        }
      }
    })
    
    if (error) throw error
    
    // Log activity
    await logActivity('email_test', 'Email de test envoyé')
    
    showNotification('success', 'Email envoyé', 'L\'email de test a été envoyé avec succès.')
  } catch (err) {
    console.error('Erreur lors de l\'envoi de l\'email:', err)
    showNotification('error', 'Erreur', 'Impossible d\'envoyer l\'email de test: ' + (err.message || 'Erreur inconnue'))
  }
}

// Show notification
const showNotification = (type, title, message) => {
  notification.value = {
    show: true,
    type,
    title,
    message
  }
  
  // Auto-hide after 5 seconds only for success and info notifications
  if (type !== 'error') {
  setTimeout(() => {
      // Only hide this specific notification (not a new one that might have appeared)
      if (notification.value.title === title && notification.value.message === message) {
    notification.value.show = false
      }
  }, 5000)
  }
}

// Update a legal document
const updateLegalDocument = async (docType) => {
  try {
    const now = new Date().toISOString()
    
    if (docType === 'cgu') {
      settings.value.cgu_last_updated = now
      await saveSetting('cgu_content', settings.value.cgu_content)
      await saveSetting('cgu_last_updated', now)
    } else if (docType === 'privacy') {
      settings.value.privacy_last_updated = now
      await saveSetting('privacy_content', settings.value.privacy_content)
      await saveSetting('privacy_last_updated', now)
    } else if (docType === 'legal_notice') {
      settings.value.legal_notice_last_updated = now
      await saveSetting('legal_notice_content', settings.value.legal_notice_content)
      await saveSetting('legal_notice_last_updated', now)
    }
    
    // Log activity
    await logActivity('legal_doc_updated', `Document légal mis à jour: ${docType}`)
    
    showNotification('success', 'Document mis à jour', `Le document a été mis à jour avec succès.`)
  } catch (err) {
    console.error(`Erreur lors de la mise à jour du document ${docType}:`, err)
    showNotification('error', 'Erreur', `Impossible de mettre à jour le document: ` + (err.message || 'Erreur inconnue'))
  }
}

// Format date for displaying in the UI
const formatDate = (dateString) => {
  if (!dateString) return 'Jamais'
  
  const date = new Date(dateString)
  return date.toLocaleDateString('fr-FR', {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  })
}

// Validate settings before saving
const validateSettings = () => {
  const errors = []
  
  // Valider les paramètres généraux
  if (!settings.value.app_name) {
    errors.push('Le nom de l\'application est requis')
  }
  
  if (settings.value.app_url && !isValidUrl(settings.value.app_url)) {
    errors.push('L\'URL du site doit être une URL valide')
  }
  
  if (settings.value.contact_email && !isValidEmail(settings.value.contact_email)) {
    errors.push('L\'email de contact doit être une adresse email valide')
  }
  
  // Valider les paramètres SMTP si l'envoi d'email est activé
  if (settings.value.enable_email_notifications) {
    if (!settings.value.smtp_host) {
      errors.push('Le serveur SMTP est requis lorsque les notifications par email sont activées')
    }
    
    if (!settings.value.smtp_port || isNaN(settings.value.smtp_port)) {
      errors.push('Le port SMTP doit être un nombre valide')
    }
    
    if (!settings.value.smtp_user) {
      errors.push('L\'utilisateur SMTP est requis')
    }
    
    if (!settings.value.mail_from_location || !isValidEmail(settings.value.mail_from_location)) {
      errors.push('L\'adresse d\'expéditeur doit être une adresse email valide')
    }
  }
  
  // Validation des taux pour les services
  if (settings.value.service_commission < 0 || settings.value.service_commission > 100) {
    errors.push('La commission sur les services doit être comprise entre 0 et 100')
  }
  
  if (settings.value.expert_validation_days < 1) {
    errors.push('Le délai de validation des experts doit être d\'au moins 1 jour')
  }
  
  return {
    isValid: errors.length === 0,
    errors
  }
}

// Helper function to validate email
const isValidEmail = (email) => {
  const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
  return re.test(email)
}

// Helper function to validate URL
const isValidUrl = (url) => {
  try {
    new URL(url)
    return true
  } catch (e) {
    return false
  }
}

// Page configuration
definePageMeta({
  layout: 'admin',
})
</script> 
