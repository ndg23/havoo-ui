<!-- pages/index.vue -->
<template>
  <div class="min-h-screen bg-white dark:bg-gray-900">
    <!-- Twitter-inspired sticky header with lighter design and backdrop filter -->
    <header class="sticky top-0 z-10 bg-white/90 dark:bg-gray-900/90 backdrop-blur-sm border-b border-gray-100 dark:border-gray-800 px-4 py-3">
      <div class="max-w-2xl mx-auto flex items-center justify-between">
        <h1 class="text-xl font-bold text-gray-900 dark:text-white">Tableau de bord</h1>
        <!-- Added refresh button with improved hover effect -->
        <button 
          @click="fetchUserProfile" 
          class="p-2 rounded-full hover:bg-gray-50 dark:hover:bg-gray-800 transition-colors"
          aria-label="Actualiser le tableau de bord"
        >
          <RefreshCw class="w-5 h-5 text-gray-700 dark:text-gray-300" />
        </button>
      </div>
    </header>

    <!-- Main content with more white space -->
    <main class="max-w-2xl mx-auto px- py-6 space-y-6">
      <!-- Enhanced loading state with Twitter spinner -->
      <div v-if="isLoading" class="flex flex-col items-center justify-center py-24">
        <div class="animate-spin h-10 w-10 mb-5 text-primary-500">
          <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
          </svg>
        </div>
        <p class="text-gray-500 dark:text-gray-400 font-medium">Chargement de votre tableau de bord...</p>
      </div>

      <!-- Twitter-style error state -->
      <div v-else-if="error" class="bg-red-50 dark:bg-red-900/10 p-5 rounded-2xl border border-red-100 dark:border-red-800/40 text-red-700 dark:text-red-300">
        <div class="flex">
          <AlertCircle class="h-5 w-5 text-red-500 dark:text-red-400 mr-3 flex-shrink-0" />
          <div>
            <p class="font-medium">{{ error }}</p>
            <button 
              @click="fetchUserProfile" 
              class="mt-4 text-sm font-semibold text-red-600 hover:text-red-700 dark:text-red-400 dark:hover:text-red-300 bg-red-50 hover:bg-red-100 dark:bg-red-900/20 dark:hover:bg-red-900/30 px-5 py-2 rounded-full transition-colors"
            >
              Réessayer
            </button>
          </div>
        </div>
      </div>

      <div v-else class="space-y-6 animate-fade-in">
        <!-- Profile card with enhanced Twitter 2023 aesthetic -->
        <div class="bg-white dark:bg-gray-800 rounded-2xl border border-gray-100 dark:border-gray-700 shadow-xs overflow-hidden transition-all hover:shadow-sm">
          <!-- User profile header -->
          <div class="p-6 relative">
            <div class="flex items-start">
              <!-- Profile picture with Twitter-style border -->
              <div v-if="profile.avatar_url" class="w-20 h-20 rounded-full overflow-hidden border border-gray-100 dark:border-gray-700 flex-shrink-0">
                <img :src="profile.avatar_url" alt="Photo de profil" class="w-full h-full object-cover" />
              </div>
              <div v-else class="w-20 h-20 rounded-full bg-primary-50 dark:bg-primary-900/30 flex items-center justify-center text-xl font-bold text-primary-500 dark:text-primary-400 border border-gray-100 dark:border-gray-700 flex-shrink-0">
                {{ getInitials(profile.first_name, profile.last_name) }}
              </div>
              
              <div class="ml-5 flex-1">
                <!-- User name and status with Twitter typography -->
                <h2 class="text-xl font-bold text-gray-900 dark:text-white">{{ profile.first_name }} {{ profile.last_name }}</h2>
                <p class="text-gray-500 dark:text-gray-400">{{ profile.email }}</p>
                
                <!-- Expert badge with Twitter pill style -->
                <div v-if="profile.is_expert" class="mt-2 inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-primary-50 dark:bg-primary-900/20 text-primary-700 dark:text-primary-400">
                  <CheckCircle class="w-3.5 h-3.5 mr-1" />
                  Expert
                </div>
              </div>
              
              <!-- Edit profile button with Twitter-style hover -->
              <NuxtLink 
                to="/account/edit-profile" 
                class="flex-shrink-0 inline-flex justify-center items-center p-2.5 border border-gray-100 dark:border-gray-700 rounded-full text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 transition-colors"
                aria-label="Modifier votre profil"
              >
                <Edit2 class="w-4 h-4" />
              </NuxtLink>
            </div>
            
            <!-- Profile completion with Twitter-style progress bar -->
            <div class="mt-6">
              <div class="flex items-center justify-between mb-2">
                <span class="text-sm font-medium text-gray-700 dark:text-gray-300">Profil complété</span>
                <span class="text-sm font-bold text-primary-600 dark:text-primary-400">{{ profileCompletionPercent }}%</span>
              </div>
              <div class="w-full bg-gray-50 dark:bg-gray-700 rounded-full h-2 overflow-hidden">
                <div 
                  class="bg-primary-500 dark:bg-primary-400 h-2 rounded-full transition-all duration-500 ease-out" 
                  :style="{ width: `${profileCompletionPercent}%` }"
                ></div>
              </div>
              
              <!-- Missing profile items with Twitter-style pill list -->
              <div v-if="profileCompletionPercent < 100" class="mt-4 bg-primary-50 dark:bg-primary-900/10 rounded-2xl p-4">
                <p class="text-sm font-medium text-primary-800 dark:text-primary-300 mb-2">Pour compléter votre profil :</p>
                <ul class="space-y-2">
                  <li v-if="!profile.phone" class="text-sm text-primary-700 dark:text-primary-400 flex items-center">
                    <Plus class="w-3.5 h-3.5 mr-2 text-primary-500 dark:text-primary-400" />
                    Ajouter un numéro de téléphone
                  </li>
                  <li v-if="!profile.avatar_url" class="text-sm text-primary-700 dark:text-primary-400 flex items-center">
                    <Plus class="w-3.5 h-3.5 mr-2 text-primary-500 dark:text-primary-400" />
                    Ajouter une photo de profil
                  </li>
                  <li v-if="!profile.bio" class="text-sm text-primary-700 dark:text-primary-400 flex items-center">
                    <Plus class="w-3.5 h-3.5 mr-2 text-primary-500 dark:text-primary-400" />
                    Ajouter une bio
                  </li>
                </ul>
              </div>
            </div>
          </div>
        </div>

        <!-- Twitter-style verification alert with light banner design -->
        <div v-if="profile.is_expert && !isVerified" class="bg-amber-50 dark:bg-amber-900/10 p-5 rounded-2xl border border-amber-100 dark:border-amber-800/40">
          <div class="flex">
            <div class="flex-shrink-0">
              <AlertTriangle class="h-6 w-6 text-amber-500 dark:text-amber-400" />
            </div>
            <div class="ml-4">
              <h3 class="text-base font-semibold text-amber-800 dark:text-amber-300">Vérification requise</h3>
              <div class="mt-2 text-sm text-amber-700 dark:text-amber-400">
                <p>Votre compte expert n'est pas encore vérifié. La vérification est nécessaire pour recevoir des demandes et proposer vos services.</p>
              </div>
              <div class="mt-4">
                <NuxtLink to="/account/verification" class="inline-flex items-center px-5 py-2 text-sm font-medium rounded-full shadow-sm text-amber-800 dark:text-amber-300 bg-amber-100 dark:bg-amber-900/20 hover:bg-amber-200 dark:hover:bg-amber-900/30 transition-colors">
                  Compléter la vérification
                </NuxtLink>
              </div>
            </div>
          </div>
        </div>

        <!-- Stat cards with Twitter-inspired design -->
        <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
          <!-- Requests stats card -->
          <div class="bg-white dark:bg-gray-800 border border-gray-100 dark:border-gray-700 rounded-2xl p-5 hover:bg-gray-50 dark:hover:bg-gray-700/50 transition-all group cursor-pointer">
            <div class="flex items-center">
              <div class="w-12 h-12 rounded-xl flex items-center justify-center bg-blue-50 dark:bg-blue-900/20 text-blue-600 dark:text-blue-400">
                <File class="w-6 h-6" />
              </div>
              <div class="ml-4">
                <div class="text-2xl font-bold text-gray-900 dark:text-white">{{ stats.requestsCount }}</div>
                <div class="text-sm text-gray-500 dark:text-gray-400 font-medium">Demandes</div>
              </div>
            </div>
          </div>
          
          <!-- Completed stats card -->
          <div class="bg-white dark:bg-gray-800 border border-gray-100 dark:border-gray-700 rounded-2xl p-5 hover:bg-gray-50 dark:hover:bg-gray-700/50 transition-all group cursor-pointer">
            <div class="flex items-center">
              <div class="w-12 h-12 rounded-xl flex items-center justify-center bg-green-50 dark:bg-green-900/20 text-green-600 dark:text-green-400">
                <CheckCircle class="w-6 h-6" />
              </div>
              <div class="ml-4">
                <div class="text-2xl font-bold text-gray-900 dark:text-white">{{ stats.completedCount }}</div>
                <div class="text-sm text-gray-500 dark:text-gray-400 font-medium">Terminées</div>
              </div>
            </div>
          </div>
          
          <!-- Rating stats card -->
          <div class="bg-white dark:bg-gray-800 border border-gray-100 dark:border-gray-700 rounded-2xl p-5 hover:bg-gray-50 dark:hover:bg-gray-700/50 transition-all group cursor-pointer">
            <div class="flex items-center">
              <div class="w-12 h-12 rounded-xl flex items-center justify-center bg-amber-50 dark:bg-amber-900/20 text-amber-600 dark:text-amber-400">
                <Star class="w-6 h-6" />
              </div>
              <div class="ml-4">
                <div class="text-2xl font-bold text-gray-900 dark:text-white">{{ stats.averageRating }}</div>
                <div class="text-sm text-gray-500 dark:text-gray-400 font-medium">Note moyenne</div>
              </div>
            </div>
          </div>
        </div>
        
        <!-- Recent activity feed with Twitter-style timeline -->
        <div class="bg-white dark:bg-gray-800 border border-gray-100 dark:border-gray-700 rounded-2xl overflow-hidden shadow-xs hover:shadow-sm transition-all">
          <div class="px-6 py-4 border-b border-gray-100 dark:border-gray-700 flex justify-between items-center">
            <h3 class="font-semibold text-gray-900 dark:text-white">Activité récente</h3>
            <NuxtLink 
              to="/account/activities" 
              class="text-sm text-primary-600 hover:text-primary-700 dark:text-primary-400 dark:hover:text-primary-300 font-medium inline-flex items-center"
            >
              Voir tout
              <ChevronRight class="h-4 w-4 ml-1" />
            </NuxtLink>
          </div>
          
          <div class="p-6">
            <!-- Twitter-style activity list -->
            <div v-if="recentActivity.length > 0" class="space-y-6">              
              <div 
                v-for="activity in recentActivity" 
                :key="activity.id"
                class="flex group"
              >
                <!-- Activity icon -->
                <div class="flex-shrink-0">
                  <span class="w-12 h-12 rounded-full bg-gray-50 dark:bg-gray-700 flex items-center justify-center text-primary-600 dark:text-primary-400 group-hover:bg-gray-100 dark:group-hover:bg-gray-600 transition-colors">
                    <File v-if="activity.type === 'request'" class="w-6 h-6" />
                    <MessageSquare v-else-if="activity.type === 'message'" class="w-6 h-6" />
                    <CheckSquare v-else-if="activity.type === 'completed'" class="w-6 h-6" />
                    <Activity v-else class="w-6 h-6" />
                  </span>
                </div>
                
                <!-- Activity content with Twitter-style card -->
                <div class="ml-4 flex-1">
                  <div class="flex items-center justify-between">
                    <h4 class="text-base font-medium text-gray-900 dark:text-white">{{ activity.title }}</h4>
                    <span class="text-xs text-gray-500 dark:text-gray-400 font-medium">{{ formatDate(activity.date) }}</span>
                  </div>
                  <p class="mt-1 text-sm text-gray-600 dark:text-gray-300 line-clamp-2">{{ activity.description }}</p>
                  <div class="mt-3">
                    <NuxtLink :to="activity.link" class="text-sm font-semibold text-primary-600 hover:text-primary-700 dark:text-primary-400 dark:hover:text-primary-300 inline-flex items-center">
                      Voir les détails
                      <ArrowRight class="h-3.5 w-3.5 ml-1" />
                    </NuxtLink>
                  </div>
                </div>
              </div>
            </div>
            
            <!-- Twitter-style empty state -->
            <div v-else class="text-center py-10">
              <div class="mx-auto h-16 w-16 text-gray-300 dark:text-gray-600 bg-gray-50 dark:bg-gray-700 rounded-full flex items-center justify-center">
                <Clock class="h-8 w-8" />
              </div>
              <h3 class="mt-4 text-base font-medium text-gray-900 dark:text-white">Aucune activité récente</h3>
              <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">Votre activité récente apparaîtra ici</p>
              <NuxtLink 
                to="/services"
                class="mt-5 inline-flex items-center px-5 py-2.5 text-sm font-medium rounded-full text-white bg-primary-600 hover:bg-primary-700 dark:bg-primary-500 dark:hover:bg-primary-600 transition-colors"
              >
                Explorer les services
              </NuxtLink>
            </div>
          </div>
        </div>
        
        <!-- Expert skills section with Twitter-style tags -->
        <div v-if="profile.is_expert" class="bg-white dark:bg-gray-800 border border-gray-100 dark:border-gray-700 rounded-2xl overflow-hidden shadow-xs hover:shadow-sm transition-all">
          <div class="px-6 py-4 border-b border-gray-100 dark:border-gray-700 flex justify-between items-center">
            <h3 class="font-semibold text-gray-900 dark:text-white">Mes compétences</h3>
            <NuxtLink 
              to="/account/edit-profile" 
              class="text-sm text-primary-600 hover:text-primary-700 dark:text-primary-400 dark:hover:text-primary-300 font-medium inline-flex items-center"
            >
              Modifier
              <Edit3 class="h-3.5 w-3.5 ml-1" />
            </NuxtLink>
          </div>
          
          <div class="p-6">
            <!-- Skills tags with Twitter-style pills -->
            <div v-if="profile.skills && profile.skills.length > 0" class="flex flex-wrap gap-2">
              <span 
                v-for="skill in profile.skills" 
                :key="skill"
                class="inline-flex items-center px-4 py-2 rounded-full text-sm font-medium bg-gray-50 dark:bg-gray-700 text-gray-800 dark:text-gray-200 hover:bg-gray-100 dark:hover:bg-gray-600 transition-colors"
              >
                {{ skill }}
              </span>
            </div>
            
            <!-- Twitter-style empty state for skills -->
            <div v-else class="text-center py-8">
              <div class="mx-auto h-16 w-16 text-gray-300 dark:text-gray-600 bg-gray-50 dark:bg-gray-700 rounded-full flex items-center justify-center">
                <Briefcase class="h-8 w-8" />
              </div>
              <h3 class="mt-4 text-base font-medium text-gray-900 dark:text-white">Aucune compétence ajoutée</h3>
              <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">Ajoutez vos compétences pour vous démarquer</p>
              <NuxtLink 
                to="/account/edit-profile" 
                class="mt-5 inline-flex items-center px-5 py-2.5 border border-gray-200 dark:border-gray-600 text-sm font-medium rounded-full text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors"
              >
                Ajouter des compétences
              </NuxtLink>
            </div>
          </div>
        </div>
      </div>
    </main>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useSupabaseClient, useRouter } from '#imports'
