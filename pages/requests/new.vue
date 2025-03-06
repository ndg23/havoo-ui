<template>
  <div class="min-h-screen bg-white">
    <!-- Barre de progression Uber-style -->
    <div class="fixed top-0 left-0 right-0 z-50">
      <div class="h-1 bg-black transition-all duration-500 ease-out"
           :style="{ width: `${(currentStep / totalSteps) * 100}%` }">
      </div>
    </div>
    
    <div class="max-w-lg mx-auto px-5 pt-16 pb-8">
      <!-- En-tête minimaliste style Uber -->
      <div class="mb-6 flex items-center">
        <button 
          @click="goBack" 
          class="text-black p-1 -ml-1"
          aria-label="Retour"
        >
          <ChevronLeft class="h-6 w-6" />
        </button>
        <div class="text-xs font-medium text-gray-500 ml-auto">
          ÉTAPE {{ currentStep }}/{{ totalSteps }}
        </div>
      </div>
      
      <!-- Zone de contenu principal - une question à la fois comme Uber -->
      <div class="py-4">
        <transition 
          name="uber-fade" 
          mode="out-in"
        >
          <div :key="currentStep" class="space-y-6">
            <!-- Étape 1: Titre et catégorie de service - style Uber -->
            <div v-if="currentStep === 1">
              <h1 class="text-3xl font-bold text-black mb-10 tracking-tight">
                Que recherchez-vous ?
              </h1>
              
              <!-- Titre de la demande -->
              <div class="mb-10">
                <input
                  id="title"
                  v-model="form.title"
                  type="text"
                  placeholder="Titre de votre demande"
                  class="w-full py-4 px-0 text-xl border-b-2 border-gray-200 focus:border-black focus:outline-none transition-colors"
                />
                <p class="mt-2 text-sm text-gray-500">
                  Par exemple : "Besoin d'un plombier pour réparer un robinet"
                </p>
              </div>
              
              <!-- Catégories style Uber - grandes tuiles cliquables -->
              <div class="grid grid-cols-2 gap-4">
                <button
                  v-for="category in serviceCategories"
                  :key="category.id"
                  @click="selectCategory(category.id)"
                  class="aspect-square relative overflow-hidden group"
                >
                  <div 
                    :class="[
                      'absolute inset-0 rounded-xl flex flex-col items-center justify-center p-4 transition-all duration-200',
                      form.category_id === category.id 
                        ? 'bg-black text-white' 
                        : 'bg-gray-100 text-black group-hover:bg-gray-200'
                    ]"
                  >
                    <component 
                      :is="category.icon" 
                      class="h-8 w-8 mb-3"
                    />
                    <span class="font-medium text-center">{{ category.name }}</span>
                  </div>
                </button>
              </div>
            </div>
            
            <!-- Étape 2: Services spécifiques - style Uber -->
            <div v-else-if="currentStep === 2">
              <h1 class="text-3xl font-bold text-black mb-8 tracking-tight">
                Quel service précis vous faut-il ?
              </h1>
              
              <div v-if="filteredServices.length > 0" class="space-y-3">
                <div class="max-h-[60vh] overflow-y-auto pr-2 -mr-2 space-y-2">
                  <button
                    v-for="service in filteredServices"
                    :key="service.id"
                    @click="selectService(service.id)"
                    :class="[
                      'w-full p-5 text-left rounded-xl transition-all flex items-center',
                      form.service_id === service.id 
                        ? 'bg-black text-white'
                        : 'bg-gray-100 hover:bg-gray-200 text-black'
                    ]"
                  >
                    <span class="text-lg">{{ service.name }}</span>
                    <ChevronRight 
                      class="h-5 w-5 ml-auto" 
                      :class="form.service_id === service.id ? 'text-white' : 'text-gray-400'"
                    />
                  </button>
                </div>
              </div>
              
              <div v-else class="py-12 text-center">
                <div class="rounded-full bg-gray-100 h-16 w-16 flex items-center justify-center mx-auto mb-4">
                  <AlertCircle class="h-8 w-8 text-gray-500" />
                </div>
                <p class="text-gray-500 font-medium">Veuillez d'abord sélectionner une catégorie</p>
              </div>
            </div>
            
            <!-- Étape 3: Description et localisation - style Uber -->
            <div v-else-if="currentStep === 3">
              <h1 class="text-3xl font-bold text-black mb-8 tracking-tight">
                Précisez votre besoin
              </h1>
              
              <!-- Description -->
              <div class="mb-10">
                <label for="description" class="block text-sm font-semibold text-gray-700 mb-2">
                  Description de votre demande
                </label>
                <textarea
                  id="description"
                  v-model="form.description"
                  placeholder="Expliquez votre besoin avec le plus de détails possible..."
                  rows="4"
                  class="w-full p-4 text-lg border-2 border-gray-200 rounded-xl focus:border-black focus:outline-none transition-colors"
                ></textarea>
              </div>
              
              <!-- Localisation -->
              <div>
                <label for="location" class="block text-sm font-semibold text-gray-700 mb-2">
                  Adresse du service
                </label>
                <div class="relative">
                  <MapPin class="absolute left-4 top-4 text-gray-400 h-6 w-6" />
                  <input
                    id="location"
                    v-model="form.location"
                    type="text"
                    placeholder="Où le service sera-t-il réalisé ?"
                    class="w-full p-4 pl-12 text-lg border-2 border-gray-200 rounded-xl focus:border-black focus:outline-none transition-colors"
                  />
                </div>
              </div>
            </div>
            
            <!-- Étape 4: Date & heure - style Uber -->
            <div v-else-if="currentStep === 4">
              <h1 class="text-3xl font-bold text-black mb-8 tracking-tight">
                Quand en avez-vous besoin ?
              </h1>
              
              <!-- Date -->
              <div class="mb-8">
                <label for="date" class="block text-sm font-semibold text-gray-700 mb-2">
                  Date souhaitée
                </label>
                <input
                  id="date"
                  v-model="form.date"
                  type="date"
                  :min="new Date().toISOString().split('T')[0]"
                  class="w-full p-4 text-lg border-2 border-gray-200 rounded-xl focus:border-black focus:outline-none transition-colors"
                />
              </div>
              
              <!-- Période de la journée -->
              <div class="mb-8">
                <label class="block text-sm font-semibold text-gray-700 mb-2">
                  Période de la journée
                </label>
                <div class="grid grid-cols-3 gap-3">
                  <button
                    v-for="(period, index) in ['Matin', 'Après-midi', 'Soir']"
                    :key="index"
                    @click="selectTimePeriod(period)"
                    :class="[
                      'py-4 rounded-xl text-center transition-all',
                      form.time === getPeriodTime(period)
                        ? 'bg-black text-white'
                        : 'bg-gray-100 hover:bg-gray-200 text-black'
                    ]"
                  >
                    {{ period }}
                  </button>
                </div>
              </div>
              
              <!-- Durée estimée -->
              <div>
                <label class="block text-sm font-semibold text-gray-700 mb-2">
                  Durée estimée
                </label>
                <div class="grid grid-cols-3 gap-3">
                  <button
                    v-for="duration in [30, 60, 120]"
                    :key="duration"
                    type="button"
                    @click="form.duration = duration"
                    :class="[
                      'py-4 rounded-xl text-center transition-colors',
                      form.duration === duration
                        ? 'bg-black text-white'
                        : 'bg-gray-100 hover:bg-gray-200 text-black'
                    ]"
                  >
                    {{ duration >= 60 ? `${duration/60}h` : `${duration}min` }}
                  </button>
                </div>
              </div>
            </div>
            
            <!-- Étape 5: Budget - style Uber -->
            <div v-else-if="currentStep === 5">
              <h1 class="text-3xl font-bold text-black mb-12 tracking-tight">
                Quel est votre budget ?
              </h1>
              
              <!-- Options de budget style Uber -->
              <div class="space-y-4">
                <button
                  v-for="range in budgetRanges"
                  :key="range.label"
                  @click="selectBudgetRange(range.value)"
                  :class="[
                    'w-full py-5 px-6 rounded-xl text-left transition-all flex items-center text-lg',
                    form.budget === range.value
                      ? 'bg-black text-white'
                      : 'bg-gray-100 hover:bg-gray-200 text-black'
                  ]"
                >
                  {{ range.label }}
                  <Check 
                    v-if="form.budget === range.value"
                    class="h-5 w-5 ml-auto" 
                  />
                </button>
              </div>
              
              <!-- Option de saisie manuelle -->
              <div class="mt-8">
                <label for="custom-budget" class="block text-sm font-semibold text-gray-700 mb-2">
                  Ou précisez votre budget exact
                </label>
                <div class="relative">
                  <input
                    id="custom-budget"
                    v-model="form.budget"
                    type="number"
                    min="0"
                    step="5"
                    placeholder="Montant"
                    class="w-full p-4 text-lg border-2 border-gray-200 rounded-xl focus:border-black focus:outline-none transition-colors pl-12"
                  />
                  <div class="absolute inset-y-0 left-0 flex items-center pl-4 text-xl font-medium">
                    €
                  </div>
                </div>
              </div>
            </div>
            
            <!-- Étape 6: Résumé - style Uber -->
            <div v-else-if="currentStep === 6">
              <h1 class="text-3xl font-bold text-black mb-8 tracking-tight">
                Vérifiez et publiez
              </h1>
              
              <div class="space-y-6">
                <!-- Titre et service -->
                <div class="p-4 bg-gray-50 rounded-xl">
                  <div class="flex justify-between items-start">
                    <div>
                      <h3 class="font-bold text-lg text-black">{{ form.title || "Sans titre" }}</h3>
                      <p v-if="selectedService" class="text-gray-600">
                        {{ selectedService.name }}
                      </p>
                    </div>
                    <button @click="goToStep(1)" class="p-2 text-gray-500">
                      <Edit class="h-5 w-5" />
                    </button>
                  </div>
                </div>
                
                <!-- Description et lieu -->
                <div class="p-4 bg-gray-50 rounded-xl">
                  <div class="flex justify-between items-start">
                    <div class="flex-1">
                      <h3 class="font-bold text-black mb-2">Détails</h3>
                      <p class="text-gray-600 mb-3 line-clamp-3">{{ form.description }}</p>
                      <div class="flex items-center text-gray-600">
                        <MapPin class="h-4 w-4 mr-1" />
                        <span>{{ form.location }}</span>
                      </div>
                    </div>
                    <button @click="goToStep(3)" class="p-2 text-gray-500">
                      <Edit class="h-5 w-5" />
                    </button>
                  </div>
                </div>
                
                <!-- Planification -->
                <div class="p-4 bg-gray-50 rounded-xl">
                  <div class="flex justify-between items-start">
                    <div>
                      <h3 class="font-bold text-black mb-2">Planification</h3>
                      <div class="flex items-center">
                        <Calendar class="h-4 w-4 mr-2 text-gray-500" />
                        <span class="text-gray-600">
                          {{ form.date ? formatDate(form.date) : "Non spécifié" }}
                        </span>
                      </div>
                      <div class="flex items-center mt-1">
                        <Clock class="h-4 w-4 mr-2 text-gray-500" />
                        <span class="text-gray-600">
                          {{ getFormattedPeriod(form.time) }} · {{ form.duration }} min
                        </span>
                      </div>
                    </div>
                    <button @click="goToStep(4)" class="p-2 text-gray-500">
                      <Edit class="h-5 w-5" />
                    </button>
                  </div>
                </div>
                
                <!-- Budget -->
                <div class="p-4 bg-gray-50 rounded-xl">
                  <div class="flex justify-between items-center">
                    <div>
                      <h3 class="font-bold text-black mb-1">Budget</h3>
                      <span class="text-2xl font-bold">{{ form.budget }}€</span>
                    </div>
                    <button @click="goToStep(5)" class="p-2 text-gray-500">
                      <Edit class="h-5 w-5" />
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </transition>
          
        <!-- Navigation buttons style Uber - bouton unique et impactant -->
        <div class="mt-12">
          <button
            v-if="currentStep < totalSteps"
            @click="nextStep"
            :disabled="!canProceed"
            class="w-full py-4 bg-black text-white font-medium text-lg rounded-xl
              disabled:bg-gray-300 disabled:text-gray-500
              transition-all duration-200 transform hover:scale-[0.98] active:scale-[0.96]"
          >
            Continuer
          </button>
          
          <button
            v-else
            @click="submitRequest"
            :disabled="loading"
            class="w-full py-4 bg-black text-white font-medium text-lg rounded-xl
              disabled:bg-gray-300 disabled:text-gray-500
              transition-all duration-200 transform hover:scale-[0.98] active:scale-[0.96]
              flex items-center justify-center"
          >
            <Loader2 v-if="loading" class="animate-spin mr-2 h-5 w-5" />
            {{ loading ? 'Publication en cours...' : 'Publier ma demande' }}
          </button>
          
          <button
            v-if="currentStep > 1"
            @click="goBack"
            class="w-full text-black font-medium mt-3 py-3"
          >
            Retour
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { ChevronLeft, ChevronRight, Loader2, MapPin, Calendar, Clock, 
         Check, Edit, AlertCircle } from 'lucide-vue-next'
