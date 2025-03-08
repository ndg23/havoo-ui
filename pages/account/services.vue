<template>
  <div class="max-w-7xl mx-auto px-4 py-8">
    <!-- En-tête de la page -->
    <div class="mb-8">
      <h1 class="text-2xl font-bold text-gray-900 dark:text-white">Mes services</h1>
      <p class="text-gray-600 dark:text-gray-400 mt-1">Gérez les services que vous proposez en tant qu'expert</p>
    </div>
    
    <!-- Alerte de statut -->
    <ErrorAlert 
      v-if="statusMessage.show"
      :type="statusMessage.type"
      :message="statusMessage.message"
      dismissible
      @dismiss="statusMessage.show = false"
      class="mb-6"
    />
    
    <!-- Filtres et recherche -->
    <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 p-6 mb-8 shadow-sm">
      <div class="flex flex-wrap gap-4 items-end">
        <div class="flex-1 min-w-[250px]">
          <label for="search" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">Rechercher</label>
          <div class="relative">
            <input
              v-model="search"
              type="text"
              id="search"
              placeholder="Rechercher dans mes services..."
              class="w-full px-4 py-2.5 border border-gray-300 dark:border-gray-600 rounded-full shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white pl-10"
            />
            <Search class="absolute left-3 top-3 h-4 w-4 text-gray-400" />
          </div>
        </div>
        
        <div class="w-44">
          <label for="status" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">Statut</label>
          <select
            v-model="statusFilter"
            id="status"
            class="w-full px-4 py-2.5 border border-gray-300 dark:border-gray-600 rounded-full shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white appearance-none bg-no-repeat"
          >
            <option value="all">Tous les statuts</option>
            <option value="active">Actif</option>
            <option value="paused">En pause</option>
            <option value="draft">Brouillon</option>
          </select>
        </div>
        
        <div class="w-52">
          <label for="sort" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">Trier par</label>
          <select
            v-model="sortOption"
            id="sort"
            class="w-full px-4 py-2.5 border border-gray-300 dark:border-gray-600 rounded-full shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white appearance-none bg-no-repeat"
          >
            <option value="recent">Plus récents</option>
            <option value="oldest">Plus anciens</option>
            <option value="price_high">Prix (élevé à bas)</option>
            <option value="price_low">Prix (bas à élevé)</option>
            <option value="popular">Popularité</option>
          </select>
        </div>
        
        <div>
          <NuxtLink 
            to="/services/create" 
            class="h-full px-6 py-2.5 bg-primary-600 hover:bg-primary-700 text-white text-sm font-medium rounded-full transition-colors shadow-sm flex items-center"
          >
            <Plus class="h-4 w-4 mr-1.5" />
            Nouveau service
          </NuxtLink>
        </div>
      </div>
    </div>
    
    <!-- Section de chargement -->
    <div v-if="isLoading" class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 p-16 animate-pulse shadow-sm">
      <div class="flex flex-col items-center justify-center">
        <div class="h-10 w-10 border-4 border-primary-500 border-t-transparent rounded-full animate-spin"></div>
        <p class="mt-4 text-gray-600 dark:text-gray-400 font-medium">Chargement de vos services...</p>
      </div>
    </div>
    
    <!-- Message si aucun service -->
    <div v-else-if="filteredServices.length === 0" class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 p-16 text-center shadow-sm">
      <div class="flex flex-col items-center justify-center">
        <BriefcaseBusiness class="h-16 w-16 text-gray-400 mb-3" />
        <h3 class="text-lg font-medium text-gray-900 dark:text-gray-100 mb-1">Aucun service trouvé</h3>
        <p class="text-gray-600 dark:text-gray-400 max-w-md mb-6">
          {{ search ? `Aucun résultat pour "${search}"` : 'Vous n\'avez pas encore proposé de service.' }}
        </p>
        <NuxtLink 
          to="/services/create" 
          class="px-6 py-2.5 bg-primary-600 hover:bg-primary-700 text-white text-sm font-medium rounded-full transition-colors shadow-sm flex items-center"
        >
          <Plus class="h-4 w-4 mr-1.5" />
          Créer un service
        </NuxtLink>
      </div>
    </div>
    
    <!-- Liste des services -->
    <div v-else class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      <div 
        v-for="service in paginatedServices" 
        :key="service.id" 
        class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 overflow-hidden shadow-sm hover:shadow-md transition-shadow"
      >
        <!-- Image du service avec badge de statut -->
        <div class="relative">
          <img 
            :src="service.image_url || '/img/default-service.jpg'" 
            :alt="service.title"
            class="w-full h-48 object-cover"
          />
          <div class="absolute top-3 left-3">
            <span 
              class="px-3 py-1 text-xs font-medium rounded-full"
              :class="{
                'bg-green-100 text-green-800 dark:bg-green-900/40 dark:text-green-300': service.status === 'active',
                'bg-yellow-100 text-yellow-800 dark:bg-yellow-900/40 dark:text-yellow-300': service.status === 'paused',
                'bg-gray-100 text-gray-800 dark:bg-gray-700 dark:text-gray-300': service.status === 'draft'
              }"
            >
              {{ formatStatus(service.status) }}
            </span>
          </div>
          
          <div class="absolute top-3 right-3">
            <span class="px-3 py-1 bg-primary-100 dark:bg-primary-900/30 text-primary-800 dark:text-primary-300 text-xs font-medium rounded-full">
              {{ getCategoryName(service.category_id) }}
            </span>
          </div>
          
          <!-- Menu d'options rapide -->
          <div class="absolute bottom-3 right-3">
            <div class="relative inline-block">
              <button 
                @click="toggleServiceMenu(service.id)"
                class="bg-white dark:bg-gray-800 rounded-full p-2 shadow-sm border border-gray-200 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-700"
              >
                <MoreVertical class="h-4 w-4 text-gray-600 dark:text-gray-400" />
              </button>
              
              <div 
                v-if="activeMenu === service.id"
                class="absolute right-0 bottom-10 bg-white dark:bg-gray-800 rounded-lg shadow-lg border border-gray-200 dark:border-gray-700 z-10 w-48 py-1"
              >
                <NuxtLink 
                  :to="`/services/${service.id}`"
                  class="flex items-center px-4 py-2 text-sm text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700"
                >
                  <Eye class="h-4 w-4 mr-2 text-gray-500 dark:text-gray-500" />
                  Voir
                </NuxtLink>
                
                <NuxtLink 
                  :to="`/services/edit/${service.id}`"
                  class="flex items-center px-4 py-2 text-sm text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700"
                >
                  <Pencil class="h-4 w-4 mr-2 text-gray-500 dark:text-gray-500" />
                  Modifier
                </NuxtLink>
                
                <button 
                  v-if="service.status === 'active'"
                  @click="updateServiceStatus(service, 'paused')"
                  class="flex items-center w-full text-left px-4 py-2 text-sm text-yellow-600 dark:text-yellow-400 hover:bg-gray-50 dark:hover:bg-gray-700"
                >
                  <Pause class="h-4 w-4 mr-2" />
                  Mettre en pause
                </button>
                
                <button 
                  v-if="service.status === 'paused' || service.status === 'draft'"
                  @click="updateServiceStatus(service, 'active')"
                  class="flex items-center w-full text-left px-4 py-2 text-sm text-green-600 dark:text-green-400 hover:bg-gray-50 dark:hover:bg-gray-700"
                >
                  <Play class="h-4 w-4 mr-2" />
                  Activer
                </button>
                
                <button 
                  v-if="!showDuplicate[service.id]"
                  @click="showDuplicate[service.id] = true"
                  class="flex items-center w-full text-left px-4 py-2 text-sm text-blue-600 dark:text-blue-400 hover:bg-gray-50 dark:hover:bg-gray-700"
                >
                  <Copy class="h-4 w-4 mr-2" />
                  Dupliquer
                </button>
                
                <div 
                  v-if="showDuplicate[service.id]" 
                  class="px-4 py-2 text-sm border-t border-gray-200 dark:border-gray-700"
                >
                  <div class="mb-2 text-gray-700 dark:text-gray-300">Nouveau titre:</div>
                  <input 
                    v-model="duplicateTitles[service.id]" 
                    type="text" 
                    class="w-full px-2 py-1 text-sm border border-gray-300 dark:border-gray-600 rounded-md mb-2"
                    :placeholder="service.title + ' (copie)'"
                  />
                  <div class="flex justify-end space-x-2 mt-2">
                    <button 
                      @click="showDuplicate[service.id] = false"
                      class="px-2 py-1 text-xs text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700 rounded"
                    >
                      Annuler
                    </button>
                    <button 
                      @click="duplicateService(service)"
                      class="px-2 py-1 text-xs bg-primary-600 hover:bg-primary-700 text-white rounded"
                    >
                      Dupliquer
                    </button>
                  </div>
                </div>
                
                <button 
                  @click="confirmDelete(service)"
                  class="flex items-center w-full text-left px-4 py-2 text-sm text-red-600 dark:text-red-400 hover:bg-gray-50 dark:hover:bg-gray-700 border-t border-gray-200 dark:border-gray-700"
                >
                  <Trash2 class="h-4 w-4 mr-2" />
                  Supprimer
                </button>
              </div>
            </div>
          </div>
        </div>
        
        <!-- Contenu du service -->
        <div class="p-5">
          <NuxtLink :to="`/services/${service.id}`">
            <h3 class="text-lg font-semibold text-gray-900 dark:text-white line-clamp-1 hover:text-primary-600 dark:hover:text-primary-400 transition-colors">
              {{ service.title }}
            </h3>
          </NuxtLink>
          
          <p class="mt-2 text-sm text-gray-600 dark:text-gray-400 line-clamp-2">
            {{ service.description }}
          </p>
          
          <div class="mt-4 flex justify-between items-center">
            <div class="text-xl font-bold text-primary-700 dark:text-primary-400">
              {{ service.price ? `${service.price}€` : 'Sur devis' }}
            </div>
            
            <div class="flex items-center">
              <Star class="h-4 w-4 text-yellow-500 mr-1" />
              <span class="text-sm font-medium text-gray-700 dark:text-gray-300">
                {{ service.rating || '0' }}
              </span>
            </div>
          </div>
          
          <!-- Statistiques -->
          <div class="mt-4 grid grid-cols-2 gap-2 text-center text-xs">
            <div class="bg-gray-50 dark:bg-gray-700/50 rounded-lg p-2">
              <div class="font-semibold text-gray-900 dark:text-white">{{ service.order_count || 0 }}</div>
              <div class="text-gray-600 dark:text-gray-400">Commandes</div>
            </div>
            
            <div class="bg-gray-50 dark:bg-gray-700/50 rounded-lg p-2">
              <div class="font-semibold text-gray-900 dark:text-white">{{ service.view_count || 0 }}</div>
              <div class="text-gray-600 dark:text-gray-400">Vues</div>
            </div>
          </div>
          
          <!-- Actions -->
          <div class="mt-5 flex flex-wrap gap-2">
            <NuxtLink 
              :to="`/services/edit/${service.id}`"
              class="flex-1 inline-flex justify-center items-center px-4 py-2 bg-white dark:bg-gray-700 border border-gray-300 dark:border-gray-600 text-gray-700 dark:text-gray-300 text-sm font-medium rounded-full hover:bg-gray-50 dark:hover:bg-gray-600 transition-colors"
            >
              <Pencil class="h-4 w-4 mr-1.5" />
              Modifier
            </NuxtLink>
            
            <NuxtLink 
              :to="`/services/${service.id}`" 
              class="flex-1 inline-flex justify-center items-center px-4 py-2 bg-primary-600 hover:bg-primary-700 text-white text-sm font-medium rounded-full transition-colors"
            >
              <Eye class="h-4 w-4 mr-1.5" />
              Voir
            </NuxtLink>
          </div>
        </div>
      </div>
    </div>
    
    <!-- Pagination -->
    <div v-if="totalPages > 1" class="mt-8 flex justify-center">
      <div class="flex space-x-1">
        <button 
          @click="currentPage = Math.max(1, currentPage - 1)"
          :disabled="currentPage === 1"
          class="px-4 py-2 flex items-center justify-center border border-gray-300 dark:border-gray-700 rounded-full text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700 disabled:opacity-50 disabled:cursor-not-allowed"
        >
          <ChevronLeft class="h-4 w-4" />
        </button>
        
        <button 
          v-for="page in pageRange" 
          :key="page"
          @click="page !== '...' ? currentPage = page : null"
          :class="[
            'h-10 w-10 flex items-center justify-center rounded-full text-sm font-medium',
            page === '...' 
              ? 'text-gray-700 dark:text-gray-300 cursor-default'
              : page === currentPage
                ? 'bg-primary-600 text-white'
                : 'text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700 border border-gray-300 dark:border-gray-700'
          ]"
        >
          {{ page }}
        </button>
        
        <button 
          @click="currentPage = Math.min(totalPages, currentPage + 1)"
          :disabled="currentPage === totalPages"
          class="px-4 py-2 flex items-center justify-center border border-gray-300 dark:border-gray-700 rounded-full text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700 disabled:opacity-50 disabled:cursor-not-allowed"
        >
          <ChevronRight class="h-4 w-4" />
        </button>
      </div>
    </div>
    
    <!-- Bouton "Ajouter un service" dans le style Twitter -->
    <button
      @click="openAddServiceModal"
      class="fixed bottom-20 md:bottom-8 right-8 h-14 w-14 md:h-16 md:w-16 rounded-full bg-primary-500 hover:bg-primary-600 text-white shadow-lg flex items-center justify-center transition-colors focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500"
    >
      <Plus class="h-7 w-7" />
    </button>
    
    <!-- Utilisation du modal -->
    <ServiceModal 
      :show="showServiceModal"
      :service="selectedService"
      @close="closeServiceModal"
      @saved="handleServiceSaved"
    />
    
    <!-- Modal de confirmation de suppression -->
    <Teleport to="body">
      <div v-if="showDeleteModal" class="fixed inset-0 bg-black/60 backdrop-blur-sm z-50 flex items-center justify-center p-4">
        <div @click.stop class="bg-white dark:bg-gray-800 rounded-2xl w-full max-w-md shadow-xl overflow-hidden">
          <div class="px-6 py-4 border-b border-gray-200 dark:border-gray-700 flex justify-between items-center">
            <h3 class="text-lg font-medium text-gray-900 dark:text-white">Confirmer la suppression</h3>
            <button @click="showDeleteModal = false" class="text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200">
              <X class="h-5 w-5" />
            </button>
          </div>
          
          <div class="p-6">
            <div class="flex items-center mb-4 text-red-600 dark:text-red-400 bg-red-50 dark:bg-red-900/20 rounded-lg p-3">
              <AlertTriangle class="h-6 w-6 mr-3" />
              <p class="text-sm font-medium">Cette action est irréversible.</p>
            </div>
            
            <p class="text-gray-600 dark:text-gray-300 mb-4">
              Êtes-vous sûr de vouloir supprimer le service <span class="font-medium text-gray-900 dark:text-white">{{ deleteTarget?.title }}</span> ?
            </p>
            
            <p v-if="deleteTarget?.order_count > 0" class="text-sm text-yellow-600 dark:text-yellow-400 bg-yellow-50 dark:bg-yellow-900/20 p-3 rounded-lg my-4">
              <AlertCircle class="h-4 w-4 inline-block mr-1.5" />
              Ce service a des commandes en cours ou passées.
            </p>
            
            <div class="mt-8 flex justify-end space-x-3">
              <button
                @click="showDeleteModal = false"
                type="button"
                class="px-5 py-2.5 bg-white dark:bg-gray-700 border border-gray-300 dark:border-gray-600 rounded-full text-gray-700 dark:text-gray-300 font-medium hover:bg-gray-50 dark:hover:bg-gray-600 focus:outline-none"
              >
                Annuler
              </button>
              <button
                @click="deleteService"
                type="button"
                class="px-5 py-2.5 bg-red-600 hover:bg-red-700 rounded-full text-white font-medium focus:outline-none flex items-center justify-center min-w-[100px]"
                :disabled="isDeleting"
              >
                <div v-if="isDeleting" class="h-4 w-4 border-2 border-white border-t-transparent rounded-full animate-spin mr-2"></div>
                {{ isDeleting ? 'Suppression...' : 'Supprimer' }}
              </button>
            </div>
          </div>
        </div>
      </div>
    </Teleport>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { useRouter } from 'vue-router'
