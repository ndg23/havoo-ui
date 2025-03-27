<template>
  <form @submit.prevent="handleSubmit" class="space-y-6">
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
      <SharedUiInput
        v-model="form.name"
        label="Nom de l'objet"
        required
        :error="errors.name"
      />
      
      <SharedUiSelect
        v-model="form.category"
        :options="professions"
        label="Catégorie"
        required
        :error="errors.category"
      />
    </div>

    <SharedUiInput
      v-model="form.description"
      label="Description"
      type="textarea"
      rows="4"
      required
      :error="errors.description"
    />

    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
      <SharedUiInput
        v-model="form.price"
        type="number"
        label="Prix par jour (FCFA)"
        min="0"
        step="0.01"
        required
        :error="errors.price"
      />

      <div>
        <label class="block text-sm font-medium text-gray-700 mb-1">
          Photo de l'objet
        </label>
        <div class="flex items-center space-x-4">
          <img
            v-if="imagePreview"
            :src="imagePreview"
            alt="Aperçu"
            class="w-20 h-20 object-cover rounded"
          />
          <input
            type="file"
            accept="image/*"
            @change="handleImageChange"
            class="block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-blue-50 file:text-blue-700 hover:file:bg-blue-100"
          />
        </div>
        <p v-if="errors.image" class="mt-1 text-sm text-red-600">
          {{ errors.image }}
        </p>
      </div>
    </div>

    <div class="flex justify-end space-x-4">
      <SharedUiButton
        type="button"
        variant="secondary"
        @click="$emit('cancel')"
      >
        Annuler
      </SharedUiButton>
      <SharedUiButton
        type="submit"
        :disabled="!isValid || isSubmitting"
      >
        {{ item ? 'Modifier' : 'Ajouter' }}
      </SharedUiButton>
    </div>
  </form>
</template>

<script setup lang="ts">
import type { Item } from '~/stores/user'

const props = defineProps<{
  item?: Item
}>()

const emit = defineEmits<{
  submit: [formData: FormData]
  cancel: []
}>()

const professions = [
  { value: 'tools', label: 'Outils' },
  { value: 'sports', label: 'Sports' },
  { value: 'electronics', label: 'Électronique' },
  { value: 'garden', label: 'Jardin' },
  { value: 'other', label: 'Autre' }
]

const form = ref({
  name: props.item?.name || '',
  description: props.item?.description || '',
  category: props.item?.category || '',
  price: props.item?.price?.toString() || '',
  image: null as File | null
})

const imagePreview = ref(props.item?.image || '')
const errors = ref({} as Record<string, string>)
const isSubmitting = ref(false)

const isValid = computed(() => {
  return form.value.name &&
    form.value.description &&
    form.value.category &&
    form.value.price &&
    Object.keys(errors.value).length === 0
})

const handleImageChange = (event: Event) => {
  const file = (event.target as HTMLInputElement).files?.[0]
  if (file) {
    if (file.size > 5 * 1024 * 1024) {
      errors.value.image = 'L\'image ne doit pas dépasser 5Mo'
      return
    }
    form.value.image = file
    imagePreview.value = URL.createObjectURL(file)
  }
}

const handleSubmit = async () => {
  errors.value = {}
  isSubmitting.value = true

  try {
    const formData = new FormData()
    formData.append('name', form.value.name)
    formData.append('description', form.value.description)
    formData.append('category', form.value.category)
    formData.append('price', form.value.price)
    if (form.value.image) {
      formData.append('image', form.value.image)
    }

    emit('submit', formData)
  } catch (error) {
    console.error('Erreur lors de la soumission:', error)
  } finally {
    isSubmitting.value = false
  }
}
</script> 