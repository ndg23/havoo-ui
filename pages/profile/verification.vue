<template>
  <div>
    <div class="max-w-3xl mx-auto">
      <h1 class="text-2xl font-bold mb-4">Vérification d'identité</h1>
      <p class="text-gray-600 dark:text-gray-400 mb-8">
        Pour vérifier votre identité, nous avons besoin d'une copie de votre Carte Nationale d'Identité (CNI).
      </p>
      
      <!-- Processus de vérification -->
      <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm border border-gray-200 dark:border-gray-700 p-6">
        <h2 class="text-lg font-medium mb-4">Télécharger votre CNI</h2>
        
        <!-- État d'upload -->
        <div class="mb-6">
          <div v-if="isUploading" class="text-gray-500 dark:text-gray-400 flex items-center">
            <Loader class="animate-spin mr-2 h-5 w-5" />
            Téléchargement en cours...
          </div>
          
          <div v-else-if="uploadComplete" class="text-green-600 dark:text-green-400 flex items-center">
            <CheckCircle class="mr-2 h-5 w-5" />
            Document téléchargé avec succès
          </div>
          
          <div v-else-if="uploadError" class="text-red-600 dark:text-red-400 flex items-center">
            <AlertCircle class="mr-2 h-5 w-5" />
            Erreur: {{ uploadError }}
          </div>
        </div>
        
        <!-- Zone de dépôt de fichier -->
        <div 
          v-if="!uploadComplete"
          @dragover.prevent
          @drop.prevent="onFileDrop"
          class="border-2 border-dashed border-gray-300 dark:border-gray-600 rounded-lg p-8 text-center hover:border-gray-400 dark:hover:border-gray-500 transition-colors cursor-pointer"
          :class="{ 'border-primary-500 dark:border-primary-400': isDragging }"
          @dragenter.prevent="isDragging = true"
          @dragleave.prevent="isDragging = false"
          @click="$refs.fileInput.click()"
        >
          <Upload class="mx-auto h-12 w-12 text-gray-400 dark:text-gray-500 mb-3" />
          <p class="text-sm text-gray-600 dark:text-gray-400 mb-2">
            Glissez-déposez votre document ici ou
            <span class="text-primary-600 dark:text-primary-400 font-medium">cliquez pour parcourir</span>
          </p>
          <p class="text-xs text-gray-500 dark:text-gray-500">
            Formats acceptés: JPG, PNG ou PDF - Max 5MB
          </p>
          <input 
            ref="fileInput" 
            type="file" 
            class="hidden" 
            accept="image/jpeg,image/png,application/pdf"
            @change="onFileSelected"
          />
        </div>
        
        <!-- Actions -->
        <div class="mt-6 flex justify-end">
          <button 
            @click="submitVerification" 
            class="px-4 py-2 bg-primary-600 hover:bg-primary-700 text-white rounded-lg disabled:opacity-50 disabled:cursor-not-allowed"
            :disabled="!uploadComplete || isSubmitting"
          >
            <Loader v-if="isSubmitting" class="animate-spin inline-block mr-2 h-4 w-4" />
            Soumettre pour vérification
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { CheckCircle, Upload, AlertCircle, Loader } from 'lucide-vue-next'
import { useRouter } from 'vue-router'

const router = useRouter()

const isDragging = ref(false)
const isUploading = ref(false)
const uploadComplete = ref(false)
const uploadError = ref(null)
const isSubmitting = ref(false)
const fileInput = ref(null)

const onFileDrop = (event) => {
  isDragging.value = false
  const files = event.dataTransfer.files
  if (files.length > 0) {
    handleFile(files[0])
  }
}

const onFileSelected = (event) => {
  const files = event.target.files
  if (files.length > 0) {
    handleFile(files[0])
  }
}

const handleFile = async (file) => {
  // Vérification de la taille et du type
  if (file.size > 5 * 1024 * 1024) { // 5MB
    uploadError.value = 'Le fichier est trop volumineux. Maximum 5MB.'
    return
  }
  
  const validTypes = ['image/jpeg', 'image/png', 'application/pdf']
  if (!validTypes.includes(file.type)) {
    uploadError.value = 'Format de fichier non accepté. Utilisez JPG, PNG ou PDF.'
    return
  }
  
  uploadError.value = null
  isUploading.value = true
  
  try {
    // Simuler un téléchargement
    await new Promise(resolve => setTimeout(resolve, 2000))
    
    // Ici, vous implémenteriez le téléchargement réel vers votre serveur
    // const formData = new FormData()
    // formData.append('document', file)
    // const response = await fetch('/api/verification/upload', {
    //   method: 'POST',
    //   body: formData
    // })
    
    // if (!response.ok) throw new Error('Erreur lors du téléchargement')
    
    uploadComplete.value = true
  } catch (error) {
    console.error('Erreur d\'upload:', error)
    uploadError.value = 'Une erreur est survenue pendant le téléchargement. Veuillez réessayer.'
  } finally {
    isUploading.value = false
  }
}

const submitVerification = async () => {
  if (!uploadComplete.value) return
  
  isSubmitting.value = true
  
  try {
    // Simuler une soumission
    await new Promise(resolve => setTimeout(resolve, 1500))
    
    // Ici, vous implémenteriez l'appel API pour soumettre la demande de vérification
    // const { data, error } = await supabase
    //   .from('verification_requests')
    //   .insert({ user_id: auth.user.id, status: 'pending' })
    
    // if (error) throw error
    
    // Redirection avec message de succès
    router.push({
      path: '/profile',
      query: { verification_submitted: 'true' }
    })
  } catch (error) {
    console.error('Erreur de soumission:', error)
    alert('Une erreur est survenue lors de la soumission. Veuillez réessayer.')
  } finally {
    isSubmitting.value = false
  }
}
</script> 