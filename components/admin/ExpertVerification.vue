<template>
  <div class="bg-white border border-gray-200 rounded-xl overflow-hidden">
    <!-- En-tête -->
    <div class="px-6 py-4 border-b border-gray-200 flex justify-between items-center">
      <div>
        <h3 class="text-lg font-semibold text-gray-900">Vérification des documents</h3>
        <p class="text-sm text-gray-500">{{ expert.first_name }} {{ expert.last_name }}</p>
      </div>
      <div class="flex items-center gap-3">
        <button 
          @click="approveExpert"
          :disabled="saving"
          class="px-4 py-2 bg-green-600 text-white text-sm font-medium rounded-lg hover:bg-green-700 transition-colors flex items-center"
        >
          <Loader2 v-if="saving" class="h-4 w-4 mr-1.5 animate-spin" />
          <CheckCircle v-else class="h-4 w-4 mr-1.5" />
          Approuver
        </button>
        <button 
          @click="rejectExpert"
          :disabled="saving"
          class="px-4 py-2 bg-red-600 text-white text-sm font-medium rounded-lg hover:bg-red-700 transition-colors flex items-center"
        >
          <XCircle class="h-4 w-4 mr-1.5" />
          Refuser
        </button>
      </div>
    </div>
    
    <!-- Documents -->
    <div class="p-6 space-y-6">
      <!-- Identité -->
      <div class="space-y-4">
        <h4 class="text-sm font-semibold text-gray-900 flex items-center">
          <UserCheck class="h-4 w-4 mr-2" />
          Pièce d'identité
        </h4>
        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div class="border border-gray-200 rounded-lg p-4">
            <img 
              :src="expert.id_front" 
              alt="Recto pièce d'identité"
              class="w-full h-48 object-cover rounded-lg"
            />
            <p class="mt-2 text-sm text-gray-500">Recto</p>
          </div>
          <div class="border border-gray-200 rounded-lg p-4">
            <img 
              :src="expert.id_back" 
              alt="Verso pièce d'identité"
              class="w-full h-48 object-cover rounded-lg"
            />
            <p class="mt-2 text-sm text-gray-500">Verso</p>
          </div>
        </div>
      </div>
      
      <!-- Justificatif de domicile -->
      <div class="space-y-4">
        <h4 class="text-sm font-semibold text-gray-900 flex items-center">
          <Home class="h-4 w-4 mr-2" />
          Justificatif de domicile
        </h4>
        <div class="border border-gray-200 rounded-lg p-4">
          <img 
            :src="expert.proof_address" 
            alt="Justificatif de domicile"
            class="w-full h-48 object-cover rounded-lg"
          />
        </div>
      </div>
      
      <!-- Diplômes et certifications -->
      <div class="space-y-4">
        <h4 class="text-sm font-semibold text-gray-900 flex items-center">
          <GraduationCap class="h-4 w-4 mr-2" />
          Diplômes et certifications
        </h4>
        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div 
            v-for="(cert, index) in expert.certifications" 
            :key="index"
            class="border border-gray-200 rounded-lg p-4"
          >
            <img 
              :src="cert.file_url" 
              :alt="cert.name"
              class="w-full h-48 object-cover rounded-lg"
            />
            <p class="mt-2 text-sm font-medium text-gray-900">{{ cert.name }}</p>
            <p class="text-sm text-gray-500">Délivré le {{ formatDate(cert.issue_date) }}</p>
          </div>
        </div>
      </div>
      
      <!-- Notes et commentaires -->
      <div class="space-y-4">
        <h4 class="text-sm font-semibold text-gray-900 flex items-center">
          <ClipboardList class="h-4 w-4 mr-2" />
          Notes et commentaires
        </h4>
        <textarea
          v-model="notes"
          rows="4"
          class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-transparent"
          placeholder="Ajouter des notes sur la vérification..."
        ></textarea>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { 
  CheckCircle, XCircle, UserCheck, Home, 
  GraduationCap, ClipboardList, Loader2 
} from 'lucide-vue-next'

const props = defineProps({
  expert: {
    type: Object,
    required: true
  }
})

const emit = defineEmits(['approved', 'rejected'])

const saving = ref(false)
const notes = ref('')

// Approuver l'expert
const approveExpert = async () => {
  try {
    saving.value = true
    
    // Mettre à jour le statut de l'expert
    const { error } = await useSupabaseClient()
      .from('profiles')
      .update({ 
        verification_status: 'approved',
        verification_notes: notes.value,
        verified_at: new Date().toISOString()
      })
      .eq('id', props.expert.id)
    
    if (error) throw error
    
    emit('approved', {
      expertId: props.expert.id,
      notes: notes.value
    })
  } catch (error) {
    console.error('Erreur lors de l\'approbation:', error)
  } finally {
    saving.value = false
  }
}

// Refuser l'expert
const rejectExpert = async () => {
  try {
    saving.value = true
    
    // Mettre à jour le statut de l'expert
    const { error } = await useSupabaseClient()
      .from('profiles')
      .update({ 
        verification_status: 'rejected',
        verification_notes: notes.value,
        verified_at: new Date().toISOString()
      })
      .eq('id', props.expert.id)
    
    if (error) throw error
    
    emit('rejected', {
      expertId: props.expert.id,
      notes: notes.value
    })
  } catch (error) {
    console.error('Erreur lors du refus:', error)
  } finally {
    saving.value = false
  }
}

// Formater une date
const formatDate = (date) => {
  return new Date(date).toLocaleDateString('fr-FR', {
    day: 'numeric',
    month: 'long',
    year: 'numeric'
  })
}
</script> 