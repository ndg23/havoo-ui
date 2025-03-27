<template>
  <div class="min-h-screen bg-white dark:bg-gray-900">
    <!-- Main content -->
    <main class="max-w-2xl mx-auto px-4 py-6">
      <!-- Loading state -->
      <div v-if="isLoading" class="flex flex-col items-center justify-center py-12">
        <Loader2 class="animate-spin h-8 w-8 text-gray-400 mb-4" />
        <p class="text-gray-500">Chargement du service...</p>
      </div>

      <!-- Error state -->
      <div v-else-if="error" class="bg-red-50 dark:bg-red-900/10 p-4 rounded-lg text-red-700 dark:text-red-400 my-6">
        <div class="flex">
          <AlertCircle class="h-5 w-5 text-red-400 dark:text-red-500 mr-3" />
          <p>{{ error }}</p>
        </div>
        <button 
          @click="fetchService" 
          class="mt-3 text-sm font-medium text-red-600 dark:text-red-400 hover:text-red-500"
        >
          Réessayer
        </button>
      </div>

      <!-- Service details -->
      <div v-else-if="service" class="space-y-6">
        <!-- Actions bar -->
        <div class="flex items-center justify-between">
          <NuxtLink 
            to="/account/services" 
            class="inline-flex items-center text-sm font-medium text-gray-600 dark:text-gray-400 hover:text-gray-900 dark:hover:text-gray-200"
          >
            <ArrowLeft class="h-4 w-4 mr-1" />
            Retour aux services
          </NuxtLink>
          
          <div class="flex space-x-2">
            <button 
              v-if="!service.is_active" 
              @click="toggleServiceStatus" 
              class="inline-flex items-center px-3 py-1.5 rounded-full text-xs font-medium bg-primary-50 dark:bg-primary-900/20 text-primary-600 dark:text-primary-400 hover:bg-primary-100 dark:hover:bg-primary-900/30"
              :disabled="isUpdating"
            >
              <Eye class="h-3.5 w-3.5 mr-1" />
              Activer
            </button>
            
            <button 
              v-else 
              @click="toggleServiceStatus" 
              class="inline-flex items-center px-3 py-1.5 rounded-full text-xs font-medium bg-gray-100 dark:bg-gray-800 text-gray-600 dark:text-gray-400 hover:bg-gray-200 dark:hover:bg-gray-700"
              :disabled="isUpdating"
            >
              <EyeOff class="h-3.5 w-3.5 mr-1" />
              Désactiver
            </button>
            
            <NuxtLink 
              :to="`/account/services/edit/${service.id}`" 
              class="inline-flex items-center px-3 py-1.5 rounded-full text-xs font-medium bg-gray-100 dark:bg-gray-800 text-gray-600 dark:text-gray-400 hover:bg-gray-200 dark:hover:bg-gray-700"
            >
              <Edit class="h-3.5 w-3.5 mr-1" />
              Modifier
            </NuxtLink>
          </div>
        </div>
        
        <!-- Service card -->
        <div class="bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-xl overflow-hidden shadow-sm">
          <!-- Service images -->
          <div v-if="service.image_urls && service.image_urls.length > 0" class="relative h-64">
            <img 
              :src="service.image_urls[0]" 
              alt="Image du service" 
              class="w-full h-full object-cover"
            />
            <div 
              v-if="!service.is_active" 
              class="absolute top-3 left-3 bg-gray-900/80 text-white text-xs font-medium px-2 py-1 rounded-md"
            >
              Non publié
            </div>
          </div>
          <div v-else class="bg-gray-100 dark:bg-gray-700 h-48 flex items-center justify-center">
            <Image class="h-12 w-12 text-gray-400 dark:text-gray-500" />
          </div>
          
          <!-- Service content -->
          <div class="p-6">
            <div class="flex items-start justify-between">
              <div>
                <h1 class="text-xl font-bold text-gray-900 dark:text-white">{{ service.title }}</h1>
                <div class="mt-1 flex items-center text-sm text-gray-500 dark:text-gray-400">
                  <MapPin class="h-4 w-4 mr-1" />
                  <span>{{ service.location || 'Emplacement non spécifié' }}</span>
                </div>
              </div>
              <div class="text-right">
                <div class="text-lg font-bold text-primary-600 dark:text-primary-400">
                  {{ formatPrice(service.price) }}
                </div>
                <div class="text-xs text-gray-500 dark:text-gray-400">
                  {{ service.price_type === 'hourly' ? 'par heure' : 'prix fixe' }}
                </div>
              </div>
            </div>
            
            <!-- Category -->
            <div class="mt-4">
              <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-primary-50 dark:bg-primary-900/20 text-primary-700 dark:text-primary-400">
                {{ service.category?.name || 'Catégorie non spécifiée' }}
              </span>
            </div>
            
            <!-- Description -->
            <div class="mt-4">
              <h2 class="text-sm font-medium text-gray-900 dark:text-white">Description</h2>
              <div class="mt-2 prose prose-sm max-w-none text-gray-600 dark:text-gray-300">
                {{ service.description }}
              </div>
            </div>
            
            <!-- Service details -->
            <div class="mt-6 grid grid-cols-2 gap-4">
              <div>
                <h3 class="text-xs font-medium text-gray-500 dark:text-gray-400">Délai de livraison</h3>
                <p class="mt-1 text-sm font-medium text-gray-900 dark:text-white">
                  {{ service.delivery_time ? `${service.delivery_time} jours` : 'Non spécifié' }}
                </p>
              </div>
              <div>
                <h3 class="text-xs font-medium text-gray-500 dark:text-gray-400">Créé le</h3>
                <p class="mt-1 text-sm font-medium text-gray-900 dark:text-white">
                  {{ formatDate(service.created_at) }}
                </p>
              </div>
            </div>
          </div>
        </div>
        
        <!-- Service stats -->
        <div class="grid grid-cols-3 gap-4">
          <div class="bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-lg p-4">
            <h3 class="text-xs font-medium text-gray-500 dark:text-gray-400">Vues</h3>
            <p class="mt-1 text-xl font-semibold text-gray-900 dark:text-white">{{ serviceStats.views || 0 }}</p>
          </div>
          <div class="bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-lg p-4">
            <h3 class="text-xs font-medium text-gray-500 dark:text-gray-400">Demandes</h3>
            <p class="mt-1 text-xl font-semibold text-gray-900 dark:text-white">{{ serviceStats.missions || 0 }}</p>
          </div>
          <div class="bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-lg p-4">
            <h3 class="text-xs font-medium text-gray-500 dark:text-gray-400">Contrats</h3>
            <p class="mt-1 text-xl font-semibold text-gray-900 dark:text-white">{{ serviceStats.contracts || 0 }}</p>
          </div>
        </div>
      </div>
    </main>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useSupabaseClient } from '#imports'