import { useSupabaseClient } from '#imports'
import { 
  Plus, 
  Search, 
  ChevronLeft, 
  ChevronRight, 
  Eye, 
  Pencil, 
  Trash2, 
  X, 
  Star, 
  Calendar, 
  Clock, 
  BriefcaseBusiness,
  MoreVertical,
  Copy,
  Pause,
  Play,
  AlertTriangle,
  AlertCircle
} from 'lucide-vue-next'
import ServiceModal from '~/components/ServiceModal.vue'

// Router
const router = useRouter()

// États
const services = ref([])
const isLoading = ref(true)
const search = ref('')
const statusFilter = ref('all')
const sortOption = ref('recent')
const currentPage = ref(1)
const perPage = ref(9)
const deleteTarget = ref(null)
const showDeleteModal = ref(false)
const isDeleting = ref(false)
const activeMenu = ref(null)
const showDuplicate = ref({})
const duplicateTitles = ref({})
const statusMessage = ref({
  show: false,
  type: 'info',
  message: ''
})
const showServiceModal = ref(false)
const selectedService = ref(null)

// Supabase
const supabase = useSupabaseClient()

// Filtrer les services
const filteredServices = computed(() => {
  let result = [...services.value]
  
  // Filtrer par recherche
  if (search.value) {
    const searchLower = search.value.toLowerCase()
    result = result.filter(service => 
      (service.title && service.title.toLowerCase().includes(searchLower)) || 
      (service.description && service.description.toLowerCase().includes(searchLower))
    )
  }
  
  // Filtrer par statut
  if (statusFilter.value !== 'all') {
    result = result.filter(service => service.status === statusFilter.value)
  }
  
  // Trier les services
  switch (sortOption.value) {
    case 'recent':
      result.sort((a, b) => new Date(b.created_at || Date.now()) - new Date(a.created_at || Date.now()))
      break
    case 'oldest':
      result.sort((a, b) => new Date(a.created_at || Date.now()) - new Date(b.created_at || Date.now()))
      break
    case 'price_high':
      result.sort((a, b) => (b.price || 0) - (a.price || 0))
      break
    case 'price_low':
      result.sort((a, b) => (a.price || 0) - (b.price || 0))
      break
    case 'popular':
      result.sort((a, b) => (b.view_count || 0) - (a.view_count || 0))
      break
  }
  
  return result
})

