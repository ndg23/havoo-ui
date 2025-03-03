<template>
  <form @submit.prevent="validateAndSubmit" class="space-y-8">
    <!-- Validation des erreurs -->
    <div 
      v-if="errors.length" 
      class="bg-red-50 border border-red-200 rounded-xl p-4"
    >
      <h3 class="text-sm font-medium text-red-800 mb-2">
        Veuillez corriger les erreurs suivantes :
      </h3>
      <ul class="text-sm text-red-700 list-disc list-inside">
        <li v-for="error in errors" :key="error">{{ error }}</li>
      </ul>
    </div>

  
    <!-- Form sections with visual indicators -->
    <div class="bg-white rounded-xl border ">
      <div class="p-6">
        <h2 class="text-lg font-semibold text-gray-900 mb-6 flex items-center">
          <TagIcon class="w-5 h-5 text-orange-500 mr-2" />
          Informations de l'objet
        </h2>
      <div class="space-y-4">
        <FloatingInput
          id="name"
          v-model="form.name"
          label="Nom de l'objet"
          required
            :error="hasFieldError('name')"
        />
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
          <FloatingSelect
            id="category"
            v-model="form.category"
            label="Catégorie"
            :options="categories"
            required
              :error="hasFieldError('category')"
            >
              <template #prefix>
                <FolderIcon class="w-4 h-4 text-gray-400" />
              </template>
            </FloatingSelect>
          <FloatingInput
            id="price"
            v-model="form.price"
            type="number"
              label="Prix par jour (FCFA)"
            min="1"
            step="0.5"
            required
              :error="hasFieldError('price')"
            >
              <template #prefix>
                <EuroIcon class="w-4 h-4 text-gray-400" />
              </template>
            </FloatingInput>
        </div>
        <FloatingTextarea
          id="description"
          v-model="form.description"
          label="Description"
          required
            :error="hasFieldError('description')"
            :rows="3"
          />
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
            <FloatingSelect
              id="condition"
              v-model="form.condition"
              label="État"
              :options="conditions"
              required
              :error="hasFieldError('condition')"
            >
              <template #prefix>
                <BadgeCheckIcon class="w-4 h-4 text-gray-400" />
              </template>
            </FloatingSelect>
          </div>
        </div>
      </div>
      <ProgressBar :progress="sectionProgress.basic" />
    </div>

    <!-- Photos with improved UI -->
    <div class="bg-white rounded-xl border ">
      <div class="p-6">
        <h2 class="text-lg font-semibold text-gray-900 mb-6 flex items-center">
          <CameraIcon class="w-5 h-5 text-orange-500 mr-2" />
          Photos
          <span class="ml-2 text-sm font-normal text-gray-500">
            ({{ form.images.length }}/4)
          </span>
        </h2>
        <div 
          class="grid grid-cols-2 sm:grid-cols-4 gap-4"
          @dragover.prevent="dragActive = true"
          @dragleave.prevent="dragActive = false"
          @drop.prevent="handleDrop($event); dragActive = false"
          :class="{ 'bg-orange-50 border-2 border-dashed border-orange-300 p-4 rounded-xl': dragActive }"
        >
          <!-- Existing images -->
          <TransitionGroup name="image-fade">
        <div 
          v-for="(image, index) in form.images" 
          :key="index"
              class="aspect-square rounded-xl overflow-hidden relative group -shadow-sm"
        >
          <img 
            :src="image.url || URL.createObjectURL(image)"
            class="w-full h-full object-cover"
            alt=""
          />
              <div class="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent opacity-0 group-hover:opacity-100 transition-opacity flex flex-col justify-end p-2">
          <button
            type="button"
                  class="ml-auto bg-white/90 rounded-full p-1 text-red-500 hover:bg-red-500 hover:text-white transition-colors"
            @click="removeImage(index)"
          >
                  <TrashIcon class="w-4 h-4" />
          </button>
        </div>
              <div class="absolute top-2 left-2 bg-black/50 text-white text-xs px-2 py-1 rounded-full">
                Photo {{ index + 1 }}
              </div>
            </div>
          </TransitionGroup>

          <!-- Add button -->
        <div
          v-if="form.images.length < 4"
            class="aspect-square rounded-xl border-2 border-dashed border-gray-200 flex flex-col items-center justify-center hover:border-orange-500/50 hover:bg-orange-50 transition-colors cursor-pointer group"
          @click="$refs.fileInput.click()"
        >
            <PlusIcon class="w-8 h-8 text-gray-400 group-hover:text-orange-500 transition-colors" />
            <span class="text-xs text-gray-500 mt-2 group-hover:text-orange-500 transition-colors">Ajouter</span>
          <input
            ref="fileInput"
            type="file"
            accept="image/*"
            class="hidden"
            @change="addImage"
          />
        </div>
      </div>
        <p class="mt-4 text-sm text-gray-500 flex items-center">
          <UploadCloudIcon class="w-4 h-4 mr-2 text-gray-400" />
        Glissez-déposez vos photos ici ou cliquez pour en ajouter.
          <span class="text-xs ml-1 text-gray-400">Format : JPG, PNG. Max : 5 MB</span>
      </p>
      </div>
      <ProgressBar :progress="sectionProgress.photos" />
    </div>

    <!-- Rental conditions -->
    <div class="bg-white rounded-xl border ">
      <div class="p-6">
        <h2 class="text-lg font-semibold text-gray-900 mb-6 flex items-center">
          <ClipboardCheckIcon class="w-5 h-5 text-orange-500 mr-2" />
          Conditions de location
        </h2>
      <div class="space-y-4">
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
        <FloatingInput
          id="minDuration"
          v-model="form.minDuration"
          type="number"
          label="Durée minimum (jours)"
          min="1"
          required
              :error="hasFieldError('minDuration')"
            >
              <template #prefix>
                <CalendarIcon class="w-4 h-4 text-gray-400" />
              </template>
            </FloatingInput>
        <FloatingInput
          id="deposit"
          v-model="form.deposit"
          type="number"
          label="Caution (€)"
          min="0"
          required
              :error="hasFieldError('deposit')"
            >
              <template #prefix>
                <ShieldIcon class="w-4 h-4 text-gray-400" />
              </template>
            </FloatingInput>
          </div>
        <FloatingTextarea
          id="conditions"
          v-model="form.conditions"
          label="Conditions particulières"
          placeholder="Ex: Pièce d'identité requise, retour propre exigé..."
            :rows="2"
          />
        </div>
      </div>
      <ProgressBar :progress="sectionProgress.conditions" />
    </div>

    <!-- Availability with calendar features -->
    <div class="bg-white rounded-xl border ">
      <div class="p-6">
        <h2 class="text-lg font-semibold text-gray-900 mb-6 flex items-center">
          <ClockIcon class="w-5 h-5 text-orange-500 mr-2" />
          Disponibilité
        </h2>
        <div class="space-y-6">
          <!-- Availability period -->
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2">Période de disponibilité</label>
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <FloatingInput
                type="date"
                id="availabilityStartDate"
                v-model="form.availabilityStartDate"
                label="Disponible du"
                :min="new Date().toISOString().split('T')[0]"
                required
                :error="hasFieldError('availabilityStartDate')"
              >
                <template #prefix>
                  <CalendarIcon class="w-4 h-4 text-gray-400" />
                </template>
              </FloatingInput>
              <FloatingInput
                type="date"
                id="availabilityEndDate"
                v-model="form.availabilityEndDate"
                label="au"
                :min="form.availabilityStartDate"
                required
                :error="hasFieldError('availabilityEndDate')"
              >
                <template #prefix>
                  <CalendarIcon class="w-4 h-4 text-gray-400" />
                </template>
              </FloatingInput>
            </div>
          </div>

          <!-- Time slots with better organization -->
          <div>
            <div class="flex items-center justify-between mb-2">
              <label class="block text-sm font-medium text-gray-700">Créneaux quotidiens</label>
              <button 
                type="button"
                @click="addTimeSlot"
                class="text-sm text-orange-500 hover:text-orange-600 flex items-center"
              >
                <PlusIcon class="w-4 h-4 mr-1" />
                Ajouter un créneau
              </button>
            </div>
            
            <TransitionGroup name="list" tag="div" class="space-y-3">
              <div 
                v-for="(slot, index) in form.timeSlots" 
                :key="index"
                class="flex items-center gap-4 p-3 rounded-lg border border-gray-100 bg-gray-50 hover:bg-white transition-colors"
              >
                <div class="flex-shrink-0 w-6 h-6 flex items-center justify-center rounded-full bg-orange-100 text-orange-600 text-xs font-medium">
                  {{ index + 1 }}
                </div>
                <div class="flex flex-grow items-center gap-4">
                  <FloatingInput
                    id="time-start"
                    type="time"
                    v-model="slot.start"
                    label="Début"
                  >
                    <template #prefix>
                      <ClockIcon class="w-3 h-3 text-gray-400" />
                    </template>
                  </FloatingInput>
                  <span class="text-gray-500">-</span>
                  <FloatingInput
                    id="time-end"
                    type="time"
                    v-model="slot.end"
                    label="Fin"
                  >
                    <template #prefix>
                      <ClockIcon class="w-3 h-3 text-gray-400" />
                    </template>
                  </FloatingInput>
                </div>
                <button 
                  type="button"
                  @click="removeTimeSlot(index)"
                  class="flex-shrink-0 text-gray-400 hover:text-red-500 p-1 rounded-full hover:bg-red-50 transition"
                >
                  <TrashIcon class="w-4 h-4" />
                </button>
              </div>
            </TransitionGroup>
            
            <div v-if="!form.timeSlots.length" class="text-center py-4 border border-dashed border-gray-200 rounded-lg">
              <ClockIcon class="w-6 h-6 text-gray-300 mx-auto" />
              <p class="text-sm text-gray-500 mt-2">Aucun créneau défini</p>
            </div>
          </div>
        </div>
      </div>
      <ProgressBar :progress="sectionProgress.availability" />
    </div>

    <!-- Form controls -->
    <div class="flex flex-col sm:flex-row sm:justify-between gap-4 items-center">
      <div class="text-sm text-gray-500">
        <span v-if="formCompletionPercentage < 100">
          {{ formCompletionPercentage }}% complété
        </span>
        <span v-else class="text-green-600 font-medium flex items-center">
          <CheckCircleIcon class="w-4 h-4 mr-1" />
          Formulaire complété
        </span>
      </div>
      
      <div class="flex w-full sm:w-auto gap-3">
      <button 
        type="button"
          class="flex-1 sm:flex-initial px-5 py-2.5 text-gray-700 bg-white border border-gray-300 rounded-lg hover:bg-gray-50 flex items-center justify-center"
        @click="$emit('cancel')"
      >
          <XIcon class="w-4 h-4 mr-2" />
        Annuler
      </button>
      <button 
        type="submit"
          class="flex-1 sm:flex-initial px-5 py-2.5 bg-orange-500 text-white rounded-lg hover:bg-orange-600 flex items-center justify-center font-medium transition-colors"
      >
          <SaveIcon class="w-4 h-4 mr-2" />
          {{ submitLabel || 'Enregistrer' }}
      </button>
      </div>
    </div>
  </form>
