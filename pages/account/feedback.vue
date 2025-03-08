<template>
  <div class="max-w-3xl mx-auto px-4 py-12">
    <div class="bg-white dark:bg-gray-800 rounded-2xl shadow-sm border border-gray-200 dark:border-gray-700 p-8">
      <!-- En-tête -->
      <div class="flex items-center justify-between mb-8">
        <h1 class="text-2xl font-bold text-gray-900 dark:text-white">Mes retours</h1>
        <NuxtLink 
          to="/account" 
          class="text-sm text-gray-600 dark:text-gray-300 hover:text-gray-900 dark:hover:text-white flex items-center gap-1"
        >
          <ArrowLeft class="w-4 h-4" />
          <span>Retour au profil</span>
        </NuxtLink>
      </div>
      
      <!-- Navigation par onglets -->
      <div class="mb-8">
        <div class="flex border-b border-gray-200 dark:border-gray-700">
          <button 
            @click="activeTab = 'received'"
            class="py-3 px-4 text-sm font-medium -mb-px"
            :class="activeTab === 'received' 
              ? 'text-primary-600 dark:text-primary-400 border-b-2 border-primary-500' 
              : 'text-gray-500 dark:text-gray-400 hover:text-gray-700 dark:hover:text-gray-300'"
          >
            Avis reçus
          </button>
          <button 
            @click="activeTab = 'given'"
            class="py-3 px-4 text-sm font-medium -mb-px"
            :class="activeTab === 'given' 
              ? 'text-primary-600 dark:text-primary-400 border-b-2 border-primary-500' 
              : 'text-gray-500 dark:text-gray-400 hover:text-gray-700 dark:hover:text-gray-300'"
          >
            Avis donnés
          </button>
          <button 
            @click="activeTab = 'pending'"
            class="py-3 px-4 text-sm font-medium -mb-px relative"
            :class="activeTab === 'pending' 
              ? 'text-primary-600 dark:text-primary-400 border-b-2 border-primary-500' 
              : 'text-gray-500 dark:text-gray-400 hover:text-gray-700 dark:hover:text-gray-300'"
          >
            À évaluer
            <span 
              v-if="pendingContracts.length > 0"
              class="absolute -top-0.5 -right-0.5 h-5 w-5 flex items-center justify-center rounded-full bg-primary-600 text-white text-xs font-bold"
            >
              {{ pendingContracts.length }}
            </span>
          </button>
        </div>
      </div>
      
      <!-- Contenu des onglets -->
      <div>
        <!-- Onglet: Avis reçus -->
        <div v-if="activeTab === 'received'">
          <div v-if="receivedFeedbacks.length > 0">
            <!-- Note moyenne -->
            <div v-if="userData?.is_expert" class="mb-6 p-4 bg-gray-50 dark:bg-gray-800/60 rounded-xl">
              <div class="flex items-center">
                <div class="flex text-yellow-400 dark:text-yellow-300">
                  <Star v-for="i in 5" :key="i" class="h-6 w-6" :class="{'fill-current': i <= averageRating}" />
                </div>
                <span class="ml-2 text-lg font-bold text-gray-900 dark:text-white">{{ averageRating.toFixed(1) }}</span>
                <span class="ml-1 text-sm text-gray-500 dark:text-gray-400">({{ receivedFeedbacks.length }} avis)</span>
              </div>
            </div>
            
            <!-- Liste des avis -->
            <div class="space-y-6">
              <div 
                v-for="feedback in receivedFeedbacks" 
                :key="feedback.id"
                class="p-5 border border-gray-100 dark:border-gray-700 rounded-xl"
              >
                <div class="flex items-start justify-between mb-4">
                  <div class="flex">
                    <div class="h-10 w-10 rounded-full bg-gray-100 dark:bg-gray-700 flex items-center justify-center overflow-hidden mr-3">
                      <img 
                        v-if="feedback.author_avatar" 
                        :src="feedback.author_avatar" 
                        alt="Avatar" 
                        class="h-full w-full object-cover"
                      />
                      <User v-else class="h-5 w-5 text-gray-400" />
                    </div>
                    
                    <div>
                      <div class="font-medium text-gray-900 dark:text-white">
                        {{ feedback.author_name }}
                      </div>
                      <div class="text-xs text-gray-500 dark:text-gray-400 mt-0.5">
                        {{ formatDate(feedback.created_at) }}
                      </div>
                    </div>
                  </div>
                  
                  <div class="flex items-center">
                    <div class="flex">
                      <Star 
                        v-for="i in 5" 
                        :key="i"
                        :class="[
                          'h-4 w-4',
                          i <= feedback.rating ? 'text-yellow-400 fill-current' : 'text-gray-300 dark:text-gray-600'
                        ]"
                      />
                    </div>
                  </div>
                </div>
                
                <p class="text-gray-600 dark:text-gray-300 text-sm mb-3">
                  {{ feedback.comment }}
                </p>
                
                <div class="flex items-center text-xs text-gray-500 dark:text-gray-400 mt-4 pt-3 border-t border-gray-100 dark:border-gray-700">
                  <Briefcase class="h-3.5 w-3.5 mr-1.5" />
                  <span>{{ feedback.contract_title }}</span>
                </div>
              </div>
            </div>
          </div>
          
          <!-- État vide -->
          <div v-else class="text-center py-12">
            <div class="mx-auto h-16 w-16 rounded-full bg-gray-100 dark:bg-gray-800 flex items-center justify-center mb-4">
              <MessageSquare class="h-8 w-8 text-gray-400 dark:text-gray-500" />
            </div>
            <h3 class="text-lg font-medium text-gray-700 dark:text-gray-300 mb-2">Aucun avis reçu</h3>
            <p class="text-sm text-gray-500 dark:text-gray-400 max-w-md mx-auto">
              Les avis que vous recevez sur vos services apparaîtront ici. Ils vous aideront à améliorer votre réputation.
            </p>
          </div>
        </div>
        
        <!-- Onglet: Avis donnés -->
        <div v-else-if="activeTab === 'given'">
          <div v-if="givenFeedbacks.length > 0">
            <div class="space-y-6">
              <div 
                v-for="feedback in givenFeedbacks" 
                :key="feedback.id"
                class="p-5 border border-gray-100 dark:border-gray-700 rounded-xl"
              >
                <div class="flex items-start justify-between mb-4">
                  <div class="flex">
                    <div class="h-10 w-10 rounded-full bg-gray-100 dark:bg-gray-700 flex items-center justify-center overflow-hidden mr-3">
                      <img 
                        v-if="feedback.recipient_avatar" 
                        :src="feedback.recipient_avatar" 
                        alt="Avatar" 
                        class="h-full w-full object-cover"
                      />
                      <User v-else class="h-5 w-5 text-gray-400" />
                    </div>
                    
                    <div>
                      <div class="font-medium text-gray-900 dark:text-white">
                        {{ feedback.recipient_name }}
                      </div>
                      <div class="text-xs text-gray-500 dark:text-gray-400 mt-0.5">
                        {{ formatDate(feedback.created_at) }}
                      </div>
                    </div>
                  </div>
                  
                  <div class="flex items-center">
                    <div class="flex">
                      <Star 
                        v-for="i in 5" 
                        :key="i"
                        :class="[
                          'h-4 w-4',
                          i <= feedback.rating ? 'text-yellow-400 fill-current' : 'text-gray-300 dark:text-gray-600'
                        ]"
                      />
                    </div>
                  </div>
                </div>
                
                <p class="text-gray-600 dark:text-gray-300 text-sm mb-3">
                  {{ feedback.comment }}
                </p>
                
                <div class="flex items-center text-xs text-gray-500 dark:text-gray-400 mt-4 pt-3 border-t border-gray-100 dark:border-gray-700">
                  <Briefcase class="h-3.5 w-3.5 mr-1.5" />
                  <span>{{ feedback.contract_title }}</span>
                </div>
              </div>
            </div>
          </div>
          
          <!-- État vide -->
          <div v-else class="text-center py-12">
            <div class="mx-auto h-16 w-16 rounded-full bg-gray-100 dark:bg-gray-800 flex items-center justify-center mb-4">
              <ThumbsUp class="h-8 w-8 text-gray-400 dark:text-gray-500" />
            </div>
            <h3 class="text-lg font-medium text-gray-700 dark:text-gray-300 mb-2">Aucun avis donné</h3>
            <p class="text-sm text-gray-500 dark:text-gray-400 max-w-md mx-auto">
              Les avis que vous donnez sur les services apparaîtront ici. N'hésitez pas à partager votre expérience.
            </p>
          </div>
        </div>
        
        <!-- Onglet: À évaluer -->
        <div v-else>
          <div v-if="pendingContracts.length > 0">
            <div class="space-y-6">
              <div 
                v-for="contract in pendingContracts" 
                :key="contract.id"
                class="p-5 border border-gray-100 dark:border-gray-700 rounded-xl"
              >
                <div class="flex justify-between items-start mb-4">
                  <div>
                    <h4 class="font-medium text-gray-900 dark:text-white text-lg">{{ contract.title }}</h4>
                    <p class="text-xs text-gray-500 dark:text-gray-400 mt-1">
                      Terminé le {{ formatDate(contract.completion_date) }}
                    </p>
                  </div>
                  
                  <button 
                    @click="openAddFeedbackModal(contract)"
                    class="px-4 py-1.5 text-sm font-medium text-white bg-primary-600 hover:bg-primary-700 rounded-xl shadow-sm"
                  >
                    Évaluer
                  </button>
                </div>
                
                <div class="flex items-center p-3 bg-gray-50 dark:bg-gray-800/60 rounded-lg">
                  <div class="h-10 w-10 rounded-full bg-gray-100 dark:bg-gray-700 flex items-center justify-center overflow-hidden mr-3">
                    <img 
                      v-if="contract.other_party_avatar" 
                      :src="contract.other_party_avatar" 
                      alt="Avatar" 
                      class="h-full w-full object-cover"
                    />
                    <User v-else class="h-5 w-5 text-gray-400" />
                  </div>
                  <div>
                    <div class="font-medium text-gray-900 dark:text-white">
                      {{ contract.other_party_name }}
                    </div>
                    <div class="text-xs text-gray-500 dark:text-gray-400">
                      {{ contract.other_party_role === 'expert' ? 'Expert' : 'Client' }}
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          
          <!-- État vide -->
          <div v-else class="text-center py-12">
            <div class="mx-auto h-16 w-16 rounded-full bg-gray-100 dark:bg-gray-800 flex items-center justify-center mb-4">
              <CheckCircle class="h-8 w-8 text-gray-400 dark:text-gray-500" />
            </div>
            <h3 class="text-lg font-medium text-gray-700 dark:text-gray-300 mb-2">Pas de contrats à évaluer</h3>
            <p class="text-sm text-gray-500 dark:text-gray-400 max-w-md mx-auto">
              Tous vos contrats ont été évalués. Les nouveaux contrats terminés qui nécessitent votre évaluation apparaîtront ici.
            </p>
          </div>
        </div>
      </div>
    </div>
    
    <!-- Modale d'ajout de feedback -->
    <div v-if="showAddFeedbackModal" class="fixed inset-0 bg-black/50 flex items-center justify-center z-50">
      <div class="bg-white dark:bg-gray-800 rounded-xl p-8 max-w-lg w-full">
        <h3 class="text-xl font-bold text-gray-900 dark:text-white mb-6">Évaluer {{ selectedContract?.other_party_name }}</h3>
        
        <div class="mb-6">
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-3">Note</label>
          <div class="flex space-x-4">
            <button 
              v-for="i in 5" 
              :key="i"
              @click="newFeedback.rating = i"
              class="h-10 w-10 rounded-full flex items-center justify-center focus:outline-none transition-all"
              :class="i <= newFeedback.rating ? 'bg-yellow-50 dark:bg-yellow-900/20' : ''"
            >
              <Star 
                class="h-6 w-6"
                :class="i <= newFeedback.rating ? 'text-yellow-400 fill-current' : 'text-gray-300 dark:text-gray-600'" 
              />
            </button>
          </div>
        </div>
        
        <div class="mb-6">
          <label for="comment" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Commentaire</label>
          <textarea 
            id="comment"
            v-model="newFeedback.comment"
            rows="4" 
            class="w-full rounded-lg border-gray-300 dark:border-gray-700 dark:bg-gray-800 shadow-sm focus:border-primary-500 focus:ring-primary-500"
            placeholder="Partagez votre expérience avec cette personne..."
          ></textarea>
        </div>
        
        <div class="flex justify-end space-x-3 pt-4">
          <button 
            @click="showAddFeedbackModal = false"
            class="px-4 py-2 text-sm font-medium text-gray-700 dark:text-gray-300 bg-white dark:bg-gray-700 border border-gray-300 dark:border-gray-600 rounded-xl hover:bg-gray-50 dark:hover:bg-gray-600"
          >
            Annuler
          </button>
          
          <button 
            @click="submitFeedback"
            :disabled="newFeedback.rating === 0 || !newFeedback.comment.trim()"
            class="px-6 py-2 text-sm font-medium text-white bg-primary-600 hover:bg-primary-700 rounded-xl shadow-sm disabled:opacity-50 disabled:cursor-not-allowed"
          >
            Envoyer l'évaluation
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useSupabaseClient, useSupabaseUser } from '#imports'
import { useRouter } from 'vue-router'
import {
  ArrowLeft, User, Star, MessageSquare, ThumbsUp, CheckCircle, Briefcase
} from 'lucide-vue-next'

