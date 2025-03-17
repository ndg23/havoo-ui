<template>
  <div class="bg-white min-h-screen">
    <!-- Navbar component -->
    <NavbarMain />
    
    <!-- Account layout container -->
    <div class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 pt-20 pb-8">
      <!-- Header section -->
      <div class="mb-8">
        <h1 class="text-2xl font-medium text-gray-800">{{ pageTitle }}</h1>
        <p class="mt-2 text-gray-500 max-w-2xl">
          {{ pageDescription }}
        </p>
      </div>

      <!-- Loading state -->
      <div v-if="isLoading" class="flex justify-center py-12">
        <svg class="animate-spin h-8 w-8 text-primary-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
          <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
          <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
        </svg>
      </div>

      <div v-else class="grid grid-cols-1 lg:grid-cols-4 gap-6">
        <!-- Left column - Profile and navigation -->
        <div class="lg:col-span-1">
          <!-- Profile card -->
          <div class="bg-white border border-gray-100 rounded-xl shadow-sm overflow-hidden mb-6">
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
          
          <!-- Account navigation -->
          <div class="bg-white border border-gray-100 rounded-xl shadow-sm overflow-hidden">
            <div class="px-5 py-4 border-b border-gray-100">
              <h3 class="text-sm font-medium text-gray-700">Navigation</h3>
            </div>
            <div class="divide-y divide-gray-100">
              <NuxtLink 
                v-for="(link, index) in accountLinks" 
                :key="index"
                :to="link.path"
                class="flex items-center px-5 py-3.5 hover:bg-gray-50 transition-colors"
                :class="{ 'bg-primary-50': isActiveRoute(link.path) }"
              >
                <span class="w-8 h-8 rounded-lg flex items-center justify-center"
                      :class="isActiveRoute(link.path) ? 'bg-primary-100 text-primary-700' : 'bg-gray-100 text-gray-500'"
                >
                  <svg class="w-4.5 h-4.5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path :d="link.icon" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" />
                  </svg>
                </span>
                <span class="ml-3 text-sm font-medium" 
                      :class="isActiveRoute(link.path) ? 'text-primary-700' : 'text-gray-700'"
                >
                  {{ link.name }}
                </span>
                <svg v-if="isActiveRoute(link.path)" class="ml-auto w-5 h-5 text-primary-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
                </svg>
              </NuxtLink>
            </div>
          </div>
        </div>
        
        <!-- Right column - Page content -->
        <div class="lg:col-span-3">
          <slot />
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onBeforeUnmount } from 'vue'
import { useSupabaseClient, useRoute, useRouter } from '#imports'

// Props for page metadata
const props = defineProps({
  title: {
    type: String,
    default: 'Mon compte'
  },
  description: {
    type: String,
    default: 'Gérez votre profil, suivez vos demandes et consultez vos statistiques'
  }
})

// State variables
const isLoading = ref(true)
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

// Supabase client
const supabase = useSupabaseClient()
const route = useRoute()
const router = useRouter()

// Computed properties
const pageTitle = computed(() => props.title)
const pageDescription = computed(() => props.description)

const profileCompletionPercent = computed(() => {
  let completed = 0
  let total = 3 // Base fields: name, email are assumed to be completed
  
  if (profile.value.avatar_url) completed++
  if (profile.value.phone) completed++
  if (profile.value.bio) completed++
  
  return Math.round((completed / total) * 100)
})

// Account navigation links
const accountLinks = [
  {
    name: 'Tableau de bord',
    path: '/account',
    icon: 'M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6'
  },
  {
    name: 'Mes demandes',
    path: '/account/requests',
    icon: 'M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z'
  },
  {
    name: 'Mes services',
    path: '/account/services',
    icon: 'M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z'
  },
  {
    name: 'Messages',
    path: '/account/messages',
    icon: 'M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z'
  },
  {
    name: 'Paramètres',
    path: '/account/settings',
    icon: 'M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z'
  }
]

// Check if current route is active
const isActiveRoute = (path) => {
  if (path === '/account') {
    return route.path === '/account'
  }
  return route.path.startsWith(path)
}

// Methods
const getInitials = (firstName, lastName) => {
  return (firstName?.[0] || '') + (lastName?.[0] || '')
}

// Fetch user profile data
const fetchUserProfile = async () => {
  try {
    isLoading.value = true
    
    const { data: { session } } = await supabase.auth.getSession()
    if (!session) {
      // Redirect to login if not authenticated
      return router.push('/login')
    }
    
    const { data, error } = await supabase
      .from('profiles')
      .select('*, user_skills(skill_id, skills(name))')
      .eq('id', session.user.id)
      .single()
      
    if (error) throw error
    
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
  } catch (error) {
    console.error('Error fetching profile:', error)
  } finally {
    isLoading.value = false
  }
}

// Lifecycle hooks
onMounted(() => {
  fetchUserProfile()
})
</script>