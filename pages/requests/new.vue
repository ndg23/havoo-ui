<template>
  <div class="max-w-3xl mx-auto px-4 pt-5 pb-16">
    <!-- En-tête -->
    <div class="mb-6">
      <h1 class="text-2xl font-bold text-gray-900 dark:text-white">Publier une demande</h1>
      <p class="text-gray-600 dark:text-gray-400 mt-1">
        Décrivez clairement votre besoin pour recevoir des propositions d'experts qualifiés
      </p>
    </div>

    <!-- Formulaire de demande -->
    <form @submit.prevent="submitRequest" class="space-y-6">
      <!-- Informations de base -->
      <div class="bg-white dark:bg-gray-800 rounded-xl p-5 border border-gray-200 dark:border-gray-700 shadow-sm">
        <h2 class="text-lg font-semibold text-gray-900 dark:text-white mb-4">
          Informations générales
        </h2>
        
        <div class="space-y-4">
          <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Titre de la demande*</label>
            <input 
              type="text" 
              v-model="requestData.title" 
              required
              placeholder="Ex: Création d'un site web e-commerce"
              class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
            />
          </div>
          
          <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Catégorie*</label>
            <select 
              v-model="requestData.category" 
              required
              class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
            >
              <option value="" disabled selected>Sélectionner une catégorie</option>
              <option v-for="category in categories" :key="category.id" :value="category.id">
                {{ category.name }}
              </option>
            </select>
          </div>
          
          <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Description détaillée*</label>
            <textarea 
              v-model="requestData.description" 
              required
              rows="6"
              placeholder="Décrivez votre projet en détail : objectifs, fonctionnalités attendues, contraintes éventuelles..."
              class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
            ></textarea>
            <p class="mt-1 text-xs text-gray-500 dark:text-gray-400">
              {{ 2000 - (requestData.description?.length || 0) }} caractères restants
            </p>
          </div>
        </div>
      </div>
      
      <!-- Fichiers et documents -->
      <div class="bg-white dark:bg-gray-800 rounded-xl p-5 border border-gray-200 dark:border-gray-700 shadow-sm">
        <h2 class="text-lg font-semibold text-gray-900 dark:text-white mb-4">
          Documents annexes
        </h2>
        
        <div class="space-y-4">
          <div class="border-dashed border-2 border-gray-300 dark:border-gray-600 rounded-lg p-6 text-center">
            <input type="file" id="file-upload" class="hidden" multiple @change="handleFileUpload" />
            <label for="file-upload" class="cursor-pointer">
              <UploadCloud class="mx-auto h-10 w-10 text-gray-400 dark:text-gray-500 mb-3" />
              <p class="text-sm text-gray-600 dark:text-gray-400">
                Déposez vos fichiers ici ou <span class="text-primary-600 dark:text-primary-400 font-medium">parcourir</span>
              </p>
              <p class="text-xs text-gray-500 dark:text-gray-500 mt-1">
                PDF, Word, Excel, images (max 10 MB chacun)
              </p>
            </label>
          </div>
          
          <!-- Liste des fichiers ajoutés -->
          <div v-if="requestData.files.length > 0" class="space-y-2">
            <div 
              v-for="(file, index) in requestData.files" 
              :key="index"
              class="flex items-center justify-between p-3 bg-gray-50 dark:bg-gray-700 rounded-lg"
            >
              <div class="flex items-center">
                <FileText class="h-5 w-5 text-gray-500 dark:text-gray-400 mr-3" />
                <div class="text-sm">
                  <p class="text-gray-700 dark:text-gray-300 font-medium truncate max-w-xs">{{ file.name }}</p>
                  <p class="text-xs text-gray-500 dark:text-gray-500">{{ formatFileSize(file.size) }}</p>
                </div>
              </div>
              <button 
                type="button" 
                @click="removeFile(index)"
                class="p-1 rounded-full hover:bg-gray-200 dark:hover:bg-gray-600"
              >
                <X class="h-4 w-4 text-gray-500 dark:text-gray-400" />
              </button>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Budget et délai -->
      <div class="bg-white dark:bg-gray-800 rounded-xl p-5 border border-gray-200 dark:border-gray-700 shadow-sm">
        <h2 class="text-lg font-semibold text-gray-900 dark:text-white mb-4">
          Budget et délai
        </h2>
        
        <div class="space-y-4">
          <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Budget estimé (FCFA)*</label>
            <div class="flex gap-4">
              <div class="w-1/2">
                <label class="block text-xs text-gray-500 dark:text-gray-400 mb-1">Minimum</label>
                <input 
                  type="number" 
                  v-model="requestData.budget_min" 
                  required
                  min="0"
                  step="1000"
                  class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
                />
              </div>
              <div class="w-1/2">
                <label class="block text-xs text-gray-500 dark:text-gray-400 mb-1">Maximum</label>
                <input 
                  type="number" 
                  v-model="requestData.budget_max" 
                  required
                  min="0"
                  step="1000"
                  class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
                />
              </div>
            </div>
          </div>
          
          <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Délai souhaité*</label>
            <input 
              type="date" 
              v-model="requestData.deadline" 
              required
              :min="minDate"
              class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
            />
          </div>
          
          <div>
            <label class="flex items-center space-x-2">
              <input 
                type="checkbox" 
                v-model="requestData.is_urgent"
                class="h-4 w-4 rounded border-gray-300 text-primary-600 focus:ring-primary-500"
              />
              <span class="text-sm text-gray-700 dark:text-gray-300">Marquer comme urgent</span>
            </label>
            <p class="mt-1 text-xs text-gray-500 dark:text-gray-500 ml-6">
              Les demandes urgentes attirent plus rapidement l'attention des experts
            </p>
          </div>
        </div>
      </div>
      
      <!-- Préférences supplémentaires -->
      <div class="bg-white dark:bg-gray-800 rounded-xl p-5 border border-gray-200 dark:border-gray-700 shadow-sm">
        <h2 class="text-lg font-semibold text-gray-900 dark:text-white mb-4">
          Préférences supplémentaires
        </h2>
        
        <div class="space-y-4">
          <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Compétences requises</label>
            <div class="flex items-center gap-2">
              <input 
                type="text" 
                v-model="newSkill" 
                @keyup.enter="addSkill"
                placeholder="Ajouter une compétence et appuyez sur Entrée"
                class="flex-1 px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
              />
              <button 
                type="button"
                @click="addSkill"
                class="p-2 bg-primary-600 hover:bg-primary-700 text-white rounded-lg"
              >
                <Plus class="h-5 w-5" />
              </button>
            </div>
            
            <div v-if="requestData.skills.length > 0" class="flex flex-wrap gap-2 mt-3">
              <div 
                v-for="(skill, index) in requestData.skills" 
                :key="index"
                class="flex items-center gap-1 px-3 py-1 bg-primary-100 dark:bg-primary-900/30 text-primary-800 dark:text-primary-400 rounded-full text-sm"
              >
                <span>{{ skill }}</span>
                <button type="button" @click="removeSkill(skill)" class="focus:outline-none">
                  <X class="h-3.5 w-3.5" />
                </button>
              </div>
            </div>
          </div>
          
          <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Visibilité de la demande</label>
            <div class="space-y-2">
              <label class="flex items-center space-x-2">
                <input 
                  type="radio" 
                  v-model="requestData.visibility" 
                  value="public"
                  class="h-4 w-4 border-gray-300 text-primary-600 focus:ring-primary-500"
                />
                <span class="text-sm text-gray-700 dark:text-gray-300">Publique (visible par tous les experts)</span>
              </label>
              <label class="flex items-center space-x-2">
                <input 
                  type="radio" 
                  v-model="requestData.visibility" 
                  value="private"
                  class="h-4 w-4 border-gray-300 text-primary-600 focus:ring-primary-500"
                />
                <span class="text-sm text-gray-700 dark:text-gray-300">Privée (inviter des experts spécifiques uniquement)</span>
              </label>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Boutons d'action -->
      <div class="flex justify-end space-x-3">
        <button 
          type="button" 
          @click="saveAsDraft"
          class="px-4 py-2 bg-gray-100 hover:bg-gray-200 dark:bg-gray-700 dark:hover:bg-gray-600 text-gray-800 dark:text-gray-200 font-medium rounded-lg text-sm transition-colors"
          :disabled="isSubmitting"
        >
          Enregistrer comme brouillon
        </button>
        <button 
          type="submit" 
          class="px-6 py-2 bg-primary-600 hover:bg-primary-700 text-white font-medium rounded-lg text-sm transition-colors flex items-center"
          :disabled="isSubmitting"
        >
          <span v-if="isSubmitting">
            <span class="inline-block h-4 w-4 border-2 border-white/20 border-t-white rounded-full animate-spin mr-2"></span>
            Publication...
          </span>
          <span v-else>Publier la demande</span>
        </button>
      </div>
    </form>
    
    <!-- Notification de succès -->
    <div 
      v-if="showSuccess" 
      class="fixed bottom-6 right-6 bg-green-100 dark:bg-green-900/30 border-l-4 border-green-500 text-green-700 dark:text-green-400 p-4 rounded-lg shadow-lg max-w-sm animated fadeInUp"
    >
      <div class="flex">
        <CheckCircle class="h-5 w-5 mt-0.5 mr-3" />
        <div>
          <p class="font-medium">Demande publiée avec succès!</p>
          <p class="text-sm">Vous serez notifié dès qu'un expert proposera ses services.</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useSupabaseClient, useSupabaseUser } from '#imports'
