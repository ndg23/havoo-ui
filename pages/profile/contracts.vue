<template>
  <div class="max-w-3xl mx-auto px-4 pt-5 pb-16">
    <!-- En-tête minimaliste style Twitter -->
    <div class="mb-6">
      <h1 class="text-2xl font-bold text-gray-900 dark:text-white">Mes contrats</h1>
    </div>

    <!-- Filtres pour les contrats -->
    <div class="sticky top-0 z-10 bg-white/90 dark:bg-gray-900/90 backdrop-blur-sm py-3 -mx-4 px-4 mb-4">
      <div class="flex overflow-x-auto pb-2 no-scrollbar gap-2">
        <button
          v-for="status in ['Tous', 'En cours', 'En attente', 'Terminés', 'Annulés']"
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
    </div>

    <!-- État de chargement -->
    <div v-if="isLoading" class="flex justify-center items-center py-20">
      <div class="h-10 w-10 border-4 border-gray-200 dark:border-gray-700 border-t-primary-500 dark:border-t-primary-400 rounded-full animate-spin"></div>
    </div>

    <!-- Aucun contrat -->
    <div v-else-if="contracts.length === 0" class="py-16 text-center">
      <div class="mb-4 flex justify-center">
        <div class="bg-primary-50 dark:bg-primary-900/20 p-4 rounded-full">
          <FileCheck class="h-8 w-8 text-primary-500 dark:text-primary-400" />
        </div>
      </div>
      <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-2">Aucun contrat</h3>
      <p class="text-gray-600 dark:text-gray-400 mb-6 max-w-sm mx-auto">
        {{ isExpert ? 
          "Vous n'avez pas encore de contrats. Proposez vos services aux clients." :
          "Vous n'avez pas encore de contrats actifs. Contactez un expert."
        }}
      </p>
      <NuxtLink 
        :to="isExpert ? '/requests' : '/experts'" 
        class="px-4 py-2 bg-primary-600 hover:bg-primary-700 text-white rounded-full text-sm font-medium"
      >
        {{ isExpert ? 'Voir les demandes' : 'Trouver un expert' }}
      </NuxtLink>
    </div>

    <!-- Liste des contrats avec séparations horizontales -->
    <div v-else>
      <div 
        v-for="(contract, index) in filteredContracts" 
        :key="contract.id"
        class="py-5 hover:bg-gray-50 dark:hover:bg-gray-800/50 transition-all"
        :class="{ 'border-b border-gray-200 dark:border-gray-700': index !== filteredContracts.length - 1 }"
      >
        <!-- En-tête avec informations principales -->
        <div class="flex justify-between items-start">
          <div>
            <div class="flex items-center">
              <h3 class="text-lg font-bold text-gray-900 dark:text-white">
                {{ contract.title }}
              </h3>
              <div :class="['ml-2 px-2.5 py-0.5 rounded-full text-xs font-medium', getStatusClass(contract.status)]">
                {{ contract.status }}
              </div>
            </div>
            <div class="mt-1 text-sm text-gray-500 dark:text-gray-400">
              {{ isExpert ? 'Client: ' : 'Expert: ' }}
              <span class="font-medium text-gray-900 dark:text-white">{{ isExpert ? contract.client_name : contract.expert_name }}</span>
            </div>
          </div>
          
          <div class="font-bold text-lg text-primary-600 dark:text-primary-400">
            {{ contract.amount }}
          </div>
        </div>
        
        <!-- Détails du contrat -->
        <div class="mt-3 grid grid-cols-2 gap-4">
          <div class="text-sm">
            <div class="text-gray-500 dark:text-gray-400">Date de début</div>
            <div class="font-medium text-gray-900 dark:text-white">{{ contract.start_date }}</div>
          </div>
          
          <div class="text-sm">
            <div class="text-gray-500 dark:text-gray-400">Échéance</div>
            <div class="font-medium text-gray-900 dark:text-white">{{ contract.due_date }}</div>
          </div>
        </div>
        
        <!-- Actions selon le statut -->
        <div class="mt-4 flex items-center justify-end gap-3">
          <NuxtLink 
            :to="`/messages/${contract.chat_id}`" 
            class="px-3 py-1.5 rounded-full text-xs font-medium bg-gray-100 text-gray-800 dark:bg-gray-800 dark:text-gray-300 flex items-center"
          >
            <MessageSquare class="h-3.5 w-3.5 mr-1.5" />
            Message
          </NuxtLink>
          
          <NuxtLink 
            :to="`/profile/contracts/${contract.id}`" 
            class="px-3 py-1.5 rounded-full text-xs font-medium bg-primary-100 text-primary-800 dark:bg-primary-900/20 dark:text-primary-400 flex items-center"
          >
            <Eye class="h-3.5 w-3.5 mr-1.5" />
            Détails
          </NuxtLink>
          
          <!-- Bouton contextuel basé sur le statut et le rôle -->
          <button 
            v-if="contract.status === 'En attente' && !isExpert"
            class="px-3 py-1.5 rounded-full text-xs font-medium bg-green-600 text-white flex items-center"
          >
            <Check class="h-3.5 w-3.5 mr-1.5" />
            Accepter
          </button>
          
          <button 
            v-if="contract.status === 'En cours'"
            class="px-3 py-1.5 rounded-full text-xs font-medium bg-amber-600 text-white flex items-center"
          >
            <FileCheck class="h-3.5 w-3.5 mr-1.5" />
            {{ isExpert ? 'Marquer terminé' : 'Payer' }}
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useSupabaseClient, useSupabaseUser } from '#imports'
import { 
  FileCheck,
  Eye,
  MessageSquare,
  Check
} from 'lucide-vue-next'

