<template>
  <div class="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
    <div class="mb-6 flex items-center justify-between">
      <h1 class="text-xl font-semibold text-gray-900 dark:text-white">Créer un nouveau service</h1>
      <NuxtLink 
        to="/account/services" 
        class="inline-flex items-center px-3 py-1.5 text-sm rounded-full text-gray-700 dark:text-gray-300 bg-gray-100 hover:bg-gray-200 dark:bg-gray-700 dark:hover:bg-gray-600 transition-colors"
      >
        <ArrowLeft class="h-3.5 w-3.5 mr-1" />
        Retour
      </NuxtLink>
    </div>

    <form @submit.prevent="saveService" class="space-y-5">
      <!-- Basic Information -->
      <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-100 dark:border-gray-700 overflow-hidden">
        <div class="border-b border-gray-100 dark:border-gray-700 px-5 py-4">
          <h2 class="text-lg font-semibold text-gray-900 dark:text-white">Informations générales</h2>
        </div>
        <div class="p-5 space-y-4">
          <!-- Service Title -->
          <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
              Titre du service <span class="text-red-500">*</span>
            </label>
            <input 
              v-model="form.title" 
              type="text" 
              class="w-full px-4 py-2.5 rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
              placeholder="Ex: Création de site web professionnel"
              required
            />
            <p class="mt-1 text-xs text-gray-500 dark:text-gray-400">
              Choisissez un titre clair et précis qui décrit votre service (max 80 caractères)
            </p>
          </div>

          <!-- Service Category -->
          <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
              Catégorie <span class="text-red-500">*</span>
            </label>
            <select 
              v-model="form.category_id" 
              class="w-full px-4 py-2.5 rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
              required
            >
              <option value="" disabled selected>Sélectionnez une catégorie</option>
              <option v-for="category in categories" :key="category.id" :value="category.id">
                {{ category.name }}
              </option>
            </select>
          </div>

          <!-- Service Description -->
          <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
              Description détaillée <span class="text-red-500">*</span>
            </label>
            <textarea 
              v-model="form.description" 
              rows="5" 
              class="w-full px-4 py-2.5 rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
              placeholder="Décrivez en détail ce que vous proposez, votre méthodologie et ce qui est inclus dans le service..."
              required
            ></textarea>
            <p class="mt-1 flex justify-between text-xs">
              <span class="text-gray-500 dark:text-gray-400">
                Soyez précis et détaillé pour attirer les bons clients
              </span>
              <span 
                :class="[form.description.length > 800 ? 'text-red-500' : 'text-gray-500 dark:text-gray-400']"
              >
                {{ form.description.length }}/1000
              </span>
            </p>
          </div>
        </div>
      </div>

      <!-- Pricing Section -->
      <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-100 dark:border-gray-700 overflow-hidden">
        <div class="border-b border-gray-100 dark:border-gray-700 px-5 py-4">
          <h2 class="text-lg font-semibold text-gray-900 dark:text-white">Tarification</h2>
        </div>
        <div class="p-5 space-y-4">
          <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
            <!-- Price Amount -->
            <div>
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                Prix <span class="text-red-500">*</span>
              </label>
              <div class="relative">
                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                  <span class="text-gray-500 dark:text-gray-400">€</span>
                </div>
                <input 
                  v-model.number="form.price" 
                  type="number" 
                  min="0" 
                  step="0.01" 
                  class="w-full pl-8 px-4 py-2.5 rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
                  placeholder="0.00"
                  required
                />
              </div>
            </div>

            <!-- Price Type -->
            <div>
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                Type de tarification <span class="text-red-500">*</span>
              </label>
              <select 
                v-model="form.price_type" 
                class="w-full px-4 py-2.5 rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
                required
              >
                <option value="fixed">Forfait</option>
                <option value="hourly">Tarif horaire</option>
                <option value="daily">Tarif journalier</option>
              </select>
            </div>
          </div>

          <!-- Delivery Time -->
          <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
              Délai de livraison estimé <span class="text-red-500">*</span>
            </label>
            <input 
              v-model="form.estimated_delivery" 
              type="text" 
              class="w-full px-4 py-2.5 rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
              placeholder="Ex: 7 jours ouvrés"
              required
            />
            <p class="mt-1 text-xs text-gray-500 dark:text-gray-400">
              Indiquez un délai réaliste qui tient compte du temps nécessaire pour fournir un travail de qualité
            </p>
          </div>
        </div>
      </div>

      <!-- Skills Section -->
      <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-100 dark:border-gray-700 overflow-hidden">
        <div class="border-b border-gray-100 dark:border-gray-700 px-5 py-4 flex justify-between items-center">
          <h2 class="text-lg font-semibold text-gray-900 dark:text-white">Compétences associées</h2>
          <span class="text-xs text-gray-500 dark:text-gray-400">
            {{ selectedSkills.length }}/10 max
          </span>
        </div>
        <div class="p-5 space-y-4">
          <!-- Selected Skills -->
          <div class="flex flex-wrap gap-2 mb-3">
            <div 
              v-for="skill in selectedSkills" 
              :key="skill.id"
              class="inline-flex items-center px-3 py-1 rounded-full text-sm bg-primary-50 text-primary-700 dark:bg-primary-900/30 dark:text-primary-400"
            >
              {{ skill.name }}
              <button 
                @click="removeSkill(skill)"
                type="button"
                class="ml-1.5 text-primary-500 hover:text-primary-700 dark:text-primary-400 dark:hover:text-primary-300"
              >
                <X class="h-3.5 w-3.5" />
              </button>
            </div>
            <div v-if="selectedSkills.length === 0" class="text-sm text-gray-500 dark:text-gray-400 italic">
              Aucune compétence sélectionnée
            </div>
          </div>

          <!-- Add Skills -->
          <div class="flex gap-2">
            <select 
              v-model="selectedSkill" 
              class="flex-1 px-4 py-2.5 rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
              :disabled="selectedSkills.length >= 10"
            >
              <option value="" disabled selected>Choisir une compétence</option>
              <option 
                v-for="skill in availableSkills" 
                :key="skill.id" 
                :value="skill"
                :disabled="isSkillSelected(skill)"
              >
                {{ skill.name }}
              </option>
            </select>
            <button 
              @click="addSkill"
              type="button"
              class="px-4 py-2 bg-primary-500 hover:bg-primary-600 text-white rounded-lg disabled:opacity-50 disabled:cursor-not-allowed"
              :disabled="!selectedSkill || selectedSkills.length >= 10"
            >
              Ajouter
            </button>
          </div>
          <p class="text-xs text-gray-500 dark:text-gray-400">
            Les compétences permettent aux clients de trouver plus facilement votre service lors des recherches
          </p>
        </div>
      </div>

      <!-- Image Upload Section -->
      <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-100 dark:border-gray-700 overflow-hidden">
        <div class="border-b border-gray-100 dark:border-gray-700 px-5 py-4">
          <h2 class="text-lg font-semibold text-gray-900 dark:text-white">Images</h2>
        </div>
        <div class="p-5">
          <div 
            class="border-2 border-dashed border-gray-300 dark:border-gray-600 rounded-lg p-6 text-center"
            :class="{ 'border-primary-300 dark:border-primary-700 bg-primary-50/20 dark:bg-primary-900/10': isDragging }"
            @dragover.prevent="isDragging = true"
            @dragleave.prevent="isDragging = false"
            @drop.prevent="onDrop"
          >
            <div v-if="serviceImages.length > 0" class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 gap-4 mb-4">
              <div 
                v-for="(image, index) in serviceImages" 
                :key="index"
                class="relative h-24 rounded-lg overflow-hidden bg-gray-200 dark:bg-gray-700"
              >
                <img 
                  :src="image.preview" 
                  class="h-full w-full object-cover" 
                />
                <button 
                  @click="removeImage(index)"
                  type="button"
                  class="absolute top-1 right-1 p-1 bg-white dark:bg-gray-800 rounded-full text-red-500 hover:text-red-700 shadow-sm"
                >
                  <X class="h-3.5 w-3.5" />
                </button>
              </div>
            </div>
            
            <div class="flex flex-col items-center justify-center">
              <Image class="h-12 w-12 text-gray-400 mb-2" />
              <p class="text-sm text-gray-500 dark:text-gray-400 mb-2">
                Glissez-déposez vos images ici ou
              </p>
              <label class="cursor-pointer px-4 py-2 bg-primary-500 hover:bg-primary-600 text-white rounded-lg transition-colors">
                <input 
                  type="file" 
                  @change="onFileSelected" 
                  multiple 
                  accept="image/*" 
                  class="hidden" 
                />
                Parcourir
              </label>
              <p class="mt-2 text-xs text-gray-500 dark:text-gray-400">
                Maximum 5 images. Format JPG ou PNG. Taille max: 5MB par image
              </p>
            </div>
          </div>
        </div>
      </div>

      <!-- Terms and Submission -->
      <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-100 dark:border-gray-700 overflow-hidden">
        <div class="p-5">
          <div class="flex items-start mb-4">
            <div class="flex items-center h-5">
              <input 
                id="terms" 
                v-model="termsAccepted" 
                type="checkbox" 
                class="w-4 h-4 rounded border-gray-300 text-primary-600 focus:ring-primary-500"
                required
              />
            </div>
            <label for="terms" class="ml-2 text-sm text-gray-600 dark:text-gray-400">
              J'accepte les <NuxtLink to="/terms" target="_blank" class="text-primary-600 dark:text-primary-400 hover:underline">conditions d'utilisation</NuxtLink> et je confirme que mon service respecte les règles de la plateforme.
            </label>
          </div>
          
          <div class="flex justify-end">
            <button 
              type="submit"
              class="px-6 py-2.5 bg-primary-500 hover:bg-primary-600 text-white rounded-lg disabled:opacity-50 disabled:cursor-not-allowed flex items-center"
              :disabled="!isFormValid || isSubmitting"
            >
              <Loader2 v-if="isSubmitting" class="h-4 w-4 mr-2 animate-spin" />
              <span>{{ isSubmitting ? 'Publication en cours...' : 'Publier le service' }}</span>
            </button>
          </div>
        </div>
      </div>
    </form>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useSupabaseClient, useSupabaseUser } from '#imports'