import { 
  UploadCloud, 
  FileText, 
  X, 
  Plus, 
  CheckCircle,
} from 'lucide-vue-next'

const router = useRouter()
const supabase = useSupabaseClient()
const user = useSupabaseUser()

// État local
const isSubmitting = ref(false)
const showSuccess = ref(false)
const newSkill = ref('')

// Données de la demande
const requestData = ref({
  title: '',
  category: '',
  description: '',
  budget_min: 15000,
  budget_max: 100000,
  deadline: '',
  is_urgent: false,
  files: [],
  skills: [],
  visibility: 'public'
})

// Catégories (à remplacer par des données de l'API)
const categories = ref([
  { id: 1, name: 'Développement web' },
  { id: 2, name: 'Développement mobile' },
  { id: 3, name: 'Design graphique' },
  { id: 4, name: 'Référencement SEO' },
  { id: 5, name: 'Rédaction web' },
  { id: 6, name: 'Traduction' },
  { id: 7, name: 'Marketing digital' },
  { id: 8, name: 'Gestion de projets' },
  { id: 9, name: 'Assistance administrative' },
  { id: 10, name: 'Autre' }
])

// Computed
const minDate = computed(() => {
  const today = new Date()
  today.setDate(today.getDate() + 1)
  return today.toISOString().split('T')[0]
})