const router = useRouter()
const supabase = useSupabaseClient()
const user = useSupabaseUser()

// État local
const isLoading = ref(true)
const activeFilter = ref('Tous')

// Profil et contrats
const profile = ref({
  is_expert: true
})
const contracts = ref([
  {
    id: 1,
    title: 'Développement d\'un site vitrine',
    client_name: 'Fatou Ndiaye',
    expert_name: 'Amadou Diallo',
    status: 'En cours',
    amount: '85 000 FCFA',
    start_date: '15 mars 2023',
    due_date: '15 avril 2023',
    chat_id: 'c1',
  },
  {
    id: 2,
    title: 'Maintenance mensuelle',
    client_name: 'Ibrahim Sow',
    expert_name: 'Amadou Diallo',
    status: 'En attente',
    amount: '25 000 FCFA',
    start_date: '1 avril 2023',
    due_date: '30 avril 2023',
    chat_id: 'c2',
  },
  {
    id: 3,
    title: 'Refonte logo et charte graphique',
    client_name: 'Marie Diop',
    expert_name: 'Amadou Diallo',
    status: 'Terminé',
    amount: '45 000 FCFA',
    start_date: '10 février 2023',
    due_date: '25 février 2023',
    chat_id: 'c3',
  }
])

// Computed
const isExpert = computed(() => profile.value.is_expert)
const filteredContracts = computed(() => {
  if (activeFilter.value === 'Tous') return contracts.value
  return contracts.value.filter(contract => contract.status === activeFilter.value)
})

// Méthodes
const fetchContracts = async () => {
  try {
    // Simuler le chargement
    isLoading.value = true
    
    // Dans un environnement réel, nous chargerions les contrats depuis Supabase
    /*
    const { data, error } = await supabase
      .from('contracts')
      .select('*, client:profiles!client_id(*), expert:profiles!expert_id(*)')
      .or(`client_id.eq.${user.value.id},expert_id.eq.${user.value.id}`)
      .order('created_at', { ascending: false })
    
    if (error) throw error
    contracts.value = data
    */
    
    // Simuler un délai de chargement
    setTimeout(() => {
      isLoading.value = false
    }, 800)
  } catch (error) {
    console.error('Erreur lors du chargement des contrats:', error)
    isLoading.value = false
  }
}

const getStatusClass = (status) => {
  switch (status) {
    case 'En cours':
      return 'bg-blue-100 text-blue-800 dark:bg-blue-900/30 dark:text-blue-400'
    case 'En attente':
      return 'bg-amber-100 text-amber-800 dark:bg-amber-900/30 dark:text-amber-400'
    case 'Terminé':
      return 'bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-400'
    case 'Annulé':
      return 'bg-red-100 text-red-800 dark:bg-red-900/30 dark:text-red-400'
    default:
      return 'bg-gray-100 text-gray-800 dark:bg-gray-800 dark:text-gray-400'
  }
}

// Initialisation
onMounted(() => {
  fetchContracts()
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