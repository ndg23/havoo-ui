<template>
  <div class="space-y-6 max-w-7xl mx-auto">
    <!-- En-tête avec style Twitter -->
    <div class="px-4 py-6">
      <h1 class="text-2xl font-bold text-gray-900 dark:text-white">Paramètres de l'application</h1>
      <p class="text-gray-600 dark:text-gray-400 mt-1">Configurez les paramètres généraux de la plateforme</p>
    </div>
    
    <!-- Notifications -->
    <div 
      v-if="notification.show" 
      class="mx-4 p-4 rounded-xl flex items-start gap-3"
      :class="[
        notification.type === 'success' ? 'bg-green-50 text-green-800 dark:bg-green-900/20 dark:text-green-400' : 
        notification.type === 'error' ? 'bg-red-50 text-red-800 dark:bg-red-900/20 dark:text-red-400' : 
        'bg-blue-50 text-blue-800 dark:bg-blue-900/20 dark:text-blue-400'
      ]"
    >
      <component 
        :is="notification.type === 'success' ? 'CheckCircle' : notification.type === 'error' ? 'AlertTriangle' : 'Info'" 
        class="h-5 w-5 mt-0.5 flex-shrink-0" 
      />
      <div>
        <h3 class="font-medium">{{ notification.title }}</h3>
        <p class="text-sm opacity-80 mt-0.5">{{ notification.message }}</p>
      </div>
      <button 
        @click="notification.show = false" 
        class="ml-auto p-1.5 rounded-full hover:bg-black/5 dark:hover:bg-white/5"
      >
        <X class="h-4 w-4" />
      </button>
    </div>
    
    <!-- Onglets de configuration -->
    <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-100 dark:border-gray-700 overflow-hidden">
      <div class="border-b border-gray-200 dark:border-gray-700">
        <nav class="flex flex-wrap">
          <button 
            v-for="tab in tabs" 
            :key="tab.id"
            @click="activeTab = tab.id"
            class="px-6 py-4 text-sm font-medium border-b-2 -mb-px transition-colors"
            :class="activeTab === tab.id ? 
              'border-primary-500 text-primary-600 dark:text-primary-400' : 
              'border-transparent text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-300'"
          >
            <component :is="tab.icon" class="h-4 w-4 inline-block mr-2" />
            {{ tab.label }}
          </button>
        </nav>
      </div>
      
      <div class="p-6">
        <!-- Paramètres généraux -->
        <div v-if="activeTab === 'general'" class="space-y-6">
          <div class="grid grid-cols-1 gap-6 md:grid-cols-2">
            <div>
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                Nom de l'application
              </label>
              <input 
                v-model="settings.app_name"
                type="text"
                class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
              />
            </div>
            
            <div>
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                URL du site
              </label>
              <input 
                v-model="settings.app_url"
                type="url"
                class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
              />
            </div>
            
            <div>
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                Email de contact
              </label>
              <input 
                v-model="settings.contact_email"
                type="email"
                class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
              />
            </div>
            
            <div>
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                Numéro de téléphone
              </label>
              <input 
                v-model="settings.contact_phone"
                type="tel"
                class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
              />
            </div>
          </div>
          
          <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
              Description de l'application
            </label>
            <textarea
              v-model="settings.app_description"
              rows="3"
              class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
            ></textarea>
          </div>
          
          <div class="flex items-center">
            <switch-toggle v-model="settings.maintenance_mode" />
            <span class="ml-2 text-sm text-gray-700 dark:text-gray-300">
              Mode maintenance
            </span>
          </div>
        </div>
        
        <!-- Paramètres des services -->
        <div v-else-if="activeTab === 'services'" class="space-y-6">
          <div class="grid grid-cols-1 gap-6 md:grid-cols-2">
            <div>
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                Commission sur les services (%)
              </label>
              <input 
                v-model="settings.service_commission"
                type="number"
                min="0"
                max="100"
                step="0.1"
                class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
              />
            </div>
            
            <div>
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                Délai de validation expert (jours)
              </label>
              <input 
                v-model="settings.expert_validation_days"
                type="number"
                min="1"
                class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
              />
            </div>
          </div>
          
          <div class="flex items-center">
            <switch-toggle v-model="settings.auto_assign_experts" />
            <span class="ml-2 text-sm text-gray-700 dark:text-gray-300">
              Attribution automatique des experts
            </span>
          </div>
          
          <div class="flex items-center">
            <switch-toggle v-model="settings.allow_user_categories" />
            <span class="ml-2 text-sm text-gray-700 dark:text-gray-300">
              Permettre aux experts de suggérer des catégories
            </span>
          </div>
        </div>
        
        <!-- Paramètres d'email -->
        <div v-else-if="activeTab === 'email'" class="space-y-6">
          <div class="grid grid-cols-1 gap-6 md:grid-cols-2">
            <div>
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                Serveur SMTP
              </label>
              <input 
                v-model="settings.smtp_host"
                type="text"
                class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
              />
            </div>
            
            <div>
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                Port SMTP
              </label>
              <input 
                v-model="settings.smtp_port"
                type="number"
                class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
              />
            </div>
            
            <div>
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                Utilisateur SMTP
              </label>
              <input 
                v-model="settings.smtp_user"
                type="text"
                class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
              />
            </div>
            
            <div>
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                Mot de passe SMTP
              </label>
              <input 
                v-model="settings.smtp_password"
                type="password"
                class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
              />
            </div>
          </div>
          
          <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
              Adresse d'expéditeur
            </label>
            <input 
              v-model="settings.mail_from_address"
              type="email"
              class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
            />
          </div>
          
          <div class="flex items-center">
            <switch-toggle v-model="settings.enable_email_notifications" />
            <span class="ml-2 text-sm text-gray-700 dark:text-gray-300">
              Activer les notifications par email
            </span>
          </div>
        </div>
        
        <!-- Paramètres de paiement -->
        <div v-else-if="activeTab === 'payment'" class="space-y-6">
          <div class="grid grid-cols-1 gap-6 md:grid-cols-2">
            <div>
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                Clé API Stripe publique
              </label>
              <input 
                v-model="settings.stripe_public_key"
                type="text"
                class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
              />
            </div>
            
            <div>
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                Clé API Stripe privée
              </label>
              <input 
                v-model="settings.stripe_secret_key"
                type="password"
                class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
              />
            </div>
            
            <div>
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                Devise par défaut
              </label>
              <select
                v-model="settings.default_currency"
                class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
              >
                <option value="EUR">Euro (FCFA)</option>
                <option value="USD">Dollar américain ($)</option>
                <option value="GBP">Livre sterling (£)</option>
              </select>
            </div>
            
            <div>
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                Délai de paiement (jours)
              </label>
              <input 
                v-model="settings.payment_delay_days"
                type="number"
                min="1"
                class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
              />
            </div>
          </div>
          
          <div class="flex items-center">
            <switch-toggle v-model="settings.enable_stripe" />
            <span class="ml-2 text-sm text-gray-700 dark:text-gray-300">
              Activer les paiements Stripe
            </span>
          </div>
          
          <div class="flex items-center">
            <switch-toggle v-model="settings.enable_paypal" />
            <span class="ml-2 text-sm text-gray-700 dark:text-gray-300">
              Activer les paiements PayPal
            </span>
          </div>
        </div>
      </div>
      
      <!-- Actions -->
      <div class="bg-gray-50 dark:bg-gray-700/30 px-6 py-4 flex justify-end">
        <button 
          @click="resetSettings"
          class="px-4 py-2 mr-3 border border-gray-300 dark:border-gray-600 rounded-md shadow-sm text-sm font-medium text-gray-700 dark:text-gray-300 bg-white dark:bg-gray-800 hover:bg-gray-50 dark:hover:bg-gray-700"
        >
          Réinitialiser
        </button>
        <button 
          @click="saveSettings"
          class="px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500"
          :disabled="isSaving"
        >
          <span v-if="isSaving">
            <svg class="animate-spin -ml-1 mr-2 h-4 w-4 text-white inline-block" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
              <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
              <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
            </svg>
            Enregistrement...
          </span>
          <span v-else>Enregistrer les modifications</span>
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useSupabaseClient } from '#imports'
import { 
  Cog, Mail, CreditCard, ShoppingBag, X, CheckCircle, AlertTriangle, Info
} from 'lucide-vue-next'

