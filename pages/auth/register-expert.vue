<template>
  <div class="min-h-screen bg-white flex flex-col">
    <!-- Barre de progression subtile -->
    <div class="fixed top-0 left-0 right-0 h-1 bg-gray-100">
      <div 
        class="h-full bg-blue-600 transition-all duration-500 ease-out"
        :style="{ width: `${(currentStep / totalSteps) * 100}%` }"
      ></div>
    </div>
      
    <!-- Notification pour les erreurs/succès -->
    <div 
      v-if="notification.show"
      :class="[
        'fixed top-4 right-4 p-4 rounded-lg shadow-lg max-w-xs z-50 transition-all duration-300 transform',
        notification.type === 'error' ? 'bg-red-500 text-white' : 'bg-green-500 text-white'
      ]"
    >
      <div class="flex items-start">
        <div class="flex-shrink-0">
          <CheckCircle v-if="notification.type === 'success'" class="h-5 w-5" />
          <AlertCircle v-else class="h-5 w-5" />
        </div>
        <div class="ml-3">
          <p class="text-sm font-medium">{{ notification.message }}</p>
        </div>
        <button @click="notification.show = false" class="ml-4">
          <X class="h-4 w-4" />
        </button>
      </div>
    </div>
      
    <div class="flex-1 flex flex-col items-center pt-16 p-6">
      <div class="w-full max-w-md">
        <!-- Étape -->
        <div class="mb-14 flex justify-between">
          <button 
            v-if="currentStep > 1" 
            @click="currentStep--" 
            class="text-gray-500 text-sm flex items-center hover:text-gray-700"
          >
            <ChevronLeft class="h-4 w-4 mr-1" />
            Retour
          </button>
          <div class="ml-auto text-gray-400 text-sm font-medium">
            Étape {{ currentStep }} sur {{ totalSteps }}
          </div>
        </div>

        <!-- Titre et contenu de l'étape actuelle -->
        <transition 
          name="slide-fade" 
          mode="out-in"
        >
          <div :key="currentStep">
            <!-- Étape 1: Prénom -->
            <div v-if="currentStep === 1" class="space-y-12">
              <h1 class="text-3xl font-semibold text-gray-900">
                Comment vous appelez-vous ?
              </h1>
              <div class="space-y-6">
                <input
                  v-model="form.firstName"
                  type="text"
                  placeholder="Votre prénom"
                  class="w-full p-4 text-xl border-b-2 border-gray-200 focus:border-blue-500 focus:outline-none transition-colors"
                  autofocus
                />
              </div>
            </div>
            
            <!-- Étape 2: Nom -->
            <div v-if="currentStep === 2" class="space-y-12">
              <h1 class="text-3xl font-semibold text-gray-900">
                Et votre nom de famille ?
              </h1>
              <div class="space-y-6">
                <input
                  v-model="form.lastName"
                  type="text"
                  placeholder="Votre nom"
                  class="w-full p-4 text-xl border-b-2 border-gray-200 focus:border-blue-500 focus:outline-none transition-colors"
                  autofocus
                />
              </div>
            </div>

            <!-- Étape 3: Bio professionnelle -->
            <div v-if="currentStep === 3" class="space-y-12">
              <h1 class="text-3xl font-semibold text-gray-900">
                Parlez-nous de votre expertise
              </h1>
              <div class="space-y-2">
                <textarea 
                  v-model="form.bio"
                  rows="5"
                  placeholder="Décrivez votre parcours et vos compétences..."
                  class="w-full p-4 text-lg border-2 border-gray-200 rounded-xl focus:border-blue-500 focus:outline-none transition-colors"
                  autofocus
                ></textarea>
                <p class="text-sm text-gray-500">
                  Cette description sera visible sur votre profil public 
                  <span :class="bioLength < 10 ? 'text-red-500' : 'text-green-500'">
                    ({{ bioLength }}/10 caractères minimum)
                  </span>
                </p>
              </div>
            </div>

            <!-- Étape 4: Tarif horaire -->
            <div v-if="currentStep === 4" class="space-y-12">
              <h1 class="text-3xl font-semibold text-gray-900">
                Quel est votre tarif horaire ?
              </h1>
              <div class="space-y-6">
                <div class="relative">
                  <div class="absolute inset-y-0 left-0 flex items-center pl-4">
                    <span class="text-gray-600 text-xl">FCFA</span>
                  </div>
                  <input
                    v-model="form.hourlyRate"
                    type="number"
                    min="0"
                    step="1"
                    placeholder="50"
                    class="w-full p-4 pl-16 text-xl border-b-2 border-gray-200 focus:border-blue-500 focus:outline-none transition-colors"
                    autofocus
                  />
                </div>
                <p class="text-sm text-gray-500">Vous pourrez personnaliser vos tarifs par service ultérieurement</p>
              </div>
            </div>
              
            <!-- Étape 5: Compétences -->
            <div v-if="currentStep === 5" class="space-y-12">
              <h1 class="text-3xl font-semibold text-gray-900">
                Sélectionnez vos compétences
              </h1>
              <div class="space-y-6">
                <div v-if="loadingData" class="flex justify-center py-10">
                  <Loader2 class="animate-spin h-8 w-8 text-blue-500" />
                </div>
                <div v-else-if="availableSkills.length === 0" class="text-center py-6">
                  <p class="text-gray-500">Aucune compétence disponible pour le moment</p>
                </div>
                <div v-else class="grid grid-cols-2 gap-3 max-h-72 overflow-y-auto p-1">
                  <button
                    v-for="skill in availableSkills"
                    :key="skill.id"
                    type="button"
                    @click="toggleSkill(skill.id)"
                    :class="[
                      'p-3 text-left rounded-xl border-2 transition-all',
                      form.skills.includes(skill.id)
                        ? 'border-blue-500 bg-blue-50 text-blue-700'
                        : 'border-gray-200 hover:border-gray-300'
                    ]"
                  >
                    {{ skill.name }}
                  </button>
                </div>
                <p class="text-sm text-gray-500">
                  {{ form.skills.length }} compétence(s) sélectionnée(s)
                </p>
                <div v-if="form.skills.length === 0" class="text-sm text-red-500">
                  Veuillez sélectionner au moins une compétence
                </div>
              </div>
            </div>

            <!-- Étape 6: Catégories de services -->
            <div v-if="currentStep === 6" class="space-y-12">
              <h1 class="text-3xl font-semibold text-gray-900">
                Quels services proposez-vous ?
              </h1>
              <div class="space-y-6">
                <div v-if="loadingData" class="flex justify-center py-10">
                  <Loader2 class="animate-spin h-8 w-8 text-blue-500" />
                </div>
                <div v-else-if="availableCategories.length === 0" class="text-center py-6">
                  <p class="text-gray-500">Aucune catégorie disponible pour le moment</p>
                </div>
                <div v-else class="grid grid-cols-2 gap-3 max-h-72 overflow-y-auto p-1">
                  <button
                    v-for="category in availableCategories"
                    :key="category.id"
                    type="button"
                    @click="toggleCategory(category.id)"
                    :class="[
                      'p-3 text-left rounded-xl border-2 transition-all',
                      selectedCategories.includes(category.id)
                        ? 'border-blue-500 bg-blue-50 text-blue-700'
                        : 'border-gray-200 hover:border-gray-300'
                    ]"
                  >
                    {{ category.name }}
                  </button>
                </div>
                <p class="text-sm text-gray-500">
                  {{ selectedCategories.length }} catégorie(s) sélectionnée(s)
                </p>
              </div>
            </div>

            <!-- Étape 7: Configuration des services -->
            <div v-if="currentStep === 7" class="space-y-12">
              <h1 class="text-3xl font-semibold text-gray-900">
                Configurez vos services
              </h1>
              <div class="space-y-6">
                <div v-if="selectedCategories.length === 0" class="text-center py-6">
                  <p class="text-gray-500">Aucune catégorie sélectionnée</p>
                </div>
                <div v-else>
                  <div v-for="(categoryId, index) in selectedCategories" :key="categoryId" class="mb-8 pb-8 border-b last:border-b-0">
                    <h2 class="text-lg font-medium mb-4">
                      {{ getCategoryName(categoryId) }}
                    </h2>
                    <div class="space-y-4">
                      <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">
                          Titre du service
                        </label>
                        <input
                          v-model="servicesConfig[categoryId].title"
                          type="text"
                          placeholder="Ex: Consultation en design d'intérieur"
                          class="w-full p-3 border border-gray-300 rounded-lg focus:ring-blue-500 focus:border-blue-500"
                        />
                      </div>
                      <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">
                          Description du service
                        </label>
                        <textarea
                          v-model="servicesConfig[categoryId].description"
                          rows="3"
                          placeholder="Décrivez ce que vous proposez..."
                          class="w-full p-3 border border-gray-300 rounded-lg focus:ring-blue-500 focus:border-blue-500"
                        ></textarea>
                      </div>
                      <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">
                          Tarif pour ce service (FCFA)
                        </label>
                        <input
                          v-model="servicesConfig[categoryId].price"
                          type="number"
                          min="0"
                          :placeholder="form.hourlyRate"
                          class="w-full p-3 border border-gray-300 rounded-lg focus:ring-blue-500 focus:border-blue-500"
                        />
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Étape 8: Conditions -->
            <div v-if="currentStep === 8" class="space-y-12">
              <h1 class="text-3xl font-semibold text-gray-900">
                Dernière étape
              </h1>
              <div class="space-y-6">
                <div class="flex items-start gap-3">
                  <input
                    v-model="form.acceptTerms"
                    id="terms"
                    type="checkbox"
                    class="mt-1 h-5 w-5 rounded text-blue-600 focus:ring-blue-500"
                  />
                  <label for="terms" class="text-gray-700">
                    J'accepte les <a href="#" class="text-blue-600 hover:underline">conditions d'utilisation</a> 
                    et je certifie que les informations fournies sont exactes.
                  </label>
                </div>
                <div class="flex items-start gap-3">
                  <input
                    v-model="form.acceptEmailNotifications"
                    id="emailNotif"
                    type="checkbox"
                    class="mt-1 h-5 w-5 rounded text-blue-600 focus:ring-blue-500"
                  />
                  <label for="emailNotif" class="text-gray-700">
                    J'accepte de recevoir des notifications par email concernant mes demandes de service
                    (recommandé).
                  </label>
                </div>
              </div>
            </div>
          </div>
        </transition>

        <!-- Boutons de navigation -->
        <div class="mt-14 space-y-4">
          <button
            v-if="currentStep < totalSteps"
            @click="nextStep"
            :disabled="!canProceed"
            class="w-full py-4 bg-blue-600 text-white font-medium rounded-full
              hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed
              transition-colors shadow-md"
          >
            Continuer
          </button>
              
          <button
            v-else
            @click="handleSubmit"
            :disabled="loading || !form.acceptTerms"
            class="w-full py-4 bg-blue-600 text-white font-medium rounded-full
              hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed
              transition-colors shadow-md flex items-center justify-center"
          >
            <Loader2 v-if="loading" class="animate-spin -ml-1 mr-2 h-5 w-5" />
            {{ loading ? 'Création en cours...' : 'Créer mon profil expert' }}
          </button>
              
          <button
            v-if="currentStep > 1"
            @click="currentStep--"
            type="button"
            class="w-full py-3 text-gray-600 font-medium hover:text-gray-900 transition-colors"
          >
            Retour
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch, reactive } from 'vue'
import { Loader2, ChevronLeft, CheckCircle, AlertCircle, X } from 'lucide-vue-next'
import { useSupabaseClient, useSupabaseUser } from '#imports'
// import { useUserStore } from '~/stores/user'

