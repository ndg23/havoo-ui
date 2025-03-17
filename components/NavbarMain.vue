<template>
  <nav class="bg-white border-b border-gray-100 sticky top-0 z-50">
    <div class="max-w-6xl mx-auto px-4">
      <div class="flex justify-between h-16">
        <!-- Logo -->
        <div class="flex-shrink-0 flex items-center">
          <NuxtLink to="/" class="text-xl font-bold text-black">
            ExpertConnect
          </NuxtLink>
        </div>
        
        <!-- Navigation principale (desktop) - Centrée -->
        <div class="hidden md:flex items-center justify-center flex-1 px-2">
          <div class="flex space-x-4">
            <NuxtLink 
              v-for="item in navigationItems" 
              :key="item.name"
              :to="item.href"
              class="px-3 py-2 rounded-md text-sm font-medium transition-colors"
              :class="isActive(item.href) 
                ? 'bg-gray-900 text-white' 
                : 'text-gray-700 hover:bg-gray-100'"
            >
              {{ item.name }}
            </NuxtLink>
          </div>
        </div>
        
        <!-- Boutons d'action et menu utilisateur -->
        <div class="flex items-center">
          <!-- Bouton de recherche -->
          <button 
            class="p-2 rounded-full text-gray-500 hover:text-gray-700 hover:bg-gray-100 focus:outline-none"
            @click="toggleSearch"
          >
            <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
            </svg>
          </button>
          
          <!-- Bouton de notification -->
          <button 
            v-if="user"
            class="ml-3 p-2 rounded-full text-gray-500 hover:text-gray-700 hover:bg-gray-100 focus:outline-none relative"
          >
            <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9" />
            </svg>
            <span 
              v-if="notificationCount > 0"
              class="absolute top-0 right-0 inline-flex items-center justify-center px-2 py-1 text-xs font-bold leading-none text-white transform translate-x-1/2 -translate-y-1/2 bg-red-500 rounded-full"
            >
              {{ notificationCount > 9 ? '9+' : notificationCount }}
            </span>
          </button>
          
          <!-- Boutons de connexion/inscription (non connecté) -->
          <div v-if="!user" class="ml-4 flex items-center">
            <NuxtLink 
              to="/auth/login" 
              class="text-sm font-medium text-gray-700 hover:text-gray-900 mr-4"
            >
              Connexion
            </NuxtLink>
            <NuxtLink 
              to="/auth/register" 
              class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md text-white bg-black hover:bg-gray-800 shadow-sm"
            >
              Inscription
            </NuxtLink>
          </div>
          
          <!-- Menu utilisateur (connecté) -->
          <div v-else class="ml-3 relative">
            <div>
              <button 
                @click="isUserMenuOpen = !isUserMenuOpen" 
                class="flex text-sm rounded-full focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-black"
                id="user-menu-button"
                aria-expanded="false"
                aria-haspopup="true"
              >
                <span class="sr-only">Ouvrir le menu utilisateur</span>
                <div v-if="profile?.avatar_url" class="h-8 w-8 rounded-full overflow-hidden border border-gray-200">
                  <img 
                    :src="profile.avatar_url" 
                    alt="Avatar de l'utilisateur"
                    class="h-full w-full object-cover"
                  >
                </div>
                <div v-else class="h-8 w-8 rounded-full bg-gray-200 flex items-center justify-center text-gray-600 border border-gray-300">
                  {{ userInitials }}
                </div>
              </button>
            </div>
            
            <!-- Menu déroulant utilisateur -->
            <div 
              v-if="isUserMenuOpen" 
              class="origin-top-right absolute right-0 mt-2 w-56 rounded-md shadow-lg bg-white ring-1 ring-black ring-opacity-5 divide-y divide-gray-100 focus:outline-none z-50"
              role="menu"
              aria-orientation="vertical"
              aria-labelledby="user-menu-button"
              tabindex="-1"
            >
              <div class="px-4 py-3">
                <p class="text-sm font-medium text-gray-900">{{ profile?.first_name }} {{ profile?.last_name }}</p>
                <p class="text-xs text-gray-500 truncate mt-1">{{ user.email }}</p>
              </div>
              
              <div class="py-1">
                <!-- Profil et messages -->
                <NuxtLink 
                  to="/account/" 
                  class="flex items-center px-4 py-2 text-sm text-gray-700 hover:bg-gray-100"
                  role="menuitem"
                  tabindex="-1"
                  @click="isUserMenuOpen = false"
                >
                  <svg class="mr-3 h-5 w-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                  </svg>
                  Mon profil
                </NuxtLink>
                
                <NuxtLink 
                  to="/account/messages" 
                  class="flex items-center px-4 py-2 text-sm text-gray-700 hover:bg-gray-100"
                  role="menuitem"
                  tabindex="-1"
                  @click="isUserMenuOpen = false"
                >
                  <svg class="mr-3 h-5 w-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 10h.01M12 10h.01M16 10h.01M9 16H5a2 2 0 01-2-2V6a2 2 0 012-2h14a2 2 0 012 2v8a2 2 0 01-2 2h-5l-5 5v-5z" />
                  </svg>
                  Mes messages
                </NuxtLink>
              </div>
              
              <!-- Section "Je cherche" -->
              <div class="py-1">
                <div class="px-4 py-1 text-xs font-semibold text-gray-500 uppercase tracking-wider">
                  Je cherche
                </div>
                
                <NuxtLink 
                  to="/account/requests" 
                  class="flex items-center px-4 py-2 text-sm text-gray-700 hover:bg-gray-100"
                  role="menuitem"
                  tabindex="-1"
                  @click="isUserMenuOpen = false"
                >
                  <svg class="mr-3 h-5 w-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
                  </svg>
                  Mes demandes
                </NuxtLink>
              </div>
              
              <!-- Section "Je propose" -->
              <div class="py-1">
                <div class="px-4 py-1 text-xs font-semibold text-gray-500 uppercase tracking-wider">
                  Je propose
                </div>
                
                <NuxtLink 
                  to="/account/services" 
                  class="flex items-center px-4 py-2 text-sm text-gray-700 hover:bg-gray-100"
                  role="menuitem"
                  tabindex="-1"
                  @click="isUserMenuOpen = false"
                >
                  <svg class="mr-3 h-5 w-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                  </svg>
                  Mes services
                </NuxtLink>
                
                <NuxtLink 
                  to="/account/proposals" 
                  class="flex items-center px-4 py-2 text-sm text-gray-700 hover:bg-gray-100"
                  role="menuitem"
                  tabindex="-1"
                  @click="isUserMenuOpen = false"
                >
                  <svg class="mr-3 h-5 w-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                  </svg>
                  Mes propositions
                </NuxtLink>
                
                <NuxtLink 
                  v-if="!isVerified"
                  to="/account/verify" 
                  class="flex items-center px-4 py-2 text-sm text-orange-600 hover:bg-orange-50"
                  role="menuitem"
                  tabindex="-1"
                  @click="isUserMenuOpen = false"
                >
                  <svg class="mr-3 h-5 w-5 text-orange-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" />
                  </svg>
                  Vérifier mon identité
                </NuxtLink>
              </div>
              
              <!-- Contrats et déconnexion -->
              <div class="py-1">
                <NuxtLink 
                  to="/account/contracts" 
                  class="flex items-center px-4 py-2 text-sm text-gray-700 hover:bg-gray-100"
                  role="menuitem"
                  tabindex="-1"
                  @click="isUserMenuOpen = false"
                >
                  <svg class="mr-3 h-5 w-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                  </svg>
                  Mes contrats
                </NuxtLink>
                
                <button 
                  @click="logout" 
                  class="flex w-full items-center px-4 py-2 text-sm text-red-600 hover:bg-red-50"
                  role="menuitem"
                  tabindex="-1"
                >
                  <svg class="mr-3 h-5 w-5 text-red-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" />
                  </svg>
                  Déconnexion
                </button>
              </div>
            </div>
          </div>
          
          <!-- Bouton menu mobile -->
          <div class="flex md:hidden ml-2">
            <button
              @click="isMobileMenuOpen = !isMobileMenuOpen"
              class="inline-flex items-center justify-center p-2 rounded-md text-gray-700 hover:text-gray-900 hover:bg-gray-100 focus:outline-none"
            >
              <svg
                class="h-6 w-6"
                :class="isMobileMenuOpen ? 'hidden' : 'block'"
                fill="none"
                viewBox="0 0 24 24"
                stroke="currentColor"
              >
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
              </svg>
              <svg
                class="h-6 w-6"
                :class="isMobileMenuOpen ? 'block' : 'hidden'"
                fill="none" 
                viewBox="0 0 24 24" 
                stroke="currentColor"
              >
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
              </svg>
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Menu mobile -->
    <div 
      v-if="isMobileMenuOpen" 
      class="md:hidden bg-white border-b border-gray-200 shadow-lg"
    >
      <div class="pt-2 pb-3 space-y-1">
        <NuxtLink 
          v-for="item in navigationItems" 
          :key="item.name"
          :to="item.href"
          class="block px-3 py-2 text-base font-medium"
          :class="isActive(item.href) 
            ? 'bg-gray-900 text-white' 
            : 'text-gray-700 hover:bg-gray-100'"
          @click="isMobileMenuOpen = false"
        >
          {{ item.name }}
        </NuxtLink>
      </div>
      
      <!-- Section utilisateur (si connecté) -->
      <div v-if="user && profile" class="pt-4 pb-3 border-t border-gray-200">
        <div class="flex items-center px-4">
          <div class="flex-shrink-0">
            <div v-if="profile?.avatar_url" class="h-10 w-10 rounded-full overflow-hidden border border-gray-200">
              <img 
                :src="profile.avatar_url" 
                alt="Avatar de l'utilisateur"
                class="h-full w-full object-cover"
              >
            </div>
            <div v-else class="h-10 w-10 rounded-full bg-gray-200 flex items-center justify-center text-gray-600 border border-gray-300">
              {{ userInitials }}
            </div>
          </div>
          <div class="ml-3">
            <div class="text-base font-medium text-gray-800">{{ profile?.first_name }} {{ profile?.last_name }}</div>
            <div class="text-sm font-medium text-gray-500">{{ user.email }}</div>
          </div>
        </div>
        
        <div class="mt-3 space-y-1">
          <!-- Profil et messages -->
          <NuxtLink 
            to="/account/" 
            class="flex items-center px-4 py-2 text-base font-medium text-gray-700 hover:bg-gray-100"
            @click="isMobileMenuOpen = false"
          >
            <svg class="mr-3 h-5 w-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
            </svg>
            Mon profil
          </NuxtLink>
          
          <NuxtLink 
            to="/account/messages" 
            class="flex items-center px-4 py-2 text-base font-medium text-gray-700 hover:bg-gray-100"
            @click="isMobileMenuOpen = false"
          >
            <svg class="mr-3 h-5 w-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 10h.01M12 10h.01M16 10h.01M9 16H5a2 2 0 01-2-2V6a2 2 0 012-2h14a2 2 0 012 2v8a2 2 0 01-2 2h-5l-5 5v-5z" />
            </svg>
            Mes messages
          </NuxtLink>
          
          <!-- Séparateur avec titre "Je cherche" -->
          <div class="border-t border-gray-200 pt-2 mt-2">
            <div class="px-4 py-1 text-xs font-semibold text-gray-500 uppercase tracking-wider">
              Je cherche
            </div>
            
            <NuxtLink 
              to="/account/requests" 
              class="flex items-center px-4 py-2 text-base font-medium text-gray-700 hover:bg-gray-100"
              @click="isMobileMenuOpen = false"
            >
              <svg class="mr-3 h-5 w-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
              </svg>
              Mes demandes
            </NuxtLink>
          </div>
          
          <!-- Séparateur avec titre "Je propose" -->
          <div class="border-t border-gray-200 pt-2 mt-2">
            <div class="px-4 py-1 text-xs font-semibold text-gray-500 uppercase tracking-wider">
              Je propose
            </div>
            
            <NuxtLink 
              to="/account/services" 
              class="flex items-center px-4 py-2 text-base font-medium text-gray-700 hover:bg-gray-100"
              @click="isMobileMenuOpen = false"
            >
              <svg class="mr-3 h-5 w-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
              </svg>
              Mes services
            </NuxtLink>
            
            <NuxtLink 
              to="/account/proposals" 
              class="flex items-center px-4 py-2 text-base font-medium text-gray-700 hover:bg-gray-100"
              @click="isMobileMenuOpen = false"
            >
              <svg class="mr-3 h-5 w-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
              Mes propositions
            </NuxtLink>
            
            <NuxtLink 
              v-if="!isVerified"
              to="/account/verify" 
              class="flex items-center px-4 py-2 text-base font-medium text-orange-600 hover:bg-orange-50"
              @click="isMobileMenuOpen = false"
            >
              <svg class="mr-3 h-5 w-5 text-orange-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" />
              </svg>
              Vérifier mon identité
            </NuxtLink>
          </div>
          
          <!-- Contrats et déconnexion -->
          <div class="border-t border-gray-200 pt-2 mt-2">
            <NuxtLink 
              to="/account/contracts" 
              class="flex items-center px-4 py-2 text-base font-medium text-gray-700 hover:bg-gray-100"
              @click="isMobileMenuOpen = false"
            >
              <svg class="mr-3 h-5 w-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
              </svg>
              Mes contrats
            </NuxtLink>
            
            <button 
              @click="logout" 
              class="flex w-full items-center px-4 py-2 text-base font-medium text-red-600 hover:bg-red-50"
            >
              <svg class="mr-3 h-5 w-5 text-red-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" />
              </svg>
              Déconnexion
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Overlay de recherche -->
    <div 
      v-if="isSearchOpen" 
      class="absolute inset-0 z-50 bg-white"
    >
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
        <div class="flex items-center">
          <div class="flex-1">
            <input 
              type="text" 
              placeholder="Rechercher..." 
              class="w-full border-0 focus:ring-0 text-lg"
              v-model="searchQuery"
              @keyup.enter="performSearch"
              ref="searchInput"
            >
          </div>
          <button 
            @click="toggleSearch" 
            class="p-2 rounded-full text-gray-500 hover:text-gray-700 hover:bg-gray-100"
          >
            <svg class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </div>
      </div>
    </div>
  </nav>
