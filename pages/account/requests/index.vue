<template>
  <div class="max-w-4xl mx-auto px-4 pt-5 pb-16">
    <!-- En-tête de la page -->
    <div class="mb-7 bg-white dark:bg-gray-800 rounded-xl p-5 border-l-4 border-primary-500 shadow-sm">
      <h1 class="text-2xl font-bold text-gray-900 dark:text-white flex items-center">
        <FileText class="h-6 w-6 mr-3 text-primary-600 dark:text-primary-400" />
        Mes demandes de service
      </h1>
      <p class="text-gray-600 dark:text-gray-400 mt-1">
        Consultez et gérez vos demandes de services actuelles et passées
      </p>
    </div>

    <!-- Filtres et recherche -->
    <div class="mb-7 flex flex-col sm:flex-row sm:items-center justify-between gap-4">
      <div class="flex items-center gap-2">
        <button 
          @click="activeFilter = 'all'"
          class="px-4 py-2 rounded-full text-sm font-medium transition-all"
          :class="activeFilter === 'all' ? 'bg-primary-100 text-primary-800 dark:bg-primary-900/30 dark:text-primary-400' : 'bg-gray-100 text-gray-800 dark:bg-gray-800 dark:text-gray-400 hover:bg-gray-200'"
        >
          Toutes
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
          Terminées
        </button>
      </div>

      <div class="relative">
        <Search class="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-gray-400" />
        <input 
          type="text" 
          placeholder="Rechercher dans mes demandes..."
          v-model="searchQuery"
          class="pl-10 pr-4 py-2 w-full sm:w-64 rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-800 dark:text-gray-200 focus:ring-2 focus:ring-primary-500 focus:border-primary-500 dark:focus:ring-primary-600 dark:focus:border-primary-600"
        />
      </div>
    </div>

    <!-- Liste des demandes -->
    <div v-if="isLoading" class="bg-white dark:bg-gray-800 rounded-xl p-12 flex flex-col items-center">
      <div class="h-10 w-10 border-4 border-primary-500 border-t-transparent rounded-full animate-spin"></div>
      <p class="mt-4 text-gray-600 dark:text-gray-400">Chargement de vos demandes...</p>
    </div>

    <div v-else-if="filteredRequests.length === 0" class="bg-white dark:bg-gray-800 rounded-xl p-8 text-center border border-gray-200 dark:border-gray-700">
      <div class="mb-4 flex justify-center">
        <div class="bg-gray-100 dark:bg-gray-700 p-4 rounded-full">
          <SearchX class="h-8 w-8 text-gray-500 dark:text-gray-400" />
        </div>
      </div>
      <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-2">Aucune demande trouvée</h3>
      <p class="text-gray-600 dark:text-gray-400 mb-6">
        {{ activeFilter === 'all' 
          ? "Vous n'avez pas encore créé de demande de service." 
          : activeFilter === 'active' 
          ? "Vous n'avez aucune demande en cours actuellement."
          : "Vous n'avez aucune demande terminée pour le moment." 
        }}
      </p>
      <NuxtLink to="/requests/new" class="px-5 py-2.5 bg-primary-600 hover:bg-primary-700 text-white text-sm font-medium rounded-full shadow-sm inline-flex items-center">
        <Plus class="h-4 w-4 mr-2" />
        Créer une nouvelle demande
      </NuxtLink>
    </div>

    <div v-else class="space-y-4">
      <div v-for="request in filteredRequests" :key="request.id" 
        class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 overflow-hidden hover:shadow-md transition-shadow duration-200">
        <div class="p-5">
          <div class="flex items-start justify-between">
            <div>
              <h3 class="text-lg font-semibold text-gray-900 dark:text-white mb-1">{{ request.title }}</h3>
              <div class="flex items-center gap-3 text-sm text-gray-600 dark:text-gray-400 mb-3">
                <span class="flex items-center">
                  <Calendar class="h-4 w-4 mr-1" />
                  {{ formatDate(request.created_at) }}
                </span>
                <span class="flex items-center">
                  <Tag class="h-4 w-4 mr-1" />
                  {{ request.category }}
                </span>
                <span class="flex items-center">
                  <MapPin class="h-4 w-4 mr-1" />
                  {{ request.location }}
                </span>
              </div>
              <p class="text-gray-700 dark:text-gray-300 mb-4 line-clamp-2">
                {{ request.description }}
              </p>
            </div>
            <div>
              <span class="px-3 py-1 rounded-full text-xs font-bold" 
                :class="getStatusClass(request.status)">
                {{ request.status }}
              </span>
            </div>
          </div>

          <div class="flex flex-wrap items-center gap-3 mt-4 pt-4 border-t border-gray-200 dark:border-gray-700">
            <div class="flex-1">
              <span class="text-sm text-gray-600 dark:text-gray-400">
                {{ request.proposal_count }} proposition{{ request.proposal_count !== 1 ? 's' : '' }} reçue{{ request.proposal_count !== 1 ? 's' : '' }}
              </span>
            </div>
            
            <NuxtLink :to="`/account/requests/${request.id}`" class="px-4 py-2 bg-primary-600 hover:bg-primary-700 text-white text-sm font-medium rounded-full shadow-sm">
              Voir les détails
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
  FileText,
  Calendar,
  Tag,
  MapPin,
  Search,
  Plus,
  SearchX
} from 'lucide-vue-next'

