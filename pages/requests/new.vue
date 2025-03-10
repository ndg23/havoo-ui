<template>
  <div class="max-w-2xl mx-auto px-4 pt-5 pb-16">
    <!-- En-tête avec illustration subtile -->
    <div class="mb-7 bg-white dark:bg-gray-800 rounded-xl p-5 border-l-4 border-primary-500 shadow-sm flex items-center justify-between">
      <div>
        <h1 class="text-2xl font-bold text-gray-900 dark:text-white">Publiez votre demande</h1>
        <p class="text-gray-600 dark:text-gray-400 mt-1">
          Des experts qualifiés vous proposeront leurs services
        </p>
      </div>
      <div class="bg-primary-50 dark:bg-primary-900/20 p-3 rounded-full">
        <MessageSquarePlus class="h-6 w-6 text-primary-600 dark:text-primary-400" />
      </div>
    </div>

    <!-- Formulaire principal -->
    <form @submit.prevent="submitRequest" class="space-y-6">
      <!-- Titre de la demande -->
      <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 p-5 transition-shadow hover:shadow-sm">
        <label for="title" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">
          Titre de votre demande
        </label>
        <input 
          id="title"
          v-model="requestForm.title"
          type="text"
          placeholder="Ex: Création d'un site web pour mon restaurant"
          class="w-full px-4 py-3 rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
          :class="{ 'border-red-500 dark:border-red-500': errors.title }"
          required
        />
        <p v-if="errors.title" class="text-red-600 dark:text-red-400 text-sm mt-1">{{ errors.title }}</p>
        <p v-else class="text-gray-500 dark:text-gray-400 text-xs mt-1.5">Soyez précis et concis (max. 100 caractères)</p>
      </div>

      <!-- Description -->
      <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 p-5 transition-shadow hover:shadow-sm">
        <label for="description" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">
          Description détaillée
        </label>
        <textarea 
          id="description"
          v-model="requestForm.description"
          placeholder="Décrivez votre besoin en détail... Qu'attendez-vous exactement ? Avez-vous des contraintes particulières ?"
          rows="5"
          class="w-full px-4 py-3 rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
          :class="{ 'border-red-500 dark:border-red-500': errors.description }"
          required
        ></textarea>
        <p v-if="errors.description" class="text-red-600 dark:text-red-400 text-sm mt-1">{{ errors.description }}</p>
        <div v-else class="flex justify-between text-xs mt-1.5">
          <span class="text-gray-500 dark:text-gray-400">Plus votre description est détaillée, plus les propositions seront pertinentes</span>
          <span :class="requestForm.description.length > 800 ? 'text-amber-600' : 'text-gray-500 dark:text-gray-400'">
            {{ requestForm.description.length }}/1000
          </span>
        </div>
      </div>

      <!-- Catégorie et Budget (côte à côte sur desktop) -->
      <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
        <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 p-5 transition-shadow hover:shadow-sm">
          <label for="category" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">
            Catégorie
          </label>
          <select 
            id="category"
            v-model="requestForm.category"
            class="w-full px-4 py-3 rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
            :class="{ 'border-red-500 dark:border-red-500': errors.category }"
            required
          >
            <option value="" disabled selected>Sélectionnez une catégorie</option>
            <option v-for="category in categories" :key="category.id" :value="category.name">
              {{ category.name }}
            </option>
          </select>
          <p v-if="errors.category" class="text-red-600 dark:text-red-400 text-sm mt-1">{{ errors.category }}</p>
        </div>

        <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 p-5 transition-shadow hover:shadow-sm">
          <label for="budget" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">
            Budget estimé (€)
          </label>
          <div class="relative">
            <input 
              id="budget"
              v-model="requestForm.budget"
              type="number"
              min="10"
              placeholder="Votre budget pour cette mission"
              class="w-full pl-4 pr-10 py-3 rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
              :class="{ 'border-red-500 dark:border-red-500': errors.budget }"
              required
            />
            <div class="absolute inset-y-0 right-0 flex items-center pr-3 pointer-events-none">
              <Euro class="h-5 w-5 text-gray-400" />
            </div>
          </div>
          <p v-if="errors.budget" class="text-red-600 dark:text-red-400 text-sm mt-1">{{ errors.budget }}</p>
        </div>
      </div>

      <!-- Localisation et Date -->
      <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
        <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 p-5 transition-shadow hover:shadow-sm">
          <label for="location" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">
            Localisation
          </label>
          <div class="flex items-center space-x-3 mb-3">
            <button 
              type="button"
              @click="requestForm.isRemote = true"
              class="flex-1 py-2.5 px-3 rounded-lg text-center text-sm font-medium transition-colors"
              :class="requestForm.isRemote ? 'bg-primary-100 text-primary-800 dark:bg-primary-900/30 dark:text-primary-400' : 'bg-gray-100 text-gray-700 dark:bg-gray-700 dark:text-gray-300'"
            >
              À distance
            </button>
            <button 
              type="button"
              @click="requestForm.isRemote = false"
              class="flex-1 py-2.5 px-3 rounded-lg text-center text-sm font-medium transition-colors"
              :class="!requestForm.isRemote ? 'bg-primary-100 text-primary-800 dark:bg-primary-900/30 dark:text-primary-400' : 'bg-gray-100 text-gray-700 dark:bg-gray-700 dark:text-gray-300'"
            >
              Sur place
            </button>
          </div>
          <input 
            v-if="!requestForm.isRemote"
            v-model="requestForm.location"
            type="text"
            placeholder="Ville ou code postal"
            class="w-full px-4 py-3 rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
            :class="{ 'border-red-500 dark:border-red-500': errors.location }"
          />
          <p v-if="errors.location" class="text-red-600 dark:text-red-400 text-sm mt-1">{{ errors.location }}</p>
        </div>

        <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 p-5 transition-shadow hover:shadow-sm">
          <label for="deadline" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">
            Date souhaitée
          </label>
          <input 
            id="deadline"
            v-model="requestForm.deadline"
            type="date"
            class="w-full px-4 py-3 rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
            :class="{ 'border-red-500 dark:border-red-500': errors.deadline }"
            :min="tomorrow"
            required
          />
          <p v-if="errors.deadline" class="text-red-600 dark:text-red-400 text-sm mt-1">{{ errors.deadline }}</p>
        </div>
      </div>

      <!-- Fichiers annexes -->
      <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 p-5 transition-shadow hover:shadow-sm">
        <div class="flex items-center justify-between mb-1.5">
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300">
            Fichiers annexes (facultatif)
          </label>
          <span class="text-xs text-gray-500 dark:text-gray-400">Max 3 fichiers</span>
        </div>
        
        <div class="border-2 border-dashed border-gray-300 dark:border-gray-600 rounded-lg p-6 text-center"
          :class="isDragging ? 'border-primary-500 bg-primary-50 dark:bg-primary-900/10' : ''"
          @dragenter.prevent="isDragging = true"
          @dragleave.prevent="isDragging = false"
          @dragover.prevent
          @drop.prevent="handleFileDrop"
        >
          <div class="flex flex-col items-center">
            <Upload class="h-8 w-8 text-gray-400 dark:text-gray-500 mb-2" />
            <p class="text-sm text-gray-600 dark:text-gray-400 mb-1">
              Glissez vos fichiers ici ou 
              <button 
                type="button"
                class="text-primary-600 dark:text-primary-400 font-medium"
                @click="$refs.fileInput.click()"
              >
                parcourez
              </button>
            </p>
            <p class="text-xs text-gray-500 dark:text-gray-500">
              PNG, JPG, PDF jusqu'à 5MB
            </p>
            <input 
              ref="fileInput"
              type="file"
              multiple
              class="hidden"
              accept="image/png,image/jpeg,application/pdf"
              @change="handleFileInput"
            />
          </div>
        </div>

        <!-- Aperçu des fichiers -->
        <div v-if="requestForm.files.length > 0" class="mt-3 space-y-2">
          <div v-for="(file, index) in requestForm.files" :key="index" 
            class="flex items-center justify-between bg-gray-50 dark:bg-gray-750 p-2 rounded-lg">
            <div class="flex items-center">
              <FileText class="h-5 w-5 text-gray-500 mr-2" />
              <span class="text-sm text-gray-700 dark:text-gray-300 truncate max-w-xs">{{ file.name }}</span>
            </div>
            <button type="button" @click="removeFile(index)" class="text-gray-500 hover:text-red-500">
              <X class="h-5 w-5" />
            </button>
          </div>
        </div>
      </div>

      <!-- Aperçu de la demande -->
      <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 overflow-hidden">
        <div class="bg-gray-50 dark:bg-gray-750 px-5 py-3 border-b border-gray-200 dark:border-gray-700">
          <h3 class="font-medium text-gray-900 dark:text-white">Aperçu de votre demande</h3>
        </div>
        <div class="p-5">
          <div class="flex items-start justify-between">
            <div>
              <h4 class="text-lg font-semibold text-gray-900 dark:text-white mb-1">
                {{ requestForm.title || 'Titre de votre demande' }}
              </h4>
              <div class="flex items-center gap-3 text-sm text-gray-600 dark:text-gray-400 mb-3">
                <span class="flex items-center">
                  <Calendar class="h-4 w-4 mr-1" />
                  {{ requestForm.deadline ? formatDate(requestForm.deadline) : 'Date à définir' }}
                </span>
                <span class="flex items-center">
                  <Tag class="h-4 w-4 mr-1" />
                  {{ requestForm.category || 'Catégorie' }}
                </span>
                <span class="flex items-center">
                  <MapPin class="h-4 w-4 mr-1" />
                  {{ requestForm.isRemote ? 'À distance' : (requestForm.location || 'Lieu à définir') }}
                </span>
              </div>
              <p class="text-gray-700 dark:text-gray-300 line-clamp-3">
                {{ requestForm.description || 'Votre description apparaîtra ici...' }}
              </p>
            </div>
            <div>
              <span class="px-3 py-1 rounded-full text-xs font-bold bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-400">
                {{ requestForm.budget ? `${requestForm.budget}€` : 'Budget' }}
              </span>
            </div>
          </div>
        </div>
      </div>

      <!-- Bouton de soumission -->
      <div class="mt-8">
        <button 
          type="submit"
          :disabled="isSubmitting"
          class="w-full bg-primary-600 hover:bg-primary-700 text-white font-bold py-3.5 px-6 rounded-xl shadow-sm hover:shadow-md transition-all flex items-center justify-center"
        >
          <span v-if="isSubmitting">
            <span class="h-5 w-5 border-2 border-white border-t-transparent rounded-full animate-spin mr-2"></span>
            Publication en cours...
          </span>
          <span v-else>
            Publier ma demande
          </span>
        </button>
      </div>
    </form>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useSupabaseClient, useSupabaseUser } from '#imports'