// Pagination
const totalPages = computed(() => Math.ceil(filteredServices.value.length / perPage.value))

const pageRange = computed(() => {
  const pages = []
  
  if (totalPages.value > 0) {
    // Toujours afficher la première page
    pages.push(1)
    
    if (totalPages.value <= 7) {
      // Afficher toutes les pages si pas trop nombreuses
      for (let i = 2; i <= totalPages.value; i++) {
        pages.push(i)
      }
    } else if (currentPage.value < 4) {
      // Près du début
      for (let i = 2; i <= 4; i++) {
        pages.push(i)
      }
      pages.push('...')
    } else if (currentPage.value > totalPages.value - 3) {
      // Près de la fin
      pages.push('...')
      for (let i = totalPages.value - 3; i < totalPages.value; i++) {
        pages.push(i)
      }
    } else {
      // Au milieu
      pages.push('...')
      pages.push(currentPage.value - 1)
      pages.push(currentPage.value)
      pages.push(currentPage.value + 1)
      pages.push('...')
    }
    
    // Toujours afficher la dernière page
    if (totalPages.value > 1) {
      pages.push(totalPages.value)
    }
  }
  
  return pages
})

const paginatedServices = computed(() => {
  const start = (currentPage.value - 1) * perPage.value
  const end = start + perPage.value
  return filteredServices.value.slice(start, end)
})

