<template>
  <div class="max-w-4xl mx-auto px-4 py-8">
    <!-- En-tête de la page -->
    <div class="mb-8">
      <h1 class="text-2xl font-bold text-gray-900 dark:text-white">Mon compte</h1>
      <p class="text-gray-600 dark:text-gray-400 mt-1">Gérez vos informations personnelles et vos préférences</p>
    </div>
    
    <!-- Alerte de statut -->
    <ErrorAlert 
      v-if="statusMessage.show"
      :type="statusMessage.type"
      :message="statusMessage.message"
      dismissible
      @dismiss="statusMessage.show = false"
      class="mb-6"
    />
    
    <!-- Section chargement -->
    <div v-if="isLoading" class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 p-16 animate-pulse shadow-sm">
      <div class="flex flex-col items-center justify-center">
        <div class="h-10 w-10 border-4 border-primary-500 border-t-transparent rounded-full animate-spin"></div>
        <p class="mt-4 text-gray-600 dark:text-gray-400 font-medium">Chargement de vos informations...</p>
      </div>
    </div>
    
    <div v-else class="space-y-8">
      <!-- Résumé du profil -->
      <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 overflow-hidden shadow-sm">
        <div class="px-6 py-4 border-b border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-700">
          <h2 class="text-lg font-medium text-gray-900 dark:text-white flex items-center">
            <User class="h-5 w-5 mr-2 text-primary-600 dark:text-primary-400" />
            Profil
          </h2>
      </div>
      
        <div class="p-6">
          <div class="flex flex-col md:flex-row items-start gap-6">
            <!-- Avatar -->
            <div class="flex-shrink-0">
          <div class="relative">
              <img 
                  :src="profile.avatar_url || '/img/default-avatar.png'" 
                alt="Photo de profil"
                  class="w-24 h-24 rounded-full object-cover border-2 border-white dark:border-gray-700 shadow-sm"
                />
                <span 
                  class="absolute bottom-0 right-0 bg-white dark:bg-gray-800 border-2 border-white dark:border-gray-700 rounded-full w-6 h-6 flex items-center justify-center shadow-sm"
                >
                  <UserCheck v-if="profile.is_verified" class="h-3.5 w-3.5 text-green-500" />
                  <UserX v-else class="h-3.5 w-3.5 text-gray-400 dark:text-gray-500" />
                </span>
              </div>
            </div>
            
            <!-- Informations principales -->
            <div class="flex-grow">
              <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
                {{ profile.first_name }} {{ profile.last_name }}
              </h3>
              
              <div class="mt-1 text-primary-600 dark:text-primary-400 font-medium">
                {{ user?.email }}
            </div>
              
              <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mt-4">
                <div class="flex items-center text-sm text-gray-600 dark:text-gray-400">
                  <Calendar class="h-4 w-4 mr-2 text-gray-500 dark:text-gray-500" />
                  <span>Membre depuis {{ formatDate(profile.created_at) }}</span>
          </div>
          
                <div class="flex items-center text-sm text-gray-600 dark:text-gray-400">
                  <MapPin class="h-4 w-4 mr-2 text-gray-500 dark:text-gray-500" />
                  <span>{{ profile.city || 'Non spécifié' }}, {{ profile.country || 'Non spécifié' }}</span>
        </div>
        
                <div class="flex items-center text-sm text-gray-600 dark:text-gray-400">
                  <Phone class="h-4 w-4 mr-2 text-gray-500 dark:text-gray-500" />
                  <span>{{ profile.phone || 'Non spécifié' }}</span>
                </div>
                
                <div class="flex items-center text-sm text-gray-600 dark:text-gray-400">
                  <Link class="h-4 w-4 mr-2 text-gray-500 dark:text-gray-500" />
                  <span>{{ profile.website || 'Non spécifié' }}</span>
            </div>
          </div>
          
              <div class="mt-5 flex flex-wrap gap-2">
                <NuxtLink to="/account/edit-profile" class="px-5 py-2 bg-primary-600 hover:bg-primary-700 text-white text-sm font-medium rounded-full transition-colors">
                  Modifier mon profil
                </NuxtLink>
                
                <NuxtLink v-if="isExpert" to="/account/expert" class="px-5 py-2 bg-white dark:bg-gray-700 border border-gray-300 dark:border-gray-600 text-gray-700 dark:text-gray-300 text-sm font-medium rounded-full hover:bg-gray-50 dark:hover:bg-gray-600 transition-colors">
                  Profil expert
                </NuxtLink>
            </div>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Bio et informations complémentaires -->
      <div v-if="profile.bio" class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 overflow-hidden shadow-sm">
        <div class="px-6 py-4 border-b border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-700">
          <h2 class="text-lg font-medium text-gray-900 dark:text-white flex items-center">
            <FileText class="h-5 w-5 mr-2 text-primary-600 dark:text-primary-400" />
            À propos de moi
          </h2>
        </div>
        
        <div class="p-6">
          <p class="text-gray-700 dark:text-gray-300 whitespace-pre-line">{{ profile.bio }}</p>
        </div>
      </div>
      
      <!-- Statistiques -->
      <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 overflow-hidden shadow-sm">
        <div class="px-6 py-4 border-b border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-700">
          <h2 class="text-lg font-medium text-gray-900 dark:text-white flex items-center">
            <BarChart class="h-5 w-5 mr-2 text-primary-600 dark:text-primary-400" />
            Statistiques
          </h2>
        </div>
        
        <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-4 divide-y sm:divide-y-0 sm:divide-x divide-gray-200 dark:divide-gray-700">
          <div class="p-6 text-center">
            <div class="text-3xl font-bold text-primary-600 dark:text-primary-400">{{ stats.requestCount }}</div>
            <div class="text-sm text-gray-600 dark:text-gray-400 mt-1">Demandes publiées</div>
          </div>
          
          <div class="p-6 text-center">
            <div class="text-3xl font-bold text-primary-600 dark:text-primary-400">{{ stats.proposalCount }}</div>
            <div class="text-sm text-gray-600 dark:text-gray-400 mt-1">Propositions reçues</div>
      </div>
      
          <div class="p-6 text-center">
            <div class="text-3xl font-bold text-primary-600 dark:text-primary-400">{{ stats.contractCount }}</div>
            <div class="text-sm text-gray-600 dark:text-gray-400 mt-1">Contrats finalisés</div>
          </div>
          
          <div class="p-6 text-center">
            <div class="text-3xl font-bold text-gray-900 dark:text-gray-100">{{ stats.rating || '-' }}</div>
            <div class="text-sm text-gray-600 dark:text-gray-400 mt-1">Note moyenne</div>
          </div>
        </div>
      </div>
      
      <!-- Préférences de notification -->
      <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 overflow-hidden shadow-sm">
        <div class="px-6 py-4 border-b border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-700">
          <h2 class="text-lg font-medium text-gray-900 dark:text-white flex items-center">
            <Bell class="h-5 w-5 mr-2 text-primary-600 dark:text-primary-400" />
            Préférences de notification
          </h2>
        </div>
        
        <div class="p-6">
          <div class="space-y-4">
            <div class="flex items-center justify-between">
            <div>
                <h3 class="text-gray-900 dark:text-white font-medium">Notifications par email</h3>
                <p class="text-sm text-gray-600 dark:text-gray-400">Recevoir des emails pour les mises à jour importantes</p>
              </div>
              <Switch 
                v-model="preferences.emailNotifications" 
                @change="updatePreferences" 
                class="relative inline-flex h-6 w-11 items-center rounded-full bg-gray-300 dark:bg-gray-600"
                :class="{ 'bg-primary-600 dark:bg-primary-500': preferences.emailNotifications }"
              >
                <span 
                  class="inline-block h-4 w-4 transform rounded-full bg-white transition"
                  :class="preferences.emailNotifications ? 'translate-x-6' : 'translate-x-1'"
                ></span>
              </Switch>
          </div>
          
            <div class="flex items-center justify-between">
            <div>
                <h3 class="text-gray-900 dark:text-white font-medium">Notifications push</h3>
                <p class="text-sm text-gray-600 dark:text-gray-400">Recevoir des notifications dans l'application</p>
              </div>
              <Switch 
                v-model="preferences.pushNotifications" 
                @change="updatePreferences" 
                class="relative inline-flex h-6 w-11 items-center rounded-full bg-gray-300 dark:bg-gray-600"
                :class="{ 'bg-primary-600 dark:bg-primary-500': preferences.pushNotifications }"
              >
                <span 
                  class="inline-block h-4 w-4 transform rounded-full bg-white transition"
                  :class="preferences.pushNotifications ? 'translate-x-6' : 'translate-x-1'"
                ></span>
              </Switch>
          </div>
          
            <div class="flex items-center justify-between">
            <div>
                <h3 class="text-gray-900 dark:text-white font-medium">Nouvelles offres</h3>
                <p class="text-sm text-gray-600 dark:text-gray-400">Être notifié des nouvelles offres correspondant à mes intérêts</p>
              </div>
              <Switch 
                v-model="preferences.newOffers" 
                @change="updatePreferences" 
                class="relative inline-flex h-6 w-11 items-center rounded-full bg-gray-300 dark:bg-gray-600"
                :class="{ 'bg-primary-600 dark:bg-primary-500': preferences.newOffers }"
              >
                <span 
                  class="inline-block h-4 w-4 transform rounded-full bg-white transition"
                  :class="preferences.newOffers ? 'translate-x-6' : 'translate-x-1'"
                ></span>
              </Switch>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Paramètres du compte -->
      <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 overflow-hidden shadow-sm">
        <div class="px-6 py-4 border-b border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-700">
          <h2 class="text-lg font-medium text-gray-900 dark:text-white flex items-center">
            <Settings class="h-5 w-5 mr-2 text-primary-600 dark:text-primary-400" />
            Paramètres du compte
          </h2>
          </div>
        
        <div class="p-6">
          <div class="space-y-5">
            <div>
              <NuxtLink to="/account/change-password" class="inline-flex items-center text-gray-700 dark:text-gray-300 hover:text-primary-600 dark:hover:text-primary-400">
                <Lock class="h-4 w-4 mr-2" />
                <span>Changer mon mot de passe</span>
        </NuxtLink>
            </div>
            
            <div>
              <NuxtLink to="/account/privacy" class="inline-flex items-center text-gray-700 dark:text-gray-300 hover:text-primary-600 dark:hover:text-primary-400">
                <Shield class="h-4 w-4 mr-2" />
                <span>Confidentialité et sécurité</span>
              </NuxtLink>
        </div>
        
            <div>
              <button 
                @click="confirmLogout"
                class="inline-flex items-center text-gray-700 dark:text-gray-300 hover:text-red-600 dark:hover:text-red-400"
              >
                <LogOut class="h-4 w-4 mr-2" />
                <span>Se déconnecter</span>
              </button>
            </div>
            
            <div class="pt-4 border-t border-gray-200 dark:border-gray-700">
              <button 
                @click="confirmDeactivate"
                class="inline-flex items-center text-red-600 dark:text-red-400 hover:text-red-700 dark:hover:text-red-300"
              >
                <AlertTriangle class="h-4 w-4 mr-2" />
                <span>Désactiver mon compte</span>
              </button>
            </div>
          </div>
        </div>
            </div>
          </div>
    
    <!-- Modal de confirmation de déconnexion -->
    <Teleport to="body">
      <div v-if="showLogoutModal" class="fixed inset-0 bg-black/60 backdrop-blur-sm z-50 flex items-center justify-center p-4">
        <div @click.stop class="bg-white dark:bg-gray-800 rounded-2xl w-full max-w-md shadow-xl overflow-hidden">
          <div class="px-6 py-4 border-b border-gray-200 dark:border-gray-700 flex justify-between items-center">
            <h3 class="text-lg font-medium text-gray-900 dark:text-white">Confirmer la déconnexion</h3>
            <button @click="showLogoutModal = false" class="text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200">
              <X class="h-5 w-5" />
            </button>
          </div>
          
          <div class="p-6">
            <p class="text-gray-600 dark:text-gray-300 mb-6">
              Êtes-vous sûr de vouloir vous déconnecter ?
            </p>
            
            <div class="flex justify-end space-x-3">
              <button
                @click="showLogoutModal = false"
                type="button"
                class="px-5 py-2.5 bg-white dark:bg-gray-700 border border-gray-300 dark:border-gray-600 rounded-full text-gray-700 dark:text-gray-300 font-medium hover:bg-gray-50 dark:hover:bg-gray-600 focus:outline-none"
              >
                Annuler
              </button>
              <button
                @click="logout"
                type="button"
                class="px-5 py-2.5 bg-primary-600 hover:bg-primary-700 rounded-full text-white font-medium focus:outline-none"
              >
                Se déconnecter
              </button>
            </div>
          </div>
        </div>
      </div>
    </Teleport>
    
    <!-- Modal de confirmation de désactivation -->
    <Teleport to="body">
      <div v-if="showDeactivateModal" class="fixed inset-0 bg-black/60 backdrop-blur-sm z-50 flex items-center justify-center p-4">
        <div @click.stop class="bg-white dark:bg-gray-800 rounded-2xl w-full max-w-md shadow-xl overflow-hidden">
          <div class="px-6 py-4 border-b border-gray-200 dark:border-gray-700 flex justify-between items-center">
            <h3 class="text-lg font-medium text-gray-900 dark:text-white">Confirmer la désactivation</h3>
            <button @click="showDeactivateModal = false" class="text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200">
              <X class="h-5 w-5" />
            </button>
      </div>
      
          <div class="p-6">
            <div class="text-amber-600 dark:text-amber-500 p-4 bg-amber-50 dark:bg-amber-900/20 rounded-xl mb-4 flex items-start">
              <AlertTriangle class="h-5 w-5 mr-2 flex-shrink-0 mt-0.5" />
              <div>
                <p class="font-medium">Attention: Cette action est irréversible</p>
                <p class="mt-1 text-sm">La désactivation de votre compte supprimera toutes vos données personnelles.</p>
        </div>
            </div>
            
            <p class="text-gray-600 dark:text-gray-300 mb-4">
              Pour confirmer, veuillez saisir "DÉSACTIVER" ci-dessous:
            </p>
            
            <input
              v-model="deactivateConfirmation"
              type="text"
              placeholder="DÉSACTIVER"
              class="w-full px-4 py-2.5 border border-gray-300 dark:border-gray-600 rounded-full shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white mb-6"
            />
            
            <div class="flex justify-end space-x-3">
              <button
                @click="showDeactivateModal = false"
                type="button"
                class="px-5 py-2.5 bg-white dark:bg-gray-700 border border-gray-300 dark:border-gray-600 rounded-full text-gray-700 dark:text-gray-300 font-medium hover:bg-gray-50 dark:hover:bg-gray-600 focus:outline-none"
              >
                Annuler
              </button>
              <button
                @click="deactivateAccount"
                type="button"
                :disabled="deactivateConfirmation !== 'DÉSACTIVER'"
                class="px-5 py-2.5 bg-red-600 hover:bg-red-700 rounded-full text-white font-medium focus:outline-none disabled:opacity-50 disabled:pointer-events-none"
              >
                Désactiver mon compte
              </button>
            </div>
          </div>
        </div>
      </div>
    </Teleport>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { useRouter } from 'vue-router'
