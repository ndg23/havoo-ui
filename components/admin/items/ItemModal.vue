<template>
  <BaseModal :is-open="isOpen" :title="item ? 'Modifier l\'objet' : 'Nouvel objet'" @close="close">
    <form @submit.prevent="handleSubmit" class="space-y-6">
      <!-- Images -->
      <div>
        <h4 class="text-sm font-medium text-gray-700 mb-4">Images</h4>
        <div class="grid grid-cols-5 gap-4">
          <!-- Image principale -->
          <div class="col-span-2">
            <div 
              class="flex flex-col items-center p-4 border-2 border-dashed border-gray-200 rounded-lg hover:border-orange-500/50 transition-colors"
              :class="{ 'border-red-300': errors.mainImage }"
            >
              <img 
                :src="mainImagePreview"
                class="w-full h-32 object-cover rounded-lg mb-4"
              >
              <input 
                ref="imageInput"
                type="file" 
                accept="image/*"
                @change="handleMainImageUpload"
                class="block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-medium file:bg-orange-50 file:text-orange-700 hover:file:bg-orange-100"
              >
              <p class="mt-2 text-xs text-gray-500">Image principale</p>
              <p v-if="errors.mainImage" class="mt-1 text-xs text-red-500">{{ errors.mainImage }}</p>
            </div>
          </div>
          <!-- Images supplémentaires -->
          <div class="col-span-3 grid grid-cols-3 gap-2">
            <template v-for="(preview, index) in previewImages" :key="index">
              <div class="relative aspect-square">
                <img :src="preview" class="w-full h-full object-cover rounded-lg">
                <button 
                  @click="removeAdditionalImage(index)"
                  class="absolute top-1 right-1 p-1 bg-red-500 text-white rounded-full hover:bg-red-600"
                >
                  <XMarkIcon class="w-4 h-4" />
                </button>
              </div>
            </template>
            
            <label 
              v-if="previewImages.length < 3"
              class="aspect-square border border-dashed border-gray-200 rounded-lg flex items-center justify-center cursor-pointer hover:border-orange-500/50 transition-colors"
            >
              <input 
                type="file"
                accept="image/*"
                class="hidden"
                @change="handleAdditionalImageUpload"
                multiple
              >
              <PlusIcon class="w-6 h-6 text-gray-400" />
            </label>
          </div>
        </div>
      </div>

      <!-- Informations de base -->
      <div>
        <h4 class="text-sm font-medium text-gray-700 mb-4">Informations de base</h4>
        <div class="grid grid-cols-2 gap-4">
          <div class="col-span-2">
            <label class="block text-sm font-medium text-gray-700 mb-1">
              Nom de l'objet
              <span class="text-red-500">*</span>
            </label>
            <input 
              type="text" 
              v-model="form.name"
              :class="{ 'border-red-300': errors.name }"
              class="w-full px-3 py-2 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-orange-500/20 focus:border-orange-500"
              placeholder="ex: Perceuse Bosch Professional"
            >
            <p v-if="errors.name" class="mt-1 text-xs text-red-500">{{ errors.name }}</p>
          </div>
          <div class="col-span-2">
            <label class="block text-sm font-medium text-gray-700 mb-1">Description</label>
            <textarea 
              v-model="form.description"
              rows="3"
              class="w-full px-3 py-2 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-orange-500/20 focus:border-orange-500"
              placeholder="Description détaillée de l'objet..."
            ></textarea>
          </div>
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Catégorie</label>
            <select 
              v-model="form.category"
              class="w-full px-3 py-2 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-orange-500/20 focus:border-orange-500"
            >
              <option value="">Sélectionner une catégorie</option>
              <option v-for="category in categories" :key="category.id" :value="category.id">
                {{ category.name }}
              </option>
            </select>
          </div>
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">État</label>
            <select 
              v-model="form.condition"
              class="w-full px-3 py-2 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-orange-500/20 focus:border-orange-500"
            >
              <option value="new">Neuf</option>
              <option value="like_new">Comme neuf</option>
              <option value="good">Bon état</option>
              <option value="fair">État correct</option>
            </select>
          </div>
        </div>
      </div>

      <!-- Tarification -->
      <div>
        <h4 class="text-sm font-medium text-gray-700 mb-4">Tarification</h4>
        <div class="grid grid-cols-2 gap-4">
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Prix par jour (FCFA)</label>
            <input 
              type="number" 
              v-model="form.pricePerDay"
              min="0"
              step="0.5"
              class="w-full px-3 py-2 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-orange-500/20 focus:border-orange-500"
            >
          </div>
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Caution (FCFA)</label>
            <input 
              type="number" 
              v-model="form.deposit"
              min="0"
              class="w-full px-3 py-2 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-orange-500/20 focus:border-orange-500"
            >
          </div>
        </div>
      </div>

      <!-- Disponibilité -->
      <div>
        <h4 class="text-sm font-medium text-gray-700 mb-4">Disponibilité</h4>
        <div class="grid grid-cols-2 gap-4">
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Statut</label>
            <select 
              v-model="form.status"
              class="w-full px-3 py-2 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-orange-500/20 focus:border-orange-500"
            >
              <option value="available">Disponible</option>
              <option value="rented">En location</option>
              <option value="maintenance">En maintenance</option>
              <option value="inactive">Inactif</option>
            </select>
          </div>
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Localisation</label>
            <input 
              type="text" 
              v-model="form.location"
              class="w-full px-3 py-2 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-orange-500/20 focus:border-orange-500"
              placeholder="ex: Paris 75011"
            >
          </div>
        </div>
      </div>

      <!-- Actions -->
      <div class="flex justify-end gap-3 pt-4">
        <button 
          type="button"
          @click="close"
          class="px-4 py-2 text-gray-700 bg-gray-100 rounded-lg hover:bg-gray-200"
        >
          Annuler
        </button>
        <button 
          type="submit"
          class="px-4 py-2 bg-orange-500 text-white rounded-lg hover:bg-orange-600"
        >
          {{ item ? 'Modifier' : 'Créer' }}
        </button>
      </div>
    </form>
  </BaseModal>
