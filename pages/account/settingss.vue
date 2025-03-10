<template>
  <div class="min-h-screen bg-white">
    <!-- Navigation du compte - style Uber (identique à la page profil) -->
    <div class="fixed bottom-0 left-0 right-0 bg-white border-t border-gray-200 z-40 md:relative md:border-t-0 md:border-b md:mb-8">
      <div class="max-w-4xl mx-auto px-2 md:px-5">
        <div class="flex justify-between items-center overflow-x-auto no-scrollbar">
          <NuxtLink 
            v-for="item in navItems" 
            :key="item.path"
            :to="item.path"
            class="flex flex-col items-center py-3 px-3 min-w-[72px] md:min-w-0 md:flex-row md:py-4"
            :class="$route.path === item.path ? 'text-black' : 'text-gray-400 hover:text-gray-600'"
          >
            <component :is="item.icon" class="h-6 w-6 mb-1 md:mr-2 md:mb-0" />
            <span class="text-xs md:text-sm font-medium">{{ item.name }}</span>
          </NuxtLink>
        </div>
      </div>
    </div>

    <!-- En-tête simple -->
    <div class="border-b border-gray-200">
      <div class="max-w-4xl mx-auto px-5 py-5 flex items-center">
        <h1 class="text-2xl font-bold text-black">Paramètres</h1>
      </div>
    </div>
    
    <!-- Contenu principal -->
    <div class="max-w-4xl mx-auto px-5 py-8 pb-24 md:pb-8">
      <!-- État de chargement -->
      <div v-if="loading" class="flex justify-center py-12">
        <Loader2 class="h-8 w-8 text-gray-400 animate-spin" />
      </div>
      
      <!-- Contenu des paramètres -->
      <div v-else class="space-y-10">
        <!-- Section Sécurité -->
        <div>
          <h2 class="text-xl font-bold text-black mb-6 flex items-center">
            <Shield class="h-5 w-5 mr-2" />
            Sécurité
          </h2>
          
          <div class="space-y-6">
            <!-- Changement de mot de passe -->
            <div class="bg-gray-50 rounded-xl p-5 border border-gray-100">
              <div class="flex justify-between items-start mb-4">
                <div>
                  <h3 class="font-medium text-lg text-gray-900">Mot de passe</h3>
                  <p class="text-gray-600 text-sm mt-1">Mettez à jour votre mot de passe pour sécuriser votre compte</p>
                </div>
                <button 
                  @click="showPasswordForm = !showPasswordForm"
                  class="px-4 py-2 text-sm font-medium text-black border border-gray-300 rounded-full hover:bg-gray-100 transition-colors"
                >
                  Modifier
                </button>
              </div>
              
              <!-- Formulaire de changement de mot de passe -->
              <div v-if="showPasswordForm" class="mt-4 pt-4 border-t border-gray-200 space-y-4">
                <div>
                  <label for="current_password" class="block text-sm font-medium text-gray-700 mb-1">
                    Mot de passe actuel <span class="text-red-500">*</span>
                  </label>
                  <div class="relative">
                    <input
                      id="current_password"
                      v-model="passwordForm.current"
                      :type="showCurrentPassword ? 'text' : 'password'"
                      class="w-full p-3 text-base border-2 border-gray-200 rounded-lg focus:border-black focus:outline-none transition-colors pr-10"
                    />
                    <button 
                      @click="showCurrentPassword = !showCurrentPassword"
                      type="button"
                      class="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400 hover:text-gray-600"
                    >
                      <Eye v-if="showCurrentPassword" class="h-5 w-5" />
                      <EyeOff v-else class="h-5 w-5" />
                    </button>
                  </div>
                </div>
                
                <div>
                  <label for="new_password" class="block text-sm font-medium text-gray-700 mb-1">
                    Nouveau mot de passe <span class="text-red-500">*</span>
                  </label>
                  <div class="relative">
                    <input
                      id="new_password"
                      v-model="passwordForm.new"
                      :type="showNewPassword ? 'text' : 'password'"
                      class="w-full p-3 text-base border-2 border-gray-200 rounded-lg focus:border-black focus:outline-none transition-colors pr-10"
                    />
                    <button 
                      @click="showNewPassword = !showNewPassword"
                      type="button"
                      class="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400 hover:text-gray-600"
                    >
                      <Eye v-if="showNewPassword" class="h-5 w-5" />
                      <EyeOff v-else class="h-5 w-5" />
                    </button>
                  </div>
                  <p class="text-xs text-gray-500 mt-1">Au moins 8 caractères, avec majuscules, minuscules et chiffres</p>
                </div>
                
                <div>
                  <label for="confirm_password" class="block text-sm font-medium text-gray-700 mb-1">
                    Confirmer le mot de passe <span class="text-red-500">*</span>
                  </label>
                  <input
                    id="confirm_password"
                    v-model="passwordForm.confirm"
                    type="password"
                    class="w-full p-3 text-base border-2 border-gray-200 rounded-lg focus:border-black focus:outline-none transition-colors"
                  />
                </div>
                
                <div class="flex justify-end gap-3 pt-2">
                  <button 
                    @click="showPasswordForm = false"
                    class="px-5 py-2.5 text-gray-700 font-medium rounded-full hover:bg-gray-100 transition-colors"
                  >
                    Annuler
                  </button>
                  <button 
                    @click="updatePassword"
                    :disabled="updatingPassword"
                    class="px-5 py-2.5 bg-black text-white font-medium rounded-full hover:bg-gray-800 transition-colors disabled:opacity-50 disabled:cursor-not-allowed flex items-center"
                  >
                    <Loader2 v-if="updatingPassword" class="animate-spin h-4 w-4 mr-2" />
                    Enregistrer
                  </button>
                </div>
              </div>
            </div>
            
            <!-- Double authentification -->
            <div class="bg-gray-50 rounded-xl p-5 border border-gray-100">
              <div class="flex justify-between items-start">
                <div>
                  <h3 class="font-medium text-lg text-gray-900">Double authentification</h3>
                  <p class="text-gray-600 text-sm mt-1">Renforcez la sécurité de votre compte avec une vérification en deux étapes</p>
                </div>
                <div class="flex items-center">
                  <Switch
                    v-model="twoFactorEnabled"
                    class="relative inline-flex h-6 w-11 items-center rounded-full"
                    :class="twoFactorEnabled ? 'bg-black' : 'bg-gray-300'"
                  >
                    <span class="sr-only">Activer la double authentification</span>
                    <span
                      class="inline-block h-4 w-4 transform rounded-full bg-white transition"
                      :class="twoFactorEnabled ? 'translate-x-6' : 'translate-x-1'"
                    />
                  </Switch>
                </div>
              </div>
            </div>
          </div>
        </div>
        
        <!-- Section Notifications -->
        <div>
          <h2 class="text-xl font-bold text-black mb-6 flex items-center">
            <Bell class="h-5 w-5 mr-2" />
            Notifications
          </h2>
          
          <div class="space-y-4">
            <div class="p-5 border border-gray-200 rounded-xl flex justify-between items-start">
              <div>
                <h3 class="font-medium text-gray-900">Notifications par email</h3>
                <p class="text-gray-600 text-sm mt-1">Recevoir des notifications par email</p>
              </div>
              <div class="flex items-center">
                <Switch
                  v-model="notificationSettings.email"
                  class="relative inline-flex h-6 w-11 items-center rounded-full"
                  :class="notificationSettings.email ? 'bg-black' : 'bg-gray-300'"
                >
                  <span class="sr-only">Activer les notifications par email</span>
                  <span
                    class="inline-block h-4 w-4 transform rounded-full bg-white transition"
                    :class="notificationSettings.email ? 'translate-x-6' : 'translate-x-1'"
                  />
                </Switch>
              </div>
            </div>
            
            <div class="p-5 border border-gray-200 rounded-xl flex justify-between items-start">
              <div>
                <h3 class="font-medium text-gray-900">Notifications push</h3>
                <p class="text-gray-600 text-sm mt-1">Recevoir des notifications sur votre appareil</p>
              </div>
              <div class="flex items-center">
                <Switch
                  v-model="notificationSettings.push"
                  class="relative inline-flex h-6 w-11 items-center rounded-full"
                  :class="notificationSettings.push ? 'bg-black' : 'bg-gray-300'"
                >
                  <span class="sr-only">Activer les notifications push</span>
                  <span
                    class="inline-block h-4 w-4 transform rounded-full bg-white transition"
                    :class="notificationSettings.push ? 'translate-x-6' : 'translate-x-1'"
                  />
                </Switch>
              </div>
            </div>
            
            <div class="p-5 border border-gray-200 rounded-xl flex justify-between items-start">
              <div>
                <h3 class="font-medium text-gray-900">Newsletters et offres</h3>
                <p class="text-gray-600 text-sm mt-1">Recevoir des actualités et offres promotionnelles</p>
              </div>
              <div class="flex items-center">
                <Switch
                  v-model="notificationSettings.marketing"
                  class="relative inline-flex h-6 w-11 items-center rounded-full"
                  :class="notificationSettings.marketing ? 'bg-black' : 'bg-gray-300'"
                >
                  <span class="sr-only">Activer les newsletters</span>
                  <span
                    class="inline-block h-4 w-4 transform rounded-full bg-white transition"
                    :class="notificationSettings.marketing ? 'translate-x-6' : 'translate-x-1'"
                  />
                </Switch>
              </div>
            </div>
          </div>
          
          <div class="flex justify-end mt-6">
            <button 
              @click="saveNotificationSettings"
              :disabled="savingNotifications"
              class="px-5 py-2.5 bg-black text-white font-medium rounded-full hover:bg-gray-800 transition-colors disabled:opacity-50 disabled:cursor-not-allowed flex items-center"
            >
              <Loader2 v-if="savingNotifications" class="animate-spin h-4 w-4 mr-2" />
              Enregistrer les préférences
            </button>
          </div>
        </div>
        
        <!-- Section Confidentialité -->
        <div>
          <h2 class="text-xl font-bold text-black mb-6 flex items-center">
            <Lock class="h-5 w-5 mr-2" />
            Confidentialité
          </h2>
          
          <div class="p-5 border border-gray-200 rounded-xl flex justify-between items-start">
            <div>
              <h3 class="font-medium text-gray-900">Profil public</h3>
              <p class="text-gray-600 text-sm mt-1">Autoriser les autres utilisateurs à voir votre profil</p>
            </div>
            <div class="flex items-center">
              <Switch
                v-model="privacySettings.publicProfile"
                class="relative inline-flex h-6 w-11 items-center rounded-full"
                :class="privacySettings.publicProfile ? 'bg-black' : 'bg-gray-300'"
              >
                <span class="sr-only">Rendre le profil public</span>
                <span
                  class="inline-block h-4 w-4 transform rounded-full bg-white transition"
                  :class="privacySettings.publicProfile ? 'translate-x-6' : 'translate-x-1'"
                />
              </Switch>
            </div>
          </div>
          
          <div class="flex justify-end mt-6">
            <button 
              @click="savePrivacySettings"
              :disabled="savingPrivacy"
              class="px-5 py-2.5 bg-black text-white font-medium rounded-full hover:bg-gray-800 transition-colors disabled:opacity-50 disabled:cursor-not-allowed flex items-center"
            >
              <Loader2 v-if="savingPrivacy" class="animate-spin h-4 w-4 mr-2" />
              Enregistrer les préférences
            </button>
          </div>
        </div>
        
        <!-- Section Suppression de compte -->
        <div>
          <h2 class="text-xl font-bold text-black mb-6 flex items-center">
            <Trash2 class="h-5 w-5 mr-2" />
            Suppression de compte
          </h2>
          
          <div class="bg-red-50 rounded-xl p-5 border border-red-100">
            <h3 class="font-medium text-red-700">Supprimer mon compte</h3>
            <p class="text-red-600 text-sm mt-1 mb-4">
              Cette action est irréversible. Toutes vos données seront définitivement supprimées.
            </p>
            <button 
              @click="showDeleteAccountConfirm = true"
              class="px-5 py-2.5 bg-white text-red-600 font-medium rounded-full border border-red-300 hover:bg-red-50 transition-colors"
            >
              Supprimer mon compte
            </button>
          </div>
        </div>
      </div>
    </div>
    
    <!-- Modal de confirmation pour la suppression du compte -->
    <Teleport to="body">
      <div v-if="showDeleteAccountConfirm" class="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
        <div class="bg-white rounded-xl p-6 max-w-md w-full">
          <AlertTriangle class="h-10 w-10 text-red-500 mx-auto mb-4" />
          <h3 class="text-xl font-bold text-center mb-2">Êtes-vous sûr ?</h3>
          <p class="text-gray-600 text-center mb-6">
            Cette action est irréversible. Votre compte et toutes les données associées seront définitivement supprimés.
          </p>
          <div class="flex flex-col sm:flex-row gap-3 justify-center">
            <button 
              @click="showDeleteAccountConfirm = false"
              class="order-2 sm:order-1 px-5 py-3 text-gray-700 font-medium rounded-full hover:bg-gray-100 transition-colors"
            >
              Annuler
            </button>
            <button 
              @click="deleteAccount"
              :disabled="deletingAccount"
              class="order-1 sm:order-2 px-5 py-3 bg-red-600 text-white font-medium rounded-full hover:bg-red-700 transition-colors disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center"
            >
              <Loader2 v-if="deletingAccount" class="animate-spin h-4 w-4 mr-2" />
              Supprimer définitivement
            </button>
          </div>
        </div>
      </div>
    </Teleport>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { 
  User, ChevronLeft, Shield, Bell, Lock, Trash2, Eye, EyeOff, 
  Home, Settings, FileText, CreditCard, Loader2, AlertTriangle, 
  UserCog, List, LogOut
} from 'lucide-vue-next'
import { Switch } from '@headlessui/vue'

