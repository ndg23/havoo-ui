<template>
  <div class="min-h-screen bg-gray-50 dark:bg-gray-900">
    <!-- Header fixe avec effet glassmorphism -->
    <header class="sticky top-0 z-10 backdrop-blur-lg bg-white/80 dark:bg-gray-800/80 border-b border-gray-200 dark:border-gray-700">
      <div class="max-w-2xl mx-auto px-4 py-3 flex items-center justify-between">
        <div class="flex items-center gap-3">
          <button 
            @click="$router.back()" 
            class="p-2 -ml-2 rounded-full hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors"
          >
            <UIcon name="i-heroicons-arrow-left" class="h-5 w-5 text-gray-700 dark:text-gray-200" />
          </button>
          <div>
            <h1 class="text-xl font-bold text-gray-900 dark:text-white">Nouvelle mission</h1>
            <p class="text-sm text-gray-500 dark:text-gray-400">Créez votre demande</p>
          </div>
        </div>
        
        <button
          type="button"
          @click="handleSubmit"
          :disabled="isSubmitting || !isFormValid"
          class="inline-flex items-center px-4 py-2 rounded-full text-white font-medium transition-all duration-200 hover:shadow-md active:scale-95"
          :class="[
            isSubmitting || !isFormValid 
              ? 'bg-gray-300 dark:bg-gray-600 cursor-not-allowed' 
              : 'bg-primary-600 hover:bg-primary-700'
          ]"
        >
          <UIcon 
            v-if="isSubmitting"
            name="i-heroicons-arrow-path" 
            class="animate-spin mr-2 h-4 w-4"
          />
          {{ isSubmitting ? 'Publication...' : 'Publier' }}
        </button>
      </div>
    </header>

    <main class="max-w-2xl mx-auto px-4 py-6">
      <!-- Introduction avec animation -->
      <div class="mb-8 text-center animate-fade-in">
        <h2 class="text-2xl font-bold text-gray-900 dark:text-white mb-2">
          Que voulez-vous faire réaliser ?
        </h2>
        <p class="text-gray-600 dark:text-gray-400">
          Décrivez votre projet en détail pour trouver le meilleur expert
        </p>
      </div>

      <!-- Barre de progression moderne -->
      <div class="relative mb-8 px-4">
        <div class="h-1.5 bg-gray-200 dark:bg-gray-700 rounded-full overflow-hidden">
          <div 
            class="h-full bg-gradient-to-r from-primary-500 to-primary-600 transition-all duration-500 ease-out"
            :style="{ width: `${formProgress}%` }"
          />
        </div>
        <span class="absolute right-0 top-2 text-sm font-medium text-primary-600 dark:text-primary-400">
          {{ formProgress }}%
        </span>
      </div>

      <!-- Formulaire avec animations -->
      <form @submit.prevent="handleSubmit" class="space-y-6">
        <!-- Titre -->
        <div class="space-y-1">
          <div class="relative group">
            <input
              v-model="missionData.title"
              type="text"
              id="title"
              class="block w-full px-4 pt-6 pb-1 text-gray-900 dark:text-white bg-white dark:bg-gray-800 border border-gray-300 dark:border-gray-600 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-all duration-200"
              :class="{ 'border-red-500 focus:ring-red-500': formErrors.title }"
              placeholder=" "
              maxlength="100"
              required
            />
            <label 
              for="title" 
              class="absolute left-4 top-2 text-gray-500 dark:text-gray-400 text-sm transition-all duration-200"
            >
              Titre de la mission
            </label>
          </div>
          <div class="flex justify-between px-1">
            <span class="text-xs text-gray-500">
              Ex: "Création d'un logo pour ma startup"
            </span>
            <span class="text-xs text-gray-400">
              {{ missionData.title.length }}/100
            </span>
          </div>
          <p v-if="formErrors.title" class="text-sm text-red-500 px-1">
            {{ formErrors.title }}
          </p>
        </div>

        <!-- Description avec compteur de caractères circulaire -->
        <div class="space-y-1">
          <div class="relative group">
            <textarea
              v-model="missionData.description"
              id="description"
              class="block w-full px-4 pt-6 pb-1 text-gray-900 dark:text-white bg-white dark:bg-gray-800 border border-gray-300 dark:border-gray-600 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-all duration-200 min-h-[120px] resize-none"
              :class="{ 'border-red-500 focus:ring-red-500': formErrors.description }"
              placeholder=" "
              maxlength="1000"
              rows="4"
              required
            />
            <label 
              for="description" 
              class="absolute left-4 top-2 text-gray-500 dark:text-gray-400 text-sm transition-all duration-200"
            >
              Description détaillée
            </label>
            <!-- Compteur circulaire -->
            <div class="absolute right-3 top-3 h-6 w-6">
              <svg class="transform -rotate-90" viewBox="0 0 36 36">
                <path
                  d="M18 2.0845 a 15.9155 15.9155 0 0 1 0 31.831 a 15.9155 15.9155 0 0 1 0 -31.831"
                  fill="none"
                  stroke="#E5E7EB"
                  stroke-width="3"
                />
                <path
                  d="M18 2.0845 a 15.9155 15.9155 0 0 1 0 31.831 a 15.9155 15.9155 0 0 1 0 -31.831"
                  fill="none"
                  stroke="#6366F1"
                  stroke-width="3"
                  :stroke-dasharray="`${(missionData.description.length / 1000) * 100}, 100`"
                />
              </svg>
              <span class="absolute inset-0 flex items-center justify-center text-xs font-medium text-primary-600">
                {{ Math.round((missionData.description.length / 1000) * 100) }}%
              </span>
            </div>
          </div>
          <div class="flex justify-between px-1">
            <span class="text-xs text-gray-500">
              Soyez précis pour obtenir les meilleures propositions
            </span>
            <span class="text-xs text-gray-400">
              {{ missionData.description.length }}/1000
            </span>
          </div>
          <p v-if="formErrors.description" class="text-sm text-red-500 px-1">
            {{ formErrors.description }}
          </p>
        </div>

        <!-- Catégorie avec Dropdown -->
        <div class="space-y-1">
          <div class="relative" ref="dropdownRef">
            <!-- Bouton principal -->
            <button
              type="button"
              @click.stop.prevent="toggleDropdown"
              class="w-full px-4 pt-6 pb-1 text-left text-gray-900 dark:text-white bg-white dark:bg-gray-800 border border-gray-300 dark:border-gray-600 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-all duration-200"
            >
              <label class="absolute left-4 top-2 text-gray-500 dark:text-gray-400 text-sm">
                Catégorie
              </label>
              <span class="block truncate">
                {{ selectedCategory?.name || 'Sélectionner une catégorie' }}
              </span>
              <span class="absolute inset-y-0 right-0 flex items-center pr-3">
                <UIcon 
                  name="i-heroicons-chevron-down" 
                  class="h-4 w-4 text-gray-400"
                />
              </span>
            </button>

            <!-- Dropdown -->
            <div 
              v-show="isOpen"
              class="absolute z-50 mt-1 w-full bg-white dark:bg-gray-800 rounded-xl shadow-lg border border-gray-200 dark:border-gray-700"
            >
              <!-- Search -->
              <div class="p-2 border-b border-gray-200 dark:border-gray-700">
                <div class="relative">
                  <UIcon 
                    name="i-heroicons-magnifying-glass" 
                    class="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-gray-400"
                  />
                  <input
                    v-model="search"
                    type="text"
                    @click.stop.prevent
                    placeholder="Rechercher..."
                    class="w-full pl-9 pr-4 py-2 text-sm bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-700 rounded-full focus:outline-none focus:ring-2 focus:ring-primary-500"
                  />
                </div>
              </div>

              <!-- Liste -->
              <div class="max-h-60 overflow-y-auto">
                <button
                  v-for="item in filteredItems"
                  :key="item.id"
                  type="button"
                  @click.stop.prevent="selectItem(item)"
                  class="w-full px-4 py-2.5 text-left hover:bg-gray-50 dark:hover:bg-gray-700 flex items-center gap-3"
                  :class="{ 'bg-gray-50 dark:bg-gray-700': selectedCategory?.id === item.id }"
                >
                  <span class="flex-1">{{ item.name }}</span>
                  <UIcon 
                    v-if="selectedCategory?.id === item.id"
                    name="i-heroicons-check" 
                    class="h-4 w-4 text-primary-500"
                  />
                </button>
              </div>
            </div>
          </div>

          <p v-if="formErrors.categoryId" class="text-sm text-red-500 px-1">
            {{ formErrors.categoryId }}
          </p>
        </div>

        <!-- Budget et Deadline -->
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <!-- Budget -->
          <div class="space-y-1">
            <div class="relative group">
              <input
                v-model="missionData.budget"
                type="number"
                id="budget"
                class="block w-full px-4 pt-6 pb-1 text-gray-900 dark:text-white bg-white dark:bg-gray-800 border border-gray-300 dark:border-gray-600 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-all duration-200"
                :class="{ 'border-red-500 focus:ring-red-500': formErrors.budget }"
                placeholder=" "
                min="0"
                required
              />
              <label 
                for="budget" 
                class="absolute left-4 top-2 text-gray-500 dark:text-gray-400 text-sm transition-all duration-200"
              >
                Budget (FCFA)
              </label>
            </div>
            <div class="flex justify-between px-1">
              <span class="text-xs text-gray-500">
                Ex: 50000
              </span>
            </div>
            <p v-if="formErrors.budget" class="text-sm text-red-500 px-1">
              {{ formErrors.budget }}
            </p>
          </div>

          <!-- Deadline -->
          <div class="space-y-1">
            <div class="relative group">
              <input
                v-model="missionData.deadline"
                type="date"
                id="deadline"
                class="block w-full px-4 pt-6 pb-1 text-gray-900 dark:text-white bg-white dark:bg-gray-800 border border-gray-300 dark:border-gray-600 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-all duration-200"
                :class="{ 'border-red-500 focus:ring-red-500': formErrors.deadline }"
                :min="minDate"
                required
              />
              <label 
                for="deadline" 
                class="absolute left-4 top-2 text-gray-500 dark:text-gray-400 text-sm transition-all duration-200"
              >
                Date limite
              </label>
            </div>
            <div class="flex justify-between px-1">
              <span class="text-xs text-gray-500">
                Date souhaitée de réalisation
              </span>
            </div>
            <p v-if="formErrors.deadline" class="text-sm text-red-500 px-1">
              {{ formErrors.deadline }}
            </p>
          </div>
        </div>
      </form>

      <!-- Message d'aide contextuel -->
      <div class="mt-6 p-4 bg-blue-50 dark:bg-blue-900/20 rounded-xl border border-blue-100 dark:border-blue-800">
        <p class="text-sm text-blue-700 dark:text-blue-400 flex items-center gap-2">
          <UIcon name="i-heroicons-light-bulb" class="h-5 w-5 flex-shrink-0" />
          {{ formProgressMessage }}
        </p>
      </div>
    </main>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onBeforeUnmount, watch } from 'vue';
