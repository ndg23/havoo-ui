<template>
  <NuxtLayout 
    name="creation"
    :current-step="currentStep"
    :total-steps="steps.length"
  >
    <div class="max-w-xl mx-auto px-4 pb-24">
      <TransitionGroup 
        name="slide-fade"
        mode="out-in"
        tag="div"
      >
        <div :key="currentStep" class="space-y-8">
          <!-- Impactful header with Twitter-inspired styling -->
          <div class="space-y-3">
            <span class="inline-flex items-center px-3 py-1.5 rounded-full text-xs font-bold bg-blue-50 text-blue-500 dark:bg-blue-900/30 dark:text-blue-400">
              Étape {{ currentStep }}/{{ steps.length }}
            </span>
            <h1 class="text-3xl font-extrabold text-gray-900 dark:text-white">
              {{ steps[currentStep - 1].question }}
            </h1>
            <p class="text-base text-gray-600 dark:text-gray-400">
              {{ steps[currentStep - 1].description }}
            </p>
          </div>

          <!-- Dynamic fields with Twitter-inspired styling -->
          <div class="space-y-5">
            <!-- Input texte -->
            <template v-if="steps[currentStep - 1].type === 'text'">
              <input
                v-model="missionData[steps[currentStep - 1].key]"
                type="text"
                :placeholder="steps[currentStep - 1].placeholder"
                class="w-full px-4 py-4 text-lg rounded-2xl 
                       border border-gray-200 dark:border-gray-700
                       bg-white dark:bg-gray-800 
                       focus:ring-2 focus:ring-blue-500 focus:border-blue-500
                       placeholder:text-gray-500 dark:placeholder:text-gray-500
                       text-gray-900 dark:text-white"
              />
            </template>

            <!-- Description -->
            <template v-if="steps[currentStep - 1].type === 'textarea'">
              <textarea
                v-model="missionData[steps[currentStep - 1].key]"
                :placeholder="steps[currentStep - 1].placeholder"
                rows="5"
                class="w-full px-5 py-3.5 text-lg 
           rounded-xl
           border border-gray-200/40 dark:border-gray-700/40
           bg-white dark:bg-gray-800
           focus:outline-none
           focus:border-gray-300 dark:focus:border-gray-600
           focus:ring-0
           placeholder:text-gray-400/80 dark:placeholder:text-gray-500/80
           text-gray-900 dark:text-white
           shadow-sm
           resize-none
           transition-all duration-200 ease-in-out"
  />
              
              <div class="flex justify-between items-center text-sm">
                <span class="text-gray-500">{{ missionData[steps[currentStep - 1].key]?.length || 0 }}/500</span>
                <button 
                  @click="showTips = !showTips"
                  class="text-blue-500 font-medium hover:text-blue-600"
                >
                  {{ showTips ? 'Masquer les conseils' : 'Voir les conseils' }}
                </button>
              </div>

              <!-- Tips in Twitter card style -->
              <div v-if="showTips" class="mt-4 space-y-3 rounded-2xl bg-gray-50 dark:bg-gray-900 p-4 border border-gray-200 dark:border-gray-800">
                <h3 class="font-bold text-gray-900 dark:text-white">Conseils de rédaction</h3>
                <div 
                  v-for="(tip, index) in descriptionTips" 
                  :key="index"
                  class="flex items-start gap-2.5"
                >
                  <UIcon name="i-heroicons-light-bulb" class="h-5 w-5 text-blue-500 flex-shrink-0 mt-0.5" />
                  <p class="text-sm text-gray-700 dark:text-gray-300">{{ tip }}</p>
                </div>
              </div>
            </template>

            <!-- Catégories avec design Twitter -->
            <template v-if="steps[currentStep - 1].type === 'categories'">
              <div class="space-y-4">
                <!-- Barre de recherche avec icône intégrée -->
                <div class="relative">
                  <input
                    v-model="search"
                    type="text"
                    placeholder="Rechercher une expertise..."
                    class="w-full pl-12 pr-5 py-3.5 text-lg 
           rounded-xl
           border border-gray-200/40 dark:border-gray-700/40
           bg-white dark:bg-gray-800
           focus:outline-none
           focus:border-gray-300 dark:focus:border-gray-600
           focus:ring-0
           placeholder:text-gray-400/80 dark:placeholder:text-gray-500/80
           text-gray-900 dark:text-white
           shadow-sm
           transition-all duration-200 ease-in-out"
  />
                  <UIcon 
                    name="i-heroicons-magnifying-glass" 
                    class="absolute left-4 top-1/2 -translate-y-1/2 h-5 w-5 text-gray-500"
                  />
                </div>

                <!-- Liste des professions au style Twitter -->
                <div 
                  ref="professionsContainer"
                  class="overflow-y-auto max-h-[400px] space-y-2.5 pr-2 
                         scrollbar-thin scrollbar-thumb-gray-300 dark:scrollbar-thumb-gray-700
                         scrollbar-track-transparent"
                  @scroll="handleScroll"
                >
                  <button
                    v-for="profession in displayedProfessions"
                    :key="profession.id"
                    @click="selectItem(profession)"
                    class="w-full flex items-center gap-3 p-4 text-left
                           rounded-2xl border transition-all duration-150"
                    :class="[
                      selectedCategory?.id === profession.id 
                        ? 'border-blue-500 bg-blue-50 dark:bg-blue-900/20' 
                        : 'border-transparent bg-gray-100 dark:bg-gray-800 hover:bg-gray-200 dark:hover:bg-gray-700'
                    ]"
                  >
                    <div class="flex items-center justify-center w-10 h-10 rounded-full bg-blue-100 dark:bg-blue-900/30">
                      <UIcon 
                        :name="getProfessionIcon(profession.name)"
                        class="h-5 w-5 text-blue-500 flex-shrink-0"
                      />
                    </div>
                    <div class="min-w-0 flex-1">
                      <div class="font-bold text-gray-900 dark:text-white">
                        {{ profession.name }}
                      </div>
                      <div class="text-sm text-gray-600 dark:text-gray-400 truncate">
                        {{ profession.description }}
                      </div>
                    </div>
                    <UIcon 
                      v-if="selectedCategory?.id === profession.id"
                      name="i-heroicons-check-circle-solid" 
                      class="h-6 w-6 text-blue-500 flex-shrink-0"
                    />
                  </button>

                  <!-- Loading state -->
                  <div 
                    v-if="isLoadingMore" 
                    class="py-4 text-center"
                  >
                    <div class="inline-flex items-center gap-2">
                      <UIcon 
                        name="i-heroicons-arrow-path" 
                        class="h-5 w-5 animate-spin text-blue-500"
                      />
                      <span class="text-sm font-medium text-gray-700 dark:text-gray-300">
                        Chargement...
                      </span>
                    </div>
                  </div>
                </div>

                <!-- Empty state -->
                <div 
                  v-if="displayedProfessions.length === 0" 
                  class="py-12 text-center rounded-2xl bg-gray-100 dark:bg-gray-800"
                >
                  <UIcon 
                    name="i-heroicons-magnifying-glass" 
                    class="mx-auto h-12 w-12 text-gray-400"
                  />
                  <p class="mt-3 font-medium text-gray-700 dark:text-gray-300">
                    Aucune expertise trouvée
                  </p>
                </div>
              </div>
            </template>

            <!-- Budget avec design Twitter -->
            <template v-if="steps[currentStep - 1].type === 'budget'">
              <div class="space-y-6">
                <!-- Options de budget prédéfinies -->
                <div class="grid grid-cols-2 gap-3">
                  <button
                    v-for="amount in quickAmounts"
                    :key="amount"
                    @click="selectBudget(amount)"
                    class="relative group overflow-hidden p-6 rounded-2xl text-left
                           border-2 transition-all duration-150"
                    :class="[
                      missionData.budget === amount 
                        ? 'border-blue-500 bg-blue-50 dark:bg-blue-900/20' 
                        : 'border-transparent bg-gray-100 dark:bg-gray-800 hover:bg-gray-200 dark:hover:bg-gray-700'
                    ]"
                  >
                    <!-- Amount -->
                    <div class="text-2xl font-bold text-gray-900 dark:text-white">
                      {{ formatPrice(amount) }}
                    </div>
                    
                    <!-- Description -->
                    <div class="mt-2 text-sm text-gray-600 dark:text-gray-400">
                      {{ getBudgetDescription(amount) }}
                    </div>

                    <!-- Selection indicator -->
                    <div 
                      v-if="missionData.budget === amount"
                      class="absolute top-3 right-3"
                    >
                      <UIcon 
                        name="i-heroicons-check-circle-solid" 
                        class="h-6 w-6 text-blue-500"
                      />
                    </div>
                  </button>
                </div>

                <!-- Separator -->
                <div class="relative">
                  <div class="absolute inset-0 flex items-center">
                    <div class="w-full border-t border-gray-200 dark:border-gray-800"></div>
                  </div>
                  <div class="relative flex justify-center">
                    <span class="px-4 text-sm font-medium text-gray-500 bg-white dark:bg-black">ou</span>
                  </div>
                </div>

                <!-- Custom budget -->
                <div class="space-y-3">
                  <label class="block text-sm font-medium text-gray-700 dark:text-gray-300">
                    Budget personnalisé
                  </label>
                  <div class="relative">
                    <input
                      v-model.number="missionData.budget"
                      type="number"
                      min="1000"
                      step="1000"
                      placeholder="Ex: 15000"
                      class="w-full pl-4 pr-16 py-4 text-xl rounded-2xl
                             border border-gray-200 dark:border-gray-700
                             bg-white dark:bg-gray-800
                             focus:ring-2 focus:ring-blue-500 focus:border-blue-500
                             placeholder:text-gray-500 dark:placeholder:text-gray-500
                             text-gray-900 dark:text-white"
                    />
                    <div class="absolute right-4 top-1/2 -translate-y-1/2 font-medium text-gray-500">
                      XOF
                    </div>
                  </div>
                </div>
              </div>
            </template>

            <!-- Date avec design Twitter -->
            <template v-if="steps[currentStep - 1].type === 'deadline'">
              <div class="space-y-6">
                <!-- Options rapides -->
                <div class="grid grid-cols-2 gap-3">
                  <button
                    v-for="option in quickDateOptions"
                    :key="option.days"
                    @click="selectQuickDate(option.days)"
                    class="relative group p-6 rounded-2xl text-left
                           border-2 transition-all duration-150"
                    :class="[
                      missionData.deadline === getDateFromDays(option.days)
                        ? 'border-blue-500 bg-blue-50 dark:bg-blue-900/20'
                        : 'border-transparent bg-gray-100 dark:bg-gray-800 hover:bg-gray-200 dark:hover:bg-gray-700'
                    ]"
                  >
                    <!-- Label -->
                    <div class="text-xl font-bold text-gray-900 dark:text-white">
                      {{ option.label }}
                    </div>
                    
                    <!-- Formatted date -->
                    <div class="mt-2 text-sm text-gray-600 dark:text-gray-400">
                      {{ getFormattedDate(option.days) }}
                    </div>

                    <!-- Indicator -->
                    <div 
                      v-if="missionData.deadline === getDateFromDays(option.days)"
                      class="absolute top-3 right-3"
                    >
                      <UIcon 
                        name="i-heroicons-check-circle-solid" 
                        class="h-6 w-6 text-blue-500"
                      />
                    </div>
                  </button>
                </div>

                <!-- Separator -->
                <div class="relative">
                  <div class="absolute inset-0 flex items-center">
                    <div class="w-full border-t border-gray-200 dark:border-gray-800"></div>
                  </div>
                  <div class="relative flex justify-center">
                    <span class="px-4 text-sm font-medium text-gray-500 bg-white dark:bg-black">ou</span>
                  </div>
                </div>

                <!-- Custom date -->
                <div class="space-y-3">
                  <label class="block text-sm font-medium text-gray-700 dark:text-gray-300">
                    Date personnalisée
                  </label>
                  <div class="relative">
                    <input
                      v-model="missionData.deadline"
                      type="date"
                      :min="new Date().toISOString().split('T')[0]"
                      class="w-full pl-4 pr-12 py-4 text-xl rounded-2xl
                             border border-gray-200 dark:border-gray-700
                             bg-white dark:bg-gray-800
                             focus:ring-2 focus:ring-blue-500 focus:border-blue-500
                             text-gray-900 dark:text-white"
                    />
                    <UIcon 
                      name="i-heroicons-calendar" 
                      class="absolute right-4 top-1/2 -translate-y-1/2 h-6 w-6 text-gray-500"
                    />
                  </div>
                </div>

                <!-- Information box -->
                <div class="flex items-start gap-3 p-4 rounded-2xl bg-blue-50 dark:bg-blue-900/20">
                  <UIcon 
                    name="i-heroicons-information-circle" 
                    class="h-5 w-5 text-blue-500 flex-shrink-0 mt-0.5"
                  />
                  <p class="text-sm text-blue-700 dark:text-blue-300">
                    Choisissez une date qui vous laisse suffisamment de temps pour échanger avec les talents et affiner votre projet.
                  </p>
                </div>
              </div>
            </template>
          </div>

          <!-- Twitter-style navigation buttons -->
          <div class="space-y-3 pt-4">
            <button
              @click="nextStep"
              :disabled="!isCurrentStepValid"
              class="w-full px-4 py-3.5 rounded-full text-base font-bold
                     bg-blue-500 text-white
                     disabled:opacity-50 disabled:cursor-not-allowed
                     hover:bg-blue-600 transition-colors active:scale-98"
            >
              {{ isLastStep ? 'Publier la mission' : 'Continuer' }}
            </button>

            <button
              v-if="currentStep > 1"
              @click="previousStep"
              class="w-full px-4 py-3.5 rounded-full text-base font-bold
                     bg-transparent text-gray-700 dark:text-gray-300
                     hover:bg-gray-100 dark:hover:bg-gray-800
                     transition-colors"
            >
              Retour
            </button>
          </div>
        </div>
      </TransitionGroup>
    </div>

    <!-- Success modal with Twitter style -->
    <Teleport to="body">
      <TransitionRoot appear :show="showSuccessModal" as="template">
        <Dialog as="div" @close="closeSuccessModal" class="relative z-50">
          <TransitionChild
            enter="duration-300 ease-out"
            enter-from="opacity-0"
            enter-to="opacity-100"
            leave="duration-200 ease-in"
            leave-from="opacity-100"
            leave-to="opacity-0"
          >
            <div class="fixed inset-0 bg-black/50 backdrop-blur-sm" />
          </TransitionChild>

          <div class="fixed inset-0 overflow-y-auto">
            <div class="flex min-h-full items-center justify-center p-4 text-center">
              <TransitionChild
                enter="duration-300 ease-out"
                enter-from="opacity-0 scale-95"
                enter-to="opacity-100 scale-100"
                leave="duration-200 ease-in"
                leave-from="opacity-100 scale-100"
                leave-to="opacity-0 scale-95"
              >
                <DialogPanel class="w-full max-w-md transform overflow-hidden rounded-3xl bg-white dark:bg-gray-900 p-8 text-left align-middle shadow-xl transition-all">
                  <div class="text-center">
                    <div class="mx-auto flex h-16 w-16 items-center justify-center rounded-full bg-green-100 dark:bg-green-900/50">
                      <UIcon name="i-heroicons-check" class="h-8 w-8 text-green-600 dark:text-green-300" />
                    </div>
                    <DialogTitle as="h3" class="mt-5 text-2xl font-bold text-gray-900 dark:text-white">
                      Mission publiée !
                    </DialogTitle>
                    <div class="mt-3">
                      <p class="text-gray-600 dark:text-gray-400">
                        Votre mission a été publiée avec succès. Vous recevrez bientôt des propositions de talents.
                      </p>
                    </div>
                    <div class="mt-7">
                      <button
                        @click="closeSuccessModal"
                        class="inline-flex justify-center rounded-full bg-blue-500 hover:bg-blue-600 px-8 py-3 text-base font-bold text-white transition-colors active:scale-95"
                      >
                        Voir mes missions
                      </button>
                    </div>
                  </div>
                </DialogPanel>
              </TransitionChild>
            </div>
          </div>
        </Dialog>
      </TransitionRoot>

      <!-- Global loader with Twitter style -->
      <TransitionRoot :show="isLoading" as="template">
        <div class="fixed inset-0 z-50 flex items-center justify-center bg-white/80 dark:bg-black/80 backdrop-blur-sm">
          <div class="text-center">
            <div class="inline-flex items-center gap-3 px-6 py-3.5 bg-blue-500 rounded-full">
              <UIcon name="i-heroicons-arrow-path" class="h-5 w-5 animate-spin text-white" />
              <span class="text-base font-bold text-white">Publication en cours...</span>
            </div>
          </div>
        </div>
      </TransitionRoot>
    </Teleport>

    <!-- For accessibility -->
    <div id="step-announcement" class="sr-only" aria-live="polite"></div>
  </NuxtLayout>
