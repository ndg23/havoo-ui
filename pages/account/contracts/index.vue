<template>
  <div class="max-w-4xl mx-auto">
  

    <!-- Notification de succès après finalisation d'un contrat -->
    <div 
      v-if="successMessage" 
      class="mb-6 bg-green-100 dark:bg-green-900/30 border-l-4 border-green-500 text-green-700 dark:text-green-400 p-4 rounded-lg flex items-start"
    >
      <CheckCircle class="h-5 w-5 mr-3 flex-shrink-0 mt-0.5" />
      <div>
        <p class="font-medium">{{ successMessage }}</p>
        <p class="text-sm mt-1">Le paiement a été traité et la mission est maintenant terminée.</p>
      </div>
    </div>

    <!-- Chargement -->
    <div v-if="isLoading" class="bg-white dark:bg-gray-800 rounded-xl p-8 shadow-sm text-center">
      <div class="inline-block h-8 w-8 animate-spin rounded-full border-4 border-solid border-primary-500 border-r-transparent"></div>
      <p class="mt-3 text-gray-600 dark:text-gray-400">Chargement de vos contrats...</p>
    </div>

    <!-- Aucun contrat -->
    <div v-else-if="contracts.length === 0" class="bg-white dark:bg-gray-800 rounded-xl p-8 text-center border border-gray-200 dark:border-gray-700">
      <div class="inline-flex items-center justify-center h-16 w-16 rounded-full bg-gray-100 dark:bg-gray-700 mb-4">
        <ClipboardList class="h-8 w-8 text-gray-500 dark:text-gray-400" />
      </div>
      <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-2">Aucun contrat actif</h3>
      <p class="text-gray-600 dark:text-gray-400 mb-6 max-w-md mx-auto">
        {{ isExpert ? 
          "Vous n'avez pas encore de contrats en cours. Proposez vos services pour obtenir des missions." : 
          "Vous n'avez pas encore de contrats en cours. Contactez un expert pour démarrer une mission." 
        }}
      </p>
      <NuxtLink 
        :to="isExpert ? '/requests' : '/services'" 
        class="px-5 py-2.5 bg-primary-600 hover:bg-primary-700 text-white text-sm font-medium rounded-full shadow-sm"
      >
        {{ isExpert ? 'Voir les demandes' : 'Trouver un expert' }}
      </NuxtLink>
    </div>

    <!-- Liste des contrats -->
    <div v-else>
      <!-- Filtres -->
      <div class="mb-6 flex items-center space-x-4 overflow-x-auto py-2">
        <button 
          v-for="filter in statusFilters" 
          :key="filter.value"
          @click="activeFilter = filter.value"
          class="px-4 py-2 rounded-full text-sm font-medium transition-colors whitespace-nowrap"
          :class="activeFilter === filter.value ? 
            'bg-primary-600 text-white' : 
            'bg-white dark:bg-gray-800 text-gray-700 dark:text-gray-300 border border-gray-300 dark:border-gray-600 hover:bg-gray-50 dark:hover:bg-gray-700'"
        >
          {{ filter.label }}
          <span class="ml-1.5 bg-white bg-opacity-20 text-white px-1.5 py-0.5 rounded-full text-xs">
            {{ getContractCountByStatus(filter.value) }}
          </span>
        </button>
      </div>

      <!-- Contrats -->
      <div class="space-y-4">
        <div 
          v-for="contract in filteredContracts" 
          :key="contract.id"
          class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 overflow-hidden hover:shadow-md transition-all"
        >
          <div class="p-5">
            <div class="flex items-center justify-between mb-4">
              <div>
                <h3 class="text-lg font-bold text-gray-900 dark:text-white">{{ contract.title }}</h3>
                <div class="flex items-center mt-1 text-sm text-gray-600 dark:text-gray-400">
                  <CalendarIcon class="h-4 w-4 mr-1.5" />
                  <span>Créé le {{ formatDate(contract.created_at) }}</span>
                </div>
              </div>
              
              <div 
                class="px-3 py-1 rounded-full text-xs font-medium"
                :class="getStatusClass(contract.status)"
              >
                {{ formatStatus(contract.status) }}
              </div>
            </div>
            
            <div class="flex items-center mb-4 pb-4 border-b border-gray-200 dark:border-gray-700">
              <div class="w-10 h-10 rounded-full bg-primary-100 dark:bg-primary-900/30 flex items-center justify-center">
                <UserIcon class="h-5 w-5 text-primary-600 dark:text-primary-400" />
              </div>
              <div class="ml-3">
                <p class="text-sm font-medium text-gray-900 dark:text-white">
                  {{ isExpert ? 'Client' : 'Expert' }}
                </p>
                <p class="text-sm text-gray-600 dark:text-gray-400">
                  {{ isExpert ? contract.client_name : contract.expert_name }}
                </p>
              </div>
            </div>
            
            <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-2 text-sm">
              <div>
                <span class="text-gray-600 dark:text-gray-400">Montant:</span>
                <span class="font-medium text-gray-900 dark:text-white ml-1">{{ contract.amount }}€</span>
              </div>
              <div>
                <span class="text-gray-600 dark:text-gray-400">Service:</span>
                <span class="font-medium text-gray-900 dark:text-white ml-1">{{ contract.service_name }}</span>
              </div>
              <div v-if="contract.completed_at">
                <span class="text-gray-600 dark:text-gray-400">Terminé le:</span>
                <span class="font-medium text-gray-900 dark:text-white ml-1">{{ formatDate(contract.completed_at) }}</span>
              </div>
            </div>
          </div>
          
          <!-- Actions -->
          <div class="border-t border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-800 px-5 py-3 flex justify-between items-center">
            <div>
              <NuxtLink 
                :to="`/account/contracts/${contract.id}`"
                class="text-sm text-primary-600 dark:text-primary-400 hover:text-primary-700 dark:hover:text-primary-300 font-medium"
              >
                Voir les détails
              </NuxtLink>
            </div>
            
            <div class="flex gap-2">
              <!-- Bouton de finalisation pour les contrats en cours -->
              <NuxtLink 
                v-if="contract.status === 'in_progress'"
                :to="`/account/contracts/${contract.id}/complete`"
                class="px-4 py-2 bg-primary-600 hover:bg-primary-700 text-white text-sm font-medium rounded-md shadow-sm transition-colors"
              >
                <CheckIcon class="h-4 w-4 inline-block mr-1.5" />
                Finaliser
              </NuxtLink>
              
              <!-- Bouton de contact -->
              <button 
                class="px-4 py-2 bg-white dark:bg-gray-700 text-gray-700 dark:text-gray-300 text-sm font-medium rounded-md border border-gray-300 dark:border-gray-600 hover:bg-gray-50 dark:hover:bg-gray-600 transition-colors"
              >
                <MessageSquare class="h-4 w-4 inline-block mr-1.5" />
                Message
              </button>
            </div>
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
  CheckCircle,
  UserIcon,
  CalendarIcon,
  MessageSquare,
  CheckIcon,
  ClipboardList
} from 'lucide-vue-next'
import AccountHeader from '~/components/account/AccountHeader.vue'

