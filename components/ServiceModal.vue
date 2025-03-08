<template>
  <Teleport to="body">
    <transition
      enter-active-class="transition duration-300 ease-out"
      enter-from-class="opacity-0"
      enter-to-class="opacity-100"
      leave-active-class="transition duration-200 ease-in"
      leave-from-class="opacity-100"
      leave-to-class="opacity-0"
    >
      <div v-if="show" class="fixed inset-0 z-50 overflow-y-auto">
        <!-- Overlay -->
        <div 
          class="fixed inset-0 bg-black/70 backdrop-blur-sm" 
          @click="$emit('close')"
        ></div>
        
        <!-- Modal -->
        <div class="flex min-h-full items-center justify-center p-4">
          <transition
            enter-active-class="transition duration-300 ease-out"
            enter-from-class="translate-y-8 opacity-0"
            enter-to-class="translate-y-0 opacity-100"
            leave-active-class="transition duration-200 ease-in"
            leave-from-class="translate-y-0 opacity-100"
            leave-to-class="translate-y-8 opacity-0"
          >
            <div 
              class="relative w-full max-w-2xl rounded-2xl bg-white dark:bg-gray-900 shadow-xl transform"
            >
              <!-- En-tête du modal avec barre de progression -->
              <div class="border-b border-gray-200 dark:border-gray-800">
                <div class="h-1 bg-primary-500 rounded-t-2xl" :style="{ width: `${progress}%` }"></div>
                <div class="p-5 flex items-center justify-between">
                  <h3 class="text-xl font-bold text-black dark:text-white">
                    {{ isEdit ? 'Modifier le service' : 'Nouveau service' }}
                  </h3>
                  <button 
                    @click="$emit('close')" 
                    class="h-8 w-8 rounded-full flex items-center justify-center hover:bg-gray-100 dark:hover:bg-gray-800 transition-colors"
                  >
                    <X class="h-5 w-5 text-gray-500 dark:text-gray-400" />
                  </button>
                </div>
              </div>
              
              <!-- Corps du modal -->
              <div class="p-6">
                <form @submit.prevent="submitForm" class="space-y-6">
                  <!-- Étape 1: Informations générales -->
                  <div v-if="currentStep === 1" class="space-y-5">
                    <div>
                      <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                        Titre du service <span class="text-red-500">*</span>
                      </label>
                      <input
                        v-model="form.title"
                        type="text"
                        class="w-full px-4 py-3 bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors"
                        placeholder="Ex: Ménage complet d'appartement"
                        required
                      />
                      <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                        Donnez un titre clair et précis à votre service.
                      </p>
                    </div>
                    
                    <div>
                      <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                        Catégorie <span class="text-red-500">*</span>
                      </label>
                      <div class="relative">
                        <select
                          v-model="form.category_id"
                          class="w-full px-4 py-3 bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-xl appearance-none focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors"
                          required
                        >
                          <option disabled value="">Sélectionner une catégorie</option>
                          <option 
                            v-for="category in categories" 
                            :key="category.id" 
                            :value="category.id"
                          >
                            {{ category.name }}
                          </option>
                        </select>
                        <ChevronDown class="absolute right-4 top-1/2 transform -translate-y-1/2 h-5 w-5 text-gray-400 pointer-events-none" />
                      </div>
                    </div>
                    
                    <div>
                      <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                        Description <span class="text-red-500">*</span>
                      </label>
                      <textarea
                        v-model="form.description"
                        rows="4"
                        class="w-full px-4 py-3 bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors"
                        placeholder="Décrivez votre service en détail..."
                        required
                      ></textarea>
                    </div>
                  </div>
                  
                  <!-- Étape 2: Tarification et disponibilité -->
                  <div v-if="currentStep === 2" class="space-y-5">
                    <div>
                      <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                        Prix <span class="text-red-500">*</span>
                      </label>
                      <div class="relative">
                        <input
                          v-model="form.price"
                          type="number"
                          min="0"
                          step="0.01"
                          class="w-full px-4 py-3 bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-xl pl-10 focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors"
                          placeholder="0.00"
                          required
                        />
                        <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                          <span class="text-gray-500 dark:text-gray-400">€</span>
                        </div>
                      </div>
                      <div class="mt-3 flex items-center space-x-3">
                        <span class="text-xs font-medium text-gray-500 dark:text-gray-400">Type de tarif:</span>
                        <div class="flex items-center space-x-4">
                          <label class="flex items-center">
                            <input 
                              type="radio" 
                              v-model="form.price_type" 
                              value="hourly"
                              class="h-4 w-4 text-primary-500 focus:ring-primary-500 border-gray-300 dark:border-gray-600"
                            />
                            <span class="ml-2 text-sm text-gray-700 dark:text-gray-300">Horaire</span>
                          </label>
                          <label class="flex items-center">
                            <input 
                              type="radio" 
                              v-model="form.price_type" 
                              value="fixed"
                              class="h-4 w-4 text-primary-500 focus:ring-primary-500 border-gray-300 dark:border-gray-600"
                            />
                            <span class="ml-2 text-sm text-gray-700 dark:text-gray-300">Forfait</span>
                          </label>
                        </div>
                      </div>
                    </div>
                    
                    <div>
                      <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                        Délai d'intervention
                      </label>
                      <div class="relative">
                        <select
                          v-model="form.response_time"
                          class="w-full px-4 py-3 bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-xl appearance-none focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors"
                        >
                          <option value="immediate">Immédiat (moins de 24h)</option>
                          <option value="fast">Rapide (1-2 jours)</option>
                          <option value="standard">Standard (3-5 jours)</option>
                          <option value="relaxed">Flexible (plus de 5 jours)</option>
                        </select>
                        <ChevronDown class="absolute right-4 top-1/2 transform -translate-y-1/2 h-5 w-5 text-gray-400 pointer-events-none" />
                      </div>
                    </div>
                    
                    <div>
                      <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                        Zone d'intervention
                      </label>
                      <input
                        v-model="form.location"
                        type="text"
                        class="w-full px-4 py-3 bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors"
                        placeholder="Ex: Paris et proche banlieue"
                      />
                    </div>
                  </div>
                  
                  <!-- Étape 3: Détails et visibilité -->
                  <div v-if="currentStep === 3" class="space-y-5">
                    <div>
                      <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                        Compétences requises
                      </label>
                      <div class="flex flex-wrap gap-2 mb-2">
                        <div 
                          v-for="(skill, index) in form.skills" 
                          :key="index"
                          class="bg-primary-100 dark:bg-primary-900 text-primary-700 dark:text-primary-300 px-3 py-1.5 rounded-full text-sm font-medium flex items-center"
                        >
                          {{ skill }}
                          <button 
                            @click="removeSkill(index)" 
                            type="button"
                            class="ml-1.5 h-4 w-4 rounded-full bg-primary-200 dark:bg-primary-800 flex items-center justify-center hover:bg-primary-300 dark:hover:bg-primary-700 transition-colors"
                          >
                            <X class="h-3 w-3" />
                          </button>
                        </div>
                      </div>
                      <div class="flex">
                        <input
                          v-model="newSkill"
                          type="text"
                          class="w-full px-4 py-3 bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-l-xl focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors"
                          placeholder="Ajouter une compétence..."
                          @keyup.enter.prevent="addSkill"
                        />
                        <button 
                          @click="addSkill" 
                          type="button"
                          class="bg-primary-500 hover:bg-primary-600 text-white px-4 rounded-r-xl transition-colors"
                        >
                          <Plus class="h-5 w-5" />
                        </button>
                      </div>
                    </div>
                    
                    <div>
                      <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                        Options supplémentaires
                      </label>
                      <div class="space-y-3">
                        <label class="flex items-start">
                          <input 
                            type="checkbox" 
                            v-model="form.is_featured"
                            class="h-4 w-4 mt-1 text-primary-500 focus:ring-primary-500 border-gray-300 dark:border-gray-600 rounded"
                          />
                          <div class="ml-3">
                            <span class="text-sm font-medium text-gray-700 dark:text-gray-300">Service premium</span>
                            <p class="text-xs text-gray-500 dark:text-gray-400">
                              Mettre en avant ce service (apparaît en haut des résultats)
                            </p>
                          </div>
                        </label>
                        
                        <label class="flex items-start">
                          <input 
                            type="checkbox" 
                            v-model="form.emergency_available"
                            class="h-4 w-4 mt-1 text-primary-500 focus:ring-primary-500 border-gray-300 dark:border-gray-600 rounded"
                          />
                          <div class="ml-3">
                            <span class="text-sm font-medium text-gray-700 dark:text-gray-300">Disponible en urgence</span>
                            <p class="text-xs text-gray-500 dark:text-gray-400">
                              Vous êtes disponible pour des demandes urgentes
                            </p>
                          </div>
                        </label>
                      </div>
                    </div>
                    
                    <div>
                      <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                        Statut du service
                      </label>
                      <div class="relative">
                        <select
                          v-model="form.status"
                          class="w-full px-4 py-3 bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-xl appearance-none focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors"
                        >
                          <option value="active">Actif (visible par tous)</option>
                          <option value="draft">Brouillon (visible uniquement par vous)</option>
                          <option value="paused">En pause (temporairement indisponible)</option>
                        </select>
                        <ChevronDown class="absolute right-4 top-1/2 transform -translate-y-1/2 h-5 w-5 text-gray-400 pointer-events-none" />
                      </div>
                    </div>
                  </div>
                  
                  <!-- Actions du formulaire -->
                  <div class="flex justify-between pt-4 border-t border-gray-200 dark:border-gray-800">
                    <!-- Bouton retour (sauf pour la première étape) -->
                    <button 
                      v-if="currentStep > 1"
                      type="button"
                      @click="currentStep--"
                      class="px-5 py-2.5 bg-white dark:bg-gray-800 border border-gray-300 dark:border-gray-600 hover:bg-gray-50 dark:hover:bg-gray-700 rounded-full text-gray-700 dark:text-gray-300 font-medium transition-colors flex items-center"
                    >
                      <ChevronLeft class="h-4 w-4 mr-1.5" />
                      Retour
                    </button>
                    <div v-else class="w-24"></div> <!-- Espace réservé pour l'alignement -->
                    
                    <!-- Boutons suivant et soumettre -->
                    <div>
                      <button 
                        v-if="currentStep < totalSteps"
                        type="button"
                        @click="goToNextStep"
                        class="px-5 py-2.5 bg-primary-500 hover:bg-primary-600 rounded-full text-white font-medium transition-colors flex items-center"
                      >
                        Suivant
                        <ChevronRight class="h-4 w-4 ml-1.5" />
                      </button>
                      
                      <button 
                        v-else
                        type="submit"
                        :disabled="loading"
                        class="px-6 py-2.5 bg-primary-500 hover:bg-primary-600 rounded-full text-white font-medium transition-colors flex items-center"
                      >
                        <Loader2 v-if="loading" class="h-4 w-4 mr-2 animate-spin" />
                        {{ isEdit ? 'Mettre à jour' : 'Créer le service' }}
                      </button>
                    </div>
                  </div>
                </form>
              </div>
            </div>
          </transition>
        </div>
      </div>
    </transition>
  </Teleport>
