<template>
  <div class="min-h-screen bg-white dark:bg-gray-900">
    <!-- Twitter-style sticky header with blur effect -->
    <header class="sticky top-0 z-10 bg-white/90 dark:bg-gray-900/90 backdrop-blur-sm border-b border-gray-100 dark:border-gray-800">
      <div class="max-w-2xl mx-auto px-4 py-3 flex items-center justify-between">
        <div class="flex items-center">
          <button 
            @click="$router.back()" 
            class="p-2 -ml-2 rounded-full hover:bg-gray-100 dark:hover:bg-gray-800 transition-colors"
            aria-label="Retour"
          >
            <svg class="w-5 h-5 text-gray-800 dark:text-gray-200" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M15 19l-7-7 7-7" />
            </svg>
          </button>
          <h1 class="ml-6 text-xl font-bold text-gray-900 dark:text-white">Nouvelle demande</h1>
        </div>
        
        <!-- Twitter-style submit button in header -->
        <button
          type="button"
          @click="submitRequest"
          :disabled="isSubmitting"
          class="py-1.5 px-4 rounded-full text-white font-medium transition-colors shadow-sm"
          :class="!isSubmitting ? 'bg-primary-600 hover:bg-primary-700' : 'bg-primary-300 dark:bg-primary-800 cursor-not-allowed'"
        >
          <span v-if="isSubmitting" class="flex items-center">
            <svg class="animate-spin -ml-1 mr-2 h-4 w-4 text-white" fill="none" viewBox="0 0 24 24">
              <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
              <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
            </svg>
            Publication...
          </span>
          <span v-else>Publier</span>
        </button>
      </div>
    </header>

    <!-- Main content with Twitter style -->
    <main class="max-w-2xl mx-auto px-4 py-6">
      <!-- Status message with Twitter style -->
      <div v-if="statusMessage" 
        class="mb-6 p-4 rounded-xl text-sm flex items-center"
        :class="statusType === 'error' ? 'bg-red-50 dark:bg-red-900/20 text-red-700 dark:text-red-400 border border-red-100 dark:border-red-800/40' : 'bg-blue-50 dark:bg-blue-900/20 text-blue-700 dark:text-blue-400 border border-blue-100 dark:border-blue-800/40'"
      >
        <span v-if="statusType === 'error'" class="mr-2 flex-shrink-0">
          <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
          </svg>
        </span>
        <span v-else class="mr-2 flex-shrink-0">
          <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
          </svg>
        </span>
        {{ statusMessage }}
      </div>

      <!-- Twitter-style form layout -->
      <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 overflow-hidden">
        <form @submit.prevent="submitRequest">
          <!-- Title input with Twitter style -->
          <div class="p-4 border-b border-gray-100 dark:border-gray-700">
            <TwitterInput
              id="title"
              v-model="requestData.title"
              placeholder="Titre de votre demande"
              maxLength="100"
              showCount
              required
            />
          </div>
          
          <!-- Description textarea with Twitter style -->
          <div class="p-4 border-b border-gray-100 dark:border-gray-700">
            <TwitterInput
              id="description"
              v-model="requestData.description"
              placeholder="Décrivez votre besoin en détail..."
              type="textarea"
              rows="4"
              maxLength="1000"
              showCount
              required
            />
          </div>
          
          <!-- Category selection with Google-style dropdown -->
          <div class="p-4 border-b border-gray-100 dark:border-gray-700">
            <div class="mb-2 text-sm font-medium text-gray-700 dark:text-gray-300">
              Catégorie <span class="text-red-500">*</span>
            </div>
            <div class="relative">
              <select
                v-model="requestData.categoryId"
                @change="updateSelectedCategory"
                class="w-full appearance-none bg-white dark:bg-gray-800 border border-gray-300 dark:border-gray-700 rounded-xl px-4 py-3 pr-10 text-gray-900 dark:text-white focus:border-primary-500 focus:outline-none transition-colors"
                :class="{'text-gray-500 dark:text-gray-400': !requestData.categoryId}"
              >
                <option value="" disabled selected>Sélectionnez une catégorie</option>
                <option 
                  v-for="category in categories" 
                  :key="category.id" 
                  :value="category.id"
                  >
                  {{ category.name }}
                </option>
              </select>
              
              <!-- Custom dropdown arrow -->
              <div class="pointer-events-none absolute inset-y-0 right-0 flex items-center px-4 text-gray-400">
                <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
                </svg>
              </div>
              
            
            </div>
          </div>
          
          <!-- Budget field with Twitter style -->
          <div class="p-4 border-b border-gray-100 dark:border-gray-700">
            <TwitterInput
              id="budget"
              v-model="requestData.budget"
              placeholder="Budget (FCFA)"
              type="number"
              required
            />
            <div class="mt-1 text-xs text-gray-500 dark:text-gray-400 px-1">
               - Indiquez votre budget approximatif
            </div>
          </div>
          
          <!-- Deadline field with Twitter style -->
          <div class="p-4">
            <TwitterInput
              id="deadline"
              v-model="requestData.deadline"
              placeholder="Date limite"
              type="date"
              required
            />
            <div class="mt-1 text-xs text-gray-500 dark:text-gray-400 px-1">
               - Date souhaitée pour la réalisation
            </div>
          </div>
        </form>
      </div>
      
      <!-- Form progress indicator with Twitter style -->
      <div class="mt-6 bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 p-4">
        <div class="flex items-center justify-between mb-2">
          <span class="text-sm font-medium text-gray-700 dark:text-gray-300">Progression</span>
          <span class="text-sm font-medium text-primary-600 dark:text-primary-400">{{ formProgress }}%</span>
        </div>
        <div class="w-full bg-gray-200 dark:bg-gray-700 rounded-full h-2.5">
          <div 
            class="bg-primary-600 h-2.5 rounded-full transition-all duration-500"
            :style="{ width: `${formProgress}%` }"
          ></div>
        </div>
        <p class="mt-2 text-xs text-gray-500 dark:text-gray-400">
          {{ formProgressMessage }}
        </p>
      </div>
    </main>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onBeforeUnmount, watch } from 'vue';
