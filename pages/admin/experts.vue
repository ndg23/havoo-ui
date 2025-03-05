<template>
  <div class="space-y-6">
    <!-- Header avec stats -->
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
            placeholder="Rechercher un expert..."
            class="w-full pl-10 pr-4 py-2 rounded-xl border border-gray-200 focus:ring-primary-500 focus:border-primary-500"
          />
        </div>
        <select 
          v-model="statusFilter"
          class="px-4 py-2 rounded-xl border border-gray-200 focus:ring-primary-500 focus:border-primary-500"
        >
          <option value="">Tous les statuts</option>
          <option value="pending">En attente</option>
          <option value="active">Actif</option>
          <option value="inactive">Inactif</option>
          <option value="suspended">Suspendu</option>
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
      <button 
        @click="exportExperts"
        class="flex items-center gap-2 px-4 py-2 bg-white border border-gray-200 rounded-xl hover:bg-gray-50"
      >
        <ArrowDownTrayIcon class="w-5 h-5 text-gray-600" />
        <span class="text-sm font-medium text-gray-700">Exporter</span>
      </button>
    </div>

    <!-- Table des experts -->
    <div class="bg-white rounded-xl border border-gray-200 overflow-hidden">
      <div class="overflow-x-auto">
        <table class="w-full">
          <thead class="bg-gray-50 border-b border-gray-200">
            <tr>
              <th class="px-6 py-4 text-left text-sm font-medium text-gray-500">Expert</th>
              <th class="px-6 py-4 text-left text-sm font-medium text-gray-500">Services</th>
              <th class="px-6 py-4 text-left text-sm font-medium text-gray-500">Note</th>
              <th class="px-6 py-4 text-left text-sm font-medium text-gray-500">Missions</th>
              <th class="px-6 py-4 text-left text-sm font-medium text-gray-500">Statut</th>
              <th class="px-6 py-4 text-right text-sm font-medium text-gray-500">Actions</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-gray-200">
            <tr v-for="expert in filteredExperts" :key="expert.id" class="hover:bg-gray-50">
              <td class="px-6 py-4 whitespace-nowrap">
                <div class="flex items-center gap-3">
                  <img 
                    :src="expert.avatar_url || `https://ui-avatars.com/api/?name=${expert.first_name}+${expert.last_name}`"
                    class="w-10 h-10 rounded-full"
                  />
                  <div>
                    <div class="font-medium text-gray-900">
                      {{ expert.first_name }} {{ expert.last_name }}
                    </div>
                    <div class="text-sm text-gray-500">{{ expert.email }}</div>
                  </div>
                </div>
              </td>
              <td class="px-6 py-4">
                <div class="flex flex-wrap gap-1">
                  <span 
                    v-for="service in expert.services" 
                    :key="service.id"
                    class="inline-flex items-center px-2 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-800"
                  >
                    {{ service.name }}
                  </span>
                </div>
              </td>
              <td class="px-6 py-4 whitespace-nowrap">
                <div class="flex items-center gap-1">
                  <StarIcon 
                    v-for="i in 5" 
                    :key="i"
                    class="w-4 h-4"
                    :class="i <= expert.rating ? 'text-yellow-400' : 'text-gray-200'"
                  />
                  <span class="ml-1 text-sm text-gray-600">
                    ({{ expert.rating }})
                  </span>
                </div>
              </td>
              <td class="px-6 py-4 whitespace-nowrap">
                <div class="text-sm text-gray-900">{{ expert.total_jobs }} missions</div>
                <div class="text-xs text-gray-500">{{ expert.completed_jobs }} terminées</div>
              </td>
              <td class="px-6 py-4 whitespace-nowrap">
                <span 
                  class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium"
                  :class="{
                    'bg-green-100 text-green-800': expert.status === 'active',
                    'bg-yellow-100 text-yellow-800': expert.status === 'pending',
                    'bg-gray-100 text-gray-800': expert.status === 'inactive',
                    'bg-red-100 text-red-800': expert.status === 'suspended'
                  }"
                >
                  {{ expert.status }}
                </span>
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-right text-sm">
                <Menu as="div" class="relative inline-block text-left">
                  <MenuButton class="p-2 rounded-lg hover:bg-gray-50">
                    <EllipsisVerticalIcon class="w-5 h-5 text-gray-400" />
                  </MenuButton>
                  <MenuItems class="absolute right-0 mt-2 w-56 bg-white rounded-lg shadow-lg py-1 border border-gray-200">
                    <MenuItem v-slot="{ active }">
                      <button
                        class="flex w-full items-center px-4 py-2 text-sm text-gray-700 hover:bg-gray-50"
                        @click="viewExpert(expert)"
                      >
                        <EyeIcon class="w-4 h-4 mr-3" />
                        Voir le profil
                      </button>
                    </MenuItem>
                    <MenuItem v-slot="{ active }">
                      <button
                        class="flex w-full items-center px-4 py-2 text-sm text-gray-700 hover:bg-gray-50"
                        @click="verifyDocuments(expert)"
                      >
                        <DocumentCheckIcon class="w-4 h-4 mr-3" />
                        Vérifier les documents
                      </button>
                    </MenuItem>
                    <MenuItem v-slot="{ active }">
                      <button
                        class="flex w-full items-center px-4 py-2 text-sm text-gray-700 hover:bg-gray-50"
                        @click="updateStatus(expert)"
                      >
                        <ArrowPathIcon class="w-4 h-4 mr-3" />
                        Changer le statut
                      </button>
                    </MenuItem>
                    <MenuItem v-slot="{ active }">
                      <button
                        class="flex w-full items-center px-4 py-2 text-sm text-red-600 hover:bg-red-50"
                        @click="suspendExpert(expert)"
                      >
                        <BanIcon class="w-4 h-4 mr-3" />
                        Suspendre
                      </button>
                    </MenuItem>
                  </MenuItems>
                </Menu>
              </td>
            </tr>
          </tbody>
        </table>
      </div>

      <!-- Pagination -->
      <div class="flex items-center justify-between px-6 py-4 border-t border-gray-200">
        <div class="text-sm text-gray-500">
          Affichage de {{ startIndex + 1 }}-{{ endIndex }} sur {{ totalExperts }} experts
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
            :disabled="endIndex >= totalExperts"
            @click="currentPage++"
          >
            Suivant
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { Menu, MenuButton, MenuItems, MenuItem } from '@headlessui/vue'
import { 
  MagnifyingGlassIcon,
  EllipsisVerticalIcon,
  StarIcon,
  EyeIcon,
  DocumentCheckIcon,
  ArrowPathIcon,
  BanIcon,
  ArrowDownTrayIcon,
  UserGroupIcon,
  CheckBadgeIcon,
  ClockIcon,
  ExclamationTriangleIcon
} from '@heroicons/vue/24/outline'

