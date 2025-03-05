<template>
  <div class="max-w-3xl mx-auto px-4 py-12">
    <!-- En-tête -->
    <div class="flex flex-col md:flex-row justify-between items-start md:items-center gap-6 mb-8">
      <div>
        <h1 class="text-3xl font-bold text-gray-900">Nos experts</h1>
        <p class="mt-2 text-gray-600">Découvrez nos professionnels qualifiés prêts à vous aider</p>
      </div>
      
      <!-- Filtres -->
      <div class="flex items-center gap-3">
        <div class="relative">
          <input 
            type="text" 
            placeholder="Rechercher un expert..." 
            class="pl-10 pr-4 py-2.5 w-64 rounded-xl border border-gray-200 focus:border-primary-300 focus:ring focus:ring-primary-200 focus:ring-opacity-50"
          />
          <Search class="w-5 h-5 text-gray-400 absolute left-3 top-1/2 transform -translate-y-1/2" />
        </div>
        
        <button 
          @click="showFilters = !showFilters"
          class="p-2.5 rounded-xl border border-gray-200 text-gray-700 hover:bg-gray-50"
        >
          <SlidersHorizontal class="w-5 h-5" />
        </button>
      </div>
    </div>
    
    <!-- Filtres avancés (collapsible) -->
    <div v-if="showFilters" class="bg-white rounded-2xl shadow-sm border border-gray-200 p-6 mb-8">
      <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
        <!-- Catégories de services -->
        <div>
          <h3 class="font-medium text-gray-900 mb-3">Catégories</h3>
          <div class="space-y-2">
            <label v-for="category in categories" :key="category.id" class="flex items-center gap-2">
              <input 
                type="checkbox" 
                :value="category.id" 
                v-model="selectedCategories"
                class="rounded text-primary-600 focus:ring-primary-500"
              />
              <span class="text-gray-700">{{ category.name }}</span>
            </label>
          </div>
        </div>
        
        <!-- Localisation -->
        <div>
          <h3 class="font-medium text-gray-900 mb-3">Localisation</h3>
          <select 
            v-model="selectedLocation" 
            class="w-full rounded-lg border-gray-300 focus:border-primary-300 focus:ring focus:ring-primary-200 focus:ring-opacity-50"
          >
            <option value="">Toutes les localisations</option>
            <option v-for="location in locations" :key="location" :value="location">
              {{ location }}
            </option>
          </select>
        </div>
        
        <!-- Note minimale -->
        <div>
          <h3 class="font-medium text-gray-900 mb-3">Note minimale</h3>
          <div class="flex items-center gap-2">
            <button 
              v-for="rating in 5" 
              :key="rating"
              @click="minRating = rating"
              class="flex items-center justify-center w-10 h-10 rounded-lg border"
              :class="rating <= minRating ? 'bg-primary-50 border-primary-200 text-primary-700' : 'border-gray-200 text-gray-400'"
            >
              {{ rating }}
            </button>
            <button 
              @click="minRating = 0"
              class="ml-2 text-sm text-gray-500 hover:text-gray-700"
            >
              Réinitialiser
            </button>
          </div>
        </div>
      </div>
      
      <!-- Actions -->
      <div class="flex justify-end mt-6">
        <button 
          @click="applyFilters"
          class="px-4 py-2 bg-primary-600 text-white rounded-lg hover:bg-primary-700"
        >
          Appliquer les filtres
        </button>
      </div>
    </div>
    
    <!-- Liste des experts style CNI française -->
    <div class="space-y-4">
      <NuxtLink 
        v-for="expert in filteredExperts" 
        :key="expert.id"
        :to="`/experts/${expert.id}`"
        class="block"
      >
        <div class="bg-white rounded-xl border border-gray-200 overflow-hidden hover:shadow-md transition-shadow">
          <!-- Bannière bleue style CNI -->
          <div class="h-10 bg-gradient-to-r from-blue-600 to-blue-700 flex items-center justify-between px-4">
            <div class="flex items-center gap-2">
              <span class="text-white text-sm font-medium">République Française</span>
              <span class="text-blue-200">•</span>
              <span class="text-white text-sm font-medium">Expert vérifié</span>
            </div>
            <div class="text-xs text-blue-100">ID: {{ expert.id }}</div>
          </div>
          
          <div class="flex">
            <!-- Partie gauche (photo) - ratio d'or: 38.2% -->
            <div class="w-[38.2%] p-4 flex flex-col items-center justify-center border-r border-gray-100">
              <!-- Photo -->
              <div class="w-32 h-40 bg-gray-100 relative overflow-hidden border border-gray-200">
                <img 
                  :src="expert.avatar" 
                  :alt="expert.name"
                  class="w-full h-full object-cover"
                />
              </div>
              
              <!-- Badge de vérification -->
              <div class="mt-3 flex items-center gap-1 bg-green-100 px-2 py-1 rounded-full">
                <CheckCircle class="w-3 h-3 text-green-600" />
                <span class="text-xs font-medium text-green-800">Identité vérifiée</span>
              </div>
              
              <!-- Note -->
              <div class="mt-2 flex items-center gap-1">
                <div class="flex">
                  <Star 
                    v-for="i in 5" 
                    :key="i"
                    class="w-3 h-3" 
                    :class="i <= Math.floor(expert.rating) ? 'text-yellow-400 fill-current' : 'text-gray-300'"
                  />
                </div>
                <span class="text-xs text-gray-700">({{ expert.reviewCount }})</span>
              </div>
            </div>
            
            <!-- Partie droite (informations) - ratio d'or: 61.8% -->
            <div class="w-[61.8%] p-4">
              <!-- En-tête -->
              <div class="border-b border-gray-100 pb-2">
                <h3 class="text-base font-bold text-gray-900">{{ expert.name }}</h3>
                <p class="text-sm text-gray-600">{{ expert.title }}</p>
              </div>
              
              <!-- Informations principales -->
              <div class="mt-3 space-y-2">
                <div class="flex items-start gap-2">
                  <MapPin class="w-4 h-4 text-gray-400 mt-0.5" />
                  <div>
                    <p class="text-xs font-medium text-gray-700">Adresse</p>
                    <p class="text-sm text-gray-900">{{ expert.location }}</p>
                  </div>
                </div>
                
                <div class="flex items-start gap-2">
                  <Calendar class="w-4 h-4 text-gray-400 mt-0.5" />
                  <div>
                    <p class="text-xs font-medium text-gray-700">Membre depuis</p>
                    <p class="text-sm text-gray-900">{{ expert.memberSince }}</p>
                  </div>
                </div>
                
                <div class="flex items-start gap-2">
                  <Briefcase class="w-4 h-4 text-gray-400 mt-0.5" />
                  <div>
                    <p class="text-xs font-medium text-gray-700">Services</p>
                    <div class="flex flex-wrap gap-1 mt-1">
                      <span 
                        v-for="service in expert.services" 
                        :key="service.id"
                        class="px-1.5 py-0.5 bg-gray-100 rounded-full text-[10px] text-gray-700 flex items-center gap-0.5"
                      >
                        <span>{{ service.icon }}</span>
                        <span>{{ service.name }}</span>
                      </span>
                    </div>
                  </div>
                </div>
              </div>
              
              <!-- Actions -->
              <div class="mt-4 flex gap-2">
                <button 
                  @click.prevent="toggleFavorite(expert.id)"
                  class="px-3 py-1.5 border rounded-lg text-sm flex items-center gap-1 transition-colors"
                  :class="expert.isFavorite ? 'bg-red-50 text-red-600 border-red-200' : 'border-gray-200 text-gray-600 hover:bg-gray-50'"
                >
                  <Heart class="w-4 h-4" :class="expert.isFavorite ? 'fill-current' : ''" />
                  <span>{{ expert.isFavorite ? 'Favori' : 'Ajouter' }}</span>
                </button>
                <button 
                  @click.prevent="contactExpert(expert.id)"
                  class="px-3 py-1.5 bg-primary-600 text-white text-sm rounded-lg hover:bg-primary-700 transition-colors flex items-center gap-1"
                >
                  <MessageSquare class="w-4 h-4" />
                  <span>Contacter</span>
                </button>
              </div>
            </div>
          </div>
          
          <!-- Pied de carte -->
          <div class="px-4 py-2 bg-gray-50 border-t border-gray-200 flex justify-between items-center">
            <div class="text-xs text-gray-500">
              Signature électronique
            </div>
            <div class="text-xs text-gray-500">
              Valide jusqu'au 31/12/2024
            </div>
          </div>
        </div>
      </NuxtLink>
    </div>
    
    <!-- Pagination -->
    <div class="mt-8 flex justify-center">
      <div class="flex items-center gap-1">
        <button class="w-8 h-8 rounded-lg border border-gray-200 flex items-center justify-center text-gray-500 hover:bg-gray-50">
          <ChevronLeft class="w-4 h-4" />
        </button>
        <button class="w-8 h-8 rounded-lg border border-gray-200 flex items-center justify-center bg-primary-50 text-primary-600 border-primary-200 font-medium">
          1
        </button>
        <button class="w-8 h-8 rounded-lg border border-gray-200 flex items-center justify-center text-gray-700 hover:bg-gray-50">
          2
        </button>
        <button class="w-8 h-8 rounded-lg border border-gray-200 flex items-center justify-center text-gray-700 hover:bg-gray-50">
          3
        </button>
        <span class="w-8 h-8 flex items-center justify-center text-gray-400">...</span>
        <button class="w-8 h-8 rounded-lg border border-gray-200 flex items-center justify-center text-gray-700 hover:bg-gray-50">
          8
        </button>
        <button class="w-8 h-8 rounded-lg border border-gray-200 flex items-center justify-center text-gray-500 hover:bg-gray-50">
          <ChevronRight class="w-4 h-4" />
        </button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { 
  Search, SlidersHorizontal, Heart, Star, MapPin, 
  CheckCircle, ChevronLeft, ChevronRight, Calendar,
  Briefcase, MessageSquare
} from 'lucide-vue-next'

