<template>
  <div class="max-w-2xl mx-auto px-4 py-6">
    <!-- En-tête -->
    <div class="mb-8">
      <h1 class="text-2xl font-semibold text-gray-900 dark:text-white">Paramètres</h1>
      <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">Gérez vos informations personnelles et préférences</p>
    </div>

    <!-- Formulaire principal -->
    <div class="space-y-6">
      <!-- Photo de profil -->
      <div class="flex items-center gap-4">
        <img 
          :src="form.avatar_url || '/default-avatar.png'" 
          class="h-20 w-20 rounded-full object-cover border border-gray-200 dark:border-gray-700"
          alt="Photo de profil"
        />
        <button class="text-sm text-primary-600 dark:text-primary-400 hover:underline">
          Modifier la photo
        </button>
      </div>

      <!-- Informations de base -->
      <div class="bg-white dark:bg-gray-800 rounded-xl divide-y divide-gray-200 dark:divide-gray-700">
        <div class="p-4 space-y-4">
          <h2 class="font-medium text-gray-900 dark:text-white">Informations personnelles</h2>
          
          <div class="grid gap-4">
            <FloatingLabelInput
              v-model="form.first_name"
              label="Prénom"
              placeholder="Votre prénom"
            />

            <FloatingLabelInput
              v-model="form.last_name"
              label="Nom"
              placeholder="Votre nom"
            />

            <FloatingLabelInput
              v-model="form.email"
              label="Email"
              type="email"
              placeholder="vous@exemple.com"
              disabled
            />

            <FloatingLabelInput
              v-model="form.phone"
              label="Téléphone"
              type="tel"
              placeholder="+33 6 XX XX XX XX"
            />
          </div>
        </div>

        <div class="p-4 space-y-4">
          <h2 class="font-medium text-gray-900 dark:text-white">Profession</h2>
          
          <div class="grid gap-4">
            <!-- Sélection de la profession -->
            <FloatingLabelInput
              v-model="form.profession_id"
              label="Votre métier"
              :isSelect="true"
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

            <!-- Bio -->
            <div class="space-y-2">
              <TwitterInput
                v-model="form.bio"
                placeholder="Décrivez votre activité en quelques mots"
                :maxLength="280"
                showCount
                type="textarea"
                :rows="4"
              />
            </div>

            <!-- Tarif horaire -->
            <FloatingLabelInput
              v-model="form.hourly_rate"
              label="Tarif horaire"
              type="number"
              min="0"
              step="5"
            >
              <template #suffix>
                <span class="text-gray-500">€/h</span>
              </template>
            </FloatingLabelInput>
          </div>
        </div>

        <div class="p-4 space-y-4">
          <h2 class="font-medium text-gray-900 dark:text-white">Localisation</h2>
          
          <div class="grid gap-4">
            <FloatingLabelInput
              v-model="form.city"
              label="Ville"
              placeholder="Votre ville"
            />

            <FloatingLabelInput
              v-model="form.country"
              label="Pays"
              :isSelect="true"
            >
              <option value="">Sélectionnez votre pays</option>
              <option value="FR">France</option>
              <option value="BE">Belgique</option>
              <option value="CH">Suisse</option>
              <option value="CA">Canada</option>
            </FloatingLabelInput>
          </div>
        </div>

        <!-- Disponibilité -->
        <div class="p-4">
          <div class="flex items-center justify-between">
            <div>
              <h2 class="font-medium text-gray-900 dark:text-white">Disponibilité</h2>
              <p class="text-sm text-gray-500 dark:text-gray-400">Indiquez si vous êtes disponible pour des missions</p>
            </div>
            
            <button 
              type="button"
              role="switch"
              :aria-checked="form.availability_status === 'available'"
              @click="toggleAvailability"
              class="relative inline-flex h-6 w-11 flex-shrink-0 cursor-pointer rounded-full border-2 border-transparent transition-colors duration-200 ease-in-out focus:outline-none focus:ring-2 focus:ring-primary-600 focus:ring-offset-2"
              :class="[
                form.availability_status === 'available' 
                  ? 'bg-primary-600' 
                  : 'bg-gray-200 dark:bg-gray-700'
              ]"
            >
              <span 
                class="pointer-events-none relative inline-block h-5 w-5 transform rounded-full bg-white shadow ring-0 transition duration-200 ease-in-out"
                :class="[
                  form.availability_status === 'available' 
                    ? 'translate-x-5' 
                    : 'translate-x-0'
                ]"
              />
            </button>
          </div>
        </div>
      </div>

      <!-- Boutons d'action -->
      <div class="flex justify-end gap-3">
        <button
          type="button"
          @click="resetForm"
          class="px-4 py-2 text-sm font-medium text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-800 rounded-lg transition-colors"
        >
          Annuler
        </button>
        
        <button
          @click="saveSettings"
          class="px-4 py-2 text-sm font-medium text-white bg-primary-600 hover:bg-primary-700 rounded-lg transition-colors disabled:opacity-50"
          :disabled="isSaving"
        >
          {{ isSaving ? 'Enregistrement...' : 'Enregistrer' }}
        </button>
      </div>
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