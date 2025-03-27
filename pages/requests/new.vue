<template>
  <div class="min-h-screen bg-gray-50 dark:bg-gray-900">
    <!-- Header fixe -->
    <header class="sticky top-0 z-10 bg-white dark:bg-gray-800 border-b border-gray-200 dark:border-gray-700">
      <div class="max-w-2xl mx-auto px-4 py-3 flex items-center justify-between">
        <div class="flex items-center gap-3">
          <button 
            @click="$router.back()" 
            class="p-2 -ml-2 rounded-full hover:bg-gray-100 dark:hover:bg-gray-700"
          >
            <v-icon name="bi-arrow-left" scale="1.2" />
          </button>
          <div>
            <h1 class="text-xl font-bold text-gray-900 dark:text-white">Nouvelle mission</h1>
            <p class="text-sm text-gray-500 dark:text-gray-400">Créez votre demande</p>
          </div>
        </div>
        
        <button
          @click="submitRequest"
          :disabled="isSubmitting || !isFormValid"
          class="inline-flex items-center px-4 py-2 rounded-full text-white font-medium transition-all"
          :class="[
            isSubmitting || !isFormValid 
              ? 'bg-gray-300 dark:bg-gray-600 cursor-not-allowed' 
              : 'bg-primary-600 hover:bg-primary-700'
          ]"
        >
          <v-icon 
            v-if="isSubmitting"
            name="bi-arrow-repeat" 
            class="animate-spin mr-2"
          />
          {{ isSubmitting ? 'Publication...' : 'Publier' }}
        </button>
      </div>
    </header>

    <main class="max-w-2xl mx-auto px-4 py-6">
      <!-- Introduction -->
      <div class="mb-8 text-center">
        <h2 class="text-2xl font-bold text-gray-900 dark:text-white mb-2">
          Que voulez-vous faire réaliser ?
        </h2>
        <p class="text-gray-600 dark:text-gray-400">
          Décrivez votre projet en détail pour trouver le meilleur expert
        </p>
      </div>

      <!-- Étapes de progression -->
      <div class="flex items-center justify-between mb-8 px-4">
        <div class="flex-1 relative">
          <div 
            class="h-1 bg-primary-600"
            :style="{ width: `${formProgress}%` }"
          />
          <div class="absolute h-1 w-full bg-gray-200 dark:bg-gray-700 -z-10" />
        </div>
        <span class="ml-4 text-sm font-medium text-primary-600 dark:text-primary-400">
          {{ formProgress }}%
        </span>
      </div>

      <!-- Formulaire -->
      <form @submit.prevent="submitRequest" class="space-y-6">
        <!-- Titre -->
        <div class="facebook-input-group">
          <div class="relative">
            <input
              v-model="missionData.title"
              type="text"
              :id="'title'"
              class="facebook-input peer pt-6"
              :class="{ 'error': formErrors.title }"
              placeholder=" "
              maxlength="100"
              required
            />
            <label 
              :for="'title'" 
              class="facebook-label"
            >
              Titre de la mission
            </label>
          </div>
          <div class="facebook-hints">
            <span class="text-xs text-gray-500">
              Ex: "Création d'un logo pour ma startup"
            </span>
            <span class="text-xs text-gray-400">
              {{ missionData.title.length }}/100
            </span>
          </div>
          <p v-if="formErrors.title" class="facebook-error">
            {{ formErrors.title }}
          </p>
        </div>

        <!-- Description -->
        <div class="facebook-input-group">
          <div class="relative">
            <textarea
              v-model="missionData.description"
              :id="'description'"
              class="facebook-input peer pt-6"
              :class="{ 'error': formErrors.description }"
              placeholder=" "
              maxlength="1000"
              rows="4"
              required
            />
            <label 
              :for="'description'" 
              class="facebook-label"
            >
              Description détaillée
            </label>
          </div>
          <div class="facebook-hints">
            <span class="text-xs text-gray-500">
              Soyez précis pour obtenir les meilleures propositions
            </span>
            <span class="text-xs text-gray-400">
              {{ missionData.description.length }}/1000
            </span>
          </div>
          <p v-if="formErrors.description" class="facebook-error">
            {{ formErrors.description }}
          </p>
        </div>

        <!-- Catégorie -->
        <div class="facebook-input-group">
          <div class="relative">
            <select
              v-model="missionData.categoryId"
              :id="'category'"
              class="facebook-input peer"
              :class="{ 'error': formErrors.categoryId }"
              :disabled="isLoadingCategories"
              required
            >
              <option value="" disabled selected> </option>
              <option 
                v-for="profession in professions" 
                :key="profession.id" 
                :value="profession.id"
                class="py-2"
              >
                {{ profession.name }}
              </option>
            </select>
            <label 
              :for="'category'" 
              class="facebook-label"
            >
              Catégorie
            </label>
            <div class="absolute inset-y-0 right-0 flex items-center pr-3 pointer-events-none">
              <v-icon 
                :name="isLoadingCategories ? 'bi-arrow-repeat' : 'bi-chevron-down'"
                :class="{ 'animate-spin': isLoadingCategories }"
                class="text-gray-400"
              />
            </div>
          </div>
          <p v-if="formErrors.categoryId" class="facebook-error">
            {{ formErrors.categoryId }}
          </p>
        </div>

        <!-- Budget et Deadline -->
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <!-- Budget -->
          <div class="facebook-input-group">
            <div class="relative">
              <input
                v-model="missionData.budget"
                type="number"
                :id="'budget'"
                class="facebook-input peer pt-6 appearance-none"
                :class="{ 'error': formErrors.budget }"
                placeholder=" "
                min="0"
                required
              />
              <label 
                :for="'budget'" 
                class="facebook-label"
              >
                Budget (FCFA)
              </label>
            </div>
            <div class="facebook-hints">
              <span class="text-xs text-gray-500">
                Ex: 50000
              </span>
            </div>
            <p v-if="formErrors.budget" class="facebook-error">
              {{ formErrors.budget }}
            </p>
          </div>

          <!-- Deadline -->
          <div class="facebook-input-group">
            <div class="relative">
              <input
                v-model="missionData.deadline"
                type="date"
                :id="'deadline'"
                class="facebook-input peer"
                :class="{ 'error': formErrors.deadline }"
                :min="minDate"
                required
              />
              <label 
                :for="'deadline'" 
                class="facebook-label"
              >
                Date limite
              </label>
            </div>
            <div class="facebook-hints">
              <span class="text-xs text-gray-500">
                Date souhaitée de réalisation
              </span>
            </div>
            <p v-if="formErrors.deadline" class="facebook-error">
              {{ formErrors.deadline }}
            </p>
          </div>
        </div>
      </form>

      <!-- Message d'aide contextuel -->
      <div class="mt-6 p-4 bg-blue-50 dark:bg-blue-900/20 rounded-lg">
        <p class="text-sm text-blue-700 dark:text-blue-400">
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
const showCategoryDropdown = ref(false);
const selectedCategory = ref(null);
const professions = ref([]);
const isLoadingCategories = ref(true);

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

