<template>
  <div class="min-h-screen bg-white dark:bg-gray-900 flex flex-col justify-center px-4 sm:px-6 lg:px-8">
    <div class="sm:mx-auto sm:w-full sm:max-w-md">
      <!-- Logo ou icône (optionnel) -->
      <div class="flex justify-center mb-6">
        <div class="w-12 h-12 rounded-full bg-primary-100 dark:bg-primary-900/30 flex items-center justify-center">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-primary-600 dark:text-primary-400" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M12 4.75L19.25 9L12 13.25L4.75 9L12 4.75Z" />
            <path d="M9.25 12L4.75 15L12 19.25L19.25 15L14.6722 12" />
          </svg>
        </div>
      </div>
      
      <h1 class="text-center text-3xl font-bold tracking-tight text-gray-900 dark:text-white">
        Complétez votre profil
      </h1>
      
      <p class="mt-2 text-center text-gray-600 dark:text-gray-400">
        Ajoutez vos compétences pour être visible auprès des clients
      </p>
    </div>

    <div class="mt-8 sm:mx-auto sm:w-full sm:max-w-md">
      <!-- Message d'erreur -->
      <div v-if="errorMessage" class="mb-6 bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800/40 text-red-600 dark:text-red-400 rounded-lg p-3 text-sm">
        {{ errorMessage }}
      </div>
      
      <div class="bg-white dark:bg-gray-800 py-8 px-6 shadow sm:rounded-lg sm:px-10 border border-gray-100 dark:border-gray-700">
        <!-- État de chargement -->
        <div v-if="isLoading" class="flex flex-col items-center justify-center py-8">
          <div class="animate-spin h-8 w-8 text-primary-500 mb-4">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
              <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
              <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
            </svg>
          </div>
          <p class="text-gray-500 dark:text-gray-400">Chargement des compétences...</p>
        </div>
        
        <form v-else @submit.prevent="saveSkills" class="space-y-6">
          <!-- Barre de recherche -->
          <div class="relative">
            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
              <svg class="h-5 w-5 text-gray-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                <path fill-rule="evenodd" d="M8 4a4 4 0 100 8 4 4 0 000-8zM2 8a6 6 0 1110.89 3.476l4.817 4.817a1 1 0 01-1.414 1.414l-4.816-4.816A6 6 0 012 8z" clip-rule="evenodd" />
              </svg>
            </div>
            <input
              type="text"
              v-model="searchQuery"
              placeholder="Rechercher une compétence..."
              class="pl-10 w-full py-3 px-4 border border-gray-300 dark:border-gray-700 rounded-full text-gray-900 dark:text-white bg-white dark:bg-gray-800 focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
            />
          </div>
          
          <!-- Catégories (affichage horizontal avec scroll) -->
          <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
              Catégories
            </label>
            <div class="flex space-x-2 overflow-x-auto pb-2 hide-scrollbar">
              <button
                type="button"
                @click="selectedCategories = []"
                class="flex-shrink-0 px-4 py-2 rounded-full text-sm font-medium transition-colors whitespace-nowrap"
                :class="selectedCategories.length === 0 ? 
                  'bg-primary-500 text-white' : 
                  'bg-gray-100 dark:bg-gray-800 text-gray-700 dark:text-gray-300'"
              >
                Toutes
              </button>
              <button
                v-for="category in categories"
                :key="category.id"
                type="button"
                @click="toggleCategory(category)"
                class="flex-shrink-0 px-4 py-2 rounded-full text-sm font-medium transition-colors whitespace-nowrap"
                :class="selectedCategories.some(c => c.id === category.id) ? 
                  'bg-primary-500 text-white' : 
                  'bg-gray-100 dark:bg-gray-800 text-gray-700 dark:text-gray-300'"
              >
                {{ category.name }}
              </button>
            </div>
          </div>
          
          <!-- Compétences disponibles -->
          <div>
            <div class="flex justify-between items-center mb-2">
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300">
                Compétences disponibles
              </label>
              <span class="text-xs text-gray-500 dark:text-gray-400">
                {{ filteredSkills.length }} trouvée(s)
              </span>
            </div>
            
            <div class="max-h-48 overflow-y-auto border border-gray-200 dark:border-gray-700 rounded-lg p-3 bg-gray-50 dark:bg-gray-900/30">
              <div v-if="filteredSkills.length === 0" class="flex items-center justify-center h-24 text-gray-500 dark:text-gray-400">
                Aucune compétence trouvée
              </div>
              
              <div class="flex flex-wrap gap-2">
                <button
                  v-for="skill in filteredSkills"
                  :key="skill.id"
                  type="button"
                  @click="toggleSkill(skill)"
                  class="px-3 py-1.5 rounded-full text-sm font-medium transition-colors"
                  :class="selectedSkills.some(s => s.id === skill.id) ? 
                    'bg-primary-500 text-white' : 
                    'bg-white dark:bg-gray-800 text-gray-700 dark:text-gray-300 border border-gray-200 dark:border-gray-700'"
                >
                  {{ skill.name }}
                </button>
              </div>
            </div>
          </div>
          
          <!-- Compétences sélectionnées -->
          <div>
            <div class="flex justify-between items-center mb-2">
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300">
                Vos compétences
              </label>
              <span class="text-xs text-gray-500 dark:text-gray-400">
                {{ selectedSkills.length }} sélectionnée(s)
              </span>
            </div>
            
            <div class="flex flex-wrap gap-2 p-3 border border-gray-200 dark:border-gray-700 rounded-lg bg-gray-50 dark:bg-gray-900/30 min-h-[80px]">
              <div 
                v-if="selectedSkills.length === 0" 
                class="flex items-center justify-center w-full h-full text-gray-500 dark:text-gray-400 text-sm"
              >
                Sélectionnez au moins une compétence
              </div>
              
              <div 
                v-for="skill in selectedSkills" 
                :key="skill.id"
                class="bg-white dark:bg-gray-800 px-3 py-1.5 rounded-full text-sm font-medium text-gray-700 dark:text-gray-300 border border-gray-200 dark:border-gray-700 flex items-center"
              >
                {{ skill.name }}
                <button 
                  @click.prevent="toggleSkill(skill)" 
                  class="ml-1.5 text-gray-400 hover:text-gray-600 dark:hover:text-gray-200"
                >
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" viewBox="0 0 20 20" fill="currentColor">
                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd" />
                  </svg>
                </button>
              </div>
            </div>
          </div>
          
          <div class="flex items-center space-x-4 pt-4">
            <button
              type="button"
              @click="skipOnboarding"
              class="flex-1 py-2.5 px-4 border border-gray-300 dark:border-gray-700 rounded-full text-base font-medium text-gray-700 dark:text-gray-300 bg-white dark:bg-gray-800 hover:bg-gray-50 dark:hover:bg-gray-700"
            >
              Plus tard
            </button>
            
            <button
              type="submit"
              class="flex-1 py-2.5 px-4 border border-transparent rounded-full text-base font-medium text-white bg-primary-600 hover:bg-primary-700"
              :disabled="isSaving || selectedSkills.length === 0"
            >
              <span v-if="isSaving" class="flex items-center justify-center">
                <svg class="animate-spin -ml-1 mr-2 h-4 w-4 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                  <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                  <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                </svg>
                Enregistrement...
              </span>
              <span v-else>Enregistrer</span>
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import { useSupabaseClient, useSupabaseUser } from '#imports';

