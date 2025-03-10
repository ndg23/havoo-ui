<template>
  <div class="max-w-4xl mx-auto px-4 pt-5 pb-16">
    <!-- En-tête de la page -->
    <div class="mb-7 bg-white dark:bg-gray-800 rounded-xl p-5 border-l-4 border-primary-500 shadow-sm">
      <h1 class="text-2xl font-bold text-gray-900 dark:text-white flex items-center">
        <FileCheck class="h-6 w-6 mr-3 text-primary-600 dark:text-primary-400" />
        Mes contrats
      </h1>
      <p class="text-gray-600 dark:text-gray-400 mt-1">
        Suivez l'état de tous vos contrats et engagements en cours
      </p>
    </div>

    <!-- Filtres et statistiques -->
    <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mb-7">
      <div class="bg-white dark:bg-gray-800 rounded-xl p-4 border border-gray-200 dark:border-gray-700 text-center">
        <div class="text-2xl font-bold text-gray-900 dark:text-gray-100">{{ stats.active }}</div>
        <div class="text-xs font-medium text-gray-600 dark:text-gray-400">Contrats actifs</div>
      </div>
      <div class="bg-white dark:bg-gray-800 rounded-xl p-4 border border-gray-200 dark:border-gray-700 text-center">
        <div class="text-2xl font-bold text-gray-900 dark:text-gray-100">{{ stats.pending }}</div>
        <div class="text-xs font-medium text-gray-600 dark:text-gray-400">En attente</div>
      </div>
      <div class="bg-white dark:bg-gray-800 rounded-xl p-4 border border-gray-200 dark:border-gray-700 text-center">
        <div class="text-2xl font-bold text-gray-900 dark:text-gray-100">{{ stats.completed }}</div>
        <div class="text-xs font-medium text-gray-600 dark:text-gray-400">Terminés</div>
      </div>
      <div class="bg-white dark:bg-gray-800 rounded-xl p-4 border border-gray-200 dark:border-gray-700 text-center">
        <div class="text-2xl font-bold text-green-600 dark:text-green-400">{{ stats.revenues }}€</div>
        <div class="text-xs font-medium text-gray-600 dark:text-gray-400">{{ isExpert ? 'Revenus totaux' : 'Budget engagé' }}</div>
      </div>
    </div>

    <!-- Filtres et recherche -->
    <div class="mb-7 flex flex-col sm:flex-row sm:items-center justify-between gap-4">
      <div class="flex items-center gap-2">
        <button 
          @click="activeFilter = 'all'"
          class="px-4 py-2 rounded-full text-sm font-medium transition-all"
          :class="activeFilter === 'all' ? 'bg-primary-100 text-primary-800 dark:bg-primary-900/30 dark:text-primary-400' : 'bg-gray-100 text-gray-800 dark:bg-gray-800 dark:text-gray-400 hover:bg-gray-200'"
        >
          Tous
        </button>
        <button 
          @click="activeFilter = 'active'"
          class="px-4 py-2 rounded-full text-sm font-medium transition-all"
          :class="activeFilter === 'active' ? 'bg-primary-100 text-primary-800 dark:bg-primary-900/30 dark:text-primary-400' : 'bg-gray-100 text-gray-800 dark:bg-gray-800 dark:text-gray-400 hover:bg-gray-200'"
        >
          En cours
        </button>
        <button 
          @click="activeFilter = 'completed'"
          class="px-4 py-2 rounded-full text-sm font-medium transition-all"
          :class="activeFilter === 'completed' ? 'bg-primary-100 text-primary-800 dark:bg-primary-900/30 dark:text-primary-400' : 'bg-gray-100 text-gray-800 dark:bg-gray-800 dark:text-gray-400 hover:bg-gray-200'"
        >
          Terminés
        </button>
      </div>

      <div class="relative">
        <Search class="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-gray-400" />
        <input 
          type="text" 
          placeholder="Rechercher dans mes contrats..."
          v-model="searchQuery"
          class="pl-10 pr-4 py-2 w-full sm:w-64 rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-800 dark:text-gray-200 focus:ring-2 focus:ring-primary-500 focus:border-primary-500 dark:focus:ring-primary-600 dark:focus:border-primary-600"
        />
      </div>
    </div>

    <!-- Liste des contrats -->
    <div v-if="isLoading" class="bg-white dark:bg-gray-800 rounded-xl p-12 flex flex-col items-center">
      <div class="h-10 w-10 border-4 border-primary-500 border-t-transparent rounded-full animate-spin"></div>
      <p class="mt-4 text-gray-600 dark:text-gray-400">Chargement de vos contrats...</p>
    </div>

    <div v-else-if="filteredContracts.length === 0" class="bg-white dark:bg-gray-800 rounded-xl p-8 text-center border border-gray-200 dark:border-gray-700">
      <div class="mb-4 flex justify-center">
        <div class="bg-gray-100 dark:bg-gray-700 p-4 rounded-full">
          <FileX class="h-8 w-8 text-gray-500 dark:text-gray-400" />
        </div>
      </div>
      <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-2">Aucun contrat trouvé</h3>
      <p class="text-gray-600 dark:text-gray-400 mb-6">
        {{ activeFilter === 'all' 
          ? "Vous n'avez encore aucun contrat à afficher." 
          : activeFilter === 'active' 
          ? "Vous n'avez aucun contrat actif en ce moment."
          : "Vous n'avez pas encore de contrats terminés." 
        }}
      </p>
      <NuxtLink to="/requests" class="px-5 py-2.5 bg-primary-600 hover:bg-primary-700 text-white text-sm font-medium rounded-full shadow-sm inline-flex items-center">
        <Search class="h-4 w-4 mr-2" />
        Explorer les demandes
      </NuxtLink>
    </div>

    <div v-else class="space-y-4">
      <div v-for="contract in filteredContracts" :key="contract.id" 
        class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 overflow-hidden hover:shadow-md transition-shadow duration-200">
        <div class="p-5">
          <div class="flex items-start justify-between">
            <div>
              <h3 class="text-lg font-semibold text-gray-900 dark:text-white mb-1">{{ contract.title }}</h3>
              <div class="flex flex-wrap items-center gap-3 text-sm text-gray-600 dark:text-gray-400 mb-3">
                <span class="flex items-center">
                  <User class="h-4 w-4 mr-1" />
                  {{ isExpert ? 'Client: ' : 'Expert: ' }} {{ contract.with_user }}
                </span>
                <span class="flex items-center">
                  <Calendar class="h-4 w-4 mr-1" />
                  Début: {{ formatDate(contract.start_date) }}
                </span>
                <span class="flex items-center">
                  <Clock class="h-4 w-4 mr-1" />
                  Durée: {{ contract.duration }}
                </span>
              </div>
              <p class="text-gray-700 dark:text-gray-300 mb-4 line-clamp-2">
                {{ contract.description }}
              </p>
            </div>
            <div>
              <span class="px-3 py-1 rounded-full text-xs font-bold" 
                :class="getStatusClass(contract.status)">
                {{ contract.status }}
              </span>
            </div>
          </div>

          <div class="flex flex-wrap items-center gap-3 mt-4 pt-4 border-t border-gray-200 dark:border-gray-700">
            <div class="flex-1">
              <div class="flex items-baseline">
                <span class="text-lg font-bold text-gray-900 dark:text-white">{{ contract.amount }}€</span>
                <span class="ml-2 text-sm text-gray-600 dark:text-gray-400">
                  {{ contract.payment_status }}
                </span>
              </div>
            </div>
            
            <NuxtLink :to="`/account/contracts/${contract.id}`" class="px-4 py-2 bg-primary-600 hover:bg-primary-700 text-white text-sm font-medium rounded-full shadow-sm">
              Voir le contrat
            </NuxtLink>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useSupabaseClient, useSupabaseUser } from '#imports'