import { 
  AlertTriangle, 
  AlertCircle, 
  File, 
  CheckCircle, 
  Star, 
  Activity, 
  MessageSquare, 
  Clock, 
  Briefcase,
  CheckSquare,
  Edit2,
  Edit3,
  Plus,
  ArrowRight,
  ChevronRight,
  RefreshCw
} from 'lucide-vue-next'

// Mise à jour de la définition de page pour utiliser le layout par défaut
definePageMeta({
  middleware: ['auth'],
  layout: 'account'
})

// State
const isLoading = ref(true)
const error = ref(null)
const profile = ref({
  first_name: '',
  last_name: '',
  email: '',
  avatar_url: null,
  phone: null,
  bio: null,
  is_expert: false,
  skills: []
})
const stats = ref({
  requestsCount: 0,
  completedCount: 0,
  averageRating: '0.0'
})
const recentActivity = ref([])
const isVerified = ref(false)

// Supabase client
const supabase = useSupabaseClient()
const router = useRouter()

// Computed properties
const profileCompletionPercent = computed(() => {
  let completed = 0
  let total = 3 // Base fields: name, email are assumed to be completed
  
  if (profile.value.avatar_url) completed++
  if (profile.value.phone) completed++
  if (profile.value.bio) completed++
  
  return Math.round((completed / total) * 100)
})