// Composant pour les interrupteurs (toggle)
const SwitchToggle = defineComponent({
  props: {
    modelValue: {
      type: Boolean,
      default: false
    }
  },
  emits: ['update:modelValue'],
  setup(props, { emit }) {
    const toggle = () => {
      emit('update:modelValue', !props.modelValue)
    }
    
    return () => h('button', {
      type: 'button',
      class: [
        'relative inline-flex h-6 w-11 flex-shrink-0 cursor-pointer rounded-full border-2 border-transparent transition-colors duration-200 ease-in-out focus:outline-none focus:ring-2 focus:ring-primary-500 focus:ring-offset-2',
        props.modelValue ? 'bg-primary-600' : 'bg-gray-200 dark:bg-gray-700'
      ],
      onClick: toggle
    }, [
      h('span', {
        class: 'sr-only'
      }, 'Toggle'),
      h('span', {
        class: [
          'pointer-events-none inline-block h-5 w-5 transform rounded-full bg-white shadow ring-0 transition duration-200 ease-in-out',
          props.modelValue ? 'translate-x-5' : 'translate-x-0'
        ]
      })
    ])
  }
})

// État
const supabase = useSupabaseClient()
const notification = ref({ show: false, type: '', title: '', message: '' })
const activeTab = ref('general')
const isSaving = ref(false)
const originalSettings = ref({})
const settings = ref({
  app_name: 'Nom de l\'application',
  app_url: 'https://exemple.com',
  app_description: 'Description de l\'application',
  contact_email: 'contact@exemple.com',
  contact_phone: '+33 1 23 45 67 89',
  maintenance_mode: false,
  
  service_commission: 10,
  expert_validation_days: 3,
  auto_assign_experts: false,
  allow_user_categories: true,
  
  smtp_host: 'smtp.exemple.com',
  smtp_port: 587,
  smtp_user: 'utilisateur',
  smtp_password: '',
  mail_from_address: 'no-reply@exemple.com',
  enable_email_notifications: true,
  
  stripe_public_key: '',
  stripe_secret_key: '',
  default_currency: 'EUR',
  payment_delay_days: 14,
  enable_stripe: false,
  enable_paypal: false
})