// Composables
const supabase = useSupabaseClient()
const currentUser = useSupabaseUser()
const router = useRouter()

// États
const loading = ref(false)
const activeTab = ref('received')
const userData = ref(null)
const receivedFeedbacks = ref([])
const givenFeedbacks = ref([])
const pendingContracts = ref([])
const showAddFeedbackModal = ref(false)
const selectedContract = ref(null)
const newFeedback = ref({
  rating: 0,
  comment: ''
})

// Note moyenne calculée
const averageRating = computed(() => {
  if (!receivedFeedbacks.value.length) return 0
  const sum = receivedFeedbacks.value.reduce((acc, feedback) => acc + feedback.rating, 0)
  return sum / receivedFeedbacks.value.length
})

// Méthodes
const fetchUserData = async () => {
  try {
    if (!currentUser.value) return
    
    const { data, error } = await supabase
      .from('profiles')
      .select('*')
      .eq('id', currentUser.value.id)
      .single()
    
    if (error) throw error
    userData.value = data
    
    // Charger les données associées
    await Promise.all([
      fetchReceivedFeedbacks(),
      fetchGivenFeedbacks(),
      fetchPendingContracts()
    ])
  } catch (error) {
    console.error('Erreur lors du chargement des données utilisateur:', error)
  }
}