</template>

<script setup>
import { ref, computed, watch, onMounted } from 'vue'
import { useSupabaseClient } from '#imports'
import { 
  Plus, X, Check, ChevronDown, ChevronLeft, 
  ChevronRight, Loader2
} from 'lucide-vue-next'

const props = defineProps({
  show: Boolean,
  service: {
    type: Object,
    default: () => null
  }
})

const emit = defineEmits(['close', 'saved'])

const client = useSupabaseClient()

// États
const currentStep = ref(1)
const totalSteps = 3
const loading = ref(false)
const categories = ref([])
const newSkill = ref('')

// Formulaire
const form = ref({
  title: '',
  category_id: '',
  description: '',
  price: '',
  price_type: 'hourly',
  response_time: 'standard',
  location: '',
  skills: [],
  is_featured: false,
  emergency_available: false,
  status: 'active'
})

// Déterminer si c'est une édition ou une création
const isEdit = computed(() => !!props.service)

// Calcul de la progression
const progress = computed(() => (currentStep.value / totalSteps) * 100)

// Charger les catégories
const fetchCategories = async () => {
  try {
    const { data, error } = await client
      .from('service_categories')
      .select('id, name')
    
    if (error) throw error
    categories.value = data || []
  } catch (error) {
    console.error('Erreur lors du chargement des catégories:', error)
  }
}

