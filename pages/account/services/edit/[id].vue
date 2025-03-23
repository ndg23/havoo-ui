<template>
  <div class="min-h-screen bg-white dark:bg-gray-900">
    <!-- Main content -->
    <main class="max-w-2xl mx-auto px-4 py-6">
      <!-- Loading state -->
      <div v-if="isLoading" class="flex flex-col items-center justify-center py-12">
        <Loader2 class="animate-spin h-8 w-8 text-gray-400 mb-4" />
        <p class="text-gray-500">Chargement du service...</p>
      </div>

      <!-- Error state -->
      <div v-else-if="error" class="bg-red-50 dark:bg-red-900/10 p-4 rounded-lg text-red-700 dark:text-red-400 my-6">
        <div class="flex">
          <AlertCircle class="h-5 w-5 text-red-400 dark:text-red-500 mr-3" />
          <p>{{ error }}</p>
        </div>
        <button 
          @click="fetchService" 
          class="mt-3 text-sm font-medium text-red-600 dark:text-red-400 hover:text-red-500"
        >
          Réessayer
        </button>
      </div>

      <!-- Service form -->
      <div v-else class="space-y-6">
        <!-- Header -->
        <div class="flex items-center justify-between mb-6">
          <NuxtLink 
            to="/account/services" 
            class="inline-flex items-center text-sm font-medium text-gray-600 dark:text-gray-400 hover:text-gray-900 dark:hover:text-gray-200"
          >
            <ArrowLeft class="h-4 w-4 mr-1" />
            Retour aux services
          </NuxtLink>
          
          <h1 class="text-xl font-bold text-gray-900 dark:text-white">Modifier le service</h1>
        </div>
        
        <!-- Form card -->
        <div class="bg-white dark:bg-gray-800 shadow-sm rounded-xl border border-gray-200 dark:border-gray-700 overflow-hidden">
          <div class="p-6">
            <form @submit.prevent="updateService" class="space-y-6">
              <!-- Title -->
              <FloatInputLabel
                id="title"
                v-model="form.title"
                label="Titre"
                placeholder="Ex: Consultation juridique en droit des affaires"
                required
              />
              
              <!-- Description -->
              <FloatInputLabel
                id="description"
                v-model="form.description"
                label="Description"
                type="textarea"
                rows="4"
                placeholder="Décrivez votre service en détail..."
                required
              />
              
              <!-- Category -->
              <FloatInputLabel
                id="category"
                v-model="form.category_id"
                label="Catégorie"
                type="select"
                required
              >
                <option value="" disabled>Sélectionnez une catégorie</option>
                <option v-for="category in categories" :key="category.id" :value="category.id">
                  {{ category.name }}
                </option>
              </FloatInputLabel>
              
              <!-- Price -->
              <div class="grid grid-cols-2 gap-4">
                <FloatInputLabel
                  id="price"
                  v-model.number="form.price"
                  label="Prix"
                  type="number"
                  min="0"
                  placeholder="0"
                  required
                  suffix="XOF"
                />
                
                <FloatInputLabel
                  id="price_type"
                  v-model="form.price_type"
                  label="Type de prix"
                  type="select"
                >
                  <option value="fixed">Prix fixe</option>
                  <option value="hourly">Prix horaire</option>
                </FloatInputLabel>
              </div>
              
              <!-- Location -->
              <FloatInputLabel
                id="location"
                v-model="form.location"
                label="Lieu"
                placeholder="Ex: Dakar, Sénégal"
              />
              
              <!-- Delivery time -->
              <FloatInputLabel
                id="delivery_time"
                v-model.number="form.delivery_time"
                label="Délai de livraison (jours)"
                type="number"
                min="1"
                placeholder="Ex: 7"
              />
              
              <!-- Image upload -->
              <div>
                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                  Images
                </label>
                <div class="flex justify-center px-6 pt-5 pb-6 border-2 border-gray-300 dark:border-gray-700 border-dashed rounded-lg">
                  <div class="space-y-2 text-center">
                    <div class="mx-auto h-12 w-12 text-gray-400">
                      <ImagePlus class="h-12 w-12" />
                    </div>
                    <div class="flex text-sm text-gray-600 dark:text-gray-400">
                      <label for="file-upload" class="relative cursor-pointer bg-white dark:bg-gray-800 rounded-md font-medium text-primary-600 dark:text-primary-400 hover:text-primary-500 focus-within:outline-none">
                        <span>Télécharger une image</span>
                        <input id="file-upload" name="file-upload" type="file" class="sr-only" accept="image/*" @change="handleFileUpload">
                      </label>
                      <p class="pl-1">ou glisser-déposer</p>
                    </div>
                    <p class="text-xs text-gray-500 dark:text-gray-400">
                      PNG, JPG, GIF jusqu'à 10MB
                    </p>
                  </div>
                </div>
                
                <!-- Image preview -->
                <div v-if="form.image_urls && form.image_urls.length > 0" class="mt-4 grid grid-cols-3 gap-4">
                  <div v-for="(image, index) in form.image_urls" :key="index" class="relative rounded-lg overflow-hidden h-24 group">
                    <img :src="image" alt="Preview" class="w-full h-full object-cover" />
                    <div class="absolute inset-0 bg-black bg-opacity-40 opacity-0 group-hover:opacity-100 transition-opacity flex items-center justify-center">
                      <button 
                        type="button"
                        @click="removeImage(index)"
                        class="p-1.5 bg-red-500 text-white rounded-full hover:bg-red-600 focus:outline-none"
                      >
                        <Trash2 class="h-4 w-4" />
                      </button>
                    </div>
                  </div>
                </div>
              </div>
              
              <!-- Active status -->
              <div class="flex items-center space-x-3 pt-2">
                <div class="flex items-center h-5">
                  <input 
                    id="is_active" 
                    v-model="form.is_active" 
                    type="checkbox"
                    class="h-4 w-4 text-primary-600 focus:ring-primary-500 border-gray-300 dark:border-gray-700 rounded"
                  />
                </div>
                <div class="ml-3 text-sm">
                  <label for="is_active" class="font-medium text-gray-700 dark:text-gray-300">
                    Publier ce service
                  </label>
                  <p class="text-gray-500 dark:text-gray-400">
                    Rendre ce service visible pour les clients
                  </p>
                </div>
              </div>
              
              <!-- Form actions -->
              <div class="flex justify-end space-x-3 pt-6 border-t border-gray-200 dark:border-gray-700 mt-6">
                <NuxtLink 
                  :to="`/account/services/${serviceId}`" 
                  class="inline-flex justify-center py-2.5 px-4 border border-gray-300 dark:border-gray-700 shadow-sm text-sm font-medium rounded-lg text-gray-700 dark:text-gray-300 bg-white dark:bg-gray-800 hover:bg-gray-50 dark:hover:bg-gray-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500"
                >
                  Annuler
                </NuxtLink>
                <button 
                  type="submit" 
                  class="inline-flex justify-center py-2.5 px-4 border border-transparent shadow-sm text-sm font-medium rounded-lg text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500"
                  :disabled="isSubmitting"
                >
                  <Loader2 v-if="isSubmitting" class="animate-spin h-4 w-4 mr-2" />
                  <span v-else>Enregistrer les modifications</span>
                </button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </main>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter, useSupabaseClient } from '#imports'