import { useRouter } from 'vue-router';
import { Dialog, DialogPanel, DialogTitle, TransitionRoot, TransitionChild } from '@headlessui/vue';
import { onClickOutside } from '@vueuse/core';
import { useThrottle } from '@vueuse/core';
import { useToast } from '@/composables/useToast'; // Added missing import

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
]);

// Price formatting
const formatPrice = (value) => {
  if (!value) return 'Personnalisé';
  return new Intl.NumberFormat('fr-FR', {
    style: 'currency',
    currency: 'XOF',
    minimumFractionDigits: 0
  }).format(value);
};

// État pour la pagination
const page = ref(1);
const perPage = 20;
const hasMore = ref(true);
const isLoadingMore = ref(false);
const professionsContainer = ref(null);
const search = ref('');
const currentStep = ref(1);

// Professions affichées
const displayedProfessions = computed(() => {
  if (!search.value) {
    return professions.value.slice(0, page.value * perPage);
  }
  return filteredItems.value.slice(0, page.value * perPage);
});

// Gestion du scroll infini
const handleScroll = useThrottle((e) => {
  const { scrollTop, scrollHeight, clientHeight } = e.target;
  if (scrollHeight - scrollTop <= clientHeight * 1.5 && hasMore.value && !isLoadingMore.value) {
    loadMore();
  }
}, 200);