</template>

<script setup>
import { ref, computed, onMounted, onBeforeUnmount, nextTick } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import { useSupabaseClient, useSupabaseUser } from '#imports';

const supabase = useSupabaseClient();
const user = useSupabaseUser();
const router = useRouter();
const route = useRoute();

// État
const profile = ref(null);
const isUserMenuOpen = ref(false);
const isMobileMenuOpen = ref(false);
const isSearchOpen = ref(false);
const searchQuery = ref('');
const notificationCount = ref(0);
const isVerified = ref(false);

// Computed properties
const isExpert = computed(() => {
  return profile.value?.role === 'expert' || profile.value?.is_expert === true;
});

// Éléments de navigation
const navigationItems = [
  { name: 'Accueil', href: '/' },
  { name: 'Demandes', href: '/requests' },
  { name: 'Experts', href: '/experts' },
  { name: 'Comment ça marche', href: '/how-it-works' },
];

// Vérifier si un lien est actif
const isActive = (href) => {
  if (href === '/') {
    return route.path === '/';
  }
  return route.path.startsWith(href);
};

// Obtenir les initiales de l'utilisateur
const userInitials = computed(() => {
  if (!profile.value) return '';
  
  const firstName = profile.value.first_name || '';
  const lastName = profile.value.last_name || '';
  
  return (firstName.charAt(0) + lastName.charAt(0)).toUpperCase();
});