</template>

<style scoped>
.slide-fade-enter-active {
  transition: all 0.4s cubic-bezier(0.23, 1, 0.32, 1);
  position: relative;
}

.slide-fade-leave-active {
  transition: all 0.4s cubic-bezier(0.23, 1, 0.32, 1);
  position: absolute;
  width: 100%;
}

.slide-fade-enter-from {
  opacity: 0;
  transform: translateX(30px);
}

.slide-fade-leave-to {
  opacity: 0;
  transform: translateX(-30px);
}

.max-w-xl {
  position: relative;
}

@keyframes subtle-bounce {
  0% { transform: translateX(30px); }
  70% { transform: translateX(-5px); }
  100% { transform: translateX(0); }
}

.slide-fade-enter-active {
  animation: subtle-bounce 0.4s cubic-bezier(0.23, 1, 0.32, 1);
}

input[type="date"]::-webkit-calendar-picker-indicator {
  @apply opacity-0 absolute inset-0 w-full h-full cursor-pointer;
}

/* Custom scrollbar styles */
.scrollbar-thin {
  scrollbar-width: thin;
}

.scrollbar-thin::-webkit-scrollbar {
  width: 4px;
}

.scrollbar-thin::-webkit-scrollbar-track {
  background: transparent;
}

.scrollbar-thin::-webkit-scrollbar-thumb {
  background-color: rgba(156, 163, 175, 0.5);
  border-radius: 4px;
}