// Chargement des données
const loadMore = async () => {
  if (isLoadingMore.value || !hasMore.value) return;
  
  isLoadingMore.value = true;
  try {
    const { data, error } = await useFetch('/api/professions', {
      params: {
        page: page.value + 1,
        search: search.value
      }
    });
    
    if (error.value) throw error.value;
    
    if (data.value.professions.length < perPage) {
      hasMore.value = false;
    }
    
    professions.value = [...professions.value, ...data.value.professions];
    page.value++;
    
  } catch (error) {
    console.error('Error loading professions:', error);
    showStatus('Impossible de charger les catégories. Veuillez réessayer.', 'error');
  } finally {
    isLoadingMore.value = false;
  }
};

// Recherche
const filteredItems = computed(() => {
  if (!search.value) return professions.value;
  
  const searchTerm = search.value.toLowerCase();
  return professions.value.filter(profession => 
    profession.name.toLowerCase().includes(searchTerm) ||
    profession.description.toLowerCase().includes(searchTerm)
  );
});

// Reset de la recherche quand on change d'étape
watch(() => currentStep.value, () => {
  search.value = '';
  page.value = 1;
  hasMore.value = true;
});

// Date utility functions
const getTomorrowDate = () => {
  const tomorrow = new Date();
  tomorrow.setDate(tomorrow.getDate() + 1);
  return tomorrow.toISOString().split('T')[0];
};