// Methods
const getInitials = (firstName, lastName) => {
  if (!firstName || !lastName) return '??'
  return `${firstName.charAt(0)}${lastName.charAt(0)}`.toUpperCase()
}

const formatDate = (dateString) => {
  const options = { day: 'numeric', month: 'short', hour: '2-digit', minute: '2-digit' }
  return new Date(dateString).toLocaleDateString('fr-FR', options)
}

// Fetch user profile data
const fetchUserProfile = async () => {
  try {
    isLoading.value = true
    error.value = null
    
    const { data: { session } } = await supabase.auth.getSession()
    if (!session) {
      // Redirect to login if not authenticated
      return router.push('/login')
    }
    
    const { data, error: profileError } = await supabase
      .from('profiles')
      .select('*, user_skills(skill_id, skills(name))')
      .eq('id', session.user.id)
      .single()
      
    if (profileError) throw profileError
    
    // Format skills array
    let skills = []
    if (data.user_skills && data.user_skills.length > 0) {
      skills = data.user_skills.map(us => us.skills.name)
    }
    
    profile.value = {
      ...data,
      email: session.user.email,
      skills
    }

    // Fetch stats and activity after profile is loaded
    await Promise.all([
      fetchUserStats(),
      fetchRecentActivity()
    ])
    
    // Check verification status
    await checkVerificationStatus()
    
  } catch (error) {
    console.error('Error fetching profile:', error)
    error.value = "Une erreur est survenue lors du chargement de votre profil"
  } finally {
    isLoading.value = false
  }
}