/* Spinner animation */
@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}

.animate-spin {
  animation: spin 1s linear infinite;
}

.active\:scale-95:active {
  transform: scale(0.95);
}

.active\:scale-98:active {
  transform: scale(0.98);
}

/* Subtle focus effect */
input:focus, textarea:focus {
  box-shadow: 0 0 0 1px rgba(0,0,0,0.05),
              0 2px 4px rgba(0,0,0,0.02),
              0 4px 8px rgba(0,0,0,0.02);
}

/* Dark mode focus effect */
.dark input:focus, .dark textarea:focus {
  box-shadow: 0 0 0 1px rgba(255,255,255,0.05),
              0 2px 4px rgba(0,0,0,0.1),
              0 4px 8px rgba(0,0,0,0.1);
}

/* Remove default focus outline for Safari */
input:focus, textarea:focus {
  outline: none;
}

/* Remove default appearance for Safari */
input, textarea {
  -webkit-appearance: none;
  appearance: none;
}
</style>


<script setup>
import { ref, computed, onMounted, onBeforeUnmount, watch } from 'vue';
import { useRouter } from 'vue-router';
import { Dialog, DialogPanel, DialogTitle, TransitionRoot, TransitionChild } from '@headlessui/vue';
import { onClickOutside } from '@vueuse/core';
import { useThrottle } from '@vueuse/core';
// import { useSupabaseClient } from '#import';

