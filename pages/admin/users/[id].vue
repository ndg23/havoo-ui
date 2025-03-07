<template>
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
    <!-- En-tête avec navigation retour -->
    <div class="flex items-center mb-8">
      <button 
        @click="router.back()" 
        class="flex items-center text-gray-600 hover:text-gray-900"
      >
        <ChevronLeft class="h-5 w-5 mr-1" />
        <span>Retour</span>
      </button>
      
      <h1 class="text-2xl font-bold text-gray-900 ml-4">
        Détails de l'utilisateur
      </h1>
      
      <div class="ml-auto flex gap-2">
        <button
          @click="editUser"
          class="px-4 py-2 rounded-lg flex items-center bg-gray-100 text-gray-700 hover:bg-gray-200"
        >
          <Edit class="h-4 w-4 mr-2" />
          Modifier
        </button>
        
        <button
          @click="confirmDelete"
          class="px-4 py-2 rounded-lg flex items-center bg-red-50 text-red-600 hover:bg-red-100"
        >
          <Trash class="h-4 w-4 mr-2" />
          Supprimer
        </button>
      </div>
    </div>
    
    <!-- Affichage du chargement -->
    <div v-if="loading" class="py-32 flex flex-col items-center justify-center">
      <Loader2 class="h-8 w-8 text-gray-400 animate-spin mb-4" />
      <p class="text-gray-500">Chargement des informations...</p>
    </div>
    
    <!-- Message d'erreur -->
    <div v-else-if="error" class="py-32 flex flex-col items-center justify-center">
      <AlertCircle class="h-12 w-12 text-red-500 mb-4" />
      <h3 class="text-lg font-medium text-gray-900 mb-2">Utilisateur non trouvé</h3>
      <p class="text-gray-500">
        Impossible de trouver les détails de cet utilisateur. Il a peut-être été supprimé.
      </p>
      <button 
        @click="router.push('/admin/users')" 
        class="mt-6 px-4 py-2 bg-gray-900 text-white rounded-lg hover:bg-gray-800"
      >
        Retour à la liste
      </button>
    </div>
    
    <!-- Contenu principal -->
    <div v-else-if="user" class="bg-white rounded-xl shadow-sm overflow-hidden">
      <!-- En-tête du profil -->
      <div class="p-6 border-b border-gray-200 flex items-center">
        <div class="h-16 w-16 rounded-full bg-gray-100 overflow-hidden flex-shrink-0">
          <img 
            v-if="user.avatar_url" 
            :src="user.avatar_url" 
            alt="Avatar" 
            class="h-full w-full object-cover"
          />
          <User v-else class="h-8 w-8 text-gray-400 m-4" />
        </div>
        
        <div class="ml-5">
          <h2 class="text-xl font-semibold text-gray-900">
            {{ user.first_name }} {{ user.last_name }}
          </h2>
          <div class="text-sm text-gray-500">{{ user.email }}</div>
          
          <div class="flex mt-2 gap-2">
            <span 
              class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium"
              :class="{
                'bg-blue-100 text-blue-800': user.role === 'admin',
                'bg-purple-100 text-purple-800': user.role === 'expert',
                'bg-gray-100 text-gray-800': user.role === 'client'
              }"
            >
              {{ formatRole(user.role) }}
            </span>
            
            <span 
              class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium"
              :class="{
                'bg-green-100 text-green-800': user.status === 'active',
                'bg-yellow-100 text-yellow-800': user.status === 'pending',
                'bg-red-100 text-red-800': user.status === 'blocked'
              }"
            >
              {{ formatStatus(user.status) }}
            </span>
          </div>
        </div>
        
        <div class="ml-auto">
          <div class="text-sm text-gray-500">
            Inscrit le {{ formatDate(user.created_at) }}
          </div>
        </div>
      </div>
      
      <!-- Informations principales -->
      <div class="grid grid-cols-1 md:grid-cols-2 gap-6 p-6">
        <div class="space-y-6">
          <div>
            <h3 class="text-lg font-medium text-gray-900 mb-4">Informations personnelles</h3>
            
            <div class="space-y-4">
              <div class="flex">
                <span class="text-sm font-medium text-gray-500 w-32">Nom complet</span>
                <span class="text-sm text-gray-900">{{ user.first_name }} {{ user.last_name }}</span>
              </div>
              
              <div class="flex">
                <span class="text-sm font-medium text-gray-500 w-32">Email</span>
                <span class="text-sm text-gray-900">{{ user.email }}</span>
              </div>
              
              <div class="flex">
                <span class="text-sm font-medium text-gray-500 w-32">Téléphone</span>
                <span class="text-sm text-gray-900">{{ user.phone || '—' }}</span>
              </div>
              
              <div class="flex">
                <span class="text-sm font-medium text-gray-500 w-32">Adresse</span>
                <span class="text-sm text-gray-900">{{ user.address || '—' }}</span>
              </div>
              
              <div class="flex">
                <span class="text-sm font-medium text-gray-500 w-32">Ville</span>
                <span class="text-sm text-gray-900">{{ user.city || '—' }}</span>
              </div>
              
              <div class="flex">
                <span class="text-sm font-medium text-gray-500 w-32">Code postal</span>
                <span class="text-sm text-gray-900">{{ user.zip_code || '—' }}</span>
              </div>
            </div>
          </div>
          
          <div v-if="user.role === 'expert'">
            <h3 class="text-lg font-medium text-gray-900 mb-4">Informations expert</h3>
            
            <div class="space-y-4">
              <div class="flex">
                <span class="text-sm font-medium text-gray-500 w-32">Tarif horaire</span>
                <span class="text-sm text-gray-900">{{ user.hourly_rate ? `${user.hourly_rate}€/h` : '—' }}</span>
              </div>
              
              <div class="flex">
                <span class="text-sm font-medium text-gray-500 w-32">Disponibilité</span>
                <span class="text-sm text-gray-900">{{ user.availability_status || '—' }}</span>
              </div>
              
              <div class="flex">
                <span class="text-sm font-medium text-gray-500 w-32">Vérification</span>
                <span 
                  class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium"
                  :class="{
                    'bg-green-100 text-green-800': user.verification_status === 'verified',
                    'bg-yellow-100 text-yellow-800': user.verification_status === 'pending',
                    'bg-red-100 text-red-800': user.verification_status === 'rejected'
                  }"
                >
                  {{ formatVerificationStatus(user.verification_status) }}
                </span>
              </div>
              
              <div class="flex">
                <span class="text-sm font-medium text-gray-500 w-32">Note moyenne</span>
                <span class="flex items-center text-sm">
                  <Star 
                    class="h-4 w-4 text-yellow-400 mr-1" 
                    :fill="user.rating ? true : false" 
                  />
                  {{ user.rating || '—' }}
                </span>
              </div>
            </div>
          </div>
        </div>
        
        <div>
          <h3 class="text-lg font-medium text-gray-900 mb-4">Activité récente</h3>
          
          <div v-if="activities.length > 0" class="space-y-4">
            <div 
              v-for="activity in activities" 
              :key="activity.id"
              class="flex p-3 rounded-lg bg-gray-50"
            >
              <div class="h-8 w-8 rounded-full bg-gray-200 flex items-center justify-center mr-3">
                <component :is="getActivityIcon(activity.type)" class="h-4 w-4 text-gray-500" />
              </div>
              
              <div>
                <div class="text-sm font-medium">{{ activity.title }}</div>
                <div class="text-xs text-gray-500">{{ formatDate(activity.created_at) }}</div>
              </div>
            </div>
          </div>
          
          <div v-else class="text-center py-8 text-gray-500">
            Aucune activité récente
          </div>
          
          <!-- Statistiques -->
          <div class="mt-6">
            <h3 class="text-lg font-medium text-gray-900 mb-4">Statistiques</h3>
            
            <div class="grid grid-cols-2 gap-4">
              <div class="bg-gray-50 p-4 rounded-lg">
                <div class="text-sm text-gray-500">Demandes</div>
                <div class="text-xl font-semibold">{{ stats.requests || 0 }}</div>
              </div>
              
              <div class="bg-gray-50 p-4 rounded-lg">
                <div class="text-sm text-gray-500">Propositions</div>
                <div class="text-xl font-semibold">{{ stats.proposals || 0 }}</div>
              </div>
              
              <div class="bg-gray-50 p-4 rounded-lg">
                <div class="text-sm text-gray-500">Contrats</div>
                <div class="text-xl font-semibold">{{ stats.contracts || 0 }}</div>
              </div>
              
              <div class="bg-gray-50 p-4 rounded-lg">
                <div class="text-sm text-gray-500">Avis</div>
                <div class="text-xl font-semibold">{{ stats.reviews || 0 }}</div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    
    <!-- Modal de confirmation de suppression -->
    <ConfirmModal
      :show="showDeleteModal"
      title="Supprimer cet utilisateur ?"
      @close="showDeleteModal = false"
    >
      <p class="text-gray-700 mb-4">
        Cette action est irréversible et supprimera définitivement toutes les données de cet utilisateur.
      </p>
      
      <div class="bg-gray-50 p-4 rounded-lg mb-4">
        <div class="font-medium">{{ user?.first_name }} {{ user?.last_name }}</div>
        <div class="text-sm text-gray-500">{{ user?.email }}</div>
      </div>
      
      <template #footer>
        <div class="flex justify-end gap-3">
          <button
            @click="showDeleteModal = false"
            class="px-4 py-2 bg-white border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50"
          >
            Annuler
          </button>
          
          <button
            @click="deleteUser"
            class="px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700"
            :class="{ 'opacity-75 cursor-not-allowed': deleting }"
            :disabled="deleting"
          >
            <span v-if="deleting" class="flex items-center">
              <Loader2 class="animate-spin h-4 w-4 mr-2" />
              Suppression...
            </span>
            <span v-else>Supprimer</span>
          </button>
        </div>
      </template>
    </ConfirmModal>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useSupabaseClient } from '#imports'