import {
  MessageSquarePlus,
  Calendar,
  Tag,
  MapPin,
  FileText,
  Upload,
  X,
  Euro
} from 'lucide-vue-next'

// Initialisation
const router = useRouter()
const user = useSupabaseUser()
const supabase = useSupabaseClient()

// État du formulaire
const requestForm = ref({
  title: '',
  description: '',
  category: '',
  budget: '',
  isRemote: true,
  location: '',
  deadline: '',
  files: []
})

// États UI
const errors = ref({})
const isSubmitting = ref(false)
const isDragging = ref(false)

// Données de référence
const categories = ref([
  { id: 1, name: 'Développement web' },
  { id: 2, name: 'Design graphique' },
  { id: 3, name: 'Marketing digital' },
  { id: 4, name: 'Rédaction de contenu' },
  { id: 5, name: 'Traduction' },
  { id: 6, name: 'Support administratif' },
  { id: 7, name: 'Coaching' },
  { id: 8, name: 'Photographie' },
  { id: 9, name: 'Montage vidéo' },
  { id: 10, name: 'Conseil juridique' },
  { id: 11, name: 'Conseil financier' },
  { id: 12, name: 'Assistance informatique' }
])

// Date de demain (pour la date minimale)
const tomorrow = computed(() => {
  const date = new Date()
  date.setDate(date.getDate() + 1)
  return date.toISOString().split('T')[0]
})

