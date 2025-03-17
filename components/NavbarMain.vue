<template>
    <header class="fixed inset-x-0 top-0 z-50">
      <!-- Improved navbar with more refined aesthetics -->
      <div class="bg-white shadow-sm border-b border-gray-50">
        <div class="max-w-7xl mx-auto">
          <div class="flex items-center justify-between h-16 px-4 sm:px-6 lg:px-8">
            <!-- Refined logo and brand -->
            <div class="flex items-center">
              <nuxt-link to="/" class="flex items-center" aria-label="Accueil">
                <div class="w-10 h-10 bg-primary-600 rounded flex items-center justify-center transition-transform hover:scale-105">
                  <svg class="w-5 h-5 text-white" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path d="M12 2L2 7l10 5 10-5-10-5z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                    <path d="M2 17l10 5 10-5" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                    <path d="M2 12l10 5 10-5" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                  </svg>
                </div>
                <span class="ml-3 text-lg font-bold text-gray-900">Nom App</span>
              </nuxt-link>
            </div>
  
            <!-- Streamlined navigation links (desktop) -->
            <nav class="hidden md:flex items-center space-x-10 flex-1 mx-8 justify-center">
              <nuxt-link to="/explore" class="nav-link" active-class="nav-link-active">
                Explorer
              </nuxt-link>
              
              <nuxt-link to="/requests" class="nav-link" active-class="nav-link-active">
                Demandes
              </nuxt-link>
              
              <nuxt-link to="/messages" class="nav-link flex items-center" active-class="nav-link-active">
                Messages
                <!-- More compact badge -->
                <span v-if="unreadMessagesCount > 0" class="ml-1.5 bg-primary-500 text-white rounded-full h-5 min-w-5 inline-flex items-center justify-center text-xs font-medium px-1">
                  {{ unreadMessagesCount > 9 ? '9+' : unreadMessagesCount }}
                </span>
              </nuxt-link>
            </nav>
            
            <!-- Simplified right side actions -->
            <div class="flex items-center">
              <!-- Avatar and dropdown for authenticated users with cleaner design -->
              <template v-if="user">
                <div class="relative">
                  <button 
                    @click="showUserMenu = !showUserMenu" 
                    type="button" 
                    class="flex items-center justify-center rounded-full overflow-hidden focus:outline-none focus:ring-2 focus:ring-primary-500 focus:ring-offset-1"
                    id="user-menu-button"
                    aria-expanded="false"
                    aria-haspopup="true"
                  >
                    <span class="sr-only">Open user menu</span>
                    <div class="h-9 w-9 rounded-full bg-primary-100 flex items-center justify-center text-primary-800 text-sm font-medium">
                      {{ user.first_name.charAt(0) + user.last_name.charAt(0) }}
                    </div>
                  </button>
                  
                  <!-- Cleaner dropdown menu -->
                  <transition
                    enter-active-class="transition ease-out duration-200"
                    enter-from-class="transform opacity-0 scale-95"
                    enter-to-class="transform opacity-100 scale-100"
                    leave-active-class="transition ease-in duration-75"
                    leave-from-class="transform opacity-100 scale-100"
                    leave-to-class="transform opacity-0 scale-95"
                  >
                    <div 
                      v-if="showUserMenu"
                      class="absolute right-0 z-10 mt-2 w-48 origin-top-right rounded-lg bg-white py-1 shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none"
                      role="menu" 
                      aria-orientation="vertical" 
                      aria-labelledby="user-menu-button"
                      tabindex="-1"
                    >
                      <div class="border-b border-gray-50 pb-2 mb-1">
                        <div class="block px-4 py-2 text-sm">
                          <div class="font-medium text-gray-800">{{ user.first_name }} {{ user.last_name }}</div>
                          <div class="text-gray-500 truncate text-xs">{{ user.email }}</div>
                        </div>
                      </div>
                      
                      <nuxt-link to="/profile" class="menu-item" role="menuitem">
                        Profil
                      </nuxt-link>
                      <nuxt-link to="/account" class="menu-item" role="menuitem">
                        Paramètres
                      </nuxt-link>
                      <button 
                        @click="logout"
                        class="menu-item w-full text-left" 
                        role="menuitem"
                      >
                        Déconnexion
                      </button>
                    </div>
                  </transition>
                </div>
                
                <!-- Enhanced create button -->
                <button 
                  @click="navigateToCreate"
                  class="create-button ml-4 rounded-full bg-primary-600 text-white px-5 py-2 text-sm font-medium transition-all duration-200 ease-in-out"
                >
                  Créer
                </button>
              </template>
              
              <!-- Streamlined login/signup buttons -->
              <template v-else>
                <nuxt-link to="/login" class="text-gray-700 hover:text-gray-900 px-3 py-2 text-sm font-medium">
                  Connexion
                </nuxt-link>
                <nuxt-link to="/signup" class="ml-3 rounded-full bg-primary-600 text-white px-5 py-2 text-sm font-medium transition-all duration-200 ease-in-out hover:bg-primary-700">
                  Inscription
                </nuxt-link>
              </template>
            </div>
            
            <!-- Cleaner mobile menu button -->
            <div class="flex md:hidden">
              <button 
                @click="showMobileMenu = !showMobileMenu"
                type="button" 
                class="p-2 rounded-md text-gray-500 hover:text-gray-900 focus:outline-none focus:ring-2 focus:ring-inset focus:ring-primary-500"
              >
                <span class="sr-only">Open menu</span>
                <svg v-if="!showMobileMenu" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
                </svg>
                <svg v-else class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                </svg>
              </button>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Improved mobile menu with smoother transitions -->
      <transition
        enter-active-class="transition ease-out duration-200"
        enter-from-class="opacity-0 -translate-y-2"
        enter-to-class="opacity-100 translate-y-0"
        leave-active-class="transition ease-in duration-150"
        leave-from-class="opacity-100 translate-y-0"
        leave-to-class="opacity-0 -translate-y-2"
      >
        <div v-if="showMobileMenu" class="md:hidden bg-white border-b border-gray-50 shadow">
          <div class="space-y-1 px-3 pt-2 pb-3">
            <nuxt-link to="/explore" class="mobile-nav-link" active-class="mobile-nav-link-active">
              Explorer
            </nuxt-link>
            <nuxt-link to="/requests" class="mobile-nav-link" active-class="mobile-nav-link-active">
              Demandes
            </nuxt-link>
            <nuxt-link to="/messages" class="mobile-nav-link flex justify-between items-center" active-class="mobile-nav-link-active">
              Messages
              <span v-if="unreadMessagesCount > 0" class="bg-primary-500 text-white rounded-full h-5 min-w-5 inline-flex items-center justify-center text-xs font-medium px-1">
                {{ unreadMessagesCount > 9 ? '9+' : unreadMessagesCount }}
              </span>
            </nuxt-link>
            
            <!-- Cleaner user info in mobile menu -->
            <div v-if="user" class="border-t border-gray-50 pt-4 pb-2 mt-2">
              <div class="flex items-center px-3 py-1.5">
                <div class="h-9 w-9 rounded-full bg-primary-100 flex items-center justify-center text-primary-800 text-sm font-medium">
                  {{ user.first_name.charAt(0) + user.last_name.charAt(0) }}
                </div>
                <div class="ml-3">
                  <div class="text-base font-medium text-gray-800">{{ user.first_name }} {{ user.last_name }}</div>
                  <div class="text-xs font-medium text-gray-500 truncate max-w-[200px]">{{ user.email }}</div>
                </div>
              </div>
              <div class="mt-3 space-y-0.5">
                <nuxt-link to="/profile" class="mobile-nav-link">
                  Profil
                </nuxt-link>
                <nuxt-link to="/account" class="mobile-nav-link">
                  Paramètres
                </nuxt-link>
                <button @click="logout" class="w-full text-left mobile-nav-link">
                  Déconnexion
                </button>
              </div>
            </div>
            
            <!-- Non-authenticated options in mobile menu -->
            <template v-else>
              <div class="border-t border-gray-50 pt-4 pb-2 mt-2">
                <nuxt-link to="/login" class="mobile-nav-link">
                  Connexion
                </nuxt-link>
                <nuxt-link to="/signup" class="mobile-nav-link">
                  Créer un compte
                </nuxt-link>
              </div>
            </template>
            
            <!-- Enhanced create button in mobile menu -->
            <div v-if="user" class="px-5 py-4">
              <button 
                @click="navigateToCreate" 
                class="w-full bg-primary-600 text-white rounded-full py-2.5 text-center font-medium transition-all hover:bg-primary-700 active:bg-primary-800"
              >
                Créer
              </button>
            </div>
          </div>
        </div>
      </transition>
    </header>
    
    <!-- Spacer element to push the content below fixed header -->
    <div class="h-16"></div>
  </template>
  
  <script setup>
  import { ref, onMounted, onBeforeUnmount } from 'vue';
  import { useRouter } from 'vue-router';
  import { useSupabaseClient } from '#imports';
  
  const router = useRouter();
  const supabase = useSupabaseClient();
  
  // User state
  const user = ref(null);
  const unreadMessagesCount = ref(2); // Example count, should be from your actual state
  
  // UI state
  const showUserMenu = ref(false);
  const showMobileMenu = ref(false);
  
  // Close user menu when clicking outside
  const closeUserMenu = (event) => {
    if (showUserMenu.value && !event.target.closest('#user-menu-button')) {
      showUserMenu.value = false;
    }
  };
  
  // Navigation functions
  const navigateToCreate = () => {
    router.push('/requests/new');
    showMobileMenu.value = false;
  };
  
  // Authentication functions
  const logout = async () => {
    try {
      const { error } = await supabase.auth.signOut();
      if (error) throw error;
      router.push('/login');
    } catch (error) {
      console.error('Error logging out:', error);
    } finally {
      showUserMenu.value = false;
      showMobileMenu.value = false;
    }
  };
  
  // Get current user
  const getCurrentUser = async () => {
    try {
      const { data: { session } } = await supabase.auth.getSession();
      
      if (session) {
        const { data, error } = await supabase
          .from('profiles')
          .select('*')
          .eq('id', session.user.id)
          .single();
          
        if (error) throw error;
        user.value = data;
      }
    } catch (error) {
      console.error('Error fetching user:', error);
    }
  };
  
  // Lifecycle hooks
  onMounted(() => {
    document.addEventListener('click', closeUserMenu);
    getCurrentUser();
    
    // Close mobile menu on route change
    router.afterEach(() => {
      showMobileMenu.value = false;
    });
    
    // Subscribe to auth changes
    const { data: { subscription } } = supabase.auth.onAuthStateChange(async (event) => {
      if (event === 'SIGNED_IN') {
        await getCurrentUser();
      } else if (event === 'SIGNED_OUT') {
        user.value = null;
      }
    });
    
    // Clean up subscription
    onBeforeUnmount(() => {
      subscription.unsubscribe();
    });
  });
  
  onBeforeUnmount(() => {
    document.removeEventListener('click', closeUserMenu);
  });
  </script>
  
  <style scoped>
  /* Desktop navigation styles - cleaner, more impactful */
  .nav-link {
    @apply relative font-medium text-gray-600 hover:text-gray-900 transition-colors duration-200;
    padding-bottom: 2px;
  }
  
  .nav-link-active {
    @apply text-primary-600 font-medium;
  }
  
  .nav-link-active::after {
    content: '';
    position: absolute;
    bottom: -10px;
    left: 50%;
    transform: translateX(-50%);
    width: 16px;
    height: 2px;
    background-color: rgb(79, 70, 229);
    border-radius: 4px;
  }
  
  /* Menu item styling */
  .menu-item {
    @apply block px-4 py-2 text-sm text-gray-700 hover:bg-gray-50
  }
  
  /* Desktop navigation styles - now with text only */
.nav-link {
  @apply relative font-medium text-gray-600 hover:text-gray-900;
  padding-bottom: 3px;
}

.nav-link-active {
  @apply text-primary-600;
}

.nav-link-active::after {
  content: '';
  position: absolute;
  bottom: -8px;
  left: 50%;
  transform: translateX(-50%);
  width: 16px;
  height: 3px;
  background-color: rgb(79, 70, 229);
  border-radius: 3px 3px 0 0;
}

/* Mobile navigation styles */
.mobile-nav-link {
  @apply block px-3 py-2.5 text-base font-medium rounded-lg text-gray-700 hover:bg-gray-50;
}

.mobile-nav-link-active {
  @apply bg-primary-50 text-primary-700;
}

/* Create button hover effect */
.create-button:hover {
  transform: translateY(-1px);
  box-shadow: 0 4px 6px -1px rgba(79, 70, 229, 0.1), 0 2px 4px -1px rgba(79, 70, 229, 0.06);
}

.create-button:active {
  transform: translateY(0);
}
</style> 