// Récupérer les avis reçus
const fetchReceivedFeedbacks = async () => {
  try {
    loading.value = true
    
    // Simuler des données pour le moment
    const mockFeedbacks = [
      {
        id: 1,
        author_id: 'user123',
        author_name: 'Marie Dupont',
        author_avatar: 'https://randomuser.me/api/portraits/women/44.jpg',
        rating: 5,
        comment: 'Excellent travail, très professionnel et livré dans les délais. Je recommande vivement!',
        contract_title: 'Développement site web e-commerce',
        created_at: new Date(Date.now() - 5 * 24 * 60 * 60 * 1000)
      },
      {
        id: 2,
        author_id: 'user456',
        author_name: 'Jean Martin',
        author_avatar: 'https://randomuser.me/api/portraits/men/32.jpg',
        rating: 4,
        comment: 'Bonne communication et résultat satisfaisant. Quelques ajustements ont été nécessaires mais bien gérés.',
        contract_title: 'Design logo entreprise',
        created_at: new Date(Date.now() - 15 * 24 * 60 * 60 * 1000)
      }
    ]
    
    receivedFeedbacks.value = mockFeedbacks
  } catch (error) {
    console.error('Erreur lors du chargement des avis reçus:', error)
  } finally {
    loading.value = false
  }
}

