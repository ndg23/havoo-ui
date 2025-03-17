<template>
  <div class="max-w-4xl mx-auto px-4 py-6">
    <div class="flex justify-between items-center mb-5">
      <h1 class="text-xl font-bold">Mes Contrats</h1>
    </div>

    <!-- Notification de succès après finalisation d'un contrat -->
    <div 
      v-if="successMessage" 
      class="mb-6 bg-green-50 border-l-4 border-green-500 text-green-700 dark:bg-green-900/30 dark:text-green-400 dark:border-green-500 p-4 rounded-lg flex items-start"
    >
      <CheckCircleIcon class="h-5 w-5 mr-3 flex-shrink-0 mt-0.5" />
      <div>
        <p class="font-medium">{{ successMessage }}</p>
        <p class="text-sm mt-1">Le paiement a été traité et la mission est maintenant terminée.</p>
      </div>
    </div>

    <!-- Filtres -->
    <div class="flex overflow-x-auto gap-2 mb-5 py-1">
      <button 
        v-for="filter in statusFilters" 
        :key="filter.value"
        @click="activeFilter = filter.value"
        class="px-3 py-1.5 rounded-full text-sm whitespace-nowrap"
        :class="activeFilter === filter.value ? 
          'bg-primary-100 text-primary-800 dark:bg-primary-900/30 dark:text-primary-400' : 
          'bg-gray-100 text-gray-800 dark:bg-gray-800 dark:text-gray-400'"
      >
        {{ filter.label }}
        <span class="ml-1 text-xs opacity-70">
          {{ getContractCountByStatus(filter.value) }}
        </span>
      </button>
    </div>

    <!-- Chargement -->
    <div v-if="isLoading" class="py-10 flex justify-center">
      <svg class="animate-spin h-6 w-6 text-primary-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
      </svg>
    </div>

    <!-- Aucun contrat -->
    <div v-else-if="contracts.length === 0" class="border border-gray-200 dark:border-gray-700 rounded-xl p-5 text-center">
      <div class="inline-flex items-center justify-center p-3 bg-gray-100 dark:bg-gray-800 rounded-full mb-3">
        <ClipboardIcon class="h-5 w-5 text-gray-500" />
      </div>
      <h3 class="text-lg font-medium mb-1">Aucun contrat actif</h3>
      <p class="text-gray-500 text-sm mb-4">
        {{ isExpert ? 
          "Vous n'avez pas encore de contrats en cours. Proposez vos services pour obtenir des missions." : 
          "Vous n'avez pas encore de contrats en cours. Contactez un expert pour démarrer une mission." 
        }}
      </p>
      <NuxtLink 
        :to="isExpert ? '/requests' : '/services'" 
        class="px-4 py-2 bg-primary-600 text-white rounded-full text-sm font-medium"
      >
        {{ isExpert ? 'Voir les demandes' : 'Trouver un expert' }}
      </NuxtLink>
    </div>

    <!-- Liste des contrats -->
    <div v-else class="space-y-3">
      <div 
        v-for="contract in filteredContracts" 
        :key="contract.id"
        class="border border-gray-200 dark:border-gray-700 rounded-xl overflow-hidden"
      >
        <div class="p-4">
          <div class="flex justify-between items-start">
            <div>
              <h3 class="font-medium">{{ contract.title }}</h3>
              <div class="flex flex-wrap gap-1.5 mt-1.5">
                <span 
                  class="inline-flex items-center px-2 py-0.5 rounded-full text-xs font-medium"
                  :class="getStatusClass(contract.status)"
                >
                  {{ formatStatus(contract.status) }}
                </span>
              </div>
            </div>
            <div class="text-right">
              <div class="font-medium">{{ contract.amount }}€</div>
              <div class="text-xs text-gray-500 mt-1">
                Créé le {{ formatDate(contract.created_at) }}
              </div>
            </div>
          </div>
          
          <div class="flex items-center mt-4 pb-4 border-b border-gray-200 dark:border-gray-700">
            <div class="w-8 h-8 rounded-full bg-gray-200 dark:bg-gray-700 flex items-center justify-center">
              <UserIcon class="h-4 w-4 text-gray-500 dark:text-gray-400" />
            </div>
            <div class="ml-3">
              <p class="text-sm font-medium">
                {{ isExpert ? 'Client' : 'Expert' }}
              </p>
              <p class="text-sm text-gray-600 dark:text-gray-400">
                {{ isExpert ? contract.client_name : contract.expert_name }}
              </p>
            </div>
          </div>
          
          <div class="grid grid-cols-2 gap-4 mt-3 text-sm">
            <div>
              <span class="text-gray-500">Service:</span>
              <span class="font-medium ml-1">{{ contract.service_name }}</span>
            </div>
            <div v-if="contract.completed_at">
              <span class="text-gray-500">Terminé le:</span>
              <span class="font-medium ml-1">{{ formatDate(contract.completed_at) }}</span>
            </div>
          </div>
        </div>
        
        <!-- Actions -->
        <div class="border-t border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-800/50 px-4 py-3 flex justify-between items-center">
          <NuxtLink 
            :to="`/account/contracts/${contract.id}`"
            class="text-sm text-primary-600 dark:text-primary-400 hover:underline"
          >
            Voir les détails
          </NuxtLink>
          
          <div class="flex gap-2">
            <!-- Bouton de finalisation pour les contrats en cours -->
            <NuxtLink 
              v-if="contract.status === 'in_progress'"
              :to="`/account/contracts/${contract.id}/complete`"
              class="px-3 py-1.5 bg-primary-600 text-white text-sm rounded-full inline-flex items-center"
            >
              <CheckIcon class="h-4 w-4 mr-1" />
              Finaliser
            </NuxtLink>
            
            <!-- Bouton de contact -->
            <button 
              class="px-3 py-1.5 text-sm rounded-full border border-gray-300 dark:border-gray-600 hover:bg-gray-100 dark:hover:bg-gray-700 inline-flex items-center"
            >
              <MessageSquare class="h-4 w-4 mr-1" />
              Message
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useSupabaseClient, useSupabaseUser } from '#imports'
// import { useToast } from 'vue-toastification'
import {
  CheckCircleIcon,
  UserIcon,
  CalendarIcon,
  MessageSquareIcon as MessageSquare,
  CheckIcon,
  ClipboardIcon,
} from 'lucide-vue-next'