const router = useRouter();
const supabase = useSupabaseClient();

const steps = ref([
  {
    key: 'title',
    type: 'text',
    question: 'Quel est le titre de votre mission ?',
    description: 'Soyez concis et précis pour attirer les meilleurs talents.',
    placeholder: 'Ex: Création d\'un logo moderne pour une startup'
  },
  {
    key: 'categoryId',
    type: 'categories',
    question: 'Quelle est la catégorie de votre mission ?',
    description: 'Choisissez la catégorie qui correspond le mieux à votre besoin.'
  },
  {
    key: 'description',
    type: 'textarea',
    question: 'Décrivez votre mission en détail',
    description: 'Plus vous serez précis, plus les propositions seront pertinentes.',
    placeholder: 'Décrivez votre projet, vos attentes et vos contraintes...'
  },
  {
    key: 'budget',
    type: 'budget',
    question: 'Quel est votre budget ?',
    description: 'Définissez le budget que vous souhaitez allouer à cette mission.'
  },
  {
    key: 'deadline',
    type: 'deadline',
    question: 'Quelle est votre date limite ?',
    description: 'Choisissez une date limite pour la réalisation de votre mission.'
  }
])

// Price formatting
const formatPrice = (value) => {
  if (!value) return 'Personnalisé'
  return new Intl.NumberFormat('fr-FR', {
    style: 'currency',
    currency: 'XOF',
    minimumFractionDigits: 0
  }).format(value)
}

