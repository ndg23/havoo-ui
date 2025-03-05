<template>
  <div class="space-y-6">
    <!-- Stats Cards -->
    <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
      <div 
        v-for="stat in stats" 
        :key="stat.name"
        class="bg-white p-4 rounded-xl border border-gray-200"
      >
        <div class="flex items-center gap-3">
          <div class="shrink-0 w-10 h-10 rounded-lg bg-primary-50 flex items-center justify-center">
            <component :is="stat.icon" class="w-5 h-5 text-primary-600" />
          </div>
          <div>
            <p class="text-sm font-medium text-gray-600">{{ stat.name }}</p>
            <p class="text-xl font-bold text-gray-900">{{ stat.value }}</p>
          </div>
        </div>
      </div>
    </div>

    <!-- Filtres -->
    <div class="flex items-center justify-between gap-4 flex-wrap">
      <div class="flex items-center gap-3">
        <div class="relative w-64">
          <MagnifyingGlassIcon class="w-5 h-5 text-gray-400 absolute left-3 top-1/2 -translate-y-1/2" />
          <input 
            v-model="searchQuery"
            type="text"
            placeholder="Rechercher une demande..."
            class="w-full pl-10 pr-4 py-2 rounded-xl border border-gray-200 focus:ring-primary-500 focus:border-primary-500"
          />
        </div>
        <select 
          v-model="statusFilter"
          class="px-4 py-2 rounded-xl border border-gray-200 focus:ring-primary-500 focus:border-primary-500"
        >
          <option value="">Tous les statuts</option>
          <option value="pending">En attente</option>
          <option value="accepted">Acceptée</option>
          <option value="in_progress">En cours</option>
          <option value="completed">Terminée</option>
          <option value="cancelled">Annulée</option>
        </select>
        <select 
          v-model="serviceFilter"
          class="px-4 py-2 rounded-xl border border-gray-200 focus:ring-primary-500 focus:border-primary-500"
        >
          <option value="">Tous les services</option>
          <option v-for="service in services" :key="service.id" :value="service.id">
            {{ service.name }}
          </option>
        </select>
      </div>
    </div>

    <!-- Liste des demandes -->
    <div class="space-y-4">
      <div 
        v-for="request in filteredRequests" 
        :key="request.id"
        class="bg-white rounded-xl border border-gray-200 overflow-hidden hover:shadow-lg transition-shadow"
      >
        <div class="p-6">
          <div class="flex items-start justify-between">
            <div class="flex items-start gap-4">
              <div class="w-12 h-12 rounded-xl bg-primary-50 flex items-center justify-center text-2xl">
                {{ request.service_icon }}
              </div>
              <div>
                <h3 class="font-medium text-gray-900">{{ request.service }}</h3>
                <div class="mt-1 flex items-center gap-2 text-sm text-gray-500">
                  <CalendarIcon class="w-4 h-4" />
                  {{ formatDate(request.date_needed) }} à {{ request.time_needed }}
                </div>
                <div class="mt-1 flex items-center gap-2 text-sm text-gray-500">
                  <MapPinIcon class="w-4 h-4" />
                  {{ request.location }}
                </div>
              </div>
            </div>
            <div class="flex items-center gap-3">
              <span 
                class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium"
                :class="{
                  'bg-yellow-100 text-yellow-800': request.status === 'pending',
                  'bg-blue-100 text-blue-800': request.status === 'accepted',
                  'bg-purple-100 text-purple-800': request.status === 'in_progress',
                  'bg-green-100 text-green-800': request.status === 'completed',
                  'bg-red-100 text-red-800': request.status === 'cancelled'
                }"
              >
                {{ request.status }}
              </span>
              <Menu as="div" class="relative">
                <MenuButton class="p-2 rounded-lg hover:bg-gray-50">
                  <EllipsisVerticalIcon class="w-5 h-5 text-gray-400" />
                </MenuButton>
                <MenuItems class="absolute right-0 mt-2 w-48 bg-white rounded-lg shadow-lg py-1 border border-gray-200">
                  <MenuItem v-slot="{ active }">
                    <button
                      class="flex w-full items-center px-4 py-2 text-sm text-gray-700 hover:bg-gray-50"
                      @click="viewDetails(request)"
                    >
                      <EyeIcon class="w-4 h-4 mr-3" />
                      Voir les détails
                    </button>
                  </MenuItem>
                  <MenuItem v-if="request.status === 'pending'" v-slot="{ active }">
                    <button
                      class="flex w-full items-center px-4 py-2 text-sm text-green-600 hover:bg-green-50"
                      @click="assignExpert(request)"
                    >
                      <UserPlusIcon class="w-4 h-4 mr-3" />
                      Assigner un expert
                    </button>
                  </MenuItem>
                  <MenuItem v-if="['pending', 'accepted'].includes(request.status)" v-slot="{ active }">
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
                  :src="request.client.avatar_url || `https://ui-avatars.com/api/?name=${request.client.name}`"
                  class="w-8 h-8 rounded-full"
                />
                <div>
                  <div class="font-medium text-gray-900">{{ request.client.name }}</div>
                  <div class="text-sm text-gray-500">{{ request.client.email }}</div>
                </div>
              </div>
              <div class="text-right">
                <div class="font-medium text-gray-900">{{ request.budget }} FCFA</div>
                <div class="text-sm text-gray-500">{{ request.duration }}h</div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Pagination -->
    <div class="flex items-center justify-between">
      <div class="text-sm text-gray-500">
        Affichage de {{ startIndex + 1 }}-{{ endIndex }} sur {{ totalRequests }} demandes
      </div>
      <div class="flex items-center gap-2">
        <button
          class="px-3 py-1 rounded-lg border border-gray-200 text-sm font-medium text-gray-600 hover:bg-gray-50 disabled:opacity-50"
          :disabled="currentPage === 1"
          @click="currentPage--"
        >
          Précédent
        </button>
        <button
          class="px-3 py-1 rounded-lg border border-gray-200 text-sm font-medium text-gray-600 hover:bg-gray-50 disabled:opacity-50"
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
import { ref, computed } from 'vue'
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
  XCircleIcon
} from '@heroicons/vue/24/outline'
import RequestDetailsModal from '~/components/admin/RequestDetailsModal.vue'
import AssignExpertModal from '~/components/admin/AssignExpertModal.vue'