// Toggle category dropdown
const toggleCategoryDropdown = () => {
  showCategoryDropdown.value = !showCategoryDropdown.value;
  
  // Si on ouvre le dropdown et que les catégories ne sont pas encore chargées
  if (showCategoryDropdown.value && professions.value.length === 0 && !isLoadingCategories.value) {
    fetchProfessions();
  }
};

// Close dropdown when clicking outside
const handleClickOutside = (event) => {
  const dropdownContainer = document.querySelector('.dropdown-container');
  if (showCategoryDropdown.value && dropdownContainer && !dropdownContainer.contains(event.target)) {
    showCategoryDropdown.value = false;
  }
};

// Select category
const selectCategory = (category) => {
  selectedCategory.value = category;
  missionData.value.categoryId = category.id;
  showCategoryDropdown.value = false;
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
  document.addEventListener('click', handleClickOutside);
  fetchProfessions();
});

onBeforeUnmount(() => {
  document.removeEventListener('click', handleClickOutside);
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
</script>

<style scoped>
.facebook-input-group {
  @apply space-y-1;
}

.facebook-input {
  @apply block w-full px-4 pb-1 rounded-lg border border-gray-300 dark:border-gray-600
         bg-white dark:bg-gray-800 text-gray-900 dark:text-white
         focus:border-primary-500 focus:ring-1 focus:ring-primary-500
         disabled:bg-gray-100 dark:disabled:bg-gray-700
         transition-colors duration-200;
}

.facebook-input.error {
  @apply border-red-500 focus:border-red-500 focus:ring-red-500;
}

.facebook-label {
  @apply absolute left-4 top-2 text-gray-500 dark:text-gray-400
         transition-all duration-200 transform
         pointer-events-none text-base
         peer-focus:text-primary-500 peer-focus:text-xs
         peer-[:not(:placeholder-shown)]:text-xs;
}

.facebook-hints {
  @apply flex justify-between items-center mt-1 px-1;
}

.facebook-error {
  @apply text-sm text-red-500 dark:text-red-400 mt-1 px-1;
}

/* Style spécial pour l'input date en mode dark */
.facebook-input[type="date"] {
  @apply pt-6;
}

/* Style pour le select */
select.facebook-input {
  @apply pt-6 pl-2;
}

/* Style pour le placeholder du select */
select.facebook-input option[value=""][disabled] {
  @apply text-transparent;
}

/* Ajustement pour textarea */
textarea.facebook-input {
  @apply min-h-[120px] resize-none;
}

/* Ajout d'animations pour les transitions */
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
</style>