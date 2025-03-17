<template>
  <div class="min-h-screen bg-white">
    <!-- Header -->
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
          <h1 class="ml-6 text-xl font-bold">Modifier la demande</h1>
        </div>
      </div>
    </header>

    <!-- Main content -->
    <main class="max-w-2xl mx-auto px-4 py-6">
      <!-- Loading state -->
      <div v-if="isLoading" class="flex flex-col items-center justify-center py-12">
        <svg class="animate-spin h-8 w-8 text-gray-400 mb-4" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
          <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
          <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
        </svg>
        <p class="text-gray-500">Chargement de la demande...</p>
      </div>

      <!-- Error state -->
      <div v-else-if="error" class="bg-red-50 p-4 rounded-lg text-red-700 my-6">
        <div class="flex">
          <svg class="h-5 w-5 text-red-400 mr-3" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
          </svg>
          <p>{{ error }}</p>
        </div>
        <button 
          @click="fetchRequest" 
          class="mt-3 text-sm font-medium text-red-600 hover:text-red-500"
        >
          Réessayer
        </button>
      </div>

      <!-- Request form -->
      <form v-else @submit.prevent="updateRequest" class="space-y-6">
        <!-- Title input -->
        <div class="relative">
          <FloatingLabelInput
            id="title"
            label="Titre de la demande"
            v-model="requestData.title"
            required
            placeholder="Décrivez brièvement votre besoin"
          />
          <div class="mt-1 text-xs text-gray-500 flex justify-between px-1">
            <span>Soyez précis et concis</span>
            <span>{{ requestData.title.length }}/100</span>
          </div>
        </div>

        <!-- Category selection -->
        <div class="relative dropdown-container">
          <div class="floating-input-container">
            <div 
              class="w-full border border-gray-300 rounded-lg px-4 py-3.5 bg-white transition-all focus-within:outline-none focus-within:border-primary-500 focus-within:ring-2 focus-within:ring-primary-500 focus-within:ring-opacity-30 relative"
              :class="{'border-primary-500 ring-2 ring-primary-500 ring-opacity-30': showCategoryDropdown}"
            >
              <label 
                for="category" 
                class="absolute text-sm text-gray-500 duration-300 transform -translate-y-4 scale-75 top-4 z-10 origin-[0] left-4 peer-focus:text-primary-600 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-4 bg-white px-1"
                :class="{'text-primary-600': requestData.category_id || showCategoryDropdown}"
              >
                Catégorie
              </label>
              
              <button
                id="category"
                type="button"
                @click="showCategoryDropdown = !showCategoryDropdown"
                class="w-full text-left focus:outline-none flex items-center justify-between h-full"
              >
                <span class="text-base" :class="requestData.category_id ? 'text-black' : 'text-gray-400'">
                  {{ selectedCategoryName || 'Sélectionnez une catégorie' }}
                </span>
                <svg class="w-5 h-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
                </svg>
              </button>
            </div>
            
            <!-- Dropdown -->
            <div 
              v-if="showCategoryDropdown"
              class="absolute mt-1 w-full bg-white rounded-lg shadow-lg border border-gray-200 z-10 py-1 max-h-60 overflow-y-auto"
            >
              <div class="px-3 py-2 sticky top-0 bg-white border-b border-gray-100">
                <input 
                  type="text" 
                  v-model="categorySearch" 
                  placeholder="Rechercher une catégorie..." 
                  class="w-full px-3 py-2 border border-gray-300 rounded-md text-sm focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
                  @click.stop
                />
              </div>
              <div 
                v-for="category in filteredCategories" 
                :key="category.id"
                @click="selectCategory(category.id); showCategoryDropdown = false"
                class="px-4 py-2 hover:bg-gray-50 cursor-pointer transition-colors"
              >
                <span>{{ category.name }}</span>
              </div>
            </div>
          </div>
        </div>

        <!-- Description -->
        <div class="relative">
          <FloatingLabelInput
            id="description"
            label="Description détaillée"
            v-model="requestData.description"
            required
            rows="4"
            placeholder="Décrivez votre besoin en détail..."
          />
          <div class="mt-1 text-xs text-gray-500 px-1">
            Plus votre description est détaillée, plus les experts pourront vous proposer des solutions adaptées.
          </div>
        </div>

        <!-- Budget -->
        <div>
          <FloatingLabelInput
            id="budget"
            label="Budget"
            type="number"
            v-model="requestData.budget"
            placeholder="0"
            :min="0"
            :step="1000"
            :precision="0"
            currency="FCFA"
            required
          />
          <p class="mt-1 text-xs text-gray-500 px-1">
            Indiquez votre budget approximatif pour ce projet.
          </p>
        </div>

        <!-- Deadline -->
        <div>
          <FloatingLabelInput
            id="deadline"
            label="Date limite"
            type="date"
            v-model="requestData.deadline"
            :min="minDate"
            required
          />
          <p class="mt-1 text-xs text-gray-500 px-1">
            Date à laquelle vous souhaitez que le service soit terminé.
          </p>
        </div>

        <!-- Location -->
        <div class="relative dropdown-container">
          <div class="floating-input-container">
            <div 
              class="w-full border border-gray-300 rounded-lg px-4 py-3.5 bg-white transition-all focus-within:outline-none focus-within:border-primary-500 focus-within:ring-2 focus-within:ring-primary-500 focus-within:ring-opacity-30 relative"
              :class="{'border-primary-500 ring-2 ring-primary-500 ring-opacity-30': showLocationDropdown}"
            >
              <label 
                for="location_type" 
                class="absolute text-sm text-gray-500 duration-300 transform -translate-y-4 scale-75 top-4 z-10 origin-[0] left-4 peer-focus:text-primary-600 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-4 bg-white px-1"
                :class="{'text-primary-600': requestData.location_type || showLocationDropdown}"
              >
                Type de localisation
              </label>
              
              <button
                id="location_type"
                type="button"
                @click="showLocationDropdown = !showLocationDropdown"
                class="w-full text-left focus:outline-none flex items-center justify-between h-full"
              >
                <span class="text-base" :class="requestData.location_type ? 'text-black' : 'text-gray-400'">
                  {{ getLocationTypeLabel(requestData.location_type) || 'Sélectionnez un type de localisation' }}
                </span>
                <svg class="w-5 h-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
                </svg>
              </button>
            </div>
            
            <!-- Dropdown -->
            <div 
              v-if="showLocationDropdown"
              class="absolute mt-1 w-full bg-white rounded-lg shadow-lg border border-gray-200 z-10 py-1"
            >
              <div 
                v-for="option in locationOptions" 
                :key="option.value"
                @click="requestData.location_type = option.value; showLocationDropdown = false"
                class="px-4 py-2 hover:bg-gray-50 cursor-pointer transition-colors"
              >
                <span>{{ option.label }}</span>
              </div>
            </div>
          </div>
          <p class="mt-1 text-xs text-gray-500 px-1">
            Indiquez si le service peut être réalisé à distance, en personne, ou les deux.
          </p>
        </div>

        <!-- Attachments -->
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">Pièces jointes (optionnel)</label>
          <div class="mt-1 flex justify-center px-6 pt-5 pb-6 border-2 border-gray-300 border-dashed rounded-md">
            <div class="space-y-1 text-center">
              <svg class="mx-auto h-12 w-12 text-gray-400" stroke="currentColor" fill="none" viewBox="0 0 48 48" aria-hidden="true">
                <path d="M28 8H12a4 4 0 00-4 4v20m32-12v8m0 0v8a4 4 0 01-4 4H12a4 4 0 01-4-4v-4m32-4l-3.172-3.172a4 4 0 00-5.656 0L28 28M8 32l9.172-9.172a4 4 0 015.656 0L28 28m0 0l4 4m4-24h8m-4-4v8m-12 4h.02" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
              </svg>
              <div class="flex text-sm text-gray-600">
                <label for="file-upload" class="relative cursor-pointer bg-white rounded-md font-medium text-primary-600 hover:text-primary-500 focus-within:outline-none focus-within:ring-2 focus-within:ring-offset-2 focus-within:ring-primary-500">
                  <span>Télécharger un fichier</span>
                  <input 
                    id="file-upload" 
                    name="file-upload" 
                    type="file" 
                    class="sr-only" 
                    multiple 
                    @change="handleFileUpload"
                  >
                </label>
                <p class="pl-1">ou glisser-déposer</p>
              </div>
              <p class="text-xs text-gray-500">
                PNG, JPG, PDF jusqu'à 10MB
              </p>
            </div>
          </div>
          
          <!-- File list -->
          <div v-if="attachments.length > 0" class="mt-4 space-y-2">
            <div 
              v-for="(file, index) in attachments" 
              :key="index"
              class="flex items-center justify-between p-2 bg-gray-50 rounded-md"
            >
              <div class="flex items-center">
                <svg class="h-5 w-5 text-gray-400 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.172 7l-6.586 6.586a2 2 0 102.828 2.828l6.414-6.586a4 4 0 00-5.656-5.656l-6.415 6.585a6 6 0 108.486 8.486L20.5 13" />
                </svg>
                <span class="text-sm truncate max-w-xs">{{ file.name }}</span>
              </div>
              <button 
                type="button" 
                @click="removeFile(index)"
                class="text-red-500 hover:text-red-700"
              >
                <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                </svg>
              </button>
            </div>
          </div>
        </div>

        <!-- Submit buttons -->
        <div class="flex justify-end space-x-3 pt-4">
          <button 
            type="button"
            @click="$router.back()"
            class="inline-flex justify-center py-2 px-4 border border-gray-300 shadow-sm text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-black"
          >
            Annuler
          </button>
          <button 
            type="submit" 
            class="inline-flex justify-center py-2 px-4 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-black hover:bg-gray-800 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-black"
            :disabled="isSubmitting"
          >
            <svg v-if="isSubmitting" class="animate-spin -ml-1 mr-2 h-4 w-4 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
              <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
              <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
            </svg>
            {{ isSubmitting ? 'Mise à jour...' : 'Mettre à jour' }}
          </button>
        </div>
      </form>
    </main>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { useSupabaseClient, useSupabaseUser } from '#imports';
