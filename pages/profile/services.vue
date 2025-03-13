<template>
  <div class="max-w-3xl mx-auto px-4 pt-5 pb-16">
    <!-- En-tête minimaliste style Twitter -->
    <div class="mb-6 flex items-center justify-between">
      <h1 class="text-2xl font-bold text-gray-900 dark:text-white">Mes services</h1>
      
      <!-- Toggle pour la disponibilité d'un service -->
      <div v-if="isExpert" class="flex items-center gap-2 text-sm">
        <span class="text-gray-600 dark:text-gray-400">{{ availability ? 'Services visibles' : 'Services masqués' }}</span>
        <Switch v-model="availability" @change="updateServicesVisibility" />
      </div>
    </div>

    <!-- Filtres pour les services -->
    <div v-if="isExpert" class="mb-6 flex items-center gap-3 overflow-x-auto pb-1 no-scrollbar">
      <button
        v-for="status in ['Tous', 'Actifs', 'En pause', 'Brouillons']"
        :key="status"
        @click="activeFilter = status"
        class="px-4 py-2 rounded-full text-sm font-medium whitespace-nowrap transition-colors"
        :class="activeFilter === status ? 
          'bg-primary-600 text-white dark:bg-primary-500' : 
          'bg-gray-100 text-gray-800 dark:bg-gray-800 dark:text-gray-200 hover:bg-gray-200 dark:hover:bg-gray-700'"
      >
        {{ status }}
      </button>
    </div>

    <!-- État de chargement -->
    <div v-if="isLoading" class="flex justify-center items-center py-20">
      <div class="h-10 w-10 border-4 border-gray-200 dark:border-gray-700 border-t-primary-500 dark:border-t-primary-400 rounded-full animate-spin"></div>
    </div>

    <!-- Message pour les clients -->
    <div v-else-if="!isExpert" class="py-16 text-center">
      <div class="mb-4 flex justify-center">
        <div class="bg-primary-50 dark:bg-primary-900/20 p-4 rounded-full">
          <UserX class="h-8 w-8 text-primary-500 dark:text-primary-400" />
        </div>
      </div>
      <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-2">Mode client actif</h3>
      <p class="text-gray-600 dark:text-gray-400 mb-6 max-w-sm mx-auto">
        Cette section est réservée aux experts. Passez en mode expert pour gérer vos services.
      </p>
      <button 
        @click="toggleExpertMode" 
        class="px-4 py-2 bg-primary-600 hover:bg-primary-700 text-white rounded-full text-sm font-medium"
      >
        Passer en mode expert
      </button>
    </div>

    <!-- Aucun service -->
    <div v-else-if="services.length === 0" class="py-16 text-center">
      <div class="mb-4 flex justify-center">
        <div class="bg-primary-50 dark:bg-primary-900/20 p-4 rounded-full">
          <Package class="h-8 w-8 text-primary-500 dark:text-primary-400" />
        </div>
      </div>
      <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-2">Aucun service</h3>
      <p class="text-gray-600 dark:text-gray-400 mb-6 max-w-sm mx-auto">
        Vous n'avez pas encore créé de services. Proposez vos compétences aux clients.
      </p>
      <button 
        @click="createNewService" 
        class="px-4 py-2 bg-primary-600 hover:bg-primary-700 text-white rounded-full text-sm font-medium"
      >
        Créer un service
      </button>
    </div>

    <!-- Liste des services avec séparations horizontales -->
    <div v-else>
      <div 
        v-for="(service, index) in filteredServices" 
        :key="service.id"
        class="py-5 hover:bg-gray-50 dark:hover:bg-gray-800/50 transition-all"
        :class="{ 'border-b border-gray-200 dark:border-gray-700': index !== filteredServices.length - 1 }"
      >
        <!-- Titre et statut -->
        <div class="flex justify-between items-start">
          <div>
            <h3 class="text-lg font-bold text-gray-900 dark:text-white">
              {{ service.title }}
            </h3>
            <div class="flex items-center mt-1">
              <span class="text-sm text-primary-600 dark:text-primary-400 font-medium">{{ service.category }}</span>
              <span class="mx-1.5 text-gray-400">•</span>
              <span class="text-sm text-gray-500 dark:text-gray-400">{{ service.created_at }}</span>
            </div>
          </div>
          <div :class="['px-3 py-1 rounded-full text-xs font-medium', getStatusClass(service.status)]">
            {{ service.status }}
          </div>
        </div>
        
        <!-- Description -->
        <p class="mt-2 text-gray-700 dark:text-gray-300 text-sm line-clamp-2">
          {{ service.description }}
        </p>
        
        <!-- Prix et actions -->
        <div class="flex justify-between items-center mt-4">
          <div class="font-bold text-lg text-primary-600 dark:text-primary-400">
            {{ service.price }}
          </div>
          
          <div class="flex items-center gap-2">
            <button class="p-2 rounded-full text-gray-500 hover:bg-gray-100 dark:hover:bg-gray-700">
              <Eye class="h-5 w-5" />
            </button>
            <button class="p-2 rounded-full text-gray-500 hover:bg-gray-100 dark:hover:bg-gray-700">
              <Edit class="h-5 w-5" />
            </button>
            <button 
              @click="editService(service)"
              class="px-4 py-2 bg-primary-600 hover:bg-primary-700 text-white rounded-full text-sm font-medium"
            >
              Modifier
            </button>
          </div>
        </div>
        
        <!-- Statistiques -->
        <div class="flex items-center mt-3 gap-4 text-xs text-gray-500 dark:text-gray-400">
          <div class="flex items-center">
            <Eye class="h-3.5 w-3.5 mr-1" />
            <span>{{ service.views }} vues</span>
          </div>
          <div class="flex items-center">
            <MessageSquare class="h-3.5 w-3.5 mr-1" />
            <span>{{ service.contacts }} contacts</span>
          </div>
          <div class="flex items-center">
            <Star class="h-3.5 w-3.5 mr-1 text-amber-400 fill-amber-400" />
            <span>{{ service.rating }} ({{ service.reviews }})</span>
          </div>
        </div>
      </div>
    </div>
    
    <!-- Bouton flottant pour créer un nouveau service -->
    <button 
      v-if="isExpert"
      @click="createNewService" 
      class="fixed bottom-6 right-6 w-14 h-14 bg-primary-600 hover:bg-primary-700 text-white rounded-full shadow-lg flex items-center justify-center hover:scale-105 transition-transform"
    >
      <Plus class="h-6 w-6" />
    </button>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useSupabaseClient, useSupabaseUser } from '#imports'