const supabase = useSupabaseClient()
const user = useSupabaseUser()
const router = useRouter()
const route = useRoute()

// États
const isLoading = ref(true)
const contracts = ref([])
const activeFilter = ref('all')
const isExpert = ref(false)
const successMessage = ref('')

// Filtres disponibles
const statusFilters = [
  { label: 'Tous', value: 'all' },
  { label: 'En cours', value: 'in_progress' },
  { label: 'Terminés', value: 'completed' }
]

// Contrats filtrés
const filteredContracts = computed(() => {
  if (activeFilter.value === 'all') {
    return contracts.value
  }
  
  return contracts.value.filter(contract => contract.status === activeFilter.value)
})

// Vérifier si l'utilisateur est un expert
const checkUserRole = async () => {
  try {
    const { data, error } = await supabase
      .from('users')
      .select('role')
      .eq('id', user.value.id)
      .single()
    
    if (error) throw error
    
    isExpert.value = data.role === 'expert'
  } catch (err) {
    console.error('Erreur lors de la vérification du rôle:', err)
  }
}

// Récupérer les contrats
const fetchContracts = async () => {
  isLoading.value = true
  
  try {
    await checkUserRole()
    
    let query = supabase
      .from('contracts')
      .select(`
        *,
        client:client_id(first_name, last_name, avatar_url),
        expert:expert_id(first_name, last_name, avatar_url),
        request:request_id(title, description)
      `)
    
    // Filtrer selon l'utilisateur
    if (isExpert.value) {
      query = query.eq('expert_id', user.value.id)
    } else {
      query = query.eq('client_id', user.value.id)
    }
    
    // Trier par date
    query = query.order('created_at', { ascending: false })
    
    const { data, error } = await query
    
    if (error) throw error
    
    contracts.value = data.map(contract => ({
      ...contract,
      title: contract.title || contract.request?.title || 'Contrat sans titre',
      counterparty_name: isExpert.value 
        ? `${contract.client.first_name} ${contract.client.last_name}`
        : `${contract.expert.first_name} ${contract.expert.last_name}`,
      counterparty_avatar: isExpert.value 
        ? contract.client.avatar_url
        : contract.expert.avatar_url,
      formatted_price: new Intl.NumberFormat('fr-FR', { style: 'currency', currency: 'EUR' }).format(contract.price)
    }))
    
    // Vérifier s'il y a un message de succès dans l'URL
    checkSuccessMessage()
    
  } catch (err) {
    console.error('Erreur lors du chargement des contrats:', err)
  } finally {
    isLoading.value = false
  }
}

