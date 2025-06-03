<template>
  <div class="min-h-screen bg-white dark:bg-gray-900">
    <!-- Header avec style GAFAM -->
    <header class="sticky top-0 z-10 bg-white/80 dark:bg-gray-900/80 backdrop-blur-sm border-b border-gray-100 dark:border-gray-800">
      <div class="max-w-2xl mx-auto px-4 py-4">
        <div class="flex items-center justify-between">
          <div class="flex items-center gap-4">
            <NuxtLink to="/requests" class="p-2 -ml-2 rounded-full hover:bg-gray-100 dark:hover:bg-gray-800 transition-colors">
              <UIcon name="i-heroicons-arrow-left" class="w-5 h-5 text-gray-700 dark:text-gray-300" />
            </NuxtLink>
            <h1 class="text-2xl font-semibold bg-gradient-to-r from-primary to-primary-600 bg-clip-text text-transparent">
              Nouvelle mission
            </h1>
          </div>
          <div class="text-sm text-gray-500">
            {{ isFormValid ? 'Prêt à publier' : 'En cours de rédaction' }}
                    </div>
                  </div>
                </div>
    </header>

    <!-- Formulaire -->
    <main class="max-w-2xl mx-auto px-4 py-6">
      <form @submit.prevent="handleSubmit" class="space-y-6">
        <!-- Titre -->
        <FloatingLabelInput
          id="title"
          v-model="formData.title"
          label="Titre de votre mission"
          :error="formErrors.title"
          required
          maxlength="100"
          helpText="Soyez clair et concis dans votre titre (max 100 caractères)"
        />

        <!-- Description -->
        <div class="relative w-full">
          <textarea
            id="description"
            v-model="formData.description"
            rows="4"
            class="block w-full pl-6 pr-4 pt-6 text-gray-900 dark:text-white border border-gray-200 dark:border-gray-700 rounded-2xl  transition-colors text-lg dark:bg-gray-800"
            :class="{ 'border-red-500': formErrors.description }"
            maxlength="500"
          />
          <label
            for="description"
            class="absolute left-4 pointer-events-none transition-all duration-200 ease-out"
                    :class="[
              formData?.description ? 'text-xs top-2 text-blue-600' : 'text-base top-4 text-gray-500'
            ]"
          >
            Description détaillée
            <span class="text-red-500 ml-0.5">*</span>
          </label>
          <div class="mt-1 flex justify-end">
            <span class="text-sm text-gray-500">
              {{ formData?.description?.length || 0 }}/500
                      </span>
                    </div>
                    </div>
                    
        <!-- Budget -->
        <FloatingLabelInput
          id="budget"
          v-model="formData.budget"
          label="Budget (en FCFA)"
                      type="number"
          :error="formErrors.budget"
          required
                      min="1000"
          helpText="Montant minimum: 1000 FCFA"
        />

        <!-- Date limite -->
        <FloatingLabelInput
          id="deadline"
          v-model="formData.deadline"
          label="Date limite"
          type="date"
          :error="formErrors.deadline"
          required
          :min="minDate"
          helpText="Date limite de réalisation"
        />

        <!-- Type de travail -->
        <div class="space-y-2">
                  <label class="block text-sm font-medium text-gray-700 dark:text-gray-300">
            Type de travail
                  </label>
          <div class="flex gap-4">
            <label class="flex items-center gap-2 p-4 border rounded-xl cursor-pointer transition-colors"
              :class="formData.workType === 'remote' ? 'border-primary bg-primary/5' : 'border-gray-200'">
                    <input
                type="radio" 
                v-model="formData.workType" 
                value="remote"
                class="text-primary focus:ring-primary"
              />
              <span>En ligne</span>
            </label>
            <label class="flex items-center gap-2 p-4 border rounded-xl cursor-pointer transition-colors"
              :class="formData.workType === 'onsite' ? 'border-primary bg-primary/5' : 'border-gray-200'">
              <input 
                type="radio" 
                v-model="formData.workType" 
                value="onsite"
                class="text-primary focus:ring-primary"
              />
              <span>Sur place</span>
            </label>
                  </div>
                </div>

        <!-- Urgence -->
        <label class="flex items-center gap-3 p-4 border rounded-xl cursor-pointer transition-colors"
          :class="formData.isUrgent ? 'border-primary bg-primary/5' : 'border-gray-200'">
          <input 
            type="checkbox" 
            v-model="formData.isUrgent"
            class="rounded text-primary focus:ring-primary"
          />
          <div>
            <span class="font-medium">Mission urgente</span>
            <p class="text-sm text-gray-500">La mission nécessite une réalisation rapide</p>
          </div>
        </label>

        <!-- Bouton de soumission amélioré -->
        <div class="fixed- bottom-0 left-0 right-0 bg-white/80 dark:bg-gray-900/80 backdrop-blur-sm border-t border-gray-100 dark:border-gray-800">
          <div class="max-w-2xl mx-auto px-4 py-4">
            <button
              type="submit"
              :disabled="!isFormValid || isSubmitting"
              class="relative w-full h-14 rounded-2xl font-medium text-white overflow-hidden transition-all duration-300"
              :class="[
                isFormValid ? 'bg-gradient-to-r from-primary to-primary-600 hover:scale-[1.02]' : 'bg-gray-200 dark:bg-gray-800'
              ]"
            >
              <span class="relative z-10 flex items-center justify-center gap-2">
                <UIcon 
                  :name="isSubmitting ? 'i-heroicons-arrow-path' : 'i-heroicons-rocket-launch'" 
                  class="w-5 h-5"
                  :class="{ 'animate-spin': isSubmitting }"
                />
                {{ isSubmitting ? 'Publication en cours...' : 'Publier la mission' }}
              </span>
              <div 
                v-if="isFormValid && !isSubmitting"
                class="absolute inset-0 bg-gradient-to-r from-primary-600 to-primary opacity-0 hover:opacity-100 transition-opacity duration-300"
              />
            </button>

            <p v-if="formErrors.submit" class="mt-2 text-sm text-red-600 text-center">
              {{ formErrors.submit }}
            </p>
          </div>
        </div>
      </form>
    </main>

    <!-- Modal de succès amélioré -->
    <UModal v-model="showSuccessModal">
      <div class="p-8 text-center">
        <div class="mx-auto w-16 h-16 rounded-full bg-gradient-to-r from-green-400 to-green-500 flex items-center justify-center mb-6">
          <UIcon name="i-heroicons-check" class="w-8 h-8 text-white" />
                    </div>
        <h3 class="text-2xl font-semibold text-gray-900 dark:text-white mb-3">
                      Mission publiée !
        </h3>
        <p class="text-gray-600 dark:text-gray-400 mb-8">
          Votre mission est maintenant en ligne et visible par les experts.
        </p>
        <div class="flex flex-col gap-3">
                      <button
            @click="router.push('/requests')"
            class="w-full h-12 rounded-xl bg-gradient-to-r from-primary to-primary-600 text-white font-medium hover:scale-[1.02] transition-transform"
                      >
                        Voir mes missions
                      </button>
          <button
            @click="showSuccessModal = false"
            class="w-full h-12 rounded-xl border border-gray-200 dark:border-gray-700 font-medium hover:bg-gray-50 dark:hover:bg-gray-800 transition-colors"
          >
            Fermer
                      </button>
                    </div>
                  </div>
    </UModal>
        </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useRouter } from 'vue-router'
