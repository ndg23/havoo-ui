<template>
  <div class="p-6 max-w-7xl mx-auto">
    <!-- En-tête avec titre et compteurs -->
    <div class="flex items-center justify-between mb-6">
      <div>
        <h1 class="text-2xl font-semibold text-gray-900 dark:text-white">Vérification des experts</h1>
        <p class="text-sm text-gray-500 dark:text-gray-400 mt-1">
          Examinez et validez les documents soumis par les experts
        </p>
      </div>
      
      <div class="flex space-x-3">
        <!-- Compteurs de statut -->
        <div class="flex items-center px-4 py-2 bg-yellow-50 dark:bg-yellow-900/20 text-yellow-700 dark:text-yellow-400 rounded-full">
          <Clock class="h-4 w-4 mr-2" />
          <span class="text-sm font-medium">{{ pendingCount || 0 }} en attente</span>
        </div>
        <div class="flex items-center px-4 py-2 bg-green-50 dark:bg-green-900/20 text-green-700 dark:text-green-400 rounded-full">
          <CheckCircle class="h-4 w-4 mr-2" />
          <span class="text-sm font-medium">{{ approvedCount || 0 }} approuvés</span>
        </div>
      </div>
    </div>
    
    <!-- Filtres et recherche -->
    <div class="bg-white dark:bg-gray-800 rounded-xl shadow-sm mb-6 overflow-hidden">
      <div class="p-5 border-b dark:border-gray-700">
        <h2 class="text-lg font-medium text-gray-900 dark:text-white">Filtres</h2>
      </div>
      
      <div class="p-5 grid grid-cols-1 md:grid-cols-3 gap-4">
        <!-- Recherche -->
        <div>
          <label for="search" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Recherche</label>
          <div class="relative">
            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
              <Search class="h-4 w-4 text-gray-400" />
            </div>
            <input
              id="search"
              v-model="search"
              type="text"
              placeholder="Nom, email..."
              class="block w-full pl-10 pr-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
            />
          </div>
        </div>
        
        <!-- Filtre par statut -->
        <div>
          <label for="status-filter" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Statut</label>
          <select
            id="status-filter"
            v-model="statusFilter"
            class="block w-full py-2 pl-3 pr-10 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
          >
            <option value="">Tous les statuts</option>
            <option value="pending">En attente</option>
            <option value="approved">Approuvé</option>
            <option value="rejected">Rejeté</option>
          </select>
        </div>
        
        <!-- Filtre par date -->
        <div>
          <label for="date-filter" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Date de soumission</label>
          <select
            id="date-filter"
            v-model="dateFilter"
            class="block w-full py-2 pl-3 pr-10 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
          >
            <option value="">Toutes les dates</option>
            <option value="today">Aujourd'hui</option>
            <option value="week">Cette semaine</option>
            <option value="month">Ce mois</option>
          </select>
        </div>
      </div>
    </div>
    
    <!-- État de chargement -->
    <div v-if="loading" class="flex justify-center py-20">
      <Loader2 class="h-10 w-10 text-primary-500 animate-spin" />
    </div>
    
    <!-- Liste des demandes de vérification -->
    <div v-else-if="filteredVerifications.length > 0" class="grid grid-cols-1 gap-6">
      <!-- Demande de vérification (Cards pour une meilleure expérience visuelle) -->
      <div 
        v-for="verification in paginatedVerifications" 
        :key="verification.id" 
        class="bg-white dark:bg-gray-800 rounded-xl shadow-sm overflow-hidden"
      >
        <div class="p-6">
          <div class="flex flex-col md:flex-row md:items-center md:justify-between">
            <!-- Informations de l'expert -->
            <div class="flex items-center mb-4 md:mb-0">
              <div class="h-12 w-12 rounded-full bg-gray-200 dark:bg-gray-700 overflow-hidden flex-shrink-0">
                <img 
                  v-if="verification.user.avatar_url" 
                  :src="verification.user.avatar_url" 
                  alt="Avatar" 
                  class="h-full w-full object-cover"
                />
                <User v-else class="h-6 w-6 text-gray-400 m-3" />
              </div>
              
              <div class="ml-4">
                <div class="font-medium text-gray-900 dark:text-white">
                  {{ verification.user.first_name }} {{ verification.user.last_name }}
                </div>
                <div class="text-sm text-gray-500 dark:text-gray-400">
                  {{ verification.user.email }}
                </div>
              </div>
            </div>
            
            <!-- Statut de vérification -->
            <div class="flex items-center">
              <div 
                class="px-3 py-1 rounded-full text-xs font-medium flex items-center"
                :class="{
                  'bg-yellow-100 dark:bg-yellow-900/30 text-yellow-800 dark:text-yellow-400': verification.status === 'pending',
                  'bg-green-100 dark:bg-green-900/30 text-green-800 dark:text-green-400': verification.status === 'approved',
                  'bg-red-100 dark:bg-red-900/30 text-red-800 dark:text-red-400': verification.status === 'rejected'
                }"
              >
                <div 
                  class="h-1.5 w-1.5 rounded-full mr-1.5"
                  :class="{
                    'bg-yellow-500': verification.status === 'pending',
                    'bg-green-500': verification.status === 'approved',
                    'bg-red-500': verification.status === 'rejected'
                  }"
                ></div>
                {{ formatStatus(verification.status) }}
              </div>
              
              <div class="text-xs text-gray-500 dark:text-gray-400 ml-3">
                Soumis le {{ formatDate(verification.submitted_at) }}
              </div>
            </div>
          </div>
          
          <!-- Documents soumis -->
          <div class="mt-6 border-t dark:border-gray-700 pt-6">
            <h3 class="text-sm font-medium text-gray-700 dark:text-gray-300 mb-4">Documents soumis</h3>
            
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
              <div 
                v-for="(document, index) in verification.documents" 
                :key="index"
                class="border dark:border-gray-700 rounded-lg overflow-hidden group relative"
              >
                <!-- Aperçu du document -->
                <div class="aspect-video bg-gray-100 dark:bg-gray-700 relative">
                  <!-- Image preview si c'est une image -->
                  <img 
                    v-if="isImage(document.file_type)" 
                    :src="document.file_url" 
                    alt="Document" 
                    class="w-full h-full object-cover"
                  />
                  
                  <!-- Icône pour les autres types de fichiers -->
                  <div 
                    v-else 
                    class="w-full h-full flex items-center justify-center"
                  >
                    <FileText v-if="document.file_type === 'pdf'" class="h-12 w-12 text-gray-400" />
                    <File v-else class="h-12 w-12 text-gray-400" />
                  </div>
                  
                  <!-- Actions sur le document -->
                  <div class="absolute inset-0 bg-black/60 opacity-0 group-hover:opacity-100 transition-opacity flex items-center justify-center space-x-2">
                    <a 
                      :href="document.file_url" 
                      target="_blank" 
                      class="h-9 w-9 flex items-center justify-center rounded-full bg-white text-gray-700 hover:bg-gray-100"
                    >
                      <ExternalLink class="h-4 w-4" />
                    </a>
                    <button 
                      @click="openDocumentModal(document)" 
                      class="h-9 w-9 flex items-center justify-center rounded-full bg-white text-gray-700 hover:bg-gray-100"
                    >
                      <Maximize2 class="h-4 w-4" />
                    </button>
                  </div>
                </div>
                
                <div class="p-3 bg-white dark:bg-gray-800">
                  <div class="font-medium text-sm text-gray-900 dark:text-white mb-1">
                    {{ document.document_type || 'Document' }}
                  </div>
                  <div class="text-xs text-gray-500 dark:text-gray-400 line-clamp-1">
                    {{ document.file_name || 'Fichier' }}
                  </div>
                </div>
              </div>
            </div>
          </div>
          
          <!-- Actions sur la demande -->
          <div class="mt-6 border-t dark:border-gray-700 pt-6 flex flex-col md:flex-row justify-end items-center space-y-4 md:space-y-0 md:space-x-4">
            <div v-if="verification.status === 'pending'" class="w-full md:w-auto order-last md:order-first">
              <textarea
                v-model="verification.rejection_reason"
                placeholder="Motif de rejet (optionnel)"
                rows="1"
                class="w-full md:w-64 px-3 py-2 text-sm border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
              ></textarea>
            </div>
            
            <div class="flex space-x-3 w-full md:w-auto justify-end">
              <button 
                v-if="verification.status === 'pending'"
                @click="rejectVerification(verification)"
                class="px-4 py-2 rounded-lg text-sm font-medium border border-red-300 text-red-700 bg-white hover:bg-red-50 dark:bg-transparent dark:text-red-400 dark:border-red-700 dark:hover:bg-red-900/20"
              >
                Rejeter
              </button>
              <button 
                v-if="verification.status === 'pending'"
                @click="approveVerification(verification)"
                class="px-4 py-2 rounded-lg text-sm font-medium bg-primary-600 text-white hover:bg-primary-700"
              >
                Approuver
              </button>
              <button 
                v-if="verification.status !== 'pending'"
                @click="resetVerification(verification)"
                class="px-4 py-2 rounded-lg text-sm font-medium border border-gray-300 text-gray-700 bg-white hover:bg-gray-50 dark:bg-transparent dark:text-gray-300 dark:border-gray-600 dark:hover:bg-gray-700"
              >
                Réinitialiser
              </button>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Pagination -->
      <div class="mt-4 flex items-center justify-between">
        <div class="text-sm text-gray-700 dark:text-gray-300">
          Affichage de <span class="font-medium">{{ paginationStart }}</span> à <span class="font-medium">{{ paginationEnd }}</span> sur <span class="font-medium">{{ filteredVerifications.length }}</span> demandes
        </div>
        
        <div class="flex space-x-1">
          <button 
            @click="currentPage = 1" 
            :disabled="currentPage === 1"
            class="px-3 py-1 rounded text-sm font-medium"
            :class="currentPage === 1 ? 'text-gray-400 cursor-not-allowed' : 'text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700'"
          >
            Premier
          </button>
          
          <button 
            v-for="page in displayedPages" 
            :key="page"
            @click="currentPage = typeof page === 'number' ? page : currentPage"
            :disabled="page === '...'"
            class="px-3 py-1 rounded text-sm font-medium"
            :class="[
              page === '...' ? 'text-gray-400 cursor-not-allowed' : '',
              page !== '...' && page === currentPage ? 'bg-primary-600 text-white' : 'text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700'
            ]"
          >
            {{ page }}
          </button>
          
          <button 
            @click="currentPage = totalPages" 
            :disabled="currentPage === totalPages"
            class="px-3 py-1 rounded text-sm font-medium"
            :class="currentPage === totalPages ? 'text-gray-400 cursor-not-allowed' : 'text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700'"
          >
            Dernier
          </button>
        </div>
      </div>
    </div>
    
    <!-- Pas de résultats -->
    <div v-else class="bg-white dark:bg-gray-800 rounded-xl shadow-sm p-12 text-center">
      <FileCheck class="h-16 w-16 mx-auto text-gray-300 dark:text-gray-600 mb-4" />
      <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-2">Aucune demande de vérification trouvée</h3>
      <p class="text-gray-500 dark:text-gray-400 mb-6">
        {{ search || statusFilter || dateFilter ? 'Essayez d\'autres filtres' : 'Toutes les demandes de vérification ont été traitées' }}
      </p>
    </div>
    
    <!-- Modal de prévisualisation de document -->
    <div 
      v-if="showDocumentModal" 
      class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/70"
      @click.self="showDocumentModal = false"
    >
      <div class="bg-white dark:bg-gray-800 rounded-xl shadow-lg overflow-hidden max-w-4xl w-full max-h-[90vh] flex flex-col">
        <div class="px-6 py-4 border-b dark:border-gray-700 flex justify-between items-center">
          <h3 class="font-medium text-gray-900 dark:text-white">
            {{ selectedDocument?.document_type || 'Document' }}
          </h3>
          <button @click="showDocumentModal = false" class="text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200">
            <X class="h-5 w-5" />
          </button>
        </div>
        
        <div class="flex-1 overflow-auto p-6 flex items-center justify-center">
          <img 
            v-if="isImage(selectedDocument?.file_type)" 
            :src="selectedDocument?.file_url" 
            alt="Document" 
            class="max-w-full max-h-[70vh] object-contain"
          />
          
          <div v-else-if="selectedDocument?.file_type === 'pdf'" class="w-full h-[70vh]">
            <iframe :src="selectedDocument?.file_url" class="w-full h-full border-0"></iframe>
          </div>
          
          <div v-else class="text-center text-gray-500 dark:text-gray-400">
            <File class="h-16 w-16 mx-auto mb-4" />
            <p>Ce type de document ne peut pas être prévisualisé</p>
            <a 
              :href="selectedDocument?.file_url" 
              target="_blank" 
              class="mt-4 inline-flex items-center px-4 py-2 rounded-lg text-sm font-medium bg-primary-600 text-white hover:bg-primary-700"
            >
              <Download class="h-4 w-4 mr-2" />
              Télécharger
            </a>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { useSupabaseClient } from '#imports'
