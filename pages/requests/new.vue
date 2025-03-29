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
          @click="submitRequest"
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
      <form @submit.prevent="submitRequest" class="space-y-6">
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
              @click.stop="toggleDropdown"
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
                    @click.stop
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
                  @click.stop="selectItem(item)"
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
// import { useSupabaseClient } from '#supabase/client';
import TwitterInput from '~/components/ui/TwitterInput.vue';

const router = useRouter();
const supabase = useSupabaseClient();

// Form data
const missionData = ref({
  title: '',
  description: '',
  categoryId: null,
  budget: '',
  deadline: ''
});

// UI state
const isSubmitting = ref(false);
const statusMessage = ref('');
const statusType = ref('info');
const isOpen = ref(false);
const search = ref('');
const selectedCategory = ref(null);
const professions = ref([]);
const isLoadingCategories = ref(true);
const dropdownRef = ref(null);

// Validation du formulaire
const formErrors = ref({})
const minDate = computed(() => {
  const today = new Date()
  return today.toISOString().split('T')[0]
})

// Computed pour la validation du formulaire
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

// Validation avant soumission
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

// Show status message
const showStatus = (message, type = 'info') => {
  statusMessage.value = message;
  statusType.value = type;
  
  // Auto-hide after 5 seconds
  setTimeout(() => {
    statusMessage.value = '';
  }, 5000);
};

// Messages de progression plus engageants
const formProgressMessage = computed(() => {
  if (formProgress.value < 25) {
    return "👋 Commencez par donner un titre accrocheur à votre mission"
  }
  if (formProgress.value < 50) {
    return "✍️ Super ! Maintenant, décrivez votre besoin en détail"
  }
  if (formProgress.value < 75) {
    return "🎯 Précisez la catégorie et votre budget"
  }
  if (formProgress.value < 100) {
    return "📅 Plus qu'une étape : définissez la date limite"
  }
  return "🎉 Parfait ! Votre demande est prête à être publiée"
})

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
const selectItem = (item) => {
  selectedCategory.value = item;
  missionData.value.categoryId = item.id;
  isOpen.value = false;
};

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

// Submit request with category validation
const submitRequest = async () => {
  if (!validateForm()) {
    showStatus('Veuillez corriger les erreurs dans le formulaire', 'error');
    return;
  }
  
  // Vérifier si la catégorie existe
  const selectedCategory = professions.value.find(p => p.id === missionData.value.categoryId);
  if (!selectedCategory) {
    showStatus('Veuillez sélectionner une catégorie valide', 'error');
    return;
  }
  
  isSubmitting.value = true;
  
  try {
    const { data, error } = await supabase
      .from('missions')
      .insert([
        {
          title: missionData.value.title,
          description: missionData.value.description,
          profession_id: missionData.value.categoryId,
          budget: missionData.value.budget,
          deadline: missionData.value.deadline,
          status: 'open'
        }
      ])
      .select()
      .single();

    if (error) throw error;
    
    showStatus('Votre demande a été publiée avec succès !', 'success');
    
    // Redirection après un court délai
    setTimeout(() => {
      router.push('/requests');
    }, 1500);
    
  } catch (error) {
    console.error('Error submitting request:', error);
    showStatus('Une erreur est survenue lors de la publication', 'error');
  } finally {
    isSubmitting.value = false;
  }
};

// Lifecycle hooks
onMounted(() => {
  const handleClickOutside = (event) => {
    if (dropdownRef.value && !dropdownRef.value.contains(event.target)) {
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

// Computed for filtered professions
const filteredItems = computed(() => {
  if (!search.value) return professions.value
  
  const query = search.value.toLowerCase()
  return professions.value.filter(profession => 
    profession.name.toLowerCase().includes(query)
  )
})
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