import { useSupabaseClient } from '#imports'
import FloatingLabelInput from '../../components/FloatingLabelInput.vue'

const router = useRouter()
const supabase = useSupabaseClient()

// États
const formData = ref({
  title: '',
  description: '',
  budget: '',
  deadline: '',
  workType: 'remote',
  isUrgent: false
})

const formErrors = ref({})
const isSubmitting = ref(false)
const showSuccessModal = ref(false)

// Validation des champs
const validateForm = () => {
  const errors = {}
  
  if (!formData.value.title?.trim()) {
    errors.title = 'Le titre est requis'
  } else if (formData.value.title.length < 3) {
    errors.title = 'Le titre doit contenir au moins 3 caractères'
  }

  if (!formData.value.description?.trim()) {
    errors.description = 'La description est requise'
  } else if (formData.value.description.length < 10) {
    errors.description = 'La description doit contenir au moins 10 caractères'
  }

  if (!formData.value.budget) {
    errors.budget = 'Le budget est requis'
  } else if (Number(formData.value.budget) < 1000) {
    errors.budget = 'Le budget minimum est de 1000 FCFA'
  }

  if (!formData.value.deadline) {
    errors.deadline = 'La date limite est requise'
  } else {
    const selectedDate = new Date(formData.value.deadline)
    const today = new Date()
    if (selectedDate < today) {
      errors.deadline = 'La date limite doit être future'
    }
  }

  formErrors.value = errors
  return Object.keys(errors).length === 0
}

// Validation du formulaire
const isFormValid = computed(() => {
  return (
    formData.value.title?.length >= 3 &&
    formData.value.description?.length >= 10 &&
    Number(formData.value.budget) >= 1000 &&
    formData.value.deadline &&
    new Date(formData.value.deadline) > new Date()
  )
})

// Date minimum (aujourd'hui)
const minDate = new Date().toISOString().split('T')[0]

// Soumission du formulaire
const handleSubmit = async () => {
  if (!validateForm()) return

  isSubmitting.value = true
  formErrors.value = {}
  
  try {
    const { data, error } = await supabase
      .from('missions')
      .insert({
        title: formData.value.title.trim(),
        description: formData.value.description.trim(),
        budget: Number(formData.value.budget),
        deadline: formData.value.deadline,
        work_type: formData.value.workType,
        is_urgent: formData.value.isUrgent,
          status: 'open'
      })
      .select()
      .single()

    if (error) throw error

    showSuccessModal.value = true
  } catch (error) {
    console.error('Error:', error)
    
    if (error.code === '23505') { // Code pour violation d'unicité
      formErrors.value = {
        submit: 'Une mission similaire existe déjà'
      }
    } else if (error.code === '23503') { // Code pour violation de clé étrangère
      formErrors.value = {
        submit: 'Erreur de référence dans les données'
      }
    } else {
      formErrors.value = {
        submit: 'Une erreur est survenue lors de la publication'
      }
    }
  } finally {
    isSubmitting.value = false
  }
}

// Reset du formulaire
const resetForm = () => {
  formData.value = {
    title: '',
    description: '',
    budget: '',
    deadline: '',
    workType: 'remote',
    isUrgent: false
  }
  formErrors.value = {}
}
</script>