// Initialiser le formulaire avec les données existantes
const initForm = () => {
  if (props.service) {
    form.value = {
      title: props.service.title || '',
      category_id: props.service.category_id || '',
      description: props.service.description || '',
      price: props.service.price || '',
      price_type: props.service.price_type || 'hourly',
      response_time: props.service.response_time || 'standard',
      location: props.service.location || '',
      skills: props.service.skills || [],
      is_featured: props.service.is_featured || false,
      emergency_available: props.service.emergency_available || false,
      status: props.service.status || 'active'
    }
  } else {
    // Réinitialiser pour un nouveau service
    form.value = {
      title: '',
      category_id: '',
      description: '',
      price: '',
      price_type: 'hourly',
      response_time: 'standard',
      location: '',
      skills: [],
      is_featured: false,
      emergency_available: false,
      status: 'active'
    }
  }
  
  // Toujours commencer à la première étape
  currentStep.value = 1
}

// Validation pour passer à l'étape suivante
const goToNextStep = () => {
  if (currentStep.value === 1) {
    // Valider les champs de l'étape 1
    if (!form.value.title || !form.value.category_id || !form.value.description) {
      alert('Veuillez remplir tous les champs obligatoires.')
      return
    }
  }
  
  if (currentStep.value === 2) {
    // Valider les champs de l'étape 2
    if (!form.value.price) {
      alert('Veuillez indiquer un prix.')
      return
    }
  }
  
  currentStep.value++
}

