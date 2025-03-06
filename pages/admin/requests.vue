<template>
  <div class="space-y-6 bg-gray-50 min-h-screen p-6">
    <!-- En-tête -->
    <div class="flex justify-between items-center bg-black text-white p-4 rounded-xl">
      <h1 class="text-xl font-bold">Tableau de bord administrateur</h1>
      <div class="flex items-center gap-3">
        <button class="bg-white text-black px-4 py-2 rounded-full font-medium text-sm hover:bg-gray-200 transition-colors">
          Aide
        </button>
        <div class="relative">
          <img 
            src="https://ui-avatars.com/api/?name=Admin" 
            alt="Admin profile" 
            class="w-10 h-10 rounded-full border-2 border-white"
          />
        </div>
      </div>
    </div>

    <!-- Stats Cards -->
    <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
      <div 
        v-for="stat in stats" 
        :key="stat.name"
        class="bg-white p-6 rounded-xl border border-gray-100 shadow-sm hover:shadow-md transition-shadow"
      >
        <div class="flex items-center gap-4">
          <div class="shrink-0 w-12 h-12 rounded-full bg-black flex items-center justify-center">
            <component :is="stat.icon" class="w-6 h-6 text-white" />
          </div>
          <div>
            <p class="text-sm font-medium text-gray-500">{{ stat.name }}</p>
            <p class="text-2xl font-bold text-gray-900">{{ stat.value }}</p>
          </div>
        </div>
      </div>
    </div>

    <!-- Filtres -->
    <div class="bg-white p-6 rounded-xl border border-gray-100 shadow-sm">
      <div class="flex items-center justify-between gap-4 flex-wrap">
        <div class="flex items-center gap-3 flex-wrap">
          <div class="relative w-64">
            <MagnifyingGlassIcon class="w-5 h-5 text-gray-400 absolute left-3 top-1/2 -translate-y-1/2" />
            <input 
              v-model="searchQuery"
              type="text"
              placeholder="Rechercher une demande..."
              class="w-full pl-10 pr-4 py-3 rounded-full border border-gray-200 focus:ring-black focus:border-black"
            />
          </div>
          <select 
            v-model="statusFilter"
            class="px-4 py-3 rounded-full border border-gray-200 focus:ring-black focus:border-black bg-white"
          >
            <option value="">Tous les statuts</option>
            <option value="active">Active</option>
            <option value="pending">En attente</option>
            <option value="completed">Terminée</option>
            <option value="cancelled">Annulée</option>
          </select>
          <select 
            v-model="serviceFilter"
            class="px-4 py-3 rounded-full border border-gray-200 focus:ring-black focus:border-black bg-white"
          >
            <option value="">Tous les services</option>
            <option v-for="service in services" :key="service.id" :value="service.id">
              {{ service.name }}
            </option>
          </select>
        </div>
        <button 
          class="bg-black text-white px-6 py-3 rounded-full font-medium text-sm hover:bg-gray-800 transition-colors"
          @click="showCreateRequestModal = true"
        >
          Nouvelle demande
        </button>
      </div>
    </div>

    <!-- Liste des demandes -->
    <div class="bg-white p-6 rounded-xl border border-gray-100 shadow-sm">
      <h2 class="text-xl font-bold mb-4 text-gray-900">Demandes récentes</h2>
      <div v-if="loading" class="flex justify-center p-8">
        <div class="animate-spin rounded-full h-12 w-12 border-4 border-black border-t-transparent"></div>
      </div>
      <div v-else-if="error" class="bg-red-50 p-4 rounded-xl border border-red-200 text-red-700">
        {{ error }}
      </div>
      <div v-else-if="filteredRequests.length === 0" class="text-center py-8 text-gray-500">
        Aucune demande ne correspond aux critères sélectionnés
      </div>
      <div v-else class="space-y-4">
        <div 
          v-for="request in paginatedRequests" 
          :key="request.id"
          class="bg-white rounded-xl border border-gray-200 overflow-hidden hover:shadow-md transition-shadow"
        >
          <div class="p-6">
            <div class="flex items-start justify-between">
              <div class="flex items-start gap-4">
                <div class="w-14 h-14 rounded-full bg-black flex items-center justify-center text-xl text-white">
                  {{ request.service_icon }}
                </div>
                <div>
                  <h3 class="font-semibold text-gray-900 text-lg">{{ request.service_name }}</h3>
                  <div class="mt-1 flex items-center gap-2 text-sm text-gray-500">
                    <CalendarIcon class="w-4 h-4" />
                    {{ formatDate(request.date) }} à {{ formatTime(request.time) }}
                  </div>
                  <div class="mt-1 flex items-center gap-2 text-sm text-gray-500">
                    <MapPinIcon class="w-4 h-4" />
                    {{ request.location }}
                  </div>
                </div>
              </div>
              <div class="flex items-center gap-3">
                <span 
                  class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium"
                  :class="{
                    'bg-yellow-50 text-yellow-800 border border-yellow-200': request.status === 'active',
                    'bg-blue-50 text-blue-800 border border-blue-200': request.status === 'pending',
                    'bg-green-50 text-green-800 border border-green-200': request.status === 'completed',
                    'bg-red-50 text-red-800 border border-red-200': request.status === 'cancelled'
                  }"
                >
                  {{ getStatusLabel(request.status) }}
                </span>
                <Menu as="div" class="relative">
                  <MenuButton class="p-2 rounded-full hover:bg-gray-100">
                    <EllipsisVerticalIcon class="w-5 h-5 text-gray-400" />
                  </MenuButton>
                  <MenuItems class="absolute right-0 mt-2 w-48 bg-white rounded-xl shadow-lg py-1 border border-gray-200 z-10">
                    <MenuItem v-slot="{ active }">
                      <button
                        class="flex w-full items-center px-4 py-2 text-sm text-gray-700 hover:bg-gray-50"
                        @click="viewDetails(request)"
                      >
                        <EyeIcon class="w-4 h-4 mr-3" />
                        Voir les détails
                      </button>
                    </MenuItem>
                    <MenuItem v-if="request.status === 'active'" v-slot="{ active }">
                      <button
                        class="flex w-full items-center px-4 py-2 text-sm text-green-600 hover:bg-green-50"
                        @click="assignExpert(request)"
                      >
                        <UserPlusIcon class="w-4 h-4 mr-3" />
                        Assigner un expert
                      </button>
                    </MenuItem>
                    <MenuItem v-if="['active', 'pending'].includes(request.status)" v-slot="{ active }">
                      <button
                        class="flex w-full items-center px-4 py-2 text-sm text-red-600 hover:bg-red-50"
                        @click="cancelRequest(request)"
                      >
                        <XMarkIcon class="w-4 h-4 mr-3" />
                        Annuler
                      </button>
                    </MenuItem>
                  </MenuItems>
                </Menu>
              </div>
            </div>

            <div class="mt-4 border-t border-gray-100 pt-4">
              <div class="flex items-center justify-between">
                <div class="flex items-center gap-3">
                  <img 
                    :src="request.client_image || `https://ui-avatars.com/api/?name=${request.client_first_name}+${request.client_last_name}&background=000000&color=ffffff`"
                    class="w-10 h-10 rounded-full border border-gray-200"
                    alt="Client avatar"
                  />
                  <div>
                    <div class="font-medium text-gray-900">{{ request.client_first_name }} {{ request.client_last_name }}</div>
                    <div class="text-sm text-gray-500">{{ request.client_email || '—' }}</div>
                  </div>
                </div>
                <div class="text-right">
                  <div class="font-semibold text-gray-900">{{ formatPrice(request.budget) }}</div>
                  <div class="text-sm text-gray-500">{{ request.duration }}h</div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Pagination -->
    <div class="bg-white p-4 rounded-xl border border-gray-100 shadow-sm flex items-center justify-between">
      <div class="text-sm text-gray-500">
        Affichage de {{ startIndex + 1 }}-{{ endIndex }} sur {{ totalRequests }} demandes
      </div>
      <div class="flex items-center gap-2">
        <button
          class="px-4 py-2 rounded-full border border-gray-200 text-sm font-medium text-gray-600 hover:bg-gray-50 disabled:opacity-50"
          :disabled="currentPage === 1"
          @click="currentPage--"
        >
          Précédent
        </button>
        <button
          class="px-4 py-2 rounded-full border border-gray-200 text-sm font-medium text-gray-600 hover:bg-gray-50 disabled:opacity-50"
          :disabled="endIndex >= totalRequests"
          @click="currentPage++"
        >
          Suivant
        </button>
      </div>
    </div>

    <RequestDetailsModal 
      v-if="showDetailsModal"
      :request="selectedRequest"
      @close="showDetailsModal = false"
    />

    <AssignExpertModal 
      v-if="showAssignModal"
      :request="selectedRequest"
      @close="showAssignModal = false"
      @assign="handleAssignExpert"
    />
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { Menu, MenuButton, MenuItems, MenuItem } from '@headlessui/vue'
import { 
  MagnifyingGlassIcon,
  EllipsisVerticalIcon,
  CalendarIcon,
  MapPinIcon,
  EyeIcon,
  UserPlusIcon,
  XMarkIcon,
  ClipboardDocumentListIcon,
  CheckCircleIcon,
  ClockIcon,
  XCircleIcon,
  CurrencyDollarIcon
} from '@heroicons/vue/24/outline'