import { 
  ChevronLeft, Edit, Trash, User, Star, AlertCircle, Loader2,
  MessageCircle, FileText, CreditCard, Check, X, ShoppingBag,
  Calendar, Clock, Briefcase, Heart
} from 'lucide-vue-next'
import ConfirmModal from '@/components/admin/ConfirmModal.vue'

const router = useRouter()
const route = useRoute()
const client = useSupabaseClient()

const userId = route.params.id
const user = ref(null)
const loading = ref(true)
const error = ref(null)
const showDeleteModal = ref(false)
const deleting = ref(false)
const activities = ref([])
const stats = ref({
  requests: 0,
  proposals: 0,
  contracts: 0,
  reviews: 0
})

// Charger les données de l'utilisateur
onMounted(async () => {
  try {
    loading.value = true
    
    // Récupérer les détails de l'utilisateur
    const { data, error: fetchError } = await client
      .from('profiles')
      .select('*')
      .eq('id', userId)
      .single()
    
    if (fetchError) throw fetchError
    
    if (!data) {
      error.value = 'Utilisateur non trouvé'
    } else {
      user.value = data
      
      // Charger les activités (simulation)
      activities.value = generateMockActivities()
      
      // Charger les statistiques (simulation)
      stats.value = await fetchUserStats()
    }
  } catch (err) {
    console.error('Erreur lors du chargement des données:', err)
    error.value = err.message
  } finally {
    loading.value = false
  }
})