import { 
  Search, Clock, CheckCircle, User, FileText, Loader2, 
  File, FileCheck, Maximize2, ExternalLink, X, Download
} from 'lucide-vue-next'

// Client Supabase
const client = useSupabaseClient()

// État local
const verifications = ref([])
const loading = ref(true)
const search = ref('')
const statusFilter = ref('')
const dateFilter = ref('')
const currentPage = ref(1)
const itemsPerPage = 5 // Moins d'éléments par page pour des cards plus détaillées

// État du modal
const showDocumentModal = ref(false)
const selectedDocument = ref(null)

// Compteurs
const pendingCount = computed(() => 
  verifications.value.filter(v => v.status === 'pending').length
)
const approvedCount = computed(() => 
  verifications.value.filter(v => v.status === 'approved').length
)

// Filtrer les vérifications
const filteredVerifications = computed(() => {
  let filtered = verifications.value
  
  // Filtre de recherche
  if (search.value) {
    const searchLower = search.value.toLowerCase()
    filtered = filtered.filter(verification => 
      (verification.user.first_name + ' ' + verification.user.last_name).toLowerCase().includes(searchLower) ||
      verification.user.email.toLowerCase().includes(searchLower)
    )
  }
  
  // Filtre par statut
  if (statusFilter.value) {
    filtered = filtered.filter(verification => verification.status === statusFilter.value)
  }
  
  // Filtre par date
  if (dateFilter.value) {
    const now = new Date()
    const today = new Date(now.getFullYear(), now.getMonth(), now.getDate())
    const weekStart = new Date(today)
    weekStart.setDate(today.getDate() - today.getDay())
    const monthStart = new Date(now.getFullYear(), now.getMonth(), 1)
    
    filtered = filtered.filter(verification => {
      const submittedDate = new Date(verification.submitted_at)
      
      switch (dateFilter.value) {
        case 'today':
          return submittedDate >= today
        case 'week':
          return submittedDate >= weekStart
        case 'month':
          return submittedDate >= monthStart
        default:
          return true
      }
    })
  }
  
  // Tri par date de soumission (les plus récents d'abord)
  return filtered.sort((a, b) => new Date(b.submitted_at) - new Date(a.submitted_at))
})