// État
const requests = ref([])
const loading = ref(false)
const error = ref(null)
const searchQuery = ref('')
const statusFilter = ref('')
const serviceFilter = ref('')
const currentPage = ref(1)
const perPage = 10
const showDetailsModal = ref(false)
const showAssignModal = ref(false)
const selectedRequest = ref(null)
const services = ref([])
const stats = ref([
  { 
    name: 'Total demandes',
    value: '0',
    icon: ClipboardDocumentListIcon
  },
  {
    name: 'Complétées',
    value: '0',
    icon: CheckCircleIcon
  },
  {
    name: 'En attente',
    value: '0',
    icon: ClockIcon
  },
  {
    name: 'Revenus',
    value: '0 FCFA',
    icon: CurrencyDollarIcon
  }
])
const supabase = useSupabaseClient()
// Chargement des données
onMounted(async () => {
  await fetchServices()
  await fetchRequests()
  updateStats()
})

// Récupérer les services
const fetchServices = async () => {
  try {
    const { data, error: err } = await supabase
      .from('services')
      .select('id, name, icon')
    
    if (err) throw err
    services.value = data || []
  } catch (err) {
    console.error('Erreur lors du chargement des services:', err)
    error.value = 'Impossible de charger les services'
  }
}

// Récupérer les demandes
const fetchRequests = async () => {
  try {
    loading.value = true
    error.value = null
    
    // Utilisation de la vue request_details créée dans votre schéma SQL
    const { data, error: err } = await supabase
      .from('request_details')
      .select('*')
    
    if (err) throw err
    requests.value = data || []
  } catch (err) {
    console.error('Erreur lors du chargement des demandes:', err)
    error.value = 'Impossible de charger les demandes'
  } finally {
    loading.value = false
  }
}