// Fonction pour générer des activités simulées
const generateMockActivities = () => {
  const types = ['message', 'contract', 'request', 'proposal', 'review']
  const results = []
  
  const count = Math.floor(Math.random() * 5) + 1
  
  for (let i = 0; i < count; i++) {
    const type = types[Math.floor(Math.random() * types.length)]
    results.push({
      id: `activity-${i}`,
      type,
      title: getActivityTitle(type),
      created_at: new Date(Date.now() - Math.random() * 7 * 24 * 60 * 60 * 1000).toISOString()
    })
  }
  
  return results.sort((a, b) => new Date(b.created_at) - new Date(a.created_at))
}

// Obtenir les statistiques de l'utilisateur
const fetchUserStats = async () => {
  // Dans une vraie application, vous feriez des requêtes à la base de données
  // Pour cet exemple, nous générons des données aléatoires
  return {
    requests: Math.floor(Math.random() * 20),
    proposals: Math.floor(Math.random() * 15),
    contracts: Math.floor(Math.random() * 10),
    reviews: Math.floor(Math.random() * 8)
  }
}

// Obtenir le titre d'une activité
const getActivityTitle = (type) => {
  switch (type) {
    case 'message':
      return 'A envoyé un message'
    case 'contract':
      return 'A signé un contrat'
    case 'request':
      return 'A créé une nouvelle demande'
    case 'proposal':
      return 'A envoyé une proposition'
    case 'review':
      return 'A laissé un avis'
    default:
      return 'Activité'
  }
}

// Obtenir l'icône d'une activité
const getActivityIcon = (type) => {
  switch (type) {
    case 'message':
      return MessageCircle
    case 'contract':
      return FileText
    case 'request':
      return ShoppingBag
    case 'proposal':
      return Briefcase
    case 'review':
      return Star
    default:
      return Clock
  }
}

// Formater le rôle
const formatRole = (role) => {
  switch (role) {
    case 'admin':
      return 'Administrateur'
    case 'expert':
      return 'Expert'
    case 'client':
      return 'Client'
    default:
      return role
  }
}

// Formater le statut
const formatStatus = (status) => {
  switch (status) {
    case 'active':
      return 'Actif'
    case 'pending':
      return 'En attente'
    case 'blocked':
      return 'Bloqué'
    default:
      return status
  }
}

// Formater le statut de vérification
const formatVerificationStatus = (status) => {
  switch (status) {
    case 'verified':
      return 'Vérifié'
    case 'pending':
      return 'En attente'
    case 'rejected':
      return 'Rejeté'
    default:
      return status
  }
}

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

// Éditer l'utilisateur
const editUser = () => {
  // Rediriger vers la page d'édition ou ouvrir un modal
  alert('Fonctionnalité d\'édition à implémenter')
}

// Confirmer la suppression
const confirmDelete = () => {
  showDeleteModal.value = true
}

// Supprimer l'utilisateur
const deleteUser = async () => {
  try {
    deleting.value = true
    
    // Supprimer le profil utilisateur
    const { error: profileError } = await client
      .from('profiles')
      .delete()
      .eq('id', userId)
    
    if (profileError) throw profileError
    
    // Supprimer l'utilisateur dans Auth
    const { error: authError } = await client.auth.admin.deleteUser(userId)
    
    if (authError) throw authError
    
    // Rediriger vers la liste des utilisateurs
    router.push({
      path: '/admin/users',
      query: { success: 'user_deleted' }
    })
  } catch (error) {
    console.error('Erreur lors de la suppression:', error)
    alert('Erreur lors de la suppression: ' + error.message)
  } finally {
    deleting.value = false
    showDeleteModal.value = false
  }
}

// Configuration de la page
definePageMeta({
  layout: 'admin',
})
</script> 