</template>

<script setup lang="ts">
import { 
  PlusIcon, 
  TrashIcon, 
  CameraIcon, 
  ClockIcon, 
  SaveIcon, 
  XIcon,
  TagIcon,
  ClipboardCheckIcon,
  CalendarIcon,
  FolderIcon,
  EuroIcon,
  BadgeCheckIcon,
  AlertCircleIcon,
  UploadCloudIcon,
  ShieldIcon,
  CheckCircleIcon
} from 'lucide-vue-next'
import FloatingInput from '~/components/shared/FloatingInput.vue'
import FloatingSelect from '~/components/shared/FloatingSelect.vue'
import FloatingTextarea from '~/components/shared/FloatingTextarea.vue'
import { ref, computed } from 'vue'
import { useNotificationStore } from '~/stores/notification'

// Progress bar component
const ProgressBar = defineComponent({
  props: {
    progress: {
      type: Number,
      required: true
    }
  },
  setup(props) {
    return () => h('div', { class: 'h-1 bg-gray-100' }, [
      h('div', { 
        class: 'h-full bg-orange-500 transition-all duration-500',
        style: { width: `${props.progress}%` }
      })
    ])
  }
})

const props = defineProps({
  modelValue: {
    type: Object,
    required: true
  },
  submitLabel: {
    type: String,
    default: 'Enregistrer'
  }
})