// Services
const router = useRouter();
const supabase = useSupabaseClient();
const user = useSupabaseUser();

// État
const isLoading = ref(true);
const isSaving = ref(false);
const errorMessage = ref('');
const searchQuery = ref('');

// Données
const categories = ref([]);
const skills = ref([]);
const selectedCategories = ref([]);
const selectedSkills = ref([]);

// Compétences filtrées par recherche et catégories
const filteredSkills = computed(() => {
  let result = skills.value;
  
  // Filtrer par catégories sélectionnées
  if (selectedCategories.value.length > 0) {
    const categoryIds = selectedCategories.value.map(c => c.id);
    result = result.filter(skill => categoryIds.includes(skill.category_id));
  }
  
  // Filtrer par recherche
  if (searchQuery.value.trim()) {
    const query = searchQuery.value.toLowerCase().trim();
    result = result.filter(skill => 
      skill.name.toLowerCase().includes(query)
    );
  }
  
  return result;
});

// Récupérer les catégories depuis Supabase
const fetchCategories = async () => {
  try {
    const { data, error } = await supabase
      .from('categories')
      .select('*')
      .eq('is_active', true)
      .order('name');
    
    if (error) throw error;
    
    categories.value = data || [];
  } catch (error) {
    console.error('Erreur lors du chargement des catégories:', error);
    errorMessage.value = 'Impossible de charger les catégories';
  }
};