// Récupérer les avis donnés
const fetchGivenFeedbacks = async () => {
  try {
    loading.value = true
    
    // Simuler des données pour le moment
    const mockFeedbacks = [
      {
        id: 1,
        recipient_id: 'user789',
        recipient_name: 'Sophie Legrand',
        recipient_avatar: 'https://randomuser.me/api/portraits/women/68.jpg',
        rating: 5,
        comment: 'Excellente prestation, très à l\'écoute des besoins et réactive. Je referai appel à ses services.',
        contract_title: 'Rédaction contenu web',
        created_at: new Date(Date.now() - 8 * 24 * 60 * 60 * 1000)
      }
    ]
    
    givenFeedbacks.value = mockFeedbacks
  } catch (error) {
    console.error('Erreur lors du chargement des avis donnés:', error)
  } finally {
    loading.value = false
  }
}

// Récupérer les contrats en attente d'évaluation
const fetchPendingContracts = async () => {
  try {
    loading.value = true
    
    // Simuler des données pour le moment
    const mockContracts = [
      {
        id: 1,
        title: 'Création d\'application mobile',
        completion_date: new Date(Date.now() - 2 * 24 * 60 * 60 * 1000),
        other_party_id: 'user789',
        other_party_name: 'Thomas Laurent',
        other_party_avatar: 'https://randomuser.me/api/portraits/men/22.jpg',
        other_party_role: 'expert'
      }
    ]
    
    pendingContracts.value = mockContracts
  } catch (error) {
    console.error('Erreur lors du chargement des contrats en attente:', error)
  } finally {
    loading.value = false
  }
}