// État pour la pagination
const page = ref(1)
const perPage = 20
const hasMore = ref(true)
const isLoadingMore = ref(false)
const professionsContainer = ref(null)
// const search = ref('')
const currentStep = ref(1)
// Professions affichées
const displayedProfessions = computed(() => {
  if (!search.value) {
    return professions.value.slice(0, page.value * perPage)
  }
  return filteredItems.value.slice(0, page.value * perPage)
})

// Gestion du scroll infini
const handleScroll = useThrottle((e) => {
  if (!e?.target) return;
  
  const container = e.target;
  const { scrollTop, scrollHeight, clientHeight } = container;
  
  if (scrollHeight - scrollTop <= clientHeight * 1.5 && hasMore.value && !isLoadingMore.value) {
    loadMore();
  }
}, 200);

// Chargement des données
const loadMore = async () => {
  if (isLoadingMore.value || !hasMore.value) return
  
  isLoadingMore.value = true
  try {
    // Calculer l'offset pour la pagination
    const offset = page.value * perPage

    // Construire la requête Supabase
    let query = supabase
      .from('professions')
      .select('id, name, description')
      .eq('is_active', true)
      .order('name')
      .range(offset, offset + perPage - 1)

    // Ajouter la recherche si nécessaire
    if (search.value) {
      query = query.or(`name.ilike.%${search.value}%,description.ilike.%${search.value}%`)
    }

    // Exécuter la requête
    const { data, error } = await query

    if (error) throw error

    // Vérifier s'il y a plus de données
    if (!data || data.length < perPage) {
      hasMore.value = false
    }

    // Mettre à jour les professions
    professions.value = [...professions.value, ...(data || [])]
    page.value++

  } catch (error) {
    console.error('Error loading professions:', error)
    useToast().add({
      title: 'Erreur',
      description: 'Impossible de charger les catégories. Veuillez réessayer.',
      color: 'red'
    })
  } finally {
    isLoadingMore.value = false
  }
}

// Recherche
const search = ref('')
const filteredItems = computed(() => {
  if (!search.value) return professions.value
  
  const searchTerm = search.value.toLowerCase()
  return professions.value.filter(profession => 
    profession.name.toLowerCase().includes(searchTerm) ||
    profession.description.toLowerCase().includes(searchTerm)
  )
})

// Reset de la recherche quand on change d'étape
watch(() => currentStep.value, () => {
  search.value = ''
  page.value = 1
  hasMore.value = true
})

// Chargement initial
onMounted(() => {
  loadMore()
})

// Date utility functions
const getTomorrowDate = () => {
  const tomorrow = new Date()
  tomorrow.setDate(tomorrow.getDate() + 1)
  return tomorrow.toISOString().split('T')[0]
}

const getDatePlus = (days) => {
  const date = new Date()
  date.setDate(date.getDate() + days)
  return date.toISOString().split('T')[0]
}

// Minimum date (today)
const minDate = computed(() => {
  const today = new Date()
  return today.toISOString().split('T')[0]
})