// Récupérer le profil de l'utilisateur
const fetchProfile = async () => {
  if (!user.value) return;
  
  try {
    const { data, error } = await supabase
      .from('profiles')
      .select('*')
      .eq('id', user.value.id)
      .single();
    
    if (error) throw error;
    
    profile.value = data;
    
    // Vérifier si l'expert est vérifié
    if (isExpert.value) {
      await checkVerificationStatus();
    }
  } catch (err) {
    console.error('Error fetching profile:', err);
  }
};

// Vérifier le statut de vérification de l'expert
const checkVerificationStatus = async () => {
  try {
    const { data, error } = await supabase
      .from('verifications')
      .select('status')
      .eq('user_id', user.value.id)
      .order('submitted_at', { ascending: false })
      .limit(1)
      .single();
    
    if (error && error.code !== 'PGRST116') throw error;
    
    isVerified.value = data?.status === 'approved';
  } catch (err) {
    console.error('Error checking verification status:', err);
  }
};

// Récupérer le nombre de notifications
const fetchNotifications = async () => {
  if (!user.value) return;
  
  try {
    // Exemple : compter les messages non lus
    const { count, error } = await supabase
      .from('messages')
      .select('*', { count: 'exact', head: true })
      .eq('recipient_id', user.value.id)
      .eq('is_read', false);
    
    if (error) throw error;
    
    notificationCount.value = count || 0;
  } catch (err) {
    console.error('Error fetching notifications:', err);
  }
};

