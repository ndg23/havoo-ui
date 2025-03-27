<template>
  <div class="min-h-screen bg-white">
    <!-- Header -->
    <header class="sticky top-0 z-10 bg-white/80 backdrop-blur-sm border-b border-gray-100">
      <div class="max-w-2xl mx-auto px-4 py-3 flex items-center justify-between">
        <div class="flex items-center">
      <NuxtLink 
        to="/account/services" 
            class="p-2 -ml-2 rounded-full hover:bg-gray-100 transition-colors"
      >
            <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M15 19l-7-7 7-7" />
            </svg>
      </NuxtLink>
          <h1 class="ml-6 text-xl font-bold">Nouveau service</h1>
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
        <p class="text-gray-500">Chargement...</p>
    </div>

      <!-- Error state -->
      <div v-else-if="error" class="bg-red-50 p-4 rounded-lg text-red-700 my-6">
        <div class="flex">
          <svg class="h-5 w-5 text-red-400 mr-3" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
          </svg>
          <p>{{ error }}</p>
        </div>
      </div>

      <!-- Not verified warning -->
      <div v-else-if="!isVerified" class="bg-yellow-50 p-4 rounded-lg mb-6">
        <div class="flex">
          <svg class="h-5 w-5 text-yellow-400 mr-3" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
          </svg>
          <div>
            <p class="text-sm text-yellow-700 font-medium">Votre compte n'est pas encore vérifié</p>
            <p class="text-sm text-yellow-600 mt-1">
              Vous pouvez créer des services, mais ils ne seront visibles qu'après vérification de votre identité.
            </p>
            <NuxtLink 
              to="/account/verify" 
              class="mt-2 inline-flex items-center text-sm font-medium text-yellow-600 hover:text-yellow-500"
            >
              Vérifier mon identité
              <svg class="ml-1 w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
              </svg>
            </NuxtLink>
          </div>
        </div>
      </div>

      <!-- Service form -->
      <form @submit.prevent="submitService" class="space-y-6">
        <!-- Titre -->
        <div>
          <FloatingLabelInput
            id="title"
            label="Titre du service"
            v-model="service.title"
            placeholder="Ex: Cours de guitare pour débutants"
            required
          />
          <p class="mt-1 text-xs text-gray-500 px-1">
            Soyez précis et concis pour attirer plus de clients.
          </p>
        </div>

        <!-- Description -->
            <div>
          <FloatingLabelInput
            id="description"
            label="Description"
            v-model="service.description"
            placeholder="Décrivez votre service en détail..."
            required
            rows="4"
          />
          <p class="mt-1 text-xs text-gray-500 px-1">
            Soyez précis et détaillé pour attirer plus de clients.
          </p>
        </div>

        <!-- Catégorie -->
        <div class="relative dropdown-container">
          <div class="floating-input-container">
            <div 
              class="w-full border border-gray-300 rounded-lg px-4 py-3.5 bg-white transition-all focus-within:outline-none focus-within:border-primary-500 focus-within:ring-2 focus-within:ring-primary-500 focus-within:ring-opacity-30 relative"
              :class="{'border-primary-500 ring-2 ring-primary-500 ring-opacity-30': showCategoryDropdown}"
            >
              <label 
                for="category" 
                class="absolute text-sm text-gray-500 duration-300 transform -translate-y-4 scale-75 top-4 z-10 origin-[0] left-4 peer-focus:text-primary-600 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-4 bg-white px-1"
                :class="{'text-primary-600': service.profession_id || showCategoryDropdown}"
              >
                Catégorie
              </label>
              
              <button
                id="category"
                type="button"
                @click="showCategoryDropdown = !showCategoryDropdown"
                class="w-full text-left focus:outline-none flex items-center justify-between h-full"
              >
                <span class="text-base" :class="service.profession_id ? 'text-black' : 'text-gray-400'">
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
              <div 
                v-for="category in professions" 
                :key="category.id"
                @click="selectCategory(category.id); showCategoryDropdown = false"
                class="px-4 py-2 hover:bg-gray-50 cursor-pointer transition-colors"
              >
                <span>{{ category.name }}</span>
              </div>
            </div>
          </div>
          <p class="mt-1 text-xs text-gray-500 px-1">
            Choisissez la catégorie qui correspond le mieux à votre service.
          </p>
          </div>

        <!-- Prix -->
          <div>
          <FloatingLabelInput
            id="price"
            label="Prix"
            type="number"
            v-model="service.price"
            placeholder="0.00"
            :min="0"
            :step="0.01"
            :precision="2"
            currency="FCFA"
              required
            />
          <p class="mt-1 text-xs text-gray-500 px-1">
            Prix de votre service en FCFA.
            </p>
      </div>

        <!-- Durée -->
        <div>
          <FloatingLabelInput
            id="duration"
            label="Durée"
            type="number"
            v-model="service.duration"
            placeholder="1.5"
            :min="0.5"
            :step="0.5"
            :precision="1"
            suffix="h"
            required
          />
          <p class="mt-1 text-xs text-gray-500 px-1">
            Durée moyenne pour réaliser ce service (en heures).
          </p>
        </div>

        <!-- Localisation -->
        <div class="relative dropdown-container">
          <div class="floating-input-container">
            <div 
              class="w-full border border-gray-300 rounded-lg px-4 py-3.5 bg-white transition-all focus-within:outline-none focus-within:border-primary-500 focus-within:ring-2 focus-within:ring-primary-500 focus-within:ring-opacity-30 relative"
              :class="{'border-primary-500 ring-2 ring-primary-500 ring-opacity-30': showLocationDropdown}"
            >
              <label 
                for="location" 
                class="absolute text-sm text-gray-500 duration-300 transform -translate-y-4 scale-75 top-4 z-10 origin-[0] left-4 peer-focus:text-primary-600 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-4 bg-white px-1"
                :class="{'text-primary-600': service.location_type || showLocationDropdown}"
              >
                Localisation
              </label>
              
              <button 
                id="location"
                type="button"
                @click="showLocationDropdown = !showLocationDropdown"
                class="w-full text-left focus:outline-none flex items-center justify-between h-full"
              >
                <span class="text-base" :class="service.location_type ? 'text-black' : 'text-gray-400'">
                  {{ locationTypeLabel || 'Sélectionnez une option' }}
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
                @click="selectLocationType(option.value); showLocationDropdown = false"
                class="px-4 py-2 hover:bg-gray-50 cursor-pointer transition-colors"
              >
                <span>{{ option.label }}</span>
              </div>
            </div>
          </div>
          <p class="mt-1 text-xs text-gray-500 px-1">
            Indiquez où vous pouvez réaliser ce service.
          </p>
        </div>

        <!-- Images -->
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">Images (optionnel)</label>
          <div class="mt-1 flex justify-center px-6 pt-5 pb-6 border-2 border-gray-300 border-dashed rounded-md">
            <div class="space-y-1 text-center">
              <svg class="mx-auto h-12 w-12 text-gray-400" stroke="currentColor" fill="none" viewBox="0 0 48 48" aria-hidden="true">
                <path d="M28 8H12a4 4 0 00-4 4v20m32-12v8m0 0v8a4 4 0 01-4 4H12a4 4 0 01-4-4v-4m32-4l-3.172-3.172a4 4 0 00-5.656 0L28 28M8 32l9.172-9.172a4 4 0 015.656 0L28 28m0 0l4 4m4-24h8m-4-4v8m-12 4h.02" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
              </svg>
              <div class="flex text-sm text-gray-600">
                <label for="file-upload" class="relative cursor-pointer bg-white rounded-md font-medium text-black hover:text-gray-700 focus-within:outline-none">
                  <span>Télécharger des images</span>
                  <input 
                    id="file-upload" 
                    name="file-upload" 
                    type="file" 
                    class="sr-only" 
                    accept="image/*" 
                    multiple 
                    @change="handleFileUpload"
                  />
                </label>
                <p class="pl-1">ou glisser-déposer</p>
              </div>
              <p class="text-xs text-gray-500">
                PNG, JPG, GIF jusqu'à 5MB
          </p>
        </div>
      </div>

          <!-- Prévisualisation des images -->
          <div v-if="imageFiles.length > 0" class="mt-4 grid grid-cols-2 gap-4 sm:grid-cols-3">
            <div 
              v-for="(file, index) in imageFiles" 
                :key="index"
              class="relative group rounded-lg overflow-hidden bg-gray-100 aspect-w-1 aspect-h-1"
              >
                <img 
                :src="getImagePreview(file)" 
                alt="Prévisualisation" 
                class="object-cover w-full h-full"
                />
                <button 
                type="button"
                  @click="removeImage(index)"
                class="absolute top-2 right-2 bg-white rounded-full p-1 shadow-sm opacity-0 group-hover:opacity-100 transition-opacity"
                >
                <svg class="h-4 w-4 text-gray-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                </svg>
                </button>
          </div>
        </div>
      </div>

        <!-- Statut -->
        <div class="flex items-start">
            <div class="flex items-center h-5">
              <input 
              id="is_active" 
                type="checkbox" 
              v-model="service.is_active" 
              class="focus:ring-black h-4 w-4 text-black border-gray-300 rounded"
              />
            </div>
          <div class="ml-3 text-sm">
            <label for="is_active" class="font-medium text-gray-700">Activer ce service</label>
            <p class="text-gray-500">Le service sera visible et disponible pour les clients.</p>
          </div>
          </div>
          
        <!-- Boutons d'action -->
        <div class="flex justify-end space-x-3 pt-4">
          <NuxtLink 
            to="/account/services" 
            class="inline-flex justify-center py-2 px-4 border border-gray-300 shadow-sm text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-black"
          >
            Annuler
          </NuxtLink>
            <button 
              type="submit"
            class="inline-flex justify-center py-2 px-4 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-black hover:bg-gray-800 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-black"
            :disabled="isSubmitting"
          >
            <svg v-if="isSubmitting" class="animate-spin -ml-1 mr-2 h-4 w-4 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
              <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
              <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
            </svg>
            {{ isSubmitting ? 'Création en cours...' : 'Créer le service' }}
            </button>
      </div>
    </form>
    </main>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import { useSupabaseClient, useSupabaseUser } from '#imports';
