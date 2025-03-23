<template>
  <NuxtLayout name="default">
    <template #default>
      <div class="min-h-screen bg-white dark:bg-gray-900 flex flex-col">
        <!-- Navigation principale style Twitter -->
        <div class="bg-white dark:bg-gray-800 border-b border-gray-200 dark:border-gray-700">
          <div class="max-w-5xl mx-auto px-4">
            <!-- Navigation desktop -->
            <div class="hidden md:flex">
              <div class="flex">
                <NuxtLink 
                  to="/account" 
                  class="twitter-tab"
                  :class="[$route.path === '/account' ? 'active' : '']"
                >
                  <span>Tableau de bord</span>
                </NuxtLink>
                
                <NuxtLink 
                  to="/account/requests" 
                  class="twitter-tab"
                  :class="[$route.path.includes('/account/requests') ? 'active' : '']"
                >
                  <span>Demandes</span>
                </NuxtLink>
                
                <NuxtLink 
                  v-if="isExpert"
                  to="/account/services" 
                  class="twitter-tab"
                  :class="[$route.path.includes('/account/services') ? 'active' : '']"
                >
                  <span>Services</span>
                </NuxtLink>
                
                <NuxtLink 
                  to="/account/contracts" 
                  class="twitter-tab"
                  :class="[$route.path.includes('/account/contracts') ? 'active' : '']"
                >
                  <span>Contrats</span>
                </NuxtLink>
                
                <NuxtLink 
                  to="/account/messages" 
                  class="twitter-tab relative"
                  :class="[$route.path.includes('/account/messages') ? 'active' : '']"
                >
                  <span>Messages</span>
                  <span 
                    v-if="unreadCount > 0" 
                    class="twitter-badge"
                  >
                    {{ unreadCount }}
                  </span>
                </NuxtLink>
              </div>
              
              <!-- Bouton d'action principal avec dropdown correctement positionné -->
              <div class="ml-auto relative">
                <button 
                  @click="showQuickActions = !showQuickActions"
                  class="twitter-button"
                >
                  <span>Créer</span>
                  <ChevronDown v-if="showQuickActions" class="h-4 w-4 ml-1" />
                  <ChevronUp v-else class="h-4 w-4 ml-1" />
                </button>
                
                <!-- Menu déroulant des actions rapides (maintenant correctement positionné) -->
                <div 
                  v-if="showQuickActions" 
                  class="absolute right-0 mt-2 w-64 bg-white dark:bg-gray-800 rounded-xl shadow-lg py-2 z-20 border border-gray-200 dark:border-gray-700 animate-scaleUp"
                >
                  <NuxtLink 
                    to="/requests/new" 
                    class="twitter-dropdown-item"
                    @click="showQuickActions = false"
                  >
                    <div class="flex items-center">
                      <div class="h-9 w-9 rounded-full bg-primary-50 dark:bg-primary-900/30 flex items-center justify-center mr-3">
                        <FileText class="h-5 w-5 text-primary-500 dark:text-primary-400" />
                      </div>
                      <div>
                        <span class="block font-medium">Nouvelle demande</span>
                        <span class="text-xs text-gray-500 dark:text-gray-400">Créer une demande d'expertise</span>
                      </div>
                    </div>
                  </NuxtLink>
                  
                  <NuxtLink 
                    v-if="isExpert"
                    to="/account/services/new" 
                    class="twitter-dropdown-item"
                    @click="showQuickActions = false"
                  >
                    <div class="flex items-center">
                      <div class="h-9 w-9 rounded-full bg-primary-50 dark:bg-primary-900/30 flex items-center justify-center mr-3">
                        <Briefcase class="h-5 w-5 text-primary-500 dark:text-primary-400" />
                      </div>
                      <div>
                        <span class="block font-medium">Nouveau service</span>
                        <span class="text-xs text-gray-500 dark:text-gray-400">Proposer un service d'expertise</span>
                      </div>
                    </div>
                  </NuxtLink>
                </div>
              </div>
            </div>
            
            <!-- Navigation mobile (tabs) -->
            <div class="md:hidden overflow-x-auto hide-scrollbar">
              <div class="flex">
                <NuxtLink 
                  to="/account" 
                  class="twitter-tab-mobile"
                  :class="[$route.path === '/account' ? 'active' : '']"
                >
                  <span>Tableau</span>
                </NuxtLink>
                
                <NuxtLink 
                  to="/account/requests" 
                  class="twitter-tab-mobile"
                  :class="[$route.path.includes('/account/requests') ? 'active' : '']"
                >
                  <span>Demandes</span>
                </NuxtLink>
                
                <NuxtLink 
                  v-if="isExpert"
                  to="/account/services" 
                  class="twitter-tab-mobile"
                  :class="[$route.path.includes('/account/services') ? 'active' : '']"
                >
                  <span>Services</span>
                </NuxtLink>
                
                <NuxtLink 
                  to="/account/contracts" 
                  class="twitter-tab-mobile"
                  :class="[$route.path.includes('/account/contracts') ? 'active' : '']"
                >
                  <span>Contrats</span>
                </NuxtLink>
                
                <NuxtLink 
                  to="/account/messages" 
                  class="twitter-tab-mobile relative"
                  :class="[$route.path.includes('/account/messages') ? 'active' : '']"
                >
                  <span>Messages</span>
                  <span 
                    v-if="unreadCount > 0" 
                    class="twitter-badge-mobile"
                  >
                    {{ unreadCount }}
                  </span>
                </NuxtLink>
              </div>
              </div>
            </div>
          </div>
          
        <!-- Alerte de vérification (si expert non vérifié) -->
        <div 
          v-if="isExpert && !isVerified" 
          class="bg-amber-50 dark:bg-amber-900/10 border-b border-amber-100 dark:border-amber-800/30"
        >
          <div class="max-w-5xl mx-auto px-4 py-2 flex items-center justify-between">
            <div class="flex items-center">
              <AlertTriangle class="h-4 w-4 text-amber-500 mr-2" />
              <span class="text-sm text-amber-700 dark:text-amber-400">
                Votre compte expert n'est pas encore vérifié
              </span>
            </div>
              <NuxtLink 
              to="/account/verify" 
              class="text-xs font-medium text-amber-600 dark:text-amber-400 hover:text-amber-700 dark:hover:text-amber-300"
            >
              Vérifier maintenant
              </NuxtLink>
          </div>
        </div>
        
        <!-- Contenu principal -->
        <div class="flex-1">
          <slot />
        </div>
        
        <!-- Bouton d'action flottant (mobile uniquement) -->
        <div class="fixed bottom-6 right-6 md:hidden">
          <button 
            class="twitter-fab"
            @click="showMobileActions = !showMobileActions"
          >
            <Plus v-if="!showMobileActions" class="h-6 w-6" />
            <X v-else class="h-6 w-6" />
          </button>
          
          <!-- Actions flottantes -->
          <div 
            v-if="showMobileActions" 
            class="absolute bottom-16 right-0 space-y-2 animate-slideUp"
          >
            <NuxtLink 
              to="/requests/new" 
              class="twitter-fab-action"
              @click="showMobileActions = false"
            >
              <FileText class="h-4 w-4 mr-2" />
              Nouvelle demande
            </NuxtLink>
            
            <NuxtLink 
              v-if="isExpert"
              to="/account/services/new" 
              class="twitter-fab-action"
              @click="showMobileActions = false"
            >
              <Briefcase class="h-4 w-4 mr-2" />
              Nouveau service
            </NuxtLink>
      </div>
    </div>
  </div>
    </template>
  </NuxtLayout>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount } from 'vue'