const supabase = useSupabaseClient()
const user = useSupabaseUser()
const router = useRouter()
const route = useRoute()
const toast = useToast()

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

// Compter les contrats par statut
const getContractCountByStatus = (status) => {
  if (status === 'all') {
    return contracts.value.length
  }
  
  return contracts.value.filter(contract => contract.status === status).length
}

// Vérifier si l'utilisateur est un expert
const checkUserRole = async () => {
  try {
    const { data, error } = await supabase
      .from('profiles')
      .select('is_expert')
      .eq('id', user.value.id)
      .single()
    
    if (error) throw error
    
    isExpert.value = data.is_expert
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
        service:service_id(title)
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
      client_name: `${contract.client.first_name} ${contract.client.last_name}`,
      expert_name: `${contract.expert.first_name} ${contract.expert.last_name}`,
      service_name: contract.service?.title || 'Service sans titre'
    }))
    
    // Vérifier s'il y a un message de succès dans l'URL
    checkSuccessMessage()
    
  } catch (err) {
    console.error('Erreur lors du chargement des contrats:', err)
    toast.error('Erreur lors du chargement des contrats')
  } finally {
    isLoading.value = false
  }
}

// Vérifier s'il y a un message de succès dans l'URL
const checkSuccessMessage = () => {
  if (route.query.success === 'completion') {
    successMessage.value = 'Le contrat a été finalisé avec succès!'
    
    // Effacer le paramètre de l'URL
    const { success, ...params } = route.query
    router.replace({ query: params })
    
    // Effacer le message après 5 secondes
    setTimeout(() => {
      successMessage.value = ''
    }, 5000)
  }
}

// Formater la date
const formatDate = (dateString) => {
  if (!dateString) return ''
  
  const date = new Date(dateString)
  return new Intl.DateTimeFormat('fr-FR', {
    day: 'numeric',
    month: 'long',
    year: 'numeric'
  }).format(date)
}

// Formater le statut
const formatStatus = (status) => {
  switch (status) {
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
    case 'in_progress':
      return 'bg-blue-100 text-blue-800 dark:bg-blue-900/30 dark:text-blue-400'
    case 'completed':
      return 'bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-400'
    case 'cancelled':
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
  middleware: ['auth'],
  layout: 'account'
})
</script> 