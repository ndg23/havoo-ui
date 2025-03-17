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
            <input
              id="title"
              v-model="requestData.title"
              type="text"
              required
              maxlength="100"
              class="floating-input rounded-full"
              :class="{ 'has-value': requestData.title }"
            />
            <label for="title" class="floating-label">Titre de votre demande</label>
          </div>
          <div class="mt-1 text-xs text-gray-500 flex justify-between px-3">
            <span>Soyez précis et concis</span>
            <span>{{ requestData.title.length }}/100</span>
          </div>
        </div>

        <!-- Category selection -->
        <div>
          <div class="text-base font-medium mb-2">Catégorie</div>
          <div class="relative">
            <button
              type="button"
              @click="showCategoryDropdown = !showCategoryDropdown"
              class="w-full flex items-center justify-between px-4 py-3 border border-gray-300 rounded-full bg-white text-left focus:outline-none focus:ring-1 focus:ring-primary-500 focus:border-primary-500 transition-colors"
            >
              <span class="text-base" :class="selectedCategory ? 'text-black' : 'text-gray-500'">
                {{ selectedCategory ? selectedCategory.name : 'Sélectionnez une catégorie' }}
              </span>
              <svg class="w-5 h-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
              </svg>
            </button>
            
            <!-- Dropdown -->
            <div v-if="showCategoryDropdown" class="absolute mt-2 w-full bg-white rounded-2xl shadow-lg border border-gray-200 z-10 py-1 max-h-60 overflow-y-auto">
              <div 
                v-for="category in categories" 
                :key="category.id"
                @click="selectCategory(category); showCategoryDropdown = false"
                class="px-4 py-2.5 hover:bg-gray-50 cursor-pointer flex items-center transition-colors"
              >
                <div class="w-5 h-5 rounded-full mr-3" :style="`background-color: ${category.color}`"></div>
                <span>{{ category.name }}</span>
              </div>
            </div>
          </div>
        </div>

        <!-- Description textarea -->
        <div class="relative">
          <div class="floating-input-container">
            <textarea
              id="description"
              v-model="requestData.description"
              rows="5"
              required
              class="floating-textarea rounded-3xl"
              :class="{ 'has-value': requestData.description }"
            ></textarea>
            <label for="description" class="floating-label">Description détaillée</label>
          </div>
          <div class="mt-1 text-xs text-gray-500 flex px-3">
            <span>Décrivez précisément votre besoin</span>
          </div>
        </div>

        <!-- Budget field -->
        <div class="relative">
          <div class="floating-input-container">
            <input
              id="budget"
              v-model="requestData.budget"
              type="number"
              min="0"
              class="floating-input rounded-full"
              :class="{ 'has-value': requestData.budget }"
            />
            <label for="budget" class="floating-label">Budget (€)</label>
          </div>
          <div class="mt-1 text-xs text-gray-500 px-3">
            <span>Optionnel - Indiquez votre budget approximatif</span>
          </div>
        </div>

        <!-- Deadline field -->
        <div class="relative">
          <div class="floating-input-container">
            <input
              id="deadline"
              v-model="requestData.deadline"
              type="date"
              class="floating-input rounded-full"
              :class="{ 'has-value': requestData.deadline }"
            />
            <label for="deadline" class="floating-label">Date limite</label>
          </div>
          <div class="mt-1 text-xs text-gray-500 px-3">
            <span>Optionnel - Date souhaitée pour la réalisation</span>
          </div>
        </div>

        <!-- Attachment section -->
        <div class="pt-2">
          <div class="text-base font-medium mb-2">Documents ou images</div>
          <div 
            @dragover.prevent
            @drop.prevent="handleFileDrop"
            class="border-2 border-dashed border-gray-300 rounded-2xl p-6 text-center hover:border-primary-400 transition-colors"
          >
            <div class="space-y-2">
              <svg class="mx-auto h-10 w-10 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12" />
              </svg>
              <div class="text-sm text-gray-600">
                <label for="file-upload" class="relative cursor-pointer text-primary-600 hover:text-primary-500">
                  <span>Télécharger un fichier</span>
                  <input 
                    id="file-upload" 
                    name="file-upload" 
                    type="file" 
                    class="sr-only" 
                    multiple
                    @change="handleFileChange"
                  />
                </label>
                <span class="text-gray-500"> ou glisser-déposer</span>
              </div>
              <p class="text-xs text-gray-500">
                PNG, JPG, PDF jusqu'à 10MB
              </p>
            </div>
          </div>
          
          <!-- File preview -->
          <div v-if="files.length > 0" class="mt-4 space-y-2">
            <div 
              v-for="(file, index) in files" 
              :key="index"
              class="flex items-center justify-between py-2 px-3 bg-gray-50 rounded-full"
            >
              <div class="flex items-center overflow-hidden">
                <svg class="flex-shrink-0 h-5 w-5 text-gray-400 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.172 7l-6.586 6.586a2 2 0 102.828 2.828l6.414-6.586a4 4 0 00-5.656-5.656l-6.415 6.585a6 6 0 108.486 8.486L20.5 13" />
                </svg>
                <span class="text-sm truncate">{{ file.name }}</span>
              </div>
              <button 
                type="button" 
                @click="removeFile(index)"
                class="ml-2 flex-shrink-0 text-gray-500 hover:text-red-500"
              >
                <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                </svg>
              </button>
            </div>
          </div>
        </div>

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
    </main>
  </div>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount } from 'vue';
import { useRouter } from 'vue-router';
// import { useSupabaseClient } from '@supabase/auth-helpers-vue';

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

// Mock categories
const categories = ref([
  { id: 1, name: 'Développement web', color: '#3B82F6' },
  { id: 2, name: 'Design graphique', color: '#EC4899' },
  { id: 3, name: 'Marketing digital', color: '#10B981' },
  { id: 4, name: 'Rédaction', color: '#F59E0B' },
  { id: 5, name: 'Traduction', color: '#8B5CF6' },
  { id: 6, name: 'SEO', color: '#EF4444' },
]);

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
        user_id: user.id,
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
  if (showCategoryDropdown.value && !event.target.closest('.dropdown-container')) {
    showCategoryDropdown.value = false;
  }
};

onMounted(() => {
  document.addEventListener('click', handleClickOutside);
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