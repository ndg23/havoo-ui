<template>
  <div class="min-h-screen bg-gray-50">
    <!-- En-tête du profil avec bannière et photo -->
    <div class="relative bg-white border-b border-gray-200">
      <!-- Bannière -->
      <div class="h-48 w-full bg-gradient-to-r from-primary-600 via-blue-500 to-indigo-600 animate-gradient-x"></div>
      
      <!-- Informations principales -->
      <div class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="relative -mt-24 sm:-mt-16 sm:flex sm:items-end sm:space-x-5 mb-8">
          <!-- Avatar -->
          <div class="relative group">
            <div class="h-32 w-32 rounded-full ring-4 ring-white bg-white overflow-hidden">
              <img 
                :src="profile.avatar_url || defaultAvatar" 
                :alt="fullName"
                class="h-full w-full object-cover"
              />
              
              <!-- Bouton upload photo (si propriétaire) -->
              <div 
                v-if="isOwner"
                class="absolute inset-0 bg-black bg-opacity-40 flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity cursor-pointer"
                @click="$refs.avatarInput.click()"
              >
                <Camera class="h-6 w-6 text-white" />
              </div>
              <input
                ref="avatarInput"
                type="file"
                accept="image/*"
                class="hidden"
                @change="uploadAvatar"
              />
            </div>
            
            <!-- Badge vérifié pour les experts -->
            <div 
              v-if="profile.role === 'expert' && profile.verification_status === 'approved'"
              class="absolute bottom-0 right-0 h-8 w-8 bg-white rounded-full ring-4 ring-white flex items-center justify-center"
            >
              <CheckCircle class="h-6 w-6 text-primary-600" />
            </div>
          </div>
          
          <!-- Informations de base -->
          <div class="mt-6 sm:mt-0 sm:flex-1 min-w-0">
            <div class="flex items-center space-x-3">
              <h1 class="text-2xl font-bold text-gray-900 truncate">{{ fullName }}</h1>
              <span 
                v-if="profile.role === 'expert'"
                class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium"
                :class="verificationStatusClass"
              >
                {{ verificationStatusText }}
              </span>
            </div>
            <p class="text-sm text-gray-500">{{ profile.email }}</p>
          </div>
          
          <!-- Actions -->
          <div class="mt-6 sm:mt-0 flex flex-col sm:flex-row sm:items-center sm:space-x-3">
            <button 
              v-if="isOwner"
              @click="editMode = !editMode"
              class="inline-flex items-center px-4 py-2 border border-gray-300 shadow-sm text-sm font-medium rounded-lg text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500"
            >
              <Edit3 class="h-4 w-4 mr-2" />
              Modifier le profil
            </button>
            
            <button 
              v-else
              class="inline-flex items-center px-4 py-2 border border-transparent shadow-sm text-sm font-medium rounded-lg text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500"
            >
              <MessageCircle class="h-4 w-4 mr-2" />
              Contacter
            </button>
          </div>
        </div>
      </div>
    </div>
    
    <!-- Contenu principal -->
    <div class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
        <!-- Sidebar -->
        <div class="lg:col-span-1 space-y-6">
          <!-- Informations de base -->
          <div class="bg-white rounded-xl border border-gray-200 overflow-hidden shadow-sm">
            <div class="px-6 py-4 border-b border-gray-200">
              <h3 class="text-lg font-semibold text-gray-900">Informations</h3>
            </div>
            <div class="p-6 space-y-4">
              <div class="flex items-center text-sm">
                <MapPin class="h-4 w-4 text-gray-400 mr-2" />
                <span>{{ profile.city || 'Non renseigné' }}</span>
              </div>
              <div class="flex items-center text-sm">
                <Calendar class="h-4 w-4 text-gray-400 mr-2" />
                <span>Membre depuis {{ memberSince }}</span>
              </div>
              <div v-if="profile.role === 'expert'" class="flex items-center text-sm">
                <Star class="h-4 w-4 text-gray-400 mr-2" />
                <span>{{ profile.rating || '0' }} ({{ profile.reviews_count || '0' }} avis)</span>
              </div>
            </div>
          </div>
          
          <!-- Spécialités (experts uniquement) -->
          <div 
            v-if="profile.role === 'expert'"
            class="bg-white rounded-xl border border-gray-200 overflow-hidden shadow-sm"
          >
            <div class="px-6 py-4 border-b border-gray-200">
              <h3 class="text-lg font-semibold text-gray-900">Spécialités</h3>
            </div>
            <div class="p-6">
              <div class="flex flex-wrap gap-2">
                <span 
                  v-for="specialty in profile.specialties" 
                  :key="specialty"
                  class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-primary-50 text-primary-700"
                >
                  {{ specialty }}
                </span>
              </div>
            </div>
          </div>
        </div>
        
        <!-- Contenu principal -->
        <div class="lg:col-span-2 space-y-6">
          <!-- Bio -->
          <div class="bg-white rounded-xl border border-gray-200 overflow-hidden shadow-sm">
            <div class="px-6 py-4 border-b border-gray-200">
              <h3 class="text-lg font-semibold text-gray-900">À propos</h3>
            </div>
            <div class="p-6">
              <p class="text-gray-700 whitespace-pre-line">{{ profile.bio || 'Aucune description' }}</p>
            </div>
          </div>
          
          <!-- Slot pour le contenu spécifique -->
          <slot></slot>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { 
  Camera, CheckCircle, Edit3, MessageCircle,
  MapPin, Calendar, Star
} from 'lucide-vue-next'

