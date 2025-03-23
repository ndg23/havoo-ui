<template>
  <div class="min-h-screen bg-white">
    <!-- Header -->
    <header class="sticky top-0 z-10 bg-white/80 backdrop-blur-sm border-b border-gray-100">
      <div class="max-w-2xl mx-auto px-4 py-3 flex items-center justify-between">
        <h1 class="text-xl font-bold">Tableau de bord</h1>
      </div>
    </header>

    <!-- Main content -->
    <main class="max-w-2xl mx-auto px-4 py-6">
      <!-- Loading state -->
      <div v-if="isLoading" class="flex flex-col items-center justify-center py-12">
        <svg class="animate-spin h-8 w-8 text-gray-400 mb-4" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
          <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
          <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
        </svg>
        <p class="text-gray-500">Chargement de votre tableau de bord...</p>
      </div>

      <!-- Error state -->
      <div v-else-if="error" class="bg-red-50 p-4 rounded-lg text-red-700 my-6">
        <div class="flex">
          <svg class="h-5 w-5 text-red-400 mr-3" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
          </svg>
          <p>{{ error }}</p>
        </div>
        <button 
          @click="fetchUserProfile" 
          class="mt-3 text-sm font-medium text-red-600 hover:text-red-500"
        >
          Réessayer
        </button>
      </div>

      <!-- Profile card -->
      <div v-else class="bg-white border border-gray-200 rounded-lg shadow-sm overflow-hidden mb-6">
        <div class="bg-primary-50 p-6 flex flex-col items-center">
          <!-- Profile picture or default avatar -->
          <div v-if="profile.avatar_url" class="w-24 h-24 rounded-full overflow-hidden border-4 border-white shadow-sm mb-3">
            <img :src="profile.avatar_url" alt="Photo de profil" class="w-full h-full object-cover" />
          </div>
          <div v-else class="w-24 h-24 rounded-full bg-white flex items-center justify-center text-2xl font-medium text-primary-600 border-4 border-white shadow-sm mb-3">
            {{ getInitials(profile.first_name, profile.last_name) }}
          </div>
          
          <!-- User name and status -->
          <h2 class="text-lg font-medium text-gray-800">{{ profile.first_name }} {{ profile.last_name }}</h2>
          <p class="text-gray-500 text-sm">{{ profile.email }}</p>
          
          <!-- Expert badge if applicable -->
          <div v-if="profile.is_expert" class="mt-2 inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-primary-100 text-primary-800">
            Expert
          </div>
        </div>
        
        <!-- Profile completion -->
        <div class="p-6">
          <div class="flex items-center justify-between mb-2">
            <span class="text-sm font-medium text-gray-700">Profil complété</span>
            <span class="text-sm font-medium text-primary-600">{{ profileCompletionPercent }}%</span>
          </div>
          <div class="w-full bg-gray-100 rounded-full h-2">
            <div 
              class="bg-primary-500 h-2 rounded-full" 
              :style="{ width: `${profileCompletionPercent}%` }"
            ></div>
          </div>
          
          <!-- Missing profile items -->
          <div v-if="profileCompletionPercent < 100" class="mt-3">
            <p class="text-xs text-gray-500 mb-2">Pour compléter votre profil :</p>
            <ul class="space-y-1">
              <li v-if="!profile.phone" class="text-xs text-gray-600 flex items-center">
                <svg class="w-3.5 h-3.5 mr-1.5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v3m0 0v3m0-3h3m-3 0H9m12 0a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
                Ajouter un numéro de téléphone
              </li>
              <li v-if="!profile.avatar_url" class="text-xs text-gray-600 flex items-center">
                <svg class="w-3.5 h-3.5 mr-1.5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v3m0 0v3m0-3h3m-3 0H9m12 0a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
                Ajouter une photo de profil
              </li>
              <li v-if="!profile.bio" class="text-xs text-gray-600 flex items-center">
                <svg class="w-3.5 h-3.5 mr-1.5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v3m0 0v3m0-3h3m-3 0H9m12 0a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
                Ajouter une bio
              </li>
            </ul>
          </div>
          
          <!-- Edit profile button -->
          <div class="mt-4">
            <NuxtLink 
              to="/account/edit-profile" 
              class="w-full inline-flex justify-center items-center px-4 py-2.5 border border-gray-300 rounded-lg text-sm font-medium text-gray-700 hover:bg-gray-50 transition-colors"
            >
              <svg class="w-4 h-4 mr-2 text-gray-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
              </svg>
              Modifier mon profil
            </NuxtLink>
          </div>
        </div>
      </div>

      <!-- Alerte de vérification (si l'utilisateur est expert mais non vérifié) -->
      <div v-if="profile.is_expert && !isVerified" class="bg-amber-50 border-l-4 border-amber-400 p-4 mb-6 rounded-md">
        <div class="flex">
          <div class="flex-shrink-0">
            <AlertTriangle class="h-5 w-5 text-amber-400" />
          </div>
          <div class="ml-3">
            <h3 class="text-sm font-medium text-amber-800">Vérification requise</h3>
            <div class="mt-2 text-sm text-amber-700">
              <p>Votre compte expert n'est pas encore vérifié. La vérification est nécessaire pour recevoir des demandes et proposer vos services.</p>
            </div>
            <div class="mt-4">
              <NuxtLink to="/account/verification" class="inline-flex items-center px-3 py-2 border border-transparent text-sm leading-4 font-medium rounded-md text-amber-700 bg-amber-100 hover:bg-amber-200 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-amber-500">
                Compléter la vérification
              </NuxtLink>
            </div>
          </div>
        </div>
      </div>

  <!-- Stats cards -->
  <div class="grid grid-cols-1 sm:grid-cols-3 gap-4 mb-6">
        <div class="bg-white border border-gray-200 rounded-lg shadow-sm p-5">
      <div class="flex items-center">
        <div class="w-10 h-10 rounded-lg flex items-center justify-center bg-blue-50 text-blue-600">
          <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
          </svg>
        </div>
        <div class="ml-3">
          <div class="text-2xl font-semibold text-gray-800">{{ stats.requestsCount }}</div>
          <div class="text-xs text-gray-500">Demandes</div>
        </div>
      </div>
    </div>
    
        <div class="bg-white border border-gray-200 rounded-lg shadow-sm p-5">
      <div class="flex items-center">
        <div class="w-10 h-10 rounded-lg flex items-center justify-center bg-green-50 text-green-600">
          <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
          </svg>
        </div>
        <div class="ml-3">
          <div class="text-2xl font-semibold text-gray-800">{{ stats.completedCount }}</div>
          <div class="text-xs text-gray-500">Terminées</div>
        </div>
      </div>
    </div>
    
        <div class="bg-white border border-gray-200 rounded-lg shadow-sm p-5">
      <div class="flex items-center">
        <div class="w-10 h-10 rounded-lg flex items-center justify-center bg-yellow-50 text-yellow-600">
          <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11.049 2.927c.3-.921 1.603-.921 1.902 0l1.519 4.674a1 1 0 00.95.69h4.915c.969 0 1.371 1.24.588 1.81l-3.976 2.888a1 1 0 00-.363 1.118l1.518 4.674c.3.922-.755 1.688-1.538 1.118l-3.976-2.888a1 1 0 00-1.176 0l-3.976 2.888c-.783.57-1.838-.197-1.538-1.118l1.518-4.674a1 1 0 00-.363-1.118l-3.976-2.888c-.784-.57-.38-1.81.588-1.81h4.914a1 1 0 00.951-.69l1.519-4.674z" />
          </svg>
        </div>
        <div class="ml-3">
          <div class="text-2xl font-semibold text-gray-800">{{ stats.averageRating }}</div>
          <div class="text-xs text-gray-500">Note moyenne</div>
        </div>
      </div>
    </div>
  </div>
  
  <!-- Recent activity -->
      <div class="bg-white border border-gray-200 rounded-lg shadow-sm overflow-hidden mb-6">
        <div class="px-6 py-4 border-b border-gray-200">
      <h3 class="font-medium text-gray-800">Activité récente</h3>
    </div>
    
    <div class="p-6">
      <!-- Activity list -->
      <div v-if="recentActivity.length > 0" class="space-y-6">
        <div 
          v-for="activity in recentActivity" 
          :key="activity.id"
          class="flex"
        >
          <!-- Activity icon -->
          <div class="flex-shrink-0">
            <span class="w-10 h-10 rounded-full bg-primary-50 flex items-center justify-center text-primary-600">
              <svg v-if="activity.type === 'request'" class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
              </svg>
            </span>
          </div>
          
          <!-- Activity content -->
          <div class="ml-4 flex-1">
            <div class="flex items-center justify-between">
              <h4 class="text-sm font-medium text-gray-800">{{ activity.title }}</h4>
              <span class="text-xs text-gray-500">{{ formatDate(activity.date) }}</span>
            </div>
            <p class="mt-1 text-sm text-gray-600 line-clamp-1">{{ activity.description }}</p>
            <div class="mt-2">
              <NuxtLink :to="activity.link" class="text-sm font-medium text-primary-600 hover:text-primary-500">
                Voir les détails
              </NuxtLink>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Empty state -->
      <div v-else class="text-center py-6">
        <svg class="mx-auto h-12 w-12 text-gray-300" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
        </svg>
        <h3 class="mt-2 text-sm font-medium text-gray-700">Aucune activité récente</h3>
        <p class="mt-1 text-sm text-gray-500">Votre activité récente apparaîtra ici</p>
      </div>
    </div>
  </div>
  
  <!-- Expert-specific section (if applicable) -->
      <div v-if="profile.is_expert" class="bg-white border border-gray-200 rounded-lg shadow-sm overflow-hidden">
        <div class="px-6 py-4 border-b border-gray-200">
      <h3 class="font-medium text-gray-800">Mes compétences</h3>
    </div>
    
    <div class="p-6">
      <!-- Skills tags -->
          <div v-if="profile.skills && profile.skills.length > 0" class="flex flex-wrap gap-2">
        <span 
              v-for="skill in profile.skills" 
          :key="skill"
          class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-primary-50 text-primary-700"
        >
          {{ skill }}
        </span>
      </div>
      
      <!-- Empty state for skills -->
      <div v-else class="text-center py-4">
        <p class="text-sm text-gray-500">Vous n'avez pas encore ajouté de compétences</p>
        <NuxtLink to="/account/edit-profile" class="mt-2 inline-block text-sm font-medium text-primary-600 hover:text-primary-500">
          Ajouter des compétences
        </NuxtLink>
      </div>
    </div>
      </div>
    </main>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useSupabaseClient, useRouter } from '#imports'
import { AlertTriangle } from 'lucide-vue-next'

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
</script>

<style scoped>
.line-clamp-1 {
  display: -webkit-box;
  -webkit-line-clamp: 1;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
</style>