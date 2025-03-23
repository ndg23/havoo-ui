// pages/experts/_id.vue
<template>
  <div class="max-w-4xl mx-auto px-4 py-6 bg-white">
    <!-- Retour à la liste -->
    <div class="mb-6">
      <NuxtLink to="/experts" class="inline-flex items-center text-sm font-medium text-gray-600 hover:text-primary-600">
        <svg class="mr-2 w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18" />
        </svg>
        Retour aux experts
      </NuxtLink>
    </div>

    <!-- État de chargement -->
    <div v-if="isLoading" class="flex justify-center items-center py-12">
      <div class="animate-spin rounded-full h-10 w-10 border-b-2 border-primary-600"></div>
    </div>
    
    <!-- Message d'erreur -->
    <div v-else-if="error" class="bg-red-50 p-4 rounded-lg text-red-700 my-6">
      <div class="flex">
        <svg class="h-5 w-5 text-red-400 mr-3" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
        </svg>
        <p>{{ error }}</p>
      </div>
      <button 
        @click="fetchExpertProfile" 
        class="mt-3 text-sm font-medium text-red-600 hover:text-red-500"
      >
        Réessayer
      </button>
        </div>
        
    <!-- Profil de l'expert -->
    <div v-else-if="expert" class="bg-white rounded-lg shadow-sm border border-gray-200 overflow-hidden">
      <!-- En-tête du profil -->
      <div class="p-6 border-b border-gray-200">
        <div class="flex flex-col sm:flex-row items-start sm:items-center">
          <div class="flex-shrink-0 mb-4 sm:mb-0 sm:mr-6">
            <div v-if="expert.avatar_url" class="h-24 w-24 rounded-full overflow-hidden">
              <img :src="expert.avatar_url" alt="Avatar" class="h-full w-full object-cover" />
            </div>
            <div v-else class="h-24 w-24 rounded-full bg-gray-200 flex items-center justify-center text-gray-600 text-2xl font-medium">
              {{ getInitials(expert.first_name, expert.last_name) }}
          </div>
          </div>
          
          <div class="flex-1">
            <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between">
              <div>
                <h1 class="text-2xl font-bold text-gray-900">
                  {{ expert.first_name }} {{ expert.last_name }}
                </h1>
                <div class="flex items-center mt-2">
                  <div class="flex items-center">
                    <svg class="w-5 h-5 text-yellow-400" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg">
                      <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
                    </svg>
                    <span class="ml-1 text-sm font-medium text-gray-700">{{ expert.average_rating || 'Nouveau' }}</span>
                    <span v-if="expert.review_count" class="ml-1 text-sm text-gray-500">({{ expert.review_count }} avis)</span>
          </div>
                  <span class="mx-2 text-gray-300">•</span>
                  <span class="text-sm text-gray-500">{{ formatDate(expert.created_at) }}</span>
                  <span class="mx-2 text-gray-300">•</span>
                  <span class="text-sm text-gray-500">{{ expert.city || 'Lieu non spécifié' }}</span>
        </div>
      </div>
      
              <div class="mt-4 sm:mt-0">
                <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-green-100 text-green-800">
                  Disponible
                </span>
              </div>
      </div>
      
            <div class="mt-4 flex flex-wrap gap-2">
              <span 
                v-for="(category, index) in expert.categories" 
                :key="`category-${index}`"
                class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-800"
              >
                {{ category }}
              </span>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Corps du profil -->
      <div class="p-6">
        <!-- À propos -->
        <div class="mb-8">
          <h2 class="text-lg font-medium text-gray-900 mb-4">À propos</h2>
          <p v-if="expert.bio" class="text-gray-600">{{ expert.bio }}</p>
          <p v-else class="text-gray-500 italic">Aucune biographie disponible</p>
        </div>
        
        <!-- Compétences -->
        <div class="mb-8">
          <h2 class="text-lg font-medium text-gray-900 mb-4">Compétences</h2>
          <div class="flex flex-wrap gap-2">
            <span 
              v-for="(skill, index) in expert.skills" 
              :key="`skill-${index}`"
              class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-primary-100 text-primary-800"
            >
              {{ skill }}
            </span>
            <p v-if="expert.skills.length === 0" class="text-gray-500 italic">Aucune compétence spécifiée</p>
          </div>
        </div>
        
        <!-- Services proposés -->
        <div v-if="services.length > 0" class="mb-8">
          <h2 class="text-lg font-medium text-gray-900 mb-4">Services proposés</h2>
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div 
              v-for="service in services" 
              :key="service.id"
              class="border border-gray-200 rounded-lg p-4 hover:shadow-sm transition-shadow"
            >
              <h3 class="font-medium text-gray-900 mb-2">{{ service.title }}</h3>
              <p class="text-sm text-gray-600 mb-3 line-clamp-2">{{ service.description }}</p>
              <div class="flex justify-between items-center">
                <span class="font-medium text-gray-900">{{ formatPrice(service.price) }}</span>
                <span class="text-sm text-gray-500">{{ formatDeliveryTime(service.delivery_time) }}</span>
              </div>
            </div>
          </div>
        </div>
        
        <!-- Avis -->
        <div class="mb-8">
          <h2 class="text-lg font-medium text-gray-900 mb-4">Avis ({{ reviews.length }})</h2>
          
          <div v-if="reviews.length === 0" class="text-center py-8 bg-gray-50 rounded-lg">
            <svg class="mx-auto h-12 w-12 text-gray-300" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M11.48 3.499a.562.562 0 011.04 0l2.125 5.111a.563.563 0 00.475.345l5.518.442c.499.04.701.663.321.988l-4.204 3.602a.563.563 0 00-.182.557l1.285 5.385a.562.562 0 01-.84.61l-4.725-2.885a.563.563 0 00-.586 0L6.982 20.54a.562.562 0 01-.84-.61l1.285-5.386a.562.562 0 00-.182-.557l-4.204-3.602a.563.563 0 01.321-.988l5.518-.442a.563.563 0 00.475-.345L11.48 3.5z" />
            </svg>
            <h3 class="mt-2 text-sm font-medium text-gray-900">Aucun avis pour le moment</h3>
            <p class="mt-1 text-sm text-gray-500">Cet expert n'a pas encore reçu d'avis.</p>
      </div>
      
          <div v-else class="space-y-4">
            <div 
              v-for="review in reviews" 
              :key="review.id"
              class="border-b border-gray-200 pb-4 last:border-b-0 last:pb-0"
            >
              <div class="flex items-start">
                <div class="flex-shrink-0 mr-4">
                  <div v-if="review.reviewer_avatar" class="h-10 w-10 rounded-full overflow-hidden">
                    <img :src="review.reviewer_avatar" alt="Avatar" class="h-full w-full object-cover" />
                  </div>
                  <div v-else class="h-10 w-10 rounded-full bg-gray-200 flex items-center justify-center text-gray-600 text-sm font-medium">
                    {{ getInitials(review.reviewer_name, '') }}
                  </div>
                </div>
                <div class="flex-1">
                  <div class="flex items-center justify-between">
                    <h4 class="text-sm font-medium text-gray-900">{{ review.reviewer_name }}</h4>
                    <span class="text-xs text-gray-500">{{ formatReviewDate(review.created_at) }}</span>
                  </div>
                  <div class="flex items-center mt-1 mb-2">
                    <div class="flex">
                      <svg 
                        v-for="i in 5" 
                        :key="i"
                        :class="[
                          'w-4 h-4', 
                          i <= review.rating ? 'text-yellow-400' : 'text-gray-300'
                        ]"
                        fill="currentColor" 
                        viewBox="0 0 20 20" 
                        xmlns="http://www.w3.org/2000/svg"
                      >
                        <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
                      </svg>
                    </div>
                  </div>
                  <p class="text-sm text-gray-600">{{ review.comment }}</p>
              </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Pied de page avec bouton de contact -->
      <div class="px-6 py-4 bg-gray-50 border-t border-gray-200">
        <div class="flex flex-col sm:flex-row sm:justify-between sm:items-center">
          <p class="text-sm text-gray-500 mb-4 sm:mb-0">
            Besoin des services de cet expert ? Contactez-le directement.
          </p>
          <button 
            @click="contactExpert"
            class="inline-flex items-center justify-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500"
          >
            <svg class="mr-2 h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z" />
            </svg>
            Contacter
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { useSupabaseClient, useSupabaseUser } from '#imports';
// import { useToast } from 'vue-toastification';

