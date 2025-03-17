<template>
  <div class="max-w-2xl mx-auto px-4 pt-5 pb-16">
    <!-- Header de profil avec vérification simplifiée -->
    <div class="mb-6 bg-white dark:bg-gray-800 rounded-xl overflow-hidden border border-gray-200 dark:border-gray-700 shadow-sm">
      <!-- Bannière avec alerte de vérification -->
      <div class="h-32 bg-gradient-to-r from-blue-500 to-indigo-600 dark:from-blue-600 dark:to-indigo-700 relative">
        <div v-if="!isProfileConfirmed" class="absolute top-0 left-0 right-0 bg-red-500 dark:bg-red-600 py-2 px-4 text-white text-sm font-medium flex items-center justify-center gap-2">
          <AlertTriangle class="w-4 h-4" />
          <span>Profil non vérifié</span>
          <NuxtLink to="/account/verification" class="ml-2 bg-white text-red-600 px-3 py-1 rounded-full text-xs font-bold hover:bg-red-50">
            Vérifier maintenant
          </NuxtLink>
        </div>
      </div>
      
      <div class="p-5">
        <!-- Photo de profil et switch mode -->
        <div class="flex justify-between items-start">
          <div class="relative -mt-16">
            <img 
              :src="profile?.avatar_url || '/img/default-avatar.png'" 
              class="w-24 h-24 rounded-full border-4 border-white dark:border-gray-800 object-cover shadow-md"
              alt="Photo de profil"
            />
            <div 
              class="absolute bottom-0 right-0 w-6 h-6 rounded-full border-2 border-white dark:border-gray-800"
              :class="availability ? 'bg-green-500' : 'bg-gray-400'"
            ></div>
          </div>
          
          <button 
            @click="toggleExpertMode" 
            class="flex items-center gap-2 px-4 py-2 rounded-full text-sm font-bold transition-all duration-200"
            :class="isExpert 
              ? 'bg-blue-500 text-white shadow-md hover:bg-blue-600' 
              : 'bg-gray-100 text-gray-700 hover:bg-gray-200 dark:bg-gray-700 dark:text-gray-200 dark:hover:bg-gray-600'"
          >
            <Briefcase v-if="isExpert" class="w-4 h-4" />
            <User v-else class="w-4 h-4" />
            {{ isExpert ? 'Mode Expert' : 'Mode Client' }}
          </button>
        </div>
        
        <!-- Informations utilisateur -->
        <div class="mt-3">
          <h1 class="text-xl font-bold flex items-center gap-2">
            {{ profile?.first_name }} {{ profile?.last_name }}
            <CheckCircle v-if="isProfileConfirmed" class="h-5 w-5 text-blue-500" />
          </h1>
          <div class="flex items-center gap-2 mt-2 text-sm text-gray-500 dark:text-gray-400">
            <div class="flex items-center">
              <span>{{ availability ? 'En ligne' : 'Hors ligne' }}</span>
              <Switch v-model="availability" @change="updateAvailability" class="ml-1" />
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Stats Cards - Plus modernes et impactantes -->
    <div class="grid grid-cols-3 gap-3 mb-6">
      <div class="bg-white dark:bg-gray-800 p-4 rounded-xl border border-gray-200 dark:border-gray-700 text-center shadow-sm hover:shadow-md transition-shadow">
        <div class="text-2xl font-bold text-blue-600 dark:text-blue-400">{{ stats.completed || 0 }}</div>
        <div class="text-sm text-gray-500 dark:text-gray-400 font-medium">Missions</div>
      </div>
      <div class="bg-white dark:bg-gray-800 p-4 rounded-xl border border-gray-200 dark:border-gray-700 text-center shadow-sm hover:shadow-md transition-shadow">
        <div class="flex items-center justify-center">
          <span class="text-2xl font-bold text-amber-500">{{ stats.rating || '-' }}</span>
          <Star v-if="stats.rating" class="h-5 w-5 ml-1 text-amber-400 fill-amber-400" />
        </div>
        <div class="text-sm text-gray-500 dark:text-gray-400 font-medium">Note</div>
      </div>
      <div class="bg-white dark:bg-gray-800 p-4 rounded-xl border border-gray-200 dark:border-gray-700 text-center shadow-sm hover:shadow-md transition-shadow">
        <div class="text-2xl font-bold text-green-600 dark:text-green-400">{{ isExpert ? stats.earnings || 0 : stats.spent || 0 }}FCFA</div>
        <div class="text-sm text-gray-500 dark:text-gray-400 font-medium">{{ isExpert ? 'Revenus' : 'Budget' }}</div>
      </div>
    </div>

    <!-- Bouton d'action principal - Plus impactant -->
    <div class="mb-6">
      <NuxtLink 
        :to="isExpert ? '/requests' : '/requests/new'" 
        class="bg-gradient-to-r from-blue-500 to-indigo-600 text-white font-bold rounded-full p-4 flex items-center justify-center gap-3 shadow-md hover:shadow-lg transition-all text-base"
      >
        <component :is="isExpert ? Search : Plus" class="h-6 w-6" />
        {{ isExpert ? 'Découvrir les missions' : 'Publier une demande' }}
      </NuxtLink>
    </div>

    <!-- Activités en cours - Améliorées -->
    <div class="mb-6">
      <h2 class="text-lg font-bold mb-3 px-1 flex items-center gap-2">
        <Activity class="h-5 w-5 text-blue-500" />
        Activités en cours
      </h2>
      
      <div v-if="activeProjects.length === 0" class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 p-6 text-center shadow-sm">
        <Image class="h-12 w-12 mx-auto text-gray-400 mb-2" />
        <p class="text-base text-gray-600 dark:text-gray-300 mb-3">Aucune activité en cours</p>
        <NuxtLink to="/requests" class="text-blue-500 dark:text-blue-400 text-sm font-bold inline-flex items-center px-4 py-2 bg-blue-50 dark:bg-blue-900/20 rounded-full hover:bg-blue-100 dark:hover:bg-blue-800/30 transition-colors">
          Trouver une mission
          <ArrowRight class="h-4 w-4 ml-1" />
        </NuxtLink>
      </div>
      
      <div v-else class="space-y-3">
        <div v-for="project in activeProjects" :key="project.id" 
          class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 p-4 flex justify-between items-center shadow-sm hover:shadow-md transition-shadow">
          <div>
            <h3 class="font-bold text-base">{{ project.title }}</h3>
            <p class="text-sm text-gray-500 dark:text-gray-400 flex items-center gap-1">
              <User2 class="h-3 w-3" />
              {{ project.with }}
            </p>
          </div>
          <div class="flex items-center gap-2">
            <span class="px-3 py-1 rounded-full text-xs font-bold" 
              :class="project.status === 'En cours' 
                ? 'bg-blue-100 text-blue-800 dark:bg-blue-900/30 dark:text-blue-400' 
                : 'bg-amber-100 text-amber-800 dark:bg-amber-900/30 dark:text-amber-400'">
              {{ project.status }}
            </span>
            <NuxtLink :to="project.link" class="p-2 rounded-full bg-gray-100 hover:bg-gray-200 dark:bg-gray-700 dark:hover:bg-gray-600 transition-colors">
              <ChevronRight class="h-5 w-5 text-gray-600 dark:text-gray-300" />
            </NuxtLink>
          </div>
        </div>
      </div>
    </div>

    <!-- Menu rapide - Plus moderne et interactif -->
    <div>
      <h2 class="text-lg font-bold mb-3 px-1 flex items-center gap-2">
        <LayoutGrid class="h-5 w-5 text-blue-500" />
        Menu rapide
      </h2>
      
      <nav class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 overflow-hidden shadow-sm">
        <NuxtLink to="/account/messages" class="flex items-center p-4 border-b border-gray-200 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-750 group">
          <div class="p-2 rounded-full bg-blue-100 dark:bg-blue-900/30 group-hover:bg-blue-200 dark:group-hover:bg-blue-800/40 transition-colors">
            <MessageCircle class="h-6 w-6 text-blue-500 dark:text-blue-400" />
          </div>
          <span class="ml-4 text-base font-medium">Messages</span>
          <span v-if="unreadMessages > 0" class="ml-auto px-2.5 py-0.5 bg-blue-500 text-white text-sm font-bold rounded-full">
            {{ unreadMessages }}
          </span>
        </NuxtLink>
        
        <NuxtLink to="/account/requests" class="flex items-center p-4 border-b border-gray-200 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-750 group">
          <div class="p-2 rounded-full bg-green-100 dark:bg-green-900/30 group-hover:bg-green-200 dark:group-hover:bg-green-800/40 transition-colors">
            <FileText class="h-6 w-6 text-green-500 dark:text-green-400" />
          </div>
          <span class="ml-4 text-base font-medium">Demandes</span>
        </NuxtLink>
        
        <NuxtLink to="/account/contracts" class="flex items-center p-4 border-b border-gray-200 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-750 group">
          <div class="p-2 rounded-full bg-purple-100 dark:bg-purple-900/30 group-hover:bg-purple-200 dark:group-hover:bg-purple-800/40 transition-colors">
            <FileCheck class="h-6 w-6 text-purple-500 dark:text-purple-400" />
          </div>
          <span class="ml-4 text-base font-medium">Contrats</span>
        </NuxtLink>
        
        <NuxtLink v-if="isExpert" to="/account/services" class="flex items-center p-4 border-b border-gray-200 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-750 group">
          <div class="p-2 rounded-full bg-amber-100 dark:bg-amber-900/30 group-hover:bg-amber-200 dark:group-hover:bg-amber-800/40 transition-colors">
            <Briefcase class="h-6 w-6 text-amber-500 dark:text-amber-400" />
          </div>
          <span class="ml-4 text-base font-medium">Services</span>
        </NuxtLink>
        
        <NuxtLink v-if="isExpert" to="/account/proposals" class="flex items-center p-4 border-b border-gray-200 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-750 group">
          <div class="p-2 rounded-full bg-red-100 dark:bg-red-900/30 group-hover:bg-red-200 dark:group-hover:bg-red-800/40 transition-colors">
            <SendHorizonal class="h-6 w-6 text-red-500 dark:text-red-400" />
          </div>
          <span class="ml-4 text-base font-medium">Propositions</span>
        </NuxtLink>
        
        <NuxtLink to="/account/settings" class="flex items-center p-4 hover:bg-gray-50 dark:hover:bg-gray-750 group">
          <div class="p-2 rounded-full bg-gray-100 dark:bg-gray-700 group-hover:bg-gray-200 dark:group-hover:bg-gray-600 transition-colors">
            <Settings class="h-6 w-6 text-gray-500 dark:text-gray-400" />
          </div>
          <span class="ml-4 text-base font-medium">Paramètres</span>
        </NuxtLink>
      </nav>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { useSupabaseClient, useSupabaseUser } from '#imports'