const getDatePlus = (days) => {
  const date = new Date();
  date.setDate(date.getDate() + days);
  return date.toISOString().split('T')[0];
};

// Minimum date (today)
const minDate = computed(() => {
  const today = new Date();
  return today.toISOString().split('T')[0];
});

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
]);

// Format dates
const formatDate = (date) => {
  return new Intl.DateTimeFormat('fr-FR', {
    weekday: 'long',
    day: 'numeric',
    month: 'long'
  }).format(new Date(date));
};

// State
const missionData = ref({
  title: '',
  description: '',
  categoryId: null,
  budget: null,
  deadline: ''
});

// Navigation
const nextStep = () => {
  if (currentStep.value < steps.value.length) {
    currentStep.value++;
    announceStepChange(currentStep.value);
    triggerHapticFeedback();
  } else {
    handleSubmit();
  }
};

const previousStep = () => {
  if (currentStep.value > 1) {
    currentStep.value--;
    announceStepChange(currentStep.value);
  }
};

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
const formErrors = ref({});

// Form validation computed
const isFormValid = computed(() => {
  return (
    missionData.value.title?.trim() &&
    missionData.value.description?.trim() &&
    missionData.value.categoryId &&
    missionData.value.budget > 0 &&
    missionData.value.deadline &&
    new Date(missionData.value.deadline) > new Date()
  );
});

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
  let progress = 0;
  const fields = {
    title: 25,
    description: 25,
    categoryId: 25,
    budget: 12.5,
    deadline: 12.5
  };

  for (const [field, value] of Object.entries(fields)) {
    if (missionData.value[field]) progress += value;
  }

  return Math.round(progress);
});

// Toggle dropdown
const toggleDropdown = () => {
  isOpen.value = !isOpen.value;
  if (isOpen.value) {
    search.value = ''; // Reset search on open
    if (professions.value.length === 0 && !isLoadingCategories.value) {
      fetchProfessions();
    }
  }
};

// Select item
const selectItem = (profession) => {
  selectedCategory.value = profession;
  missionData.value.categoryId = profession.id;
  isSearchFocused.value = false;
  search.value = '';
  triggerHapticFeedback();
};

// Fetch professions from Supabase
const fetchProfessions = async () => {
  isLoadingCategories.value = true;
  
  try {
    const { data, error } = await supabase
      .from('professions')
      .select('id, name, description')
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
    return;
  }

  isSubmitting.value = true;
  isLoading.value = true;

  try {
    // Récupérer l'utilisateur connecté
    const { data: { user } } = await supabase.auth.getUser();
    
    if (!user) throw new Error('Non authentifié');

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
      .single();

    if (error) throw error;

    // Afficher le modal de succès
    showSuccessModal.value = true;

  } catch (error) {
    console.error('Error creating mission:', error);
    // Afficher une notification d'erreur
    useToast().add({
      title: 'Erreur',
      description: 'Impossible de créer la mission. Veuillez réessayer.',
      color: 'red'
    });
  } finally {
    isSubmitting.value = false;
    isLoading.value = false;
  }
};

// Validation du formulaire
const validateForm = () => {
  const errors = {};
  
  if (!missionData.value.title?.trim()) {
    errors.title = 'Le titre est requis';
  } else if (missionData.value.title.trim().length < 5) {
    errors.title = 'Le titre doit contenir au moins 5 caractères';
  } else if (missionData.value.title.trim().length > 100) {
    errors.title = 'Le titre ne doit pas dépasser 100 caractères';
  }
  
  if (!missionData.value.description?.trim()) {
    errors.description = 'La description est requise';
  } else if (missionData.value.description.trim().length < 20) {
    errors.description = 'La description doit contenir au moins 20 caractères';
  } else if (missionData.value.description.trim().length > 500) {
    errors.description = 'La description ne doit pas dépasser 500 caractères';
  }
  
  if (!missionData.value.categoryId) {
    errors.categoryId = 'La catégorie est requise';
  }
  
  if (!missionData.value.budget || missionData.value.budget <= 0) {
    errors.budget = 'Le budget doit être supérieur à 0';
  }
  
  if (!missionData.value.deadline) {
    errors.deadline = 'La date limite est requise';
  } else if (new Date(missionData.value.deadline) <= new Date()) {
    errors.deadline = 'La date limite doit être future';
  }
  
  formErrors.value = errors;
  return Object.keys(errors).length === 0;
};

