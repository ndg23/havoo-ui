<template>
  <div class="min-h-screen bg-white dark:bg-gray-900">
    <!-- Header -->
    <header class="sticky top-0 z-30 bg-white dark:bg-gray-900 backdrop-blur bg-opacity-80 dark:bg-opacity-80 border-b border-gray-200 dark:border-gray-800">
      <div class="max-w-3xl mx-auto px-4 py-3 flex items-center">
        <NuxtLink 
          :to="`/requests/${requestId}`" 
          class="p-2 -ml-2 rounded-full hover:bg-gray-100 dark:hover:bg-gray-800 transition-colors"
        >
          <ArrowLeft class="w-5 h-5" />
        </NuxtLink>
        <h1 class="ml-4 text-xl font-bold">Faire une proposition</h1>
      </div>
    </header>

    <!-- Main content -->
    <main class="max-w-3xl mx-auto px-4 py-6">
      <!-- Loading state -->
      <div v-if="isLoading" class="flex flex-col items-center justify-center py-12">
        <div class="animate-spin rounded-full h-10 w-10 border-b-2 border-primary-600"></div>
        <p class="text-gray-500 dark:text-gray-400 mt-4">Chargement de la demande...</p>
      </div>

      <!-- Error state -->
      <div v-else-if="error" class="bg-red-50 dark:bg-red-900/20 p-4 rounded-lg text-red-700 dark:text-red-400 my-6">
        <div class="flex">
          <svg class="h-5 w-5 text-red-400 mr-3" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
          </svg>
          <p>{{ error }}</p>
        </div>
        <button 
          @click="fetchRequest" 
          class="mt-3 text-sm font-medium text-red-600 dark:text-red-400 hover:text-red-500"
        >
          Réessayer
        </button>
      </div>

      <!-- Request summary and proposal form -->
      <div v-else class="space-y-4">
        <!-- Request summary card -->
        <div class="bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-xl overflow-hidden shadow-sm">
          <div class="p-5">
            <div class="flex items-start justify-between">
              <div>
                <h2 class="text-xl font-medium text-gray-900 dark:text-white">{{ request.title }}</h2>
                <div class="flex items-center flex-wrap gap-2 mt-2">
                  <span class="inline-flex items-center text-sm text-gray-500 dark:text-gray-400">
                    <svg class="h-4 w-4 mr-1.5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                    </svg>
                    {{ formatDate(request.created_at) }}
                  </span>
                  <span class="inline-flex items-center text-sm text-gray-500 dark:text-gray-400">
                    <svg class="h-4 w-4 mr-1.5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 7h.01M7 3h5c.512 0 1.024.195 1.414.586l7 7a2 2 0 010 2.828l-7 7a2 2 0 01-2.828 0l-7-7A1.994 1.994 0 013 12V7a4 4 0 014-4z" />
                    </svg>
                    {{ request.category?.name || 'Non catégorisé' }}
                  </span>
                  <span 
                    class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 dark:bg-green-900/30 text-green-800 dark:text-green-200"
                  >
                    Ouvert
                  </span>
                </div>
              </div>
              <div class="text-right">
                <div class="text-lg font-bold text-primary-600 dark:text-primary-400">
                  {{ formatPrice(request.budget) }}
                </div>
                <div v-if="request.deadline" class="text-sm text-gray-500 dark:text-gray-400 mt-1">
                  Deadline: {{ formatDate(request.deadline) }}
                </div>
              </div>
            </div>
            
            <div class="mt-3 text-sm text-gray-600 dark:text-gray-300 line-clamp-2">
              {{ request.description }}
            </div>
            
            <button @click="showFullDescription = !showFullDescription" class="mt-1 text-xs text-primary-600 dark:text-primary-400 font-medium hover:text-primary-700 dark:hover:text-primary-300 transition-colors">
              {{ showFullDescription ? 'Voir moins' : 'Voir plus' }}
            </button>
          </div>
        </div>
        
        <!-- Full description (collapsible) -->
        <div v-if="showFullDescription" class="bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-xl p-5 shadow-sm">
          <h3 class="text-md font-medium text-gray-900 dark:text-white mb-3">Description complète</h3>
          <div class="prose prose-sm dark:prose-invert max-w-none text-gray-700 dark:text-gray-300">
            {{ request.description }}
          </div>
        </div>
        
        <!-- Quick proposal form -->
        <div class="bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-xl shadow-sm overflow-hidden">
          <div class="p-5">
            <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-4">Votre proposition</h3>
            
            <form @submit.prevent="submitProposal">
              <div class="space-y-4">
                <!-- Price field with more modern styling -->
                <div>
                  <label for="price" class="block text-sm font-medium text-gray-700 dark:text-gray-300">Prix proposé</label>
                  <div class="mt-1 relative rounded-md">
                    <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                      <span class="text-gray-500 dark:text-gray-400 sm:text-sm">FCFA</span>
                    </div>
                    <input 
                      type="number"
                      id="price"
                      v-model="proposalForm.price" 
                      class="focus:ring-primary-500 focus:border-primary-500 block w-full pl-16 pr-4 sm:text-sm border-gray-300 dark:border-gray-700 bg-white dark:bg-gray-900 rounded-lg" 
                      placeholder="0" 
                      min="0" 
                      required
                    />
                  </div>
                </div>
                
                <!-- Duration field with more modern styling -->
                <div>
                  <label for="duration" class="block text-sm font-medium text-gray-700 dark:text-gray-300">Durée de réalisation</label>
                  <div class="mt-1 flex rounded-md">
                    <input 
                      type="number"
                      id="duration" 
                      v-model="proposalForm.duration" 
                      class="focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 dark:border-gray-700 bg-white dark:bg-gray-900 rounded-l-lg" 
                      min="1" 
                      required
                    />
                    <span class="inline-flex items-center px-3 rounded-r-lg border border-l-0 border-gray-300 dark:border-gray-700 bg-gray-50 dark:bg-gray-800 text-gray-500 dark:text-gray-400 text-sm">
                      jour{{ proposalForm.duration > 1 ? 's' : '' }}
                    </span>
                  </div>
                </div>
                
                <!-- Message with character count -->
                <div>
                  <div class="flex justify-between items-center">
                    <label for="message" class="block text-sm font-medium text-gray-700 dark:text-gray-300">Votre message</label>
                    <span class="text-xs text-gray-500 dark:text-gray-400">{{ proposalForm.message.length }}/500</span>
                  </div>
                  <textarea 
                    id="message"
                    v-model="proposalForm.message" 
                    rows="4"
                    maxlength="500"
                    placeholder="Décrivez pourquoi vous êtes le meilleur candidat pour cette demande..."
                    class="mt-1 focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 dark:border-gray-700 bg-white dark:bg-gray-900 rounded-lg" 
                    required
                  ></textarea>
                </div>
                
                <!-- Quick template buttons -->
                <div>
                  <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Messages rapides</label>
                  <div class="flex flex-wrap gap-2">
                    <button 
                      type="button"
                      v-for="(template, index) in messageTemplates" 
                      :key="index"
                      @click="useTemplate(template)"
                      class="px-3 py-1.5 text-xs rounded-full border border-gray-300 dark:border-gray-700 bg-white dark:bg-gray-800 hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors"
                    >
                      {{ template.label }}
                    </button>
                  </div>
                </div>
              </div>

              <div class="mt-6">
                <!-- Submit button that spans full width -->
                <button
                  type="submit"
                  class="w-full inline-flex justify-center items-center px-4 py-3 border border-transparent rounded-full shadow-sm text-base font-medium text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 transition-colors"
                  :disabled="isSubmitting"
                >
                  <svg v-if="isSubmitting" class="animate-spin -ml-1 mr-2 h-4 w-4 text-white" fill="none" viewBox="0 0 24 24">
                    <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                    <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                  </svg>
                  <span>{{ isSubmitting ? 'Envoi en cours...' : 'Envoyer ma proposition' }}</span>
                </button>
                
                <!-- Cancel button -->
                <div class="mt-2 text-center">
                  <NuxtLink 
                    :to="`/requests/${requestId}`" 
                    class="text-sm text-gray-500 dark:text-gray-400 hover:text-gray-700 dark:hover:text-gray-300 transition-colors"
                  >
                    Annuler et retourner à la demande
                  </NuxtLink>
                </div>
              </div>
            </form>
          </div>
        </div>
      </div>
    </main>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { useSupabaseClient } from '#imports';