import { useSupabaseClient, useSupabaseUser } from '#imports'
import {
  User, 
  UserCheck, 
  UserX, 
  Calendar, 
  MapPin, 
  Phone, 
  Link, 
  FileText, 
  BarChart, 
  Bell, 
  Settings, 
  Lock, 
  Shield, 
  LogOut, 
  AlertTriangle, 
  X 
} from 'lucide-vue-next'

// États
const isLoading = ref(true)
const profile = ref({})
const user = useSupabaseUser()
const stats = ref({
  requestCount: 0,
  proposalCount: 0,
  contractCount: 0,
  rating: null
})
const preferences = ref({
  emailNotifications: true,
  pushNotifications: true,
  newOffers: false
})
const showLogoutModal = ref(false)
const showDeactivateModal = ref(false)
const deactivateConfirmation = ref('')
const statusMessage = ref({
  show: false,
  type: 'info',
  message: ''
})

// Composables
const supabase = useSupabaseClient()
const router = useRouter()

// Propriétés calculées
const isExpert = computed(() => {
  return profile.value?.is_expert
})

// Méthodes
const fetchProfile = async () => {
  isLoading.value = true
  
  try {
    if (!user.value?.id) {
      router.push('/auth/login')
      return
    }
    
    const { data, error } = await supabase
      .from('profiles')
      .select('*')
      .eq('id', user.value.id)
      .single()
    
    if (error) throw error
    
    profile.value = data
    
    // Récupérer les préférences de notification
    preferences.value = {
      emailNotifications: data.email_notifications !== false,
      pushNotifications: data.push_notifications !== false,
      newOffers: data.new_offers_notifications || false
    }
    
    // Récupérer les statistiques
    await fetchStats()
  } catch (error) {
    console.error('Erreur lors du chargement du profil:', error)
    showStatusMessage('error', 'Erreur lors du chargement de votre profil')
  } finally {
    isLoading.value = false
  }
}

