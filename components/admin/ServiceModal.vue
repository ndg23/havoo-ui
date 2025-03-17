<template>
  <AdminModal 
    :show="show" 
    :title="mode === 'edit' ? 'Modifier le service' : 'Ajouter un service'"
    :size="'lg'"
    @close="$emit('close')"
  >
    <template #icon>
      <Package v-if="mode === 'edit'" class="mr-2 h-5 w-5 text-blue-500" />
      <PackagePlus v-else class="mr-2 h-5 w-5 text-green-500" />
    </template>
    
    <form @submit.prevent="saveService" class="p-6 space-y-6">
      <!-- Informations principales -->
      <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div>
          <label for="name" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
            Nom du service *
          </label>
          <input 
            id="name"
            v-model="formData.name"
            type="text" 
            required
            class="w-full px-4 py-3 rounded-xl border border-gray-300 dark:border-gray-700 bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-blue-500 transition-all"
            placeholder="ex: Coaching personnel"
          />
        </div>
        
        <div>
          <label for="category" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
            Catégorie *
          </label>
          <div class="relative">
            <select 
              id="category"
              v-model="formData.category_id"
              required
              class="w-full appearance-none px-4 py-3 rounded-xl border border-gray-300 dark:border-gray-700 bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-blue-500 transition-all"
            >
              <option value="" disabled>Sélectionnez une catégorie</option>
              <option 
                v-for="category in categories" 
                :key="category.id" 
                :value="category.id"
              >
                {{ category.name }}
              </option>
            </select>
            <ChevronDown class="absolute right-4 top-1/2 transform -translate-y-1/2 h-4 w-4 text-gray-500 pointer-events-none" />
          </div>
        </div>
      </div>
      
      <!-- Prix et durée -->
      <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
        <div>
          <label for="price" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
            Prix (FCFA) *
          </label>
          <div class="relative">
            <input 
              id="price"
              v-model.number="formData.price"
              type="number" 
              min="0"
              step="0.01"
              required
              class="w-full pl-9 pr-4 py-3 rounded-xl border border-gray-300 dark:border-gray-700 bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-blue-500 transition-all"
            />
            <DollarSign class="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-gray-500" />
          </div>
        </div>
        
        <div>
          <label for="duration" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
            Durée (minutes) *
          </label>
          <div class="relative">
            <input 
              id="duration"
              v-model.number="formData.duration"
              type="number" 
              min="5"
              step="5"
              required
              class="w-full pl-9 pr-4 py-3 rounded-xl border border-gray-300 dark:border-gray-700 bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-blue-500 transition-all"
            />
            <Clock class="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-gray-500" />
          </div>
        </div>
        
        <div>
          <label for="icon" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
            Icône (emoji)
          </label>
          <div class="relative">
            <input 
              id="icon"
              v-model="formData.icon"
              type="text" 
              maxlength="2"
              class="w-full px-4 py-3 rounded-xl border border-gray-300 dark:border-gray-700 bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-blue-500 transition-all text-center text-2xl"
            />
          </div>
        </div>
      </div>
      
      <!-- Description -->
      <div>
        <label for="description" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
          Description
        </label>
        <textarea 
          id="description"
          v-model="formData.description"
          rows="4"
          class="w-full px-4 py-3 rounded-xl border border-gray-300 dark:border-gray-700 bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-blue-500 transition-all resize-none"
          placeholder="Décrivez ce service en détail..."
        ></textarea>
      </div>
      
      <!-- Statut -->
      <div class="flex items-center">
        <label class="flex items-center cursor-pointer">
          <div class="relative">
            <input 
              type="checkbox" 
              v-model="formData.active"
              class="sr-only"
            />
            <div class="block bg-gray-200 dark:bg-gray-700 w-14 h-8 rounded-full"></div>
            <div 
              class="dot absolute left-1 top-1 bg-white w-6 h-6 rounded-full transition-transform"
              :class="{ 'transform translate-x-6 bg-green-500': formData.active }"
            ></div>
          </div>
          <div class="ml-3 text-sm font-medium text-gray-700 dark:text-gray-300">
            {{ formData.active ? 'Service actif' : 'Service inactif' }}
          </div>
        </label>
      </div>
    </form>
    
    <template #footer>
      <div class="flex justify-end gap-3">
        <button
          type="button"
          @click="$emit('close')"
          class="px-4 py-2 text-sm font-medium text-gray-700 dark:text-gray-200 bg-white dark:bg-gray-800 border border-gray-300 dark:border-gray-700 rounded-lg hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors"
        >
          Annuler
        </button>
        
        <button
          type="button"
          @click="saveService"
          class="px-4 py-2 text-sm font-medium text-white bg-blue-500 rounded-lg hover:bg-blue-600 transition-colors flex items-center"
          :disabled="saving"
        >
          <Loader2 v-if="saving" class="animate-spin h-4 w-4 mr-2" />
          <Save v-else class="h-4 w-4 mr-2" />
          {{ mode === 'edit' ? 'Enregistrer' : 'Créer' }}
        </button>
      </div>
    </template>
  </AdminModal>
</template>

<script setup>
import AdminModal from '@/components/admin/AdminModal.vue'
import { ref, watch } from 'vue'
import { 
  Package, PackagePlus, Save, ChevronDown, 
  DollarSign, Clock, Loader2 
} from 'lucide-vue-next'

const props = defineProps({
  show: Boolean,
  mode: {
    type: String,
    default: 'add',
    validator: (value) => ['add', 'edit', 'view'].includes(value)
  },
  service: {
    type: Object,
    default: () => ({
      name: '',
      description: '',
      category_id: '',
      price: 0,
      duration: 60,
      active: true,
      icon: '🔧'
    })
  },
  categories: {
    type: Array,
    default: () => []
  }
})

const emit = defineEmits(['close', 'save'])

const formData = ref({...props.service})
const saving = ref(false)

// Mettre à jour le formulaire lorsque le service change
watch(() => props.service, (newService) => {
  formData.value = {...newService}
}, { deep: true })

// Mettre à jour le formulaire lorsque le mode change
watch(() => props.mode, () => {
  if (props.mode === 'add') {
    formData.value = {
      name: '',
      description: '',
      category_id: '',
      price: 0,
      duration: 60,
      active: true,
      icon: '🔧'
    }
  } else {
    formData.value = {...props.service}
  }
})

function saveService() {
  try {
    saving.value = true
    
    // Valider les champs obligatoires
    if (!formData.value.name || !formData.value.category_id) {
      alert('Veuillez remplir tous les champs obligatoires')
      saving.value = false
      return
    }
    
    // S'assurer que le prix et la durée sont des nombres
    const price = parseFloat(formData.value.price)
    const duration = parseInt(formData.value.duration)
    
    if (isNaN(price) || price < 0) {
      alert('Le prix doit être un nombre positif')
      saving.value = false
      return
    }
    
    if (isNaN(duration) || duration < 5) {
      alert('La durée doit être d\'au moins 5 minutes')
      saving.value = false
      return
    }
    
    // Mettre à jour les valeurs avec les bons types
    const serviceData = {
      ...formData.value,
      price,
      duration
    }
    
    emit('save', serviceData)
  } catch (error) {
    console.error('Erreur lors de la sauvegarde:', error)
    alert('Une erreur est survenue lors de la sauvegarde')
  } finally {
    saving.value = false
  }
}
</script>

<style scoped>
.dot {
  transition: transform 0.3s ease, background-color 0.3s ease;
}
</style> 