import { ArrowLeft } from 'lucide-vue-next';

const route = useRoute();
const router = useRouter();
const supabase = useSupabaseClient();
const user = useSupabaseUser();

// Get request ID from route
const requestId = route.params.id;

// State variables
const isLoading = ref(true);
const error = ref(null);
const request = ref({});
const showFullDescription = ref(false);
const isSubmitting = ref(false);
const proposalForm = ref({
  price: '',
  duration: 1,
  message: ''
});

// Template messages for quick reply
const messageTemplates = [
  { 
    label: 'Expérience similaire', 
    text: "J'ai déjà travaillé sur des projets similaires et je serais ravi de mettre mon expertise à votre service. Je peux commencer immédiatement et vous livrer un travail de qualité dans les délais impartis." 
  },
  { 
    label: 'Disponible immédiatement', 
    text: "Je suis actuellement disponible et peux commencer à travailler sur votre projet dès aujourd'hui. Je vous garantis un travail de qualité et une communication régulière." 
  },
  { 
    label: 'Prix compétitif', 
    text: "Je vous propose un prix compétitif pour une prestation de qualité. Mon objectif est de vous satisfaire pleinement et de construire une relation professionnelle durable." 
  },
  { 
    label: 'Expertise spécifique', 
    text: "Je possède une expertise spécifique dans ce domaine et je suis confiant dans ma capacité à répondre parfaitement à vos attentes. N'hésitez pas à me contacter pour en discuter davantage." 
  }
];

