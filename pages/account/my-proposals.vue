<template>
  <div>
    <!-- En-tête de la section -->
    <div class="flex justify-between items-center mb-6">
      <h2 class="text-xl font-bold text-gray-900 dark:text-white">Mes propositions</h2>
      
      <NuxtLink 
        to="/experts/profile" 
        class="inline-flex items-center px-4 py-2 bg-primary-600 rounded-full text-sm font-medium text-white hover:bg-primary-700"
      >
        <User class="h-4 w-4 mr-2" />
        Mon profil expert
      </NuxtLink>
    </div>
    
    <!-- État de chargement -->
    <div v-if="loading" class="flex justify-center py-12">
      <Loader2 class="h-8 w-8 text-gray-400 animate-spin" />
    </div>
    
    <!-- Affichage des propositions -->
    <div v-else-if="myProposals.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      <div 
        v-for="proposal in myProposals" 
        :key="proposal.id"
        class="bg-white dark:bg-gray-800 rounded-xl overflow-hidden border border-gray-200 dark:border-gray-700 shadow-sm hover:shadow-md transition-shadow"
      >
        <!-- En-tête avec client et statut -->
        <div class="p-4 border-b border-gray-100 dark:border-gray-700 flex justify-between items-start">
          <div class="flex items-center">
            <div class="h-10 w-10 rounded-full bg-gray-200 dark:bg-gray-700 flex items-center justify-center mr-3">
              <User class="h-5 w-5 text-gray-500 dark:text-gray-400" />
            </div>
            <div>
              <div class="font-medium text-gray-900 dark:text-white">{{ proposal.client_name }}</div>
              <div class="text-xs text-gray-500 dark:text-gray-400">{{ formatDate(proposal.created_at) }}</div>
            </div>
          </div>
          
          <div 
            class="px-2 py-1 rounded-full text-xs font-medium"
            :class="getStatusClasses(proposal.status)"
          >
            {{ formatStatus(proposal.status) }}
          </div>
        </div>
        
        <!-- Détails de la demande -->
        <div class="p-4">
          <h3 class="font-semibold text-gray-900 dark:text-white text-lg mb-2">
            {{ proposal.request_title }}
          </h3>
          
          <div class="flex items-center gap-4 mb-3">
            <div class="flex items-center text-sm text-gray-600 dark:text-gray-400">
              <Calendar class="h-3.5 w-3.5 mr-1" />
              {{ formatDate(proposal.deadline) }}
            </div>
            
            <div class="flex items-center text-sm text-gray-600 dark:text-gray-400">
              <MapPin class="h-3.5 w-3.5 mr-1" />
              {{ proposal.location || 'Paris' }}
            </div>
          </div>
          
          <div class="mb-3 px-3 py-1.5 inline-block rounded-full bg-primary-50 dark:bg-primary-900/20 text-primary-700 dark:text-primary-400 font-medium text-sm">
            {{ proposal.price || '120' }}€
          </div>
          
          <div class="mt-2">
            <p class="text-sm text-gray-600 dark:text-gray-400 line-clamp-2">
              {{ proposal.message }}
            </p>
          </div>
        </div>
        
        <!-- Actions -->
        <div class="p-4 border-t border-gray-100 dark:border-gray-700 flex justify-between items-center">
          <div class="text-xs text-gray-500 dark:text-gray-400">
            {{ proposal.updated_at ? `Modifiée ${formatTimeAgo(proposal.updated_at)}` : '' }}
          </div>
          
          <NuxtLink 
            :to="`/requests/${proposal.request_id}`"
            class="text-sm text-primary-600 dark:text-primary-400 hover:underline flex items-center"
          >
            Voir détails
            <ArrowRight class="h-3.5 w-3.5 ml-1" />
          </NuxtLink>
        </div>
      </div>
    </div>
    
    <!-- Aucune proposition -->
    <div 
      v-else
      class="bg-white dark:bg-gray-800 rounded-xl p-8 text-center border border-gray-200 dark:border-gray-700"
    >
      <div class="inline-flex items-center justify-center h-16 w-16 rounded-full bg-gray-100 dark:bg-gray-700 mb-4">
        <ClipboardX class="h-8 w-8 text-gray-500 dark:text-gray-400" />
      </div>
      <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-2">
        Aucune proposition trouvée
      </h3>
      <p class="text-gray-600 dark:text-gray-400 mb-6">
        Vous n'avez pas encore fait de propositions aux demandes de service.
      </p>
      <NuxtLink 
        to="/requests" 
        class="inline-flex items-center px-4 py-2 bg-primary-600 rounded-full text-sm font-medium text-white hover:bg-primary-700"
      >
        <Search class="h-4 w-4 mr-2" />
        Explorer les demandes
      </NuxtLink>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { format, parseISO, formatDistance } from 'date-fns'