import { 
  ArrowLeft, 
  X, 
  Image, 
  Loader2
} from 'lucide-vue-next'

const router = useRouter()
const supabase = useSupabaseClient()
const user = useSupabaseUser()

// Form data
const form = ref({
  title: '',
  description: '',
  category_id: '',
  price: null,
  price_type: 'fixed',
  estimated_delivery: '',
})

// UI state
const isSubmitting = ref(false)
const isDragging = ref(false)
const termsAccepted = ref(false)

// Data from Supabase
const categories = ref([])
const allSkills = ref([])
const selectedSkills = ref([])
const selectedSkill = ref(null)
const serviceImages = ref([])

// Computed
const availableSkills = computed(() => {
  return allSkills.value.filter(skill => 
    !selectedSkills.value.some(selected => selected.id === skill.id)
  )
})

const isFormValid = computed(() => {
  return form.value.title.trim() !== '' && 
         form.value.description.trim() !== '' && 
         form.value.category_id && 
         form.value.price !== null && 
         form.value.price > 0 &&
         form.value.estimated_delivery.trim() !== '' &&
         termsAccepted.value
})

// Methods
const fetchCategories = async () => {
  try {
    const { data, error } = await supabase
      .from('categories')
      .select('*')
      .order('name')
    
    if (error) throw error
    categories.value = data
  } catch (error) {
    console.error('Error fetching categories:', error)
  }
}