// Pagination
const totalPages = computed(() => Math.ceil(filteredVerifications.value.length / itemsPerPage))
const paginatedVerifications = computed(() => {
  const start = (currentPage.value - 1) * itemsPerPage
  const end = start + itemsPerPage
  return filteredVerifications.value.slice(start, end)
})

const paginationStart = computed(() => {
  if (filteredVerifications.value.length === 0) return 0
  return (currentPage.value - 1) * itemsPerPage + 1
})

const paginationEnd = computed(() => {
  const end = currentPage.value * itemsPerPage
  return end > filteredVerifications.value.length ? filteredVerifications.value.length : end
})

// Pages à afficher dans la pagination
const displayedPages = computed(() => {
  if (totalPages.value <= 7) {
    return Array.from({ length: totalPages.value }, (_, i) => i + 1)
  }
  
  if (currentPage.value <= 4) {
    return [1, 2, 3, 4, 5, '...', totalPages.value]
  }
  
  if (currentPage.value >= totalPages.value - 3) {
    return [1, '...', totalPages.value - 4, totalPages.value - 3, totalPages.value - 2, totalPages.value - 1, totalPages.value]
  }
  
  return [1, '...', currentPage.value - 1, currentPage.value, currentPage.value + 1, '...', totalPages.value]
})