import FloatingLabelInput from '~/components/ui/FloatingLabelInput.vue';

const supabase = useSupabaseClient();
const user = useSupabaseUser();
const route = useRoute();
const router = useRouter();

// État
const isLoading = ref(true);
const isSubmitting = ref(false);
const error = ref(null);
const categories = ref([]);
const showCategoryDropdown = ref(false);
const showLocationDropdown = ref(false);
const categorySearch = ref('');
const attachments = ref([]);
const existingAttachments = ref([]);
const attachmentsToDelete = ref([]);

// Données de la demande
const requestData = ref({
  title: '',
  description: '',
  category_id: '',
  budget: null,
  deadline: '',
  location_type: '',
  attachments: []
});

// Options de localisation
const locationOptions = [
  { value: 'remote', label: 'À distance' },
  { value: 'in_person', label: 'En personne' },
  { value: 'both', label: 'Les deux' }
];

// Date minimum (aujourd'hui)
const minDate = computed(() => {
  const today = new Date();
  return today.toISOString().split('T')[0];
});

// Catégories filtrées par recherche
const filteredCategories = computed(() => {
  if (!categorySearch.value) return categories.value;
  
  const search = categorySearch.value.toLowerCase();
  return categories.value.filter(category => 
    category.name.toLowerCase().includes(search)
  );
});