// Charger les services
const fetchServices = async () => {
  isLoading.value = true
  
  try {
    const { data: userData } = await supabase.auth.getUser()
    
    if (!userData?.user) {
      router.push('/auth/login')
      return
    }
    
    const { data, error } = await supabase
      .from('services')
      .select(`
        id, 
        title, 
        description, 
        price, 
        status, 
        category_id, 
        created_at,
        updated_at,
        image_url,
        view_count,
        rating,
        order_count
      `)
      .eq('expert_id', userData.user.id)
      .order('created_at', { ascending: false })
    
    if (error) throw error
    
    services.value = data || []
    
  } catch (error) {
    console.error('Erreur lors du chargement des services:', error)
    showStatusMessage('error', 'Erreur lors du chargement de vos services')
  } finally {
    isLoading.value = false
  }
}

// Formater le statut
const formatStatus = (status) => {
  switch (status) {
    case 'active':
      return 'Actif'
    case 'paused':
      return 'En pause'
    case 'draft':
      return 'Brouillon'
    default:
      return status
  }
}

// Obtenir le nom de la catégorie
const getCategoryName = (categoryId) => {
  const category = categoriesStore.categories.find(c => c.id === categoryId)
  return category ? category.name : 'Catégorie'
}

// Obtenir l'icône de la catégorie
const getCategoryIcon = (categoryId) => {
  const category = categoriesStore.categories.find(c => c.id === categoryId)
  return category ? category.icon : 'Briefcase'
}