// Mettre à jour les statistiques
const updateStats = () => {
  if (requests.value.length > 0) {
    const total = requests.value.length
    const completed = requests.value.filter(r => r.status === 'completed').length
    const pending = requests.value.filter(r => r.status === 'pending').length
    const revenue = requests.value
      .filter(r => r.status === 'completed')
      .reduce((sum, r) => sum + (r.budget || 0), 0)
    
    stats.value = [
      { name: 'Total demandes', value: total.toString(), icon: ClipboardDocumentListIcon },
      { name: 'Complétées', value: completed.toString(), icon: CheckCircleIcon },
      { name: 'En attente', value: pending.toString(), icon: ClockIcon },
      { name: 'Revenus', value: formatPrice(revenue), icon: CurrencyDollarIcon }
    ]
  }
}

// Filtrage et pagination
const filteredRequests = computed(() => {
  let filtered = requests.value

  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase()
    filtered = filtered.filter(request => 
      request.service_name?.toLowerCase().includes(query) ||
      `${request.client_first_name} ${request.client_last_name}`.toLowerCase().includes(query) ||
      request.client_email?.toLowerCase().includes(query) ||
      request.location?.toLowerCase().includes(query)
    )
  }

  if (statusFilter.value) {
    filtered = filtered.filter(request => request.status === statusFilter.value)
  }

  if (serviceFilter.value) {
    filtered = filtered.filter(request => request.service_id === serviceFilter.value)
  }

  return filtered
})

