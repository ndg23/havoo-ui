<template>
  <div class="max-w-3xl mx-auto px-4 pt-5 pb-16">
    <!-- En-tête avec statut - Plus impactant -->
    <div class="mb-7 flex items-center justify-between bg-white dark:bg-gray-800 rounded-xl p-4 border-l-4 border-primary-500 shadow-sm">
      <div class="flex items-center gap-4">
        <div class="relative">
          <img 
            :src="profile?.avatar_url || '/img/default-avatar.png'" 
            class="w-16 h-16 rounded-full object-cover border-2 border-white shadow"
            alt="Photo de profil"
          />
          <div 
            class="absolute -bottom-1 -right-1 w-5 h-5 rounded-full border-2 border-white shadow-sm flex items-center justify-center"
            :class="availability ? 'bg-green-500' : 'bg-gray-400'"
          >
            <span v-if="availability" class="sr-only">En ligne</span>
            <span v-else class="sr-only">Hors ligne</span>
          </div>
        </div>
        <div>
          <h1 class="text-xl font-bold text-gray-900 dark:text-white">{{ profile?.first_name }} {{ profile?.last_name }}</h1>
          <div class="flex items-center gap-2 text-sm text-gray-600 dark:text-gray-400">
            <span class="font-medium">{{ availability ? 'Statut: En ligne' : 'Statut: Indisponible' }}</span>
            <Switch v-model="availability" @change="updateAvailability" class="ml-1" />
          </div>
        </div>
      </div>
      <div>
        <button 
          @click="toggleExpertMode" 
          class="px-5 py-2.5 rounded-full text-sm font-semibold transition-all"
          :class="isExpert ? 'bg-primary-100 text-primary-800 dark:bg-primary-900/30 dark:text-primary-400 hover:bg-primary-200' : 'bg-gray-100 text-gray-800 dark:bg-gray-800 dark:text-gray-400 hover:bg-gray-200'"
        >
          {{ isExpert ? 'Passer en mode Client' : 'Passer en mode Expert' }}
        </button>
      </div>
    </div>

    <!-- Statistiques clés - Style carte Twitter mais plus explicite -->
    <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 mb-7 shadow-sm hover:shadow transition-shadow duration-300">
      <div class="grid grid-cols-3 divide-x divide-gray-200 dark:divide-gray-700">
        <div class="p-4 text-center">
          <div class="text-2xl font-bold text-gray-900 dark:text-gray-100">{{ stats.completed || 0 }}</div>
          <div class="text-xs font-medium text-gray-600 dark:text-gray-400">Missions réalisées</div>
        </div>
        <div class="p-4 text-center">
          <div class="flex items-center justify-center">
            <span class="text-2xl font-bold text-gray-900 dark:text-gray-100">{{ stats.rating || '-' }}</span>
            <Star v-if="stats.rating" class="h-5 w-5 ml-1 text-amber-400 fill-amber-400" />
          </div>
          <div class="text-xs font-medium text-gray-600 dark:text-gray-400">Satisfaction client</div>
        </div>
        <div class="p-4 text-center">
          <div class="text-2xl font-bold text-gray-900 dark:text-gray-100">{{ isExpert ? stats.earnings || 0 : stats.spent || 0 }}€</div>
          <div class="text-xs font-medium text-gray-600 dark:text-gray-400">{{ isExpert ? 'Revenus totaux' : 'Budget utilisé' }}</div>
        </div>
      </div>
    </div>

    <!-- Action principale selon le rôle - Plus impactante -->
    <div class="mb-7">
      <div v-if="isExpert" class="bg-gradient-to-r from-primary-600 to-primary-500 rounded-xl p-6 text-white shadow-md hover:shadow-lg transition-shadow">
        <h2 class="text-xl font-bold mb-2">Opportunités pour vous</h2>
        <p class="text-sm text-white/90 mb-5">
          <span class="font-semibold text-lg">{{ stats.openRequests || 0 }}</span> 
          nouvelles demandes correspondent à votre profil d'expert
        </p>
        <NuxtLink to="/requests" class="px-6 py-2.5 bg-white text-primary-600 rounded-full text-sm font-semibold inline-flex items-center shadow-sm hover:shadow transition-all">
          <Search class="h-5 w-5 mr-2" />
          Découvrir les missions
        </NuxtLink>
      </div>
      <div v-else class="bg-gradient-to-r from-primary-600 to-primary-500 rounded-xl p-6 text-white shadow-md hover:shadow-lg transition-shadow">
        <h2 class="text-xl font-bold mb-2">Besoin d'un professionnel ?</h2>
        <p class="text-sm text-white/90 mb-5">Publiez votre demande et trouvez rapidement un expert qualifié</p>
        <NuxtLink to="/requests/new" class="px-6 py-2.5 bg-white text-primary-600 rounded-full text-sm font-semibold inline-flex items-center shadow-sm hover:shadow transition-all">
          <Plus class="h-5 w-5 mr-2" />
          Publier une demande
        </NuxtLink>
      </div>
    </div>

    <!-- Activités en cours - Plus explicite -->
    <div class="mb-7">
      <h2 class="font-bold text-lg mb-4 px-1 flex items-center text-gray-900 dark:text-white">
        <Activity class="h-5 w-5 mr-2 text-primary-500" />
        Vos activités en cours
      </h2>
      
      <div v-if="activeProjects.length === 0" class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 p-6 text-center text-gray-500 dark:text-gray-400">
        <p>Vous n'avez aucune activité en cours actuellement</p>
        <NuxtLink to="/requests" class="mt-3 text-primary-600 dark:text-primary-400 font-medium inline-flex items-center">
          Trouver une nouvelle mission
          <ArrowRight class="h-4 w-4 ml-1" />
        </NuxtLink>
      </div>
      
      <div v-else>
        <div v-for="project in activeProjects" :key="project.id" 
          class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 p-5 mb-3 flex justify-between items-center hover:shadow-sm transition-shadow">
          <div>
            <h3 class="font-medium text-gray-900 dark:text-white">{{ project.title }}</h3>
            <p class="text-sm text-gray-500 dark:text-gray-400">Avec {{ project.with }}</p>
          </div>
          <div class="flex items-center">
            <span class="px-3 py-1 rounded-full text-xs font-bold" 
              :class="project.status === 'En cours' ? 'bg-blue-100 text-blue-800 dark:bg-blue-900/30 dark:text-blue-400' : 'bg-amber-100 text-amber-800 dark:bg-amber-900/30 dark:text-amber-400'">
              {{ project.status }}
            </span>
            <NuxtLink :to="project.link" class="ml-3 p-2 rounded-full hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors">
              <ChevronRight class="h-5 w-5 text-primary-600 dark:text-primary-400" />
            </NuxtLink>
          </div>
        </div>
      </div>
    </div>

    <!-- Menu d'accès rapide - Plus explicite et impactant -->
    <h2 class="font-bold text-lg mb-3 px-1 flex items-center text-gray-900 dark:text-white">
      <MenuSquare class="h-5 w-5 mr-2 text-primary-500" />
      Menu rapide
    </h2>
    <nav class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 overflow-hidden shadow-sm">
      <NuxtLink to="/account/requests" class="flex items-center justify-between p-4 border-b border-gray-200 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-750 transition-colors">
        <div class="flex items-center">
          <div class="bg-primary-50 dark:bg-primary-900/20 p-2.5 rounded-lg">
            <FileText class="h-5 w-5 text-primary-600 dark:text-primary-400" />
          </div>
          <div class="ml-4">
            <span class="font-medium text-gray-900 dark:text-white">Mes demandes</span>
            <p class="text-xs text-gray-500 dark:text-gray-400">Gérer vos demandes de service</p>
          </div>
        </div>
        <ChevronRight class="h-5 w-5 text-gray-400 dark:text-gray-500" />
      </NuxtLink>
      
      <NuxtLink to="/account/contracts" class="flex items-center justify-between p-4 border-b border-gray-200 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-750 transition-colors">
        <div class="flex items-center">
          <div class="bg-primary-50 dark:bg-primary-900/20 p-2.5 rounded-lg">
            <FileCheck class="h-5 w-5 text-primary-600 dark:text-primary-400" />
          </div>
          <div class="ml-4">
            <span class="font-medium text-gray-900 dark:text-white">Mes contrats</span>
            <p class="text-xs text-gray-500 dark:text-gray-400">Suivre vos engagements actuels</p>
          </div>
        </div>
        <ChevronRight class="h-5 w-5 text-gray-400 dark:text-gray-500" />
      </NuxtLink>
      
      <NuxtLink v-if="isExpert" to="/account/services" class="flex items-center justify-between p-4 border-b border-gray-200 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-750 transition-colors">
        <div class="flex items-center">
          <div class="bg-primary-50 dark:bg-primary-900/20 p-2.5 rounded-lg">
            <Briefcase class="h-5 w-5 text-primary-600 dark:text-primary-400" />
          </div>
          <div class="ml-4">
            <span class="font-medium text-gray-900 dark:text-white">Mes services</span>
            <p class="text-xs text-gray-500 dark:text-gray-400">Gérer vos offres de service</p>
          </div>
        </div>
        <ChevronRight class="h-5 w-5 text-gray-400 dark:text-gray-500" />
      </NuxtLink>
      
      <NuxtLink v-if="isExpert" to="/account/proposals" class="flex items-center justify-between p-4 border-b border-gray-200 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-750 transition-colors">
        <div class="flex items-center">
          <div class="bg-primary-50 dark:bg-primary-900/20 p-2.5 rounded-lg">
            <SendHorizonal class="h-5 w-5 text-primary-600 dark:text-primary-400" />
          </div>
          <div class="ml-4">
            <span class="font-medium text-gray-900 dark:text-white">Mes propositions</span>
            <p class="text-xs text-gray-500 dark:text-gray-400">Suivre vos devis envoyés</p>
          </div>
        </div>
        <ChevronRight class="h-5 w-5 text-gray-400 dark:text-gray-500" />
      </NuxtLink>
      
      <NuxtLink to="/account/messages" class="flex items-center justify-between p-4 border-b border-gray-200 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-750 transition-colors">
        <div class="flex items-center">
          <div class="bg-primary-50 dark:bg-primary-900/20 p-2.5 rounded-lg">
            <MessageCircle class="h-5 w-5 text-primary-600 dark:text-primary-400" />
          </div>
          <div class="ml-4">
            <span class="font-medium text-gray-900 dark:text-white">Messagerie</span>
            <p class="text-xs text-gray-500 dark:text-gray-400">Vos conversations</p>
          </div>
          <span v-if="unreadMessages > 0" class="ml-2 px-2.5 py-0.5 bg-primary-600 text-white text-xs font-bold rounded-full">
            {{ unreadMessages }} {{ unreadMessages > 1 ? 'nouveaux' : 'nouveau' }}
          </span>
        </div>
        <ChevronRight class="h-5 w-5 text-gray-400 dark:text-gray-500" />
      </NuxtLink>
      
      <NuxtLink to="/account/settings" class="flex items-center justify-between p-4 hover:bg-gray-50 dark:hover:bg-gray-750 transition-colors">
        <div class="flex items-center">
          <div class="bg-primary-50 dark:bg-primary-900/20 p-2.5 rounded-lg">
            <Settings class="h-5 w-5 text-primary-600 dark:text-primary-400" />
          </div>
          <div class="ml-4">
            <span class="font-medium text-gray-900 dark:text-white">Paramètres</span>
            <p class="text-xs text-gray-500 dark:text-gray-400">Configuration du compte</p>
          </div>
        </div>
        <ChevronRight class="h-5 w-5 text-gray-400 dark:text-gray-500" />
      </NuxtLink>
    </nav>
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
  Activity,
  ChevronRight,
  SendHorizonal,
  MenuSquare,
  ArrowRight
} from 'lucide-vue-next'
import Switch from '~/components/ui/Switch.vue'

// États essentiels
const profile = ref(null)
const user = useSupabaseUser()
const supabase = useSupabaseClient()
const isLoading = ref(false)
const availability = ref(true)
const unreadMessages = ref(2)

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
/* Animation pour les liens du menu */
a {
  transition: all 0.2s ease;
}

/* Animation douce des composants lors du chargement */
.mb-7 {
  animation: fadeIn 0.5s ease;
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
</style> 