import { useRouter } from 'vue-router'
import { useSupabaseClient } from '#imports'

const router = useRouter()
const client = useSupabaseClient()

// État du formulaire et étapes
const currentStep = ref(1)
const totalSteps = 6
const loading = ref(false)

// Catégories et services
const serviceCategories = ref([])
const services = ref([])
const filteredServices = computed(() => 
  services.value.filter(s => s.category_id === form.value.category_id)
)

// Données du formulaire
const form = ref({
  title: '',
  category_id: '',
  service_id: '',
  description: '',
  location: '',
  date: null,
  time: '',
  duration: 60,
  budget: '',
})

// Fourchettes de budget prédéfinies
const budgetRanges = [
  { label: 'Moins de 50€', value: 50 },
  { label: 'Entre 50€ et 200€', value: 125 },
  { label: 'Plus de 200€', value: 250 },
]

// Formater la date
const formatDate = (date) => {
  if (!date) return null
  const d = new Date(date)
  return d.toLocaleDateString('fr-FR', { 
    year: 'numeric', 
    month: 'long', 
    day: 'numeric' 
  })
}

// Sélection de la période de temps
const selectTimePeriod = (period) => {
  form.value.time = getPeriodTime(period)
}

const getPeriodTime = (period) => {
  switch(period) {
    case 'Matin': return '09:00'
    case 'Après-midi': return '14:00'
    case 'Soir': return '18:00'
    default: return ''
  }
}

