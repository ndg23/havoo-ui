<template>
  <div class="min-h-screen bg-white">
    <!-- Simple header -->
    <header class="sticky top-0 z-10 bg-white/80 backdrop-blur-sm border-b border-gray-100">
      <div class="max-w-2xl mx-auto px-4 py-3 flex items-center justify-between">
        <div class="flex items-center">
          <button 
            @click="$router.back()" 
            class="p-2 -ml-2 rounded-full hover:bg-gray-100 transition-colors"
          >
            <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M15 19l-7-7 7-7" />
            </svg>
          </button>
          <h1 class="ml-6 text-xl font-bold">Nouvelle demande</h1>
        </div>
      </div>
    </header>

    <!-- Main content -->
    <main class="max-w-2xl mx-auto px-4 py-6">
      <!-- Status message -->
      <div v-if="statusMessage" 
        class="mb-6 p-3 rounded-full text-sm flex items-center"
        :class="statusType === 'error' ? 'bg-red-50 text-red-700' : 'bg-blue-50 text-blue-700'"
      >
        <span v-if="statusType === 'error'" class="mr-2">
          <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
          </svg>
        </span>
        <span v-else class="mr-2">
          <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
          </svg>
        </span>
        {{ statusMessage }}
      </div>

      <form @submit.prevent="submitRequest" class="space-y-6">
        <!-- Title input -->
        <div class="relative">
          <div class="floating-input-container">
            <FloatingLabelInput
              id="title"
              label="Titre de la demande"
              v-model="requestData.title"
              required
              placeholder="Décrivez brièvement votre besoin"
            />
          </div>
          <div class="mt-1 text-xs text-gray-500 flex justify-between px-3">
            <span>Soyez précis et concis</span>
            <span>{{ requestData.title.length }}/100</span>
          </div>
        </div>

        <!-- Category selection with cleaner style -->
        <div class="relative dropdown-container">
          <div class="floating-input-container">
            <div 
              class="w-full border border-gray-300 rounded-lg px-4 py-3.5 bg-white transition-all focus-within:outline-none focus-within:border-primary-500 focus-within:ring-2 focus-within:ring-primary-500 focus-within:ring-opacity-30 relative"
              :class="{'border-primary-500 ring-2 ring-primary-500 ring-opacity-30': showCategoryDropdown}"
            >
              <label 
                for="category" 
                class="absolute text-sm text-gray-500 duration-300 transform -translate-y-4 scale-75 top-4 z-10 origin-[0] left-4 peer-focus:text-primary-600 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-4 bg-white px-1"
                :class="{'text-primary-600': selectedCategory || showCategoryDropdown}"
              >
                Catégorie
              </label>
              
              <button
                id="category"
                type="button"
                @click="showCategoryDropdown = !showCategoryDropdown"
                class="w-full text-left focus:outline-none flex items-center justify-between h-full"
              >
                <span class="text-base" :class="selectedCategory ? 'text-black' : 'text-gray-400'">
                  {{ selectedCategory ? selectedCategory.name : 'Sélectionnez une catégorie' }}
                </span>
                <svg class="w-5 h-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
                </svg>
              </button>
            </div>
            
            <!-- Dropdown with simplified design -->
            <div 
              v-if="showCategoryDropdown"
              class="absolute mt-1 w-full bg-white rounded-lg shadow-lg border border-gray-200 z-10 py-1 max-h-60 overflow-y-auto"
            >
              <div v-if="isLoadingCategories" class="px-4 py-3 text-center text-gray-500">
                <svg class="animate-spin h-5 w-5 mx-auto mb-1" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                  <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                  <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                </svg>
                Chargement...
              </div>
              
              <div v-else-if="categories.length === 0" class="px-4 py-3 text-center text-gray-500">
                Aucune catégorie disponible
              </div>
              
              <div 
                v-else
                v-for="category in categories" 
                :key="category.id"
                @click="selectCategory(category); showCategoryDropdown = false"
                class="px-4 py-2 hover:bg-gray-50 cursor-pointer transition-colors"
              >
                <span>{{ category.name }}</span>
              </div>
            </div>
          </div>
          <div class="mt-1 text-xs text-gray-500 px-3">
            <span>Choisissez la catégorie qui correspond le mieux à votre demande</span>
          </div>
        </div>

        <!-- Description textarea -->
        <div class="relative">
          <div class="floating-input-container">
            <FloatingLabelInput
              id="description"
              label="Description"
              v-model="requestData.description"
              required
              placeholder="Décrivez en détail votre besoin..."
              rows="5"
            />
          </div>
          <div class="mt-1 text-xs text-gray-500 flex px-3">
            <span>Décrivez précisément votre besoin</span>
          </div>
        </div>

        <!-- Budget field -->
        <div class="relative">
          <div class="floating-input-container">
            <FloatingLabelInput
              id="budget"
              label="Budget (FCFA)"
              type="number"
              v-model="requestData.budget"
              min="0"
              step="10"
              required
            />
          </div>
          <div class="mt-1 text-xs text-gray-500 px-3">
            <span>Optionnel - Indiquez votre budget approximatif</span>
          </div>
        </div>

        <!-- Deadline field -->
        <div class="relative">
          <div class="floating-input-container">
            <FloatingLabelInput
              id="deadline"
              label="Date limite"
              type="date"
              v-model="requestData.deadline"
              :min="minDate"
              required
            />
          </div>
          <div class="mt-1 text-xs text-gray-500 px-3">
            <span>Optionnel - Date souhaitée pour la réalisation</span>
          </div>
        </div>

        <!-- Attachment section -->
        <!--  -->

        <!-- Submit button -->
        <div class="pt-4">
          <button
            type="submit"
            :disabled="isSubmitting"
            class="w-full py-3.5 px-4 flex justify-center items-center rounded-full text-white bg-black hover:bg-gray-800 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-gray-800 text-base font-medium transition-colors"
          >
            <svg v-if="isSubmitting" class="animate-spin -ml-1 mr-3 h-5 w-5 text-white" fill="none" viewBox="0 0 24 24">
              <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
              <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
            </svg>
            Publier ma demande
          </button>
        </div>
      </form>

      <!-- Bouton de débogage temporaire -->
     
    </main>
  </div>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount, computed } from 'vue';