interface Skill {
  id: string
  name: string
}

interface Category {
  id: string
  name: string
  description?: string
}

interface ServiceConfig {
  title: string
  description: string
  price: string
}

interface ExpertForm {
  firstName: string
  lastName: string
  bio: string
  hourlyRate: string
  skills: string[]
  acceptTerms: boolean
  acceptEmailNotifications: boolean
  isExpert: boolean
}

interface Notification {
  show: boolean
  type: 'success' | 'error'
  message: string
}

const client = useSupabaseClient()
const router = useRouter()
const user = useSupabaseUser()

const currentStep = ref(1)
const totalSteps = 8
const loading = ref(false)
const loadingData = ref(false)
const selectedCategories = ref<string[]>([])
const servicesConfig = reactive<Record<string, ServiceConfig>>({})

const notification = reactive<Notification>({
  show: false,
  type: 'success',
  message: ''
})

// Récupération des données du formulaire des localStorage si disponibles
// const savedForm = localStorage.getItem('expertRegistrationForm')
const initialForm = {
  firstName: '',
  lastName: '',
  bio: '',
  hourlyRate: '',
  skills: [],
  acceptTerms: false,
  acceptEmailNotifications: true,
  isExpert: true
}

const form = ref<ExpertForm>(initialForm)

const availableSkills = ref<Skill[]>([])
const availableCategories = ref<Category[]>([])

