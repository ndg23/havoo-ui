<template>
  <div class="min-h-screen bg-white">
    <!-- En-tête minimaliste -->
    <div class="border-b border-gray-200">
      <div class="max-w-4xl mx-auto px-5 py-4 flex items-center justify-between">
        <div class="flex items-center gap-2">
          <button 
            @click="router.back()" 
            class="p-1 -ml-1 text-black"
          >
            <ChevronLeft class="h-6 w-6" />
          </button>
          <h1 class="text-xl font-bold text-black">Mes demandes</h1>
        </div>
        <NuxtLink 
          to="/requests/new"
          class="px-5 py-2.5 bg-black text-white text-sm font-medium rounded-full hover:bg-gray-800 transition-colors"
        >
          Nouvelle demande
        </NuxtLink>
      </div>
    </div>
    
    <div class="max-w-4xl mx-auto px-5 py-8">
      <!-- État de chargement -->
      <div v-if="loading" class="flex justify-center py-20">
        <Loader2 class="h-8 w-8 text-gray-400 animate-spin" />
                </div>
      
      <!-- Aucune demande -->
      <div v-else-if="requests.length === 0" class="py-16 text-center">
        <div class="rounded-full bg-gray-100 h-20 w-20 flex items-center justify-center mx-auto mb-6">
          <FileSearch class="h-10 w-10 text-gray-400" />
                  </div>
        <h3 class="text-xl font-semibold text-gray-900 mb-2">Aucune demande</h3>
        <p class="text-gray-500 max-w-md mx-auto mb-8">
          Vous n'avez pas encore publié de demande de service. Créez-en une nouvelle pour trouver l'expert idéal.
        </p>
        <NuxtLink 
          to="/requests/new" 
          class="inline-flex items-center px-6 py-3 bg-black text-white font-medium rounded-full hover:bg-gray-800 transition-colors"
        >
          <Plus class="h-5 w-5 mr-2" />
          Publier une demande
        </NuxtLink>
              </div>
              
      <!-- Liste des demandes -->
      <div v-else class="space-y-6">
        <!-- Filtre par statut -->
        <div class="flex overflow-x-auto py-2 -mx-5 px-5 no-scrollbar">
          <button 
            v-for="status in statusFilters" 
            :key="status.value"
            @click="currentFilter = status.value"
            :class="[
              'px-5 py-2 text-sm font-medium rounded-full whitespace-nowrap mr-2',
              currentFilter === status.value
                ? 'bg-black text-white'
                : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
            ]"
          >
            {{ status.label }}
          </button>
            </div>
            
        <!-- Carte pour chaque demande -->
        <div v-for="request in filteredRequests" :key="request.id" class="border border-gray-200 rounded-xl overflow-hidden shadow-sm hover:shadow-md transition-shadow">
          <!-- En-tête de la carte avec statut -->
          <div class="border-b border-gray-100 px-5 py-4 flex justify-between items-center">
            <div class="flex items-center">
              <div 
                :class="[
                  'h-2.5 w-2.5 rounded-full mr-2',
                  request.status === 'active' ? 'bg-green-500' :
                  request.status === 'pending' ? 'bg-yellow-500' :
                  request.status === 'completed' ? 'bg-blue-500' :
                  'bg-gray-400'
                ]"
              ></div>
              <span 
                class="text-sm font-medium"
                :class="[
                  request.status === 'active' ? 'text-green-600' :
                  request.status === 'pending' ? 'text-yellow-600' :
                  request.status === 'completed' ? 'text-blue-600' :
                  'text-gray-600'
                ]"
              >
                {{ statusLabels[request.status] || 'Inconnu' }}
              </span>
            </div>
            <span class="text-xs text-gray-500">
              {{ formatDate(request.created_at) }}
            </span>
        </div>
        
          <!-- Corps de la carte -->
          <div class="px-5 py-4">
            <h3 class="font-semibold text-lg text-gray-900 mb-2 line-clamp-1">
              {{ request.title }}
          </h3>
          
            <div class="flex flex-col sm:flex-row sm:justify-between sm:items-end gap-4">
              <div class="space-y-2">
                <div class="flex items-center text-sm text-gray-600" v-if="serviceInfo[request.service_id]">
                  <Tag class="h-4 w-4 mr-1.5 flex-shrink-0" />
                  <span>{{ serviceInfo[request.service_id].name }}</span>
                  </div>
                
                <div class="flex items-center text-sm text-gray-600">
                  <MapPin class="h-4 w-4 mr-1.5 flex-shrink-0" />
                  <span class="line-clamp-1">{{ request.location }}</span>
                </div>
                
                <div class="flex items-center text-sm text-gray-600">
                  <Calendar class="h-4 w-4 mr-1.5 flex-shrink-0" />
                  <span>{{ formatDate(request.date) }} à {{ formatTime(request.time) }}</span>
                </div>
              </div>
              
              <div class="flex items-center justify-end">
                <div class="text-right">
                  <p class="text-xs text-gray-500">Budget</p>
                  <p class="text-xl font-semibold text-gray-900">{{ request.budget }} €</p>
                </div>
              </div>
            </div>
          </div>
          
          <!-- Actions -->
          <div class="bg-gray-50 px-5 py-3 flex justify-between items-center border-t border-gray-100">
            <div class="flex items-center gap-2">
              <div class="flex -space-x-2">
                <div v-for="i in (request.proposals_count || 0)" :key="i" class="h-8 w-8 rounded-full bg-gray-200 border-2 border-white flex items-center justify-center text-xs text-gray-500">
                  <User class="h-4 w-4" />
                </div>
                <div v-if="request.proposals_count > 3" class="h-8 w-8 rounded-full bg-gray-100 border-2 border-white flex items-center justify-center text-xs text-gray-600 font-medium">
                  +{{ request.proposals_count - 3 }}
                </div>
              </div>
              <span class="text-sm text-gray-600" v-if="request.proposals_count">
                {{ request.proposals_count }} proposition{{ request.proposals_count > 1 ? 's' : '' }}
              </span>
              <span class="text-sm text-gray-500" v-else>
                Aucune proposition
              </span>
            </div>
            
            <div class="flex items-center gap-2">
              <NuxtLink :to="`/requests/${request.id}`" 
                class="p-2 rounded-full text-gray-700 hover:bg-gray-200 transition-colors"
                title="Voir les détails"
              >
                <Eye class="h-5 w-5" />
              </NuxtLink>
              
              <NuxtLink :to="`/requests/${request.id}/edit`" 
                v-if="request.status === 'active'"
                class="p-2 rounded-full text-gray-700 hover:bg-gray-200 transition-colors"
                title="Modifier"
              >
                <Edit2 class="h-5 w-5" />
              </NuxtLink>
              
              <button
                v-if="request.status === 'active'"
                @click="confirmDelete(request.id)"
                class="p-2 rounded-full text-gray-700 hover:bg-gray-200 transition-colors"
                title="Supprimer"
              >
                <Trash2 class="h-5 w-5" />
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
    
    <!-- Modal de confirmation de suppression -->
    <div v-if="showDeleteModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 px-4 py-6">
      <div class="bg-white rounded-xl p-6 w-full max-w-md shadow-xl" @click.stop>
        <h3 class="text-xl font-bold text-gray-900 mb-4">Supprimer cette demande ?</h3>
        <p class="text-gray-600 mb-6">
          Cette action est irréversible. La demande et toutes les propositions associées seront définitivement supprimées.
        </p>
        <div class="flex gap-3">
          <button
            @click="deleteRequest"
            :disabled="isDeleting"
            class="flex-1 py-3 bg-red-600 text-white font-medium rounded-lg hover:bg-red-700 
              disabled:opacity-50 disabled:cursor-not-allowed transition-colors flex items-center justify-center"
          >
            <Loader2 v-if="isDeleting" class="animate-spin -ml-1 mr-2 h-5 w-5" />
            {{ isDeleting ? 'Suppression...' : 'Supprimer' }}
          </button>
          
            <button
              @click="showDeleteModal = false"
            class="py-3 px-6 border border-gray-300 text-gray-700 font-medium rounded-lg 
              hover:bg-gray-50 transition-colors"
            >
              Annuler
            </button>
          </div>
      </div>
      </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { 
  ChevronLeft, Loader2, FileSearch, Plus, Tag, MapPin, Calendar, 
  User, Eye, Edit2, Trash2
} from 'lucide-vue-next'