// Stats
const stats = [
  { 
    name: 'Total Experts',
    value: '89',
    icon: UserGroupIcon
  },
  {
    name: 'Experts vérifiés',
    value: '65',
    icon: CheckBadgeIcon
  },
  {
    name: 'En attente',
    value: '12',
    icon: ClockIcon
  },
  {
    name: 'Suspendus',
    value: '3',
    icon: ExclamationTriangleIcon
  }
]

// État
const searchQuery = ref('')
const statusFilter = ref('')
const serviceFilter = ref('')
const currentPage = ref(1)
const perPage = 10

// Services disponibles
const services = [
  { id: 'menage', name: 'Ménage' },
  { id: 'jardinage', name: 'Jardinage' },
  { id: 'bricolage', name: 'Bricolage' }
]

// Données simulées
const experts = ref([
  {
    id: 1,
    first_name: 'Jean',
    last_name: 'Dupont',
    email: 'jean@example.com',
    avatar_url: null,
    services: [
      { id: 'menage', name: 'Ménage' },
      { id: 'jardinage', name: 'Jardinage' }
    ],
    rating: 4.5,
    total_jobs: 45,
    completed_jobs: 42,
    status: 'active'
  }
  // ... autres experts
])

// Filtrage et pagination
const filteredExperts = computed(() => {
  let filtered = experts.value

  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase()
    filtered = filtered.filter(expert => 
      expert.first_name.toLowerCase().includes(query) ||
      expert.last_name.toLowerCase().includes(query) ||
      expert.email.toLowerCase().includes(query)
    )
  }

  if (statusFilter.value) {
    filtered = filtered.filter(expert => expert.status === statusFilter.value)
  }

  if (serviceFilter.value) {
    filtered = filtered.filter(expert => 
      expert.services.some(service => service.id === serviceFilter.value)
    )
  }

  return filtered
})

const totalExperts = computed(() => filteredExperts.value.length)
const startIndex = computed(() => (currentPage.value - 1) * perPage)
const endIndex = computed(() => Math.min(startIndex.value + perPage, totalExperts.value))

// Actions
const viewExpert = (expert) => {
  // Implémenter la vue détaillée
  console.log('View expert:', expert)
}

const verifyDocuments = (expert) => {
  // Implémenter la vérification des documents
  console.log('Verify documents:', expert)
}

const updateStatus = (expert) => {
  // Implémenter le changement de statut
  console.log('Update status:', expert)
}

const suspendExpert = (expert) => {
  // Implémenter la suspension
  console.log('Suspend expert:', expert)
}

const exportExperts = () => {
  // Implémenter l'export
  console.log('Export experts')
}

definePageMeta({
  layout: 'admin'
})
</script> 