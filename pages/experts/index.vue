<template>
  <div class="max-w-3xl mx-auto px-4 pt-5 pb-16">
    <!-- En-tête minimaliste style Twitter -->
    <div class="mb-6">
      <h1 class="text-2xl font-bold text-gray-900 dark:text-white">Trouver un expert</h1>
    </div>

    <!-- Filtres par catégorie style pills coloré -->
    <div class="sticky top-0 z-10 bg-white/90 dark:bg-gray-900/90 backdrop-blur-sm py-3 -mx-4 px-4 mb-4">
      <div class="flex overflow-x-auto pb-2 no-scrollbar gap-2">
        <button
          v-for="category in categories"
          :key="category.id"
          class="px-4 py-2 rounded-full text-sm font-medium whitespace-nowrap transition-colors"
          :class="selectedCategory === category.id ? 
            'bg-primary-600 text-white dark:bg-primary-500' : 
            'bg-gray-100 text-gray-800 dark:bg-gray-800 dark:text-gray-200 hover:bg-gray-200 dark:hover:bg-gray-700'"
          @click="filterByCategory(category.id)"
        >
          {{ category.name }}
        </button>
      </div>
    </div>
    
    <!-- État de chargement -->
    <div v-if="loading" class="flex justify-center items-center py-20">
      <div class="h-10 w-10 border-4 border-gray-200 dark:border-gray-700 border-t-primary-500 dark:border-t-primary-400 rounded-full animate-spin"></div>
      <span class="ml-3 text-gray-600 dark:text-gray-400">Chargement des experts...</span>
    </div>
    
    <!-- Aucun expert trouvé -->
    <div v-else-if="experts.length === 0" class="py-16 text-center">
      <div class="mb-4 flex justify-center">
        <div class="bg-primary-50 dark:bg-primary-900/20 p-4 rounded-full">
          <UserX class="h-8 w-8 text-primary-500 dark:text-primary-400" />
        </div>
      </div>
      <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-2">Aucun expert trouvé</h3>
      <p class="text-gray-600 dark:text-gray-400 mb-6 max-w-sm mx-auto">
        Aucun expert ne correspond à cette catégorie pour le moment
      </p>
    </div>
    
    <!-- Liste des experts avec séparations horizontales -->
    <div v-else>
      <div 
        v-for="(expert, index) in experts" 
        :key="expert.id"
        class="py-5 hover:bg-gray-50 dark:hover:bg-gray-800/50 transition-all"
        :class="{ 'border-b border-gray-200 dark:border-gray-700': index !== experts.length - 1 }"
      >
        <!-- En-tête avec avatar et nom -->
        <div class="flex items-start">
          <img 
            :src="expert.profile_image || '/img/default-avatar.png'" 
            :alt="expert.firstName + ' ' + expert.lastName"
            class="w-12 h-12 rounded-full object-cover border border-gray-100 dark:border-gray-700"
          />
          <div class="ml-3 flex-1">
            <div class="flex items-center">
              <h3 class="font-semibold text-gray-900 dark:text-white">{{ expert.firstName }} {{ expert.lastName }}</h3>
              <div v-if="expert.isVerified" class="ml-1.5 bg-blue-100 dark:bg-blue-900/30 text-blue-600 dark:text-blue-400 text-xs px-2 py-0.5 rounded-full font-medium">
                Vérifié
              </div>
            </div>
            
            <!-- Spécialité/catégorie et note -->
            <div class="flex items-center mt-1 text-sm">
              <span class="text-primary-600 dark:text-primary-400 font-medium">{{ expert.specialty }}</span>
              <span class="mx-1.5 text-gray-400">•</span>
              <div class="flex items-center">
                <Star class="h-3.5 w-3.5 text-amber-400 fill-amber-400" />
                <span class="ml-1 text-gray-700 dark:text-gray-300">{{ expert.rating }}</span>
                <span class="ml-1 text-gray-500 dark:text-gray-400">({{ expert.reviewCount }})</span>
              </div>
            </div>
            
            <!-- Bio -->
            <p class="mt-2 text-gray-700 dark:text-gray-300 line-clamp-2 text-sm">
              {{ expert.bio }}
            </p>
            
            <!-- Tags/compétences avec couleurs -->
            <div class="flex flex-wrap gap-1.5 mt-3">
              <span 
                v-for="(skill, skillIndex) in expert.skills" 
                :key="skillIndex" 
                class="rounded-full px-3 py-1 text-xs font-medium"
                :class="getSkillColor(skillIndex)"
              >
                {{ skill }}
              </span>
            </div>
          </div>
        </div>
        
        <!-- Prix et bouton de contact -->
        <div class="flex items-center justify-between mt-4 ml-14">
          <div>
            <div class="font-bold text-lg text-primary-600 dark:text-primary-400">
              {{ expert.hourlyRate }}
            </div>
            <div class="text-xs text-gray-500 dark:text-gray-400">
              par heure
            </div>
          </div>
          
          <button 
            @click="contactExpert(expert)"
            class="px-4 py-2 bg-primary-600 hover:bg-primary-700 dark:bg-primary-500 dark:hover:bg-primary-600 text-white rounded-full text-sm font-medium transition-transform hover:scale-105"
          >
            Contacter
          </button>
        </div>
      </div>
    </div>
    
    <!-- Bouton flottant pour la recherche -->
    <button @click="openSearch" class="fixed bottom-6 right-6 w-14 h-14 bg-primary-600 hover:bg-primary-700 text-white rounded-full shadow-lg flex items-center justify-center hover:scale-105 transition-transform">
      <Search class="h-6 w-6" />
    </button>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useSupabaseClient } from '#imports'
