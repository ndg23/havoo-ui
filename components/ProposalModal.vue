<template>
  <div v-if="isOpen" class="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
    <div class="bg-white dark:bg-gray-800 rounded-xl max-w-md w-full p-5 animate-fadeIn">
      <div class="flex justify-between items-center mb-4">
        <h3 class="text-lg font-bold text-gray-900 dark:text-white">Proposer mes services</h3>
        <button @click="close" class="text-gray-500 hover:text-gray-700 dark:hover:text-gray-300">
          <X class="h-5 w-5" />
        </button>
      </div>
      
      <p class="text-gray-600 dark:text-gray-400 mb-4">
        Envoyez une proposition à <span class="font-medium text-gray-800 dark:text-gray-200">{{ request.client_name }}</span> pour la demande <span class="font-medium text-gray-800 dark:text-gray-200">{{ request.title }}</span>
      </p>
      
      <div class="space-y-4">
        <div>
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Votre prix (FCFA)*</label>
          <input 
            type="number" 
            v-model="proposal.price"
            required 
            min="0"
            class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
          />
        </div>
        
        <div>
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Délai de livraison (jours)*</label>
          <input 
            type="number" 
            v-model="proposal.deliveryTime"
            required
            min="1"
            class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
          />
        </div>
        
        <div>
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Message*</label>
          <textarea 
            v-model="proposal.message"
            required
            rows="3"
            placeholder="Expliquez pourquoi vous êtes le meilleur expert pour cette demande..."
            class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
          ></textarea>
        </div>
      </div>
      
      <div class="mt-6 flex items-center gap-3">
        <button 
          @click="submitProposal"
          :disabled="isSubmitting"
          class="flex-1 px-4 py-2 bg-primary-600 hover:bg-primary-700 disabled:bg-primary-400 text-white rounded-full text-sm font-medium"
        >
          <div v-if="isSubmitting" class="flex items-center justify-center">
            <div class="h-4 w-4 border-2 border-white/30 border-t-white rounded-full animate-spin mr-2"></div>
            Envoi en cours...
          </div>
          <span v-else>Envoyer la proposition</span>
        </button>
        
        <button 
          @click="close"
          class="px-4 py-2 bg-gray-100 hover:bg-gray-200 dark:bg-gray-700 dark:hover:bg-gray-600 text-gray-800 dark:text-gray-200 rounded-full text-sm font-medium"
        >
          Annuler
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { X } from 'lucide-vue-next'

const props = defineProps({
  isOpen: Boolean,
  request: Object
})

const emit = defineEmits(['close', 'submit'])

const proposal = ref({
  price: '',
  deliveryTime: '',
  message: ''
})

const isSubmitting = ref(false)

const close = () => {
  emit('close')
}

const submitProposal = async () => {
  // Validation basique
  if (!proposal.value.price || !proposal.value.deliveryTime || !proposal.value.message) {
    return
  }
  
  isSubmitting.value = true
  
  try {
    // Dans un environnement réel, envoyer à Supabase
    await new Promise(resolve => setTimeout(resolve, 1000))
    
    emit('submit', {
      requestId: props.request.id,
      ...proposal.value
    })
    
    // Réinitialiser le formulaire
    proposal.value = {
      price: '',
      deliveryTime: '',
      message: ''
    }
    
    close()
  } catch (error) {
    console.error('Erreur lors de l\'envoi de la proposition:', error)
  } finally {
    isSubmitting.value = false
  }
}
</script>

<style scoped>
.animate-fadeIn {
  animation: fadeIn 0.3s ease-out;
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
</style> 