import {
  FileCheck,
  Calendar,
  User,
  Clock,
  Search,
  FileX
} from 'lucide-vue-next'

// États
const user = useSupabaseUser()
const supabase = useSupabaseClient()
const isLoading = ref(true)
const contracts = ref([])
const activeFilter = ref('all')
const searchQuery = ref('')
const isExpert = ref(false)

// Statistiques des contrats
const stats = ref({
  active: 0,
  pending: 0,
  completed: 0,
  revenues: 0
})

// Filtrer les contrats selon les critères
const filteredContracts = computed(() => {
  let filtered = [...contracts.value]
  
  // Filtrer par statut
  if (activeFilter.value === 'active') {
    filtered = filtered.filter(contract => ['En cours', 'En préparation'].includes(contract.status))
  } else if (activeFilter.value === 'completed') {
    filtered = filtered.filter(contract => ['Terminé', 'Annulé'].includes(contract.status))
  }
  
  // Recherche textuelle
  if (searchQuery.value.trim()) {
    const query = searchQuery.value.toLowerCase().trim()
    filtered = filtered.filter(contract => 
      contract.title.toLowerCase().includes(query) || 
      contract.description.toLowerCase().includes(query) ||
      contract.with_user.toLowerCase().includes(query)
    )
  }
  
  return filtered
})