// Fetch user statistics
const fetchUserStats = async () => {
  try {
    const userId = profile.value.id
    
    // Fetch request count
    const { data: requestsData, error: requestsError } = await supabase
      .from('requests')
      .select('id, status')
      .eq('client_id', userId)
    
    if (requestsError) throw requestsError
    
    stats.value.requestsCount = requestsData.length
    stats.value.completedCount = requestsData.filter(r => r.status === 'completed').length
    
    // Fetch average rating
    const { data: ratingsData, error: ratingsError } = await supabase
      .from('reviews')
      .select('rating')
      .eq('receiver_id', userId)
    
    if (ratingsError) throw ratingsError
    
    if (ratingsData.length > 0) {
      const sum = ratingsData.reduce((acc, curr) => acc + curr.rating, 0)
      stats.value.averageRating = (sum / ratingsData.length).toFixed(1)
    }
    
  } catch (err) {
    console.error('Error fetching stats:', err)
  }
}

// Fetch recent activity
const fetchRecentActivity = async () => {
  try {
    const userId = profile.value.id
    
    // Sample - fetch recent requests
    const { data: requestsData, error: requestsError } = await supabase
      .from('requests')
      .select('id, title, description, created_at')
      .eq('client_id', userId)
      .order('created_at', { ascending: false })
      .limit(5)
    
    if (requestsError) throw requestsError
    
    const requestsActivity = requestsData.map(request => ({
      id: `request-${request.id}`,
      type: 'request',
      title: request.title,
      description: request.description,
      date: request.created_at,
      link: `/requests/${request.id}`
    }))
    
    // Add more activity types as needed
    
    // Combine and sort by date
    recentActivity.value = [...requestsActivity]
      .sort((a, b) => new Date(b.date) - new Date(a.date))
      .slice(0, 5)
    
  } catch (error) {
    console.error('Error fetching activity:', error)
  }
}