const route = useRoute();
const router = useRouter();
const supabase = useSupabaseClient();
const user = useSupabaseUser();
const toast = useToast();

// État
const isLoading = ref(true);
const error = ref(null);
const expert = ref(null);
const services = ref([]);
const reviews = ref([]);

// Récupérer le profil de l'expert
const fetchExpertProfile = async () => {
  isLoading.value = true;
  error.value = null;
  
  try {
    const expertId = route.params.id;
    
    // Récupérer les informations de l'expert
    const { data: expertData, error: expertError } = await supabase
        .from('profiles')
        .select(`
          id,
          first_name,
          last_name,
        avatar_url,
        bio,
        created_at,
    
        is_expert,
          user_skills (
            skills (
              id,
              name,
            category_id,
            categories:category_id (
              name
            )
          )
          )
        `)
        .eq('id', expertId)
        .eq('is_expert', true)
      .single();
    
    if (expertError) throw expertError;
    
    if (!expertData) {
      error.value = "Cet expert n'existe pas ou n'est pas disponible.";
      isLoading.value = false;
      return;
    }
    
    // Transformer les données pour faciliter l'affichage
    const skills = [];
    const categories = new Set();
    
    if (expertData.user_skills) {
      expertData.user_skills.forEach(userSkill => {
        if (userSkill.skills) {
          skills.push(userSkill.skills.name);
          
          if (userSkill.skills.categories) {
            categories.add(userSkill.skills.categories.name);
          }
        }
      });
    }
    
    expert.value = {
      ...expertData,
      skills,
      categories: Array.from(categories),
      average_rating: 4.7, // Valeur fictive pour l'exemple
      review_count: 23 // Valeur fictive pour l'exemple
    };
    
    // Récupérer les services de l'expert
    const { data: servicesData, error: servicesError } = await supabase
      .from('services')
      .select('*')
      .eq('expert_id', expertId)
      .eq('is_active', true);
    
    if (servicesError) throw servicesError;
    
    services.value = servicesData || [];
    
    // Récupérer les avis sur l'expert (données fictives pour l'exemple)
    reviews.value = [
      {
        id: 1,
        reviewer_name: 'Jean Dupont',
        reviewer_avatar: null,
        rating: 5,
        comment: 'Excellent travail, très professionnel et livraison dans les délais. Je recommande vivement !',
        created_at: '2023-06-15T10:30:00Z'
      },
      {
        id: 2,
        reviewer_name: 'Marie Martin',
        reviewer_avatar: null,
        rating: 4,
        comment: 'Bonne prestation, communication claire tout au long du projet.',
        created_at: '2023-05-22T14:15:00Z'
      }
    ];
    
  } catch (err) {
    console.error('Error fetching expert profile:', err);
    error.value = "Une erreur est survenue lors du chargement du profil. Veuillez réessayer.";
  } finally {
    isLoading.value = false;
  }
};

