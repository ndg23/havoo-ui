<template>
    <div class="min-h-screen bg-gray-50 dark:bg-gray-900">
      <!-- En-tête -->
      <header class="bg-white dark:bg-gray-800 border-b border-gray-200 dark:border-gray-700 shadow-sm">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="flex justify-between h-16">
            <!-- Logo et Navigation principale -->
            <div class="flex">
              <div class="flex-shrink-0 flex items-center">
                <NuxtLink to="/" class="text-primary-600 dark:text-primary-400 font-bold text-xl">
                  HAVOO
                </NuxtLink>
              </div>
              <nav class="hidden sm:ml-6 sm:flex sm:space-x-8">
                <NuxtLink to="/" class="inline-flex items-center px-1 pt-1 text-sm font-medium text-gray-500 dark:text-gray-400 hover:text-gray-900 dark:hover:text-white">
                  Accueil
                </NuxtLink>
                <NuxtLink to="/requests" class="inline-flex items-center px-1 pt-1 text-sm font-medium text-gray-500 dark:text-gray-400 hover:text-gray-900 dark:hover:text-white">
                  Demandes
                </NuxtLink>
                <NuxtLink to="/services" class="inline-flex items-center px-1 pt-1 text-sm font-medium text-gray-500 dark:text-gray-400 hover:text-gray-900 dark:hover:text-white">
                  Services
                </NuxtLink>
                <NuxtLink to="/experts" class="inline-flex items-center px-1 pt-1 text-sm font-medium text-gray-500 dark:text-gray-400 hover:text-gray-900 dark:hover:text-white">
                  Experts
                </NuxtLink>
              </nav>
            </div>
            
            <!-- Actions utilisateur -->
            <div class="hidden sm:ml-6 sm:flex sm:items-center">
              <!-- Notifications -->
              <button class="p-1.5 rounded-full text-gray-500 dark:text-gray-400 hover:text-gray-900 dark:hover:text-white focus:outline-none">
                <Bell class="h-5 w-5" />
              </button>
              
              <!-- Menu utilisateur -->
              <div class="ml-3 relative">
                <button class="flex items-center space-x-2 p-1.5 rounded-full text-gray-500 dark:text-gray-400 hover:text-gray-900 dark:hover:text-white focus:outline-none">
                  <User class="h-5 w-5" />
                  <span class="text-sm font-medium">Mon compte</span>
                  <ChevronDown class="h-4 w-4" />
                </button>
              </div>
            </div>
          </div>
        </div>
      </header>
      
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div class="flex flex-col md:flex-row gap-8">
          <!-- Barre latérale de navigation de compte -->
          <div class="w-full md:w-64 flex-shrink-0">
            <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 shadow-sm overflow-hidden">
              <div class="px-6 py-4 bg-gradient-to-r from-primary-600 to-primary-700 text-white">
                <h2 class="font-semibold text-lg">Mon espace</h2>
              </div>
              
              <nav class="py-2">
                <NuxtLink 
                  to="/account" 
                  class="flex items-center px-6 py-3 text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors"
                  :class="{ 'bg-gray-100 dark:bg-gray-700 border-l-4 border-primary-500 font-medium text-primary-600 dark:text-primary-400': $route.path === '/account' }"
                >
                  <User class="h-5 w-5 mr-3" />
                  Tableau de bord
                </NuxtLink>
                
                <NuxtLink 
                  to="/account/edit-profile" 
                  class="flex items-center px-6 py-3 text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors"
                  :class="{ 'bg-gray-100 dark:bg-gray-700 border-l-4 border-primary-500 font-medium text-primary-600 dark:text-primary-400': $route.path === '/account/edit-profile' }"
                >
                  <Settings class="h-5 w-5 mr-3" />
                  Modifier mon profil
                </NuxtLink>
                
                <div class="px-6 py-2 text-xs font-medium text-gray-500 dark:text-gray-400 uppercase mt-4">
                  Demandes
                </div>
                
                <NuxtLink 
                  to="/account/requests" 
                  class="flex items-center px-6 py-3 text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors"
                  :class="{ 'bg-gray-100 dark:bg-gray-700 border-l-4 border-primary-500 font-medium text-primary-600 dark:text-primary-400': $route.path === '/account/requests' }"
                >
                  <FileQuestion class="h-5 w-5 mr-3" />
                  Mes demandes
                </NuxtLink>
                
                <div v-if="isExpert" class="px-6 py-2 text-xs font-medium text-gray-500 dark:text-gray-400 uppercase mt-4">
                  Expert
                </div>
                
                <NuxtLink 
                  v-if="isExpert"
                  to="/account/services" 
                  class="flex items-center px-6 py-3 text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors"
                  :class="{ 'bg-gray-100 dark:bg-gray-700 border-l-4 border-primary-500 font-medium text-primary-600 dark:text-primary-400': $route.path === '/account/services' }"
                >
                  <Briefcase class="h-5 w-5 mr-3" />
                  Mes services
                </NuxtLink>
                
                <NuxtLink 
                  v-if="isExpert"
                  to="/account/my-proposals" 
                  class="flex items-center px-6 py-3 text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors"
                  :class="{ 'bg-gray-100 dark:bg-gray-700 border-l-4 border-primary-500 font-medium text-primary-600 dark:text-primary-400': $route.path === '/account/my-proposals' }"
                >
                  <Send class="h-5 w-5 mr-3" />
                  Mes propositions
                </NuxtLink>
                
                <div class="px-6 py-2 text-xs font-medium text-gray-500 dark:text-gray-400 uppercase mt-4">
                  Contrats
                </div>
                
                <NuxtLink 
                  to="/account/contracts" 
                  class="flex items-center px-6 py-3 text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors"
                  :class="{ 'bg-gray-100 dark:bg-gray-700 border-l-4 border-primary-500 font-medium text-primary-600 dark:text-primary-400': $route.path === '/account/contracts' }"
                >
                  <FileText class="h-5 w-5 mr-3" />
                  Mes contrats
                </NuxtLink>
                
                <div class="px-6 py-2 text-xs font-medium text-gray-500 dark:text-gray-400 uppercase mt-4">
                  Paiements
                </div>
                
                <NuxtLink 
                  to="/account/payment-methods" 
                  class="flex items-center px-6 py-3 text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors"
                  :class="{ 'bg-gray-100 dark:bg-gray-700 border-l-4 border-primary-500 font-medium text-primary-600 dark:text-primary-400': $route.path === '/account/payment-methods' }"
                >
                  <CreditCard class="h-5 w-5 mr-3" />
                  Moyens de paiement
                </NuxtLink>
                
                <NuxtLink 
                  to="/account/transactions" 
                  class="flex items-center px-6 py-3 text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors"
                  :class="{ 'bg-gray-100 dark:bg-gray-700 border-l-4 border-primary-500 font-medium text-primary-600 dark:text-primary-400': $route.path === '/account/transactions' }"
                >
                  <DollarSign class="h-5 w-5 mr-3" />
                  Transactions
                </NuxtLink>
                
                <div class="border-t border-gray-200 dark:border-gray-700 my-2"></div>
                
                <button 
                  @click="logout"
                  class="w-full flex items-center px-6 py-3 text-red-600 dark:text-red-400 hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors"
                >
                  <LogOut class="h-5 w-5 mr-3" />
                  Déconnexion
                </button>
              </nav>
            </div>
          </div>
          
          <!-- Contenu principal -->
          <div class="flex-1">
            <slot />
          </div>
        </div>
      </div>
      
      <!-- Pied de page -->
      <footer class="bg-white dark:bg-gray-800 border-t border-gray-200 dark:border-gray-700 py-8 mt-12">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="text-center text-gray-500 dark:text-gray-400 text-sm">
            <p>&copy; {{ new Date().getFullYear() }} HAVOO. Tous droits réservés.</p>
          </div>
        </div>
      </footer>
    </div>
  </template>
  
  <script setup>
  import { ref, onMounted } from 'vue'
  import { useRouter } from 'vue-router'
  import { 
    User, 
    Bell, 
    Settings, 
    FileQuestion, 
    Briefcase, 
    FileText,
    CreditCard,
    DollarSign,
    LogOut,
    Send,
    ChevronDown
  } from 'lucide-vue-next'
  
  const router = useRouter()
  const supabase = useSupabaseClient()
  const isExpert = ref(false)
  
  // Vérifier si l'utilisateur est un expert
  const checkUserRole = async () => {
    try {
      const { data: userData } = await supabase.auth.getUser()
      
      if (userData?.user) {
        const { data } = await supabase
          .from('profiles')
          .select('is_expert, role')
          .eq('id', userData.user.id)
          .single()
        
        isExpert.value = data?.is_expert || data?.role === 'expert'
      }
    } catch (error) {
      console.error('Erreur lors de la vérification du rôle:', error)
    }
  }
  
  // Déconnexion
  const logout = async () => {
    try {
      await supabase.auth.signOut()
      router.push('/auth/login')
    } catch (error) {
      console.error('Erreur lors de la déconnexion:', error)
    }
  }
  
  onMounted(() => {
    checkUserRole()
  })
  </script>