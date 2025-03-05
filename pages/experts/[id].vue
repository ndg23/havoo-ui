<template>
  <div class="max-w-4xl mx-auto px-4 py-12">
    <!-- En-tête avec navigation -->
    <div class="flex items-center justify-between mb-8">
      <NuxtLink 
        to="/experts" 
        class="text-sm text-gray-600 hover:text-gray-900 flex items-center gap-1"
      >
        <ArrowLeft class="w-4 h-4" />
        <span>Retour aux experts</span>
      </NuxtLink>
      
      <button 
        class="p-2 rounded-full text-gray-400 hover:text-red-500 hover:bg-red-50 transition-colors"
        :class="expert.isFavorite ? 'text-red-500' : ''"
        @click="toggleFavorite"
      >
        <Heart class="w-5 h-5" :class="expert.isFavorite ? 'fill-current' : ''" />
      </button>
    </div>
    
    <!-- Carte d'expert style CNI -->
    <div class="bg-white rounded-2xl shadow-sm border border-gray-200 overflow-hidden">
      <!-- En-tête de la carte -->
      <div class="bg-gradient-to-r from-blue-600 to-blue-700 p-6 text-white">
        <div class="flex items-center justify-between">
          <div>
            <h1 class="text-2xl font-bold">Expert en services</h1>
            <p class="text-blue-100 mt-1">Carte d'identité professionnelle</p>
          </div>
          <div class="flex flex-col items-end">
            <span class="text-sm text-blue-100">ID: {{ expert.id }}</span>
            <span class="text-sm text-blue-100">Membre depuis {{ expert.memberSince }}</span>
          </div>
        </div>
      </div>
      
      <!-- Photo et informations principales -->
      <div class="p-6 flex flex-col md:flex-row gap-6 border-b border-gray-200">
        <!-- Photo et statut de vérification -->
        <div class="w-full md:w-1/3 flex flex-col items-center">
          <div class="w-40 h-40 rounded-xl overflow-hidden border-4 border-white shadow-md">
            <img 
              :src="expert.avatar" 
              :alt="expert.name"
              class="w-full h-full object-cover"
            />
          </div>
          <div class="mt-4 flex items-center gap-1 bg-green-100 px-3 py-1 rounded-full">
            <CheckCircle class="w-4 h-4 text-green-600" />
            <span class="text-sm font-medium text-green-800">Identité vérifiée</span>
          </div>
        </div>
        
        <!-- Informations principales -->
        <div class="w-full md:w-2/3">
          <h2 class="text-2xl font-bold text-gray-900">{{ expert.name }}</h2>
          <p class="text-lg text-gray-600">{{ expert.title }}</p>
          
          <!-- Note et avis -->
          <div class="mt-3 flex items-center gap-2">
            <div class="flex">
              <Star 
                v-for="i in 5" 
                :key="i"
                class="w-5 h-5" 
                :class="i <= Math.floor(expert.rating) ? 'text-yellow-400 fill-current' : 'text-gray-300'"
              />
            </div>
            <span class="font-medium text-gray-900">{{ expert.rating }}</span>
            <span class="text-gray-500">({{ expert.reviewCount }} avis)</span>
          </div>
          
          <!-- Localisation -->
          <div class="mt-4 flex items-center gap-2 text-gray-600">
            <MapPin class="w-5 h-5" />
            <span>{{ expert.location }}</span>
          </div>
          
          <!-- Services proposés -->
          <div class="mt-4">
            <h3 class="font-medium text-gray-900 mb-2">Services proposés</h3>
            <div class="flex flex-wrap gap-2">
              <span 
                v-for="service in expert.services" 
                :key="service.id"
                class="px-3 py-1.5 bg-gray-100 rounded-full text-sm text-gray-800 flex items-center gap-1"
              >
                <span>{{ service.icon }}</span>
                <span>{{ service.name }}</span>
              </span>
            </div>
          </div>
          
          <!-- Actions -->
          <div class="mt-6 flex gap-3">
            <button 
              @click="contactExpert"
              class="flex-1 px-4 py-2.5 bg-primary-600 text-white rounded-xl font-medium hover:bg-primary-700 transition-colors flex items-center justify-center gap-2"
            >
              <MessageSquare class="w-5 h-5" />
              <span>Contacter</span>
            </button>
            <button 
              @click="showRequestForm = true"
              class="flex-1 px-4 py-2.5 border border-gray-300 text-gray-700 rounded-xl font-medium hover:bg-gray-50 transition-colors flex items-center justify-center gap-2"
            >
              <ClipboardList class="w-5 h-5" />
              <span>Demander un service</span>
            </button>
          </div>
        </div>
      </div>
      
      <!-- Onglets d'information -->
      <div class="border-b border-gray-200">
        <div class="flex overflow-x-auto">
          <button 
            v-for="tab in tabs" 
            :key="tab.id"
            @click="activeTab = tab.id"
            class="px-6 py-4 text-sm font-medium whitespace-nowrap border-b-2 transition-colors"
            :class="activeTab === tab.id ? 'border-primary-600 text-primary-600' : 'border-transparent text-gray-500 hover:text-gray-700'"
          >
            {{ tab.name }}
          </button>
        </div>
      </div>
      
      <!-- Contenu des onglets -->
      <div class="p-6">
        <!-- À propos -->
        <div v-if="activeTab === 'about'" class="space-y-6">
          <div>
            <h3 class="text-lg font-medium text-gray-900 mb-3">Biographie</h3>
            <p class="text-gray-600">{{ expert.bio }}</p>
          </div>
          
          <div>
            <h3 class="text-lg font-medium text-gray-900 mb-3">Compétences</h3>
            <div class="flex flex-wrap gap-2">
              <span 
                v-for="skill in expert.skills" 
                :key="skill.id"
                class="px-3 py-1.5 bg-gray-100 rounded-full text-sm text-gray-800"
              >
                {{ skill.name }}
              </span>
            </div>
          </div>
          
          <div>
            <h3 class="text-lg font-medium text-gray-900 mb-3">Langues parlées</h3>
            <div class="flex flex-wrap gap-4">
              <div v-for="language in expert.languages" :key="language.name" class="flex items-center gap-2">
                <span class="text-xl">{{ language.flag }}</span>
                <div>
                  <p class="font-medium text-gray-900">{{ language.name }}</p>
                  <p class="text-sm text-gray-500">{{ language.level }}</p>
                </div>
              </div>
            </div>
          </div>
          
          <div>
            <h3 class="text-lg font-medium text-gray-900 mb-3">Diplômes et certifications</h3>
            <div class="space-y-3">
              <div 
                v-for="certification in expert.certifications" 
                :key="certification.id"
                class="flex items-start gap-3"
              >
                <div class="w-10 h-10 rounded-full bg-blue-100 flex items-center justify-center text-blue-600">
                  <Award class="w-5 h-5" />
                </div>
                <div>
                  <p class="font-medium text-gray-900">{{ certification.title }}</p>
                  <p class="text-sm text-gray-500">{{ certification.institution }} • {{ certification.year }}</p>
                </div>
              </div>
            </div>
          </div>
        </div>
        
        <!-- Services et tarifs -->
        <div v-if="activeTab === 'services'" class="space-y-6">
          <div v-for="service in expert.detailedServices" :key="service.id" class="border border-gray-200 rounded-xl p-5">
            <div class="flex items-start justify-between">
              <div class="flex items-center gap-3">
                <div class="w-12 h-12 rounded-full bg-primary-50 flex items-center justify-center text-xl">
                  {{ service.icon }}
                </div>
                <div>
                  <h4 class="text-lg font-medium text-gray-900">{{ service.name }}</h4>
                  <p class="text-sm text-gray-500">{{ service.category }}</p>
                </div>
              </div>
              <div class="text-right">
                <p class="text-xl font-bold text-gray-900">{{ formatPrice(service.price) }}</p>
                <p class="text-sm text-gray-500">{{ service.priceUnit }}</p>
              </div>
            </div>
            
            <p class="mt-3 text-gray-600">{{ service.description }}</p>
            
            <div class="mt-4 flex justify-end">
              <button 
                @click="bookService(service.id)"
                class="px-4 py-2 bg-primary-600 text-white text-sm rounded-lg hover:bg-primary-700 transition-colors"
              >
                Réserver ce service
              </button>
            </div>
          </div>
        </div>
        
        <!-- Avis -->
        <div v-if="activeTab === 'reviews'" class="space-y-6">
          <div class="flex items-center justify-between">
            <h3 class="text-lg font-medium text-gray-900">
              {{ expert.reviews.length }} avis
            </h3>
            <div class="flex items-center gap-1">
              <span class="font-medium text-gray-900">{{ expert.rating }}</span>
              <div class="flex">
                <Star 
                  v-for="i in 5" 
                  :key="i"
                  class="w-5 h-5" 
                  :class="i <= Math.floor(expert.rating) ? 'text-yellow-400 fill-current' : 'text-gray-300'"
                />
              </div>
            </div>
          </div>
          
          <div class="space-y-6">
            <div 
              v-for="review in expert.reviews" 
              :key="review.id"
              class="border-b border-gray-100 pb-6 last:border-0"
            >
              <div class="flex items-start justify-between">
                <div class="flex items-center gap-3">
                  <div class="w-10 h-10 rounded-full overflow-hidden">
                    <img 
                      :src="review.author.avatar" 
                      :alt="review.author.name"
                      class="w-full h-full object-cover"
                    />
                  </div>
                  <div>
                    <p class="font-medium text-gray-900">{{ review.author.name }}</p>
                    <p class="text-sm text-gray-500">{{ review.date }}</p>
                  </div>
                </div>
                <div class="flex">
                  <Star 
                    v-for="i in 5" 
                    :key="i"
                    class="w-4 h-4" 
                    :class="i <= review.rating ? 'text-yellow-400 fill-current' : 'text-gray-300'"
                  />
                </div>
              </div>
              
              <p class="mt-3 text-gray-600">{{ review.comment }}</p>
              
              <div v-if="review.service" class="mt-2 inline-flex items-center gap-1 px-2 py-1 bg-gray-100 rounded-md text-xs text-gray-600">
                {{ review.service.icon }} {{ review.service.name }}
              </div>
            </div>
          </div>
        </div>
        
        <!-- Disponibilité -->
        <div v-if="activeTab === 'availability'" class="space-y-6">
          <div>
            <h3 class="text-lg font-medium text-gray-900 mb-3">Horaires de disponibilité</h3>
            <div class="border border-gray-200 rounded-xl overflow-hidden">
              <table class="w-full">
                <thead class="bg-gray-50">
                  <tr>
                    <th class="px-4 py-3 text-left text-sm font-medium text-gray-500">Jour</th>
                    <th class="px-4 py-3 text-left text-sm font-medium text-gray-500">Matin</th>
                    <th class="px-4 py-3 text-left text-sm font-medium text-gray-500">Après-midi</th>
                  </tr>
                </thead>
                <tbody class="divide-y divide-gray-200">
                  <tr v-for="day in expert.availability" :key="day.day" class="hover:bg-gray-50">
                    <td class="px-4 py-3 text-sm font-medium text-gray-900">{{ day.day }}</td>
                    <td class="px-4 py-3 text-sm text-gray-600">
                      <span v-if="day.morning" class="text-green-600">{{ day.morning }}</span>
                      <span v-else class="text-gray-400">Indisponible</span>
                    </td>
                    <td class="px-4 py-3 text-sm text-gray-600">
                      <span v-if="day.afternoon" class="text-green-600">{{ day.afternoon }}</span>
                      <span v-else class="text-gray-400">Indisponible</span>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
          
          <div>
            <h3 class="text-lg font-medium text-gray-900 mb-3">Zone d'intervention</h3>
            <div class="h-64 bg-gray-100 rounded-xl flex items-center justify-center">
              <!-- Emplacement pour une carte -->
              <Map class="w-12 h-12 text-gray-400" />
            </div>
            <p class="mt-2 text-sm text-gray-600">
              {{ expert.name }} intervient dans un rayon de {{ expert.radius }} km autour de {{ expert.location }}.
            </p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { 
  ArrowLeft, Heart, Star, MapPin, MessageSquare, ClipboardList,
  Award, CheckCircle, Map
} from 'lucide-vue-next'