// Ajouter une compétence
const addSkill = () => {
  const skill = newSkill.value.trim()
  if (skill && !form.value.skills.includes(skill)) {
    form.value.skills.push(skill)
    newSkill.value = ''
  }
}

// Supprimer une compétence
const removeSkill = (index) => {
  form.value.skills.splice(index, 1)
}

// Soumettre le formulaire
const submitForm = async () => {
  loading.value = true
  
  try {
    const serviceData = {
      ...form.value,
      price: parseFloat(form.value.price),
      updated_at: new Date().toISOString()
    }
    
    let response
    
    if (isEdit.value) {
      // Mise à jour d'un service existant
      const { data, error } = await client
        .from('services')
        .update(serviceData)
        .eq('id', props.service.id)
        .select()
      
      if (error) throw error
      response = data[0]
    } else {
      // Création d'un nouveau service
      serviceData.created_at = new Date().toISOString()
      serviceData.user_id = (await client.auth.getUser()).data.user.id
      
      const { data, error } = await client
        .from('services')
        .insert(serviceData)
        .select()
      
      if (error) throw error
      response = data[0]
    }
    
    emit('saved', response)
    emit('close')
  } catch (error) {
    console.error('Erreur lors de la soumission:', error)
    alert(`Erreur: ${error.message}`)
  } finally {
    loading.value = false
  }
}

// Observer les changements de la prop show
watch(() => props.show, (newVal) => {
  if (newVal) {
    initForm()
  }
})

// Initialisation
onMounted(() => {
  fetchCategories()
})
</script> 