import { useRouter } from 'vue-router';
// import { useSupabaseClient } from '@supabase/auth-helpers-vue';
import FloatingLabelInput from '~/components/ui/FloatingLabelInput.vue'

const router = useRouter();
const supabase = useSupabaseClient();

// Form data
const requestData = ref({
  title: '',
  categoryId: null,
  description: '',
  budget: '',
  deadline: '',
});

// UI state
const isSubmitting = ref(false);
const statusMessage = ref('');
const statusType = ref('');
const selectedCategory = ref(null);
const showCategoryDropdown = ref(false);
const files = ref([]);

// Categories from Supabase
const categories = ref([]);
const isLoadingCategories = ref(true);

// Fetch categories from Supabase
const fetchCategories = async () => {
  isLoadingCategories.value = true;
  categories.value = []; // Réinitialiser les catégories
  
  try {
    console.log('Fetching categories...');
    const { data, error } = await supabase
      .from('categories')
      .select('*')
      .order('name');
      
    if (error) {
      console.error('Error fetching categories:', error);
      throw error;
    }
    
    console.log('Categories data:', data);
    
    if (data && data.length > 0) {
      categories.value = data;
      console.log('Categories loaded:', categories.value);
    } else {
      console.log('No categories found, using fallback');
      // Fallback to default categories if none found
      categories.value = [
        { id: 1, name: 'Développement web', color: '#3B82F6' },
        { id: 2, name: 'Design graphique', color: '#EC4899' },
        { id: 3, name: 'Marketing digital', color: '#10B981' },
        { id: 4, name: 'Rédaction', color: '#F59E0B' },
        { id: 5, name: 'Traduction', color: '#8B5CF6' },
        { id: 6, name: 'SEO', color: '#EF4444' },
      ];
    }
  } catch (error) {
    console.error('Error in fetchCategories:', error);
    // Fallback to default categories
    categories.value = [
      { id: 1, name: 'Développement web', color: '#3B82F6' },
      { id: 2, name: 'Design graphique', color: '#EC4899' },
      { id: 3, name: 'Marketing digital', color: '#10B981' },
      { id: 4, name: 'Rédaction', color: '#F59E0B' },
      { id: 5, name: 'Traduction', color: '#8B5CF6' },
      { id: 6, name: 'SEO', color: '#EF4444' },
    ];
  } finally {
    isLoadingCategories.value = false;
    console.log('Categories loading complete. Count:', categories.value.length);
  }
};

// Date minimum (aujourd'hui)
const minDate = computed(() => {
  const today = new Date()
  return today.toISOString().split('T')[0]
})

// Functions
const selectCategory = (category) => {
  selectedCategory.value = category;
  requestData.value.categoryId = category.id;
};

const handleFileChange = (event) => {
  const newFiles = Array.from(event.target.files);
  
  // Validate file size (10MB max)
  const validFiles = newFiles.filter(file => file.size <= 10 * 1024 * 1024);
  
  if (validFiles.length < newFiles.length) {
    showStatus('Certains fichiers dépassent la limite de 10MB', 'error');
  }
  
  files.value = [...files.value, ...validFiles];
};