// Longueur de la bio pour la validation
const bioLength = computed(() => form.value.bio.trim().length)

// Sauvegarder le formulaire lorsqu'il est modifié
watch(form, (newForm) => {
  // localStorage.setItem('expertRegistrationForm', JSON.stringify(newForm))
}, { deep: true })

// Déterminer si l'utilisateur peut passer à l'étape suivante
const canProceed = computed(() => {
  switch (currentStep.value) {
    case 1: return !!form.value.firstName.trim()
    case 2: return !!form.value.lastName.trim()
    case 3: return !!form.value.bio.trim() && form.value.bio.length >= 10
    case 4: return !!form.value.hourlyRate && parseFloat(form.value.hourlyRate) > 0
    case 5: return form.value.skills.length > 0
    case 6: return true // On peut continuer même sans catégorie sélectionnée
    case 7: return validateServicesConfig()
    case 8: return form.value.acceptTerms
    default: return true
  }
})

// Valider que tous les services configurés ont des informations valides
function validateServicesConfig(): boolean {
  if (selectedCategories.value.length === 0) return true
  
  return selectedCategories.value.every(categoryId => {
    const config = servicesConfig[categoryId]
    return config && 
           config.title.trim() !== '' && 
           config.description.trim() !== '' &&
           (!!config.price && parseFloat(config.price) > 0)
  })
}