import { 
  ArrowLeft, 
  X, 
  Loader2, 
  AlertCircle,
  ImagePlus,
  Trash2
} from 'lucide-vue-next'
import FloatInputLabel from '~/components/ui/FloatingLabelInput.vue'

const route = useRoute()
const router = useRouter()
const supabase = useSupabaseClient()

const serviceId = route.params.id
const isLoading = ref(true)
const isSubmitting = ref(false)
const error = ref(null)
const categories = ref([])

const form = ref({
  title: '',
  description: '',
  category_id: '',
  price: 0,
  price_type: 'fixed',
  location: '',
  delivery_time: null,
  image_urls: [],
  is_active: false
})

// Récupérer le service
const fetchService = async () => {
  isLoading.value = true
  error.value = null
  
  try {
    // Récupérer les données du service
    const { data, error: fetchError } = await supabase
      .from('services')
      .select('*')
      .eq('id', serviceId)
      .single()
    
    if (fetchError) throw fetchError
    
    // Remplir le formulaire avec les données du service
    form.value = {
      title: data.title || '',
      description: data.description || '',
      category_id: data.category_id || '',
      price: data.price || 0,
      price_type: data.price_type || 'fixed',
      location: data.location || '',
      delivery_time: data.delivery_time || null,
      image_urls: data.image_urls || [],
      is_active: data.is_active || false
    }
    
    // Récupérer les catégories
    await fetchCategories()
  } catch (err) {
    console.error('Error fetching service:', err)
    error.value = "Impossible de charger le service. Veuillez réessayer."
  } finally {
    isLoading.value = false
  }
}

