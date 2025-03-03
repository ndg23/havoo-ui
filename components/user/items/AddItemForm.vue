<template>
  <div class="max-w-4xl mx-auto">
    <form @submit.prevent="handleSubmit" class="space-y-10">
      <!-- Images Upload Section -->
      <div class="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden">
        <div class="p-8 pb-0">
          <h2 class="text-xl font-semibold text-gray-900">Photos de l'objet</h2>
          <p class="text-gray-500 mt-1">Ajoutez jusqu'à 8 photos de haute qualité</p>
        </div>
        
        <div class="p-8">
          <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
            <div v-for="(preview, index) in imagePreview" :key="index" 
                 class="relative aspect-square rounded-2xl border border-gray-200 overflow-hidden
                        group hover:border-blue-500/50 transition-all duration-300">
              <img :src="preview" class="w-full h-full object-cover" />
              <div class="absolute inset-0 bg-black/40 opacity-0 group-hover:opacity-100 
                          transition-opacity duration-300">
                <button @click="removeImage(index)" 
                        class="absolute top-2 right-2 p-2.5 bg-white/90 backdrop-blur-sm rounded-xl
                               shadow-lg hover:bg-white transition-all duration-200">
                  <XMarkIcon class="w-4 h-4 text-gray-700" />
                </button>
              </div>
            </div>
            
            <label v-if="imagePreview.length < 8" 
                   class="aspect-square rounded-2xl border-2 border-dashed border-gray-200 
                          hover:border-blue-500/50 hover:bg-blue-50/30 transition-all duration-300
                          cursor-pointer flex flex-col items-center justify-center gap-3
                          group">
              <input type="file" class="hidden" @change="handleImageUpload" accept="image/*" multiple />
              <div class="p-4 rounded-xl bg-blue-50 text-blue-500 
                          group-hover:bg-blue-100 transition-colors duration-300">
                <PhotoIcon class="w-8 h-8" />
              </div>
              <div class="text-center">
                <p class="font-medium text-gray-700">Ajouter des photos</p>
                <p class="text-sm text-gray-500">ou glisser-déposer</p>
              </div>
            </label>
          </div>
        </div>
      </div>

      <!-- Basic Information -->
      <div class="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden">
        <div class="p-8 pb-0">
          <h2 class="text-xl font-semibold text-gray-900">Informations de l'objet</h2>
          <p class="text-gray-500 mt-1">Décrivez votre objet avec précision</p>
        </div>
        
        <div class="p-8 space-y-6">
          <div class="relative">
            <input
              v-model="form.title"
              type="text"
              required
              class="peer w-full px-6 py-4 rounded-xl bg-gray-50 border border-gray-200
                     focus:bg-white focus:border-blue-500 focus:ring-4 focus:ring-blue-50
                     placeholder-transparent transition-all duration-300 text-base"
              placeholder="Titre"
              id="title"
            />
            <label 
              for="title"
              class="absolute left-6 top-4 text-gray-500 pointer-events-none
                     transition-all duration-200 transform origin-left"
            >
              Titre de l'annonce
            </label>
          </div>

          <div class="grid grid-cols-2 gap-4">
            <div class="relative">
              <select
                v-model="form.category"
                required
                class="w-full px-6 py-4 rounded-xl bg-gray-50 border border-gray-200
                       focus:bg-white focus:border-blue-500 focus:ring-4 focus:ring-blue-50
                       transition-all duration-300 text-base appearance-none"
              >
                <option value="">Sélectionner une catégorie</option>
                <option v-for="cat in categories" :key="cat.id" :value="cat.id">
                  {{ cat.name }}
                </option>
              </select>
              <ChevronDownIcon class="w-5 h-5 text-gray-400 absolute right-6 top-1/2 -translate-y-1/2 pointer-events-none" />
            </div>

            <div class="relative">
              <div class="flex items-center">
                <span class="absolute left-6 text-gray-500">€</span>
                <input
                  v-model="form.price"
                  type="number"
                  min="0"
                  step="0.01"
                  required
                  class="peer w-full pl-10 pr-6 py-4 rounded-xl bg-gray-50 border border-gray-200
                         focus:bg-white focus:border-blue-500 focus:ring-4 focus:ring-blue-50
                         placeholder-transparent transition-all duration-300 text-base"
                  placeholder="Prix par jour"
                />
              </div>
            </div>
          </div>

          <div class="relative">
            <textarea
              v-model="form.description"
              rows="4"
              required
              class="peer w-full px-6 py-4 rounded-xl bg-gray-50 border border-gray-200
                     focus:bg-white focus:border-blue-500 focus:ring-4 focus:ring-blue-50
                     placeholder-transparent transition-all duration-300 text-base resize-none"
              placeholder="Description"
            ></textarea>
          </div>
        </div>
      </div>

      <!-- Availability Section -->
      <div class="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden">
        <div class="p-8 pb-0">
          <h2 class="text-xl font-semibold text-gray-900">Disponibilité</h2>
          <p class="text-gray-500 mt-1">Définissez quand votre objet est disponible</p>
        </div>
        
        <div class="p-8 space-y-6">
          <div class="grid grid-cols-2 gap-4">
            <div class="relative">
              <input
                v-model="form.availableFrom"
                type="date"
                required
                class="peer w-full px-6 py-4 rounded-xl bg-gray-50 border border-gray-200
                       focus:bg-white focus:border-blue-500 focus:ring-4 focus:ring-blue-50
                       placeholder-transparent transition-all duration-300 text-base"
                :min="today"
                placeholder="Disponible à partir du"
                id="availableFrom"
              />
              <label 
                for="availableFrom"
                class="absolute left-6 top-4 text-gray-500 pointer-events-none
                       transition-all duration-200 transform origin-left"
              >
                Disponible à partir du
              </label>
            </div>

            <div class="relative">
              <input
                v-model="form.availableTo"
                type="date"
                class="peer w-full px-6 py-4 rounded-xl bg-gray-50 border border-gray-200
                       focus:bg-white focus:border-blue-500 focus:ring-4 focus:ring-blue-50
                       placeholder-transparent transition-all duration-300 text-base"
                :min="form.availableFrom || today"
                placeholder="Jusqu'au (optionnel)"
                id="availableTo"
              />
              <label 
                for="availableTo"
                class="absolute left-6 top-4 text-gray-500 pointer-events-none
                       transition-all duration-200 transform origin-left"
              >
                Jusqu'au (optionnel)
              </label>
            </div>
          </div>

          <!-- Recurring Availability -->
          <div class="space-y-4">
            <label class="flex items-start gap-3 cursor-pointer group">
              <input
                v-model="form.isRecurring"
                type="checkbox"
                class="mt-0.5 rounded border-gray-300 text-blue-500 
                       focus:ring-blue-500 focus:ring-offset-0"
              />
              <div>
                <span class="text-gray-700 font-medium">Disponibilité récurrente</span>
                <p class="text-sm text-gray-500">L'objet sera disponible régulièrement entre ces dates</p>
              </div>
            </label>

            <div v-if="form.isRecurring" class="pl-8 space-y-3">
              <label 
                v-for="day in weekDays" 
                :key="day.value"
                class="flex items-center gap-3 cursor-pointer group"
              >
                <input
                  v-model="form.availableDays"
                  type="checkbox"
                  :value="day.value"
                  class="rounded border-gray-300 text-blue-500 
                         focus:ring-blue-500 focus:ring-offset-0"
                />
                <span class="text-gray-600 group-hover:text-gray-900">{{ day.label }}</span>
              </label>
            </div>
          </div>
        </div>
      </div>

      <!-- Submit Buttons -->
      <div class="flex justify-end gap-4">
        <SharedUiButton
          type="button"
          variant="secondary"
          class="px-8 py-3 text-base font-medium rounded-xl"
          @click="$emit('cancel')"
        >
          Annuler
        </SharedUiButton>
        <SharedUiButton
          type="submit"
          :disabled="!isValid || isSubmitting"
          class="px-8 py-3 text-base font-medium rounded-xl"
        >
          {{ isSubmitting ? 'Publication...' : 'Publier l\'annonce' }}
        </SharedUiButton>
      </div>
    </form>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { XMarkIcon, PhotoIcon, ChevronDownIcon } from '@heroicons/vue/24/outline'

