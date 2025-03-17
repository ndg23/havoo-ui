<template>
  <div class="max-w-2xl mx-auto px-4 pt-5 pb-16">


    <!-- Profile Header - More Twitter-like but larger -->
    <div class="mb-6 bg-white dark:bg-gray-800 rounded-xl overflow-hidden border border-gray-200 dark:border-gray-700">
      <div class="h-32 bg-gray-100 dark:bg-gray-700 relative">
        <div v-if="!isProfileConfirmed" class="absolute top-0 left-0 right-0 bg-red-500 dark:bg-red-600 py-2 px-4 text-white text-sm font-medium flex items-center justify-center gap-2">
          <AlertTriangle class="w-4 h-4" />
          <span>Profil non vérifié</span>
          <NuxtLink to="/account/verification" class="ml-2 bg-white text-red-600 px-3 py-1 rounded-full text-xs font-bold hover:bg-red-50">
            Vérifier maintenant
          </NuxtLink>
        </div>
        
      </div>
      <div class="p-5">
        <div class="flex justify-between items-start">
          <div class="relative -mt-16">
            <img 
              :src="profile?.avatar_url || '/img/default-avatar.png'" 
              class="w-24 h-24 rounded-full border-4 border-white dark:border-gray-800 object-cover"
              alt="Photo de profil"
            />
            <div 
              class="absolute bottom-0 right-0 w-6 h-6 rounded-full border-2 border-white dark:border-gray-800"
              :class="availability ? 'bg-green-500' : 'bg-gray-400'"
            ></div>
          </div>
          <button 
            @click="toggleExpertMode" 
            class="px-4 py-2 rounded-full text-sm font-bold border"
            :class="isExpert ? 'bg-primary-50 text-primary-600 border-primary-200 dark:bg-primary-900/20 dark:border-primary-800 dark:text-primary-400' : 'border-gray-200 dark:border-gray-700'"
          >
            {{ isExpert ? 'Mode Expert' : 'Mode Client' }}
          </button>
        </div>
        
        <div class="mt-3">
          <h1 class="text-xl font-bold">{{ profile?.first_name }} {{ profile?.last_name }}</h1>
          <div class="flex items-center gap-2 mt-2 text-sm text-gray-500 dark:text-gray-400">
            <span>{{ availability ? 'En ligne' : 'Hors ligne' }}</span>
            <Switch v-model="availability" @change="updateAvailability" class="ml-1" />
          </div>
        </div>
      </div>
    </div>

    <!-- Stats Cards - Twitter-like metrics but larger -->
    <div class="grid grid-cols-3 gap-3 mb-6">
      <div class="bg-white dark:bg-gray-800 p-4 rounded-xl border border-gray-200 dark:border-gray-700 text-center">
        <div class="text-xl font-bold">{{ stats.completed || 0 }}</div>
        <div class="text-sm text-gray-500 dark:text-gray-400">Missions</div>
      </div>
      <div class="bg-white dark:bg-gray-800 p-4 rounded-xl border border-gray-200 dark:border-gray-700 text-center">
        <div class="flex items-center justify-center">
          <span class="text-xl font-bold">{{ stats.rating || '-' }}</span>
          <Star v-if="stats.rating" class="h-5 w-5 ml-1 text-amber-400 fill-amber-400" />
        </div>
        <div class="text-sm text-gray-500 dark:text-gray-400">Note</div>
      </div>
      <div class="bg-white dark:bg-gray-800 p-4 rounded-xl border border-gray-200 dark:border-gray-700 text-center">
        <div class="text-xl font-bold">{{ isExpert ? stats.earnings || 0 : stats.spent || 0 }}FCFA</div>
        <div class="text-sm text-gray-500 dark:text-gray-400">{{ isExpert ? 'Revenus' : 'Budget' }}</div>
      </div>
    </div>

    <!-- Primary Action Button - Twitter-style prominent but larger -->
    <div class="mb-6">
      <NuxtLink 
        :to="isExpert ? '/requests' : '/requests/new'" 
        class="bg-black dark:bg-white text-white dark:text-black font-bold rounded-full p-4 flex items-center justify-center gap-3 shadow-sm hover:bg-gray-800 dark:hover:bg-gray-100 transition-colors text-base"
      >
        <component :is="isExpert ? Search : Plus" class="h-6 w-6" />
        {{ isExpert ? 'Découvrir les missions' : 'Publier une demande' }}
      </NuxtLink>
    </div>

    <!-- Active Projects - Twitter-like cards but larger -->
    <div class="mb-6">
      <h2 class="text-base font-bold mb-3 px-1">Activités en cours</h2>
      
      <div v-if="activeProjects.length === 0" class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 p-5 text-center text-base text-gray-500 dark:text-gray-400">
        <p>Aucune activité en cours</p>
        <NuxtLink to="/requests" class="mt-3 text-blue-500 dark:text-blue-400 text-sm font-medium inline-flex items-center">
          Trouver une mission
          <ArrowRight class="h-4 w-4 ml-1" />
        </NuxtLink>
      </div>
      
      <div v-else class="space-y-3">
        <div v-for="project in activeProjects" :key="project.id" 
          class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 p-4 flex justify-between items-center">
          <div>
            <h3 class="font-medium text-base">{{ project.title }}</h3>
            <p class="text-sm text-gray-500 dark:text-gray-400">{{ project.with }}</p>
          </div>
          <div class="flex items-center">
            <span class="px-3 py-1 rounded-full text-sm" 
              :class="project.status === 'En cours' ? 'bg-blue-100 text-blue-800 dark:bg-blue-900/30 dark:text-blue-400' : 'bg-amber-100 text-amber-800 dark:bg-amber-900/30 dark:text-amber-400'">
              {{ project.status }}
            </span>
            <NuxtLink :to="project.link" class="ml-2 p-2 rounded-full hover:bg-gray-100 dark:hover:bg-gray-700">
              <ChevronRight class="h-5 w-5 text-gray-400" />
            </NuxtLink>
          </div>
        </div>
      </div>
    </div>

    <div>
      <h2 class="text-base font-bold mb-3 px-1">Menu</h2>
      <nav class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 overflow-hidden ">
       
      
        <NuxtLink to="/account/services" class="flex items-center p-4 border-b border-gray-200 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-750">
          <Briefcase class="h-6 w-6 text-gray-700 dark:text-gray-300" />
          <div class="ml-4">
            <span class="font-medium text-gray-900 dark:text-white">Mes services</span>
            <p class="text-xs text-gray-500 dark:text-gray-400">Gérer vos offres de service</p>
          </div>
                </NuxtLink>
        <NuxtLink to="/account/contracts" class="flex items-center p-4 border-b border-gray-200 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-750">
          <FileCheck class="h-6 w-6 text-gray-700 dark:text-gray-300" />
          <div class="ml-4">
            <span class="font-medium text-gray-900 dark:text-white">Mes contrats</span>
            <p class="text-xs text-gray-500 dark:text-gray-400">Suivre vos engagements actuels</p>
          </div>
                </NuxtLink>
        
        <NuxtLink v-if="isExpert" to="/account/services" class="flex items-center p-4 border-b border-gray-200 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-750">
          <Briefcase class="h-6 w-6 text-gray-700 dark:text-gray-300" />
          <div class="ml-4">
            <span class="font-medium text-gray-900 dark:text-white">Mes services</span>
            <p class="text-xs text-gray-500 dark:text-gray-400">Gérer vos offres de service</p>
          </div>
        </NuxtLink>
        
        <NuxtLink v-if="isExpert" to="/account/proposals" class="flex items-center p-4 border-b border-gray-200 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-750">
          <SendHorizonal class="h-6 w-6 text-gray-700 dark:text-gray-300" />
          <div class="ml-4">
            <span class="font-medium text-gray-900 dark:text-white">Propositions</span>
            <p class="text-xs text-gray-500 dark:text-gray-400">Suivre vos propositions de service</p>
          </div>
        </NuxtLink>
        
        <NuxtLink to="/account/settings" class="flex items-center p-4 hover:bg-gray-50 dark:hover:bg-gray-750">
          <Settings class="h-6 w-6 text-gray-700 dark:text-gray-300" />
          <div class="ml-4">
            <span class="font-medium text-gray-900 dark:text-white">Paramètres</span>
            <p class="text-xs text-gray-500 dark:text-gray-400">Gérer vos paramètres</p>
          </div>
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
  Badge
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