const handleFileDrop = (event) => {
  const newFiles = Array.from(event.dataTransfer.files);
  
  // Validate file size (10MB max)
  const validFiles = newFiles.filter(file => file.size <= 10 * 1024 * 1024);
  
  if (validFiles.length < newFiles.length) {
    showStatus('Certains fichiers dépassent la limite de 10MB', 'error');
  }
  
  files.value = [...files.value, ...validFiles];
};

const removeFile = (index) => {
  files.value.splice(index, 1);
};

const showStatus = (message, type = 'info') => {
  statusMessage.value = message;
  statusType.value = type;
  
  setTimeout(() => {
    statusMessage.value = '';
  }, 5000);
};

const submitRequest = async () => {
  // Validate form
  if (!requestData.value.title) {
    return showStatus('Veuillez indiquer un titre', 'error');
  }
  
  if (!requestData.value.categoryId) {
    return showStatus('Veuillez sélectionner une catégorie', 'error');
  }
  
  if (!requestData.value.description) {
    return showStatus('Veuillez décrire votre demande', 'error');
  }
  
  // Submit form
  isSubmitting.value = true;
  
  try {
    // Get current user
    const { data: { user } } = await supabase.auth.getUser();
    
    if (!user) {
      router.push('/auth/login?redirect=/requests/new');
      return;
    }
    
    // Insert request into database
    const { data, error } = await supabase
      .from('requests')
      .insert({
        title: requestData.value.title,
        description: requestData.value.description,
        category_id: requestData.value.categoryId,
        budget: requestData.value.budget || null,
        deadline: requestData.value.deadline || null,
        client_id: user.id,
      })
      .select()
      .single();
    
    if (error) throw error;
    
    // Upload files if any
    if (files.value.length > 0) {
      for (const file of files.value) {
        const fileExt = file.name.split('.').pop();
        const fileName = `${Math.random().toString(36).substring(2)}.${fileExt}`;
        const filePath = `requests/${data.id}/${fileName}`;
        
        const { error: uploadError } = await supabase.storage
          .from('attachments')
          .upload(filePath, file);
          
        if (uploadError) console.error('Error uploading file:', uploadError);
      }
    }
    
    // Show success and redirect
    showStatus('Votre demande a été publiée avec succès!');
    setTimeout(() => {
      router.push(`/requests/${data.id}`);
    }, 1500);
    
  } catch (error) {
    console.error('Error submitting request:', error);
    showStatus(`Erreur: ${error.message || 'Une erreur est survenue'}`, 'error');
  } finally {
    isSubmitting.value = false;
  }
};

// Close dropdown when clicking outside
const handleClickOutside = (event) => {
  const dropdownContainer = document.querySelector('.dropdown-container');
  if (showCategoryDropdown.value && dropdownContainer && !dropdownContainer.contains(event.target)) {
    showCategoryDropdown.value = false;
  }
};

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

// Fonction de débogage temporaire
const debugCategories = () => {
  console.log('Current categories:', categories.value);
  console.log('Loading state:', isLoadingCategories.value);
  console.log('Dropdown visible:', showCategoryDropdown.value);
};

onMounted(() => {
  document.addEventListener('click', handleClickOutside);
  fetchCategories(); // Fetch categories on component mount
});

onBeforeUnmount(() => {
  document.removeEventListener('click', handleClickOutside);
});
</script>

<style scoped>
/* Floating input styles */
.floating-input-container {
  position: relative;
}

.floating-input {
  width: 100%;
  padding: 1rem 1.25rem;
  height: 3.5rem;
  border: 1px solid rgb(209, 213, 219);
  color: rgb(17, 24, 39);
  appearance: none;
  transition: border-color 0.2s ease-in-out, box-shadow 0.2s ease-in-out;
}

.floating-textarea {
  width: 100%;
  padding: 1.25rem;
  min-height: 10rem;
  border: 1px solid rgb(209, 213, 219);
  color: rgb(17, 24, 39);
  appearance: none;
  transition: border-color 0.2s ease-in-out, box-shadow 0.2s ease-in-out;
  resize: vertical;
}

.floating-input:focus,
.floating-textarea:focus {
  outline: none;
  border-color: rgb(79, 70, 229);
  box-shadow: 0 0 0 1px rgb(79, 70, 229);
}

.floating-input:focus + .floating-label,
.floating-input.has-value + .floating-label,
.floating-textarea:focus + .floating-label,
.floating-textarea.has-value + .floating-label {
  transform: translateY(-1.1rem) translateX(0.5rem) scale(0.75);
  background-color: white;
  padding: 0 0.25rem;
  color: rgb(79, 70, 229);
}

.floating-label {
  position: absolute;
  top: 1rem;
  left: 1.25rem;
  color: rgb(107, 114, 128);
  pointer-events: none;
  transform-origin: left top;
  transition: transform 0.15s ease-out, background-color 0.2s ease-out, color 0.15s ease-out;
}
</style>