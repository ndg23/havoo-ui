<template>
  <!-- Content specific to the dashboard page -->
  <!-- Stats cards -->
  <div class="grid grid-cols-1 sm:grid-cols-3 gap-4 mb-6">
    <div class="bg-white border border-gray-100 rounded-xl shadow-sm p-5">
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
    
    <div class="bg-white border border-gray-100 rounded-xl shadow-sm p-5">
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
    
    <div class="bg-white border border-gray-100 rounded-xl shadow-sm p-5">
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
  <div class="bg-white border border-gray-100 rounded-xl shadow-sm overflow-hidden mb-6">
    <div class="px-6 py-4 border-b border-gray-100">
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
  <div v-if="userProfile && userProfile.is_expert" class="bg-white border border-gray-100 rounded-xl shadow-sm overflow-hidden">
    <div class="px-6 py-4 border-b border-gray-100">
      <h3 class="font-medium text-gray-800">Mes compétences</h3>
    </div>
    
    <div class="p-6">
      <!-- Skills tags -->
      <div v-if="userProfile.skills && userProfile.skills.length > 0" class="flex flex-wrap gap-2">
        <span 
          v-for="skill in userProfile.skills" 
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
</template>

<script setup>
import { ref, onMounted, inject } from 'vue'
import { useSupabaseClient } from '#imports'

// Structure correcte pour définir les métadonnées de la page
definePageMeta({
  layout: 'account'
})

// State
const stats = ref({
  requestsCount: 0,
  completedCount: 0,
  averageRating: '0.0'
})
const recentActivity = ref([])
const userProfile = ref(null)

// Supabase client
const supabase = useSupabaseClient()

// Methods
const formatDate = (dateString) => {
  const options = { day: 'numeric', month: 'short', hour: '2-digit', minute: '2-digit' }
  return new Date(dateString).toLocaleDateString('fr-FR', options)
}

// Fetch user statistics
const fetchUserStats = async () => {
  try {
    const { data: { session } } = await supabase.auth.getSession()
    if (!session) return
    
    const userId = session.user.id
    
    // Récupérer le profil utilisateur
    const { data: profileData, error: profileError } = await supabase
      .from('profiles')
      .select('*, user_skills(skill_id, skills(name))')
      .eq('id', userId)
      .single()
      
    if (profileError) throw profileError
    
    // Format skills array
    let skills = []
    if (profileData.user_skills && profileData.user_skills.length > 0) {
      skills = profileData.user_skills.map(us => us.skills.name)
    }
    
    userProfile.value = {
      ...profileData,
      email: session.user.email,
      skills
    }
    
    // Fetch request count
    const { data: requestsData, error: requestsError } = await supabase
      .from('requests')
      .select('id, status')
      .eq('user_id', userId)
    
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
    
  } catch (error) {
    console.error('Error fetching stats:', error)
  }
}

// Fetch recent activity
const fetchRecentActivity = async () => {
  try {
    const { data: { session } } = await supabase.auth.getSession()
    if (!session) return
    
    const userId = session.user.id
    
    // Example activity data - in real app, this would come from different tables
    // (requests, messages, proposals, reviews)
    
    // Sample - fetch recent requests
    const { data: requestsData, error: requestsError } = await supabase
      .from('requests')
      .select('id, title, description, created_at')
      .eq('user_id', userId)
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

// Lifecycle hooks
onMounted(() => {
  fetchUserStats()
  fetchRecentActivity()
})
</script>