import { useRouter } from 'vue-router';
import TwitterInput from '~/components/ui/TwitterInput.vue';

const router = useRouter();
const supabase = useSupabaseClient();

// Form data
const requestData = ref({
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
const categories = ref([]);
const isLoadingCategories = ref(true);

// Show status message
const showStatus = (message, type = 'info') => {
  statusMessage.value = message;
  statusType.value = type;
  
  // Auto-hide after 5 seconds
  setTimeout(() => {
    statusMessage.value = '';
  }, 5000);
};

// Form validation
const isFormValid = computed(() => {
  return (
    requestData.value.title.trim() !== '' &&
    requestData.value.description.trim() !== '' &&
    requestData.value.categoryId !== null
  );
});

// Calculate form progress
const formProgress = computed(() => {
  let progress = 0;
  
  if (requestData.value.title.trim() !== '') progress += 30;
  if (requestData.value.description.trim() !== '') progress += 30;
  if (requestData.value.categoryId !== null) progress += 30;
  if (requestData.value.budget !== '' || requestData.value.deadline !== '') progress += 10;
  
  return progress;
});

// Form progress message
const formProgressMessage = computed(() => {
  if (formProgress.value < 30) return 'Commencez par ajouter un titre à votre demande';
  if (formProgress.value < 60) return 'Décrivez votre besoin en détail';
  if (formProgress.value < 90) return 'Sélectionnez une catégorie pour votre demande';
  if (formProgress.value < 100) return 'Ajoutez des informations supplémentaires (optionnel)';
  return 'Votre demande est prête à être publiée !';
});

// Toggle category dropdown
const toggleCategoryDropdown = () => {
  showCategoryDropdown.value = !showCategoryDropdown.value;
  
  // Si on ouvre le dropdown et que les catégories ne sont pas encore chargées
  if (showCategoryDropdown.value && categories.value.length === 0 && !isLoadingCategories.value) {
    fetchCategories();
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
  requestData.value.categoryId = category.id;
  showCategoryDropdown.value = false;
};

// Fetch categories
const fetchCategories = async () => {
  isLoadingCategories.value = true;
  
  try {
    // Simulate API call
    await new Promise(resolve => setTimeout(resolve, 500));
    
    categories.value = [
      { id: 1, name: 'Développement web', color: '#3B82F6' },
      { id: 2, name: 'Design graphique', color: '#EC4899' },
      { id: 3, name: 'Marketing digital', color: '#10B981' },
      { id: 4, name: 'Rédaction', color: '#F59E0B' },
      { id: 5, name: 'Traduction', color: '#8B5CF6' }
    ];
  } catch (error) {
    console.error('Error fetching categories:', error);
    showStatus('Impossible de charger les catégories. Veuillez réessayer.', 'error');
  } finally {
    isLoadingCategories.value = false;
  }
};

// Submit request
const submitRequest = async () => {
  if (!isFormValid.value) {
    showStatus('Veuillez remplir tous les champs obligatoires.', 'error');
    return;
  }
  
  isSubmitting.value = true;
  
  try {
    // Simulate API call
    await new Promise(resolve => setTimeout(resolve, 1500));
    
    showStatus('Votre demande a été publiée avec succès !', 'info');
    
    // Reset form
    requestData.value = {
      title: '',
      description: '',
      categoryId: null,
      budget: '',
      deadline: ''
    };
    selectedCategory.value = null;
    
    // Redirect to requests page after a short delay
    setTimeout(() => {
      router.push('/requests');
    }, 1500);
    
  } catch (error) {
    console.error('Error submitting request:', error);
    showStatus('Une erreur est survenue lors de la publication de votre demande.', 'error');
  } finally {
    isSubmitting.value = false;
  }
};

// Lifecycle hooks
onMounted(() => {
  document.addEventListener('click', handleClickOutside);
  // Préchargement des catégories au montage du composant
  fetchCategories();
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
  const categoryId = requestData.value.categoryId;
  if (categoryId) {
    selectedCategory.value = categories.value.find(cat => cat.id === categoryId);
  } else {
    selectedCategory.value = null;
  }
};

// Watch for categories loaded to update selected category if needed
watch(categories, () => {
  if (requestData.value.categoryId) {
    updateSelectedCategory();
  }
}, { deep: true });
</script>

<style scoped>
/* Animation for dropdown */
@keyframes slideDown {
  from { 
    opacity: 0;
    transform: translateY(-10px);
  }
  to { 
    opacity: 1;
    transform: translateY(0);
  }
}

.animate-slide-down {
  animation: slideDown 0.2s ease-out forwards;
}

/* Smooth transition effects */
button, a, input, select, textarea, .transition-colors {
  transition: all 0.2s ease;
}

/* Twitter-style ripple effect for buttons */
button:not(:disabled) {
  position: relative;
  overflow: hidden;
}

button:not(:disabled):after {
  content: "";
  display: block;
  position: absolute;
  top: 50%;
  left: 50%;
  width: 5px;
  height: 5px;
  background: rgba(255, 255, 255, 0.3);
  opacity: 0;
  border-radius: 100%;
  transform: scale(1, 1) translate(-50%);
  transform-origin: 50% 50%;
}

button:not(:disabled):active:after {
  animation: ripple 0.6s ease-out;
}

@keyframes ripple {
  0% {
    transform: scale(0, 0);
    opacity: 0.5;
  }
  100% {
    transform: scale(25, 25);
    opacity: 0;
  }
}
</style>