const router = useRouter()
const client = useSupabaseClient()

// État de chargement
const loading = ref(true)

// Navigation items
const navItems = [
  { path: '/account', name: 'Profil', icon: User },
  { path: '/account/my-demands', name: 'Demandes', icon: List },
  { path: '/account/settings', name: 'Paramètres', icon: Settings },
]

// Password form state
const showPasswordForm = ref(false)
const showCurrentPassword = ref(false)
const showNewPassword = ref(false)
const updatingPassword = ref(false)
const passwordForm = reactive({
  current: '',
  new: '',
  confirm: ''
})

// Notification settings
const notificationSettings = reactive({
  email: true,
  push: false,
  marketing: true
})
const savingNotifications = ref(false)

// Privacy settings
const privacySettings = reactive({
  publicProfile: true
})
const savingPrivacy = ref(false)

// Two-factor authentication
const twoFactorEnabled = ref(false)

// Delete account
const showDeleteAccountConfirm = ref(false)
const deletingAccount = ref(false)

// Fetch user settings
const fetchSettings = async () => {
  try {
    loading.value = true
    
    const { data: { user }, error: authError } = await client.auth.getUser()
    if (authError) throw authError
    if (!user) {
      router.push('/auth/login')
      return
    }
    
    // Fetch notification and privacy settings
    const { data, error } = await client
      .from('user_settings')
      .select('*')
      .eq('user_id', user.id)
      .single()
    
    if (error && error.code !== 'PGSQL_ERROR') throw error
    
    // If there are settings, populate the reactive objects
    if (data) {
      notificationSettings.email = data.notification_email || true
      notificationSettings.push = data.notification_push || false
      notificationSettings.marketing = data.notification_marketing || true
      privacySettings.publicProfile = data.public_profile || true
      twoFactorEnabled.value = data.two_factor_enabled || false
    }
  } catch (error) {
    console.error('Erreur lors de la récupération des paramètres:', error)
  } finally {
    loading.value = false
  }
}