import FloatingLabelInput from '~/components/ui/FloatingLabelInput.vue';

const supabase = useSupabaseClient();
const user = useSupabaseUser();
const router = useRouter();

// État
const isLoading = ref(true);
const isSubmitting = ref(false);
const error = ref(null);
const isVerified = ref(false);
const professions = ref([]);
const imageFiles = ref([]);
const showCategoryDropdown = ref(false);
const showLocationDropdown = ref(false);

// Données du service
const service = ref({
  title: '',
  description: '',
  profession_id: '',
  price: null,
  duration: null,
  location_type: '',
  is_active: true
});

// Options de localisation
const locationOptions = [
  { value: 'remote', label: 'À distance' },
  { value: 'in_person', label: 'En personne' },
  { value: 'both', label: 'Les deux' }
];

// Nom de la catégorie sélectionnée
const selectedCategoryName = computed(() => {
  const category = professions.value.find(c => c.id === service.value.profession_id);
  return category ? category.name : '';
});

// Label du type de localisation
const locationTypeLabel = computed(() => {
  const option = locationOptions.find(o => o.value === service.value.location_type);
  return option ? option.label : '';
});

// Récupérer les catégories
const fetchCategories = async () => {
  try {
    const { data, error: fetchError } = await supabase
      .from('professions')
      .select('id, name')
      .order('name');
    
    if (fetchError) throw fetchError;
    
    professions.value = data;
  } catch (err) {
    console.error('Error fetching professions:', err);
    error.value = "Impossible de charger les catégories. Veuillez réessayer.";
  }
};