// Deadline options
const deadlineOptions = computed(() => [
  { 
    value: getTomorrowDate(),
    label: "Demain",
    description: formatDate(getTomorrowDate())
  },
  { 
    value: getDatePlus(7),
    label: "Dans une semaine",
    description: formatDate(getDatePlus(7))
  },
  { 
    value: getDatePlus(14),
    label: "Dans 2 semaines",
    description: formatDate(getDatePlus(14))
  },
  { 
    value: getDatePlus(30),
    label: "Dans un mois",
    description: formatDate(getDatePlus(30))
  }
])

// Format dates
const formatDate = (date) => {
  return new Intl.DateTimeFormat('fr-FR', {
    weekday: 'long',
    day: 'numeric',
    month: 'long'
  }).format(new Date(date))
}

// State
// const currentStep = ref(1)
const missionData = ref({
  title: '',
  description: '',
  categoryId: null,
  budget: null,
  deadline: ''
})

// Navigation
const nextStep = () => {
  if (currentStep.value < steps.value.length) {
    document.startViewTransition(() => {
      currentStep.value++
      announceStepChange(currentStep.value)
      triggerHapticFeedback()
    })
  } else {
    handleSubmit()
  }
}

const previousStep = () => {
  if (currentStep.value > 1) {
    document.startViewTransition(() => {
      currentStep.value--
      announceStepChange(currentStep.value)
      triggerHapticFeedback()
    })
  }
}

// UI state
const isSubmitting = ref(false);
const statusMessage = ref('');
const statusType = ref('info');
const isOpen = ref(false);
const selectedCategory = ref(null);
const professions = ref([
  { id: 1, name: "Développeur", description: "Applications, sites web et logiciels" },
  { id: 2, name: "Designer", description: "UI/UX, graphisme et identité visuelle" },
  { id: 3, name: "Marketing", description: "Stratégie digitale et croissance" },
  { id: 4, name: "Rédacteur", description: "Articles, contenus et copywriting" },
  { id: 5, name: "Photographe", description: "Photos professionnelles et retouches" }
]);
const isLoadingCategories = ref(false);
const dropdownRef = ref(null);

// Form validation
const formErrors = ref({})

// Form validation computed
const isFormValid = computed(() => {
  return (
    missionData.value.title?.trim() &&
    missionData.value.description?.trim() &&
    missionData.value.categoryId &&
    missionData.value.budget > 0 &&
    missionData.value.deadline &&
    new Date(missionData.value.deadline) > new Date()
  )
})

// Show status message
const showStatus = (message, type = 'info') => {
  statusMessage.value = message;
  statusType.value = type;
  
  // Auto-hide after 5 seconds
  setTimeout(() => {
    statusMessage.value = '';
  }, 5000);
};

// Calcul de la progression
const formProgress = computed(() => {
  let progress = 0
  const fields = {
    title: 25,
    description: 25,
    categoryId: 25,
    budget: 12.5,
    deadline: 12.5
  }

  for (const [field, value] of Object.entries(fields)) {
    if (missionData.value[field]) progress += value
  }

  return Math.round(progress)
})

// Toggle dropdown
const toggleDropdown = () => {
  isOpen.value = !isOpen.value;
  if (isOpen.value) {
    search.value = ''; // Reset search on open
    if (professions.value.length === 0 && !isLoadingCategories.value) {
      fetchProfessions()
    }
  }
}

// Select item
const selectItem = (profession) => {
  selectedCategory.value = profession
  missionData.value.categoryId = profession.id
  isSearchFocused.value = false
  search.value = ''
  triggerHapticFeedback()
}

// Fetch professions from Supabase
const fetchProfessions = async () => {
  isLoadingCategories.value = true;
  
  try {
    const { data, error } = await supabase
      .from('professions')
      .select('id, name')
      .eq('is_active', true)
      .order('name');
    
    if (error) throw error;
    
    professions.value = data || [];
  } catch (error) {
    console.error('Error fetching professions:', error);
    showStatus('Impossible de charger les catégories. Veuillez réessayer.', 'error');
  } finally {
    isLoadingCategories.value = false;
  }
};

// Fonction de soumission
const handleSubmit = async () => {
  if (!validateForm()) {
    return
  }

  isSubmitting.value = true

  try {
    // Récupérer l'utilisateur connecté
    const { data: { user } } = await supabase.auth.getUser()
    
    if (!user) throw new Error('Non authentifié')

    // Créer la mission
    const { data, error } = await supabase
      .from('missions')
      .insert([
        {
          title: missionData.value.title,
          description: missionData.value.description,
          profession_id: missionData.value.categoryId,
          budget: missionData.value.budget,
          deadline: missionData.value.deadline,
          client_id: user.id,
          status: 'open'
        }
      ])
      .select()
      .single()

    if (error) throw error

    // Rediriger vers la page de la mission
    await router.push(`/missions/${data.id}`)

  } catch (error) {
    console.error('Error creating mission:', error)
    // Afficher une notification d'erreur
    // Si vous utilisez Nuxt UI Toast ou autre système de notification
    useToast().add({
      title: 'Erreur',
      description: 'Impossible de créer la mission. Veuillez réessayer.',
      color: 'red'
    })
  } finally {
    isSubmitting.value = false
  }
}