// Récupérer les compétences depuis Supabase
const fetchSkills = async () => {
  try {
    const { data, error } = await supabase
      .from('skills')
      .select('*')
      .eq('is_active', true)
      .order('name');
    
    if (error) throw error;
    
    skills.value = data || [];
  } catch (error) {
    console.error('Erreur lors du chargement des compétences:', error);
    errorMessage.value = 'Impossible de charger les compétences';
  } finally {
    isLoading.value = false;
  }
};

// Sélectionner/désélectionner une catégorie
const toggleCategory = (category) => {
  const index = selectedCategories.value.findIndex(c => c.id === category.id);
  
  if (index === -1) {
    selectedCategories.value.push(category);
  } else {
    selectedCategories.value.splice(index, 1);
  }
};

// Sélectionner/désélectionner une compétence
const toggleSkill = (skill) => {
  const index = selectedSkills.value.findIndex(s => s.id === skill.id);
  
  if (index === -1) {
    selectedSkills.value.push(skill);
  } else {
    selectedSkills.value.splice(index, 1);
  }
};

// Enregistrer les compétences
const saveSkills = async () => {
  if (selectedSkills.value.length === 0) {
    errorMessage.value = 'Veuillez sélectionner au moins une compétence';
    return;
  }
  
  isSaving.value = true;
  errorMessage.value = '';
  
  try {
    // Préparer les données pour l'insertion
    const userSkillsData = selectedSkills.value.map(skill => ({
      user_id: user.value.id,
      skill_id: skill.id
    }));
    
    // Insérer les compétences de l'utilisateur
    const { error } = await supabase
      .from('user_skills')
      .upsert(userSkillsData);
    
    if (error) throw error;
    
    // Mettre à jour le pourcentage de complétion du profil
    const { error: profileError } = await supabase
      .from('profiles')
      .update({
        profile_completion_percentage: 60,
        updated_at: new Date().toISOString()
      })
      .eq('id', user.value.id);
    
    if (profileError) throw profileError;
    
    // Rediriger vers le tableau de bord
    router.push('/account');
    
  } catch (error) {
    console.error('Erreur lors de l\'enregistrement des compétences:', error);
    errorMessage.value = error.message || 'Une erreur est survenue lors de l\'enregistrement de vos compétences';
  } finally {
    isSaving.value = false;
  }
};

// Passer l'onboarding
const skipOnboarding = () => {
  router.push('/account');
};

// Initialisation
onMounted(async () => {
  if (!user.value) {
    router.push('/auth/login');
    return;
  }
  
  // Vérifier si l'utilisateur est un expert
  const { data: profile } = await supabase
    .from('profiles')
    .select('is_expert, role')
    .eq('id', user.value.id)
    .single();
  
  if (!profile || (!profile.is_expert && profile.role !== 'expert')) {
    router.push('/account');
    return;
  }
  
  // Charger les données
  await Promise.all([fetchCategories(), fetchSkills()]);
});
</script>

<style scoped>
/* Masquer la scrollbar tout en permettant le défilement */
.hide-scrollbar {
  -ms-overflow-style: none;  /* IE and Edge */
  scrollbar-width: none;  /* Firefox */
}

.hide-scrollbar::-webkit-scrollbar {
  display: none;  /* Chrome, Safari and Opera */
}

/* Scrollbar personnalisée pour les zones de défilement vertical */
.overflow-y-auto::-webkit-scrollbar {
  width: 6px;
}

.overflow-y-auto::-webkit-scrollbar-track {
  background: #f1f1f1;
  border-radius: 10px;
}

.overflow-y-auto::-webkit-scrollbar-thumb {
  background: #888;
  border-radius: 10px;
}

.overflow-y-auto::-webkit-scrollbar-thumb:hover {
  background: #555;
}

/* Animation du spinner */
.animate-spin {
  animation: spin 1s linear infinite;
}

@keyframes spin {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}
</style> 