import { fr } from 'date-fns/locale'
import {
  User, Loader2, Calendar, MapPin, ArrowRight, ClipboardX,
  Search
} from 'lucide-vue-next'

// Définir le layout
definePageMeta({
  layout: 'account'
})

// Définir un titre de page
useHead({
  title: 'Mes propositions | Havoo Services'
})

// États
const supabase = useSupabaseClient()
const currentUser = useSupabaseUser()
const loading = ref(true)
const myProposals = ref([])

// Charger les propositions de l'utilisateur
const fetchMyProposals = async () => {
  if (!currentUser.value) return
  
  try {
    loading.value = true
    
    const { data, error } = await supabase
      .from('proposals')
      .select(`
        *,
        requests (
          id,
          title,
          location,
          deadline,
          user_id,
          users (
            first_name,
            last_name
          )
        )
      `)
      .eq('expert_id', currentUser.value.id)
      .order('created_at', { ascending: false })
    
    if (error) throw error
    
    // Transformer les données pour faciliter l'affichage
    myProposals.value = data.map(proposal => ({
      id: proposal.id,
      request_id: proposal.request_id,
      request_title: proposal.requests?.title || 'Demande sans titre',
      client_name: `${proposal.requests?.users?.first_name || ''} ${proposal.requests?.users?.last_name || ''}`.trim() || 'Client inconnu',
      location: proposal.requests?.location,
      deadline: proposal.requests?.deadline,
      created_at: proposal.created_at,
      updated_at: proposal.updated_at,
      price: proposal.price,
      message: proposal.message,
      status: proposal.status
    }))
  } catch (error) {
    console.error('Erreur lors du chargement des propositions:', error)
  } finally {
    loading.value = false
  }
}

// Formatter une date
const formatDate = (dateString) => {
  if (!dateString) return 'Date inconnue'
  
  try {
    return format(parseISO(dateString), 'dd MMM yyyy', { locale: fr })
  } catch (e) {
    return dateString
  }
}

// Formatter un temps relatif (il y a...)
const formatTimeAgo = (dateString) => {
  if (!dateString) return ''
  
  try {
    return formatDistance(parseISO(dateString), new Date(), { 
      addSuffix: true,
      locale: fr
    })
  } catch (e) {
    return ''
  }
}

// Formatter un statut
const formatStatus = (status) => {
  switch (status) {
    case 'pending': return 'En attente'
    case 'accepted': return 'Acceptée'
    case 'rejected': return 'Refusée'
    case 'completed': return 'Terminée'
    default: return 'En attente'
  }
}

// Classes CSS pour le statut
const getStatusClasses = (status) => {
  switch (status) {
    case 'pending': return 'bg-yellow-100 text-yellow-800 dark:bg-yellow-900/30 dark:text-yellow-400'
    case 'accepted': return 'bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-400'
    case 'rejected': return 'bg-red-100 text-red-800 dark:bg-red-900/30 dark:text-red-400'
    case 'completed': return 'bg-gray-100 text-gray-800 dark:bg-gray-900/30 dark:text-gray-400'
    default: return 'bg-yellow-100 text-yellow-800 dark:bg-yellow-900/30 dark:text-yellow-400'
  }
}

// Initialisation
onMounted(fetchMyProposals)

// Vous pouvez ajouter ce bloc en haut de chaque fichier
definePageMeta({
  layout: 'account'
})
</script> 