<template>
  <div class="max-w-4xl mx-auto px-4 pt-5 pb-16">
    <!-- En-tête de la page -->
    <AccountHeader 
      title="Mes services" 
      subtitle="Gérez les services que vous proposez" 
    />

    <!-- Redirection si non expert -->
    <div v-if="!isExpert" class="bg-white dark:bg-gray-800 rounded-xl p-8 text-center border border-gray-200 dark:border-gray-700 mb-7">
      <div class="mb-4 flex justify-center">
        <div class="bg-amber-100 dark:bg-amber-900/30 p-4 rounded-full">
          <AlertTriangle class="h-8 w-8 text-amber-600 dark:text-amber-400" />
        </div>
      </div>
      <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-2">Mode Expert nécessaire</h3>
      <p class="text-gray-600 dark:text-gray-400 mb-6 max-w-md mx-auto">
        Cette section est réservée aux experts. Activez le mode expert dans votre profil pour proposer vos services.
      </p>
      <NuxtLink to="/account" class="px-5 py-2.5 bg-primary-600 hover:bg-primary-700 text-white text-sm font-medium rounded-full shadow-sm">
        Retour au profil
      </NuxtLink>
    </div>

    <template v-else>
      <!-- Stats et filtres -->
      <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-7">
        <div class="bg-white dark:bg-gray-800 rounded-xl p-4 border border-gray-200 dark:border-gray-700 text-center">
          <div class="text-2xl font-bold text-gray-900 dark:text-gray-100">{{ services.length }}</div>
          <div class="text-xs font-medium text-gray-600 dark:text-gray-400">Services publiés</div>
        </div>
        <div class="bg-white dark:bg-gray-800 rounded-xl p-4 border border-gray-200 dark:border-gray-700 text-center">
          <div class="text-2xl font-bold text-gray-900 dark:text-gray-100">{{ totalViews }}</div>
          <div class="text-xs font-medium text-gray-600 dark:text-gray-400">Vues totales</div>
        </div>
        <div class="bg-white dark:bg-gray-800 rounded-xl p-4 border border-gray-200 dark:border-gray-700 text-center">
          <div class="text-2xl font-bold text-amber-600 dark:text-amber-400">{{ totalRequests }}</div>
          <div class="text-xs font-medium text-gray-600 dark:text-gray-400">Demandes reçues</div>
        </div>
      </div>

      <!-- Recherche et filtres -->
      <div class="mb-7 flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div class="flex items-center gap-2">
          <button 
            @click="activeFilter = 'all'"
            class="px-4 py-2 rounded-full text-sm font-medium transition-all"
            :class="activeFilter === 'all' ? 'bg-primary-100 text-primary-800 dark:bg-primary-900/30 dark:text-primary-400' : 'bg-gray-100 text-gray-800 dark:bg-gray-800 dark:text-gray-400 hover:bg-gray-200'"
          >
            Tous
          </button>
          <button 
            @click="activeFilter = 'active'"
            class="px-4 py-2 rounded-full text-sm font-medium transition-all"
            :class="activeFilter === 'active' ? 'bg-primary-100 text-primary-800 dark:bg-primary-900/30 dark:text-primary-400' : 'bg-gray-100 text-gray-800 dark:bg-gray-800 dark:text-gray-400 hover:bg-gray-200'"
          >
            Actifs
          </button>
          <button 
            @click="activeFilter = 'draft'"
            class="px-4 py-2 rounded-full text-sm font-medium transition-all"
            :class="activeFilter === 'draft' ? 'bg-primary-100 text-primary-800 dark:bg-primary-900/30 dark:text-primary-400' : 'bg-gray-100 text-gray-800 dark:bg-gray-800 dark:text-gray-400 hover:bg-gray-200'"
          >
            Brouillons
          </button>
        </div>

        <div class="relative">
          <Search class="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-gray-400" />
          <input 
            type="text" 
            placeholder="Rechercher dans mes services..."
            v-model="searchQuery"
            class="pl-10 pr-4 py-2 w-full sm:w-64 rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-800 dark:text-gray-200 focus:ring-2 focus:ring-primary-500 focus:border-primary-500 dark:focus:ring-primary-600 dark:focus:border-primary-600"
          />
        </div>
      </div>

      <!-- Chargement -->
      <div v-if="isLoading" class="bg-white dark:bg-gray-800 rounded-xl p-12 flex flex-col items-center">
        <div class="h-10 w-10 border-4 border-primary-500 border-t-transparent rounded-full animate-spin"></div>
        <p class="mt-4 text-gray-600 dark:text-gray-400">Chargement de vos services...</p>
      </div>

      <!-- Aucun service -->
      <div v-else-if="filteredServices.length === 0" class="bg-white dark:bg-gray-800 rounded-xl p-8 text-center border border-gray-200 dark:border-gray-700">
        <div class="mb-4 flex justify-center">
          <div class="bg-gray-100 dark:bg-gray-700 p-4 rounded-full">
            <Package class="h-8 w-8 text-gray-500 dark:text-gray-400" />
          </div>
        </div>
        <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-2">Aucun service trouvé</h3>
        <p class="text-gray-600 dark:text-gray-400 mb-6">
          {{ activeFilter === 'all' 
            ? "Vous n'avez pas encore créé de service. Commencez à proposer votre expertise." 
            : activeFilter === 'active' 
            ? "Vous n'avez aucun service actif actuellement."
            : "Vous n'avez aucun service en brouillon." 
          }}
        </p>
        <button 
          @click="showAddModal = true"
          class="px-5 py-2.5 bg-primary-600 hover:bg-primary-700 text-white text-sm font-medium rounded-full shadow-sm inline-flex items-center"
        >
          <Plus class="h-4 w-4 mr-2" />
          Créer un service
        </button>
      </div>

      <!-- Liste des services -->
      <div v-else class="space-y-4">
        <div v-for="service in filteredServices" :key="service.id" 
          class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 overflow-hidden hover:shadow-md transition-shadow duration-200">
          <div class="p-5">
            <div class="flex flex-col sm:flex-row sm:items-center gap-4">
              <!-- Image du service -->
              <div class="h-20 w-20 sm:h-24 sm:w-24 bg-gray-200 dark:bg-gray-700 rounded-lg overflow-hidden shrink-0">
                <img 
                  v-if="service.image_url" 
                  :src="service.image_url" 
                  :alt="service.title" 
                  class="h-full w-full object-cover"
                />
                <Image v-else class="h-full w-full p-6 text-gray-400" />
              </div>
              
              <!-- Informations du service -->
              <div class="flex-1">
                <div class="flex flex-wrap gap-2 mb-1">
                  <span 
                    class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium"
                    :class="service.status === 'active' 
                      ? 'bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-400' 
                      : 'bg-gray-100 text-gray-800 dark:bg-gray-700 dark:text-gray-400'"
                  >
                    {{ service.status === 'active' ? 'Publié' : 'Brouillon' }}
                  </span>
                  <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-primary-100 text-primary-800 dark:bg-primary-900/30 dark:text-primary-400">
                    {{ service.category }}
                  </span>
                </div>
                
                <h3 class="text-lg font-medium text-gray-900 dark:text-white">{{ service.title }}</h3>
              </div>
            </div>
          </div>
        </div>
      </div>
    </template>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { Briefcase, Plus, AlertTriangle, Search, Image } from 'lucide-vue-next'
