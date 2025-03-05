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
            placeholder="Rechercher..."
            class="w-full pl-10 pr-4 py-2 rounded-xl border border-gray-200 focus:ring-primary-500 focus:border-primary-500"
          />
        </div>
        <select 
          v-model="statusFilter"
          class="px-4 py-2 rounded-xl border border-gray-200 focus:ring-primary-500 focus:border-primary-500"
        >
          <option value="">Tous les statuts</option>
          <option value="pending">En attente</option>
          <option value="paid">Payé</option>
          <option value="failed">Échoué</option>
          <option value="refunded">Remboursé</option>
        </select>
        <div class="flex items-center gap-2">
          <input 
            type="date" 
            v-model="dateRange.start"
            class="px-4 py-2 rounded-xl border border-gray-200 focus:ring-primary-500 focus:border-primary-500"
          />
          <span class="text-gray-500">à</span>
          <input 
            type="date" 
            v-model="dateRange.end"
            class="px-4 py-2 rounded-xl border border-gray-200 focus:ring-primary-500 focus:border-primary-500"
          />
        </div>
      </div>
      <button 
        @click="exportPayments"
        class="flex items-center gap-2 px-4 py-2 bg-white border border-gray-200 rounded-xl hover:bg-gray-50"
      >
        <ArrowDownTrayIcon class="w-5 h-5 text-gray-600" />
        <span class="text-sm font-medium text-gray-700">Exporter</span>
      </button>
    </div>

    <!-- Table des paiements -->
    <div class="bg-white rounded-xl border border-gray-200 overflow-hidden">
      <div class="overflow-x-auto">
        <table class="w-full">
          <thead class="bg-gray-50 border-b border-gray-200">
            <tr>
              <th class="px-6 py-4 text-left text-sm font-medium text-gray-500">ID Transaction</th>
              <th class="px-6 py-4 text-left text-sm font-medium text-gray-500">Client</th>
              <th class="px-6 py-4 text-left text-sm font-medium text-gray-500">Service</th>
              <th class="px-6 py-4 text-left text-sm font-medium text-gray-500">Montant</th>
              <th class="px-6 py-4 text-left text-sm font-medium text-gray-500">Date</th>
              <th class="px-6 py-4 text-left text-sm font-medium text-gray-500">Statut</th>
              <th class="px-6 py-4 text-right text-sm font-medium text-gray-500">Actions</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-gray-200">
            <tr v-for="payment in filteredPayments" :key="payment.id" class="hover:bg-gray-50">
              <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                {{ payment.transaction_id }}
              </td>
              <td class="px-6 py-4 whitespace-nowrap">
                <div class="flex items-center gap-3">
                  <img 
                    :src="payment.client.avatar_url || `https://ui-avatars.com/api/?name=${payment.client.name}`"
                    class="w-8 h-8 rounded-full"
                  />
                  <div>
                    <div class="font-medium text-gray-900">{{ payment.client.name }}</div>
                    <div class="text-sm text-gray-500">{{ payment.client.email }}</div>
                  </div>
                </div>
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                {{ payment.service }}
              </td>
              <td class="px-6 py-4 whitespace-nowrap">
                <div class="font-medium text-gray-900">{{ payment.amount }} FCFA</div>
                <div class="text-xs text-gray-500">{{ payment.payment_method }}</div>
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                {{ formatDate(payment.date) }}
              </td>
              <td class="px-6 py-4 whitespace-nowrap">
                <span 
                  class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium"
                  :class="{
                    'bg-yellow-100 text-yellow-800': payment.status === 'pending',
                    'bg-green-100 text-green-800': payment.status === 'paid',
                    'bg-red-100 text-red-800': payment.status === 'failed',
                    'bg-gray-100 text-gray-800': payment.status === 'refunded'
                  }"
                >
                  {{ payment.status }}
                </span>
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-right text-sm">
                <Menu as="div" class="relative inline-block text-left">
                  <MenuButton class="p-2 rounded-lg hover:bg-gray-50">
                    <EllipsisVerticalIcon class="w-5 h-5 text-gray-400" />
                  </MenuButton>
                  <MenuItems class="absolute right-0 mt-2 w-48 bg-white rounded-lg shadow-lg py-1 border border-gray-200">
                    <MenuItem v-slot="{ active }">
                      <button
                        class="flex w-full items-center px-4 py-2 text-sm text-gray-700 hover:bg-gray-50"
                        @click="viewDetails(payment)"
                      >
                        <EyeIcon class="w-4 h-4 mr-3" />
                        Voir les détails
                      </button>
                    </MenuItem>
                    <MenuItem v-if="payment.status === 'pending'" v-slot="{ active }">
                      <button
                        class="flex w-full items-center px-4 py-2 text-sm text-green-600 hover:bg-green-50"
                        @click="markAsPaid(payment)"
                      >
                        <CheckIcon class="w-4 h-4 mr-3" />
                        Marquer comme payé
                      </button>
                    </MenuItem>
                    <MenuItem v-if="payment.status === 'paid'" v-slot="{ active }">
                      <button
                        class="flex w-full items-center px-4 py-2 text-sm text-red-600 hover:bg-red-50"
                        @click="initiateRefund(payment)"
                      >
                        <ArrowUturnLeftIcon class="w-4 h-4 mr-3" />
                        Rembourser
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
          Affichage de {{ startIndex + 1 }}-{{ endIndex }} sur {{ totalPayments }} paiements
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
            :disabled="endIndex >= totalPayments"
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
  EyeIcon,
  CheckIcon,
  ArrowUturnLeftIcon,
  ArrowDownTrayIcon,
  BanknotesIcon,
  ArrowTrendingUpIcon,
  UserGroupIcon,
  ExclamationTriangleIcon
} from '@heroicons/vue/24/outline'

