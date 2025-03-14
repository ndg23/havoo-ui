<template>
  <div>
    <h2 class="text-lg font-medium text-gray-900 dark:text-white mb-6">
      Paramètres du profil expert
    </h2>
    
    <form @submit.prevent="saveExpertProfile">
      <!-- Profession et tarif -->
      <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
        <div>
          <label for="profession" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
            Profession / Spécialité
          </label>
          <input
            id="profession"
            v-model="form.profession"
            type="text"
            class="block w-full rounded-lg border-gray-300 dark:border-gray-700 shadow-sm dark:bg-gray-800 dark:text-white"
          />
        </div>
        
        <div>
          <label for="hourlyRate" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
            Tarif horaire (FCFA)
          </label>
          <input
            id="hourlyRate"
            v-model="form.hourlyRate"
            type="number"
            min="0"
            class="block w-full rounded-lg border-gray-300 dark:border-gray-700 shadow-sm dark:bg-gray-800 dark:text-white"
          />
        </div>
      </div>
      
      <!-- Bio / Description -->
      <div class="mb-6">
        <label for="bio" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
          Bio / Description
        </label>
        <textarea
          id="bio"
          v-model="form.bio"
          rows="4"
          class="block w-full rounded-lg border-gray-300 dark:border-gray-700 shadow-sm dark:bg-gray-800 dark:text-white"
          placeholder="Décrivez votre expérience et vos services..."
        ></textarea>
      </div>
      
      <!-- Expérience -->
      <div class="mb-6">
        <label for="experience" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
          Années d'expérience
        </label>
        <input
          id="experience"
          v-model="form.experience"
          type="number"
          min="0"
          class="block w-full rounded-lg border-gray-300 dark:border-gray-700 shadow-sm dark:bg-gray-800 dark:text-white"
        />
      </div>
      
      <!-- Disponibilité -->
      <div class="mb-6">
        <div class="flex items-center">
          <input
            id="isAvailable"
            v-model="form.isAvailable"
            type="checkbox"
            class="h-4 w-4 text-primary-600 focus:ring-primary-500 border-gray-300 rounded"
          />
          <label for="isAvailable" class="ml-2 block text-sm text-gray-700 dark:text-gray-300">
            Je suis disponible pour accepter de nouvelles missions
          </label>
        </div>
      </div>
      
      <!-- Catégories -->
      <div class="mb-6">
        <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
          Catégories de services
        </label>
        <div class="grid grid-cols-2 sm:grid-cols-3 gap-3">
          <label 
            v-for="category in categories" 
            :key="category.id"
            class="flex items-start p-3 border border-gray-300 dark:border-gray-600 rounded-lg cursor-pointer hover:bg-gray-50 dark:hover:bg-gray-800"
          >
            <input 
              type="checkbox" 
              :value="category.id" 
              v-model="form.categories"
              class="h-4 w-4 text-primary-600 focus:ring-primary-500 border-gray-300 rounded mt-0.5"
            />
            <span class="ml-2 text-sm text-gray-700 dark:text-gray-300">
              {{ category.name }}
            </span>
          </label>
        </div>
      </div>
      
      <!-- Compétences -->
      <div class="mb-6">
        <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
          Compétences
        </label>
        <div class="flex flex-wrap gap-2">
          <div 
            v-for="skill in selectedSkills" 
            :key="skill.id" 
            class="bg-primary-100 text-primary-800 dark:bg-primary-900 dark:text-primary-200 px-3 py-1 rounded-full text-sm flex items-center"
          >
            <span>{{ skill.name }}</span>
            <button 
              type="button" 
              @click="removeSkill(skill.id)" 
              class="ml-1.5 text-primary-600 hover:text-primary-800"
            >
              <XCircle class="w-4 h-4" />
            </button>
          </div>
          
          <div class="relative">
            <input
              v-model="skillInput"
              @keydown.enter.prevent="addSkill"
              type="text"
              placeholder="Ajouter une compétence..."
              class="px-3 py-1 border border-gray-300 dark:border-gray-600 rounded-full text-sm"
            />
            <button 
              type="button" 
              @click="addSkill" 
              class="absolute right-1 top-1/2 transform -translate-y-1/2 p-1 text-gray-500 hover:text-gray-700"
            >
              <PlusCircle class="w-4 h-4" />
            </button>
          </div>
        </div>
      </div>
      
      <!-- Boutons -->
      <div class="flex justify-end space-x-3">
        <button
          type="button"
          @click="resetExpertForm"
          class="px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700"
        >
          Annuler
        </button>
        <button
          type="submit"
          class="px-4 py-2 bg-primary-600 text-white rounded-lg hover:bg-primary-700 flex items-center"
          :disabled="isSubmitting"
        >
          <span v-if="isSubmitting">
            <span class="inline-block animate-spin rounded-full h-4 w-4 border-b-2 border-white mr-2"></span>
            Enregistrement...
          </span>
          <span v-else>Enregistrer</span>
        </button>
      </div>
    </form>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { XCircle, PlusCircle } from 'lucide-vue-next'
