<template>
  <div class="min-h-screen bg-white flex flex-col">
    <!-- Barre de progression subtile -->
    <div class="fixed top-0 left-0 right-0 h-1 bg-gray-100">
      <div 
        class="h-full bg-blue-600 transition-all duration-500 ease-out"
        :style="{ width: `${(currentStep / totalSteps) * 100}%` }"
      ></div>
    </div>
      
    <div class="flex-1 flex flex-col items-center pt-16 p-6">
      <div class="w-full max-w-md">
        <!-- Étape -->
        <div class="mb-14 flex justify-end">
          <div class="text-gray-400 text-sm font-medium">
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
                <p class="text-sm text-gray-500">Cette description sera visible sur votre profil public</p>
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
                    <span class="text-gray-600 text-xl">€</span>
                  </div>
                  <input
                    v-model="form.hourlyRate"
                    type="number"
                    min="0"
                    step="1"
                    placeholder="50"
                    class="w-full p-4 pl-10 text-xl border-b-2 border-gray-200 focus:border-blue-500 focus:outline-none transition-colors"
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
                <div class="grid grid-cols-2 gap-3">
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
              </div>
            </div>

            <!-- Étape 6: Services -->
            <div v-if="currentStep === 6" class="space-y-12">
              <h1 class="text-3xl font-semibold text-gray-900">
                Quels services proposez-vous ?
              </h1>
              <div class="space-y-6">
                <div class="grid grid-cols-2 gap-3 max-h-72 overflow-y-auto">
                    <button
                    v-for="service in availableServices"
                    :key="service.id"
                      type="button"
                    @click="toggleService(service.id)"
                    :class="[
                      'p-3 text-left rounded-xl border-2 transition-all',
                      form.services.includes(service.id)
                        ? 'border-blue-500 bg-blue-50 text-blue-700'
                        : 'border-gray-200 hover:border-gray-300'
                    ]"
                  >
                    {{ service.name }}
                  </button>
                </div>
                <p class="text-sm text-gray-500">
                  {{ form.services.length }} service(s) sélectionné(s)
                </p>
              </div>
            </div>

            <!-- Étape 7: Conditions -->
            <div v-if="currentStep === 7" class="space-y-12">
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
import { ref, computed, onMounted } from 'vue'
import { Loader2 } from 'lucide-vue-next'
import type { Skill, Service } from '~/types'

const client = useSupabaseClient()
const router = useRouter()

const currentStep = ref(1)
const totalSteps = 7
const loading = ref(false)

interface ExpertForm {
  firstName: string
  lastName: string
  bio: string
  hourlyRate: string
  skills: string[]
  services: string[]
  acceptTerms: boolean
}

const form = ref<ExpertForm>({
  firstName: '',
  lastName: '',
  bio: '',
  hourlyRate: '',
  skills: [],
  services: [],
  acceptTerms: false
})

const availableSkills = ref<Skill[]>([])
const availableServices = ref<Service[]>([])

// Déterminer si l'utilisateur peut passer à l'étape suivante
const canProceed = computed(() => {
  switch (currentStep.value) {
    case 1: return !!form.value.firstName.trim()
    case 2: return !!form.value.lastName.trim()
    case 3: return !!form.value.bio.trim() && form.value.bio.length >= 10
    case 4: return !!form.value.hourlyRate && parseFloat(form.value.hourlyRate) > 0
    case 5: return form.value.skills.length > 0
    case 6: return form.value.services.length > 0
    case 7: return form.value.acceptTerms
    default: return true
  }
})

onMounted(async () => {
  try {
    const [skillsResponse, servicesResponse] = await Promise.all([
      client.from('skills').select('*'),
      client.from('services').select('*')
    ])

    availableSkills.value = skillsResponse.data || []
    availableServices.value = servicesResponse.data || []
  } catch (error) {
    console.error('Erreur chargement données:', error)
  }
})

const toggleSkill = (skillId: string) => {
  const index = form.value.skills.indexOf(skillId)
  if (index === -1) {
    form.value.skills.push(skillId)
  } else {
    form.value.skills.splice(index, 1)
  }
}

const toggleService = (serviceId: string) => {
  const index = form.value.services.indexOf(serviceId)
  if (index === -1) {
    form.value.services.push(serviceId)
  } else {
    form.value.services.splice(index, 1)
  }
}

const nextStep = () => {
  if (currentStep.value < totalSteps) {
    currentStep.value++
  }
}

const handleSubmit = async () => {
  try {
    loading.value = true
    const { data: { user }, error: userError } = await client.auth.getUser()
    
    if (userError) throw userError
    if (!user) throw new Error('Utilisateur non connecté')

    // 1. Mettre à jour le profil existant
    const { error: profileError } = await client
      .from('profiles')
      .update({
        first_name: form.value.firstName,
        last_name: form.value.lastName,
        bio: form.value.bio,
        is_expert: true,
        updated_at: new Date().toISOString()
      })
      .eq('id', user.id)

    if (profileError) throw profileError

    // 2. Créer l'entrée expert
    const { error: expertError } = await client
      .from('experts')
      .insert({
        id: user.id,
        bio: form.value.bio,
        hourly_rate: parseFloat(form.value.hourlyRate),
        availability_status: 'available',
        verification_status: 'pending',
        created_at: new Date().toISOString(),
        updated_at: new Date().toISOString()
      })

    if (expertError) throw expertError

    // 3. Associer les compétences
    if (form.value.skills.length > 0) {
      const skillsToInsert = form.value.skills.map(skillId => ({
        profile_id: user.id,
        skill_id: skillId,
        created_at: new Date().toISOString()
      }))

      const { error: skillsError } = await client
        .from('profile_skills')
        .insert(skillsToInsert)

      if (skillsError) throw skillsError
    }

    // 4. Associer les services
    if (form.value.services.length > 0) {
      const servicesToInsert = form.value.services.map(serviceId => ({
        expert_id: user.id,
        service_id: serviceId,
        price_per_hour: parseFloat(form.value.hourlyRate),
        created_at: new Date().toISOString()
      }))

      const { error: servicesError } = await client
        .from('expert_services')
        .insert(servicesToInsert)

      if (servicesError) throw servicesError
    }

    // Rediriger vers le tableau de bord expert
    router.push('/expert/dashboard')
  } catch (error) {
    console.error('Erreur création profil expert:', error)
    // Afficher une notification d'erreur
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