// États
const showFilters = ref(false)
const selectedCategories = ref<string[]>([])
const selectedLocation = ref('')
const minRating = ref(0)

// Catégories
const categories = ref([
  { id: 'menage', name: 'Ménage' },
  { id: 'jardinage', name: 'Jardinage' },
  { id: 'bricolage', name: 'Bricolage' },
  { id: 'garde', name: 'Garde d\'enfants' },
  { id: 'cours', name: 'Cours particuliers' },
  { id: 'informatique', name: 'Informatique' }
])

// Localisations
const locations = ref([
  'Cotonou, Bénin',
  'Abidjan, Côte d\'Ivoire',
  'Lomé, Togo',
  'Dakar, Sénégal',
  'Ouagadougou, Burkina Faso'
])

const experts = ref([
  {
    id: 1,
    name: 'Aminata Diallo',
    title: 'Spécialiste en ménage',
    avatar: 'https://randomuser.me/api/portraits/women/65.jpg',
    memberSince: 'Janvier 2023',
    rating: 4.8,
    reviewCount: 24,
    services: [
      { id: 'menage', name: 'Ménage', icon: '🧹' },
      { id: 'repassage', name: 'Repassage', icon: '👕' }
    ],
    bio: 'Professionnelle du ménage avec 5 ans d\'expérience. Je propose des services de nettoyage complets pour particuliers et entreprises.',
    location: 'Cotonou, Bénin',
    isFavorite: false
  },
  {
    id: 2,
    name: 'Kofi Mensah',
    title: 'Jardinier paysagiste',
    avatar: 'https://randomuser.me/api/portraits/men/42.jpg',
    memberSince: 'Mars 2022',
    rating: 4.6,
    reviewCount: 18,
    services: [
      { id: 'jardinage', name: 'Jardinage', icon: '🌱' },
      { id: 'paysagisme', name: 'Paysagisme', icon: '🌳' }
    ],
    bio: 'Jardinier passionné, je m\'occupe de l\'entretien et de l\'aménagement de vos espaces verts. Diplômé en horticulture.',
    location: 'Cotonou, Bénin',
    isFavorite: true
  },
  {
    id: 3,
    name: 'Ibrahim Touré',
    title: 'Bricoleur multi-services',
    avatar: 'https://randomuser.me/api/portraits/men/32.jpg',
    memberSince: 'Janvier 2022',
    rating: 4.9,
    reviewCount: 37,
    services: [
      { id: 'bricolage', name: 'Bricolage', icon: '🔨' },
      { id: 'plomberie', name: 'Plomberie', icon: '🚿' },
      { id: 'electricite', name: 'Électricité', icon: '💡' }
    ],
    bio: 'Technicien polyvalent avec plus de 10 ans d\'expérience. Je réalise tous types de travaux de bricolage, plomberie et électricité.',
    location: 'Abidjan, Côte d\'Ivoire',
    isFavorite: false
  },
  {
    id: 4,
    name: 'Fatou Ndiaye',
    title: 'Nounou expérimentée',
    avatar: 'https://randomuser.me/api/portraits/women/28.jpg',
    memberSince: 'Juin 2023',
    rating: 4.7,
    reviewCount: 15,
    services: [
      { id: 'garde', name: 'Garde d\'enfants', icon: '👶' },
      { id: 'aide_devoirs', name: 'Aide aux devoirs', icon: '📚' }
    ],
    bio: 'Nounou attentionnée et patiente, je m\'occupe de vos enfants avec bienveillance. Diplômée en petite enfance.',
    location: 'Dakar, Sénégal',
    isFavorite: false
  },
  {
    id: 5,
    name: 'Moussa Ouedraogo',
    title: 'Professeur particulier',
    avatar: 'https://randomuser.me/api/portraits/men/55.jpg',
    memberSince: 'Septembre 2022',
    rating: 4.5,
    reviewCount: 12,
    services: [
      { id: 'cours', name: 'Cours particuliers', icon: '📚' },
      { id: 'maths', name: 'Mathématiques', icon: '🔢' },
      { id: 'physique', name: 'Physique', icon: '⚛️' }
    ],
    bio: 'Enseignant certifié en mathématiques et physique. J\'aide les élèves à progresser et à préparer leurs examens.',
    location: 'Ouagadougou, Burkina Faso',
    isFavorite: false
  },
  {
    id: 6,
    name: 'Ama Koffi',
    title: 'Technicienne informatique',
    avatar: 'https://randomuser.me/api/portraits/women/45.jpg',
    memberSince: 'Avril 2022',
    rating: 4.9,
    reviewCount: 28,
    services: [
      { id: 'informatique', name: 'Dépannage informatique', icon: '💻' },
      { id: 'formation', name: 'Formation', icon: '🎓' }
    ],
    bio: 'Ingénieure en informatique, je propose des services de dépannage, installation et formation sur tous types d\'appareils.',
    location: 'Lomé, Togo',
    isFavorite: false
  }
])

// Computed
const filteredExperts = computed(() => {
  let result = [...experts.value]
  
  // Filtrer par catégorie
  if (selectedCategories.value.length > 0) {
    result = result.filter(expert => 
      expert.services.some(service => 
        selectedCategories.value.includes(service.id)
      )
    )
  }
  
  // Filtrer par localisation
  if (selectedLocation.value) {
    result = result.filter(expert => 
      expert.location === selectedLocation.value
    )
  }
  
  // Filtrer par note minimale
  if (minRating.value > 0) {
    result = result.filter(expert => 
      expert.rating >= minRating.value
    )
  }
  
  return result
})

// Méthodes
const applyFilters = () => {
  showFilters.value = false
  // Les filtres sont déjà appliqués via le computed
}

const toggleFavorite = (id: number) => {
  const expert = experts.value.find(e => e.id === id)
  if (expert) {
    expert.isFavorite = !expert.isFavorite
  }
}

const contactExpert = (id: number) => {
  // Rediriger vers la messagerie
  navigateTo(`/messages?expert=${id}`)
}
</script> 