// Méthodes pour la gestion des fichiers
const handleFileInput = (event) => {
  const newFiles = Array.from(event.target.files)
  addFiles(newFiles)
  event.target.value = null // Réinitialise l'input
}

const handleFileDrop = (event) => {
  isDragging.value = false
  const newFiles = Array.from(event.dataTransfer.files)
  addFiles(newFiles)
}

const addFiles = (newFiles) => {
  // Filtrer les types de fichiers autorisés
  const validFiles = newFiles.filter(file => 
    ['image/jpeg', 'image/png', 'application/pdf'].includes(file.type) && file.size <= 5 * 1024 * 1024
  )
  
  // Limiter à 3 fichiers maximum
  const remainingSlots = 3 - requestForm.value.files.length
  const filesToAdd = validFiles.slice(0, remainingSlots)
  
  requestForm.value.files = [...requestForm.value.files, ...filesToAdd]
}

const removeFile = (index) => {
  requestForm.value.files.splice(index, 1)
}

// Validation du formulaire
const validateForm = () => {
  const newErrors = {}
  
  if (!requestForm.value.title.trim()) {
    newErrors.title = 'Veuillez saisir un titre'
  } else if (requestForm.value.title.length > 100) {
    newErrors.title = 'Le titre ne doit pas dépasser 100 caractères'
  }
  
  if (!requestForm.value.description.trim()) {
    newErrors.description = 'Veuillez détailler votre demande'
  } else if (requestForm.value.description.length < 50) {
    newErrors.description = 'La description doit contenir au moins 50 caractères'
  } else if (requestForm.value.description.length > 1000) {
    newErrors.description = 'La description ne doit pas dépasser 1000 caractères'
  }
  
  if (!requestForm.value.category) {
    newErrors.category = 'Veuillez sélectionner une catégorie'
  }
  
  if (!requestForm.value.budget) {
    newErrors.budget = 'Veuillez indiquer votre budget'
  } else if (requestForm.value.budget < 10) {
    newErrors.budget = 'Le budget minimum est de 10€'
  }
  
  if (!requestForm.value.isRemote && !requestForm.value.location.trim()) {
    newErrors.location = 'Veuillez indiquer votre localisation'
  }
  
  if (!requestForm.value.deadline) {
    newErrors.deadline = 'Veuillez indiquer une date souhaitée'
  }
  
  errors.value = newErrors
  return Object.keys(newErrors).length === 0
}