const fetchStats = async () => {
  try {
    // Compter les demandes
    const { count: requestCount, error: requestError } = await supabase
      .from('requests')
      .select('id', { count: 'exact', head: true })
      .eq('profile_id', user.value.id)
    
    if (requestError) throw requestError
    
    // Compter les propositions reçues
    const { count: proposalCount, error: proposalError } = await supabase
      .from('proposals')
      .select('id', { count: 'exact', head: true })
      .eq('client_id', user.value.id)
    
    if (proposalError) throw proposalError
    
    // Compter les contrats
    const { count: contractCount, error: contractError } = await supabase
      .from('contracts')
      .select('id', { count: 'exact', head: true })
      .eq('client_id', user.value.id)
    
    if (contractError) throw contractError
    
    // Récupérer la note moyenne
    const { data: ratingData, error: ratingError } = await supabase
      .from('profiles')
      .select('rating')
      .eq('id', user.value.id)
      .single()
    
    if (ratingError) throw ratingError
    
    stats.value = {
      requestCount: requestCount || 0,
      proposalCount: proposalCount || 0,
      contractCount: contractCount || 0,
      rating: ratingData.rating ? Number(ratingData.rating).toFixed(1) : null
    }
  } catch (error) {
    console.error('Erreur lors du chargement des statistiques:', error)
  }
}