const getFormattedPeriod = (time) => {
  if (!time) return 'Non spécifié'
  
  if (time === '09:00') return 'Matin'
  if (time === '14:00') return 'Après-midi'
  if (time === '18:00') return 'Soir'
  
  return time
}

// Vérifier si l'utilisateur peut passer à l'étape suivante
const canProceed = computed(() => {
  switch (currentStep.value) {
    case 1: return !!form.value.title?.trim() && !!form.value.category_id
    case 2: return !!form.value.service_id
    case 3: return !!form.value.description?.trim() && !!form.value.location?.trim()
    case 4: return !!form.value.date && !!form.value.time && !!form.value.duration
    case 5: return !!form.value.budget && form.value.budget > 0
    default: return true
  }
})

// Sélection de catégorie
const selectCategory = (categoryId) => {
  form.value.category_id = categoryId
  form.value.service_id = ''
}

// Sélection de service
const selectService = (serviceId) => {
  form.value.service_id = serviceId
}

// Sélection de budget
const selectBudgetRange = (value) => {
  form.value.budget = value
}

// Données sélectionnées
const selectedCategory = computed(() => 
  serviceCategories.value.find(c => c.id === form.value.category_id)
)

const selectedService = computed(() => 
  services.value.find(s => s.id === form.value.service_id)
)