// Lifecycle hooks
onMounted(() => {
  if (professionsContainer.value) {
    professionsContainer.value.addEventListener('scroll', handleScroll);
  }

  const handleClickOutside = (event) => {
    if (dropdownRef.value && !dropdownRef.value.contains(event.target)) {
      isOpen.value = false;
    }
  };

  // Utilisation de mousedown au lieu de click
  document.addEventListener('mousedown', handleClickOutside);

  onBeforeUnmount(() => {
    if (professionsContainer.value) {
      professionsContainer.value.removeEventListener('scroll', handleScroll);
    }
    document.removeEventListener('mousedown', handleClickOutside);
  });

  fetchProfessions();
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
];

// Conseils pour la description
const descriptionTips = [
  "Décrivez le contexte et les objectifs de votre projet",
  "Précisez vos attentes et les livrables souhaités",
  "Mentionnez vos contraintes techniques ou créatives",
  "Indiquez vos références ou inspirations",
  "Spécifiez le format et la qualité attendus"
];

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
];

// Validation de l'étape date
const isDeadlineValid = computed(() => {
  if (steps.value[currentStep.value - 1].type !== 'deadline') return true;
  return !!missionData.value.deadline;
});

// Mise à jour de la validation globale
const isCurrentStepValid = computed(() => {
  const currentStepData = steps.value[currentStep.value - 1];
  const value = missionData.value[currentStepData.key];

  switch (currentStepData.type) {
    case 'text':
      return value?.trim().length >= 5 && value?.trim().length <= 100;
    case 'textarea':
      return value?.trim().length >= 20 && value?.trim().length <= 500;
    case 'categories':
      return !!value;
    case 'budget':
      return value > 0;
    case 'deadline':
      return isDeadlineValid.value;
    default:
      return false;
  }
});

const quickAmounts = [5000, 10000, 25000, 50000];

const currentTip = computed(() => {
  const tips = [
    "Soyez précis dans vos attentes",
    "Donnez des exemples concrets",
    "Mentionnez vos contraintes",
    "Indiquez vos préférences"
  ];
  return tips[Math.floor(Math.random() * tips.length)];
});

// États
const showSuccessModal = ref(false);
const isLoading = ref(false);

// Fermeture du modal
const closeSuccessModal = () => {
  showSuccessModal.value = false;
  router.push('/requests'); // Changed navigateTo to router.push for consistency
};

// Refs
const searchRef = ref(null);

// Fermeture de la liste au clic en dehors
onClickOutside(searchRef, () => {
  isSearchFocused.value = false;
});

// Style des professions
const getProfessionStyle = (professionName) => ({
  'Développeur': 'bg-purple-50 dark:bg-purple-900/20 text-purple-600 dark:text-purple-400',
  'Designer': 'bg-pink-50 dark:bg-pink-900/20 text-pink-600 dark:text-pink-400',
  'Marketing': 'bg-blue-50 dark:bg-blue-900/20 text-blue-600 dark:text-blue-400',
  'Rédacteur': 'bg-green-50 dark:bg-green-900/20 text-green-600 dark:text-green-400'
})[professionName] || 'bg-gray-100 dark:bg-gray-800 text-gray-600 dark:text-gray-400';

// Icônes des professions
const getProfessionIcon = (professionName) => ({
  'Développeur': 'i-heroicons-code-bracket',
  'Designer': 'i-heroicons-paint-brush',
  'Marketing': 'i-heroicons-presentation-chart-line',
  'Rédacteur': 'i-heroicons-pencil',
  'Photographe': 'i-heroicons-camera'
})[professionName] || 'i-heroicons-briefcase';

// Fonction pour ajouter du contenu à la description
const appendToDescription = (structure) => {
  const currentText = missionData.value.description || '';
  const newText = `${structure.title}:\n${structure.example}\n\n`;
  missionData.value.description = currentText + newText;
};