// Compter les contrats par statut
const getContractCountByStatus = (status) => {
  if (status === 'all') {
    return contracts.value.length
  }
  
  return contracts.value.filter(contract => contract.status === status).length
}

// Vérifier les paramètres d'URL pour afficher un message de succès
const checkSuccessMessage = () => {
  if (route.query.success === 'completed') {
    successMessage.value = 'Contrat finalisé avec succès!'
    
    // Effacer le message après 5 secondes
    setTimeout(() => {
      successMessage.value = ''
      router.replace({ path: route.path })
    }, 5000)
  }
}

// Formater une date
const formatDate = (dateString) => {
  if (!dateString) return 'Non spécifiée'
  
  const date = new Date(dateString)
  return new Intl.DateTimeFormat('fr-FR', {
    day: 'numeric',
    month: 'long',
    year: 'numeric'
  }).format(date)
}

// Formater le statut d'un contrat
const formatStatus = (status) => {
  switch (status) {
    case 'pending':
      return 'En attente'
    case 'in_progress':
      return 'En cours'
    case 'completed':
      return 'Terminé'
    case 'cancelled':
      return 'Annulé'
    default:
      return status
  }
}

// Obtenir la classe CSS pour le statut
const getStatusClass = (status) => {
  switch (status) {
    case 'pending':
      return 'bg-amber-100 text-amber-800 dark:bg-amber-900/30 dark:text-amber-400'
    case 'in_progress':
      return 'bg-blue-100 text-blue-800 dark:bg-blue-900/30 dark:text-blue-400'
    case 'completed':
      return 'bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-400'
    case 'cancelled':
      return 'bg-red-100 text-red-800 dark:bg-red-900/30 dark:text-red-400'
    default:
      return 'bg-gray-100 text-gray-800 dark:bg-gray-700 dark:text-gray-400'
  }
}

// Initialisation
onMounted(() => {
  fetchContracts()
})

definePageMeta({
  layout: 'account'
})
</script> 