import Switch from '@/components/ui/Switch.vue'
import { 
  Plus, 
  Package, 
  Edit,
  Eye,
  Star,
  MessageSquare,
  UserX
} from 'lucide-vue-next'

const router = useRouter()
const supabase = useSupabaseClient()
const user = useSupabaseUser()

// État local
const isLoading = ref(true)
const activeFilter = ref('Tous')
const availability = ref(true)

// Profil et services
const profile = ref({
  is_expert: true
})
const services = ref([
  {
    id: 1,
    title: 'Développement de site web responsive',
    description: 'Création de sites web modernes, rapides et adaptés à tous les appareils avec les dernières technologies.',
    price: '50 000 FCFA',
    category: 'Développement web',
    status: 'Actif',
    views: 245,
    contacts: 18,
    rating: 4.8,
    reviews: 12,
    created_at: 'Il y a 2 mois'
  },
  {
    id: 2,
    title: 'Intégration WordPress',
    description: 'Installation et configuration complète de WordPress avec thème personnalisé et plugins essentiels.',
    price: '35 000 FCFA',
    category: 'WordPress',
    status: 'En pause',
    views: 124,
    contacts: 7,
    rating: 4.5,
    reviews: 6,
    created_at: 'Il y a 3 mois'
  },
  {
    id: 3,
    title: 'Maintenance et optimisation',
    description: 'Service de maintenance mensuel pour garder votre site performant, sécurisé et à jour.',
    price: '15 000 FCFA/mois',
    category: 'Maintenance',
    status: 'Brouillon',
    views: 0,
    contacts: 0,
    rating: 0,
    reviews: 0,
    created_at: 'Aujourd\'hui'
  }
])

// Computed
const isExpert = computed(() => profile.value.is_expert)
const filteredServices = computed(() => {
  if (activeFilter.value === 'Tous') return services.value
  return services.value.filter(service => service.status === activeFilter.value)
})

// Méthodes
const fetchServices = async () => {
  try {
    // Simuler le chargement
    isLoading.value = true
    
    // Dans un environnement réel, nous chargerions les services depuis Supabase
    /*
    const { data, error } = await supabase
      .from('services')
      .select('*')
      .eq('user_id', user.value.id)
      .order('created_at', { ascending: false })
    
    if (error) throw error
    services.value = data
    */
    
    // Simuler un délai de chargement
    setTimeout(() => {
      isLoading.value = false
    }, 800)
  } catch (error) {
    console.error('Erreur lors du chargement des services:', error)
    isLoading.value = false
  }
}

const updateServicesVisibility = () => {
  // Mise à jour de la visibilité des services
  console.log('Visibilité des services mise à jour:', availability.value)
}

const createNewService = () => {
  router.push('/profile/services/new')
}

const editService = (service) => {
  router.push(`/profile/services/${service.id}/edit`)
}

const toggleExpertMode = () => {
  profile.value.is_expert = true
}

const getStatusClass = (status) => {
  switch (status) {
    case 'Actif':
      return 'bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-400'
    case 'En pause':
      return 'bg-amber-100 text-amber-800 dark:bg-amber-900/30 dark:text-amber-400'
    case 'Brouillon':
      return 'bg-gray-100 text-gray-800 dark:bg-gray-800 dark:text-gray-400'
    default:
      return 'bg-gray-100 text-gray-800 dark:bg-gray-800 dark:text-gray-400'
  }
}

// Initialisation
onMounted(() => {
  fetchServices()
})

definePageMeta({
  layout: 'default'
})
</script>

<style scoped>
/* Masquer la barre de défilement tout en gardant la fonctionnalité */
.no-scrollbar {
  -ms-overflow-style: none;
  scrollbar-width: none;
}
.no-scrollbar::-webkit-scrollbar {
  display: none;
}

/* Animation pour l'apparition des composants */
.py-5 {
  animation: fadeIn 0.3s ease-out;
  animation-fill-mode: both;
}

/* Animation séquentielle pour les items */
div > div:nth-child(1) { animation-delay: 0.05s; }
div > div:nth-child(2) { animation-delay: 0.1s; }
div > div:nth-child(3) { animation-delay: 0.15s; }
div > div:nth-child(4) { animation-delay: 0.2s; }
div > div:nth-child(5) { animation-delay: 0.25s; }

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