// Récupérer les catégories
const fetchCategories = async () => {
  try {
    const { data, error: categoriesError } = await supabase
      .from('categories')
      .select('id, name')
      .order('name')
    
    if (categoriesError) throw categoriesError
    
    categories.value = data || []
  } catch (err) {
    console.error('Error fetching categories:', err)
  }
}

// Gérer l'upload de fichier
const handleFileUpload = async (event) => {
  const file = event.target.files[0]
  if (!file) return
  
  // Vérifier le type et la taille du fichier
  if (!file.type.match('image.*')) {
    alert('Veuillez sélectionner une image')
    return
  }
  
  if (file.size > 10 * 1024 * 1024) { // 10MB
    alert('La taille de l\'image ne doit pas dépasser 10MB')
    return
  }
  
  try {
    // Générer un nom de fichier unique
    const fileExt = file.name.split('.').pop()
    const fileName = `${Math.random().toString(36).substring(2, 15)}.${fileExt}`
    const filePath = `services/${serviceId}/${fileName}`
    
    // Uploader le fichier
    const { data, error: uploadError } = await supabase.storage
      .from('images')
      .upload(filePath, file)
    
    if (uploadError) throw uploadError
    
    // Obtenir l'URL publique
    const { data: { publicUrl } } = supabase.storage
      .from('images')
      .getPublicUrl(filePath)
    
    // Ajouter l'URL à la liste
    form.value.image_urls = [...(form.value.image_urls || []), publicUrl]
  } catch (err) {
    console.error('Error uploading file:', err)
    alert('Erreur lors du téléchargement de l\'image')
  }
  
  // Réinitialiser l'input file
  event.target.value = null
}

// Supprimer une image
const removeImage = (index) => {
  form.value.image_urls = form.value.image_urls.filter((_, i) => i !== index)
}

// Mettre à jour le service
const updateService = async () => {
  isSubmitting.value = true
  
  try {
    const { error: updateError } = await supabase
      .from('services')
      .update({
        title: form.value.title,
        description: form.value.description,
        category_id: form.value.category_id,
        price: form.value.price,
        price_type: form.value.price_type,
        location: form.value.location,
        delivery_time: form.value.delivery_time,
        image_urls: form.value.image_urls,
        is_active: form.value.is_active,
        updated_at: new Date().toISOString()
      })
      .eq('id', serviceId)
    
    if (updateError) throw updateError
    
    // Rediriger vers la page de détail
    router.push(`/account/services/${serviceId}`)
  } catch (err) {
    console.error('Error updating service:', err)
    error.value = "Une erreur est survenue lors de la mise à jour du service"
  } finally {
    isSubmitting.value = false
  }
}

// Initialisation
onMounted(() => {
  fetchService()
})

definePageMeta({
  middleware: ['auth'],
  layout: 'account'
})
</script>

<style scoped>
/* Styles pour les inputs */
input[type="text"],
input[type="number"],
textarea,
select {
  @apply border-gray-300 dark:border-gray-700 dark:bg-gray-800 dark:text-white;
}

/* Animation pour le hover des images */
.group {
  @apply transition-all duration-200;
}

.group-hover\:opacity-100 {
  @apply transition-opacity duration-200;
}
</style> 