import { 
  Loader2, 
  AlertCircle, 
  ArrowLeft, 
  Eye, 
  EyeOff, 
  Edit, 
  Image, 
  MapPin 
} from 'lucide-vue-next'

const route = useRoute()
const supabase = useSupabaseClient()
const serviceId = route.params.id

// État
const service = ref(null)
const serviceStats = ref({
  views: 0,
  missions: 0,
  contracts: 0
})
const isLoading = ref(true)
const isUpdating = ref(false)
const error = ref(null)

// Récupérer les détails du service
const fetchService = async () => {
  isLoading.value = true
  error.value = null
  
  try {
    const { data, error: fetchError } = await supabase
      .from('services')
      .select(`
        *,
        category:profession_id (id, name)
      `)
      .eq('id', serviceId)
      .single()
    
    if (fetchError) throw fetchError
    
    service.value = data
    
    // Récupérer les statistiques du service
    await fetchServiceStats()
  } catch (err) {
    console.error('Error fetching service:', err)
    error.value = "Impossible de charger les détails du service. Veuillez réessayer."
  } finally {
    isLoading.value = false
  }
}

// Récupérer les statistiques du service
const fetchServiceStats = async () => {
  try {
    // Exemple: compter les vues (à adapter selon votre schéma)
    const { count: viewsCount, error: viewsError } = await supabase
      .from('service_views')
      .select('id', { count: 'exact' })
      .eq('service_id', serviceId)
    
    if (!viewsError) {
      serviceStats.value.views = viewsCount || 0
    }
    
    // Exemple: compter les demandes liées à ce service
    const { count: missionsCount, error: missionsError } = await supabase
      .from('missions')
      .select('id', { count: 'exact' })
      .eq('service_id', serviceId)
    
    if (!missionsError) {
      serviceStats.value.missions = missionsCount || 0
    }
    
    // Exemple: compter les contrats liés à ce service
    const { count: contractsCount, error: contractsError } = await supabase
      .from('contracts')
      .select('id', { count: 'exact' })
      .eq('service_id', serviceId)
    
    if (!contractsError) {
      serviceStats.value.contracts = contractsCount || 0
    }
  } catch (err) {
    console.error('Error fetching service stats:', err)
  }
}

// Activer/désactiver un service
const toggleServiceStatus = async () => {
  if (!service.value) return
  
  isUpdating.value = true
  
  try {
    const newStatus = !service.value.is_active
    
    const { error: updateError } = await supabase
      .from('services')
      .update({ is_active: newStatus })
      .eq('id', service.value.id)
    
    if (updateError) throw updateError
    
    // Mettre à jour localement
    service.value.is_active = newStatus
  } catch (err) {
    console.error('Error updating service status:', err)
    error.value = "Une erreur est survenue lors de la mise à jour du statut du service"
  } finally {
    isUpdating.value = false
  }
}

// Formater le prix
const formatPrice = (price) => {
  if (!price) return 'Prix non défini'
  return new Intl.NumberFormat('fr-FR', {
    style: 'currency',
    currency: 'XOF',
    maximumFractionDigits: 0
  }).format(price)
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

// Initialisation
onMounted(() => {
  fetchService()
})

definePageMeta({
  middleware: ['auth'],
  layout: 'account'
})
</script>

<style scoped>
.prose {
  max-width: 65ch;
}
</style>