const emit = defineEmits<{
  (e: 'update:modelValue', value: any): void
  (e: 'submit'): void
  (e: 'cancel'): void
}>()

// Form state
const form = computed({
  get: () => props.modelValue,
  set: (value) => emit('update:modelValue', value)
})

// Form UI states
const errors = ref<string[]>([])
const dragActive = ref(false)
const fieldErrors = ref<Set<string>>(new Set())

// Lists
const categories = [
  { value: 'tools', label: 'Outils' },
  { value: 'garden', label: 'Jardin' },
  { value: 'sport', label: 'Sport' },
  { value: 'party', label: 'Fête' },
  { value: 'camping', label: 'Camping' },
  { value: 'electronics', label: 'Électronique' },
  { value: 'diy', label: 'Bricolage' },
  { value: 'kitchen', label: 'Cuisine' },
  { value: 'other', label: 'Autre' }
]

const conditions = [
  { value: 'new', label: 'Neuf' },
  { value: 'very_good', label: 'Très bon état' },
  { value: 'good', label: 'Bon état' },
  { value: 'fair', label: 'État correct' }
]

// Stores
const notificationStore = useNotificationStore()

// Methods
const addImage = (event: Event) => {
  const input = event.target as HTMLInputElement
  const files = input.files
  
  if (files && files.length > 0) {
    const file = files[0]
    
    // Validate file size
    if (file.size > 5 * 1024 * 1024) {
      notificationStore.error(
        'Fichier trop volumineux',
        'La taille maximum est de 5 MB'
      )
      input.value = ''
      return
    }
    
    // Validate file type
    if (!file.type.startsWith('image/')) {
      notificationStore.error(
        'Format non supporté',
        'Seules les images sont acceptées'
      )
      input.value = ''
      return
    }
    
    form.value.images.push(file)
    
    // Provide feedback
    notificationStore.success(
      'Image ajoutée',
      `${file.name} a été ajouté avec succès`
    )
  }
  
  // Reset input
  input.value = ''
}