// Ouvrir la modale d'ajout de feedback
const openAddFeedbackModal = (contract) => {
  selectedContract.value = contract
  newFeedback.value = {
    rating: 0,
    comment: ''
  }
  showAddFeedbackModal.value = true
}

// Soumettre un feedback
const submitFeedback = async () => {
  try {
    loading.value = true
    
    // Simuler l'envoi d'un feedback
    console.log('Feedback soumis:', {
      contract_id: selectedContract.value.id,
      recipient_id: selectedContract.value.other_party_id,
      rating: newFeedback.value.rating,
      comment: newFeedback.value.comment
    })
    
    // Mise à jour des données locales pour la démonstration
    pendingContracts.value = pendingContracts.value.filter(
      contract => contract.id !== selectedContract.value.id
    )
    
    givenFeedbacks.value.unshift({
      id: Date.now(),
      recipient_id: selectedContract.value.other_party_id,
      recipient_name: selectedContract.value.other_party_name,
      recipient_avatar: selectedContract.value.other_party_avatar,
      rating: newFeedback.value.rating,
      comment: newFeedback.value.comment,
      contract_title: selectedContract.value.title,
      created_at: new Date()
    })
    
    // Fermer la modale
    showAddFeedbackModal.value = false
    selectedContract.value = null
    
    // Afficher un message de succès
    alert('Votre évaluation a été envoyée avec succès!')
  } catch (error) {
    console.error('Erreur lors de l\'envoi du feedback:', error)
    alert('Une erreur est survenue lors de l\'envoi de votre évaluation.')
  } finally {
    loading.value = false
  }
}

// Formater une date
const formatDate = (date) => {
  if (!date) return ''
  return new Date(date).toLocaleDateString('fr-FR', {
    day: 'numeric',
    month: 'long',
    year: 'numeric'
  })
}

// Initialisation
onMounted(() => {
  fetchUserData()
})

// Vous pouvez ajouter ce bloc en haut de chaque fichier
definePageMeta({
  layout: 'account'
})
</script> 