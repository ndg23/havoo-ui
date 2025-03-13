<template>
  <div class="max-w-3xl mx-auto px-4 pt-5 pb-16">
    <!-- En-tête du profil (style Twitter) -->
    <div class="relative mb-8">
      <!-- Bannière -->
      <div class="h-32 bg-gray-100 dark:bg-gray-800 rounded-t-xl overflow-hidden">
        <img v-if="profile.banner_url" :src="profile.banner_url" class="w-full h-full object-cover" alt="Bannière">
      </div>
      
      <!-- Photo de profil et badge d'état -->
      <div class="flex flex-col sm:flex-row sm:justify-between sm:items-end -mt-12 pb-4 px-4">
        <div class="flex items-end">
          <div class="relative">
            <img :src="profile.avatar_url || '/img/default-avatar.png'" 
              class="w-24 h-24 rounded-full border-4 border-white dark:border-gray-900 object-cover shadow-sm" 
              alt="Photo de profil">
            
            <div class="absolute -bottom-1 -right-1 w-6 h-6 rounded-full border-2 border-white dark:border-gray-900"
              :class="profile.is_available ? 'bg-green-500' : 'bg-gray-400'">
            </div>
          </div>
          
          <div class="ml-4 mb-3">
            <div class="flex items-center">
              <h1 class="text-xl font-bold text-gray-900 dark:text-white">{{ profile.first_name }} {{ profile.last_name }}</h1>
              <div v-if="profile.is_verified" class="ml-2 bg-blue-100 dark:bg-blue-900/30 text-blue-600 dark:text-blue-400 text-xs px-2 py-0.5 rounded-full font-medium">
                Vérifié
              </div>
            </div>
            <div class="text-sm text-gray-500 dark:text-gray-400 mt-1">
              {{ isExpert ? profile.specialty || 'Expert' : 'Client' }}
            </div>
          </div>
        </div>
        
        <!-- Switch mode button -->
        <button 
          @click="toggleExpertMode" 
          class="mt-4 sm:mt-0 px-4 py-2 rounded-full text-sm font-medium transition-colors border"
          :class="isExpert ? 
            'bg-primary-100 text-primary-800 border-primary-200 dark:bg-primary-900/20 dark:border-primary-800 dark:text-primary-400' : 
            'bg-gray-100 text-gray-800 border-gray-200 dark:bg-gray-800 dark:border-gray-700 dark:text-gray-300'"
        >
          {{ isExpert ? 'Passer en mode client' : 'Passer en mode expert' }}
        </button>
      </div>
    </div>

    <!-- Statistiques -->
    <div class="grid grid-cols-3 gap-3 mb-8">
      <div class="bg-white dark:bg-gray-800 p-4 rounded-xl text-center shadow-sm border border-gray-100 dark:border-gray-700">
        <div class="text-xl font-bold text-gray-900 dark:text-white">{{ stats.completed }}</div>
        <div class="text-xs text-gray-500 dark:text-gray-400">Missions</div>
      </div>
      
      <div class="bg-white dark:bg-gray-800 p-4 rounded-xl text-center shadow-sm border border-gray-100 dark:border-gray-700">
        <div class="flex items-center justify-center">
          <span class="text-xl font-bold text-gray-900 dark:text-white">{{ stats.rating }}</span>
          <Star v-if="stats.rating" class="h-4 w-4 ml-1 text-amber-400 fill-amber-400" />
        </div>
        <div class="text-xs text-gray-500 dark:text-gray-400">Satisfaction</div>
      </div>
      
      <div class="bg-white dark:bg-gray-800 p-4 rounded-xl text-center shadow-sm border border-gray-100 dark:border-gray-700">
        <div class="text-xl font-bold text-primary-600 dark:text-primary-400">{{ isExpert ? stats.earnings : stats.spent }}€</div>
        <div class="text-xs text-gray-500 dark:text-gray-400">{{ isExpert ? 'Revenus' : 'Dépenses' }}</div>
      </div>
    </div>

    <!-- Menu d'actions -->
    <div class="mb-6">
      <h2 class="text-base font-medium text-gray-900 dark:text-white mb-3">Actions rapides</h2>
      
      <div class="space-y-2">
        <!-- Actions pour les experts -->
        <template v-if="isExpert">
          <NuxtLink to="/requests" 
            class="flex items-center justify-between p-4 bg-white dark:bg-gray-800 border border-gray-100 dark:border-gray-700 rounded-xl shadow-sm hover:bg-gray-50 dark:hover:bg-gray-750 transition-colors">
            <div class="flex items-center">
              <div class="bg-blue-100 dark:bg-blue-900/20 p-2 rounded-full mr-3">
                <Search class="h-5 w-5 text-blue-600 dark:text-blue-400" />
              </div>
              <div>
                <span class="font-medium text-gray-900 dark:text-white">Trouver des missions</span>
                <p class="text-xs text-gray-500 dark:text-gray-400 mt-0.5">Parcourir les demandes des clients</p>
              </div>
            </div>
            <ChevronRight class="h-5 w-5 text-gray-400" />
          </NuxtLink>
          
          <NuxtLink to="/account/proposals" 
            class="flex items-center justify-between p-4 bg-white dark:bg-gray-800 border border-gray-100 dark:border-gray-700 rounded-xl shadow-sm hover:bg-gray-50 dark:hover:bg-gray-750 transition-colors">
            <div class="flex items-center">
              <div class="bg-green-100 dark:bg-green-900/20 p-2 rounded-full mr-3">
                <FileText class="h-5 w-5 text-green-600 dark:text-green-400" />
              </div>
              <div>
                <span class="font-medium text-gray-900 dark:text-white">Mes propositions</span>
                <p class="text-xs text-gray-500 dark:text-gray-400 mt-0.5">Suivre l'état de mes propositions envoyées</p>
              </div>
            </div>
            <div class="flex items-center">
              <div v-if="stats.activeProposals > 0" class="bg-primary-600 text-white text-xs rounded-full h-5 w-5 flex items-center justify-center mr-2">
                {{ stats.activeProposals }}
              </div>
              <ChevronRight class="h-5 w-5 text-gray-400" />
            </div>
          </NuxtLink>
          
          <NuxtLink to="/account/services" 
            class="flex items-center justify-between p-4 bg-white dark:bg-gray-800 border border-gray-100 dark:border-gray-700 rounded-xl shadow-sm hover:bg-gray-50 dark:hover:bg-gray-750 transition-colors">
            <div class="flex items-center">
              <div class="bg-purple-100 dark:bg-purple-900/20 p-2 rounded-full mr-3">
                <Package class="h-5 w-5 text-purple-600 dark:text-purple-400" />
              </div>
              <div>
                <span class="font-medium text-gray-900 dark:text-white">Mes services</span>
                <p class="text-xs text-gray-500 dark:text-gray-400 mt-0.5">Gérer et promouvoir mes services</p>
              </div>
            </div>
            <ChevronRight class="h-5 w-5 text-gray-400" />
          </NuxtLink>
        </template>
        
        <!-- Actions pour les clients -->
        <template v-else>
          <NuxtLink to="/requests/new" 
            class="flex items-center justify-between p-4 bg-white dark:bg-gray-800 border border-gray-100 dark:border-gray-700 rounded-xl shadow-sm hover:bg-gray-50 dark:hover:bg-gray-750 transition-colors">
            <div class="flex items-center">
              <div class="bg-primary-100 dark:bg-primary-900/20 p-2 rounded-full mr-3">
                <Plus class="h-5 w-5 text-primary-600 dark:text-primary-400" />
              </div>
              <div>
                <span class="font-medium text-gray-900 dark:text-white">Créer une demande</span>
                <p class="text-xs text-gray-500 dark:text-gray-400 mt-0.5">Publiez votre besoin et recevez des offres</p>
              </div>
            </div>
            <ChevronRight class="h-5 w-5 text-gray-400" />
          </NuxtLink>
          
          <NuxtLink to="/experts" 
            class="flex items-center justify-between p-4 bg-white dark:bg-gray-800 border border-gray-100 dark:border-gray-700 rounded-xl shadow-sm hover:bg-gray-50 dark:hover:bg-gray-750 transition-colors">
            <div class="flex items-center">
              <div class="bg-blue-100 dark:bg-blue-900/20 p-2 rounded-full mr-3">
                <Users class="h-5 w-5 text-blue-600 dark:text-blue-400" />
              </div>
              <div>
                <span class="font-medium text-gray-900 dark:text-white">Trouver un expert</span>
                <p class="text-xs text-gray-500 dark:text-gray-400 mt-0.5">Parcourir les profils d'experts disponibles</p>
              </div>
            </div>
            <ChevronRight class="h-5 w-5 text-gray-400" />
          </NuxtLink>
          
          <NuxtLink to="/account/requests" 
            class="flex items-center justify-between p-4 bg-white dark:bg-gray-800 border border-gray-100 dark:border-gray-700 rounded-xl shadow-sm hover:bg-gray-50 dark:hover:bg-gray-750 transition-colors">
            <div class="flex items-center">
              <div class="bg-amber-100 dark:bg-amber-900/20 p-2 rounded-full mr-3">
                <FileText class="h-5 w-5 text-amber-600 dark:text-amber-400" />
              </div>
              <div>
                <span class="font-medium text-gray-900 dark:text-white">Mes demandes</span>
                <p class="text-xs text-gray-500 dark:text-gray-400 mt-0.5">Suivre l'état de mes demandes publiées</p>
              </div>
            </div>
            <div class="flex items-center">
              <div v-if="stats.activeRequests > 0" class="bg-primary-600 text-white text-xs rounded-full h-5 w-5 flex items-center justify-center mr-2">
                {{ stats.activeRequests }}
              </div>
              <ChevronRight class="h-5 w-5 text-gray-400" />
            </div>
          </NuxtLink>
        </template>
        
        <!-- Actions communes -->
        <NuxtLink to="/account/contracts" 
          class="flex items-center justify-between p-4 bg-white dark:bg-gray-800 border border-gray-100 dark:border-gray-700 rounded-xl shadow-sm hover:bg-gray-50 dark:hover:bg-gray-750 transition-colors">
          <div class="flex items-center">
            <div class="bg-green-100 dark:bg-green-900/20 p-2 rounded-full mr-3">
              <FileCheck class="h-5 w-5 text-green-600 dark:text-green-400" />
            </div>
            <div>
              <span class="font-medium text-gray-900 dark:text-white">Mes contrats</span>
              <p class="text-xs text-gray-500 dark:text-gray-400 mt-0.5">{{ isExpert ? 'Gérer vos missions en cours' : 'Suivre vos projets actifs' }}</p>
            </div>
          </div>
          <div class="flex items-center">
            <div v-if="stats.activeContracts > 0" class="bg-primary-600 text-white text-xs rounded-full h-5 w-5 flex items-center justify-center mr-2">
              {{ stats.activeContracts }}
            </div>
            <ChevronRight class="h-5 w-5 text-gray-400" />
          </div>
        </NuxtLink>
        
        <NuxtLink to="/messages" 
          class="flex items-center justify-between p-4 bg-white dark:bg-gray-800 border border-gray-100 dark:border-gray-700 rounded-xl shadow-sm hover:bg-gray-50 dark:hover:bg-gray-750 transition-colors">
          <div class="flex items-center">
            <div class="bg-blue-100 dark:bg-blue-900/20 p-2 rounded-full mr-3">
              <MessageSquare class="h-5 w-5 text-blue-600 dark:text-blue-400" />
            </div>
            <div>
              <span class="font-medium text-gray-900 dark:text-white">Messages</span>
              <p class="text-xs text-gray-500 dark:text-gray-400 mt-0.5">Consulter vos conversations</p>
            </div>
          </div>
          <div class="flex items-center">
            <div v-if="stats.unreadMessages > 0" class="bg-red-600 text-white text-xs rounded-full h-5 w-5 flex items-center justify-center mr-2">
              {{ stats.unreadMessages }}
            </div>
            <ChevronRight class="h-5 w-5 text-gray-400" />
          </div>
        </NuxtLink>
        
        <NuxtLink to="/account/settings" 
          class="flex items-center justify-between p-4 bg-white dark:bg-gray-800 border border-gray-100 dark:border-gray-700 rounded-xl shadow-sm hover:bg-gray-50 dark:hover:bg-gray-750 transition-colors">
          <div class="flex items-center">
            <div class="bg-gray-100 dark:bg-gray-700 p-2 rounded-full mr-3">
              <Settings class="h-5 w-5 text-gray-600 dark:text-gray-400" />
            </div>
            <div>
              <span class="font-medium text-gray-900 dark:text-white">Paramètres</span>
              <p class="text-xs text-gray-500 dark:text-gray-400 mt-0.5">Gérer votre profil et préférences</p>
            </div>
          </div>
          <ChevronRight class="h-5 w-5 text-gray-400" />
        </NuxtLink>
      </div>
    </div>

    <!-- Activités récentes -->
    <div v-if="activities.length > 0" class="mb-8">
      <h2 class="text-base font-medium text-gray-900 dark:text-white mb-3">Activités récentes</h2>
      
      <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-100 dark:border-gray-700 shadow-sm overflow-hidden">
        <div v-for="(activity, index) in activities" :key="activity.id" 
             class="p-4 hover:bg-gray-50 dark:hover:bg-gray-750 transition-colors"
             :class="{ 'border-b border-gray-100 dark:border-gray-700': index !== activities.length - 1 }">
          <div class="flex items-center">
            <div class="flex-shrink-0" :class="`bg-${activity.color}-100 dark:bg-${activity.color}-900/20 p-2 rounded-full mr-3`">
              <component :is="activity.icon" class="h-4 w-4" :class="`text-${activity.color}-600 dark:text-${activity.color}-400`" />
            </div>
            <div class="flex-grow">
              <p class="text-sm text-gray-900 dark:text-white">{{ activity.text }}</p>
              <div class="text-xs text-gray-500 dark:text-gray-400 mt-0.5">{{ activity.time }}</div>
            </div>
            <NuxtLink :to="activity.link" class="p-1.5 hover:bg-gray-200 dark:hover:bg-gray-700 rounded-full">
              <ChevronRight class="h-4 w-4 text-gray-500 dark:text-gray-400" />
            </NuxtLink>
          </div>
        </div>
      </div>
    </div>

    <!-- Bouton flottant pour l'action principale -->
    <button 
      v-if="isExpert" 
      @click="createNewService" 
      class="fixed bottom-6 right-6 w-14 h-14 bg-primary-600 hover:bg-primary-700 text-white rounded-full shadow-lg flex items-center justify-center hover:scale-105 transition-transform">
      <Plus class="h-6 w-6" />
    </button>
    <button 
      v-else 
      @click="createNewRequest" 
      class="fixed bottom-6 right-6 w-14 h-14 bg-primary-600 hover:bg-primary-700 text-white rounded-full shadow-lg flex items-center justify-center hover:scale-105 transition-transform">
      <Plus class="h-6 w-6" />
    </button>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useSupabaseClient, useSupabaseUser } from '#imports'