// Formater la date
const formatDate = (dateString) => {
  if (!dateString) return '—'
  const date = new Date(dateString)
  return date.toLocaleDateString('fr-FR', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  })
}

// Formater le statut de vérification
const formatStatus = (status) => {
  switch (status) {
    case 'pending': return 'En attente'
    case 'approved': return 'Approuvé'
    case 'rejected': return 'Rejeté'
    default: return status
  }
}

// Vérifier si le fichier est une image
const isImage = (fileType) => {
  if (!fileType) return false
  return ['jpg', 'jpeg', 'png', 'gif', 'webp'].includes(fileType.toLowerCase())
}

// Ouvrir le modal de prévisualisation
const openDocumentModal = (document) => {
  selectedDocument.value = document
  showDocumentModal.value = true
}

// Approuver une demande de vérification
const approveVerification = async (verification) => {
  try {
    // Mettre à jour le statut dans la base de données
    const { error } = await client
      .from('expert_verifications')
      .update({ 
        status: 'approved', 
        reviewed_at: new Date().toISOString(),
        rejection_reason: null
      })
      .eq('id', verification.id)
    
    if (error) throw error
    
    // Mettre à jour l'utilisateur comme vérifié
    const { error: userError } = await client
      .from('profiles')
      .update({ is_verified: true })
      .eq('id', verification.user.id)
    
    if (userError) throw userError
    
    // Mettre à jour les données locales
    verification.status = 'approved'
    verification.reviewed_at = new Date().toISOString()
    verification.rejection_reason = null
    
    // Notification de succès
    alert('Expert vérifié avec succès')
  } catch (error) {
    console.error('Erreur lors de l\'approbation:', error)
    alert('Erreur lors de l\'approbation: ' + error.message)
  }
}