const fetchSkills = async () => {
  try {
    const { data, error } = await supabase
      .from('skills')
      .select('*')
      .order('name')
    
    if (error) throw error
    allSkills.value = data
  } catch (error) {
    console.error('Error fetching skills:', error)
  }
}

const addSkill = () => {
  if (!selectedSkill.value || selectedSkills.value.length >= 10) return
  
  // Check if skill is already selected
  if (!isSkillSelected(selectedSkill.value)) {
    selectedSkills.value.push(selectedSkill.value)
  }
  
  // Reset selection
  selectedSkill.value = null
}

const removeSkill = (skillToRemove) => {
  selectedSkills.value = selectedSkills.value.filter(skill => skill.id !== skillToRemove.id)
}

const isSkillSelected = (skill) => {
  return selectedSkills.value.some(s => s.id === skill.id)
}

const onFileSelected = (event) => {
  const files = event.target.files
  handleFiles(files)
}

const onDrop = (event) => {
  isDragging.value = false
  const files = event.dataTransfer.files
  handleFiles(files)
}

const handleFiles = (files) => {
  if (!files || !files.length) return
  
  // Check if adding new files would exceed limit
  if (serviceImages.value.length + files.length > 5) {
    alert('Vous ne pouvez pas ajouter plus de 5 images.')
    return
  }
  
  for (let i = 0; i < files.length; i++) {
    const file = files[i]
    
    // Validate file type
    if (!file.type.match('image.*')) {
      alert('Veuillez sélectionner uniquement des images.')
      continue
    }
    
    // Validate file size (5MB)
    if (file.size > 5 * 1024 * 1024) {
      alert(`L'image ${file.name} dépasse la taille maximale de 5MB.`)
      continue
    }
    
    // Create preview
    const reader = new FileReader()
    reader.onload = (e) => {
      serviceImages.value.push({
        file: file,
        preview: e.target.result
      })
    }
    reader.readAsDataURL(file)
  }
}

