<template>
  <NuxtLayout name="default">
    <template #default>
      <div class="min-h-screen max-w-4xl mx-auto bg-white dark:bg-gray-900 flex flex-col">
        <!-- Enhanced Navigation principale with modern design -->
        <div class="bg-white dark:bg-gray-800 border-b border-gray-200 dark:border-gray-700 shadow-sm">
          <div class="max-w-5xl mx-auto px-4">
            <!-- Navigation desktop with enhanced styling -->
            <div class="hidden md:flex">
              <div class="flex">
                <NuxtLink 
                  to="/account" 
                  class="account-tab group"
                  :class="[$route.path === '/account' ? 'active' : '']"
                >
                  <span>Tableau de bord</span>
                  <div class="tab-indicator"></div>
                </NuxtLink>
                
                <NuxtLink 
                  to="/account/requests" 
                  class="account-tab group"
                  :class="[$route.path.includes('/account/requests') ? 'active' : '']"
                >
                  <span>Demandes</span>
                  <div class="tab-indicator"></div>
                </NuxtLink>
                
                <NuxtLink 
                  v-if="isExpert"
                  to="/account/services" 
                  class="account-tab group"
                  :class="[$route.path.includes('/account/services') ? 'active' : '']"
                >
                  <span>Services</span>
                  <div class="tab-indicator"></div>
                </NuxtLink>
                
                <NuxtLink 
                  to="/account/contracts" 
                  class="account-tab group"
                  :class="[$route.path.includes('/account/contracts') ? 'active' : '']"
                >
                  <span>Contrats</span>
                  <div class="tab-indicator"></div>
                </NuxtLink>
                
                <NuxtLink 
                  to="/account/messages" 
                  class="account-tab group relative"
                  :class="[$route.path.includes('/account/messages') ? 'active' : '']"
                >
                  <span>Messages</span>
                  <div class="tab-indicator"></div>
                  <span 
                    v-if="unreadCount > 0" 
                    class="notification-badge"
                  >
                    {{ unreadCount }}
                  </span>
                </NuxtLink>
              </div>
              
              <!-- Enhanced action button with dropdown -->
              <div class="ml-auto relative">
                <button 
                  @click="showQuickActions = !showQuickActions"
                  class="action-button twitter-button mt-2 shadow-sm hover:shadow transition-all"
                >
                  <span>Créer</span>
                  <ChevronDown v-if="showQuickActions" class="h-4 w-4 ml-1 transition-transform" />
                  <ChevronUp v-else class="h-4 w-4 ml-1 transition-transform" />
                </button>
                
                <!-- Enhanced dropdown menu -->
                <div 
                  v-if="showQuickActions" 
                  class="absolute right-0 mt-2 w-64 bg-white dark:bg-gray-800 rounded-xl shadow-lg py-2 z-20 border border-gray-200 dark:border-gray-700 animate-scaleUp"
                >
                  <NuxtLink 
                    to="/requests/new" 
                    class="dropdown-item group"
                    @click="showQuickActions = false"
                  >
                    <div class="flex items-center">
                      <div class="h-9 w-9 rounded-full bg-primary-50 dark:bg-primary-900/30 flex items-center justify-center mr-3 group-hover:bg-primary-100 dark:group-hover:bg-primary-900/50 transition-colors">
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
                    class="dropdown-item group"
                    @click="showQuickActions = false"
                  >
                    <div class="flex items-center">
                      <div class="h-9 w-9 rounded-full bg-primary-50 dark:bg-primary-900/30 flex items-center justify-center mr-3 group-hover:bg-primary-100 dark:group-hover:bg-primary-900/50 transition-colors">
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
            
            <!-- Enhanced mobile navigation with smooth scrolling -->
            <div class="md:hidden overflow-x-auto hide-scrollbar">
              <div class="flex">
                <NuxtLink 
                  to="/account" 
                  class="account-tab-mobile group"
                  :class="[$route.path === '/account' ? 'active' : '']"
                >
                  <span>Tableau</span>
                  <div class="tab-indicator-mobile"></div>
                </NuxtLink>
                
                <NuxtLink 
                  to="/account/requests" 
                  class="account-tab-mobile group"
                  :class="[$route.path.includes('/account/requests') ? 'active' : '']"
                >
                  <span>Demandes</span>
                  <div class="tab-indicator-mobile"></div>
                </NuxtLink>
                
                <NuxtLink 
                  v-if="isExpert"
                  to="/account/services" 
                  class="account-tab-mobile group"
                  :class="[$route.path.includes('/account/services') ? 'active' : '']"
                >
                  <span>Services</span>
                  <div class="tab-indicator-mobile"></div>
                </NuxtLink>
                
                <NuxtLink 
                  to="/account/contracts" 
                  class="account-tab-mobile group"
                  :class="[$route.path.includes('/account/contracts') ? 'active' : '']"
                >
                  <span>Contrats</span>
                  <div class="tab-indicator-mobile"></div>
                </NuxtLink>
                
                <NuxtLink 
                  to="/account/messages" 
                  class="account-tab-mobile group relative"
                  :class="[$route.path.includes('/account/messages') ? 'active' : '']"
                >
                  <span>Messages</span>
                  <div class="tab-indicator-mobile"></div>
                  <span 
                    v-if="unreadCount > 0" 
                    class="notification-badge-mobile"
                  >
                    {{ unreadCount }}
                  </span>
                </NuxtLink>
              </div>
              </div>
            </div>
          </div>
          
        <!-- Enhanced alert for unverified experts -->
        <div 
          v-if="isExpert && !isVerified" 
          class="bg-amber-50 dark:bg-amber-900/10 border-b border-amber-100 dark:border-amber-800/30"
        >
          <div class="max-w-5xl mx-auto px-4 py-3 flex items-center justify-between">
            <div class="flex items-center">
              <AlertTriangle class="h-4 w-4 text-amber-500 mr-2" />
              <span class="text-sm text-amber-700 dark:text-amber-400">
                Votre compte expert n'est pas encore vérifié
              </span>
            </div>
            <NuxtLink 
              to="/account/verify" 
              class="text-xs font-medium text-amber-600 dark:text-amber-400 hover:text-amber-700 dark:hover:text-amber-300 hover:underline transition-all"
            >
              Vérifier maintenant →
            </NuxtLink>
          </div>
        </div>
        
        <!-- Enhanced content area with padding -->
        <div class="flex-1 px-4 py-4 md:py-6">
          <slot />
        </div>
        
        <!-- Enhanced floating action button with smoother animations -->
        <div class="fixed bottom-6 right-6 md:hidden z-30">
          <button 
            class="action-fab"
            @click="showMobileActions = !showMobileActions"
          >
            <Plus v-if="!showMobileActions" class="h-6 w-6 transition-transform" />
            <X v-else class="h-6 w-6 transition-transform" />
          </button>
          
          <!-- Enhanced floating actions menu -->
          <div 
            v-if="showMobileActions" 
            class="absolute bottom-16 right-0 space-y-3 animate-slideUp"
          >
            <NuxtLink 
              to="/requests/new" 
              class="action-fab-item"
              @click="showMobileActions = false"
            >
              <FileText class="h-4 w-4 mr-2" />
              Nouvelle demande
            </NuxtLink>
            
            <NuxtLink 
              v-if="isExpert"
              to="/account/services/new" 
              class="action-fab-item"
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
  if (showQuickActions.value && !event.target.closest('.action-button') && !event.target.closest('.dropdown-item')) {
    showQuickActions.value = false
  }
  
  if (showMobileActions.value && !event.target.closest('.action-fab') && !event.target.closest('.action-fab-item')) {
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
/* Enhanced Tabs style */
.account-tab {
  @apply px-4 py-4 font-medium text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-800 relative flex items-center justify-center transition-colors;
}

.account-tab.active {
  @apply font-bold text-primary-600 dark:text-primary-400;
}

.tab-indicator {
  @apply absolute bottom-0 left-0 right-0 h-1 bg-primary-500 dark:bg-primary-400 rounded-full origin-center scale-x-0 transition-transform duration-200;
  width: 60%;
  margin: 0 auto;
}

.account-tab.active .tab-indicator,
.account-tab:hover .tab-indicator {
  @apply scale-x-100;
}

.account-tab.active .tab-indicator {
  @apply bg-primary-500 dark:bg-primary-400;
}

.account-tab:hover:not(.active) .tab-indicator {
  @apply bg-gray-300 dark:bg-gray-700 scale-x-75;
}

/* Enhanced Tabs mobile */
.account-tab-mobile {
  @apply px-3 py-3 font-medium text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-800 relative flex items-center justify-center flex-1 transition-colors;
}

.account-tab-mobile.active {
  @apply font-bold text-primary-600 dark:text-primary-400;
}

.tab-indicator-mobile {
  @apply absolute bottom-0 left-0 right-0 h-1 bg-primary-500 dark:bg-primary-400 rounded-full origin-center scale-x-0 transition-transform duration-200;
  width: 60%;
  margin: 0 auto;
}

.account-tab-mobile.active .tab-indicator-mobile {
  @apply scale-x-100;
}

/* Enhanced action button */
.action-button {
  @apply py-2 px-4 bg-primary-500 hover:bg-primary-600 text-white font-bold rounded-full flex items-center transition-all duration-200;
}

/* Enhanced dropdown menu items */
.dropdown-item {
  @apply block px-4 py-3 hover:bg-gray-50 dark:hover:bg-gray-700/50 transition-all duration-200;
}

.dropdown-item:hover {
  @apply translate-x-1;
}

/* Enhanced notification badge */
.notification-badge {
  @apply absolute -top-1 -right-1 bg-red-500 text-white text-xs font-bold rounded-full h-5 min-w-[1.25rem] flex items-center justify-center shadow-sm;
}

.notification-badge-mobile {
  @apply absolute top-1 right-1 bg-red-500 text-white text-xs font-bold rounded-full h-4 min-w-[1rem] flex items-center justify-center shadow-sm;
}

/* Enhanced floating action button */
.action-fab {
  @apply h-14 w-14 rounded-full bg-primary-500 hover:bg-primary-600 text-white flex items-center justify-center shadow-lg transition-all duration-300;
}

.action-fab:hover {
  @apply transform scale-105 shadow-xl;
}

/* Enhanced floating action items */
.action-fab-item {
  @apply flex items-center bg-primary-500 text-white rounded-full pl-3 pr-5 py-2.5 shadow-md transition-all duration-200 hover:bg-primary-600;
}

.action-fab-item:hover {
  @apply transform -translate-y-0.5 shadow-lg;
}

/* Hide scrollbar */
.hide-scrollbar {
  -ms-overflow-style: none;  /* IE and Edge */
  scrollbar-width: none;  /* Firefox */
}
.hide-scrollbar::-webkit-scrollbar {
  display: none;  /* Chrome, Safari and Opera */
}

/* Enhanced animations */
@keyframes scaleUp {
  from { opacity: 0; transform: scale(0.95); }
  to { opacity: 1; transform: scale(1); }
}

.animate-scaleUp {
  animation: scaleUp 0.2s cubic-bezier(0.4, 0, 0.2, 1) forwards;
}

@keyframes slideUp {
  from { opacity: 0; transform: translateY(15px); }
  to { opacity: 1; transform: translateY(0); }
}

.animate-slideUp {
  animation: slideUp 0.25s cubic-bezier(0.4, 0, 0.2, 1) forwards;
}
</style>