// Nom de la catégorie sélectionnée
const selectedCategoryName = computed(() => {
  const category = categories.value.find(c => c.id === requestData.value.category_id);
  return category ? category.name : '';
});

// Récupérer les catégories
const fetchCategories = async () => {
  try {
    const { data, error } = await supabase
      .from('categories')
      .select('*')
      .order('name');
    
    if (error) throw error;
    
    categories.value = data;
  } catch (err) {
    console.error('Error fetching categories:', err);
    error.value = "Impossible de charger les catégories. Veuillez réessayer.";
  }
};

// Récupérer la demande
const fetchRequest = async () => {
  isLoading.value = true;
  error.value = null;
  
  try {
    const requestId = route.params.id;
    
    const { data, error: requestError } = await supabase
      .from('requests')
      .select('*')
      .eq('id', requestId)
      .single();
    
    if (requestError) throw requestError;
    
    // Vérifier que l'utilisateur est le propriétaire de la demande
    if (data.user_id !== user.value.id) {
      router.push('/requests');
      return;
    }
    
    // Formater la date
    if (data.deadline) {
      const date = new Date(data.deadline);
      data.deadline = date.toISOString().split('T')[0];
    }
    
    requestData.value = {
      title: data.title,
      description: data.description,
      category_id: data.category_id,
      budget: data.budget,
      deadline: data.deadline,
      location_type: data.location_type,
      attachments: data.attachments || []
    };
    
    // Récupérer les pièces jointes existantes
    existingAttachments.value = data.attachments || [];
    
  } catch (err) {
    console.error('Error fetching request:', err);
    error.value = "Impossible de charger la demande. Veuillez réessayer.";
  } finally {
    isLoading.value = false;
  }
};