// Check verification status
const checkVerificationStatus = async () => {
  if (!profile.value?.is_expert) return
  
  try {
    const { data, error } = await supabase
      .from('verifications')
      .select('status')
      .eq('user_id', profile.value.id)
      .order('created_at', { ascending: false })
      .limit(1)
      .single()
    
    if (error && error.code !== 'PGRST116') throw error
    
    isVerified.value = data?.status === 'approved'
  } catch (err) {
    console.error('Erreur lors de la vérification du statut:', err)
  }
}

// Lifecycle hooks
onMounted(() => {
  fetchUserProfile()
})

// Define animation class
const animateFadeIn = {
  'animate-fade-in': true
}
</script>

<style scoped>
.line-clamp-2 {
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

/* Twitter-style subtle shadows */
.shadow-xs {
  box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
}

.shadow-sm {
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1), 0 1px 2px rgba(0, 0, 0, 0.06);
}

/* Enhanced Twitter-style animations */
.transition-colors {
  transition-property: background-color, border-color, color, fill, stroke;
  transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
  transition-duration: 300ms;
}

.transition-all {
  transition-property: all;
  transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
  transition-duration: 300ms;
}

/* Fade-in animation for content */
@keyframes fadeIn {
  from { opacity: 0; transform: translateY(10px); }
  to { opacity: 1; transform: translateY(0); }
}

.animate-fade-in {
  animation: fadeIn 0.5s ease-out forwards;
}

/* Blur effect for sticky header */
.backdrop-blur-sm {
  backdrop-filter: blur(8px);
  -webkit-backdrop-filter: blur(8px);
}
</style>