// Stats
const stats = [
  { 
    name: 'Revenus du mois',
    value: '2.1M FCFA',
    icon: BanknotesIcon
  },
  {
    name: 'Croissance',
    value: '+12.5%',
    icon: ArrowTrendingUpIcon
  },
  {
    name: 'Clients actifs',
    value: '234',
    icon: UserGroupIcon
  },
  {
    name: 'Paiements en attente',
    value: '12',
    icon: ExclamationTriangleIcon
  }
]

// État
const searchQuery = ref('')
const statusFilter = ref('')
const dateRange = ref({
  start: '',
  end: ''
})
const currentPage = ref(1)
const perPage = 10

// Données simulées
const payments = ref([
  {
    id: 1,
    transaction_id: 'TRX-001',
    client: {
      name: 'Jean Dupont',
      email: 'jean@example.com',
      avatar_url: null
    },
    service: 'Ménage',
    amount: 15000,
    payment_method: 'Mobile Money',
    date: '2024-01-15T10:00:00Z',
    status: 'paid'
  }
  // ... autres paiements
])

// Filtrage et pagination
const filteredPayments = computed(() => {
  let filtered = payments.value

  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase()
    filtered = filtered.filter(payment => 
      payment.transaction_id.toLowerCase().includes(query) ||
      payment.client.name.toLowerCase().includes(query) ||
      payment.client.email.toLowerCase().includes(query)
    )
  }

  if (statusFilter.value) {
    filtered = filtered.filter(payment => payment.status === statusFilter.value)
  }

  if (dateRange.value.start && dateRange.value.end) {
    filtered = filtered.filter(payment => {
      const paymentDate = new Date(payment.date)
      const start = new Date(dateRange.value.start)
      const end = new Date(dateRange.value.end)
      return paymentDate >= start && paymentDate <= end
    })
  }

  return filtered
})

const totalPayments = computed(() => filteredPayments.value.length)
const startIndex = computed(() => (currentPage.value - 1) * perPage)
const endIndex = computed(() => Math.min(startIndex.value + perPage, totalPayments.value))

// Formatage
const formatDate = (date) => {
  return new Date(date).toLocaleDateString('fr-FR', {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  })
}

// Actions
const viewDetails = (payment) => {
  console.log('View payment:', payment)
}

const markAsPaid = (payment) => {
  console.log('Mark as paid:', payment)
}

const initiateRefund = (payment) => {
  console.log('Initiate refund:', payment)
}

const exportPayments = () => {
  console.log('Export payments')
}

definePageMeta({
  layout: 'admin'
})
</script> 