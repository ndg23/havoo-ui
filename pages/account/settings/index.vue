<template>
  <div class="max-w-xl mx-auto px-4 py-8">
    <!-- Header -->
    <div class="mb-8">
      <h1 class="text-2xl font-bold text-gray-900 dark:text-white">Paramètres</h1>
      <p class="mt-2 text-base text-gray-600 dark:text-gray-400">
        Gérez vos informations personnelles
      </p>
    </div>

    <!-- Profile Section -->
    <div class="mb-6">
      <div class="flex items-start space-x-4 mb-8">
        <img 
          :src="form.avatar_url || '/default-avatar.png'" 
          class="h-20 w-20 rounded-full object-cover ring-2 ring-gray-100 dark:ring-gray-800"
          alt="Photo de profil"
        />
        <div class="mt-2">
          <button class="text-primary-600 dark:text-primary-400 text-sm font-medium hover:underline">
            Modifier la photo
          </button>
          <p class="mt-1 text-xs text-gray-500">
            JPG ou PNG. 1MB max.
          </p>
        </div>
      </div>

      <!-- Basic Info -->
      <div class="space-y-6">
        <FloatingLabelInput
          v-model="form.first_name"
          label="Prénom"
          class="bg-transparent border-b border-gray-200 dark:border-gray-700 focus-within:border-primary-600 rounded-none px-0"
        />
        <FloatingLabelInput
          v-model="form.last_name"
          label="Nom"
          class="bg-transparent border-b border-gray-200 dark:border-gray-700 focus-within:border-primary-600 rounded-none px-0"
        />
        <FloatingLabelInput
          v-model="form.email"
          label="Email"
          type="email"
          disabled
          class="bg-transparent border-b border-gray-200 dark:border-gray-700 rounded-none px-0"
        />
        <FloatingLabelInput
          v-model="form.phone"
          label="Téléphone"
          type="tel"
          class="bg-transparent border-b border-gray-200 dark:border-gray-700 focus-within:border-primary-600 rounded-none px-0"
        />
      </div>
    </div>

    <!-- Professional Info -->
    <div class="my-8 pt-8 border-t border-gray-100 dark:border-gray-800">
      <h2 class="text-xl font-semibold mb-6 text-gray-900 dark:text-white">
        Informations professionnelles
      </h2>

      <div class="space-y-6">
        <FloatingLabelInput
          v-model="form.profession_id"
          label="Profession"
          :isSelect="true"
          class="bg-transparent border-b border-gray-200 dark:border-gray-700 focus-within:border-primary-600 rounded-none px-0"
        >
          <option value="">Sélectionnez votre profession</option>
          <option 
            v-for="profession in professions" 
            :key="profession.id" 
            :value="profession.id"
          >
            {{ profession.name }}
          </option>
        </FloatingLabelInput>

        <div class="space-y-2">
          <label class="text-sm text-gray-700 dark:text-gray-300">Bio</label>
          <TwitterInput
            v-model="form.bio"
            placeholder="Décrivez votre activité..."
            :maxLength="280"
            showCount
            type="textarea"
            :rows="3"
            class="w-full bg-transparent border border-gray-200 dark:border-gray-700 focus:border-primary-600 rounded-2xl p-4"
          />
        </div>

        <FloatingLabelInput
          v-model="form.hourly_rate"
          label="Tarif horaire"
          type="number"
          min="0"
          class="bg-transparent border-b border-gray-200 dark:border-gray-700 focus-within:border-primary-600 rounded-none px-0"
        >
          <template #suffix>€/h</template>
        </FloatingLabelInput>

        <div class="flex items-center justify-between py-4">
          <div>
            <p class="text-sm font-medium text-gray-900 dark:text-white">Disponibilité</p>
            <p class="text-sm text-gray-500">Disponible pour des missions</p>
          </div>
          <button 
            type="button"
            role="switch"
            :aria-checked="form.availability_status === 'available'"
            @click="toggleAvailability"
            class="relative inline-flex h-7 w-12 rounded-full transition-colors duration-200 ease-in-out focus:outline-none"
            :class="[form.availability_status === 'available' ? 'bg-primary-600' : 'bg-gray-200 dark:bg-gray-700']"
          >
            <span 
              class="pointer-events-none relative inline-block h-6 w-6 transform rounded-full bg-white shadow-sm ring-1 ring-gray-200 transition duration-200 ease-in-out translate-y-0.5"
              :class="[form.availability_status === 'available' ? 'translate-x-5' : 'translate-x-0.5']"
            />
          </button>
        </div>
      </div>
    </div>

    <!-- Location -->
    <div class="my-8 pt-8 border-t border-gray-100 dark:border-gray-800">
      <h2 class="text-xl font-semibold mb-6 text-gray-900 dark:text-white">
        Localisation
      </h2>

      <div class="space-y-6">
        <FloatingLabelInput
          v-model="form.city"
          label="Ville"
          class="bg-transparent border-b border-gray-200 dark:border-gray-700 focus-within:border-primary-600 rounded-none px-0"
        />
        <FloatingLabelInput
          v-model="form.country"
          label="Pays"
          :isSelect="true"
          class="bg-transparent border-b border-gray-200 dark:border-gray-700 focus-within:border-primary-600 rounded-none px-0"
        >
          <option value="">Sélectionnez votre pays</option>
          <option value="FR">France</option>
          <option value="BE">Belgique</option>
          <option value="CH">Suisse</option>
          <option value="CA">Canada</option>
        </FloatingLabelInput>
      </div>
    </div>

    <!-- Action Buttons -->
    <div class="flex justify-end gap-4 mt-12">
      <button
        type="button"
        @click="resetForm"
        class="px-6 py-2.5 text-sm font-medium text-gray-700 hover:bg-gray-50 dark:text-gray-300 dark:hover:bg-gray-800 rounded-full transition-colors"
      >
        Annuler
      </button>
      
      <button
        @click="saveSettings"
        class="px-6 py-2.5 text-sm font-medium text-white bg-gray-900 hover:bg-gray-800 dark:bg-primary-600 dark:hover:bg-primary-700 rounded-full transition-colors disabled:opacity-50"
        :disabled="isSaving"
      >
        {{ isSaving ? 'Enregistrement...' : 'Enregistrer' }}
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useSupabaseClient, useSupabaseUser } from '#imports'
import { OhVueIcon as VIcon, addIcons } from 'oh-vue-icons'
import FloatingLabelInput from '~/components/ui/FloatingLabelInput.vue'
const supabase = useSupabaseClient()
const user = useSupabaseUser()