// Toggle menu pour un service
const toggleServiceMenu = (serviceId) => {
  if (activeMenu.value === serviceId) {
    activeMenu.value = null
  } else {
    activeMenu.value = serviceId
  }
}

// Mettre à jour le statut d'un service
const updateServiceStatus = async (service, newStatus) => {
  try {
    const { error } = await supabase
      .from('services')
      .update({ status: newStatus, updated_at: new Date().toISOString() })
      .eq('id', service.id)
    
    if (error) throw error
    
    // Mettre à jour localement
    const index = services.value.findIndex(s => s.id === service.id)
    if (index !== -1) {
      services.value[index].status = newStatus
    }
    
    activeMenu.value = null
    showStatusMessage('success', `Service ${newStatus === 'active' ? 'activé' : newStatus === 'paused' ? 'mis en pause' : 'mis en brouillon'}`)
    
  } catch (error) {
    console.error('Erreur lors de la mise à jour du statut:', error)
    showStatusMessage('error', 'Erreur lors de la mise à jour du statut')
  }
}

// Dupliquer un service
const duplicateService = async (service) => {
  try {
    const newTitle = duplicateTitles.value[service.id] || `${service.title} (copie)`
    
    // Créer une copie du service sans l'id, les stats et avec statut brouillon
    const { data, error } = await supabase
      .from('services')
      .insert({
        title: newTitle,
        description: service.description,
        price: service.price,
        category_id: service.category_id,
        expert_id: service.expert_id,
        image_url: service.image_url,
        status: 'draft',
        created_at: new Date().toISOString(),
        updated_at: new Date().toISOString()
      })
      .select()
    
    if (error) throw error
    
    // Ajouter le nouveau service à la liste
    if (data && data.length > 0) {
      services.value.unshift(data[0])
    }
    
    // Réinitialiser
    showDuplicate.value[service.id] = false
    duplicateTitles.value[service.id] = ''
    activeMenu.value = null
    
    showStatusMessage('success', 'Service dupliqué avec succès (en brouillon)')
    
  } catch (error) {
    console.error('Erreur lors de la duplication:', error)
    showStatusMessage('error', 'Erreur lors de la duplication du service')
  }
}