import { useSupabaseClient, useRouter } from '#imports'
import { 
  FileText, 
  Briefcase, 
  MessageSquare, 
  Plus, 
  X, 
  AlertTriangle,
  ChevronDown,
  ChevronUp
} from 'lucide-vue-next'

const supabase = useSupabaseClient()
const router = useRouter()

// État utilisateur
const isExpert = ref(false)
const isVerified = ref(false)
const unreadCount = ref(0)

// État UI
const showMobileActions = ref(false)
const showQuickActions = ref(false)

// Fermer les menus en cliquant ailleurs
const handleClickOutside = (event) => {
  if (showQuickActions.value && !event.target.closest('.twitter-button') && !event.target.closest('.twitter-dropdown-item')) {
    showQuickActions.value = false
  }
  
  if (showMobileActions.value && !event.target.closest('.twitter-fab') && !event.target.closest('.twitter-fab-action')) {
    showMobileActions.value = false
  }
}

// Récupérer le profil utilisateur
const fetchUserProfile = async () => {
  try {
    const { data: { user } } = await supabase.auth.getUser()
    
    if (!user) {
      router.push('/login')
      return
    }
    
    const { data, error } = await supabase
      .from('profiles')
      .select('*')
      .eq('id', user.id)
      .single()
      
    if (error) throw error
    
    isExpert.value = data.is_expert
    
    // Vérifier le statut de vérification si expert
    if (data.is_expert) {
      await checkVerificationStatus()
    }
    
    // Récupérer le nombre de messages non lus
    await fetchUnreadMessages()
  } catch (err) {
    console.error('Error fetching user profile:', err)
  }
}