// Déconnexion
const logout = async () => {
  try {
    const { error } = await supabase.auth.signOut();
    if (error) throw error;
    
    router.push('/');
  } catch (err) {
    console.error('Error signing out:', err);
  }
};

// Ouvrir/fermer la recherche
const toggleSearch = () => {
  isSearchOpen.value = !isSearchOpen.value;
  
  if (isSearchOpen.value) {
    nextTick(() => {
      if (document.activeElement) {
        document.activeElement.blur();
      }
      if (document.querySelector('input[type="text"]')) {
        document.querySelector('input[type="text"]').focus();
      }
    });
  }
};

// Effectuer une recherche
const performSearch = () => {
  if (!searchQuery.value.trim()) return;
  
  router.push({
    path: '/search',
    query: { q: searchQuery.value }
  });
  
  isSearchOpen.value = false;
  searchQuery.value = '';
};

// Fermer les menus en cliquant ailleurs
const handleClickOutside = (event) => {
  if (isUserMenuOpen.value && !event.target.closest('#user-menu-button')) {
    isUserMenuOpen.value = false;
  }
};

// Cycle de vie
onMounted(() => {
  fetchProfile();
  fetchNotifications();
  document.addEventListener('click', handleClickOutside);
});

onBeforeUnmount(() => {
  document.removeEventListener('click', handleClickOutside);
});
</script>