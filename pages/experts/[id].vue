// pages/experts/_id.vue
<template>
  <div class="min-h-screen bg-white">
    <!-- Main content with Twitter-style layout -->
    <div class="max-w-4xl mx-auto px-4 py-6">
      <!-- Back button with Twitter style -->
      <div class="mb-6">
        <NuxtLink to="/experts" class="inline-flex items-center text-gray-700 hover:text-primary-600 font-medium transition-colors">
          <ArrowLeft class="mr-2 w-4 h-4" />
          Retour aux experts
        </NuxtLink>
      </div>

      <!-- Enhanced loading state with Twitter spinner -->
      <div v-if="isLoading" class="flex flex-col items-center justify-center py-24">
        <div class="animate-spin h-10 w-10 mb-5 text-primary-500">
          <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="#E1E8ED" stroke-width="4"></circle>
            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
          </svg>
        </div>
        <p class="text-gray-500 font-medium">Chargement du profil de l'expert...</p>
      </div>
      
      <!-- Twitter-style error state -->
      <div v-else-if="error" class="bg-red-50 p-5 rounded-2xl border border-red-50 text-red-700">
        <div class="flex">
          <AlertCircle class="h-5 w-5 text-red-500 mr-3 flex-shrink-0" />
          <div>
            <p class="font-medium">{{ error }}</p>
            <button 
              @click="fetchExpertProfile" 
              class="mt-4 text-sm font-semibold text-red-600 hover:text-red-700 bg-red-50 hover:bg-red-100 px-5 py-2 rounded-full transition-colors"
            >
              Réessayer
            </button>
          </div>
        </div>
      </div>
      
      <!-- Expert profile with Twitter 2023 design aesthetic -->
      <div v-else-if="expert" class="space-y-6">
        <!-- Profile header with clean design -->
        <div class="bg-white rounded-2xl border border-gray-100 shadow-xs overflow-hidden">
          <div class="p-6">
            <div class="flex flex-col sm:flex-row sm:items-start">
              <!-- Profile picture with Twitter-style border -->
              <div class="flex-shrink-0 mb-4 sm:mb-0 sm:mr-6">
                <div v-if="expert.avatar_url" class="h-24 w-24 rounded-full overflow-hidden border border-gray-100">
                  <img :src="expert.avatar_url" alt="Avatar" class="h-full w-full object-cover" />
                </div>
                <div v-else class="h-24 w-24 rounded-full bg-primary-50 flex items-center justify-center text-2xl font-bold text-primary-600 border border-gray-100">
                  {{ getInitials(expert.first_name, expert.last_name) }}
                </div>
              </div>
              
              <div class="flex-1">
                <div class="flex flex-col sm:flex-row sm:items-start sm:justify-between">
                  <div>
                    <h1 class="text-2xl font-bold text-gray-900">
                      {{ expert.first_name }} {{ expert.last_name }}
                    </h1>
                    
                    <div class="flex flex-wrap items-center mt-2 text-sm text-gray-600">
                      <div class="flex items-center">
                        <Star class="w-4 h-4 text-amber-400" />
                        <span class="ml-1 font-medium">{{ expert.average_rating || 'Nouveau' }}</span>
                        <span v-if="expert.review_count" class="ml-1 text-gray-500">({{ expert.review_count }} avis)</span>
                      </div>
                      <span class="mx-2 text-gray-300">•</span>
                      <span>{{ formatDate(expert.created_at) }}</span>
                      <span v-if="expert.city" class="hidden sm:inline">
                        <span class="mx-2 text-gray-300">•</span>
                        <span>{{ expert.city }}</span>
                      </span>
                    </div>
                    
                    <!-- City for mobile -->
                    <span v-if="expert.city" class="sm:hidden block mt-1 text-sm text-gray-600">
                      <MapPin class="inline-block w-3.5 h-3.5 mr-1" />
                      {{ expert.city }}
                    </span>
                  </div>
                  
                  <div class="mt-4 sm:mt-0">
                    <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-green-50 text-green-700">
                      <CheckCircle class="w-3.5 h-3.5 mr-1" />
                      Disponible
                    </span>
                  </div>
                </div>
                
                <!-- Categories tags with Twitter-style pills -->
                <div class="mt-4 flex flex-wrap gap-2">
                  <span 
                    v-for="(category, index) in expert.professions" 
                    :key="`category-${index}`"
                    class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-gray-50 text-gray-700 hover:bg-gray-100 transition-colors"
                  >
                    {{ category }}
                  </span>
                </div>
              </div>
            </div>
            
            <!-- Contact button for smaller screens -->
            <div class="mt-6 sm:hidden">
              <button 
                @click="contactExpert"
                class="w-full inline-flex items-center justify-center px-4 py-2.5 text-sm font-medium rounded-full text-white bg-primary-600 hover:bg-primary-700 transition-colors"
              >
                <MessageSquare class="mr-2 h-4 w-4" />
                Contacter cet expert
              </button>
            </div>
          </div>
        </div>
        
        <!-- About section with Twitter card style -->
        <div class="bg-white rounded-2xl border border-gray-100 shadow-xs overflow-hidden">
          <div class="px-6 py-4 border-b border-gray-100">
            <h2 class="font-semibold text-gray-900">À propos</h2>
          </div>
          <div class="p-6">
            <p v-if="expert.bio" class="text-gray-700 whitespace-pre-line">{{ expert.bio }}</p>
            <div v-else class="flex items-center text-gray-500 italic">
              <InformationCircle class="w-4 h-4 mr-2 text-gray-400" />
              Aucune biographie disponible
            </div>
          </div>
        </div>
        
        <!-- Skills section with Twitter card style -->
        <div class="bg-white rounded-2xl border border-gray-100 shadow-xs overflow-hidden">
          <div class="px-6 py-4 border-b border-gray-100">
            <h2 class="font-semibold text-gray-900">Compétences</h2>
          </div>
          <div class="p-6">
            <div class="flex flex-wrap gap-2">
              <span 
                v-for="(skill, index) in expert.skills" 
                :key="`skill-${index}`"
                class="inline-flex items-center px-4 py-2 rounded-full text-sm font-medium bg-primary-50 text-primary-700 hover:bg-primary-100 transition-colors"
              >
                {{ skill }}
              </span>
            </div>
            <div v-if="expert.skills.length === 0" class="flex items-center text-gray-500 italic">
              <InformationCircle class="w-4 h-4 mr-2 text-gray-400" />
              Aucune compétence spécifiée
            </div>
          </div>
        </div>
        
        <!-- Services section with Twitter card style -->
        <div v-if="services.length > 0" class="bg-white rounded-2xl border border-gray-100 shadow-xs overflow-hidden">
          <div class="px-6 py-4 border-b border-gray-100 flex justify-between items-center">
            <h2 class="font-semibold text-gray-900">Services proposés</h2>
            <span class="text-sm text-gray-500">{{ services.length }} service{{ services.length > 1 ? 's' : '' }}</span>
          </div>
          <div class="p-6">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div 
                v-for="service in services" 
                :key="service.id"
                class="bg-white rounded-xl border border-gray-100 p-4 hover:border-gray-200 hover:shadow-sm transition-all cursor-pointer"
              >
                <h3 class="font-medium text-gray-900 mb-2">{{ service.title }}</h3>
                <p class="text-sm text-gray-600 mb-4 line-clamp-2">{{ service.description }}</p>
                <div class="flex justify-between items-center pt-2 border-t border-gray-50">
                  <span class="font-bold text-gray-900">{{ formatPrice(service.price) }}</span>
                  <span class="text-xs text-gray-500 flex items-center">
                    <Clock class="w-3.5 h-3.5 mr-1" />
                    {{ formatDeliveryTime(service.delivery_time) }}
                  </span>
                </div>
              </div>
            </div>
          </div>
        </div>
        
        <!-- Reviews section with Twitter card style -->
        <div class="bg-white rounded-2xl border border-gray-100 shadow-xs overflow-hidden">
          <div class="px-6 py-4 border-b border-gray-100 flex justify-between items-center">
            <h2 class="font-semibold text-gray-900">Avis</h2>
            <span class="inline-flex items-center text-sm">
              <Star class="w-4 h-4 text-amber-400 mr-1" />
              <span class="font-medium">{{ expert.average_rating || '-' }}</span>
              <span class="text-gray-500 ml-1">({{ reviews.length }})</span>
            </span>
          </div>
          
          <div class="divide-y divide-gray-100">
            <div v-if="reviews.length === 0" class="py-12 text-center">
              <div class="mx-auto h-16 w-16 text-gray-300 bg-gray-50 rounded-full flex items-center justify-center">
                <Star class="h-8 w-8" />
              </div>
              <h3 class="mt-4 text-base font-medium text-gray-900">Aucun avis pour le moment</h3>
              <p class="mt-1 text-sm text-gray-500">Cet expert n'a pas encore reçu d'avis.</p>
            </div>
            
            <div 
              v-for="review in reviews" 
              :key="review.id"
              class="p-6"
            >
              <div class="flex items-start">
                <div class="flex-shrink-0 mr-4">
                  <div v-if="review.reviewer_avatar" class="h-12 w-12 rounded-full overflow-hidden border border-gray-100">
                    <img :src="review.reviewer_avatar" alt="Avatar" class="h-full w-full object-cover" />
                  </div>
                  <div v-else class="h-12 w-12 rounded-full bg-gray-50 flex items-center justify-center text-base font-bold text-gray-500 border border-gray-100">
                    {{ getInitials(review.reviewer_name, '') }}
                  </div>
                </div>
                <div class="flex-1 min-w-0">
                  <div class="flex items-center justify-between">
                    <h4 class="text-base font-medium text-gray-900">{{ review.reviewer_name }}</h4>
                    <span class="text-xs text-gray-500">{{ formatReviewDate(review.created_at) }}</span>
                  </div>
                  <div class="flex items-center mt-1 mb-2">
                    <div class="flex">
                      <Star 
                        v-for="i in 5" 
                        :key="i"
                        :class="[
                          'w-4 h-4', 
                          i <= review.rating ? 'text-amber-400' : 'text-gray-200'
                        ]"
                      />
                    </div>
                  </div>
                  <p class="text-sm text-gray-700">{{ review.comment }}</p>
                </div>
              </div>
            </div>
          </div>
        </div>
        
        <!-- Contact section with Twitter-style layout -->
        <div class="hidden sm:block bg-white rounded-2xl border border-gray-100 shadow-xs overflow-hidden">
          <div class="p-6">
            <div class="flex flex-col sm:flex-row sm:justify-between sm:items-center">
              <div class="mb-4 sm:mb-0">
                <h3 class="text-base font-medium text-gray-900 mb-1">Besoin des services de cet expert ?</h3>
                <p class="text-sm text-gray-600">Contactez-le directement pour discuter de votre projet.</p>
              </div>
              <button 
                @click="contactExpert"
                class="inline-flex items-center justify-center px-5 py-2.5 text-sm font-medium rounded-full text-white bg-primary-600 hover:bg-primary-700 transition-colors"
              >
                <MessageSquare class="mr-2 h-4 w-4" />
                Contacter cet expert
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { useSupabaseClient, useSupabaseUser } from '#imports';
import { 
  Star, 
  MessageSquare, 
  Clock, 
  ArrowLeft,
  CheckCircle,
  MapPin,
  AlertCircle
} from 'lucide-vue-next';

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
            profession_id,
            professions:profession_id (
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
    const professions = new Set();
    
    if (expertData.user_skills) {
      expertData.user_skills.forEach(userSkill => {
        if (userSkill.skills) {
          skills.push(userSkill.skills.name);
          
          if (userSkill.skills.professions) {
            professions.add(userSkill.skills.professions.name);
          }
        }
      });
    }
    
    expert.value = {
      ...expertData,
      skills,
      professions: Array.from(professions),
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

/* Twitter-style subtle shadows */
.shadow-xs {
  box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
}

/* Enhanced Twitter-style animations */
.transition-colors {
  transition-property: background-color, border-color, color, fill, stroke;
  transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
  transition-duration: 300ms;
}

.transition-all {
  transition-property: all;
  transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
  transition-duration: 300ms;
}
</style>