// Update password
const updatePassword = async () => {
  try {
    // Validate form
    if (!passwordForm.current || !passwordForm.new || !passwordForm.confirm) {
      alert('Veuillez remplir tous les champs')
      return
    }
    
    if (passwordForm.new.length < 8) {
      alert('Le nouveau mot de passe doit contenir au moins 8 caractères')
      return
    }
    
    if (passwordForm.new !== passwordForm.confirm) {
      alert('Les mots de passe ne correspondent pas')
      return
    }
    
    updatingPassword.value = true
    
    const { error } = await client.auth.updateUser({
      password: passwordForm.new
    })
    
    if (error) throw error
    
    // Reset form
    passwordForm.current = ''
    passwordForm.new = ''
    passwordForm.confirm = ''
    showPasswordForm.value = false
    
    alert('Votre mot de passe a été mis à jour')
  } catch (error) {
    console.error('Erreur lors de la mise à jour du mot de passe:', error)
    alert('Une erreur est survenue lors de la mise à jour du mot de passe')
  } finally {
    updatingPassword.value = false
  }
}

// Save notification settings
const saveNotificationSettings = async () => {
  try {
    savingNotifications.value = true
    
    const { data: { user } } = await client.auth.getUser()
    if (!user) throw new Error('Non authentifié')
    
    const { error } = await client
      .from('user_settings')
      .upsert({
        user_id: user.id,
        notification_email: notificationSettings.email,
        notification_push: notificationSettings.push,
        notification_marketing: notificationSettings.marketing,
        updated_at: new Date().toISOString()
      })
    
    if (error) throw error
    
    alert('Vos préférences de notification ont été enregistrées')
  } catch (error) {
    console.error('Erreur lors de la sauvegarde des paramètres de notification:', error)
    alert('Une erreur est survenue lors de la sauvegarde des paramètres')
  } finally {
    savingNotifications.value = false
  }
}

