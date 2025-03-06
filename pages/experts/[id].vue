<template>
  <div class="min-h-screen bg-white">
    <!-- En-tête avec bouton retour -->
    <div class="border-b border-gray-200">
      <div class="max-w-4xl mx-auto px-5 py-4 flex items-center">
      <button 
          @click="router.back()" 
          class="p-1 -ml-1 text-black"
      >
          <ChevronLeft class="h-6 w-6" />
      </button>
        <h1 class="text-xl font-bold text-black ml-2">Profil de l'expert</h1>
      </div>
    </div>
    
    <!-- Contenu principal -->
    <div class="max-w-4xl mx-auto px-5 pb-16">
      <!-- État de chargement -->
      <div v-if="loading" class="flex justify-center py-20">
        <Loader2 class="h-8 w-8 text-gray-400 animate-spin" />
      </div>
      
      <!-- Profil de l'expert -->
      <div v-else-if="expert" class="space-y-8 pt-6">
        <!-- Informations principales -->
        <div class="flex flex-col md:flex-row gap-6 items-start">
          <!-- Photo de profil -->
          <div class="h-24 w-24 md:h-32 md:w-32 rounded-full bg-gray-100 overflow-hidden flex-shrink-0">
            <img 
              v-if="expert.profile_image_url" 
              :src="expert.profile_image_url" 
              alt="Photo de profil" 
              class="w-full h-full object-cover"
            />
            <div v-else class="w-full h-full flex items-center justify-center bg-gray-200">
              <User class="h-12 w-12 text-gray-400" />
            </div>
          </div>
          
          <!-- Infos de l'expert -->
          <div class="flex-1">
            <h2 class="text-2xl font-bold text-black">
              {{ expert.first_name }} {{ expert.last_name }}
            </h2>
            
            <div class="flex items-center gap-1 mt-2">
              <Star class="h-5 w-5 text-yellow-400 fill-yellow-400" />
              <span class="text-lg font-medium">{{ expert.rating || '4.8' }}</span>
              <span class="text-gray-500">({{ expert.reviews_count || '12' }} avis)</span>
          </div>
          
            <div class="flex flex-wrap gap-4 mt-3">
              <div class="flex items-center text-gray-600">
                <MapPin class="h-4 w-4 mr-1.5" />
                <span>{{ expert.city || 'Paris' }}, {{ expert.postal_code || '75000' }}</span>
                </div>
              <div class="flex items-center text-gray-600">
                <Calendar class="h-4 w-4 mr-1.5" />
                <span>Membre depuis {{ formatDate(expert.created_at) }}</span>
            </div>
          </div>
          
            <!-- Tarifs -->
            <div class="mt-4 p-4 bg-gray-50 rounded-xl border border-gray-100">
              <div class="text-lg font-semibold text-black">
                À partir de {{ expert.hourly_rate || '25' }}€/heure
              </div>
              <p class="text-gray-600 text-sm mt-1">
                Les tarifs peuvent varier selon le type de service et la complexité
              </p>
            </div>
          </div>
        </div>
        
        <!-- Call to action -->
        <div class="flex flex-col sm:flex-row gap-4">
          <button 
            @click="contactExpert"
            class="flex-1 py-3.5 bg-primary-600 text-white font-medium rounded-full hover:bg-primary-700 transition-colors flex items-center justify-center"
          >
            <MessageSquare class="h-5 w-5 mr-2" />
            Contacter
          </button>
          
          <button 
            @click="showRequestForm = true"
            class="flex-1 py-3.5 border border-gray-300 text-black font-medium rounded-full hover:bg-gray-100 transition-colors flex items-center justify-center"
          >
            <CalendarPlus class="h-5 w-5 mr-2" />
            Demander un service
          </button>
                </div>
        
        <!-- À propos / Bio -->
                <div>
          <h3 class="text-xl font-bold text-black mb-4">À propos</h3>
          <p class="text-gray-700 whitespace-pre-line">
            {{ expert.bio || 'Expert professionnel disponible pour tous vos besoins de services. N\'hésitez pas à me contacter pour discuter de votre projet.' }}
          </p>
            </div>
            
        <!-- Spécialités -->
        <div>
          <h3 class="text-xl font-bold text-black mb-4">Spécialités</h3>
          <div class="grid grid-cols-1 md:grid-cols-2 gap-3">
            <div 
              v-for="(specialty, index) in getExpertiseAreas(expert)" 
              :key="index"
              class="flex items-center p-3 bg-gray-50 rounded-lg border border-gray-100"
            >
              <Check class="h-5 w-5 text-green-500 mr-2" />
              <span>{{ specialty }}</span>
            </div>
          </div>
        </div>
        
        <!-- Avis -->
        <div>
          <h3 class="text-xl font-bold text-black mb-4">Avis clients</h3>
          
          <div v-if="reviews.length > 0" class="space-y-4">
            <div 
              v-for="review in reviews" 
              :key="review.id"
              class="p-4 border border-gray-200 rounded-xl"
            >
              <div class="flex justify-between">
                <div class="flex items-center">
                  <div class="h-10 w-10 rounded-full bg-gray-100 mr-3">
                    <img 
                      v-if="review.author_image"
                      :src="review.author_image"
                      class="h-full w-full object-cover rounded-full"
                      alt="Photo de profil"
                    />
                    <div v-else class="h-full w-full flex items-center justify-center">
                      <User class="h-5 w-5 text-gray-400" />
                    </div>
                  </div>
                  <div>
                    <div class="font-medium">{{ review.author_name }}</div>
                    <div class="text-xs text-gray-500">{{ formatDate(review.created_at) }}</div>
                  </div>
                </div>
                
                <div class="flex items-center">
                <div class="flex">
                  <Star 
                    v-for="i in 5" 
                    :key="i"
                      class="h-4 w-4"
                      :class="i <= review.rating ? 'text-yellow-400 fill-yellow-400' : 'text-gray-300'"
                  />
                  </div>
                </div>
              </div>
              
              <p class="text-gray-700 text-sm mt-3">{{ review.comment }}</p>
            </div>
          </div>
          
          <div v-else class="p-6 text-center bg-gray-50 rounded-xl">
            <MessageSquare class="h-10 w-10 text-gray-400 mx-auto mb-3" />
            <p class="text-gray-600">Cet expert n'a pas encore reçu d'avis</p>
          </div>
        </div>
      </div>
      
      <!-- Modal de demande de service -->
      <Modal v-if="showRequestForm" @close="showRequestForm = false">
        <template #header>
          <h2 class="text-xl font-bold">Demander un service</h2>
        </template>
        
        <template #default>
          <div class="space-y-4 py-2">
            <p class="text-gray-600">
              Vous allez faire une demande de service auprès de 
              <span class="font-medium">{{ expert.first_name }} {{ expert.last_name }}</span>
            </p>
            
            <NuxtLink 
              to="/requests/new" 
              class="block w-full py-3 mt-4 bg-primary-600 text-white font-medium rounded-full hover:bg-primary-700 transition-colors text-center"
            >
              Créer une nouvelle demande
            </NuxtLink>
            
            <div class="text-center">
              <button 
                @click="showRequestForm = false"
                class="text-gray-600 text-sm font-medium hover:text-black"
              >
                Annuler
              </button>
            </div>
          </div>
        </template>
      </Modal>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { 
  ChevronLeft, Loader2, Star, User, MapPin, Calendar, 
  MessageSquare, CalendarPlus, Check 
} from 'lucide-vue-next'