// Vérifier si l'utilisateur est vérifié
const checkVerificationStatus = async () => {
  try {
    const { data, error: fetchError } = await supabase
      .from('verifications')
      .select('status')
      .eq('user_id', user.value.id)
      .order('submitted_at', { ascending: false })
      .limit(1)
      .single();
    
    if (fetchError && fetchError.code !== 'PGRST116') throw fetchError;
    
    isVerified.value = data?.status === 'approved';
  } catch (err) {
    console.error('Error checking verification status:', err);
  }
};

// Sélectionner une catégorie
const selectCategory = (categoryId) => {
  service.value.profession_id = categoryId;
};

// Sélectionner un type de localisation
const selectLocationType = (locationType) => {
  service.value.location_type = locationType;
};

// Gérer l'upload de fichiers
const handleFileUpload = (event) => {
  const files = event.target.files;
  if (!files || files.length === 0) return;
  
  for (const file of files) {
    // Vérifier la taille
    if (file.size > 5 * 1024 * 1024) {
      error.value = `Le fichier ${file.name} est trop volumineux. La taille maximale est de 5MB.`;
      continue;
    }
    
    // Vérifier le type
    if (!file.type.startsWith('image/')) {
      error.value = `Le fichier ${file.name} n'est pas une image.`;
      continue;
    }
    
    imageFiles.value.push(file);
  }
};