onMounted(async () => {
  await loadInitialData()
  
  // Pré-remplir le formulaire avec les données utilisateur si disponibles
  if (user.value) {
    try {
      const { data, error } = await client
        .from('profiles')
        .select('first_name, last_name, bio, hourly_rate')
        .eq('id', user.value.id)
        .single()
      
      if (data && !error) {
        if (!form.value.firstName && data.first_name) form.value.firstName = data.first_name
        if (!form.value.lastName && data.last_name) form.value.lastName = data.last_name
        if (!form.value.bio && data.bio) form.value.bio = data.bio
        if (!form.value.hourlyRate && data.hourly_rate) form.value.hourlyRate = data.hourly_rate.toString()
      }
    } catch (err) {
      console.error('Erreur lors du chargement des données utilisateur', err)
    }
  }
})

async function loadInitialData() {
  loadingData.value = true
  try {
    const [skillsResponse, categoriesResponse] = await Promise.all([
      client.from('skills').select('id, name, category_id'),
      client.from('categories').select('id, name, description').eq('is_active', true)
    ])

    if (skillsResponse.error) throw skillsResponse.error
    if (categoriesResponse.error) throw categoriesResponse.error

    availableSkills.value = skillsResponse.data || []
    availableCategories.value = categoriesResponse.data || []
    
    // Initialiser la configuration des services pour chaque catégorie
    availableCategories.value.forEach(category => {
      if (!servicesConfig[category.id]) {
        servicesConfig[category.id] = {
          title: `Service ${category.name}`,
          description: '',
          price: form.value.hourlyRate || ''
        }
      }
    })
  } catch (error) {
    console.error('Erreur chargement données:', error)
    showNotification('Erreur lors du chargement des données. Veuillez réessayer.', 'error')
  } finally {
    loadingData.value = false
  }
}

function toggleSkill(skillId: string) {
  const index = form.value.skills.indexOf(skillId)
  if (index === -1) {
    form.value.skills.push(skillId)
  } else {
    form.value.skills.splice(index, 1)
  }
}