// Méthodes
const handleFileUpload = (event) => {
  const files = Array.from(event.target.files)
  
  files.forEach(file => {
    // Vérifier la taille du fichier (10 MB max)
    if (file.size <= 10 * 1024 * 1024) {
      requestData.value.files.push(file)
    } else {
      alert(`Le fichier ${file.name} dépasse la taille maximale autorisée (10 MB)`)
    }
  })
  
  // Réinitialiser l'input file pour permettre de sélectionner le même fichier à nouveau
  event.target.value = null
}

const removeFile = (index) => {
  requestData.value.files.splice(index, 1)
}

const formatFileSize = (size) => {
  if (size < 1024) {
    return size + ' B'
  } else if (size < 1024 * 1024) {
    return (size / 1024).toFixed(1) + ' KB'
  } else {
    return (size / (1024 * 1024)).toFixed(1) + ' MB'
  }
}

const addSkill = () => {
  if (newSkill.value.trim() && !requestData.value.skills.includes(newSkill.value.trim())) {
    requestData.value.skills.push(newSkill.value.trim())
    newSkill.value = ''
  }
}

const removeSkill = (skill) => {
  requestData.value.skills = requestData.value.skills.filter(s => s !== skill)
}

const saveAsDraft = async () => {
  try {
    isSubmitting.value = true
    
    // Simuler la sauvegarde comme brouillon
    console.log('Saving as draft:', requestData.value)
    
    // Dans un environnement réel, nous sauvegarderions la demande dans Supabase
    /*
    const { error } = await supabase
      .from('requests')
      .insert({
        ...requestData.value,
        status: 'draft',
        user_id: user.value.id
      })

    if (error) throw error
    */
    
    // Simuler un délai
    setTimeout(() => {
      isSubmitting.value = false
      router.push('/account/requests')
    }, 1000)
  } catch (error) {
    console.error('Erreur lors de la sauvegarde du brouillon:', error)
    isSubmitting.value = false
  }
}

const submitRequest = async () => {
  try {
    isSubmitting.value = true
    
    // Simuler la publication de la demande
    console.log('Publishing request:', requestData.value)
    
    // Dans un environnement réel, nous sauvegarderions la demande dans Supabase
    /*
    const { error } = await supabase
      .from('requests')
      .insert({
        ...requestData.value,
        status: 'open',
        user_id: user.value.id
      })

    if (error) throw error
    */
    
    // Simuler un délai
    setTimeout(() => {
      isSubmitting.value = false
      showSuccess.value = true
      
      // Rediriger après 2 secondes
      setTimeout(() => {
        router.push('/account/requests')
      }, 2000)
    }, 1500)
  } catch (error) {
    console.error('Erreur lors de la publication de la demande:', error)
    isSubmitting.value = false
  }
}

// Initialisation
onMounted(() => {
  // Définir la date par défaut à 7 jours à partir d'aujourd'hui
  const defaultDate = new Date()
  defaultDate.setDate(defaultDate.getDate() + 7)
  requestData.value.deadline = defaultDate.toISOString().split('T')[0]
})

definePageMeta({
  layout: 'default'
})
</script>

<style scoped>
.animated {
  animation-duration: 0.4s;
  animation-fill-mode: both;
}

@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translate3d(0, 10px, 0);
  }
  to {
    opacity: 1;
    transform: translate3d(0, 0, 0);
  }
}

.fadeInUp {
  animation-name: fadeInUp;
}
</style>