// Contacter l'expert
const contactExpert = async () => {
  if (!user.value) {
    toast.info('Veuillez vous connecter pour contacter cet expert');
    router.push('/login');
    return;
  }
  
  try {
    // Vérifier si une conversation existe déjà
    const { data: existingConversation, error: conversationError } = await supabase
      .from('conversations')
      .select('id')
      .eq('type', 'direct')
      .contains('participants', [user.value.id, expert.value.id])
      .maybeSingle();
    
    if (conversationError) throw conversationError;
    
    let conversationId;
    
    if (existingConversation) {
      conversationId = existingConversation.id;
    } else {
      // Créer une nouvelle conversation
      const { data: newConversation, error: createError } = await supabase
        .from('conversations')
        .insert({
          type: 'direct',
          participants: [user.value.id, expert.value.id]
        })
        .select('id')
        .single();
      
      if (createError) throw createError;
      
      conversationId = newConversation.id;
    }
    
    // Rediriger vers la conversation
    router.push(`/messages/${conversationId}`);
    
  } catch (err) {
    console.error('Error contacting expert:', err);
    toast.error("Une erreur est survenue. Veuillez réessayer.");
  }
};

// Formater la date
const formatDate = (dateString) => {
  if (!dateString) return 'Date inconnue';
  
  const date = new Date(dateString);
  const now = new Date();
  const diffTime = Math.abs(now - date);
  const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
  
  if (diffDays <= 30) {
    return 'Nouveau';
  } else {
    return `Membre depuis ${date.toLocaleDateString('fr-FR', { month: 'long', year: 'numeric' })}`;
  }
};

// Formater la date d'un avis
const formatReviewDate = (dateString) => {
  if (!dateString) return '';
  
  const date = new Date(dateString);
  return date.toLocaleDateString('fr-FR', { day: 'numeric', month: 'long', year: 'numeric' });
};

// Formater le prix
const formatPrice = (price) => {
  if (price === null || price === undefined) return 'Prix non défini';
  
  return new Intl.NumberFormat('fr-FR', {
    style: 'currency',
    currency: 'XOF',
    minimumFractionDigits: 0,
    maximumFractionDigits: 0
  }).format(price);
};

// Formater le délai de livraison
const formatDeliveryTime = (days) => {
  if (!days) return 'Délai non spécifié';
  
  if (days === 1) {
    return '1 jour';
  } else if (days < 7) {
    return `${days} jours`;
  } else if (days === 7) {
    return '1 semaine';
  } else if (days < 30) {
    const weeks = Math.floor(days / 7);
    return `${weeks} semaine${weeks > 1 ? 's' : ''}`;
  } else {
    const months = Math.floor(days / 30);
    return `${months} mois`;
  }
};

// Obtenir les initiales du nom
const getInitials = (firstName, lastName) => {
  if (!firstName && !lastName) return '';
  if (!firstName) return lastName.charAt(0).toUpperCase();
  if (!lastName) return firstName.charAt(0).toUpperCase();
  
  return `${firstName.charAt(0)}${lastName.charAt(0)}`.toUpperCase();
};

// Lifecycle hooks
onMounted(() => {
  fetchExpertProfile();
});
</script>

<style scoped>
.line-clamp-2 {
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
</style>