const totalRequests = computed(() => filteredRequests.value.length)
const startIndex = computed(() => (currentPage.value - 1) * perPage)
const endIndex = computed(() => Math.min(startIndex.value + perPage, totalRequests.value))
const paginatedRequests = computed(() => 
  filteredRequests.value.slice(startIndex.value, endIndex.value)
)

// Formatage
const formatDate = (date) => {
  if (!date) return '—'
  return new Date(date).toLocaleDateString('fr-FR', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  })
}

const formatTime = (time) => {
  if (!time) return '—'
  return time
}

const formatPrice = (price) => {
  return new Intl.NumberFormat('fr-FR', {
    style: 'currency',
    currency: 'XOF',
    maximumFractionDigits: 0
  }).format(price || 0)
}

const getStatusLabel = (status) => {
  const statusMap = {
    'active': 'Active',
    'pending': 'En attente',
    'completed': 'Terminée',
    'cancelled': 'Annulée'
  }
  return statusMap[status] || status
}

// Actions
const viewDetails = (request) => {
  selectedRequest.value = request
  showDetailsModal.value = true
}

const assignExpert = (request) => {
  selectedRequest.value = request
  showAssignModal.value = true
}

const cancelRequest = async (request) => {
  if (confirm(`Êtes-vous sûr de vouloir annuler la demande "${request.service_name}" ?`)) {
    try {
      const { error: err } = await supabase
        .from('requests')
        .update({ status: 'cancelled', updated_at: new Date() })
        .eq('id', request.id)
      
      if (err) throw err
      
      // Mettre à jour la liste locale
      await fetchRequests()
      updateStats()
    } catch (err) {
      console.error('Erreur lors de l\'annulation de la demande:', err)
      alert('Erreur lors de l\'annulation de la demande')
    }
  }
}

const handleAssignExpert = async ({ request, expert }) => {
  try {
    // 1. Créer une proposition
    const { data: proposal, error: proposalError } = await supabase
      .from('proposals')
      .insert({
        request_id: request.id,
        expert_id: expert.id,
        price: request.budget, // Vous pourriez ajuster cela
        message: 'Assigné par l\'administrateur',
        status: 'accepted'
      })
      .select()
      .single()
    
    if (proposalError) throw proposalError
    
    // 2. Mettre à jour le statut de la demande
    const { error: requestError } = await supabase
      .from('requests')
      .update({ 
        status: 'pending',
        updated_at: new Date()
      })
      .eq('id', request.id)
    
    if (requestError) throw requestError
    
    // Mettre à jour la liste locale
    await fetchRequests()
    updateStats()
    showAssignModal.value = false
  } catch (error) {
    console.error('Erreur lors de l\'assignation:', error)
    alert('Erreur lors de l\'assignation de l\'expert')
  }
}
definePageMeta({
  // middleware: ['auth'],
  layout: 'admin'
})
</script>