import AccountHeader from '~/components/account/AccountHeader.vue'

const supabase = useSupabaseClient()
const services = ref([])
const totalViews = ref(0)
const totalRequests = ref(0)
const isExpert = ref(true)
const showAddModal = ref(false)
const activeFilter = ref('all')
const searchQuery = ref('')
const isLoading = ref(false)

const fetchServices = async () => {
  try {
    isLoading.value = true
    const { data: servicesData } = await supabase
      .from('services')
      .select('*')
    
    if (servicesData) {
      services.value = servicesData
      totalViews.value = servicesData.reduce((total, service) => total + service.views, 0)
      totalRequests.value = servicesData.reduce((total, service) => total + service.requests, 0)
    }
  } catch (error) {
    console.error('Erreur lors de la récupération des services:', error)
    alert('Erreur lors de la récupération des services')
  } finally {
    isLoading.value = false
  }
}

const uploadServiceImage = async (serviceId) => {
  const input = document.createElement('input')
  input.type = 'file'
  input.accept = 'image/*'
  
  input.onchange = async (e) => {
    const file = e.target.files[0]
    if (!file) return
    
    try {
      // Créer un nom de fichier unique
      const fileExt = file.name.split('.').pop()
      const fileName = `${serviceId}-${Date.now()}.${fileExt}`
      const filePath = `services/${fileName}`
      
      // Upload du fichier
      const { error: uploadError } = await supabase.storage
        .from('services')
        .upload(filePath, file)
      
      if (uploadError) throw uploadError
      
      // Obtenir l'URL publique
      const { data: { publicUrl } } = supabase.storage
        .from('services')
        .getPublicUrl(filePath)
      
      // Mettre à jour le service
      const { error: updateError } = await supabase
        .from('services')
        .update({
          image_url: publicUrl
        })
        .eq('id', serviceId)
      
      if (updateError) throw updateError
      
      // Mise à jour locale
      const serviceIndex = services.value.findIndex(s => s.id === serviceId)
      if (serviceIndex !== -1) {
        services.value[serviceIndex].image_url = publicUrl
      }
      
    } catch (error) {
      console.error('Erreur lors de l\'upload de l\'image:', error)
      alert('Erreur lors de l\'upload de l\'image')
    }
  }
  
  input.click()
}

const filteredServices = ref([])

const applyFilters = () => {
  filteredServices.value = services.value.filter(service => {
    const statusMatch = activeFilter.value === 'all' || service.status === activeFilter.value
    const queryMatch = searchQuery.value.length === 0 || service.title.toLowerCase().includes(searchQuery.value.toLowerCase())
    return statusMatch && queryMatch
  })
}

onMounted(() => {
  fetchServices()
  applyFilters()
})

definePageMeta({
  layout: 'account'
})
</script>

<style scoped>
/* Animation des composants */
.rounded-xl {
  animation: fadeIn 0.4s ease;
  animation-fill-mode: both;
}

.space-y-4 > div {
  animation: fadeIn 0.4s ease;
  animation-fill-mode: both;
}

.space-y-4 > div:nth-child(1) { animation-delay: 0.05s; }
.space-y-4 > div:nth-child(2) { animation-delay: 0.1s; }
.space-y-4 > div:nth-child(3) { animation-delay: 0.15s; }
.space-y-4 > div:nth-child(4) { animation-delay: 0.2s; }
.space-y-4 > div:nth-child(5) { animation-delay: 0.25s; }

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(8px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* Améliorer l'apparence du focus */
input:focus, select:focus, textarea:focus {
  outline: none;
}

/* Empêcher le redimensionnement des textarea */
textarea {
  resize: none;
}
</style> 