import {
  Star,
  Plus,
  Search,
  FileText,
  FileCheck,
  Briefcase,
  MessageCircle,
  Settings,
  ChevronRight,
  SendHorizonal,
  ArrowRight,
  AlertTriangle,
  CheckCircle,
  Activity,
  User,
  User2,
  LayoutGrid,
  Image
} from 'lucide-vue-next'
import Switch from '~/components/ui/Switch.vue'

// États essentiels
const profile = ref(null)
const user = useSupabaseUser()
const supabase = useSupabaseClient()
const isLoading = ref(false)
const availability = ref(true)
const unreadMessages = ref(2)
const isProfileConfirmed = ref(false)

// Stats simplifiées
const stats = ref({
  completed: 14,
  rating: 4.8,
  earnings: 380,
  spent: 250,
  openRequests: 8
})

// Projets actifs
const activeProjects = ref([
  {
    id: 1,
    title: 'Développement site web',
    with: 'Marine Dupont',
    status: 'En cours',
    link: '/account/contracts/1'
  },
  {
    id: 2,
    title: 'Consultation SEO',
    with: 'Thomas Martin',
    status: 'En attente',
    link: '/account/proposals/2'
  }
])

// Calculer si l'utilisateur est un expert
const isExpert = computed(() => {
  return profile.value?.is_expert || false
})

// Méthodes
const fetchProfile = async () => {
  isLoading.value = true
  try {
    const { data, error } = await supabase
      .from('profiles')
      .select('*')
      .eq('id', user.value.id)
      .single()
    
    if (error) throw error
    profile.value = data
    availability.value = data.is_available !== false
  } catch (error) {
    console.error('Erreur lors du chargement du profil:', error)
  } finally {
    isLoading.value = false
  }
}

const updateAvailability = async () => {
  try {
    const { error } = await supabase
      .from('profiles')
      .update({ is_available: availability.value })
      .eq('id', user.value.id)
    
    if (error) throw error
  } catch (error) {
    console.error('Erreur lors de la mise à jour de la disponibilité:', error)
  }
}

const toggleExpertMode = () => {
  // Basculer entre les modes
  profile.value.is_expert = !profile.value.is_expert
}

// Initialisation
onMounted(() => {
  fetchProfile()
})

definePageMeta({
  layout: 'default'
})
</script>

<style scoped>
.rounded-xl {
  border-radius: 1rem;
}
</style>