const props = defineProps({
  profile: {
    type: Object,
    required: true
  },
  isOwner: {
    type: Boolean,
    default: false
  }
})

const editMode = ref(false)
const defaultAvatar = 'https://ui-avatars.com/api/?background=random'

// Nom complet
const fullName = computed(() => {
  return `${props.profile.first_name} ${props.profile.last_name}`
})

// Date d'inscription
const memberSince = computed(() => {
  return new Date(props.profile.created_at).toLocaleDateString('fr-FR', {
    month: 'long',
    year: 'numeric'
  })
})

// Classes pour le badge de statut
const verificationStatusClass = computed(() => {
  switch(props.profile.verification_status) {
    case 'approved':
      return 'bg-green-100 text-green-800'
    case 'pending':
      return 'bg-yellow-100 text-yellow-800'
    case 'rejected':
      return 'bg-red-100 text-red-800'
    default:
      return 'bg-gray-100 text-gray-800'
  }
})

// Texte du statut
const verificationStatusText = computed(() => {
  switch(props.profile.verification_status) {
    case 'approved':
      return 'Vérifié'
    case 'pending':
      return 'En attente'
    case 'rejected':
      return 'Non vérifié'
    default:
      return 'Non vérifié'
  }
})

// Upload d'avatar
const uploadAvatar = async (event) => {
  const file = event.target.files[0]
  if (!file) return
  
  try {
    const path = `avatars/${props.profile.id}/${Date.now()}`
    const { data, error } = await useSupabaseClient().storage
      .from('public')
      .upload(path, file)
    
    if (error) throw error
    
    // Mettre à jour l'URL de l'avatar
    const { error: updateError } = await useSupabaseClient()
      .from('profiles')
      .update({ avatar_url: data.path })
      .eq('id', props.profile.id)
    
    if (updateError) throw updateError
    
  } catch (error) {
    console.error('Erreur lors de l\'upload:', error)
  }
}
</script>

<style scoped>
.animate-gradient-x {
  background-size: 200% 200%;
  animation: gradient-x 15s ease infinite;
}

@keyframes gradient-x {
  0% { background-position: 0% 50% }
  50% { background-position: 100% 50% }
  100% { background-position: 0% 50% }
}
</style> 