const categories = [
  { id: 'tools', name: 'Bricolage' },
  { id: 'sport', name: 'Sport' },
  { id: 'camping', name: 'Camping' },
  { id: 'cooking', name: 'Cuisine' },
  { id: 'electronics', name: 'Électronique' },
  { id: 'garden', name: 'Jardin' }
]

const weekDays = [
  { value: 1, label: 'Lundi' },
  { value: 2, label: 'Mardi' },
  { value: 3, label: 'Mercredi' },
  { value: 4, label: 'Jeudi' },
  { value: 5, label: 'Vendredi' },
  { value: 6, label: 'Samedi' },
  { value: 0, label: 'Dimanche' }
]

const today = new Date().toISOString().split('T')[0]

const form = ref({
  title: '',
  category: '',
  price: '',
  description: '',
  images: [] as File[],
  availableFrom: '',
  availableTo: '',
  isRecurring: false,
  availableDays: [] as number[]
})

const imagePreview = ref<string[]>([])
const isSubmitting = ref(false)

const isValid = computed(() => {
  return form.value.title &&
         form.value.category &&
         form.value.price &&
         form.value.description &&
         form.value.images.length > 0
})

const handleImageUpload = (event: Event) => {
  const files = (event.target as HTMLInputElement).files
  if (!files) return

  Array.from(files).forEach(file => {
    if (imagePreview.value.length >= 8) return
    
    const reader = new FileReader()
    reader.onload = (e) => {
      if (e.target?.result) {
        imagePreview.value.push(e.target.result as string)
        form.value.images.push(file)
      }
    }
    reader.readAsDataURL(file)
  })
}

const removeImage = (index: number) => {
  imagePreview.value.splice(index, 1)
  form.value.images.splice(index, 1)
}

const handleSubmit = async () => {
  if (!isValid.value) return
  isSubmitting.value = true

  try {
    const formData = new FormData()
    formData.append('title', form.value.title)
    formData.append('category', form.value.category)
    formData.append('price', form.value.price)
    formData.append('description', form.value.description)
    
    form.value.images.forEach((image, index) => {
      formData.append(`images[${index}]`, image)
    })
    
    formData.append('availableFrom', form.value.availableFrom)
    formData.append('availableTo', form.value.availableTo)
    formData.append('isRecurring', form.value.isRecurring.toString())
    formData.append('availableDays', JSON.stringify(form.value.availableDays))
    
    emit('submit', formData)
  } catch (error) {
    console.error('Error submitting form:', error)
  } finally {
    isSubmitting.value = false
  }
}

const emit = defineEmits<{
  submit: [formData: FormData]
  cancel: []
}>()
</script>

<style scoped>
/* Floating label animation */
.peer:focus ~ label,
.peer:not(:placeholder-shown) ~ label {
  @apply text-xs text-blue-500;
  transform: translateY(-28px) scale(0.85);
}

/* Smooth transitions */
.transition-all {
  transition-property: all;
  transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
  transition-duration: 300ms;
}

label {
  transform-origin: 0 0;
}

/* Custom select styles */
select {
  background-image: none;
}
</style> 