// Rejeter une demande de vérification
const rejectVerification = async (verification) => {
  try {
    // Mettre à jour le statut dans la base de données
    const { error } = await client
      .from('expert_verifications')
      .update({ 
        status: 'rejected', 
        reviewed_at: new Date().toISOString(),
        rejection_reason: verification.rejection_reason || 'Documents non conformes'
      })
      .eq('id', verification.id)
    
    if (error) throw error
    
    // Mettre à jour les données locales
    verification.status = 'rejected'
    verification.reviewed_at = new Date().toISOString()
    
    // Notification de succès
    alert('Demande rejetée')
  } catch (error) {
    console.error('Erreur lors du rejet:', error)
    alert('Erreur lors du rejet: ' + error.message)
  }
}

// Réinitialiser une demande de vérification
const resetVerification = async (verification) => {
  try {
    // Mettre à jour le statut dans la base de données
    const { error } = await client
      .from('expert_verifications')
      .update({ 
        status: 'pending', 
        reviewed_at: null,
        rejection_reason: null
      })
      .eq('id', verification.id)
    
    if (error) throw error
    
    // Si l'utilisateur était vérifié, le démarquer
    if (verification.status === 'approved') {
      const { error: userError } = await client
        .from('profiles')
        .update({ is_verified: false })
        .eq('id', verification.user.id)
      
      if (userError) throw userError
    }
    
    // Mettre à jour les données locales
    verification.status = 'pending'
    verification.reviewed_at = null
    verification.rejection_reason = null
    
    // Notification de succès
    alert('Demande réinitialisée')
  } catch (error) {
    console.error('Erreur lors de la réinitialisation:', error)
    alert('Erreur lors de la réinitialisation: ' + error.message)
  }
}

// Chargement des données
const fetchVerifications = async () => {
  try {
    loading.value = true
    
    // Récupérer les demandes de vérification avec les informations utilisateur
    const { data, error } = await client
      .from('expert_verifications')
      .select(`
        id,
        status,
        submitted_at,
        reviewed_at,
        rejection_reason,
        documents,
        user_id,
        user:profiles(id, first_name, last_name, email, avatar_url)
      `)
      .order('submitted_at', { ascending: false })
    
    if (error) throw error
    
    verifications.value = data || []
  } catch (error) {
    console.error('Erreur lors du chargement des vérifications:', error)
  } finally {
    loading.value = false
  }
}

// Réinitialiser la pagination quand les filtres changent
watch([search, statusFilter, dateFilter], () => {
  currentPage.value = 1
})

// Charger les données au montage du composant
onMounted(fetchVerifications)

// Configuration de la page
definePageMeta({
  layout: 'admin'
})
</script> 