const removeImage = (index: number) => {
  const image = form.value.images[index]
  form.value.images.splice(index, 1)
  
  // Provide feedback
  notificationStore.info(
    'Image supprimée',
    image.name ? `${image.name} a été supprimé` : 'L\'image a été supprimée'
  )
}

// Time slot methods
const addTimeSlot = () => {
  form.value.timeSlots.push({ start: '09:00', end: '18:00' })
}

const removeTimeSlot = (index: number) => {
  form.value.timeSlots.splice(index, 1)
}

// Form validation
const validateForm = () => {
  errors.value = []
  fieldErrors.value.clear()
  
  // Required field validation
  const requiredFields = [
    { field: 'name', label: 'Le nom' },
    { field: 'category', label: 'La catégorie' },
    { field: 'price', label: 'Le prix' },
    { field: 'description', label: 'La description' },
    { field: 'condition', label: 'L\'état' },
    { field: 'minDuration', label: 'La durée minimum' },
    { field: 'deposit', label: 'La caution' },
    { field: 'availabilityStartDate', label: 'La date de début' },
    { field: 'availabilityEndDate', label: 'La date de fin' }
  ]
  
  requiredFields.forEach(({ field, label }) => {
    if (!form.value[field]) {
      errors.value.push(`${label} est requis`)
      fieldErrors.value.add(field)
    }
  })
  
  // Specific validations
  if (form.value.price && form.value.price <= 0) {
    errors.value.push('Le prix doit être supérieur à 0')
    fieldErrors.value.add('price')
  }
  
  if (!form.value.images.length) {
    errors.value.push('Au moins une photo est requise')
  }
  
  if (!form.value.timeSlots.length) {
    errors.value.push('Au moins un créneau horaire est requis')
  }
  
  // Date validations
  if (form.value.availabilityStartDate && form.value.availabilityEndDate) {
    if (form.value.availabilityStartDate > form.value.availabilityEndDate) {
      errors.value.push('La date de fin doit être postérieure à la date de début')
      fieldErrors.value.add('availabilityEndDate')
    }
  }
  
  return errors.value.length === 0
}