const form = ref({
  first_name: '',
  last_name: '',
  email: '',
  phone: '',
  birthdate: '',
  profession_id: '',
  hourly_rate: null,
  website: '',
  bio: '',
  city: '',
  zip_code: '',
  country: '',
  availability_status: 'available'
})

const professions = ref([])
const availableSkills = ref([])
const selectedSkills = ref([])
const isSaving = ref(false)

// Charger les données initiales
onMounted(async () => {
  if (user.value) {
    await Promise.all([
      fetchProfile(),
      fetchProfessions(),
      fetchSkills()
    ])
  }
})

// Charger le profil
const fetchProfile = async () => {
  const { data: profile } = await supabase
    .from('profiles')
    .select('*')
    .eq('id', user.value.id)
    .single()

  if (profile) {
    Object.assign(form.value, profile)
    selectedSkills.value = profile.user_skills.map(us => us.skill_id)
  }
}

// Charger les professions
const fetchProfessions = async () => {
  const { data } = await supabase
    .from('professions')
    .select('*')
    .eq('is_active', true)
    .order('name')

  professions.value = data || []
}

// Charger les compétences
const fetchSkills = async () => {
  const { data } = await supabase
    .from('skills')
    .select('*')
    .eq('is_active', true)
    .order('name')

  availableSkills.value = data || []
}

// Toggle skill selection
const toggleSkill = (skillId) => {
  const index = selectedSkills.value.indexOf(skillId)
  if (index === -1) {
    selectedSkills.value.push(skillId)
  } else {
    selectedSkills.value.splice(index, 1)
  }
}

// Sauvegarder les modifications
const saveSettings = async () => {
  isSaving.value = true

  try {
    // Mettre à jour le profil
    const { error: profileError } = await supabase
      .from('profiles')
      .update(form.value)
      .eq('id', user.value.id)

    if (profileError) throw profileError

    // Mettre à jour les compétences
    await supabase
      .from('user_skills')
      .delete()
      .eq('user_id', user.value.id)

    if (selectedSkills.value.length > 0) {
      const skillsToInsert = selectedSkills.value.map(skillId => ({
        user_id: user.value.id,
        skill_id: skillId
      }))

      await supabase
        .from('user_skills')
        .insert(skillsToInsert)
    }

    // Afficher un message de succès
    alert('Paramètres enregistrés avec succès')
  } catch (error) {
    console.error('Error saving settings:', error)
    alert('Une erreur est survenue lors de l\'enregistrement')
  } finally {
    isSaving.value = false
  }
}

// Réinitialiser le formulaire
const resetForm = () => {
  fetchProfile()
}

const toggleAvailability = () => {
  form.value.availability_status = form.value.availability_status === 'available' ? 'unavailable' : 'available'
}
</script>

<style scoped>
/* Animations douces */
.transition-all {
  transition-property: all;
  transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
  transition-duration: 200ms;
}
</style> 