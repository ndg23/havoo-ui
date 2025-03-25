<template>
  <NuxtLayout name="default">
    <template #default>
      <div class="min-h-screen bg-white dark:bg-gray-900 flex flex-col">
        <!-- Header fixe avec design Twitter -->
        <div class="sticky top-0 z-10 bg-white/80 dark:bg-gray-800/80 backdrop-blur-sm border-b border-gray-200 dark:border-gray-700">
          <div class="max-w-5xl mx-auto px-4">
            <!-- Navigation desktop -->
            <div class="hidden md:flex h-14 items-center">
              <div class="flex h-full space-x-1">
                <NuxtLink 
                  to="/account" 
                  class="twitter-tab group"
                  :class="[$route.path === '/account' ? 'twitter-tab-active' : '']"
                >
                  <span>Tableau de bord</span>
                  <div class="twitter-indicator"></div>
                </NuxtLink>
                
                <NuxtLink 
                  to="/account/requests" 
                  class="twitter-tab group"
                  :class="[$route.path.includes('/account/requests') ? 'twitter-tab-active' : '']"
                >
                  <span>Demandes</span>
                  <div class="twitter-indicator"></div>
                </NuxtLink>
                
                <NuxtLink 
                  v-if="isExpert"
                  to="/account/services" 
                  class="twitter-tab group"
                  :class="[$route.path.includes('/account/services') ? 'twitter-tab-active' : '']"
                >
                  <span>Services</span>
                  <div class="twitter-indicator"></div>
                </NuxtLink>
                
                <NuxtLink 
                  to="/account/contracts" 
                  class="twitter-tab group"
                  :class="[$route.path.includes('/account/contracts') ? 'twitter-tab-active' : '']"
                >
                  <span>Contrats</span>
                  <div class="twitter-indicator"></div>
                </NuxtLink>
                
                <NuxtLink 
                  to="/account/messages" 
                  class="twitter-tab group relative"
                  :class="[$route.path.includes('/account/messages') ? 'twitter-tab-active' : '']"
                >
                  <span>Messages</span>
                  <div class="twitter-indicator"></div>
                  <span 
                    v-if="unreadCount > 0" 
                    class="twitter-badge"
                  >
                    {{ unreadCount > 99 ? '99+' : unreadCount }}
                  </span>
                </NuxtLink>
              </div>
              
              <!-- Action button avec bulle d'aide -->
              <div class="ml-auto">
                <div class="relative group">
                  <NuxtLink 
                    v-if="isExpert"
                    to="/account/services/create" 
                    class="twitter-action-button"
                  >
                    <Plus class="h-5 w-5 mr-2" />
                    <span>Créer un service</span>
                  </NuxtLink>
                  <NuxtLink 
                    v-else
                    to="/requests/new" 
                    class="twitter-action-button"
                  >
                    <Plus class="h-5 w-5 mr-2" />
                    <span>Créer une demande</span>
                  </NuxtLink>
                </div>
              </div>
            </div>
            
            <!-- Navigation mobile avec défilement fluide -->
            <div class="md:hidden overflow-x-auto hide-scrollbar">
              <div class="flex h-14 items-center space-x-0">
                <NuxtLink 
                  to="/account" 
                  class="twitter-tab-mobile group"
                  :class="[$route.path === '/account' ? 'twitter-tab-mobile-active' : '']"
                >
                  <span>Tableau</span>
                  <div class="twitter-indicator-mobile"></div>
                </NuxtLink>
                
                <NuxtLink 
                  to="/account/requests" 
                  class="twitter-tab-mobile group"
                  :class="[$route.path.includes('/account/requests') ? 'twitter-tab-mobile-active' : '']"
                >
                  <span>Demandes</span>
                  <div class="twitter-indicator-mobile"></div>
                </NuxtLink>
                
                <NuxtLink 
                  v-if="isExpert"
                  to="/account/services" 
                  class="twitter-tab-mobile group"
                  :class="[$route.path.includes('/account/services') ? 'twitter-tab-mobile-active' : '']"
                >
                  <span>Services</span>
                  <div class="twitter-indicator-mobile"></div>
                </NuxtLink>
                
                <NuxtLink 
                  to="/account/contracts" 
                  class="twitter-tab-mobile group"
                  :class="[$route.path.includes('/account/contracts') ? 'twitter-tab-mobile-active' : '']"
                >
                  <span>Contrats</span>
                  <div class="twitter-indicator-mobile"></div>
                </NuxtLink>
                
                <NuxtLink 
                  to="/account/messages" 
                  class="twitter-tab-mobile group relative"
                  :class="[$route.path.includes('/account/messages') ? 'twitter-tab-mobile-active' : '']"
                >
                  <span>Messages</span>
                  <div class="twitter-indicator-mobile"></div>
                  <span 
                    v-if="unreadCount > 0" 
                    class="twitter-badge-mobile"
                  >
                    {{ unreadCount > 99 ? '99+' : unreadCount }}
                  </span>
                </NuxtLink>
              </div>
            </div>
          </div>
        </div>
          
        <!-- Alerte de vérification avec style moderne -->
        <div 
          v-if="isExpert && !isVerified" 
          class="bg-primary-50 dark:bg-primary-900/10 border-b border-primary-100 dark:border-primary-800/30"
        >
          <div class="max-w-5xl mx-auto px-4 py-3 flex items-center justify-between">
            <div class="flex items-center">
              <AlertTriangle class="h-4 w-4 text-primary-600 dark:text-primary-400 mr-2" />
              <span class="text-sm text-primary-700 dark:text-primary-300">
                Votre compte expert n'est pas encore vérifié
              </span>
            </div>
            <NuxtLink 
              to="/account/verification" 
              class="inline-flex items-center px-3 py-1 text-xs font-medium rounded-full bg-primary-100 dark:bg-primary-900/30 text-primary-700 dark:text-primary-300 hover:bg-primary-200 dark:hover:bg-primary-800/50 transition-colors"
            >
              Vérifier maintenant
              <ChevronRight class="ml-1 h-3 w-3" />
            </NuxtLink>
          </div>
        </div>
        
        <!-- Zone de contenu avec transitions -->
        <div class="flex-1 max-w-5xl w-full mx-auto px-4 py-6 animate-fadeIn">
          <slot />
        </div>
        
        <!-- Bouton d'action flottant sur mobile -->
        <div class="md:hidden fixed right-6 bottom-6 z-20">
          <button 
            @click="showMobileActions = !showMobileActions"
            class="twitter-fab"
            :class="{ 'rotate-45': showMobileActions }"
          >
            <Plus class="h-6 w-6" />
          </button>
          
          <!-- Menu d'actions mobile -->
          <div 
            v-if="showMobileActions" 
            class="absolute right-0 bottom-16 flex flex-col-reverse items-end space-y-reverse space-y-3"
          >
            <NuxtLink 
              to="/requests/new" 
              class="twitter-fab-item"
              @click="showMobileActions = false"
            >
              <span class="twitter-fab-label">Nouvelle demande</span>
              <div class="twitter-fab-icon bg-green-500">
                <FileText class="h-4 w-4 text-white" />
              </div>
            </NuxtLink>
            
            <NuxtLink 
              v-if="isExpert"
              to="/account/services/create" 
              class="twitter-fab-item"
              @click="showMobileActions = false"
            >
              <span class="twitter-fab-label">Nouveau service</span>
              <div class="twitter-fab-icon bg-blue-500">
                <Briefcase class="h-4 w-4 text-white" />
              </div>
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
  ChevronUp,
  ChevronRight
} from 'lucide-vue-next'