// Save privacy settings
const savePrivacySettings = async () => {
  try {
    savingPrivacy.value = true
    
    const { data: { user } } = await client.auth.getUser()
    if (!user) throw new Error('Non authentifié')
    
    const { error } = await client
      .from('user_settings')
      .upsert({
        user_id: user.id,
        public_profile: privacySettings.publicProfile,
        updated_at: new Date().toISOString()
      })
    
    if (error) throw error
    
    alert('Vos paramètres de confidentialité ont été enregistrés')
  } catch (error) {
    console.error('Erreur lors de la sauvegarde des paramètres de confidentialité:', error)
    alert('Une erreur est survenue lors de la sauvegarde des paramètres')
  } finally {
    savingPrivacy.value = false
  }
}

// Delete account
const deleteAccount = async () => {
  try {
    deletingAccount.value = true
    
    const { data: { user } } = await client.auth.getUser()
    if (!user) throw new Error('Non authentifié')
    
    // Delete user data from custom tables
    // Note: This is simplified, you may need more complex cascading deletes
    const { error: deleteSettingsError } = await client
      .from('user_settings')
      .delete()
      .eq('user_id', user.id)
    
    const { error: deleteProfileError } = await client
      .from('profiles')
      .delete()
      .eq('id', user.id)
    
    // Finally, delete the auth user
    const { error: deleteUserError } = await client.auth.admin.deleteUser(user.id)
    
    if (deleteUserError) throw deleteUserError
    
    // Sign out
    await client.auth.signOut()
    
    // Redirect to home
    router.push('/')
  } catch (error) {
    console.error('Erreur lors de la suppression du compte:', error)
    alert('Une erreur est survenue lors de la suppression du compte')
    showDeleteAccountConfirm.value = false
  } finally {
    deletingAccount.value = false
  }
}

// Fetch settings on mount
onMounted(fetchSettings)

definePageMeta({
  layout: 'account',
  auth: true
})
</script>

<style scoped>
/* Masquer la barre de défilement tout en permettant le défilement */
.no-scrollbar::-webkit-scrollbar {
  display: none;
}
.no-scrollbar {
  -ms-overflow-style: none;
  scrollbar-width: none;
}
</style> 