</template>

<script setup lang="ts">
import { ref, watch, computed } from 'vue'
import { PlusIcon, XMarkIcon } from '@heroicons/vue/24/outline'
import BaseModal from '../BaseModal.vue'

interface ItemForm {
  name: string
  description: string
  mainImage: string | File
  category: string
  condition: string
  pricePerDay: number
  deposit: number
  status: string
  location: string
}

const props = defineProps<{
  isOpen: boolean
  item?: any
}>()

const emit = defineEmits<{
  (e: 'close'): void
  (e: 'submit', data: FormData): void
}>()

// Sample data
const categories = [
  { id: 'tools', name: 'Outils' },
  { id: 'garden', name: 'Jardin' },
  { id: 'sport', name: 'Sport' },
  { id: 'party', name: 'Fête' },
  { id: 'tech', name: 'High-Tech' }
]

const form = ref<ItemForm>({
  name: '',
  description: '',
  mainImage: '',
  category: '',
  condition: 'good',
  pricePerDay: 0,
  deposit: 0,
  status: 'available',
  location: ''
})

// Gestion des images
const imageInput = ref<HTMLInputElement | null>(null)
const additionalImages = ref<File[]>([])
const previewImages = ref<string[]>([])

const mainImagePreview = computed(() => {
  if (typeof form.value.mainImage !== 'string') {
    return URL.createObjectURL(form.value.mainImage)
  }
  return form.value.mainImage || '/placeholder-item.png'
})

const handleMainImageUpload = (event: Event) => {
  const input = event.target as HTMLInputElement
  if (input.files && input.files[0]) {
    form.value.mainImage = input.files[0]
  }
}

const handleAdditionalImageUpload = (event: Event) => {
  const input = event.target as HTMLInputElement
  if (input.files) {
    const newFiles = Array.from(input.files)
    additionalImages.value = [...additionalImages.value, ...newFiles].slice(0, 3)
    
    newFiles.forEach(file => {
      const reader = new FileReader()
      reader.onload = (e) => {
        if (e.target?.result) {
          previewImages.value.push(e.target.result as string)
        }
      }
      reader.readAsDataURL(file)
    })
  }
}

const removeAdditionalImage = (index: number) => {
  additionalImages.value = additionalImages.value.filter((_, i) => i !== index)
  previewImages.value = previewImages.value.filter((_, i) => i !== index)
}

// Validation
const errors = ref<Record<string, string>>({})

const validateForm = () => {
  errors.value = {}
  
  if (!form.value.name) {
    errors.value.name = 'Le nom est requis'
  }
  if (!form.value.category) {
    errors.value.category = 'La catégorie est requise'
  }
  if (form.value.pricePerDay <= 0) {
    errors.value.pricePerDay = 'Le prix doit être supérieur à 0'
  }
  
  return Object.keys(errors.value).length === 0
}

const handleSubmit = () => {
  if (!validateForm()) return

  const formData = new FormData()
  
  // Ajouter les champs du formulaire
  Object.entries(form.value).forEach(([key, value]) => {
    if (value !== null && value !== undefined) {
      if (value instanceof File) {
        formData.append(key, value)
      } else {
        formData.append(key, String(value))
      }
    }
  })
  
  // Ajouter les images additionnelles
  additionalImages.value.forEach((file, index) => {
    formData.append(`additionalImages[${index}]`, file)
  })

  emit('submit', formData)
  close()
}

const close = () => {
  previewImages.value.forEach(preview => {
    if (preview.startsWith('blob:')) {
      URL.revokeObjectURL(preview)
    }
  })
  previewImages.value = []
  additionalImages.value = []
  emit('close')
}

watch(() => props.item, (newItem) => {
  if (newItem) {
    form.value = {
      ...form.value,
      ...newItem
    }
  } else {
    form.value = {
      name: '',
      description: '',
      mainImage: '',
      category: '',
      condition: 'good',
      pricePerDay: 0,
      deposit: 0,
      status: 'available',
      location: ''
    }
  }
}, { immediate: true })
</script> 