// Add missing functions
const triggerHapticFeedback = () => {
  // Implementation depends on the device capabilities
  // For mobile devices, you might use navigator.vibrate if available
  if (navigator.vibrate) {
    navigator.vibrate(10); // Short vibration
  }
};

// Ajoutez cette fonction pour améliorer l'accessibilité
const announceStepChange = (step) => {
  const announcement = document.getElementById('step-announcement');
  if (announcement) {
    announcement.textContent = `Étape ${step} sur ${steps.value.length}: ${steps.value[step-1].question}`;
  }
};

const currentStepData = computed(() => steps.value[currentStep.value - 1]);
const getStepComponent = computed(() => {
  switch (currentStepData.value.type) {
    case 'text':
      return 'TextComponent';
    case 'textarea':
      return 'TextareaComponent';
    case 'categories':
      return 'CategoriesComponent';
    case 'budget':
      return 'BudgetComponent';
    case 'deadline':
      return 'DeadlineComponent';
    default:
      return null;
  }
});

const isLastStep = computed(() => currentStep.value === steps.value.length);

// États pour la recherche
const isSearchFocused = ref(false);

// Description des professions
const getProfessionDescription = (professionName) => {
  const descriptions = {
    'Développeur': 'Applications, sites web et logiciels',
    'Designer': 'UI/UX, graphisme et identité visuelle',
    'Marketing': 'Stratégie, acquisition et croissance',
    'Rédacteur': 'Articles, contenus et copywriting',
    'Photographe': 'Photos professionnelles et retouches',
    'default': 'Expert dans son domaine'
  };
  return descriptions[professionName] || descriptions.default;
};

// Réinitialisation de la sélection
const clearSelection = () => {
  selectedCategory.value = null;
  missionData.value.categoryId = null;
  triggerHapticFeedback();
};

// Validation spécifique pour les catégories
const isCategoryValid = computed(() => {
  return !!missionData.value.categoryId;
});

// Sélection d'une date rapide
const selectQuickDate = (days) => {
  const date = new Date();
  date.setDate(date.getDate() + days);
  missionData.value.deadline = date.toISOString().split('T')[0];
};

// Formatage de la date
const getDateString = (days) => {
  const date = new Date();
  date.setDate(date.getDate() + days);
  return date.toLocaleDateString('fr-FR', { 
    day: 'numeric',
    month: 'long'
  });
};

const quickDateOptions = [
  { days: 7, label: '1 semaine' },
  { days: 14, label: '2 semaines' },
  { days: 30, label: '1 mois' },
  { days: 60, label: '2 mois' }
];

// Obtenir une date à partir du nombre de jours
const getDateFromDays = (days) => {
  const date = new Date();
  date.setDate(date.getDate() + days);
  return date.toISOString().split('T')[0];
};

// Formatage de la date
const getFormattedDate = (days) => {
  const date = new Date();
  date.setDate(date.getDate() + days);
  return new Intl.DateTimeFormat('fr-FR', { 
    day: 'numeric',
    month: 'long',
    year: 'numeric'
  }).format(date);
};

// Style personnalisé pour l'input date
const dateInputStyle = computed(() => {
  if (!missionData.value.deadline) {
    return 'text-gray-400 dark:text-gray-500';
  }
  return 'text-gray-900 dark:text-white';
});

// Ajout du state pour les tips
const showTips = ref(false);

// Constantes pour le budget
const getBudgetDescription = (amount) => ({
  5000: 'Idéal pour les petits projets',
  10000: 'Pour les projets simples',
  25000: 'Pour les projets moyens',
  50000: 'Pour les projets complexes'
})[amount] || 'Budget personnalisé';

// Sélection du budget
const selectBudget = (amount) => {
  missionData.value.budget = amount;
};

definePageMeta({
  layout: 'creation',
  layoutTransition: {
    name: 'slide-up'
  }
});
</script>

<style scoped>
/* Animation d'entrée */
@keyframes fade-in {
  from { opacity: 0; transform: translateY(10px); }
  to { opacity: 1; transform: translateY(0); }
}

.animate-fade-in {
  animation: fade-in 0.5s ease-out;
}

/* Style des inputs */
input:focus-within ~ label,
input:not(:placeholder-shown) ~ label,
textarea:focus-within ~ label,
textarea:not(:placeholder-shown) ~ label {
  @apply transform -translate-y-1 scale-90 text-primary-500;
}

.group:hover label {
  @apply text-gray-900 dark:text-gray-200;
}
</style>