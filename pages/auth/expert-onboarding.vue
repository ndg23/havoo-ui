<template>
  <div class="min-h-screen bg-white dark:bg-gray-900 flex flex-col justify-center px-4 sm:px-6 lg:px-8">
    <div class="sm:mx-auto sm:w-full sm:max-w-md">
     
      
      <h1 class="text-center text-3xl font-bold tracking-tight text-gray-900 dark:text-white">
        Choisissez votre profession
      </h1>
      
      <p class="mt-2 text-center text-gray-600 dark:text-gray-400">
        Cette information nous aidera à mieux vous connaître
      </p>
    </div>

    <div class="mt-8 sm:mx-auto sm:w-full sm:max-w-md">
      <!-- Message d'erreur -->
      <div v-if="errorMessage" class="mb-6 bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800/40 text-red-600 dark:text-red-400 rounded-lg p-3 text-sm">
        {{ errorMessage }}
      </div>
      
      <div class="bg-white dark:bg-gray-800 py-8 px-6  sm:rounded-lg sm:px-10 border border-gray-100 dark:border-gray-700">
        <!-- État de chargement -->
        <div v-if="isLoading" class="flex flex-col items-center justify-center py-8">
          <div class="animate-spin h-8 w-8 text-primary-500 mb-4">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
              <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
              <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
            </svg>
          </div>
          <p class="text-gray-500 dark:text-gray-400">Chargement des professions...</p>
        </div>
        
        <form v-else @submit.prevent="saveProfession" class="space-y-6">
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
              placeholder="Rechercher une profession..."
              class="pl-10 w-full py-3 px-4 border border-gray-300 dark:border-gray-700 rounded-full text-gray-900 dark:text-white bg-white dark:bg-gray-800 focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
            />
          </div>
          
          <!-- Liste des professions -->
          <div class="space-y-2">
            <div class="flex justify-between items-center mb-2">
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300">
                Professions disponibles
              </label>
              <span class="text-xs text-gray-500 dark:text-gray-400">
                {{ filteredProfessions.length }} trouvée(s)
              </span>
            </div>
            
            <div class="space-y-2 max-h-72 overflow-y-auto pr-2">
              <button
                v-for="profession in filteredProfessions"
                :key="profession.id"
                type="button"
                @click="selectProfession(profession)"
                class="w-full flex items-center justify-between p-4 rounded-lg border transition-all duration-200"
                :class="[
                  selectedProfession?.id === profession.id 
                    ? 'border-primary-500 bg-primary-50 dark:bg-primary-900/20' 
                    : 'border-gray-200 dark:border-gray-700 hover:border-primary-200 dark:hover:border-primary-700'
                ]"
              >
                <span class="text-left">
                  <span 
                    class="block font-medium"
                    :class="selectedProfession?.id === profession.id ? 'text-primary-700 dark:text-primary-300' : 'text-gray-900 dark:text-white'"
                  >
                    {{ profession.name }}
                  </span>
                  <span 
                    v-if="profession.description"
                    class="text-sm"
                    :class="selectedProfession?.id === profession.id ? 'text-primary-600 dark:text-primary-400' : 'text-gray-500 dark:text-gray-400'"
                  >
                    {{ profession.description }}
                  </span>
                </span>
                <svg
                  v-if="selectedProfession?.id === profession.id"
                  class="h-5 w-5 text-primary-500"
                  xmlns="http://www.w3.org/2000/svg"
                  viewBox="0 0 20 20"
                  fill="currentColor"
                >
                  <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd" />
                </svg>
              </button>
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
              class="flex-1 py-2.5 px-4 border border-transparent rounded-full text-base font-medium text-white bg-primary-600 hover:bg-primary-700 disabled:opacity-50 disabled:cursor-not-allowed"
              :disabled="isSaving || !selectedProfession"
            >
              <span v-if="isSaving" class="flex items-center justify-center">
                <svg class="animate-spin -ml-1 mr-2 h-4 w-4 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                  <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                  <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                </svg>
                Enregistrement...
              </span>
              <span v-else>Continuer</span>
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
const professions = ref([]);
const selectedProfession = ref(null);

// Professions filtrées par recherche
const filteredProfessions = computed(() => {
  if (!searchQuery.value.trim()) return professions.value;
  
  const query = searchQuery.value.toLowerCase().trim();
  return professions.value.filter(profession => 
    profession.name.toLowerCase().includes(query)
  );
});

// Sélectionner une profession
const selectProfession = (profession) => {
  selectedProfession.value = profession;
};

// Récupérer les professions depuis Supabase
const fetchProfessions = async () => {
  try {
    const { data, error } = await supabase
      .from('professions')
      .select('*')
      .eq('is_active', true)
      .order('name');
    
    if (error) throw error;
    
    professions.value = data || [];
  } catch (error) {
    console.error('Erreur lors du chargement des professions:', error);
    errorMessage.value = 'Impossible de charger les professions';
  } finally {
    isLoading.value = false;
  }
};

// Enregistrer la profession
const saveProfession = async () => {
  if (!selectedProfession.value) {
    errorMessage.value = 'Veuillez sélectionner une profession';
    return;
  }
  
  isSaving.value = true;
  errorMessage.value = '';
  
  try {
    // Mettre à jour le profil avec la profession
    const { error: profileError } = await supabase
      .from('profiles')
      .update({
        profession_id: selectedProfession.value.id,
        profile_completion_percentage: 80,
        updated_at: new Date().toISOString()
      })
      .eq('id', user.value.id);
    
    if (profileError) throw profileError;
    
    // Rediriger vers le tableau de bord
    router.push('/account');
    
  } catch (error) {
    console.error('Erreur lors de l\'enregistrement de la profession:', error);
    errorMessage.value = 'Une erreur est survenue lors de l\'enregistrement de votre profession';
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
  
  // Charger les professions
  await fetchProfessions();
});
</script>

<style scoped>
/* Masquer la scrollbar tout en permettant le défilement */
.overflow-y-auto {
  scrollbar-width: thin;
  scrollbar-color: #888 #f1f1f1;
}

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
</style> 