const route = useRoute()
const router = useRouter()
const client = useSupabaseClient()

// États
const loading = ref(true)
const expert = ref(null)
const categories = ref([])
const reviews = ref([])
const showRequestForm = ref(false)

// Obtenir les domaines d'expertise d'un expert
const getExpertiseAreas = (expert) => {
  if (!expert.expertise_areas) return []
  
  return expert.expertise_areas.map(area => {
    const category = categories.value.find(c => c.id === area.category_id)
    return area.service_name || (category ? category.name : 'Service')
  })
}

// Formater la date
const formatDate = (dateString) => {
  if (!dateString) return ''
  const date = new Date(dateString)
  return date.toLocaleDateString('fr-FR', {
    day: 'numeric',
    month: 'long',
    year: 'numeric'
  })
}

// Actions
const contactExpert = () => {
  alert('Fonctionnalité de messagerie en cours de développement')
  // TODO: Rediriger vers la messagerie ou ouvrir un modal de contact
}

// Charger les données
const fetchExpertData = async () => {
  try {
    loading.value = true
    
    // Récupérer les catégories
    const { data: categoriesData, error: categoriesError } = await client
      .from('service_categories')
      .select('id, name')
    
    if (categoriesError) throw categoriesError
    categories.value = categoriesData || []
    
    // Récupérer les infos de l'expert
    const { data: expertData, error: expertError } = await client
      .from('profiles')
      .select(`
        *,
        expertise_areas:expert_services(category_id, service_id, service_name)
      `)
      .eq('id', route.params.id)
      .eq('role', 'expert')
      .single()
    
    if (expertError) throw expertError
    
    if (!expertData) {
      // Rediriger si l'expert n'existe pas
      router.push('/experts')
      return
    }
    
    expert.value = expertData
    
    // Récupérer les avis (pour l'exemple, des avis générés)
    reviews.value = [
    {
      id: 1,
        author_name: 'Sophie Martin',
        rating: 5,
        comment: 'Excellent service, rapide et professionnel. Je recommande vivement !',
        created_at: '2023-09-15'
    },
    {
      id: 2,
        author_name: 'Julien Dupont',
        rating: 4,
        comment: 'Très satisfait du travail effectué. Ponctuel et efficace.',
        created_at: '2023-08-22'
    },
    {
      id: 3,
        author_name: 'Marie Leclerc',
        rating: 5,
        comment: 'Service impeccable, je n\'hésiterai pas à faire appel à nouveau à cet expert.',
        created_at: '2023-07-10'
      }
    ]
  } catch (error) {
    console.error('Erreur lors du chargement des données:', error)
  } finally {
    loading.value = false
  }
}

// Composant modal simple
const Modal = defineComponent({
  emits: ['close'],
  setup(_, { emit, slots }) {
    return () => h('div', {
      class: 'fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-50',
      onClick: (e) => {
        if (e.target === e.currentTarget) emit('close')
      }
    }, [
      h('div', {
        class: 'bg-white rounded-2xl max-w-md w-full p-5 max-h-[90vh] overflow-auto'
      }, [
        h('div', { class: 'flex justify-between items-center mb-4' }, [
          slots.header?.(),
          h('button', {
            onClick: () => emit('close'),
            class: 'text-gray-500 hover:text-black'
          }, [
            h('svg', {
              xmlns: 'http://www.w3.org/2000/svg',
              class: 'h-6 w-6',
              fill: 'none',
              viewBox: '0 0 24 24',
              stroke: 'currentColor'
            }, [
              h('path', {
                'stroke-linecap': 'round',
                'stroke-linejoin': 'round',
                'stroke-width': '2',
                d: 'M6 18L18 6M6 6l12 12'
              })
            ])
          ])
        ]),
        slots.default?.()
      ])
    ])
  }
})

// Charger les données lors du montage du composant
onMounted(fetchExpertData)

definePageMeta({
  layout: 'default'
})
</script> 

<style scoped>
/* Animation des étoiles */
.fill-yellow-400 {
  fill: #facc15;
}
</style> 