const supabase = useSupabaseClient()
const router = useRouter()

// État utilisateur
const isExpert = ref(false)
const isVerified = ref(false)
const unreadCount = ref(0)

// État UI
const showMobileActions = ref(false)

// Fermer les menus en cliquant ailleurs
const handleClickOutside = (event) => {
  if (showMobileActions.value && !event.target.closest('.twitter-fab') && !event.target.closest('.twitter-fab-item')) {
    showMobileActions.value = false
  }
}

// Récupérer le profil utilisateur
const fetchUserProfile = async () => {
  try {
    const { data: { user } } = await supabase.auth.getUser()
    
    if (!user) {
      router.push('/auth/login')
      return
    }
    
    const { data: profile, error } = await supabase
      .from('profiles')
      .select('is_expert, is_verified')
      .eq('id', user.id)
      .single()
    
    if (error) throw error
    
    isExpert.value = profile.is_expert
    isVerified.value = profile.is_verified
  } catch (error) {
    console.error('Error fetching user profile:', error)
  }
}

// Récupérer le nombre de messages non lus
const fetchUnreadMessages = async () => {
  try {
    const { data: { user } } = await supabase.auth.getUser()
    
    if (!user) return
    
    const { count, error } = await supabase
      .from('messages')
      .select('id', { count: 'exact' })
      .eq('recipient_id', user.id)
      .eq('is_read', false)
    
    if (error) throw error
    
    unreadCount.value = count || 0
  } catch (error) {
    console.error('Error fetching unread messages:', error)
  }
}