function toggleCategory(categoryId: string) {
  const index = selectedCategories.value.indexOf(categoryId)
  if (index === -1) {
    selectedCategories.value.push(categoryId)
    
    // Initialiser la configuration de service pour cette catégorie
    if (!servicesConfig[categoryId]) {
      servicesConfig[categoryId] = {
        title: `Service ${getCategoryName(categoryId)}`,
        description: '',
        price: form.value.hourlyRate || ''
      }
    }
  } else {
    selectedCategories.value.splice(index, 1)
  }
}

function getCategoryName(categoryId: string): string {
  const category = availableCategories.value.find(c => c.id === categoryId)
  return category ? category.name : 'Service'
}

function nextStep() {
  if (currentStep.value < totalSteps && canProceed.value) {
    currentStep.value++
    window.scrollTo(0, 0)
  }
}

function showNotification(message: string, type: 'success' | 'error' = 'success') {
  notification.message = message
  notification.type = type
  notification.show = true
  
  // Masquer la notification après 5 secondes
  setTimeout(() => {
    notification.show = false
  }, 5000)
}

async function handleSubmit() {
  if (!form.value.acceptTerms) return
  
  try {
    loading.value = true
    
    if (!user.value) {
      throw new Error('Utilisateur non connecté')
    }
    
    // 1. Mettre à jour le profil utilisateur
    const { error: updateError } = await client
      .from('profiles')
      .update({
        first_name: form.value.firstName,
        last_name: form.value.lastName,
        bio: form.value.bio,
        is_expert: true,
        hourly_rate: parseFloat(form.value.hourlyRate),
        updated_at: new Date().toISOString()
      })
      .eq('id', user.value.id)

    if (updateError) throw updateError

    // 2. Associer les compétences à l'utilisateur (d'abord supprimer les anciennes)
    const { error: deleteSkillsError } = await client
      .from('user_skills')
      .delete()
      .eq('user_id', user.value.id)
    
    if (deleteSkillsError) throw deleteSkillsError
    
    if (form.value.skills.length > 0) {
      const skillsToInsert = form.value.skills.map(skillId => ({
        user_id: user?.value?.id,
        skill_id: skillId
      }))

      const { error: skillsError } = await client
        .from('user_skills')
        .insert(skillsToInsert)

      if (skillsError) throw skillsError
    }

    // 3. Créer les services pour l'expert
    if (selectedCategories.value.length > 0) {
      const servicesToInsert = selectedCategories.value.map(categoryId => ({
        expert_id: user?.value?.id,
        category_id: categoryId,
        title: servicesConfig[categoryId].title,
        description: servicesConfig[categoryId].description,
        price: parseFloat(servicesConfig[categoryId].price || form.value.hourlyRate),
        delivery_time: 7, // Valeur par défaut, à personnaliser plus tard
        is_active: true,
        location_type: 'remote'
      }))

      const { error: servicesError } = await client
        .from('services')
        .insert(servicesToInsert)

      if (servicesError) throw servicesError
    }
    
    // 4. Créer une demande de vérification
    const { error: verificationError } = await client
      .from('verifications')
      .insert({
        user_id: user.value.id,
        status: 'pending',
        documents: {} // Sera rempli ultérieurement
      })
      
    if (verificationError) throw verificationError

    // 5. Succès - Nettoyer le stockage local et rediriger
    // localStorage.removeItem('expertRegistrationForm')
    showNotification('Votre profil expert a été créé avec succès!', 'success')
    
    // Rediriger après un court délai pour que l'utilisateur puisse voir la notification
    setTimeout(() => {
      router.push('/dashboard')
    }, 2000)
  } catch (error) {
    console.error('Erreur création profil expert:', error)
    showNotification('Une erreur est survenue lors de la création de votre profil. Veuillez réessayer.', 'error')
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.slide-fade-enter-active,
.slide-fade-leave-active {
  transition: all 0.3s ease;
}
.slide-fade-enter-from {
  transform: translateX(20px);
  opacity: 0;
}
.slide-fade-leave-to {
  transform: translateX(-20px);
  opacity: 0;
}
</style>