// États
const user = useSupabaseUser()
const supabase = useSupabaseClient()
const isLoading = ref(true)
const requests = ref([])
const activeFilter = ref('all')
const searchQuery = ref('')

// Filtrer les demandes selon les critères
const filteredRequests = computed(() => {
  let filtered = [...requests.value]
  
  // Filtrer par statut
  if (activeFilter.value === 'active') {
    filtered = filtered.filter(request => ['En attente', 'En cours'].includes(request.status))
  } else if (activeFilter.value === 'completed') {
    filtered = filtered.filter(request => ['Terminée', 'Annulée'].includes(request.status))
  }
  
  // Recherche textuelle
  if (searchQuery.value.trim()) {
    const query = searchQuery.value.toLowerCase().trim()
    filtered = filtered.filter(request => 
      request.title.toLowerCase().includes(query) || 
      request.description.toLowerCase().includes(query) ||
      request.category.toLowerCase().includes(query)
    )
  }
  
  return filtered
})

// Récupérer les demandes de l'utilisateur
const fetchRequests = async () => {
  isLoading.value = true
  
  try {
    let query = supabase
      .from('requests')
      .select(`
        *,
        client:client_id(id, first_name, last_name, avatar_url),
        proposals:proposals(id, status)
      `)
    
    // Filtrer selon le mode
    if (isExpert.value) {
      // Expert voit les demandes publiques
      query = query.eq('status', 'open')
    } else {
      // Client voit ses propres demandes
      query = query.eq('client_id', user.value.id)
    }
    
    // Trier par date
    query = query.order('created_at', { ascending: false })
    
    const { data, error } = await query
    
    if (error) throw error
    
    requests.value = data.map(request => ({
      ...request,
      proposals_count: request.proposals ? request.proposals.length : 0,
      client_name: `${request.client.first_name} ${request.client.last_name}`,
      client_avatar: request.client.avatar_url
    }))
  } catch (error) {
    console.error('Erreur lors du chargement des demandes:', error)
  } finally {
    isLoading.value = false
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
    case 'En attente':
      return 'bg-amber-100 text-amber-800 dark:bg-amber-900/30 dark:text-amber-400'
    case 'En cours':
      return 'bg-blue-100 text-blue-800 dark:bg-blue-900/30 dark:text-blue-400'
    case 'Terminée':
      return 'bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-400'
    case 'Annulée':
      return 'bg-red-100 text-red-800 dark:bg-red-900/30 dark:text-red-400'
    default:
      return 'bg-gray-100 text-gray-800 dark:bg-gray-700 dark:text-gray-300'
  }
}

// Initialisation
onMounted(() => {
  fetchRequests()
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