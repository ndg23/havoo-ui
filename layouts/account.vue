<template>
  <DefaultLayout>
    <template #default>
      <div class="max-w-4xl mx-auto px-4 py-0 relative">
        <main>
          <div class="max-w-4xl mx-auto">
            <!-- Avertissement profil désactivé style Instagram -->
            <div 
              v-if="!profileActive" 
              class="mb-4 bg-white dark:bg-neutral-900 border-b border-neutral-200 dark:border-neutral-800 p-3 flex items-center gap-3"
            >
              <AlertTriangle class="h-5 w-5 text-yellow-500 flex-shrink-0" />
              <div>
                <p class="font-medium text-sm">Votre profil est actuellement désactivé</p>
                <p class="text-neutral-500 text-xs mt-0.5">Vous n'apparaissez pas dans les recherches.</p>
              </div>
              <button 
                @click="toggleProfileStatus" 
                class="ml-auto text-primary-500 hover:text-primary-600 text-sm font-medium"
              >
                Activer
              </button>
            </div>
            
            <!-- Header style Instagram -->
            <div class="mb-6 border-b border-neutral-200 dark:border-neutral-800 pb-8">
              <div class="flex flex-col md:flex-row items-start md:items-center gap-6 pt-6">
                <!-- Avatar style Instagram -->
                <div class="flex-shrink-0">
                  <div class="relative">
                    <div class="w-20 h-20 md:w-24 md:h-24 rounded-full border border-neutral-200 dark:border-neutral-700 p-0.5">
                      <img 
                        :src="profile?.avatar || '/api/placeholder/120/120'" 
                        alt="Photo de profil"
                        class="w-full h-full rounded-full object-cover"
                      />
                    </div>
                    <div 
                      class="absolute bottom-0 right-0 w-4 h-4 rounded-full border-2 border-white dark:border-neutral-900"
                      :class="isOnline ? 'bg-green-500' : 'bg-neutral-400'"
                    ></div>
                  </div>
                </div>
                
                <!-- Informations utilisateur style Instagram -->
                <div class="flex-1">
                  <div class="flex flex-wrap items-center gap-4 mb-3">
                    <h2 class="text-base font-medium text-neutral-900 dark:text-white">
                      {{ profile?.fullName || 'Votre nom' }}
                    </h2>
                    
                    <!-- Statut du profil -->
                    <button 
                      @click="toggleProfileStatus"
                      class="text-xs font-medium py-1 px-2 border border-neutral-200 dark:border-neutral-700 rounded"
                      :class="profileActive ? 'text-green-600 dark:text-green-400' : 'text-red-600 dark:text-red-400'"
                    >
                      {{ profileActive ? 'Profil actif' : 'Profil inactif' }}
                    </button>
                    
                    <!-- Statut en ligne -->
                    <button 
                      @click="toggleOnlineStatus"
                      class="text-xs font-medium py-1 px-2 border border-neutral-200 dark:border-neutral-700 rounded"
                    >
                      {{ isOnline ? 'En ligne' : 'Hors ligne' }}
                    </button>
                  </div>
                  
                  <!-- Informations supplémentaires -->
                  <div class="flex items-center gap-6 mb-3">
                    <div class="flex flex-col items-center">
                      <span class="font-semibold text-sm">{{ profile?.contractsCount || '0' }}</span>
                      <span class="text-neutral-500 text-xs">contrats</span>
                    </div>
                    <div class="flex flex-col items-center">
                      <span class="font-semibold text-sm">{{ profile?.messagesCount || '0' }}</span>
                      <span class="text-neutral-500 text-xs">messages</span>
                    </div>
                    <div class="flex flex-col items-center">
                      <span class="font-semibold text-sm">{{ profile?.requestsCount || '0' }}</span>
                      <span class="text-neutral-500 text-xs">demandes</span>
                    </div>
                  </div>
                  
                  <!-- Type de compte -->
                  <div class="flex items-center gap-2">
                    <span 
                      class="text-xs font-medium"
                      :class="profile?.isExpert ? 'text-blue-600 dark:text-blue-400' : 'text-purple-600 dark:text-purple-400'"
                    >
                      {{ profile?.isExpert ? 'Expert' : 'Client' }}
                    </span>
                    <span class="text-neutral-300 dark:text-neutral-600">•</span>
                    <span class="text-xs text-neutral-500">
                      Membre depuis {{ profile?.memberSince || 'Janvier 2023' }}
                    </span>
                  </div>
                  
                  <!-- Bio utilisateur (optionnel) -->
                  <p v-if="profile?.bio" class="mt-3 text-sm text-neutral-800 dark:text-neutral-200">
                    {{ profile.bio }}
                  </p>
                </div>
              </div>
            </div>
            
            <!-- Navigation style Instagram -->
            <div class="mb-6">
              <nav class="flex overflow-x-auto scrollbar-hide border-b border-neutral-200 dark:border-neutral-800">
                <div class="flex min-w-full">
                  <NuxtLink
                    v-for="item in accountNavItems" 
                    :key="item.name"
                    :to="item.href"
                    class="py-3 px-4 whitespace-nowrap transition-all duration-200 flex items-center gap-1.5 relative uppercase text-xs font-medium"
                    :class="[
                      isActive(item.href)
                      ? 'text-neutral-900 dark:text-white'
                      : 'text-neutral-500 dark:text-neutral-400 hover:text-neutral-700 dark:hover:text-neutral-300'
                    ]"
                  >
                    <component :is="getNavIcon(item.name)" 
                      class="w-4 h-4 transition-colors" 
                      :class="isActive(item.href) ? 'text-neutral-900 dark:text-white' : 'text-neutral-500'" 
                    />
                    {{ item.name }}
                    <div v-if="getNotificationCount(item.name) > 0" 
                      class="ml-1 flex items-center justify-center min-w-[16px] h-[16px] rounded-full bg-red-500 text-white text-[10px] font-bold px-1"
                    >
                      {{ getNotificationCount(item.name) }}
                    </div>
                    
                    <!-- Indicateur de sélection style Instagram -->
                    <div 
                      v-if="isActive(item.href)" 
                      class="absolute top-0 left-0 right-0 mx-auto w-full h-[1px] bg-neutral-900 dark:bg-white"
                    ></div>
                  </NuxtLink>
                </div>
              </nav>
            </div>
            
            <!-- Contenu principal -->
            <div class="bg-white dark:bg-neutral-900 mb-8">
              <div class="py-4">
                <slot />
              </div>
            </div>
          </div>
        </main>
      </div>
    </template>
  </DefaultLayout>