// Soumission du formulaire
const submitRequest = async () => {
  if (!validateForm()) {
    // Scroll to first error
    const firstError = document.querySelector('.border-red-500')
    if (firstError) {
      firstError.scrollIntoView({ behavior: 'smooth', block: 'center' })
    }
    return
  }
  
  isSubmitting.value = true
  
  try {
    // Envoi des données à la base de données
    const { data, error } = await supabase
      .from('requests')
      .insert({
        user_id: user.value.id,
        title: requestForm.value.title,
        description: requestForm.value.description,
        category: requestForm.value.category,
        budget: parseFloat(requestForm.value.budget),
        location: requestForm.value.isRemote ? 'À distance' : requestForm.value.location,
        deadline: requestForm.value.deadline,
        status: 'En attente',
        created_at: new Date().toISOString()
      })
      .select()
    
    if (error) throw error
    
    // Upload des fichiers si nécessaire
    if (requestForm.value.files.length > 0) {
      const requestId = data[0].id
      
      for (const file of requestForm.value.files) {
        const fileName = `${Date.now()}_${file.name}`
        const filePath = `requests/${requestId}/${fileName}`
        
        const { error: uploadError } = await supabase.storage
          .from('attachments')
          .upload(filePath, file)
        
        if (uploadError) throw uploadError
      }
    }
    
    // Redirection vers la page des demandes avec un message de succès
    router.push({ 
      path: '/account/requests',
      query: { success: 'created' }
    })
  } catch (error) {
    console.error('Erreur lors de la création de la demande:', error)
    alert('Une erreur est survenue lors de la création de votre demande. Veuillez réessayer.')
  } finally {
    isSubmitting.value = false
  }
}

// Format de date pour l'aperçu
const formatDate = (dateString) => {
  const date = new Date(dateString)
  return new Intl.DateTimeFormat('fr-FR', {
    day: 'numeric',
    month: 'long',
    year: 'numeric'
  }).format(date)
}

definePageMeta({
  layout: 'default'
})
</script>

<style scoped>
/* Animation des composants */
.rounded-xl {
  animation: fadeIn 0.4s ease;
  animation-fill-mode: both;
}

/* Animation séquentielle pour chaque section */
.space-y-6 > div:nth-child(1) { animation-delay: 0.05s; }
.space-y-6 > div:nth-child(2) { animation-delay: 0.1s; }
.space-y-6 > div:nth-child(3) { animation-delay: 0.15s; }
.space-y-6 > div:nth-child(4) { animation-delay: 0.2s; }
.space-y-6 > div:nth-child(5) { animation-delay: 0.25s; }
.space-y-6 > div:nth-child(6) { animation-delay: 0.3s; }

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(8px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
</style>