// Vérifier le statut de vérification
const checkVerificationStatus = async () => {
  try {
    const { data: { user } } = await supabase.auth.getUser()
    
    const { data, error } = await supabase
      .from('verifications')
      .select('status')
      .eq('user_id', user.id)
      .order('created_at', { ascending: false })
      .limit(1)
      .single()
    
    if (error && error.code !== 'PGRST116') throw error
    
    isVerified.value = data?.status === 'approved'
  } catch (err) {
    console.error('Error checking verification status:', err)
  }
}

// Récupérer le nombre de messages non lus
const fetchUnreadMessages = async () => {
  try {
    const { data: { user } } = await supabase.auth.getUser()
    
    const { data, error } = await supabase
      .from('messages')
      .select('id', { count: 'exact' })
      .eq('is_read', false)
      .in('conversation_id', 
        supabase
          .from('conversation_participants')
          .select('conversation_id')
          .eq('profile_id', user.id)
      )
    
    if (error) throw error
    
    unreadCount.value = data?.length || 0
  } catch (err) {
    console.error('Error fetching unread messages:', err)
  }
}

// Initialisation
onMounted(() => {
  fetchUserProfile()
  document.addEventListener('click', handleClickOutside)
})

onBeforeUnmount(() => {
  document.removeEventListener('click', handleClickOutside)
})
</script>

<style scoped>
/* Tabs style Twitter */
.twitter-tab {
  @apply px-4 py-4 font-medium text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-800 relative flex items-center justify-center;
}

.twitter-tab.active {
  @apply font-bold text-black dark:text-white;
}

.twitter-tab.active::after {
  content: '';
  @apply absolute bottom-0 left-0 right-0 h-1 bg-primary-500 dark:bg-primary-400 rounded-full;
  width: 50%;
  margin: 0 auto;
}

/* Tabs mobile */
.twitter-tab-mobile {
  @apply px-3 py-3 font-medium text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-800 relative flex items-center justify-center flex-1;
}

.twitter-tab-mobile.active {
  @apply font-bold text-black dark:text-white;
}

.twitter-tab-mobile.active::after {
  content: '';
  @apply absolute bottom-0 left-0 right-0 h-1 bg-primary-500 dark:bg-primary-400 rounded-full;
  width: 50%;
  margin: 0 auto;
}

/* Bouton principal style Twitter */
.twitter-button {
  @apply py-2 px-4 bg-primary-500 hover:bg-primary-600 text-white font-bold rounded-full flex items-center transition-colors;
}

/* Éléments du menu déroulant */
.twitter-dropdown-item {
  @apply block px-4 py-3 hover:bg-gray-50 dark:hover:bg-gray-700/50 transition-colors;
}

/* Badge de notification */
.twitter-badge {
  @apply absolute -top-1 -right-1 bg-primary-500 text-white text-xs rounded-full h-5 min-w-[1.25rem] flex items-center justify-center;
}

.twitter-badge-mobile {
  @apply absolute top-1 right-1 bg-primary-500 text-white text-xs rounded-full h-4 min-w-[1rem] flex items-center justify-center;
}

/* Bouton d'action flottant */
.twitter-fab {
  @apply h-14 w-14 rounded-full bg-primary-500 hover:bg-primary-600 text-white flex items-center justify-center shadow-lg transition-colors;
}

/* Actions du bouton flottant */
.twitter-fab-action {
  @apply flex items-center bg-primary-500 text-white rounded-full pl-3 pr-5 py-2 shadow-md;
}

/* Hide scrollbar */
.hide-scrollbar {
  -ms-overflow-style: none;  /* IE and Edge */
  scrollbar-width: none;  /* Firefox */
}
.hide-scrollbar::-webkit-scrollbar {
  display: none;  /* Chrome, Safari and Opera */
}

/* Animation pour le menu d'actions rapides */
@keyframes scaleUp {
  from { opacity: 0; transform: scale(0.95); }
  to { opacity: 1; transform: scale(1); }
}

.animate-scaleUp {
  animation: scaleUp 0.2s ease forwards;
}

/* Animation pour les actions flottantes mobiles */
@keyframes slideUp {
  from { opacity: 0; transform: translateY(10px); }
  to { opacity: 1; transform: translateY(0); }
}

.animate-slideUp {
  animation: slideUp 0.2s ease forwards;
}
</style>