// Validation du formulaire
const validateForm = () => {
  const errors = {}
  
  if (!missionData.value.title?.trim()) {
    errors.title = 'Le titre est requis'
  }
  
  if (!missionData.value.description?.trim()) {
    errors.description = 'La description est requise'
  }
  
  if (!missionData.value.categoryId) {
    errors.categoryId = 'La catégorie est requise'
  }
  
  if (!missionData.value.budget || missionData.value.budget <= 0) {
    errors.budget = 'Le budget doit être supérieur à 0'
  }
  
  if (!missionData.value.deadline) {
    errors.deadline = 'La date limite est requise'
  } else if (new Date(missionData.value.deadline) <= new Date()) {
    errors.deadline = 'La date limite doit être future'
  }
  
  formErrors.value = errors
  return Object.keys(errors).length === 0
}

// Lifecycle hooks
onMounted(() => {
  const handleClickOutside = (event) => {
    if (dropdownRef.value && !dropdownRef.value.contains(event?.target)) {
      isOpen.value = false
    }
  }

  // Utilisation de mousedown au lieu de click
  document.addEventListener('mousedown', handleClickOutside)

  onBeforeUnmount(() => {
    document.removeEventListener('mousedown', handleClickOutside)
  })

  fetchProfessions();
});

onBeforeUnmount(() => {
  document.removeEventListener('mousedown', () => {})
});

// Fonction pour générer une couleur aléatoire basée sur l'ID de la catégorie
const getRandomColor = (id) => {
  const colors = [
    '#3B82F6', // blue
    '#EC4899', // pink
    '#10B981', // green
    '#F59E0B', // amber
    '#8B5CF6', // purple
    '#EF4444', // red
    '#06B6D4', // cyan
    '#F97316', // orange
  ];
  
  // Utiliser l'ID comme seed pour choisir une couleur
  return colors[id % colors.length];
};

// Update selected category when dropdown changes
const updateSelectedCategory = () => {
  const categoryId = missionData.value.categoryId;
  if (categoryId) {
    selectedCategory.value = professions.value.find(cat => cat.id === categoryId);
  } else {
    selectedCategory.value = null;
  }
};

// Watch for professions loaded to update selected category if needed
watch(professions, () => {
  if (missionData.value.categoryId) {
    updateSelectedCategory();
  }
}, { deep: true });

// Suggestions de titres
const titleSuggestions = [
  "Création d'un logo moderne",
  "Design d'une application mobile",
  "Développement d'un site web",
  "Rédaction d'un article blog"
]

// Conseils pour la description
const descriptionTips = [
  "Décrivez le contexte et les objectifs de votre projet",
  "Précisez vos attentes et les livrables souhaités",
  "Mentionnez vos contraintes techniques ou créatives",
  "Indiquez vos références ou inspirations",
  "Spécifiez le format et la qualité attendus"
]

const descriptionStructure = [
  {
    title: "Contexte du projet",
    example: "Je souhaite créer une identité visuelle pour ma nouvelle entreprise de..."
  },
  {
    title: "Objectifs",
    example: "Le but est de transmettre une image moderne et professionnelle..."
  },
  {
    title: "Livrables attendus",
    example: "J'ai besoin des éléments suivants : logo en formats vectoriel et PNG..."
  },
  {
    title: "Contraintes",
    example: "Les couleurs doivent respecter notre charte : bleu (#1E40AF) et..."
  }
]

// Validation de l'étape date
const isDeadlineValid = computed(() => {
  if (steps.value[currentStep.value - 1].type !== 'deadline') return true
  return !!missionData.value.deadline
})

// Mise à jour de la validation globale
const isCurrentStepValid = computed(() => {
  const currentStepData = steps.value[currentStep.value - 1]
  const value = missionData.value[currentStepData.key]

  switch (currentStepData.type) {
    case 'text':
      return value?.trim().length >= 5 && value?.trim().length <= 100
    case 'textarea':
      return value?.trim().length >= 20 && value?.trim().length <= 500
    case 'categories':
      return !!value
    case 'budget':
      return value > 0
    case 'deadline':
      return isDeadlineValid.value
    default:
      return false
  }
})

const quickAmounts = [5000, 10000, 25000, 50000]

const currentTip = computed(() => {
  const tips = [
    "Soyez précis dans vos attentes",
    "Donnez des exemples concrets",
    "Mentionnez vos contraintes",
    "Indiquez vos préférences"
  ]
  return tips[Math.floor(Math.random() * tips.length)]
})

// États
const showSuccessModal = ref(false)
const isLoading = ref(false)

// Fermeture du modal
const closeSuccessModal = () => {
  showSuccessModal.value = false
  navigateTo('/requests') // Redirection après fermeture
}

// Refs
const searchRef = ref(null)

