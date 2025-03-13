<template>
  <div v-if="isOpen" class="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
    <div class="bg-white dark:bg-gray-800 rounded-xl max-w-md w-full p-5 animate-fadeIn">
      <div class="flex justify-between items-center mb-4">
        <h3 class="text-lg font-bold text-gray-900 dark:text-white">Contacter l'expert</h3>
        <button @click="close" class="text-gray-500 hover:text-gray-700 dark:hover:text-gray-300">
          <X class="h-5 w-5" />
        </button>
      </div>
      
      <div class="flex items-center mb-4">
        <img 
          :src="expert.avatar_url || '/img/default-avatar.png'" 
          class="w-12 h-12 rounded-full object-cover mr-3" 
          alt="Expert"
        />
        <div>
          <p class="font-medium text-gray-900 dark:text-white flex items-center">
            {{ expert.first_name }} {{ expert.last_name }}
            <span v-if="expert.is_verified" class="ml-1 text-blue-500">
              <CheckCircle class="h-4 w-4" />
            </span>
          </p>
          <p class="text-sm text-primary-600 dark:text-primary-400">{{ expert.specialty }}</p>
        </div>
      </div>
      
      <div class="space-y-4">
        <div>
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Sujet*</label>
          <input 
            type="text" 
            v-model="contact.subject"
            required
            placeholder="Ex: Besoin d'un site web pour mon entreprise"
            class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
          />
        </div>
        
        <div>
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Message*</label>
          <textarea 
            v-model="contact.message"
            required
            rows="3"
            placeholder="Décrivez brièvement votre projet ou votre besoin..."
            class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
          ></textarea>
        </div>
        
        <div>
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Budget approximatif (FCFA)</label>
          <input 
            type="number" 
            v-model="contact.budget"
            min="0"
            placeholder="Optionnel"
            class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
          />
        </div>
      </div>
      
      <div class="mt-6 flex items-center gap-3">
        <button 
          @click="submitContact"
          :disabled="isSubmitting"
          class="flex-1 px-4 py-2 bg-primary-600 hover:bg-primary-700 disabled:bg-primary-400 text-white rounded-full text-sm font-medium"
        >
          <div v-if="isSubmitting" class="flex items-center justify-center">
            <div class="h-4 w-4 border-2 border-white/30 border-t-white rounded-full animate-spin mr-2"></div>
            Envoi en cours...
          </div>
          <span v-else>Contacter l'expert</span>
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
import { X, CheckCircle } from 'lucide-vue-next'

const props = defineProps({
  isOpen: Boolean,
  expert: Object
})

const emit = defineEmits(['close', 'submit'])

const contact = ref({
  subject: '',
  message: '',
  budget: ''
})

const isSubmitting = ref(false)

const close = () => {
  emit('close')
}

const submitContact = async () => {
  // Validation basique
  if (!contact.value.subject || !contact.value.message) {
    return
  }
  
  isSubmitting.value = true
  
  try {
    // Dans un environnement réel, envoyer à Supabase
    await new Promise(resolve => setTimeout(resolve, 1000))
    
    emit('submit', {
      expertId: props.expert.id,
      ...contact.value
    })
    
    // Réinitialiser le formulaire
    contact.value = {
      subject: '',
      message: '',
      budget: ''
    }
    
    close()
  } catch (error) {
    console.error('Erreur lors de l\'envoi du message:', error)
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