const removeImage = (index) => {
  serviceImages.value.splice(index, 1)
}

const uploadImages = async (serviceId) => {
  const uploadedImages = []
  
  for (let i = 0; i < serviceImages.value.length; i++) {
    const file = serviceImages.value[i].file
    const fileExt = file.name.split('.').pop()
    const fileName = `${serviceId}_${i}_${Date.now()}.${fileExt}`
    const filePath = `service_images/${fileName}`
    
    const { data, error } = await supabase.storage
      .from('services')
      .upload(filePath, file)
    
    if (error) throw error
    
    // Get public URL
    const { data: publicURL } = supabase.storage
      .from('services')
      .getPublicUrl(filePath)
    
    uploadedImages.push({
      service_id: serviceId,
      image_url: publicURL.publicUrl,
      order_index: i
    })
  }
  
  return uploadedImages
}

const saveService = async () => {
  if (!isFormValid.value) return
  
  isSubmitting.value = true
  
  try {
    // 1. Insert the service
    const { data: service, error: serviceError } = await supabase
      .from('services')
      .insert({
        expert_id: user.value.id,
        title: form.value.title,
        description: form.value.description,
        category_id: form.value.category_id,
        price: form.value.price,
        price_type: form.value.price_type,
        estimated_delivery: form.value.estimated_delivery,
        is_active: true
      })
      .select()
      .single()
    
    if (serviceError) throw serviceError
    
    // 2. Link skills to the service
    if (selectedSkills.value.length > 0) {
      const serviceSkills = selectedSkills.value.map(skill => ({
        service_id: service.id,
        skill_id: skill.id
      }))
      
      const { error: skillsError } = await supabase
        .from('service_skills')
        .insert(serviceSkills)
      
      if (skillsError) throw skillsError
    }
    
    // 3. Upload images and link them to the service
    if (serviceImages.value.length > 0) {
      const imageRecords = await uploadImages(service.id)
      
      // 3.1. Add images to database
      if (imageRecords.length > 0) {
        const { error: imagesError } = await supabase
          .from('service_images')
          .insert(imageRecords)
        
        if (imagesError) throw imagesError
        
        // 3.2. Set first image as thumbnail
        const { error: thumbnailError } = await supabase
          .from('services')
          .update({ thumbnail_url: imageRecords[0].image_url })
          .eq('id', service.id)
        
        if (thumbnailError) throw thumbnailError
      }
    }
    
    // 4. Redirect to the service details page
    router.push(`/account/services/${service.id}`)
  } catch (error) {
    console.error('Error saving service:', error)
    alert('Une erreur est survenue lors de la création du service.')
  } finally {
    isSubmitting.value = false
  }
}

// Initialize
onMounted(() => {
  fetchCategories()
  fetchSkills()
})
</script>

<style scoped>
/* Animations */
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

form > div {
  animation: fadeIn 0.4s ease-out forwards;
  animation-fill-mode: both;
}

form > div:nth-child(1) { animation-delay: 0.05s; }
form > div:nth-child(2) { animation-delay: 0.1s; }
form > div:nth-child(3) { animation-delay: 0.15s; }
form > div:nth-child(4) { animation-delay: 0.2s; }
form > div:nth-child(5) { animation-delay: 0.25s; }

/* Focus styles */
input:focus, textarea:focus, select:focus {
  outline: none;
}

/* Smooth transitions */
.transition-colors {
  transition-property: background-color, border-color, color, fill, stroke;
  transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
  transition-duration: 150ms;
}
</style>