// Fermeture de la liste au clic en dehors
onClickOutside(searchRef, () => {
  isSearchFocused.value = false
})

// Style des professions
const getProfessionStyle = (professionName) => ({
  'Développeur': 'bg-purple-50 dark:bg-purple-900/20 text-purple-600 dark:text-purple-400',
  'Designer': 'bg-pink-50 dark:bg-pink-900/20 text-pink-600 dark:text-pink-400',
  'Marketing': 'bg-blue-50 dark:bg-blue-900/20 text-blue-600 dark:text-blue-400',
  'Rédacteur': 'bg-green-50 dark:bg-green-900/20 text-green-600 dark:text-green-400'
})[professionName] || 'bg-gray-100 dark:bg-gray-800 text-gray-600 dark:text-gray-400'

// Icônes des professions
const getProfessionIcon = (professionName) => ({
  'Développeur': 'i-heroicons-code-bracket',
  'Designer': 'i-heroicons-paint-brush',
  'Marketing': 'i-heroicons-presentation-chart-line',
  'Rédacteur': 'i-heroicons-pencil'
})[professionName] || 'i-heroicons-briefcase'

// Fonction pour ajouter du contenu à la description
const appendToDescription = (structure) => {
  const currentText = missionData.value.description || ''
  const newText = `${structure.title}:\n${structure.example}\n\n`
  missionData.value.description = currentText + newText
}

// Ajoutez cette fonction pour améliorer l'accessibilité
const announceStepChange = (step) => {
  const announcement = document.getElementById('step-announcement')
  if (announcement) {
    announcement.textContent = `Étape ${step} sur ${steps.value.length}: ${steps.value[step-1].question}`
  }
}

const currentStepData = computed(() => steps.value[currentStep.value - 1])
const getStepComponent = computed(() => {
  switch (currentStepData.value.type) {
    case 'text':
      return 'TextComponent'
    case 'textarea':
      return 'TextareaComponent'
    case 'categories':
      return 'CategoriesComponent'
    case 'budget':
      return 'BudgetComponent'
    case 'deadline':
      return 'DeadlineComponent'
    default:
      return null
  }
})

const isLastStep = computed(() => currentStep.value === steps.value.length)

// États pour la recherche
const isSearchFocused = ref(false)

// Description des professions
const getProfessionDescription = (professionName) => {
  const descriptions = {
    'Développeur': 'Applications, sites web et logiciels',
    'Designer': 'UI/UX, graphisme et identité visuelle',
    'Marketing': 'Stratégie, acquisition et croissance',
    'Rédacteur': 'Articles, contenus et copywriting',
    'default': 'Expert dans son domaine'
  }
  return descriptions[professionName] || descriptions.default
}

// Réinitialisation de la sélection
const clearSelection = () => {
  selectedCategory.value = null
  missionData.value.categoryId = null
  triggerHapticFeedback()
}

// Validation spécifique pour les catégories
const isCategoryValid = computed(() => {
  return !!missionData.value.categoryId
})

// Sélection d'une date rapide
const selectQuickDate = (days) => {
  const date = new Date()
  date.setDate(date.getDate() + days)
  missionData.value.deadline = date.toISOString().split('T')[0]
}

// Formatage de la date
const getDateString = (days) => {
  const date = new Date()
  date.setDate(date.getDate() + days)
  return date.toLocaleDateString('fr-FR', { 
    day: 'numeric',
    month: 'long'
  })
}

// Ajoutez ces constantes et fonctions

const quickDateOptions = [
  { days: 7, label: '1 semaine' },
  { days: 14, label: '2 semaines' },
  { days: 30, label: '1 mois' },
  { days: 60, label: '2 mois' }
]

// Obtenir une date à partir du nombre de jours
const getDateFromDays = (days) => {
  const date = new Date()
  date.setDate(date.getDate() + days)
  return date.toISOString().split('T')[0]
}

// Formatage de la date
const getFormattedDate = (days) => {
  const date = new Date()
  date.setDate(date.getDate() + days)
  return new Intl.DateTimeFormat('fr-FR', { 
    day: 'numeric',
    month: 'long',
    year: 'numeric'
  }).format(date)
}

// Style personnalisé pour l'input date
const dateInputStyle = computed(() => {
  if (!missionData.value.deadline) {
    return 'text-gray-400 dark:text-gray-500'
  }
  return 'text-gray-900 dark:text-white'
})

// Ajout du state pour les tips
const showTips = ref(false)

// Constantes pour le budget
const getBudgetDescription = (amount) => ({
  5000: 'Idéal pour les petits projets',
  10000: 'Pour les projets simples',
  25000: 'Pour les projets moyens',
  50000: 'Pour les projets complexes'
})[amount] || 'Budget personnalisé'

// Sélection du budget
const selectBudget = (amount) => {
  missionData.value.budget = amount
}

definePageMeta({
  layout: 'creation',
  layoutTransition: {
    name: 'slide-up'
  }
})
</script>