const updatePreferences = async () => {
  try {
    const { error } = await supabase
      .from('profiles')
      .update({
        email_notifications: preferences.value.emailNotifications,
        push_notifications: preferences.value.pushNotifications,
        new_offers_notifications: preferences.value.newOffers
      })
      .eq('id', user.value.id)
    
    if (error) throw error
    
    showStatusMessage('success', 'Vos préférences ont été mises à jour')
  } catch (error) {
    console.error('Erreur lors de la mise à jour des préférences:', error)
    showStatusMessage('error', 'Erreur lors de la mise à jour de vos préférences')
  }
}

const confirmLogout = () => {
  showLogoutModal.value = true
}

const confirmDeactivate = () => {
  showDeactivateModal.value = true
  deactivateConfirmation.value = ''
}

const logout = async () => {
  try {
    const { error } = await supabase.auth.signOut()
    if (error) throw error
    
    router.push('/auth/login?logout=success')
  } catch (error) {
    console.error('Erreur lors de la déconnexion:', error)
    showStatusMessage('error', 'Erreur lors de la déconnexion')
    showLogoutModal.value = false
  }
}

const deactivateAccount = async () => {
  if (deactivateConfirmation.value !== 'DÉSACTIVER') {
    return
  }
  
  try {
    // 1. Marquer le profil comme désactivé
    const { error: profileError } = await supabase
      .from('profiles')
      .update({
        is_active: false,
        deactivated_at: new Date().toISOString()
      })
      .eq('id', user.value.id)
    
    if (profileError) throw profileError
    
    // 2. Déconnecter l'utilisateur
    const { error: authError } = await supabase.auth.signOut()
    if (authError) throw authError
    
    router.push('/auth/login?deactivated=true')
  } catch (error) {
    console.error('Erreur lors de la désactivation du compte:', error)
    showStatusMessage('error', 'Erreur lors de la désactivation de votre compte')
    showDeactivateModal.value = false
  }
}

const formatDate = (dateString) => {
  if (!dateString) return 'Date inconnue'
  
  const date = new Date(dateString)
  return new Intl.DateTimeFormat('fr-FR', {
    day: 'numeric',
    month: 'long',
    year: 'numeric'
  }).format(date)
}

const showStatusMessage = (type, message, duration = 5000) => {
  statusMessage.value = {
    show: true,
    type,
    message
  }
  
  setTimeout(() => {
    statusMessage.value.show = false
  }, duration)
}

// Initialisation
onMounted(() => {
  fetchProfile()
})
</script> 

<style scoped>
.switch {
  position: relative;
  display: inline-block;
  width: 44px;
  height: 24px;
}

/* Animation pour les sections */
.section-enter-active,
.section-leave-active {
  transition: opacity 0.3s ease, transform 0.3s ease;
}

.section-enter-from,
.section-leave-to {
  opacity: 0;
  transform: translateY(20px);
}
</style> 