import {
  Search,
  Star,
  UserX
} from 'lucide-vue-next'

const router = useRouter()
const supabase = useSupabaseClient()

// État réactif
const experts = ref([])
const categories = ref([
  { id: null, name: 'Tous' },
  { id: 1, name: 'Développement web' },
  { id: 2, name: 'Design' },
  { id: 3, name: 'Marketing' },
  { id: 4, name: 'Traduction' },
  { id: 5, name: 'Rédaction' },
  { id: 6, name: 'Conseil' },
  { id: 7, name: 'Comptabilité' }
])
const selectedCategory = ref(null)
const loading = ref(true)
const searchQuery = ref('')

// Charger les données au montage du composant
onMounted(async () => {
  try {
    // Simule le chargement des données depuis la base de données
    await new Promise(resolve => setTimeout(resolve, 800))
    
    // Données simulées des experts
    experts.value = [
      {
        id: 1,
        firstName: 'Aminata',
        lastName: 'Diallo',
        profile_image: '/img/avatars/expert1.jpg',
        specialty: 'Développement web',
        bio: 'Développeuse Full Stack avec 5 ans d\'expérience. Spécialisée en React, Node.js et bases de données.',
        skills: ['JavaScript', 'React', 'Node.js', 'MongoDB'],
        rating: 4.9,
        reviewCount: 27,
        hourlyRate: '15 000 FCFA',
        isVerified: true,
        categoryId: 1
      },
      {
        id: 2,
        firstName: 'Ousmane',
        lastName: 'Ndiaye',
        profile_image: '/img/avatars/expert2.jpg',
        specialty: 'Design graphique',
        bio: 'Designer graphique avec une passion pour les interfaces utilisateur modernes et l\'identité de marque.',
        skills: ['Photoshop', 'Illustrator', 'UI/UX', 'Figma'],
        rating: 4.7,
        reviewCount: 19,
        hourlyRate: '12 000 FCFA',
        isVerified: true,
        categoryId: 2
      },
      {
        id: 3,
        firstName: 'Fatou',
        lastName: 'Seck',
        profile_image: '/img/avatars/expert3.jpg',
        specialty: 'Marketing digital',
        bio: 'Spécialiste en marketing digital avec expérience en SEO, publicités Google et réseaux sociaux.',
        skills: ['SEO', 'Google Ads', 'Facebook Ads', 'Email Marketing'],
        rating: 4.8,
        reviewCount: 32,
        hourlyRate: '14 000 FCFA',
        isVerified: true,
        categoryId: 3
      },
      {
        id: 4,
        firstName: 'Ibrahim',
        lastName: 'Barry',
        profile_image: '/img/avatars/expert4.jpg',
        specialty: 'Traduction',
        bio: 'Traducteur professionnel anglais-français avec 8 ans d\'expérience dans divers domaines techniques.',
        skills: ['Anglais', 'Français', 'Traduction technique', 'Localisation'],
        rating: 4.9,
        reviewCount: 41,
        hourlyRate: '10 000 FCFA',
        isVerified: true,
        categoryId: 4
      },
      {
        id: 5,
        firstName: 'Aïssatou',
        lastName: 'Diop',
        profile_image: '/img/avatars/expert5.jpg',
        specialty: 'Rédaction web',
        bio: 'Rédactrice web SEO avec expérience en création de contenu pour divers secteurs d\'activité.',
        skills: ['Rédaction SEO', 'Copywriting', 'Blogging', 'Correction'],
        rating: 4.6,
        reviewCount: 23,
        hourlyRate: '8 000 FCFA',
        isVerified: false,
        categoryId: 5
      }
    ]
    
    // Simuler le chargement des catégories depuis la base de données
    // Dans un environnement réel, nous le ferions avec Supabase
    /*
    const { data: categoriesData, error } = await supabase
      .from('categories')
      .select('id, name')
      .eq('is_active', true)
      .order('name')
    
    if (error) throw error
    categories.value = [{ id: null, name: 'Tous' }, ...categoriesData]
    */
  } catch (error) {
    console.error('Error fetching data:', error)
  } finally {
    loading.value = false
  }
})