</template>

<script setup>
import { ref, computed } from 'vue';
import { useRoute } from 'vue-router';
import {
  Bell, User, Menu, X, ChevronDown, 
  LogOut, Settings, Home, MessageSquare,
  FileText, CreditCard, Briefcase, Star,
  Heart, PlusCircle, ShoppingBag, Send,
  Calendar, CheckCircle, XCircle, AlertTriangle
} from 'lucide-vue-next';
import { useProfile } from '~/composables/useProfile';
import DefaultLayout from './default.vue'

const route = useRoute();
const { profile } = useProfile();
const mobileMenuOpen = ref(false);
const profileDropdownOpen = ref(false);
const isOnline = ref(true);
const profileActive = ref(true);

const toggleOnlineStatus = () => {
  isOnline.value = !isOnline.value;
};

// Fonction pour activer/désactiver le profil
const toggleProfileStatus = async () => {
  profileActive.value = !profileActive.value;
  
  // Notification de changement d'état
  const message = profileActive.value ? 
    'Votre profil est maintenant visible par les autres utilisateurs' : 
    'Votre profil est maintenant masqué aux autres utilisateurs';
  
  // Ici, vous pourriez ajouter une logique pour sauvegarder l'état dans la base de données
  // await updateProfileStatus(profileActive.value);
  
  // Afficher une notification (si vous avez un système de notification)
  // showNotification({ message, type: profileActive.value ? 'success' : 'warning' });
};

// Navigation principale
const mainNavItems = [
  { name: 'Accueil', href: '/' },
  { name: 'Explorer', href: '/experts' },
  { name: 'Demandes', href: '/requests' },
  { name: 'Mon compte', href: '/account' },
];

// Navigation du compte - items communs
const commonNavItems = [
  { name: 'Profil', href: '/account' },
  { name: 'Messages', href: '/account/messages' },
  { name: 'Contrats', href: '/account/contracts' },
  { name: 'Paramètres', href: '/account/settings' },
];

// Items spécifiques aux clients
const clientNavItems = [
  { name: 'Mes demandes', href: '/account/requests' },
];

// Items spécifiques aux experts
const expertNavItems = [
  { name: 'Mes services', href: '/account/services' },
  { name: 'Propositions', href: '/account/proposals' },
];

// Construire le menu selon le type d'utilisateur
const accountNavItems = computed(() => {
  const navItems = [...commonNavItems];
  
  if (profile.value?.isExpert) {
    navItems.splice(1, 0, ...expertNavItems);
  } else {
    navItems.splice(1, 0, ...clientNavItems);
  }
  
  return navItems;
});

// Fonction pour obtenir l'icône correspondant à chaque élément de navigation
const getNavIcon = (name) => {
  switch (name) {
    case 'Profil': return User;
    case 'Mes demandes': return FileText;
    case 'Messages': return MessageSquare;
    case 'Contrats': return ShoppingBag;
    case 'Mes services': return Briefcase;
    case 'Propositions': return Send;
    case 'Paramètres': return Settings;
    default: return Home;
  }
};

// Fonction pour simuler des notifications
const getNotificationCount = (name) => {
  if (name === 'Messages') return 3;
  if (name === 'Mes demandes') return 1;
  if (name === 'Propositions') return 2;
  return 0;
};

// Fonction pour vérifier si un lien est actif
const isActive = (href) => {
  return route.path.startsWith(href);
};

// Fonction de déconnexion
const logout = async () => {
  profileDropdownOpen.value = false;
  navigateTo('/');
};

definePageMeta({
  layout: 'default'
});
</script>

<style scoped>
.scrollbar-hide {
  -ms-overflow-style: none;
  scrollbar-width: none;
}
.scrollbar-hide::-webkit-scrollbar {
  display: none;
}
</style>