// Obtenir la prévisualisation d'une image
const getImagePreview = (file) => {
  return URL.createObjectURL(file);
};

// Supprimer une image
const removeImage = (index) => {
  imageFiles.value.splice(index, 1);
};

// Soumettre le formulaire
const submitService = async () => {
  isSubmitting.value = true;
  error.value = null;
  
  try {
    // 1. Créer le service
    const { data: serviceData, error: serviceError } = await supabase
      .from('services')
      .insert({
        title: service.value.title,
        description: service.value.description,
        profession_id: service.value.profession_id,
        price: service.value.price,
        duration: service.value.duration,
        location_type: service.value.location_type,
        is_active: service.value.is_active,
        created_at: new Date().toISOString(),
        expert_id: user.value.id
      })
      .select()
      .single();
    
    if (serviceError) throw serviceError;
    
    // 2. Upload des images si présentes
    if (imageFiles.value.length > 0) {
      const imageUrls = [];
      
      for (const file of imageFiles.value) {
        const filePath = `services/${serviceData.id}/${Date.now()}_${file.name}`;
        
        const { data: uploadData, error: uploadError } = await supabase.storage
          .from('service_images')
          .upload(filePath, file, {
            cacheControl: '3600',
            upsert: false
          });
        
        if (uploadError) throw uploadError;
        
        // Obtenir l'URL publique
        const { data: { publicUrl } } = supabase.storage
          .from('service_images')
          .getPublicUrl(filePath);
        
        imageUrls.push(publicUrl);
      }
      
      // Mettre à jour le service avec les URLs des images
      const { error: updateError } = await supabase
        .from('services')
        .update({ image_urls: imageUrls })
        .eq('id', serviceData.id);
      
      if (updateError) throw updateError;
    }
    
    // 3. Rediriger vers la liste des services
    router.push('/account/services');
    
  } catch (err) {
    console.error('Error creating service:', err);
    error.value = "Une erreur est survenue lors de la création du service. Veuillez réessayer.";
  } finally {
    isSubmitting.value = false;
  }
};

// Fermer les dropdowns en cliquant ailleurs
const handleClickOutside = (event) => {
  if (showCategoryDropdown.value && !event.target.closest('.dropdown-container')) {
    showCategoryDropdown.value = false;
  }
  if (showLocationDropdown.value && !event.target.closest('.dropdown-container')) {
    showLocationDropdown.value = false;
  }
};

// Initialisation
onMounted(async () => {
  document.addEventListener('click', handleClickOutside);
  
  try {
    await Promise.all([
      fetchCategories(),
      checkVerificationStatus()
    ]);
  } catch (err) {
    console.error('Error during initialization:', err);
    error.value = "Une erreur est survenue lors du chargement de la page.";
  } finally {
    isLoading.value = false;
  }
});

definePageMeta({
  middleware: ['auth'],
  layout: 'account'
})
</script>

<style scoped>
/* Styles pour les dropdowns */
.dropdown-container {
  position: relative;
}
</style>