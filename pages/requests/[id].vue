<template>
    <div class="fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center p-4">
      <div class="bg-white rounded-xl w-full max-w-3xl max-h-[90vh] overflow-y-auto">
        <div class="sticky top-0 bg-white p-6 border-b border-gray-100 flex justify-between items-center">
          <h2 class="text-xl font-bold">Détails de la demande</h2>
          <button @click="$emit('close')" class="p-2 rounded-full hover:bg-gray-100">
            <XMarkIcon class="w-6 h-6" />
          </button>
        </div>
        
        <div class="p-6">
          <!-- En-tête -->
          <div class="flex items-start gap-4 mb-6">
            <div class="w-16 h-16 rounded-full bg-black flex items-center justify-center text-2xl text-white">
              {{ request.service_icon }}
            </div>
            <div>
              <h3 class="text-2xl font-bold text-gray-900">{{ request.service_name }}</h3>
              <div class="text-lg text-gray-500">{{ formatPrice(request.budget) }} • {{ request.duration }}h</div>
            </div>
          </div>
          
          <!-- Informations principales -->
          <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
            <div>
              <h4 class="font-medium text-gray-500 mb-2">Détails</h4>
              <div class="space-y-3">
                <div class="flex items-center gap-3">
                  <CalendarIcon class="w-5 h-5 text-gray-400" />
                  <span>{{ formatDate(request.date) }} à {{ formatTime(request.time) }}</span>
                </div>
                <div class="flex items-center gap-3">
                  <MapPinIcon class="w-5 h-5 text-gray-400" />
                  <span>{{ request.location }}</span>
                </div>
                <div class="flex items-center gap-3">
                  <ClockIcon class="w-5 h-5 text-gray-400" />
                  <span>{{ request.duration }} heures</span>
                </div>
                <div class="flex items-center gap-3">
                  <TagIcon class="w-5 h-5 text-gray-400" />
                  <span 
                    class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium"
                    :class="{
                      'bg-yellow-50 text-yellow-800 border border-yellow-200': request.status === 'active',
                      'bg-blue-50 text-blue-800 border border-blue-200': request.status === 'pending',
                      'bg-green-50 text-green-800 border border-green-200': request.status === 'completed',
                      'bg-red-50 text-red-800 border border-red-200': request.status === 'cancelled'
                    }"
                  >
                    {{ getStatusLabel(request.status) }}
                  </span>
                </div>
              </div>
            </div>
            
            <div>
              <h4 class="font-medium text-gray-500 mb-2">Client</h4>
              <div class="flex items-center gap-3 mb-4">
                <img 
                  :src="request.client_image || `https://ui-avatars.com/api/?name=${request.client_first_name}+${request.client_last_name}&background=000000&color=ffffff`"
                  class="w-12 h-12 rounded-full border border-gray-200"
                  alt="Client avatar"
                />
                <div>
                  <div class="font-medium text-gray-900">{{ request.client_first_name }} {{ request.client_last_name }}</div>
                  <div class="text-sm text-gray-500">{{ request.client_email || '—' }}</div>
                </div>
              </div>
            </div>
          </div>
          
          <!-- Description -->
          <div class="mb-6">
            <h4 class="font-medium text-gray-500 mb-2">Description</h4>
            <p class="text-gray-700 whitespace-pre-line">{{ request.description }}</p>
          </div>
          
          <!-- Propositions -->
          <div v-if="proposals.length > 0">
            <h4 class="font-medium text-gray-500 mb-2">Propositions ({{ proposals.length }})</h4>
            <div class="space-y-4">
              <div 
                v-for="proposal in proposals" 
                :key="proposal.id"
                class="bg-gray-50 p-4 rounded-xl"
              >
                <div class="flex items-center justify-between">
                  <div class="flex items-center gap-3">
                    <img 
                      :src="proposal.expert_image || `https://ui-avatars.com/api/?name=${proposal.expert_first_name}+${proposal.expert_last_name}&background=000000&color=ffffff`"
                      class="w-10 h-10 rounded-full border border-gray-200"
                      alt="Expert avatar"
                    />
                    <div>
                      <div class="font-medium text-gray-900">{{ proposal.expert_first_name }} {{ proposal.expert_last_name }}</div>
                      <div class="text-sm text-gray-500">{{ formatPrice(proposal.price) }}</div>
                    </div>
                  </div>
                  <span 
                    class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium"
                    :class="{
                      'bg-yellow-50 text-yellow-800 border border-yellow-200': proposal.status === 'pending',
                      'bg-green-50 text-green-800 border border-green-200': proposal.status === 'accepted',
                      'bg-red-50 text-red-800 border border-red-200': proposal.status === 'rejected'
                    }"
                  >
                    {{ getProposalStatusLabel(proposal.status) }}
                  </span>
                </div>
                <p v-if="proposal.message" class="mt-2 text-gray-700">
                  {{ proposal.message }}
                </p>
              </div>
            </div>
          </div>
          
          <!-- Section résolution (visible uniquement pour le propriétaire) -->
          <RequestResolution
            v-if="isOwner && request.status === 'accepted'"
            :request="request"
            @resolved="onRequestResolved"
          />
          
          <!-- Actions -->
          <div class="mt-8 flex justify-end gap-3">
            <button 
              v-if="request.status === 'active'"
              class="px-4 py-2 bg-black text-white rounded-full hover:bg-gray-800 transition-colors"
              @click="$emit('assign', request)"
            >
              Assigner un expert
            </button>
            <button 
              v-if="['active', 'pending'].includes(request.status)"
              class="px-4 py-2 bg-red-50 text-red-700 rounded-full hover:bg-red-100 transition-colors"
              @click="cancelRequest"
            >
              Annuler la demande
            </button>
          </div>
        </div>
      </div>
    </div>
  </template>
  
  <script setup>
  import { ref, onMounted } from 'vue'
  import { 
    XMarkIcon,
    CalendarIcon, 
    MapPinIcon, 
    ClockIcon,
    TagIcon
  } from '@heroicons/vue/24/outline'
  import { supabase } from '~/lib/supabase'
  import RequestResolution from '~/components/requests/RequestResolution.vue'
  
  const props = defineProps({
    request: {
      type: Object,
      required: true
    }
  })
  
  const emit = defineEmits(['close', 'assign'])
  const proposals = ref([])
  
  onMounted(async () => {
    await fetchProposals()
  })
  
  const fetchProposals = async () => {
    try {
      const { data, error } = await supabase
        .from('proposals')
        .select(`
          id,
          price,
          message,
          status,
          created_at,
          experts:expert_id (
            id,
            profiles:id (
              first_name,
              last_name,
              profile_image_url
            )
          )
        `)
        .eq('request_id', props.request.id)
      
      if (error) throw error
      
      // Transformer les données pour faciliter l'affichage
      proposals.value = data.map(p => ({
        id: p.id,
        price: p.price,
        message: p.message,
        status: p.status,
        created_at: p.created_at,
        expert_id: p.experts.id,
        expert_first_name: p.experts.profiles.first_name,
        expert_last_name: p.experts.profiles.last_name,
        expert_image: p.experts.profiles.profile_image_url
      }))
    } catch (error) {
      console.error('Erreur lors du chargement des propositions:', error)
    }
  }
  
  // Formatage
  const formatDate = (date) => {
    if (!date) return '—'
    return new Date(date).toLocaleDateString('fr-FR', {
      year: 'numeric',
      month: 'long',
      day: 'numeric'
    })
  }
  
  const formatTime = (time) => {
    if (!time) return '—'
    return time
  }
  
  const formatPrice = (price) => {
    return new Intl.NumberFormat('fr-FR', {
      style: 'currency',
      currency: 'XOF',
      maximumFractionDigits: 0
    }).format(price || 0)
  }
  
  const getStatusLabel = (status) => {
  const statusMap = {
    'active': 'En cours',
    'pending': 'En attente',
    'completed': 'Terminé',
    'cancelled': 'Annulé'
  }
  return statusMap[status] || status
}

const getProposalStatusLabel = (status) => {
  const statusMap = {
    'pending': 'En attente',
    'accepted': 'Acceptée',
    'rejected': 'Refusée'
  }
  return statusMap[status] || status
}

const cancelRequest = async () => {
  try {
    const { error } = await supabase
      .from('requests')
      .update({ status: 'cancelled' })
      .eq('id', props.request.id)
    
    if (error) throw error
    
    // Informer le parent que la demande a été annulée
    emit('close')
    // Rafraîchir la liste des demandes
    emit('refresh')
  } catch (error) {
    console.error('Erreur lors de l\'annulation de la demande:', error)
  }
}

// Gérer la résolution
const onRequestResolved = ({ rating, comment }) => {
  // Mettre à jour l'interface
  props.request = {
    ...props.request,
    resolved_at: new Date().toISOString(),
    rating,
    review: comment
  }
}
</script>

<style scoped>
/* Styles spécifiques au composant si nécessaire */
</style>