// Définir les onglets
const tabs = [
  { id: 'general', label: 'Général', icon: Cog },
  { id: 'services', label: 'Services', icon: ShoppingBag },
  { id: 'email', label: 'Emails', icon: Mail },
  { id: 'payment', label: 'Paiements', icon: CreditCard }
]

// Méthodes
const fetchSettings = async () => {
  try {
    const { data, error } = await supabase
      .from('app_settings')
      .select('*')
      .single()
    
    if (error) {
      console.warn('Pas de paramètres trouvés, utilisation des valeurs par défaut')
      return
    }
    
    if (data) {
      settings.value = { ...settings.value, ...data.settings }
      originalSettings.value = JSON.parse(JSON.stringify(settings.value))
    }
  } catch (err) {
    console.error('Erreur lors du chargement des paramètres:', err)
    showNotification('error', 'Erreur', 'Impossible de charger les paramètres de l\'application')
  }
}

const saveSettings = async () => {
  isSaving.value = true
  
  try {
    const { data, error } = await supabase
      .from('app_settings')
      .upsert({ 
        id: 1, 
        settings: settings.value,
        updated_at: new Date()
      })
    
    if (error) throw error
    
    originalSettings.value = JSON.parse(JSON.stringify(settings.value))
    showNotification('success', 'Paramètres enregistrés', 'Les paramètres de l\'application ont été mis à jour avec succès')
  } catch (err) {
    console.error('Erreur lors de l\'enregistrement des paramètres:', err)
    showNotification('error', 'Erreur', 'Impossible d\'enregistrer les paramètres de l\'application')
  } finally {
    isSaving.value = false
  }
}

const resetSettings = () => {
  if (confirm('Êtes-vous sûr de vouloir réinitialiser tous les paramètres aux valeurs précédentes ?')) {
    settings.value = JSON.parse(JSON.stringify(originalSettings.value))
  }
}

// Afficher une notification
const showNotification = (type, title, message = '') => {
  notification.value = {
    show: true,
    type,
    title,
    message
  }
  
  // Masquer la notification après 5 secondes
  setTimeout(() => {
    notification.value.show = false
  }, 5000)
}

// Initialisation
onMounted(() => {
  fetchSettings()
})

definePageMeta({
  layout: 'admin'
})
</script> 