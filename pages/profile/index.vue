<template>
    <div class="max-w-3xl mx-auto px-4 py-12 sm:px-6">
      <!-- Profile header with Twitter-inspired minimalism -->
      <div class="bg-white dark:bg-gray-900 rounded-xl shadow-sm overflow-hidden border border-gray-100 dark:border-gray-800">
        <!-- Cover photo area -->
        <div class="h-40 sm:h-48 bg-gradient-to-r from-gray-100 to-gray-50 dark:from-gray-800 dark:to-gray-850 relative">
          <div v-if="profile?.coverUrl" class="w-full h-full">
            <img :src="profile.coverUrl" alt="Cover image" class="w-full h-full object-cover transition-opacity" />
          </div>
          <button 
            @click="openCoverInput"
            class="absolute right-4 bottom-4 bg-black/30 hover:bg-black/50 rounded-full p-2.5 transition-all backdrop-blur-sm"
          >
            <Camera class="w-4 h-4 text-white" />
          </button>
          <input ref="coverInput" type="file" class="hidden" @change="handleCoverUpload" accept="image/*" />
        </div>
        
        <div class="px-8 pb-8">
          <!-- Avatar with Twitter-like overlay -->
          <div class="relative -mt-16 mb-6">
            <div class="w-28 h-28 rounded-full border-4 border-white dark:border-gray-900 bg-gray-100 dark:bg-gray-800 overflow-hidden shadow-sm">
              <img 
                v-if="profile?.avatarUrl" 
                :src="profile.avatarUrl" 
                alt="Photo de profil"
                class="w-full h-full object-cover transition-opacity"
              />
              <User v-else class="w-full h-full p-6 text-gray-300 dark:text-gray-600" />
            </div>
            <button 
              @click="openFileInput"
              class="absolute inset-0 bg-black/20 rounded-full opacity-0 hover:opacity-100 focus:opacity-100 transition-opacity flex items-center justify-center backdrop-blur-sm"
            >
              <Camera class="w-5 h-5 text-white" />
            </button>
            <input ref="fileInput" type="file" class="hidden" @change="handleAvatarUpload" accept="image/*" />
          </div>
          
          <!-- Profile information with better spacing -->
          <div class="flex flex-col sm:flex-row sm:justify-between sm:items-center gap-4 mb-6">
            <div>
              <h1 class="text-2xl font-semibold text-gray-900 dark:text-white tracking-tight">
                {{ profile?.firstName }} {{ profile?.lastName }}
              </h1>
              <p class="text-gray-500 dark:text-gray-400 text-sm">
                {{ profile?.email }}
              </p>
              <div v-if="profile?.isExpert" class="flex items-center gap-2 mt-1">
                <span class="px-2.5 py-0.5 rounded-full text-xs font-medium bg-primary-50 text-primary-600 dark:bg-primary-900/40 dark:text-primary-300 border border-primary-100 dark:border-primary-800">
                  Expert
                </span>
                <span v-if="profile?.expertDetails?.isVerified" class="flex items-center text-xs text-primary-500">
                  <CheckCircle class="w-3.5 h-3.5 mr-0.5 fill-current" />
                  Vérifié
                </span>
              </div>
              <p v-if="profile?.isExpert && profile?.expertDetails?.profession" class="text-sm text-gray-500 dark:text-gray-400 mt-1">
                {{ profile?.expertDetails?.profession }}
              </p>
            </div>
            
            <button 
              @click="activeTab = 'edit'"
              class="rounded-full px-5 py-2 bg-primary-50 hover:bg-primary-100 dark:bg-primary-900/20 dark:hover:bg-primary-900/30 text-primary-700 dark:text-primary-300 text-sm font-medium transition-colors border border-primary-100 dark:border-primary-800/50"
            >
              Modifier le profil
            </button>
          </div>
          
          <!-- Bio section if available -->
          <p v-if="profile?.bio" class="text-gray-700 dark:text-gray-300 mb-6 leading-relaxed">
            {{ profile?.bio }}
          </p>
          
          <!-- Stats row -->
          <div class="flex flex-wrap gap-6 text-sm text-gray-500 dark:text-gray-400 mb-2">
            <div v-if="profile?.location" class="flex items-center gap-1.5">
              <MapPin class="w-4 h-4 text-gray-400" />
              {{ profile.location }}
            </div>
            <div v-if="profile?.joinDate" class="flex items-center gap-1.5">
              <Calendar class="w-4 h-4 text-gray-400" />
              Membre depuis {{ formatDate(profile.joinDate) }}
            </div>
            <div v-if="profile?.isExpert && profile?.expertDetails?.completedJobs" class="flex items-center gap-1.5">
              <CheckSquare class="w-4 h-4 text-gray-400" />
              {{ profile.expertDetails.completedJobs }} missions terminées
            </div>
          </div>
        </div>
      </div>
      
      <!-- Twitter-style tabbed navigation -->
      <div class="mt-4 border-b border-gray-200 dark:border-gray-800">
        <nav class="flex overflow-x-auto scrollbar-hide">
          <button
            v-for="tab in filteredTabs"
            :key="tab.id"
            @click="activeTab = tab.id"
            class="px-5 py-3.5 font-medium text-sm whitespace-nowrap transition-all relative flex items-center gap-2"
            :class="activeTab === tab.id 
              ? 'text-primary-600 dark:text-primary-400' 
              : 'text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-300'"
          >
            <component :is="tab.icon" class="w-4.5 h-4.5" />
            {{ tab.name }}
            <!-- Active indicator -->
            <div 
              v-if="activeTab === tab.id"
              class="absolute bottom-0 left-0 right-0 h-0.5 bg-primary-500 dark:bg-primary-400"
            ></div>
          </button>
        </nav>
      </div>
      
      <!-- Content area with cleaner styling -->
      <div class="bg-white dark:bg-gray-900 rounded-xl shadow-sm mt-6 p-8 border border-gray-100 dark:border-gray-800">
        <!-- Loading state -->
        <div v-if="isLoading" class="py-8 text-center">
          <div class="inline-block animate-spin rounded-full h-6 w-6 border-2 border-gray-100 border-t-primary-500 dark:border-gray-800 dark:border-t-primary-400"></div>
          <p class="mt-3 text-sm text-gray-500 dark:text-gray-400">Chargement...</p>
        </div>
        
        <!-- Error state -->
        <div v-else-if="error" class="py-10 text-center">
          <div class="w-12 h-12 bg-red-50 dark:bg-red-900/20 rounded-full flex items-center justify-center mx-auto mb-3">
            <AlertCircle class="w-6 h-6 text-red-500 dark:text-red-400" />
          </div>
          <p class="text-red-600 dark:text-red-400 font-medium mb-2">{{ error }}</p>
          <button @click="fetchUserProfile" class="mt-3 text-sm text-primary-600 hover:text-primary-800 dark:text-primary-400 dark:hover:text-primary-300 font-medium">
            Réessayer
          </button>
        </div>
        
        <!-- Content -->
        <component 
          v-else-if="profile"
          :is="getComponent()"
          :profile="profile"
          @update="refreshProfile"
        />
      </div>
    </div>
  </template>
  
  <script setup>
  import { ref, onMounted, computed } from 'vue'
  import { 
    User, AlertCircle, Camera, CheckCircle,
    MapPin, Calendar, BarChart2, Settings,
    FileText, CreditCard, Briefcase, Star, Users,
    CheckSquare
  } from 'lucide-vue-next'
  import { useProfile } from '~/composables/useProfile'
  import ProfileEdit from '~/components/profile/ProfileEdit.vue'
  // import ProfileSecurity from '~/components/profile/ProfileSecurity.vue'
  // import ProfileRequests from '~/components/profile/ProfileRequests.vue'
  // import ProfilePayments from '~/components/profile/ProfilePayments.vue'
  import ProfileExpertSettings from '~/components/profile/ProfileExpertSettings.vue'
  // import ProfileStats from '~/components/profile/ProfileStats.vue'
  
  // Utilisation du composable de profil
  const { profile, isLoading, error, fetchUserProfile, uploadAvatar, uploadCover } = useProfile()
  
  // Références pour les inputs de fichier cachés
  const fileInput = ref(null)
  const coverInput = ref(null)
  
  // Onglet actif
  const activeTab = ref('dashboard')
  
  // Onglets disponibles avec les icônes correctement référencées
  const tabs = [
    { id: 'dashboard', name: 'Tableau de bord', icon: BarChart2, showFor: 'all' },
    { id: 'edit', name: 'Profil', icon: User, showFor: 'all' },
    { id: 'security', name: 'Sécurité', icon: Settings, showFor: 'all' },
    { id: 'requests', name: 'Demandes', icon: FileText, showFor: 'all' },
    { id: 'payments', name: 'Paiements', icon: CreditCard, showFor: 'all' },
    { id: 'expert', name: 'Expert', icon: Briefcase, showFor: 'expert' },
    { id: 'reviews', name: 'Avis', icon: Star, showFor: 'expert' },
    { id: 'clients', name: 'Clients', icon: Users, showFor: 'expert' }
  ]
  
  // Filtrer les onglets selon le type d'utilisateur
  const filteredTabs = computed(() => {
    if (!profile.value) return tabs.filter(tab => tab.showFor === 'all')
    
    return tabs.filter(tab => 
      tab.showFor === 'all' || 
      (tab.showFor === 'expert' && profile.value.isExpert)
    )
  })
  
  // Fonction pour déterminer quel composant afficher
  const getComponent = () => {
    switch (activeTab.value) {
      case 'edit': return ProfileEdit
      case 'expert': return ProfileExpertSettings
      // Uncomment as you implement these components
      // case 'security': return ProfileSecurity
      // case 'requests': return ProfileRequests
      // case 'payments': return ProfilePayments
      // case 'dashboard': return ProfileStats
      // Add other cases as needed
      default: return ProfileEdit
    }
  }
  
  // Ouvrir le sélecteur de fichier pour l'avatar
  const openFileInput = () => {
    fileInput.value.click()
  }
  
  // Ouvrir le sélecteur de fichier pour la couverture
  const openCoverInput = () => {
    coverInput.value.click()
  }
  
  // Gérer l'upload d'avatar
  const handleAvatarUpload = async (event) => {
    const file = event.target.files[0]
    if (file) {
      await uploadAvatar(file)
      await refreshProfile()
    }
  }
  
  // Gérer l'upload de l'image de couverture
  const handleCoverUpload = async (event) => {
    const file = event.target.files[0]
    if (file) {
      await uploadCover(file)
      await refreshProfile()
    }
  }
  
  // Format date helper
  const formatDate = (dateString) => {
    const date = new Date(dateString)
    return new Intl.DateTimeFormat('fr-FR', { 
      year: 'numeric',
      month: 'long'
    }).format(date)
  }
  
  // Actualiser les données du profil
  const refreshProfile = async () => {
    await fetchUserProfile()
  }
  
  // Charger le profil au montage du composant
  onMounted(async () => {
    await fetchUserProfile()
  })
  
  definePageMeta({
    middleware: 'auth',
    layout: 'account'

  })
 
  </script>