const router = useRouter()
const client = useSupabaseClient()

// États
const loading = ref(true)
const requests = ref([])
const serviceInfo = ref({}) // Pour stocker les infos des services
const currentFilter = ref('all')
const showDeleteModal = ref(false)
const requestToDelete = ref(null)
const isDeleting = ref(false)

// Filtres de statut
const statusFilters = [
  { label: 'Toutes', value: 'all' },
  { label: 'Actives', value: 'active' },
  { label: 'En attente', value: 'pending' },
  { label: 'Terminées', value: 'completed' },
  { label: 'Annulées', value: 'cancelled' }
]

// Labels des statuts pour l'affichage
const statusLabels = {
  active: 'Active',
  pending: 'En attente',
  completed: 'Terminée',
  cancelled: 'Annulée'
}

// Demandes filtrées par statut
const filteredRequests = computed(() => {
  if (currentFilter.value === 'all') {
    return requests.value
  }
  return requests.value.filter(request => request.status === currentFilter.value)
})

// Formater la date
const formatDate = (dateString) => {
  if (!dateString) return ''
  const date = new Date(dateString)
  return date.toLocaleDateString('fr-FR', {
    day: 'numeric',
    month: 'long',
    year: 'numeric'
  })
}

// Formater l'heure
const formatTime = (timeString) => {
  if (!timeString) return ''
  // Convertir format HH:MM:SS en HH:MM
  return timeString.substring(0, 5)
}