// Onglets
const tabs = [
  { id: 'about', name: 'À propos' },
  { id: 'services', name: 'Services et tarifs' },
  { id: 'reviews', name: 'Avis' },
  { id: 'availability', name: 'Disponibilité' }
]

const activeTab = ref('about')
const showRequestForm = ref(false)

// Données simulées de l'expert
const expert = ref({
  id: 'EXP-2024-0003',
  name: 'Ibrahim Touré',
  title: 'Bricoleur multi-services',
  avatar: 'https://randomuser.me/api/portraits/men/32.jpg',
  memberSince: 'Janvier 2022',
  rating: 4.9,
  reviewCount: 37,
  location: 'Abidjan, Côte d\'Ivoire',
  radius: 15,
  isFavorite: false,
  bio: 'Technicien polyvalent avec plus de 10 ans d\'expérience dans le domaine du bricolage et des petits travaux. Je suis spécialisé dans la plomberie, l\'électricité et les réparations diverses. Diplômé en maintenance industrielle, je propose des services de qualité avec une garantie de satisfaction. Je me déplace à domicile avec tout le matériel nécessaire pour réaliser vos travaux rapidement et efficacement.',
  services: [
    { id: 'bricolage', name: 'Bricolage', icon: '🔨' },
    { id: 'plomberie', name: 'Plomberie', icon: '🚿' },
    { id: 'electricite', name: 'Électricité', icon: '💡' }
  ],
  skills: [
    { id: 1, name: 'Réparations diverses' },
    { id: 2, name: 'Installation électrique' },
    { id: 3, name: 'Plomberie sanitaire' },
    { id: 4, name: 'Montage de meubles' },
    { id: 5, name: 'Peinture' }
  ],
  languages: [
    { name: 'Français', level: 'Natif', flag: '🇫🇷' },
    { name: 'Anglais', level: 'Intermédiaire', flag: '🇬🇧' },
    { name: 'Dioula', level: 'Natif', flag: '🇨🇮' }
  ],
  certifications: [
    { 
      id: 1, 
      title: 'Diplôme de Technicien en Maintenance Industrielle', 
      institution: 'Institut National Polytechnique Houphouët-Boigny', 
      year: '2010' 
    },
    { 
      id: 2, 
      title: 'Certification en Électricité Bâtiment', 
      institution: 'Centre de Formation Professionnelle', 
      year: '2012' 
    },
    { 
      id: 3, 
      title: 'Habilitation Électrique B2V-BR', 
      institution: 'Bureau Veritas', 
      year: '2015' 
    }
  ],
  detailedServices: [
    {
      id: 1,
      name: 'Plomberie',
      category: 'Bricolage',
      icon: '🚿',
      price: 5000,
      priceUnit: 'par heure',
      description: 'Réparation de fuites, remplacement de robinetterie, débouchage de canalisations, installation de sanitaires.'
    },
    {
      id: 2,
      name: 'Électricité',
      category: 'Bricolage',
      icon: '💡',
      price: 6000,
      priceUnit: 'par heure',
      description: 'Installation de prises et interrupteurs, dépannage électrique, installation de luminaires, mise aux normes.'
    },
    {
      id: 3,
      name: 'Montage de meubles',
      category: 'Bricolage',
      icon: '🪑',
      price: 4500,
      priceUnit: 'par heure',
      description: 'Montage de meubles en kit, installation d\'étagères, fixation murale, assemblage de mobilier.'
    }
  ],
  reviews: [
    {
      id: 1,
      author: {
        name: 'Sophie Konaté',
        avatar: 'https://randomuser.me/api/portraits/women/33.jpg'
      },
      rating: 5,
      date: '15 janvier 2024',
      comment: 'Ibrahim est intervenu rapidement pour réparer une fuite sous mon évier. Travail soigné et professionnel. Je recommande !',
      service: { name: 'Plomberie', icon: '🚿' }
    },
    {
      id: 2,
      author: {
        name: 'Jean Kouassi',
        avatar: 'https://randomuser.me/api/portraits/men/41.jpg'
      },
      rating: 5,
      date: '2 décembre 2023',
      comment: 'Excellent travail pour l\'installation électrique de ma cuisine. Ponctuel, efficace et prix raisonnable.',
      service: { name: 'Électricité', icon: '💡' }
    },
    {
      id: 3,
      author: {
        name: 'Marie Diop',
        avatar: 'https://randomuser.me/api/portraits/women/22.jpg'
      },
      rating: 4,
      date: '18 novembre 2023',
      comment: 'Ibrahim a monté tous mes meubles rapidement. Quelques petites imperfections mais dans l\'ensemble je suis satisfaite.',
      service: { name: 'Montage de meubles', icon: '🪑' }
    }
  ],
  availability: [
    { day: 'Lundi', morning: '8h - 12h', afternoon: '14h - 18h' },
    { day: 'Mardi', morning: '8h - 12h', afternoon: '14h - 18h' },
    { day: 'Mercredi', morning: '8h - 12h', afternoon: '14h - 18h' },
    { day: 'Jeudi', morning: '8h - 12h', afternoon: '14h - 18h' },
    { day: 'Vendredi', morning: '8h - 12h', afternoon: '14h - 18h' },
    { day: 'Samedi', morning: '9h - 12h', afternoon: null },
    { day: 'Dimanche', morning: null, afternoon: null }
  ]
})

// Méthodes
const toggleFavorite = () => {
  expert.value.isFavorite = !expert.value.isFavorite
}

const contactExpert = () => {
  navigateTo(`/messages?expert=${expert.value.id}`)
}

const bookService = (serviceId: number) => {
  showRequestForm.value = true
  // Logique pour pré-remplir le formulaire avec le service sélectionné
}

const formatPrice = (price: number) => {
  return new Intl.NumberFormat('fr-FR', { style: 'currency', currency: 'XOF' }).format(price)
}
</script> 