// Lifecycle hooks
onMounted(() => {
  fetchUserProfile()
  fetchUnreadMessages()
  document.addEventListener('click', handleClickOutside)
})

onBeforeUnmount(() => {
  document.removeEventListener('click', handleClickOutside)
})
</script>

<style scoped>
/* Animations */
.animate-fadeIn {
  animation: fadeIn 0.3s ease-out;
}

.animate-scaleUp {
  animation: scaleUp 0.2s ease-out;
}

@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

@keyframes scaleUp {
  from { transform: scale(0.95); opacity: 0; }
  to { transform: scale(1); opacity: 1; }
}

/* Style Twitter-like tabs */
.twitter-tab {
  @apply px-4 h-full flex items-center justify-center font-medium text-gray-600 dark:text-gray-400 hover:text-gray-900 dark:hover:text-white hover:bg-gray-50 dark:hover:bg-gray-800/60 relative transition-colors;
}

.twitter-tab-active {
  @apply text-gray-900 dark:text-white font-semibold;
}

.twitter-indicator {
  @apply absolute bottom-0 left-0 w-full h-1 rounded-full scale-x-0 bg-primary-500 dark:bg-primary-400 group-hover:scale-x-75 transition-transform origin-center duration-200;
}

.twitter-tab-active .twitter-indicator {
  @apply scale-x-100;
}

.twitter-tab-mobile {
  @apply px-3 h-full flex items-center justify-center text-sm font-medium text-gray-600 dark:text-gray-400 hover:text-gray-900 dark:hover:text-white relative transition-colors;
}

.twitter-tab-mobile-active {
  @apply text-gray-900 dark:text-white font-semibold;
}

.twitter-indicator-mobile {
  @apply absolute bottom-0 left-0 w-full h-1 rounded-full scale-x-0 bg-primary-500 dark:bg-primary-400 group-hover:scale-x-75 transition-transform origin-center duration-200;
}

.twitter-tab-mobile-active .twitter-indicator-mobile {
  @apply scale-x-100;
}

/* Badge de notification */
.twitter-badge {
  @apply absolute -top-1 -right-1 bg-red-500 text-white text-[10px] font-bold min-w-[16px] h-4 rounded-full flex items-center justify-center px-1;
}

.twitter-badge-mobile {
  @apply absolute -top-1 right-0 bg-red-500 text-white text-[10px] font-bold min-w-[16px] h-4 rounded-full flex items-center justify-center px-1;
}

/* Bouton d'action style Twitter */
.twitter-action-button {
  @apply flex items-center justify-center px-4 py-2 bg-primary-500 hover:bg-primary-600 dark:bg-primary-600 dark:hover:bg-primary-700 text-white font-medium rounded-full transition-colors shadow-sm hover:shadow;
}

/* Masquer la scrollbar tout en gardant la fonctionnalité */
.hide-scrollbar {
  -ms-overflow-style: none;  /* Internet Explorer and Edge */
  scrollbar-width: none;  /* Firefox */
}

.hide-scrollbar::-webkit-scrollbar {
  display: none;  /* Chrome, Safari and Opera */
}

/* Bouton d'action flottant */
.twitter-fab {
  @apply h-14 w-14 rounded-full bg-primary-500 hover:bg-primary-600 dark:bg-primary-600 dark:hover:bg-primary-700 text-white flex items-center justify-center shadow-lg transition-all duration-300 focus:outline-none;
}

.twitter-fab-item {
  @apply flex items-center space-x-2 mb-2 animate-scaleUp transform-gpu;
  animation-delay: calc(var(--idx, 0) * 0.05s);
}

.twitter-fab-label {
  @apply py-2 px-3 bg-gray-800 dark:bg-gray-700 text-white text-sm font-medium rounded-full shadow-md;
}

.twitter-fab-icon {
  @apply h-10 w-10 rounded-full flex items-center justify-center shadow-md;
}
</style>