// Récupérer les demandes de l'utilisateur
const fetchRequests = async () => {
  try {
    loading.value = true
    
    // Récupérer l'utilisateur authentifié
    const { data: { user }, error: authError } = await client.auth.getUser()
    if (authError) throw authError
    if (!user) {
      router.push('/auth/login')
      return
    }
    
    // Récupérer les demandes de l'utilisateur
    const { data, error } = await client
      .from('requests')
      .select(`
        *,
        proposals:proposals(count)
      `)
      .eq('client_id', user.id)
      .order('created_at', { ascending: false })
    
    if (error) throw error
    
    // Transformer les données pour obtenir le nombre de propositions
    requests.value = data.map(request => ({
      ...request,
      proposals_count: request.proposals[0]?.count || 0
    }))
    
    // Récupérer les infos des services
    await fetchServiceInfo()
  } catch (error) {
    console.error('Erreur lors de la récupération des demandes:', error)
  } finally {
    loading.value = false
  }
}

// Récupérer les infos des services
const fetchServiceInfo = async () => {
  try {
    // Récupérer les IDs uniques des services
    const serviceIds = [...new Set(requests.value.map(r => r.service_id))]
    
    if (serviceIds.length === 0) return
    
    // Récupérer les détails des services
    const { data, error } = await client
      .from('services')
      .select('id, name, category_id')
      .in('id', serviceIds)
    
    if (error) throw error
    
    // Convertir en objet indexé par ID pour un accès facile
    const serviceInfoObj = {}
    data.forEach(service => {
      serviceInfoObj[service.id] = service
    })
    
    serviceInfo.value = serviceInfoObj
  } catch (error) {
    console.error('Erreur lors de la récupération des services:', error)
  }
}

// Confirmer la suppression
const confirmDelete = (requestId) => {
  requestToDelete.value = requestId
  showDeleteModal.value = true
}

// Supprimer une demande
const deleteRequest = async () => {
  try {
    isDeleting.value = true
    
    const { error } = await client
      .from('requests')
      .delete()
      .eq('id', requestToDelete.value)
    
    if (error) throw error
    
    // Mettre à jour la liste des demandes
    requests.value = requests.value.filter(r => r.id !== requestToDelete.value)
    
    // Fermer la modal
    showDeleteModal.value = false
  } catch (error) {
    console.error('Erreur lors de la suppression:', error)
    // TODO: Afficher un message d'erreur
  } finally {
    isDeleting.value = false
  }
}

// Charger les données lors du montage du composant
onMounted(fetchRequests)

definePageMeta({
  layout: 'default',
  auth: true
})
</script>

<style scoped>
/* Masquer la barre de défilement tout en permettant le défilement */
.no-scrollbar::-webkit-scrollbar {
  display: none;
}
.no-scrollbar {
  -ms-overflow-style: none;
  scrollbar-width: none;
}
</style> 