import { 
  Star, 
  ChevronRight, 
  Search, 
  FileText, 
  Plus, 
  FileCheck, 
  Package, 
  Users, 
  MessageSquare, 
  Settings,
  Bell,
  CheckCircle
} from 'lucide-vue-next'

const router = useRouter()
const supabase = useSupabaseClient()
const user = useSupabaseUser()

// État du profil et paramètres
const profile = ref({
  first_name: 'Amadou',
  last_name: 'Diallo',
  avatar_url: '/img/avatars/user1.jpg',
  banner_url: null,
  is_expert: true,
  is_verified: true,
  is_available: true,
  specialty: 'Développeur web'
})

// Mode expert ou client
const isExpert = computed(() => profile.value.is_expert)

// Statistiques
const stats = ref({
  completed: 14,
  rating: 4.8,
  earnings: 380,
  spent: 250,
  activeRequests: 2,
  activeProposals: 3,
  activeContracts: 1,
  unreadMessages: 5
})

// Activités récentes
const activities = ref([
  {
    id: 1,
    text: 'Nouvelle proposition reçue pour votre demande "Création de logo"',
    time: 'Il y a 30 minutes',
    icon: Bell,
    color: 'blue',
    link: '/account/requests/123'
  },
  {
    id: 2,
    text: 'Contrat signé avec Sarah Koné',
    time: 'Hier',
    icon: CheckCircle,
    color: 'green',
    link: '/account/contracts/456'
  },
  {
    id: 3,
    text: 'Nouveau message de Mamadou Sy',
    time: 'Il y a 2 jours',
    icon: MessageSquare,
    color: 'purple',
    link: '/messages/789'
  }
])

