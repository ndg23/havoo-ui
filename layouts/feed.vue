<template>
    <div class="bg-gray-50 dark:bg-gray-900 min-h-screen">
      <!-- Header with simplified navigation -->
      <header class="sticky top-0 z-10 bg-white dark:bg-gray-800 border-b border-gray-200 dark:border-gray-700 px-4 py-3">
        <div class="flex items-center justify-between">
          <!-- Logo -->
          <div class="flex items-center">
            <!-- <img src="/logo.svg" alt="Logo" class="h-8 w-8" /> -->
             <Logo />
          </div>
          
          <!-- Center tab navigation (simplified) -->
          <div class="flex space-x-8">
            <button 
              class="flex flex-col items-center pb-1 pt-1 border-b-2 border-primary-500 text-primary-600 dark:text-primary-400 font-medium"
            >
              <Home class="h-6 w-6" />
              <span class="text-xs mt-1">Accueil</span>
            </button>
            <button 
              class="flex flex-col items-center pb-1 pt-1 border-b-2 border-transparent text-gray-500 hover:text-gray-700 dark:text-gray-400"
            >
              <Search class="h-6 w-6" />
              <span class="text-xs mt-1">Explorer</span>
            </button>
            <button 
              class="flex flex-col items-center pb-1 pt-1 border-b-2 border-transparent text-gray-500 hover:text-gray-700 dark:text-gray-400 relative"
            >
              <MessageSquare class="h-6 w-6" />
              <span class="text-xs mt-1">Messages</span>
              <span v-if="unreadCount > 0" class="absolute -top-1 -right-1 bg-primary-500 text-white text-xs rounded-full h-5 w-5 flex items-center justify-center">
                {{ unreadCount }}
              </span>
            </button>
          </div>
          
          <!-- User avatar -->
          <div>
            <div class="h-8 w-8 rounded-full bg-gray-300 overflow-hidden">
              <img v-if="userProfile?.avatar_url" :src="userProfile.avatar_url" alt="Avatar" class="h-full w-full object-cover" />
              <UserCircle v-else class="h-full w-full text-gray-500" />
            </div>
          </div>
        </div>
      </header>
      
      <!-- Main content feed -->
      <main class="max-w-lg mx-auto pt-4 pb-20">
        <!-- New post/request prompt -->
        <div class="bg-white dark:bg-gray-800 rounded-xl shadow-sm p-4 mb-4 mx-3">
          <div class="flex items-start space-x-3">
            <div class="h-10 w-10 rounded-full bg-gray-300 overflow-hidden flex-shrink-0">
              <img v-if="userProfile?.avatar_url" :src="userProfile.avatar_url" alt="Avatar" class="h-full w-full object-cover" />
              <UserCircle v-else class="h-full w-full text-gray-500" />
            </div>
            <div class="flex-1">
              <div 
                class="rounded-full bg-gray-100 dark:bg-gray-700 text-gray-500 py-2.5 px-4 text-sm cursor-pointer hover:bg-gray-200 dark:hover:bg-gray-600 transition"
                @click="showNewPostModal = true"
              >
                Qu'est-ce que vous recherchez aujourd'hui ?
              </div>
              <div class="flex justify-around mt-3">
                <button class="flex items-center text-primary-500 text-sm">
                  <FileText class="h-4 w-4 mr-1" />
                  Demande
                </button>
                <button class="flex items-center text-emerald-500 text-sm">
                  <Briefcase class="h-4 w-4 mr-1" />
                  Service
                </button>
                <button class="flex items-center text-amber-500 text-sm">
                  <Image class="h-4 w-4 mr-1" />
                  Photo
                </button>
              </div>
            </div>
          </div>
        </div>
        
        <!-- Feed items -->
        <div class="space-y-4 px-3">
          <!-- New mission card -->
          <div v-for="item in feedItems" :key="item.id" class="bg-white dark:bg-gray-800 rounded-xl shadow-sm overflow-hidden">
            <!-- Card header -->
            <div class="p-4">
              <div class="flex items-center justify-between">
                <div class="flex items-center space-x-3">
                  <div class="h-10 w-10 rounded-full bg-gray-300 overflow-hidden">
                    <img v-if="item.author.avatar_url" :src="item.author.avatar_url" alt="Avatar" class="h-full w-full object-cover" />
                    <UserCircle v-else class="h-full w-full text-gray-500" />
                  </div>
                  <div>
                    <div class="font-medium text-gray-900 dark:text-white">{{ item.author.first_name }} {{ item.author.last_name }}</div>
                    <div class="text-xs text-gray-500 flex items-center">
                      <span>{{ formatTimeAgo(item.created_at) }}</span>
                      <span class="mx-1">•</span>
                      <span :class="item.type === 'mission' ? 'text-primary-500' : 'text-emerald-500'">
                        {{ item.type === 'mission' ? 'Demande' : 'Service' }}
                      </span>
                    </div>
                  </div>
                </div>
                <button class="text-gray-500">
                  <MoreHorizontal class="h-5 w-5" />
                </button>
              </div>
            </div>
            
            <!-- Card content -->
            <div class="px-4 pb-3">
              <h3 class="font-semibold text-lg mb-2">{{ item.title }}</h3>
              <p class="text-gray-700 dark:text-gray-300">{{ item.description }}</p>
              
              <!-- Tags/skills -->
              <div class="flex flex-wrap gap-2 mt-3" v-if="item.skills && item.skills.length">
                <span v-for="skill in item.skills" :key="skill" class="bg-gray-100 dark:bg-gray-700 text-gray-800 dark:text-gray-200 text-xs px-2 py-1 rounded-full">
                  {{ skill }}
                </span>
              </div>
              
              <!-- Additional info -->
              <div class="flex items-center justify-between mt-4 text-sm text-gray-500 border-t border-gray-100 dark:border-gray-700 pt-3">
                <div>
                  <span class="font-medium">{{ formatPrice(item.price) }}</span>
                  <span v-if="item.deadline" class="ml-3">Date limite: {{ formatDate(item.deadline) }}</span>
                </div>
                
                <div class="flex items-center space-x-2">
                  <span class="text-gray-400" v-if="item.location_type">{{ item.location_type }}</span>
                  <MapPin v-if="item.location_type === 'onsite'" class="h-4 w-4 text-gray-400" />
                  <Globe v-else-if="item.location_type === 'remote'" class="h-4 w-4 text-gray-400" />
                </div>
              </div>
            </div>
            
            <!-- Card footer / actions -->
            <div class="flex border-t border-gray-200 dark:border-gray-700">
              <button class="flex-1 py-3 flex items-center justify-center text-gray-500 hover:text-primary-500 hover:bg-primary-50 dark:hover:bg-gray-700 transition">
                <MessageSquare class="h-5 w-5 mr-2" />
                <span class="text-sm">{{ item.replies || 0 }}</span>
              </button>
              
              <button class="flex-1 py-3 flex items-center justify-center text-gray-500 hover:text-emerald-500 hover:bg-emerald-50 dark:hover:bg-gray-700 transition">
                <Repeat2 class="h-5 w-5 mr-2" />
                <span class="text-sm">{{ item.shares || 0 }}</span>
              </button>
              
              <button class="flex-1 py-3 flex items-center justify-center text-gray-500 hover:text-red-500 hover:bg-red-50 dark:hover:bg-gray-700 transition">
                <Heart class="h-5 w-5 mr-2" />
                <span class="text-sm">{{ item.likes || 0 }}</span>
              </button>
              
              <button class="flex-1 py-3 flex items-center justify-center text-gray-500 hover:text-blue-500 hover:bg-blue-50 dark:hover:bg-gray-700 transition">
                <Bookmark class="h-5 w-5 mr-2" />
              </button>
            </div>
          </div>
        </div>
      </main>
      
      <!-- Mobile bottom navigation (Twitter style) -->
      <nav class="fixed bottom-0 left-0 right-0 bg-white dark:bg-gray-800 border-t border-gray-200 dark:border-gray-700 flex justify-around py-2 md:hidden z-10">
        <button class="p-2 text-primary-500">
          <Home class="h-6 w-6" />
        </button>
        <button class="p-2 text-gray-500">
          <Search class="h-6 w-6" />
        </button>
        <button class="p-2 text-gray-500 relative">
          <MessageSquare class="h-6 w-6" />
          <span v-if="unreadCount > 0" class="absolute top-1 right-1 bg-primary-500 text-white text-xs rounded-full h-4 w-4 flex items-center justify-center">
            {{ unreadCount }}
          </span>
        </button>
        <button class="p-2 text-gray-500">
          <Bell class="h-6 w-6" />
        </button>
        <button class="p-2 text-gray-500">
          <Menu class="h-6 w-6" />
        </button>
      </nav>
      
      <!-- Floating action button (Twitter style) -->
      <div class="fixed bottom-20 right-5 md:bottom-8 md:right-8 z-20">
        <button 
          class="bg-primary-500 hover:bg-primary-600 text-white rounded-full w-14 h-14 flex items-center justify-center shadow-lg"
          @click="showNewPostModal = true"
        >
          <Plus class="h-6 w-6" />
        </button>
      </div>
    </div>
  </template>
  
  <script setup>
  import { ref, onMounted } from 'vue'
  import { useSupabaseClient } from '#imports'
  import { 
    Home, 
    Search, 
    MessageSquare, 
    UserCircle, 
    FileText, 
    Briefcase, 
    Image,
    MoreHorizontal,
    Heart,
    Repeat2,
    Bookmark,
    Plus,
    Bell,
    Menu,
    MapPin,
    Globe
  } from 'lucide-vue-next'
  
  const supabase = useSupabaseClient()
  const showNewPostModal = ref(false)
  const unreadCount = ref(2)
  const userProfile = ref(null)
  
  // Sample feed data
  const feedItems = ref([
    {
      id: 1,
      type: 'mission',
      title: 'Recherche développeur frontend Vue.js pour un projet de 3 mois',
      description: 'Nous sommes à la recherche d\'un développeur frontend expérimenté avec Vue.js pour rejoindre notre équipe pendant 3 mois. Le projet concerne la refonte de notre plateforme e-commerce.',
      price: 5000,
      deadline: '2025-04-30',
      skills: ['Vue.js', 'JavaScript', 'TailwindCSS'],
      created_at: '2025-03-16T14:20:00Z',
      author: {
        first_name: 'Thomas',
        last_name: 'Dubois',
        avatar_url: null
      },
      replies: 8,
      shares: 3,
      likes: 12
    },
    {
      id: 2,
      type: 'service',
      title: 'Développement de site web sur mesure avec WordPress',
      description: 'Je propose mes services de développement WordPress pour créer votre site web professionnel et responsive. Plus de 5 ans d\'expérience dans la création de sites pour des PME.',
      price: 1200,
      location_type: 'remote',
      skills: ['WordPress', 'PHP', 'SEO'],
      created_at: '2025-03-17T09:15:00Z',
      author: {
        first_name: 'Marie',
        last_name: 'Laurent',
        avatar_url: null
      },
      replies: 5,
      shares: 7,
      likes: 23
    }
  ])
  
  // Format functions
  const formatTimeAgo = (dateString) => {
    const date = new Date(dateString)
    const now = new Date()
    const diffInSeconds = Math.floor((now - date) / 1000)
    const diffInMinutes = Math.floor(diffInSeconds / 60)
    const diffInHours = Math.floor(diffInMinutes / 60)
    const diffInDays = Math.floor(diffInHours / 24)
    
    if (diffInDays > 0) {
      return `${diffInDays}j`
    } else if (diffInHours > 0) {
      return `${diffInHours}h`
    } else if (diffInMinutes > 0) {
      return `${diffInMinutes}m`
    } else {
      return `${diffInSeconds}s`
    }
  }
  
  const formatPrice = (price) => {
    return new Intl.NumberFormat('fr-FR', { style: 'currency', currency: 'EUR' }).format(price)
  }
  
  const formatDate = (dateString) => {
    const date = new Date(dateString)
    return new Intl.DateTimeFormat('fr-FR', { day: 'numeric', month: 'short' }).format(date)
  }
  
  // Fetch user profile
  const fetchUserProfile = async () => {
    try {
      const { data: { user } } = await supabase.auth.getUser()
      
      if (!user) return
      
      const { data, error } = await supabase
        .from('profiles')
        .select('*')
        .eq('id', user.id)
        .single()
        
      if (error) throw error
      
      userProfile.value = data
    } catch (err) {
      console.error('Error fetching user profile:', err)
    }
  }
  
  onMounted(() => {
    fetchUserProfile()
  })
  </script>