import { useProfile } from '~/composables/useProfile'

const props = defineProps({
  profile: {
    type: Object,
    required: true
  }
})

const emit = defineEmits(['update'])

const { updateExpertProfile } = useProfile()
const isSubmitting = ref(false)

// Données simulées pour les catégories (à remplacer par votre propre source de données)
const categories = ref([
  { id: 1, name: 'Ménage' },
  { id: 2, name: 'Jardinage' },
  { id: 3, name: 'Bricolage' },
  { id: 4, name: 'Garde d\'enfants' },
  { id: 5, name: 'Cours particuliers' },
  { id: 6, name: 'Déménagement' }
])

// Formulaire
const form = ref({
  profession: '',
  hourlyRate: 0,
  bio: '',
  experience: 0,
  isAvailable: true,
  categories: [],
  skills: []
})

// Gestion des compétences
const skillInput = ref('')
const selectedSkills = ref([])

const addSkill = () => {
  if (skillInput.value.trim()) {
    const newSkill = {
      id: Date.now(), // ID temporaire
      name: skillInput.value.trim()
    }
    selectedSkills.value.push(newSkill)
    form.value.skills.push(newSkill.id)
    skillInput.value = ''
  }
}

const removeSkill = (skillId) => {
  selectedSkills.value = selectedSkills.value.filter(skill => skill.id !== skillId)
  form.value.skills = form.value.skills.filter(id => id !== skillId)
}

// Initialiser le formulaire
onMounted(() => {
  if (props.profile && props.profile.expertDetails) {
    const details = props.profile.expertDetails
    
    form.value = {
      profession: details.profession || '',
      hourlyRate: details.hourlyRate || 0,
      bio: details.bio || '',
      experience: details.experience || 0,
      isAvailable: details.isAvailable !== undefined ? details.isAvailable : true,
      categories: details.categories?.map(cat => cat.id) || [],
      skills: []
    }
    
    // Initialiser les compétences sélectionnées
    selectedSkills.value = details.skills || []
    form.value.skills = selectedSkills.value.map(skill => skill.id)
  }
})

// Réinitialiser le formulaire
const resetExpertForm = () => {
  if (props.profile && props.profile.expertDetails) {
    const details = props.profile.expertDetails
    
    form.value = {
      profession: details.profession || '',
      hourlyRate: details.hourlyRate || 0,
      bio: details.bio || '',
      experience: details.experience || 0,
      isAvailable: details.isAvailable !== undefined ? details.isAvailable : true,
      categories: details.categories?.map(cat => cat.id) || [],
      skills: []
    }
    
    // Réinitialiser les compétences sélectionnées
    selectedSkills.value = details.skills || []
    form.value.skills = selectedSkills.value.map(skill => skill.id)
  }
}

// Enregistrer les modifications
const saveExpertProfile = async () => {
  isSubmitting.value = true
  
  try {
    await updateExpertProfile({
      profession: form.value.profession,
      hourlyRate: form.value.hourlyRate,
      bio: form.value.bio,
      experience: form.value.experience,
      isAvailable: form.value.isAvailable,
      categories: form.value.categories,
      skills: form.value.skills
    })
    
    // Émettre l'événement pour rafraîchir les données du profil
    emit('update')
  } catch (error) {
    console.error('Erreur lors de la mise à jour du profil expert:', error)
  } finally {
    isSubmitting.value = false
  }
}
</script> 