// Stats
const stats = [
  { 
    name: 'Total demandes',
    value: '156',
    icon: ClipboardDocumentListIcon
  },
  {
    name: 'Complétées',
    value: '89',
    icon: CheckCircleIcon
  },
  {
    name: 'En attente',
    value: '45',
    icon: ClockIcon
  },
  {
    name: 'Annulées',
    value: '22',
    icon: XCircleIcon
  }
]

// État
const searchQuery = ref('')
const statusFilter = ref('')
const serviceFilter = ref('')
const currentPage = ref(1)
const perPage = 10
const showDetailsModal = ref(false)
const showAssignModal = ref(false)
const selectedRequest = ref(null)

// Services disponibles
const services = [
  { id: 'menage', name: 'Ménage' },
  { id: 'jardinage', name: 'Jardinage' },
  { id: 'bricolage', name: 'Bricolage' }
]

// Données simulées
const requests = ref([
  {
    id: 1,
    service: 'Ménage',
    service_icon: '🧹',
    date_needed: '2024-02-20',
    time_needed: '14:00',
    location: 'Cotonou, Bénin',
    status: 'pending',
    client: {
      name: 'Marie Dupont',
      email: 'marie@example.com',
      avatar_url: null
    },
    budget: 15000,
    duration: 4
  }
  ,
  {
    id: 2,
    service: 'Jardinage',
    service_icon: '🌱',
    date_needed: '2024-02-21',
    time_needed: '10:00',
    location: 'Cotonou, Bénin',
    status: 'accepted',
    client: {
      name: 'Jean Dupont',
      email: 'jean@example.com',
      avatar_url: null
    },
    budget: 10000,
    duration: 2
  }
])

// Filtrage et pagination
const filteredRequests = computed(() => {
  let filtered = requests.value

  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase()
    filtered = filtered.filter(request => 
      request.service.toLowerCase().includes(query) ||
      request.client.name.toLowerCase().includes(query) ||
      request.client.email.toLowerCase().includes(query)
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

// Formatage
const formatDate = (date) => {
  return new Date(date).toLocaleDateString('fr-FR', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  })
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

const cancelRequest = (request) => {
  console.log('Cancel request:', request)
}

const handleAssignExpert = async ({ request, expert }) => {
  try {
    // Implémenter l'assignation
    console.log('Assign expert:', expert, 'to request:', request)
    showAssignModal.value = false
  } catch (error) {
    console.error('Error:', error)
  }
}

definePageMeta({
  layout: 'admin'
})
</script>