const hasFieldError = (fieldName: string) => {
  return fieldErrors.value.has(fieldName)
}

const validateAndSubmit = () => {
  if (validateForm()) {
    emit('submit')
    notificationStore.success(
      'Formulaire soumis',
      'Vos informations ont été envoyées avec succès'
    )
  } else {
    // Scroll to errors
    setTimeout(() => {
      document.querySelector('.bg-red-50')?.scrollIntoView({ 
        behavior: 'smooth',
        block: 'center'
      })
    }, 100)
  }
}

// Drag and drop handling
const handleDrop = (event: DragEvent) => {
  const files = event.dataTransfer?.files
  if (!files) return
  
  let addedCount = 0
  const maxAllowed = 4 - form.value.images.length
  
  Array.from(files).forEach(file => {
    if (addedCount >= maxAllowed) {
      return
    }
    
    if (!file.type.startsWith('image/')) {
      notificationStore.error(
        'Format non supporté',
        'Seules les images sont acceptées'
      )
      return
    }
    
    if (file.size > 5 * 1024 * 1024) {
      notificationStore.error(
        'Fichier trop volumineux',
        'La taille maximum est de 5 MB'
      )
      return
    }
    
    form.value.images.push(file)
    addedCount++
  })
  
  if (addedCount > 0) {
    notificationStore.success(
      'Images ajoutées', 
      `${addedCount} image${addedCount > 1 ? 's' : ''} ajoutée${addedCount > 1 ? 's' : ''}`
    )
  }
  
  if (addedCount < files.length) {
    notificationStore.info(
      'Maximum atteint',
      'Certaines images n\'ont pas été ajoutées (maximum 4 photos)'
    )
  }
}

// Form completion metrics
const sectionProgress = computed(() => {
  const basic = calculateSectionProgress([
    !!form.value.name,
    !!form.value.category,
    !!form.value.price && form.value.price > 0,
    !!form.value.description,
    !!form.value.condition
  ])
  
  const photos = calculateSectionProgress([
    form.value.images.length > 0
  ])
  
  const conditions = calculateSectionProgress([
    !!form.value.minDuration && form.value.minDuration > 0,
    form.value.deposit !== undefined && form.value.deposit !== null
  ])
  
  const availability = calculateSectionProgress([
    !!form.value.availabilityStartDate,
    !!form.value.availabilityEndDate,
    form.value.timeSlots.length > 0
  ])
  
  return { basic, photos, conditions, availability }
})

const calculateSectionProgress = (criteria: boolean[]) => {
  if (criteria.length === 0) return 0
  return (criteria.filter(Boolean).length / criteria.length) * 100
}

const formCompletionPercentage = computed(() => {
  const weights = {
    basic: 0.4,
    photos: 0.2,
    conditions: 0.2,
    availability: 0.2
  }
  
  const weightedProgress = 
    sectionProgress.value.basic * weights.basic +
    sectionProgress.value.photos * weights.photos +
    sectionProgress.value.conditions * weights.conditions +
    sectionProgress.value.availability * weights.availability
  
  return Math.round(weightedProgress)
})
</script> 

<style scoped>
/* Transitions */
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s, transform 0.3s;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
  transform: translateY(-10px);
}

.image-fade-enter-active,
.image-fade-leave-active {
  transition: all 0.3s;
}

.image-fade-enter-from {
  opacity: 0;
  transform: scale(0.9);
}

.image-fade-leave-to {
  opacity: 0;
  transform: scale(0.9);
}

.list-enter-active,
.list-leave-active {
  transition: all 0.3s;
}

.list-enter-from {
  opacity: 0;
  transform: translateX(-20px);
}

.list-leave-to {
  opacity: 0;
  transform: translateX(20px);
}
</style>