// Navigation
const nextStep = () => {
  if (currentStep.value < totalSteps) {
    currentStep.value++
    window.scrollTo(0, 0)
  }
}

const goToStep = (step) => {
  currentStep.value = step
  window.scrollTo(0, 0)
}

const goBack = () => {
  if (currentStep.value > 1) {
    currentStep.value--
    window.scrollTo(0, 0)
  } else {
    router.push('/requests')
  }
}

// Soumission du formulaire
const submitRequest = async () => {
  try {
    loading.value = true
    
    const { data: { user }, error: userError } = await client.auth.getUser()
    if (userError) throw userError
    if (!user) throw new Error('Utilisateur non connecté')
    
    const { error: requestError } = await client
      .from('requests')
      .insert({
        client_id: user.id,
        service_id: form.value.service_id,
        title: form.value.title,
        description: form.value.description,
        location: form.value.location,
        date: form.value.date,
        time: form.value.time,
        duration: form.value.duration,
        budget: parseFloat(form.value.budget),
        status: 'active',
        created_at: new Date().toISOString(),
        updated_at: new Date().toISOString()
      })
    
    if (requestError) throw requestError
    
    router.push({ 
      path: '/requests', 
      query: { success: 'request_created' } 
    })
  } catch (error) {
    console.error('Erreur:', error)
  } finally {
    loading.value = false
  }
}

// Chargement des données
onMounted(async () => {
  try {
    // Chargement des catégories
    const { data: categoriesData, error: categoriesError } = await client
      .from('service_categories')
      .select('id, name, icon')
    
    if (categoriesError) throw categoriesError
    
    // Icônes correspondant aux catégories
    const iconMap = {
      'Ménage': 'Home',
      'Jardinage': 'Leaf',
      'Bricolage': 'Tool',
      'Garde d\'enfants': 'Baby',
      'Cours particuliers': 'BookOpen',
      'Informatique': 'Laptop'
    }
    
    // Associer les icônes Lucide aux catégories
    serviceCategories.value = categoriesData.map(cat => ({
      ...cat,
      icon: iconMap[cat.name] || 'Package'
    }))
    
    // Chargement des services
    const { data: servicesData, error: servicesError } = await client
      .from('services')
      .select('id, category_id, name')
    
    if (servicesError) throw servicesError
    services.value = servicesData || []
  } catch (error) {
    console.error('Erreur chargement données:', error)
  }
})

definePageMeta({
  layout: 'default',
  auth: true
})
</script>

<style scoped>
.uber-fade-enter-active,
.uber-fade-leave-active {
  transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
}
.uber-fade-enter-from {
  opacity: 0;
  transform: translateY(8px);
}
.uber-fade-leave-to {
  opacity: 0;
  transform: translateY(-8px);
}
</style>