// Methods
const fetchRequest = async () => {
  isLoading.value = true;
  error.value = null;
  
  try {
    const { data, error: fetchError } = await supabase
      .from('requests')
      .select(`
        *,      
        client:client_id(*),
        category:category_id(*)
      `)
      .eq('id', requestId)
      .single();
    
    if (fetchError) throw fetchError;
    
    request.value = data;
    
    // Set initial price based on request budget
    if (request.value.budget) {
      proposalForm.value.price = request.value.budget;
    }
    
  } catch (err) {
    console.error('Error fetching request:', err);
    error.value = "Impossible de charger cette demande";
  } finally {
    isLoading.value = false;
  }
};

const useTemplate = (template) => {
  proposalForm.value.message = template.text;
};

const submitProposal = async () => {
  if (!user.value) {
    router.push('/login');
    return;
  }
  
  isSubmitting.value = true;
  
  try {
    const { error: submitError } = await supabase
      .from('deals')
      .insert({
        request_id: requestId,
        expert_id: user.value.id,
        price: proposalForm.value.price,
        duration: proposalForm.value.duration,
        message: proposalForm.value.message,
        status: 'pending'
      });
    
    if (submitError) throw submitError;
    
    // Show success notification
    // For a real implementation, you would use a notification system here
    
    // Navigate back to the request page
    router.push(`/requests/${requestId}?proposal_submitted=true`);
    
  } catch (err) {
    console.error('Error submitting proposal:', err);
    alert('Une erreur est survenue lors de l\'envoi de votre proposition');
  } finally {
    isSubmitting.value = false;
  }
};

const formatDate = (dateString) => {
  if (!dateString) return '';
  const date = new Date(dateString);
  return new Intl.DateTimeFormat('fr-FR', {
    day: 'numeric',
    month: 'short',
    year: 'numeric'
  }).format(date);
};

const formatPrice = (price) => {
  if (!price) return 'Prix non défini';
  return new Intl.NumberFormat('fr-FR', {
    style: 'currency',
    currency: 'XOF',
    maximumFractionDigits: 0
  }).format(price);
};

// Initialize page
onMounted(async () => {
  // Check if user is logged in
  if (!user.value) {
    router.push('/login');
    return;
  }
  
  // Check if user is an expert
  if (!user.value.is_expert) {
    router.push(`/requests/${requestId}`);
    return;
  }
  
  await fetchRequest();
});

definePageMeta({
  middleware: ['auth'],
  layout: 'account'
});
</script>

<style scoped>
.line-clamp-2 {
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.prose {
  max-width: 65ch;
  color: inherit;
}

/* Smooth transition effects */
button, a, .transition-colors {
  transition: all 0.2s ease;
}

/* Animation when hovering buttons */
button:not(:disabled):hover {
  transform: translateY(-1px);
}

/* Animation for submit button */
button[type="submit"]:not(:disabled):hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
}
</style> 