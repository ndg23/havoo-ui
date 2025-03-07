<template>
  <div>
    <!-- En-tête de la section -->
    <div class="flex justify-between items-center mb-6">
      <h2 class="text-xl font-bold text-gray-900 dark:text-white">Mes demandes</h2>
      
      <NuxtLink 
        to="/requests/create" 
        class="inline-flex items-center px-4 py-2 bg-primary-600 rounded-full text-sm font-medium text-white hover:bg-primary-700"
      >
        <Plus class="h-4 w-4 mr-2" />
        Nouvelle demande
      </NuxtLink>
    </div>
    
    <!-- État de chargement -->
    <div v-if="loading" class="flex justify-center py-12">
      <Loader2 class="h-8 w-8 text-gray-400 animate-spin" />
    </div>
    
    <!-- Affichage des demandes style Instagram -->
    <div v-else-if="myDemands.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      <div 
        v-for="demand in myDemands" 
        :key="demand.id"
        class="bg-white dark:bg-gray-800 rounded-xl overflow-hidden border border-gray-200 dark:border-gray-700 shadow-sm hover:shadow-md transition-shadow"
      >
        <!-- Image de couverture ou couleur de catégorie -->
        <div 
          class="h-40 relative"
          :class="demand.image ? '' : getCategoryColorClass(demand.category_id)"
        >
          <img 
            v-if="demand.image" 
            :src="demand.image" 
            :alt="demand.title"
            class="w-full h-full object-cover"
          />
          
          <!-- Icône de catégorie si pas d'image -->
          <div v-else class="w-full h-full flex items-center justify-center">
            <component 
              :is="getCategoryIcon(demand.category_id)" 
              class="h-12 w-12 text-white"
            />
          </div>
          
          <!-- Badge de statut -->
          <div 
            class="absolute top-3 right-3 px-2 py-1 rounded-full text-xs font-medium"
            :class="getStatusClasses(demand.status)"
          >
            {{ formatStatus(demand.status) }}
          </div>
        </div>
        
        <!-- Contenu -->
        <div class="p-4">
          <h3 class="font-semibold text-gray-900 dark:text-white text-lg mb-1">
            {{ demand.title }}
          </h3>
          
          <div class="flex items-center text-sm text-gray-500 dark:text-gray-400 mb-3">
            <Calendar class="h-3.5 w-3.5 mr-1" />
            <span>{{ formatDate(demand.created_at) }}</span>
            
            <div class="mx-2 h-1 w-1 rounded-full bg-gray-300 dark:bg-gray-600"></div>
            
            <MapPin class="h-3.5 w-3.5 mr-1" />
            <span>{{ demand.location || 'Paris' }}</span>
          </div>
          
          <p class="text-gray-700 dark:text-gray-300 text-sm line-clamp-2 mb-4">
            {{ demand.description }}
          </p>
          
          <!-- Budget -->
          <div class="flex items-center justify-between">
            <div class="text-primary-600 dark:text-primary-400 font-bold">
              {{ demand.budget || '120' }}€
            </div>
            
            <NuxtLink 
              :to="`/requests/${demand.id}`"
              class="text-sm text-gray-700 dark:text-gray-300 hover:text-primary-600 dark:hover:text-primary-400"
            >
              Voir détails
              <ArrowRight class="h-3.5 w-3.5 inline ml-1" />
            </NuxtLink>
          </div>
        </div>
      </div>
    </div>
    
    <!-- Aucune demande -->
    <div 
      v-else
      class="bg-white dark:bg-gray-800 rounded-xl p-8 text-center border border-gray-200 dark:border-gray-700"
    >
      <div class="inline-flex items-center justify-center h-16 w-16 rounded-full bg-gray-100 dark:bg-gray-700 mb-4">
        <FileQuestion class="h-8 w-8 text-gray-500 dark:text-gray-400" />
      </div>
      <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-2">
        Aucune demande trouvée
      </h3>
      <p class="text-gray-600 dark:text-gray-400 mb-6">
        Vous n'avez pas encore créé de demandes de service.
      </p>
      <NuxtLink 
        to="/requests/create" 
        class="inline-flex items-center px-4 py-2 bg-primary-600 rounded-full text-sm font-medium text-white hover:bg-primary-700"
      >
        <Plus class="h-4 w-4 mr-2" />
        Créer une demande
      </NuxtLink>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { format, parseISO } from 'date-fns'
import { fr } from 'date-fns/locale'
import {
  Plus, Loader2, Calendar, MapPin, ArrowRight, FileQuestion,
  Home, Paintbrush, Wrench, Briefcase, FileText, ShieldCheck
} from 'lucide-vue-next'

// Définir le layout
definePageMeta({
  layout: 'account'
})

// États
const client = useSupabaseClient()
const currentUser = useSupabaseUser()
const loading = ref(true)
const myDemands = ref([])

// Charger les demandes de l'utilisateur
const fetchMyDemands = async () => {
  if (!currentUser.value) return
  
  try {
    loading.value = true
    
    const { data, error } = await client
      .from('requests')
      .select('*')
      .eq('user_id', currentUser.value.id)
      .order('created_at', { ascending: false })
    
    if (error) throw error
    
    myDemands.value = data || []
  } catch (error) {
    console.error('Erreur lors du chargement des demandes:', error)
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

// Formatter un statut
const formatStatus = (status) => {
  switch (status) {
    case 'open': return 'Ouverte'
    case 'in_progress': return 'En cours'
    case 'completed': return 'Terminée'
    case 'cancelled': return 'Annulée'
    default: return 'Ouverte'
  }
}

// Classes CSS pour le statut
const getStatusClasses = (status) => {
  switch (status) {
    case 'open': return 'bg-green-100 text-green-800'
    case 'in_progress': return 'bg-blue-100 text-blue-800'
    case 'completed': return 'bg-gray-100 text-gray-800'
    case 'cancelled': return 'bg-red-100 text-red-800'
    default: return 'bg-green-100 text-green-800'
  }
}

// Obtenir l'icône de catégorie
const getCategoryIcon = (categoryId) => {
  const icons = {
    1: Home,
    2: Paintbrush,
    3: Wrench,
    4: Briefcase,
    5: FileText,
    6: ShieldCheck
  }
  
  return icons[categoryId] || Home
}

// Obtenir la classe de couleur pour une catégorie
const getCategoryColorClass = (categoryId) => {
  const colors = {
    1: 'bg-blue-500',
    2: 'bg-purple-500',
    3: 'bg-green-500',
    4: 'bg-yellow-500',
    5: 'bg-red-500',
    6: 'bg-indigo-500'
  }
  
  return colors[categoryId] || 'bg-gray-500'
}

// Initialisation
onMounted(fetchMyDemands)
</script> 