// Méthodes
const filterByCategory = (categoryId) => {
  selectedCategory.value = categoryId
  
  // Réinitialiser la recherche quand on change de catégorie
  searchQuery.value = ''
  
  // Simuler le chargement
  loading.value = true
  setTimeout(() => {
    loading.value = false
  }, 300)
}

const openSearch = () => {
  // Ouvrir la recherche avancée, peut-être avec une modale ou un drawer
  console.log('Opening advanced search')
}

const contactExpert = (expert) => {
  // Rediriger vers la page de chat ou ouvrir une modale de contact
  console.log('Contacting expert:', expert.firstName)
  router.push(`/chat/${expert.id}`)
}

// Fonction pour obtenir une couleur cohérente pour les compétences
const getSkillColor = (index) => {
  const colors = [
    'bg-blue-100 text-blue-700 dark:bg-blue-900/30 dark:text-blue-400',
    'bg-green-100 text-green-700 dark:bg-green-900/30 dark:text-green-400',
    'bg-purple-100 text-purple-700 dark:bg-purple-900/30 dark:text-purple-400',
    'bg-amber-100 text-amber-700 dark:bg-amber-900/30 dark:text-amber-400',
    'bg-rose-100 text-rose-700 dark:bg-rose-900/30 dark:text-rose-400',
    'bg-teal-100 text-teal-700 dark:bg-teal-900/30 dark:text-teal-400'
  ]
  
  return colors[index % colors.length]
}

definePageMeta({
  layout: 'default'
})
</script>

<style scoped>
/* Masquer la barre de défilement tout en gardant la fonctionnalité */
.no-scrollbar {
  -ms-overflow-style: none;
  scrollbar-width: none;
}
.no-scrollbar::-webkit-scrollbar {
  display: none;
}

/* Animation pour l'apparition des composants */
.py-5 {
  animation: fadeIn 0.3s ease-out;
  animation-fill-mode: both;
}

/* Animation séquentielle pour les experts */
div > div:nth-child(1) { animation-delay: 0.05s; }
div > div:nth-child(2) { animation-delay: 0.1s; }
div > div:nth-child(3) { animation-delay: 0.15s; }
div > div:nth-child(4) { animation-delay: 0.2s; }
div > div:nth-child(5) { animation-delay: 0.25s; }

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(8px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
</style>