// Confirmer la suppression
const confirmDelete = (service) => {
  deleteTarget.value = service
  showDeleteModal.value = true
  activeMenu.value = null
}

// Supprimer un service
const deleteService = async () => {
  if (!deleteTarget.value) return
  
  isDeleting.value = true
  
  try {
    const { error } = await supabase
      .from('services')
      .delete()
      .eq('id', deleteTarget.value.id)
    
    if (error) throw error
    
    // Mettre à jour la liste des services
    services.value = services.value.filter(service => service.id !== deleteTarget.value.id)
    
    showStatusMessage('success', 'Service supprimé avec succès')
    showDeleteModal.value = false
    deleteTarget.value = null
    
    // Revenir à la page 1 si nécessaire
    if (currentPage.value > totalPages.value && totalPages.value > 0) {
      currentPage.value = totalPages.value
    }
    
  } catch (error) {
    console.error('Erreur lors de la suppression:', error)
    showStatusMessage('error', 'Erreur lors de la suppression du service')
  } finally {
    isDeleting.value = false
  }
}

// Afficher un message de statut
const showStatusMessage = (type, message, duration = 5000) => {
  statusMessage.value = {
    show: true,
    type,
    message
  }
  
  setTimeout(() => {
    statusMessage.value.show = false
  }, duration)
}