// Sélectionner une catégorie
const selectCategory = (categoryId) => {
  requestData.value.category_id = categoryId;
};

// Obtenir le libellé du type de localisation
const getLocationTypeLabel = (type) => {
  const option = locationOptions.find(opt => opt.value === type);
  return option ? option.label : '';
};

// Gérer l'upload de fichiers
const handleFileUpload = (event) => {
  const files = event.target.files;
  
  if (!files.length) return;
  
  for (let i = 0; i < files.length; i++) {
    const file = files[i];
    
    // Vérifier la taille du fichier (10MB max)
    if (file.size > 10 * 1024 * 1024) {
      error.value = `Le fichier ${file.name} est trop volumineux. La taille maximale est de 10MB.`;
      continue;
    }
    
    // Vérifier le type de fichier
    const allowedTypes = ['image/jpeg', 'image/png', 'application/pdf'];
    if (!allowedTypes.includes(file.type)) {
      error.value = `Le type de fichier ${file.name} n'est pas pris en charge. Utilisez JPG, PNG ou PDF.`;
      continue;
    }
    
    attachments.value.push(file);
  }
  
  // Réinitialiser l'input file
  event.target.value = '';
};

// Supprimer un fichier
const removeFile = (index) => {
  attachments.value.splice(index, 1);
};

// Supprimer une pièce jointe existante
const removeExistingAttachment = (index) => {
  const attachment = existingAttachments.value[index];
  attachmentsToDelete.value.push(attachment);
  existingAttachments.value.splice(index, 1);
};

// Mettre à jour la demande
const updateRequest = async () => {
  isSubmitting.value = true;
  error.value = null;
  
  try {
    const requestId = route.params.id;
    
    // 1. Mettre à jour les informations de base de la demande
    const { error: updateError } = await supabase
      .from('requests')
      .update({
        title: requestData.value.title,
        description: requestData.value.description,
        category_id: requestData.value.category_id,
        budget: requestData.value.budget,
        deadline: requestData.value.deadline,
        location_type: requestData.value.location_type,
        updated_at: new Date().toISOString()
      })
      .eq('id', requestId);
    
    if (updateError) throw updateError;
    
    // 2. Gérer les pièces jointes
    if (attachments.value.length > 0) {
      const newAttachmentUrls = [];
      
      // Upload des nouvelles pièces jointes
      for (const file of attachments.value) {
        const filePath = `requests/${requestId}/${Date.now()}_${file.name}`;
        
        const { error: uploadError } = await supabase.storage
          .from('request_attachments')
          .upload(filePath, file, {
            cacheControl: '3600',
            upsert: false
          });
        
        if (uploadError) throw uploadError;
        
        // Obtenir l'URL publique
        const { data: { publicUrl } } = supabase.storage
          .from('request_attachments')
          .getPublicUrl(filePath);
        
        newAttachmentUrls.push({
          name: file.name,
          url: publicUrl,
          type: file.type
        });
      }
      
      // Combiner les pièces jointes existantes et nouvelles
      const updatedAttachments = [
        ...existingAttachments.value,
        ...newAttachmentUrls
      ];
      
      // Mettre à jour la demande avec les nouvelles pièces jointes
      const { error: attachmentError } = await supabase
        .from('requests')
        .update({ attachments: updatedAttachments })
        .eq('id', requestId);
      
      if (attachmentError) throw attachmentError;
    } else if (existingAttachments.value.length !== requestData.value.attachments.length) {
      // Mettre à jour si des pièces jointes ont été supprimées
      const { error: attachmentError } = await supabase
        .from('requests')
        .update({ attachments: existingAttachments.value })
        .eq('id', requestId);
      
      if (attachmentError) throw attachmentError;
    }
    
    // 3. Rediriger vers la page de détail de la demande
    router.push(`/requests/${requestId}`);
    
  } catch (err) {
    console.error('Error updating request:', err);
    error.value = "Une erreur est survenue lors de la mise à jour de la demande. Veuillez réessayer.";
  } finally {
    isSubmitting.value = false;
  }
};

// Initialisation
onMounted(async () => {
  try {
    await Promise.all([
      fetchCategories(),
      fetchRequest()
    ]);
  } catch (err) {
    console.error('Error during initialization:', err);
    error.value = "Une erreur est survenue lors du chargement de la page.";
  }
});

definePageMeta({
  middleware: ['auth']
})
</script>

<style scoped>
/* Styles pour les dropdowns */
.dropdown-container {
  position: relative;
}
</style> 