// Méthodes
const fetchProfile = async () => {
  try {
    // Dans un environnement réel, nous récupérerions le profil depuis Supabase
    /*
    const { data, error } = await supabase
      .from('profiles')
      .select('*')
      .eq('id', user.value.id)
      .single()

    if (error) throw error
    profile.value = data
    */
  } catch (error) {
    console.error('Erreur lors du chargement du profil:', error)
  }
}

const toggleExpertMode = () => {
  profile.value.is_expert = !profile.value.is_expert
}

const createNewService = () => {
  router.push('/account/services/new')
}

const createNewRequest = () => {
  router.push('/requests/new')
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
/* Animation pour l'apparition des composants */
.rounded-xl {
  animation: fadeIn 0.3s ease-out;
  animation-fill-mode: both;
}

/* Animation séquentielle pour les éléments */
h2 + div > a:nth-child(1), 
h2 + div > div:nth-child(1) { animation-delay: 0.05s; }
h2 + div > a:nth-child(2), 
h2 + div > div:nth-child(2) { animation-delay: 0.1s; }
h2 + div > a:nth-child(3), 
h2 + div > div:nth-child(3) { animation-delay: 0.15s; }
h2 + div > a:nth-child(4), 
h2 + div > div:nth-child(4) { animation-delay: 0.2s; }
h2 + div > a:nth-child(5), 
h2 + div > div:nth-child(5) { animation-delay: 0.25s; }
h2 + div > a:nth-child(6), 
h2 + div > div:nth-child(6) { animation-delay: 0.3s; }

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(8px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
</style> 