// Fermer le menu si on clique ailleurs
const handleClickOutside = (event) => {
  if (activeMenu.value !== null) {
    activeMenu.value = null
  }
}

// Réinitialiser la page quand les filtres changent
watch([search, statusFilter, sortOption], () => {
  currentPage.value = 1
})

// Initialisation
onMounted(() => {
  fetchServices()
  window.addEventListener('click', handleClickOutside)
})

// Nettoyage
onUnmounted(() => {
  window.removeEventListener('click', handleClickOutside)
})

// Vous pouvez ajouter ce bloc en haut de chaque fichier
definePageMeta({
  layout: 'account'
})

// Ouvrir modal pour ajouter un service
const openAddServiceModal = () => {
  selectedService.value = null // Pour une création (pas d'édition)
  showServiceModal.value = true
}

// Ouvrir modal pour éditer un service existant
const editService = (service) => {
  selectedService.value = service
  showServiceModal.value = true
}

// Fermer le modal
const closeServiceModal = () => {
  showServiceModal.value = false
}

// Gérer la sauvegarde d'un service
const handleServiceSaved = (service) => {
  // Mettre à jour la liste des services
  if (selectedService.value) {
    // Mise à jour d'un service existant
    const index = services.value.findIndex(s => s.id === service.id)
    if (index !== -1) {
      services.value[index] = service
    }
  } else {
    // Ajout d'un nouveau service
    services.value.unshift(service)
  }
  
  // Afficher un message de succès
  showStatusMessage('success', selectedService.value 
    ? 'Service mis à jour avec succès' 
    : 'Service créé avec succès'
  )
}
</script>

<style scoped>
/* Style pour empêcher le menu de disparaître lorsqu'on clique dessus */
.menu-popup {
  cursor: default;
}

/* Faire en sorte que les sélecteurs aient une flèche */
select {
  background-position: right 1rem center;
  background-repeat: no-repeat;
  background-size: 1em;
  background-image: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/></svg>');
}
</style> 