// Récupérer les contrats de l'utilisateur
const fetchContracts = async () => {
  isLoading.value = true
  
  try {
    // D'abord récupérer le profil pour savoir si l'utilisateur est un expert
    const { data: profileData, error: profileError } = await supabase
      .from('profiles')
      .select('is_expert')
      .eq('id', user.value.id)
      .single()
    
    if (profileError) throw profileError
    
    isExpert.value = profileData?.is_expert || false
    
    // Récupérer les contrats
    const { data, error } = await supabase
      .from('contracts')
      .select('*')
      .eq(isExpert.value ? 'expert_id' : 'client_id', user.value.id)
      .order('created_at', { ascending: false })
    
    if (error) throw error
    
    // Simuler des données pour l'exemple
    if (!data || data.length === 0) {
      contracts.value = [
        {
          id: 1,
          title: 'Développement site e-commerce',
          description: 'Création d\'un site e-commerce complet avec système de paiement et gestion de stock.',
          status: 'En cours',
          with_user: 'Marie Lambert',
          start_date: '2023-05-10',
          duration: '4 semaines',
          amount: 2800,
          payment_status: 'Acompte payé'
        },
        {
          id: 2,
          title: 'Campagne marketing réseaux sociaux',
          description: 'Élaboration et gestion d\'une campagne marketing sur 3 plateformes sociales.',
          status: 'En préparation',
          with_user: 'Thomas Martin',
          start_date: '2023-06-15',
          duration: '2 mois',
          amount: 1500,
          payment_status: 'En attente'
        },
        {
          id: 3,
          title: 'Création logo et charte graphique',
          description: 'Design d\'un logo et développement d\'une charte graphique complète pour une nouvelle marque.',
          status: 'Terminé',
          with_user: 'Julie Dubois',
          start_date: '2023-04-05',
          duration: '3 semaines',
          amount: 950,
          payment_status: 'Payé intégralement'
        }
      ]
    } else {
      contracts.value = data
    }
    
    // Calculer les statistiques
    updateStats()
  } catch (error) {
    console.error('Erreur lors du chargement des contrats:', error)
  } finally {
    isLoading.value = false
  }
}

// Mettre à jour les statistiques
const updateStats = () => {
  stats.value = {
    active: contracts.value.filter(c => ['En cours', 'En préparation'].includes(c.status)).length,
    pending: contracts.value.filter(c => c.status === 'En préparation').length,
    completed: contracts.value.filter(c => c.status === 'Terminé').length,
    revenues: contracts.value.reduce((sum, contract) => {
      return contract.status !== 'Annulé' ? sum + contract.amount : sum
    }, 0)
  }
}

// Formater la date pour affichage
const formatDate = (dateString) => {
  const date = new Date(dateString)
  return new Intl.DateTimeFormat('fr-FR', {
    day: 'numeric',
    month: 'long',
    year: 'numeric'
  }).format(date)
}

// Définir la classe de couleur selon le statut
const getStatusClass = (status) => {
  switch(status) {
    case 'En préparation':
      return 'bg-amber-100 text-amber-800 dark:bg-amber-900/30 dark:text-amber-400'
    case 'En cours':
      return 'bg-blue-100 text-blue-800 dark:bg-blue-900/30 dark:text-blue-400'
    case 'Terminé':
      return 'bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-400'
    case 'Annulé':
      return 'bg-red-100 text-red-800 dark:bg-red-900/30 dark:text-red-400'
    default:
      return 'bg-gray-100 text-gray-800 dark:bg-gray-700 dark:text-gray-300'
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
/* Animation des composants */
.rounded-xl {
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